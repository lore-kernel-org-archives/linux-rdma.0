Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7103253B61F;
	Wed, 23 Sep 2026 14:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174659; cv=none; b=D0oXPEzEvfXCplAG2PgMuEWXRmcllKtyDWDC/fBhgZ4X06q9zzEq6wQ/+tTrZE3blp1EjudgJ23fI91EsSTgMTijzwYXlCSDBNwY0p25RnX3sZEiBIjKBneTGxqRPSrw+1KY/aqFRhKRd03iH37qEHe3bUnM8J1jsH/RwxsX24w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174659; c=relaxed/simple;
	bh=JbK8SF6rj3FVILYqLYruw8+ndDVRZsJrV3Nb1yA+JnI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Q9qUQ6gcZ0+95xmGGBPMhNPBrz8Cyxe9K7AYuloaeEQIJBSK/s5xK0b2YRe7O8yf6fmmlcqlJtTYAYNUFfSQWgYtgXCRRblTz3LecDx7cZfS8dariJjFzTC3wAC7T8GfQL75/bTQDq6sG7JZGhsB3Dq6e8u/lsTCG3LySIKKdlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r9/q2UWr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r9/q2UWr"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 185CCC2BCB8;
	Wed, 23 Sep 2026 14:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790174659;
	bh=JbK8SF6rj3FVILYqLYruw8+ndDVRZsJrV3Nb1yA+JnI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=r9/q2UWrVpzu9bnrG66b65BQNrtBIsu4IefFyeiUo49eOHkQPko0km6apyyrhsPrC
	 QCZSk80UB47kbFN7pN+B17FASf7q5n5O3WPtBZdhxIvBvE6vQQeubnwd1Qol+7oKdM
	 lXH00ntbNkKoRESCBCdpy5NbwlL7btlY0whbRydy/PlybpAz/DBPFI4daNECg4EGsN
	 R/Ottnz4xrKo7viozSctGODI4hBAbX9eYlCyspuHYeKS2qk+InXZ+HDr2GvefSzkeG
	 f7pFe9jUVqquqJzFwyJrimWLl6D3JnAQuwua1VbpQvK/9xe8w32I+cr85JdqjxMCh+
	 wsQfurytk43Xw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9803C9830B;
	Wed, 23 Sep 2026 14:44:18 +0000 (UTC)
From: Norbert Szetei via B4 Relay <devnull+norbert.doyensec.com@kernel.org>
Date: Wed, 23 Sep 2026 16:40:49 +0200
Subject: [PATCH v3 1/2] RDMA/rxe: Reject IB_ACCESS_ON_DEMAND changes after
 MR creation
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-rxe-advise-mr-v3-v3-1-95e1a4077e4d@doyensec.com>
References: <20260923-rxe-advise-mr-v3-v3-0-95e1a4077e4d@doyensec.com>
In-Reply-To: <20260923-rxe-advise-mr-v3-v3-0-95e1a4077e4d@doyensec.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>, Bob Pearson <rpearsonhpe@gmail.com>, 
 Daisuke Matsuda <dskmtsd@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Zhu Yanjun <yanjun.zhu@linux.dev>, stable@vger.kernel.org, 
 Norbert Szetei <norbert@doyensec.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790174657; l=2510;
 i=norbert@doyensec.com; s=20260913; h=from:subject:message-id;
 bh=GGDMNIMMFgavQyw+alW2k5m6GacCiuPCFvCSnkVJm7M=;
 b=YVBMCEN8W79y713DC9Z3JrPx/igouyNVpEHragpEpC0fyRvC9DqYZx1utrwToKNDkMF760FwG
 uIHrgrMpLJrADwyn0Ksj6a5RrUVK8rBAZZGS0u+yKyUx3yCF08vQMQr
X-Developer-Key: i=norbert@doyensec.com; a=ed25519;
 pk=c6ZqJ+mhvi5FloJOiMJUcIPPjT7tczbglx5gruwpVi8=
X-Endpoint-Received: by B4 Relay for norbert@doyensec.com/20260913 with
 auth_id=1029
X-Original-From: Norbert Szetei <norbert@doyensec.com>
Reply-To: norbert@doyensec.com

From: Norbert Szetei <norbert@doyensec.com>

Whether an MR is an ODP MR is decided once, at registration time:
rxe_reg_user_mr() picks rxe_odp_mr_init_user() over rxe_mr_init_user()
based on IB_ACCESS_ON_DEMAND, and only the former builds an ib_umem_odp
via ib_umem_odp_get(). The umem cannot change type afterwards, and
is_odp_mr() reads mr->umem->is_odp.

Two paths assign mr->access after that point and can leave it
describing an MR type the umem does not have:

rxe_rereg_user_mr() with IB_MR_REREG_ACCESS overwrites mr->access with
the caller's value, and IB_ACCESS_ON_DEMAND is part of
RXE_ACCESS_SUPPORTED_MR, so userspace can set the flag on a plain MR or
clear it on an ODP MR while the umem stays what it was.

rxe_reg_fast_mr() takes mr->access from the REG_MR work request
unmasked and moves the MR to RXE_MR_STATE_VALID, on an MR that
rxe_mr_init_fast() left with a NULL umem.

Reject IB_ACCESS_ON_DEMAND in both, so mr->access carries the flag only
for an MR that has an ODP umem and the flag can be used to identify one.

Fixes: 544c7f62cf32 ("RDMA/rxe: Implement rereg_user_mr")
Cc: stable@vger.kernel.org
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
---
 drivers/infiniband/sw/rxe/rxe_mr.c    | 6 ++++++
 drivers/infiniband/sw/rxe/rxe_verbs.c | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 875eceb55fdf..2afda5154dfb 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -795,6 +795,12 @@ int rxe_reg_fast_mr(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 		return -EINVAL;
 	}
 
+	/* an MR with no umem is never an ODP MR */
+	if (unlikely(access & IB_ACCESS_ON_DEMAND)) {
+		rxe_dbg_mr(mr, "access = 0x%x requests ODP\n", access);
+		return -EINVAL;
+	}
+
 	mr->access = access;
 	mr->lkey = key;
 	mr->rkey = key;
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 96c7716057fe..21855274f63a 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1331,6 +1331,12 @@ static struct ib_mr *rxe_rereg_user_mr(struct ib_mr *ibmr, int flags,
 	if (err)
 		return ERR_PTR(err);
 
+	if ((flags & IB_MR_REREG_ACCESS) &&
+	    ((access ^ mr->access) & IB_ACCESS_ON_DEMAND)) {
+		rxe_err_mr(mr, "cannot change IB_ACCESS_ON_DEMAND\n");
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
 	if (flags & IB_MR_REREG_PD) {
 		rxe_put(old_pd);
 		rxe_get(pd);

-- 
2.55.0


