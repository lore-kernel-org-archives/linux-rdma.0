Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792973269;
	b=MU305V+sDQLUYGxlGfgkkWHefChwMYOmeFUKSMM2gbEmAZOJlcpk89aKpVc5w3YFVeP/
	 yJhv7z965ByRuf3008t9YrqNpwDWo6y78cQ5DNnQBeZqsLFT0+8jm3otTLthPoGXwGpFB
	 7YagKsUBAsU3gd+RHe6aRqSCQLbnSkagBCMMY17qVicXBffpVb11j3VfR7/auRO/avci4
	 Kzk8KdoM30LDJbNoO4XPQaPvkXNDt6WnUb1TahAkksx4sSItXczkGWrNCimGD2hDFo2E1
	 uJPSPTZJvmPINHMBGdIi84/VsSwVI7k50KvLSJJ+H7rAIXmkmlL3lzY9DVmX1Q4MGKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792973269;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VdkT2RHYcWV7GvnLz4TIAWoUXNhRorpoV7gVhnHjlPM=;
	b=s9B+9P0lo6CvehFDnuXRpJJXrQfqNzUALy8L3pn8fd/d3K0BG9PdqwLyPFVwOZTf4Zhi
	 Sc4vbZSXSSRN1cXSp1+Z1cnb9DYvhYTmVbo5tWBeKK8DGW96V8PfkrLGeHnOEEsSIC4Nc
	 hhJqvuALzqgZX3iuwAfUa2TMvqpQq9GxCLVgd7iNLeLp38qt0bTFVUmgXzY5Kmi8hao0N
	 s/b/5IZUruMslY7T+DC0r3uv+UdNqLX1f1j/jn634QgkaXr58qJLH7Y/j3jARRadVuFAP
	 PvmsYr/4p+hDTeZmu+ucM4e7b6TIKt/CbL6TeLteZTfGRLW6kg0/FE1P8wm3kQftKzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=lj3sD4Am;
	arc=none smtp.remote-ip=209.85.215.178
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B066C606A31B
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 00:07:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B066C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=lj3sD4Am
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cd69954c755so1647543a12.3
        for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 17:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792973267; x=1793578067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VdkT2RHYcWV7GvnLz4TIAWoUXNhRorpoV7gVhnHjlPM=;
        b=lj3sD4Am/aiIHN7NCAcRfN8n2iip+RovV4pk3Sly44YZsCSGUEBj0DgCgvVeVkFXdQ
         9TlJQ9zIP1xpPhhThjHi7/fEoyCZRadpXMA1mFN0dhmRKlBS+4Yt6sMuPKdAuYTKmidm
         wgYwnYUCIvkmHVBO2/TiZnuiRiDbFG4dm4oWEGSBwkyrgtcU7j0RrzOCZblUVFiuZDap
         KcKh1TNZmjBRoqMHVb+CyrBPd08FR3LSOSHmDKWpeihRtLAhNA+D9/GvJ5NZFCt47jbV
         p2c18tE05jCBwMtNuFxU8O+gxvcJdUzcIBhe5NRpVL1PFgtC7pzBztio7v/bKGy0ffTm
         KMJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792973267; x=1793578067;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VdkT2RHYcWV7GvnLz4TIAWoUXNhRorpoV7gVhnHjlPM=;
        b=Ag9aPMDxJGQp9GaItIoFni/ScScA9Rw5Az0V6QMNYxeJqsCLHS41WrfDkXWHyHvf1A
         H72DGaJCv8g6ltGTgDlm7dtfTEL6DlkO7yVORxBsasX+Nu2Yyq981SONyeobHRACIp7x
         u23T0jdcDSXqyHn+uTo22tMjOY1woUWcigUpR8ltVKNwZ8wIr2HWOVv6GqedAKJsz6Uc
         2C4N3IrXEUecpXAggISZWGkwtFtNqwK4x2putqdudHAyP8DQdUO+6ltRZ4kcePqvG3Y4
         LgVr4AjuBBc+WWpAfMZLhmiQjZbsWTdN+9CqO8dB5t7uOxS2/QK236cVoX6LzCNvBpPF
         OOtA==
X-Forwarded-Encrypted: i=1; AKwUvBwaJSaIe11RywTSG1wpGEa1zfObiPlmMIv7/QrBfnPJocl4K1zRxReEnAXv5NegOIzdkHvn3JtP1VUz@vger.kernel.org
X-Gm-Message-State: AFq9FYK/iXgvyGGTxeVnRU7wzdsjW8uUJrSYxvY6nhqezOEEBuC7/VdR
	Qig9qpYiQUCJiCOmELtRPPMY8HwKKrRe8UyGyOCktnbkZS1Isf5D6mG4pqDqwUk5EiI=
X-Gm-Gg: AYBFou04VFkwryxZk8lHA6uskYGj7xJUMscc2w3Q4PppUgLUR7nyFMb65/vqnSctXsZ
	FQSYD17eXhebI06IPG/M3QfpnSG/DhLcmtFAJxWvNFnXmy+XHVJ/otcHs58Ihop5r6oUYAxgRRb
	TX7kMzeljAuTTtT6QzhAbStPK66xfh/fUSRwI+XpzjmmHL9Xms8cvN4URlaSTjSwSt2MbJjo5zV
	Tcnvg5HWepkLjUdr1MTjd5NIg05PHrz8ZLXiXZjVD3T4ye47gf0Vexg37N4C+3LqntG+K1ys72b
	M9e+IEsf/G8wl3hQ6xbNRlUfXcD73UZATpv6/RJ60Xha4LWxsDzcHgIM1GzLnlWplSh8CQZIGpe
	WOM2Boh5Tb6W4iY5f4sqm9693GVSC9rvKz509QFCCCmbFJp0tcP5FQ4OXD4b9lO1cys2PFS7BB9
	IcWEt6Mpm/4wJ5zRo/HY+Bd68E62pTRyZk398zZBYKAiWLuFr2YWuPxIzqSGxxj96q7QttBwf8m
	Ig2Vc2N++4h97thUQUWn3RdU/6nszK9p6FX6QYMTpMP6G3j6LFuKKWTlswr/R1cxI+xleN7ieVb
	Kd+0TLFWBhSiYxncSVY547cM/t9wxgfTbkKunmgyO66GmQg6dgWaMeysDiG0LeSg8TqdGA==
X-Received: by 2002:a17:90a:e7ca:b0:3a8:59d3:5317 with SMTP id 98e67ed59e1d1-3adeaf98405mr4816886a91.32.1792973266605;
        Sun, 25 Oct 2026 17:07:46 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adeb819729sm5942331a91.0.2026.10.25.17.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 17:07:46 -0700 (PDT)
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
Subject: [PATCH] IB/isert: set ISER_CONN_DOWN only after the connection has been released
Date: Mon, 26 Oct 2026 09:07:33 +0900
Message-ID: <20261026000733.4178856-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
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

Removing an RDMA device (rdma link delete, module unload, hot-unplug -
a local administrative action) while an iSER connection is in
ISER_CONN_UP, i.e. the CM handshake has completed but iscsi has not
yet accepted it through isert_accept_np(), lets the
RDMA_CM_EVENT_DEVICE_REMOVAL handler free the isert_conn while
isert_connect_release() is still tearing it down.  A remote initiator
alone cannot trigger this; it can only supply the ISER_CONN_UP
connections that the local device removal then races against.

isert_cma_handler() waits for the connection to reach ISER_CONN_DOWN and
then frees it:

	wait_event_interruptible(isert_conn->rem_wait,
				 isert_conn->state == ISER_CONN_DOWN);
	kfree(isert_conn);

but isert_release_work() published ISER_CONN_DOWN before dropping the
last reference, so the condition becomes true at the start of the
teardown instead of at its end.  The wake-up at the end of
isert_connect_release() is in the right place; the condition was not.
The handler could return and free isert_conn while
isert_connect_release() was still dereferencing it.

That ordering requirement is not incidental.  Sagi Grimberg spelled it
out when this handling was introduced (2014-10-28,
<544FC5B2.70104@dev.mellanox.co.il>): "cma_remove_one sequence ...
requires the cmd is owner to finish cleanup before the end of the
callback because in the end of it, it will allow the device to remove."

Publish ISER_CONN_DOWN from isert_connect_release() instead, immediately
before the wake-up, so the condition and the signal refer to the same
point.  It has exactly one store and one load in the tree, so nothing
else is affected.  The store no longer takes isert_conn->mutex: the last
reference has been dropped, the only legitimate accessor left is the
rem_wait waiter, and wake_up_interruptible() provides the ordering.
isert_conn->state is already accessed without that mutex in
isert_accept_np() and in the wait condition itself.

One visible side effect: the connection now stays in
ISER_CONN_TERMINATING until isert_connect_release() runs, so a second CM
event in that window takes the ISER_CONN_TERMINATING case instead of
default:, and the "conn %p terminating in state %d" warning is no longer
logged.

Reproduced with soft-RoCE (rdma_rxe) under KASAN, preempt=full, an
initiator opening 32 CM-only connections (no login PDU) concurrently, so
that they queue up in ISER_CONN_UP, followed by "rdma link delete".  The
window is sub-microsecond, so the rate is low.  The splat below
reproduces on an unmodified kernel and does not with this patch applied
(36 of 60 runs unpatched, 0 of 60 patched).

  BUG: KASAN: slab-use-after-free in isert_connect_release+0x5cb/0x620
  Read of size 4 at addr ffff88810ca1d158 by task kworker/u16:1/43

  CPU: 0 UID: 0 PID: 43 Comm: kworker/u16:1 Not tainted 7.3.0-CTL2-13247-g330517c63aa9 #1 PREEMPT(full)
  Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  Workqueue: isert_release_wq isert_release_work
  Call Trace:
   <TASK>
   dump_stack_lvl+0x53/0x70
   print_report+0xd0/0x630
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   ? kfree+0x121/0x390
   ? isert_connect_release+0x5cb/0x620
   kasan_report+0xce/0x100
   ? isert_connect_release+0x5cb/0x620
   isert_connect_release+0x5cb/0x620
   process_one_work+0x697/0x1060
   ? __pfx___schedule+0x10/0x10
   ? __pfx_process_one_work+0x10/0x10
   ? _raw_spin_lock_irq+0x81/0xe0
   ? __pfx_isert_release_work+0x10/0x10
   ? assign_work+0x11d/0x370
   worker_thread+0x45b/0xd10
   ? __pfx_worker_thread+0x10/0x10
   kthread+0x2c8/0x3b0
   ? recalc_sigpending+0x15c/0x1e0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x36e/0x5a0
   ? __pfx_ret_from_fork+0x10/0x10
   ? __switch_to+0x572/0xdc0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1a/0x30
   </TASK>

  Allocated by task 24:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   __kasan_kmalloc+0x8f/0xa0
   __kmalloc_cache_noprof+0x148/0x360
   isert_cma_handler+0x1e3/0x2840
   cma_cm_event_handler+0x3e/0x240
   cma_ib_req_handler+0x17d9/0x4480
   cm_process_work+0x41/0x330
   cm_work_handler+0x5727/0xc160
   process_one_work+0x697/0x1060
   worker_thread+0x45b/0xd10
   kthread+0x2c8/0x3b0
   ret_from_fork+0x36e/0x5a0
   ret_from_fork_asm+0x1a/0x30

  Freed by task 218:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   kasan_save_free_info+0x3b/0x60
   __kasan_slab_free+0x43/0x70
   kfree+0x121/0x390
   isert_cma_handler+0x10ff/0x2840
   cma_cm_event_handler+0x3e/0x240
   cma_process_remove+0xff/0x5a0
   cma_remove_one+0xcc/0x250
   remove_client_context+0xa4/0xf0
   disable_device+0x128/0x240
   __ib_unregister_device+0x226/0x3f0
   ib_unregister_device_and_put+0x50/0x70
   nldev_dellink+0x28e/0x3d0
   rdma_nl_rcv_msg+0x29c/0x4e0
   rdma_nl_rcv_skb.constprop.0.isra.0+0x21d/0x370
   netlink_unicast+0x68f/0x940
   netlink_sendmsg+0x810/0xf20
   __sys_sendto+0x337/0x390
   __x64_sys_sendto+0xdb/0x1b0
   do_syscall_64+0xdd/0x4a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

Not fixed here: a connection still in ISER_CONN_INIT when the device is
removed is never cleaned up - isert_disconnected_handler() only warns -
so nothing makes the wait condition true and the removal blocks.  That
pre-existing case is why the wait is left interruptible rather than
converted to wait_event().

Fixes: 63b268d232b8 ("IB/isert: Properly release resources on DEVICE_REMOVAL")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index efa8d7b7844c9..cd0ca3cf131cb 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -506,10 +506,18 @@ isert_connect_release(struct isert_conn *isert_conn)
 
 	isert_device_put(device);
 
-	if (isert_conn->dev_removed)
+	if (isert_conn->dev_removed) {
+		/*
+		 * Publish ISER_CONN_DOWN only now.  The
+		 * RDMA_CM_EVENT_DEVICE_REMOVAL handler waits for it and then
+		 * frees isert_conn, so it must not become visible before the
+		 * teardown above has finished using the connection.
+		 */
+		isert_conn->state = ISER_CONN_DOWN;
 		wake_up_interruptible(&isert_conn->rem_wait);
-	else
+	} else {
 		kfree(isert_conn);
+	}
 }
 
 static void
@@ -2537,10 +2545,6 @@ static void isert_release_work(struct work_struct *work)
 
 	isert_info("Starting release conn %p\n", isert_conn);
 
-	mutex_lock(&isert_conn->mutex);
-	isert_conn->state = ISER_CONN_DOWN;
-	mutex_unlock(&isert_conn->mutex);
-
 	isert_info("Destroying conn %p\n", isert_conn);
 	isert_put_conn(isert_conn);
 }
