#
#]activate .
using Test
using Mergepdfs
using PyCall

datafld = first(filter(isdir,["samplepdfs","../samplepdfs"]))
fi1 = joinpath(datafld,"1.pdf")
fi2 = joinpath(datafld,"2.pdf")
@assert isfile(fi1)
@assert isfile(fi2)

tmpfld = mktempdir()
@assert isdir(tmpfld)


list_of_pdf_files = joinpath.(datafld,["1.pdf","2.pdF","3.PDF","4.pDf"])
@assert all(isfile.(list_of_pdf_files))

@testset "Smoke Tests" begin

intermediatePdfFile = joinpath(tmpfld,"intermediate.pdf")
outputPdfFile = joinpath(tmpfld,"res.pdf")

##################################################################
#merging pdf files
##################################################################
merger = pyModulePyPDF2.PdfFileMerger()

merger.append(fi1)
merger.append(fi2)

isfile(intermediatePdfFile) && rm(intermediatePdfFile)
merger.write(intermediatePdfFile)
merger.close()
@test isfile(intermediatePdfFile)
intermediatePdfFile

#merge list of files
isfile(intermediatePdfFile) && rm(intermediatePdfFile)
mergepdfs(list_of_pdf_files,intermediatePdfFile)
@test isfile(intermediatePdfFile)

##################################################################
#encrypt file snippets
##################################################################
@assert isfile(intermediatePdfFile)

#file is not secured: anyone can open and edit
isfile(outputPdfFile) && rm(outputPdfFile)
    read_and_encrypt_jl(intermediatePdfFile,outputPdfFile,false)
@test isfile(outputPdfFile)

#file is not secured: anyone can open and edit
isfile(outputPdfFile) && rm(outputPdfFile)
    read_and_encrypt_jl(intermediatePdfFile,outputPdfFile,false,"usr","ownr")
@test isfile(outputPdfFile)

#file needs user pwd to be opened
isfile(outputPdfFile) && rm(outputPdfFile)
    read_and_encrypt_jl(intermediatePdfFile,outputPdfFile,true,"usr","ownr")
@test isfile(outputPdfFile)

#file can be opened by anyone, but editing is not allowed
isfile(outputPdfFile) && rm(outputPdfFile)
    read_and_encrypt_jl(intermediatePdfFile,outputPdfFile,true,"","ownr")
@test isfile(outputPdfFile)

end