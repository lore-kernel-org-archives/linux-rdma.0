Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B7403B0AC6;
	Tue, 13 Oct 2026 08:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791878764; cv=none; b=OsxJdXgEU9d/nUrRBK/2ydQIi4zA1SvhAAr+sbTntBItqW4GgMe6rONAXc80iD4xzWE/m3Cg/6EhfKXkA0VWE1St0+8dfaSLZiUMyPurkdwv5lO65Tz5Qj1uk1DdpqsWcynpTK/dlbXGqFNjZpXehjc51+GB17y1TN7YQ47Ed8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791878764; c=relaxed/simple;
	bh=mpdYh+tMfrQ1XRC2lz2dt4s7u4bQYe2NihMnCI79/zQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jzZ/jSdfx0r50TlwkwTaBG+8ZHw2wJPYhI37TNkISDGBoHZdFmDafO43yA6gAyKI9n5LnpieM4WPNQHfj2PZZLVuGfvdMiEFjp1K8BrLQvul6dppi9aKn0JOEz0ZiyrNO+8+uphcYzt3Oa7U9wFPLZL4BFqEV4t40bjvJ33z50s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=RaNb7UyT; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="RaNb7UyT"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 2721D20B7166;
	Tue, 13 Oct 2026 01:05:58 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2721D20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791878759;
	bh=ABqutO+AIeQsI2eTyNx05Yl1UwlANTFRncjxekxzhqQ=;
	h=From:To:Cc:Subject:Date:From;
	b=RaNb7UyTxchYv1OhVPxXmAhxGAqyML5QjHeigtEP34Cxlbgj/m1Dc5n2drAT496VP
	 yqwiX2JP9Y7yxjMekREEPjqyjZEPy1z/rDAgm14vQ3OIXZBr6Bl8uFfWCDDgxVv6ia
	 lflxrlH3s9JCmx5kwspMcWmVDBp4kD/0dhQK8fyQ=
From: Wei Hu <weh@linux.microsoft.com>
To: longli@kernel.org,
	kotaranov@microsoft.com,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	leon@kernel.org,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	shradhagupta@linux.microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gargaditya@linux.microsoft.com,
	kees+treewide@kernel.org,
	kees@kernel.org,
	mawasthi@linux.microsoft.com,
	weh@microsoft.com,
	edumazet@kernel.org
Subject: [PATCH net-next v7 0/4] net: mana: concurrent HWC requests and dynamic queue depth
Date: Tue, 13 Oct 2026 08:05:48 +0000
Message-ID: <cover.1791561995.git.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series picks up Long Li's v5 MANA Hardware Channel (HWC) work,
addresses its review findings, and retains its four-patch feature lineage.
Safety changes required by concurrency and repeated HWC reinitialization
are folded into the patch which owns each behavior rather than posted as a
separate fixes series.

I have taken over follow-up upstreaming from Long. Long remains the author
of every patch, his existing sign-off is preserved, and I added mine for
the changes and submission custody.

Patch 1 prepares HWC ownership for safe reinitialization. It serializes
complete shared-memory transactions, tracks possible PF ownership,
retains mappings after an unacknowledged destroy, fences the HWC EQ before
releasing CQ state, and safely publishes and withdraws the HWC CQ table.

Patch 2 gives each slot independent completion state, withdraws caller
storage before sender return, handles the response-versus-timeout race,
and prevents depth-one slot reuse after a genuine timeout.

Patch 3 adds concurrent requests with bounded admission, serialized SQ
posting, separate sender/response ownership, stale-response quarantine,
coherent timeout updates, private setup publication, and sender draining.

Patch 4 rebuilds the depth-one bootstrap queues at validated depths from 2
through 128. It validates both reports, message limits and doorbells,
keeps the untouched bootstrap channel for depth one or reports above 128,
and restores fresh bootstrap queues after a failed rebuild only when
teardown was acknowledged.

Generic Ethernet/RDMA CQ callback refcounting and generic service-work
versus device-lifecycle serialization are independent pre-existing work
and are intentionally excluded. Malformed-RX handling, duplicate-success
correlation, and broad device-controlled allocation/timeout policy caps
also remain separate follow-ups.

This series is independent of the separately posted queue-set v6 series.
That series addresses the pre-existing generic Ethernet CQ reclamation
gap discussed in the HWC v6 review. The CQ-publication hunks overlap;
whichever series lands second will need reconciliation preserving both
table-publication and individual-CQ lifetime guarantees.
https://lore.kernel.org/all/cover.1790795005.git.weh@linux.microsoft.com/

Changes in v7 (v6 -> v7):
 - Rebase onto net-next d8674294aefef02266c4d47ad10131f1bffbe534,
   following Simon Horman's request after the v6 CI application failure.
 - Preserve the upstream GDMA core/PCI transport split and CDX support.
   Initialize the HWC lifetime lock on both transport probe paths and
   perform PCI recovery's timeout cancellation through a GDMA core helper
   which protects the published HWC pointer across the module boundary.
 - Retain the four-patch lineage and the v6 ownership, request, timeout,
   publication, depth-validation and fallback policies.

Rebase request:
https://lore.kernel.org/all/20261009151906.GF83879@horms.kernel.org/

Changes in v6 (v5 -> v6):
 - Keep the four-patch v5 structure while folding review-required HWC
   ownership, teardown, timeout, publication and fallback safety into
   their owning feature patches.
 - Serialize complete ESTABLISH_HWC and DESTROY_HWC shared-memory
   transactions. Record possible PF ownership before MMIO submission and
   clear it only after DESTROY_HWC is acknowledged.
 - Retain PF-visible queues after an indeterminate destroy. Fence the
   dedicated HWC EQ and withdraw its CQ from dispatch without freeing the
   mappings, then retry teardown before assigning fresh queues.
 - Destroy the HWC EQ before CQ and completion state. Release-publish the
   CQ table and wait for IRQ-side RCU readers before freeing it, without
   adding per-completion refcount operations.
 - Withdraw the caller's response buffer before return and quarantine a
   timed-out slot until its late response arrives or teardown cancels it.
 - Return -EBUSY for healthy slot pressure and reserve -ETIMEDOUT for an
   admitted request which receives no response.
 - Publish slots under the inflight lock, protect response state with the
   per-slot lock, and retain sender/response references until both sides
   finish.
 - Synchronize hwc_timeout updates and publish the HWC only after queues,
   admission state, caller contexts and the direct EQ test are ready.
 - Replace the goto-heavy request and channel-creation flows called out in
   review with focused admission, submission, wait, build, validation,
   rebuild and fallback helpers.
 - Treat reported depth as a maximum: rebuild exactly for 2 through 128,
   retain untouched bootstrap queues for 1 or above 128, and require the
   rebuilt report to repeat the selected depth.
 - Enforce directional request/response maxima against both the report
   and allocated buffers. Rebuild only for exact 4096-byte reports while
   permitting bootstrap operation for other nonzero maxima.
 - Validate BAR page geometry and every stored doorbell. Invalidate the
   old HWC doorbell before re-establishment and suppress MMIO while the
   invalid sentinel is present, without adding full validation to each
   data-path doorbell ring.
 - Remove the proposed capability bit because driver-version
   advertisement occurs after HWC establishment and cannot negotiate
   creation-time behavior.
 - Preserve current net-next behavior which always uses the
   hardware-reported dest_vrq_id and dest_vrcq_id.

Changes in v5 (v4 -> v5):
 - Shortened comments and documented the existing error paths in patches
   1 and 2.
 - Rejected apparent success from a response accepted before request
   submission.
 - Guarded CQ unpublication when establishment failed before cq_table
   allocation.
 - Required successful retry teardown before creating fresh bootstrap
   queues after an initial destroy failure.

Changes in v4 (return to net-next after the v3 split):
 - Reworked the feature series into four standalone patches for handover,
   per-slot completion state, concurrency and dynamic depth.
 - Added bounded admission, guarded sender accounting, timeout quarantine,
   queue-depth bounds, message-buffer sizing and rebuild validation.
 - Reset routing IDs for each establish and rejected a missing doorbell.

Changes in v3 (v2 -> net v3, historical fixes-only posting):
 - Split the combined series after maintainer feedback, posting fixes to
   net and deferring concurrency and dynamic depth.
 - Added response-buffer withdrawal and stale-response handling.
 - Removed pcie_flr() teardown fallback and retained resources after an
   unacknowledged destroy.

Changes in v2 (v1 -> v2):
 - Bounds-checked the SGE pointer derived from inline OOB size.
 - Protected active-sender accounting and drained senders during
   teardown and failure exits.
 - Rebased on net-next e354f7d60f14.

v1:
 - Combined CQ-table lifetime, queue sizing, RX validation, teardown,
   concurrent-request and dynamic-depth work in seven patches.

Validation:
 - Exact application and strict checkpatch for all four patches.
 - Baseline and every intermediate commit built with GCC/Clang W=1,
   including GDMA core, PCI, CDX COMPILE_TEST and RDMA target objects.
 - Full baseline/release kernel and module builds on the new base.
 - Sparse: no new diagnostics relative to baseline. Smatch remains
   limited by identical baseline frontend and array-bound diagnostics;
   it is not counted as a clean pass.
 - Fresh baseline/release runs on two Azure MANA VMs: concurrent PD/MR
   and native RNIC PD/CQ/MR resource controls, channel/MTU changes,
   three PCI remove/rescan cycles per VM, and three samples each of
   forward/reverse TCP and 64-byte UDP. No new kernel warning or
   functional failure in these runs; safe kernels/configurations restored.
 - These runs do not establish negotiated multi-request depth, connected
   RDMA data-plane operation, CDX hardware support or fresh firmware-fault,
   fallback, sanitizer/lockdep coverage. Prior v6 fault evidence is not
   presented as fresh v7 execution.

v6:
https://lore.kernel.org/all/cover.1790665894.git.weh@linux.microsoft.com/
v5:
https://lore.kernel.org/all/20260908035201.402424-1-longli@microsoft.com/
v4:
https://lore.kernel.org/all/20260901200018.3194525-1-longli@microsoft.com/
v3:
https://lore.kernel.org/all/20260803234355.636038-1-longli@microsoft.com/
v2:
https://lore.kernel.org/all/20260721234339.1476932-1-longli@microsoft.com/
v1:
https://lore.kernel.org/all/20260715032942.3945317-1-longli@microsoft.com/

Long Li (4):
  net: mana: prepare HWC ownership for safe reinitialization
  net: mana: give each HWC message slot its own completion state
  net: mana: support concurrent HWC requests
  net: mana: add dynamic HWC queue depth with reinit path

 .../net/ethernet/microsoft/mana/gdma_cdx.c    |   1 +
 .../net/ethernet/microsoft/mana/gdma_main.c   | 140 ++-
 .../net/ethernet/microsoft/mana/gdma_pci.c    |  11 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 928 +++++++++++++++---
 .../net/ethernet/microsoft/mana/shm_channel.c |  58 +-
 include/net/mana/gdma.h                       |  16 +
 include/net/mana/hw_channel.h                 |  56 +-
 include/net/mana/shm_channel.h                |  10 +-
 8 files changed, 1019 insertions(+), 201 deletions(-)


base-commit: d8674294aefef02266c4d47ad10131f1bffbe534
-- 
2.43.0

