# #!python
# from pdfminer.pdfparser import PDFParser
# from pdfminer.pdfdocument import PDFDocument

# pdf_path = ""

# def main():
# 	print get_toc

# def get_toc(pdf_path):
#     infile = open(pdf_path, 'rb')
#     parser = PDFParser(infile)
#     document = PDFDocument(parser)
#     print document

#     toc = list()
#     for (level,title,dest,a,structelem) in document.get_outlines():
#         toc.append((level, title))

#     return toc
# if __name__ == "__main__":
# 	main()


from pdfminer.pdfinterp import PDFResourceManager, PDFPageInterpreter
from pdfminer.converter import TextConverter
from pdfminer.layout import LAParams
from pdfminer.pdfpage import PDFPage
from io import StringIO

def convert_pdf_to_txt(path, codec='utf-8'):
    rsrcmgr = PDFResourceManager()
    retstr = StringIO()
    laparams = LAParams()
    device = TextConverter(rsrcmgr, retstr, codec=codec, laparams=laparams)
    fp = open(path, 'rb')   
    with open('example.pdf') as f:
        doc = slate.PDF(f)
    # interpreter = PDFPageInterpreter(rsrcmgr, device)
    # password = ""
    # maxpages = 0
    # caching = True
    # pagenos=set()

    # for page in PDFPage.get_pages(fp, pagenos, maxpages=maxpages, password=password,caching=caching, check_extractable=True):
    #     interpreter.process_page(page)

    # text = retstr.getvalue()

    # fp.close()
    # device.close()
    # retstr.close()
    # return text












