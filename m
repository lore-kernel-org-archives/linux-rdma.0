Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0EE3E7BD5;
	Sun, 13 Sep 2026 11:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789300005; cv=none; b=uSW+VW8ntZLDpWkOIp24fzhNE1QQAAXL0V8FQXJ2Qwm5A2TJPe9ZI27+Q4c1q7d2/zL2a7C9jF/KpnJXoK9pNGyki7QSnZ9sv/QS4fYYYq6aBgq0ogv4SiHigsa75LqDq+BZw48Wn4BWd9jOtNu+S0JgdC610voI6trx/2EBpQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789300005; c=relaxed/simple;
	bh=CqYYHW4l1JlDjn2xvr7d2wLhP8wZxZdVDXt6R3/p8ps=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MmQ/ERhE7jEP73p9dvazOBDlioxsHl03z9wAvaS339mgLPLnRH/HDBY6uUYeZrtreHx9BbUBAktn1UfpC8iChaPhUEO+O2hbsYQgrh3JlMVoH85YcgULfdTdWw4qffXiwoNPZmYxj46mCvqkXBIBtKj3G/5bTYYm17PtAfcnn/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lYtSC6Le; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lYtSC6Le"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7718C2BCF6;
	Sun, 13 Sep 2026 11:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789300004;
	bh=CqYYHW4l1JlDjn2xvr7d2wLhP8wZxZdVDXt6R3/p8ps=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=lYtSC6LeUtM/ocnLovWhhyFfQIyh7onbXwDFsfjKII3sfxSa2TmQKy23vnCLDWFNS
	 ytHxibCHJiepD5xW3UcBGK7ESu1PdMzAAofSBKsmGC/jovTEqkS4s9f6IjAOM9JUSV
	 rUD6daZW7StEuxy/mEzAq+ZtEG62F1YNOv74/LJ26A109VqnA8vCP9vnil7WzkbUEb
	 pGxc072BhY6rtfUzDJ0dInA/DuPiq8ywnC3lifSCC4SCPBz08H2+Kb5vjQwFbfAb1l
	 eWHvFVXl4TebGS0Cx0q1PNu/zrY09Z12dFJSgmlyiQjSEjPKfNW2YdOodeolPX7MzS
	 8Zmf1hrRPU6Vg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B83F7C88E5A;
	Sun, 13 Sep 2026 11:46:44 +0000 (UTC)
From: Norbert Szetei via B4 Relay <devnull+norbert.doyensec.com@kernel.org>
Date: Sun, 13 Sep 2026 13:45:15 +0200
Subject: [PATCH v2 1/2] RDMA/rxe: Reject IB_ACCESS_ON_DEMAND changes after
 MR creation
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-rxe-advise-mr-v2-v2-1-b806c789871c@doyensec.com>
References: <20260913-rxe-advise-mr-v2-v2-0-b806c789871c@doyensec.com>
In-Reply-To: <20260913-rxe-advise-mr-v2-v2-0-b806c789871c@doyensec.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>, Bob Pearson <rpearsonhpe@gmail.com>, 
 Daisuke Matsuda <dskmtsd@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Zhu Yanjun <yanjun.zhu@linux.dev>, Norbert Szetei <norbert@doyensec.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789300003; l=2511;
 i=norbert@doyensec.com; s=20260913; h=from:subject:message-id;
 bh=WfQ+zWkXJa3zyWUSkxo61iXUBwiw4y7RVv8+6skS7S8=;
 b=uCGIqDGe7VX55U16C43zCc8eXH7mDUR8/6keThP82xn2mfG1r/FnfNMF/OysI2ZUIaNEY1vSG
 L/bV/auc0P1A7o6y6pK0qJgO4gH6M9LIaGAE9pKqm63i6961qBc7hS4
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
index 71d9ea477289..615da4bb9a38 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -796,6 +796,12 @@ int rxe_reg_fast_mr(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
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
index 3864284522eb..46d0810ea2a7 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1337,6 +1337,12 @@ static struct ib_mr *rxe_rereg_user_mr(struct ib_mr *ibmr, int flags,
 		return ERR_PTR(-EOPNOTSUPP);
 	}
 
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


