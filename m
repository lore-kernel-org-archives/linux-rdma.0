From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 3/3] IB/mlx5: Expose dump and fill memory key
Date: Tue, 19 Jun 2018 08:47:24 +0300
Message-ID: <20180619054724.32677-4-leon@kernel.org>
References: <20180619054724.32677-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180619054724.32677-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yonatan Cohen <yonatanc@mellanox.com>

MLX5 IB HCA offers the memory key, dump_fill_mkey to boost
performance, when used in a send or receive operations.

It is used to force local HCA operations to skip the PCI bus access,
while keeping track of the processed length in the ibv_sge handling.

Meaning, instead of a PCI write access the HCA leaves the target
memory untouched, and skips filling that packet section. Similar
behavior is done upon send, the HCA skips data in memory relevant
to this key and saves PCI bus access.

This functionality saves PCI read/write operations.

Signed-off-by: Yonatan Cohen <yonatanc@mellanox.com>
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Guy Levi <guyle@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 16 +++++++++++++++-
 include/uapi/rdma/mlx5-abi.h      |  3 ++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c29c7c838980..97113957398d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1634,6 +1634,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	int err;
 	size_t min_req_v2 = offsetof(struct mlx5_ib_alloc_ucontext_req_v2,
 				     max_cqe_version);
+	u32 dump_fill_mkey;
 	bool lib_uar_4k;
 
 	if (!dev->ib_active)
@@ -1743,8 +1744,12 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 		}
 
 		err = mlx5_ib_devx_create(dev, context);
+	}
+
+	if (MLX5_CAP_GEN(dev->mdev, dump_fill_mkey)) {
+		err = mlx5_cmd_dump_fill_mkey(dev->mdev, &dump_fill_mkey);
 		if (err)
-			goto out_td;
+			goto out_mdev;
 	}
 
 	INIT_LIST_HEAD(&context->vma_private_list);
@@ -1805,6 +1810,15 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 		resp.response_length += sizeof(resp.num_dyn_bfregs);
 	}
 
+	if (field_avail(typeof(resp), dump_fill_mkey, udata->outlen)) {
+		if (MLX5_CAP_GEN(dev->mdev, dump_fill_mkey)) {
+			resp.dump_fill_mkey = dump_fill_mkey;
+			resp.comp_mask |=
+				MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_DUMP_FILL_MKEY;
+		}
+		resp.response_length += sizeof(resp.dump_fill_mkey);
+	}
+
 	err = ib_copy_to_udata(udata, &resp, resp.response_length);
 	if (err)
 		goto out_mdev;
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 5d591ff28139..addbb9c4529e 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -93,6 +93,7 @@ struct mlx5_ib_alloc_ucontext_req_v2 {
 
 enum mlx5_ib_alloc_ucontext_resp_mask {
 	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_CORE_CLOCK_OFFSET = 1UL << 0,
+	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_DUMP_FILL_MKEY    = 1UL << 1,
 };
 
 enum mlx5_user_cmds_supp_uhw {
@@ -141,7 +142,7 @@ struct mlx5_ib_alloc_ucontext_resp {
 	__u32	log_uar_size;
 	__u32	num_uars_per_page;
 	__u32	num_dyn_bfregs;
-	__u32	reserved3;
+	__u32	dump_fill_mkey;
 };
 
 struct mlx5_ib_alloc_pd_resp {
-- 
2.14.4
