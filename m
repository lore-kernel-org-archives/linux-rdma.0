Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94916357D08;
	Thu, 23 Jul 2026 02:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784774729; cv=none; b=ktFpgG+6jJ5ILBDxqOLVDoB1yfEHp80zyQrHC4KyBDkfJ3Eua/2QrWCDpIFIddFJkfJWTIntcsfVigkPMLm2lgHutCZwSzanbEhBxRQy/oYKFOcwdglFpYJ0C+y8nNd2wCwj9QqXTJ21Z2UqwQTy1GRkIq1GQ1arD9Hh44Hreig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784774729; c=relaxed/simple;
	bh=J6jQ7zBu/viuPvQacHxEydD+EkA58qhW6V3jaeFZlXU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tqonpUeslUPoJneR3naxGsfBW7WubG2GfmOQatsQPcQyBR2Hz4g70ClAxktcvaYD+enLwALW988n+RXxVWGPUAdSbJynl7fepb1ot+jIbdCg/LdOYWbtqkUrDzYnAcJ2wbuxTvMu6EqwjDrOUKX+ORe31ZOuEoPDnNYPoL36iws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=mVSxjyGE; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="mVSxjyGE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Xu
	EWYewah4fW/Db64f1Sn108X0PzQwb1Gf0myQQFsFM=; b=mVSxjyGEMcS50VIjMg
	MPVf3yIGD2S+CC7y+DhzSxnN+5maxItHL98uN0K+j8boBpcvQmN64j9SoFaEBknd
	rcKJ0dlNS+3VmasKwxFG5p3PvmsGmcc4Gj/MnqfbPXXVEPQc1y2wjKrYjnIcLVeU
	zritWoNtb6YNPfZ8VgV4Iou98=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgAHgLIqgGFqtmu4JA--.3978S2;
	Thu, 23 Jul 2026 10:44:59 +0800 (CST)
From: kensanya@163.com
To: bvanassche@acm.org,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	TanZheng <tanzheng@kylinos.cn>
Subject: [PATCH v2] RDMA/srpt: fix NULL deref when sending BUSY before target_init_cmd()
Date: Thu, 23 Jul 2026 10:44:56 +0800
Message-Id: <20260723024456.52851-1-kensanya@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgAHgLIqgGFqtmu4JA--.3978S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCF1xur47CF43Ar1DJF1rCrg_yoW5uryfpF
	W5W34jkFZ8JFW2ywsrGay7ArWay3y8Wr4jvryIq3s5Aa1Yyr9xGF13JryavFnrAF95uw1x
	Wrn0y3W5Kr4UGaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UMv35UUUUU=
X-CM-SenderInfo: 5nhq2txq1dqiywtou0bp/xtbC6gwe+WphgCyeSgAA3y

From: TanZheng <tanzheng@kylinos.cn>

If srpt_get_desc_tbl() fails, srpt_handle_cmd() jumps to
target_send_busy() before target_init_cmd() has set cmd->se_tfo.
target_send_busy() then dereferences a NULL se_tfo.

Call target_init_cmd() first with placeholder data_length and
data_direction, parse the descriptor table next, then fill in the
real data_length. That way target_send_busy() is safe if parsing
fails.

target_send_busy() is only valid after a successful target_init_cmd().
If target_init_cmd() itself fails, free the send ioctx tag locally
with target_free_tag() instead of calling target_send_busy().

Fixes: 8b8807b9e982 ("scsi: RDMA/srpt: Fix handling of command / TMF submission failure")
Link: https://lore.kernel.org/all/20260717025402.64054-1-kensanya@163.com/
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: TanZheng <tanzheng@kylinos.cn>
---
v2:
- On target_init_cmd() failure, use target_free_tag() instead of
  target_send_busy()

 drivers/infiniband/ulp/srpt/ib_srpt.c | 36 +++++++++++++++++++--------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index f66cfd70c263..71af1fb0d380 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1558,8 +1558,8 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
 	struct srp_cmd *srp_cmd;
 	struct scatterlist *sg = NULL;
 	unsigned sg_cnt = 0;
-	u64 data_len;
-	enum dma_data_direction dir;
+	u64 data_len = 0;
+	enum dma_data_direction dir = DMA_NONE;
 	int rc;
 
 	BUG_ON(!send_ioctx);
@@ -1584,6 +1584,25 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
 		break;
 	}
 
+	/*
+	 * Call target_init_cmd() before srpt_get_desc_tbl() so that
+	 * cmd->se_tfo is set if descriptor parsing fails and
+	 * target_send_busy() is used. data_length is filled in after a
+	 * successful srpt_get_desc_tbl().
+	 *
+	 * target_send_busy() is only valid after a successful
+	 * target_init_cmd(). On init failure free the tag locally.
+	 */
+	rc = target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
+			     scsilun_to_int(&srp_cmd->lun), 0 /* data_len */,
+			     TCM_SIMPLE_TAG, DMA_NONE, TARGET_SCF_ACK_KREF);
+	if (rc != 0) {
+		pr_debug("target_init_cmd() returned %d for tag %#llx\n", rc,
+			 srp_cmd->tag);
+		target_free_tag(ch->sess, cmd);
+		return;
+	}
+
 	rc = srpt_get_desc_tbl(recv_ioctx, send_ioctx, srp_cmd, &dir,
 			       &sg, &sg_cnt, &data_len, ch->imm_data_offset);
 	if (rc) {
@@ -1594,14 +1613,11 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
 		goto busy;
 	}
 
-	rc = target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
-			     scsilun_to_int(&srp_cmd->lun), data_len,
-			     TCM_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF);
-	if (rc != 0) {
-		pr_debug("target_submit_cmd() returned %d for tag %#llx\n", rc,
-			 srp_cmd->tag);
-		goto busy;
-	}
+	/*
+	 * Replace the placeholder length from target_init_cmd(). Direction
+	 * was already set inside srpt_get_desc_tbl() for srpt_alloc_rw_ctxs().
+	 */
+	cmd->data_length = data_len;
 
 	if (target_submit_prep(cmd, srp_cmd->cdb, sg, sg_cnt, NULL, 0, NULL, 0,
 			       GFP_KERNEL))
-- 
2.25.1

