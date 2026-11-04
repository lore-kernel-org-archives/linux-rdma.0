Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793755372;
	b=t6kejhp4MCXROaGex77Z0UjtmeJhQhqW1dQ18XneCBn8OfuwUlQ0AvvDtEE9udGn0+xX
	 17jaarmeHTauB3GgQBZKyQtS/XjlV/PMlPoJYU3Rp6IMOMrJSgwcgXfQFxWl4S0W6Fr5m
	 EZSKHB11HR0uS6iYsPezFo+N2clXwWET84YoJ6jSOwp3vNZ0se5+sRPWEO4Vtsj7VHYTi
	 obhPafp3p2Iq4xNdKoevjDCboqLbcVf5q2xFilmIGH+lnbMzPcjWs7MPbwHBRKOka6a1f
	 lk9kaLvIDC3mDN9oddNWbXFt+/J39LkPsQql6k3u5+D1MZ6bq3Gw3VIlIeshcBG39uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793755372;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eUuaQRnCpWFb2AFhf+dma6sH/ltjQo/ia6lAftonDv0=;
	b=j7ljv6ehbyVyGf/hjHKt4rHqwWz1nlIGKnP70m8M8HX973yQYo2mRW0+3MFwSioHSWRr
	 4eVu6RS2CwLSgneqZiuSY8GRGa5Ecp/7p1Y/RdC3R/wZHH8YAkJ64ehPzZp66M8FWGjCE
	 /ZQuCYowQGmgIoyBUPZVXKgGWj5NPP/IatIXiV3mNsgkf7M4OuzY1z3CLUUqP1yP+jRlx
	 Q9/IJgJAzt05EE+GgeIHDg9Ndjel7rnrpyZNpK5Ip0adUAjg/gjbaEUDZ0H3vzNlPUEgA
	 Z/MnzvqUWigxvOvTj5DE2dzbAQU/WpTONRp7CKblLvTi9MwTNHWauwkqV27ZVKVOr/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=WlpOWCXQ;
	arc=none smtp.remote-ip=209.85.215.174
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7B9606A33E
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 01:22:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A7B9606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=WlpOWCXQ
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cd6028ff33fso82208a12.0
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 17:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793755371; x=1794360171; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eUuaQRnCpWFb2AFhf+dma6sH/ltjQo/ia6lAftonDv0=;
        b=WlpOWCXQCcWLNx7aZk+1RIPyNBrRvlZ8ca1FJt+nB+opeSaBTIHu5jzQgL1Z/2znq2
         0IbeOUy+pA4wk8fobaHRLhKLvJphHYXTCQfRo2u5XrJ8bC6F6UYMBK7KxtVW2HtRqJ41
         fyPENMIQZ9cqkYA9a5ptAmoTyQyOklSBiJNHfsVcZIvdCvxtQn50iT07qZ/+PAebTQ2n
         xSMU5C+MUPhJ5flfzI5DqxHMLiWFar3fkpS88EaL29UrYJpbuVvKdOOmYMVrR0LQv6SY
         oT9T6cPApNRdUEl2/oBaJ8RzcY5/bEJZEMAyFKLRSdXRN1A9PMi/+rCTlaZN3Qz7jVYF
         PlCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793755371; x=1794360171;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eUuaQRnCpWFb2AFhf+dma6sH/ltjQo/ia6lAftonDv0=;
        b=dLLB9A9obGNdlnTaTb3iXhDfzMt8sxHEVgbPgzzguDtRtWSpsqKjsacLIqMHpxvXtx
         dLgusWPuJVUanIo2Yjdbqz42cOfsmVyKbJu18MrGzjv1trARJ+EM2gsSHNbYsR3f9i1R
         1dVAZ4jAmhRNEFEz2lu/4sOYa8YBuAsHVc8ivAL4srFuE2DZwsxp77guPXx2ZnJlJSdO
         M+kZ8vswVu0St/L/NDwLgmS9ctO8tqhq4M67+xJE5Gut3dSxOCRxlGVwkDudUrP5+r2S
         lXbHaTMqeu6gXdYRDFjuN8mTLh1P/QtECgqAT1d94Xl/fv0rIMUTrGAV62XavxFjb0D6
         LX7w==
X-Forwarded-Encrypted: i=1; AKwUvBxZYL228uHzyoks0B//UbLUdUHm1CZEyKdCNdyPGdFW/Ntc5FfFNrV3PykutVrMN1A6bdqN9ysWIFIu@vger.kernel.org
X-Gm-Message-State: APuU4Z9/SVJZhKfIiuNCRoZr450XaB2NMV9z2X35xt4BYEu2DC4AlaI1
	Yk5Oqoy+1KxYUR4xtOmURIjyOhdlXZshAK982+4O742SFiyhXKoIj9KoQDdYdUZjqJ8=
X-Gm-Gg: AYBFou20jgEBpCf3OAqOBesj5MytNNV+I6KSorATKBMHegG1Iu2bPcQnbULpOySDjXw
	LO+MiwA+Hr8Gv2F04MAe7nk2U3vWkwTIehzUl7EHudVmuqPAv88xxf4yGdrDXrUunOVq5LmTjO4
	XS6jrjdsVfqd0jHDxbedam9KA10T5DASltSp2m5aqywvLOGiDFEmnHsQxKjmbj3QY5N7xBsaasy
	ZApQ+ANP7X2lKZvyFteS6pQV/jnFfUm4BnDhVm7ezif9h4STE2pmEHS5gZL2/sS0Mr4taVFjwNf
	keZnfAKYf9Z4vgvdIVFKIA1DHuWZlofe15Zp9R+1/oYX2LEaD52tGE6YSyabGvF+6UIOa3BGaiS
	0Fj/QyFfW23gZuioDnjZvvd1dzNtHafMZ3oDkuxBfwDxFvwV+qBaY7+08sBNnTQNDsyMzFnI6My
	Vs/y5kuyvglXfZjqxAMK9ZRMCBKBmx0mTrTA1q3xDqQD2DcU1WUoD8Qwec83UwMsiSCHX8nHWNY
	iMnJsnbrKJBo7epPk9LnwOtaoEUD6QPmKePzJNPOprVVvrfdvnvTYvlv2gsMfxFCs3QEGnvchBo
	JSXgyQEy/NxttDLyDLJn94LpcMCxcGhETx0fQ2+zETgKiakyIHr6ICPKwyMjGILdphNgDQ0YDjZ
	q9qBSEQsIRW+L6LpEECvonpqabPQFDFEbVFK+
X-Received: by 2002:a17:90a:d00f:b0:3ad:8ecc:5907 with SMTP id 98e67ed59e1d1-3ae897d2208mr12810308a91.56.1793755371244;
        Tue, 03 Nov 2026 17:22:51 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:744:cf40:a7b2:e78f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b09452d89bsm678045a91.0.2026.11.03.17.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:22:50 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH v7 6/6] IB/isert: only reinstate a connection that reached full feature phase
Date: Wed,  4 Nov 2026 10:22:19 +0900
Message-ID: <20261104012219.1759523-7-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104012219.1759523-1-yhlee@isslab.korea.ac.kr>
References: <20261104012219.1759523-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

isert_teardown_conn() and isert_connect_error() ask iscsi to reinstate the
connection whenever it is bound, ISER_CONN_BOUND included.  A connection
stays BOUND from isert_accept_np() until isert_get_rx_pdu(); during the
final login response the rx thread is already running but still waits for
its login completion.  iscsit_cause_connection_reinstatement() sends it
SIGINT, that wait fails, and iscsi_target_rx_thread() returns without the
connection exit path, so isert_remove_one() waits for ever.

Ask for reinstatement only from ISER_CONN_FULL_FEATURE, read under
isert_conn->mutex.  There the rx thread is inside isert_get_rx_pdu() and
returns to the exit path, so the signal still helps.  In BOUND terminating
is enough: if the login completes, isert_get_rx_pdu() sees
ISER_CONN_TERMINATING and returns; if it fails,
iscsi_target_login_sess_out() calls isert_wait_conn() and
isert_free_conn().

A test-only delay in that gap, with the device deleted inside it,
reproduced this on all three runs of patches 1 to 5: the rx thread was
signalled and the delete did not return within 240 seconds.  Three runs
with this patch signalled nothing and the delete returned in 8 seconds.

  INFO: task rdma:194 blocked for more than 10 seconds.
        Not tainted 7.4.0-rc1-V7L5-00006-g4f59be58f97a #141
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  task:rdma            state:D stack:26328 pid:194   tgid:194   ppid:1      task_flags:0x400100 flags:0x00080800
  Call Trace:
   <TASK>
   __schedule+0x180f/0x4bb0
   ? __pfx___schedule+0x10/0x10
   ? __pfx_complete_signal+0x10/0x10
   ? irq_work_queue+0x1c/0xb0
   schedule+0x70/0x1f0
   schedule_timeout+0x1cd/0x200
   ? __pfx_schedule_timeout+0x10/0x10
   ? vprintk_emit+0x200/0x2f0
   ? __pfx__raw_spin_lock_irq+0x10/0x10
   __wait_for_common+0x29e/0x420
   ? __pfx_schedule_timeout+0x10/0x10
   ? __pfx___wait_for_common+0x10/0x10
   ? mutex_lock+0x79/0xd0
   ? mutex_unlock+0x7b/0xd0
   ? __pfx_mutex_unlock+0x10/0x10
   isert_remove_one+0x554/0x740
   ? xas_load+0x1a/0x250
   ? __pfx_isert_remove_one+0x10/0x10
   ? xa_load+0xbf/0x120
   ? __pfx_xa_load+0x10/0x10
   ? __pfx_up_read+0x10/0x10
   remove_client_context+0xa4/0xf0
   disable_device+0x128/0x240
   ? __pfx_disable_device+0x10/0x10
   ? __pfx_mutex_lock+0x10/0x10
   __ib_unregister_device+0x226/0x3f0
   ? __pfx_mutex_unlock+0x10/0x10
   ib_unregister_device_and_put+0x50/0x70
   nldev_dellink+0x28e/0x3d0
   ? kernel_text_address+0xa7/0x130
   ? __pfx_nldev_dellink+0x10/0x10
   ? __pfx_down_read+0x10/0x10
   rdma_nl_rcv_msg+0x29c/0x4e0
   ? __pfx_rdma_nl_rcv_msg+0x10/0x10
   rdma_nl_rcv_skb.constprop.0.isra.0+0x21d/0x370
   ? __pfx_rdma_nl_rcv_skb.constprop.0.isra.0+0x10/0x10
   netlink_unicast+0x68f/0x940
   ? __pfx_selinux_socket_getpeersec_dgram+0x10/0x10
   ? __pfx_netlink_unicast+0x10/0x10
   netlink_sendmsg+0x810/0xf20
   ? __pfx_netlink_sendmsg+0x10/0x10
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   ? selinux_socket_sendmsg+0x8c/0x270
   ? __sys_sendto+0x337/0x390
   __sys_sendto+0x337/0x390
   ? __pfx___sys_sendto+0x10/0x10
   ? fdget+0x53/0x3b0
   __x64_sys_sendto+0xdb/0x1b0
   ? fpregs_assert_state_consistent+0x56/0xe0
   do_syscall_64+0xdd/0x4a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  RIP: 0033:0x7f1de13200d7
  RSP: 002b:00007fff7f1dd9d8 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
  RAX: ffffffffffffffda RBX: 0000563429332390 RCX: 00007f1de13200d7
  RDX: 0000000000000018 RSI: 00005634293312a0 RDI: 0000000000000004
  RBP: 00007fff7f1dda10 R08: 00007f1de1417200 R09: 000000000000000c
  R10: 0000000000000000 R11: 0000000000000202 R12: 00007fff7f1ddc00
  R13: 00007fff7f1dd9e4 R14: 00007fff7f1ddc20 R15: 00007fff7f1ddc00
   </TASK>

Fixes: 6d1fba0c2cc7 ("iser-target: Rework connection termination")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 1b388075cc6332..1ed8dbe067ab88 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -682,14 +682,14 @@ static void
 isert_teardown_conn(struct isert_conn *isert_conn)
 {
 	struct isert_np *isert_np = isert_conn->np;
-	bool owned = false, bound = false;
+	bool owned = false, bound = false, full_feature = false;
 	bool promoted = false, terminated = false;
 
 	mutex_lock(&isert_conn->mutex);
 	mutex_lock(&isert_np->mutex);
 	if (list_empty(&isert_conn->node)) {
-		bound = isert_conn->state == ISER_CONN_BOUND ||
-			isert_conn->state == ISER_CONN_FULL_FEATURE;
+		full_feature = isert_conn->state == ISER_CONN_FULL_FEATURE;
+		bound = full_feature || isert_conn->state == ISER_CONN_BOUND;
 	} else {
 		owned = true;
 		promoted = isert_conn->promoted;
@@ -701,7 +701,9 @@ isert_teardown_conn(struct isert_conn *isert_conn)
 		terminated = isert_conn_terminate(isert_conn);
 	} else if (bound) {
 		isert_conn_terminate(isert_conn);
-		iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
+		if (full_feature)
+			iscsit_cause_connection_reinstatement(isert_conn->conn,
+							      0);
 	}
 	mutex_unlock(&isert_conn->mutex);
 
@@ -732,12 +734,13 @@ isert_connect_error(struct rdma_cm_id *cma_id)
 	struct isert_conn *isert_conn = cma_id->qp->qp_context;
 	struct isert_np *isert_np = cma_id->context;
 	bool owned = false, bound = false, promoted = false;
+	bool full_feature = false;
 
 	mutex_lock(&isert_conn->mutex);
 	mutex_lock(&isert_np->mutex);
 	if (list_empty(&isert_conn->node)) {
-		bound = isert_conn->state == ISER_CONN_BOUND ||
-			isert_conn->state == ISER_CONN_FULL_FEATURE;
+		full_feature = isert_conn->state == ISER_CONN_FULL_FEATURE;
+		bound = full_feature || isert_conn->state == ISER_CONN_BOUND;
 	} else {
 		owned = true;
 		promoted = isert_conn->promoted;
@@ -749,7 +752,9 @@ isert_connect_error(struct rdma_cm_id *cma_id)
 		isert_conn->cm_id = NULL;
 	} else if (bound) {
 		isert_conn_terminate(isert_conn);
-		iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
+		if (full_feature)
+			iscsit_cause_connection_reinstatement(isert_conn->conn,
+							      0);
 	}
 	mutex_unlock(&isert_conn->mutex);
 
-- 
2.43.0

