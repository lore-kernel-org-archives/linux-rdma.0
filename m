Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8CB37206B;
	Wed, 23 Sep 2026 10:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160735; cv=none; b=DR2U3KQhfCmFwRMFI2NrPcHPvpkiCh4mipxx9DO/XfnaKZNRhSxrwTcM2pw7atx/H2qRxyQYahpeo5+rblnvDgome5RxRyAzSXHCjP2mpvlHW1s0uCyQPFBa+dKjMp/gS8vxz/AWBC3fnBfoTxCHAGEIQLQd9MJBjIng2Uca/54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160735; c=relaxed/simple;
	bh=LfpEGeo/6Nvm5ZiRbBqEYHeRf07sDNiDTMNj6qphyVc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=qif4BLZpu5z30cTfBHm8trjwBbJZrOxZ00ulHnZzPJLZcbxIQjkiFNXIp1iieWKZJCjEQ+iSM6hJJYjPv24ZP14vMJ9dBnirArJfCU2jCph3qZXBwqQfsJ5jWhYv8N/ejSFdHBElKdraIeFPEfuQKfs3mW8GMHbxj6Auz5/C/sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AEF1mZmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AEF1mZmG"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35EA4C2BCB8;
	Wed, 23 Sep 2026 10:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790160733;
	bh=LfpEGeo/6Nvm5ZiRbBqEYHeRf07sDNiDTMNj6qphyVc=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=AEF1mZmGFIH+cZbZgOtrsbYBlNREenjem9XY7R/nU0Ewh1CwjlzIfcFm3gYjE3geR
	 TDzuD0PYQB9KV7J1nGMa7K6VOR7OcUcQsFD0pTLJs1FsGvp3IslYCBgbR+81XJjM3N
	 PRn65q08OC3KTUlGvFqC1O4o4Knn973WKT7Fxbnou3VJNWPXqfnKRgXK5Zx9cLdtik
	 4jLJHPSSugjX1by5iouLR35a5yXNNvnDEl/pVWl1nMh31suTQfh1FleNqUlGnSHDvj
	 RDUgLMwAQEonukPNkLODC4lrN8St5ERSDihmqnbDbzMo2ANNCHYZ9DnkiHC7tCVJRU
	 n1XBY4Md3bsJA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08592C98307;
	Wed, 23 Sep 2026 10:52:13 +0000 (UTC)
From: Quanye Yang via B4 Relay <devnull+quanyeyang.proton.me@kernel.org>
Date: Wed, 23 Sep 2026 03:52:11 -0700
Subject: [PATCH] RDMA/rtrs-clt: Validate peer-supplied IO completion msg_id
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-rtrs-warning-inrtrs-clt-rdma-done-v1-1-0827a9a77c0b@proton.me>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXNwQrCMAyA4VcZORvoWubQVxEPXRtnRDNJOhXG3
 t06j9/l/xcwUiaDY7OA0ouNJ6lodw2ka5SRkHM1eOf37uADalHDd1RhGZFlY7oX1PyImCchDLH
 3uQ9d54YWauepdOHP9jid/7Z5uFEqvzCs6xcvlyFBhQAAAA==
X-Change-ID: 20260923-rtrs-warning-inrtrs-clt-rdma-done-3a72d73550b1
To: "Md. Haris Iqbal" <haris.iqbal@ionos.com>, 
 Jack Wang <jinpu.wang@ionos.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>, 
 Danil Kipnis <danil.kipnis@cloud.ionos.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790160731; l=3239;
 i=quanyeyang@proton.me; s=20260801; h=from:subject:message-id;
 bh=GDXHINJv2vDuvTX9EdmF1T8Ljuh5MUi1ez80LQxqrxY=;
 b=iSVJPsFdC0q9D4T0Sr5eEF7iq1+y6QVBvdXATXMYmK/mTcjNAtyIEBS4NuO6K4YLSu6oPMf/o
 5H/+dAd/CyZD/UMA+ipyjDhb6QCaZpP2ovLgfQpfcYG68ItJ9GIPob5
X-Developer-Key: i=quanyeyang@proton.me; a=ed25519;
 pk=9L9FrcvzMgxPaBRU6XV0EnqTgjDqVO596rQKSZ9qZoY=
X-Endpoint-Received: by B4 Relay for quanyeyang@proton.me/20260801 with
 auth_id=963
X-Original-From: Quanye Yang <quanyeyang@proton.me>
Reply-To: quanyeyang@proton.me

From: Quanye Yang <quanyeyang@proton.me>

process_io_rsp() indexes clt_path->reqs[] with the 19-bit msg_id
taken from a WRITE_WITH_IMM immediate. That value is chosen by the
peer. The only check was WARN_ON(msg_id >= queue_depth), which still
lets a completion run after free_path_reqs() has set reqs to NULL,
or against a slot whose FRWR is already gone. Either path
dereferences req->mr and can GPF; KASAN reports a null-ptr-deref at
offsetof(struct rtrs_clt_io_req, mr).

Treat a missing reqs array, an out-of-range msg_id, or a req
without an MR as a protocol error and recover the connection.

Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Link: https://lore.kernel.org/r/CA+0ovCiJZz6O8LzsS9Dq1-JE1OE1L_OTA6Mr-WratpUE6jczHw@mail.gmail.com
Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Signed-off-by: Quanye Yang <quanyeyang@proton.me>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index eac38b57b00d..f8d3c6f37e3e 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -489,18 +489,22 @@ static int rtrs_post_send_rdma(struct rtrs_clt_con *con,
 					    imm, flags, wr, NULL);
 }
 
-static void process_io_rsp(struct rtrs_clt_path *clt_path, u32 msg_id,
+static bool process_io_rsp(struct rtrs_clt_path *clt_path, u32 msg_id,
 			   s16 errno, bool w_inval)
 {
 	struct rtrs_clt_io_req *req;
 
-	if (WARN_ON(msg_id >= clt_path->queue_depth))
-		return;
+	if (!clt_path->reqs || msg_id >= clt_path->queue_depth)
+		return false;
 
 	req = &clt_path->reqs[msg_id];
+	if (!req->mr)
+		return false;
+
 	/* Drop need_inv if server responded with send with invalidation */
 	req->mr->need_inval &= !w_inval;
 	complete_rdma_req(req, errno, true, false);
+	return true;
 }
 
 static void rtrs_clt_recv_done(struct rtrs_clt_con *con, struct ib_wc *wc)
@@ -562,7 +566,8 @@ static void rtrs_clt_rkey_rsp_done(struct rtrs_clt_con *con, struct ib_wc *wc)
 		if (WARN_ON(buf_id != msg_id))
 			goto out;
 		clt_path->rbufs[buf_id].rkey = le32_to_cpu(msg->rkey);
-		process_io_rsp(clt_path, msg_id, err, w_inval);
+		if (!process_io_rsp(clt_path, msg_id, err, w_inval))
+			goto out;
 	}
 	ib_dma_sync_single_for_device(clt_path->s.dev->ib_dev, iu->dma_addr,
 				      iu->size, DMA_FROM_DEVICE);
@@ -634,7 +639,13 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 			w_inval = (imm_type == RTRS_IO_RSP_W_INV_IMM);
 			rtrs_from_io_rsp_imm(imm_payload, &msg_id, &err);
 
-			process_io_rsp(clt_path, msg_id, err, w_inval);
+			if (!process_io_rsp(clt_path, msg_id, err, w_inval)) {
+				rtrs_err(clt_path->clt,
+					 "Invalid IO rsp: msg_id %u queue_depth %zu\n",
+					 msg_id, clt_path->queue_depth);
+				rtrs_rdma_error_recovery(con);
+				return;
+			}
 		} else if (imm_type == RTRS_HB_MSG_IMM) {
 			WARN_ON(con->c.cid);
 			rtrs_send_hb_ack(&clt_path->s);

---
base-commit: 93f51579e7df248780214094418f205253383cc5
change-id: 20260923-rtrs-warning-inrtrs-clt-rdma-done-3a72d73550b1

Best regards,
--  
Quanye Yang <quanyeyang@proton.me>


