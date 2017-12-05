
const WIDTH: usize = 1000;
const HEIGHT: usize = 1000;
const UP: u8 = 0;
const LEFT: u8 = 1;
const RIGHT: u8 = 2;
const DOWN: u8 = 3;

fn main() {

    let mut memory_raw = vec![0; WIDTH * HEIGHT];
    let mut memory_base: Vec<_> = memory_raw.as_mut_slice().chunks_mut(WIDTH).collect();
    let memory: &mut [&mut [_]] = memory_base.as_mut_slice();
    
    let val = 312051;
    let mut locx = WIDTH / 2;
    let mut locy = HEIGHT / 2;
    let mut dir = UP;
    let mut highest = 0;

    memory[locx][locy] = 1;
    loop {
        if highest > val {
            break;
        }

        if dir == RIGHT {
            locx = locx + 1;
        } else if dir == LEFT {
            locx = locx - 1;
        } else if dir == UP {
            locy = locy - 1;
        } else if dir == DOWN {
            locy = locy + 1;
        }

        memory[locx][locy] = memory[locx - 1][locy - 1] +
                            memory[locx - 1][locy] +
                            memory[locx - 1][locy + 1] +
                            memory[locx][locy - 1] +
                            memory[locx][locy + 1] +
                            memory[locx + 1][locy - 1] +
                            memory[locx + 1][locy] +
                            memory[locx + 1][locy + 1];
        
        if memory[locx][locy] > highest {
            highest = memory[locx][locy];
            println!("New highest at {} {} is {}", locx, locy, highest)
        }

        if memory[locx][locy + 1] == 0 && memory[locx + 1][locy] != 0 {
            dir = DOWN;
        } else if memory[locx + 1][locy] == 0 && memory[locx][locy - 1] != 0 {
            dir = RIGHT;
        } else if memory[locx][locy -1] == 0 && memory[locx -1][locy] != 0{
            dir = UP;
        } else if memory[locx - 1][locy] == 0 {
            dir = LEFT;
        }
    }
    println!("Highest value is {}", highest);
}
