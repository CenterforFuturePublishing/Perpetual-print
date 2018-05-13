

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

// This drawer creates a pattern based on squares.
class DrawerRectTestDavid01 implements Drawer {

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
