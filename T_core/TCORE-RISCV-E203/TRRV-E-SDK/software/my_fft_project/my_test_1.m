% =================================================================
% Octave Script to Simulate and Visualize the C-based FFT test
% (Enhanced version with signal switching and detailed plot comments)
% =================================================================

%% 0. 設定 (Configuration)
clear; clc; close all;

% ⭐️ 開關：設為 true 使用脈衝訊號，設為 false 使用正弦波訊號
USE_IMPULSE_SIGNAL = false;

%% 1. 參數設定 (Parameter Setup)
FFT_SIZE      = 256;
SAMPLING_RATE = 1000;
PI            = 3.1415926535;

fprintf("--- Octave FFT Simulation ---\n");

%% 2. 產生測試訊號 (Generate Test Signal)
signal_buffer = zeros(1, FFT_SIZE); % 先建立一個全為零的陣列

if (USE_IMPULSE_SIGNAL)
    fprintf("1. Generating test signal (IMPULSE)...\n");
    % Octave 陣列索引從 1 開始，C 的 index 5 對應 Octave 的 index 6
    signal_buffer(6) = 100.0;
    signal_type_str = "Impulse";
else
    fprintf("1. Generating test signal (SINE WAVES)...\n");
    time_axis = (0:FFT_SIZE-1) / SAMPLING_RATE;
    main_freq_component = 1.0 * sin(2.0 * PI * 60.0 * time_axis);
    second_freq_component = 0.5 * sin(2.0 * PI * 150.0 * time_axis);
    signal_buffer = main_freq_component + second_freq_component;
    signal_type_str = "Sine Waves (60Hz + 150Hz)";
end

%% 3. 執行 FFT 並計算頻譜 (Perform FFT and Calculate Spectrum)
fprintf("2. Running FFT Calculation...\n");
fft_output = fft(signal_buffer);

fprintf("3. Calculating magnitude of the spectrum...\n");
magnitude_spectrum = abs(fft_output(1:FFT_SIZE / 2));

%% 4. 找出峰值頻率 (Find Peak Frequency)
fprintf("4. Finding the peak frequency...\n");
[max_magnitude, max_index_in_subset] = max(magnitude_spectrum(2:end)); % 忽略直流
peak_index = max_index_in_subset + 1;
dominant_frequency = (peak_index - 1) * SAMPLING_RATE / FFT_SIZE;

%% 5. 輸出結果 (Display Results)
% ... (輸出文字結果的部分保持不變，此處省略) ...
fprintf("\n--- FUNCTIONALITY ---\n");
fprintf("Peak found at index: %d\n", peak_index - 1);
fprintf("Dominant Frequency is approx: %.2f Hz\n", dominant_frequency);
fprintf("---------------------\n\n");

%% 6. 繪圖 (Plotting) - 視覺化結果
fprintf("Generating plots...\n");

% 建立時間軸和頻率軸
time_axis = (0:FFT_SIZE-1) / SAMPLING_RATE;
freq_axis = (0:FFT_SIZE/2-1) * SAMPLING_RATE / FFT_SIZE;

% figure; 指令會打開一個新的、空白的圖形視窗
figure;

% --- 上半圖：時域訊號 ---
% subplot(2, 1, 1); 將圖形視窗分割成 2 行 1 列，並選定第 1 個位置作畫
subplot(2, 1, 1);
if (USE_IMPULSE_SIGNAL)
    % 對於脈衝訊號，用 stem 畫火柴棒圖最能體現其離散特性
    stem(time_axis, signal_buffer, 'b');
else
    % 對於連續的正弦波，用 plot 畫曲線圖更合適
    plot(time_axis, signal_buffer, 'b');
end
title(['Time Domain: Input Signal (', signal_type_str, ')']);
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
if (USE_IMPULSE_SIGNAL)
    xlim([0, 20/SAMPLING_RATE]); % 脈衝訊號只顯示局部細節
end


% --- 下半圖：頻域頻譜 ---
% subplot(2, 1, 2); 選定分割後的第 2 個位置作畫
subplot(2, 1, 2);
plot(freq_axis, magnitude_spectrum, 'r-'); % 'r-' 代表紅色的實線
title('Frequency Domain: Magnitude Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;
xlim([0, SAMPLING_RATE / 2]); % 頻譜最高只會到取樣率的一半

% hold on; 告訴 Octave，接下來的繪圖要疊加在目前的圖上，不要清掉
hold on;
% 用一個藍色的圓圈，標示出我們找到的頻率峰值位置
plot(dominant_frequency, max_magnitude, 'bo', 'MarkerSize', 10, 'LineWidth', 2);
legend('Spectrum', 'Detected Peak');
hold off; % 關閉疊加模式

fprintf("Done! Please check the new plot window.\n");
