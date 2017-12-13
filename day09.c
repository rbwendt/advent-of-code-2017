#include <stdio.h>
#include <string.h>

#define BUFF_SIZE 20000

enum State {Adding = 0, Garbage = 1, Deleting = 2};

struct Result {
    int sum;
    int depth;
    int garbage;
    enum State state;
    enum State previousState;
};

struct Result handleAdding(struct Result result, char c) {
    switch(c) {
        case '{':
            result.depth++;
            break;
        case '}':
            result.sum += result.depth;
            result.depth--;
            break;
        case ',':
            break;
        case '<':
            result.state = Garbage;
            break;
    }

    return result;
}

struct Result handleGarbage(struct Result result, char c) {
    switch(c) {
        case '!':
            result.previousState = Garbage;
            result.state = Deleting;
            break;
        case '>':
            result.state = Adding;
            break;
        default:
            result.garbage++;
            break;
    }

    return result;
}

struct Result handleDeleting(struct Result result, char c) {
    switch(c) {
        default:
            result.state = result.previousState;
            break;
    }
    return result;
}

struct Result figureOut(char buff[BUFF_SIZE]) {
    
    struct Result result = {0, 0, 0, Adding, Adding};

    for (int i = 0; i < strlen(buff); i++) {
        switch(result.state) {
            case Adding:
                result = handleAdding(result, buff[i]);
                break;
            case Garbage:
                result = handleGarbage(result, buff[i]);
                break;
            case Deleting:
                result = handleDeleting(result, buff[i]);
                break;
        }
    }
    
    return result;
}

int main(int argc, char **argv)
{
    char buff[BUFF_SIZE];
    FILE *f = fopen("data/day9.txt", "r");
    fgets(buff, BUFF_SIZE, f);
    fclose(f);

    struct Result result = figureOut(buff);
    printf("Sum: %d\n", result.sum);
    printf("final depth: %d\n", result.depth);
    printf("garbage characters: %d\n", result.garbage);
    
    return 0;
}