Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3292857C7;
	Wed, 22 Jul 2026 13:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784726045; cv=none; b=N3BW5iARspzMvQtQf2G0/uGPd1gyEKzpcUOnz26t1nQwIvqYeQV2ZuYiA0Wr4t78BHo12tIE3II4TFnQwmKVa25GjiiR06FLNlusmKBSUWS2lsT4pr99bE0hwwyzfCvaulGAEu2kwUOsw9fzle2x2ArXT8R72vNl3PnUMc6YB6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784726045; c=relaxed/simple;
	bh=Ob17yG1xkr5dPMhT671GPZMXhM0VNKCfV6oGg/SiC7E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kw8c2uG5zQGId+3bfnimJtCX49Qvl4pBBiV//rrvwNuXd24Tj/UuqvAnXN4dsrFXARD5jhExcO9N3/yVvIpNNTpLBgtuVTOBv3ju6+gubiA4ZPcjs4KvKV5+eLV6kXpIdsjnpVFGpJGyXftfIGUReDqV/5TBXXiSS1s70hudCXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+yvK9Ut; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+yvK9Ut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E93C1F000E9;
	Wed, 22 Jul 2026 13:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784726044;
	bh=xEPgGbnBjzp8WR2Q7VfOrN2B21IJMZwbiSHBUz7mmr4=;
	h=From:To:Cc:Subject:Date;
	b=a+yvK9Ut1LuXR+pW8Rozd6P/cTSz/btFRYSCPZ0ukVFfGmI5qOU6Sy1Wh6PmtQec3
	 oawgbtXR61FSCazxiPq116fsTPmOKweCHnr/+Hf/kSAlr2yltBs2CYu/7DKZBVPfLR
	 lt3SeTAC4Kc9LLKGeONOEUwDZ47xFhsZxtqQch9/TUCgD5qdZGmnLjJmrgS7prWD+L
	 2dlYdB/CFADFP+imD+hVlkObeyavloCWHvsboQ6hKak0ws+XQ9+30Y2gHQCOO18Izb
	 pwwvAftzB5DSimWmWBwIcOBfPS/VDOfDZhKKo+JAyIyRX+bXxQCqRb1acUnK3e8jD1
	 DZEYKXlBb4SeA==
From: Leon Romanovsky <leon@kernel.org>
To: Cheng Xu <chengyou@linux.alibaba.com>,
	Kai Shen <kaishen@linux.alibaba.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Wei Yongjun <weiyongjun1@huawei.com>,
	Yang Li <yang.lee@linux.alibaba.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/erdma: complete object teardown when the destroy command fails
Date: Wed, 22 Jul 2026 16:13:54 +0300
Message-ID: <20260722-b4-qp-and-cq-memory-are-leaked-if-the-d-v1-1-97e223dc1c96@nvidia.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260722-b4-qp-and-cq-memory-are-leaked-if-the-d-760a0f866319
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

erdma_destroy_qp(), erdma_destroy_cq(), erdma_dereg_mr(), and
erdma_destroy_ah() returned early when erdma_post_cmd_wait() failed,
leaking the queue buffers, MTTs, doorbells and the STAG, QPN, CQN and AHN
identifiers. A command timeout clears ERDMA_CMDQ_STATE_OK_BIT and
permanently disables the command queue, so no retry can succeed; the RDMA
core keeps the object after a failed destructor and forced uverbs cleanup
then nulls the pointers, making the resources unreachable.

Warn on failure but release every software-owned resource and return
success, since during terminal destruction the hardware command result is
only diagnostic.

Fixes: 155055771704 ("RDMA/erdma: Add verbs implementation")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/erdma/erdma_verbs.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index 71e3e8618a61..ab6abbab029e 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -1302,8 +1302,15 @@ int erdma_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 
 	ret = erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), NULL, NULL,
 				  true);
+	/*
+	 * A timeout disables the command queue, so retry cannot succeed.  Treat
+	 * terminal command failures as diagnostic; propagating them can make
+	 * forced uverbs cleanup discard the last software resource pointers.
+	 */
 	if (ret)
-		return ret;
+		ibdev_warn_ratelimited(&dev->ibdev,
+				       "failed to deregister MR 0x%x: %d\n",
+				       ibmr->lkey, ret);
 
 	erdma_free_idx(&dev->res_cb[ERDMA_RES_TYPE_STAG_IDX], ibmr->lkey >> 8);
 
@@ -1329,7 +1336,9 @@ int erdma_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 	err = erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), NULL, NULL,
 				  true);
 	if (err)
-		return err;
+		ibdev_warn_ratelimited(&dev->ibdev,
+				       "failed to destroy CQ %u: %d\n",
+				       cq->cqn, err);
 
 	if (rdma_is_kernel_res(&cq->ibcq.res)) {
 		dma_free_coherent(&dev->pdev->dev, cq->depth << CQE_SHIFT,
@@ -1377,7 +1386,9 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 	err = erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), NULL, NULL,
 				  true);
 	if (err)
-		return err;
+		ibdev_warn_ratelimited(&dev->ibdev,
+				       "failed to destroy QP %u: %d\n",
+				       QP_ID(qp), err);
 
 	erdma_qp_put(qp);
 	wait_for_completion(&qp->safe_free);
@@ -2279,7 +2290,9 @@ int erdma_destroy_ah(struct ib_ah *ibah, u32 flags)
 	ret = erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), NULL, NULL,
 				  flags & RDMA_DESTROY_AH_SLEEPABLE);
 	if (ret)
-		return ret;
+		ibdev_warn_ratelimited(&dev->ibdev,
+				       "failed to destroy AH %u: %d\n",
+				       ah->ahn, ret);
 
 	erdma_free_idx(&dev->res_cb[ERDMA_RES_TYPE_AH], ah->ahn);
 

---
base-commit: 0e8e94c15091041ea8910cbfcade5a9c7cfe3f90
change-id: 20260722-b4-qp-and-cq-memory-are-leaked-if-the-d-760a0f866319

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>

