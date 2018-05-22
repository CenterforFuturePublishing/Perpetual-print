// ***************************************************************
// Define your drawer classes below. Each drawer has its own class
// The class name should begin with Drawer
// Example: DrawerRectangles01
// ***************************************************************


// This drawers create 3 empty pages. It can be duplicated as a started for new drawers.  
// (don't forget to change its name and this comment)
public class DrawerEmpty implements Drawer {

  // Draw a page into a PGrapics. 
  // Size of drawing can be obtained from p.width and p.height
  //
  // PGrapics p  The context to draw the page
  // int iPage0  Page number (0 based)
  // String filePath The file being generated (mostly for debug and tests)
  // return true to draw another page, false to stop drawing pages
  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    // Stop after drawing 3rd page
    return iPage0 + 1 < 3;
  }
}


// This drawer creates pages to test alignment on the plotter
class DrawerTestPage implements Drawer {

  PFont fontText;

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    if (fontText == null) {
      fontText = createFont("arial", 10);
    }

    String sFilename = new File(filePath).getName();

    p.translate(iPage0 * 100, 0);

    int margin = round(2 * cm2pt);

    // Texts
    p.textFont(fontText);
    p.textAlign(CENTER, CENTER);
    p.fill(0);

    // Top left corner with margin
    p.pushMatrix();
    p.translate(margin, margin);

    p.line(0, 0, 120, 0);
    p.line(0, 0, 0, 60);

    p.text(sFilename, 0, 0, 100, 40);

    // Page number
    p.text("page " + (iPage0 + 1), 50, 50);

    p.popMatrix();

    // Bottom left
    p.pushMatrix();
    p.translate(margin, p.height - margin);

    // Draw bottom lines
    p.line(0, 0, 120, 0);
    p.line(0, 0, 0, -100);

    // Filename
    p.text(sFilename, 0, -100, 100, 40);

    // Doc size only on fist page
    //if (iPage0 == 0) {
    p.text(getDocSize(), 50, -40);
    //}

    // Page number
    p.text("page " + (iPage0 + 1), 50, -10);

    p.popMatrix();


    return iPage0 + 1 < 3;
  }
}

// LINES 100 % WIDTH
// This drawer creates a pattern based on lines
class DrawerLine100 implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(0, i, p.width, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES 50 % WIDTH
// This drawer creates a pattern based on lines
class DrawerLine50 implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(0, i, p.width * 0.5, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES 5 % WIDTH
// This drawer creates a pattern based on lines
class DrawerLine5 implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line 
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(0, i, p.width * 0.05, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}
// LINES 100-0 % WIDTH
// This drawer creates a pattern based on lines
class DrawerLine100_0 implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);
    p.strokeWeight(1);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line 
      float w = map(i, 0, p.height, p.width, 0);

      p.line(0, i, w, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES SINE WIDTH
// This drawer creates a pattern based on lines
class DrawerLineSine implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between the lines

    p.noFill();
    p.stroke(0);
    p.strokeWeight(1);

    for (int i = 0; i < p.height; i += step) {
      // Diminishes the length of the line
      float w01 = map(i, 0, p.height, p.width, 0);

      // Change the length of the line with a sine
      float w02 = Math.abs(sin(i * 0.001)) * p.width;

      p.line(0, i, p.width - w02, i);
    }

    return iPage0 + 1 < 1;
  }
}


// POINTS 100 % WIDTH
// This drawer creates a pattern based on points
class DrawerPoint100 implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // changes the space between the dots

    p.noFill();
    p.stroke(0);

    //p.rotate(radians(iPage0)); // change the angle of the next page

    for (int x = 0; x < p.width; x += step) {
      for (int y = 0; y < p.height; y += step) {
        // Changes the weight of the point
        float sw = map(y, 0, p.height, 0.5, 3);
        p.strokeWeight(sw);

        p.point(x, y);
      }
    }

    return iPage0 + 1 < 1;
  }
}


// POINTS 50 % WIDTH
// This drawer creates a pattern based on points
class DrawerPoint50 implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // changes the space between the dots

    p.noFill();
    p.stroke(0);

    //p.rotate(radians(iPage0)); // change the angle of the next page

    for (int x = 0; x < p.width * 0.5; x += step) {
      for (int y = 0; y < p.height; y += step) {
        // Changes the weight of the point
        float sw = map(y, 0, p.height, 0.5, 3);
        p.strokeWeight(sw);

        p.point(x, y);
      }
    }

    return iPage0 + 1 < 1;
  }
}


// POINTS 5 % WIDTH
// This drawer creates a pattern based on points
class DrawerPoint5 implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // changes the space between the dots

    p.noFill();
    p.stroke(0);

    //p.rotate(radians(iPage0)); // change the angle of the next page

    for (int x = 0; x < p.width * 0.05; x += step) {
      for (int y = 0; y < p.height; y += step) {
        // Changes the weight of the point
        float sw = map(y, 0, p.height, 0.5, 3);
        p.strokeWeight(sw);

        p.point(x, y);
      }
    }

    return iPage0 + 1 < 1;
  }
}


// POINTS SINE SIZE
// This drawer creates a pattern based on points
class DrawerPointSine implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // changes the space between the dots

    p.noFill();
    p.stroke(0);

    //p.rotate(radians(iPage0)); // change the angle of the next page

    for (int x = 0; x < p.width; x += step) {
      for (int y = 0; y < p.height; y += step) {
        // Changes the weight of the point
        float sw = map(sin(y * 0.005), -1, 1, 0.5, 3);
        p.strokeWeight(sw);

        p.point(x, y);
      }
    }

    return iPage0 + 1 < 1;
  }
}
