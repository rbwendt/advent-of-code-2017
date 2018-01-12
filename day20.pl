class Particle {
    has Int $.x is rw;
    has Int $.y is rw;
    has Int $.z is rw;
    has Int $.dx is rw;
    has Int $.dy is rw;
    has Int $.dz is rw;
    has Int $.ddx is rw;
    has Int $.ddy is rw;
    has Int $.ddz is rw;
    has Int $.collided is rw;

    method manhattanDistance() {
        return abs($.x) + abs($.y) + abs($.z);
    }

    method update() {
        $.dx += $.ddx;
        $.dy += $.ddy;
        $.dz += $.ddz;
        $.x += $.dx;
        $.y += $.dy;
        $.z += $.dz;
    }

    method collidesWith(Particle $other) {
        return ($.x == $other.x) && ($.y == $other.y) && ($.z == $other.z);
    }
}

sub getParticles($text) {
    my $parts = $text.split("\n");
    my @particles = Array[Particle].new();
    my Regex $rgx = /\<(\-?\d+)\,(\-?\d+)\,(\-?\d+)\>\,\sv\=\<(\-?\d+)\,(\-?\d+)\,(\-?\d+)\>\,\sa\=\<(\-?\d+)\,(\-?\d+)\,(\-?\d+)\>/;

    loop (my $i = 0; $i < $parts.elems; $i++) {
        my $part = $parts[$i];
        
        if $part ~~ $rgx {
            my Particle $particle = Particle.new(x => 0+$/.list[0], y => 0+$/.list[1], z => 0+$/.list[2], dx => 0+$/.list[3], dy => 0+$/.list[4], dz => 0+$/.list[5], ddx => 0+$/.list[6], ddy => 0+$/.list[7], ddz => 0+$/.list[8], collided => 0);
            @particles.push($particle);
        }
    }
    return @particles;
}

sub runSimulation(@particles where Array) {
    my $consecutive_same = 0;
    my $current_idx = -1;
    my $consecutive_target = 10_000;
    while ($consecutive_same < $consecutive_target) {
        my $smallest_dst = 1_000_000_000;
        my $smallest_idx = -1;
        my %position_map;
        for @particles.kv -> $i, $particle {
            if ($particle.collided == 1) {
                next;
            }
            my $manh = $particle.manhattanDistance();
            if ($manh < $smallest_dst) {
                $smallest_dst = $manh;
                $smallest_idx = $i;
            }
            $particle.update();
            my $position = "$($particle.x),$($particle.y),$($particle.z)";

            if (%position_map{$position}:exists) {
                $particle.collided = 1;
                @particles[%position_map{$position}].collided = 1;
            } else {
                %position_map{$position} = $i;
            }
            
        }
        if ($smallest_idx == $current_idx) {
            $consecutive_same += 1;
        } else {
            $consecutive_same = 0;
            $current_idx = $smallest_idx;
        }
    }
    say "Long run closest is: " ~ $current_idx; # 161
    my $uncollided = 0;
    for @particles.kv -> $j, $particle {
        if ($particle.collided == 0) {
            $uncollided += 1;
        }
    }

    say 'uncollided count ' ~ $uncollided; # 438
}

my $text = slurp 'data/day20.txt';

my @particles = getParticles($text);
runSimulation(@particles);
