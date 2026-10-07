using UnityEngine;

public class EnemyMeleeController : MonoBehaviour
{
    [Header("Referencias")]
    [SerializeField] private Transform player;

    [Header("Detección")]
    [SerializeField] private float detectionRange = 5f;

    public bool PlayerDetected { get; private set; }

    private void Update()
    {
        DetectPlayer();
    }

    private void DetectPlayer()
    {
        if (player == null)
        {
            PlayerDetected = false;
            return;
        }

        float distance = Vector2.Distance(
            transform.position,
            player.position
        );

        bool detectedNow = distance <= detectionRange;

        if (detectedNow == PlayerDetected)
            return;

        PlayerDetected = detectedNow;

        Debug.Log(
            PlayerDetected
                ? "Enemy Melee: Player detectado"
                : "Enemy Melee: Player fuera del rango"
        );
    }

    private void OnDrawGizmosSelected()
    {
        Gizmos.DrawWireSphere(transform.position, detectionRange);
    }
}