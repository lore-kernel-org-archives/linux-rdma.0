Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 967021DB92C;
	Tue, 11 Aug 2026 02:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786415932; cv=none; b=CWbMS9IM592i9P1MeMnIi6R/krH8h9DeSSUlJS9ysHKywyqcRIWTKzTsQsYAai4ClrshXT/TzsCjWSnGnpsX7MxZAs/MEep7mm74jUYET6dH/5r/yMvDY/9T7GxYnHd1nA/caX9LmmnuIezXS8baZXIeQzEnqkEwawyriPkWpn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786415932; c=relaxed/simple;
	bh=mcfity+EVInadITpc5y3oshVq1EkP8Lt2LBRMxOVtAE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sEUT6TU5xhr9fQzxsS8sxwjWHlymVPbAupQLA/rsBKTZeF2STSexhE6HdASlDo+fWs07IC3m1qqiV/fJlzsn56pKblgPUiOmobsXFE8QcrH4VH9BXykTV7Su5KTPmEdyaWgASD6KBixmBncpdCcM4MRObLbTkudquoBOv0f2b+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id C3A2A20B7167; Mon, 10 Aug 2026 19:38:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C3A2A20B7167
From: Long Li <longli@microsoft.com>
To: Long Li <longli@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	shradhagupta@linux.microsoft.com,
	Simon Horman <horms@kernel.org>,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v6 0/7] net: mana: HW channel reliability and hardening fixes
Date: Mon, 10 Aug 2026 19:38:14 -0700
Message-ID: <20260811023823.2391255-1-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes a set of latent bugs and robustness gaps in the MANA
Hardware Channel (HWC), the control path the driver uses to talk to the
device.  The issues range from a use-after-free of completion queues
during teardown to buffer mis-sizing, unsafe teardown ordering, missing
validation of device-supplied RX metadata, and stale-response handling
after a command timeout.

Patch overview:

  1  RCU-protect gc->cq_table lookups against concurrent CQ destroy
     The EQ interrupt handler dereferences CQ pointers from gc->cq_table
     while teardown can free them.  Put the table under RCU and wait a
     grace period before freeing, closing the use-after-free.

  2  fix HWC RQ/SQ buffer size swap
     init_queues() sized the RQ with max_req_msg_size and the SQ with
     max_resp_msg_size -- backwards.  Correct the swap; both sizes are
     equal in practice, so this is a latent-correctness fix.

  3  free HWC comp_buf after destroying the EQ
     Reorder teardown so the EQ is destroyed (readers quiesced) before
     comp_buf and the CQ are freed, preventing a late EQ-handler access
     to freed memory.

  4  validate hardware-supplied values in the HWC RX path
     Bounds-check the SGE, verify the recovered slot index and SGE
     address, and validate response length and msg_id before use, so
     malformed or hostile DMA metadata cannot cause wrong-slot completion
     or out-of-bounds access.

  5  fix HWC teardown safety with setup_active flag and destroy ordering
     Track setup activation explicitly, tear the EQ/CQ down before the
     TXQ/RXQ, and on an unrecoverable teardown failure leak the HWC
     resources rather than free memory the device may still DMA into.

  6  fix stale HWC response after command timeout
     Replace the inflight-slot semaphore with a bitmap + waitqueue and
     per-slot refcount/lock; latch the channel on timeout so no new slots
     are handed out, drop duplicate/late responses, and ignore a zero
     firmware-supplied timeout.

  7  keep max_num_cqs immutable once cq_table is allocated
     gc->max_num_cqs is set once when cq_table is allocated and never
     reset, so a spoofed post-init HWC event cannot inflate the bound
     past the allocation and drive an out-of-bounds cq_table access.

Follow-up feature work (net-next, sent separately):

The original series also contained two patches that are improvements, not
fixes:

  net: mana: support concurrent HWC requests
  net: mana: add dynamic HWC queue depth with reinit path

Per the netdev tree rules, fixes go to 'net' and features/improvements go
to 'net-next', and the two must not be combined in a single submission.
Those two patches build on the locking and teardown groundwork in this
series, so they will be posted as a separate net-next series only after
these fixes have propagated from net into net-next through the usual
periodic merge.

Changes since v5:

Addressed the automated reviews of v5 and a net-next apply conflict
reported by the netdev CI.  No behavioural change to the patch intent;
the deltas below harden the v5 implementation.

 - patch 1: mana_gd_unpublish_cq() and mana_ib_remove_cq_cb() now clear a
   cq_table slot only when it still points at the CQ being torn down, so
   the two-pass netdev teardown cannot wipe an entry a concurrent RDMA CQ
   create legitimately recycled during the grace period.
   mana_gd_process_eqe() drops an already-unpublished (NULL) slot quietly
   instead of tripping WARN_ON_ONCE() during a normal ifdown/MTU change,
   and reads gc->cq_table before gc->max_num_cqs with an smp_rmb()
   between them so a shrinking re-establish cannot pair a stale bound
   with a newly published, smaller table.
 - patch 5: set setup_active before calling mana_smc_setup_hwc(), which
   activates the device MST entries before it can report a late failure;
   on an unrecoverable teardown failure keep the HWC context reachable
   and retry the teardown on the next bring-up instead of orphaning it.
 - patch 6: initialise the caller_ctx refcount/state before publishing
   the inflight bitmap bit so a racing or forged response cannot observe
   an uninitialised slot; honour a response only while the sender still
   owns the slot (output_buf published and not yet reclaimed), so a
   premature response cannot free the slot while its command is still in
   flight; do not latch hwc_timed_out for the deliberate no-wait teardown
   (hwc_timeout == 0), applied on both the admission gate and the
   post-wait check in mana_hwc_get_msg_index().
 - Moved the max_num_cqs/cq_table lifetime documentation onto the
   cq_table field so the series no longer rewords the comment above
   max_num_cqs, which a pending net-next change (cqe8_coalescing_sup)
   also touches; this resolves the netdev CI net-next apply conflict.
   Comment-only, no functional change.
 - Rebased onto current net/main.
 - v5: https://lore.kernel.org/netdev/20260809190047.2086368-1-longli@microsoft.com/

Changes since v4:

 - No code changes.  Resending as a standalone thread; v4 was
   accidentally sent in-reply-to the v3 thread.
 - v4: https://lore.kernel.org/netdev/20260808023417.1746886-1-longli@microsoft.com/

Changes since v3:

Addressed the netdev-ai and sashiko.dev automated reviews of v3.

 - New patch 7 ("keep max_num_cqs immutable once cq_table is
   allocated"): gc->max_num_cqs is set once and never reset, so a
   spoofed post-init HWC event cannot inflate the bound past the
   allocation and cause an out-of-bounds cq_table access.
 - patch 1: replaced the per-CQ synchronize_rcu() in the netdev teardown
   paths with a two-pass quiesce/free that takes a single grace period
   per teardown; snapshot cq->id and max_num_cqs with READ_ONCE() so the
   same value sizes, bounds and indexes cq_table.
 - patch 4: removed the short-response early return so a malformed
   response reaches verify_resp_msg() -> -EPROTO and completes the
   sender instead of hanging it; account leaked RX WQEs and trip
   hwc_timeout on RQ exhaustion; read the device-supplied
   inline_oob_size_div4 and sge->address with READ_ONCE() and reject any
   value other than the one the driver programs.
 - patch 5: arm setup_active after mana_smc_setup_hwc() succeeds; destroy
   the EQ (IRQ deregister + drain) before the CQ; drop the redundant
   teardown in mana_hwc_establish_channel() that caused a double hardware
   timeout and masked the original error.
 - patch 6: take both the sender and response-side references up front in
   mana_hwc_get_msg_index() so an early/stale/forged response cannot free
   the slot before the sender posts; changed caller_ctx::error from u32
   to int; reject a zero firmware-supplied HWC timeout in the query path
   as well as the reconfig path.
 - v3: https://lore.kernel.org/netdev/20260803234355.636038-1-longli@microsoft.com/

Changes since v2:

 - Per maintainer feedback, split the original combined series: the
   fixes here target 'net'; the two feature patches now go to 'net-next'
   and are sent separately (see above).  Rebased the fixes onto net.
 - Dropped the pcie_flr()-based reset fallback from the teardown path;
   on an unrecoverable teardown failure the driver now leaks the HWC
   resources instead of touching memory the device may still DMA into.

Long Li (7):
  net: mana: RCU-protect gc->cq_table lookups against concurrent CQ
    destroy
  net: mana: fix HWC RQ/SQ buffer size swap
  net: mana: free HWC comp_buf after destroying the EQ
  net: mana: validate hardware-supplied values in the HWC RX path
  net: mana: fix HWC teardown safety with setup_active flag and destroy
    ordering
  net: mana: fix stale HWC response after command timeout
  net: mana: keep max_num_cqs immutable once cq_table is allocated

 drivers/infiniband/hw/mana/cq.c               |  51 +-
 .../net/ethernet/microsoft/mana/gdma_main.c   |  72 ++-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 521 +++++++++++++++---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 136 ++++-
 include/net/mana/gdma.h                       |  37 +-
 include/net/mana/hw_channel.h                 |  44 +-
 6 files changed, 743 insertions(+), 118 deletions(-)


base-commit: f1b3416ceaf7ca4cb5cbd986ee8fe3ffaeda2d48
-- 
2.43.0

