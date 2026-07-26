Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C1A37C92F;
	Sun, 26 Jul 2026 08:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785056304; cv=none; b=sRlKq/U6P1jBzVfF/8c0CPKMCrazpLsHc0FOCTvJ3Mb90vKFpjvwiOTBTJMjIZ9yAVem3/TiqhJN6/MzeF+k7zkAYlb/k7gqkDLBrK1D0YFeHInh4+F1nN7j4KOZO3d8Dn3leLEc4Nv0mIG2RDDacJ6r00A6m8AEtu4Q39enD5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785056304; c=relaxed/simple;
	bh=nx2kJQnJtSXzY0x1OM7ISTHEHq9sgRuggHJmofLPOxo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ItEsmjNBcCpqUdpmcUbaEgk019CY6/5kvroPvvC5PI+raiWKA4rtL9dRSzrFU5CxXUhva0RRXf8/5Yp0uYMs9mqq+Smwr68ZzIdUM1qSC+7MaZj/4LLzGp7KwJHaIyp3oE1cqoO1uw6NIOsg7RfIKpQotdQxO7mtzl/51iEQ5Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lA8jjS9j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lA8jjS9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306C71F000E9;
	Sun, 26 Jul 2026 08:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785056303;
	bh=3bQqF91LRx1WLrDmFYfH+Du/8JsMxE44yaerb+VSGLU=;
	h=From:To:Cc:Subject:Date;
	b=lA8jjS9jcsSTOjCupoSoMJkkpsEOXTwOY3ekuC9m1nXQ6atE9+w1UkcRmZjbM15lH
	 RTzatBBzm+N5x73qxWaxDbLVKgq5SLoGG0FXf6xx3L1NeWkRTBplh5NkAyWAQqKLPP
	 SLkOnFl5a0FHl25uUtR606sYaY8+7B92qtQ5VHxp0V98VBL1qvM2Uv3CYCkv2fyr+T
	 3ivv9lbHsmyCsqJZ11l4A2Das/IBkh2kDpSs/2cwGlUR3afI4z78vCWG86FLY1/Ai0
	 7E2cfHDNumx8nkpCvsbpKde+42+cPjODVWa5PqH0Jbbmzxl5XJdrT3DZAvIh0Pqzl1
	 oHK0YOZGtHx7Q==
From: Leon Romanovsky <leon@kernel.org>
To: Potnuri Bharat Teja <bharat@chelsio.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Doug Ledford <dledford@redhat.com>,
	Hariprasad S <hariprasad@chelsio.com>,
	Steve Wise <larrystevenwise@gmail.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/cxgb4: Fix dereg_skb leak and double free in write_tpt_entry()
Date: Sun, 26 Jul 2026 11:58:08 +0300
Message-ID: <20260726-leaked-mhp-dereg-skb-in-c4iw-dereg-m-v1-1-ebd6df364d53@nvidia.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260726-leaked-mhp-dereg-skb-in-c4iw-dereg-m-e76503c672a0
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

When the device is in the fatal error state, write_tpt_entry() returns -EIO
before handing the caller's preallocated skb to the transmit path; its
allocation-failure returns do the same. c4iw_dereg_mr() ignores the error
and frees mhp, leaking mhp->dereg_skb. c4iw_get_dma_mr() instead frees the
skb a second time after dereg_mem() already consumed it, a double free.

Make write_tpt_entry() the sole owner of a non-NULL skb, freeing it on
every return preceding handoff to c4iw_ofld_send(): fatal error, tpt and
stag allocation failure. c4iw_ofld_send() consumes the skb on success and
error alike, so drop the redundant kfree_skb() in c4iw_get_dma_mr() after
dereg_mem().

Fixes: 0f8ab0b6e91b ("RDMA/iw_cxgb4: Low resource fixes for Memory registration")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/cxgb4/mem.c | 46 +++++++++++++++------------------------
 1 file changed, 17 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 49498c75f38f..12d0c7be8df8 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -199,7 +199,8 @@ static int _c4iw_write_mem_dma(struct c4iw_rdev *rdev, u32 addr, u32 len,
 
 	daddr = dma_map_single(&rdev->lldi.pdev->dev, data, len, DMA_TO_DEVICE);
 	if (dma_mapping_error(&rdev->lldi.pdev->dev, daddr))
-		return -1;
+		return _c4iw_write_mem_inline(rdev, addr, len, data, skb,
+					      wr_waitp);
 	save = daddr;
 
 	while (remain > inline_threshold) {
@@ -235,30 +236,12 @@ static int write_adapter_mem(struct c4iw_rdev *rdev, u32 addr, u32 len,
 			     void *data, struct sk_buff *skb,
 			     struct c4iw_wr_wait *wr_waitp)
 {
-	int ret;
-
-	if (!rdev->lldi.ulptx_memwrite_dsgl || !use_dsgl) {
-		ret = _c4iw_write_mem_inline(rdev, addr, len, data, skb,
-					      wr_waitp);
-		goto out;
-	}
-
-	if (len <= inline_threshold) {
-		ret = _c4iw_write_mem_inline(rdev, addr, len, data, skb,
+	if (!rdev->lldi.ulptx_memwrite_dsgl || !use_dsgl ||
+	    len <= inline_threshold)
+		return _c4iw_write_mem_inline(rdev, addr, len, data, skb,
 					      wr_waitp);
-		goto out;
-	}
-
-	ret = _c4iw_write_mem_dma(rdev, addr, len, data, skb, wr_waitp);
-	if (ret) {
-		pr_warn_ratelimited("%s: dma map failure (non fatal)\n",
-				    pci_name(rdev->lldi.pdev));
-		ret = _c4iw_write_mem_inline(rdev, addr, len, data, skb,
-					      wr_waitp);
-	}
-out:
-	return ret;
 
+	return _c4iw_write_mem_dma(rdev, addr, len, data, skb, wr_waitp);
 }
 
 /*
@@ -279,12 +262,16 @@ static int write_tpt_entry(struct c4iw_rdev *rdev, u32 reset_tpt_entry,
 	u32 stag_idx;
 	static atomic_t key;
 
-	if (c4iw_fatal_error(rdev))
+	if (c4iw_fatal_error(rdev)) {
+		kfree_skb(skb);
 		return -EIO;
+	}
 
 	tpt = kmalloc_obj(*tpt);
-	if (!tpt)
+	if (!tpt) {
+		kfree_skb(skb);
 		return -ENOMEM;
+	}
 
 	stag_state = stag_state > 0;
 	stag_idx = (*stag) >> 8;
@@ -296,6 +283,7 @@ static int write_tpt_entry(struct c4iw_rdev *rdev, u32 reset_tpt_entry,
 			rdev->stats.stag.fail++;
 			mutex_unlock(&rdev->stats.lock);
 			kfree(tpt);
+			kfree_skb(skb);
 			return -ENOMEM;
 		}
 		mutex_lock(&rdev->stats.lock);
@@ -469,8 +457,10 @@ struct ib_mr *c4iw_get_dma_mr(struct ib_pd *pd, int acc)
 			      FW_RI_STAG_NSMR, mhp->attr.perms,
 			      mhp->attr.mw_bind_enable, 0, 0, ~0ULL, 0, 0, 0,
 			      NULL, mhp->wr_waitp);
-	if (ret)
-		goto err_free_skb;
+	if (ret) {
+		kfree_skb(mhp->dereg_skb);
+		goto err_free_wr_wait;
+	}
 
 	ret = finish_mem_reg(mhp, stag);
 	if (ret)
@@ -479,8 +469,6 @@ struct ib_mr *c4iw_get_dma_mr(struct ib_pd *pd, int acc)
 err_dereg_mem:
 	dereg_mem(&rhp->rdev, mhp->attr.stag, mhp->attr.pbl_size,
 		  mhp->attr.pbl_addr, mhp->dereg_skb, mhp->wr_waitp);
-err_free_skb:
-	kfree_skb(mhp->dereg_skb);
 err_free_wr_wait:
 	c4iw_put_wr_wait(mhp->wr_waitp);
 err_free_mhp:

---
base-commit: aac287f4f1ebebc85f36c0680bcf955ef9145c66
change-id: 20260726-leaked-mhp-dereg-skb-in-c4iw-dereg-m-e76503c672a0

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>

