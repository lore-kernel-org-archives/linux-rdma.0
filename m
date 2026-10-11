Received: from sender5-of-o55.zoho.com (sender5-of-o55.zoho.com [165.173.182.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594E543BDC7
	for <linux-rdma@vger.kernel.org>; Sun, 11 Oct 2026 11:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=165.173.182.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791719780; cv=pass; b=idZQhASeOs8r7Y+P0W90dhbzzpLUEM00WB52DoWCBKP01YhgQP+W0azNEMJK03P7vz+nQ1uO9lVjU+wMQW2OxYcQS4zb8QRdYpNI/0gnjG/YAN8+HHAyF9hWx1aZvdwHh0k75w7FHGrlXmyRQ/wKpieBHV5v3wKaC3hYmcy9R7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791719780; c=relaxed/simple;
	bh=ZFZBgUhf7f+TCj8wlY4gKK/ytctvQfd5SCKgBrwzjwA=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:Subject:MIME-Version:
	 Content-Type; b=CNJ1EzyMGwSET4XtVw89fHikGElBCJPyFGGwj3BQI4J5kklIWMe13JXi/c+J/3D3kVUOFcBMGGa0VqjYc1uLxZFunKFmkZ2OasTQRhNCyko5vU7qPQCsEZ20GyTefAGc3MxXWQ0SLtrIYIGMcloBmII/FXcfH6IzVy9VoLf/5DM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lazaarsec.com; spf=pass smtp.mailfrom=lazaarsec.com; dkim=pass (1024-bit key) header.d=lazaarsec.com header.i=haitam@lazaarsec.com header.b=bJi7Jil3; arc=pass smtp.client-ip=165.173.182.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lazaarsec.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lazaarsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lazaarsec.com header.i=haitam@lazaarsec.com header.b="bJi7Jil3"
ARC-Seal: i=1; a=rsa-sha256; t=1791719759; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=M2FEg044PSzHr5e4OzjF5jwDhVWApjwdNgCG6hXf6spVvpT+0X6usTrEMP6vlZI7w48+/p7bGVnkrlMK/9dsMhwWP7CPEWdzH46YXcvdK+b7j4T51/89D7TpV/I4SbaVi3mPMHOkOGX+s+CUtCMhadqaaDWtBm208S/mJxzeULU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1791719759; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=SyyiI1b+5GgHkxqPLhTc5nCNvFTeEuT/MIzkN8tR8hw=; 
	b=Oqmyvzl82tRWwDrn7IH7JhbaavOPpIEmEZOZWC8xkxq6LVainEtL4R2eu6KftWgCbZJOTyVPYksomNn8LSoBHmR5M7z3fhOpl7pAtVlYgoHJK3UodFsZXy6dB4NdngIkSaqk4gxN1O3trLxmSY1jfGvCyBJUlXhAKyBQ05G27b0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=lazaarsec.com;
	spf=pass  smtp.mailfrom=haitam@lazaarsec.com;
	dmarc=pass header.from=<haitam@lazaarsec.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1791719759;
	s=zmail; d=lazaarsec.com; i=haitam@lazaarsec.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=SyyiI1b+5GgHkxqPLhTc5nCNvFTeEuT/MIzkN8tR8hw=;
	b=bJi7Jil3406eY897QVzMyeVe4TbQ3cqy0Yqn0GRqjIyw+lW7AI49Qbjsxz5FpJ20
	nhcEtPXxVBzuhx5mVRQr78vO02abbmvaZpbNaez4404OYuAjER60/nuvt1TVUIF6S2l
	CAv72/kNL6VfdNSNp5M5ilmLUMqANdN+u0p/pp+g=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1791719757904417.81938295907935; Sun, 11 Oct 2026 04:55:57 -0700 (PDT)
Date: Sun, 11 Oct 2026 11:55:57 +0000
From: Haitam Lazaar <haitam@lazaarsec.com>
To: "Leon Romanovsky" <leon@kernel.org>,
	"Bernard Metzler" <bernard.metzler@linux.dev>
Cc: "Jason Gunthorpe" <jgg@ziepe.ca>,
	"linux-rdma" <linux-rdma@vger.kernel.org>
Message-ID: <1a12ad1d83f.19cd98924357428.7073029566232810804@lazaarsec.com>
In-Reply-To: 
Subject: [PATCH v3 for-rc] RDMA/siw: Enforce IB_ACCESS_REMOTE_READ for read
 responses
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

When generating an RDMA READ response (SIW_OP_READ_RESPONSE),
siw_check_sgl_tx() unconditionally passes 0 as the required permission
mask:

    /* Reference memory to be tx'd w/o checking access for LOCAL_READ */
    rv = siw_check_sgl_tx(qp->pd, wqe, 0);

Because perms is 0, siw_check_mem()'s authorization test:
    if ((mem->perms & perms) < perms)
evaluates to (mem->perms & 0) < 0, which is always false. Consequently,
an untrusted remote peer can issue an RDMA Read targeting any valid
STag in the Protection Domain, even if the memory was registered strictly
as write-only (IB_ACCESS_REMOTE_WRITE) without IB_ACCESS_REMOTE_READ.

Enforce that the target memory region was granted IB_ACCESS_REMOTE_READ
when answering SIW_OP_READ_RESPONSE work queue entries, while preserving
perms = 0 for standard local sends.

Fixes: b9be6f18cf9e ("rdma/siw: transmit path")
Cc: stable@vger.kernel.org
Signed-off-by: Haitam Lazaar <haitam@lazaarsec.com>
Acked-by: Bernard Metzler <bernard.metzler@linux.dev>
---
v2 -> v3:
 - Remove stable@vger.kernel.org from email recipient list.
 - Pick up Acked-by from Bernard Metzler.

v1 -> v2:
 - Compact READ_RESPONSE handling by combining num_sge and perms assignment
   as suggested by Bernard Metzler.

 drivers/infiniband/sw/siw/siw_qp_tx.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index f7dd32c6e5ba..7dac144cc903 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -805,17 +805,21 @@ static int siw_qp_sq_proc_tx(struct siw_qp *qp, struct siw_wqe *wqe)
 
 	if (wqe->wr_status == SIW_WR_QUEUED) {
 		if (!(wqe->sqe.flags & SIW_WQE_INLINE)) {
-			if (tx_type(wqe) == SIW_OP_READ_RESPONSE)
-				wqe->sqe.num_sge = 1;
-
 			if (tx_type(wqe) != SIW_OP_READ &&
 			    tx_type(wqe) != SIW_OP_READ_LOCAL_INV) {
+				enum ib_access_flags perms = 0;
+
 				/*
-				 * Reference memory to be tx'd w/o checking
-				 * access for LOCAL_READ permission, since
-				 * not defined in RDMA core.
+				 * Local READ permission doesn't exist in RDMA core.
+				 * A READ RESPONSE source is read by the remote peer,
+				 * so it must be checked for REMOTE_READ permission.
 				 */
-				rv = siw_check_sgl_tx(qp->pd, wqe, 0);
+				if (tx_type(wqe) == SIW_OP_READ_RESPONSE) {
+					perms = IB_ACCESS_REMOTE_READ;
+					wqe->sqe.num_sge = 1;
+				}
+
+				rv = siw_check_sgl_tx(qp->pd, wqe, perms);
 				if (rv < 0) {
 					if (tx_type(wqe) ==
 					    SIW_OP_READ_RESPONSE)
-- 
2.43.0

