Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7197236E467;
	Mon, 13 Jul 2026 07:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783927052; cv=none; b=lDCFWksf5bl7eErELXj1fQYAPqkC2dfTKCam086YNuJJVQER6LElQnP3yS8aNzCVsPZuiceruby8KzHWTPTSRL1oN8JZWSFaH8/n3jgYIAFympcwytsYujzXPyBG+0ElmXqBnqoOuY2D/LB7Zbi5bLb63F1j9jXEqCOFDh1Q6zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783927052; c=relaxed/simple;
	bh=SXrz9gchSpYbNkqOo4zo2EfPrNrBLWlpKsoescdSehw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lPVWyn4wI0oon2IFDdxpA/BsIgMmZD5rMeZv5o4YwUTkvzTZE3CM57BWB9CkV4QNh9ys8s4bNz9zXAkGZx57mFa4o6u0uPSQlI0cFiGOB8Wn+pNLfGzuAlpSabv2LXHnNVWYQ150SRlSAso9ISzLTPNtNBW209GE2G++smAIL6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ejTfvo5h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ejTfvo5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B741F00A3D;
	Mon, 13 Jul 2026 07:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783927051;
	bh=B1vEwrB73ps6zpLh3UcDtCf1sAnjTUd+qckbQEIzKaA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ejTfvo5hBO6cSEnRbHpIIW/r22KHDES61igHJDW9ZcPA2O0kGD7LJzCU75DARdwwL
	 2KKztVnHkqEkPpICH2r2dv+eK3rNrm0XuDve2vTjNlSgsJELEkgk/xYMTkSOhSpz3i
	 nwmH/Wa5cahWTKWCT3+NHbM+diM2aQ4m7SeDyyvui0u4QVHGU6x83GxgNbMC1LsShl
	 BZ43fDIe1DCtUQEKZQS/ryg1QvTEwQ9YXzh4WqiUgQUglFJ8WQeF6Zp9J4OxS2TWU9
	 K3S+ormK2fzUIr5b7aGnjP8909gAZjCenA7vvD2vHLiBYLNbFGCqcjK/Ua2u5QmNIt
	 6xwFaVqslyccw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 13 Jul 2026 10:17:23 +0300
Subject: [PATCH v2 2/5] RDMA/mlx5: replace __get_free_page() with kmalloc()
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-b4-rdma-v2-2-65d2a1a5180c@kernel.org>
References: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
In-Reply-To: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-rdma@vger.kernel.org
X-Mailer: b4 0.16-dev

mlx5_ib_mr_wqe_pfault_handler() allocates a scratch buffer for
parsing work queue entries during page fault handling.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 1badec9bf527..b8618610737a 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -37,6 +37,7 @@
 #include <linux/hmm.h>
 #include <linux/hmm-dma.h>
 #include <linux/pci-p2pdma.h>
+#include <linux/slab.h>
 
 #include "mlx5_ib.h"
 #include "cmd.h"
@@ -1414,7 +1415,8 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 		goto resolve_page_fault;
 	}
 
-	wqe_start = (void *)__get_free_page(GFP_KERNEL);
+	/* TODO: switch to "fast and as large as possible" allocation helper */
+	wqe_start = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!wqe_start) {
 		mlx5_ib_err(dev, "Error allocating memory for IO page fault handling.\n");
 		goto resolve_page_fault;
@@ -1475,7 +1477,7 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 		    pfault->wqe.wq_num, resume_with_error,
 		    pfault->type);
 	mlx5_core_res_put(res);
-	free_page((unsigned long)wqe_start);
+	kfree(wqe_start);
 }
 
 static void mlx5_ib_mr_rdma_pfault_handler(struct mlx5_ib_dev *dev,

-- 
2.53.0

