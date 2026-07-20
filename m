Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB1633F5A1;
	Mon, 20 Jul 2026 03:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784516425; cv=none; b=nGdfiNIrI5+HMd4JABoswElduJA+C8/rtm5MsmV+RmjKaIEQl1tZOc2BjPjkGBR8KJtO6TdjntENhozre/bwDOiUni06mKh2Hjy/bgQ2o7GpyBQ3LAXZQmIqwUI81WIEWb4GoVW+dJBeGpGbnmj+nnuWDxPmtbfHac1rm4PID0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784516425; c=relaxed/simple;
	bh=SAzUD/+lojMDyPNw0nkdItZN59LlZbft9vCKOcN9vOM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SP38fJpWA3U/u0+sUrKeqJT7gGZ/7fzi02xgGDkU2KfLabhKp+MegeXp1n4iPRyoKmFCXrHkJCJNpoP+zor/kEs9I2Tfeajfrr/O53PcyG5zG+EMWbydCQRvodki7mZwn932QtRrSTF1sqrCiR9L/Fr3mk+RXR0tcIlUQRUWXYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=HlHUF4W+; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="HlHUF4W+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=kM
	waNzoVxLv1RbxraX3uzxbh09darAyIQ9o6y7IDVns=; b=HlHUF4W+TPB4lvRskF
	iQG1iwrGeBf38sgyzIu6BvbvBRsg7hdePA0yfDNouN4WQ4Fq798yk2HycSwqqNtp
	qrbhaUkY9UeakRkYlW3kJys0tQFSXS8iuHsCI8s9X7KvffBoliF/bgHvUx10aYEw
	iUHC53ZsRhUA5Wkvd5JTQuCRU=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wB34Pguj11q6uA2Kg--.59710S2;
	Mon, 20 Jul 2026 10:59:59 +0800 (CST)
From: kensanya@163.com
To: bvanassche@acm.org,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	TanZheng <tanzheng@kylinos.cn>
Subject: [PATCH] RDMA/srpt: fix NULL deref when sending BUSY before target_init_cmd()
Date: Mon, 20 Jul 2026 10:59:41 +0800
Message-Id: <20260720025941.69809-1-kensanya@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wB34Pguj11q6uA2Kg--.59710S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCF1xur4xJF1UKrW7JF18Zrb_yoW5WrWxpF
	W5X34YkFZ8JF42yws3Cay7CrWak348Wr4jvr4Iq3s5Aa1Yy3sxKFn8G34SvFn7JFykuw17
	WFn8tr1akr4DWaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UMv35UUUUU=
X-CM-SenderInfo: 5nhq2txq1dqiywtou0bp/xtbC6hDhvWpdjzAL8AAA3V

From: TanZheng <tanzheng@kylinos.cn>

If srpt_get_desc_tbl() fails, srpt_handle_cmd() jumps to
target_send_busy() before target_init_cmd() has set cmd->se_tfo.
target_send_busy() then dereferences a NULL se_tfo.

Call target_init_cmd() first with placeholder data_length and
data_direction, parse the descriptor table next, then fill in the
real data_length. That way target_send_busy() is safe if parsing
fails.

Fixes: 8b8807b9e982 ("scsi: RDMA/srpt: Fix handling of command / TMR submission failure")
Link: https://lore.kernel.org/all/20260717025402.64054-1-kensanya@163.com/
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: TanZheng <tanzheng@kylinos.cn>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 31 ++++++++++++++++++---------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index f66cfd70c263..379718453a7d 100644
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
@@ -1584,6 +1584,20 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
 		break;
 	}
 
+	/*
+	 * Before calling srpt_get_desc_tbl(), call target_init_cmd() first
+	 * to set cmd->se_tfo and use target_send_busy(). The data_length
+	 * will be filled after the successful call of srpt_get_desc_tbl().
+	 */
+	rc = target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
+			     scsilun_to_int(&srp_cmd->lun), 0 /* data_len */,
+			     TCM_SIMPLE_TAG, DMA_NONE, TARGET_SCF_ACK_KREF);
+	if (rc != 0) {
+		pr_debug("target_init_cmd() returned %d for tag %#llx\n", rc,
+			 srp_cmd->tag);
+		goto busy;
+	}
+
 	rc = srpt_get_desc_tbl(recv_ioctx, send_ioctx, srp_cmd, &dir,
 			       &sg, &sg_cnt, &data_len, ch->imm_data_offset);
 	if (rc) {
@@ -1594,14 +1608,11 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
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

