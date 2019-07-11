# Amjidanutpan Ramanujam
# amjith.r@gmail.com
# cs6630 - prj 4

package require vtk
package require vtkinteraction

################ read the data file ********************

vtkStructuredPointsReader reader
    reader SetFileName mummy.128.vtk


#######################Transfer Functions********************

vtkPiecewiseFunction opacityTransferFunction
    opacityTransferFunction AddPoint 0 0.0
    opacityTransferFunction AddPoint 75 0.0
    opacityTransferFunction AddPoint 95 0.0
    opacityTransferFunction AddPoint 110 0.4
     opacityTransferFunction AddPoint 120 0.6
     opacityTransferFunction AddPoint 145 1.0
     opacityTransferFunction AddPoint 255 1.0

 vtkColorTransferFunction colorTransferFunction
     colorTransferFunction AddRGBPoint     75.0 0.4 0.4 0.4
     colorTransferFunction AddRGBPoint     95.0 .8 .8 .8
     colorTransferFunction AddRGBPoint    110.0 .6 .6 .6

     colorTransferFunction AddRGBPoint    120.0 .6 .6 .6
     colorTransferFunction AddRGBPoint    145.0 .4 .4 .4 
     colorTransferFunction AddRGBPoint    255.0 .2 .2 .2



########################Volume Properties************************
vtkVolumeProperty volumeProperty
    volumeProperty SetScalarOpacity opacityTransferFunction
    volumeProperty SetColor colorTransferFunction
    volumeProperty ShadeOn




# set raycasting variables
vtkVolumeRayCastMIPFunction  MIPFunction

vtkVolumeRayCastMapper volumeMapper
    volumeMapper SetInput [reader GetOutput]
    volumeMapper SetVolumeRayCastFunction MIPFunction


volumeMapper SetSampleDistance 0.5  
#volumeMapper SetSampleDistance 1.0     
#volumeMapper SetSampleDistance 2.0     
#volumeMapper SetSampleDistance 4.0             


############ create volume ***************

vtkVolume volume
    volume SetMapper volumeMapper
    volume SetProperty volumeProperty


############# renderer, window, interactor *****************

vtkRenderer ren1
    ren1 SetBackground 0 0 0 
vtkRenderWindow renWin
    renWin AddRenderer ren1
    renWin SetSize 512 512
vtkRenderWindowInteractor iren
    iren SetRenderWindow renWin


#############################From camframe.tcl *****************************

set frame 0

vtkWindowToImageFilter w2if

vtkPNGWriter writer


proc saveFrame {} {
  global frame
  set name [format "frame%03d.png" $frame]
  w2if SetInput renWin
  writer SetInput [w2if GetOutput]
  writer SetFileName $name
  writer Write
  incr frame
  set name [format "frame%03d.png" $frame]
  .save configure -text [format "save %s" $name]
}

button .save -text "Save 'frame000.ppm'" -command saveFrame
button .quit -text "Quit" -command {exit}

######################### pack GUI objects***********************************

pack .save .quit -side bottom

ren1 AddVolume volume
renWin Render
#iren SetUserMethod {wm deiconify .vtkInteract}
iren AddObserver UserEvent {wm deiconify .vtkInteract}
iren SetDesiredUpdateRate 1
iren Initialize


