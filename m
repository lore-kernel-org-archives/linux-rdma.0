Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4864A3407;
	Mon, 21 Sep 2026 14:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789999491; cv=none; b=Qzc9ZLEYVjZGHHrQmSgr7n5G5KCCbeiQV6jlh3Br2kMzkDVy1aDNJcoyIzHTuUIXbDNmCYZp7ci9XMk6wtVeheWNlFoEAXIVWzW1Y2JUoYSVc3/21OF9k/imB5Ic5DzbUV6VAC0nwm1Ttk0wXKQKQgz1ln4lg56sTY1vzI0IuG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789999491; c=relaxed/simple;
	bh=wDzL7ubQ3VJHCTQpvWmfEl1tp5YhwoLORt71FwFlY44=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=sZVQoY3ZZZMRRmoI0X9HCUrdDmB6yOGurV0ND6mWJrCl3Pwzwa1sXACfsCkxYZNvtA/tmzi73NEawsM/0HT9/lTIgWLnelC0kNTMnDXBd/MyeiHv/56I63pZCZ5vh2mfCgRY4AbqTjZRF1OXqX8tKmLhFKFpNk8mnA0TN20hrLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SWfG+fnM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SWfG+fnM"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5FA2C2BCB8;
	Mon, 21 Sep 2026 14:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789999490;
	bh=wDzL7ubQ3VJHCTQpvWmfEl1tp5YhwoLORt71FwFlY44=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=SWfG+fnM1lZMlge2IYR6cy2O42HjvOh8otEufX2wNdgJ4eVmq9U6SoeOfe0G9AXCG
	 KZOdYGnJiQseyhPb6Z8cniZ3lx3BKmRzHTHDlyEHD/HJXNvlejD+qDEH11aZb+i9cC
	 Seye3Edmarg+g9j/KVZk8jl25Xh6oMm1FKI4kMxxUi0kt/rqlmySXoV7lMoyPuP/i8
	 RXpo4vZPxFPLXqDZGKOO/jPejwWORTmyOjkU3ZDdxQ5ACT0pbafSOk1QhqIyZvo6dE
	 q0SApUWbNixLrf2ID+zs7ftci33igIxSuT8Qbz0ZgPi6yf/p1BFoXf/A72Ydtt+ern
	 yEuBW9T1cUUqQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1DBFC982E1;
	Mon, 21 Sep 2026 14:04:50 +0000 (UTC)
From: Quanye Yang via B4 Relay <devnull+quanyeyang.proton.me@kernel.org>
Date: Mon, 21 Sep 2026 07:04:47 -0700
Subject: [PATCH] RDMA/rtrs-clt: Fix recv repost to satisfy ib_drain_rq
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-rtrs-fix-ib-drain-rq-v1-1-11b1637958ba@proton.me>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQ6CMBCF4auQWTNJ2wS0XsW4gM6o46LqDBCSh
 rtTZfkl7/0FjFXY4NIUUF7E5J0rfNtAeg75wShUDcGF3sXgUSc1vMuKMiLpIBn1i72ndO7I0am
 LUK8f5Tr5Z6+3wzaPL07TrwXbtgOecvaveAAAAA==
X-Change-ID: 20260921-rtrs-fix-ib-drain-rq-61dc85d0d759
To: "Md. Haris Iqbal" <haris.iqbal@ionos.com>, 
 Jack Wang <jinpu.wang@ionos.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>, 
 Danil Kipnis <danil.kipnis@cloud.ionos.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789999487; l=4263;
 i=quanyeyang@proton.me; s=20260801; h=from:subject:message-id;
 bh=jdc5f+VeX4vAQ0/q8YB5nswDUjlqTyT+yz3ZwEQCWWY=;
 b=+awDQrn+dez9ucZjiFAkkNLaPHDRTNQIeM5P7NDol8KqpSlUy1wmgTg9CugVwqJom/A2cBEA9
 aGVHk5ZyiFkArqRyHQcyNqHRjqw64nAXv8JeKgelmeP+Mbfrw/kzFa6
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

The legacy recv completion path deferred reposting invalidate receives
and instead posted two empty recv WQEs when handling RDMA-with-IMM
responses marked with invalidation.  If an invalidate receive never
arrived, each such response increased RQ occupancy by one until
ib_post_recv() started returning -ENOMEM and __ib_drain_rq() failed with:

  failed to drain recv queue: -12

Repost one empty recv WQE for every receive completion, including legacy
SEND_WITH_INV invalidates, and only while the path is still connected
so CQ polling cannot race with ib_drain_qp().  Size IO connection RQs to
2 * queue_depth + 1 to match the posted recv count and leave the drain
slot.

Tested with a synthetic RTRS client flooding unpaired
RTRS_IO_RSP_W_INV_IMM messages; error recovery no longer triggers
__ib_drain_rq() warnings.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Signed-off-by: Quanye Yang <quanyeyang@proton.me>
Tested-by: Quanye Yang <quanyeyang@proton.me>
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Link: https://lore.kernel.org/linux-rdma/CA+0ovCihE2_pxLimjmmR8NMz4g-ie8dvvq1jmAj-Om33y3Vzfg@mail.gmail.com
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


