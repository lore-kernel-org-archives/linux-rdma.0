Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E12A1456287;
	Tue,  1 Sep 2026 20:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788292870; cv=none; b=c0dKtKc6mBE5M2chw6JPG+xXQhy1LGSO3U5KfmPV4hEhHtN3HYse0kdzwlS7VZ8d0JKdeO3wE5BzwMg7+ZM9kB5db+Gxo9h+BXaOzw15vEBb/KjY2ayRxVzyYiHuKEcGcsi+bzgYiVpJ+4XldufqyI6UEEfQys/p0yfEY8zg2FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788292870; c=relaxed/simple;
	bh=ElS9DrRAwwiwAl3q4Y0dApLvw1rnwM5H5FcKt3bTiEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJZZHrNtwTzP1ckoIh1wJxHc8E82VrW1zUVYW8xh5+Qfq+DiinsICzQ/vn1B6eGhL3+mHqd/UjrTvcuL4xs/Cf0kP3D/h75NfQpRIiMG/qg2kwuV7oEvIO6sVgBevBItEbsoDF/kUlQTw4bWpW+g7Rdt+DoKNozD5crfsOstqvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id B3ABC20B7166; Tue,  1 Sep 2026 13:00:32 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B3ABC20B7166
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
	shirazsaleem@microsoft.com
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4 1/4] net: mana: track when the HWC has been handed to the PF
Date: Tue,  1 Sep 2026 13:00:13 -0700
Message-ID: <20260901200018.3194525-2-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901200018.3194525-1-longli@microsoft.com>
References: <20260901200018.3194525-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mana_hwc_destroy_channel() decides whether to tear the channel down by
looking at gc->max_num_cqs, which is only set when the device delivers an
HWC_INIT_DATA_MAX_NUM_CQS bootstrap event.  That is a proxy for "the
device is using the queues", and it is a poor one: the event arrives well
after mana_smc_setup_hwc() has already handed the queue addresses to the
PF, so a setup that fails in between leaves no reliable signal.

Record the handover directly instead.  mana_smc_setup_hwc() clears the
new setup_active flag on entry and sets it immediately before it writes
the ESTABLISH_HWC message, so the flag is exact in both directions: the
three exits before that write leave the device untouched and clear the
flag, while everything after it -- including a failed response -- leaves
it set, because the PF has the queue addresses either way.

No functional change is intended for the current single-establish flow.
This is preparation for the reinit path added later in this series, which
tears the channel down and rebuilds it at a larger queue depth and needs
to know whether a given attempt left the device holding the queues.

Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/hw_channel.c  | 19 +++++++++++++------
 .../net/ethernet/microsoft/mana/shm_channel.c | 11 ++++++++++-
 include/net/mana/hw_channel.h                 | 10 ++++++++++
 include/net/mana/shm_channel.h                |  2 +-
 4 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 263e7c4e2934186af037be4c80350a6e322b6771..75fdccdc8c48201b011a243fd0bd41b84c477076 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -683,7 +683,7 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 				 cq->mem_info.dma_handle,
 				 rq->mem_info.dma_handle,
 				 sq->mem_info.dma_handle,
-				 eq->eq.msix_index);
+				 eq->eq.msix_index, &hwc->setup_active);
 	if (err)
 		return err;
 
@@ -815,13 +815,20 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	if (!hwc)
 		return;
 
-	/* gc->max_num_cqs is set in mana_hwc_init_event_handler(). If it's
-	 * non-zero, the HWC worked and we should tear down the HWC here.
+	/* Tear down only if setup_hwc() handed the queues to the PF.  Until
+	 * then the device never saw them, so there is nothing to undo.
 	 */
-	if (gc->max_num_cqs > 0) {
-		mana_smc_teardown_hwc(&gc->shm_channel, false);
-		gc->max_num_cqs = 0;
+	if (hwc->setup_active) {
+		/* Only a successful teardown invalidates the MST entries.  If
+		 * it fails the device may still be using the queues, so leave
+		 * the flag set rather than record a clean teardown.
+		 */
+		if (!mana_smc_teardown_hwc(&gc->shm_channel, false))
+			hwc->setup_active = false;
+		else
+			dev_err(hwc->dev, "Failed to tear down HWC\n");
 	}
+	gc->max_num_cqs = 0;
 
 	if (hwc->txq)
 		mana_hwc_destroy_wq(hwc, hwc->txq);
diff --git a/drivers/net/ethernet/microsoft/mana/shm_channel.c b/drivers/net/ethernet/microsoft/mana/shm_channel.c
index d21b5db06e5092d82249fb1053d07f65aa38490c..1ec8e3661721dc8663975477b7ed09fcda72e2ab 100644
--- a/drivers/net/ethernet/microsoft/mana/shm_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/shm_channel.c
@@ -129,9 +129,15 @@ void mana_smc_init(struct shm_channel *sc, struct device *dev,
 	sc->base = base;
 }
 
+/* Clear *submitted on entry and set it once the ESTABLISH_HWC message has
+ * been handed to the PF, i.e. once the device may start using the queues.
+ * The caller uses it to decide whether a failure still needs
+ * mana_smc_teardown_hwc(): the exits below leave the device untouched, so
+ * they must not require one.
+ */
 int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
 		       u64 cq_addr, u64 rq_addr, u64 sq_addr,
-		       u32 eq_msix_index)
+		       u32 eq_msix_index, bool *submitted)
 {
 	union smc_proto_hdr *hdr;
 	u16 all_addr_h4bits = 0;
@@ -144,6 +150,8 @@ int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
 	int err;
 	int i;
 
+	*submitted = false;
+
 	/* Ensure VF already has possession of shared memory */
 	err = mana_smc_poll_register(sc->base, false);
 	if (err) {
@@ -229,6 +237,7 @@ int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
 	/* Write 256-message buffer to shared memory (final 32-bit write
 	 * triggers HW to set possession bit to PF).
 	 */
+	*submitted = true;
 	dword = (u32 *)shm_buf;
 	for (i = 0; i < SMC_APERTURE_DWORDS; i++)
 		writel(*dword++, sc->base + i * SMC_BASIC_UNIT);
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index 16feb39616c1bead1a043b3fadc2e18a90651516..237608b488e5ee773d7889d3c1d291ca92ebbeb9 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -199,6 +199,16 @@ struct hw_channel_context {
 	u32 pf_dest_vrcq_id;
 	u32 hwc_timeout;
 
+	/* True once mana_smc_setup_hwc() has handed the ESTABLISH_HWC message
+	 * to the PF, so the device may DMA into the HWC buffers.  That
+	 * function clears it on entry and sets it at the handover, so only a
+	 * failure before the handover leaves it false; a failure after it --
+	 * including one reported by mana_hwc_establish_channel() -- leaves it
+	 * set, which is what makes teardown attempt DESTROY_HWC.  Cleared
+	 * again once that teardown succeeds.
+	 */
+	bool setup_active;
+
 	struct hwc_caller_ctx *caller_ctx;
 };
 
diff --git a/include/net/mana/shm_channel.h b/include/net/mana/shm_channel.h
index dbabcfb95daf3e87b39a657e3a5f23a1508d4f31..e96387d795259d52aeec7b3fe0981825d90a3822 100644
--- a/include/net/mana/shm_channel.h
+++ b/include/net/mana/shm_channel.h
@@ -20,7 +20,7 @@ void mana_smc_init(struct shm_channel *sc, struct device *dev,
 
 int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
 		       u64 cq_addr, u64 rq_addr, u64 sq_addr,
-		       u32 eq_msix_index);
+		       u32 eq_msix_index, bool *submitted);
 
 int mana_smc_teardown_hwc(struct shm_channel *sc, bool reset_vf);
 
-- 
2.43.0

