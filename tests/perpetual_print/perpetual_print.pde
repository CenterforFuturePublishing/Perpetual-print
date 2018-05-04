import controlP5.*;
import processing.pdf.*;

ControlP5 cp5;

String pageWidth = "21";
String pageHeight = "12";

int pageHeightPoints = 0;
int pageWidthPoints = 0;

float cm2pt = 72 / 2.54;
float pt2cm = 2.54 / 72;

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

    cp5.addButton("preview")
        .setPosition(20, 20)
        .setSize(100, 30)
        ;

    cp5.addButton("print")
        .setPosition(200, 20)
        .setSize(100, 30)
        ;

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

void preview() {
    println("preview");

    String sFilePath = generatePDF(true);

    // open the file in its default app
    launch(sFilePath);
}

void print() {
    println("print");

    String sFilePath = generatePDF(false);

    // Print the file
    String[] args = new String[0];
    args = append(args, "lp");
    args = append(args, "-o");
    args = append(args, "media=rouleau");
    args = append(args, sFilePath);
    
    Process p = exec(args);
    //Process p = exec("pwd");

    try {
        int result = p.waitFor();
        println("the process returned " + result);
    } 
    catch (InterruptedException e) {
        println(e);
    }
}

String generatePDF(boolean preview) {

    String sFilePath = sketchPath() + "/output/";
    sFilePath += year() + "." + nf(month(), 2) + "." + nf(day(), 2) + " " + nf(hour(), 2) + "" + nf(minute(), 2) + "" + nf(second(), 2);
    sFilePath += preview ? " preview" : " print";
    sFilePath += ".pdf";

    PFont font = createFont("arial", 20);

    PGraphics pdf = createGraphics(pageWidthPoints, pageHeightPoints, PDF, sFilePath);

    pdf.beginDraw();

    int iPage0 = 0;
    boolean bDrawAnother = true;
    while (bDrawAnother) {
        if (iPage0 > 0 && !preview) {
            ((PGraphicsPDF)pdf).nextPage();
        }
        pdf.pushMatrix();
        bDrawAnother = drawPage(pdf, iPage0, sFilePath);
        pdf.popMatrix();
        iPage0++;
    }

    pdf.dispose();
    pdf.endDraw();

    return sFilePath;
}
