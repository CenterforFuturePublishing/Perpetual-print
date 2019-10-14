// Sequence class
//
// Defines what needs to be drawn, sent to which printer, which day, etc.
//
// Pierre Rossel 2018-05-19

class Sequence {

  // Data from sequences config file
  String name;
  StringList days = new StringList();
  StringList printers = new StringList();
  StringList drawers = new StringList();
  boolean random = false;
  boolean loop = true;
  float delay = 0; // in minutes

  // last drawer index used in drawers list 
  int iLastDrawer = -1;
  
  boolean active = true;
  
  int pauseEnd = 0; // End of pause (millis()) 
  
  int checkPeriod = 5000; // ms
  int nextCheck = 0;

  Sequence(JSONObject config) {
    init(config);
  }

  void draw() {
    
    int ms = millis();
    
    if (active && ms >= nextCheck && ms >= pauseEnd) {
      nextCheck += checkPeriod;
      
      String currentDay = getCurrentDayOfWeek();
  
      // Vérifier si cette séquence est active
      if (days.size() == 0 || days.hasValue(currentDay)) {
        //println("Sequence is active: " + name);
  
        // Check if printer queues are empty
        if (isPrinterQueuesEmpty(printers)) {
          sendNextDrawing();
        }
      }
      else {
        // Inactivate this sequence. Program must restart every day to have a chance of running it
       active = false; 
      }
    }
  }

  void init(JSONObject config) {
    name = config.getString("name");

    days = getStrings(config.get("days"));
    printers = getStrings(config.get("printers"));
    drawers = getStrings(config.get("drawers"));

    random = config.getBoolean("random", random);
    loop = config.getBoolean("loop", loop);
    delay = config.getFloat("delay", delay);

    // Check valid configuration for days
    String error = checkListValues(days, new StringList("lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi", "dimanche"));
    if (error != null) {
      String msg = "Sequence '" + name + "' contains an error in 'days' section: \n\n" + error; 
      log(msg);
      javax.swing.JOptionPane.showMessageDialog ( null, msg, "Sequence check", javax.swing.JOptionPane.WARNING_MESSAGE);
    }

    // Check valid configuration for printers
    error = checkListValues(printers, lstPrinters);
    if (error != null) {
      String msg = "Sequence '" + name + "' contains an error in 'printers' section: \n\n" + error; 
      log(msg);
      javax.swing.JOptionPane.showMessageDialog ( null, msg, "Sequence check", javax.swing.JOptionPane.WARNING_MESSAGE);
    }

    // Check valid configuration for drawers
    error = checkListValues(drawers, new StringList(lstDrawersClassesNames.toArray()));
    if (error != null) {
      String msg = "Sequence '" + name + "' contains an error in 'drawers' section: \n\n" + error; 
      log(msg);      
      javax.swing.JOptionPane.showMessageDialog ( null, msg, "Sequence check", javax.swing.JOptionPane.WARNING_MESSAGE);
    }

    // Register used printers
    for (String printer : printers) {
      lstUsedPrinters.appendUnique(printer);
    }

    //println("days: " + days);
    //println("printers: " + printers);
    //println("drawers: " + drawers);
  }

  void sendNextDrawing () {
    log("***** sendNextDrawing for sequence " + name + " *****");

    String drawerClassName = nextDrawer();
    if (drawerClassName == null) {
      log("no more drawer");
      active = false;
      return;
    }

    // set the pause between drawings
    if (delay > 0) {
      int delayMs = round(delay * 60 * 1000);
      pauseEnd = millis() + delayMs;
      log("Setting pause until " + new SimpleDateFormat("Y-MM-dd HH:mm:ss").format(new Date(System.currentTimeMillis() + delayMs)));
    }

    String sFilePath = generatePDF(false, drawerClassName);
    if (sFilePath == "") return;

    // Use default printer if none specified
    if (printers.size() == 0) {
      log("TODO: get default printer name");
      active = false;
      return;
    }

    // Print file on all printers of the list
    for (String printer : printers) {

      // Pause the printer before sending the job so that we can resume them all when all jobs ready
      //println("Pausing " + printer);
      exec("cupsdisable", printer);

      // Print the file
      //println("printing to " + printer);
      String[] args = new String[0];
      args = append(args, "lp");
      args = append(args, "-d");
      args = append(args, printer);
      args = append(args, "-o");
      args = append(args, "media=Custom." + pageWidth + "x" + pageHeight + "cm");
      args = append(args, "-o");
      args = append(args, "scaling=100");
      args = append(args, sFilePath);
      log("Print command: " + join(args, " "));    
      Process p = exec(args);

      try {
        int result = p.waitFor();
      } 
      catch (InterruptedException e) {
        log(e.toString());
      }
    }

    // Resume all printers so they start at the same time
    for (String printer : printers) {
      exec("cupsenable", printer);
    }

    log("***** sendNextDrawing done");
  }

  // return the name of the next drawer or null if there is no more
  String nextDrawer() {
    //log("Select next drawer");
    int nextDrawer = -1;
    if (random) {
      nextDrawer = int(random(drawers.size()));
    } else {
      nextDrawer = iLastDrawer + 1;
      if (nextDrawer >= drawers.size()) {
        if (loop) {
          nextDrawer = 0;
        } else
        {
          return null;
        }
      }
    }
    iLastDrawer = nextDrawer;
    return drawers.get(iLastDrawer);
  }
} // End of class

ArrayList<Sequence> lstSequences = new ArrayList<Sequence>();
StringList lstPrinters; // All printers available in the system
StringList lstUsedPrinters = new StringList(); // Printers used by the sequences

void setupSequences() {

  // Get list of printers
  lstPrinters = getPrinters();
  log("Available printers: " + join (lstPrinters.array(), ", "));

  // Load JSON file
  JSONArray configSeq;
  try {
    configSeq = loadJSONArray("sequences.json");
  } 
  catch (Exception e) {
    log("Error in sequences.json");
    log(e.toString());
    return;
  }

  // Create and init Sequence objects
  lstSequences.clear();
  lstUsedPrinters.clear();
  for (int i = 0; i < configSeq.size(); i++) {
    lstSequences.add(new Sequence(configSeq.getJSONObject(i)));
  }

  // clear queues of used printers
  clearUsedPrinterQueues();
}

void drawSequences() {
  for (Sequence seq : lstSequences) {
    seq.draw();
  }
}

void clearSequences() {
  clearUsedPrinterQueues();
  lstSequences.clear();
}

StringList getPrinters() {
  StringList lst = new StringList();

  Process pr = exec(
    new String[] {"lpstat", "-v"}, 
    new String[] {"SOFTWARE=", "LANG=C"}, 
    null
    );

  StringList lines = readOutput(pr);
  //log("output: \n" +join(lines.array(), "\n"));

  for (String line : lines) {
    lst.append(line.split(" ")[2].split(":")[0]);
  }

  return lst;
}

void clearUsedPrinterQueues() {
  for (String printer : lstUsedPrinters) {
    exec("lprm", "-P", printer);
  }
}

boolean isPrinterQueuesEmpty (StringList printers) {
  //println("isPrinterQueuesEmpty"); 

  for (String printer : printers) {
    Process pr = exec(
      new String[] {"lpq", "-P", printer}, 
      new String[] {"SOFTWARE=", "LANG=C"}, 
      null
      );

    StringList out = readOutput(pr);
    //println(out);

    // Jobs are listed starting at 3rd line
    if (out.size() > 2) {
      return false;
    }
  }

  return true;
}

// Check if the values of a list contains valid data
// return an error message or null
String checkListValues(StringList data, StringList lstValid) {

  for (String str : data) {
    if (!lstValid.hasValue(str)) {
      return "invalid value (" + str + ")";
    }
  }

  return null;
}

// Get a StringList out of an object that can be a String, a JSONArray of Strings
StringList getStrings(Object obj) {
  StringList sl = new StringList();
  if (obj == null) {
    // OK, list will be empty
  } else if (obj.getClass() == String.class) {
    String str = (String)obj; 
    if (str.length() > 0) {
      sl.append(str);
    }
  } else if (obj.getClass() == JSONArray.class) {
    // Assume array contains strings
    JSONArray arr = (JSONArray) obj;
    for (int i = 0; i < arr.size(); ++i) {
      sl.append(arr.getString(i));
    }
  }
  return sl;
}

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

String getCurrentDayOfWeek() {
  SimpleDateFormat sdf = new SimpleDateFormat("EEEE", Locale.FRENCH);
  String dayOfTheWeek = sdf.format(new Date());
  return dayOfTheWeek;
}
