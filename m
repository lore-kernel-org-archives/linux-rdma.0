Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793676633;
	b=m8C5t1JXDYuNOI2dCGH1bBbfQ8Exqq+qoyvWWbXzQvhxN2rz5gWVt5uZ4uL4OY/miBdJ
	 8dyxGCOb/CRmkNntjR7KYLsMeGVMr6hQwaQaufhNcAJ8oU417CGAjqXhevyEOHHEab/M/
	 Nz6W84076+FRhWJzKXIjOu13E0wY0tS+H25GFZ3SphFl5JJK/2qk+uRrywE/krKCM3FNq
	 oT1tjY0eQT7hp2sNIrVROOR/dp2Cb51OhfBxT+yyUmsB+VOykZz3Zj9z4cx1ImM7OXQVX
	 GF90ZlSW0aXDRS3XcKGsApi6TmQkLH2aAOab9bcvsErp83LsS6TkdgdL/+JNVyELG1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793676633;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fUYc6K1xuXasUOQRwQddQJ7jucpQeZX0LMyrQsiRtXo=;
	b=nu/Fv8BAeksMuM4/lfxgmpwk42gApbNHpOqib63FuceasWFSFKXQkh2BZ2OX+LavNQF/
	 eLwieMmiZWT5iAMyEHHUKS5en7Pg4k+mbDyUiXaueoXMdBLt5ODHSs5oJzvtUuRJfxeL6
	 64Tt/hacvYnJ4U653qToYk/Q8jMgc3F5TEzCzMFsZDzAtuM53+Ou2WmZdqXwWM4NnA5Bl
	 LHbBMl+7r2DexP4JhR+4csPxeNfrdcw9hhmrPddcXZMykEymQiIVTAqKKMj3/ewFFQBsR
	 ofK2XUC+emVyJXlX23Dq4n8BfA1+uTYoW2q7KfQl5FLcE8jvNZaw25i+HxPiaEgMo2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="bAE+Xp/8";
	arc=none smtp.remote-ip=74.125.82.179
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36208606D807
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 03:30:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36208606D807
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=bAE+Xp/8
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-36a17a332ecso5730207eec.1
        for <linux-rdma@vger.kernel.org>; Mon, 02 Nov 2026 19:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793676631; x=1794281431; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fUYc6K1xuXasUOQRwQddQJ7jucpQeZX0LMyrQsiRtXo=;
        b=bAE+Xp/8GjnjV6t33kkz0+scY4w1iZuc0DR6qc3DNzTIWbWfCl/qFUfRiGamInsLc4
         R6sq9Oxv89GBe1FqK/rJj+tSK6+yCzNXd2uU88W7+/50NupqYLxp+/G7nZh53gKNk2hp
         focFGaDloYgBnVmMHJEQNdxSrHtC2Mk1EWCe8yIsvHcdWMKpTkRffa7NZRYrP7d71oJm
         BvtgpkSuuqszAaM0t0jBDajIwILKzScpyJiHce+FLOLilVVibwcDON2Wh7JG+/kUO+wz
         hO2exCWkP4PnmoqzgWY316arcg9+Wh59DbNyMPBnh8voQuteC1jK0awTUTvSrSgAET4h
         LXXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793676631; x=1794281431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fUYc6K1xuXasUOQRwQddQJ7jucpQeZX0LMyrQsiRtXo=;
        b=2chs7A5nLCD+/32ZIMgxjUZn7zImYLsk69kIInO459yrBzo68REIIZBvxr30UhXbXq
         BoT4dgt0ETwJk9BEXpDkQiKmCGco2cpvY/xiwTH+TkWgUbO40WQIgJ3kFbygG5mDPSg1
         RjdMZ3lB7VO5nC/QpPFYBr+gRdG8euAPbm2tOK2LGhnkAz2Zc7hKJGpZfOfeYVRh7xNX
         5P384PwOX7ghdqwYh9Vf8p6WxHrhF/w0esXHvtlJ+adFg4zfVscom1RQsLDjFaWOmyn1
         s+QZVjHIESjZvqrDIkSnoPCUmmlvVqWjaWXxZFCsRVwWsVkX5qiwur5/lU1SgxvJp/q3
         RqMg==
X-Forwarded-Encrypted: i=1; AKwUvBxnvcPTLLy5Qi+eERB3wqvc9lqBQILZjhJBMcvY1J5tSw7R4TRggmc4v5KW6rfpuDEg1knJuIrTZ7qo@vger.kernel.org
X-Gm-Message-State: APuU4Z8AzrgcW1vpI0NMSXhUMaOMysTEBGTK6q71TBGtGqJhFbywRZGS
	p+K1/HLWtvDF41yAzNqSZ5SVN0pAB7TrW9eS+u6Ysays3eEWM2myR7qXfvGp/uUcFkc=
X-Gm-Gg: AYBFou3MFjdUO52KRNHSf3X9DWrFOy+u0WFymZB8gcrX2uf2z7RUAJFPgaE2kMl+RxW
	HLLHyArlHW+q9MDeqerO/7iWiSiCZC+14KpnN3g95L+txcg69e+SqtiMwUMRBfxLYT7Kb2Qc0mz
	2RpKO39QBobTrleMoUctDx/vzqbVdhu0B6gVP0J0Ybgua+FKO4Vi3ORVkBocYiVpZjtKNwWOHLx
	/WxngseSG8BmXljCDa1AnWpr3TOl1GjW7nRwDyJjopDXtNGjHSpJMkbrGcAGqe5H/yHaCWtTqP4
	m9SwYJEohTR7krvt2E3tUgGNoa+ROEXnCzGzLd2edl5ooEUsqBKRTBYwqnDDJmmza+rl3SEzqcf
	zUP8fDLkUGLvVB9lLJchDj23REF6qGYAWvONRZQLAhvmVH5nzDvPa8Ay2rzZW4+We/pvs2XRSu2
	Pw++asg6b0bmchAjic6N7261YG4FQleAuc0alxz63a3cPZzDhvHwz8Npx/Ub8kg6LQ85+sLG4LW
	kwpAnC1ra/JBfaMFMbaiXZc/2+2+3Jk8yTAgrN1Tjma2GKhQM7iBcrwjKzG1Yq2VNZwjiGHgaTB
	YyYFAkqpdHYjij+jfITxqjVFBjfFqaV4nrixgba0scP2aS2UuqDXwwM4IyphughCFJQu9pme3jo
	JDmXoUEoUn5HcfJ0tpQZ2Mp26VuDFPLEZqW22OA==
X-Received: by 2002:a05:7301:1a15:b0:355:fdc0:a811 with SMTP id 5a478bee46e88-36a42493bc4mr16525281eec.37.1793676631058;
        Mon, 02 Nov 2026 19:30:31 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:2da3:4696:4c5e:89c1])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af91bsm41498577eec.8.2026.11.02.19.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 19:30:30 -0800 (PST)
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
Subject: [PATCH v4 3/3] IB/isert: tear connections down from an ib_client on device removal
Date: Tue,  3 Nov 2026 12:29:24 +0900
Message-ID: <20261103032924.1073138-4-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103032924.1073138-1-yhlee@isslab.korea.ac.kr>
References: <20261103032924.1073138-1-yhlee@isslab.korea.ac.kr>
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

The RDMA_CM_EVENT_DEVICE_REMOVAL callback waits for isert_conn->state to
reach ISER_CONN_DOWN and then calls kfree(isert_conn) itself.
isert_release_work() publishes that state before dropping the last
reference, so the wait returns while the work is on its way into
kref_put().  It also deadlocks: the callback runs under the cm_id's
handler_mutex, which rdma_destroy_id() needs.

Tear the connections down from an ib_client removal callback instead,
where no cm_id lock is held, and wait there for the last isert_device
reference, which isert_connect_release() drops, as commit f1d4ef7d8883
("nvmet-rdma: register ib_client to not deadlock in device removal")
did.  That walk runs without the handler_mutex that used to serialise a
teardown against isert_free_np(), so the portal is reference counted
too.

Without this series, one of twelve runs finished the removal and two
reported this, seventeen times and eleven times; with it, all twelve
finished and reported nothing.

  BUG: KASAN: slab-use-after-free in isert_connect_release+0x5c1/0x620
  Read of size 8 at addr ffff88810bca1160 by task kworker/u16:4/69

  CPU: 3 UID: 0 PID: 69 Comm: kworker/u16:4 Tainted: G    B               7.4.0-rc1-CTL #19 PREEMPT(full)
  Tainted: [B]=BAD_PAGE
  Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  Workqueue: isert_release_wq isert_release_work
  Call Trace:
   <TASK>
   dump_stack_lvl+0x53/0x70
   print_report+0xd0/0x630
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   ? isert_connect_release+0x5c1/0x620
   kasan_report+0xce/0x100
   ? isert_connect_release+0x5c1/0x620
   isert_connect_release+0x5c1/0x620
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

  Freed by task 219:
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

  The buggy address belongs to the object at ffff88810bca0000
   which belongs to the cache kmalloc-8k of size 8192
  The buggy address is located 4448 bytes inside of
   freed 8192-byte region [ffff88810bca0000, ffff88810bca2000)

Fixes: 63b268d232b8 ("IB/isert: Properly release resources on DEVICE_REMOVAL")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 232 ++++++++++++++++++------
 drivers/infiniband/ulp/isert/ib_isert.h |   9 +-
 2 files changed, 187 insertions(+), 54 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index c6f417bb206901..5486fbdc6aa394 100644
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
@@ -417,6 +426,7 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	struct iscsi_np *np = isert_np->np;
 	struct isert_conn *isert_conn;
 	struct isert_device *device;
+	bool accepted = false;
 	int ret = 0;
 
 	spin_lock_bh(&np->np_thread_lock);
@@ -456,20 +466,42 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 		goto out_rsp_dma_map;
 	}
 
+	if (READ_ONCE(device->removing)) {
+		isert_info("device %p is being removed, rejecting conn %p\n",
+			   device, isert_conn);
+		ret = -ENODEV;
+		goto out_destroy_qp;
+	}
+
 	ret = isert_login_post_recv(isert_conn);
 	if (ret)
 		goto out_destroy_qp;
 
 	ret = isert_rdma_accept(isert_conn);
 	if (ret)
-		goto out_destroy_qp;
-
+		goto out_drain_qp;
+	accepted = true;
+
+	mutex_lock(&isert_conn_mutex);
+	if (device->removing) {
+		mutex_unlock(&isert_conn_mutex);
+		isert_info("device %p is being removed, dropping conn %p\n",
+			   device, isert_conn);
+		ret = -ENODEV;
+		goto out_drain_qp;
+	}
+	isert_conn->np = isert_np;
+	kref_get(&isert_np->kref);
+	list_add_tail(&isert_conn->conn_list, &isert_conn_list);
 	mutex_lock(&isert_np->mutex);
 	list_add_tail(&isert_conn->node, &isert_np->accepted);
 	mutex_unlock(&isert_np->mutex);
+	mutex_unlock(&isert_conn_mutex);
 
 	return 0;
 
+out_drain_qp:
+	ib_drain_qp(isert_conn->qp);
 out_destroy_qp:
 	isert_destroy_qp(isert_conn);
 out_rsp_dma_map:
@@ -478,7 +510,9 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	isert_device_put(device);
 out:
 	kfree(isert_conn);
-	rdma_reject(cma_id, NULL, 0, IB_CM_REJ_CONSUMER_DEFINED);
+	/* cma destroys an accepted cm id when this handler returns an error. */
+	if (!accepted)
+		rdma_reject(cma_id, NULL, 0, IB_CM_REJ_CONSUMER_DEFINED);
 	return ret;
 }
 
@@ -486,14 +520,18 @@ static void
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
@@ -504,12 +542,11 @@ isert_connect_release(struct isert_conn *isert_conn)
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
@@ -517,22 +554,37 @@ isert_connected_handler(struct rdma_cm_id *cma_id)
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
@@ -556,10 +608,24 @@ isert_put_conn(struct isert_conn *isert_conn)
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
 static void
 isert_handle_unbound_conn(struct isert_conn *isert_conn)
 {
-	struct isert_np *isert_np = isert_conn->cm_id->context;
+	struct isert_np *isert_np = isert_conn->np;
 
 	mutex_lock(&isert_np->mutex);
 	if (!list_empty(&isert_conn->node)) {
@@ -568,7 +634,8 @@ isert_handle_unbound_conn(struct isert_conn *isert_conn)
 		 * so schedule a cleanup ourselves
 		 */
 		list_del_init(&isert_conn->node);
-		isert_put_conn(isert_conn);
+		if (isert_conn->promoted)
+			isert_put_conn(isert_conn);
 		queue_work(isert_release_wq, &isert_conn->release_work);
 	}
 	mutex_unlock(&isert_np->mutex);
@@ -628,17 +695,17 @@ isert_np_cma_handler(struct isert_np *isert_np,
 	return -1;
 }
 
-static int
-isert_disconnected_handler(struct rdma_cm_id *cma_id,
-			   enum rdma_cm_event_type event)
+static void
+isert_teardown_conn(struct isert_conn *isert_conn)
 {
-	struct isert_conn *isert_conn = cma_id->qp->qp_context;
 	bool terminated = false;
 
 	mutex_lock(&isert_conn->mutex);
 	switch (isert_conn->state) {
 	case ISER_CONN_TERMINATING:
+	case ISER_CONN_DOWN:
 		break;
+	case ISER_CONN_INIT:
 	case ISER_CONN_UP:
 		terminated = isert_conn_terminate(isert_conn);
 		break;
@@ -652,10 +719,20 @@ isert_disconnected_handler(struct rdma_cm_id *cma_id,
 	}
 	mutex_unlock(&isert_conn->mutex);
 
-	if (terminated) {
-		ib_drain_qp(isert_conn->qp);
-		isert_handle_unbound_conn(isert_conn);
-	}
+	if (!terminated)
+		return;
+
+	ib_drain_qp(isert_conn->qp);
+	isert_handle_unbound_conn(isert_conn);
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
@@ -688,7 +765,6 @@ static int
 isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 {
 	struct isert_np *isert_np = cma_id->context;
-	struct isert_conn *isert_conn;
 	int ret = 0;
 
 	isert_info("%s (%d): status %d id %p np %p\n",
@@ -709,21 +785,10 @@ isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
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
@@ -2335,6 +2400,7 @@ isert_setup_np(struct iscsi_np *np,
 	if (!isert_np)
 		return -ENOMEM;
 
+	kref_init(&isert_np->kref);
 	sema_init(&isert_np->sem, 0);
 	mutex_init(&isert_np->mutex);
 	INIT_LIST_HEAD(&isert_np->accepted);
@@ -2360,7 +2426,7 @@ isert_setup_np(struct iscsi_np *np,
 	return 0;
 
 out:
-	kfree(isert_np);
+	isert_put_np(isert_np);
 
 	return ret;
 }
@@ -2480,6 +2546,7 @@ isert_accept_np(struct iscsi_np *np, struct iscsit_conn *conn)
 	isert_conn = list_first_entry(&isert_np->pending,
 			struct isert_conn, node);
 	list_del_init(&isert_conn->node);
+	isert_conn->promoted = false;
 	mutex_unlock(&isert_np->mutex);
 
 	conn->context = isert_conn;
@@ -2494,20 +2561,17 @@ isert_accept_np(struct iscsi_np *np, struct iscsit_conn *conn)
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
 
@@ -2540,7 +2604,8 @@ isert_free_np(struct iscsi_np *np)
 
 	for (;;) {
 		mutex_lock(&isert_np->mutex);
-		isert_conn = isert_np_take_conn(isert_np, &promoted);
+		isert_conn = isert_np_take_conn(isert_np);
+		promoted = isert_conn && isert_conn->promoted;
 		mutex_unlock(&isert_np->mutex);
 
 		if (!isert_conn)
@@ -2554,7 +2619,8 @@ isert_free_np(struct iscsi_np *np)
 	}
 
 	np->np_context = NULL;
-	kfree(isert_np);
+	isert_np->np = NULL;
+	isert_put_np(isert_np);
 }
 
 static void isert_release_work(struct work_struct *work)
@@ -2717,8 +2783,61 @@ static struct iscsit_transport iser_target_transport = {
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
+	WRITE_ONCE(found->removing, true);
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
@@ -2739,21 +2858,30 @@ static int __init isert_init(void)
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

