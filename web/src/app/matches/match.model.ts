/** Tipos alineados con shared/contracts/openapi.yaml (MatchResponse, PlayerStats). */
export type MatchOutcome = 'COMPLETED' | 'FAILED' | 'ABANDONED';

export interface MatchResponse {
  id: number;
  sessionId: string;
  playerId: string;
  score: number;
  durationSeconds: number;
  levelReached: number;
  progressPercent: number;
  outcome: MatchOutcome;
  materialsCollected: number;
  itemsCrafted: number;
  finishedAt: string;
  gameVersion: string;
  receivedAt: string;
}

export interface PlayerStats {
  playerId: string;
  matchesPlayed: number;
  bestScore: number;
  totalPlaySeconds: number;
  highestLevel: number;
  completionRate: number;
}
