
const WIDTH: usize = 1000;
const HEIGHT: usize = 1000;

enum Direction {
    Up, Left, Right, Down
}

fn get_memory() -> [[usize; WIDTH]; HEIGHT] {
  [[0; WIDTH]; HEIGHT]
}

fn main() {

    let mut memory = get_memory();

    let val = 312051;
    let mut locx = WIDTH / 2;
    let mut locy = HEIGHT / 2;
    let mut dir = Direction::Up;
    let mut highest = 0;

    memory[locx][locy] = 1;
    loop {
        if highest > val {
            break;
        }

        match dir {
         Direction::Right => locx = locx + 1,
         Direction::Left  => locx = locx - 1,
         Direction::Up    => locy = locy - 1,
         Direction::Down  => locy = locy + 1
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
            // println!("New highest at {} {} is {}", locx, locy, highest)
        }

        if memory[locx][locy + 1] == 0 && memory[locx + 1][locy] != 0 {
            dir = Direction::Down;
        } else if memory[locx + 1][locy] == 0 && memory[locx][locy - 1] != 0 {
            dir = Direction::Right;
        } else if memory[locx][locy -1] == 0 && memory[locx -1][locy] != 0{
            dir = Direction::Up;
        } else if memory[locx - 1][locy] == 0 {
            dir = Direction::Left;
        }
    }
    println!("Highest value is {}", highest);
}
