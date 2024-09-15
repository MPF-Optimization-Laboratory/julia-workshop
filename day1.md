@def title = "Day 1"

# Day 1

- [Slides](/day1.ipynb)
- [juliaup](https://github.com/JuliaLang/juliaup)
- [Julia manual](https://docs.julialang.org/en/v1/)

## Problem: Guessing Game

The goal of this game is to have the user guess a random number. Your program should select a number between 1 and 100 (inclusive). Then, it should accept a series of guesses from the user. Each time the guess entered is wrong, your program provides a hint: whether the guess entered was too high or too low. When the correct number is entered, you can print a message and exit.

You will need some pieces from the Julia standard library:

- `rand(a:b)` ([docs](https://docs.julialang.org/en/v1/stdlib/Random/#Base.rand)): select a random integer in $[a, b]$
- `readline()` ([docs](https://docs.julialang.org/en/v1/base/io-network/#Base.readline)): read a single line from the terminal and return it as a string
- `parse(Int, s)` ([docs](https://docs.julialang.org/en/v1/base/numbers/#Base.parse)): parse the `String` `s` as an Int

The top-level Julia scope behaves differently than you might expect. You will want to wrap your code in a function, like so:

```julia
# in your_filename.jl
function main()
    # your code here
end
main()
```

Then, you can run this code from the command line by running `julia your_filename.jl`. Remember, you do this from outside of Julia (in Bash/Zsh on Linux/Mac, in Command Prompt on Windows).

Alternately, you can write your `main()` function in a Jupyter/Pluto notebook and run it there. See the docs for IJulia or Pluto.jl for a reminder on how to run notebooks.

If you'd like additional challenge, here are some things you can try:

1. Print how many guesses it took to win when exiting.
2. Improve the function getting a number so that it asks again if the number is out of range. For example, if the user enters 101, the guess should be rejected without returning too high/too low.
3. Wrap the script in a function which takes a range, so that instead of the number always being in 1:100 it's in any arbitrary a:b, so long as $b > a$ (and both are integers).
4. Limit the number of guesses so that the player must guess optimally. (HINT: by how much does each well-chosen guess reduce the space of possibilities, given that you tell the user whether the guess is too high or too low?)
