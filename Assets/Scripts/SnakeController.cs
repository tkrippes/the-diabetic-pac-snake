using System.Linq;
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

    [SerializeField] private GameObject snakeHead;
    [SerializeField] private GameObject[] snakeBodies;
    [SerializeField] private GameObject snakeTail;
    
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
            if (_currentDirection != Direction.Left)
            {
                _currentDirection = Direction.Right;
            }

            return;
        }
        
        if (horizontalInput < 0)
        {
            if (_currentDirection != Direction.Right)
            {
                _currentDirection = Direction.Left;
            }

            return;
        }
        
        float verticalInput = Input.GetAxis("Vertical");
        if (verticalInput > 0)
        {
            if (_currentDirection != Direction.Down)
            {
                _currentDirection = Direction.Up;
            }

            return;
        }
        
        if (verticalInput < 0)
        {
            if (_currentDirection != Direction.Up)
            {
                _currentDirection = Direction.Down;
            }

            return;
        }
    }

    private void Move()
    {
        _timeElapsed += Time.deltaTime;
        if (_timeElapsed >= timeBetweenMovements)
        {
            _timeElapsed = 0f;
            snakeTail.transform.position = snakeBodies.Last().transform.position;
            for (int i = snakeBodies.Length - 1; i > 0; i--)
            {
                snakeBodies[i].transform.position = snakeBodies[i - 1].transform.position;
            }
            snakeBodies[0].transform.position = snakeHead.transform.position;
            
            switch (_currentDirection)
            {
                case Direction.Up:
                    snakeHead.transform.Translate(0, 1, 0);
                    break;
                case Direction.Down:
                    snakeHead.transform.Translate(0, -1, 0);
                    break;
                case Direction.Left:
                    snakeHead.transform.Translate(-1, 0, 0);
                    break;
                case Direction.Right:
                    snakeHead.transform.Translate(1, 0, 0);
                    break;
            }
        }
    }
}
