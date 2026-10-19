Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072A04FD7AA;
	Mon, 19 Oct 2026 13:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418093; cv=none; b=nFEsgA86YWZU5MKkXmod35yhzuIuwEtdajMnxZoE5MRVao6E5IP9ucMZM2o0EwBwsb698/6Odx7Wh5IeEr01d6nUrNCnrR710KGXLSb1eNAHKumcANLbOK/cJXzoT+9hevR+esChbEw2EyIpaVv9D++nVhvJa75d9d/SmqMU1SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418093; c=relaxed/simple;
	bh=kFJRuUhIRQwJnnVkg5uxQKjx3dFdI4UFaDmKepiX8fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TWcM7+XXldw2gvTXAMaZyiYOZ9VE4MCHZrdqhaLpFcKWF2IvBUhJ+C05esUnsmXokQJfAbibg0YO+qG2r+oqHSlHlHEATdbsSgKtVkWIhEHZgpidOp6ZgUvSKkc1x//BjfMk8ISMOv1/k+IqbAe7v4UrdZwtpPwpb0iQ+ZpOGAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J1Oq2tQ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J1Oq2tQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194851F000C4;
	Mon, 19 Oct 2026 13:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418090;
	bh=Sff25LkZGUAjysG7Q9gbgWz1BdZSkgYhxu9c9Ix3zx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J1Oq2tQ2/g0FMEizlPXtvwtIJ4U62VHDWkOsCyHFw/+jo3xArkH1GKoucPsggAj63
	 Owi3OFMQnj9UyX7eWVqdzsQ7brtrd9KdziejU7IG5MG7Y1EZs3GApmepKvgbS1sc5q
	 CEdil+UDzHPd/enFE/VNIxzq4iWYxh3S+UcBabL3WHsWyTelncRt2Yp2s3hpdOuJU5
	 EOunifIfok7GLjz5j1pID5EWweUWMCnkvNGxHOy9/JQar13GAJSb6ncs2SdrW08K8w
	 QVqXb1p/K73lukmOI0HXUXrIsIaWhy5TkMaHrdbBF+Itwprh9u4gZLr6nW2J4tIH41
	 D9CspqYKrWkNQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Seyeong Kim <seyeong.kim@canonical.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	tatyana.e.nikolova@intel.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] RDMA/irdma: Suppress PF reset on HMC error
Date: Mon, 19 Oct 2026 09:44:57 -0400
Message-ID: <20261019135441.1420968-6-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Seyeong Kim <seyeong.kim@canonical.com>

[ Upstream commit 4dc9c884c0aafac1e8d37536d88d485135e26883 ]

The irdma driver currently issues an unconditional PF reset whenever the
HMC Error interrupt (PFINT_OICR bit 26) fires:

	if (event->reg & IRDMAPFINT_OICR_HMC_ERR_M) {
		ibdev_err(&iwdev->ibdev, "HMC Error\n");
		iwdev->rf->reset = true;
	}

request_reset() issues an IIDC_PFR to ice. In practice a single HMC_ERR
can trigger cascading PF resets, IOMMU faults during teardown, and
teardown of every RDMA connection on the device.

i40e handles the identically-named interrupt by reading
PFHMC_ERRORINFO and PFHMC_ERRORDATA and logging them without touching
device state; see commit 9c010ee0ea5f ("i40e: Suppress HMC error to
Interrupt message level") which removed the reset as "not necessary".
This patch mirrors that handling on irdma.

With this change, repeated HMC_ERR no longer produces a reset storm and
RDMA traffic on the device continues uninterrupted.

Signed-off-by: Seyeong Kim <seyeong.kim@canonical.com>
Link: https://patch.msgid.link/20260619050044.1807044-1-seyeong.kim@canonical.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The
irdma GEN2 HMC-error path exists here, and this change is a real
production fix for Intel E810 PF-reset storms. Analysis below is for
this tree only.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[RDMA/irdma] [Suppress] [stop issuing a PF reset when the HMC
Error interrupt fires]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Fixes:** none (expected for this review)
- **Reported-by:** none in the commit message
- **Tested-by:** none tagged (author did describe hardware testing in
  the RFC/v2 cover)
- **Reviewed-by / Acked-by:** none
- **Link:** `https://patch.msgid.link/20260619050044.1807044-1-
  seyeong.kim@canonical.com`
- **Cc: stable:** none (expected)
- **Signed-off-by:** Seyeong Kim (author); Leon Romanovsky (RDMA
  maintainer). The pipeline’s “Sasha Levin” SOB is ignored.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `icrdma_iidc_event_handler()` sets `iwdev->rf->reset = true`
  on `IRDMAPFINT_OICR_HMC_ERR_M` (PFINT_OICR bit 26). That calls
  `request_reset()` → `ice_rdma_request_reset(..., IIDC_FUNC_RESET)` →
  `ICE_RESET_PFR`.
- **Symptom:** cascading PF resets, IOMMU/DMAR faults during teardown,
  every RDMA connection on the device torn down. On newer NVM a single
  forced HMC_ERR still caused a full PF reset and aborted RDMA traffic.
- **Root cause (author):** HMC_ERR was treated as fatal; i40e stopped
  resetting on the same interrupt in 9c010ee0ea5f (“reset that was not
  necessary”).
- **Version info:** author tested Ubuntu 6.8 (NVM 3.10, cascading resets
  + DMAR) and mainline 7.1-rc4 (NVM 4.51, single reset). Driver path has
  existed since irdma GEN2 was added.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not hidden.** This is an explicit error-handling fix: stop a
destructive reset. Diagnostic MMIO reads are extra, not a cleanup
disguised as a fix.

===============================================================
PHASE 2: DIFF ANALYSIS
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- `drivers/infiniband/hw/irdma/icrdma_if.c`: HMC_ERR branch (stop reset;
  log errinfo/errdata)
- `drivers/infiniband/hw/irdma/irdma.h`: `IRDMA_PFHMC_ERRORINFO`,
  `IRDMA_PFHMC_ERRORDATA` before `IRDMA_MAX_REGS`
- `drivers/infiniband/hw/irdma/icrdma_hw.h` / `icrdma_hw.c`: GEN2
  offsets `0x00520400` / `0x00520500`
- `drivers/infiniband/hw/irdma/i40iw_hw.c`: matching `0xffffffff`
  placeholders so GEN1 array length still matches the enum
**+15 / −3**, five files. **Surgical, single-subsystem.** Function:
`icrdma_iidc_event_handler`.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: **Before:** HMC_ERR → `ibdev_err("HMC Error")` → `rf->reset =
true` → `request_reset()`. **After:** HMC_ERR → `readl`
ERRORINFO/ERRORDATA → `ibdev_warn` → **do not set reset**. PE_CRITERR
(except Q1 resource check) and PE_PUSH still reset.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Logic / hardware-error handling (over-aggressive recovery).**
Unconditional PF reset on a non-fatal (or at least non-reset-worthy)
interrupt causes reset storms, aux unplug, IOMMU faults, and full RDMA
teardown. Fix: log-only, matching i40e. ice itself already only
*forwards* HMC_ERR to the aux driver and does not reset on that bit.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Core change (clear `rf->reset = true`) is obviously correct
relative to i40e/ice. Diagnostic register plumbing is extra; offsets
were **inferred** from `PFHMC_PDINV` (+0x100/+0x200), same spacing as
i40e’s PDINV/ERRORINFO/ERRORDATA. Forced-interrupt tests read back 0, so
offsets are unverified against a datasheet, but they are **read-only**
and not the recovery change. GEN1/GEN2 arrays were updated together;
GEN3/GEN4 use `ig3rdma_init_hw()` and do not index `IRDMA_MAX_REGS`.
**Regression risk:** leaving a true HMC failure running without reset —
possible, but i40e has done this since 2014, ice does not reset on
HMC_ERR, and PE_CRITERR/PE_PUSH still reset. **Low risk** for the reset-
suppression itself.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: Unconditional HMC reset came from **8498a30e1b948**
(“RDMA/irdma: Register auxiliary driver…”, 2021-06-02), moved into
`icrdma_if.c` by **0c2b80cac96e1** (2025 refactor). Present since irdma
GEN2 (~5.14-era), not new 7.3 code.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No Fixes: tag.** Related precedent **9c010ee0ea5f** (i40e,
2014) is in this tree (`git merge-base --is-ancestor` succeeded). i40e
still logs HMC error info and does not reset.

**Step 3.3: CHECK FILE HISTORY**
Record: Recent irdma work is GEN3/GEN4 and udata hardening. This patch
is **standalone**, not “X/Y”. Later commits do not revert or replace
this HMC handling.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Seyeong Kim (Canonical) — one irdma commit here. Intel irdma
maintainer is Tatyana Nikolova (CC’d). Applied by Leon Romanovsky.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Needs `icrdma_if.c`, `IRDMA_GLINT_RATE` in the enum (so new
entries stay last), and ice `IIDC_RDMA_EVENT_CRIT_ERR`. All present in
this 7.3 tree. **Applies standalone** here.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 4dc9c884c0aaf`: RFC + v2. Applied version is **v2**
  (`20260619050044.1807044-1`).
- RFC: https://patch.msgid.link/20260416071541.3899471-1-
  seyeong.kim@canonical.com
- v2: https://patch.msgid.link/20260619050044.1807044-1-
  seyeong.kim@canonical.com
- RFC notes: offsets inferred; “every HMC_ERR is safe to continue” not
  datasheet-confirmed; repro via `/dev/mem` write to PFINT_OICR, not
  firmware HMC.
- May 22 follow-up: retested on **7.1-rc4**; patch applied unchanged.
- **No NAK** in the saved thread. lore.kernel.org HTML fetch returned
  403; thread recovered via `b4 dig -m`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): linux-rdma, Krzysztof Czurylo, Tatyana Nikolova,
Jason Gunthorpe, Leon Romanovsky. **No Reviewed-by** in the mbox (RFC,
author ping, then maintainer apply). Right maintainers were CC’d.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: Real-world HMC_ERR → “Requesting a reset” is widely reported:
- GitHub intel/ethernet-linux-ice#12: recurring OICR `0x06000803` / HMC
  Error / PF reset on multiple machines; workaround unload/blacklist
  irdma.
- Proxmox forum: E810 HMC Error → Corosync loss / node reboots.
- Alpine even blacklists `irdma` by default over this class of issue.
Author also cites a **customer report on NVM 3.10** (cascading PFR +
DMAR).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Single patch (RFC → v2). Not a multi-patch series.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search **403**. No evidence this commit
was NAK’d for stable. Unrelated 6.6 irdma reset patch
(`irdma_modify_qp_to_err`) is a different bug.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: KEY FUNCTIONS**
Record: `icrdma_iidc_event_handler` (behavior). Arrays/enum:
`icrdma_regs`, `i40iw_regs`, `enum irdma_registers`. Init:
`icrdma_init_hw` / `i40iw_init_hw` walk `IRDMA_MAX_REGS`.

**Step 5.2: TRACE CALLERS**
Record: Registered as `.event_handler` on the GEN2 auxiliary driver. ice
misc IRQ sets `ICE_AUX_ERR_PENDING` for `PFINT_OICR_HMC_ERR_M`; service
task sends `IIDC_RDMA_EVENT_CRIT_ERR` with the OICR value.
**Hardware/interrupt-driven**, not a syscall. Hits any system with ice +
irdma loaded (E810 and similar), including hosts that are not running
RDMA traffic.

**Step 5.3: TRACE CALLEES**
Record: After the patch, `readl` of two HMC diagnostic regs. Before,
`icrdma_request_reset` → `ice_rdma_request_reset` →
`ice_schedule_reset(ICE_RESET_PFR)` — full function reset, unplug aux,
drop the NIC datapath.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: ice OICR → service task → aux event → irdma handler → (old) PF
reset. Userspace cannot set OICR, but **firmware/hardware HMC_ERR is
common** on E810. Forced-bit tests still prove the handler’s reset is
what destroys connections.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same interrupt: i40e logs and does not reset; ice does not
reset, only notifies aux. irdma PE_CRITERR already special-cases Q1
resource errors as non-fatal. This HMC change is the same pattern.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `icrdma_iidc_event_handler` in
`drivers/infiniband/hw/irdma/icrdma_if.c`. Pre-fix parent still had
`rf->reset = true` on HMC_ERR. Bug introduced **2021** (8498a30e1b948),
long before 7.3. Current HEAD already contains **4dc9c884c0aaf** (that
is the mainline merge of this fix, not a reason to reject it on merit).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply on this tree.** Context matches. GEN1 placeholders
keep `IRDMA_MAX_REGS` arrays aligned. Would need more care on much older
stables if `IRDMA_GLINT_RATE` or `icrdma_if.c` were missing; **not an
issue here**.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This *is* the HMC-reset suppression. No alternate fix. i40e’s
older analogous change is present.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: SUBSYSTEM AND CRITICALITY**
Record: **RDMA/irdma (Intel E810 / ice GEN2).** **IMPORTANT** — not core
mm/VFS, but E810 is common in servers/clusters. A PF reset takes down
**Ethernet as well as RDMA**.

**Step 7.2: SUBSYSTEM ACTIVITY**
Record: Actively developed (GEN3/GEN4, udata). This handler itself has
been stable since the 2021 introduction / 2025 file move.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: WHO IS AFFECTED**
Record: **Driver-specific** — ice + irdma (Intel E810 and related).
Includes clusters that load irdma by default even when they do not use
RDMA (Proxmox/ice GitHub reports).

**Step 8.2: TRIGGER CONDITIONS**
Record: Hardware HMC_ERR (OICR bit 26). Seen in the field without a
special RDMA workload. Not a userspace-triggered security bug. **Common
enough** that distros document blacklisting irdma.

**Step 8.3: FAILURE MODE SEVERITY**
Record: PF reset → link down, RDMA teardown, IOMMU faults, uverbs WARN
during aux unplug, cluster partition / reboot in reports. **Severity:
HIGH (hang/datapath loss); CRITICAL in HA/cluster setups.**

**Step 8.4: RISK-BENEFIT RATIO**
Record: **Benefit: high** (stops reset storms on a widely deployed NIC).
**Risk: low** for dropping the reset; **very low** extra risk from read-
only diagnostic MMIO (wrong offset would log junk or, at worst, a bad
read — tests did not blow up). Ratio favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real, user-visible bug: PF reset storm, IOMMU faults, full
  RDMA/Ethernet disruption on E810.
- Field reports (customer, Proxmox, ice GitHub); Canonical engineer with
  before/after on 6.8 and 7.1-rc4.
- Small (+15/-3), contained in irdma.
- Matches i40e (2014, Intel: reset “not necessary”) and ice (forwards
  HMC_ERR, does not reset).
- Fatal PE_CRITERR / PE_PUSH paths unchanged.
- RDMA maintainer applied it; Intel irdma maintainers were CC’d.
- Code and prerequisites exist in this 7.3 tree.

AGAINST:
- Diagnostic register offsets inferred, not datasheet-confirmed (reads
  were 0 on a *forced* interrupt).
- Author RFC: not proven every firmware HMC_ERR is safe to run through.
- Repro used `/dev/mem` OICR injection, not a firmware HMC event
  (customer logs still show the same handler path).
- No Fixes/Cc stable, no Reviewed-by (absence is not a no-vote per the
  rules).

UNRESOLVED:
- Full public review text beyond the RFC mbox (lore HTML 403).
- Whether stable@ discussed this specific patch (stable search 403).
- Exact meaning of HMC_ERR on E810 silicon.

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — drop destructive reset;
   tested on E810; i40e/ice precedent.
2. Fixes a real bug that affects users? **PASS** — production reset
   storms.
3. Important (crash/security/corruption/deadlock)? **PASS** — PF reset /
   datapath loss / IOMMU faults / cluster impact. HIGH.
4. Small and contained? **PASS** — 15 insertions, one handler.
5. No new features or APIs? **PASS** — error-path policy + diagnostic
   reads.
6. Can apply to the local tree? **PASS** — matching irdma GEN2 code in
   7.3.0-rc4.

**Step 9.3: EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. It is a
**hardware error-handling workaround** in an existing driver (same class
as USB/PCI quirks: stop a harmful default for real devices).

**Step 9.4: DECISION**
This tree has the irdma GEN2 HMC path. Suppressing PF reset on HMC_ERR
is a small, tested fix for a serious, widely seen E810 failure mode.
Diagnostic MMIO is best-effort; the stable-worthy part is not resetting.
Benefit clearly outweighs risk.

Verification:
- [Phase 1] Tags: Link to msgid 20260619050044; SOB Seyeong Kim + Leon
  Romanovsky; no Fixes/Reported-by/Cc stable
- [Phase 2] Diff: 5 files, +15/-3; HMC_ERR no longer sets `rf->reset`;
  GEN2 regs + GEN1 0xffffffff pads
- [Phase 2] Confirmed `ice_rdma_request_reset(IIDC_FUNC_RESET)` →
  `ICE_RESET_PFR`
- [Phase 3] Blame: reset from 8498a30e1b948 (2021); moved in
  0c2b80cac96e1
- [Phase 3] `git merge-base --is-ancestor 9c010ee0ea5f HEAD` = YES; i40e
  still log-only
- [Phase 3] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4
- [Phase 3] `git merge-base --is-ancestor 4dc9c884c0aaf HEAD` = YES
  (mainline landing of this fix)
- [Phase 4] `b4 dig -c 4dc9c884c0aaf`: RFC then v2; v2 applied; `-w`
  CC’d Intel irdma + RDMA maintainers
- [Phase 4] `b4 dig -m`: RFC caveats + 7.1-rc4 retest; no NAK in mbox
- [Phase 4] External: ice GitHub #12 and Proxmox E810 HMC reset reports
- [Phase 4] lore.kernel.org WebFetch 403; stable@ search 403 — listed
  UNVERIFIED
- [Phase 5] Handler is ice aux `.event_handler`; GEN3/4 use a different
  event path (no HMC reset there)
- [Phase 6] Pre-fix HMC_ERR block present at 4dc9c884c0aaf^; arrays
  aligned with enum
- [Phase 8] Failure mode: PF reset / RDMA+Ethernet teardown / IOMMU
  faults, severity HIGH
- UNVERIFIED: datasheet-correctness of 0x00520400/0x00520500; public
  Intel Acked-by beyond CC

The patch is small, matches long-standing i40e/ice behavior, and
prevents a real E810 reset storm that takes down RDMA and the PF.

**YES**

 drivers/infiniband/hw/irdma/i40iw_hw.c  | 4 +++-
 drivers/infiniband/hw/irdma/icrdma_hw.c | 2 ++
 drivers/infiniband/hw/irdma/icrdma_hw.h | 2 ++
 drivers/infiniband/hw/irdma/icrdma_if.c | 8 ++++++--
 drivers/infiniband/hw/irdma/irdma.h     | 2 ++
 5 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/i40iw_hw.c b/drivers/infiniband/hw/irdma/i40iw_hw.c
index 60c1f2b1811de..8301938b45432 100644
--- a/drivers/infiniband/hw/irdma/i40iw_hw.c
+++ b/drivers/infiniband/hw/irdma/i40iw_hw.c
@@ -29,7 +29,9 @@ static u32 i40iw_regs[IRDMA_MAX_REGS] = {
 	I40E_PFHMC_PDINV,
 	I40E_GLHMC_VFPDINV(0),
 	I40E_GLPE_CRITERR,
-	0xffffffff      /* PFINT_RATEN not used in FPK */
+	0xffffffff,     /* PFINT_RATEN not used in FPK */
+	0xffffffff,     /* PFHMC_ERRORINFO not used in FPK */
+	0xffffffff      /* PFHMC_ERRORDATA not used in FPK */
 };
 
 static u32 i40iw_stat_offsets[] = {
diff --git a/drivers/infiniband/hw/irdma/icrdma_hw.c b/drivers/infiniband/hw/irdma/icrdma_hw.c
index 32f26284a788b..b1f1b54857626 100644
--- a/drivers/infiniband/hw/irdma/icrdma_hw.c
+++ b/drivers/infiniband/hw/irdma/icrdma_hw.c
@@ -29,6 +29,8 @@ static u32 icrdma_regs[IRDMA_MAX_REGS] = {
 	GLHMC_VFPDINV(0),
 	GLPE_CRITERR,
 	GLINT_RATE(0),
+	PFHMC_ERRORINFO,
+	PFHMC_ERRORDATA,
 };
 
 static u64 icrdma_masks[IRDMA_MAX_MASKS] = {
diff --git a/drivers/infiniband/hw/irdma/icrdma_hw.h b/drivers/infiniband/hw/irdma/icrdma_hw.h
index d97944ab45dac..0acdeda1236d1 100644
--- a/drivers/infiniband/hw/irdma/icrdma_hw.h
+++ b/drivers/infiniband/hw/irdma/icrdma_hw.h
@@ -40,6 +40,8 @@
 #define GLHMC_VFPDINV(_i)	(0x00528300 + ((_i) * 4)) /* _i=0...31 */
 #define GLPE_CRITERR		0x00534000
 #define GLINT_RATE(_INT)	(0x0015A000 + ((_INT) * 4)) /* _i=0...2047 */ /* Reset Source: CORER */
+#define PFHMC_ERRORINFO		0x00520400
+#define PFHMC_ERRORDATA		0x00520500
 
 #define ICRDMA_DB_ADDR_OFFSET		(8 * 1024 * 1024 - 64 * 1024)
 
diff --git a/drivers/infiniband/hw/irdma/icrdma_if.c b/drivers/infiniband/hw/irdma/icrdma_if.c
index b49fd9cf24765..6c1d285d1c176 100644
--- a/drivers/infiniband/hw/irdma/icrdma_if.c
+++ b/drivers/infiniband/hw/irdma/icrdma_if.c
@@ -91,8 +91,12 @@ static void icrdma_iidc_event_handler(struct iidc_rdma_core_dev_info *cdev_info,
 			}
 		}
 		if (event->reg & IRDMAPFINT_OICR_HMC_ERR_M) {
-			ibdev_err(&iwdev->ibdev, "HMC Error\n");
-			iwdev->rf->reset = true;
+			u32 hmc_errinfo = readl(iwdev->rf->sc_dev.hw_regs[IRDMA_PFHMC_ERRORINFO]);
+			u32 hmc_errdata = readl(iwdev->rf->sc_dev.hw_regs[IRDMA_PFHMC_ERRORDATA]);
+
+			/* Log diagnostics; do not reset here. */
+			ibdev_warn(&iwdev->ibdev, "HMC Error: errinfo=0x%08x errdata=0x%08x\n",
+				   hmc_errinfo, hmc_errdata);
 		}
 		if (event->reg & IRDMAPFINT_OICR_PE_PUSH_M) {
 			ibdev_err(&iwdev->ibdev, "PE Push Error\n");
diff --git a/drivers/infiniband/hw/irdma/irdma.h b/drivers/infiniband/hw/irdma/irdma.h
index ff938a01d70c4..e8cda27d78543 100644
--- a/drivers/infiniband/hw/irdma/irdma.h
+++ b/drivers/infiniband/hw/irdma/irdma.h
@@ -66,6 +66,8 @@ enum irdma_registers {
 	IRDMA_GLHMC_VFPDINV,
 	IRDMA_GLPE_CRITERR,
 	IRDMA_GLINT_RATE,
+	IRDMA_PFHMC_ERRORINFO,
+	IRDMA_PFHMC_ERRORDATA,
 	IRDMA_MAX_REGS, /* Must be last entry */
 };
 
-- 
2.53.0

