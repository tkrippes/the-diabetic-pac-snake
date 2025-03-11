using UnityEngine;

enum Direction
{
    Up,
    Down,
    Left,
    Right
}

public class SnakeController : MonoBehaviour
{
    [SerializeField]
    private float timeBetweenMovements = 0.25f;
    
    private float _timeElapsed;
    private Direction _currentDirection = Direction.Right;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        ChangeDirection();
        Move();
    }

    private void ChangeDirection()
    {
        float horizontalInput = Input.GetAxis("Horizontal");
        if (horizontalInput > 0)
        {
            _currentDirection = Direction.Right;

            return;
        }
        
        if (horizontalInput < 0)
        {
            _currentDirection = Direction.Left;

            return;
        }
        
        float verticalInput = Input.GetAxis("Vertical");
        if (verticalInput > 0)
        {
            _currentDirection = Direction.Up;

            return;
        }
        
        if (verticalInput < 0)
        {
            _currentDirection = Direction.Down;

            return;
        }
    }

    private void Move()
    {
        _timeElapsed += Time.deltaTime;
        if (_timeElapsed >= timeBetweenMovements)
        {
            _timeElapsed = 0f;
            switch (_currentDirection)
            {
                case Direction.Up:
                    transform.Translate(0, 1, 0);
                    break;
                case Direction.Down:
                    transform.Translate(0, -1, 0);
                    break;
                case Direction.Left:
                    transform.Translate(-1, 0, 0);
                    break;
                case Direction.Right:
                    transform.Translate(1, 0, 0);
                    break;
            }
        }
    }
}
