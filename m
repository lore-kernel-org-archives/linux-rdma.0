From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] mlx4: Limit num of fast reg WRs
Date: Thu, 7 Oct 2010 16:24:16 +0200
Message-ID: <20101007142416.GA11518@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix the limit of max fast regisreation WRs that can be posted to CX to match
hardware capabilities.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    2 +-
 drivers/infiniband/hw/mlx4/mr.c   |    2 +-
 include/linux/mlx4/device.h       |    4 ++++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 4e94e36..829225d 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -135,7 +135,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	props->max_srq		   = dev->dev->caps.num_srqs - dev->dev->caps.reserved_srqs;
 	props->max_srq_wr	   = dev->dev->caps.max_srq_wqes - 1;
 	props->max_srq_sge	   = dev->dev->caps.max_srq_sge;
-	props->max_fast_reg_page_list_len = PAGE_SIZE / sizeof (u64);
+	props->max_fast_reg_page_list_len = MAX_FAST_REG_PAGES;
 	props->local_ca_ack_delay  = dev->dev->caps.local_ca_ack_delay;
 	props->atomic_cap	   = dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_ATOMIC ?
 		IB_ATOMIC_HCA : IB_ATOMIC_NONE;
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 1d27b9a..83e3cc7 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -226,7 +226,7 @@ struct ib_fast_reg_page_list *mlx4_ib_alloc_fast_reg_page_list(struct ib_device
 	struct mlx4_ib_fast_reg_page_list *mfrpl;
 	int size = page_list_len * sizeof (u64);
 
-	if (size > PAGE_SIZE)
+	if (page_list_len > MAX_FAST_REG_PAGES)
 		return ERR_PTR(-EINVAL);
 
 	mfrpl = kmalloc(sizeof *mfrpl, GFP_KERNEL);
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 7a7f9c1..69fe3f7 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -171,6 +171,10 @@ enum {
 	MLX4_NUM_FEXCH          = 64 * 1024,
 };
 
+enum {
+	MAX_FAST_REG_PAGES = 511,
+};
+
 static inline u64 mlx4_fw_ver(u64 major, u64 minor, u64 subminor)
 {
 	return (major << 32) | (minor << 16) | subminor;
-- 
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
