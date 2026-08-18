Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B633D3D1D
	for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 03:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787025170; cv=none; b=PcuaSrNLkrSjkvzkcO16EUgY1KYY6Lj+TTc0H0nBzflAZTwevCOcNkwMiPw6XawjG+WbNCfCfuKnI5XzMyqkOZSvMjAgeZ6EmPyTs+hIiGqtgNDm+aY9zJQUngGeOuk9fF4AGWUFu5Jep57ubpzgajFCj37/HsmuJw03Xuhqehk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787025170; c=relaxed/simple;
	bh=2rJfuZl7V4GaJNwGLLET/5XuukkWgGKRGeh00EpCrH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfJ9mafeTnHiRy7wHUhuxhrGUDTS6iv6xQamUGjU80l6KLMk+fP7AxasK3h5x+zmc7+OtAvZ5zj/WTaCI9Eq8IovLm8idQHk8uFnVqNq+/gbNG07vLWcis9MkM8zGkXHpXH6lJXuUud9G6qPVhh5RV5EoAff4lcWndZljLhS1UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=nhJ/LnD/; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="nhJ/LnD/"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-84867f07d63so4310216b3a.2
        for <linux-rdma@vger.kernel.org>; Mon, 17 Aug 2026 20:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1787025168; x=1787629968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UV8ClkYyHBQt8qz8iO59yEdYsVyXo9a3l22jb6LF/yc=;
        b=nhJ/LnD/5QS5OMt0Rj9ztFscFLR2gsExhlf7TIdEv1wUrPrTUTZO0FKb26mRSFyptH
         GIhLS1GhWq7HaXp4RtdJ+QcjGzmQadK4KptBdfRK3eW/XiN5e4xXOiFqQ9MNhUKgr1nz
         jjo6A/R4toP22Uh+DMsURpGMXFX5ZDdM8ohiV18aeo0SPOTtwR35XCGT7Zc0fiM2+PJo
         4xo4hVoa3wDvwVbCvqv79zSvArg3KHxQt5DfD84vVHIfZhqB5HhW+6jLzRnvi7Skji6A
         fnk30E3o4/CQqS+eDI74KEBBQfqj34R9vbsTbDnAeWtJObtEsk5sQ/QA1re/0lhgkmHS
         qOBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787025168; x=1787629968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UV8ClkYyHBQt8qz8iO59yEdYsVyXo9a3l22jb6LF/yc=;
        b=oy1JmwajydM+y5AthyyJdoLvs8jQFRRe02LhwTfOl7sPM3t7lfD788HRtRX0faUQQJ
         2nHEKxCPfzdp+NCDp3ZaHDKUGq6OvFNo0qgvOIQqJSzxLIGzcPToorQxI8M1H5Y6lwCK
         8FRs8eO+rhE7kzNDtrl1M9O/N7tG9g+/Z7UN94VR0g5OiQiY/zxf9HBW32Z/HucJgt7q
         WRVIF2IkDQycHH9t3eejuoDmKYQqY6ypJKkNvsQ3OmP2mSpJNlK8AngmqXQT26RGmYj1
         5hlugHIYQiP7MX2/iXlUfV1MdW1+8grMw9HLFI+EPVDk/Zvyn8X0ZJC5H6Cigr2+fIlC
         tONg==
X-Gm-Message-State: AOJu0YwdBHt8YtSMpQGcJV6hkOyVueQWSfZgxhw95ci0wF4AL5zoUhSj
	z3a9CuFSXPItOSIzswif31iV7M6brMKD1vGyuzI1V7bJb2m4gSS54u5O8YyO31KDN4MP6vkzoSS
	cWrIvvrk=
X-Gm-Gg: AR+sD13hgPtgg+zRnMtSEMzuthwMwTZJAGab9onGhMS4is936bXQl05MFJZBezkUSUI
	m55jb+2MLsqNO97e9bUzTtVurkuVm3xqVXsGUXyR8EBl1lTQIhQ0M3C7/Rba+Bb1/REj5wdK5Z9
	d+XpBqHi8/qYtiX2FPkHs45iY5pj0+v9k1I5h0QMGRdWyS8ra2EiS+2QHiHmHGECdxB+oPfuGhb
	Vd9jvB+2naH/EnfGcP1zAiAzuRSJGp/HrBkmvi3jJwOtwvve/q77ljZafTnkV1BFojnJHefQrTe
	bIGq71o90ybkgDKKp38U8twXeivrgl3nWJyx4tqkKcLJ498ciFo9LxobgzHq0OKwmDei8ZYCejX
	YdAkRnyDecD3S3CTBW8SEG3za1c5LkedQdy4kJfkJkcOaxCghXF/CtAulBzBd/W6lmRh73XBmQA
	uqSR+gC3/ZE0j1PSoCR+guZ3OaMSJvU9yKgdAH8IErw3xXmLSzEnwLZL5vt+atSsWCCm+tMA==
X-Received: by 2002:a05:6a00:10cd:b0:847:982e:cca0 with SMTP id d2e1a72fcca58-84fde1fd916mr28596104b3a.19.1787025168312;
        Mon, 17 Aug 2026 20:52:48 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6f8bf71sm985058b3a.32.2026.08.17.20.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 20:52:47 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: linux-rdma@vger.kernel.org
Cc: bvanassche@acm.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] RDMA/srp: fix use-after-free of a request in srp_destroy_qp()
Date: Tue, 18 Aug 2026 12:52:28 +0900
Message-ID: <20260818035229.505098-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818035229.505098-1-yhlee@isslab.korea.ac.kr>
References: <20260818035229.505098-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

srp_destroy_qp() drains the send queue before destroying the queue pair.
For the fast registration and invalidation work requests the wr_cqe it
finds there is &req->reg_cqe, which lives in the blk-mq request pool, and
srp_remove_target() has already freed that pool through
scsi_remove_host(): page_owner records the page freed by
blk_mq_free_tags_callback() while that call is running.
__ib_process_cq() then calls wc->wr_cqe->done on it.

A target whose login fails after a command has been mapped leaves such a
work request flushed in the send queue, and the drain reads it after the
pool is gone.

  [   18.969484] BUG: KASAN: use-after-free in __ib_process_cq+0x2ec/0x390
  [   18.970521] Read of size 8 at addr ffff888107cc5a50 by task kworker/0:1/11
  [   18.971544]
  [   18.971811] CPU: 0 UID: 0 PID: 11 Comm: kworker/0:1 Not tainted 7.2.0-rc5-CLEANA-gd788e9657d56-dirty #17 PREEMPT(lazy)
  [   18.971819] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  [   18.971831] Workqueue: srp_remove srp_remove_work
  [   18.971868] Call Trace:
  [   18.971879]  <TASK>
  [   18.971883]  dump_stack_lvl+0x53/0x70
  [   18.971937]  print_report+0xd0/0x630
  [   18.971987]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
  [   18.972010]  ? _raw_spin_lock_irqsave+0x85/0xe0
  [   18.972017]  ? __ib_process_cq+0x2ec/0x390
  [   18.972022]  kasan_report+0xce/0x100
  [   18.972027]  ? __ib_process_cq+0x2ec/0x390
  [   18.972033]  __ib_process_cq+0x2ec/0x390
  [   18.972038]  ib_process_cq_direct+0x8e/0xd0
  [   18.972043]  ? __pfx_ib_process_cq_direct+0x10/0x10
  [   18.972053]  ? _raw_spin_lock_irq+0x80/0xe0
  [   18.972057]  ? __pfx__raw_spin_lock_irq+0x10/0x10
  [   18.972061]  ? kfree+0x121/0x380
  [   18.972083]  srp_free_ch_ib+0x284/0xc00
  [   18.972090]  srp_remove_work+0x30f/0x650
  [   18.972095]  process_one_work+0x633/0x1030
  [   18.972127]  ? assign_work+0x11d/0x370
  [   18.972132]  worker_thread+0x45b/0xd10
  [   18.972138]  ? __pfx_worker_thread+0x10/0x10
  [   18.972144]  ? __pfx_worker_thread+0x10/0x10
  [   18.972149]  kthread+0x2c6/0x3b0
  [   18.972163]  ? recalc_sigpending+0x15c/0x1e0
  [   18.972184]  ? __pfx_kthread+0x10/0x10
  [   18.972188]  ret_from_fork+0x36e/0x5a0
  [   18.972212]  ? __pfx_ret_from_fork+0x10/0x10
  [   18.972217]  ? __switch_to+0x572/0xdd0
  [   18.972231]  ? __pfx_kthread+0x10/0x10
  [   18.972236]  ret_from_fork_asm+0x1a/0x30
  [   18.972247]  </TASK>
  [   18.972250]
  [   18.993356] The buggy address belongs to the physical page:
  [   18.994084] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x107cc5
  [   18.995090] flags: 0x200000000000000(node=0|zone=2)
  [   18.995739] raw: 0200000000000000 ffffea00041f3148 ffffea00041f3148 0000000000000000
  [   18.996725] raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
  [   18.997705] page dumped because: kasan: bad access detected
  [   18.998427]
  [   18.998644] Memory state around the buggy address:
  [   18.999235]  ffff888107cc5900: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  [   19.000867]  ffff888107cc5980: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  [   19.002577] >ffff888107cc5a00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  [   19.003500]                                                  ^
  [   19.004261]  ffff888107cc5a80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  [   19.005198]  ffff888107cc5b00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

The completion does not identify the request.  Both handlers hand it to
srp_handle_qp_err(), which finds the channel through cq->cq_context, and
neither work request is signalled on success.  Put the two completion
contexts in the channel, which outlives the queue pair.

Fixes: 9294000d6d89 ("IB/srp: Drain the send queue before destroying a QP")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 16 ++++++++--------
 drivers/infiniband/ulp/srp/ib_srp.h |  8 +++++++-
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 6b429ef63f8f3..f3f19277c2720 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -144,6 +144,8 @@ static void srp_rename_dev(struct ib_device *device, void *client_data);
 static void srp_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 static void srp_handle_qp_err(struct ib_cq *cq, struct ib_wc *wc,
 		const char *opname);
+static void srp_inv_rkey_err_done(struct ib_cq *cq, struct ib_wc *wc);
+static void srp_reg_mr_err_done(struct ib_cq *cq, struct ib_wc *wc);
 static int srp_ib_cm_handler(struct ib_cm_id *cm_id,
 			     const struct ib_cm_event *event);
 static int srp_rdma_cm_handler(struct rdma_cm_id *cm_id,
@@ -604,6 +606,8 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	ch->qp = qp;
 	ch->recv_cq = recv_cq;
 	ch->send_cq = send_cq;
+	ch->reg_cqe.done = srp_reg_mr_err_done;
+	ch->inv_cqe.done = srp_inv_rkey_err_done;
 
 	if (dev->use_fast_reg) {
 		if (ch->fr_pool)
@@ -1159,8 +1163,7 @@ static void srp_inv_rkey_err_done(struct ib_cq *cq, struct ib_wc *wc)
 	srp_handle_qp_err(cq, wc, "INV RKEY");
 }
 
-static int srp_inv_rkey(struct srp_request *req, struct srp_rdma_ch *ch,
-		u32 rkey)
+static int srp_inv_rkey(struct srp_rdma_ch *ch, u32 rkey)
 {
 	struct ib_send_wr wr = {
 		.opcode		    = IB_WR_LOCAL_INV,
@@ -1170,8 +1173,7 @@ static int srp_inv_rkey(struct srp_request *req, struct srp_rdma_ch *ch,
 		.ex.invalidate_rkey = rkey,
 	};
 
-	wr.wr_cqe = &req->reg_cqe;
-	req->reg_cqe.done = srp_inv_rkey_err_done;
+	wr.wr_cqe = &ch->inv_cqe;
 	return ib_post_send(ch->qp, &wr, NULL);
 }
 
@@ -1193,7 +1195,7 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
 		struct srp_fr_desc **pfr;
 
 		for (i = req->nmdesc, pfr = req->fr_list; i > 0; i--, pfr++) {
-			res = srp_inv_rkey(req, ch, (*pfr)->mr->rkey);
+			res = srp_inv_rkey(ch, (*pfr)->mr->rkey);
 			if (res < 0) {
 				shost_printk(KERN_ERR, target->scsi_host, PFX
 				  "Queueing INV WR for rkey %#x failed (%d)\n",
@@ -1470,11 +1472,9 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 
 	WARN_ON_ONCE(desc->mr->length == 0);
 
-	req->reg_cqe.done = srp_reg_mr_err_done;
-
 	wr.wr.next = NULL;
 	wr.wr.opcode = IB_WR_REG_MR;
-	wr.wr.wr_cqe = &req->reg_cqe;
+	wr.wr.wr_cqe = &ch->reg_cqe;
 	wr.wr.num_sge = 0;
 	wr.wr.send_flags = 0;
 	wr.mr = desc->mr;
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 349576ff38450..22720f103d4eb 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -137,7 +137,6 @@ struct srp_request {
 	struct srp_direct_buf  *indirect_desc;
 	dma_addr_t		indirect_dma_addr;
 	short			nmdesc;
-	struct ib_cqe		reg_cqe;
 };
 
 /**
@@ -145,6 +144,10 @@ struct srp_request {
  * @comp_vector: Completion vector used by this RDMA channel.
  * @max_it_iu_len: Maximum initiator-to-target information unit length.
  * @max_ti_iu_len: Maximum target-to-initiator information unit length.
+ * @reg_cqe: Completion context for fast registration work requests.
+ * @inv_cqe: Completion context for invalidation work requests.  These are
+ *	per channel because their completions do not identify the request and
+ *	because the request pool can be freed before the send queue is drained.
  */
 struct srp_rdma_ch {
 	/* These are RW in the hot path, and commonly used together */
@@ -170,6 +173,9 @@ struct srp_rdma_ch {
 	struct completion	done;
 	int			status;
 
+	struct ib_cqe		reg_cqe;
+	struct ib_cqe		inv_cqe;
+
 	union {
 		struct ib_cm {
 			struct sa_path_rec	path;
-- 
2.43.0

