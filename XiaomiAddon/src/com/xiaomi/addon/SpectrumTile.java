package com.xiaomi.addon;

import android.annotation.TargetApi;
import android.graphics.drawable.Icon;
import android.os.SystemProperties;
import android.service.quicksettings.Tile;
import android.service.quicksettings.TileService;

@TargetApi(24)
public class SpectrumTile extends TileService {

    private static final String SPECTRUM_PROP = "persist.spectrum.profile";

    private static final String[] PROFILE_NAMES = {
        "Balance", "Performance", "Battery", "Gaming"
    };

    private static final int[] PROFILE_ICONS = {
        R.drawable.ic_spectrum_balance,
        R.drawable.ic_spectrum_performance,
        R.drawable.ic_spectrum_battery,
        R.drawable.ic_spectrum_gaming
    };

    @Override
    public void onStartListening() {
        super.onStartListening();
        updateTile();
    }

    @Override
    public void onClick() {
        super.onClick();
        int current = getProfile();
        int next = (current + 1) % 4;
        SystemProperties.set(SPECTRUM_PROP, String.valueOf(next));
        updateTile();
    }

    private void updateTile() {
        Tile tile = getQsTile();
        if (tile == null) return;
        int profile = getProfile();
        tile.setLabel("Spectrum: " + PROFILE_NAMES[profile]);
        tile.setIcon(Icon.createWithResource(this, PROFILE_ICONS[profile]));
        tile.setState(Tile.STATE_ACTIVE);
        tile.updateTile();
    }

    private int getProfile() {
        try {
            return Integer.parseInt(SystemProperties.get(SPECTRUM_PROP, "0"));
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}
