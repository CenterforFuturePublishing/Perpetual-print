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

// LINES 0-100 % WIDTH
// 0-100 % lines, stroke weight 0.1-1
class DrawerLine0_100Sine implements Drawer {

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


// LINES 0-50 % WIDTH
// 0-50 % width lines, stroke weight 0.1-1
class DrawerLine0_50Sine implements Drawer {

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


// LINES 50-100 % WIDTH
// 50-100 % width lines, stroke weight 0.1-1
class DrawerLine50_100Sine implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(p.width * 0.5, i, p.width, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES 0-5 % WIDTH
// 0-5 % width lines, stroke weight 0.1-1
class DrawerLine0_5Sine implements Drawer {

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


// LINES 5-10 % WIDTH
// 5-10 % width lines, stroke weight 0.1-1
class DrawerLine5_10Sine implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line 
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(p.width * 0.05, i, p.width * 0.1, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES 10-15 % WIDTH
// 10-15 % width lines, stroke weight 0.1-1
class DrawerLine10_15Sine implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line 
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(p.width * 0.1, i, p.width * 0.15, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES 15-20 % WIDTH
// 15-20 % width lines, stroke weight 0.1-1
class DrawerLine15_20Sine implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line 
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(p.width * 0.15, i, p.width * 0.2, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES 20-25 % WIDTH
// 20-25 % width lines, stroke weight 0.1-1
class DrawerLine20_25Sine implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line 
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(p.width * 0.2, i, p.width * 0.25, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES 25-30 % WIDTH
// 25-30 % width lines, stroke weight 0.1-1
class DrawerLine25_30Sine implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line 
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(p.width * 0.25, i, p.width * 0.3, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES 30-35 % WIDTH
// 30-35 % width lines, stroke weight 0.1-1
class DrawerLine30_35Sine implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line 
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(p.width * 0.3, i, p.width * 0.35, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES 35-40 % WIDTH
// 35-40 % width lines, stroke weight 0.1-1
class DrawerLine35_40Sine implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line 
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(p.width * 0.35, i, p.width * 0.4, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES 40-45 % WIDTH
// 40-45 % width lines, stroke weight 0.1-1
class DrawerLine40_45Sine implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line 
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(p.width * 0.4, i, p.width * 0.45, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES 45-50 % WIDTH
// 45-50 % width lines, stroke weight 0.1-1
class DrawerLine45_50Sine implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line 
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(p.width * 0.45, i, p.width * 0.5, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES 50-55 % WIDTH
// 50-55 % width lines, stroke weight 0.1-1
class DrawerLine50_55Sine implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line 
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(p.width * 0.5, i, p.width * 0.55, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES 55-60 % WIDTH
// 55-60 % width lines, stroke weight 0.1-1
class DrawerLine55_60Sine implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line 
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(p.width * 0.55, i, p.width * 0.6, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES 60-65 % WIDTH
// 60-65 % width lines, stroke weight 0.1-1
class DrawerLine60_65Sine implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line 
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(p.width * 0.6, i, p.width * 0.65, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES 65-70 % WIDTH
// 65-70 % width lines, stroke weight 0.1-1
class DrawerLine65_70Sine implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line 
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(p.width * 0.65, i, p.width * 0.7, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES 70-75 % WIDTH
// 70-75 % width lines, stroke weight 0.1-1
class DrawerLine70_75Sine implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line 
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(p.width * 0.7, i, p.width * 0.75, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES 75-80 % WIDTH
// 75-80 % width lines, stroke weight 0.1-1
class DrawerLine75_80Sine implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line 
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(p.width * 0.75, i, p.width * 0.8, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES 80-85 % WIDTH
// 80-85 % width lines, stroke weight 0.1-1
class DrawerLine80_85Sine implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line 
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(p.width * 0.8, i, p.width * 0.85, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES 85-90 % WIDTH
// 85-90 % width lines, stroke weight 0.1-1
class DrawerLine85_90Sine implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line 
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(p.width * 0.85, i, p.width * 0.9, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES 90-95 % WIDTH
// 90-95 % width lines, stroke weight 0.1-1
class DrawerLine90_95Sine implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line 
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(p.width * 0.9, i, p.width * 0.95, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES 95-100 % WIDTH
// 95-100 % width lines, stroke weight 0.1-1
class DrawerLine95_100Sine implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);

    for (int i = 0; i < p.height; i += step) {
      // Changes the weight of the line 
      float thickness = map(sin(i * 0.001), -1, 1, 0.1, 1);
      p.strokeWeight(thickness);

      p.line(p.width * 0.95, i, p.width, i); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


// LINES 0-100 % WIDTH, SINE DISTANCE
// 0-100 % width lines, stroke weight 0.1, distance 10-100
class DrawerLine0_100SineDist implements Drawer {

  @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

    int step = 10; // defines the distance between lines

    p.noFill();
    p.stroke(0);
    p.strokeWeight(0.1);

    for (int i = 0; i < p.height; i += step) {
      float dist = map(sin(i * 0.01), -1, 1, 1, 100);
      p.line(0, i + dist, p.width, i + dist); // draw a line
    }

    return iPage0 + 1 < 1;
  }
}


/*
// LINES 100-0 % WIDTH
// Lines full-width to 0, stroke weight 1
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
// Lines sine between full-width-0, stroke weight 1
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
*/
