From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 rdma-next 07/18] IB/core: Rename ib_create_ah to rdma_create_ah
Date: Sat, 29 Apr 2017 14:41:19 -0400
Message-ID: <1493491290-31621-8-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Rename ib_create_ah to rdma_create_ah so its in sync with the
rename of the ib address handle attribute

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cm.c                    | 2 +-
 drivers/infiniband/core/sa_query.c              | 2 +-
 drivers/infiniband/core/user_mad.c              | 2 +-
 drivers/infiniband/core/verbs.c                 | 6 +++---
 drivers/infiniband/hw/hfi1/verbs.c              | 2 +-
 drivers/infiniband/hw/mlx4/mad.c                | 8 ++++----
 drivers/infiniband/hw/mthca/mthca_mad.c         | 4 ++--
 drivers/infiniband/hw/qib/qib_verbs.c           | 2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c         | 2 +-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c | 2 +-
 include/rdma/ib_verbs.h                         | 4 ++--
 11 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index c9751cc..ac62dd8 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -343,7 +343,7 @@ static int cm_alloc_msg(struct cm_id_private *cm_id_priv,
 		ret = -ENODEV;
 		goto out;
 	}
-	ah = ib_create_ah(mad_agent->qp->pd, &av->ah_attr);
+	ah = rdma_create_ah(mad_agent->qp->pd, &av->ah_attr);
 	if (IS_ERR(ah)) {
 		ret = PTR_ERR(ah);
 		goto out;
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 18e0853..e998d6b 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -2043,7 +2043,7 @@ static void update_sm_ah(struct work_struct *work)
 			cpu_to_be64(IB_SA_WELL_KNOWN_GUID);
 	}
 
-	new_ah->ah = ib_create_ah(port->agent->qp->pd, &ah_attr);
+	new_ah->ah = rdma_create_ah(port->agent->qp->pd, &ah_attr);
 	if (IS_ERR(new_ah->ah)) {
 		pr_warn("Couldn't create new SM AH\n");
 		kfree(new_ah);
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 7198c40..3ac6f97 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -502,7 +502,7 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 		ah_attr.grh.traffic_class  = packet->mad.hdr.traffic_class;
 	}
 
-	ah = ib_create_ah(agent->qp->pd, &ah_attr);
+	ah = rdma_create_ah(agent->qp->pd, &ah_attr);
 	if (IS_ERR(ah)) {
 		ret = PTR_ERR(ah);
 		goto err_up;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index b1cde14..b52f4a1 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -311,7 +311,7 @@ void ib_dealloc_pd(struct ib_pd *pd)
 
 /* Address handles */
 
-struct ib_ah *ib_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr)
+struct ib_ah *rdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr)
 {
 	struct ib_ah *ah;
 
@@ -326,7 +326,7 @@ struct ib_ah *ib_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr)
 
 	return ah;
 }
-EXPORT_SYMBOL(ib_create_ah);
+EXPORT_SYMBOL(rdma_create_ah);
 
 int ib_get_rdma_header_version(const union rdma_network_hdr *hdr)
 {
@@ -567,7 +567,7 @@ struct ib_ah *ib_create_ah_from_wc(struct ib_pd *pd, const struct ib_wc *wc,
 	if (ret)
 		return ERR_PTR(ret);
 
-	return ib_create_ah(pd, &ah_attr);
+	return rdma_create_ah(pd, &ah_attr);
 }
 EXPORT_SYMBOL(ib_create_ah_from_wc);
 
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 0d3ae04..3cd1122 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1518,7 +1518,7 @@ struct ib_ah *hfi1_create_qp0_ah(struct hfi1_ibport *ibp, u16 dlid)
 	rcu_read_lock();
 	qp0 = rcu_dereference(ibp->rvp.qp[0]);
 	if (qp0)
-		ah = ib_create_ah(qp0->ibqp.pd, &attr);
+		ah = rdma_create_ah(qp0->ibqp.pd, &attr);
 	rcu_read_unlock();
 	return ah;
 }
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index d934959..76010d0 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -200,8 +200,8 @@ static void update_sm_ah(struct mlx4_ib_dev *dev, u8 port_num, u16 lid, u8 sl)
 	ah_attr.sl       = sl;
 	ah_attr.port_num = port_num;
 
-	new_ah = ib_create_ah(dev->send_agent[port_num - 1][0]->qp->pd,
-			      &ah_attr);
+	new_ah = rdma_create_ah(dev->send_agent[port_num - 1][0]->qp->pd,
+				&ah_attr);
 	if (IS_ERR(new_ah))
 		return;
 
@@ -563,7 +563,7 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 			return -EINVAL;
 		attr.ah_flags = IB_AH_GRH;
 	}
-	ah = ib_create_ah(tun_ctx->pd, &attr);
+	ah = rdma_create_ah(tun_ctx->pd, &attr);
 	if (IS_ERR(ah))
 		return -ENOMEM;
 
@@ -1391,7 +1391,7 @@ int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u8 port,
 	/* create ah */
 	sgid_index = attr->grh.sgid_index;
 	attr->grh.sgid_index = 0;
-	ah = ib_create_ah(sqp_ctx->pd, attr);
+	ah = rdma_create_ah(sqp_ctx->pd, attr);
 	if (IS_ERR(ah))
 		return -ENOMEM;
 	attr->grh.sgid_index = sgid_index;
diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index 00f7831..7f671a2 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -86,8 +86,8 @@ static void update_sm_ah(struct mthca_dev *dev,
 	ah_attr.sl       = sl;
 	ah_attr.port_num = port_num;
 
-	new_ah = ib_create_ah(dev->send_agent[port_num - 1][0]->qp->pd,
-			      &ah_attr);
+	new_ah = rdma_create_ah(dev->send_agent[port_num - 1][0]->qp->pd,
+				&ah_attr);
 	if (IS_ERR(new_ah))
 		return;
 
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 16a9aa1..de04aca 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1374,7 +1374,7 @@ struct ib_ah *qib_create_qp0_ah(struct qib_ibport *ibp, u16 dlid)
 	rcu_read_lock();
 	qp0 = rcu_dereference(ibp->rvp.qp[0]);
 	if (qp0)
-		ah = ib_create_ah(qp0->ibqp.pd, &attr);
+		ah = rdma_create_ah(qp0->ibqp.pd, &attr);
 	rcu_read_unlock();
 	return ah;
 }
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index adbce02..e0ba6b0 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -65,7 +65,7 @@ struct ipoib_ah *ipoib_create_ah(struct net_device *dev,
 	ah->last_send = 0;
 	kref_init(&ah->ref);
 
-	vah = ib_create_ah(pd, attr);
+	vah = rdma_create_ah(pd, attr);
 	if (IS_ERR(vah)) {
 		kfree(ah);
 		ah = (struct ipoib_ah *)vah;
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
index 4f0b74b..f6c11f6 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
@@ -772,7 +772,7 @@ void opa_vnic_vema_send_trap(struct opa_vnic_adapter *adapter,
 	}
 
 	ah_attr.dlid = trap_lid;
-	ah = ib_create_ah(port->mad_agent->qp->pd, &ah_attr);
+	ah = rdma_create_ah(port->mad_agent->qp->pd, &ah_attr);
 	if (IS_ERR(ah)) {
 		c_err("%s:Couldn't create new AH = %p\n", __func__, ah);
 		c_err("%s:dlid = %d, sl = %d, port = %d\n", __func__,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ed9f198..d658121 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2720,14 +2720,14 @@ struct ib_pd *__ib_alloc_pd(struct ib_device *device, unsigned int flags,
 void ib_dealloc_pd(struct ib_pd *pd);
 
 /**
- * ib_create_ah - Creates an address handle for the given address vector.
+ * rdma_create_ah - Creates an address handle for the given address vector.
  * @pd: The protection domain associated with the address handle.
  * @ah_attr: The attributes of the address vector.
  *
  * The address handle is used to reference a local or global destination
  * in all UD QP post sends.
  */
-struct ib_ah *ib_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr);
+struct ib_ah *rdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr);
 
 /**
  * ib_get_gids_from_rdma_hdr - Get sgid and dgid from GRH or IPv4 header
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
