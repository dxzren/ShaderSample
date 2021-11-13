using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Events;

namespace ShaderSample.TransForm_TRS
{
    public class ShaderController : MonoBehaviour
    {
        [HideInInspector]
        public  UnityEvent              UPdateHandler;

        public Text                     AixH;
        public Text                     OffsetRotateValue;
        public Text                     AxisXorY;
        public Text                     Info_04;

        public Text                     Info_05;
        public Text                     Info_06;
        public Text                     Info_07;
        public Transform                TRS_Target3D_TF;

        [SerializeField] Transform      TRS_Target2D_TF;
        [SerializeField] LayerMask      CastLayer;

        private Vector3                 m_MouseAndTargetOffset;

        private bool                    m_Enable_3D_Translate           = true;                                             /// 
        private bool                    m_Enable_3D_Rotate              = true;                                             /// 
        private bool                    m_Enable_3D_Scale               = true;                                             /// 

        private bool                    m_Enable_2D_Translate           = true;                                             /// 
        private bool                    m_Enable_2D_Rotate              = true;                                             /// 
        private bool                    m_Enable_2D_Scale               = true;                                             /// 

        private bool                    m_Horiztonal                    = true;                                             /// 

        private bool                    m_Hited                         = false;                                            /// 

        private RaycastHit              m_HitData;
        void Start()
        {

        }
        void Update()
        {
            UPdateHandler?.Invoke();
            TransformTRS_2D_Update();
            TransformTRS_3D_Update();
            MouseScreenPointShow_Update();
        }
        private void TransformTRS_2D_Update()
        {
            if (m_Enable_2D_Translate)                                                                                      
            {
                if (Input.GetMouseButton(0))
                {
                    TRS_Target2D_TF.GetComponent<Renderer>().material.SetFloat("_OnTranslate", 1);
                    Vector4 aTranslate = TRS_Target2D_TF.GetComponent<Renderer>().material.GetVector("_Translate");

                    if (Input.GetAxis("Mouse X") > 0)
                    {
                        aTranslate = new Vector4(aTranslate.x - 1 * Time.deltaTime, aTranslate.y, aTranslate.z, aTranslate.w);
                        TRS_Target2D_TF.GetComponent<Renderer>().material.SetVector("_Translate", aTranslate);
                    }
                    else if (Input.GetAxis("Mouse X") < 0)
                    {
                        aTranslate = new Vector4(aTranslate.x + 1 * Time.deltaTime, aTranslate.y, aTranslate.z, aTranslate.w);
                        TRS_Target2D_TF.GetComponent<Renderer>().material.SetVector("_Translate", aTranslate);
                    }
                    if (Input.GetAxis("Mouse Y") > 0)
                    {
                        aTranslate = new Vector4(aTranslate.x, aTranslate.y - 1 * Time.deltaTime, aTranslate.z, aTranslate.w);
                        TRS_Target2D_TF.GetComponent<Renderer>().material.SetVector("_Translate", aTranslate);
                    }
                    else if (Input.GetAxis("Mouse Y") < 0)
                    {
                        aTranslate = new Vector4(aTranslate.x, aTranslate.y + 1 * Time.deltaTime, aTranslate.z, aTranslate.w);
                        TRS_Target2D_TF.GetComponent<Renderer>().material.SetVector("_Translate", aTranslate);
                    }
                    AixH.text = aTranslate.ToString();
                }
            }
            if (m_Enable_2D_Rotate)                                                                                         // 
            {
                if (Input.GetMouseButton(1))
                {
                    TRS_Target2D_TF.GetComponent<Renderer>().material.SetFloat("_OnRotate", 1);
                    float aScale = TRS_Target2D_TF.GetComponent<Renderer>().material.GetFloat("_Rotate");

                    if (Input.GetAxis("Mouse X") > 0)
                    {
                        TRS_Target2D_TF.GetComponent<Renderer>().material.SetFloat("_Rotate", aScale + 60 * Time.deltaTime);
                    }
                    else if (Input.GetAxis("Mouse X") < 0)
                    {
                        TRS_Target2D_TF.GetComponent<Renderer>().material.SetFloat("_Rotate", aScale - 60 * Time.deltaTime);
                    }
                }
            }
            if (m_Enable_2D_Scale)                                                                                          // 
            {
                TRS_Target2D_TF.GetComponent<Renderer>().material.SetFloat("_OnScale", 1);
                float                   aScale                  = TRS_Target2D_TF.GetComponent<Renderer>().material.GetFloat ("_Scale");

                if      (Input.GetAxis("Mouse ScrollWheel") > 0)
                {
                    TRS_Target2D_TF.GetComponent<Renderer>().material.SetFloat("_Scale", aScale + 40* Time.deltaTime);
                }
                else if (Input.GetAxis("Mouse ScrollWheel") < 0)
                {
                    TRS_Target2D_TF.GetComponent<Renderer>().material.SetFloat("_Scale", aScale - 40 * Time.deltaTime);
                }
            }
        }
        private void TransformTRS_3D_Update()
        {
            if (m_Enable_3D_Translate)
            {
                if (Input.GetMouseButtonDown(0))
                {
                    m_MouseAndTargetOffset          = Camera.main.WorldToScreenPoint(TRS_Target3D_TF.position) - Input.mousePosition;
                }
                if (Input.GetMouseButton(0))
                {
                    TRS_Target3D_TF.position        = Camera.main.ScreenToWorldPoint(Input.mousePosition + m_MouseAndTargetOffset);
                }
            }
            if (m_Enable_3D_Rotate)  
            {

                if (Input.GetMouseButtonDown(1))
                {
                    Vector3             aOffset     = Camera.main.WorldToScreenPoint(TRS_Target3D_TF.position) - Input.mousePosition;
                    OffsetRotateValue.text          = aOffset.ToString("0.00");
                    if (Mathf.Abs(aOffset.x) > Mathf.Abs(aOffset.y))    {  m_Horiztonal = true; AxisXorY.text = "X";    }
                    else                                                {  m_Horiztonal = false; AxisXorY.text = "Y"; }
                }
                if (Input.GetMouseButton(1))
                {
                    if (m_Horiztonal == true)
                    {
                        if (Input.GetAxis("Mouse X") > 0)
                        {
                            TRS_Target3D_TF.Rotate(new Vector3(0, 1, 0));
                        }
                        else if (Input.GetAxis("Mouse X") < 0)
                        {
                            TRS_Target3D_TF.Rotate(new Vector3(0, -1, 0));
                        }
                    }
                    else
                    {
                        if (Input.GetAxis("Mouse Y") > 0)
                        {
                            TRS_Target3D_TF.Rotate(new Vector3(1, 0, 0), Space.World);
                        }
                        else if (Input.GetAxis("Mouse Y") < 0)
                        {
                            TRS_Target3D_TF.Rotate(new Vector3(-1, 0, 0),Space.World);
                        }
                        
                    }
                }

            }
            if (m_Enable_3D_Scale)
            {
                if (Input.GetAxis("Mouse ScrollWheel") > 0)
                {
                    TRS_Target3D_TF.localScale += TRS_Target3D_TF.localScale * Time.deltaTime * 10;
                }
                else if (Input.GetAxis("Mouse ScrollWheel") < 0)
                {
                    TRS_Target3D_TF.localScale -= TRS_Target3D_TF.localScale * Time.deltaTime * 10;
                }
            }
        }
        private void MouseScreenPointShow_Update()
        {
            if (Input.GetMouseButtonDown(0))
            {
                Ray                     aCameraRay                      = Camera.main.ScreenPointToRay (Input.mousePosition);
                m_Hited                                                 = Physics.Raycast (aCameraRay, out m_HitData, 2000);
                Info_04.text                                            = "MousePos: " + Input.mousePosition;
            }
            if (m_Hited)
            {
                Info_05.text                                            = "World Pos: " + m_HitData.point.ToString("0.00");
                Info_06.text                                            = "Local Pos: " + m_HitData.transform.InverseTransformPoint(m_HitData.point).ToString("0.0");
                Info_07.text                                            = "View Pos: " + Camera.main.WorldToViewportPoint(m_HitData.point).ToString("0.0");
            }
            else
            {
                Info_05.text                                            = "Null";

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

