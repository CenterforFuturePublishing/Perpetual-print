
// Temporary select here the drawer that has to be used. (until we get a list box)
String selectedDrawer = "RectTestDavid01";

// All drawers must have a name here
String[] drawerNames = {
    "Empty", 
    "TestPage", 
    "RectTestDavid01"
};

// All drawers must be created from this function 
// Use the same name as in drawers variable above and the class name as defined below
Drawer createDrawer(String name) {
    
    switch(name) {
        
    case "Empty":        
        return new DrawerEmpty();
    case "TestPage":        
        return new DrawerTestPage();
    case "RectTestDavid01":
        return new DrawerRectTestDavid01();
        
    }
    return null;
}


// This is the base class of all drawers
// Create your drawer implementation by extenting this class, see examples below
// Do not modify this class
class Drawer {

    // Draw a page into a PGrapics. 
    // Size of drawing can be got from p.width and p.height
    //
    // PGrapics p  The context to draw the page
    // int iPage0  Page number (0 based)
    // return true to draw another page, false to stop drawing pages
    boolean drawPage(PGraphics p, int iPage0, String filePath) {
        return false;
    }
}


// ***************************************************************
// Define your drawer classes below. Each drawer has its own class
// The class name must begin with Drawer, then the name as given 
// in the drawers variable above.
// Example: 
// ***************************************************************


// This drawers create 3 empty pages. It can be duplicated as a started for new drawers.  
// (don't forget to change its name and this comment)
class DrawerEmpty extends Drawer {

    @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

        return iPage0 + 1 < 3;
    }
}


// This drawer creates pages to test alignment on the plotter
class DrawerTestPage extends Drawer {

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

// This drawer creates a pattern based on squares.
class DrawerRectTestDavid01 extends Drawer {

    @Override boolean drawPage(PGraphics p, int iPage0, String filePath) {

        p.rectMode(CENTER);

        //int step = 200;
        int step = p.width / 6;
        float size = step / 2;

        //p.background(255);

        //p.fill(255);
        p.noFill();
        p.stroke(0);
        p.strokeWeight(1);

        for (int x = 0; x < p.width; x += step) {
            for (int y = 0; y < p.height; y += step) {
                p.pushMatrix();
                p.translate(x, y);
                p.scale(sin(x + y + iPage0  * 0.1));
                p.rotate(sin(x + y + iPage0  * 0.1));
                p.translate(-x, -y);
                //p.strokeWeight(sin(iPage0  * 0.0001) * 5);
                p.rect(x, y, size * 1 + sin(iPage0  * 0.1) * 100, size * 1 + sin(iPage0  * 0.1) * 100);
                p.popMatrix();
            }
        }

        return iPage0 + 1 < 10;
    }
}
