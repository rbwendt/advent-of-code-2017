#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#define BUFF_SIZE 1000000

struct Coordinates {
    int n;
    int ne;
    int nw;
};

struct Coordinates balance(struct Coordinates coords) {
    while (coords.ne < 0 && coords.nw < 0) {
        coords.n --;
        coords.ne ++;
        coords.nw ++;
    }
    while (coords.ne > 0 && coords.nw > 0) {
        coords.n ++;
        coords.ne --;
        coords.nw --;
    }
    while (coords.n > 0 && coords.ne > 0 && coords.nw < 0) {
        coords.n --;
        coords.ne ++;
        coords.nw ++;
    }
    
    return coords;
}

int dist(struct Coordinates c) {
    return abs(c.n) + abs(c.ne) + abs(c.nw);
}

struct Coordinates walkPath(char buff[BUFF_SIZE]) {
    struct Coordinates result = {0, 0, 0};
    int maxDist = 0;
    for (int i = 0; i < strlen(buff); i++) {
        switch(buff[i]) {
            case 'n':
                if (buff[i+1] == ',') {
                    result.n ++;
                } else if (buff[i+1] == 'e') {
                    result.ne++;
                } else if (buff[i+1] == 'w') {
                    result.nw++;
                }
                break;
            case 's':
                if (buff[i+1] == ',') {
                    result.n --;
                } else if (buff[i+1] == 'e') {
                    result.nw --;
                } else if (buff[i+1] == 'w') {
                    result.ne --;
                }
                break;
            case ',':
                break;
        };
        result = balance(result);
        int disto = dist(result);
        if (disto > maxDist) {
            maxDist = disto;
        }
    }
    printf("max dist is %d\n", maxDist);
    return result;
}

int main(int argc, char **argv) {
    char buff[BUFF_SIZE];
    FILE *f = fopen("data/day11.txt", "r");
    fgets(buff, BUFF_SIZE, f);
    fclose(f);

    struct Coordinates coords = walkPath(buff);

    printf("Coords: N %d NE %d NW %d\n", coords.n, coords.ne, coords.nw);
    int d = dist(coords);

    printf("Distance: %d\n", d);
}
