# Amjidanutpan Ramanujam
# amjith.r@gmail.com
# cs6630 - Prj 4

package require vtk
package require vtkinteraction


# Add this line and one after the renderer 
vtkInteractorStyleTrackballCamera style


vtkStructuredPointsReader reader1
        reader1 SetFileName mummy.128.vtk

# Create transfer functions for opacity and color


vtkPiecewiseFunction opacityTransferFunction
    opacityTransferFunction AddPoint 0 0.0
    opacityTransferFunction AddPoint 50 0.0
    opacityTransferFunction AddPoint 55 0.1
    opacityTransferFunction AddPoint 80 0.1
    opacityTransferFunction AddPoint 100 1.0
    opacityTransferFunction AddPoint 120 1.0




vtkColorTransferFunction colorTransferFunction
colorTransferFunction AddRGBPoint 0 0.0 0.0 0.0
colorTransferFunction AddRGBPoint 50 0.0 0.0 0.0
colorTransferFunction AddRGBPoint 55 0.0 0.0 0.6
colorTransferFunction AddRGBPoint 80 0.0 0.0 0.6
colorTransferFunction AddRGBPoint 100 1.0 1.0 1.0 
colorTransferFunction AddRGBPoint 120 1.0 1.0 1.0


# Create properties, mappers, volume actors, and ray cast function
vtkVolumeProperty volumeProperty
    volumeProperty SetColor colorTransferFunction
    volumeProperty SetScalarOpacity opacityTransferFunction
    volumeProperty ShadeOn
    volumeProperty SetInterpolationTypeToLinear
    #volumeProperty SetInterpolationTypeToNearest

vtkVolumeRayCastCompositeFunction  compositeFunction

vtkVolumeRayCastMapper volumeMapper
    volumeMapper SetInput [reader1 GetOutput]
    volumeMapper SetVolumeRayCastFunction compositeFunction
    volumeMapper SetSampleDistance 0.5
#volumeMapper SetSampleDistance 1.0
#volumeMapper SetSampleDistance 8.0
#volumeMapper SetSampleDistance 0.2

vtkVolume volume
    volume SetMapper volumeMapper
    volume SetProperty volumeProperty



# Create outline
vtkOutlineFilter outline
outline SetInput [reader1 GetOutput]

vtkPolyDataMapper outlineMapper
outlineMapper SetInput [outline GetOutput]

vtkActor outlineActor
    outlineActor SetMapper outlineMapper
eval [outlineActor GetProperty] SetColor 1 1 1

# Okay now the graphics stuff
vtkRenderer ren1
vtkRenderWindow renWin
    renWin AddRenderer ren1
    renWin SetSize 512 512

vtkRenderWindowInteractor iren
    iren SetRenderWindow renWin
iren SetInteractorStyle style

#ren1 AddActor outlineActor
ren1 AddVolume volume
ren1 SetBackground 0 0 0
renWin Render

 proc TkCheckAbort {} {
     set foo [renWin GetEventPending]
     if {$foo != 0} {renWin SetAbortRender 1}
 }
#renWin SetAbortCheckMethod {TkCheckAbort}
renWin AddObserver AbortCheckEvent {TkCheckAbort}

#iren SetUserMethod {wm deiconify .vtkInteract}
iren AddObserver UserEvent {wm deiconify .vtkInteract}
iren Initialize

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


button .save -text "save frame000.ppm" -command saveFrame
button .quit -text "bye" -command exit
pack .save .quit
