import controlP5.*;
import processing.pdf.*;

ControlP5 cp5;
Toggle tglSendToPrinter;

String pageWidth = "21";
String pageHeight = "12";

int pageHeightPoints = 0;
int pageWidthPoints = 0;

float cm2pt = 72 / 2.54;
float pt2cm = 2.54 / 72;

JSONObject settings;

String settingsFilename = "settings.json";

boolean setupDone = false;

void setup () {
    size(400, 400);
    PFont font = createFont("arial", 16);

    loadSettings();

    cp5 = new ControlP5(this);
    cp5.setFont(font);

    cp5.addTextfield("pageWidth")
        .setPosition(20, 200)
        .setSize(170, 30)
        //.setFocus(true)
        .setAutoClear(false)
        .setValue(settings.getString("pageWidth", pageWidth))
        ;

    cp5.addTextfield("pageHeight")
        .setPosition(210, 200)
        .setSize(170, 30)
        //.setFocus(true)
        .setAutoClear(false)
        .setValue(settings.getString("pageHeight", pageHeight))
        ;

    cp5.addButton("preview")
        .setPosition(20, 20)
        .setSize(170, 30)
        ;

    cp5.addButton("print")
        .setPosition(210, 20)
        .setSize(170, 30)
        ;

    tglSendToPrinter = cp5.addToggle("sendToPrinter")
        .setPosition(210, 80)
        .setSize(50, 20)
        .setLabel("Send to printer")
        .setValue(settings.getBoolean("sendToPrinter", false));
    ;

    textFont(font);

    setupDone = true;
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

void controlEvent(ControlEvent theEvent) {
    if (theEvent.isAssignableFrom(Textfield.class)) {
        if (Float.isNaN(float(theEvent.getStringValue()))) {
            println("invalid");
            ((Textfield)theEvent.getController()).setColor(color(255, 0, 0));
        } else {
            println("valid");
            ((Textfield)theEvent.getController()).setColor(color(255));

            saveSettings();
        }
    } else {
        if (setupDone) {
            saveSettings();
        }
    }
}

void loadSettings() {
    try {
        if (new File(sketchPath(settingsFilename)).exists()) {
            settings = loadJSONObject(settingsFilename);
        }
    } 
    catch(Exception e) {
        println(e);
    }
    if (settings == null) {
        settings = new JSONObject();
    }
}

void saveSettings() {
    settings.setString("pageWidth", pageWidth);
    settings.setString("pageHeight", pageHeight);
    settings.setBoolean("sendToPrinter", tglSendToPrinter.getBooleanValue());
    saveJSONObject(settings, settingsFilename);
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

    if (tglSendToPrinter.getBooleanValue()) {
        // Print the file
        String[] args = new String[0];
        args = append(args, "lp");
        args = append(args, "-o");
        args = append(args, "media=Custom." + pageWidth + "." + pageHeight + "cm");
        args = append(args, "-o");
        args = append(args, "scaling=100");
        args = append(args, sFilePath);
        println(join(args, " "));    
        Process p = exec(args);
        //Process p = exec("pwd");

        try {
            int result = p.waitFor();
            println("the process returned " + result);
        } 
        catch (InterruptedException e) {
            println(e);
        }
    } else {
        // open the file in its default app
        launch(sFilePath);
    }
}

String generatePDF(boolean preview) {

    String sFilePath = sketchPath() + "/output/";
    sFilePath += year() + "." + nf(month(), 2) + "." + nf(day(), 2) + " " + nf(hour(), 2) + "" + nf(minute(), 2) + "" + nf(second(), 2);
    sFilePath += preview ? " preview" : " print";
    sFilePath += ".pdf";

    Drawer drawer = createDrawer(selectedDrawer);

    PGraphics pdf = createGraphics(pageWidthPoints, pageHeightPoints, PDF, sFilePath);

    pdf.beginDraw();

    int iPage0 = 0;
    boolean bDrawAnother = true;
    while (bDrawAnother) {
        if (iPage0 > 0 && !preview) {
            ((PGraphicsPDF)pdf).nextPage();
        }
        pdf.pushMatrix();
        bDrawAnother = drawer.drawPage(pdf, iPage0, sFilePath);
        pdf.popMatrix();
        iPage0++;
    }

    pdf.dispose();
    pdf.endDraw();

    return sFilePath;
}
