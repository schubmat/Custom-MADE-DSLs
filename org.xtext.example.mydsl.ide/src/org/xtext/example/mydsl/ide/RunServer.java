package org.xtext.example.mydsl.ide;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.SocketAddress;
import java.nio.channels.AsynchronousServerSocketChannel;
import java.nio.channels.AsynchronousSocketChannel;
import java.nio.channels.Channels;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.function.Function;

import org.eclipse.lsp4j.jsonrpc.Launcher;
import org.eclipse.lsp4j.jsonrpc.MessageConsumer;
import org.eclipse.lsp4j.services.LanguageClient;
import org.eclipse.xtext.ide.server.LanguageServerImpl;
import org.eclipse.xtext.ide.server.ServerModule;
//import org.xtext.example.mydsl.websockets.

import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.inject.Guice;
import com.google.inject.Injector;

/**
 * @author dietrich - Initial contribution and API
 */
public class RunServer {

/**
     * Logging, just in case anything goes wrong.
     */
    private static final Logger LOG = Logger.getLogger(RunServer.class.getName());
        //LoggerFactory.getLogger(RunServer.class);

	public static void main(String[] args) throws InterruptedException, IOException {

		//RunWebSocketServer.main(args);
		
		LOG.setLevel(Level.INFO);
		LOG.log(Level.INFO,"-- Starting.");

		Injector injector = Guice.createInjector(new ServerModule());
		LanguageServerImpl languageServer = injector.getInstance(LanguageServerImpl.class);

		LOG.log(Level.INFO,"-- LanguageServer injected");

		Function<MessageConsumer, MessageConsumer> wrapper = consumer -> {
			MessageConsumer result = consumer;
			return result;
		};
		Launcher<LanguageClient> launcher = createSocketLauncher(languageServer, LanguageClient.class, new InetSocketAddress("localhost", 5007), Executors.newCachedThreadPool(), wrapper);
		languageServer.connect(launcher.getRemoteProxy());

		Future<?> future = launcher.startListening();
		while (!future.isDone()) {
			Thread.sleep(10_000l);
		}
		
	}
	
    static <T> Launcher<T> createSocketLauncher(Object localService, Class<T> remoteInterface, SocketAddress socketAddress, ExecutorService executorService, Function<MessageConsumer, MessageConsumer> wrapper) throws IOException {
        AsynchronousServerSocketChannel serverSocket = AsynchronousServerSocketChannel.open().bind(socketAddress);
        AsynchronousSocketChannel socketChannel;
        try {
            socketChannel = serverSocket.accept().get();
            return Launcher.createIoLauncher(localService, remoteInterface, Channels.newInputStream(socketChannel), Channels.newOutputStream(socketChannel), executorService, wrapper);
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
        }
        return null;
    }

}