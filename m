Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14A0419303
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 17:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790615911; cv=none; b=X8j61sya09+jnvpsTQFsMZo34Hxgxdx/l4Y4I5anLwtVpyv8JmpZSJ3lsx/s8Qt4OyA36cCdctBLxM4J3LvJezebirVy0Pru/dPIxkWJudBOs8BghUNfI1h6HMKYhnW7kCJhHaiqnDZWEP2wgGDN83c2bvuVm5J1y9+iHXWAUbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790615911; c=relaxed/simple;
	bh=nGRBvZ1IbcJ9flvuRg4eNXnjGJw7itSnW5hZmBIjqIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1gZtxPP6Hlal3gYTHL0Kre0QCoKLuHVqOyhX4SBut6RK4QQ8X8uykORzKUeJY45oEVkDJgEfRmY7K6Z65GgJAqfv1gJzHJVeM9pvnDwDQJlcSSVb4pxlV+qLC7xkRv8IU5c55T/wEj/V1VRnGisfwGgTnLXaPuL44CNSt0JmJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pl81LitN; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pl81LitN"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccd5cf02so1721721a91.3
        for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 10:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790615907; x=1791220707; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0J1YH5odqV0iWslsDrfPs2abhmn/SWHUbgbnWQikAKc=;
        b=Pl81LitNG2ORvuBda/kT2i+iwrrZWnC3VkZ4KynIdFkv96T6kSWc0MDGEWh8j5jb+Q
         F1yRc1fKukQbnx76U5hrB/yJ10WOGbk8snJBNevyI1uyEBarYhW3HwRMd0jpG1ILaVwN
         /AJeAOADTcpomwNn2XfF3XaINBrLtOxOyPANcCvjTcA33WqV1P4gj56gzFokcbHLHpGL
         m6y4Z/TgoUb8v3WexXTp80HXdSend8nh4qSNCIJ9CLoyPJUhg9uwjhVDid1s8bhRuAsY
         ydSVxEbrWfId8wcoIuiAGOhc414sdghHIokEK4M4lFnW4N1imRoajfaW4PoQYzGtvM5K
         /cHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790615907; x=1791220707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0J1YH5odqV0iWslsDrfPs2abhmn/SWHUbgbnWQikAKc=;
        b=gUXruLxIeGxvhEdDhBdtGu6RYkHAt/d8YdVX2C9JJniksHzK/NLduK14T7eGh1pmHI
         agQd286GXJtyvm/OJS/GBuZYAMkN8QYmiygX/gfjdYLhCwelt4/s3cnNlxOEgvLaDJB8
         CmZYRitd8LWaOQ6ossUpJZ6jlxiVMuFGUUEhc6HTJiRx7K5I4M+ELOKbGTetiKYQ47Gp
         LowH/DZixBBTaLw+14J+aQrv114ntYtx3zzsiEZkGXAD1pv8+RqxdB6HFdrwjJytplJz
         3xdL3habqhu5RaJF5RI8Jjhw+V+87NR7kxd9xqTOs8NMwJSZ3VOEHf2yXecxCrP+5HHH
         1KLA==
X-Forwarded-Encrypted: i=1; AKwUvBxloigtY7z9Lmi0lGLT1YaXPwCshPAA5aJqBr0H7WtPb22op2+wccHZOrrSTXqd+Yw6ierq9UNaOQAc@vger.kernel.org
X-Gm-Message-State: AFq9FYJRJib++TNSFHxD4wQp+BqFiWKBrMz4JQNi/bGFWkI9j/N1u5e5
	+GrfbYyfkNNjaykdmbU4clKiPBJHjhe/pnBvd2SxrvAqPyyKr5zL/G5A
X-Gm-Gg: AYBFou3HdEiW9pbjXXsYMybGtbVdoMgMR/rR/aKmtAeBfmvg7cjf02FHNGEFiVTSGUp
	119UiAEOpKSY6tI8PfzXjXXkq3OH+btT3d7Qt5nndn9DiKzl8/aBY0nFZMOiHyEBkgSQaIYe4h/
	eoK+o+A+Qkob4mON5krnTChdlrCoxBlgKhp3XyGn92rRjig2Xaojr/VWMsOS1CysBsK02UDLlGh
	2PCOjEHVSLe947iROovZXYdVZYo+owl18ZvdlRQhDBNY+Qxwe1awBkhUwmxP8ijrkxRfI+Z9HJe
	Q921EKMpDpdZeOXVmBvUwlgTO0JEcczstZA1/52KCNStjg0mw66XZaw0To16M/KphcRH2TaMxvF
	RaTAHiRlmKTGNAI5N2qHVhgdNymXcCKPpEv88jH3bnOLrdj3TKjGxT6kaqai4dbtgFeryGRaQDe
	MQYi7tE34pfLuPZw/cAVsoacdvTN/os/440favfovmVGz+2EHrrkpRhL4HiXoEtC9zfGbIUKpWN
	nK/yVC7UpeX3BopnvaVoB74
X-Received: by 2002:a17:90a:a8f:b0:3a0:a912:e759 with SMTP id 98e67ed59e1d1-3a0a912ead8mr7295026a91.25.1790615907447;
        Mon, 28 Sep 2026 10:18:27 -0700 (PDT)
Received: from localhost.localdomain ([43.224.245.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4986bb8f6sm189139a91.0.2026.09.28.10.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 10:18:26 -0700 (PDT)
From: Dongliang Qin <cccccccccccc777777@gmail.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Dongliang Qin <cccccccccccc777777@gmail.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bob Pearson <rpearsonhpe@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/4] RDMA/rxe: Reserve MR state during MW binding
Date: Tue, 29 Sep 2026 01:17:54 +0800
Message-ID: <20260928171756.3254016-3-cccccccccccc777777@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260928171756.3254016-1-cccccccccccc777777@gmail.com>
References: <20260928171756.3254016-1-cccccccccccc777777@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MR invalidation, fast registration, reregistration, and deregistration
only test num_mw before changing MR state. A concurrent type-2 MW bind
can increment num_mw after that test and leave an MW bound to an MR
that is being destroyed.

Reserve num_mw == -1 while the MR state is changing, and allow binds
only while num_mw is nonnegative. This keeps the MW binding count and
MR lifetime synchronized without adding a new object.

An unprivileged user with access to the device can use this race to corrupt
kernel memory and escalate privileges.

A concurrent bind and deregistration reproducer made KASAN report:

BUG: KASAN: slab-use-after-free in rxe_mr_copy+0xd5/0x3d0
Read of size 1 at addr ff11000105d217b0 by task kworker/u16:3/44
Workqueue: rxe_wq do_work
Call Trace:
 rxe_mr_copy+0xd5/0x3d0
 rxe_receiver+0x1b50/0x3ed0
 do_work+0xbb/0x250
 process_one_work+0x412/0x780
 worker_thread+0x341/0x5b0
 kthread+0x1b8/0x210

Freed by task 1151:
 kasan_save_stack+0x33/0x60
 kfree+0x17c/0x450
 rxe_mr_cleanup+0x3c/0x90
 __rxe_cleanup+0x145/0x1e0
 rxe_dereg_mr+0x4e/0x110
 ib_dereg_mr_user+0xa4/0x1a0
 ib_uverbs_ioctl+0x12f/0x1c0

Fixes: 32a577b4c3a9 ("RDMA/rxe: Add support for bind MW work requests")

Cc: stable@vger.kernel.org
Signed-off-by: Dongliang Qin <cccccccccccc777777@gmail.com>
---
 drivers/infiniband/sw/rxe/rxe_loc.h   |  4 ++
 drivers/infiniband/sw/rxe/rxe_mr.c    | 70 +++++++++++++++++++++++++--
 drivers/infiniband/sw/rxe/rxe_mw.c    | 44 +++++++++--------
 drivers/infiniband/sw/rxe/rxe_verbs.c | 13 ++++-
 4 files changed, 105 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 2cbec92566f70..5e95e5c5e32d6 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -72,6 +72,10 @@ enum resp_states rxe_mr_do_atomic_op(struct rxe_mr *mr, u64 iova, int opcode,
 enum resp_states rxe_mr_do_atomic_write(struct rxe_mr *mr, u64 iova, u64 value);
 struct rxe_mr *lookup_mr(struct rxe_pd *pd, int access, u32 key,
 			 enum rxe_mr_lookup_type type);
+int rxe_mr_get_mw(struct rxe_mr *mr);
+void rxe_mr_put_mw(struct rxe_mr *mr);
+bool rxe_mr_reserve_mw_state(struct rxe_mr *mr);
+void rxe_mr_release_mw_state(struct rxe_mr *mr);
 int mr_check_range(struct rxe_mr *mr, u64 iova, size_t length);
 int advance_dma_data(struct rxe_dma_info *dma, unsigned int length);
 int rxe_invalidate_mr(struct rxe_qp *qp, u32 key);
diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 71d9ea4772890..4dc5b7405832f 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -721,6 +721,53 @@ struct rxe_mr *lookup_mr(struct rxe_pd *pd, int access, u32 key,
 	return mr;
 }
 
+/*
+ * num_mw counts the MWs bound to an MR. The value -1 is reserved while
+ * the MR is changing state so that a new MW binding cannot race with
+ * invalidation, fast registration, or deregistration.
+ */
+int rxe_mr_get_mw(struct rxe_mr *mr)
+{
+	int old;
+
+	if (!rxe_get(mr))
+		return 0;
+
+	old = atomic_read(&mr->num_mw);
+	do {
+		if (old < 0)
+			goto err_put;
+	} while (!atomic_try_cmpxchg(&mr->num_mw, &old, old + 1));
+
+	if (mr->state != RXE_MR_STATE_VALID) {
+		atomic_dec_return(&mr->num_mw);
+		rxe_put(mr);
+		return 0;
+	}
+
+	return 1;
+
+err_put:
+	rxe_put(mr);
+	return 0;
+}
+
+void rxe_mr_put_mw(struct rxe_mr *mr)
+{
+	atomic_dec_return(&mr->num_mw);
+	rxe_put(mr);
+}
+
+bool rxe_mr_reserve_mw_state(struct rxe_mr *mr)
+{
+	return atomic_cmpxchg(&mr->num_mw, 0, -1) == 0;
+}
+
+void rxe_mr_release_mw_state(struct rxe_mr *mr)
+{
+	atomic_xchg(&mr->num_mw, 0);
+}
+
 int rxe_invalidate_mr(struct rxe_qp *qp, u32 key)
 {
 	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
@@ -743,7 +790,7 @@ int rxe_invalidate_mr(struct rxe_qp *qp, u32 key)
 		goto err_drop_ref;
 	}
 
-	if (atomic_read(&mr->num_mw) > 0) {
+	if (!rxe_mr_reserve_mw_state(mr)) {
 		rxe_dbg_mr(mr, "Attempt to invalidate an MR while bound to MWs\n");
 		ret = -EINVAL;
 		goto err_drop_ref;
@@ -752,11 +799,16 @@ int rxe_invalidate_mr(struct rxe_qp *qp, u32 key)
 	if (unlikely(mr->ibmr.type != IB_MR_TYPE_MEM_REG)) {
 		rxe_dbg_mr(mr, "Type (%d) is wrong\n", mr->ibmr.type);
 		ret = -EINVAL;
-		goto err_drop_ref;
+		goto err_release;
 	}
 
 	mr->state = RXE_MR_STATE_FREE;
+	rxe_mr_release_mw_state(mr);
 	ret = 0;
+	goto err_drop_ref;
+
+err_release:
+	rxe_mr_release_mw_state(mr);
 
 err_drop_ref:
 	rxe_put(mr);
@@ -777,23 +829,26 @@ int rxe_reg_fast_mr(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	u32 key = wqe->wr.wr.reg.key;
 	u32 access = wqe->wr.wr.reg.access;
 
+	if (!rxe_mr_reserve_mw_state(mr))
+		return -EINVAL;
+
 	/* user can only register MR in free state */
 	if (unlikely(mr->state != RXE_MR_STATE_FREE)) {
 		rxe_dbg_mr(mr, "mr->lkey = 0x%x not free\n", mr->lkey);
-		return -EINVAL;
+		goto err_release;
 	}
 
 	/* user can only register mr with qp in same protection domain */
 	if (unlikely(qp->ibqp.pd != mr->ibmr.pd)) {
 		rxe_dbg_mr(mr, "qp->pd and mr->pd don't match\n");
-		return -EINVAL;
+		goto err_release;
 	}
 
 	/* user is only allowed to change key portion of l/rkey */
 	if (unlikely((mr->lkey & ~0xff) != (key & ~0xff))) {
 		rxe_dbg_mr(mr, "key = 0x%x has wrong index mr->lkey = 0x%x\n",
 			key, mr->lkey);
-		return -EINVAL;
+		goto err_release;
 	}
 
 	mr->access = access;
@@ -801,8 +856,13 @@ int rxe_reg_fast_mr(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	mr->rkey = key;
 	mr->ibmr.iova = wqe->wr.wr.reg.mr->iova;
 	mr->state = RXE_MR_STATE_VALID;
+	rxe_mr_release_mw_state(mr);
 
 	return 0;
+
+err_release:
+	rxe_mr_release_mw_state(mr);
+	return -EINVAL;
 }
 
 void rxe_mr_cleanup(struct rxe_pool_elem *elem)
diff --git a/drivers/infiniband/sw/rxe/rxe_mw.c b/drivers/infiniband/sw/rxe/rxe_mw.c
index 04f795adacf53..82e9fef89b6c3 100644
--- a/drivers/infiniband/sw/rxe/rxe_mw.c
+++ b/drivers/infiniband/sw/rxe/rxe_mw.c
@@ -136,33 +136,39 @@ static int rxe_check_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 	return 0;
 }
 
-static void rxe_do_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
-		      struct rxe_mw *mw, struct rxe_mr *mr, int access)
+static int rxe_do_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
+			  struct rxe_mw *mw, struct rxe_mr *mr, int access)
 {
 	u32 key = wqe->wr.wr.mw.rkey & 0xff;
 
-	mw->rkey = (mw->rkey & ~0xff) | key;
-	mw->access = access;
-	mw->state = RXE_MW_STATE_VALID;
-	mw->addr = wqe->wr.wr.mw.addr;
-	mw->length = wqe->wr.wr.mw.length;
+	if (mw->ibmw.type == IB_MW_TYPE_2 && !rxe_get(qp))
+		return -EINVAL;
+
+	if (mr && !rxe_mr_get_mw(mr)) {
+		if (mw->ibmw.type == IB_MW_TYPE_2)
+			rxe_put(qp);
+		return -EINVAL;
+	}
 
 	if (mw->mr) {
-		rxe_put(mw->mr);
-		atomic_dec(&mw->mr->num_mw);
+		rxe_mr_put_mw(mw->mr);
 		mw->mr = NULL;
 	}
 
-	if (mw->length) {
+	if (mr)
 		mw->mr = mr;
-		atomic_inc(&mr->num_mw);
-		rxe_get(mr);
-	}
+
+	mw->rkey = (mw->rkey & ~0xff) | key;
+	mw->access = access;
+	mw->state = RXE_MW_STATE_VALID;
+	mw->addr = wqe->wr.wr.mw.addr;
+	mw->length = wqe->wr.wr.mw.length;
 
 	if (mw->ibmw.type == IB_MW_TYPE_2) {
-		rxe_get(qp);
 		mw->qp = qp;
 	}
+
+	return 0;
 }
 
 int rxe_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
@@ -213,7 +219,9 @@ int rxe_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	if (ret)
 		goto err_unlock;
 
-	rxe_do_bind_mw(qp, wqe, mw, mr, access);
+	ret = rxe_do_bind_mw(qp, wqe, mw, mr, access);
+	if (ret)
+		goto err_unlock;
 err_unlock:
 	spin_unlock_bh(&mw->lock);
 err_drop_mr:
@@ -250,8 +258,7 @@ static void rxe_do_invalidate_mw(struct rxe_mw *mw)
 	/* valid type 2 MW will always have an MR pointer */
 	mr = mw->mr;
 	mw->mr = NULL;
-	atomic_dec(&mr->num_mw);
-	rxe_put(mr);
+	rxe_mr_put_mw(mr);
 
 	mw->access = 0;
 	mw->addr = 0;
@@ -336,8 +343,7 @@ void rxe_mw_cleanup(struct rxe_pool_elem *elem)
 		struct rxe_mr *mr = mw->mr;
 
 		mw->mr = NULL;
-		atomic_dec(&mr->num_mw);
-		rxe_put(mr);
+		rxe_mr_put_mw(mr);
 	}
 
 	if (mw->qp) {
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 3864284522ebc..8553c8402c619 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1337,6 +1337,11 @@ static struct ib_mr *rxe_rereg_user_mr(struct ib_mr *ibmr, int flags,
 		return ERR_PTR(-EOPNOTSUPP);
 	}
 
+	if (!rxe_mr_reserve_mw_state(mr)) {
+		rxe_err_mr(mr, "mr has mws bound\n");
+		return ERR_PTR(-EINVAL);
+	}
+
 	if (flags & IB_MR_REREG_PD) {
 		rxe_put(old_pd);
 		rxe_get(pd);
@@ -1346,6 +1351,8 @@ static struct ib_mr *rxe_rereg_user_mr(struct ib_mr *ibmr, int flags,
 	if (flags & IB_MR_REREG_ACCESS)
 		mr->access = access;
 
+	rxe_mr_release_mw_state(mr);
+
 	return NULL;
 }
 
@@ -1401,13 +1408,15 @@ static int rxe_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 	struct rxe_mr *mr = to_rmr(ibmr);
 	int err, cleanup_err;
 
-	/* See IBA 10.6.7.2.6 */
-	if (atomic_read(&mr->num_mw) > 0) {
+	/* See IBA 10.6.7.2.6. Leave num_mw set to -1 for destruction. */
+	if (!rxe_mr_reserve_mw_state(mr)) {
 		err = -EINVAL;
 		rxe_dbg_mr(mr, "mr has mw's bound\n");
 		goto err_out;
 	}
 
+	mr->state = RXE_MR_STATE_INVALID;
+
 	cleanup_err = rxe_cleanup(mr);
 	if (cleanup_err)
 		rxe_err_mr(mr, "cleanup failed, err = %d\n", cleanup_err);
-- 
2.43.0

