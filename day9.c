#include <stdio.h>
#include <string.h>

#define BUFF_SIZE 20000

enum State {Adding = 0, Garbage = 1, Deleting = 2};

int main(int argc, char **argv)
{
    char buff[BUFF_SIZE];
    FILE *f = fopen("data/day9.txt", "r");
    fgets(buff, BUFF_SIZE, f);
    int currentSum = 0;
    int currentDepth = 0;
    int garbageCharacters = 0;

    enum State state = Adding;
    enum State previousState = Adding;
    

    for (int i = 0; i < strlen(buff); i++) {
        switch(state) {
            case Adding:
                switch(buff[i]) {
                    case '{':
                        currentDepth++;
                        break;
                    case '}':
                        currentSum += currentDepth;
                        currentDepth--;
                        break;
                    case ',':
                        break;
                    case '<':
                        state = Garbage;
                        break;
                }
                break;
            case Garbage:
                switch(buff[i]) {
                    case '!':
                        previousState = Garbage;
                        state = Deleting;
                        break;
                    case '>':
                        state = Adding;
                        break;
                    default:
                        garbageCharacters++;
                        break;
                }
                break;
            case Deleting:
                switch(buff[i]) {
                    default:
                        state = previousState;
                        break;
                }
                break;
        }
    }
    printf("Sum: %d, final depth: %d, garbage characters: %d\n", currentSum, currentDepth, garbageCharacters);
    fclose(f);
    
    return 0;
}