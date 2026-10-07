using UnityEngine;
using UnityEngine.InputSystem;

[RequireComponent(typeof(PlayerStats))]
public class PlayerController : MonoBehaviour
{
    [Header("Dash")]
    [SerializeField] private float dashSpeed = 15f;
    [SerializeField] private float dashDuration = 0.15f;
    [SerializeField] private float dashCooldown = 0.6f;

    [Header("Dash Visuals")]
    [SerializeField] private Color dashColor = new Color(0.5f, 0.8f, 1f, 1f);
    [SerializeField] private Color cooldownColor = new Color(0.6f, 0.6f, 0.6f, 1f);
    [SerializeField] private Color normalColor = Color.white;
    [SerializeField] private float ghostSpawnInterval = 0.03f;
    [SerializeField] private float ghostLifetime = 0.25f;

    [Header("Dash Particles")]
    [SerializeField] private ParticleSystem dashParticles;
    [SerializeField] private float particleDuration = 1.2f;

    [Header("Attack")]
    [SerializeField] private float attackRange = 0.6f;
    [SerializeField] private float attackCooldown = 0.4f;
    [SerializeField] private LayerMask enemyLayer;

    [Header("Animation (opcional por ahora)")]
    [SerializeField] private Animator animator;

    private Rigidbody2D rb;
    private SpriteRenderer sr;
    private PlayerStats stats;
    private Vector2 movement;
    private Vector2 lastMoveDirection = Vector2.down;

    private bool isDashing;
    private float dashTimer;
    private float dashCooldownTimer;
    private float ghostTimer;
    private float attackCooldownTimer;

    private void Awake()
    {
        rb = GetComponent<Rigidbody2D>();
        sr = GetComponent<SpriteRenderer>();
        stats = GetComponent<PlayerStats>();
        rb.interpolation = RigidbodyInterpolation2D.Interpolate;

        if (dashParticles != null)
        {
            var main = dashParticles.main;
            main.startLifetime = particleDuration;
        }
    }

    private void Update()
    {
        if (Keyboard.current == null)
            return;

        movement = Vector2.zero;

        if (Keyboard.current.wKey.isPressed || Keyboard.current.upArrowKey.isPressed)
            movement.y += 1;
        if (Keyboard.current.sKey.isPressed || Keyboard.current.downArrowKey.isPressed)
            movement.y -= 1;
        if (Keyboard.current.aKey.isPressed || Keyboard.current.leftArrowKey.isPressed)
            movement.x -= 1;
        if (Keyboard.current.dKey.isPressed || Keyboard.current.rightArrowKey.isPressed)
            movement.x += 1;

        movement = movement.normalized;

        if (movement.sqrMagnitude > 0)
            lastMoveDirection = movement;

        if (dashCooldownTimer > 0)
            dashCooldownTimer -= Time.deltaTime;

        if (attackCooldownTimer > 0)
            attackCooldownTimer -= Time.deltaTime;

        if (Keyboard.current.spaceKey.wasPressedThisFrame && !isDashing && dashCooldownTimer <= 0)
        {
            isDashing = true;
            dashTimer = dashDuration;
            dashCooldownTimer = dashCooldown;
            ghostTimer = 0f;
            dashParticles?.Play();
        }

        if (isDashing)
        {
            ghostTimer -= Time.deltaTime;
            if (ghostTimer <= 0f)
            {
                SpawnGhost();
                ghostTimer = ghostSpawnInterval;
            }
        }

        if (Mouse.current != null && Mouse.current.leftButton.wasPressedThisFrame)
        {
            TryAttack();
        }

        if (isDashing)
            sr.color = dashColor;
        else if (dashCooldownTimer > 0)
            sr.color = cooldownColor;
        else
            sr.color = normalColor;
    }

    private void FixedUpdate()
    {
        if (isDashing)
        {
            rb.linearVelocity = lastMoveDirection * dashSpeed;
            dashTimer -= Time.fixedDeltaTime;
            if (dashTimer <= 0)
                isDashing = false;
        }
        else
        {
            rb.linearVelocity = movement * stats.MoveSpeed;
        }
    }

    private void TryAttack()
    {
        if (attackCooldownTimer > 0)
            return;

        attackCooldownTimer = attackCooldown;
        animator?.SetTrigger("Attack");

        Vector2 attackPos = (Vector2)transform.position + lastMoveDirection * attackRange * 0.5f;
        Collider2D[] hits = Physics2D.OverlapCircleAll(attackPos, attackRange, enemyLayer);

        foreach (var hit in hits)
        {
            IDamageable damageable = hit.GetComponent<IDamageable>();
            damageable?.TakeDamage(stats.Attack);
        }
    }

    private void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        Vector2 attackPos = (Vector2)transform.position + lastMoveDirection * attackRange * 0.5f;
        Gizmos.DrawWireSphere(attackPos, attackRange);
    }

    private void SpawnGhost()
    {
        GameObject ghost = new GameObject("DashGhost");
        ghost.transform.position = transform.position;
        ghost.transform.rotation = transform.rotation;

        DashGhost dashGhost = ghost.AddComponent<DashGhost>();
        dashGhost.Initialize(sr.sprite, dashColor, transform.localScale, ghostLifetime, sr.material, sr.sortingLayerName, sr.sortingOrder);
    }
}