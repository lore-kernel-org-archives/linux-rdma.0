From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 2/7] IB/qib: Remove create and free mad agents
Date: Fri, 22 Jan 2016 13:07:30 -0800
Message-ID: <20160122210728.10962.51545.stgit@scvm10.sc.intel.com>
References: <20160122210559.10962.33295.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122210559.10962.33295.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Get rid of create and free mad agent from the driver and use rdmavt
version.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |   10 ++-
 drivers/infiniband/hw/qib/qib_mad.c     |   99 ++++++++-----------------------
 drivers/infiniband/hw/qib/qib_verbs.c   |   14 +---
 drivers/infiniband/hw/qib/qib_verbs.h   |    6 +-
 4 files changed, 34 insertions(+), 95 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index ca28c19..a159922 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -2910,8 +2910,8 @@ static void qib_setup_7322_cleanup(struct qib_devdata *dd)
 			spin_unlock_irqrestore(&dd->cspec->gpio_lock, flags);
 			qib_qsfp_deinit(&dd->pport[i].cpspec->qsfp_data);
 		}
-		if (dd->pport[i].ibport_data.smi_ah)
-			ib_destroy_ah(&dd->pport[i].ibport_data.smi_ah->ibah);
+		if (dd->pport[i].ibport_data.rvp.smi_ah)
+			ib_destroy_ah(&dd->pport[i].ibport_data.rvp.smi_ah->ibah);
 	}
 }
 
@@ -5507,7 +5507,7 @@ static void try_7322_ipg(struct qib_pportdata *ppd)
 	if (IS_ERR(send_buf))
 		goto retry;
 
-	if (!ibp->smi_ah) {
+	if (!ibp->rvp.smi_ah) {
 		struct ib_ah *ah;
 
 		ah = qib_create_qp0_ah(ibp, be16_to_cpu(IB_LID_PERMISSIVE));
@@ -5515,11 +5515,11 @@ static void try_7322_ipg(struct qib_pportdata *ppd)
 			ret = PTR_ERR(ah);
 		else {
 			send_buf->ah = ah;
-			ibp->smi_ah = ibah_to_rvtah(ah);
+			ibp->rvp.smi_ah = ibah_to_rvtah(ah);
 			ret = 0;
 		}
 	} else {
-		send_buf->ah = &ibp->smi_ah->ibah;
+		send_buf->ah = &ibp->rvp.smi_ah->ibah;
 		ret = 0;
 	}
 
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 3e8dde2..1273537 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -101,7 +101,7 @@ static void qib_send_trap(struct qib_ibport *ibp, void *data, unsigned len)
 	memcpy(smp->data, data, len);
 
 	spin_lock_irqsave(&ibp->rvp.lock, flags);
-	if (!ibp->sm_ah) {
+	if (!ibp->rvp.sm_ah) {
 		if (ibp->rvp.sm_lid != be16_to_cpu(IB_LID_PERMISSIVE)) {
 			struct ib_ah *ah;
 
@@ -110,13 +110,13 @@ static void qib_send_trap(struct qib_ibport *ibp, void *data, unsigned len)
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
@@ -712,11 +712,11 @@ static int subn_set_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 		smp->status |= IB_SMP_INVALID_FIELD;
 	else if (smlid != ibp->rvp.sm_lid || msl != ibp->rvp.sm_sl) {
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
@@ -2445,12 +2445,6 @@ bail:
 	return ret;
 }
 
-static void send_handler(struct ib_mad_agent *agent,
-			 struct ib_mad_send_wc *mad_send_wc)
-{
-	ib_free_send_mad(mad_send_wc->send_buf);
-}
-
 static void xmit_wait_timer_func(unsigned long opaque)
 {
 	struct qib_pportdata *ppd = (struct qib_pportdata *)opaque;
@@ -2475,71 +2469,28 @@ done:
 	mod_timer(&ppd->cong_stats.timer, jiffies + HZ);
 }
 
-int qib_create_agents(struct qib_ibdev *dev)
+void qib_notify_create_mad_agent(struct rvt_dev_info *rdi, int port_idx)
 {
-	struct qib_devdata *dd = dd_from_dev(dev);
-	struct ib_mad_agent *agent;
-	struct qib_ibport *ibp;
-	int p;
-	int ret;
+	struct qib_ibdev *ibdev = container_of(rdi, struct qib_ibdev, rdi);
+	struct qib_devdata *dd = container_of(ibdev,
+					      struct qib_devdata, verbs_dev);
 
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
-		/* Initialize xmit_wait structure */
-		dd->pport[p].cong_stats.counter = 0;
-		init_timer(&dd->pport[p].cong_stats.timer);
-		dd->pport[p].cong_stats.timer.function = xmit_wait_timer_func;
-		dd->pport[p].cong_stats.timer.data =
-			(unsigned long)(&dd->pport[p]);
-		dd->pport[p].cong_stats.timer.expires = 0;
-		add_timer(&dd->pport[p].cong_stats.timer);
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
+	/* Initialize xmit_wait structure */
+	dd->pport[port_idx].cong_stats.counter = 0;
+	init_timer(&dd->pport[port_idx].cong_stats.timer);
+	dd->pport[port_idx].cong_stats.timer.function = xmit_wait_timer_func;
+	dd->pport[port_idx].cong_stats.timer.data =
+		(unsigned long)(&dd->pport[port_idx]);
+	dd->pport[port_idx].cong_stats.timer.expires = 0;
+	add_timer(&dd->pport[port_idx].cong_stats.timer);
 }
 
-void qib_free_agents(struct qib_ibdev *dev)
+void qib_notify_free_mad_agent(struct rvt_dev_info *rdi, int port_idx)
 {
-	struct qib_devdata *dd = dd_from_dev(dev);
-	struct ib_mad_agent *agent;
-	struct qib_ibport *ibp;
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
-		if (dd->pport[p].cong_stats.timer.data)
-			del_timer_sync(&dd->pport[p].cong_stats.timer);
-	}
+	struct qib_ibdev *ibdev = container_of(rdi, struct qib_ibdev, rdi);
+	struct qib_devdata *dd = container_of(ibdev,
+					      struct qib_devdata, verbs_dev);
+
+	if (dd->pport[port_idx].cong_stats.timer.data)
+		del_timer_sync(&dd->pport[port_idx].cong_stats.timer);
 }
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 6b85153..a181502 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -2084,23 +2084,16 @@ int qib_register_ib_device(struct qib_devdata *dd)
 
 	ret = rvt_register_device(&dd->verbs_dev.rdi);
 	if (ret)
-		goto err_reg;
-
-	ret = qib_create_agents(dev);
-	if (ret)
-		goto err_agents;
+		goto err_tx;
 
 	ret = qib_verbs_register_sysfs(dd);
 	if (ret)
 		goto err_class;
 
-	goto bail;
+	return ret;
 
 err_class:
-	qib_free_agents(dev);
-err_agents:
 	rvt_unregister_device(&dd->verbs_dev.rdi);
-err_reg:
 err_tx:
 	while (!list_empty(&dev->txreq_free)) {
 		struct list_head *l = dev->txreq_free.next;
@@ -2117,7 +2110,6 @@ err_tx:
 				  dev->pio_hdrs, dev->pio_hdrs_phys);
 err_hdrs:
 	qib_dev_err(dd, "cannot register verbs: %d!\n", -ret);
-bail:
 	return ret;
 }
 
@@ -2127,8 +2119,6 @@ void qib_unregister_ib_device(struct qib_devdata *dd)
 
 	qib_verbs_unregister_sysfs(dd);
 
-	qib_free_agents(dev);
-
 	rvt_unregister_device(&dd->verbs_dev.rdi);
 
 	if (!list_empty(&dev->piowait))
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index bcc6271..3383d56 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -307,8 +307,6 @@ struct qib_pma_counters {
 
 struct qib_ibport {
 	struct rvt_ibport rvp;
-	struct rvt_ah *sm_ah;
-	struct rvt_ah *smi_ah;
 	__be64 guids[QIB_GUIDS_PER_PORT	- 1];	/* writable GUIDs */
 	struct qib_pma_counters __percpu *pmastats;
 	u64 z_unicast_xmit;     /* starting count for PMA */
@@ -433,8 +431,8 @@ int qib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 		    const struct ib_mad_hdr *in, size_t in_mad_size,
 		    struct ib_mad_hdr *out, size_t *out_mad_size,
 		    u16 *out_mad_pkey_index);
-int qib_create_agents(struct qib_ibdev *dev);
-void qib_free_agents(struct qib_ibdev *dev);
+void qib_notify_create_mad_agent(struct rvt_dev_info *rdi, int port_idx);
+void qib_notify_free_mad_agent(struct rvt_dev_info *rdi, int port_idx);
 
 /*
  * Compare the lower 24 bits of the two values.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
