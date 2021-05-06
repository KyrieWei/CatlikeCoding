using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GPUGraph : MonoBehaviour
{

    [SerializeField, Range(10, 200)]
    int resolution = 10;

    [SerializeField]
    FunctionLibrary.FunctionName function = default;

    public enum TransitionMode { Cycle, Random }

    [SerializeField]
    TransitionMode transitionMode = TransitionMode.Cycle;

    [SerializeField, Min(0f)]
    float functionDuration = 1f, transitionDuration = 1f;

    [SerializeField]
    ComputeShader computeShader = default;

    [SerializeField]
    Material material = default;

    [SerializeField]
    Mesh mesh = default;


    float duration;

    bool transitioning;

    ComputeBuffer positionBuffer;

    FunctionLibrary.FunctionName transitionFunction;

    static readonly int positionID = Shader.PropertyToID("_Positions");
    static readonly int resolutionID = Shader.PropertyToID("_Resolution");
    static readonly int stepID = Shader.PropertyToID("_Step");
    static readonly int timeID = Shader.PropertyToID("_Time");

    void onEnable()
    {
        positionBuffer = new ComputeBuffer(resolution * resolution, 3 * 4);
    }

    private void OnDisable()
    {
        positionBuffer.Release();
        positionBuffer = null;
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    void UpdateFunctionOnGPU()
    {
        float step = 2f / resolution;
        computeShader.SetInt(resolutionID, resolution);
        computeShader.SetFloat(stepID, step);
        computeShader.SetFloat(timeID, Time.time);

        computeShader.SetBuffer(0, positionID, positionBuffer);

        int groups = Mathf.CeilToInt(resolution / 8f);
        computeShader.Dispatch(0, groups, groups, 1);

        var bounds = new Bounds(Vector3.zero, Vector3.one * (2f + 2f / resolution));
        Graphics.DrawMeshInstancedProcedural(mesh, 0, material, bounds, positionBuffer.count);
    }

    // Update is called once per frame
    void Update()
    {
        duration += Time.deltaTime;
        if(transitioning)
        {
            if(duration >= transitionDuration)
            {
                duration -= transitionDuration;
                transitioning = false;
            }
        }
        else if(duration >= functionDuration)
        {
            transitioning = true;
            transitionFunction = function;
            duration -= functionDuration;
            PickNextFunction();
            
        }

        UpdateFunctionOnGPU();

    }

    void PickNextFunction()
    {
        function = transitionMode == TransitionMode.Cycle ?
            FunctionLibrary.GetNextFunctionName(function) :
            FunctionLibrary.GetRandomFunctionNameOtherThan(function);
    }
}
