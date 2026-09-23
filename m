Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CED53C3C9;
	Wed, 23 Sep 2026 14:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174659; cv=none; b=aqSXzvrlpucPrTvgTixJTSYEv7JF+b0o0EPdXHVdzgMEVdTOUoZPsmBSlibLsN4AFmRZyDfHy/4xBSh81MyTYT9BiB7eSWjy3sz+6JikXrbOPmYipYkBVxpPa2Xq0DOlf1nYckur47olblb6teCZY/voXZEPl7Abvs176c5aZKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174659; c=relaxed/simple;
	bh=EB63EaSZMCNY5nE3KWUV4Qnkrt4NrdgytM88dOQtn3c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kFJ4HbUtmCdxp0l7++FceN3bHOCFObWPgSi/aOEjrPD1RjXy4LzCzq+BeeawpzEW6rWgnsvI7q64Ev13ZOR4staf1+ZxB6ffBIotXOLLu+M7VXfrc3hJzgcyo42RAN8OBSlBgMAu4lMNaXgLgnHiN7zbcJl7Z3Zd5/YjJrPt4uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PSw8iiaB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PSw8iiaB"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2EE04C2BCF7;
	Wed, 23 Sep 2026 14:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790174659;
	bh=EB63EaSZMCNY5nE3KWUV4Qnkrt4NrdgytM88dOQtn3c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=PSw8iiaBjfiVoJDzbpGdW/D5xNAYBUugrGq1bj+IjUbwi/l30xG6YUTHosmtjWB9/
	 MOuvImdiu4JwhUgZTJ+dzODyMm6+qJmykV6GLQaK0wHlrCBVLmLHUBIChUOmqLVuCs
	 XPryM9Nw50wZVZFyu+hc5nhmol61qWtlNxN57jI/lieo9IhNEGyrwR4disUZHeHPJz
	 NKW2RZBQCszUn9YZqlxtB3iZGH96cQGa5UQzKZiGK3I15OP93soOFEv05xF1wRIjSb
	 kdSz3VjexsUcJs6S7VO3uvnPB/VH48ySKbEedu30pX1QC+/ITEjK0P1SbvZzk1uIeQ
	 KN4xXCI9Kxzag==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09061C9830E;
	Wed, 23 Sep 2026 14:44:19 +0000 (UTC)
From: Norbert Szetei via B4 Relay <devnull+norbert.doyensec.com@kernel.org>
Date: Wed, 23 Sep 2026 16:40:50 +0200
Subject: [PATCH v3 2/2] RDMA/rxe: Reject prefetch of a non-ODP MR
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-rxe-advise-mr-v3-v3-2-95e1a4077e4d@doyensec.com>
References: <20260923-rxe-advise-mr-v3-v3-0-95e1a4077e4d@doyensec.com>
In-Reply-To: <20260923-rxe-advise-mr-v3-v3-0-95e1a4077e4d@doyensec.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>, Bob Pearson <rpearsonhpe@gmail.com>, 
 Daisuke Matsuda <dskmtsd@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Zhu Yanjun <yanjun.zhu@linux.dev>, stable@vger.kernel.org, 
 Norbert Szetei <norbert@doyensec.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790174657; l=2646;
 i=norbert@doyensec.com; s=20260913; h=from:subject:message-id;
 bh=cfYNjNX25gHhCbVjC9M+4NI38O7i/5dxSGK9KDS3KKw=;
 b=0RklZrJRnMkEocD5BNy4CQohSSJnFN+1Xpy84302tD7CFu9c+DFUdofFA+2o4VuzZQk8ipS3v
 ftUDGOQBWa9DDfRDWApGP3CxkTcye1f7BkC8JIGAj7CGxcN2zNWNfxh
X-Developer-Key: i=norbert@doyensec.com; a=ed25519;
 pk=c6ZqJ+mhvi5FloJOiMJUcIPPjT7tczbglx5gruwpVi8=
X-Endpoint-Received: by B4 Relay for norbert@doyensec.com/20260913 with
 auth_id=1029
X-Original-From: Norbert Szetei <norbert@doyensec.com>
Reply-To: norbert@doyensec.com

From: Norbert Szetei <norbert@doyensec.com>

rxe_ib_advise_mr_prefetch() and rxe_ib_prefetch_sg_list() look up the MR
by lkey and hand it to rxe_odp_do_pagefault_and_lock() without checking
that it is an ODP MR. That path runs to_ib_umem_odp() on mr->umem, and
for a non-ODP MR mr->umem is a plain struct ib_umem from ib_umem_get(),
so the container_of() in to_ib_umem_odp() lands past the end of the
object and ib_umem_odp_map_dma_and_lock() reads its ib_umem_odp fields
out of bounds.

lookup_mr() validates the lkey, PD, access and state but not the MR
type, and IB_UVERBS_ADVISE_MR_ADVICE_PREFETCH is accepted for any MR.

 BUG: KASAN: slab-out-of-bounds in ib_umem_odp_map_dma_and_lock+0x884/0x8a0
 Read of size 8 at addr ffff88810a3ebcf0 by task advi/921
  ib_umem_odp_map_dma_and_lock+0x884/0x8a0
  rxe_ib_advise_mr+0x543/0xad0
  ib_uverbs_handler_UVERBS_METHOD_ADVISE_MR+0x446/0x530
  ib_uverbs_cmd_verbs+0x2b3c/0x3b20
  ib_uverbs_ioctl+0x1e3/0x310
 Allocated by task 921:
  __ib_umem_get_va+0x13e/0xae0
  rxe_mr_init_user+0x2ae/0xb00
  rxe_reg_user_mr+0x337/0x510
 The buggy address belongs to the object at ffff88810a3ebc80
  which belongs to the cache kmalloc-96 of size 96

Ask lookup_mr() for IB_ACCESS_ON_DEMAND in both the synchronous and
the asynchronous prefetch arm. mr->access carries that flag only for
an MR registered as ODP, so the existing
(access & mr->access) != access test rejects a plain MR and the
prefetch fails with -EINVAL.

Fixes: 3576b0df1588 ("RDMA/rxe: Implement synchronous prefetch for ODP MRs")
Cc: stable@vger.kernel.org
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
---
 drivers/infiniband/sw/rxe/rxe_odp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
index e870efa7a0a3..f8ffd6a3219a 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -463,7 +463,7 @@ static int rxe_ib_prefetch_sg_list(struct ib_pd *ibpd,
 		struct rxe_mr *mr;
 		struct ib_umem_odp *umem_odp;
 
-		mr = lookup_mr(pd, IB_ACCESS_LOCAL_WRITE,
+		mr = lookup_mr(pd, IB_ACCESS_LOCAL_WRITE | IB_ACCESS_ON_DEMAND,
 			       sg_list[i].lkey, RXE_LOOKUP_LOCAL);
 
 		if (!mr) {
@@ -529,7 +529,7 @@ static int rxe_ib_advise_mr_prefetch(struct ib_pd *ibpd,
 
 	for (i = 0; i < num_sge; ++i) {
 		/* Takes a reference, which will be released in the queued work */
-		mr = lookup_mr(pd, IB_ACCESS_LOCAL_WRITE,
+		mr = lookup_mr(pd, IB_ACCESS_LOCAL_WRITE | IB_ACCESS_ON_DEMAND,
 			       sg_list[i].lkey, RXE_LOOKUP_LOCAL);
 		if (!mr) {
 			mr = ERR_PTR(-EINVAL);

-- 
2.55.0


