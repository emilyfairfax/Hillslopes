# Hillslopes
Models for various hillslope diffusion scenarios

<em>General Notes:</em>
<p>1) All scenarios make use of the HbedrockFunction to define the initial topography, so ensure that it is downloaded to the same folder as the script files</p>
<p>2) The parameters used (such as dx, dt, k, etc) are very sensitive and changing them even slightly sometimes makes the code blow up. At this point in time I have not figured out a way to make the code less sensitive to small changes in parameters.</p>

<em>File Navigation:</em>
<p>1) The basic hillslope diffusion model is in the code titled "rockandsoilwithfunction"</p>
<p>2) A scenario of continual vertical slip along a fault line is in the code titled "faultdiffusion"</p>
<p>3) A scenario of discreet large vertically displacing earthquakes along a fault line is in the code titled "earthquakediffusion"</p>
<p>4) A scenario of just a big pile of sand flattening out without channels to take away the material is in the code titled  "sandpilediffusion"</p>

<p>Feel free to email me with questions/concerns/issues</p>
<p>Emily</p>
