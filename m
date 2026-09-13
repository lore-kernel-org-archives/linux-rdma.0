Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB573DB651;
	Sun, 13 Sep 2026 11:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789300005; cv=none; b=aDYlY86cB0xOTjK5ussFkDfakr0KoEErLk2CdYCUszyjZ3cb8SWNbslhILju++NmHW7cpep84+heRjeaLDW5D4JRzA4I1IuJm662uAHkR4mqTuSUWtPaCRH02VOZ9ctQrTz/5pprcC6LWST9l9hmpKidgYKAX9He4qGdb49d4fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789300005; c=relaxed/simple;
	bh=X9SMODT+oLS5jLGkNnFqvBlRGFvfl0UyniYxAUkHZEI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EkpPy3GOfLi5AxEq6nWNlTSjZ5gIQpEEe/Cimzkw4+YBiI8rGRx5BOgsk5ANHJ9sginMP37q4JbQAKUccviTh5pDSyNGVNaO3B7GLP2GkNQbcNqf3qZSrpZMOpc9ST7xBUPzJIOgchWij8txMyBqMoFWPU5EMyetJ2bs0hQ0k9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cjOlkXl+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cjOlkXl+"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6254C2BCFA;
	Sun, 13 Sep 2026 11:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789300005;
	bh=X9SMODT+oLS5jLGkNnFqvBlRGFvfl0UyniYxAUkHZEI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=cjOlkXl+6TnWiqiSEHItDJr7NelMgs3ttpLu2OgXyw91uEbSdXbewhws84l2/eEb9
	 rKoR0NfslQcMBKbDjsigBRk+2s5Lae08k3k7wbfhb7fnRdJJ5EB65a1bXIr1aKOHjd
	 oJQEo+BgzVHPepoFyiR9HufH/GGewGTakIORnobpWe8llD0R2/VxQ/UsXVhjfIpJLR
	 RYcnWPULOygPYVq2S9NCycvAUx7b2FbNrI6F5c+Ymcy8iziUJBGRo0UR5TyI8QfHPb
	 ADodUo9UZpe4qC1jV96KGNhuwKkakobtTNXNB9oAxWrAxUmAPtfkd2NxWOtBXRHVK9
	 FMFAlIh3uZVww==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D74C88E56;
	Sun, 13 Sep 2026 11:46:44 +0000 (UTC)
From: Norbert Szetei via B4 Relay <devnull+norbert.doyensec.com@kernel.org>
Date: Sun, 13 Sep 2026 13:45:16 +0200
Subject: [PATCH v2 2/2] RDMA/rxe: Reject prefetch of a non-ODP MR
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-rxe-advise-mr-v2-v2-2-b806c789871c@doyensec.com>
References: <20260913-rxe-advise-mr-v2-v2-0-b806c789871c@doyensec.com>
In-Reply-To: <20260913-rxe-advise-mr-v2-v2-0-b806c789871c@doyensec.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>, Bob Pearson <rpearsonhpe@gmail.com>, 
 Daisuke Matsuda <dskmtsd@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Zhu Yanjun <yanjun.zhu@linux.dev>, Norbert Szetei <norbert@doyensec.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789300003; l=2646;
 i=norbert@doyensec.com; s=20260913; h=from:subject:message-id;
 bh=oyLYk3wvsncMfK3wTS1S+010mockfwDHoTbDbXbk75Q=;
 b=xItCqBxvv+eIGB4uhoNf32tjUI5Fo+P5pqj1n5mA+5lo1Rvgq0uLJRI85SnSo4fKGiUjyJA02
 j/1DKn1d2BMDFAuC76RLuEOCx8HH8VTyYyC9BKcfE3UHM7dsZoqWdXp
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
index ab21b620e94c..c375d3efd999 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -469,7 +469,7 @@ static int rxe_ib_prefetch_sg_list(struct ib_pd *ibpd,
 		struct rxe_mr *mr;
 		struct ib_umem_odp *umem_odp;
 
-		mr = lookup_mr(pd, IB_ACCESS_LOCAL_WRITE,
+		mr = lookup_mr(pd, IB_ACCESS_LOCAL_WRITE | IB_ACCESS_ON_DEMAND,
 			       sg_list[i].lkey, RXE_LOOKUP_LOCAL);
 
 		if (!mr) {
@@ -535,7 +535,7 @@ static int rxe_ib_advise_mr_prefetch(struct ib_pd *ibpd,
 
 	for (i = 0; i < num_sge; ++i) {
 		/* Takes a reference, which will be released in the queued work */
-		mr = lookup_mr(pd, IB_ACCESS_LOCAL_WRITE,
+		mr = lookup_mr(pd, IB_ACCESS_LOCAL_WRITE | IB_ACCESS_ON_DEMAND,
 			       sg_list[i].lkey, RXE_LOOKUP_LOCAL);
 		if (!mr) {
 			mr = ERR_PTR(-EINVAL);

-- 
2.55.0


