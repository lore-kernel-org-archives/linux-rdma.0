Received: from cvsmtppost36.nm.naver.com (cvsmtppost36.nm.naver.com [114.111.35.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268F83644CF
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 06:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.111.35.244
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791439683; cv=none; b=HTNhW0B8TuyKcruurF1mUg8AmU0pfW56cleaXzPVHI4QnmmfIzVH1K2Tbw2fKNJx2NZTBk51HfXwsRteZWx8M6K/+stCwI0hVZdzrQuDhyL3zYcY2Mt22MHFuMvIyAmXaPcsbl2iYmqt8HsStNAMYX1RW8IjmlU/DcSGoKA4HZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791439683; c=relaxed/simple;
	bh=YTqyIPDUpAWrX15Td3Nz9EVelyPwisY1f/xZSJRb1+0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OXqWRdsKL568A7KSRXCyJ7kLLUa9hzhuEyybRsxgGkwgeKYvjLOTN5GF0+8tFv/L6fzGkdLtjA029r6edumblMhCBoXVCj0v2YFbcrgBrQcoAsprN+iZyCcvTa2KBtOjzc3l8VIjUF3SERBRGNjUR/6NyIs8CdZx9YmCvW8zYGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=TMt1j62A; arc=none smtp.client-ip=114.111.35.244
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="TMt1j62A"
Received: from cvsendbo033.nm ([10.112.18.61])
  by cvsmtppost36.nm.naver.com with ESMTP id 8PicKdBBRfmdr1KdZVoWJA
  for <linux-rdma@vger.kernel.org>;
  Thu, 08 Oct 2026 06:07:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1791439678; bh=YTqyIPDUpAWrX15Td3Nz9EVelyPwisY1f/xZSJRb1+0=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=TMt1j62AKobK0+150r6B+tQmqG8aOUY8+62dXg9LQomq94lZpezz1FsFfnkq2IIxL
	 MDhfnIXnnlqj2ynu/lYpDXdfy8MlWNVAxD1c5puZuFtvb1Y83tXbGFGVQazCzEiF6q
	 WVbTLt5LEKE9O211y1rTL7hv8w5UTm4AVSwiIeLDuAmDXHqY/taiVWaE8V7UhzhJD4
	 Lze3g+pRtM+Ig92BrLT7PAKDzniubpLGzNbp/jRQyPtBLEeTb3yYYYWcMszx0YXKRK
	 W41LlNi0NbpkoV/a+eZG2l03VzOY7ZNmjwnbiXMK6SYXqg542l4Dp5KaXDSA5cf7TN
	 1vR9IfFTrMXJQ==
X-Session-ID: -o8cXF41QlK3PMnJLKuWXQ
X-Works-Send-Opt: OPFwpzGdjHmdKHFOMr39Ko3YKHmdjAudFqM9KqMqFxIYkEljxBmwjAg=
X-Works-Smtp-Source: r9KmFAulFqJZ+Hm/FqUX+6E=
Received: from localhost.localdomain ([115.136.205.4])
  by cvnsmtp005.nm.naver.com with ESMTP id -o8cXF41QlK3PMnJLKuWXQ
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Thu, 08 Oct 2026 06:07:58 -0000
From: sung byeongchan <tjdqudcks0424@naver.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org
Subject: [PATCH v2] RDMA/rxe: enforce memory window ranges
Date: Thu,  8 Oct 2026 15:07:51 +0900
Message-ID: <20261008060751.183786-1-tjdqudcks0424@naver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RXE records the address and length authorized by an MW bind, but the
responder checks remote requests only against the wider backing MR.  A peer
holding a valid type-2 MW rkey can consequently access registered userspace
memory outside the interval delegated by that MW.

The first version added the missing range check but read mutable MW
binding fields without preserving one coherent lifetime-protected
snapshot.  It also applied the same range treatment to IB_FLUSH_MR, whose
optional RETH range does not describe an MW-relative interval.

Validate the MW and take a reference on its backing MR while holding the MW
lock.  Copy the address, length, and access fields from that same snapshot,
then use subtraction-form bounds checks to reject wrapping or end-crossing
requests.  Preserve whole-MR flush semantics while enforcing both MW and
MR bounds for range flushes.  Retain the initially authorized MR reference
in an RDMA READ responder resource, and require later packets and replays
to resolve to the same MR and still cover the original interval.

The original out-of-window READ and WRITE were reproduced twice on the
originally tested baseline.  The v2 authorization, FLUSH, invalidate, and
rebind matrices passed under KASAN, with the race cases repeated twice,
and a separate KCSAN build reported no RXE race.  The affected source
blobs are unchanged on the current mainline base, where this version also
applies and builds.

The demonstrated impact is access to registered userspace memory outside
the delegated MW.  Kernel-memory access, code execution, and privilege
escalation were not demonstrated.  The source reproducer is available
privately on request and is intentionally omitted from this public
submission.

Fixes: cdd0b85675ae ("RDMA/rxe: Implement memory access through MWs")
Assisted-by: LLM
Signed-off-by: sung byeongchan <tjdqudcks0424@naver.com>
---
 drivers/infiniband/sw/rxe/rxe_loc.h   |  3 +-
 drivers/infiniband/sw/rxe/rxe_mw.c    | 31 +++++++--
 drivers/infiniband/sw/rxe/rxe_qp.c    |  5 ++
 drivers/infiniband/sw/rxe/rxe_resp.c  | 96 ++++++++++++++++-----------
 drivers/infiniband/sw/rxe/rxe_verbs.h |  1 +
 5 files changed, 90 insertions(+), 46 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 64d636bf80fd2..c0b78e3e1b185 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -86,7 +86,8 @@ int rxe_alloc_mw(struct ib_mw *ibmw, struct ib_udata *udata);
 int rxe_dealloc_mw(struct ib_mw *ibmw);
 int rxe_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe);
 int rxe_invalidate_mw(struct rxe_qp *qp, u32 rkey);
-struct rxe_mw *rxe_lookup_mw(struct rxe_qp *qp, int access, u32 rkey);
+struct rxe_mr *rxe_lookup_mw(struct rxe_qp *qp, int access, u32 rkey,
+			     u64 *addr, u64 *length, int *mw_access);
 void rxe_mw_cleanup(struct rxe_pool_elem *elem);
 
 /* rxe_net.c */
diff --git a/drivers/infiniband/sw/rxe/rxe_mw.c b/drivers/infiniband/sw/rxe/rxe_mw.c
index bddb7a2578313..faa1d0d97c8e2 100644
--- a/drivers/infiniband/sw/rxe/rxe_mw.c
+++ b/drivers/infiniband/sw/rxe/rxe_mw.c
@@ -291,10 +291,17 @@ int rxe_invalidate_mw(struct rxe_qp *qp, u32 rkey)
 	return ret;
 }
 
-struct rxe_mw *rxe_lookup_mw(struct rxe_qp *qp, int access, u32 rkey)
+/*
+ * Validate an MW and take a reference on its backing MR while holding the
+ * MW lock.  This keeps the binding fields coherent with the MR reference if
+ * an invalidate or rebind is running concurrently.
+ */
+struct rxe_mr *rxe_lookup_mw(struct rxe_qp *qp, int access, u32 rkey,
+			     u64 *addr, u64 *length, int *mw_access)
 {
 	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
 	struct rxe_pd *pd = to_rpd(qp->ibqp.pd);
+	struct rxe_mr *mr = NULL;
 	struct rxe_mw *mw;
 	int index = rkey >> 8;
 
@@ -302,15 +309,29 @@ struct rxe_mw *rxe_lookup_mw(struct rxe_qp *qp, int access, u32 rkey)
 	if (!mw)
 		return NULL;
 
+	spin_lock_bh(&mw->lock);
 	if (unlikely((mw->rkey != rkey) || rxe_mw_pd(mw) != pd ||
 		     (mw->ibmw.type == IB_MW_TYPE_2 && mw->qp != qp) ||
 		     (mw->length == 0) || ((access & mw->access) != access) ||
-		     mw->state != RXE_MW_STATE_VALID)) {
-		rxe_put(mw);
-		return NULL;
+		     mw->state != RXE_MW_STATE_VALID || !mw->mr ||
+		     mw->mr->state != RXE_MR_STATE_VALID)) {
+		goto out_unlock;
 	}
 
-	return mw;
+	mr = mw->mr;
+	if (!rxe_get(mr)) {
+		mr = NULL;
+		goto out_unlock;
+	}
+
+	*addr = mw->addr;
+	*length = mw->length;
+	*mw_access = mw->access;
+
+out_unlock:
+	spin_unlock_bh(&mw->lock);
+	rxe_put(mw);
+	return mr;
 }
 
 void rxe_mw_cleanup(struct rxe_pool_elem *elem)
diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 311f285d78a6b..5b7e058fd14db 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -178,6 +178,11 @@ static void free_rd_atomic_resources(struct rxe_qp *qp)
 
 void free_rd_atomic_resource(struct resp_res *res)
 {
+	if (res->type == RXE_READ_MASK && res->read.mr) {
+		rxe_put(res->read.mr);
+		res->read.mr = NULL;
+	}
+
 	res->type = 0;
 }
 
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 02b16e2b49b8f..706a2a2d94333 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -468,7 +468,9 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 				   struct rxe_pkt_info *pkt)
 {
 	struct rxe_mr *mr = NULL;
-	struct rxe_mw *mw = NULL;
+	u64 mw_addr = 0;
+	u64 mw_length = 0;
+	int mw_access = 0;
 	u64 va;
 	u32 rkey;
 	u32 resid;
@@ -520,26 +522,32 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 	pktlen	= payload_size(pkt);
 
 	if (rkey_is_mw(rkey)) {
-		mw = rxe_lookup_mw(qp, access, rkey);
-		if (!mw) {
-			rxe_dbg_qp(qp, "no MW matches rkey %#x\n", rkey);
-			state = get_rkey_violation_state(pkt);
-			goto err;
-		}
+		u64 mw_start;
 
-		mr = mw->mr;
+		mr = rxe_lookup_mw(qp, access, rkey, &mw_addr, &mw_length,
+				   &mw_access);
 		if (!mr) {
-			rxe_dbg_qp(qp, "MW doesn't have an MR\n");
+			rxe_dbg_qp(qp, "no MW matches rkey %#x\n", rkey);
 			state = get_rkey_violation_state(pkt);
 			goto err;
 		}
 
-		if (mw->access & IB_ZERO_BASED)
-			qp->resp.offset = mw->addr;
+		if (mw_access & IB_ZERO_BASED)
+			qp->resp.offset = mw_addr;
 
-		rxe_get(mr);
-		rxe_put(mw);
-		mw = NULL;
+		/* FLUSH MR applies to the whole backing MR and its RETH fields
+		 * are not required to describe an MW-relative range.
+		 */
+		if (!(pkt->mask & RXE_FLUSH_MASK) ||
+		    feth_sel(pkt) != IB_FLUSH_MR) {
+			mw_start = (mw_access & IB_ZERO_BASED) ? 0 : mw_addr;
+			if (unlikely(va < mw_start || resid > mw_length ||
+				     va - mw_start > mw_length - resid)) {
+				rxe_dbg_qp(qp, "request outside MW range\n");
+				state = get_rkey_violation_state(pkt);
+				goto err;
+			}
+		}
 	} else {
 		mr = lookup_mr(qp->pd, access, rkey, RXE_LOOKUP_REMOTE);
 		if (!mr) {
@@ -605,8 +613,6 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 	qp->resp.mr = NULL;
 	if (mr)
 		rxe_put(mr);
-	if (mw)
-		rxe_put(mw);
 
 	return state;
 }
@@ -662,6 +668,8 @@ static struct resp_res *rxe_prepare_res(struct rxe_qp *qp,
 
 	switch (type) {
 	case RXE_READ_MASK:
+		res->read.mr = qp->resp.mr;
+		qp->resp.mr = NULL;
 		res->read.va = qp->resp.va + qp->resp.offset;
 		res->read.va_org = qp->resp.va + qp->resp.offset;
 		res->read.resid = qp->resp.resid;
@@ -876,7 +884,7 @@ static struct sk_buff *prepare_ack_packet(struct rxe_qp *qp,
 /**
  * rxe_recheck_mr - revalidate MR from rkey and get a reference
  * @qp: the qp
- * @rkey: the rkey
+ * @res: the responder resource holding the original authorized range
  *
  * This code allows the MR to be invalidated or deregistered or
  * the MW if one was used to be invalidated or deallocated.
@@ -890,27 +898,33 @@ static struct sk_buff *prepare_ack_packet(struct rxe_qp *qp,
  *
  * Return: mr on success else NULL
  */
-static struct rxe_mr *rxe_recheck_mr(struct rxe_qp *qp, u32 rkey)
+static struct rxe_mr *rxe_recheck_mr(struct rxe_qp *qp,
+				     const struct resp_res *res)
 {
 	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
+	u32 rkey = res->read.rkey;
 	struct rxe_mr *mr;
-	struct rxe_mw *mw;
 
 	if (rkey_is_mw(rkey)) {
-		mw = rxe_pool_get_index(&rxe->mw_pool, rkey >> 8);
-		if (!mw)
+		u64 addr, length;
+		int access;
+
+		mr = rxe_lookup_mw(qp, IB_ACCESS_REMOTE_READ, rkey,
+				   &addr, &length, &access);
+		if (!mr)
 			return NULL;
 
-		mr = mw->mr;
-		if (mw->rkey != rkey || mw->state != RXE_MW_STATE_VALID ||
-		    !mr || mr->state != RXE_MR_STATE_VALID) {
-			rxe_put(mw);
+		/* A replay or a later response packet must still refer to the
+		 * same backing MR and the entire originally authorized interval.
+		 * This catches invalidate/rebind even when the object survives.
+		 */
+		if (mr != res->read.mr || res->read.va_org < addr ||
+		    res->read.length > length ||
+		    res->read.va_org - addr > length - res->read.length) {
+			rxe_put(mr);
 			return NULL;
 		}
 
-		rxe_get(mr);
-		rxe_put(mw);
-
 		return mr;
 	}
 
@@ -918,7 +932,8 @@ static struct rxe_mr *rxe_recheck_mr(struct rxe_qp *qp, u32 rkey)
 	if (!mr)
 		return NULL;
 
-	if (mr->rkey != rkey || mr->state != RXE_MR_STATE_VALID) {
+	if (mr->rkey != rkey || mr->state != RXE_MR_STATE_VALID ||
+	    (res->read.mr && mr != res->read.mr)) {
 		rxe_put(mr);
 		return NULL;
 	}
@@ -949,14 +964,11 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 
 	if (res->state == rdatm_res_state_new) {
 		if (!res->replay || qp->resp.length == 0) {
-			/* if length == 0 mr will be NULL (is ok)
-			 * otherwise qp->resp.mr holds a ref on mr
-			 * which we transfer to mr and drop below.
-			 */
-			mr = qp->resp.mr;
-			qp->resp.mr = NULL;
+			mr = res->read.mr;
+			if (mr)
+				rxe_get(mr);
 		} else {
-			mr = rxe_recheck_mr(qp, res->read.rkey);
+			mr = rxe_recheck_mr(qp, res);
 			if (!mr)
 				return RESPST_ERR_RKEY_VIOLATION;
 		}
@@ -966,11 +978,11 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 		else
 			opcode = IB_OPCODE_RC_RDMA_READ_RESPONSE_FIRST;
 	} else {
-		/* re-lookup mr from rkey on all later packets.
-		 * length will be non-zero. This can fail if someone
-		 * modifies or destroys the mr since the first packet.
+		/* The permanent resource reference keeps the original backing MR
+		 * alive; this lookup also verifies that the MW still names that MR
+		 * and still covers the original request after invalidate/rebind.
 		 */
-		mr = rxe_recheck_mr(qp, res->read.rkey);
+		mr = rxe_recheck_mr(qp, res);
 		if (!mr)
 			return RESPST_ERR_RKEY_VIOLATION;
 
@@ -1019,6 +1031,10 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 	if (res->read.resid > 0) {
 		state = RESPST_DONE;
 	} else {
+		if (res->read.mr) {
+			rxe_put(res->read.mr);
+			res->read.mr = NULL;
+		}
 		qp->resp.res = NULL;
 		if (!res->replay)
 			qp->resp.opcode = -1;
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index 0f5ffd94643f9..b2c229ecef2a1 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -188,6 +188,7 @@ struct resp_res {
 			u32		length;
 			u64		va;
 			u32		resid;
+			struct rxe_mr	*mr;
 		} read;
 		struct {
 			u32		length;
-- 
2.43.0

