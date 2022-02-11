module Mergepdfs

#https://stackoverflow.com/questions/64520684/merge-pdf-files-using-python-pypdf2 

using Conda
using PyCall

export mergepdfs

export pyModulePyPDF2
pyModulePyPDF2 = PyCall.PyNULL()

#https://anaconda.org/conda-forge/pypdf2

try 
    #this line may trigger installation
    copy!(pyModulePyPDF2, PyCall.pyimport("PyPDF2"))
catch
    try 
    copy!(pyModulePyPDF2, PyCall.pyimport_conda("PdfFileMerger","PyPDF2","conda-forge"))
    catch
        using Conda
        Conda.add("PyPDF2")
    end
end


function __init__()
	copy!(pyModulePyPDF2, PyCall.pyimport("PyPDF2"))
    
    if isinteractive()
        include("src/py_snippted.jl")
    else 
        include("py_snippted.jl")
    end
end

function mergepdfs(list_of_pdf_files,resfi)
    @assert all(isfile.(list_of_pdf_files))
    endings = map(x->lowercase.(splitext(x)[2]),list_of_pdf_files) 
    @assert all(".pdf".==endings)

    @assert isdir(splitdir(resfi)[1])

    merger = pyModulePyPDF2.PdfFileMerger()
    for fi in list_of_pdf_files
        merger.append(fi)
    end

    isfile(resfi) && rm(resfi)
    merger.write(resfi)
    merger.close()

    return nothing    
end


export read_and_encrypt_jl
function read_and_encrypt_jl(pdf_inputfile,pdf_outfile,secure_file=false,usrpwd="",ownrpwd="")
    println("mih")
    return py"read_and_encrypt"(pdf_inputfile,pdf_outfile,secure_file=secure_file,usrpwd=usrpwd,ownrpwd=ownrpwd)
end

end #module 