## Problem 1 

Check whether your solutions for last week's problems were type stable. Which function cannot be type stable?


## Problem 2

For the Peano numbers problem from last time, in the following code, how many compilations for `+` happen?

```julia
Zero() + Zero()
Zero() + convert(PeanoNumber, 1)
convert(PeanoNumber, 1) + Zero()
convert(PeanoNumber, 1) + convert(PeanoNumber, 5)
convert(PeanoNumber, 2) + convert(PeanoNumber, 5)
```

## Problem 3

Write code which "draws" Julia sets for at least the complex numbers and the quaternions for quadratic polynomials.

### Part 1

The typical method for drawing Julia sets with complex numbers is:

1. Let $f(z) = z^2 + c$ for some $c$.
2. Set every pixel to the integer zero.
3. For every pixel in an image,
  1. Compute a complex number $z$ to start with.
    - This is usually a simple map, like picking the `x` coordinate for the real component and `y` for complex. You probably want to translate so that zero is in the middle of the image, and scale the coordinates up or down so that you get all the interesting stuff in "frame".
  2. Let $i = 0$
  3. While $i < ITERATIONS$ and $abs(z) < R$:
    1. Let $z = f(z)$
    2. Let $i = i + 1$
  4. Set the value of the pixel to a color which is a function of $i$
    - You could just map $[0, ITERATIONS] \mapsto (0, 1)$ and use a grayscale image

You should write a type to represent the polynomials you want to try. You should start with one for the form $z^2 + c$, where you should only store the complex number $c$. You can define function calls for your polynomial like so:

```julia
struct Poly{...} <: AbstractPolynomial
    ...
end

function (Poly{...})(z)
     # calculate here
end

# now you can do this:

p = Poly(...)
z = some_complex_number()
p(z)  # calls the function above
```

Now, test your function! You don't actually have to draw to an image, but [Images.jl](https://juliaimages.org/stable/) will help you out here if you do. To use a simple grayscale colormap:

```julia
juliadrawing = Matrix{Int}(...)
# call your function for drawing the Julia set here
using Images
img = Gray.(juliadrawing ./ maximum(juliadrawing)) # scale to (0, 1) and convert to a grayscale image
# below is only necessary if you're not using a Jupyter or Pluto notebook
using ImageView
imshow(img)
```


Tips:

- You can create a matrix of all zeros of size $(m, n)$ using `zeros(Int, m, n)`
- Try other polynomials with only even powers of $z$


### Part 2

Now, modify your function and polynomial types to be able to use either complex numbers or the [quaternions](https://en.wikipedia.org/wiki/Quaternion). You can use [Quaternions.jl](https://github.com/JuliaGeometry/Quaternions.jl) for all the arithmetic needs. Note `Complex{T}` and `Quaternion{T}` are both subtypes of `Number`. You could also accept reals if you want to, but they won't do much interesting.

Your "image" now is going to need to be four dimensional, since quaternions have four components. You can't draw that, but you can pretty easily take 2D slices of it to look at. If we label the four orders $a, b, c, d$, then:

```julia
img = Array{Int, 4}(...)  # fourth order tensor

# this is the plane $c = 5, d = 4$
img[:, :, 5, 4]

# this is the plane $a = 1, c = 3$
img[1, :, 3, :]
```

If you want to take other slices not along those axes, the easiest thing to do is probably change your map from pixels to starting quaternions.

Tips:

- Use dispatch to pick what function gets your starting quaternions
- If you're feeling fancy, ImageView.jl does have tools for viewing 3D images, so you could slice once fewer and have a slider for the third dimension


### Part 3

First, use `@code_warntype` to make sure your code is type-stable. In particular, make sure you test stuff like making `c` a `Quaternion{Int}` instead of using floats. Try to get the widest array of input types and check that you're type stable for all of them. Make sure you're properly testing any helper functions you've written as well.

Next, use BenchmarkTools.jl to compare performance between quaternions and complex numbers. Make sure you're testing the same number of pixels (for example, if you're doing a $256 × 256$ image for complex numbers, do a $16 × 16 × 16 × 16$ iage for quaternions). Garbage collection should take up very little to none of the time here.

Finally, use FlameGraphs.jl and one of its visualization packages to see where your program spends most of its time. Make sure there's no orange (garbage collection) or red (runtime dispatch) happening. See if you can use the information to speed up your program at all, and confirm using BenchmarkTools.


