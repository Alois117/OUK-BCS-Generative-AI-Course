"""A Number Guessing Game"""

import random;

# Define the game walker
walker GuessGame {
    has guess: int;

    # Abilities (must have bodies, provided below)
    can start with `root entry;
    can process_guess with turn entry;
}

# Define the node where guessing happens
node turn {
    has correct_number: int = random.randint(1, 10);
}

# CLI mode entry: spawn multiple walkers
with entry:__main__ {
    print("Spawning multiple GuessGame instances...");
    root spawn GuessGame(3);
    root spawn GuessGame(4);
    root spawn GuessGame(5);
    root spawn GuessGame(6);
    print("All walkers spawned successfully!");
}

# Implementation of start ability
impl GuessGame.start {
    # If there is no turn node yet, create one
    if not [root --> (`?turn)] {
        next = root ++> turn(random.randint(1, 10));
    } else {
        next = [root --> (`?turn)];
    }
    visit next;
}

# Implementation of process_guess ability
impl GuessGame.process_guess {
    if [-->] {
        visit [-->];
    } else {
        if self.guess < here.correct_number {
            print("Too high!");
            here ++> turn(here.correct_number);
        } elif self.guess > here.correct_number {
            print("Too low!");
            here ++> turn(here.correct_number);
        } else {
            print("Congratulations! You guessed correctly.");
            disengage;
        }
    }
}
