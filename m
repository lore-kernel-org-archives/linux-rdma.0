Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360C842A179
	for <linux-rdma@vger.kernel.org>; Fri, 21 Aug 2026 08:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787299595; cv=none; b=GAKL4q1yPggzFiNJjUotVlzB9FOaDPti8bIk1sndumSG3yknVZ4HL14kn11Lz0EDfMe6rKGCcHtjnFz4Sk+T4Jtz31SYaoQ7lYZ4JDEP1g1n3fUhPmxX8KleGoeIN7wXnbp7itJ5iXWIsJxSLrFgR5DCoYtNYjlNMBPUNmOppv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787299595; c=relaxed/simple;
	bh=t1ekyKkdMeqTYW2HHGg+/6fO3kAXEeHxG78H5kydXPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I7E54zm8y2LxRYnU4IKDrOJQVjGzWnDLqtQmL2erpYp7E8QM57gsSLS/OkoZAOh+Tymj0BuRFr46w+KWxwkiHxaF0MnSJ7Kj3+zqGzojHrS9DbUwzeEqMSXmK0iUoiqvp81lq8MkNBvOueeCavqM/7XXvZ+GrQ2jJ5JqPJ0KjVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=igxJK3sV; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="igxJK3sV"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8518b3ff3e9so549459b3a.2
        for <linux-rdma@vger.kernel.org>; Fri, 21 Aug 2026 01:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1787299591; x=1787904391; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jz5sBAEFdT/Ok15cO4OYFgI2x1CXaW2UGMA8q+5LqqM=;
        b=igxJK3sVujBoFwZCbMlkKfF6EgefMuSRHJRDRmtijNaQpB8E09tM9OiiuOh6gsfoCs
         vhuCEQkUYZDp0ITBr089OiiqBrMZI8KVuBqO2mnxHdf/bpR2R0FKEhr5yG2ml0wsaBXP
         SsJoQChWBN6SuhKFH8R4bbYNdQ8KcqK/PD2rroQLViiYfuhmK3q7kWiQoAg3sMiDUBY/
         hOkemnGGKqxyLn22O9A2HwHCvciYebdHCBQLEO3a2zgOA8I+aD6oZsh5KMbCKVLjPBM6
         BDu2nMtv5DxAVOTbZ1t3qSQsI7OwWlAxlkhUhjhuc5uAetVH05DPcIok+D2o/V1JE1/y
         TJMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787299591; x=1787904391;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jz5sBAEFdT/Ok15cO4OYFgI2x1CXaW2UGMA8q+5LqqM=;
        b=aB0QktFlnnUuqrj4its3rXfkIm4H5dTXq62YIohEBL4CZ/mA7UTrh6hrupk0wdfWoC
         T4uqbo7X8Rh4HrdH7lg1SehaYw6wgxL47NVS55likVp3gnw6CwErKZsGOS9u2E5L+9bE
         5PRPt6HfA23m9Bev8CDZP0EXKcmsQGiHh011vx61rI0J1OQot6Xsu9bvCeplyzF9HbgM
         c1/vQ1sjoFv0FWylSuFOC26XsCJtDPs1ovGZ8L4kQSNDdb98wHZVUGqM5tlazT0Txrhe
         8tjrLyCjfSKH2nFYnDjA6fkK64H4T79V78Fdll+fhD6E1vg1MLtV6afQ3+wzhl422Rne
         yIww==
X-Gm-Message-State: AOJu0Yx0ZARIqZW+CKYNz+DPNAjY8AYf/I5Qz+60qBUG7IuFQByAU1ns
	ViTl31b1O9oC9OJjJx2yswgurBT0Bmd6HYqlR67wdQoTwfNXX7+ky7AIMNOCW5+yBCs=
X-Gm-Gg: AR+sD13OZPKn+MokumBv0ZPTX4ccoqLXrOJegBvUmuQMa2W64TZSiYdh1NwVsMKMsUR
	feIRfs+Vcbh9fXFx2cDq2Jj/fV8GY6PWbND1aJ6XEe54TTMrA+v9mPJ2ucfuY2tFg3s6nhMN09V
	++Z3YX1Ieae6YCuHK/0uO1SSfkom/tikO0d6ZkFO4f3RWwcWQIaGP2gjwXYRG+yFpc4gTfFhrHF
	LIXyzlYsYYbk4w3LvbF8CYGaAOXzkHF9ndoglYeKqSG0QJahOzAf7X4jXYgKI2mYr4T869PX4CU
	424d4c8xRfU/6M43KY2uWD+DeAZDd1dhK1Kyr98VHzza1yOhmjfQwwj8mdMj5ehmqfFgxn9Nw2E
	9SLucjDtKLQObL3Go6oyE8nrZSwj/o1KN3+V/m8mbVKIHyRgtlZ/QshRnFGMlh1Utf4iUnRRDYx
	7NvoYiwxemmpcvAL+yIjv5VxmZBU3x/dlYhptyFvJLjSTGaJk6rWPg1JM2vIdvy4GyRC8i755Hf
	7hygYM7
X-Received: by 2002:a05:6a21:138f:b0:3c1:fbf:1e2e with SMTP id adf61e73a8af0-3cd3008bf4bmr1727665637.10.1787299591101;
        Fri, 21 Aug 2026 01:06:31 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc16c6dd2f4sm1161923a12.17.2026.08.21.01.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 01:06:30 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Sagi Grimberg <sagi@grimberg.me>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH v2] IB/isert: wait for deferred control PDU completions before releasing the connection
Date: Fri, 21 Aug 2026 17:06:20 +0900
Message-ID: <20260821080620.1694119-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

isert_send_done() hands ISTATE_SEND_TASKMGTRSP, ISTATE_SEND_REJECT and
ISTATE_SEND_TEXTRSP completions off to isert_comp_wq and returns.  The work
item then runs isert_completion_put() -> isert_put_cmd(), which reads
isert_conn->conn and takes conn->cmd_lock.

Nothing orders that work item against teardown.  isert_wait_conn() queues
isert_release_work, which frees isert_conn, and iscsit_close_connection()
frees the iscsit_conn right after it returns, so the queued work can run
against freed memory.

Count the deferred control PDU completions per connection and let
isert_wait_conn() wait for them before the release work is queued.

ISTATE_SEND_LOGOUTRSP is deliberately not counted: that branch runs
iscsit_logout_post_handler(), which ends up waiting for
conn->conn_wait_comp, and that completion is only sent by
iscsit_close_connection() after it has called iscsit_wait_conn().
Waiting for it here would deadlock.  Its wait stays the existing
isert_wait4logout().

The splat below is from a kernel with tracing printk()s and an msleep(200)
injected into isert_do_control_comp() to widen the window:

  BUG: KASAN: slab-use-after-free in isert_put_cmd+0x53d/0x620
  Read of size 8 at addr ffff8881054f1038 by task kworker/u17:1/182

  CPU: 0 UID: 0 PID: 182 Comm: kworker/u17:1 Tainted: G    B               7.2.0-rc5-TWIDE-gb8babf08acc7 #1 PREEMPT(lazy)
  Tainted: [B]=BAD_PAGE
  Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  Workqueue: isert_comp_wq isert_do_control_comp
  Call Trace:
   <TASK>
   dump_stack_lvl+0x53/0x70
   print_report+0xd0/0x630
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   ? _raw_spin_unlock_irqrestore+0x3e/0x70
   ? isert_put_cmd+0x53d/0x620
   kasan_report+0xce/0x100
   ? isert_put_cmd+0x53d/0x620
   isert_put_cmd+0x53d/0x620
   ? isert_completion_put+0x305/0x330
   ? isert_do_control_comp+0x2ef/0x310
   process_one_work+0x633/0x1030
   ? assign_work+0x11d/0x370
   worker_thread+0x45b/0xd10
   ? __pfx_worker_thread+0x10/0x10
   ? __pfx_worker_thread+0x10/0x10
   kthread+0x2c6/0x3b0
   ? recalc_sigpending+0x15c/0x1e0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x36e/0x5a0
   ? __pfx_ret_from_fork+0x10/0x10
   ? __switch_to+0x572/0xdd0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1a/0x30
   </TASK>

  Allocated by task 48:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   __kasan_kmalloc+0x8f/0xa0
   __kmalloc_cache_noprof+0x158/0x370
   isert_cma_handler+0x1e3/0x2ae0
   cma_cm_event_handler+0x3e/0x240
   cma_ib_req_handler+0x17d9/0x4490
   cm_process_work+0x41/0x330
   cm_work_handler+0x5727/0xc160
   process_one_work+0x633/0x1030
   worker_thread+0x45b/0xd10
   kthread+0x2c6/0x3b0
   ret_from_fork+0x36e/0x5a0
   ret_from_fork_asm+0x1a/0x30

  Freed by task 184:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   kasan_save_free_info+0x3b/0x60
   __kasan_slab_free+0x43/0x70
   kfree+0x121/0x380
   iscsit_close_connection+0x7cf/0x1e60
   iscsit_take_action_for_connection_exit+0x1b6/0x360
   iscsi_target_tx_thread+0x472/0x690
   kthread+0x2c6/0x3b0
   ret_from_fork+0x36e/0x5a0
   ret_from_fork_asm+0x1a/0x30

Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) target driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v2: the counter in v1 was paired with a wait queue embedded in isert_conn.
The waiter reads the count outside that queue's lock, so it could observe
zero and skip the wait entirely.  The release work then freed isert_conn
while the last work item was still between its atomic_dec_and_test() and
its wake_up(), which locked the freed queue.  Use wait_var_event() and
wake_up_var() instead: those hash the address into a global wait queue
table, so the waker never dereferences isert_conn.  The count itself is
unchanged.

The v1 race was pointed out by the Sashiko review bot.
 drivers/infiniband/ulp/isert/ib_isert.c | 22 ++++++++++++++++++++++
 drivers/infiniband/ulp/isert/ib_isert.h |  2 ++
 2 files changed, 24 insertions(+)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 1015a51f750af..bc3e69f55054f 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -21,6 +21,7 @@
 #include <target/target_core_fabric.h>
 #include <target/iscsi/iscsi_transport.h>
 #include <linux/semaphore.h>
+#include <linux/wait_bit.h>
 
 #include "ib_isert.h"
 
@@ -308,6 +309,7 @@ isert_init_conn(struct isert_conn *isert_conn)
 	init_completion(&isert_conn->login_req_comp);
 	init_waitqueue_head(&isert_conn->rem_wait);
 	kref_init(&isert_conn->kref);
+	atomic_set(&isert_conn->ctrl_comp_cnt, 0);
 	mutex_init(&isert_conn->mutex);
 	INIT_WORK(&isert_conn->release_work, isert_release_work);
 }
@@ -1668,6 +1670,8 @@ isert_do_control_comp(struct work_struct *work)
 	struct isert_conn *isert_conn = isert_cmd->conn;
 	struct ib_device *ib_dev = isert_conn->cm_id->device;
 	struct iscsit_cmd *cmd = isert_cmd->iscsit_cmd;
+	/* The switch below may free isert_cmd. */
+	bool counted = isert_cmd->ctrl_counted;
 
 	isert_dbg("Cmd %p i_state %d\n", isert_cmd, cmd->i_state);
 
@@ -1689,6 +1693,14 @@ isert_do_control_comp(struct work_struct *work)
 		dump_stack();
 		break;
 	}
+
+	/*
+	 * The count is what keeps isert_conn alive, so drop it last.  The wait
+	 * queue lives in the global hash table, not in isert_conn, so this is
+	 * safe even if the waiter has already freed the connection.
+	 */
+	if (counted && atomic_dec_and_test(&isert_conn->ctrl_comp_cnt))
+		wake_up_var(&isert_conn->ctrl_comp_cnt);
 }
 
 static void
@@ -1732,6 +1744,12 @@ isert_send_done(struct ib_cq *cq, struct ib_wc *wc)
 	case ISTATE_SEND_TEXTRSP:
 		isert_unmap_tx_desc(tx_desc, ib_dev);
 
+		/* Paired with the wait in isert_wait_conn(). */
+		isert_cmd->ctrl_counted =
+			isert_cmd->iscsit_cmd->i_state != ISTATE_SEND_LOGOUTRSP;
+		if (isert_cmd->ctrl_counted)
+			atomic_inc(&isert_conn->ctrl_comp_cnt);
+
 		INIT_WORK(&isert_cmd->comp_work, isert_do_control_comp);
 		queue_work(isert_comp_wq, &isert_cmd->comp_work);
 		return;
@@ -2572,6 +2590,10 @@ static void isert_wait_conn(struct iscsit_conn *conn)
 	isert_wait4cmds(conn);
 	isert_wait4logout(isert_conn);
 
+	/* Paired with the count taken in isert_send_done(). */
+	wait_var_event(&isert_conn->ctrl_comp_cnt,
+		       !atomic_read(&isert_conn->ctrl_comp_cnt));
+
 	queue_work(isert_release_wq, &isert_conn->release_work);
 }
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 0b2dfd6e7e270..221d2a3376c1f 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -153,6 +153,7 @@ struct isert_cmd {
 	struct work_struct	comp_work;
 	struct scatterlist	sg;
 	bool			ctx_init_done;
+	bool			ctrl_counted;
 };
 
 static inline struct isert_cmd *tx_desc_to_cmd(struct iser_tx_desc *desc)
@@ -186,6 +187,7 @@ struct isert_conn {
 	struct mutex		mutex;
 	struct kref		kref;
 	struct work_struct	release_work;
+	atomic_t		ctrl_comp_cnt;
 	bool                    logout_posted;
 	bool                    snd_w_inv;
 	wait_queue_head_t	rem_wait;
-- 
2.43.0

