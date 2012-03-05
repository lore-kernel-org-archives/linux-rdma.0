From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH/RFC] mxl4_core: Scale size of MTT table with system RAM
Date: Mon,  5 Mar 2012 10:09:31 -0800
Message-ID: <1330970972-10225-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

The current driver defaults to 1M MTT segments, where each segment holds
8 MTT entries.  This limits the total memory registered to 8M * PAGE_SIZE
which is 32GB with 4K pages.  Since systems that have much more memory
are pretty common now (at least among systems with InfiniBand hardware),
this limit ends up getting hit in practice quite a bit.

Handle this by having the driver allocate at least enough MTT entries to
cover 2 * totalram pages.

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
Albert, if you could try this on one of your 192GB systems and see if
you still are able to register enough memory, that would be great.

(Of course please remove any local hacks you have to work around the
problem in any other way.  And actually I'd be curious to know how
much you're bumping up num_mtt and/or log_mtts_per_seg to use 192GB
right now ... I'd like to validate the (2*totalram) heuristic)

Thanks!

 drivers/net/ethernet/mellanox/mlx4/mlx4.h    |    2 +-
 drivers/net/ethernet/mellanox/mlx4/profile.c |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index c92269f..c846152 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -399,7 +399,7 @@ struct mlx4_profile {
 	int			num_cq;
 	int			num_mcg;
 	int			num_mpt;
-	int			num_mtt;
+	unsigned		num_mtt;
 };
 
 struct mlx4_fw {
diff --git a/drivers/net/ethernet/mellanox/mlx4/profile.c b/drivers/net/ethernet/mellanox/mlx4/profile.c
index 1129677..06e5ade 100644
--- a/drivers/net/ethernet/mellanox/mlx4/profile.c
+++ b/drivers/net/ethernet/mellanox/mlx4/profile.c
@@ -83,12 +83,31 @@ u64 mlx4_make_profile(struct mlx4_dev *dev,
 	u64 total_size = 0;
 	struct mlx4_resource *profile;
 	struct mlx4_resource tmp;
+	struct sysinfo si;
 	int i, j;
 
 	profile = kcalloc(MLX4_RES_NUM, sizeof(*profile), GFP_KERNEL);
 	if (!profile)
 		return -ENOMEM;
 
+	/*
+	 * We want to scale the number of MTTs with the size of the
+	 * system memory, since it makes sense to register a lot of
+	 * memory on a system with a lot of memory.  As a heuristic,
+	 * make sure we have enough MTTs to cover twice the system
+	 * memory (with PAGE_SIZE entries).
+	 *
+	 * This number has to be a power of two and fit into 32 bits
+	 * due to device limitations, so cap this at 2^31 as well.
+	 * That limits us to 8TB of memory registration per HCA with
+	 * 4KB pages, which is probably OK for the next few months.
+	 */
+	si_meminfo(&si);
+	request->num_mtt =
+		roundup_pow_of_two(max_t(unsigned, request->num_mtt,
+					 min(1UL << 31,
+					     si.totalram >> (log_mtts_per_seg - 1))));
+
 	profile[MLX4_RES_QP].size     = dev_cap->qpc_entry_sz;
 	profile[MLX4_RES_RDMARC].size = dev_cap->rdmarc_entry_sz;
 	profile[MLX4_RES_ALTC].size   = dev_cap->altc_entry_sz;
-- 
1.7.9

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
