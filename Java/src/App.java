import java.util.Arrays;

public class App {
	
	public static void main(String[] args) {
		try {
			switch(args[1]) {
				case "--getVideoSize":
					System.out.println(VideoService.getDimensioneVideo(args[0]));
					break;
				case "--getVideoLength":
					System.out.println(VideoService.getLunghezzaVideo(args[0]));
					break;
				case "--getFrameRate":
					System.out.println(VideoService.getFrameRate(args[0]));
					break;
				case "--getFrameNumber":
					System.out.println(VideoService.getNumeroFrame(args[0]));
					break;
				case "--getFrameHeight":
					System.out.println(VideoService.getAltezzaFrame(args[0]));
					break;
				case "--getFrameWidth":
					System.out.println(VideoService.getLarghezzaFrame(args[0]));
					break;
				case "--getPixelFormat":
					System.out.println(VideoService.getFormatoPixel(args[0], Integer.parseInt(args[2]), Integer.parseInt(args[3]), Double.parseDouble(args[4])));
					break;
				case "--getVideoSlices":
					System.out.println(VideoService.getVideoSlices(args[0]));
					break;
				case "--getTimeSlice":
					System.out.println(VideoService.getTempoSlice(Double.parseDouble(args[2]), Integer.parseInt(args[3])));
					break;
				case "--getTime":
					System.out.println(VideoService.getTempo());
					break;
				case "--computeTime":
					System.out.println(VideoService.computaTempo(Long.parseLong(args[2]), Long.parseLong(args[3])));
					break;
				case "--sumTime":
					System.out.println(VideoService.sommaTempi(Double.parseDouble(args[2]), Double.parseDouble(args[3])));
					break;
				case "--writeConcatBashScript":
					PartitionManager.writeConcatBashScript(args[2], Integer.parseInt(args[3]));
					break;
				case "--writeDelBashScript":
					PartitionManager.writeDelBashScript(args[2], Integer.parseInt(args[3]));
					break;
				case "--sumFrames":
					PartitionManager.sommaFrame(args[2],args[3]);
					break;
				case "--delta0":
					PartitionManager.delta0(Integer.parseInt(args[2]));
					break;
				case "--delta1":
					PartitionManager.delta1(Integer.parseInt(args[2]));
					break;
				case "--secret":
					PartitionManager.secret(Integer.parseInt(args[2]));
					break;
				default:
					throw new Exception("Comando sconosciuto - " + Arrays.toString(args));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
}