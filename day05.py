class Day5:
    def __init__(self, file, changer):
        self.pointer_position = 0
        self.initialize_state(file)
        self.changer = changer

    def initialize_state(self, file):
        with open(file, "r") as io_thang:
            self.state = io_thang.readlines()
        self.state = [int(x.rstrip("\n")) for x in self.state]

    def get_steps(self):
        steps = 0
        L = len(self.state)
        while self.pointer_position > -1 and self.pointer_position < L:
            steps += 1
            jumpsize = self.state[self.pointer_position]
            self.change_current(jumpsize)
            self.pointer_position += jumpsize
        return steps

    def change_current(self, jumpsize):
        self.state[self.pointer_position] += self.changer.nextval(jumpsize)

class ChangerA:
    def nextval(self, jumpsize):
        return 1

class ChangerB:
    def nextval(self, jumpsize):
        if jumpsize > 2:
            return -1
        else:
            return 1

doer = Day5("data/day5.txt", ChangerA())
print(doer.get_steps()) # 360603

doer2 = Day5("data/day5.txt", ChangerB())
print(doer2.get_steps()) # 25347697
