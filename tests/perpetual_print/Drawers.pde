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

//// 01
// This drawer creates a pattern based on lines.
class DrawerLineDavid01 implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = p.height / 100; // defines the number of lines on the page

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      float thickness = map(sin(i), -1, 1, 0.01, 0.1);
      p.strokeWeight(thickness); // defines the thickness of the lines

      p.line(0, i, p.width, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


//// 02
// This drawer creates a pattern based on lines.
class DrawerLineDavid02 implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 1; // defines the distance between lines

    p.noFill();
    p.stroke(0);
    p.strokeWeight(0.1); // defines the thickness of the lines

    for (int i = 0; i < p.height; i += step) {

      p.line(sin(i) * p.width / 3, i, p.width - sin(i) * p.width / 3, i); // draw a line
      step += 5;
    }

    return iPage0 + 1 < 1;
  }
}


//// 03
// This drawer creates a pattern based on lines.
class DrawerLineDavid03 implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = p.height / 100; // defines the number of lines on the page
    //int step = 100; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      float thickness = map(sin(i), -1, 1, 0.01, 0.1);
      p.strokeWeight(thickness); // defines the thickness of the lines

      p.line(0, i, p.width - noise(i) * p.width, i); // draw a line with perlin noise width
    }

    return iPage0 + 1 < 1;
  }
}

// This drawer creates a pattern based on points.
class DrawerPointTestDavid01 implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 50; // changes the space between the dots

    p.noFill();
    p.stroke(0);
    p.strokeWeight(10); // changes the size of the points

    p.rotate(radians(iPage0)); // change the angle of the next page

    for (int x = -p.height; x < p.height * 2; x += step) {
      for (int y = -p.height; y < p.height * 2; y += step) {
        p.point(x, y);
      }
    }

    return iPage0 + 1 < 6;
  }
}
