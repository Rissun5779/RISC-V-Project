% =================================================================
% Octave Script - Advanced Signal Simulation
% (Sine Wave + Broadband Signal + Noise)
% =================================================================

%% 1. 參數設定 (Parameter Setup)
clear; clc; close all;

FFT_SIZE      = 256;
SAMPLING_RATE = 1000;
PI            = 3.1415926535;
NOISE_LEVEL   = 0.2;  % 雜訊的強度，您可以調整這個值看看效果

fprintf("--- Octave Advanced FFT Simulation ---\n");

%% 2. 產生更複雜的測試訊號 (Generate Complex Test Signal)
fprintf("1. Generating complex signal (Sine + Sinc + Noise)...\n");

% 建立時間軸
time_axis = (0:FFT_SIZE-1) / SAMPLING_RATE;

% --- 訊號成分 ---
% 成分 A: 一個 50 Hz 的正弦波，振幅為 1.0
component_sine = 1.0 * sin(2.0 * PI * 50.0 * time_axis);

% 成分 B: 一個 Sinc 函數，它是一個典型的寬頻訊號
% 我們讓它在時間軸的中央出現
sinc_time = ( (0:FFT_SIZE-1) - FFT_SIZE/2 );
component_sinc = 2 * sinc(sinc_time / 10); % sinc(x) = sin(pi*x)/(pi*x)

% 成分 C: 高斯白雜訊 (Gaussian White Noise)
component_noise = NOISE_LEVEL * randn(1, FFT_SIZE);

% --- 混合訊號 ---
signal_buffer = component_sine + component_sinc + component_noise;
signal_type_str = "Sine(50Hz) + Sinc Pulse + Noise";


%% 3. 執行 FFT 並計算頻譜 (Perform FFT and Calculate Spectrum)
fprintf("2. Running FFT Calculation...\n");
fft_output = fft(signal_buffer);

fprintf("3. Calculating magnitude of the spectrum...\n");
magnitude_spectrum = abs(fft_output(1:FFT_SIZE / 2));


%% 4. 找出峰值頻率 (Find Peak Frequency)
% ... (這部分的邏輯和之前完全一樣，我們仍然尋找能量最強的點) ...
fprintf("4. Finding the peak frequency...\n");
[max_magnitude, max_index_in_subset] = max(magnitude_spectrum(2:end));
peak_index = max_index_in_subset + 1;
dominant_frequency = (peak_index - 1) * SAMPLING_RATE / FFT_SIZE;


%% 5. 輸出結果 (Display Results)
% ... (輸出文字結果的部分保持不變) ...
fprintf("\n--- FUNCTIONALITY ---\n");
fprintf("Peak found at index: %d\n", peak_index - 1);
fprintf("Dominant Frequency is approx: %.2f Hz\n", dominant_frequency);
fprintf("---------------------\n\n");


%% 6. 繪圖 (Plotting) - 視覺化結果
fprintf("Generating plots...\n");

freq_axis = (0:FFT_SIZE/2-1) * SAMPLING_RATE / FFT_SIZE;
figure;

% --- 上半圖：時域訊號 ---
subplot(2, 1, 1);
plot(time_axis, signal_buffer, 'b');
title(['Time Domain: Input Signal (', signal_type_str, ')']);
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% --- 下半圖：頻域頻譜 ---
subplot(2, 1, 2);
plot(freq_axis, magnitude_spectrum, 'r-');
title('Frequency Domain: Magnitude Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;
xlim([0, SAMPLING_RATE / 2]);

hold on;
plot(dominant_frequency, max_magnitude, 'bo', 'MarkerSize', 10, 'LineWidth', 2);
legend('Spectrum', 'Detected Peak');
hold off;

fprintf("Done! Please check the new plot window.\n");
