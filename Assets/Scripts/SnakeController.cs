using UnityEngine;

public class SnakeController : MonoBehaviour
{
    private float _timeElapsed;
    
    [SerializeField]
    private float timeBetweenMovements = 0.25f;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        _timeElapsed += Time.deltaTime;
        if (_timeElapsed >= timeBetweenMovements)
        {
            _timeElapsed = 0f;
            transform.Translate(1, 0, 0);
        }
    }
}
