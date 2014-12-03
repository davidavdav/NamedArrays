## namedarraytypes.jl.
## (c) 2013 David A. van Leeuwen

## Julia type that implements a drop-in replacement of Array with named dimensions. 

## This code is licensed under the GNU General Public License, version 2
## See the file LICENSE in this distribution

## DT is a tuple of Dicts, characterized by the types of the keys.  
## This way NamedArray is dependent on the dictionary type of each dimensions. 
## The inner constructor checks for consistency, the values must all be 1:d
type NamedArray{T,N,DT} <: AbstractArray{T,N}
    array::Array{T,N}
    dicts::DT
    dimnames::NTuple{N}
    function NamedArray(array::Array{T,N}, dicts::NTuple{N,Dict}, dimnames::NTuple{N})
        size(array) == map(length, dicts) || error("Inconsistent dictionary sizes")
        for (d,dict) in zip(size(array),dicts)
            Set(values(dict)) == Set(1:d) || error("Inconsistent values in dict")
        end
        new(array, dicts, dimnames)
    end
end


## a type that negates any index
immutable Not{T}
    index::T
end

typealias NamedVector{T} NamedArray{T,1}
typealias NamedMatrix{T} NamedArray{T,2}
typealias ArrayOrNamed{T,N} Union(Array{T,N}, NamedArray{T,N})

