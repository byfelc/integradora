using System;
using UnityEngine;

public class PlayerStats : MonoBehaviour, IDamageable
{
    [Header("Base Stats")]
    [SerializeField] private int baseMaxHealth = 100;
    [SerializeField] private int baseAttack = 10;
    [SerializeField] private int baseDefense = 0;
    [SerializeField] private float baseMoveSpeed = 1.4f;

    public int MaxHealth { get; private set; }
    public int CurrentHealth { get; private set; }
    public int Attack { get; private set; }
    public int Defense { get; private set; }
    public float MoveSpeed { get; private set; }

    public event Action OnStatsChanged;
    public event Action<int, int> OnHealthChanged; // (current, max)

    private EquipmentItem weapon;
    private EquipmentItem armor;
    private EquipmentItem accessory;

    private void Awake()
    {
        RecalculateStats();
        CurrentHealth = MaxHealth;
    }

    public void EquipItem(EquipmentItem item)
    {
        if (item == null) return;

        switch (item.slot)
        {
            case EquipmentSlot.Weapon: weapon = item; break;
            case EquipmentSlot.Armor: armor = item; break;
            case EquipmentSlot.Accessory: accessory = item; break;
        }
        RecalculateStats();
    }

    public void UnequipSlot(EquipmentSlot slot)
    {
        switch (slot)
        {
            case EquipmentSlot.Weapon: weapon = null; break;
            case EquipmentSlot.Armor: armor = null; break;
            case EquipmentSlot.Accessory: accessory = null; break;
        }
        RecalculateStats();
    }

    private void RecalculateStats()
    {
        int bonusHealth = 0, bonusAttack = 0, bonusDefense = 0;
        float bonusSpeed = 0f;

        foreach (var item in new[] { weapon, armor, accessory })
        {
            if (item == null) continue;
            bonusHealth += item.bonusMaxHealth;
            bonusAttack += item.bonusAttack;
            bonusDefense += item.bonusDefense;
            bonusSpeed += item.bonusMoveSpeed;
        }

        int previousMax = MaxHealth;
        MaxHealth = baseMaxHealth + bonusHealth;
        Attack = baseAttack + bonusAttack;
        Defense = baseDefense + bonusDefense;
        MoveSpeed = baseMoveSpeed + bonusSpeed;

        if (MaxHealth != previousMax)
            CurrentHealth = Mathf.Min(CurrentHealth == 0 ? MaxHealth : CurrentHealth + (MaxHealth - previousMax), MaxHealth);

        OnStatsChanged?.Invoke();
        OnHealthChanged?.Invoke(CurrentHealth, MaxHealth);
    }

    public void TakeDamage(int rawAmount)
    {
        int finalDamage = Mathf.Max(1, rawAmount - Defense);
        CurrentHealth = Mathf.Max(0, CurrentHealth - finalDamage);
        OnHealthChanged?.Invoke(CurrentHealth, MaxHealth);

        if (CurrentHealth <= 0)
            Die();
    }

    public void Heal(int amount)
    {
        CurrentHealth = Mathf.Min(MaxHealth, CurrentHealth + amount);
        OnHealthChanged?.Invoke(CurrentHealth, MaxHealth);
    }

    private void Die()
    {
        Debug.Log("El jugador murió.");
    }
}