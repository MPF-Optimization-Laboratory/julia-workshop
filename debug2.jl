function inner(l)
    acc = 1
    for j in 1:l
        acc *= l + j
    end
    acc
end

function outer(k)
    i = 0
    for j in 1:k
        i += inner(k-j)
    end
    i
end
