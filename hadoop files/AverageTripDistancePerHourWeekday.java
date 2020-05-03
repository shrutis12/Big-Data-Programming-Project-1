import java.io.IOException;
import java.util.StringTokenizer;
import java.util.*;
import java.text.*;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class AverageTripDistancePerHourWeekday {
    private static final Log LOG = LogFactory.getLog(AverageTripDistancePerHourWeekday.class);

    public static class TokenMapper extends Mapper<Object, Text, Text, DoubleWritable> {
        private DoubleWritable one = new DoubleWritable(1.0);
        private Text word = new Text();

        public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
            String[] tokens = value.toString().split(",");
			String weekend = null;
			
            if (!Character.isDigit(tokens[4].charAt(0))) // to skip the header
                return;
            one.set(Double.valueOf(tokens[4])); //column 4 has trip_distance info
            try {
                DateFormat inputDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date date=inputDateFormat.parse(tokens[1]);
				if(!date.getDay()==0 || !date.getDay()==6)
                {
					Text weekday = new Text("Weekday: "+date.getHours());
					word.set(weekday);
					context.write(word, one);
				}
            } catch (ParseException excpt) {
                excpt.printStackTrace();
            }
        }
    }

    public static class SumReducer extends Reducer<Text, DoubleWritable, Text, DoubleWritable> {
        private DoubleWritable result = new DoubleWritable();

        public void reduce(Text key, Iterable<DoubleWritable> values, Context context)
                throws IOException, InterruptedException {
            Double sum = 0.0;
            Double ctr = 0.0;
            for (DoubleWritable val : values) {
                sum += val.get();
                ctr++;
            }
            result.set(sum / ctr);
            context.write(key, result);
        }
    }

    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        conf.addResource(new Path("/opt/hadoop-3.2.1/etc/hadoop/core-site.xml"));
        conf.addResource(new Path("/opt/hadoop-3.2.1/etc/hadoop/hdfs-site.xml"));
        Job job = Job.getInstance(conf, "passenger count");
        job.setJarByClass(AverageTripDistancePerHourWeekday.class);
        job.setMapperClass(TokenMapper.class);
        job.setCombinerClass(SumReducer.class);
        job.setReducerClass(SumReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(DoubleWritable.class);
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }

}

