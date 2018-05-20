// Process utility functions
// Pierre Rossel 2018-05-19

import java.io.InputStreamReader;


// Return the exit value of the process
// This function will block until the end of the process
int getExitValue (Process pr) {
  int exitValue = 0;
  try {
    exitValue = pr.waitFor();
  } 
  catch (InterruptedException e) {
    println(e);
  }
  return exitValue;
}

// Return the content of the output stream of the process
// This function will block until the end of the process
StringList readOutput (Process pr) {
  return readStream(pr, pr.getInputStream());
}

// Return the content of the error stream of the process
// This function will block until the end of the process
StringList readError (Process pr) {
  return readStream(pr, pr.getErrorStream());
}

// Return the exit value of the process
// This function will block until the end of the process
StringList readStream (Process pr, InputStream stream) {
  StringList lines = new StringList();

  try {

    pr.waitFor();

    BufferedReader in = new BufferedReader(new InputStreamReader(stream));
    String line;
    while ((line = in.readLine()) != null) {
      //System.out.println(line);
      lines.append(line);
    }
  } 
  catch (IOException e) {
    println(e);
  }
  catch (InterruptedException e) {
    println(e);
  }
  return lines;
}

// exec with try/catch, env and dir
Process exec (String[] cmd, String[] env, File dir) {
 
  Process pr;
  try {
    pr = Runtime.getRuntime().exec(cmd, env, dir);
  } 
  catch (Exception e) {
    println(e);
    throw new RuntimeException(e);
  }
  return pr;
}
