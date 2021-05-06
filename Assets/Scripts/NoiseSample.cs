using UnityEngine;

public struct NoiseSample
{
    public float value;
    public Vector3 derivative;

    public static NoiseSample operator +(NoiseSample a, NoiseSample b)
    {
        a.value += b.value;
        a.derivative += b.derivative;
        return a;
    }

    
}

