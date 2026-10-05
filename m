Received: from sender6-of-o55.zoho.com (sender6-of-o55.zoho.com [165.173.180.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3668B4AD4A1;
	Mon,  5 Oct 2026 15:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=165.173.180.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791213515; cv=pass; b=SfDj+zjyjEXe+LSkVBtTqpl5xBTBgDxPiZKl+OVfUn9PgGw+OxoVsJnEMOXUi7rhJI8sliaAwXHE4MLyHt+LO5LlWYuSVFZhUfcX3SsU/79qPsx8J6vIevsuq0BzcUcCOrMdst6GQ+HiojcJBUHGKetKpknIKJ6zVpArqgcC+4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791213515; c=relaxed/simple;
	bh=9yE0K0KnfxY256k6cb1m5zTR0Vqh5BVIOtS7Rc+fsEU=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=FZFvCLKC8tdU1Pn8uO8pudQnUxOFgGc+L5NWYgfN7LPTkPTDXfN4u2o+jupr/palKRNcHyg/vXZhZgAIQMLckKYUtHxrnsaKpe96PhVpnK/+zlNDQwVlF6QPJbkDeLV4FJo/BIgYc8D0y9jqw1YK4uPeDpeBpqaljaVSEkFgdwc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lazaarsec.com; spf=pass smtp.mailfrom=lazaarsec.com; dkim=pass (1024-bit key) header.d=lazaarsec.com header.i=haitam@lazaarsec.com header.b=T9A/SEDd; arc=pass smtp.client-ip=165.173.180.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lazaarsec.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lazaarsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lazaarsec.com header.i=haitam@lazaarsec.com header.b="T9A/SEDd"
ARC-Seal: i=1; a=rsa-sha256; t=1791213507; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=RLtHvH32l3etp8jvjpBjbqnSqGK7x9BkQ9POF7iywPWttdzYeREfBBnn5HIA7AI4Qn0VqzCDhfoYzlikY9v8hDrzDUsjTfqw8t6Qj7XsZ3ovA3+hz/+P76UnbqTsHmRaYCQqDUXW+rZQqB2dA4iZAqJmp/kjHm+wdEoxPava16U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1791213507; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=9j8EnpDO+PvmefT89bDOgjlKvhc36MR5LPBLf5aa3Zg=; 
	b=jjbQrx621O0bWypseQ8cYd5FAxbAeerI78Fz33OrvF6QLI/3XhwXlfBueLjSdDE3GB8/f4OTh83bnXwojcMRHXTqpZadNs5JOc68TTwfCWhAhpQtsJG1z+9ZZyn0q30JLOjAqtVq+Pdv9c4bpHt9nmrI52qz9Zo4CitxerBUpLs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=lazaarsec.com;
	spf=pass  smtp.mailfrom=haitam@lazaarsec.com;
	dmarc=pass header.from=<haitam@lazaarsec.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1791213507;
	s=zmail; d=lazaarsec.com; i=haitam@lazaarsec.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=9j8EnpDO+PvmefT89bDOgjlKvhc36MR5LPBLf5aa3Zg=;
	b=T9A/SEDdmKMjn0eiy4aamGbK/SfaczL/mmi3Fxyebw1HF2zxx5VdHCX05f+9JJ/+
	4X8enmZdZzu7S/+N8uKtAb1WB+vy+3fp7DnB/xaBK+qvYKcBFo9wWU/4pSPoHftH9R2
	cpVr5RTn0ucdExq+ZhnRLqoTRuryZVQ8foYtvNsg=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1791213507367634.0366848917367; Mon, 5 Oct 2026 08:18:27 -0700 (PDT)
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1791213505436363.02545003773287; Mon, 5 Oct 2026 08:18:25 -0700 (PDT)
Date: Mon, 05 Oct 2026 15:18:25 +0000
From: Haitam Lazaar <haitam@lazaarsec.com>
To: "Bernard Metzler" <bernard.metzler@linux.dev>
Cc: "Jason Gunthorpe" <jgg@ziepe.ca>, "Leon Romanovsky" <leon@kernel.org>,
	"linux-rdma" <linux-rdma@vger.kernel.org>,
	"stable" <stable@vger.kernel.org>
Message-ID: <1a10ca50b82.4c79b9977088.8671544618706545172@lazaarsec.com>
In-Reply-To: <ecf307a2-e814-480d-8da8-1a7b76537d3f@linux.dev>
References: <1a10973a2a8.17e04b672219.8760522594078806286@lazaarsec.com> <ecf307a2-e814-480d-8da8-1a7b76537d3f@linux.dev>
Subject: [PATCH v2 for-rc] RDMA/siw: Enforce IB_ACCESS_REMOTE_READ for read
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
---
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


