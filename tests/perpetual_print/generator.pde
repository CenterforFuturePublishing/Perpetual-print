PFont fontText;

// Draw a page into a PGrapics. 
// Size of drawing can be got from p.width and p.height
//
// PGrapics p  The context to draw the page
// int iPage0  Page number (0 based)
// return true to draw another page, false to stop drawing pages
boolean drawPage(PGraphics p, int iPage0, String filePath) {

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


    return iPage0 < 2;
}
