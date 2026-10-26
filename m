Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792994734;
	b=leWyQYRVkM7Ejixk/1KWp696ncVYc82F4w4hGBM43ufP8jeFH9LTFoS2mFRyXa9ywd+6
	 SQLe6a0tJ6DW6djL/+ZPAZUe7yTOj7SDP3gqOGt/2vF2WkUxOfaFRpJ0vPSgw+m0Q/LvV
	 6IzJ1IoXwBTQxAp7lFQ1wVBx/mnShcwGISGeOYSOfAHYL01c84B/zHMTUHjyiNRkC4NrW
	 riRduGl4McNbVZcheyP7/oXahojTfZMANE+2igSDYBvYuQ/y0fkEsOMvybgGH9co7HDGr
	 6mnnPw1pJEWNG02DTiv1famrw7noLTstCj+gOSAoGbSu6eB4uzkaB8kCUwbQ4CdQ+kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792994734;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=UUsq0ITCU6ZleegXek2GI4n8g8GMIA+2LvSMEbZSYRU=;
	b=UFsb+eDc9b8reNqltrw4MRik2x96h8iVRff1VDgJSF/1vBGKSfwhypi68J4noFb7kmA0
	 uF6hk2mwII8oQ5OXXG2zUTuubh7KltUtbQKJ3r/sX/fG8yw7w6v+gywP8nqvffKBtnVsV
	 fKqDeA6BgjTWXcmQBjwzPmkaKapyfKEofeCrv2weQ9gAyW9zXbTY+6Sz/VsefPRbkQVlL
	 q2SbFYwmp0KTkiFuBB8P+cWR1vUVqrHYHllVLWhhlZGqsDWrbFptoaUrHZM6nq+7FJH6q
	 EGPb8KbTQpiZrlLBCY8HQcG3pq/CZnsxdvLz/Dj3q3EvvNG4kUYYRFOodo3QVyCom+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=gGzSJdmA;
	arc=none smtp.remote-ip=74.125.82.178
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C74606A31D
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 06:05:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32C74606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=gGzSJdmA
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-3550c917fd3so3986216eec.0
        for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 23:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792994732; x=1793599532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UUsq0ITCU6ZleegXek2GI4n8g8GMIA+2LvSMEbZSYRU=;
        b=gGzSJdmAvDzygK4ZAxwCbRw3YMmNTF1DOmfpWUy0PXWktNx6E73ejWxx7mKmL3GWNS
         sTAuxZZGMWDmPuw293kd5Kk5SAso7j2CPV17V77nf5iT3zVxz1ji5msFeK6296fYHfNZ
         McSZQhCIiLoog7wnv4y9ssPFL7QxbOhUxtUdKo0e6LfhkC8FnVeUI37aTxJ/SRxsGmsO
         14wtVwLnYYZ1hBhtHBpc1D4jkiFxOchNgDAC+aRVZ6TvO63KgTsP/AhHPL50kBb2AkMC
         LfZIUjGulP9Hb0TWHMrgn1CztVKQIxEyCB5jhBtcga8bugb7pumSNKJ9YIP6UIHzGt9M
         Zefw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792994732; x=1793599532;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UUsq0ITCU6ZleegXek2GI4n8g8GMIA+2LvSMEbZSYRU=;
        b=R1iMs6n1DbKCusIbmP/coktatE+MgDnBwrCQrm3XCR/+6O0SA7Y/cbLUlKRgKzm46H
         eeHITXAiKGA6chp5Jip1U2PL0X/VoI6hclKKstRPQOhMB/cAjQ5LwPbXwKNDsM7jtZxD
         2lCvrcL9yt3h6cOVxJOlq5677cNe8h3mhLasoDGVIURs0A3N0wQuQFEaSuGUafbqUSPX
         nde2/7sBDf8n0LwZtlbFGhf9IiDXyeYUppUfVYkg7mXvw+V2gGP9lPZiUbSdCs5+zJg5
         p1sK5DIcjlx12N9xKaI76RNuSCVbtVB4cUc4Q3+yhOZ7P29TbXqhay5vSOKBtjvqlvEa
         5j3A==
X-Forwarded-Encrypted: i=1; AKwUvBxNjLlqdJIoNGaZoLkcLQV32hfLTQAVl356Xl4KGuNtV8K/mKwFQ+JVwO0SbmmSJemCAomt+eknGj0q@vger.kernel.org
X-Gm-Message-State: AFq9FYIL7mbV5tdNM47Ma+pRHGoNLmJEzVXeUFwLdeV4nKc9kr2TQlSH
	SJD3Glttl6RCfNXPeD1jY+HQ7poP3y9SreimO8deTxh/4W+yDrI7brO+ZY+hgEElt28=
X-Gm-Gg: AYBFou0eYYOZfBeP7ChKgZYSxeN26ZhaKiIGrY3iv1DfJgtdcHv3DzCasdWwjW5wIHv
	Ub44ndZHGBau9c1q4JkB8kbUwN/iX0iABrlnEJXyQUo+x2Z+A9/vD831nFffQ+dPlU2oMKVqHtg
	PQ6R9EZw2yHhIyoztQWduBWtsPl3gBV5aFHduyeACvekvMju74WJyt2sFAv73e3+kTU7y87g7z3
	zG8C1R/fmaEmTX4EW91pHqvIVGULC/dr5iwFVWv9GmGM98voHlf9W5FH6JZsfFDBMvZOh7C4fcm
	MZ9vKDQc7bC6ng2dFCy677p8F8KCbOojssuT2rARMPcfrwo4r1DD4rBp3tWbiJdSl1znLj8T9Om
	nqP6kPQ2DgoSUNHobuW/0dsCmiKNnZKSnDHtvS0S7VAADyJBeENJjzNOLY16+8zcdRJAQgAK+YH
	jovdRH3JK+wGWamdNp2/A3WOjjPeZ9jIcRm0MaIkLie5KH+4LOFHKDZa1BhD4tVXdF9DhOV6xfL
	Hm0/QhM6BrigIRWssBKaQ94EYnH+VZiS64o0+geEZZIdCQOciNZXXX3zBx81CHyzR0kphQzjeRw
	WkQ2EyruJ4g3C6TuYJMTTLua/vHyS68H2ROoZengfOUvOgBS
X-Received: by 2002:a05:7300:50f0:b0:369:ef63:ea90 with SMTP id 5a478bee46e88-369ef63f3abmr7629613eec.28.1792994732066;
        Sun, 25 Oct 2026 23:05:32 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8daa3a8sm27373092eec.16.2026.10.25.23.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 23:05:31 -0700 (PDT)
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
Subject: [PATCH v2 RESEND] IB/isert: tear connections down from an ib_client on device removal
Date: Mon, 26 Oct 2026 15:05:05 +0900
Message-ID: <20261026060505.409476-1-yhlee@isslab.korea.ac.kr>
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
Resending as a standalone thread; the v2 I sent earlier went out
In-Reply-To v1 by mistake. No code changes. Apologies for the noise.

v2: redesigned to tear down from an ib_client (v1 had a handler_mutex
deadlock and did not close the rem_wait UAF).

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
