Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793710833;
	b=lZJ6mKyKN4ouBOwTe91D5hIusWD9vdcLmG5e3P/O8Kof4Td9VKbR5syaTMkdg9YE7DPx
	 LtmW2109MQ1BvOrSb9mk99yaYP8AkQfKmHNyGcSqsS7dqyTEBXvWGt3E6ugQ/X9y3qDCO
	 ROE6np8IJuGO5VQcM0ic3re45iG3OTP82KrhRRYH2wi6fmAheEzjsSPWnOgAmsc4LWkzM
	 1yNj25du7z5al/mCXpcTXl1rwBUt4nIdaIKJalG1fQalr2RuUAb2lSrfvf2tOA4wpyTKp
	 tCsLQl+kRmd4XHpC7lCqbGHhLyXRKxA4xSxEl6IO3fPaWgFTkIdKoSS1jAIYcOvyHig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793710833;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1IA5ETZMPLzSompMwTaW9OXY4U7uitMWLAXP4GzW4Ik=;
	b=GJchg5NgkzkwpObnOCfx3b+b2dVyv47PNkw5h28z9W0t6uXo8oS/kzXRDIqNFa51u449
	 hOfEOqd1Q6xeVU0nkaBLLMZMXbAynR7UV0g/mZmiQeo9wru2dCGwqhCRNA9pkA4aqVG9u
	 q7HaV+KP0NUlS1mLaWOOHZjO+TbNttEOciL7JIJWR7Pi8rZKWer137v9cAiMnzX5E3P+J
	 vAYNpEhBpjp1HLQAIpKDV2BIxmAOTo+g+GIUmyEW9nQtPdcg5FbA9JYjWLFI1ELZ2jJKu
	 ZbqjWCMeHVY5B0kUluAJEt8DvAYU2JZLWQwpZGefP9pzCzHNrQbyZkoAczAPcZOJ/dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=RK12Qm3Y;
	arc=none smtp.remote-ip=74.125.82.54
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C93606D818
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 13:00:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97C93606D818
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=RK12Qm3Y
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1a2761c69fbso6999652c88.0
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 05:00:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793710832; x=1794315632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1IA5ETZMPLzSompMwTaW9OXY4U7uitMWLAXP4GzW4Ik=;
        b=RK12Qm3Yz7IKC9pfKFiOX3VfPWzsgruK3Ww5G+s5G7ax+Bw9hSLJ2xtlx3Hu0HufHV
         JJWSD97RzypjlAqOQ8+O4ctaWa78Jp/MTWm3+1qZDuW13X+WJrZ3hbaFsjMGrOnM8Rmv
         rjr/QQT/5tYX91qThR65w7FVMo8fyP5yr7O1oQOyBTpJDUgqoxCOjUe/nK2zoAQEzMTV
         CqxO0VnBoscmZaNP+u0vBsR8IIkBLMD0CHBItNrkAZ1xkxZeQi0adsSk4Q/3BWe1MXnY
         /ab5OMQJDG7eGma7ih/i/bYw6x2xtUSS+IFuSitQiLn8AXU25E7lZp6DUnrWExl1pV1o
         peQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793710832; x=1794315632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1IA5ETZMPLzSompMwTaW9OXY4U7uitMWLAXP4GzW4Ik=;
        b=QhIVUCRyOyzQmRiBEojrdixpFSNzmTrYtJAriI4jwV+0bFMHvm++gbdh6ZPrTVIKl5
         VcmFvXrutc8U0kRi4FahK2c97JALpU5xuxaMR7UWgf4GzDkrkw9fDenV8K45SHVK899y
         D8sSoUdxEvfkp9iDTZMhjFylvVfOAhkKmI+ED8DsYf3+/XmWv0zUYGC4eQBSvtQ9zdoc
         qZy5KXcW3f7ADK+NVwqxkFw77eN5gu3npOI4yQNUduYFCm2xnFcTIOYE9NT38iKxArR7
         jwgIa0SQ9as+yYPd+6Nce1pjbp7H7hCeWYr+/dra11vc/1sJz//HLn+L9jJCnqbjXKkl
         n4tA==
X-Forwarded-Encrypted: i=1; AKwUvBz0JJA9ZYS67dLGvIAqA+FWTfln66umKwj5Q4V8YpesXFbC1tGzkPwBPm07jWRbZSrr9zkzvlxsSPga@vger.kernel.org
X-Gm-Message-State: APuU4Z/jJFbFRdK2583IyXHcmogNstm2tAIHlfjBlAZUCdyZ9u3DrM8W
	RcPQSDLhcrjpy0ZsogQ4+xNz5vAtap3LsRwmBkwhNsm0DstElA1+BAE/ZSXX+Avr6WE=
X-Gm-Gg: AYBFou22erW3SdxoaVDzmZDLa153Ksx3sy7t6CxVFF71DpFTahJuC+31vqV1zSBG9Pb
	gEGrtLO5KBb9NkTwiI3+U5TSMjxSN5hKod5ddxr+zMV9mUZ5qPYLiLxNQRRG4bh2A/y9iNSBO2k
	63GBImvnkpIkL9Pxbi8i5b4hzJOL1u3FJjHkrKn8UPTissu8ShpmsOUe/fdcndhc9VBsXe6Gwq7
	hwlnDS5tU849vLcD7krWvFVfR95QMIKUB/f9YvcQpVWtTp/FqZmjryZUnldF/NBsSCVyuXmPneD
	Q4nRqBmtt2S31/3FNEPl/anmJnbQoXCbHLSurpF5GQ8m+6YkmhiQ8WpkC1o7psUf3CIJm8r/pj7
	Mo7B+K3Aiha4fuxt+0Y2L0V6cNGf4lAVpo+Z6sjuTyXNFXVsCmLiE70nKYDcTVBpIXmYZFjZi9W
	S/sNAfltjmTnj+U6hdwqn4IQI01WBPvIXGrOPZifZzs1HTzsZSCjZtnDbMplMCYUEdTN/mBPiEa
	9mMqqIKy9YwjsoGTmQFxb0bLOQ3BpFkIAbKj7mp5UjQ11Oed+a90hwbDx/jkpVGn5Eh7/ws7aEj
	EkvdNxWfYgqKN/9N3clli2vjSI0edl+IvW44JKa0SP3Pafy4M8MN0nK142NOyEMeWit63i/3Is/
	w6RgK9BAI6XAAg34qtb/7dtybFkptO7vF7qfs/y5CUaDwcVDZuPMx7nFxMlk=
X-Received: by 2002:a05:7022:eb42:20b0:186:4a57:94e5 with SMTP id a92af1059eb24-1ac5c272744mr20693402c88.34.1793710831233;
        Tue, 03 Nov 2026 05:00:31 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:2da3:4696:4c5e:89c1])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42669128sm50806107eec.3.2026.11.03.05.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:00:30 -0800 (PST)
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
Subject: [PATCH v5 3/5] IB/isert: tear connections down from an ib_client on device removal
Date: Tue,  3 Nov 2026 21:59:53 +0900
Message-ID: <20261103125955.1530355-4-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103125955.1530355-1-yhlee@isslab.korea.ac.kr>
References: <20261103125955.1530355-1-yhlee@isslab.korea.ac.kr>
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

The RDMA_CM_EVENT_DEVICE_REMOVAL callback waits for the connection it was
handed to reach ISER_CONN_DOWN and then frees it.  isert_release_work()
publishes that state before it drops its reference, so the handler can free
a connection that isert_connect_release() is still running on.  The wait
itself deadlocks against the handler_mutex rdma_destroy_id() needs.

Register an ib_client instead, as nvmet-rdma did in commit f1d4ef7d8883
("nvmet-rdma: register ib_client to not deadlock in device removal"), and
tear the device's connections down from its remove callback.  It walks
isert_conn_list under isert_conn_mutex, takes a reference with
kref_get_unless_zero(), tears each one down after dropping the lock, and
asks iscsi to reinstate the session.  isert_device_put() completes
removal_comp once the CQs and the PD are gone.  Publishing now happens in
the same isert_conn_mutex section that tests isert_device->removing, and
isert_np is reference counted because a connection can outlive its portal.

This cell drives 32 logins and then deletes the device, with no delay knob.
One of twelve runs of 7.4-rc1 finished the removal, and two reported the
use-after-free below, 17 and 11 times; all twelve runs of this series
finished and none reported it.  The sides ran in separate rounds.

  BUG: KASAN: slab-use-after-free in isert_connect_release+0x5cb/0x620
  Read of size 4 at addr ffff88810af75158 by task kworker/u16:6/76

  CPU: 1 UID: 0 PID: 76 Comm: kworker/u16:6 Not tainted 7.4.0-rc1-CTL #19 PREEMPT(full)
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

  Allocated by task 51:
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

  Freed by task 217:
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
 drivers/infiniband/ulp/isert/ib_isert.c | 274 +++++++++++++++++-------
 drivers/infiniband/ulp/isert/ib_isert.h |   9 +-
 2 files changed, 208 insertions(+), 75 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 61b214012a70b0..4812dabd939453 100644
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
@@ -56,6 +58,10 @@ isert_rdma_accept(struct isert_conn *isert_conn);
 struct rdma_cm_id *isert_setup_id(struct isert_np *isert_np);
 
 static void isert_release_work(struct work_struct *work);
+static void
+isert_put_np(struct isert_np *isert_np);
+static void
+isert_teardown_conn(struct isert_conn *isert_conn);
 static void isert_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 static void isert_send_done(struct ib_cq *cq, struct ib_wc *wc);
 static void isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc);
@@ -255,6 +261,8 @@ isert_device_put(struct isert_device *device)
 	if (!device->refcount) {
 		isert_free_device_ib_res(device);
 		list_del(&device->dev_node);
+		if (device->removal_comp)
+			complete(device->removal_comp);
 		kfree(device);
 	}
 	mutex_unlock(&device_list_mutex);
@@ -309,7 +317,8 @@ isert_init_conn(struct isert_conn *isert_conn)
 	INIT_LIST_HEAD(&isert_conn->node);
 	init_completion(&isert_conn->login_comp);
 	init_completion(&isert_conn->login_req_comp);
-	init_waitqueue_head(&isert_conn->rem_wait);
+	INIT_LIST_HEAD(&isert_conn->conn_list);
+	INIT_LIST_HEAD(&isert_conn->removal_node);
 	kref_init(&isert_conn->kref);
 	atomic_set(&isert_conn->ctrl_comp_cnt, 0);
 	mutex_init(&isert_conn->mutex);
@@ -456,17 +465,34 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 		goto out_rsp_dma_map;
 	}
 
+	mutex_lock(&isert_conn_mutex);
+	if (device->removing) {
+		mutex_unlock(&isert_conn_mutex);
+		isert_info("device %p is being removed, rejecting conn %p\n",
+			   device, isert_conn);
+		ret = -ENODEV;
+		goto out_destroy_qp;
+	}
+
 	ret = isert_login_post_recv(isert_conn);
-	if (ret)
+	if (ret) {
+		mutex_unlock(&isert_conn_mutex);
 		goto out_destroy_qp;
+	}
 
 	ret = isert_rdma_accept(isert_conn);
-	if (ret)
+	if (ret) {
+		mutex_unlock(&isert_conn_mutex);
 		goto out_destroy_qp;
+	}
 
+	isert_conn->np = isert_np;
+	kref_get(&isert_np->kref);
+	list_add_tail(&isert_conn->conn_list, &isert_conn_list);
 	mutex_lock(&isert_np->mutex);
 	list_add_tail(&isert_conn->node, &isert_np->accepted);
 	mutex_unlock(&isert_np->mutex);
+	mutex_unlock(&isert_conn_mutex);
 
 	return 0;
 
@@ -486,14 +512,18 @@ static void
 isert_connect_release(struct isert_conn *isert_conn)
 {
 	struct isert_device *device = isert_conn->device;
+	struct isert_np *isert_np = isert_conn->np;
 
 	isert_dbg("conn %p\n", isert_conn);
 
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
@@ -504,12 +534,11 @@ isert_connect_release(struct isert_conn *isert_conn)
 	if (isert_conn->login_desc)
 		isert_free_login_buf(isert_conn);
 
-	isert_device_put(device);
+	kfree(isert_conn);
 
-	if (isert_conn->dev_removed)
-		wake_up_interruptible(&isert_conn->rem_wait);
-	else
-		kfree(isert_conn);
+	if (isert_np)
+		isert_put_np(isert_np);
+	isert_device_put(device);
 }
 
 static void
@@ -517,22 +546,37 @@ isert_connected_handler(struct rdma_cm_id *cma_id)
 {
 	struct isert_conn *isert_conn = cma_id->qp->qp_context;
 	struct isert_np *isert_np = cma_id->context;
+	bool owned, promote;
 
 	isert_info("conn %p\n", isert_conn);
 
+	mutex_lock(&isert_conn_mutex);
 	mutex_lock(&isert_conn->mutex);
 	mutex_lock(&isert_np->mutex);
-	if (list_empty(&isert_conn->node)) {
-		mutex_unlock(&isert_np->mutex);
-		mutex_unlock(&isert_conn->mutex);
-		isert_info("conn %p is being released already\n", isert_conn);
-		return;
+	owned = !list_empty(&isert_conn->node);
+	promote = owned && isert_conn->state < ISER_CONN_TERMINATING &&
+		  !isert_conn->device->removing;
+	if (promote) {
+		isert_conn->state = ISER_CONN_UP;
+		kref_get(&isert_conn->kref);
+		isert_conn->promoted = true;
+		list_move_tail(&isert_conn->node, &isert_np->pending);
 	}
-	isert_conn->state = ISER_CONN_UP;
-	kref_get(&isert_conn->kref);
-	list_move_tail(&isert_conn->node, &isert_np->pending);
 	mutex_unlock(&isert_np->mutex);
 	mutex_unlock(&isert_conn->mutex);
+	mutex_unlock(&isert_conn_mutex);
+
+	if (!owned) {
+		isert_info("conn %p is being released already\n", isert_conn);
+		return;
+	}
+
+	if (!promote) {
+		isert_info("conn %p is not promoted, state %d\n",
+			   isert_conn, isert_conn->state);
+		isert_teardown_conn(isert_conn);
+		return;
+	}
 
 	isert_info("np %p: Allow accept_np to continue\n", isert_np);
 	up(&isert_np->sem);
@@ -556,6 +600,20 @@ isert_put_conn(struct isert_conn *isert_conn)
 	kref_put(&isert_conn->kref, isert_release_kref);
 }
 
+static void
+isert_release_np_kref(struct kref *kref)
+{
+	struct isert_np *isert_np = container_of(kref, struct isert_np, kref);
+
+	kfree(isert_np);
+}
+
+static void
+isert_put_np(struct isert_np *isert_np)
+{
+	kref_put(&isert_np->kref, isert_release_np_kref);
+}
+
 /**
  * isert_conn_terminate() - Initiate connection termination
  * @isert_conn: isert connection struct
@@ -610,48 +668,50 @@ isert_np_cma_handler(struct isert_np *isert_np,
 	return -1;
 }
 
-static int
-isert_disconnected_handler(struct rdma_cm_id *cma_id,
-			   enum rdma_cm_event_type event)
+static void
+isert_teardown_conn(struct isert_conn *isert_conn)
 {
-	struct isert_conn *isert_conn = cma_id->qp->qp_context;
-	struct isert_np *isert_np = cma_id->context;
-	bool owned = false, bound = false, terminated = false;
+	struct isert_np *isert_np = isert_conn->np;
+	bool owned = false, bound = false;
+	bool promoted = false, terminated = false;
 
 	mutex_lock(&isert_conn->mutex);
-	switch (isert_conn->state) {
-	case ISER_CONN_UP:
-		mutex_lock(&isert_np->mutex);
-		if (list_empty(&isert_conn->node)) {
-			bound = isert_conn->state == ISER_CONN_BOUND ||
-				isert_conn->state == ISER_CONN_FULL_FEATURE;
-		} else {
-			owned = true;
-			list_del_init(&isert_conn->node);
-		}
-		mutex_unlock(&isert_np->mutex);
-		break;
-	case ISER_CONN_BOUND:
-	case ISER_CONN_FULL_FEATURE: /* FALLTHRU */
-		bound = true;
-		break;
-	default:
-		break;
+	mutex_lock(&isert_np->mutex);
+	if (list_empty(&isert_conn->node)) {
+		bound = isert_conn->state == ISER_CONN_BOUND ||
+			isert_conn->state == ISER_CONN_FULL_FEATURE;
+	} else {
+		owned = true;
+		promoted = isert_conn->promoted;
+		list_del_init(&isert_conn->node);
 	}
+	mutex_unlock(&isert_np->mutex);
 
-	if (owned)
+	if (owned) {
 		terminated = isert_conn_terminate(isert_conn);
-	else if (bound)
+	} else if (bound) {
+		isert_conn_terminate(isert_conn);
 		iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
+	}
 	mutex_unlock(&isert_conn->mutex);
 
 	if (!owned)
-		return 0;
+		return;
 
 	if (terminated)
 		ib_drain_qp(isert_conn->qp);
-	isert_put_conn(isert_conn);
+	if (promoted)
+		isert_put_conn(isert_conn);
 	queue_work(isert_release_wq, &isert_conn->release_work);
+}
+
+static int
+isert_disconnected_handler(struct rdma_cm_id *cma_id,
+			   enum rdma_cm_event_type event)
+{
+	struct isert_conn *isert_conn = cma_id->qp->qp_context;
+
+	isert_teardown_conn(isert_conn);
 
 	return 0;
 }
@@ -661,20 +721,33 @@ isert_connect_error(struct rdma_cm_id *cma_id)
 {
 	struct isert_conn *isert_conn = cma_id->qp->qp_context;
 	struct isert_np *isert_np = cma_id->context;
-	bool owned;
+	bool owned = false, bound = false;
 
+	mutex_lock(&isert_conn->mutex);
 	mutex_lock(&isert_np->mutex);
-	owned = !list_empty(&isert_conn->node);
-	list_del_init(&isert_conn->node);
+	if (list_empty(&isert_conn->node)) {
+		bound = isert_conn->state == ISER_CONN_BOUND ||
+			isert_conn->state == ISER_CONN_FULL_FEATURE;
+	} else {
+		owned = true;
+		list_del_init(&isert_conn->node);
+	}
 	mutex_unlock(&isert_np->mutex);
 
+	if (owned) {
+		isert_conn->cm_id = NULL;
+	} else if (bound) {
+		isert_conn_terminate(isert_conn);
+		iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
+	}
+	mutex_unlock(&isert_conn->mutex);
+
 	if (!owned) {
 		isert_info("conn %p is being released already\n", isert_conn);
 		return 0;
 	}
 
 	ib_drain_qp(isert_conn->qp);
-	isert_conn->cm_id = NULL;
 	isert_put_conn(isert_conn);
 
 	return -1;
@@ -684,7 +757,6 @@ static int
 isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 {
 	struct isert_np *isert_np = cma_id->context;
-	struct isert_conn *isert_conn;
 	int ret = 0;
 
 	isert_info("%s (%d): status %d id %p np %p\n",
@@ -705,21 +777,10 @@ isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 		break;
 	case RDMA_CM_EVENT_ADDR_CHANGE:
 	case RDMA_CM_EVENT_DISCONNECTED:
-	case RDMA_CM_EVENT_TIMEWAIT_EXIT:  /* FALLTHRU */
+	case RDMA_CM_EVENT_TIMEWAIT_EXIT:
+	case RDMA_CM_EVENT_DEVICE_REMOVAL:
 		ret = isert_disconnected_handler(cma_id, event->event);
 		break;
-	case RDMA_CM_EVENT_DEVICE_REMOVAL:
-		isert_conn = cma_id->qp->qp_context;
-		isert_conn->dev_removed = true;
-		isert_disconnected_handler(cma_id, event->event);
-		wait_event_interruptible(isert_conn->rem_wait,
-					 isert_conn->state == ISER_CONN_DOWN);
-		kfree(isert_conn);
-		/*
-		 * return non-zero from the callback to destroy
-		 * the rdma cm id
-		 */
-		return 1;
 	case RDMA_CM_EVENT_REJECTED:
 		isert_info("Connection rejected: %s\n",
 			   rdma_reject_msg(cma_id, event->status));
@@ -2331,6 +2392,7 @@ isert_setup_np(struct iscsi_np *np,
 	if (!isert_np)
 		return -ENOMEM;
 
+	kref_init(&isert_np->kref);
 	sema_init(&isert_np->sem, 0);
 	mutex_init(&isert_np->mutex);
 	INIT_LIST_HEAD(&isert_np->accepted);
@@ -2356,7 +2418,7 @@ isert_setup_np(struct iscsi_np *np,
 	return 0;
 
 out:
-	kfree(isert_np);
+	isert_put_np(isert_np);
 
 	return ret;
 }
@@ -2476,6 +2538,7 @@ isert_accept_np(struct iscsi_np *np, struct iscsit_conn *conn)
 	isert_conn = list_first_entry(&isert_np->pending,
 			struct isert_conn, node);
 	list_del_init(&isert_conn->node);
+	isert_conn->promoted = false;
 	conn->context = isert_conn;
 	isert_conn->conn = conn;
 	isert_conn->state = ISER_CONN_BOUND;
@@ -2489,20 +2552,17 @@ isert_accept_np(struct iscsi_np *np, struct iscsit_conn *conn)
 }
 
 static struct isert_conn *
-isert_np_take_conn(struct isert_np *isert_np, bool *promoted)
+isert_np_take_conn(struct isert_np *isert_np)
 {
 	struct isert_conn *isert_conn;
 
 	lockdep_assert_held(&isert_np->mutex);
 
-	*promoted = true;
 	isert_conn = list_first_entry_or_null(&isert_np->pending,
 					      struct isert_conn, node);
-	if (!isert_conn) {
-		*promoted = false;
+	if (!isert_conn)
 		isert_conn = list_first_entry_or_null(&isert_np->accepted,
 						      struct isert_conn, node);
-	}
 	if (isert_conn)
 		list_del_init(&isert_conn->node);
 
@@ -2535,7 +2595,8 @@ isert_free_np(struct iscsi_np *np)
 
 	for (;;) {
 		mutex_lock(&isert_np->mutex);
-		isert_conn = isert_np_take_conn(isert_np, &promoted);
+		isert_conn = isert_np_take_conn(isert_np);
+		promoted = isert_conn && isert_conn->promoted;
 		mutex_unlock(&isert_np->mutex);
 
 		if (!isert_conn)
@@ -2550,7 +2611,8 @@ isert_free_np(struct iscsi_np *np)
 	}
 
 	np->np_context = NULL;
-	kfree(isert_np);
+	isert_np->np = NULL;
+	isert_put_np(isert_np);
 }
 
 static void isert_release_work(struct work_struct *work)
@@ -2679,6 +2741,10 @@ static void isert_get_rx_pdu(struct iscsit_conn *conn)
 
 	/* Now we are in FULL_FEATURE phase */
 	mutex_lock(&isert_conn->mutex);
+	if (isert_conn->state >= ISER_CONN_TERMINATING) {
+		mutex_unlock(&isert_conn->mutex);
+		return;
+	}
 	isert_conn->state = ISER_CONN_FULL_FEATURE;
 	mutex_unlock(&isert_conn->mutex);
 
@@ -2713,8 +2779,61 @@ static struct iscsit_transport iser_target_transport = {
 	.iscsit_get_sup_prot_ops = isert_get_sup_prot_ops,
 };
 
+static void
+isert_remove_one(struct ib_device *ib_device, void *client_data)
+{
+	DECLARE_COMPLETION_ONSTACK(removal_comp);
+	struct isert_device *device, *found = NULL;
+	struct isert_conn *isert_conn, *tmp;
+	LIST_HEAD(removal_list);
+
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
+	found->removing = true;
+	list_for_each_entry(isert_conn, &isert_conn_list, conn_list) {
+		if (isert_conn->device != found)
+			continue;
+		/* A connection with no reference left is already releasing. */
+		if (!kref_get_unless_zero(&isert_conn->kref))
+			continue;
+		list_add_tail(&isert_conn->removal_node, &removal_list);
+	}
+	mutex_unlock(&isert_conn_mutex);
+
+	list_for_each_entry_safe(isert_conn, tmp, &removal_list, removal_node) {
+		list_del_init(&isert_conn->removal_node);
+		isert_info("removing conn %p state %d\n",
+			   isert_conn, isert_conn->state);
+		isert_teardown_conn(isert_conn);
+		isert_put_conn(isert_conn);
+	}
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
@@ -2735,21 +2854,30 @@ static int __init isert_init(void)
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
index 519b17e54bd342..fbb58f3865f215 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -185,14 +185,16 @@ struct isert_conn {
 	struct ib_cq		*cq;
 	u32			cq_size;
 	struct isert_device	*device;
+	struct isert_np		*np;
+	bool			promoted;
 	struct mutex		mutex;
 	struct kref		kref;
 	struct work_struct	release_work;
+	struct list_head	removal_node;
 	atomic_t		ctrl_comp_cnt;
 	bool                    logout_posted;
 	bool                    snd_w_inv;
-	wait_queue_head_t	rem_wait;
-	bool			dev_removed;
+	struct list_head	conn_list;
 };
 
 struct isert_device {
@@ -203,6 +205,8 @@ struct isert_device {
 	struct isert_comp	*comps;
 	int                     comps_used;
 	struct list_head	dev_node;
+	struct completion	*removal_comp;
+	bool			removing;
 };
 
 struct isert_np {
@@ -212,4 +216,5 @@ struct isert_np {
 	struct mutex		mutex;
 	struct list_head	accepted;
 	struct list_head	pending;
+	struct kref		kref;
 };
-- 
2.43.0

