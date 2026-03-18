Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC71F38E5C6;
	Wed, 18 Mar 2026 10:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773828174; cv=none; b=G2WiXw895NxjSQUHLSjGalyl/rc22VZdvPrBAAdo5PDoBX09LduAOaO/RXY90BFJCxlAQUgzhV70xrfCXuekSsb30e4RBX0I3auzY1YkXan5943v3LhyDlE13Lhpn1OoSTMl/rBmmQNiaOXI6OCpkK6/XsYeItpN7Mp+umUsdo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773828174; c=relaxed/simple;
	bh=IRsLprM8YhjSl7rr5EaIUZHnYerzJnEM5WNKqlHAi+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nmgc/5IRKcxfFA1Mm1SMdARir10Wi3vhZx55tOqNj5wiWiKghZ1RbPsMuii2GmNEmLqxjJyhxh41k3Cg0GdSiWGQgaWMJFGAPrGFB0V7db62y+5DUqAzftTNI7Yx8jQptV1U6rr/w6gAIqirFXpnUssvd92D9KS1RTHJixyubKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SpBum4gD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SpBum4gD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4CAC19424;
	Wed, 18 Mar 2026 10:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773828174;
	bh=IRsLprM8YhjSl7rr5EaIUZHnYerzJnEM5WNKqlHAi+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpBum4gDwXdQYsTJRfACp5jI7/wXjdNmpk3agNogl9Q5CxhhU7jdgcI2zP/Zexe/z
	 24pm85XNybTb0G+Oaw+CQupugvoB9znzxI1k6wrQjQTTczQD3NT4Qc78TwNGJuxMiw
	 UbLzmoQfZfYX/mvi1QyDxY+nUHtizGZTTx+JFEWfyr+U2GFucXcFzZ+T+JWSV0bCZd
	 WtyqN8on+7g/O48afkiIduDOyhDw944VVOQz471XVIGAztekyziCPAs0CsBGtVhMxO
	 k1fWehj2xGcVlWOgRkfJEJLsHAO6f1dI1LVybf6GGQaw2h62N0aYmhSjdUbT03yIAw
	 ds+1qr5kB+LZA==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Krzysztof Czurylo <krzysztof.czurylo@intel.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next 1/2] RDMA/core: Remove unused ib_resize_cq() implementation
Date: Wed, 18 Mar 2026 12:02:36 +0200
Message-ID: <20260318-resize_cq-type-v1-1-b2846ed18846@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260318-resize_cq-type-v1-0-b2846ed18846@nvidia.com>
References: <20260318-resize_cq-type-v1-0-b2846ed18846@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

There are no in-kernel users of the CQ resize functionality, so drop it.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/verbs.c | 10 ----------
 include/rdma/ib_verbs.h         |  9 ---------
 2 files changed, 19 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 721cd43212380..bac87de9cc673 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2264,16 +2264,6 @@ int ib_destroy_cq_user(struct ib_cq *cq, struct ib_udata *udata)
 }
 EXPORT_SYMBOL(ib_destroy_cq_user);
 
-int ib_resize_cq(struct ib_cq *cq, int cqe)
-{
-	if (cq->shared)
-		return -EOPNOTSUPP;
-
-	return cq->device->ops.resize_cq ?
-		cq->device->ops.resize_cq(cq, cqe, NULL) : -EOPNOTSUPP;
-}
-EXPORT_SYMBOL(ib_resize_cq);
-
 /* Memory regions */
 
 struct ib_mr *ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 57b81ca0fabdc..37260d37144c5 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -4103,15 +4103,6 @@ struct ib_cq *__ib_create_cq(struct ib_device *device,
 #define ib_create_cq(device, cmp_hndlr, evt_hndlr, cq_ctxt, cq_attr) \
 	__ib_create_cq((device), (cmp_hndlr), (evt_hndlr), (cq_ctxt), (cq_attr), KBUILD_MODNAME)
 
-/**
- * ib_resize_cq - Modifies the capacity of the CQ.
- * @cq: The CQ to resize.
- * @cqe: The minimum size of the CQ.
- *
- * Users can examine the cq structure to determine the actual CQ size.
- */
-int ib_resize_cq(struct ib_cq *cq, int cqe);
-
 /**
  * rdma_set_cq_moderation - Modifies moderation params of the CQ
  * @cq: The CQ to modify.

-- 
2.53.0

