# EEGTools
Author: Zach Psaras

Written for the Suzuki Exercise lab @ NYU

## Files
<pre>
.
├── README.md
├── scripts						Contains automation scripts
│   ├── batch						Contains scripts that work on groups of folders (batch)
│   │   ├── old_step1.sh				Old version of step1.sh. Do not use
│   │   └── step1.sh					Script that renames and merges EEG Data in batch
│   └── single_folder				Contains scripts that work on single folders
│       ├── step1.sh					DEPRECATED First half of instructions
│       └── step2.sh					DEPRECATED Second half of instructions
├── tools						Contains binaries for manipulating EEG Data
│   └── xml-edit-xpath				Contains xml-edit
│       ├── main.c					xml-edit source
│       ├── makefile				xml-edit makefile. Run make to build the source to a binary
│       └── xml-edit				A binary. You may need to rebuild for your Linux Distro
└── xml							Contains generic .xml's for automation
    ├── amplifier.xml				Default XML with out settings. Not important.
    ├── concatenate.xml				Settings and plugins loaded for concatenation.
    ├── merge1.xml					Settings and plugins for the first merge.
    ├── merge2.xml					Settings and plugins for the second merge.
    ├── what_are_these.txt			Text file giving details about these files
    ├── what_are_these.txt~			Hue.
    └── WSC001Baseline1_COLORS.xml	Settings and plugins for the final files with "Color by Julia (tm)" ;]
</pre>
