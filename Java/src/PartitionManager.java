import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.SecureRandom;
import java.io.FileOutputStream;
import java.io.OutputStream;

public class PartitionManager {
	
	public static void writeConcatBashScript(String sliceType, int slices) throws Exception {
		String sh = "for i in {0.."+slices+"}\n"
					+ "do\n"
					+ " cat "+sliceType+"-$i.yuv >> "+sliceType+".yuv\n"
					+ "done";
		File file = new File(sliceType+".sh");
    	OutputStream os = new FileOutputStream(file);
    	os.write(sh.getBytes());
    	os.flush();
    	os.close();
	}
	
	public static void writeDelBashScript(String sliceType, int slices) throws Exception {
		String sh = "for i in {0.."+slices+"}\n"
					+ "do\n"
					+ " rm "+sliceType+"-$i.yuv\n"
					+ "done";
		File file = new File(sliceType+"-del.sh");
    	OutputStream os = new FileOutputStream(file);
    	os.write(sh.getBytes());
    	os.flush();
    	os.close();
	}
	
	public static void sommaFrame(String file1, String file2) throws Exception {
		byte[] frame0 = Files.readAllBytes(Paths.get(file1+".yuv"));
		byte[] frame1 = Files.readAllBytes(Paths.get(file2+".yuv"));
		byte[] sum = new byte[frame0.length];
		for(int i=0; i<frame0.length; i++) {
			sum[i] = (byte)(frame0[i] + frame1[i]);
		}
		File file = new File(file1+"-"+file2+".yuv");
		OutputStream os = new FileOutputStream(file);
		os.write(sum);
		os.flush();
		os.close();
	}

	public static void delta0(int nSlice) throws Exception {
		for(int i=0; i<nSlice; i++) {
			byte[] videoBytes = Files.readAllBytes(Paths.get("video-"+i+".yuv"));
			SecureRandom sr = new SecureRandom();
			byte[] delta0Bytes = new byte[videoBytes.length];
			sr.nextBytes(delta0Bytes);
			File file = new File("delta0-"+i+".yuv");
	    	OutputStream os = new FileOutputStream(file);
	    	os.write(delta0Bytes);
	    	os.flush();
	    	os.close();
		}
	}
	
	public static void delta1(int nSlice) throws Exception {
		for(int i=0; i<nSlice; i++) {
			byte[] videoBytes = Files.readAllBytes(Paths.get("video-"+i+".yuv"));
			byte[] delta0Bytes = Files.readAllBytes(Paths.get("delta0-"+i+".yuv"));
			byte[] delta1Bytes = new byte[delta0Bytes.length];
			for(int j=0; j<videoBytes.length; j++) {
				delta1Bytes[j] = (byte)(videoBytes[j] - delta0Bytes[j]);
			}
			File file = new File("delta1-"+i+".yuv");
	    	OutputStream os = new FileOutputStream(file);
	    	os.write(delta1Bytes);
	    	os.flush();
	    	os.close();
		}
	}
	
	// Ricostruzione del video originale
	public static void secret(int nSlice) throws Exception {
		for(int i=0; i<nSlice; i++) {
			byte[] delta0Bytes = Files.readAllBytes(Paths.get("delta0-"+i+".yuv"));
			byte[] delta1Bytes = Files.readAllBytes(Paths.get("delta1-"+i+".yuv"));
			byte[] secretBytes = new byte[delta0Bytes.length];
			for(int j=0; j<delta0Bytes.length; j++) {
				secretBytes[j] = (byte)(delta0Bytes[j] + delta1Bytes[j]);
			}
			File file = new File("secret-"+i+".yuv");
	    	OutputStream os = new FileOutputStream(file);
	    	os.write(secretBytes);
	    	os.flush();
	    	os.close();
		}
	}
}
