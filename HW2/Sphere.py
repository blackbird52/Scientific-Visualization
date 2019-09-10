import vtk
 
# create sphere geometry
sphere = vtk.vtkSphereSource()
sphere.SetRadius(1.0)
sphere.SetThetaResolution(18)
sphere.SetPhiResolution(18)
 
# map to graphics library
mapper = vtk.vtkPolyDataMapper()
if vtk.VTK_MAJOR_VERSION <= 5:
    mapper.SetInput(sphere.GetOutput())
else:
    mapper.SetInputConnection(sphere.GetOutputPort())
 
# actor coordinates geometry, properties, transformation
aSphere = vtk.vtkActor()
aSphere.SetMapper(mapper)
aSphere.GetProperty().SetColor(0, 0, 1)
 
# create a rendering window and renderer
ren = vtk.vtkRenderer()
renWin = vtk.vtkRenderWindow()
renWin.AddRenderer(ren)
 
# create a renderwindowinteractor
iren = vtk.vtkRenderWindowInteractor()
iren.SetRenderWindow(renWin)
 
# assign actor to the renderer
ren.AddActor(aSphere)
 
# enable user interface interactor
iren.Initialize()
renWin.Render()
iren.Start()