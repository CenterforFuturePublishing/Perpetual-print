import controlP5.*;
import processing.pdf.*;
import static javax.swing.JOptionPane.*;
import java.util.Map;

ControlP5 cp5;
Toggle tglSendToPrinter;
Toggle tglShowMode;
ScrollableList lstDrawers;
Textfield txtLogFolder;

String pageWidth = "21";
String pageHeight = "12";

int pageHeightPoints = 0;
int pageWidthPoints = 0;

float cm2pt = 72 / 2.54;
float pt2cm = 2.54 / 72;

JSONObject settings;

String settingsFilename = "settings.json";

boolean setupDone = false;

ArrayList<String> lstDrawersNames = new ArrayList<String>(); // Human readable version
ArrayList<Class> lstDrawersClasses = new ArrayList<Class>(); // The classes objects 
ArrayList<String> lstDrawersClassesNames = new ArrayList<String>(); // The classes names (used in config file) 

String logFolder = "logs";
PrintWriter logger = null;
SimpleDateFormat sdfLogger;
int lastLogMs = 0;


void setup () {

  size(400, 600);
  PFont font = createFont("arial", 16);

  loadSettings();

  initDrawers();

  cp5 = new ControlP5(this);
  cp5.setFont(font);

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
    .setValue(settings.getBoolean("sendToPrinter", false))
    ;

  cp5.addTextfield("pageWidth")
    .setPosition(20, 200)
    .setSize(170, 30)
    .setAutoClear(false)
    .setValue(settings.getString("pageWidth", pageWidth))
    ;

  cp5.addTextfield("pageHeight")
    .setPosition(210, 200)
    .setSize(170, 30)
    .setAutoClear(false)
    .setValue(settings.getString("pageHeight", pageHeight))
    ;

  lstDrawers = cp5.addScrollableList("drawer")
    .setPosition(19, 141)
    .setSize(362, 250)
    .setBarHeight(30)
    .setItemHeight(30)
    .addItems(lstDrawersNames)
    .setValue(max(0, lstDrawersNames.indexOf(settings.getString("drawer", lstDrawersNames.get(0)))))
    ;

  boolean bShowMode = settings.getBoolean("showMode", false);
  tglShowMode = cp5.addToggle("showMode")
    .setPosition(210, 300)
    .setSize(50, 20)
    .setLabel("Show mode")
    .setValue(bShowMode)
    ;

  txtLogFolder = cp5.addTextfield("logFolder")
    .setPosition(20, 380)
    .setSize(width - 40, 30)
    .setAutoClear(false)
    .setValue(logFolder)
    ;

  cp5.addButton("changeLogPath")
    .setPosition(210, 420)
    .setSize(170, 30)
    .setLabel("change")
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
    20, 315); 
  //text(txtPageWidth.getStringValue() + " x " + txtPageHeight.getValue(), 20, 300);

  drawSequences();
}

void controlEvent(ControlEvent theEvent) {

  switch(theEvent.getName()) {

  case "pageWidth":
  case "pageHeight":
    if (Float.isNaN(float(theEvent.getStringValue()))) {
      ((Textfield)theEvent.getController()).setColor(color(255, 0, 0));
    } else {
      ((Textfield)theEvent.getController()).setColor(color(255));

      saveSettings();
    }

    break;
  default:
    if (setupDone) {
      saveSettings();
    }
  }

}

void initDrawers() {

  Class[] classes = getClass().getDeclaredClasses();
  for (Class cls : classes) {
    if (cls != Drawer.class && Drawer.class.isAssignableFrom(cls)) {
      String clsName = cls.getSimpleName();
      lstDrawersClassesNames.add(clsName);
      clsName = clsName.replace("Drawer", "");
      clsName = clsName.replaceAll("([A-Z])", " $1").trim();
      clsName = clsName.replaceAll("(\\d+)", " $1");
      log(clsName);
      lstDrawersNames.add(clsName);            
      lstDrawersClasses.add(cls);
    }
  }
}

//ArrayList<String> getDrawersNames() {
//    ArrayList<String> names = new ArrayList<String>();

//    Class[] classes = getClass().getDeclaredClasses();
//    for (Class cls : classes) {
//        //System.out.println("Class = " + cls.getSimpleName());
//        //System.out.println("   " + (Drawer.class.isAssignableFrom(cls) && cls != Drawer.class));
//        if (cls != Drawer.class && Drawer.class.isAssignableFrom(cls)) {
//            String clsName = cls.getSimpleName();
//            clsName = clsName.replace("Drawer", "");
//            clsName = clsName.replaceAll("([A-Z])", " $1").trim();
//            clsName = clsName.replaceAll("(\\d+)", " $1").trim();
//            println(clsName);
//            names.add(clsName);
//        }
//    }
//    return names;
//}

void loadSettings() {
  try {
    if (new File(sketchPath(settingsFilename)).exists()) {
      settings = loadJSONObject(settingsFilename);
      pageWidth = settings.getString("pageWidth", pageWidth);
      pageHeight = settings.getString("pageHeight", pageHeight);
      logFolder = settings.getString("logFolder", logFolder);
    }
  } 
  catch(Exception e) {
    log(e.toString());
  }
  if (settings == null) {
    settings = new JSONObject();
  }
}

void saveSettings() {
  log("saving settings");
  settings.setString("pageWidth", pageWidth);
  settings.setString("pageHeight", pageHeight);
  settings.setBoolean("sendToPrinter", tglSendToPrinter.getBooleanValue());
  settings.setString("drawer", lstDrawersNames.get((int)lstDrawers.getValue()));
  settings.setBoolean("showMode", tglShowMode.getBooleanValue());
  settings.setString("logFolder", logFolder);
  saveJSONObject(settings, settingsFilename);
}

String getDocSize() {
  return pageWidth + " x " + pageHeight + " cm\n" + 
    pageWidthPoints + " x " + pageHeightPoints + " pt";
}

void preview() {
  log("preview button pressed");

  String sFilePath = generatePDF(true, lstDrawersClassesNames.get((int)lstDrawers.getValue()));
  if (sFilePath == "") return;

  // open the file in its default app
  launch(sFilePath);
}

void print() {
  log("print button pressed");

  String sFilePath = generatePDF(false, lstDrawersClassesNames.get((int)lstDrawers.getValue()));
  if (sFilePath == "") return;

  if (tglSendToPrinter.getBooleanValue()) {
    // Print the file
    String[] args = new String[0];
    args = append(args, "lp");
    args = append(args, "-o");
    args = append(args, "media=Custom." + pageWidth + "x" + pageHeight + "cm");
    args = append(args, "-o");
    args = append(args, "scaling=100");
    args = append(args, sFilePath);
    log(join(args, " "));    
    Process p = exec(args);
    //Process p = exec("pwd");

    try {
      int result = p.waitFor();
      log("the process returned " + result);
    } 
    catch (InterruptedException e) {
      log(e.toString());
    }
  } else {
    // open the file in its default app
    launch(sFilePath);
  }
}

void showMode(boolean val) {
  if (val) {
    setupSequences();
  } else {
    clearSequences();
  }
}

void changeLogPath() {
  selectFolder("Select a folder to store log files:", "logFolderSelected");
}

void logFolderSelected(File selection) {
  if (selection != null) {
    log("User selected new log folder: " + selection.getAbsolutePath());
    logFolder = selection.getAbsolutePath();
    txtLogFolder.setValue(logFolder);
    saveSettings();
    javax.swing.JOptionPane.showMessageDialog ( null, "Restart the app to use new log folder", "Log folder", javax.swing.JOptionPane.INFORMATION_MESSAGE);
  }
}

void logFolder(String value) {
  logFolder = value;
  log("User changed log folder to: " + logFolder);
  javax.swing.JOptionPane.showMessageDialog ( null, "Restart the app to use new log folder", "Log folder", javax.swing.JOptionPane.INFORMATION_MESSAGE);
}

String generatePDF(boolean preview, String drawerClassName) {

  String sFilePath = sketchPath() + "/output/";
  sFilePath += year() + "." + nf(month(), 2) + "." + nf(day(), 2) + " " + nf(hour(), 2) + "" + nf(minute(), 2) + "" + nf(second(), 2);
  sFilePath += preview ? " preview" : " print";
  sFilePath += " " + drawerClassName;
  sFilePath += ".pdf";

  Drawer drawer = null;
  try {
    //java.lang.reflect.Constructor constructor = drawerClasses[1].getDeclaredConstructor(this.getClass());
    //java.lang.reflect.Constructor constructor = Class.forName(this.getClass().getName() + "$" + selectedDrawer).getDeclaredConstructor(this.getClass());
    java.lang.reflect.Constructor constructor = Class.forName(this.getClass().getName() + "$" + drawerClassName).getDeclaredConstructor(this.getClass());
    //java.lang.reflect.Constructor constructor = lstDrawersClasses.get((int)lstDrawers.getValue()).getDeclaredConstructor(this.getClass());

    drawer = (Drawer)constructor.newInstance(this);
  }
  //catch(ClassNotFoundException e) {
  //    showMessageDialog(null, "The drawer name is invalid: " + selectedDrawer, "Alert", ERROR_MESSAGE);
  //    //println("The drawer name is invalid: " + selectedDrawer);
  //    return "";
  //}
  catch(Exception e) {
    e.printStackTrace();
    return "";
  }
  if (drawer == null) {
    return "";
  }
  //println("Drawing with " + drawer.getName());
  log("Drawing with " + drawer.getClass().getSimpleName());

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

void log(String str) {

  if (logger == null) {
    sdfLogger = new SimpleDateFormat("Y-MM-dd HHmmss");
    String timestamp = sdfLogger.format(new Date());
    logger = createWriter(logFolder + "/log " + timestamp + ".txt");
    sdfLogger.applyPattern("YMMdd HH:mm:ss");
  }

  // Add empty line between sequences of messages
  int ms = millis();
  if (ms - lastLogMs > 1000) {
    logger.println();
    println();
  }

  // Send to file
  String time = sdfLogger.format(new Date());
  logger.println(time + "\t" + str);
  logger.flush();

  // Send to console
  println(time + "  " + str);

  lastLogMs = ms;
}

// This is the base class of all drawers
// Create your drawer implementation by extenting this class, see examples in Drawers tab
// Do not modify this class
public interface Drawer {

  // Draw a page into a PGrapics. 
  // Size of drawing can be obtained from p.width and p.height
  //
  // PGrapics p  The context to draw the page
  // int iPage0  Page number (0 based)
  // String filePath The file being generated (mostly for debug and tests)
  // return true to draw another page, false to stop drawing pages
  boolean drawPage(PGraphics p, int iPage0, String filePath);
}
