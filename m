Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64BC362149
	for <linux-rdma@vger.kernel.org>; Wed, 12 Aug 2026 19:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786561478; cv=none; b=skUp4RPQYQNLjHbjnegMJrKYvMJmTZgXbXyY4mjG86q0ZwvceVbpPoyY8Y1ZeAf5kS7UKlMyi3NAddbfCRSIUhtzlm+Fjs6joagcJQhKPrpJpWWIAkk6TjM7W7etHC32uRhaxyANspFuB4Dr2F7JYz5xuPpXOjZ+gpaFPky8llQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786561478; c=relaxed/simple;
	bh=pnt9J/xV3Ip9bNp5Ug4KyAAA9smjFSCfqWksfcI7eMI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q98nbqKvBuNJliOKLwjMCEKqRskUq6jgVv0KsG67d1vjxYmcRnN8r5SCh1AJ5X3hz6hEZm2GwJBQYRrVxJtJaJ6I6Wx1nqda4XokR7CmzBnFQeWhlefJPy+Ht6NTUDV7c+sqej8Y5HiCJq4wa/hJYb0ns1hhQB9E5KoDuKyj2aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=IcCzVGis; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="IcCzVGis"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38e347638adso1824813a91.0
        for <linux-rdma@vger.kernel.org>; Wed, 12 Aug 2026 12:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1786561475; x=1787166275; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8LXiIwcGiqlcACI3JgS0ERVno9qwpqofV9Mnyqctee8=;
        b=IcCzVGisrGxSpn80FJHsuAmFXGnb67lNbtkATaceae6dH0kE+I0zoihUhduCowM+TD
         aVTWq8/cjby/YLjce2zedF5cEE5RTULLaR24MRd471QfG7HoPoYqHqPLwoZThrwLrwE+
         alNbh5zi5lklDY1tr44UNogVe3h2vpckj8K1Igmy128PRqHaI0l4UyXcJHZBAaFKJMl+
         BbRhPaC56eVxbXPEnNfkwgRYweu7dGl7YIlw7myQN+shBEkHE6zBwjfwwDSRKr6UYobh
         DAuKm8c1muwjZcaH7gM9YifaE690sKn8eAEmp10EpB5Rsqh7w0sHDCXjmA4cVOD67kEh
         Gjmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786561475; x=1787166275;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8LXiIwcGiqlcACI3JgS0ERVno9qwpqofV9Mnyqctee8=;
        b=OIKXQ2rQ8itLtGnbqryjecJmoO/nZbeUMOTCmvJd9sN33oiEtA7SpcNHfDj252XbQe
         LDXnX/jCBtlrYMpEW52+vPv/xXnEsR1BBbyswDGWs/Cug4tUlFkBZjEqbmRVSAyBTrH0
         r7sqA2i7pcUZSeG4p1IW4sM/i2j0Gw/kSmiZjK8I0uu5EWTlNxRdpldX6DhJYdtn4vdV
         6cSBMmIgY7U/L7CtYZbs4Ur6r/8gfkq+690ax6VnHPJvGw7r3eOF80DCgu3ssTHa/41J
         aILoG58cqAYr2GM3d6J5I49hlo1gBM/BH4HDFhueaDI/in7w/REhRyikCR6rwtbtVrbW
         W7bg==
X-Gm-Message-State: AOJu0Yx3qgg+/xMGCkF5SgGcKLnfpM3cvJ1k248CNTWLbeI8DJcX24pz
	i5oXRVDRGTvuAzp4ZHPBn19YwibZhU98vtLKEfJzJSBEnZKQb0Sto4lHrjS4ftRo22yVPxaEUfO
	WZtb5PvZGdQ==
X-Gm-Gg: AR+sD113OkFk7torNeawrLqZE6U124Le8kxUaDbqld82BaUwHt7RubpS6rq/J3EcKMw
	EJVwutdwoUqKlnC7JZPGPVf7yO92+4CvXgSYZZcoMGCukuEzacI9xazDbiQNEg1AJlX1jmOxO3b
	C2aXlq4UeVogUM/+8ZcMF5pjTZ5tx2iniFFhooqZS7bR7Fs/38+K7VwnLfmIs722mNyZoJQr/Zj
	t3oGXvHSHv3aqjN/nTxlBeaY4+TEeJhH9p9eKQO4B2W6D2lWp2br4/zEeRghrhGCwjWYnIx9ZcO
	LCYwy3t9QR0ONF4C30UiF230R69SAyVaIttgEkQKpOYs7dhnXXIXPFgYbTuNXHUO3PM/eswtous
	Yjg3zykGL0Lofkxn8l2CclTYoOc8vreXOJIPThJ6R6kRIjkmWTfIKmb4CtSDGaU4I/7K8n3BcAi
	E6XMfMmVaG3wAw5cXLQQMSaxSEOB4/QQSQyEoU2QlFFCmgvly9XXSmYjlHqyhhX8GFj6idkIwUe
	CKhFOI0bPI=
X-Received: by 2002:a17:90b:57f0:b0:38e:9045:bac0 with SMTP id 98e67ed59e1d1-3931e01dca9mr486141a91.5.1786561474497;
        Wed, 12 Aug 2026 12:04:34 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:365f:6c09:b402:1986])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3931d9ae17csm101583a91.1.2026.08.12.12.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 12:04:34 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: linux-rdma@vger.kernel.org
Cc: bvanassche@acm.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/srp: fix use-after-free of a request in srp_destroy_qp()
Date: Thu, 13 Aug 2026 04:04:18 +0900
Message-ID: <20260812190418.200337-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

srp_destroy_qp() drains the send queue before destroying the queue pair.
For the fast registration and invalidation work requests, the wr_cqe it
finds there is &req->reg_cqe, which lives in the blk-mq request pool.
srp_remove_target() frees that pool first, through scsi_remove_host():
page_owner records the page freed by blk_mq_free_tags_callback() while
that call is running.  __ib_process_cq() then calls wc->wr_cqe->done on
it.

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
Measured over rxe with KASAN against a target that advertises
max_ti_iu_len = 8, the same test target as 961ac0f0c5e4 ("RDMA/srp: fix
heap information leak on a truncated SRP_CRED_REQ"), with that commit
applied: the report above appeared in 5 of 5 runs without this patch and
in none of 5 with it.  A conforming target is unaffected - login, I/O and
teardown, 5 runs each way, no report and the same number of completions
drained.

The page_owner stack named above comes from a build with
CONFIG_PAGE_OWNER; the report itself is from a plain KASAN build.

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

