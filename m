Received: from sender6-of-o55.zoho.com (sender6-of-o55.zoho.com [165.173.180.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE37119CC0F;
	Mon,  5 Oct 2026 00:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=165.173.180.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791159945; cv=pass; b=gPldSzmhUohIdw4GBT5ShPg6IqDvgK+ReP0W2LljqzNPUehUxbrrLatvdOgb6XpGryVxZmBx2gQ0fNytJxFFg9umos2NbilyehFI/pggaMLua/ttkTSnddanXVjohY5fIxw+/AcfFInNPT1l45EYR0tgld1PIweP1iFU6eyEa7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791159945; c=relaxed/simple;
	bh=g6Id/CITe1AjCOe8BiyGg2h/PT4nBSQdxzRDYcfScYQ=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:Subject:MIME-Version:
	 Content-Type; b=nlmTa+HT09ieMjdPPl83ikA3QZuzxfudfXMEliypPiMelFBCCe1W0F82uyW5RhqMO9/M/2WDJqJ3Zgh+9eg090UijAT5fmVgrlQfIRS1sGY2NsPJOy2w8v/v6cOUCQvKexYOhMQd4yk85ZWjDcFgx9Y7mCQw2VEzJ2f3Fv/4+As=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lazaarsec.com; spf=pass smtp.mailfrom=lazaarsec.com; dkim=pass (1024-bit key) header.d=lazaarsec.com header.i=haitam@lazaarsec.com header.b=IcaliGFB; arc=pass smtp.client-ip=165.173.180.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lazaarsec.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lazaarsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lazaarsec.com header.i=haitam@lazaarsec.com header.b="IcaliGFB"
ARC-Seal: i=1; a=rsa-sha256; t=1791159937; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=SFG+UL0pCCK98a6LIqckXsYMchHYNIEl6T84lsqsvTbIHS4ezrf3fHhQAtQ2w/T3ybcLZzYiTjB+S34o2oljoVocYkC4EgGfPdXahdjL1nTCCGySW8rkWaObNU5AxrQEaVMa4M/64AJWNq+5O4sipAhsEkvYHJj2cM4cVYCTCfc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1791159937; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=QjlTM+K9c2VSwtfFNdZjfx0yyzVG/WinHq6Izi14f8A=; 
	b=HmoMft81pT4PSUQRGgnQlI49ac5dYHHjr4sV1GZyKws2zHnIKBwx5iwSefNeymAqN8tn+iuLguBTA2xwwN+ZFkXruXC74OuafgcT2dgUoBs8WK/jQ0YtQ+8kKhjO8ummTJauJdSqq0kRBZP0fUC5CpLuC5KQMVHDDpKsbaYSJwY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=lazaarsec.com;
	spf=pass  smtp.mailfrom=haitam@lazaarsec.com;
	dmarc=pass header.from=<haitam@lazaarsec.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1791159937;
	s=zmail; d=lazaarsec.com; i=haitam@lazaarsec.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=QjlTM+K9c2VSwtfFNdZjfx0yyzVG/WinHq6Izi14f8A=;
	b=IcaliGFBf1jejekqvuj5B1hecXmYDPEVgiMEm6y+OiQBTlI73XLO29bKc8R08+Hk
	YqVl3mr9ZGls+bBOyMLHUfseclUQn7T1zILERCjYRTuBh/BplV822dmuep37PWHlgAc
	I06C+8hWIr6kf1CVrKkjHkb654TGpv6XVWsf3gO8=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1791159937285562.4403118885974; Sun, 4 Oct 2026 17:25:37 -0700 (PDT)
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1791159935674155.37696301141693; Sun, 4 Oct 2026 17:25:35 -0700 (PDT)
Date: Mon, 05 Oct 2026 00:25:35 +0000
From: Haitam Lazaar <haitam@lazaarsec.com>
To: "Bernard Metzler" <bernard.metzler@linux.dev>
Cc: "Jason Gunthorpe" <jgg@ziepe.ca>, "Leon Romanovsky" <leon@kernel.org>,
	"linux-rdma" <linux-rdma@vger.kernel.org>,
	"stable" <stable@vger.kernel.org>
Message-ID: <1a10973a2a8.17e04b672219.8760522594078806286@lazaarsec.com>
In-Reply-To: 
Subject: [PATCH for-rc] RDMA/siw: Enforce IB_ACCESS_REMOTE_READ for read
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
 drivers/infiniband/sw/siw/siw_qp_tx.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index f7dd32c6e5ba..9e652585f904 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -810,12 +810,17 @@ static int siw_qp_sq_proc_tx(struct siw_qp *qp, struct siw_wqe *wqe)
 
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
+				if (tx_type(wqe) == SIW_OP_READ_RESPONSE)
+					perms = IB_ACCESS_REMOTE_READ;
+
+				rv = siw_check_sgl_tx(qp->pd, wqe, perms);
 				if (rv < 0) {
 					if (tx_type(wqe) ==
 					    SIW_OP_READ_RESPONSE)
-- 


