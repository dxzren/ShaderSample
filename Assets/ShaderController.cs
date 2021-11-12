using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Events;

namespace ShaderSample.TransForm_TRS
{
    public class ShaderController : MonoBehaviour
    {
        public  UnityEvent              UPdateHandler;
        public  Text                    AixH;


        [SerializeField] Transform      TargetTRS_TF;

        void Start()
        {

        }

        void Update()
        {
            UPdateHandler?.Invoke();
            if     (Input.GetMouseButton(0))
            {
                TargetTRS_TF.GetComponent<Renderer>().material.SetFloat("_OnTranslate", 1);
                Vector4               aTranslate      = TargetTRS_TF.GetComponent<Renderer>().material.GetVector("_Translate");

                if (Input.GetAxis("Mouse X") > 0 )
                {
                    aTranslate                          = new Vector4(aTranslate.x - 1 * Time.deltaTime, aTranslate.y, aTranslate.z, aTranslate.w);
                    TargetTRS_TF.GetComponent<Renderer>().material.SetVector("_Translate", aTranslate);
                }
                else if ( Input.GetAxis("Mouse X") < 0)
                {
                    aTranslate                          = new Vector4(aTranslate.x + 1 * Time.deltaTime, aTranslate.y, aTranslate.z, aTranslate.w);
                    TargetTRS_TF.GetComponent<Renderer>().material.SetVector("_Translate", aTranslate);
                }
                if ( Input.GetAxis("Mouse Y") > 0)
                {
                    aTranslate = new Vector4(aTranslate.x , aTranslate.y - 1 * Time.deltaTime, aTranslate.z, aTranslate.w);
                    TargetTRS_TF.GetComponent<Renderer>().material.SetVector("_Translate", aTranslate);
                }
                else if ( Input.GetAxis("Mouse Y") < 0)
                {
                    aTranslate = new Vector4(aTranslate.x , aTranslate.y + 1 * Time.deltaTime, aTranslate.z, aTranslate.w);
                    TargetTRS_TF.GetComponent<Renderer>().material.SetVector("_Translate", aTranslate);
                }
                AixH.text                           = aTranslate.ToString();
            }
            else if(Input.GetMouseButton(1))      
            {
                TargetTRS_TF.GetComponent<Renderer>().material.SetFloat("_OnRotate", 1);
                float                   aScale                  = TargetTRS_TF.GetComponent<Renderer>().material.GetFloat("_Rotate");

                if (Input.GetAxis("Mouse X") > 0)
                {
                    TargetTRS_TF.GetComponent<Renderer>().material.SetFloat("_Rotate", aScale + 60 * Time.deltaTime);
                }
                else if ( Input.GetAxis("Mouse X") < 0)
                {
                    TargetTRS_TF.GetComponent<Renderer>().material.SetFloat("_Rotate", aScale - 60 * Time.deltaTime);
                }
            }
            // else if(Input.GetMouseButton(2))
            {
                TargetTRS_TF.GetComponent<Renderer>().material.SetFloat("_OnScale", 1);
                float                   aScale                  = TargetTRS_TF.GetComponent<Renderer>().material.GetFloat ("_Scale");

                if      (Input.GetAxis("Mouse ScrollWheel") > 0)
                {
                    TargetTRS_TF.GetComponent<Renderer>().material.SetFloat("_Scale", aScale + 40* Time.deltaTime);
                }
                else if (Input.GetAxis("Mouse ScrollWheel") < 0)
                {
                    TargetTRS_TF.GetComponent<Renderer>().material.SetFloat("_Scale", aScale - 40 * Time.deltaTime);
                }
            }
        }

        private void OnTranslate_Update()
        { 
        }
        private void OnRotate_Update()
        {
        }
        private void OnScale_Update()
        {
        }

    }
}

