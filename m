From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 0/5] Cleanup of
 CONFIG_INFINIBAND_ON_DEMAND_PAGING usage
Date: Thu, 20 Dec 2018 20:32:35 -0700
Message-ID: <20181221033235.GA771@ziepe.ca>
References: <20181220092318.32672-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181220092318.32672-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Haggai Eran <haggaie@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 20, 2018 at 11:23:13AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Hi,
> 
> As a followup to Jason's request to rethink CONFIG_INFINIBAND_ON_DEMAND_PAGING
> usage, this series cleans mlx5_ib and RDMA/core code and it is based on already
> sent but not yet accepted patch https://patchwork.kernel.org/patch/10735547/
> 
> It is under extensive testing now, but I wanted to raise awareness as soon
> as possible for the patch "RDMA/core: Don't depend device ODP capabilities
> on kconfig option", which changes behavior for mlx5 devices with
> CONFIG_INFINIBAND_ON_DEMAND_PAGING set to no.
> 
> Thanks
> 
> Leon Romanovsky (5):
>   RDMA: Clean structures from CONFIG_INFINIBAND_ON_DEMAND_PAGING
>   RDMA/core: Don't depend device ODP capabilities on kconfig option
>   RDMA/mlx5: Introduce and reuse helper to identify ODP MR
>   RDMA/mlx5: Embed into the code flow the ODP config option
>   RDMA/mlx5: Delete declaration of already removed function

I'm imagining something like this integrated into these patches, what
do you think?

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index c6144df47ea47e..c2615b6bb68841 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -95,6 +95,9 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	struct scatterlist *sg, *sg_list_start;
 	unsigned int gup_flags = FOLL_WRITE;
 
+	if ((access & IB_ACCESS_ON_DEMAND) && !context->invalidate_range)
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (dmasync)
 		dma_attrs |= DMA_ATTR_WRITE_BARRIER;
 
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 4d28db23f53955..241376bae09540 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -236,8 +236,7 @@ static int ib_uverbs_get_context(struct uverbs_attr_bundle *attrs)
 
 	mutex_init(&ucontext->per_mm_list_lock);
 	INIT_LIST_HEAD(&ucontext->per_mm_list);
-	if (!IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING) ||
-	    !(ib_dev->attrs.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING))
+	if (!(ib_dev->attrs.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING))
 		ucontext->invalidate_range = NULL;
 
 	resp.num_comp_vectors = file->device->num_comp_vectors;
@@ -3607,13 +3606,15 @@ static int ib_uverbs_ex_query_device(struct uverbs_attr_bundle *attrs)
 
 	copy_query_dev_fields(ucontext, &resp.base, &attr);
 
-	resp.odp_caps.general_caps = attr.odp_caps.general_caps;
-	resp.odp_caps.per_transport_caps.rc_odp_caps =
-		attr.odp_caps.per_transport_caps.rc_odp_caps;
-	resp.odp_caps.per_transport_caps.uc_odp_caps =
-		attr.odp_caps.per_transport_caps.uc_odp_caps;
-	resp.odp_caps.per_transport_caps.ud_odp_caps =
-		attr.odp_caps.per_transport_caps.ud_odp_caps;
+	if (ib_dev->attrs.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING) {
+		resp.odp_caps.general_caps = attr.odp_caps.general_caps;
+		resp.odp_caps.per_transport_caps.rc_odp_caps =
+			attr.odp_caps.per_transport_caps.rc_odp_caps;
+		resp.odp_caps.per_transport_caps.uc_odp_caps =
+			attr.odp_caps.per_transport_caps.uc_odp_caps;
+		resp.odp_caps.per_transport_caps.ud_odp_caps =
+			attr.odp_caps.per_transport_caps.ud_odp_caps;
+	}
 
 	resp.timestamp_mask = attr.timestamp_mask;
 	resp.hca_core_clock = attr.hca_core_clock;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index ff131e4c874ec5..df8366fb0142d6 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -923,9 +923,11 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->hca_core_clock = MLX5_CAP_GEN(mdev, device_frequency_khz);
 	props->timestamp_mask = 0x7FFFFFFFFFFFFFFFULL;
 
-	if (MLX5_CAP_GEN(mdev, pg))
-		props->device_cap_flags |= IB_DEVICE_ON_DEMAND_PAGING;
-	props->odp_caps = dev->odp_caps;
+	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)) {
+		if (MLX5_CAP_GEN(mdev, pg))
+			props->device_cap_flags |= IB_DEVICE_ON_DEMAND_PAGING;
+		props->odp_caps = dev->odp_caps;
+	}
 
 	if (MLX5_CAP_GEN(mdev, cd))
 		props->device_cap_flags |= IB_DEVICE_CROSS_CHANNEL;
@@ -1761,7 +1763,8 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	if (err)
 		goto out_sys_pages;
 
-	context->ibucontext.invalidate_range = &mlx5_ib_invalidate_range;
+	if (ibdev->attrs.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING)
+		context->ibucontext.invalidate_range = &mlx5_ib_invalidate_range;
 
 	if (req.flags & MLX5_IB_ALLOC_UCTX_DEVX) {
 		err = mlx5_ib_devx_create(dev, true);
diff --git a/drivers/infiniband/hw/mlx5/mem.c b/drivers/infiniband/hw/mlx5/mem.c
index 9f90be296ee0f7..22827ba4b6d8eb 100644
--- a/drivers/infiniband/hw/mlx5/mem.c
+++ b/drivers/infiniband/hw/mlx5/mem.c
@@ -150,7 +150,7 @@ void __mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 	struct scatterlist *sg;
 	int entry;
 
-	if (umem->is_odp) {
+	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING) && umem->is_odp) {
 		WARN_ON(shift != 0);
 		WARN_ON(access_flags != (MLX5_IB_MTT_READ | MLX5_IB_MTT_WRITE));
 
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 65d07c111d42a7..8183e94da5a1ea 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1332,12 +1332,14 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	mlx5_ib_dbg(dev, "start 0x%llx, virt_addr 0x%llx, length 0x%llx, access_flags 0x%x\n",
 		    start, virt_addr, length, access_flags);
 
-	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING) && !start &&
-	    length == U64_MAX) {
+	if (!start && length == U64_MAX) {
 		if (!(access_flags & IB_ACCESS_ON_DEMAND) ||
 		    !(dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
 			return ERR_PTR(-EINVAL);
 
+		if (!IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING))
+			return ERR_PTR(-EOPNOTSUPP);
+
 		mr = mlx5_ib_alloc_implicit_mr(to_mpd(pd), access_flags);
 		if (IS_ERR(mr))
 			return ERR_CAST(mr);
