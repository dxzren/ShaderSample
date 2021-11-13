using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class ShagerParamShow : MonoBehaviour
{
    [SerializeField] Text               ShaderParam;
    [SerializeField] Transform          TargetShaderTF;

    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        ShowShaderParam();
    }
    private void ShowShaderParam()
    {
        ShaderParam.text            = TargetShaderTF.GetComponent<Renderer>().material.GetFloat("_DissValue").ToString();
    }
}
