#
#]activate .
using Test
using Mergepdfs

intermediatePdfFile = raw"c:\temp\intermediate.pdf"
outputPdfFile = raw"c:\temp\res.pdf"

#actual code
merger = pyModulePyPDF2.PdfFileMerger()

merger.append(raw"c:\temp\1.pdf")
merger.append(raw"c:\temp\2.pdf")

isfile(intermediatePdfFile) && rm(intermediatePdfFile)
merger.write(intermediatePdfFile)
merger.close()

