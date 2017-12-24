From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/3] IB/mlx5: Extend UAR stuff to support dynamic allocation
Date: Sun, 24 Dec 2017 16:31:34 +0200
Message-ID: <20171224143136.12306-2-leon@kernel.org>
References: <20171224143136.12306-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171224143136.12306-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch extends the alloc context flow to be prepared for working
with dynamic UAR allocations.

Currently upon alloc context there is some fix size of UARs that are
allocated (named 'static allocation') and there is no option to user
application to ask for more or control which UAR will be used by which
QP.

In this patch the driver prepares its data structures to manage both the
static and the dynamic allocations and let the user driver knows about
the max value of dynamic blue-flame registers that are allowed.

Downstream patches from this series will enable the dynamic allocation
and the association as part of QP creation.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 37 +++++++++++++++++++++++++++---------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  6 +++---
 drivers/infiniband/hw/mlx5/qp.c      |  2 +-
 include/linux/mlx5/device.h          |  2 ++
 include/linux/mlx5/driver.h          |  3 +++
 include/uapi/rdma/mlx5-abi.h         |  2 ++
 6 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 9e2d6a872e5a..4f2d71298937 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1417,9 +1417,18 @@ static void print_lib_caps(struct mlx5_ib_dev *dev, u64 caps)
 		    caps & MLX5_LIB_CAP_4K_UAR ? "y" : "n");
 }
 
+static u16 calc_dynamic_bfregs(int uars_per_sys_page)
+{
+	/* Large page with non 4k uar support might limit the dynamic size */
+	if (uars_per_sys_page == 1  && PAGE_SIZE > 4096)
+		return MLX5_MIN_DYN_BFREGS;
+
+	return MLX5_MAX_DYN_BFREGS;
+}
+
 static int calc_total_bfregs(struct mlx5_ib_dev *dev, bool lib_uar_4k,
 			     struct mlx5_ib_alloc_ucontext_req_v2 *req,
-			     u32 *num_sys_pages)
+			     struct mlx5_bfreg_info *bfregi)
 {
 	int uars_per_sys_page;
 	int bfregs_per_sys_page;
@@ -1436,16 +1445,21 @@ static int calc_total_bfregs(struct mlx5_ib_dev *dev, bool lib_uar_4k,
 
 	uars_per_sys_page = get_uars_per_sys_page(dev, lib_uar_4k);
 	bfregs_per_sys_page = uars_per_sys_page * MLX5_NON_FP_BFREGS_PER_UAR;
+	/* This holds the required static allocation asked by the user */
 	req->total_num_bfregs = ALIGN(req->total_num_bfregs, bfregs_per_sys_page);
-	*num_sys_pages = req->total_num_bfregs / bfregs_per_sys_page;
-
 	if (req->num_low_latency_bfregs > req->total_num_bfregs - 1)
 		return -EINVAL;
 
-	mlx5_ib_dbg(dev, "uar_4k: fw support %s, lib support %s, user requested %d bfregs, allocated %d, using %d sys pages\n",
+	bfregi->num_static_sys_pages = req->total_num_bfregs / bfregs_per_sys_page;
+	bfregi->num_dyn_bfregs = ALIGN(calc_dynamic_bfregs(uars_per_sys_page), bfregs_per_sys_page);
+	bfregi->total_num_bfregs = req->total_num_bfregs + bfregi->num_dyn_bfregs;
+	bfregi->num_sys_pages = bfregi->total_num_bfregs / bfregs_per_sys_page;
+
+	mlx5_ib_dbg(dev, "uar_4k: fw support %s, lib support %s, user requested %d bfregs, allocated %d, total bfregs %d, using %d sys pages\n",
 		    MLX5_CAP_GEN(dev->mdev, uar_4k) ? "yes" : "no",
 		    lib_uar_4k ? "yes" : "no", ref_bfregs,
-		    req->total_num_bfregs, *num_sys_pages);
+		    req->total_num_bfregs, bfregi->total_num_bfregs,
+		    bfregi->num_sys_pages);
 
 	return 0;
 }
@@ -1457,7 +1471,7 @@ static int allocate_uars(struct mlx5_ib_dev *dev, struct mlx5_ib_ucontext *conte
 	int i;
 
 	bfregi = &context->bfregi;
-	for (i = 0; i < bfregi->num_sys_pages; i++) {
+	for (i = 0; i < bfregi->num_static_sys_pages; i++) {
 		err = mlx5_cmd_alloc_uar(dev->mdev, &bfregi->sys_pages[i]);
 		if (err)
 			goto error;
@@ -1481,7 +1495,7 @@ static int deallocate_uars(struct mlx5_ib_dev *dev, struct mlx5_ib_ucontext *con
 	int i;
 
 	bfregi = &context->bfregi;
-	for (i = 0; i < bfregi->num_sys_pages; i++) {
+	for (i = 0; i < bfregi->num_static_sys_pages; i++) {
 		err = mlx5_cmd_free_uar(dev->mdev, bfregi->sys_pages[i]);
 		if (err) {
 			mlx5_ib_warn(dev, "failed to free uar %d\n", i);
@@ -1596,13 +1610,13 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	bfregi = &context->bfregi;
 
 	/* updates req->total_num_bfregs */
-	err = calc_total_bfregs(dev, lib_uar_4k, &req, &bfregi->num_sys_pages);
+	err = calc_total_bfregs(dev, lib_uar_4k, &req, bfregi);
 	if (err)
 		goto out_ctx;
 
 	mutex_init(&bfregi->lock);
 	bfregi->lib_uar_4k = lib_uar_4k;
-	bfregi->count = kcalloc(req.total_num_bfregs, sizeof(*bfregi->count),
+	bfregi->count = kcalloc(bfregi->total_num_bfregs, sizeof(*bfregi->count),
 				GFP_KERNEL);
 	if (!bfregi->count) {
 		err = -ENOMEM;
@@ -1685,6 +1699,11 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	if (field_avail(typeof(resp), num_uars_per_page, udata->outlen))
 		resp.response_length += sizeof(resp.num_uars_per_page);
 
+	if (field_avail(typeof(resp), num_dyn_bfregs, udata->outlen)) {
+		resp.num_dyn_bfregs = bfregi->num_dyn_bfregs;
+		resp.response_length += sizeof(resp.num_dyn_bfregs);
+	}
+
 	err = ib_copy_to_udata(udata, &resp, resp.response_length);
 	if (err)
 		goto out_td;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 196b55b90c60..32b317d16280 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1177,10 +1177,10 @@ static inline int get_uars_per_sys_page(struct mlx5_ib_dev *dev, bool lib_suppor
 				MLX5_UARS_IN_PAGE : 1;
 }
 
-static inline int get_num_uars(struct mlx5_ib_dev *dev,
-			       struct mlx5_bfreg_info *bfregi)
+static inline int get_num_static_uars(struct mlx5_ib_dev *dev,
+				      struct mlx5_bfreg_info *bfregi)
 {
-	return get_uars_per_sys_page(dev, bfregi->lib_uar_4k) * bfregi->num_sys_pages;
+	return get_uars_per_sys_page(dev, bfregi->lib_uar_4k) * bfregi->num_static_sys_pages;
 }
 
 #endif /* MLX5_IB_H */
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 33b132a9a0fc..166b37daa794 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -493,7 +493,7 @@ enum {
 
 static int max_bfregs(struct mlx5_ib_dev *dev, struct mlx5_bfreg_info *bfregi)
 {
-	return get_num_uars(dev, bfregi) * MLX5_NON_FP_BFREGS_PER_UAR;
+	return get_num_static_uars(dev, bfregi) * MLX5_NON_FP_BFREGS_PER_UAR;
 }
 
 static int num_med_bfreg(struct mlx5_ib_dev *dev,
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 18c041966ab8..2ff9f48ebec3 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -249,6 +249,8 @@ enum {
 					  MLX5_NON_FP_BFREGS_PER_UAR,
 	MLX5_UARS_IN_PAGE		= PAGE_SIZE / MLX5_ADAPTER_PAGE_SIZE,
 	MLX5_NON_FP_BFREGS_IN_PAGE	= MLX5_NON_FP_BFREGS_PER_UAR * MLX5_UARS_IN_PAGE,
+	MLX5_MIN_DYN_BFREGS		= 512,
+	MLX5_MAX_DYN_BFREGS		= 1024,
 };
 
 enum {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index bc494ddefcf8..4d1ed35fdbb4 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -230,6 +230,9 @@ struct mlx5_bfreg_info {
 	u32			ver;
 	bool			lib_uar_4k;
 	u32			num_sys_pages;
+	u32			num_static_sys_pages;
+	u32			total_num_bfregs;
+	u32			num_dyn_bfregs;
 };
 
 struct mlx5_cmd_first {
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 062d14f07b61..12c523a1dd18 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -125,6 +125,8 @@ struct mlx5_ib_alloc_ucontext_resp {
 	__u64	hca_core_clock_offset;
 	__u32	log_uar_size;
 	__u32	num_uars_per_page;
+	__u32	num_dyn_bfregs;
+	__u32	reserved3;
 };
 
 struct mlx5_ib_alloc_pd_resp {
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
