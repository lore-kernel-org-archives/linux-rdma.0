From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 30/31] staging/rdma/hfi1: Remove create and free mad agents
Date: Tue, 19 Jan 2016 14:44:11 -0800
Message-ID: <20160119224411.32765.60291.stgit@scvm10.sc.intel.com>
References: <20160119223610.32765.10571.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160119223610.32765.10571.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Get rid of create and free mad agent from the driver and use rdmavt
version.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/mad.c   |   76 +++----------------------------------
 drivers/staging/rdma/hfi1/verbs.c |   14 +------
 drivers/staging/rdma/hfi1/verbs.h |    4 --
 3 files changed, 8 insertions(+), 86 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index 6daf277..9cadf77 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -129,7 +129,7 @@ static void send_trap(struct hfi1_ibport *ibp, void *data, unsigned len)
 	memcpy(smp->route.lid.data, data, len);
 
 	spin_lock_irqsave(&ibp->rvp.lock, flags);
-	if (!ibp->sm_ah) {
+	if (!ibp->rvp.sm_ah) {
 		if (ibp->rvp.sm_lid != be16_to_cpu(IB_LID_PERMISSIVE)) {
 			struct ib_ah *ah;
 
@@ -138,13 +138,13 @@ static void send_trap(struct hfi1_ibport *ibp, void *data, unsigned len)
 				ret = PTR_ERR(ah);
 			else {
 				send_buf->ah = ah;
-				ibp->sm_ah = ibah_to_rvtah(ah);
+				ibp->rvp.sm_ah = ibah_to_rvtah(ah);
 				ret = 0;
 			}
 		} else
 			ret = -EINVAL;
 	} else {
-		send_buf->ah = &ibp->sm_ah->ibah;
+		send_buf->ah = &ibp->rvp.sm_ah->ibah;
 		ret = 0;
 	}
 	spin_unlock_irqrestore(&ibp->rvp.lock, flags);
@@ -1138,11 +1138,11 @@ static int __subn_set_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 	} else if (smlid != ibp->rvp.sm_lid || msl != ibp->rvp.sm_sl) {
 		pr_warn("SubnSet(OPA_PortInfo) smlid 0x%x\n", smlid);
 		spin_lock_irqsave(&ibp->rvp.lock, flags);
-		if (ibp->sm_ah) {
+		if (ibp->rvp.sm_ah) {
 			if (smlid != ibp->rvp.sm_lid)
-				ibp->sm_ah->attr.dlid = smlid;
+				ibp->rvp.sm_ah->attr.dlid = smlid;
 			if (msl != ibp->rvp.sm_sl)
-				ibp->sm_ah->attr.sl = msl;
+				ibp->rvp.sm_ah->attr.sl = msl;
 		}
 		spin_unlock_irqrestore(&ibp->rvp.lock, flags);
 		if (smlid != ibp->rvp.sm_lid)
@@ -4157,67 +4157,3 @@ int hfi1_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
 
 	return IB_MAD_RESULT_FAILURE;
 }
-
-static void send_handler(struct ib_mad_agent *agent,
-			 struct ib_mad_send_wc *mad_send_wc)
-{
-	ib_free_send_mad(mad_send_wc->send_buf);
-}
-
-int hfi1_create_agents(struct hfi1_ibdev *dev)
-{
-	struct hfi1_devdata *dd = dd_from_dev(dev);
-	struct ib_mad_agent *agent;
-	struct hfi1_ibport *ibp;
-	int p;
-	int ret;
-
-	for (p = 0; p < dd->num_pports; p++) {
-		ibp = &dd->pport[p].ibport_data;
-		agent = ib_register_mad_agent(&dev->rdi.ibdev, p + 1,
-					      IB_QPT_SMI,
-					      NULL, 0, send_handler,
-					      NULL, NULL, 0);
-		if (IS_ERR(agent)) {
-			ret = PTR_ERR(agent);
-			goto err;
-		}
-
-		ibp->rvp.send_agent = agent;
-	}
-
-	return 0;
-
-err:
-	for (p = 0; p < dd->num_pports; p++) {
-		ibp = &dd->pport[p].ibport_data;
-		if (ibp->rvp.send_agent) {
-			agent = ibp->rvp.send_agent;
-			ibp->rvp.send_agent = NULL;
-			ib_unregister_mad_agent(agent);
-		}
-	}
-
-	return ret;
-}
-
-void hfi1_free_agents(struct hfi1_ibdev *dev)
-{
-	struct hfi1_devdata *dd = dd_from_dev(dev);
-	struct ib_mad_agent *agent;
-	struct hfi1_ibport *ibp;
-	int p;
-
-	for (p = 0; p < dd->num_pports; p++) {
-		ibp = &dd->pport[p].ibport_data;
-		if (ibp->rvp.send_agent) {
-			agent = ibp->rvp.send_agent;
-			ibp->rvp.send_agent = NULL;
-			ib_unregister_mad_agent(agent);
-		}
-		if (ibp->sm_ah) {
-			ib_destroy_ah(&ibp->sm_ah->ibah);
-			ibp->sm_ah = NULL;
-		}
-	}
-}
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 6799915..68f4045 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1590,27 +1590,19 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 
 	ret = rvt_register_device(&dd->verbs_dev.rdi);
 	if (ret)
-		goto err_reg;
-
-	ret = hfi1_create_agents(dev);
-	if (ret)
-		goto err_agents;
+		goto err_verbs_txreq;
 
 	ret = hfi1_verbs_register_sysfs(dd);
 	if (ret)
 		goto err_class;
 
-	goto bail;
+	return ret;
 
 err_class:
-	hfi1_free_agents(dev);
-err_agents:
 	rvt_unregister_device(&dd->verbs_dev.rdi);
-err_reg:
 err_verbs_txreq:
 	kmem_cache_destroy(dev->verbs_txreq_cache);
 	dd_dev_err(dd, "cannot register verbs: %d!\n", -ret);
-bail:
 	return ret;
 }
 
@@ -1620,8 +1612,6 @@ void hfi1_unregister_ib_device(struct hfi1_devdata *dd)
 
 	hfi1_verbs_unregister_sysfs(dd);
 
-	hfi1_free_agents(dev);
-
 	rvt_unregister_device(&dd->verbs_dev.rdi);
 
 	if (!list_empty(&dev->txwait))
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index f2c8a21..c845514 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -247,8 +247,6 @@ static inline void inc_opstats(
 struct hfi1_ibport {
 	struct rvt_qp __rcu *qp[2];
 	struct rvt_ibport rvp;
-	struct rvt_ah *sm_ah;
-	struct rvt_ah *smi_ah;
 
 	__be64 guids[HFI1_GUIDS_PER_PORT	- 1];	/* writable GUIDs */
 
@@ -340,8 +338,6 @@ int hfi1_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
 		     const struct ib_mad_hdr *in_mad, size_t in_mad_size,
 		     struct ib_mad_hdr *out_mad, size_t *out_mad_size,
 		     u16 *out_mad_pkey_index);
-int hfi1_create_agents(struct hfi1_ibdev *dev);
-void hfi1_free_agents(struct hfi1_ibdev *dev);
 
 /*
  * The PSN_MASK and PSN_SHIFT allow for

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
