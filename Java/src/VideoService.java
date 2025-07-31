import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;

import org.opencv.core.Core;
import org.opencv.videoio.VideoCapture;
import org.opencv.videoio.Videoio;


public class VideoService {
	
	// Indica la grandezza massima delle partizioni
	public static final int L = 268435456;
	
	// Restituisce la dimensione del video
	public static double  getDimensioneVideo(String filename) {
		File file = new File(filename);
		return Math.floor(file.length()/1024*1000)/1000;
	}
	
	// Restituisce la lunghezza del video
	public static double getLunghezzaVideo(String filename) {
		System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
		VideoCapture videoCapture = new VideoCapture(filename);
		videoCapture.set(Videoio.CAP_PROP_POS_AVI_RATIO, 1);
		return Math.floor(videoCapture.get(Videoio.CAP_PROP_POS_MSEC)/1000*1000)/1000;
	}
	
	// Restituisce il numero di frame del video
	public static int getNumeroFrame(String filename) {
		System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
		VideoCapture videoCapture = new VideoCapture(filename);
		videoCapture.set(Videoio.CAP_PROP_POS_AVI_RATIO, 1);
		return (int) videoCapture.get(Videoio.CAP_PROP_FRAME_COUNT);
	}
	
	// Restituisce il frame rate del video
	public static double getFrameRate(String filename) {
		System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
		VideoCapture videoCapture = new VideoCapture(filename);
		videoCapture.set(Videoio.CAP_PROP_POS_AVI_RATIO, 1);
		return Math.floor(videoCapture.get(Videoio.CAP_PROP_FPS)*1000)/1000;
	}
	
	// Restituisce l'altezza dei frame
	public static int getAltezzaFrame(String filename) {
		System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
		VideoCapture videoCapture = new VideoCapture(filename);
		videoCapture.set(Videoio.CAP_PROP_POS_AVI_RATIO, 1);
		return (int) videoCapture.get(Videoio.CAP_PROP_FRAME_HEIGHT);
	}
	
	// Restituisce la larghezza dei frame
	public static int getLarghezzaFrame(String filename) {
		System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
		VideoCapture videoCapture = new VideoCapture(filename);
		videoCapture.set(Videoio.CAP_PROP_POS_AVI_RATIO, 1);
		return (int) videoCapture.get(Videoio.CAP_PROP_FRAME_WIDTH);
	}
	
	// Restituisce il formato del pixel
	public static String getFormatoPixel(String filename, int altezza, int larghezza, double nFrames) throws Exception {
		String formato = "";
		byte[] bytes = Files.readAllBytes(Paths.get(filename));
    	String bytesPerPixel = Double.toString((double) bytes.length/(altezza*larghezza*nFrames));
    	System.out.println(bytesPerPixel);
    	switch(bytesPerPixel) {
    		case "1.5":
    			formato = "yuv420p";
    			break;
    		case "2.0":
    			formato = "yuv422p";
    			break;
    		case "3.0":
    			formato = "yuv444p";
    			break;
    		default:
    			formato = "undefined";
    	}
		return formato;
	}
	
	// Restituisce il numero di slice
	public static int getVideoSlices(String filename) throws Exception {
		byte[] bytes = Files.readAllBytes(Paths.get(filename));
		int slices = (int) Math.ceil((double)bytes.length/L);
		return slices==0?1:slices;
	}
	
	// Restituisce la lunghezza delle slice
	public static int getTempoSlice(double  lunghezzaVideo, int nSlice) {
		return (int) Math.ceil((double)lunghezzaVideo/nSlice);
	}
	
	// Restituisce il tempo corrente
	public static long getTempo() {
		return System.currentTimeMillis();
	}
	
	// Restituisce il tempo trascorso
	public static double computaTempo(long t1, long t2) {
		return Math.ceil((double)(t2-t1)/1000*1000)/1000;
	}
	
	// Restituisce la somma dei tempi
	public static double sommaTempi(double t1, double t2) {
		return Math.ceil((t1+t2)*1000)/1000;
	}
}
	
