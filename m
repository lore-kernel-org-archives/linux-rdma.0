From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 2/6] IB/core: add support to create a unsafe global rkey to ib_create_pd
Date: Mon,  5 Sep 2016 12:56:17 +0200
Message-ID: <1473072981-2035-3-git-send-email-hch@lst.de>
References: <1473072981-2035-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473072981-2035-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Instead of exposing ib_get_dma_mr to ULPs and letting them use it more or
less unchecked, this moves the capability of creating a global rkey into
the RDMA core, where it can be easily audited.  It also prints a warning
everytime this feature is used as well.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/mad.c                      |  2 +-
 drivers/infiniband/core/verbs.c                    | 27 ++++++++++++++++++----
 drivers/infiniband/hw/mlx4/mad.c                   |  2 +-
 drivers/infiniband/hw/mlx4/main.c                  |  2 +-
 drivers/infiniband/hw/mlx5/main.c                  |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |  2 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           |  2 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |  2 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |  2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  2 +-
 drivers/nvme/host/rdma.c                           |  2 +-
 drivers/nvme/target/rdma.c                         |  2 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |  2 +-
 include/rdma/ib_verbs.h                            | 20 +++++++++++++++-
 net/9p/trans_rdma.c                                |  2 +-
 net/rds/ib.c                                       |  2 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |  2 +-
 net/sunrpc/xprtrdma/verbs.c                        |  2 +-
 18 files changed, 57 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 2d49228..95d33a3 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -3160,7 +3160,7 @@ static int ib_mad_port_open(struct ib_device *device,
 		goto error3;
 	}
 
-	port_priv->pd = ib_alloc_pd(device);
+	port_priv->pd = ib_alloc_pd(device, 0);
 	if (IS_ERR(port_priv->pd)) {
 		dev_err(&device->dev, "Couldn't create ib_mad PD\n");
 		ret = PTR_ERR(port_priv->pd);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 9159ea5..e87b518 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -227,9 +227,11 @@ EXPORT_SYMBOL(rdma_port_get_link_layer);
  * Every PD has a local_dma_lkey which can be used as the lkey value for local
  * memory operations.
  */
-struct ib_pd *ib_alloc_pd(struct ib_device *device)
+struct ib_pd *__ib_alloc_pd(struct ib_device *device, unsigned int flags,
+		const char *caller)
 {
 	struct ib_pd *pd;
+	int mr_access_flags = 0;
 
 	pd = device->alloc_pd(device, NULL, NULL);
 	if (IS_ERR(pd))
@@ -239,24 +241,39 @@ struct ib_pd *ib_alloc_pd(struct ib_device *device)
 	pd->uobject = NULL;
 	pd->__internal_mr = NULL;
 	atomic_set(&pd->usecnt, 0);
+	pd->flags = flags;
 
 	if (device->attrs.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)
 		pd->local_dma_lkey = device->local_dma_lkey;
-	else {
+	else
+		mr_access_flags |= IB_ACCESS_LOCAL_WRITE;
+
+	if (flags & IB_PD_UNSAFE_GLOBAL_RKEY) {
+		pr_warn("%s: enabling unsafe global rkey\n", caller);
+		mr_access_flags |= IB_ACCESS_REMOTE_READ | IB_ACCESS_REMOTE_WRITE;
+	}
+
+	if (mr_access_flags) {
 		struct ib_mr *mr;
 
-		mr = ib_get_dma_mr(pd, IB_ACCESS_LOCAL_WRITE);
+		mr = ib_get_dma_mr(pd, mr_access_flags);
 		if (IS_ERR(mr)) {
 			ib_dealloc_pd(pd);
 			return (struct ib_pd *)mr;
 		}
 
 		pd->__internal_mr = mr;
-		pd->local_dma_lkey = pd->__internal_mr->lkey;
+
+		if (!(device->attrs.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY))
+			pd->local_dma_lkey = pd->__internal_mr->lkey;
+
+		if (flags & IB_PD_UNSAFE_GLOBAL_RKEY)
+			pd->unsafe_global_rkey = pd->__internal_mr->rkey;
 	}
+
 	return pd;
 }
-EXPORT_SYMBOL(ib_alloc_pd);
+EXPORT_SYMBOL(__ib_alloc_pd);
 
 /**
  * ib_dealloc_pd - Deallocates a protection domain.
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 9c2e53d..517346f 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1897,7 +1897,7 @@ static int create_pv_resources(struct ib_device *ibdev, int slave, int port,
 		goto err_buf;
 	}
 
-	ctx->pd = ib_alloc_pd(ctx->ib_dev);
+	ctx->pd = ib_alloc_pd(ctx->ib_dev, 0);
 	if (IS_ERR(ctx->pd)) {
 		ret = PTR_ERR(ctx->pd);
 		pr_err("Couldn't create tunnel PD (%d)\n", ret);
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 2af44c2..a96e78c 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1259,7 +1259,7 @@ static struct ib_xrcd *mlx4_ib_alloc_xrcd(struct ib_device *ibdev,
 	if (err)
 		goto err1;
 
-	xrcd->pd = ib_alloc_pd(ibdev);
+	xrcd->pd = ib_alloc_pd(ibdev, 0);
 	if (IS_ERR(xrcd->pd)) {
 		err = PTR_ERR(xrcd->pd);
 		goto err2;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index f02a975..cf1eee4 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2223,7 +2223,7 @@ static int create_umr_res(struct mlx5_ib_dev *dev)
 		goto error_0;
 	}
 
-	pd = ib_alloc_pd(&dev->ib_dev);
+	pd = ib_alloc_pd(&dev->ib_dev, 0);
 	if (IS_ERR(pd)) {
 		mlx5_ib_dbg(dev, "Couldn't create PD for sync UMR QP\n");
 		ret = PTR_ERR(pd);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index c55ecb2..6067f07 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -147,7 +147,7 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 	int ret, size;
 	int i;
 
-	priv->pd = ib_alloc_pd(priv->ca);
+	priv->pd = ib_alloc_pd(priv->ca, 0);
 	if (IS_ERR(priv->pd)) {
 		printk(KERN_WARNING "%s: failed to allocate PD\n", ca->name);
 		return -ENODEV;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 1b49453..e9de992 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -88,7 +88,7 @@ static int iser_create_device_ib_res(struct iser_device *device)
 		  device->comps_used, ib_dev->name,
 		  ib_dev->num_comp_vectors, max_cqe);
 
-	device->pd = ib_alloc_pd(ib_dev);
+	device->pd = ib_alloc_pd(ib_dev, 0);
 	if (IS_ERR(device->pd))
 		goto pd_err;
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index ba6be06..8df608e 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -309,7 +309,7 @@ isert_create_device_ib_res(struct isert_device *device)
 	if (ret)
 		goto out;
 
-	device->pd = ib_alloc_pd(ib_dev);
+	device->pd = ib_alloc_pd(ib_dev, 0);
 	if (IS_ERR(device->pd)) {
 		ret = PTR_ERR(device->pd);
 		isert_err("failed to allocate pd, device %p, ret=%d\n",
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 3322ed7..579b8ae 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3573,7 +3573,7 @@ static void srp_add_one(struct ib_device *device)
 	INIT_LIST_HEAD(&srp_dev->dev_list);
 
 	srp_dev->dev = device;
-	srp_dev->pd  = ib_alloc_pd(device);
+	srp_dev->pd  = ib_alloc_pd(device, 0);
 	if (IS_ERR(srp_dev->pd))
 		goto free_dev;
 
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index dfa23b0..48a44af 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2475,7 +2475,7 @@ static void srpt_add_one(struct ib_device *device)
 	init_waitqueue_head(&sdev->ch_releaseQ);
 	mutex_init(&sdev->mutex);
 
-	sdev->pd = ib_alloc_pd(device);
+	sdev->pd = ib_alloc_pd(device, 0);
 	if (IS_ERR(sdev->pd))
 		goto free_dev;
 
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 8d2875b..a4961ed 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -446,7 +446,7 @@ nvme_rdma_find_get_device(struct rdma_cm_id *cm_id)
 	ndev->dev = cm_id->device;
 	kref_init(&ndev->ref);
 
-	ndev->pd = ib_alloc_pd(ndev->dev);
+	ndev->pd = ib_alloc_pd(ndev->dev, 0);
 	if (IS_ERR(ndev->pd))
 		goto out_free_dev;
 
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index b4d6485..187763a 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -848,7 +848,7 @@ nvmet_rdma_find_get_device(struct rdma_cm_id *cm_id)
 	ndev->device = cm_id->device;
 	kref_init(&ndev->ref);
 
-	ndev->pd = ib_alloc_pd(ndev->device);
+	ndev->pd = ib_alloc_pd(ndev->device, 0);
 	if (IS_ERR(ndev->pd))
 		goto out_free_dev;
 
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
index 4f5978b..0e4c609 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
@@ -2465,7 +2465,7 @@ int kiblnd_dev_failover(struct kib_dev *dev)
 	hdev->ibh_cmid  = cmid;
 	hdev->ibh_ibdev = cmid->device;
 
-	pd = ib_alloc_pd(cmid->device);
+	pd = ib_alloc_pd(cmid->device, 0);
 	if (IS_ERR(pd)) {
 		rc = PTR_ERR(pd);
 		CERROR("Can't allocate PD: %d\n", rc);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 38a08dae..4bdd898 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1370,10 +1370,13 @@ struct ib_udata {
 
 struct ib_pd {
 	u32			local_dma_lkey;
+	u32			flags;
 	struct ib_device       *device;
 	struct ib_uobject      *uobject;
 	atomic_t          	usecnt; /* count all resources */
 
+	u32			unsafe_global_rkey;
+
 	/*
 	 * Implementation details of the RDMA core, don't use in drivers:
 	 */
@@ -2506,8 +2509,23 @@ int ib_find_gid(struct ib_device *device, union ib_gid *gid,
 int ib_find_pkey(struct ib_device *device,
 		 u8 port_num, u16 pkey, u16 *index);
 
-struct ib_pd *ib_alloc_pd(struct ib_device *device);
+enum ib_pd_flags {
+	/*
+	 * Create a memory registration for all memory in the system and place
+	 * the rkey for it into pd->unsafe_global_rkey.  This can be used by
+	 * ULPs to avoid the overhead of dynamic MRs.
+	 *
+	 * This flag is generally considered unsafe and must only be used in
+	 * extremly trusted environments.  Every use of it will log a warning
+	 * in the kernel log.
+	 */
+	IB_PD_UNSAFE_GLOBAL_RKEY	= 0x01,
+};
 
+struct ib_pd *__ib_alloc_pd(struct ib_device *device, unsigned int flags,
+		const char *caller);
+#define ib_alloc_pd(device, flags) \
+	__ib_alloc_pd((device), (flags), __func__)
 void ib_dealloc_pd(struct ib_pd *pd);
 
 /**
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 1852e38..553ed4e 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -680,7 +680,7 @@ rdma_create_trans(struct p9_client *client, const char *addr, char *args)
 		goto error;
 
 	/* Create the Protection Domain */
-	rdma->pd = ib_alloc_pd(rdma->cm_id->device);
+	rdma->pd = ib_alloc_pd(rdma->cm_id->device, 0);
 	if (IS_ERR(rdma->pd))
 		goto error;
 
diff --git a/net/rds/ib.c b/net/rds/ib.c
index 7eaf887..5680d90 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -160,7 +160,7 @@ static void rds_ib_add_one(struct ib_device *device)
 	rds_ibdev->max_responder_resources = device->attrs.max_qp_rd_atom;
 
 	rds_ibdev->dev = device;
-	rds_ibdev->pd = ib_alloc_pd(device);
+	rds_ibdev->pd = ib_alloc_pd(device, 0);
 	if (IS_ERR(rds_ibdev->pd)) {
 		rds_ibdev->pd = NULL;
 		goto put_dev;
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index dd94401..eb2857f 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -993,7 +993,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	newxprt->sc_ord = min_t(size_t, dev->attrs.max_qp_rd_atom, newxprt->sc_ord);
 	newxprt->sc_ord = min_t(size_t,	svcrdma_ord, newxprt->sc_ord);
 
-	newxprt->sc_pd = ib_alloc_pd(dev);
+	newxprt->sc_pd = ib_alloc_pd(dev, 0);
 	if (IS_ERR(newxprt->sc_pd)) {
 		dprintk("svcrdma: error creating PD for connect request\n");
 		goto errout;
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 536d0be..6561d4a 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -386,7 +386,7 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
 	}
 	ia->ri_device = ia->ri_id->device;
 
-	ia->ri_pd = ib_alloc_pd(ia->ri_device);
+	ia->ri_pd = ib_alloc_pd(ia->ri_device, 0);
 	if (IS_ERR(ia->ri_pd)) {
 		rc = PTR_ERR(ia->ri_pd);
 		pr_err("rpcrdma: ib_alloc_pd() returned %d\n", rc);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
