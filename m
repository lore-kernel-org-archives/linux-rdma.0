From: j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 32/36] IB/odp/hmm: add new kernel option to use HMM for ODP.
Date: Thu, 21 May 2015 15:23:49 -0400
Message-ID: <1432236233-4035-33-git-send-email-j.glisse@gmail.com>
References: <1432236233-4035-1-git-send-email-j.glisse@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432236233-4035-1-git-send-email-j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brendan Conoboy <blc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Joe Donohue <jdonohue-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Duncan Poole <dpoole-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Sherry Cheung <SCheung-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Subhash Gutti <sgutti-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Mark Hairgrove <mhairgrove-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Lucien Dunning <ldunning-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Cameron Buschardt <cabuschardt-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Arvind Gopalakrishnan <arvindg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=46rom: J=C3=A9r=C3=B4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This is a preparatory patch for HMM implementation of ODP (on demand
paging). It introduce a new configure option and add proper build
time conditional code section. Enabling INFINIBAND_ON_DEMAND_PAGING_HMM
will result in build error with this patch.

Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
cc: <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 drivers/infiniband/Kconfig                   |  10 ++
 drivers/infiniband/core/umem_odp.c           |   4 +
 drivers/infiniband/core/uverbs_cmd.c         |  17 +++-
 drivers/infiniband/hw/mlx5/main.c            |  10 +-
 drivers/infiniband/hw/mlx5/mem.c             |   8 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |   9 +-
 drivers/infiniband/hw/mlx5/mr.c              |  10 +-
 drivers/infiniband/hw/mlx5/odp.c             | 135 ++++++++++++++-----=
--------
 drivers/infiniband/hw/mlx5/qp.c              |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/qp.c |   4 +-
 include/rdma/ib_umem_odp.h                   |  52 +++++++----
 include/rdma/ib_verbs.h                      |   4 +-
 12 files changed, 164 insertions(+), 101 deletions(-)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index b899531..764f524 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -49,6 +49,16 @@ config INFINIBAND_ON_DEMAND_PAGING
 	  memory regions without pinning their pages, fetching the
 	  pages on demand instead.
=20
+config INFINIBAND_ON_DEMAND_PAGING_HMM
+	bool "InfiniBand on-demand paging support using HMM."
+	depends on HMM
+	depends on INFINIBAND_ON_DEMAND_PAGING
+	default n
+	---help---
+	  Use HMM (heterogeneous memory management) kernel API for
+	  on demand paging. No userspace difference, this is just
+	  an alternative implementation of the feature.
+
 config INFINIBAND_ADDR_TRANS
 	bool
 	depends on INFINIBAND
diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/co=
re/umem_odp.c
index d10dd88..e55e124 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -41,6 +41,9 @@
 #include <rdma/ib_umem.h>
 #include <rdma/ib_umem_odp.h>
=20
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
+#error "CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM not supported at this s=
tage !"
+#else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 static void ib_umem_notifier_start_account(struct ib_umem *item)
 {
 	mutex_lock(&item->odp_data->umem_mutex);
@@ -667,3 +670,4 @@ void ib_umem_odp_unmap_dma_pages(struct ib_umem *um=
em, u64 virt,
 	mutex_unlock(&umem->odp_data->umem_mutex);
 }
 EXPORT_SYMBOL(ib_umem_odp_unmap_dma_pages);
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/=
core/uverbs_cmd.c
index a9f0489..ccd6bbe 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -290,8 +290,10 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_fil=
e *file,
 	struct ib_udata                   udata;
 	struct ib_device                 *ibdev =3D file->device->ib_dev;
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+#ifndef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
 	struct ib_device_attr		  dev_attr;
-#endif
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 	struct ib_ucontext		 *ucontext;
 	struct file			 *filp;
 	int ret;
@@ -335,6 +337,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file=
 *file,
 	ucontext->closing =3D 0;
=20
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+#ifndef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
 	ucontext->umem_tree =3D RB_ROOT;
 	init_rwsem(&ucontext->umem_rwsem);
 	ucontext->odp_mrs_count =3D 0;
@@ -345,8 +348,8 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file=
 *file,
 		goto err_free;
 	if (!(dev_attr.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING))
 		ucontext->invalidate_range =3D NULL;
-
-#endif
+#endif /* !CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
=20
 	resp.num_comp_vectors =3D file->device->num_comp_vectors;
=20
@@ -3335,6 +3338,9 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_fi=
le *file,
 		goto end;
=20
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
+#error "CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM not supported at this s=
tage !"
+#else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 	resp.odp_caps.general_caps =3D attr.odp_caps.general_caps;
 	resp.odp_caps.per_transport_caps.rc_odp_caps =3D
 		attr.odp_caps.per_transport_caps.rc_odp_caps;
@@ -3343,9 +3349,10 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_f=
ile *file,
 	resp.odp_caps.per_transport_caps.ud_odp_caps =3D
 		attr.odp_caps.per_transport_caps.ud_odp_caps;
 	resp.odp_caps.reserved =3D 0;
-#else
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
+#else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 	memset(&resp.odp_caps, 0, sizeof(resp.odp_caps));
-#endif
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 	resp.response_length +=3D sizeof(resp.odp_caps);
=20
 end:
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/=
mlx5/main.c
index 57c9809..d553f90 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -156,10 +156,14 @@ static int mlx5_ib_query_device(struct ib_device =
*ibdev,
 	props->max_map_per_fmr =3D INT_MAX; /* no limit in ConnectIB */
=20
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
+#error "CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM not supported at this s=
tage !"
+#else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 	if (dev->mdev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG)
 		props->device_cap_flags |=3D IB_DEVICE_ON_DEMAND_PAGING;
 	props->odp_caps =3D dev->odp_caps;
-#endif
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
=20
 out:
 	kfree(in_mad);
@@ -486,8 +490,10 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(=
struct ib_device *ibdev,
 	}
=20
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+#ifndef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
 	context->ibucontext.invalidate_range =3D &mlx5_ib_invalidate_range;
-#endif
+#endif /* !CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
=20
 	INIT_LIST_HEAD(&context->db_page_list);
 	mutex_init(&context->db_page_mutex);
diff --git a/drivers/infiniband/hw/mlx5/mem.c b/drivers/infiniband/hw/m=
lx5/mem.c
index df56b7d..21084c7 100644
--- a/drivers/infiniband/hw/mlx5/mem.c
+++ b/drivers/infiniband/hw/mlx5/mem.c
@@ -132,7 +132,7 @@ static u64 umem_dma_to_mtt(dma_addr_t umem_dma)
=20
 	return mtt_entry;
 }
-#endif
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
=20
 /*
  * Populate the given array with bus addresses from the umem.
@@ -163,6 +163,9 @@ void __mlx5_ib_populate_pas(struct mlx5_ib_dev *dev=
, struct ib_umem *umem,
 	struct scatterlist *sg;
 	int entry;
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
+#error "CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM not supported at this s=
tage !"
+#else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 	const bool odp =3D umem->odp_data !=3D NULL;
=20
 	if (odp) {
@@ -176,7 +179,8 @@ void __mlx5_ib_populate_pas(struct mlx5_ib_dev *dev=
, struct ib_umem *umem,
 		}
 		return;
 	}
-#endif
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
=20
 	i =3D 0;
 	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/=
hw/mlx5/mlx5_ib.h
index ec629f2..a6d62be 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -231,7 +231,7 @@ struct mlx5_ib_qp {
 	 */
 	spinlock_t              disable_page_faults_lock;
 	struct mlx5_ib_pfault	pagefaults[MLX5_IB_PAGEFAULT_CONTEXTS];
-#endif
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 };
=20
 struct mlx5_ib_cq_buf {
@@ -440,7 +440,7 @@ struct mlx5_ib_dev {
 	 * being used by a page fault handler.
 	 */
 	struct srcu_struct      mr_srcu;
-#endif
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 };
=20
 static inline struct mlx5_ib_cq *to_mibcq(struct mlx5_core_cq *mcq)
@@ -627,8 +627,13 @@ int __init mlx5_ib_odp_init(void);
 void mlx5_ib_odp_cleanup(void);
 void mlx5_ib_qp_disable_pagefaults(struct mlx5_ib_qp *qp);
 void mlx5_ib_qp_enable_pagefaults(struct mlx5_ib_qp *qp);
+
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
+#error "CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM not supported at this s=
tage !"
+#else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 void mlx5_ib_invalidate_range(struct ib_umem *umem, unsigned long star=
t,
 			      unsigned long end);
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
=20
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 static inline int mlx5_ib_internal_query_odp_caps(struct mlx5_ib_dev *=
dev)
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/ml=
x5/mr.c
index 759ed15..23cd123 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -62,7 +62,7 @@ static int destroy_mkey(struct mlx5_ib_dev *dev, stru=
ct mlx5_ib_mr *mr)
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	/* Wait until all page fault handlers using the mr complete. */
 	synchronize_srcu(&dev->mr_srcu);
-#endif
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
=20
 	return err;
 }
@@ -1114,7 +1114,7 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *p=
d, u64 start, u64 length,
 		 */
 		smp_wmb();
 	}
-#endif
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
=20
 	return &mr->ibmr;
=20
@@ -1209,9 +1209,13 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 		mr->live =3D 0;
 		/* Wait for all running page-fault handlers to finish. */
 		synchronize_srcu(&dev->mr_srcu);
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
+#error "CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM not supported at this s=
tage !"
+#else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 		/* Destroy all page mappings */
 		mlx5_ib_invalidate_range(umem, ib_umem_start(umem),
 					 ib_umem_end(umem));
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 		/*
 		 * We kill the umem before the MR for ODP,
 		 * so that there will not be any invalidations in
@@ -1223,7 +1227,7 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 		/* Avoid double-freeing the umem. */
 		umem =3D NULL;
 	}
-#endif
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
=20
 	clean_mr(mr);
=20
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/m=
lx5/odp.c
index 5171959..1de4d13 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -37,12 +37,30 @@
=20
 #define MAX_PREFETCH_LEN (4*1024*1024U)
=20
+struct workqueue_struct *mlx5_ib_page_fault_wq;
+
+static struct mlx5_ib_mr *mlx5_ib_odp_find_mr_lkey(struct mlx5_ib_dev =
*dev,
+						   u32 key)
+{
+	u32 base_key =3D mlx5_base_mkey(key);
+	struct mlx5_core_mr *mmr =3D __mlx5_mr_lookup(dev->mdev, base_key);
+	struct mlx5_ib_mr *mr =3D container_of(mmr, struct mlx5_ib_mr, mmr);
+
+	if (!mmr || mmr->key !=3D key || !mr->live)
+		return NULL;
+
+	return container_of(mmr, struct mlx5_ib_mr, mmr);
+}
+
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
+#error "CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM not supported at this s=
tage !"
+#else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
+
+
 /* Timeout in ms to wait for an active mmu notifier to complete when h=
andling
  * a pagefault. */
 #define MMU_NOTIFIER_TIMEOUT 1000
=20
-struct workqueue_struct *mlx5_ib_page_fault_wq;
-
 void mlx5_ib_invalidate_range(struct ib_umem *umem, unsigned long star=
t,
 			      unsigned long end)
 {
@@ -110,67 +128,6 @@ void mlx5_ib_invalidate_range(struct ib_umem *umem=
, unsigned long start,
 	ib_umem_odp_unmap_dma_pages(umem, start, end);
 }
=20
-#define COPY_ODP_BIT_MLX_TO_IB(reg, ib_caps, field_name, bit_name) do =
{	\
-	if (be32_to_cpu(reg.field_name) & MLX5_ODP_SUPPORT_##bit_name)	\
-		ib_caps->field_name |=3D IB_ODP_SUPPORT_##bit_name;	\
-} while (0)
-
-int mlx5_ib_internal_query_odp_caps(struct mlx5_ib_dev *dev)
-{
-	int err;
-	struct mlx5_odp_caps hw_caps;
-	struct ib_odp_caps *caps =3D &dev->odp_caps;
-
-	memset(caps, 0, sizeof(*caps));
-
-	if (!(dev->mdev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG))
-		return 0;
-
-	err =3D mlx5_query_odp_caps(dev->mdev, &hw_caps);
-	if (err)
-		goto out;
-
-	caps->general_caps =3D IB_ODP_SUPPORT;
-	COPY_ODP_BIT_MLX_TO_IB(hw_caps, caps, per_transport_caps.ud_odp_caps,
-			       SEND);
-	COPY_ODP_BIT_MLX_TO_IB(hw_caps, caps, per_transport_caps.rc_odp_caps,
-			       SEND);
-	COPY_ODP_BIT_MLX_TO_IB(hw_caps, caps, per_transport_caps.rc_odp_caps,
-			       RECV);
-	COPY_ODP_BIT_MLX_TO_IB(hw_caps, caps, per_transport_caps.rc_odp_caps,
-			       WRITE);
-	COPY_ODP_BIT_MLX_TO_IB(hw_caps, caps, per_transport_caps.rc_odp_caps,
-			       READ);
-
-out:
-	return err;
-}
-
-static struct mlx5_ib_mr *mlx5_ib_odp_find_mr_lkey(struct mlx5_ib_dev =
*dev,
-						   u32 key)
-{
-	u32 base_key =3D mlx5_base_mkey(key);
-	struct mlx5_core_mr *mmr =3D __mlx5_mr_lookup(dev->mdev, base_key);
-	struct mlx5_ib_mr *mr =3D container_of(mmr, struct mlx5_ib_mr, mmr);
-
-	if (!mmr || mmr->key !=3D key || !mr->live)
-		return NULL;
-
-	return container_of(mmr, struct mlx5_ib_mr, mmr);
-}
-
-static void mlx5_ib_page_fault_resume(struct mlx5_ib_qp *qp,
-				      struct mlx5_ib_pfault *pfault,
-				      int error) {
-	struct mlx5_ib_dev *dev =3D to_mdev(qp->ibqp.pd->device);
-	int ret =3D mlx5_core_page_fault_resume(dev->mdev, qp->mqp.qpn,
-					      pfault->mpfault.flags,
-					      error);
-	if (ret)
-		pr_err("Failed to resolve the page fault on QP 0x%x\n",
-		       qp->mqp.qpn);
-}
-
 /*
  * Handle a single data segment in a page-fault WQE.
  *
@@ -298,6 +255,58 @@ srcu_unlock:
 	return ret ? ret : npages;
 }
=20
+
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
+
+
+#define COPY_ODP_BIT_MLX_TO_IB(reg, ib_caps, field_name, bit_name) do =
{	\
+	if (be32_to_cpu(reg.field_name) & MLX5_ODP_SUPPORT_##bit_name)	\
+		ib_caps->field_name |=3D IB_ODP_SUPPORT_##bit_name;	\
+} while (0)
+
+int mlx5_ib_internal_query_odp_caps(struct mlx5_ib_dev *dev)
+{
+	int err;
+	struct mlx5_odp_caps hw_caps;
+	struct ib_odp_caps *caps =3D &dev->odp_caps;
+
+	memset(caps, 0, sizeof(*caps));
+
+	if (!(dev->mdev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG))
+		return 0;
+
+	err =3D mlx5_query_odp_caps(dev->mdev, &hw_caps);
+	if (err)
+		goto out;
+
+	caps->general_caps =3D IB_ODP_SUPPORT;
+	COPY_ODP_BIT_MLX_TO_IB(hw_caps, caps, per_transport_caps.ud_odp_caps,
+			       SEND);
+	COPY_ODP_BIT_MLX_TO_IB(hw_caps, caps, per_transport_caps.rc_odp_caps,
+			       SEND);
+	COPY_ODP_BIT_MLX_TO_IB(hw_caps, caps, per_transport_caps.rc_odp_caps,
+			       RECV);
+	COPY_ODP_BIT_MLX_TO_IB(hw_caps, caps, per_transport_caps.rc_odp_caps,
+			       WRITE);
+	COPY_ODP_BIT_MLX_TO_IB(hw_caps, caps, per_transport_caps.rc_odp_caps,
+			       READ);
+
+out:
+	return err;
+}
+
+static void mlx5_ib_page_fault_resume(struct mlx5_ib_qp *qp,
+				      struct mlx5_ib_pfault *pfault,
+				      int error) {
+	struct mlx5_ib_dev *dev =3D to_mdev(qp->ibqp.pd->device);
+	int ret =3D mlx5_core_page_fault_resume(dev->mdev, qp->mqp.qpn,
+					      pfault->mpfault.flags,
+					      error);
+	if (ret)
+		pr_err("Failed to resolve the page fault on QP 0x%x\n",
+		       qp->mqp.qpn);
+}
+
 /**
  * Parse a series of data segments for page fault handling.
  *
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/ml=
x5/qp.c
index d35f62d..e5dec1e 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3046,7 +3046,7 @@ int mlx5_ib_query_qp(struct ib_qp *ibqp, struct i=
b_qp_attr *qp_attr, int qp_attr
 	 * based upon this query's result.
 	 */
 	flush_workqueue(mlx5_ib_page_fault_wq);
-#endif
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
=20
 	mutex_lock(&qp->mutex);
 	outb =3D kzalloc(sizeof(*outb), GFP_KERNEL);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net=
/ethernet/mellanox/mlx5/core/qp.c
index dc7dbf7..a437a14 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -175,7 +175,7 @@ void mlx5_eq_pagefault(struct mlx5_core_dev *dev, s=
truct mlx5_eqe *eqe)
=20
 	mlx5_core_put_rsc(common);
 }
-#endif
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
=20
 int mlx5_core_create_qp(struct mlx5_core_dev *dev,
 			struct mlx5_core_qp *qp,
@@ -440,4 +440,4 @@ int mlx5_core_page_fault_resume(struct mlx5_core_de=
v *dev, u32 qpn,
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_core_page_fault_resume);
-#endif
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
diff --git a/include/rdma/ib_umem_odp.h b/include/rdma/ib_umem_odp.h
index 3da0b16..765aeb3 100644
--- a/include/rdma/ib_umem_odp.h
+++ b/include/rdma/ib_umem_odp.h
@@ -43,6 +43,9 @@ struct umem_odp_node {
 };
=20
 struct ib_umem_odp {
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
+#error "CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM not supported at this s=
tage !"
+#else
 	/*
 	 * An array of the pages included in the on-demand paging umem.
 	 * Indices of pages that are currently not mapped into the device wil=
l
@@ -62,8 +65,6 @@ struct ib_umem_odp {
 	 * also protects access to the mmu notifier counters.
 	 */
 	struct mutex		umem_mutex;
-	void			*private; /* for the HW driver to use. */
-
 	/* When false, use the notifier counter in the ucontext struct. */
 	bool mn_counters_active;
 	int notifiers_seq;
@@ -72,12 +73,13 @@ struct ib_umem_odp {
 	/* A linked list of umems that don't have private mmu notifier
 	 * counters yet. */
 	struct list_head no_private_counters;
+	struct completion	notifier_completion;
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
+	void			*private; /* for the HW driver to use. */
 	struct ib_umem		*umem;
=20
 	/* Tree tracking */
 	struct umem_odp_node	interval_tree;
-
-	struct completion	notifier_completion;
 	int			dying;
 };
=20
@@ -87,6 +89,28 @@ int ib_umem_odp_get(struct ib_ucontext *context, str=
uct ib_umem *umem);
=20
 void ib_umem_odp_release(struct ib_umem *umem);
=20
+void rbt_ib_umem_insert(struct umem_odp_node *node, struct rb_root *ro=
ot);
+void rbt_ib_umem_remove(struct umem_odp_node *node, struct rb_root *ro=
ot);
+typedef int (*umem_call_back)(struct ib_umem *item, u64 start, u64 end=
,
+			      void *cookie);
+/*
+ * Call the callback on each ib_umem in the range. Returns the logical=
 or of
+ * the return values of the functions called.
+ */
+int rbt_ib_umem_for_each_in_range(struct rb_root *root, u64 start, u64=
 end,
+				  umem_call_back cb, void *cookie);
+
+struct umem_odp_node *rbt_ib_umem_iter_first(struct rb_root *root,
+					     u64 start, u64 last);
+struct umem_odp_node *rbt_ib_umem_iter_next(struct umem_odp_node *node=
,
+					    u64 start, u64 last);
+
+
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
+#error "CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM not supported at this s=
tage !"
+#else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
+
+
 /*
  * The lower 2 bits of the DMA address signal the R/W permissions for
  * the entry. To upgrade the permissions, provide the appropriate
@@ -100,28 +124,13 @@ void ib_umem_odp_release(struct ib_umem *umem);
=20
 #define ODP_DMA_ADDR_MASK (~(ODP_READ_ALLOWED_BIT | ODP_WRITE_ALLOWED_=
BIT))
=20
+
 int ib_umem_odp_map_dma_pages(struct ib_umem *umem, u64 start_offset, =
u64 bcnt,
 			      u64 access_mask, unsigned long current_seq);
=20
 void ib_umem_odp_unmap_dma_pages(struct ib_umem *umem, u64 start_offse=
t,
 				 u64 bound);
=20
-void rbt_ib_umem_insert(struct umem_odp_node *node, struct rb_root *ro=
ot);
-void rbt_ib_umem_remove(struct umem_odp_node *node, struct rb_root *ro=
ot);
-typedef int (*umem_call_back)(struct ib_umem *item, u64 start, u64 end=
,
-			      void *cookie);
-/*
- * Call the callback on each ib_umem in the range. Returns the logical=
 or of
- * the return values of the functions called.
- */
-int rbt_ib_umem_for_each_in_range(struct rb_root *root, u64 start, u64=
 end,
-				  umem_call_back cb, void *cookie);
-
-struct umem_odp_node *rbt_ib_umem_iter_first(struct rb_root *root,
-					     u64 start, u64 last);
-struct umem_odp_node *rbt_ib_umem_iter_next(struct umem_odp_node *node=
,
-					    u64 start, u64 last);
-
 static inline int ib_umem_mmu_notifier_retry(struct ib_umem *item,
 					     unsigned long mmu_seq)
 {
@@ -145,8 +154,11 @@ static inline int ib_umem_mmu_notifier_retry(struc=
t ib_umem *item,
 	return 0;
 }
=20
+
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
=20
+
 static inline int ib_umem_odp_get(struct ib_ucontext *context,
 				  struct ib_umem *umem)
 {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 65994a1..7b00d30 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1157,6 +1157,7 @@ struct ib_ucontext {
=20
 	struct pid             *tgid;
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+#ifndef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
 	struct rb_root      umem_tree;
 	/*
 	 * Protects .umem_rbroot and tree, as well as odp_mrs_count and
@@ -1171,7 +1172,8 @@ struct ib_ucontext {
 	/* A list of umems that don't have private mmu notifier counters yet.=
 */
 	struct list_head	no_private_counters;
 	int                     odp_mrs_count;
-#endif
+#endif /* !CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 };
=20
 struct ib_uobject {
--=20
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
