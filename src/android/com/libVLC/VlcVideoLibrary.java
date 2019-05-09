//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.libVLC;

import android.content.Context;
import android.graphics.SurfaceTexture;
import android.net.Uri;
import android.view.Surface;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.TextureView;

import com.webmons.disono.vlc.VlcListener;

import org.videolan.libvlc.IVLCVout;
import org.videolan.libvlc.LibVLC;
import org.videolan.libvlc.Media;
import org.videolan.libvlc.MediaPlayer;
import org.videolan.libvlc.MediaPlayer.Event;
import org.videolan.libvlc.MediaPlayer.EventListener;

public class VlcVideoLibrary implements EventListener {
    private int width = 0;
    private int height = 0;
    private SurfaceView surfaceView;
    private TextureView textureView;
    private SurfaceTexture surfaceTexture;
    private Surface surface;
    private SurfaceHolder surfaceHolder;
    private LibVLC vlcInstance;
    private MediaPlayer player;
    private VlcListener vlcListener;

    public VlcVideoLibrary(Context context, VlcListener vlcListener, SurfaceView surfaceView) {
        this.vlcListener = vlcListener;
        this.surfaceView = surfaceView;
        this.vlcInstance = new LibVLC(context, (new VlcOptions()).getDefaultOptions());
    }

    public VlcVideoLibrary(Context context, VlcListener vlcListener, TextureView textureView) {
        this.vlcListener = vlcListener;
        this.textureView = textureView;
        this.vlcInstance = new LibVLC(context, (new VlcOptions()).getDefaultOptions());
    }

    public VlcVideoLibrary(Context context, VlcListener vlcListener, SurfaceTexture surfaceTexture) {
        this.vlcListener = vlcListener;
        this.surfaceTexture = surfaceTexture;
        this.vlcInstance = new LibVLC(context, (new VlcOptions()).getDefaultOptions());
    }

    public VlcVideoLibrary(Context context, VlcListener vlcListener, Surface surface) {
        this.vlcListener = vlcListener;
        this.surface = surface;
        this.surfaceHolder = null;
        this.vlcInstance = new LibVLC(context, (new VlcOptions()).getDefaultOptions());
    }

    public VlcVideoLibrary(Context context, VlcListener vlcListener, Surface surface, SurfaceHolder surfaceHolder) {
        this.vlcListener = vlcListener;
        this.surface = surface;
        this.surfaceHolder = surfaceHolder;
        this.vlcInstance = new LibVLC(context, (new VlcOptions()).getDefaultOptions());
    }

    public VlcVideoLibrary(Context context, VlcListener vlcListener, Surface surface, int width, int height) {
        this.vlcListener = vlcListener;
        this.surface = surface;
        this.width = width;
        this.height = height;
        this.surfaceHolder = null;
        this.vlcInstance = new LibVLC(context, (new VlcOptions()).getDefaultOptions());
    }

    public VlcVideoLibrary(Context context, VlcListener vlcListener, Surface surface, SurfaceHolder surfaceHolder, int width, int height) {
        this.vlcListener = vlcListener;
        this.surface = surface;
        this.surfaceHolder = surfaceHolder;
        this.width = width;
        this.height = height;
        this.vlcInstance = new LibVLC(context, (new VlcOptions()).getDefaultOptions());
    }

    public void onEvent(Event event) {
        switch(event.type) {
        case 260:
            this.vlcListener.onPlayVlc();
            break;
        case 261:
            this.vlcListener.onPauseVlc();
            break;
        case 262:
            this.vlcListener.onStopVlc();
        case 263:
        case 264:
        default:
            break;
        case 265:
            this.player.stop();
            this.vlcListener.onVideoEnd();
            break;
        case 266:
            this.vlcListener.onError();
        }

    }

    public MediaPlayer getPlayer() {
        return this.player;
    }

    public LibVLC getVlcInstance() {
        return this.vlcInstance;
    }

    public boolean isPlaying() {
        return this.vlcInstance != null && this.player != null && this.player.isPlaying();
    }

    public void play(String endPoint) {
        if (this.player != null && !this.player.isReleased()) {
            if (!this.player.isPlaying()) {
                this.player.play();
            }
        } else {
            this.setMedia(new Media(this.vlcInstance, Uri.parse(endPoint)));
        }

    }

    public void stop() {
        if (this.player != null && this.player.isPlaying()) {
            this.player.stop();
            this.player.release();
        }

    }

    public void pause() {
        if (this.player != null && this.player.isPlaying()) {
            this.player.pause();
        }

    }

    private void setMedia(Media media) {
        media.addOption(":network-caching=1000");
        media.addOption(":file-caching=1000");
        media.addOption(":fullscreen");
        media.setHWDecoderEnabled(true, false);
        this.player = new MediaPlayer(this.vlcInstance);
        this.player.setMedia(media);
        this.player.setEventListener(this);
        IVLCVout vlcOut = this.player.getVLCVout();
        if (this.surfaceView != null) {
            vlcOut.setVideoView(this.surfaceView);
            this.width = this.surfaceView.getWidth();
            this.height = this.surfaceView.getHeight();
        } else if (this.textureView != null) {
            vlcOut.setVideoView(this.textureView);
            this.width = this.textureView.getWidth();
            this.height = this.textureView.getHeight();
        } else if (this.surfaceTexture != null) {
            vlcOut.setVideoSurface(this.surfaceTexture);
        } else {
            if (this.surface == null) {
                throw new RuntimeException("You cant set a null render object");
            }

            vlcOut.setVideoSurface(this.surface, this.surfaceHolder);
        }

        if (this.width != 0 && this.height != 0) {
            vlcOut.setWindowSize(this.width, this.height);
        }

        vlcOut.attachViews();
        this.player.setVideoTrackEnabled(true);
        this.player.play();
    }
}
