Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EA19314A9E;
	Tue,  8 Sep 2026 03:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788839565; cv=none; b=CYou6MptbQr1N+4dknS0iFjHc9L4mWB4WJraLs6r8MNn/xuFRMvbJ6DPYSdgWmiPnu52WRC9R71WShK3KcL7aspejacQTY5J4RxA4cyIIHKAjQVRFyGnd+vwPLT2fWaa6ruV9AsNdPcO/VmpnStyynAOF7AeJ5lbY7/YKPq/O1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788839565; c=relaxed/simple;
	bh=tNM9k4wL7LDX/cy1e0ADPnamNjVN5oQ4REEUdBzChrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8VZLCRZHizx97q9lYZkFYFC8bI/r6f+mayGS4dQaYSABMYVj1g7SVw5Xqcz9JnezsVpGPSwZgopaNxNRzRuOkhWvgUl3Xe/oRXrn/kjFr+knCbINOIT0SR7Uc8BK1r8Iz1Xtl9ucbC1MOqzqIYe0S+L3sQphqUDTRsZZbftm3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 9605820B7128; Mon,  7 Sep 2026 20:52:04 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9605820B7128
From: Long Li <longli@microsoft.com>
To: Long Li <longli@microsoft.com>,
	Long Li <longli@kernel.org>,
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
Subject: [PATCH net-next v5 1/4] net: mana: track when the HWC has been handed to the PF
Date: Mon,  7 Sep 2026 20:51:55 -0700
Message-ID: <20260908035201.402424-2-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260908035201.402424-1-longli@microsoft.com>
References: <20260908035201.402424-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Track possible PF queue ownership with setup_active for HWC reinit.
Set it before submitting ESTABLISH_HWC. Cleanup now attempts DESTROY_HWC
after submitted setup failures even before MAX_NUM_CQS arrives, adding
potentially tens of seconds of polling. Resources are still freed if
teardown fails.

Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v5 (v4 -> v5):
 - Describe additional teardown attempts and polling after setup failure.
 - Clarify the flag's context lifetime and setup precondition.
 - Shorten comments; no executable changes from v4.

Changes in v4 (standalone net-next rework after the v3 split):
 - Introduce this dedicated handover-tracking preparation patch.
 - Set the submission flag inside mana_smc_setup_hwc() and use it as the
   cleanup gate, including setup failures before MAX_NUM_CQS arrives.
 - Do not carry the separate net series' teardown-failure resource retention.

Changes in v3 (historical net fixes-only posting):
 - Handover tracking remained in the teardown-safety patch (5/6).
 - That patch dropped pcie_flr() recovery and retained resources after
   failed teardown. Those changes are not part of this preparation patch.

Changes in v2 (v1 -> v2):
 - Handover tracking remained part of teardown-safety patch 5/7.
 - No separate preparation patch was posted.

v1:
 - The combined series introduced setup_active in teardown-safety patch 5/7.

 drivers/net/ethernet/microsoft/mana/hw_channel.c  | 14 +++++++-------
 drivers/net/ethernet/microsoft/mana/shm_channel.c |  8 +++++++-
 include/net/mana/hw_channel.h                     |  3 +++
 include/net/mana/shm_channel.h                    |  2 +-
 4 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 263e7c4e2934186af037be4c80350a6e322b6771..88e92e94e2e90ff31ca6710a7e9b8e34b5fa191c 100644
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
 
@@ -815,13 +815,13 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	if (!hwc)
 		return;
 
-	/* gc->max_num_cqs is set in mana_hwc_init_event_handler(). If it's
-	 * non-zero, the HWC worked and we should tear down the HWC here.
-	 */
-	if (gc->max_num_cqs > 0) {
-		mana_smc_teardown_hwc(&gc->shm_channel, false);
-		gc->max_num_cqs = 0;
+	if (hwc->setup_active) {
+		if (!mana_smc_teardown_hwc(&gc->shm_channel, false))
+			hwc->setup_active = false;
+		else
+			dev_err(hwc->dev, "Failed to tear down HWC\n");
 	}
+	gc->max_num_cqs = 0;
 
 	if (hwc->txq)
 		mana_hwc_destroy_wq(hwc, hwc->txq);
diff --git a/drivers/net/ethernet/microsoft/mana/shm_channel.c b/drivers/net/ethernet/microsoft/mana/shm_channel.c
index d21b5db06e5092d82249fb1053d07f65aa38490c..3cf6a9f8e32c4ff5e5423fc950e88082941e21a8 100644
--- a/drivers/net/ethernet/microsoft/mana/shm_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/shm_channel.c
@@ -129,9 +129,12 @@ void mana_smc_init(struct shm_channel *sc, struct device *dev,
 	sc->base = base;
 }
 
+/* Requires no outstanding HWC handover. *submitted records possible PF
+ * ownership, including when setup fails after submission.
+ */
 int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
 		       u64 cq_addr, u64 rq_addr, u64 sq_addr,
-		       u32 eq_msix_index)
+		       u32 eq_msix_index, bool *submitted)
 {
 	union smc_proto_hdr *hdr;
 	u16 all_addr_h4bits = 0;
@@ -144,6 +147,8 @@ int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
 	int err;
 	int i;
 
+	*submitted = false;
+
 	/* Ensure VF already has possession of shared memory */
 	err = mana_smc_poll_register(sc->base, false);
 	if (err) {
@@ -229,6 +234,7 @@ int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
 	/* Write 256-message buffer to shared memory (final 32-bit write
 	 * triggers HW to set possession bit to PF).
 	 */
+	*submitted = true;
 	dword = (u32 *)shm_buf;
 	for (i = 0; i < SMC_APERTURE_DWORDS; i++)
 		writel(*dword++, sc->base + i * SMC_BASIC_UNIT);
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index 16feb39616c1bead1a043b3fadc2e18a90651516..befa09674ce5614a955441e75e480a21aa8695fb 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -199,6 +199,9 @@ struct hw_channel_context {
 	u32 pf_dest_vrcq_id;
 	u32 hwc_timeout;
 
+	/* PF may own the queue mappings; state lasts only for this context. */
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
