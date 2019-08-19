using System.Collections;
using UnityEngine;

namespace Assets.Scripts
{
    public class TowerController : MonoBehaviour
    {
        public Transform gunDummy;
        public GameObject bullet;
        public Transform bulletDummy;

        public float bulletSpeed;

        private LineRenderer lineRenderer;

        private Vector3 g = new Vector3(0, -9.8f, 0);

        void Start()
        {
            lineRenderer = GetComponent<LineRenderer>();
            lineRenderer.positionCount = 100;
        }

        void Update()
        {
            RotateTower();

            RotateGun();

            DrawLine();

            if (Input.GetKeyDown(KeyCode.Space))
            {
                Shoot();                
            }
        }

        private void RotateTower()
        {
            if (Input.GetAxis("Horizontal") != 0)
            {
                gameObject.transform.Rotate(0, Input.GetAxis("Horizontal"), 0);
            }
        }

        private void RotateGun()
        {
            if (Input.GetAxis("Vertical") != 0)
            {
                gunDummy.Rotate(Input.GetAxis("Vertical"), 0, 0);
            }
        }

        private void Shoot()
        {
            var bulletDir = (bulletDummy.position - gunDummy.position).normalized;
            var instance = Instantiate(bullet, bulletDummy.transform.position, Quaternion.identity);
            instance.GetComponent<Rigidbody>().velocity = bulletDir * bulletSpeed;
            instance.SetActive(true);
        }

        private void DrawLine()
        {
            var startPosition = bulletDummy.position;
            var speedDir = (bulletDummy.position - gunDummy.position).normalized * bulletSpeed;

            for (var i = 0; i< lineRenderer.positionCount; i++)
            {
                var position = startPosition + speedDir * i * 0.1f + g * i * i / 2 * 0.01f;

                if (position.y < 0)
                {
                    position = i > 0 ? lineRenderer.GetPosition(i-1) : startPosition;
                }

                lineRenderer.SetPosition(i, position);
            }                       
        }
    }
}
