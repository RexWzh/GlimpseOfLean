

import GlimpseOfLean.Library.Basic

namespace Introduction

/- # 本教程简介

如果你的 VSCode 屏幕显示不下，可以按下
`alt-Z`（或`option-Z`）来启用自动换行。

欢迎来到本教程，教程旨在让你在几个小时内对 Lean 有个初步的了解。

首先，让我们看看一个 Lean 证明是什么样子的，尽管不必理解任何语法细节。在这个文件中，你无需输入任何内容。

如果一切正常，你现在在这篇文章的右边会看到一个标题为
"Lean Infoview" 的面板，上面显示着像 "No info found." 这样的信息。
这个面板在证明的过程中会显示有趣的内容。

首先让我们来复习下两个微积分的定义。
-/

/- 一个实数序列 `u` 收敛于 `l` 的条件是当 `∀ ε > 0, ∃ N, ∀ n ≥ N, |u_n - l| ≤ ε`。这个条件将被表示为 `seq_limit u l`。
-/

def seq_limit (u : ℕ → ℝ) (l : ℝ) : Prop :=
∀ ε > 0, ∃ N, ∀ n ≥ N, |u n - l| ≤ ε

/- 在上述定义中，请注意序列 `u` 的第 `n` 项被简单地记作 `u n`。

类似地，在下一个定义中，`f x` 是我们在纸上写作 `f(x)` 的形式。 还要注意，蕴含关系由一个箭头表示（我们稍后会解释原因）。
-/

/- 一个函数 `f : ℝ → ℝ` 在 `x₀` 处连续，如果满足以下条件：
`∀ ε > 0, ∃ δ > 0, ∀ x, |x - x₀| ≤ δ ⇒ |f(x) - f(x₀)| ≤ ε`。
这个条件将被说明为 `continuous_at f x₀`。
-/

def continuous_at (f : ℝ → ℝ) (x₀ : ℝ) : Prop :=
∀ ε > 0, ∃ δ > 0, ∀ x, |x - x₀| ≤ δ → |f x - f x₀| ≤ ε

/- 现在我们要证明：如果函数 `f` 在 `x₀` 处连续，那么它在 `x₀` 处就是序列连续的：对于任何收敛于 `x₀` 的序列 `u`，序列 `f ∘ u` 收敛于 `f x₀`。
-/

example (f : ℝ → ℝ) (u : ℕ → ℝ) (x₀ : ℝ) (hu : seq_limit u x₀) (hf : continuous_at f x₀) :
  seq_limit (f ∘ u) (f x₀) := by {
  -- 这里的 `by` 关键字标志着开始证明的地方
  -- 将光标放在这里，观察右侧的 Lean InfoView 面板。
  -- 在证明的过程中，根据需要将光标从一行移动到另一行，同时监视 InfoView 面板。

  -- 我们的目标是证明，对于任意正的 `ε` ，存在一个自然数 `N` ，使得对于任意自然数 `n` ，如果 `n ≥ N` ，则 `|f(u_n) - f(x₀)|` 至多为 `ε`。
  unfold seq_limit
  -- 取一个正数 `ε`。
  intros ε hε
  -- 根据 `f` 的连续性，在这个正数 `ε` 上，我们得到一个正数 `δ` ，使得对于所有实数 `x` ，当 `|x - x₀| ≤ δ` 时，有 `|f(x) - f(x₀)| ≤ ε` (1)。
  obtain ⟨δ, δ_pos, Hf⟩ : ∃ δ > 0, ∀ x, |x - x₀| ≤ δ → |f x - f x₀| ≤ ε := hf ε hε
  -- 根据 `u` 的收敛性，在这个正数 `δ` 上，我们得到一个自然数 `N` ，使得对于每个自然数 `n` ，如果 `n ≥ N` ，则 `|u_n - x₀| ≤ δ` (2)。
  obtain ⟨N, Hu⟩ : ∃ N, ∀ n ≥ N, |u n - x₀| ≤ δ := hu δ δ_pos
  -- 下面，我们证明 `N` 是合适的。
  use N
  -- 取一个大于等于 `N` 的 `n` 。我们证明 `|f(u_n) - f(x₀)| ≤ ε`。
  intros n hn
  -- 根据 (1) 对 `u_n` 的应用，我们只需证明 `|u_n - x₀| ≤ δ`。
  apply Hf
  -- 这可以通过 (2) 的性质以及我们对 `n` 的假设得到。
  exact Hu n hn
  -- 证明结束！
  }

/- 现在此证明已经结束，您可以使用面板左侧的文件浏览器打开文件 `Exercises > 01Rewriting.lean` 开始练习。
-/
