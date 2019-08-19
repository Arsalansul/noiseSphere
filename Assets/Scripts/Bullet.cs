using UnityEngine;
using UnityEditor;

namespace Assets.Scripts
{
    public class Bullet
    {
        public GameObject bulletGO;

        public Bullet()
        {
            bulletGO = Resources.Load<GameObject>("Prefabs/Bullet");
        }
    }
}