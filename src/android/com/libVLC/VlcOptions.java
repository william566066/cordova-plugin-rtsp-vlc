//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.libVLC;

import java.util.ArrayList;

public class VlcOptions {
    public VlcOptions() {
    }

    public ArrayList<String> getDefaultOptions() {
        ArrayList<String> options = new ArrayList();
        options.add("-vvv");
        options.add("--rtsp-tcp");
        return options;
    }
}
