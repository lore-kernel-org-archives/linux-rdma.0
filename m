Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFC6340416
	for <linux-rdma@vger.kernel.org>; Fri, 31 Jul 2026 04:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785471225; cv=none; b=aAXs0SAtnt8hjB862UJlU4Km6qQFceX1PZBOrxXFYfL783wKnWewf9tjkm3bXymWw/N9PL15TVhbtF/+8d5ISQCdDuHnu9N1/XloKD8+w+rSQub5nSKeaBq/ksUIG/oKL71mjsyhfzd/DQMz1quhYL7ZsPKGJmg+FjN50iz6Flk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785471225; c=relaxed/simple;
	bh=UlSKLEFjjogESAM9ctNCXwQnKD4+1ubzgs69cjEw0Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SIoTa+Hq5mSllDGC1SgWLCRykF007NCy2Voleo8qBIf0ugKxzpY/CNhqWq9ZSDhl6KaNoBoYTxomu/i6tA6G0Uoy0HufxT9MQG+sEktfvf5JgAXlqYimORv7t0jWcJMffSz3hHq4ot+gMRbJo9k4e6Q6z0HHi0eXUlwf5AP2eqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=sYbAPBnt; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="sYbAPBnt"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84874b52eabso859483b3a.0
        for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 21:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785471220; x=1786076020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CreeTxfeNGH1KocjOJKrTbuixfyODpRIWh+JUQjyW9M=;
        b=sYbAPBntzmXrYFYJt0eVq5oOJQrYjgNYpLc2yqAvDkkz4DB+p5T1WKfHmxET70lZn2
         /btbjtJpuE9nUkwAx/GlNSXjH3MGUcmLt84VQdhW0sXTN4fu9yDpBMLBOw1AALhSQCnH
         S4Cvh1JfPe0tUtItxE1Z9ZgZU9xNz8MlZORwgo1guBl4mYGvHiS+U+UphNbLQnokCAWT
         Dr3PVQJKUEQMEyOgkN1AfA+xUK52M72SPFu9stU/9xWor5VqvmiY/Cn/Jay0xZ+5kqyd
         Oea+Q7dROsCZlG687qfLfpAcNLA1rNMiTMo5xa1jkuZziQio30aIzXYQHPngyuxF5DF+
         LgNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785471220; x=1786076020;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CreeTxfeNGH1KocjOJKrTbuixfyODpRIWh+JUQjyW9M=;
        b=Jsrc8l+w7DNf34P81EF/5MGaWjbgMh1iHwKpXQ7D6I0Od//tiBiQsts9lh4UH9rvKv
         4DI3oPUxyuZ28o7aKxouliBuaqgDidbfAeybBCOvJXS+ro7IlIVXE6LfVVGT6JJ2WtB8
         ZevjNQeOsAbSIxBlOjixftEgjA6jI2TXzsGVv3zKdvWE+ggbjoRhOHvw3vNiEa45Pywh
         UV0IZN1sl8Q7Js6Pajd1JjCER4+N1JK/s63aAcZV6avOP05NMzyeXhwMZLH2suYve51d
         Ih5qVNy2ji4+CVefISqMKAnxoOXoVfLIurHaQB/QhSnTy16O8W0pk8l32HkRIOPbevb6
         PPnA==
X-Forwarded-Encrypted: i=1; AHgh+RoAigu7F0fp+obXjjnmVzUXh7jaDbaDQxpOkK/uFEXekN1Cj+CKmseU0Hzx2YnTY9TIUpYr8nmfXZCl@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/icilstZrEV/1UWCbbLujYFzh6VqyhPGQLqkXRCB5fzxm1Veg
	TXvggkec40MeuW+XZszaZMm5EJ8IfKORwF8fSWfcStC03ZQa9PZ/GMQGCq3eaKhxhvU=
X-Gm-Gg: AR+sD13NiwqzpkIIco5aybzuO8idx8fgm8K5mcxGsmohnVHrbojQgzLyJOKXmTbuwdG
	bwlLD2JkEQh7DUeliYsCWoI5dd0h9kMSH3gHEjJg7BK2sBidEeicWcs/xZlD8zLOPx4JDfJVoi8
	QYhZs8v8wg3H+IWNSLPYsA7md73z3ahJKYVJkUm4HfJ+wx5tZ0b7+sgEKWNQllCv+Aqn0LO+TOX
	sK45R4ANPI2ltb82I2/sKoRwgx1VyjKFkgHoAmWIPpOVabH8LJvVQjRrJ+H8bJMZ/DCNNTN/MSf
	oevcZX1cBEo94p+b5sTvb3EXZU+E043zfbDChzrRrcIjLP65r3/IwSqdnPP5JYWfxbkJubnUD+p
	/NKAix7NLNk5Z/I5rlu79ax1zPr5f49q/vlq9SkNzQq9rFpigDBjTAhN9dB6dOjo/yff6y91/HS
	HfoK75BR7WiaHFUUgPwKZmAfaw2LyIdUO5TkiEw97tIu8d8yP61hpLQb6Y7nbKobPFAO6t
X-Received: by 2002:a05:6a00:2986:b0:848:44ae:47c4 with SMTP id d2e1a72fcca58-84ed6bf56bfmr410450b3a.20.1785471220282;
        Thu, 30 Jul 2026 21:13:40 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ed5782ea8sm195642b3a.1.2026.07.30.21.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 21:13:39 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: michael.christie@oracle.com,
	martin.petersen@oracle.com,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH v4 1/2] IB/isert: delay the final Login Response until the session is registered
Date: Fri, 31 Jul 2026 13:12:11 +0900
Message-ID: <20260731041212.1733364-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

isert_put_login_tx() puts the final Login Response on the wire before
__transport_register_session(), which iscsi_post_login_handler() reaches
only after iscsi_target_do_login() returns.  An initiator that issues a
SCSI command as soon as it sees that response can have it executed against
an se_session whose se_tpg is still NULL, and the ib-comp-wq worker oopses
on the NULL dereference.

  [    6.469002] Oops: general protection fault, probably for non-canonical address 0xdffffc000000000f: 0000 [#1] SMP KASAN NOPTI
  [    6.469652] KASAN: null-ptr-deref in range [0x0000000000000078-0x000000000000007f]
  [    6.470053] CPU: 0 UID: 0 PID: 178 Comm: kworker/0:1H Not tainted 7.2.0-rc5-V2CTL-gf5098b6bae76 #10 PREEMPT(lazy)
  [    6.470560] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  [    6.471120] Workqueue: ib-comp-wq ib_cq_poll_work
  [    6.471372] RIP: 0010:target_submit+0xbe/0x390
  [    6.471599] Code: fa 48 c1 ea 03 80 3c 02 00 0f 85 89 02 00 00 48 b8 00 00 00 00 00 fc ff df 4d 8b 64 24 18 49 8d 7c 24 78 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 5a 02 00 00 48 8d 7b 78 4d 8b 6c 24 78 48 b8 00
  [    6.472497] RSP: 0018:ffff8881058cfa78 EFLAGS: 00010206
  [    6.472761] RAX: dffffc0000000000 RBX: ffff88810c78c6f0 RCX: ffffffff964bb363
  [    6.473112] RDX: 000000000000000f RSI: 00000000fffffe00 RDI: 0000000000000078
  [    6.473439] RBP: 1ffff11020b19f52 R08: 0000000000000001 R09: ffffed1020b19f52
  [    6.473790] R10: 0000000000000003 R11: ffff88810596c000 R12: 0000000000000000
  [    6.474153] R13: ffff88810c61b000 R14: ffff88810c6a3400 R15: ffff88810c61b044
  [    6.474479] FS:  0000000000000000(0000) GS:ffff8881822b2000(0000) knlGS:0000000000000000
  [    6.474884] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [    6.475156] CR2: 00007f1f1b83c000 CR3: 000000006fe72001 CR4: 0000000000770ef0
  [    6.475483] PKRU: 55555554
  [    6.475628] Call Trace:
  [    6.475763]  <TASK>
  [    6.475886]  ? __pfx__raw_spin_lock_bh+0x10/0x10
  [    6.476146]  ? __pfx_target_submit+0x10/0x10
  [    6.476348]  ? mutex_lock+0x81/0xe0
  [    6.476517]  ? __pfx_mutex_lock+0x10/0x10
  [    6.476722]  ? iscsit_execute_cmd+0x650/0x850
  [    6.476958]  iscsit_sequence_cmd+0x186/0x3d0
  [    6.477164]  iscsit_process_scsi_cmd+0x87/0x300
  [    6.477362]  isert_recv_done+0x1002/0x2390
  [    6.477546]  ? __pfx_isert_recv_done+0x10/0x10
  [    6.477761]  ? rxe_poll_cq+0x253/0x3d0
  [    6.477945]  ? finish_task_switch.isra.0+0x1dc/0xa70
  [    6.478192]  __ib_process_cq+0xe1/0x390
  [    6.478360]  ib_cq_poll_work+0x46/0x150
  [    6.478531]  process_one_work+0x633/0x1030
  [    6.478730]  ? assign_work+0x11d/0x370
  [    6.478918]  worker_thread+0x45b/0xd10
  [    6.479099]  ? __pfx_worker_thread+0x10/0x10
  [    6.479295]  ? __pfx_worker_thread+0x10/0x10
  [    6.479480]  kthread+0x2c6/0x3b0
  [    6.479632]  ? recalc_sigpending+0x15c/0x1e0
  [    6.479848]  ? __pfx_kthread+0x10/0x10
  [    6.480029]  ret_from_fork+0x36e/0x5a0
  [    6.480214]  ? __pfx_ret_from_fork+0x10/0x10
  [    6.480399]  ? __switch_to+0x572/0xdd0
  [    6.480566]  ? __pfx_kthread+0x10/0x10
  [    6.480748]  ret_from_fork_asm+0x1a/0x30
  [    6.480952]  </TASK>
  [    6.481062] Modules linked in:
  [    6.481235] ---[ end trace 0000000000000000 ]---

Delay the final Login Response instead.  isert_get_rx_pdu() runs from
iscsi_target_rx_thread() after conn->rx_login_comp, completed by
iscsi_post_login_handler() after __transport_register_session(); iscsi-TCP
and cxgbit already take PDUs from that thread, isert alone does not.  The
buffers are still posted first, so the initiator's first command does not
meet an empty receive queue and nothing depends on RNR flow control, and
the header and payload live in isert_conn, not in the struct iscsi_login
that iscsi_target_nego_release() frees first.

Over rxe, 400 login cycles per run, the oops appeared in 10 of 20
unpatched runs and in none of 20 runs with this patch.  An
initiator that never waits is handled by the next patch.

Not tested: iWARP, discovery sessions over iSER, and real HCAs.

Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) target driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v4: 2/2 replaced.  v3's version rejected such PDUs from isert_recv_done()
    and reinstated the connection, which strands both iscsi kthreads because
    conn->conn_state is still TARG_CONN_STATE_IN_LOGIN when it runs; dropping
    the PDU instead leaves a gap in the CmdSN stream that
    iscsit_close_connection() then waits on.  Both reproduce; this does
    neither.
    v3: https://lore.kernel.org/all/20260730135110.1647384-1-yhlee@isslab.korea.ac.kr/

 drivers/infiniband/ulp/isert/ib_isert.c | 20 ++++++++++++++++++--
 drivers/infiniband/ulp/isert/ib_isert.h |  1 +
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 1015a51f750a..e117cd2e62c9 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -59,6 +59,8 @@ static void isert_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 static void isert_send_done(struct ib_cq *cq, struct ib_wc *wc);
 static void isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 static void isert_login_send_done(struct ib_cq *cq, struct ib_wc *wc);
+static void isert_unmap_tx_desc(struct iser_tx_desc *tx_desc,
+				struct ib_device *ib_dev);
 
 static int isert_sg_tablesize_set(const char *val, const struct kernel_param *kp)
 {
@@ -496,6 +498,8 @@ isert_connect_release(struct isert_conn *isert_conn)
 	if (isert_conn->qp)
 		isert_destroy_qp(isert_conn);
 
+	isert_unmap_tx_desc(&isert_conn->login_tx_desc, device->ib_device);
+
 	if (isert_conn->login_desc)
 		isert_free_login_buf(isert_conn);
 
@@ -956,14 +960,17 @@ isert_put_login_tx(struct iscsit_conn *conn, struct iscsi_login *login,
 			mutex_lock(&isert_conn->mutex);
 			isert_conn->state = ISER_CONN_FULL_FEATURE;
 			mutex_unlock(&isert_conn->mutex);
-			goto post_send;
+
+			/* Sent from isert_get_rx_pdu() after registration. */
+			isert_conn->login_rsp_pending = true;
+			return 0;
 		}
 
 		ret = isert_login_post_recv(isert_conn);
 		if (ret)
 			return ret;
 	}
-post_send:
+
 	ret = isert_login_post_send(isert_conn, tx_desc);
 	if (ret)
 		return ret;
@@ -2585,8 +2592,17 @@ static void isert_free_conn(struct iscsit_conn *conn)
 
 static void isert_get_rx_pdu(struct iscsit_conn *conn)
 {
+	struct isert_conn *isert_conn = conn->context;
 	struct completion comp;
 
+	/* The session is registered by now; see isert_put_login_tx(). */
+	if (isert_conn->login_rsp_pending) {
+		isert_conn->login_rsp_pending = false;
+		if (isert_login_post_send(isert_conn,
+					  &isert_conn->login_tx_desc))
+			return;
+	}
+
 	init_completion(&comp);
 
 	wait_for_completion_interruptible(&comp);
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 0b2dfd6e7e27..0bac5aa66c80 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -178,6 +178,7 @@ struct isert_conn {
 	struct completion	login_comp;
 	struct completion	login_req_comp;
 	struct iser_tx_desc	login_tx_desc;
+	bool			login_rsp_pending;
 	struct rdma_cm_id	*cm_id;
 	struct ib_qp		*qp;
 	struct ib_cq		*cq;
-- 
2.43.0

