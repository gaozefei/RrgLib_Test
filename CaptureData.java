//package com.kristou.urgLibJ.RangeSensor.Capture;

import java.util.Vector;

public class CaptureData {

    public class Step {

        public Vector<Long> distances = new Vector<Long>();
        public Vector<Long> intensities = new Vector<Long>();
    }
    public String command;
    public String status;
    public long timestamp;
    public Vector<Step> steps = new Vector<Step>();                          //注意这个数组的类型，里面的元素是Step 这个类
}