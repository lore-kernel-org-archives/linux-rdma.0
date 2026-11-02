Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793600216;
	b=dBX3yEuusM+g1ZLlO2N3xCJQ1KfItCa8LcB7k1TNfCoN44Tv6Zec/CASwSWvWnm9LVYx
	 F9jFQkS6g4yd41vDWAYksiQR5wLha5qlkln38QmL++6fVtr50kFiRjWgvzGB3W/n1Gz7x
	 OeKeDEx6esBNjOk6c91dtSpBOlB+86mJfp+HYvu/gRlcylNDwLII1Uucpi0BWSvfBnGuH
	 vtpcEEnd8lZN7woXP7pDiXdEhkEEdfBRGeA9bcxLEKElEdPU7lusLrLj/5IIO0R6SSVYC
	 OP2dERBRp3zWlF8Rj67aUZXGt3DmGjq1mV39EFEIV5VcTy9MQaxD/BOPO10xXgV5YoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793600216;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YCiwuv2XbkHXLdK+n+DZWu0Zkx5l+8DgTvFsHFnO3k0=;
	b=ks1DObhSBhSFo4n8oSc5nwiAzcVUWjGcK6YjE27D2ok3Ksx0BqMVus9t1+x44MBruzGF
	 voIxBJbDNgNxDkSTrP301fEWJNraMa6ZjjU0TCmDJIT8NLMp2Lv5V8o+4OIBN9sojVSA6
	 wdaGBRYmD+0kcG5WhTInN0zqRAqIZguVHe4KGescwqyoLwRp0vW2tbsXxDJIc+lrZcQKu
	 +H+xMbuRkxYdMfgXpdE1XutYqcwcx+EPS20+SkiGHEHY9MpB4tFD2b4YwaLletmRRXLQR
	 VP8Blmqe7GC4DW3F6oO/GRQ7Xv5cUcbO0shrEc+ILDnTTZLyNfV7DZwWByrqIuOxXyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=aHCootD4;
	arc=none smtp.remote-ip=209.85.210.181
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E7660A2600
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 06:16:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2E7660A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=aHCootD4
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8a064dcfcfdso820431b3a.2
        for <linux-rdma@vger.kernel.org>; Sun, 01 Nov 2026 22:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793600215; x=1794205015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YCiwuv2XbkHXLdK+n+DZWu0Zkx5l+8DgTvFsHFnO3k0=;
        b=aHCootD4bV8nb52RYRWtSQIiMUzdltRgBwv4bTMJ2neHqHawPiXVSksHTjnMrgcP8G
         oxZYM1Jqb3iuZeapLeM1sJdHLl7m8idHU99q/CjacMP8mR6FUM0QKG655JfiXxvtmonc
         LoLRqdbaSyk6rm8qE8UMvJAgsExaX3Tzcy446ExcllEvZ6yQm0T7fzv4Gyz77J0zKyv7
         UCsslC54c5dDy+xvGFz+vwwP6t6LhuZZIUiR/qz4u34i39M8KBBmtc/2Bsu78DVlsuh0
         o8zrBNDTHJa6NfA52WmutnRP5IAOHk5qe2Uni09EodGoRzQxir/WJVmkyiSQgtfd/a/p
         W63Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793600215; x=1794205015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YCiwuv2XbkHXLdK+n+DZWu0Zkx5l+8DgTvFsHFnO3k0=;
        b=MKf7zDoTcBSdt6shbUzc4Vd+DLEtxgUiL19oBdC1iS9W10OhMIOROkUMW5wkkkwZHX
         LoKWomqXdDu3rAbx9xuCZtWRUCATA3H4SqliQgc7iSYYPFPn/gT1jPg4TaYUPkkcnzpD
         J8HT2ZB8SHTy1zfpyM9ezL2UbI6B4Cc8SY6OaVXl+PrUOqfGX4DhqO9Bqhx7b3Vwy39w
         9ECU+7TpLbIkEFP664Ewz343XjFyQRDHOe1lMyIr+VOpw4ESabRsY6mqjO/rnG+BDeYs
         JbAd9/sTwH2CZlSV52u/kfu8IpUXU7Qvt6ibeeSA3V6XFy6uPNY7JsZgRLMRKvmlhuDW
         S15Q==
X-Forwarded-Encrypted: i=1; AKwUvBzdaPf4gIfJGH9kyKJTB9eD5YW4cYIuyVPeW5dNix05ICjUorgkTNOqmlqMt2Zin0LVgRGPDb5+BGoc@vger.kernel.org
X-Gm-Message-State: APuU4Z+u4cdAwbFgSA3aniaQ7WEyuccdb5e2utY81Wx3dTn9BOUS4Kf8
	bYkPjbDTPi393+uuFt00vCDlymeHo6tkaCMSkqARsj9g60Wp0MKmA6IOezIDnWBCuvs=
X-Gm-Gg: AYBFou3B0wMNbtqQwONEVPCjg7757Aluvd767tFgOBtk4zGI5LzsBuiWXZO+vRXl0WM
	gMkuTLhgNwJLqeHIB4vLLHZLshZppZtNZf2sAMwfXyhTjSa0Db8oGKOZXP8R9v7Lu3OmntG+wT0
	OV0fdwy4rv2tqU1XEISd9x0Nz44pNRNhFrsgVHIJLiUR786z6St2A41N7V+iIkw3W8SKEyb34js
	j21ZyQc9H1B5GDo2IWUoeYNJlZzX5bOP7JK8AA7m/T+4u56ElUugfdxp0MIaP9hx1hl/O7a4aW1
	To4NbTWKNd2/tprCR+L5E7dcIcjqbVCoCHGCNG8aiYwOC7ZrChNG1teqhbrjfh5Txval104luCe
	iM3UDqzIXZNjVqUnAjW29rnpIek2Oh0S+DG3kjZF8nVEB923qFIkjYZfjl42Oo+xAII6LT3YhgG
	OxeQTJ8m6dQFsxZIf98aP0hzCFWI60xJOqXZ1e2Ab+pfNXu+Q6zWdfYhwDkltaG4SUhZrmG3ACt
	+ibI5a/G8/rOoNgWl5FXnNVZZLRywQxyzXLVIanXQcKRgoAqaM+BeEc+iuHFfojRJjRQpJVajR4
	aAS4lpLcxSjCFm5xyln+5X5Y1LKeJ7qW0CvcduhRKNqjrKMGF7SVoJjRpkZLzqTe/4LP2Ac61kf
	TAg+C7U4DGHoTtuNhQYbWrnu6hz/2STPnxkzlIg==
X-Received: by 2002:a05:6a00:a0c:b0:881:be70:4490 with SMTP id d2e1a72fcca58-8a9be68059fmr7998645b3a.28.1793600215068;
        Sun, 01 Nov 2026 22:16:55 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:d115:e4f4:23fd:61df])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8aad9d03be0sm1509071b3a.27.2026.11.01.22.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:16:54 -0800 (PST)
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
Subject: [PATCH v3 2/2] IB/isert: tear connections down from an ib_client on device removal
Date: Mon,  2 Nov 2026 15:16:07 +0900
Message-ID: <20261102061608.617186-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102061608.617186-1-yhlee@isslab.korea.ac.kr>
References: <20261102061608.617186-1-yhlee@isslab.korea.ac.kr>
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

The RDMA_CM_EVENT_DEVICE_REMOVAL callback waits on the connection state:

	wait_event_interruptible(isert_conn->rem_wait,
				 isert_conn->state == ISER_CONN_DOWN);
	kfree(isert_conn);

That is a use-after-free.  isert_release_work() publishes ISER_CONN_DOWN
before dropping the last reference, so the wait returns while that work is
still on its way into kref_put(), as in the splat below.  The state is read
with no lock held, so reordering the store does not help.

It also deadlocks.  cma_send_device_removal_put() runs the callback under
the cm_id's handler_mutex, which rdma_destroy_id() needs, so a teardown
past the dev_removed test blocks there while the callback waits for it.

Tear the connections down from an ib_client removal callback instead,
where no cm_id lock is held, and wait there for the last isert_device
reference, which isert_connect_release() drops.  nvmet-rdma did the same
in commit f1d4ef7d8883 ("nvmet-rdma: register ib_client to not deadlock
in device removal").  The cm callback keeps the cm_id and returns zero,
so dev_removed and rem_wait are gone.

Three things make that wait terminate.  A connection in ISER_CONN_INIT is
only marked, and isert_connected_handler() releases it.
isert_connect_request() fills isert_conn_list and isert_np->accepted under
isert_conn_mutex and rejects a request once the device is being removed.
isert_remove_one() holds isert_conn_mutex across the whole walk, because
it guards the lifetime of those connections and not just the list.

4 of 12 unpatched runs hit this use-after-free; none of 12 patched runs
did.

  BUG: KASAN: slab-use-after-free in isert_release_work+0x78/0x160
  Write of size 4 at addr ffff888105829180 by task kworker/u16:5/70

  CPU: 0 UID: 0 PID: 70 Comm: kworker/u16:5 Not tainted 7.3.0-CTL-13247-g330517c63aa9 #12 PREEMPT(full)
  Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  Workqueue: isert_release_wq isert_release_work
  Call Trace:
   <TASK>
   dump_stack_lvl+0x53/0x70
   print_report+0xd0/0x630
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   ? queued_spin_lock_slowpath+0xef/0xb10
   ? isert_release_work+0x78/0x160
   kasan_report+0xce/0x100
   ? isert_release_work+0x78/0x160
   kasan_check_range+0x105/0x1b0
   isert_release_work+0x78/0x160
   process_one_work+0x697/0x1060
   ? __pfx___schedule+0x10/0x10
   ? __pfx_process_one_work+0x10/0x10
   ? _raw_spin_lock_irq+0x81/0xe0
   ? __pfx_isert_release_work+0x10/0x10
   ? assign_work+0x11d/0x370
   worker_thread+0x45b/0xd10
   ? __pfx_worker_thread+0x10/0x10
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

  Allocated by task 29:
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

  Last potentially related work creation:
   kasan_save_stack+0x33/0x60
   kasan_record_aux_stack+0x8c/0xa0
   __queue_work+0x7a1/0x15e0
   queue_work_on+0x5d/0x70
   isert_disconnected_handler.isra.0+0x20b/0x380
   isert_cma_handler+0x101b/0x2840
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

  The buggy address belongs to the object at ffff888105828000
   which belongs to the cache kmalloc-8k of size 8192
  The buggy address is located 4480 bytes inside of
   freed 8192-byte region [ffff888105828000, ffff88810582a000)

Fixes: 63b268d232b8 ("IB/isert: Properly release resources on DEVICE_REMOVAL")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 149 +++++++++++++++++++-----
 drivers/infiniband/ulp/isert/ib_isert.h |   5 +-
 2 files changed, 120 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 5371bba71ba3cb..223a727c1d0dec 100644
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
@@ -56,6 +58,8 @@ isert_rdma_accept(struct isert_conn *isert_conn);
 struct rdma_cm_id *isert_setup_id(struct isert_np *isert_np);
 
 static void isert_release_work(struct work_struct *work);
+static void
+isert_handle_unbound_conn(struct isert_conn *isert_conn, bool iscsi_ref);
 static void isert_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 static void isert_send_done(struct ib_cq *cq, struct ib_wc *wc);
 static void isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc);
@@ -255,6 +259,8 @@ isert_device_put(struct isert_device *device)
 	if (!device->refcount) {
 		isert_free_device_ib_res(device);
 		list_del(&device->dev_node);
+		if (device->removal_comp)
+			complete(device->removal_comp);
 		kfree(device);
 	}
 	mutex_unlock(&device_list_mutex);
@@ -309,7 +315,7 @@ isert_init_conn(struct isert_conn *isert_conn)
 	INIT_LIST_HEAD(&isert_conn->node);
 	init_completion(&isert_conn->login_comp);
 	init_completion(&isert_conn->login_req_comp);
-	init_waitqueue_head(&isert_conn->rem_wait);
+	INIT_LIST_HEAD(&isert_conn->conn_list);
 	kref_init(&isert_conn->kref);
 	atomic_set(&isert_conn->ctrl_comp_cnt, 0);
 	mutex_init(&isert_conn->mutex);
@@ -464,9 +470,19 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	if (ret)
 		goto out_destroy_qp;
 
+	mutex_lock(&isert_conn_mutex);
+	if (device->removing) {
+		mutex_unlock(&isert_conn_mutex);
+		isert_info("device %p is being removed, rejecting conn %p\n",
+			   device, isert_conn);
+		ret = -ENODEV;
+		goto out_destroy_qp;
+	}
+	list_add_tail(&isert_conn->conn_list, &isert_conn_list);
 	mutex_lock(&isert_np->mutex);
 	list_add_tail(&isert_conn->node, &isert_np->accepted);
 	mutex_unlock(&isert_np->mutex);
+	mutex_unlock(&isert_conn_mutex);
 
 	return 0;
 
@@ -491,9 +507,12 @@ isert_connect_release(struct isert_conn *isert_conn)
 
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
@@ -504,12 +523,9 @@ isert_connect_release(struct isert_conn *isert_conn)
 	if (isert_conn->login_desc)
 		isert_free_login_buf(isert_conn);
 
-	isert_device_put(device);
+	kfree(isert_conn);
 
-	if (isert_conn->dev_removed)
-		wake_up_interruptible(&isert_conn->rem_wait);
-	else
-		kfree(isert_conn);
+	isert_device_put(device);
 }
 
 static void
@@ -521,13 +537,25 @@ isert_connected_handler(struct rdma_cm_id *cma_id)
 	isert_info("conn %p\n", isert_conn);
 
 	mutex_lock(&isert_conn->mutex);
+	if (isert_conn->state >= ISER_CONN_TERMINATING) {
+		/* The login receive is still posted, drain before releasing. */
+		isert_info("conn %p is terminating, state %d\n",
+			   isert_conn, isert_conn->state);
+		if (rdma_disconnect(isert_conn->cm_id))
+			isert_warn("Failed rdma_disconnect isert_conn %p\n",
+				   isert_conn);
+		ib_drain_qp(isert_conn->qp);
+		isert_handle_unbound_conn(isert_conn, false);
+		mutex_unlock(&isert_conn->mutex);
+		return;
+	}
 	isert_conn->state = ISER_CONN_UP;
 	kref_get(&isert_conn->kref);
-	mutex_unlock(&isert_conn->mutex);
 
 	mutex_lock(&isert_np->mutex);
 	list_move_tail(&isert_conn->node, &isert_np->pending);
 	mutex_unlock(&isert_np->mutex);
+	mutex_unlock(&isert_conn->mutex);
 
 	isert_info("np %p: Allow accept_np to continue\n", isert_np);
 	up(&isert_np->sem);
@@ -552,7 +580,7 @@ isert_put_conn(struct isert_conn *isert_conn)
 }
 
 static void
-isert_handle_unbound_conn(struct isert_conn *isert_conn)
+isert_handle_unbound_conn(struct isert_conn *isert_conn, bool iscsi_ref)
 {
 	struct isert_np *isert_np = isert_conn->cm_id->context;
 
@@ -563,7 +591,8 @@ isert_handle_unbound_conn(struct isert_conn *isert_conn)
 		 * so schedule a cleanup ourselves
 		 */
 		list_del_init(&isert_conn->node);
-		isert_put_conn(isert_conn);
+		if (iscsi_ref)
+			isert_put_conn(isert_conn);
 		queue_work(isert_release_wq, &isert_conn->release_work);
 	}
 	mutex_unlock(&isert_np->mutex);
@@ -625,20 +654,23 @@ isert_np_cma_handler(struct isert_np *isert_np,
 	return -1;
 }
 
-static int
-isert_disconnected_handler(struct rdma_cm_id *cma_id,
-			   enum rdma_cm_event_type event)
+static void
+isert_teardown_conn(struct isert_conn *isert_conn)
 {
-	struct isert_conn *isert_conn = cma_id->qp->qp_context;
+	lockdep_assert_held(&isert_conn->mutex);
 
-	mutex_lock(&isert_conn->mutex);
 	switch (isert_conn->state) {
 	case ISER_CONN_TERMINATING:
+	case ISER_CONN_DOWN:
+		break;
+	case ISER_CONN_INIT:
+		/* Mark only; isert_connected_handler() releases it. */
+		isert_conn->state = ISER_CONN_TERMINATING;
 		break;
 	case ISER_CONN_UP:
 		isert_conn_terminate(isert_conn);
 		ib_drain_qp(isert_conn->qp);
-		isert_handle_unbound_conn(isert_conn);
+		isert_handle_unbound_conn(isert_conn, true);
 		break;
 	case ISER_CONN_BOUND:
 	case ISER_CONN_FULL_FEATURE: /* FALLTHRU */
@@ -648,6 +680,16 @@ isert_disconnected_handler(struct rdma_cm_id *cma_id,
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
@@ -674,7 +716,6 @@ static int
 isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 {
 	struct isert_np *isert_np = cma_id->context;
-	struct isert_conn *isert_conn;
 	int ret = 0;
 
 	isert_info("%s (%d): status %d id %p np %p\n",
@@ -695,21 +736,10 @@ isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
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
@@ -2697,8 +2727,54 @@ static struct iscsit_transport iser_target_transport = {
 	.iscsit_get_sup_prot_ops = isert_get_sup_prot_ops,
 };
 
+static void
+isert_remove_one(struct ib_device *ib_device, void *client_data)
+{
+	DECLARE_COMPLETION_ONSTACK(removal_comp);
+	struct isert_device *device, *found = NULL;
+	struct isert_conn *isert_conn;
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
@@ -2719,21 +2795,30 @@ static int __init isert_init(void)
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
index 519b17e54bd342..802a12c5aae086 100644
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
@@ -203,6 +202,8 @@ struct isert_device {
 	struct isert_comp	*comps;
 	int                     comps_used;
 	struct list_head	dev_node;
+	struct completion	*removal_comp;
+	bool			removing;
 };
 
 struct isert_np {
-- 
2.43.0

