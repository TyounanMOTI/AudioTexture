using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace AudioTexture
{
    public class AudioTextureGenerator : ScriptableWizard
    {
        [SerializeField] private AudioClip audioClip;
        
        [MenuItem("AudioTexture/Generate")]
        static void Open()
        {
            DisplayWizard<AudioTextureGenerator>("Generate amplitude AudioTexture");
        }

        private void OnWizardCreate()
        {
            if (audioClip.channels > 2)
            {
                Debug.LogError("Currently supports only 1ch or 2ch audio.");
                return;
            }

            var data = new float[audioClip.samples * audioClip.channels];
            audioClip.GetData(data, 0);

            var width = Mathf.CeilToInt(Mathf.Sqrt(audioClip.samples));
            var height = width;
            var texture = new Texture2D(width, height, TextureFormat.RGFloat, false, true);
            var colors = new Color[width * height];

            if (audioClip.channels == 1)
            {
                for (int i = 0; i < audioClip.samples; i++)
                {
                    colors[i] = new Color((data[i] + 1.0f) / 2.0f, (data[i] + 1.0f) / 2.0f, 0);
                }
            }
            else
            {
                for (int i = 0; i < audioClip.samples; i++)
                {
                    colors[i] = new Color((data[i * 2] + 1.0f) / 2.0f, (data[i * 2 + 1] + 1.0f) / 2.0f, 0);
                }
            }

            texture.SetPixels(colors);
            ProjectWindowUtil.CreateAsset(texture, audioClip.name + ".asset");
        }

        private SerializedObject _serializedObject;

        private void OnEnable()
        {
            _serializedObject = new SerializedObject(this);
        }

        protected override bool DrawWizardGUI()
        {
            _serializedObject.Update();
            EditorGUILayout.PropertyField(_serializedObject.FindProperty("audioClip"));
            _serializedObject.ApplyModifiedProperties();
            return true;
        }
    }
}
