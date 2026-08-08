Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1B3933F5A9;
	Sat,  8 Aug 2026 02:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786156488; cv=none; b=cc8Xb1fN53lH/4PYWSAkVjkQyCx0Km6IHvyzqJ2CwiCGbdZuXvBM3X14dfIosh1vR8MhXx/EpqguZbmN7ejArUh24xZg3V8i9rUH5ngU59P826jxvHuLAPgJ5luRnqWblBQPRBh5YDRaORlrpGlqhL9OBTy66dvNsHAecRI8h+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786156488; c=relaxed/simple;
	bh=c7qygQZOBl//SCGFWBEFO24TkNKXv4J0YKCqwcm0m4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O0kMqKHHxB5rbMIpTM6evAEA9velTZPoecT9T+5nnoeOh50MwoiYkqVuzsfiIviMejS33Vh1jNXTZpD5x3fpDOAgFvd9jQMSUIqXM7WPmUiV9IF1OVw/Qy/nckmY3cISqB7LVmcfT4BZlhSZCZ35C4X/EjJB71MudtfNJSm0fr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 0AEFE20B7129; Fri,  7 Aug 2026 19:34:25 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0AEFE20B7129
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
	stephen@networkplumber.org,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Kees Cook <kees@kernel.org>,
	Shachar Raindel <shacharr@microsoft.com>
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v4 5/7] net: mana: fix HWC teardown safety with setup_active flag and destroy ordering
Date: Fri,  7 Aug 2026 19:34:14 -0700
Message-ID: <20260808023417.1746886-6-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260803234355.636038-1-longli@microsoft.com>
References: <20260803234355.636038-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Three teardown hazards let the hardware touch memory the driver freed.

First, once mana_smc_setup_hwc() succeeds the device has active MST
entries and can DMA into the HWC queue buffers.  If a later step in
mana_hwc_establish_channel() fails, the caller had no reliable way to
know teardown was required and could free those buffers while the
mappings were still live -- a DMA-after-free.  max_num_cqs was used as a
"HWC is up" proxy, but it is only set when the init EQE arrives.

Add a setup_active flag, set the moment setup_hwc activates MST entries.
On a later failure establish_channel() just returns the error; the
caller's error path (mana_hwc_create_channel() -> destroy_channel())
performs the single teardown, gated on setup_active.  Tearing down inline
as well would run teardown twice -- doubling the 60s hardware timeout on
failure and masking the original error code.  max_num_cqs is no longer
reset: it is an immutable bound (see gdma.h) and cq_table == NULL is the
sole teardown signal.

Second, destroy_channel() freed the TXQ/RXQ buffers while the HWC EQ was
still on the interrupt dispatch list, so an in-flight interrupt could run
the handler against freed buffers:

  CPU A (mana_gd_intr, hard IRQ)        CPU B (destroy_channel)
  ----------------------------------    ------------------------------
                                        free TXQ/RXQ DMA buffers
  handler accesses RQ/TXQ buffers       (EQ still registered)

Destroy the CQ first: mana_hwc_destroy_cq() -> mana_gd_deregister_irq()
removes the EQ via list_del_rcu() + synchronize_rcu(), after which no
handler can reach the queues; only then free the TXQ and RXQ.

Third, if mana_smc_teardown_hwc() itself fails the MST entries stay
live, yet destroy_channel() went on to free the CQ/RQ/TXQ buffers the
device can still DMA into -- a DMA-after-free on systems without an
IOMMU to fault the stale access.  Leak the HWC resources on teardown
failure instead of freeing memory the hardware can still reach, and
keep setup_active set so the failure is not mistaken for a clean
teardown.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v4:
 - Arm setup_active immediately after mana_smc_setup_hwc() succeeds.
 - Destroy the EQ (IRQ deregister + drain) before the CQ.
 - Dropped the redundant teardown in mana_hwc_establish_channel() that
   caused a double hardware timeout and masked the original error code.

 .../net/ethernet/microsoft/mana/hw_channel.c  | 56 ++++++++++++++-----
 include/net/mana/gdma.h                       |  8 ++-
 include/net/mana/hw_channel.h                 |  9 +++
 3 files changed, 57 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 5db8cfe2d844..adc7ad98ca8d 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -4,6 +4,7 @@
 #include <net/mana/gdma.h>
 #include <net/mana/mana.h>
 #include <net/mana/hw_channel.h>
+#include <linux/pci.h>
 #include <linux/vmalloc.h>
 
 static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
@@ -792,6 +793,15 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	if (err)
 		return err;
 
+	/* setup_hwc activated MST entries — hardware can now DMA into our
+	 * queue buffers.  Record that in setup_active so the caller's error
+	 * path (mana_hwc_create_channel() -> mana_hwc_destroy_channel())
+	 * tears the HWC down exactly once.  Do not also tear down here: a
+	 * second teardown would double the hardware timeout on failure and
+	 * mask the original error code.
+	 */
+	hwc->setup_active = true;
+
 	if (!wait_for_completion_timeout(&hwc->hwc_init_eqe_comp, 60 * HZ))
 		return -ETIMEDOUT;
 
@@ -926,11 +936,38 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	if (!hwc)
 		return;
 
-	/* gc->max_num_cqs is set in mana_hwc_init_event_handler(). If it's
-	 * non-zero, the HWC worked and we should tear down the HWC here.
+	/* Tear down the HWC if setup_hwc previously activated MST entries.
+	 * This is the definitive flag — unlike max_num_cqs which depends
+	 * on the init EQE arriving.
+	 *
+	 * If teardown fails the device may still have active MST entries
+	 * and can DMA into the HWC queue buffers.  Freeing them would risk
+	 * memory corruption on systems without an IOMMU to fault the stale
+	 * DMA, so leak the HWC resources instead of handing the pages back
+	 * to the allocator.  Keep setup_active set so the failure is not
+	 * mistaken for a clean teardown.
+	 */
+	if (hwc->setup_active) {
+		int td_err = mana_smc_teardown_hwc(&gc->shm_channel, false);
+
+		if (td_err) {
+			dev_err(gc->dev,
+				"HWC teardown failed: %d, leaking resources\n",
+				td_err);
+			return;
+		}
+
+		hwc->setup_active = false;
+	}
+
+	/* Tear down the HWC CQ object first — mana_hwc_destroy_cq()
+	 * both unpublishes the CQ from cq_table (+synchronize_rcu) and
+	 * deregisters the HWC EQ from the interrupt handler list (via
+	 * mana_gd_deregister_irq + synchronize_rcu), guaranteeing no
+	 * interrupt handler can access RQ/TXQ buffers after this point.
 	 */
-	if (gc->max_num_cqs > 0)
-		mana_smc_teardown_hwc(&gc->shm_channel, false);
+	if (hwc->cq)
+		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
 
 	if (hwc->txq)
 		mana_hwc_destroy_wq(hwc, hwc->txq);
@@ -938,17 +975,6 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	if (hwc->rxq)
 		mana_hwc_destroy_wq(hwc, hwc->rxq);
 
-	if (hwc->cq)
-		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
-
-	/* Reset only after mana_hwc_destroy_cq() above has run with a valid
-	 * max_num_cqs so mana_gd_destroy_cq() clears the CQ table slot and
-	 * waits out in-flight EQ handlers (synchronize_rcu) before the CQ is
-	 * freed.  Clearing it earlier would make that path early-return and
-	 * skip the slot clear, leaving a dangling cq_table entry.
-	 */
-	gc->max_num_cqs = 0;
-
 	kfree(hwc->caller_ctx);
 	hwc->caller_ctx = NULL;
 
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index b8b1b23f3c36..e59b8b31e834 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -416,7 +416,13 @@ struct gdma_context {
 	/* L2 MTU */
 	u16 adapter_mtu;
 
-	/* This maps a CQ index to the queue structure. */
+	/* Size of cq_table, i.e. the largest valid CQ index + 1.  Set once
+	 * when cq_table is allocated and treated as immutable for the
+	 * table's lifetime (a bound only) -- it is never reset on teardown.
+	 * cq_table == NULL is the sole "table torn down" signal, so every
+	 * cq_table[id] access must guard with both !cq_table (gone) and
+	 * id >= max_num_cqs (out of bounds).
+	 */
 	unsigned int		max_num_cqs;
 	/* Both the base pointer and each entry are RCU-managed.  The fast
 	 * path (mana_gd_process_eqe) reads the base via rcu_dereference()
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index 787c6f96d5b5..8340abd36af6 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -206,6 +206,15 @@ struct hw_channel_context {
 	 */
 	u32 rx_leaked_wqe;
 
+	/* Set after mana_smc_setup_hwc() succeeds (hardware has active
+	 * MST entries).  Cleared only after mana_smc_teardown_hwc()
+	 * succeeds, on both the recoverable establish_channel path and the
+	 * terminal destroy_channel path.  If teardown fails it stays set:
+	 * establish_channel() skips its retry and destroy_channel() leaks
+	 * the HWC rather than free buffers the device may still DMA into.
+	 */
+	bool setup_active;
+
 	struct hwc_caller_ctx *caller_ctx;
 };
 
-- 
2.43.0

