import controlP5.*;
import processing.pdf.*;

ControlP5 cp5;

String pageWidth = "21";
String pageHeight = "4";

int pageHeightPoints = 0;
int pageWidthPoints = 0;

void setup () {
    size(400, 400);
    PFont font = createFont("arial", 20);

    cp5 = new ControlP5(this);
    cp5.setFont(font);

    cp5.addTextfield("pageWidth")
        .setPosition(20, 100)
        .setSize(200, 30)
        //.setFocus(true)
        .setAutoClear(false)
        .setValue(pageWidth)
        ;

    cp5.addTextfield("pageHeight")
        .setPosition(20, 200)
        .setSize(200, 30)
        .setFocus(true)
        .setAutoClear(false)
        .setValue(pageHeight)
        ;

    cp5.addButton("print", 0, 20, 20, 100, 30);

    textFont(font);
}

void draw () {
    background(0);

    // update point sizes
    pageWidthPoints = round(float(pageWidth) * 72 / 2.54);
    pageHeightPoints = round(float(pageHeight) * 72 / 2.54);

    text(getDocSize(), 
        20, 300); 
    //text(txtPageWidth.getStringValue() + " x " + txtPageHeight.getValue(), 20, 300);
}

String getDocSize() {
    return pageWidth + " x " + pageHeight + " cm\n" + 
        pageWidthPoints + " x " + pageHeightPoints + " pt";
}

void print() {
    println("print");

    generatePS();
    generatePDF();
}

void generatePS() {

    String sPages = join(loadStrings("test_pages.tpl.ps"), "\n");

    sPages = sPages.replaceAll("\\{pageWidth\\}", pageWidthPoints + "");
    sPages = sPages.replaceAll("\\{pageHeight\\}", pageHeightPoints + "");

    PrintWriter output = createWriter("test_pages.ps");
    output.println(sPages);
    output.flush();
    output.close();
}

void generatePDF() {

    PFont font = createFont("arial", 20);

    PGraphics pdf = createGraphics(pageWidthPoints, pageHeightPoints, PDF, "test_pages.pdf");

    pdf.beginDraw();

    addPageToPDF(pdf, 1);    
    addPageToPDF(pdf, 2);    
    addPageToPDF(pdf, 3);    


    pdf.dispose();
    pdf.endDraw();
}

void addPageToPDF(PGraphics pdf, int iPage) {
    int iPage0 = iPage - 1;

    if (iPage0 > 0) {
        ((PGraphicsPDF)pdf).nextPage();
    }

    pdf.pushMatrix();
    pdf.translate(iPage0 * 100, 0);
    pdf.line(0, pageHeightPoints, 120, pageHeightPoints);
    pdf.line(100, pageHeightPoints, 100, pageHeightPoints - 10);
    
    pdf.fill(0);
    pdf.textAlign(CENTER);
    pdf.text("page " + iPage, 50, pageHeightPoints - 10);

    pdf.text(getDocSize(), 50, pageHeightPoints - 50);
    pdf.popMatrix();
}
