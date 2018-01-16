From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/2] IB/mlx5: Mmap the HCA's clock info to user-space
Date: Tue, 16 Jan 2018 20:08:41 +0200
Message-ID: <20180116180841.18976-3-leon@kernel.org>
References: <20180116180841.18976-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180116180841.18976-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eitan Rabin <rabin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch maps the new page to user space applications to
allow converting a user space completion timestamp to system wall
time at the lowest possible latency cost.
By using a versioning scheme we allow compatibility between current
and future userspace libraries.
The change moves mlx5_ib_mmap_cmd enum from mlx5_ib.h to the
abi header file mlx5-abi.h.

Reviewed-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eitan Rabin <rabin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 44 ++++++++++++++++++++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 10 --------
 include/uapi/rdma/mlx5-abi.h         | 18 ++++++++++++++-
 3 files changed, 59 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 5d6fba986fa5..f83ae1a7844b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1579,6 +1579,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	struct mlx5_ib_alloc_ucontext_req_v2 req = {};
 	struct mlx5_ib_alloc_ucontext_resp resp = {};
+	struct mlx5_core_dev *mdev = dev->mdev;
 	struct mlx5_ib_ucontext *context;
 	struct mlx5_bfreg_info *bfregi;
 	int ver;
@@ -1706,6 +1707,12 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 		resp.response_length += sizeof(resp.eth_min_inline);
 	}
 
+	if (field_avail(typeof(resp), clock_info_versions, udata->outlen)) {
+		if (mdev->clock_info)
+			resp.clock_info_versions = BIT(MLX5_IB_CLOCK_INFO_V1);
+		resp.response_length += sizeof(resp.clock_info_versions);
+	}
+
 	/*
 	 * We don't want to expose information from the PCI bar that is located
 	 * after 4096 bytes, so if the arch only supports larger pages, let's
@@ -1719,8 +1726,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 			resp.hca_core_clock_offset =
 				offsetof(struct mlx5_init_seg, internal_timer_h) % PAGE_SIZE;
 		}
-		resp.response_length += sizeof(resp.hca_core_clock_offset) +
-					sizeof(resp.reserved2);
+		resp.response_length += sizeof(resp.hca_core_clock_offset);
 	}
 
 	if (field_avail(typeof(resp), log_uar_size, udata->outlen))
@@ -1959,6 +1965,38 @@ static inline char *mmap_cmd2str(enum mlx5_ib_mmap_cmd cmd)
 	}
 }
 
+static int mlx5_ib_mmap_clock_info_page(struct mlx5_ib_dev *dev,
+					struct vm_area_struct *vma,
+					struct mlx5_ib_ucontext *context)
+{
+	phys_addr_t pfn;
+	int err;
+
+	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
+		return -EINVAL;
+
+	if (get_index(vma->vm_pgoff) != MLX5_IB_CLOCK_INFO_V1)
+		return -EOPNOTSUPP;
+
+	if (vma->vm_flags & VM_WRITE)
+		return -EPERM;
+
+	if (!dev->mdev->clock_info_page)
+		return -EOPNOTSUPP;
+
+	pfn = page_to_pfn(dev->mdev->clock_info_page);
+	err = remap_pfn_range(vma, vma->vm_start, pfn, PAGE_SIZE,
+			      vma->vm_page_prot);
+	if (err)
+		return err;
+
+	mlx5_ib_dbg(dev, "mapped clock info at 0x%lx, PA 0x%llx\n",
+		    vma->vm_start,
+		    (unsigned long long)pfn << PAGE_SHIFT);
+
+	return mlx5_ib_set_vma_data(vma, context);
+}
+
 static int uar_mmap(struct mlx5_ib_dev *dev, enum mlx5_ib_mmap_cmd cmd,
 		    struct vm_area_struct *vma,
 		    struct mlx5_ib_ucontext *context)
@@ -2121,6 +2159,8 @@ static int mlx5_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vm
 			    vma->vm_start,
 			    (unsigned long long)pfn << PAGE_SHIFT);
 		break;
+	case MLX5_IB_MMAP_CLOCK_INFO:
+		return mlx5_ib_mmap_clock_info_page(dev, vma, context);
 
 	default:
 		return -EINVAL;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 51228dfcfbe7..69a80f7512f0 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -70,16 +70,6 @@ enum {
 	MLX5_IB_MMAP_CMD_MASK	= 0xff,
 };
 
-enum mlx5_ib_mmap_cmd {
-	MLX5_IB_MMAP_REGULAR_PAGE		= 0,
-	MLX5_IB_MMAP_GET_CONTIGUOUS_PAGES	= 1,
-	MLX5_IB_MMAP_WC_PAGE			= 2,
-	MLX5_IB_MMAP_NC_PAGE			= 3,
-	/* 5 is chosen in order to be compatible with old versions of libmlx5 */
-	MLX5_IB_MMAP_CORE_CLOCK			= 5,
-	MLX5_IB_MMAP_ALLOC_WC			= 6,
-};
-
 enum {
 	MLX5_RES_SCAT_DATA32_CQE	= 0x1,
 	MLX5_RES_SCAT_DATA64_CQE	= 0x2,
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 0299deed71a2..1111aa4e7c1e 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -124,7 +124,7 @@ struct mlx5_ib_alloc_ucontext_resp {
 	__u8	cqe_version;
 	__u8	cmds_supp_uhw;
 	__u8	eth_min_inline;
-	__u8	reserved2;
+	__u8	clock_info_versions;
 	__u64	hca_core_clock_offset;
 	__u32	log_uar_size;
 	__u32	num_uars_per_page;
@@ -394,7 +394,23 @@ struct mlx5_ib_clock_info {
 	__u64 overflow_period;
 };
 
+enum mlx5_ib_mmap_cmd {
+	MLX5_IB_MMAP_REGULAR_PAGE               = 0,
+	MLX5_IB_MMAP_GET_CONTIGUOUS_PAGES       = 1,
+	MLX5_IB_MMAP_WC_PAGE                    = 2,
+	MLX5_IB_MMAP_NC_PAGE                    = 3,
+	/* 5 is chosen in order to be compatible with old versions of libmlx5 */
+	MLX5_IB_MMAP_CORE_CLOCK                 = 5,
+	MLX5_IB_MMAP_ALLOC_WC                   = 6,
+	MLX5_IB_MMAP_CLOCK_INFO                 = 7,
+};
+
 enum {
 	MLX5_IB_CLOCK_INFO_KERNEL_UPDATING = 1,
 };
+
+/* Bit indexes for the mlx5_alloc_ucontext_resp.clock_info_versions bitmap */
+enum {
+	MLX5_IB_CLOCK_INFO_V1              = 0,
+};
 #endif /* MLX5_ABI_USER_H */
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
