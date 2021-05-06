using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(SurfaceCreator))]
public class SurfaceEditorInspector : Editor
{
    private SurfaceCreator creator;
    public override void OnInspectorGUI()
    {
        EditorGUI.BeginChangeCheck();
        DrawDefaultInspector();
        if (EditorGUI.EndChangeCheck())
        {
            RefreshCreator();
        }
    }

    private void OnEnable()
    {
        creator = target as SurfaceCreator;
        Undo.undoRedoPerformed += RefreshCreator;
    }

    private void OnDisable()
    {
        Undo.undoRedoPerformed -= RefreshCreator;
    }

    private void RefreshCreator()
    {
        if (Application.isPlaying)
        {
            creator.Refresh();
        }
    }

}
