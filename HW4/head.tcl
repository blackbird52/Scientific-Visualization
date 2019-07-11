# Amjidanutpan Ramanujam
# CS 6630 
# Project 3 - Human Head  (Prob 1)
# 

package require vtk

############################## Read the Head Data######################### 

vtkStructuredPointsReader reader1
	reader1 SetFileName head.120.vtk


############################## Look up Table Bone ##############################

vtkLookupTable lut_bone
	lut_bone SetNumberOfColors 256
	lut_bone SetTableRange 0 255

lut_bone SetHueRange 0.0 1.0
lut_bone SetSaturationRange 0.0  0.0
lut_bone SetValueRange 0.0 1.0
lut_bone SetAlphaRange 1.0 1.0
lut_bone Build


############################## Look up Table Skin ##############################

vtkLookupTable lut_skin
	lut_skin SetNumberOfColors 256
	lut_skin SetTableRange 0 255

lut_skin SetHueRange 0.0 0.0
lut_skin SetSaturationRange 0.0  1.0
lut_skin SetValueRange 0.0 1.0
lut_skin SetAlphaRange 0.6 0.6
lut_skin Build

############################### ImageMapToColors Module Bone #################### 
 vtkImageMapToColors iMtC_bone
 	iMtC_bone SetInputConnection [reader1 GetOutputPort]
	iMtC_bone SetLookupTable lut_bone


############################## ImageMapToColors Module Skin #################### 

 vtkImageMapToColors iMtC_skin
 	iMtC_skin SetLookupTable lut_skin
 	iMtC_skin SetInputConnection [reader1 GetOutputPort]


########################### Contour Filter for Head Bone #######################
  
vtkContourFilter contour_bone
	contour_bone SetInputConnection [reader1 GetOutputPort]
	contour_bone SetNumberOfContours 1
 	contour_bone SetValue 0 75.0


########################### Contour Filter for Head Skin #######################
  
vtkContourFilter contour_skin
	contour_skin SetInputConnection [reader1 GetOutputPort]
	contour_skin SetNumberOfContours 1
        contour_skin SetValue 0 25.0 
 
############################## Probe Filter for Bone ######################### 

vtkProbeFilter probe_bone
probe_bone SetInputConnection [contour_bone GetOutputPort]
	probe_bone SetSourceConnection [iMtC_bone GetOutputPort]

############################## Probe Filter for Skin ######################### 

vtkProbeFilter probe_skin
	probe_skin SetInputConnection [contour_skin GetOutputPort]
	probe_skin SetSourceConnection [iMtC_skin GetOutputPort]
		
############################## PolyData Mapper Bone ############################## 

vtkPolyDataMapper mapper_bone
	mapper_bone SetInputConnection [probe_bone GetOutputPort]
        mapper_bone SetLookupTable lut_bone
        mapper_bone SetColorModeToMapScalars



############################## PolyData Mapper Skin ############################## 

vtkPolyDataMapper mapper_skin
	mapper_skin SetInputConnection [probe_skin GetOutputPort]
        mapper_skin SetLookupTable lut_skin
        mapper_skin SetColorModeToMapScalars




############################## ColorModeToMap Scalar######################## 

vtkActor actor_bone
	actor_bone SetMapper mapper_bone

vtkActor actor_skin
	actor_skin SetMapper mapper_skin

########################### Actor and Graphics Stuff ###########################


############################Standard Rendering Stuff ##########################

vtkInteractorStyleTrackballCamera style
vtkRenderer ren
vtkRenderWindow renWin
renWin AddRenderer ren
renWin SetSize 800 800

vtkRenderWindowInteractor iren
iren SetRenderWindow renWin
iren SetInteractorStyle style

ren SetBackground 1 1 1
ren AddActor actor_bone
ren AddActor actor_skin
ren ResetCamera
renWin Render

wm withdraw .