Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFCD3E7173;
	Sun, 13 Sep 2026 11:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789300005; cv=none; b=V8H7sUfqFoxY3XTZHGyHdlCX5rVdtlz05Hvl4GEGzaCDoimMB/BQXvd0+4n38Pq4wjvKtfiUuyzbC2RlxSCenD8X2gbq7/xWmu7ZpJ/wMjPARqsJ7K73tWD92Rn+xnMPKtZJhO8itFHLAwGuQShRdhVryHejCakrlbeO26NKUVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789300005; c=relaxed/simple;
	bh=q5TKN32g5tRPa2GMvzux/v2i38wCpGQecf0oQjVNALs=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=VXYD3n21zkld9Pqr0Ds6X7VOtaUQg26t0xmaAaQ+E0YMK+eTGYgN1NkPpLQX4+961Oe2dk2AVJuoh35C4kKguX0Gy+v9J+eB508vnH/e/H6h35eg0iM+GEBxSlf7bnLRs7VKQxHKw26+L4+xiZYv9CjInsCmMVU5Bp+/Dcf2c0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XnE5q1Q+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XnE5q1Q+"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D11C7C2BCC7;
	Sun, 13 Sep 2026 11:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789300004;
	bh=q5TKN32g5tRPa2GMvzux/v2i38wCpGQecf0oQjVNALs=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=XnE5q1Q+eK4/98uEzRwvZfkPpN/SeXvFNPU4t9jgI7Iwy4fTv6U1AeYMjLbLmt2qn
	 B3oe3r+YtTRAKreSLwi8xAda+a1J1deDus9DtTdMh2T6pfuZMYLG6QZWNUNOW4jDGj
	 ntRdmzecgQh651LtHLK1gZrv2cWI88TBS5H0ScX4gXM3RUWEM8t40aO3bc7pRybHtB
	 hdDcMsgLw8r3vi9cG2f8p0WZAw28K3yC396FYwmDziIF/XuSuGzqKGpPssu3c5H4uc
	 5VIvjgyjRB4i8Uxi/+B1tGEBNcrtnXGNEJ3nKThl8xnfJ07ZzVtzJzsCcOscQ95bRR
	 QQl5r+TJ65CjQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A0CC88E64;
	Sun, 13 Sep 2026 11:46:44 +0000 (UTC)
From: Norbert Szetei via B4 Relay <devnull+norbert.doyensec.com@kernel.org>
Subject: [PATCH v2 0/2] RDMA/rxe: fix ADVISE_MR prefetch on non-ODP MRs
Date: Sun, 13 Sep 2026 13:45:14 +0200
Message-Id: <20260913-rxe-advise-mr-v2-v2-0-b806c789871c@doyensec.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXM0QpFUBCF4VfRXJvaRpHzKjoXZhuM4mg2UvLut
 uPyq7X+E4KYSoBPcoLJrkF/cwSlCfihmXtBbaOBHBWuynK0Q7Bp41BwMtwJq5IzR1wyFx7ibTH
 p9Pgn6+/rsPEofn06cF03ttphCXQAAAA=
X-Change-ID: 20260913-rxe-advise-mr-v2-97b102b7bb6c
To: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>, Bob Pearson <rpearsonhpe@gmail.com>, 
 Daisuke Matsuda <dskmtsd@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Zhu Yanjun <yanjun.zhu@linux.dev>, Norbert Szetei <norbert@doyensec.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789300003; l=1834;
 i=norbert@doyensec.com; s=20260913; h=from:subject:message-id;
 bh=q5TKN32g5tRPa2GMvzux/v2i38wCpGQecf0oQjVNALs=;
 b=hYZWDWlFLXaBI0EBj3Qojkc7OJTzdrFVGyn1hLQBFgsM8nyjMZbg769prDM6MvJJzaw7+VGFM
 1pi10Pm4MuBA3qGdFcAnNjy5Tfa9lm6aLX0LzuWnDBtrq/gEOm6fd9l
X-Developer-Key: i=norbert@doyensec.com; a=ed25519;
 pk=c6ZqJ+mhvi5FloJOiMJUcIPPjT7tczbglx5gruwpVi8=
X-Endpoint-Received: by B4 Relay for norbert@doyensec.com/20260913 with
 auth_id=1029
X-Original-From: Norbert Szetei <norbert@doyensec.com>
Reply-To: norbert@doyensec.com

ADVISE_MR prefetch on a plain MR runs to_ib_umem_odp() on a struct
ib_umem, giving a KASAN slab-out-of-bounds read in
ib_umem_odp_map_dma_and_lock() (splat in patch 2).

v1 checked is_odp_mr() after lookup_mr(). Leon asked for lookup_mr() to
do the check itself, off mr->access. That only holds once mr->access
cannot disagree with the umem, so patch 1 stops the two paths that
assign mr->access after registration from touching IB_ACCESS_ON_DEMAND,
and patch 2 passes the flag to lookup_mr() in both prefetch arms.

Patch 1 adds another failure return to rxe_rereg_user_mr(), so it
depends on ae36a5b609ae ("RDMA/rxe: validate access flags before
swapping the MR's PD"), which moved the validation above the
mr->ibmr.pd swap. The series is based on for-rc.

v1 -> v2:
 - patch 1 (new): reject IB_ACCESS_ON_DEMAND in rxe_rereg_user_mr() and
   rxe_reg_fast_mr(), so mr->access keeps agreeing with the umem
 - patch 2: use lookup_mr(..., IB_ACCESS_ON_DEMAND) instead of an
   explicit is_odp_mr() check; a non-ODP MR now fails with -EINVAL from
   lookup_mr() rather than -EOPNOTSUPP
 - dropped Zhu Yanjun's Reviewed-by, the implementation changed

v1: https://lore.kernel.org/all/521D5E74-89E3-43C0-81C7-AC0BE52591E7@doyensec.com/

Signed-off-by: Norbert Szetei <norbert@doyensec.com>
---
Norbert Szetei (2):
      RDMA/rxe: Reject IB_ACCESS_ON_DEMAND changes after MR creation
      RDMA/rxe: Reject prefetch of a non-ODP MR

 drivers/infiniband/sw/rxe/rxe_mr.c    | 6 ++++++
 drivers/infiniband/sw/rxe/rxe_odp.c   | 4 ++--
 drivers/infiniband/sw/rxe/rxe_verbs.c | 6 ++++++
 3 files changed, 14 insertions(+), 2 deletions(-)
---
base-commit: e22a3627b7151754f07f90ea3d1ab6e85f5d93f4
change-id: 20260913-rxe-advise-mr-v2-97b102b7bb6c

Best regards,
--  
Norbert Szetei <norbert@doyensec.com>


