**Please note that this is an updated version (ALMM_v1), the main improvement lies in the following three parts:**

1) the updated code is able to input non-grid HSI (e.g., the size is 107 * 107, not only limiting to e.g., 100 * 100);
2) a blind ALMM code is added in this toolbox as well, which enables simultaneous abundance estimation and endmember extraction;
3) we correct a problem that the final abundance maps can not be imshown correctly.


The code in this toolbox implements the ["An augmented linear mixing model to address spectral variability for hyperspectral unmixing"](https://ieeexplore.ieee.org/document/8528557).
More specifically, it is detailed as follow

**Please kindly cite the papers if this code is useful and helpful for your research.**

     @article{hong2019augmented,
     title={An augmented linear mixing model to address spectral variability for hyperspectral unmixing},
     author={Hong, Danfeng and Yokoya, Naoto and Chanussot, Jocelyn and Zhu, Xiao Xiang},
     journal={IEEE Trans. Image Process.},
     volume={28},
     number={4},
     pages={1923--1938},
     year={2019},
     publisher={IEEE}}


System-specific notes
---------------------
The code was tested in Matlab R2016a or higher versions on Windows 10 machines.

How to use it?
---------------------

Directly run demo.m to reproduce the results on the synthetic data, which exists in the aforementioned paper.  
Note that the simulated data can be downloaded from  
[google drive](https://drive.google.com/open?id=1r1a6hP8fkwnMFGG2ATG5PM_I3gHVG-3U)  
[baiduyun](https://pan.baidu.com/s/1ABbWgkEkzp2Q02yjeYjxvw): ivb0 (access code).

If you want to run the code in your own data, you can accordingly change the input (e.g., data) and tune the parameters.
Please note that 
1) the shape of the input matrix.
2) when you are running the code in parallel, that is, you have to seperate the input HSI into some patches,
in our code, the patch must be square (length = width).
3) if the endmemebers are not given in advance, the code would automatically extract the endmembers from HSI using VCA [1].

If you encounter the bugs while using this code, please do not hesitate to contact us.

(c) Danfeng Hong, Remote Sensing Technology Institute (IMF), German Aerospace Center (DLR), Germany; <br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Singnal Processing in Earth Oberservation (SiPEO), Technical University of Munich (TUM), Germany.<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; danfeng.hong@dlr.de      
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; hongdanfeng1989@gmail.com

Licensing
---------

Copyright (C) 2019 Danfeng Hong

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.

Contact Information:
--------------------

Danfeng Hong: hongdanfeng1989@gmail.com<br>
Danfeng Hong is with the Remote Sensing Technology Institute (IMF), German Aerospace Center (DLR), Germany; <br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; with the Singnal Processing in Earth Oberservation (SiPEO), Technical University of Munich (TUM), Germany. 
