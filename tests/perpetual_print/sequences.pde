
class Sequence {

  String name;
  StringList days = new StringList();
  StringList printers = new StringList();
  StringList drawers = new StringList();
  boolean random = false;
  boolean loop = true;

  Sequence(JSONObject config) {
    init(config);
  }

  void draw() {
    String currentDay = getCurrentDayOfWeek();

    // Vérifier si cette séquence est active
    if (days.size() == 0 || days.hasValue(currentDay)) {
      //println("Sequence is active: " + name);

      // Check if printer queues are empty
      if (printerQueuesEmpty(printers)) {
        sendNextDrawing();
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

    // Check valid configuration for days
    String error = checkListValues(days, new StringList("lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi", "dimanche"));
    if (error != null) {
      javax.swing.JOptionPane.showMessageDialog ( null, 
        "Sequence '" + name + "' contains an error in 'days' section: \n\n" + error, 
        "Sequence check", javax.swing.JOptionPane.WARNING_MESSAGE);
    }

    // Check valid configuration for printers
    error = checkListValues(printers, lstPrinters);
    if (error != null) {
      javax.swing.JOptionPane.showMessageDialog ( null, 
        "Sequence '" + name + "' contains an error in 'printers' section: \n\n" + error, 
        "Sequence check", javax.swing.JOptionPane.WARNING_MESSAGE);
    }

    // Check valid configuration for drawers
    error = checkListValues(drawers, new StringList(lstDrawersClassesNames.toArray()));
    if (error != null) {
      javax.swing.JOptionPane.showMessageDialog ( null, 
        "Sequence '" + name + "' contains an error in 'drawers' section: \n\n" + error, 
        "Sequence check", javax.swing.JOptionPane.WARNING_MESSAGE);
    }

    //println("days: " + days);
    //println("printers: " + printers);
    //println("drawers: " + drawers);
  }

  void sendNextDrawing () {
    println("TODO: sendNextDrawing");
    
  }
}

ArrayList<Sequence> lstSequences = new ArrayList<Sequence>();
StringList lstPrinters;

void setupSequences() {

  // Get list of printers
  lstPrinters = getPrinters();
  println("Available printers: " + join (lstPrinters.array(), ", "));

  // Load JSON file
  JSONArray configSeq;
  try {
    configSeq = loadJSONArray("sequences.json");
  } 
  catch (Exception e) {
    //println(e);
    return;
  }

  // Create and init Sequence objects
  for (int i = 0; i < configSeq.size(); i++) {
    lstSequences.add(new Sequence(configSeq.getJSONObject(i)));
  }
}

void drawSequences() {
  for (Sequence seq : lstSequences) {
    seq.draw();
  }
}

StringList getPrinters() {
  StringList lst = new StringList();

  Process pr = exec(
    new String[] {"lpstat", "-v"}, 
    new String[] {"SOFTWARE=", "LANG=C"}, 
    null
    );

  StringList lines = readOutput(pr);
  //println("output: \n" +join(lines.array(), "\n"));

  for (String line : lines) {
    lst.append(line.split(" ")[2].split(":")[0]);
  }

  return lst;
}

boolean printerQueuesEmpty (StringList printers) {
  //println("TODO: printerQueuesEmpty"); 

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
  Date d = new Date();
  String dayOfTheWeek = sdf.format(d);
  return dayOfTheWeek;
}
