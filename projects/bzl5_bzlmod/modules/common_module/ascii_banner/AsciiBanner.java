package com.qarik.disruptor.common;

import java.awt.*;
import java.awt.image.BufferedImage;

public final class AsciiBanner {
    
    private static final String FILLUP_CHARACTER = "*";
    private static final int WIDTH = 160;
    private static final int HEIGHT = 50;
    private static final int FONT_SIZE = 12;

    private String text;
    
    public AsciiBanner(String text) {
        this.text = text;
    }

    public void show() {
        BufferedImage image = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics g = image.getGraphics();
        g.setFont(new Font("Ariel", Font.BOLD, FONT_SIZE));

        Graphics2D graphics = (Graphics2D) g;
        graphics.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING,
                RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
        graphics.drawString(this.text, 10, 20);

        for (int y = 0; y < HEIGHT; y++) {
            StringBuilder sb = new StringBuilder();
            for (int x = 0; x < WIDTH; x++) {
                // -16777216 == 0/none
                sb.append(image.getRGB(x, y) == -16777216 ? " " : FILLUP_CHARACTER);
            }

            if (sb.toString().trim().isEmpty()) {
                continue;
            }

            System.out.println(sb);
        }
    }

}