using Pkg

Pkg.build("PyCall")
Pkg.build("Conda")

using Conda
using PyCall

pyModulePyPDF2 = PyCall.PyNULL()

pypdf_version="1.27.9"
try 
    @warn("Removing PyPDF package and installing version $(pypdf_version)")
    #https://anaconda.org/conda-forge/pypdf2
    run(`pip uninstall PyPDF2 -y`)
    run(`pip install PyPDF2==$pypdf_version`)
    #pip install PyPDF2==1.27.9

    try 
        #this line may trigger installation
        copy!(pyModulePyPDF2, PyCall.pyimport("PyPDF2"))    
    catch e 
        @show e 
        try 
            copy!(pyModulePyPDF2, PyCall.pyimport_conda("PdfFileMerger","PyPDF2","conda-forge"))
        catch e 
            @show e 
        end    
    end 
        
catch ee 
    @warn("failed to build MergePDFs")
    @show ee
end 