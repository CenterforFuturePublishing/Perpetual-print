
// Draw a page into a PGrapics. 
// Size of drawing can be got from p.width and p.height
//
// PGrapics p  The context to draw the page
// int iPage0  Page number (0 based)
// return true to draw another page, false to stop drawing pages
boolean drawPage(PGraphics p, int iPage0) {

    p.translate(iPage0 * 100, 0);

    p.translate(50, -50);

    // Draw bottom lines
    p.line(0, p.height, 120, p.height);
    p.line(0, p.height, 0, p.height - 10);

    // Page number
    p.fill(0);
    p.textAlign(CENTER);
    p.text("page " + (iPage0 + 1), 50, p.height - 10);

    // Doc size only on fist page
    //if (iPage0 == 0) {
        p.text(getDocSize(), 50, p.height - 50);
    //}

    return iPage0 < 2;
}
