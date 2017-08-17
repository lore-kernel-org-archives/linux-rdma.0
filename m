From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 5/8] IB/mlx5: Fix integer overflow when page_shift == 31
Date: Thu, 17 Aug 2017 15:52:32 +0300
Message-ID: <20170817125235.5107-6-leon@kernel.org>
References: <20170817125235.5107-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817125235.5107-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Fix a bug where MR registration fails when mlx5_ib_cont_pages
indicates that the MR can be mapped using 2GB pages (page_shift == 31).

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 8cf53eb13148..0e2789d9bb4d 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -808,13 +808,14 @@ struct ib_mr *mlx5_ib_get_dma_mr(struct ib_pd *pd, int acc)
 	return ERR_PTR(err);
 }
 
-static int get_octo_len(u64 addr, u64 len, int page_size)
+static int get_octo_len(u64 addr, u64 len, int page_shift)
 {
+	u64 page_size = 1ULL << page_shift;
 	u64 offset;
 	int npages;
 
 	offset = addr & (page_size - 1);
-	npages = ALIGN(len + offset, page_size) >> ilog2(page_size);
+	npages = ALIGN(len + offset, page_size) >> page_shift;
 	return (npages + 1) / 2;
 }
 
@@ -1147,12 +1148,12 @@ static struct mlx5_ib_mr *reg_create(struct ib_mr *ibmr, struct ib_pd *pd,
 	MLX5_SET(mkc, mkc, pd, to_mpd(pd)->pdn);
 	MLX5_SET(mkc, mkc, bsf_octword_size, 0);
 	MLX5_SET(mkc, mkc, translations_octword_size,
-		 get_octo_len(virt_addr, length, 1 << page_shift));
+		 get_octo_len(virt_addr, length, page_shift));
 	MLX5_SET(mkc, mkc, log_page_size, page_shift);
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 	if (populate) {
 		MLX5_SET(create_mkey_in, in, translations_octword_actual_size,
-			 get_octo_len(virt_addr, length, 1 << page_shift));
+			 get_octo_len(virt_addr, length, page_shift));
 	}
 
 	err = mlx5_core_create_mkey(dev->mdev, &mr->mmkey, in, inlen);
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
