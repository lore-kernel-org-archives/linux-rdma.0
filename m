Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C4CDF55
	for <linux-rdma@vger.kernel.org>; Sun, 28 Jan 2024 09:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706434183; cv=none; b=MrYIGb+6tyyve8d9l/xACVJCahPAfj6rID8q8fBjZ9OeTRRKoctCtDuTEqvCIB6fTeXXaJEDaZ67aAW3MvHHHJIuu4UUSLEQh7+uZkvLNXJy0z+jKPwvgf/G3nCsgRXClpH6bw0BZtakwGPOhikbUFqONivHMyJxgY9Yt51RpWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706434183; c=relaxed/simple;
	bh=fsSyFsrNbo6EiIE62IXY4cpWicxhAgpRh2bFIatxf+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLKcXCreKOcrNCPDkTtxF/Rb++tU4yOYievpYEicV0fNSrkiAOc6gcqalYZNxkC0Sr0khI7xbvCOTludRyVtdyCyqsuYr1tHlGbvTSlbl/6AINE1TMyEeWEvls8GAmP414YOdIQ9dusWe3RO19JX5z/FVA/pkp6cYJFpE+pNNxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+u2MmRx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+u2MmRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEFCC433C7;
	Sun, 28 Jan 2024 09:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706434183;
	bh=fsSyFsrNbo6EiIE62IXY4cpWicxhAgpRh2bFIatxf+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a+u2MmRxwSaE7SU7owHAkB75OKL/8m8BZ0LRw2uTK/Scl92xNTHUuyEiVnAHpNkR0
	 8tPyLbVbJiQs2i+0tsVAZM4H54fUZz2sCNS4JHoFF68WK+0A0bTjMUClOA2v9ky+Sw
	 DCi9hV6AcSXveCzY2mvw8Ee+fuARvKZpUtMa5SGkgLVDu1XsGnOj4MQC46SJRL8KGm
	 zn3NDAeGUSh3GQRzf3LZXEHyY/9mEZQVlPG/MhHuAB3y0yizH5lQfCKgciZ51u2E7B
	 cAs80fLlQTHL0EpFTuaJVzp7mAHyiUBb+Wj1PC85osJ1cEOEZflHj97s7a4BioWc83
	 rbbpqy3v7koDA==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Or Har-Toov <ohartoov@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	linux-rdma@vger.kernel.org,
	Maor Gottlieb <maorg@nvidia.com>,
	Mark Zhang <markzhang@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Tamar Mashiah <tmashiah@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH rdma-next v1 5/6] RDMA/mlx5: Change check for cacheable user mkeys
Date: Sun, 28 Jan 2024 11:29:15 +0200
Message-ID: <20dc8ea1c606351b0491240d857977f724084345.1706433934.git.leon@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1706433934.git.leon@kernel.org>
References: <cover.1706433934.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Or Har-Toov <ohartoov@nvidia.com>

In the dereg flow, UMEM is not a good enough indication whether an MR
is from userspace since in mlx5_ib_rereg_user_mr there are some cases
when a new MR is created and the UMEM of the old MR is set to NULL.
Currently when mlx5_ib_dereg_mr is called on the old MR, UMEM is NULL
but cache_ent can be different than NULL. So, the mkey will not be
destroyed.
Therefore checking if mkey is from user application and cacheable
should be done by checking if rb_key or cache_ent exist and all other kind of
mkeys should be destroyed.

Fixes: dd1b913fb0d0 ("RDMA/mlx5: Cache all user cacheable mkeys on dereg MR flow")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mr.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 12bca6ca4760..87552a689e07 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1857,6 +1857,11 @@ static int cache_ent_find_and_store(struct mlx5_ib_dev *dev,
 	return ret;
 }
 
+static bool is_cacheable_mkey(struct mlx5_ib_mkey *mkey)
+{
+	return mkey->cache_ent || mkey->rb_key.ndescs;
+}
+
 int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 {
 	struct mlx5_ib_mr *mr = to_mmr(ibmr);
@@ -1901,12 +1906,6 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 		mr->sig = NULL;
 	}
 
-	/* Stop DMA */
-	if (mr->umem && mlx5r_umr_can_load_pas(dev, mr->umem->length))
-		if (mlx5r_umr_revoke_mr(mr) ||
-		    cache_ent_find_and_store(dev, mr))
-			mr->mmkey.cache_ent = NULL;
-
 	if (mr->umem && mr->umem->is_peer) {
 		rc = mlx5r_umr_revoke_mr(mr);
 		if (rc)
@@ -1914,7 +1913,9 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 		ib_umem_stop_invalidation_notifier(mr->umem);
 	}
 
-	if (!mr->mmkey.cache_ent) {
+	/* Stop DMA */
+	if (!is_cacheable_mkey(&mr->mmkey) || mlx5r_umr_revoke_mr(mr) ||
+	    cache_ent_find_and_store(dev, mr)) {
 		rc = destroy_mkey(to_mdev(mr->ibmr.device), mr);
 		if (rc)
 			return rc;
-- 
2.43.0

