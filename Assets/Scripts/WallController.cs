using System;
using UnityEngine;

public class WallController : MonoBehaviour
{
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            Destroy(other);
        }
        else
        {
            Debug.Log("Something other than the player hit the wall");
        }
    }
}
