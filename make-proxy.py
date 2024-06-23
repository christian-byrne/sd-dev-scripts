import subprocess
import os

def create_cineform_proxy(input_file, bitrate, preset):

    # Extract directory and filename from the input path
    directory, filename = os.path.split(input_file)
    filename, _ = os.path.splitext(filename)

    # Set output proxy file path and name
    output_file = os.path.join(directory, f"PROXY-{filename}.mov")

    # FFmpeg command to create Cineform proxy with specified settings
    ffmpeg_cmd = [
        "ffmpeg",
        "-i", input_file,
        "-c:v", "dnxhd",
        "-profile:v", "dnxhr_lb",
        "-b:v", bitrate,
        # "-g", "1",  # Lower GOP size for better seeking
        "-preset", preset,  # User specified preset for processing speed
        "-c:a", "pcm_s16le",  # Audio codec suitable for editing
        output_file
    ]

    try:
        subprocess.run(ffmpeg_cmd, check=True)
        print(f"Proxy file created: {output_file}")
    except subprocess.CalledProcessError as e:
        print(f"Error creating proxy file: {e}")
        return


def remove_quotes(filepath):
    if filepath.startswith('"') and filepath.endswith('"'):
        return filepath[1:-1]
    return filepath

if __name__ == "__main__":
    input_file = remove_quotes(input("Enter the full path of the video file: "))

    print("Select the bitrate:")
    print("Press any key for default (5 Mbps)")
    print("Enter 'L' for low (2.5 Mbps)")
    print("Enter 'H' for high (10 Mbps)")
    print("Enter 'HH' for higher (50 Mbps)")

    user_input = input("Your choice: ")

    if user_input.lower() == 'l':
        selected_bitrate = "2.5M"
    elif user_input.lower() == 'h':
        selected_bitrate = "10M"
    elif user_input.lower() == 'hh':
        selected_bitrate = "50M"
    else:
        selected_bitrate = "5M"  # Default bitrate

    print("Select the processing speed:")
    print("Enter 'F' for fast processing (faster but larger file size)")
    print("Enter 'UF' for ultrafast processing (fastest but larger file size)")
    print("Press any key for default")

    user_input = input("Your choice: ")

    if user_input.lower() == 'f':
        selected_preset = "fast"
    elif user_input.lower() == 'uf':
        selected_preset = "ultrafast"
    else:
        selected_preset = "default"  # Default preset for any other input

    create_cineform_proxy(input_file, selected_bitrate, selected_preset)