read_data_1() = reinterpret(Float64, UInt64[0x552192cc621cf3da, 0x5ce07573af5e6c0b, 0x7fe9efe466b4b559])
read_data_2() = reinterpret(Float64, UInt64[0x556ca9faa3276b68, 0x556f6ea19897afff, 0x7fe72e0b2433a49d])

function debugme()
    data1 = read_data_1()
    data2 = read_data_2()
    
    @assert !any(isnan.(data1))
    @assert !any(isnan.(data2))
 
    (data1 + data2) - (data1 .* data2)
end

debugme()