mkdir processed
for %%F in (*.jpeg) do (
  
    ffmpeg -i "%%F" -q:v 10 "processed\%%F"
)