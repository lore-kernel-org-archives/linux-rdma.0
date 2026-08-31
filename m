Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE50A45629A;
	Mon, 31 Aug 2026 13:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183276; cv=none; b=NU+YHcbrQbvF2xAVSm+KDcssGx8Xkx/ILT5sYqlOwdpOp38oDEfzEaTrKPSLnfdqemnVjL7tgKwFNGI8vugMm+9Oc2OUHwgLMLHIMIUoaopu7FLacutqmj8ojabeJCs+KNpRfEu+ux94FjOLBLKFoDs/OQ/V8FLAtYPUWpjtfMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183276; c=relaxed/simple;
	bh=XTlDyMPjqqpGEJ0fRTilMvCe868kWUmjSD8KnH9twIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TuLBIqvAjUOjKClxeFVIjhL12LhRVDH2WzoVhgpsd3eTUc9oHoVr9TEzCcpHIioEX18DLwospblMNPx1Kud2lnuvcFRI3Il+4+uZ48YptCJPEtuwp9eVMa7dBBFcA9n4VW8Nku8X73H55Z68I1zTwXf+vlBxpawW0Owh0dtdi50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TmX/6qrJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TmX/6qrJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E7B1F00A3E;
	Mon, 31 Aug 2026 13:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183274;
	bh=A7UcETNau9qk8awitJqCLxjvw7lf1xGvDC5YSGu0tas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TmX/6qrJINgTk7nytiuaxkO2Lt0RwH+HWBISgrmUPqkJDDs+0wLeWMbSYpnesghsF
	 1C4077MyJzTrnH5i67HJNuqjNbwr2xPShLB+zRMXTsqYE/bSGrle+OKXm/rcmKMDel
	 40pcuIeeQtwLgF1JBT8TKEyxeZNIpPbcd/iFNjpKL9qN4k2InZ3OHt2VlNml6E+F17
	 o586pQZaYgIx7Lo+DRxzFeGCpAvOSgLpoqdOjS+Ku0eWIkz5q+h+vaHn1OI52njYE+
	 fAwepYOH8CvNXP3D2zgvrlOUdEGUOjO40t8ZJKjrVbBDeWeXveuPAIhlPIHgGWdknm
	 gNUJHg7fyfglA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] eth: mlx5: fix macsec dependency
Date: Mon, 31 Aug 2026 09:21:17 -0400
Message-ID: <20260831133314.4125787-49-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 87ab8276ed24d688febfef4d0c1794896e778192 ]

Configurations with mlx5 built-in but macsec=m fail to link:

x86_64-linux-ld: drivers/infiniband/hw/mlx5/macsec.o: in function `mlx5r_add_gid_macsec_operations':
macsec.c:(.text+0x77d): undefined reference to `macsec_netdev_is_offloaded'
x86_64-linux-ld: drivers/infiniband/hw/mlx5/macsec.o: in function `mlx5r_del_gid_macsec_operations':
macsec.c:(.text+0xe81): undefined reference to `macsec_netdev_is_offloaded'

Fix the dependency so this configuration cannot happen.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20260622124229.2444502-1-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `eth: mlx5: fix macsec dependency`

**Local tree:** Linux **6.18.44** (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[eth: mlx5]` `[fix]` — Correct a Kconfig dependency for
mlx5 MACsec offload so invalid build configurations cannot be selected.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Arnd Bergmann `<arnd@arndb.de>` (author)
- **Reviewed-by:** Sabrina Dubroca `<sd@queasysnail.net>`
- **Link:**
  https://patch.msgid.link/20260622124229.2444502-1-arnd@kernel.org
- **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>` (net maintainer
  merge)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, or `Tested-
  by:` tags
- Notable: Reviewed by a netdev reviewer; merged by net maintainer. No
  syzbot report.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** Kernel configurations with `MLX5_CORE=y` (built-in) and
  `MACSEC=m` (module) can enable `MLX5_MACSEC=y`, but linking fails with
  undefined references to `macsec_netdev_is_offloaded` from
  `drivers/infiniband/hw/mlx5/macsec.c`.
- **Symptom:** Link-time failure (`undefined reference to
  'macsec_netdev_is_offloaded'`) during kernel build — not a runtime
  crash.
- **Root cause:** `MLX5_MACSEC` depends only on `MACSEC` (any tristate
  value), which does not prevent built-in mlx5 from referencing symbols
  exported only by a modular MACsec driver.
- **Author note (from lore):** Bug likely old; first noticed on
  `next-20260615`; rare in randconfig due to other dependency
  constraints.

### Step 1.4: Hidden Bug Fix?
**Record:** No — this is an explicit build-fix, not disguised cleanup.
Same class of fix Arnd has done before for mlx5 (TLS, psample).

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/net/ethernet/mellanox/mlx5/core/Kconfig` — 1 line
  changed (+1/-1)
- **Functions modified:** None (Kconfig only)
- **Scope:** Single-file, surgical Kconfig fix

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `MLX5_MACSEC` selectable whenever `MACSEC` is enabled at
  any tristate value (`y` or `m`), even when `MLX5_CORE=y` and
  `MACSEC=m`.
- **After:** `MLX5_MACSEC` only selectable when `MACSEC=y` (built-in) OR
  `MACSEC=MLX5_CORE` (MACsec built as module only when mlx5 core is also
  a module).
- **Affected path:** Kconfig resolution at build configuration time;
  prevents a configuration that cannot link.

### Step 2.3: Bug Mechanism
**Record:** **Build/configuration bug (h).** Built-in mlx5
(`MLX5_CORE=y`) links `macsec.o` into `mlx5_ib` when
`CONFIG_MLX5_MACSEC=y`, calling `macsec_netdev_is_offloaded()` from
`drivers/net/macsec.c`. With `MACSEC=m`, that symbol lives in a loadable
module and is unavailable at link time for built-in code.

### Step 2.4: Fix Quality
**Record:**
- **Obviously correct:** Yes — mirrors the established mlx5 pattern used
  for TLS (`TLS=y || MLX5_CORE=m` at line 162) and psample (`PSAMPLE=y
  || PSAMPLE=n || MLX5_CORE=m` at line 115).
- **Minimal:** One-line change, no unrelated edits.
- **Regression risk:** Very low — only removes an invalid Kconfig
  combination; does not change runtime behavior for configurations that
  already built successfully.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `depends on MACSEC` introduced by **8ff0ac5be14469** (Lior Nahmanson,
  2022-09-05) — `net/mlx5: Add MACsec offload Tx command support`
- `config MLX5_MACSEC` symbol added by **7390762a07374** (Patrisious
  Haddad, 2022-11-29)
- RoCE MACsec code calling `macsec_netdev_is_offloaded()` added in
  **758ce14aee825** (2022-05-03) and expanded in **58dbd6428a681**
  (2023-04-13)
- `macsec_netdev_is_offloaded()` itself added in **f132fdd9dc81e**
  (2023-08-20)
- Bug has been latent since RoCE MACsec started referencing the MACsec
  core symbol with insufficient Kconfig constraints

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related File History
**Record:**
- **c3cd281e2bc8d** (2018): `net/mlx5e: fix TLS dependency` — identical
  class of fix by same author
- **7a7dd5114f538** (2021): `mlx5: fix psample_sample_packet link error`
  — same author, same Kconfig file
- **96c34151d1577** (2020): mlx5 Kconfig weak-dependency conversion
  after kconfig `imply` semantics change
- Standalone one-patch fix, not part of a series

### Step 3.4: Author Context
**Record:** Arnd Bergmann is a long-standing contributor who routinely
fixes Kconfig/link-dependency issues across the kernel. Multiple prior
mlx5 Kconfig fixes from him are already in this tree.

### Step 3.5: Dependencies
**Record:** No prerequisite commits. Uses `MACSEC=MLX5_CORE` Kconfig
symbol-equality syntax, which is already present elsewhere in this
6.18.44 tree (e.g., `BACKLIGHT_CLASS_DEVICE=FB_RIVA`,
`HID=SND_SOC_SDCA`). Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- **URL:** https://lists.openwall.net/linux-kernel/2026/06/22/987
- **Series revisions:** v1 only (single patch)
- **Reviewer feedback:** No NAKs found; `Reviewed-by: Sabrina Dubroca`
- **Stable nomination:** None in thread
- **Author context:** Notes bug is probably old, first seen on
  next-20260615

### Step 4.2: Reviewers
**Record:** To: mlx5 maintainers (Saeed Mahameed, Leon Romanovsky,
etc.), netdev maintainers (Andrew Lunn, David Miller, Jakub Kicinski,
Paolo Abeni, Eric Dumazet). Cc: netdev@, linux-rdma@, linux-kernel@.
Reviewed-by from Sabrina Dubroca (netdev).

### Step 4.3: Bug Report
**Record:** No external bug report or syzbot link. Failure documented
via reproducible linker error in commit message and lore submission.
Syzbot CI skipped the patch as having no functional/runtime impact
(Kconfig-only).

### Step 4.4: Related Patches
**Record:** No multi-patch series. Direct precedent: TLS and psample
mlx5 Kconfig fixes already in tree.

### Step 4.5: Stable List History
**Record:** No stable@ discussion found. Not searched exhaustively on
lore stable@, but absence is not a negative signal per review
guidelines.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** No C functions modified. Affected symbols at build time:
- `mlx5r_add_gid_macsec_operations()` /
  `mlx5r_del_gid_macsec_operations()` in
  `drivers/infiniband/hw/mlx5/macsec.c` (call
  `macsec_netdev_is_offloaded()`)
- `macsec_netdev_is_offloaded()` in `drivers/net/macsec.c`
  (EXPORT_SYMBOL_GPL)

### Step 5.2: Callers
**Record:** `mlx5r_add/del_gid_macsec_operations()` called from
`drivers/infiniband/hw/mlx5/main.c` during RoCE GID add/delete. Only
compiled when `CONFIG_MLX5_MACSEC=y`. `mlx5_ib-$(CONFIG_MLX5_MACSEC) +=
macsec.o` in `drivers/infiniband/hw/mlx5/Makefile`.

### Step 5.3: Callees
**Record:** `macsec_netdev_is_offloaded()` checks whether a netdevice
has MACsec offload enabled — exported GPL symbol from MACsec core
driver.

### Step 5.4: Reachability
**Record:** Bug is reachable at **build time** when a user/distro
selects `MLX5_CORE=y`, `MACSEC=m`, `MLX5_MACSEC=y`. Not a runtime
userspace trigger, but blocks kernel compilation entirely for that
config.

### Step 5.5: Similar Patterns
**Record:** Same Kconfig dependency pattern already used in this file:
- `MLX5_EN_TLS`: `depends on TLS=y || MLX5_CORE=m` (line 162)
- `MLX5_TC_SAMPLE`: `depends on PSAMPLE=y || PSAMPLE=n || MLX5_CORE=m`
  (line 115)

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Does Buggy Code Exist?
**Record:** **YES.** Current tree at
`drivers/net/ethernet/mellanox/mlx5/core/Kconfig:146` still has `depends
on MACSEC`. RoCE MACsec code and `macsec_netdev_is_offloaded()`
references are present. Fix commit is **not yet applied** to this
checkout.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Single-line change.
`MACSEC=MLX5_CORE` syntax is supported in 6.18.44 Kconfig (verified via
grep of other `=SYMBOL` patterns in tree). No conflicting recent churn
on this Kconfig block.

### Step 6.3: Related Fixes Already Present?
**Record:** TLS and psample mlx5 Kconfig link fixes are present. No
equivalent MACsec fix found (`git log --grep="macsec dependency"`
returns nothing in this tree).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** **drivers/net/ethernet/mellanox/mlx5** +
**drivers/infiniband/hw/mlx5** (RDMA/RoCE MACsec). Criticality:
**IMPORTANT** — affects Mellanox ConnectX users building custom or
distro kernels with MACsec offload; not universal core-path but affects
a widely deployed NIC family.

### Step 7.2: Activity
**Record:** mlx5 Kconfig actively maintained; recent commits include PSP
offload, VXLAN co-dependency removal, HWS support. MACsec Kconfig
dependency has been unchanged since 2022.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Kernel builders (distro maintainers, embedded vendors,
advanced users) configuring `MLX5_CORE=y` + `MACSEC=m` +
`MLX5_MACSEC=y`. Hardware-specific (Mellanox/NVIDIA ConnectX with RoCE
MACsec offload).

### Step 8.2: Trigger Conditions
**Record:** Selecting the invalid Kconfig combination during `make
menuconfig` / defconfig customization. Uncommon but explicitly allowed
by current Kconfig. Not user-triggerable at runtime.

### Step 8.3: Failure Mode Severity
**Record:** **Build failure** — linker error, kernel cannot be built.
Per `Documentation/process/stable-kernel-rules.rst` line 19, build
errors are explicitly listed as valid stable material (excluding
CONFIG_BROKEN). Severity for stable purposes: **qualifying build
error**.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Unblocks valid-intent builders; prevents wasted build
  time hitting link failure; aligns Kconfig with link requirements
- **Risk:** Minimal — one-line Kconfig constraint, proven pattern
- **Ratio:** High benefit, very low risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Fixes a real, reproducible linker failure
- Explicitly listed stable category: build error
- One-line, obviously correct fix
- Same author fixed identical mlx5 Kconfig class before (TLS, psample) —
  those are in this tree
- Reviewed-by from netdev reviewer; merged by net maintainer
- Buggy code confirmed present in 6.18.44
- Clean backport expected

**AGAINST backport:**
- Rare configuration (author notes randconfig rarely hits it)
- No runtime/user-visible crash — build-time only
- No explicit stable nomination or user bug reports

**Unresolved:** Whether any distro actually ships this broken config
combination in practice (unverified; not needed for decision — build
errors are stable-worthy regardless).

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — proven Kconfig pattern,
   Reviewed-by present
2. Fixes real bug affecting users? **PASS** — reproducible link failure
   blocks kernel build
3. Important issue? **PASS** — build error per stable-kernel-rules.rst
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features/APIs? **PASS** — Kconfig constraint only
6. Can apply to local tree? **PASS** — buggy code present, syntax
   supported, clean apply

### Step 9.3: Exception Category
**Record:** **Build fix** — Kconfig dependency correction preventing
link failure.

### Step 9.4: Decision Rationale

For **Linux 6.18.44**, this commit should be backported. The tree still
has the insufficient `depends on MACSEC` constraint while RoCE MACsec
code unconditionally references `macsec_netdev_is_offloaded()` when
`CONFIG_MLX5_MACSEC=y`. The fix is a one-line Kconfig change using an
established mlx5 pattern and syntax already supported in 6.18.y. It
meets all stable kernel criteria, including the explicit allowance for
build errors in `stable-kernel-rules.rst`.

---

## Verification

- **[Phase 1]** `git describe HEAD` → v6.18.44; parsed commit message
  tags from user query and lore
- **[Phase 1]** WebFetch lore: https://lists.openwall.net/linux-
  kernel/2026/06/22/987 — confirmed patch content and author notes
- **[Phase 2]** Read `Kconfig` lines 143–165 — confirmed current
  `depends on MACSEC` and TLS precedent at line 162
- **[Phase 2]** Grep `macsec_netdev_is_offloaded` — found in
  `drivers/infiniband/hw/mlx5/macsec.c:246,332` and
  `drivers/net/macsec.c:4355`
- **[Phase 3]** `git blame` on Kconfig:143-150 — `depends on MACSEC`
  from 8ff0ac5be14469 (2022-09-05)
- **[Phase 3]** `git show 8ff0ac5be14469`, `758ce14aee825`,
  `58dbd6428a681` — MACsec Kconfig and RoCE MACsec introduction
- **[Phase 3]** `git show c3cd281e2bc8d`, `7a7dd5114f538` — prior Arnd
  mlx5 Kconfig link fixes
- **[Phase 3]** `git log --oneline -20 --
  drivers/net/ethernet/mellanox/mlx5/core/Kconfig` — recent file history
- **[Phase 3]** `git show f132fdd9dc81e` — `macsec_netdev_is_offloaded`
  added 2023-08-20
- **[Phase 4]** b4 dig requires commit hash; commit not in local tree —
  used WebFetch lore instead
- **[Phase 4]** WebSearch — found lore URL, GitHub commit 87ab827,
  syzbot CI skip (no runtime test needed)
- **[Phase 5]** Read `drivers/infiniband/hw/mlx5/Makefile:33` —
  `mlx5_ib-$(CONFIG_MLX5_MACSEC) += macsec.o`
- **[Phase 5]** Grep `=MLX5_CORE` and `=SYMBOL` patterns —
  `MACSEC=MLX5_CORE` syntax supported in 6.18.44 tree
- **[Phase 6]** Grep confirmed fix NOT present (`depends on MACSEC`
  without `MACSEC=y || MACSEC=MLX5_CORE`)
- **[Phase 6]** `git log --grep="macsec dependency"` — no fix already in
  tree
- **[Phase 7]** Read `Documentation/process/stable-kernel-rules.rst:19`
  — build errors explicitly allowed
- **[Phase 8]** Confirmed failure mode is link-time build failure, not
  runtime crash

**YES**

 drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 3c3e84100d5aa..925ee25d05b47 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -143,7 +143,7 @@ config MLX5_CORE_IPOIB
 config MLX5_MACSEC
 	bool "Connect-X support for MACSec offload"
 	depends on MLX5_CORE_EN
-	depends on MACSEC
+	depends on MACSEC=y || MACSEC=MLX5_CORE
 	default n
 	help
 	  Build support for MACsec cryptography-offload acceleration in the NIC.
-- 
2.53.0

