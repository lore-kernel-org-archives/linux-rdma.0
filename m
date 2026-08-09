Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75C7F1EE7C6;
	Sun,  9 Aug 2026 19:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786302083; cv=none; b=U4W755Ppf+FhENcx0uO158Ko0mGxSRpNpindxr1eaOiOs29wHdJpCgMlx10jH9ERWGF9W+uJfVgERdtYaSN2EiAxf4hR6aVletDAB9QXCBTQ7dMZpoT0FKxTcLfXC9355Un6Idvm2ITUUFAsdVYEFen+g3J9qqsRNTGlMgihp3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786302083; c=relaxed/simple;
	bh=s5tcFmNwZFA1J3xK6oZv5nXPDgKWwFFvPtkhIoxLZOw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gy1BmjNpUpFJ2CYL98W/OCIS/tMAY8FFgGWToG+34pJBxGHBrAKN5ujiuKQxfRHKC4enEmWhCAYkVfvdGP9TDrvpCjeb7L7x08/kiq7xk6pJG/In0RfFKzCGC+5puGsIGJmkvmG9iGmS+v5cJBH3q72ilhpJB/+SCgqQNDPmAag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id AAB6F20B7166; Sun,  9 Aug 2026 12:00:53 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AAB6F20B7166
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
Subject: [PATCH net v5 0/7] net: mana: HW channel reliability and hardening fixes
Date: Sun,  9 Aug 2026 12:00:34 -0700
Message-ID: <20260809190047.2086368-1-longli@microsoft.com>
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

Changes since v4:

 - No code changes.  Resending as a standalone thread; v4 was
   accidentally sent in-reply-to the v3 thread.
 - v4: https://lore.kernel.org/netdev/20260808023417.1746886-1-longli@microsoft.com/
 - v3: https://lore.kernel.org/netdev/20260803234355.636038-1-longli@microsoft.com/

Changes since v3:

Addressed the netdev-ai and sashiko.dev automated reviews of v3.

 - New patch 7 ("keep max_num_cqs immutable once cq_table is
   allocated"): gc->max_num_cqs is set once and never reset, so a
   spoofed post-init HWC event cannot inflate the bound past the
   allocation and cause an out-of-bounds cq_table access.
 - patch 1: replaced the per-CQ synchronize_rcu() in the netdev teardown
   paths with a two-pass quiesce/free that takes a single grace period
   per teardown; snapshot cq->id and max_num_cqs with READ_ONCE() so the
   same value sizes, bounds and indexes cq_table; corrected the
   gc->cq_table lifetime comment; rescoped the changelog to the
   use-after-free fix.
 - patch 2: reworded the changelog as a latent-correctness fix (both
   message sizes are 0x1000, so the swap has no observable overflow) and
   dropped the incorrect note about hoisting the queue dimensions.
 - patch 4: removed the short-response early return so a malformed
   response reaches verify_resp_msg() -> -EPROTO and completes the
   sender instead of hanging it; account leaked RX WQEs and trip
   hwc_timeout on RQ exhaustion; read the device-supplied
   inline_oob_size_div4 (through its u32 flags word, as it is a
   bit-field) and sge->address with READ_ONCE() and reject any value
   other than the one the driver programs; reframed the msg_id check as
   defense in depth.
 - patch 5: arm setup_active immediately after mana_smc_setup_hwc()
   succeeds; destroy the EQ (IRQ deregister + drain) before the CQ; drop
   the redundant teardown in mana_hwc_establish_channel() that caused a
   double hardware timeout and masked the original error.
 - patch 6: take both the sender and response-side references up front in
   mana_hwc_get_msg_index() (refcount initialised to 2, under the lock
   that publishes the slot) so an early/stale/forged response cannot free
   the slot before the sender posts; changed caller_ctx::error from u32
   to int; reject a zero firmware-supplied HWC timeout in the query path
   as well as the reconfig path; access hwc_timed_out with READ_ONCE()/
   WRITE_ONCE(); comment and changelog fixes.
 - Assorted comment and commit-message clarifications throughout.

Changes since v2:

 - Per maintainer feedback, split the original combined series: the
   fixes here target 'net'; the two feature patches now go to 'net-next'
   and are sent separately (see above).  Rebased the fixes onto net.
 - Dropped the pcie_flr()-based reset fallback from the teardown path.
   pcie_flr() resets device config without the save/restore that
   pci_reset_function() provides, and cannot be used as a drop-in here.
   On an unrecoverable teardown failure the driver now leaks the HWC
   resources instead of touching memory the device may still DMA into.
 - patch 2: store the HWC queue dimensions before creating the CQ so the
   RX completion handler can never observe a zero max_resp_msg_size
   divisor or a stale num_inflight_msg bound.
 - Assorted commit-message and comment clarifications.

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

 drivers/infiniband/hw/mana/cq.c               |  46 +-
 .../net/ethernet/microsoft/mana/gdma_main.c   |  48 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 452 +++++++++++++++---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 136 ++++--
 include/net/mana/gdma.h                       |  40 +-
 include/net/mana/hw_channel.h                 |  44 +-
 6 files changed, 652 insertions(+), 114 deletions(-)


base-commit: dd057113ac7ba5bdd2aed3d9405305911152f911
-- 
2.43.0

