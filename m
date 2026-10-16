Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0E4535CB95;
	Fri, 16 Oct 2026 12:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792152385; cv=none; b=UTbloiTd1MdtxNlvF3NQvBNIIHYhLxPQMcSbeW4vOZrdsW/3/MWDGvW2dqCKZiGCeEETYFSoJqP6Y9NyPzkb2loaP+XcvgeXm0oWOJyFKbkGlTsx2xI0QwSQ4Gj1R4CrTH78sM7xzvAqpatt6Hscu8cCH6k7HbCLNkUjpCjjVeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792152385; c=relaxed/simple;
	bh=Dux8XgG9qZ7fuXH1zzW6TRAQ+V3845zFd1x7phrq9xg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F/cICEu1CANhPDzSR1hg5FS9duOMQ/eKeFXIQvdZc2XEhyKvJuX7EtL9M+72BC9ZV1Zcb1BExgdLL4QhllIpGs/S4n/7cfXi8La74opJCmyCs1dJlsuN8SST9N/fVi4oTJjwt1gYv+Y63OIhJ1dVsFrtnlqa4lZqb6+MP0Xp62s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Gz6az5Kl; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Gz6az5Kl"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id A6FF320B7167;
	Fri, 16 Oct 2026 05:06:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A6FF320B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792152377;
	bh=fAvjJsfLqsOrRGL0PwoaIsA9wxNt0NwLGUIsp3qeLxk=;
	h=From:To:Cc:Subject:Date:From;
	b=Gz6az5KlXaV6lOBo7rKQUpxkCDVQYtu4UYY+kilsxxUZrtFz28Ud618kTDPjCP4NN
	 0Hlxshen7qssu/BOC0gA1aEas8vWtkZhkKdzWBQ2i2dkm6BjsyEZ2U+KInU6gEf9Qc
	 HOJcOk2mW9iFomxMveJCB+H5tcx6gyJOLdG/8ZK0=
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
Subject: [PATCH net-next v8 0/4] net: mana: concurrent HWC requests and dynamic queue depth
Date: Fri, 16 Oct 2026 12:06:11 +0000
Message-ID: <cover.1791998462.git.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds concurrent HWC request ownership and negotiated HWC
queue depth to MANA. It starts from depth-one bootstrap queues, keeps
setup private until the final channel is tested, and preserves the
distinction between CPU lifetime and PF ownership of DMA mappings.

I am continuing Long Li's four-patch series. Original per-patch author
identity, dates and sign-offs are retained.

Changes in v8 (v7 -> v8):
 - Rebase onto net-next 05b5019b01fb9443b09ae4ed34af1135a80a84c8.
 - Withdraw the table and drain RCU readers before freeing the HWC
   bundle, in patch 1. Add final PCI/CDX software-only disposal of
   retained state without reclaiming unacknowledged PF-owned DMA.
 - Initialize caller state under the per-slot lock. Do not introduce
   a temporary channel-wide timeout latch in intermediate patch 2.
 - Preserve recovery signaling when abandoned responses exhaust
   admission, while healthy saturation remains ordinary pressure.
 - Include the candidate functional test in bounded bootstrap fallback
   and preserve a live retry budget without reviving cancellation.
 - Share the effective TX budget with GDMA/RDMA request producers;
   bound RDMA batches without changing RX allocation/indexing strides.
 - Preserve stopped-channel errors before admission and fail malformed
   doorbell initialization without depending on a later INIT_DONE.
 - Correct cleanup comments and commit-message rationale. Review both
   Sashiko report streams rather than treating either as exhaustive.

This series remains independent of queue-set replacement. That work
addresses individual Ethernet CQ publication/retirement. The shared
CQ-table hunks must be reconciled while preserving both contracts,
whichever series lands second. Neither series is silently stacked.
https://lore.kernel.org/all/cover.1790795005.git.weh@linux.microsoft.com/

Known separate concerns include individual RDMA/datapath CQ lifetime,
malformed-response RX reposting and wider DMA failure/device-lifecycle
policy. This revision does not claim to fix them. Standalone net/stable
backports of older-kernel fixes require separate extraction/validation.

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
Source and build qualification:
Per-intermediate GCC/Clang W=1 builds, patch style checks, focused
actual-source C cases and paired full kernel/image/module qualification
are complete. Sparse retains a baseline warning; Smatch retains baseline
frontend diagnostics and is not counted as a clean pass.

Ordinary baseline/release coverage on VM5 and VM6 is complete.
Each VM/fixture has 1,600 type-2 PD/MR and 320 type-3 PD/CQ/MR operations
across the initial and three post-PCI rounds, native channels 8->4->8,
native/upper MTUs 1500->1400->1500, three PCI remove/rescan cycles,
bounded ping and three-second TCP/1Mbit UDP with positive receivers.
Both VMs returned to their exact SAFE baselines. Owned fixtures/helpers
and processes were removed; guest and central reservations were released.

Evidence is explicitly composed, not one uninterrupted four-trial run.
The completed VM5 baseline uses retained exact runtime receipts and a
corrected evaluation of iperf3's duplicate, identical UDP bitrate metadata.
That original harness attempt remains PROFILE_FAILED in its history.
VM5 release and both VM6 fixtures completed in a new three-trial run.
Fixture identity and SAFE continuity are checked across the two scopes.

No measured simultaneous outstanding firmware-command count, negotiated
depth proof, performance comparison, connected RDMA workload, CDX hardware,
fault injection, sanitizer, DIM or queue-set qualification is claimed.

The final intermediate-history correction leaves the entire final
source tree identical to the release build snapshot a1454f411cdc.
Evidence retains the literal build commit and kernelrelease rather
than relabeling an image with a later history-only commit ID.

v7:
https://lore.kernel.org/all/cover.1791561995.git.weh@linux.microsoft.com/
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

 drivers/infiniband/hw/mana/main.c             |   19 +-
 .../net/ethernet/microsoft/mana/gdma_cdx.c    |    5 +-
 .../net/ethernet/microsoft/mana/gdma_main.c   |  154 ++-
 .../net/ethernet/microsoft/mana/gdma_pci.c    |   15 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 1019 ++++++++++++++---
 .../net/ethernet/microsoft/mana/shm_channel.c |   58 +-
 include/net/mana/gdma.h                       |   17 +
 include/net/mana/hw_channel.h                 |   69 +-
 include/net/mana/shm_channel.h                |   10 +-
 9 files changed, 1150 insertions(+), 216 deletions(-)


base-commit: 05b5019b01fb9443b09ae4ed34af1135a80a84c8
-- 
2.43.0

