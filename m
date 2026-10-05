Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8A74248DB;
	Mon,  5 Oct 2026 09:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791190876; cv=none; b=mHj2oN2SK7Ym4kOQJaJjFDGupIYxgH71h0IVAxZ0aU8KuCXOaDFV1Am2zxqVFboQMjkLoP0mHjBbHMtwm9HtecUifK2xDSgNsQROAtkpG7R/9eR0u5S2zS90WqnkGy03TXfOdlkxRSXyBltPdLMo1mhsgWEua0kWxub5XtkFHyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791190876; c=relaxed/simple;
	bh=+DLvbIKKE1SahE0n2RkHugALMGd7OjcX+exktqGiYys=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=SoP8eC2dbOmTXFKyjIH/2vSUTr8fJYogKFbMfaSwZqeMUmYrvyGeWz4dXiReZegwvftfufGu99XFa8UfTGYl87HIn7BBn0fGKnB20+wThwq4MMOw9kWF9p1zQsldGecCfmm2qv1D7UWXFIOOSEvqjrb9ezm0ndhghguWGj9jJiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PWwPS1Wo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PWwPS1Wo"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61D55C2BCC7;
	Mon,  5 Oct 2026 09:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791190876;
	bh=+DLvbIKKE1SahE0n2RkHugALMGd7OjcX+exktqGiYys=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=PWwPS1WogT9rIYz5S9gRWrpTfk2dghnJLxH9ZfJAJ5ClfJgYDoaRv0wTG/uP6Krqj
	 hk20Ah0J8f+jBCohdwKY5v/CgsBixWSjKmbRDjC4XYw8Y9WTR/CofTBKUYc1hgwQfF
	 QsYZ+AmaonZYgM4NqpH+CqkXUrj6Q778W3J3ZBn2o7oHrB2pOYiZVdtvPrUWCSxQX+
	 qzNNJBaSEnJwvwkhsz4vTzOGTQsLZJ7EOADGIfdw6ip5sZoxVXYUsAZWV6q7mkTwZT
	 fUN8cSilhlUtTJGKGY24Ui+52lxn4Vg48RfhdBBi2vbkbgKwHWxkAB8KUcWirU3YP/
	 t70w53DvvjlBw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D967CA5FFC;
	Mon,  5 Oct 2026 09:01:16 +0000 (UTC)
From: Quanye Yang via B4 Relay <devnull+quanyeyang.proton.me@kernel.org>
Date: Mon, 05 Oct 2026 02:01:15 -0700
Subject: [PATCH v2] RDMA/rtrs-clt: Fix recv repost to satisfy ib_drain_rq
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261005-rtrs-fix-ib-drain-rq-v2-1-35535a3ed115@proton.me>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4WNTQ6CMBCFr0Jm7Rhaw58r72FYUDrKmNjCtBIN4
 e4WPIB5qy/53nsLBBKmAOdsAaGZA3uXQB8y6IfO3QnZJgad6zJvtEKJEvDGb2SDVjp2KBOWyvZ
 1YXNbFQ2k6iiUlH322v44vMyD+rhtbcbAIXr57L+z2rw/F7PCFGVUeaqaojbdZRQfvTs+Cdp1X
 b/NAPqdygAAAA==
X-Change-ID: 20260921-rtrs-fix-ib-drain-rq-61dc85d0d759
To: "Md. Haris Iqbal" <haris.iqbal@ionos.com>, 
 Jack Wang <jinpu.wang@ionos.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>, 
 Danil Kipnis <danil.kipnis@cloud.ionos.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791190875; l=4740;
 i=quanyeyang@proton.me; s=20260801; h=from:subject:message-id;
 bh=xU+26zGQuGnnIb4mC2wtzqOPeTks7lJXdQP6Vxpm7X8=;
 b=rql2JJN5fsfN2QEm5/l7NTEG6bzD+Ix26rD5VDgHTKuXSC6mwdT+7Wq7oqz5wav2fmzIz+gOC
 kTY4jX1EfNTDPzQPEwPQv6M5f+GMpe6pKdBh28ONDIzJpShE77h7d1w
X-Developer-Key: i=quanyeyang@proton.me; a=ed25519;
 pk=9L9FrcvzMgxPaBRU6XV0EnqTgjDqVO596rQKSZ9qZoY=
X-Endpoint-Received: by B4 Relay for quanyeyang@proton.me/20260801 with
 auth_id=963
X-Original-From: Quanye Yang <quanyeyang@proton.me>
Reply-To: quanyeyang@proton.me

From: Quanye Yang <quanyeyang@proton.me>

On disconnect the client error recovery path calls ib_drain_qp(), which
requires one free RQ slot and that no recv WQEs are posted while the
queue is being drained.

When the server is loaded with always_invalidate=N, the path does not
advertise RTRS_MSG_NEW_RKEY_F.  A client-requested invalidation is then
a standalone SEND_WITH_INV.  The recv completion path did not repost
that WQE; it posted two empty recv WQEs later, when the RDMA-with-IMM
response carried RTRS_IO_RSP_W_INV_IMM.  If the invalidate receive
never arrived, each such response increased RQ occupancy by one until
ib_post_recv() started returning -ENOMEM and __ib_drain_rq() failed
with:

  failed to drain recv queue: -12

Repost one empty recv WQE for every receive completion, including
SEND_WITH_INV completions on the always_invalidate=N path, and only
while the path is still connected so CQ polling cannot race with
ib_drain_qp().  Size IO connection RQs to 2 * queue_depth + 1 to match
the posted recv count and leave the drain slot.

Tested with a synthetic RTRS client flooding unpaired
RTRS_IO_RSP_W_INV_IMM messages; error recovery no longer triggers
__ib_drain_rq() warnings.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Signed-off-by: Quanye Yang <quanyeyang@proton.me>
Tested-by: Quanye Yang <quanyeyang@proton.me>
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Link: https://lore.kernel.org/linux-rdma/CA+0ovCihE2_pxLimjmmR8NMz4g-ie8dvvq1jmAj-Om33y3Vzfg@mail.gmail.com
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
Changes in v2:
- Clarify that the broken recv-repost path is always_invalidate=N
  (no RTRS_MSG_NEW_RKEY_F).
- Collect Acked-by from Jack Wang.
- Link to v1: https://patch.msgid.link/20260921-rtrs-fix-ib-drain-rq-v1-1-11b1637958ba@proton.me
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 45 ++++++++++++----------------------
 1 file changed, 15 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index eac38b57b00d..ee6d5c3de16c 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -577,25 +577,21 @@ static struct ib_cqe io_comp_cqe = {
 	.done = rtrs_clt_rdma_done
 };
 
-/*
- * Post x2 empty WRs: first is for this RDMA with IMM,
- * second is for RECV with INV, which happened earlier.
- */
-static int rtrs_post_recv_empty_x2(struct rtrs_con *con, struct ib_cqe *cqe)
+static int rtrs_clt_repost_recv(struct rtrs_clt_con *con)
 {
-	struct ib_recv_wr wr_arr[2], *wr;
-	int i;
+	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
+	int err;
 
-	memset(wr_arr, 0, sizeof(wr_arr));
-	for (i = 0; i < ARRAY_SIZE(wr_arr); i++) {
-		wr = &wr_arr[i];
-		wr->wr_cqe  = cqe;
-		if (i)
-			/* Chain backwards */
-			wr->next = &wr_arr[i - 1];
-	}
+	if (READ_ONCE(clt_path->state) != RTRS_CLT_CONNECTED)
+		return 0;
 
-	return ib_post_recv(con->qp, wr, NULL);
+	err = rtrs_post_recv_empty(&con->c, &io_comp_cqe);
+	if (err) {
+		rtrs_err(con->c.path, "rtrs_post_recv_empty(): %pe\n",
+			 ERR_PTR(err));
+		rtrs_rdma_error_recovery(con);
+	}
+	return err;
 }
 
 static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
@@ -650,19 +646,7 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 			rtrs_wrn(con->c.path, "Unknown IMM type %u\n",
 				  imm_type);
 		}
-		if (w_inval)
-			/*
-			 * Post x2 empty WRs: first is for this RDMA with IMM,
-			 * second is for RECV with INV, which happened earlier.
-			 */
-			err = rtrs_post_recv_empty_x2(&con->c, &io_comp_cqe);
-		else
-			err = rtrs_post_recv_empty(&con->c, &io_comp_cqe);
-		if (err) {
-			rtrs_err(con->c.path, "rtrs_post_recv_empty(): %pe\n",
-				 ERR_PTR(err));
-			rtrs_rdma_error_recovery(con);
-		}
+		rtrs_clt_repost_recv(con);
 		break;
 	case IB_WC_RECV:
 		/*
@@ -678,6 +662,7 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 
 			return  rtrs_clt_rkey_rsp_done(con, wc);
 		}
+		rtrs_clt_repost_recv(con);
 		break;
 	case IB_WC_RDMA_WRITE:
 		/*
@@ -1693,7 +1678,7 @@ static int create_con_cq_qp(struct rtrs_clt_con *con)
 		clt_path->s.dev_ref++;
 		/* QD * (REQ + RSP + FR REGS or INVS) + drain */
 		max_send_wr = min(wr_limit, clt_path->queue_depth * 4 + 1);
-		max_recv_wr = min(wr_limit, clt_path->queue_depth * 3 + 1);
+		max_recv_wr = min(wr_limit, clt_path->queue_depth * 2 + 1);
 		max_send_sge = 2;
 	}
 	atomic_set(&con->c.sq_wr_avail, max_send_wr);

---
base-commit: 93f51579e7df248780214094418f205253383cc5
change-id: 20260921-rtrs-fix-ib-drain-rq-61dc85d0d759

Best regards,
--  
Quanye Yang <quanyeyang@proton.me>


