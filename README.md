# Embroidery Finder

Have you lost the plot keeping track of all those embroidery designs?

Because I sure did.

This tool will search through your entire Windows PC's file system, tell you where all of the .pes files are, and copy them all to a single new directory so you have them all in one convenient place.

The tool can be easily modified to accomodate other file types, but I personally only use .pes files, so that's all this looks for.

If you need help modifying things to suit your needs, feel free to email dcwelch545@gmail.com... He will happily help you out :)

## Requirements

PowerShell version 5.1+ (most Windows PCs should have this if you are up to date!)

## Running the Tool

1. Download the script (find_pes_files.ps1) to your computer (e.g. clone the repo or just copy the script to your local machine)
2. Open PowerShell and go to the folder where the script is:

   `cd path\to\the\folder`
   
4. Run the script:

   `.\find_pes_files.ps1`

Note: If you get a message saying "running scripts is disabled on this system", then you need to enable running scripts using this command:
   
   `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned`

## Output

After you run the script, you should see the following:

1. A folder called "embroidery_files_found" with a copy of all the .pes files it found
2. A summary .csv showing you where the .pes files were found
3. This:

<img width="1031" height="932" alt="Untitled" src="https://github.com/user-attachments/assets/c428556a-5637-47f1-879b-ccdf49f28ad7" />

Feel free to email dcwelch545@gmail.com if you have any questions or want help!
