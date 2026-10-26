Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792988405;
	b=sCRLhFjwvmVJIfTAQRThYMu4rs1fYoPScnHMBQ/sDq3RqG0pIFMg3+BVrKp6xauaaZq7
	 69gfSvS+5ishuyTaAQoFgQNxu4x2lapAhcVoeiznYUi6tlFBtL4naWo3xZePeR7cRDtMT
	 dKKyrZ3wmT4xvzKSWTEc3641e0NAWYoAexHILJTQhL4dYQB2QqTibNzm0sReYz31M/m/n
	 qxEDfvIeEbFoU54zRhyOVNyZI+QuTa4AA/Ov0HiOiljRPb0rxjId6ZAqEoETL77bx8sZt
	 oqYPCRIdCg5nbhe85u8TZFYOjVuURfYlgeRcI/R4BRRhzA68EAUBqF3yPjlqS2yso7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792988405;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BafRKiy+z7eJw961nwDzH1YBslR1OL/QLIkk9c2cuPI=;
	b=KdCc+5rKa9I2Lh40WUokNrXWp6ZqXmkVo4rwhRK/QFDvKtAW/rySF9qhNfRhCaaOPRLX
	 ToFgSGs9jVQBq6OhzbISVCBl/uHmmqXtdzIeJcDuY3Mq6Bc6d9tEJ1S6nmzQaRrhPPTVY
	 HC81C1ovSw2FhkDXBlj+uSQNh+OLk7OnCrRpuZlfIJHDdUOU2bMRqheAvQKBijzD3gIcI
	 DtlvWezzxkPv9G0P3obFHU+fg19Peffd6XzbxUse1PqhNg4zfxLkmMp0u0bdhGdUnaU9P
	 /8IhFPNXBbXmwx+WLF/c1A8pT2RnqYvj2izyo+mtc4rynrZ5d+POK3Hlqk1+eRm+SiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=hfFWDX+v;
	arc=none smtp.remote-ip=209.85.216.54
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D1C606A31B
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 04:20:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1D1C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=hfFWDX+v
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3acb512a7a0so1272724a91.1
        for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 21:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792988402; x=1793593202; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BafRKiy+z7eJw961nwDzH1YBslR1OL/QLIkk9c2cuPI=;
        b=hfFWDX+v4Fs7KzbWApW4ntKpBvYLk1Ntym2MRSsx0Eiu9ptn6BlOh3JUkuTFv1Eo5g
         j8RCQBh3YtnD0a6iN9gCw+HJHe3Nob4r5Bk5ynEjbOFRSh4hDFRwbNBSV63QpD9cveKH
         9TgCsQAtV4xuF1obcOs3rDE5rlbxGBTaUI2q5OB2jFxMNX97ci7nGn1mkzVDtL8RGnoL
         +Uj7PGWMOJtL18XPIYVgcAQJGfN+fcHy/+VXTRBzAiO0pxmKU87Vmb/f5MewftTkuI+s
         0FHLzhMA2VWnAL2+urmvydEASfcpTBM0rfUTeTR0XyxkdniBZC5VfFKBJfsnrvZra0BX
         M6xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792988402; x=1793593202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BafRKiy+z7eJw961nwDzH1YBslR1OL/QLIkk9c2cuPI=;
        b=DKGYVvC5bSKo4411/UPk5HzGZmb+29NoKHoRoH4EkG785dzehaNSzFsZPz95YGrkE5
         XGVvEWxPxCgvwqJ/5j+2hukwx7FC3RjPKvCFC2404H0XuOXts/Bwm762IYHcp7g4E5uq
         PmyyT5UILn5FiSz1lXu8b7MyEc2rsnZ830H/DtlozhxO9ZKsa39g1LUUYmGZ5h4p2i6c
         kRo28ZTPDugPHIodY1zNN1OEchK87839+2ndnN1YxGadR0WKYZ7mblBQkNvwWJ7Rpkc9
         WUoW3GU/kbcHNut6cY/vIthkds7qspMUT9SHOjZ18nl0sRPXlocvEX7sYRQTj7mKmmeP
         ES5Q==
X-Forwarded-Encrypted: i=1; AKwUvBz+3yJH4hnRERH6J8sHzlgqkZBXQefEaTtXggxghcINmHNdq7VyjixM1EQL/oqWxdw2AeN8OjPOX0NT@vger.kernel.org
X-Gm-Message-State: AFq9FYKX2MyYGFMCIrA9vQPKPkCRUjjRIIvfIo2DWVAbXGEFmogiVklz
	BH8ghC+rannvr7Y9P+GoMv8Gui81jW+tjXJ5QM+cuD5tQio0SmpoKsmBSGebl30+X/Q=
X-Gm-Gg: AYBFou3Llo3ySe4YSjm/g2SM7sqsYLVRXMZ3nf2bXHQA9ve8yv3PVMQBOnsRTEEyvTC
	aottkKk9Vp1GJbwFNzB96IBi1LZOXy/MIJaUaviE+ZDmzv1+GrfZd/qB/8L6tpzMc0TKEEbFEHY
	Bf2ZdMZ+UfVGFnNx/J2BdKjTr+2/ULImx9lYOSJSH0Fzu1k6fc8MaE8Sdg/zCq2zoEzt3kGWLJE
	U0GUISjrE5jj7B3WvwP4freCGEimweP1adzTFSPXcvMbgN+Agk57i7S7n7cp9XdJvgXIuQNPF9S
	vP2hsJIYTytqdVrkIJGbFDhW+boEkobFGETY/QTRsLuhPNbUi3e6wY2o5oFimiD1zV2kxE73VDU
	CqEEB6mAdqtgYCkk2+erVc/GXCe3VLSBPomrzYdypxEepjzZomYZVYQO5m65l+2M8FFH/ClRmZ4
	bIZ3KJhLm5IeWtZX7qYmfnamsSvkjStLLVId/MrKtOXgBRSfktyY9pU6QoniVxe1bUS9iZK4cJ4
	bzNDh1XnsVccuiT5oXAdr5vPFkkfyTpfxQVsLT5ajV0dlELf/3vDR8i4UJ59d4CMALR5YOxJKXy
	WWaF/0iRMMsU1dM0/Vuo/ZLIfzEUZFgsbgKGAyjcmpRIddAP
X-Received: by 2002:a17:90b:4a86:b0:3a7:e126:4980 with SMTP id 98e67ed59e1d1-3adeae6d5cdmr4716362a91.43.1792988401686;
        Sun, 25 Oct 2026 21:20:01 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adeb82761esm4862118a91.0.2026.10.25.21.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 21:20:01 -0700 (PDT)
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
Subject: [PATCH v2] IB/isert: tear connections down from an ib_client on device removal
Date: Mon, 26 Oct 2026 13:19:49 +0900
Message-ID: <20261026041949.225619-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261026000733.4178856-1-yhlee@isslab.korea.ac.kr>
References: <20261026000733.4178856-1-yhlee@isslab.korea.ac.kr>
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

The RDMA_CM_EVENT_DEVICE_REMOVAL callback waits for the connection to
reach ISER_CONN_DOWN and then frees it:

	wait_event_interruptible(isert_conn->rem_wait,
				 isert_conn->state == ISER_CONN_DOWN);
	kfree(isert_conn);

That is a use-after-free.  isert_release_work() publishes ISER_CONN_DOWN
before the last reference is dropped, so the condition is already true
when isert_connect_release() starts and the callback frees isert_conn
while isert_connect_release() is still dereferencing it.  Publishing the
state next to the wake-up instead does not close it either, because the
condition is evaluated without any lock, so the waiter can leave the wait
and free isert_conn while the releasing thread is still inside
wake_up_interruptible() taking isert_conn->rem_wait.lock.

The wait also deadlocks.  cma_send_device_removal_put() runs the callback
with the cm_id's handler_mutex held and rdma_destroy_id() takes that same
mutex, so a teardown that has already passed the isert_conn->dev_removed
test in isert_connect_release() blocks there while the callback waits for
that teardown to publish ISER_CONN_DOWN.  Nothing in the callback can
test whether the teardown has reached that point.

Tear the connections down from an ib_client removal callback instead,
where no cm_id lock is held, and wait there for the last isert_device
reference, which isert_connect_release() drops once it is done with the
device.  nvmet-rdma fixed the same two problems the same way, see
commit f1d4ef7d8883 ("nvmet-rdma: register ib_client to not deadlock in
device removal").

The cm callback now returns zero for RDMA_CM_EVENT_DEVICE_REMOVAL and
keeps the cm_id, which leaves isert_connect_release() as the only place
that destroys it, so isert_conn->dev_removed and isert_conn->rem_wait are
gone.  A connection that never reached RDMA_CM_EVENT_ESTABLISHED now
delays the removal until the CM reports RDMA_CM_EVENT_UNREACHABLE and
isert_connect_error() drops the last reference.  Before this patch that
case blocked for good, because that CM event needs the handler_mutex the
waiting callback holds.

Measured with soft-RoCE under KASAN on a local device removal racing 32
connections: 11 of 20 unpatched runs hit the splat below and 0 of 20
patched runs did, and the removal itself finished in all 20 patched runs
and in none of the unpatched ones.  With the wait kept and its window
widened, 3 of 3 runs deadlocked and 0 of 3 did with this patch.  Normal
login and I/O passed 24 of 30 runs on either side of the patch.

  BUG: KASAN: slab-use-after-free in isert_connect_release+0x5cb/0x620
  Read of size 4 at addr ffff88810acbd158 by task kworker/u16:5/70

  CPU: 1 UID: 0 PID: 70 Comm: kworker/u16:5 Not tainted 7.3.0-CTL2-13247-g330517c63aa9 #1 PREEMPT(full)
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
   ? __pfx_process_one_work+0x10/0x10
   ? _raw_spin_lock_irq+0xcb/0xe0
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

  Allocated by task 81:
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

Fixes: 63b268d232b8 ("IB/isert: Properly release resources on DEVICE_REMOVAL")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v1 introduced a handler_mutex deadlock and did not close the rem_wait
use-after-free (review); redesigned to tear down from an ib_client
(nvmet-rdma pattern).

 drivers/infiniband/ulp/isert/ib_isert.c | 129 +++++++++++++++++++-----
 drivers/infiniband/ulp/isert/ib_isert.h |   4 +-
 2 files changed, 103 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index efa8d7b7844c9..35e4b9c917bd6 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -43,6 +43,8 @@ MODULE_PARM_DESC(sg_tablesize,
 
 static DEFINE_MUTEX(device_list_mutex);
 static LIST_HEAD(device_list);
+static DEFINE_MUTEX(isert_conn_mutex);
+static LIST_HEAD(isert_conn_list);
 static struct workqueue_struct *isert_login_wq;
 static struct workqueue_struct *isert_comp_wq;
 static struct workqueue_struct *isert_release_wq;
@@ -255,6 +257,8 @@ isert_device_put(struct isert_device *device)
 	if (!device->refcount) {
 		isert_free_device_ib_res(device);
 		list_del(&device->dev_node);
+		if (device->removal_comp)
+			complete(device->removal_comp);
 		kfree(device);
 	}
 	mutex_unlock(&device_list_mutex);
@@ -309,7 +313,7 @@ isert_init_conn(struct isert_conn *isert_conn)
 	INIT_LIST_HEAD(&isert_conn->node);
 	init_completion(&isert_conn->login_comp);
 	init_completion(&isert_conn->login_req_comp);
-	init_waitqueue_head(&isert_conn->rem_wait);
+	INIT_LIST_HEAD(&isert_conn->conn_list);
 	kref_init(&isert_conn->kref);
 	atomic_set(&isert_conn->ctrl_comp_cnt, 0);
 	mutex_init(&isert_conn->mutex);
@@ -468,6 +472,10 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	list_add_tail(&isert_conn->node, &isert_np->accepted);
 	mutex_unlock(&isert_np->mutex);
 
+	mutex_lock(&isert_conn_mutex);
+	list_add_tail(&isert_conn->conn_list, &isert_conn_list);
+	mutex_unlock(&isert_conn_mutex);
+
 	return 0;
 
 out_destroy_qp:
@@ -491,9 +499,12 @@ isert_connect_release(struct isert_conn *isert_conn)
 
 	BUG_ON(!device);
 
+	mutex_lock(&isert_conn_mutex);
+	list_del_init(&isert_conn->conn_list);
+	mutex_unlock(&isert_conn_mutex);
+
 	isert_free_rx_descriptors(isert_conn);
-	if (isert_conn->cm_id &&
-	    !isert_conn->dev_removed)
+	if (isert_conn->cm_id)
 		rdma_destroy_id(isert_conn->cm_id);
 
 	if (isert_conn->qp)
@@ -504,12 +515,13 @@ isert_connect_release(struct isert_conn *isert_conn)
 	if (isert_conn->login_desc)
 		isert_free_login_buf(isert_conn);
 
-	isert_device_put(device);
+	kfree(isert_conn);
 
-	if (isert_conn->dev_removed)
-		wake_up_interruptible(&isert_conn->rem_wait);
-	else
-		kfree(isert_conn);
+	/*
+	 * Releases isert_remove_one() once the last connection running on
+	 * this device is gone.
+	 */
+	isert_device_put(device);
 }
 
 static void
@@ -625,13 +637,10 @@ isert_np_cma_handler(struct isert_np *isert_np,
 	return -1;
 }
 
-static int
-isert_disconnected_handler(struct rdma_cm_id *cma_id,
-			   enum rdma_cm_event_type event)
+/* Must be called with isert_conn->mutex held. */
+static void
+isert_teardown_conn(struct isert_conn *isert_conn)
 {
-	struct isert_conn *isert_conn = cma_id->qp->qp_context;
-
-	mutex_lock(&isert_conn->mutex);
 	switch (isert_conn->state) {
 	case ISER_CONN_TERMINATING:
 		break;
@@ -648,6 +657,16 @@ isert_disconnected_handler(struct rdma_cm_id *cma_id,
 		isert_warn("conn %p terminating in state %d\n",
 			   isert_conn, isert_conn->state);
 	}
+}
+
+static int
+isert_disconnected_handler(struct rdma_cm_id *cma_id,
+			   enum rdma_cm_event_type event)
+{
+	struct isert_conn *isert_conn = cma_id->qp->qp_context;
+
+	mutex_lock(&isert_conn->mutex);
+	isert_teardown_conn(isert_conn);
 	mutex_unlock(&isert_conn->mutex);
 
 	return 0;
@@ -674,7 +693,6 @@ static int
 isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 {
 	struct isert_np *isert_np = cma_id->context;
-	struct isert_conn *isert_conn;
 	int ret = 0;
 
 	isert_info("%s (%d): status %d id %p np %p\n",
@@ -695,21 +713,15 @@ isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 		break;
 	case RDMA_CM_EVENT_ADDR_CHANGE:
 	case RDMA_CM_EVENT_DISCONNECTED:
-	case RDMA_CM_EVENT_TIMEWAIT_EXIT:  /* FALLTHRU */
-		ret = isert_disconnected_handler(cma_id, event->event);
-		break;
+	case RDMA_CM_EVENT_TIMEWAIT_EXIT:
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
-		isert_conn = cma_id->qp->qp_context;
-		isert_conn->dev_removed = true;
-		isert_disconnected_handler(cma_id, event->event);
-		wait_event_interruptible(isert_conn->rem_wait,
-					 isert_conn->state == ISER_CONN_DOWN);
-		kfree(isert_conn);
 		/*
-		 * return non-zero from the callback to destroy
-		 * the rdma cm id
+		 * Device removal is driven by isert_remove_one().  Returning
+		 * zero here keeps the cm_id; isert_connect_release() destroys
+		 * it once the connection has been released.
 		 */
-		return 1;
+		ret = isert_disconnected_handler(cma_id, event->event);
+		break;
 	case RDMA_CM_EVENT_REJECTED:
 		isert_info("Connection rejected: %s\n",
 			   rdma_reject_msg(cma_id, event->status));
@@ -2689,8 +2701,60 @@ static struct iscsit_transport iser_target_transport = {
 	.iscsit_get_sup_prot_ops = isert_get_sup_prot_ops,
 };
 
+static void
+isert_remove_one(struct ib_device *ib_device, void *client_data)
+{
+	DECLARE_COMPLETION_ONSTACK(removal_comp);
+	struct isert_device *device, *found = NULL;
+	struct isert_conn *isert_conn;
+
+	/*
+	 * Not from the RDMA_CM_EVENT_DEVICE_REMOVAL callback: that one runs
+	 * with the cm_id's handler mutex held, which a teardown already
+	 * destroying that cm_id needs.  Same reason as
+	 * commit f1d4ef7d8883 ("nvmet-rdma: register ib_client to not
+	 * deadlock in device removal").
+	 */
+	mutex_lock(&device_list_mutex);
+	list_for_each_entry(device, &device_list, dev_node) {
+		if (device->ib_device != ib_device)
+			continue;
+		device->refcount++;
+		device->removal_comp = &removal_comp;
+		found = device;
+		break;
+	}
+	mutex_unlock(&device_list_mutex);
+
+	if (!found)
+		return;
+
+	mutex_lock(&isert_conn_mutex);
+	list_for_each_entry(isert_conn, &isert_conn_list, conn_list) {
+		if (isert_conn->device != found)
+			continue;
+
+		isert_info("removing conn %p state %d\n",
+			   isert_conn, isert_conn->state);
+		mutex_lock(&isert_conn->mutex);
+		isert_teardown_conn(isert_conn);
+		mutex_unlock(&isert_conn->mutex);
+	}
+	mutex_unlock(&isert_conn_mutex);
+
+	isert_device_put(found);
+	wait_for_completion(&removal_comp);
+}
+
+static struct ib_client isert_ib_client = {
+	.name   = "isert",
+	.remove = isert_remove_one,
+};
+
 static int __init isert_init(void)
 {
+	int ret = -ENOMEM;
+
 	isert_login_wq = alloc_workqueue("isert_login_wq", WQ_PERCPU, 0);
 	if (!isert_login_wq) {
 		isert_err("Unable to allocate isert_login_wq\n");
@@ -2711,21 +2775,30 @@ static int __init isert_init(void)
 		goto destroy_comp_wq;
 	}
 
+	ret = ib_register_client(&isert_ib_client);
+	if (ret) {
+		isert_err("Unable to register isert ib client\n");
+		goto destroy_release_wq;
+	}
+
 	iscsit_register_transport(&iser_target_transport);
 	isert_info("iSER_TARGET[0] - Loaded iser_target_transport\n");
 
 	return 0;
 
+destroy_release_wq:
+	destroy_workqueue(isert_release_wq);
 destroy_comp_wq:
 	destroy_workqueue(isert_comp_wq);
 destroy_login_wq:
 	destroy_workqueue(isert_login_wq);
 
-	return -ENOMEM;
+	return ret;
 }
 
 static void __exit isert_exit(void)
 {
+	ib_unregister_client(&isert_ib_client);
 	flush_workqueue(isert_login_wq);
 	destroy_workqueue(isert_release_wq);
 	destroy_workqueue(isert_comp_wq);
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 519b17e54bd34..41023300be21b 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -191,8 +191,7 @@ struct isert_conn {
 	atomic_t		ctrl_comp_cnt;
 	bool                    logout_posted;
 	bool                    snd_w_inv;
-	wait_queue_head_t	rem_wait;
-	bool			dev_removed;
+	struct list_head	conn_list;
 };
 
 struct isert_device {
@@ -203,6 +202,7 @@ struct isert_device {
 	struct isert_comp	*comps;
 	int                     comps_used;
 	struct list_head	dev_node;
+	struct completion	*removal_comp;
 };
 
 struct isert_np {
