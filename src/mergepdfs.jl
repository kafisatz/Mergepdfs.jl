module Mergepdfs

#https://stackoverflow.com/questions/64520684/merge-pdf-files-using-python-pypdf2 

using Conda
using PyCall
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
end

intermediatePdfFile = raw"c:\temp\intermediate.pdf"
outputPdfFile = raw"c:\temp\res.pdf"

#actual code
merger = pyModulePyPDF2.PdfFileMerger()

merger.append(raw"c:\temp\1.pdf")
merger.append(raw"c:\temp\2.pdf")

isfile(intermediatePdfFile) && rm(intermediatePdfFile)
merger.write(intermediatePdfFile)
merger.close()

#pdf_reader = pyModulePyPDF2.PdfFileReader(outputPdfFile)
#pdf_writer = pyModulePyPDF2.PdfFileWriter()
#nPages = pdf_reader.getNumPages()
#NOTE: python has an offset for indexing (0 to n-1)
#for pgnum in 0:nPages-1
#    pdf_writer.addPage(pdf_reader.getPage(pgnum))
#end

#A macro exists for mimicking Python's "with statement". For example:
#@pywith pybuiltin("open")("file.txt","w") as f begin
#    f.write("hello")
#end

#pwd()
#cd(raw"C:\temp\mergepdfs.jl\mergepdfs\src")
if isinteractive()
    include("src/py_snippted.jl")
else 
    include("py_snippted.jl")
end

@assert isfile(intermediatePdfFile)
py"read_and_encrypt"(intermediatePdfFile,outputPdfFile,false)
py"read_and_encrypt"(intermediatePdfFile,outputPdfFile,false,"usr","ownr")
py"read_and_encrypt"(intermediatePdfFile,outputPdfFile,true,"usr","ownr")
py"read_and_encrypt"(intermediatePdfFile,outputPdfFile,true,"","ownr")


outputPdfFile2 = raw"C:\temp\mixa99d.pdf"
outputPdfFile2 = outputPdfFile
outputstream = pybuiltin("open")(outputPdfFile2, "wb")
#pdf_writer.encrypt("mypass", use_128bit=True)
pdf_writer.write(outputstream)
outputstream.close()

outputstream = open("/home/user/Desktop/2.pdf", "wb")
#pdf_writer.encrypt("mypass", use_128bit=True)
pdf_writer.write(outputstream)
outputstream.close()




pdf_writer.close()

fh = open(outputPdfFile)
pdf_writer.write(fh)
close(fh)
    

pdfdoc.encrypt("mi", owner_pwd="", use_128bit = false)






for item in os.listdir(source_dir):
    if item.endswith('pdf'):
        #print(item)
        merger.append(source_dir + item)

merger.write(source_dir + 'Output/Complete.pdf')       
merger.close()


"""import os
from PyPDF2 import PdfFileMerger

source_dir = './PDF Files/'
merger = PdfFileMerger()

for item in os.listdir(source_dir):
    if item.endswith('pdf'):
        #print(item)
        merger.append(source_dir + item)

merger.write(source_dir + 'Output/Complete.pdf')       
merger.close()
"""

end # module
