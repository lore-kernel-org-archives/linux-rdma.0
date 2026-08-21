Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEFD35F182
	for <linux-rdma@vger.kernel.org>; Fri, 21 Aug 2026 02:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787281071; cv=none; b=OysNETwM6XZyylcWmESv7afyCvP++B65vvM6ClNY7KAPmg2swr7KUxRqWZofB9ql8d9HvjKfqCZoaHOzqX2MSU1T8iynHKdKAfB2quSSW/NF9ipVTo0zZynvUzmsZwhculhIInsmsT88wKgiBt+bCYJgmk20+Hbn9z7qwchJ/zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787281071; c=relaxed/simple;
	bh=gAtnSTjeqCtxbumXeOH7maB8s/5xSq0wlmY5q+tZSTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j6RNKRy0r62BWFgROC8bmcTeNvZEuQNT835vsgC3Di4L0kqZqY+J0d9NFkP+UXDxMalIkWk43Fb6jW+YC/f13Juout4esxcZpEfldA2/JaXpld0nZQzdELvlK4rYpi2A5h6+LEnDcTQ6fyU24KVi5o5b0LPfnWDd1ceArIzDdkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=BE9U9amx; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="BE9U9amx"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3811f512167so626383a91.3
        for <linux-rdma@vger.kernel.org>; Thu, 20 Aug 2026 19:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1787281067; x=1787885867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6mHQa0ypxSoviqvT2UnTgyqTypHgMk+xKBTSRPmyyNg=;
        b=BE9U9amxVkTUBCIumhIw3621Zxo8Wyswp9AgNrvGrOuCbIRLiTu0Sxv3fSGoxcA/jD
         zG+W9CfVibb4M1uLhFhXKTeFnmCSF4VPwfGbhy3NGDaUfvS8sy5X2ysiSNnoQHADmhGC
         kGZJ7ipbKFPUlg97QlbVH+0BaZexSnxhINgD7e06GBRWPYiP8onS2izcuu/GDVPc2iSX
         lFoM9aNuyHd3esDaQe6iwtJNQgxqtC079pkPqgLwjUHm2GuPZMuXHBXmDQLtravj/Hoc
         NDcsqetngVY9Ki33F6mbp+fzf9ahECc+VpH2MM0dbLZWqL5NOPTFEavZIa05mN38bvEV
         LWOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787281067; x=1787885867;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6mHQa0ypxSoviqvT2UnTgyqTypHgMk+xKBTSRPmyyNg=;
        b=W2LqP2GbeuJB+w05Wp5m6Ey5BTsUcriClS+pkN5LlsQf5AaLPs7gv/wtiwCvhIFjIq
         4PlFbEIGAzutvU4WMTxYOKaKADSFEwQ5o+1lnIKQoymRfPNut/gxRJf40OvGKoDkDoJY
         uvX65UOcPIGDOFD6BpulOF4OOl+tr74xk2dhYD0GPEVL5Y8wYsTXOexBbCz1NprSNpaq
         ufihI4surbz/cKFl3QwwTXrDryHYpVywnqbGUUZpDB03FG15B8/kCRCQiYndEHB1Zt0t
         u3rdU3SSYwZWjc6Gp5PXUiwt5NUknUnh9ggWRWtV4fva3MBYDpw0sAxjf+faPls2cCx5
         lj3A==
X-Gm-Message-State: AFuF++m5fkR9VS/FI+NFam5qQOi/xUDu/tedpQ1g4OqkLvgNpAlRH3CC
	ImwjXJT2q8znEsttpX1Bf9Vb+3uA71DCMFgeIHUMpH8Ihjz4BFab5ZNGmaVWXgaoohA=
X-Gm-Gg: AR+sD126xzk6LgRrX+iQqwQeeHngM15unSaAKtpCNOuu+foYGQG29lEoMKoiuNkrnnC
	0+FsyHVwkW2fMa6uZh2X9+9UE5D+B84jvxnnZM4CNpimFNjQ1it1ZIh4oOngUGbu7Jl1HunOdIv
	zMUHfG+/rIVrDpQYVp8HIMJXWQZZlNXY/cVgWyta5QPihzojCXSjaXGUfahjt2VZUZzmSTf7boF
	DOOJYUGmn8spo+tvzbD/B1oMVOP+fEmP/zLCORFI47zwNzcZPhEm3AM3LLSDHyf39WrnwYTRUfm
	k765QswO2pMiEAHuQwMr7jobUJhm423AvaAdFpbYVQUMeXzKkraVjvZGso5JtcK5ElH+Se8h4Yx
	E3tgaUelYdb49+7UKrpK7AmQk4+vujb21IkYuf2dgLUki1pujHzozJxC4H7xy15VN3zGSck4FzL
	yjG8Q0pihbETJ+kJ81BRhHwNRGmNOABNezNF+/MyVEmvoO6Us6Pv0ErjL6qWxo0kbbzVVC
X-Received: by 2002:a17:90b:6cc:b0:392:ca3b:370a with SMTP id 98e67ed59e1d1-395c33d786amr6148277a91.2.1787281067091;
        Thu, 20 Aug 2026 19:57:47 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395c4697358sm1159077a91.8.2026.08.20.19.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 19:57:46 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Sagi Grimberg <sagi@grimberg.me>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH] IB/isert: wait for deferred control PDU completions before releasing the connection
Date: Fri, 21 Aug 2026 11:57:34 +0900
Message-ID: <20260821025734.1449084-1-yhlee@isslab.korea.ac.kr>
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
 drivers/infiniband/ulp/isert/ib_isert.c | 18 ++++++++++++++++++
 drivers/infiniband/ulp/isert/ib_isert.h |  3 +++
 2 files changed, 21 insertions(+)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 1015a51f750af..84abee9bfa785 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -308,6 +308,8 @@ isert_init_conn(struct isert_conn *isert_conn)
 	init_completion(&isert_conn->login_req_comp);
 	init_waitqueue_head(&isert_conn->rem_wait);
 	kref_init(&isert_conn->kref);
+	atomic_set(&isert_conn->ctrl_comp_cnt, 0);
+	init_waitqueue_head(&isert_conn->ctrl_comp_wait);
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
 
@@ -1689,6 +1693,10 @@ isert_do_control_comp(struct work_struct *work)
 		dump_stack();
 		break;
 	}
+
+	/* The count is what keeps isert_conn alive, so drop it last. */
+	if (counted && atomic_dec_and_test(&isert_conn->ctrl_comp_cnt))
+		wake_up(&isert_conn->ctrl_comp_wait);
 }
 
 static void
@@ -1732,6 +1740,12 @@ isert_send_done(struct ib_cq *cq, struct ib_wc *wc)
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
@@ -2572,6 +2586,10 @@ static void isert_wait_conn(struct iscsit_conn *conn)
 	isert_wait4cmds(conn);
 	isert_wait4logout(isert_conn);
 
+	/* Paired with the count taken in isert_send_done(). */
+	wait_event(isert_conn->ctrl_comp_wait,
+		   !atomic_read(&isert_conn->ctrl_comp_cnt));
+
 	queue_work(isert_release_wq, &isert_conn->release_work);
 }
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 0b2dfd6e7e270..17e512090b484 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -153,6 +153,7 @@ struct isert_cmd {
 	struct work_struct	comp_work;
 	struct scatterlist	sg;
 	bool			ctx_init_done;
+	bool			ctrl_counted;
 };
 
 static inline struct isert_cmd *tx_desc_to_cmd(struct iser_tx_desc *desc)
@@ -186,6 +187,8 @@ struct isert_conn {
 	struct mutex		mutex;
 	struct kref		kref;
 	struct work_struct	release_work;
+	atomic_t		ctrl_comp_cnt;
+	wait_queue_head_t	ctrl_comp_wait;
 	bool                    logout_posted;
 	bool                    snd_w_inv;
 	wait_queue_head_t	rem_wait;
-- 
2.43.0

