// use std::mem;

fn main() {
    let width = 1000;
    let height = 1000;
    let mut memory_raw = vec![0; width * height];
    let mut memory_base: Vec<_> = memory_raw.as_mut_slice().chunks_mut(width).collect();
    let mut memory: &mut [&mut [_]] = memory_base.as_mut_slice();
    let mut highest = 0;
    let val = 312051;
    let mut locx = width / 2;
    let mut locy = height / 2;
    let mut dir = "up";
    
    memory[locx][locy] = 1;
    loop {
        if highest > val {
            break;
        }

        if dir == "right" {
            locx = locx + 1;
        } else if dir == "left" {
            locx = locx - 1;
        } else if dir == "up" {
            locy = locy - 1;
        } else if dir == "down" {
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
            dir = "down";
        } else if memory[locx + 1][locy] == 0 && memory[locx][locy - 1] != 0 {
            dir = "right";
        } else if memory[locx][locy -1] == 0 && memory[locx -1][locy] != 0{
            dir = "up";
        } else if memory[locx - 1][locy] == 0 {
            dir = "left";
        }
    }
    println!("Highest value is {}", highest);
}
