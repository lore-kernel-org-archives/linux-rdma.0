From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [for-next 3/3] RDMA/bnxt_re: setup dscp to priority map
Date: Tue, 22 Aug 2017 07:49:47 -0400
Message-ID: <1503402587-24669-4-git-send-email-devesh.sharma@broadcom.com>
References: <1503402587-24669-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503402587-24669-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch allows bnxt_re driver to map a particular
dscp value to a pre-configured RoCE priority. There
is a DPC which keeps looking for the changes in the
RoCE-priority, if there is any change h/w is updated
with the new settings.

Signed-off-by: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h  |  13 ++
 drivers/infiniband/hw/bnxt_re/configfs.c |  54 ++++++++
 drivers/infiniband/hw/bnxt_re/main.c     | 221 +++++++++++++++++++++++++++++--
 drivers/infiniband/hw/bnxt_re/qplib_sp.c |  56 ++++++++
 drivers/infiniband/hw/bnxt_re/qplib_sp.h |   4 +
 5 files changed, 334 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index ade6698..fbbbea3 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -84,6 +84,12 @@ struct bnxt_re_sqp_entries {
 	struct bnxt_re_qp *qp1_qp;
 };
 
+struct bnxt_re_dscp2pri {
+	u8 dscp;
+	u8 mask;
+	u8 pri;
+};
+
 #define BNXT_RE_MIN_MSIX		2
 #define BNXT_RE_MAX_MSIX		9
 #define BNXT_RE_AEQ_IDX			0
@@ -108,6 +114,7 @@ struct bnxt_re_dev {
 
 	struct delayed_work		worker;
 	u8				cur_prio_map;
+	u8				dscp_prio;
 
 	/* FP Notification Queue (CQ & SRQ) */
 	struct tasklet_struct		nq_task;
@@ -124,6 +131,7 @@ struct bnxt_re_dev {
 	struct bnxt_qplib_res		qplib_res;
 	struct bnxt_qplib_dpi		dpi_privileged;
 	struct bnxt_qplib_cc_param	cc_param;
+	struct mutex			cc_lock;
 
 	atomic_t			qp_count;
 	struct mutex			qp_lock;	/* protect qp list */
@@ -158,4 +166,9 @@ static inline struct device *rdev_to_dev(struct bnxt_re_dev *rdev)
 	return NULL;
 }
 
+int bnxt_re_set_hwrm_dscp2pri(struct bnxt_re_dev *rdev,
+			      struct bnxt_re_dscp2pri *d2p, u16 count);
+int bnxt_re_query_hwrm_dscp2pri(struct bnxt_re_dev *rdev,
+				struct bnxt_re_dscp2pri *d2p, u16 count);
+int bnxt_re_vlan_tx_disable(struct bnxt_re_dev *rdev);
 #endif
diff --git a/drivers/infiniband/hw/bnxt_re/configfs.c b/drivers/infiniband/hw/bnxt_re/configfs.c
index d05e239..e356481 100644
--- a/drivers/infiniband/hw/bnxt_re/configfs.c
+++ b/drivers/infiniband/hw/bnxt_re/configfs.c
@@ -73,6 +73,7 @@ static ssize_t apply_store(struct config_item *item, const char *buf,
 {
 	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
 	struct bnxt_re_dev *rdev;
+	struct bnxt_re_dscp2pri d2p;
 	unsigned int val;
 	int rc = 0;
 
@@ -82,11 +83,30 @@ static ssize_t apply_store(struct config_item *item, const char *buf,
 	rdev = ccgrp->rdev;
 	sscanf(buf, "%x\n", &val);
 	if (val == BNXT_RE_MODIFY_CC) {
+		/* For VLAN transmission disablement */
+		if (rdev->cc_param.mask &
+		    BNXT_QPLIB_CC_PARAM_MASK_VLAN_TX_DISABLE) {
+			rdev->cc_param.mask &=
+				~BNXT_QPLIB_CC_PARAM_MASK_VLAN_TX_DISABLE;
+			rc = bnxt_re_vlan_tx_disable(rdev);
+			if (rc)
+				dev_err(rdev_to_dev(rdev),
+					"Failed to disable VLAN tx\n");
+		}
 		rc = bnxt_qplib_modify_cc(&rdev->qplib_res,
 					  &rdev->cc_param);
 		if (rc)
 			dev_err(rdev_to_dev(rdev),
 				"Failed to apply cc settings\n");
+		mutex_lock(&rdev->cc_lock);
+		d2p.dscp = rdev->cc_param.tos_dscp;
+		d2p.pri = rdev->dscp_prio;
+		mutex_unlock(&rdev->cc_lock);
+		d2p.mask = 0x3F;
+		rc = bnxt_re_set_hwrm_dscp2pri(rdev, &d2p, 1);
+		if (rc)
+			dev_err(rdev_to_dev(rdev),
+				"Failed to updated dscp\n");
 	}
 
 	return rc ? -EINVAL : strnlen(buf, count);
@@ -462,7 +482,9 @@ static ssize_t tos_dscp_store(struct config_item *item, const char *buf,
 	rdev = ccgrp->rdev;
 
 	sscanf(buf, "%x\n", &val);
+	mutex_lock(&rdev->cc_lock);
 	rdev->cc_param.tos_dscp = val & 0xFF;
+	mutex_unlock(&rdev->cc_lock);
 	rdev->cc_param.mask |= CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_TOS_DSCP;
 
 	return strnlen(buf, count);
@@ -500,6 +522,37 @@ static ssize_t tos_ecn_store(struct config_item *item, const char *buf,
 }
 CONFIGFS_ATTR(, tos_ecn);
 
+static ssize_t vlan_tx_disable_show(struct config_item *item, char *buf)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+
+	if (!ccgrp)
+		return -EINVAL;
+
+	rdev = ccgrp->rdev;
+	return sprintf(buf,"%#x\n", rdev->cc_param.vlan_tx_disable);
+}
+
+static ssize_t vlan_tx_disable_store(struct config_item *item, const char *buf,
+				     size_t count)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+	unsigned int val;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+	sscanf(buf, "%x\n", &val);
+	rdev->cc_param.vlan_tx_disable = val & 0x1;
+	rdev->cc_param.mask |= BNXT_QPLIB_CC_PARAM_MASK_VLAN_TX_DISABLE;
+
+	return strnlen(buf, count);
+}
+
+CONFIGFS_ATTR(, vlan_tx_disable);
+
 static struct configfs_attribute *bnxt_re_cc_attrs[] = {
 	&attr_apply,
 	&attr_alt_tos_dscp,
@@ -515,6 +568,7 @@ static ssize_t tos_ecn_store(struct config_item *item, const char *buf,
 	&attr_tcp_cp,
 	&attr_tos_dscp,
 	&attr_tos_ecn,
+	&attr_vlan_tx_disable,
 	NULL,
 };
 
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 6ea3ae8..decb740 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -591,6 +591,7 @@ static struct bnxt_re_dev *bnxt_re_dev_add(struct net_device *netdev,
 	rdev->id = rdev->en_dev->pdev->devfn;
 	INIT_LIST_HEAD(&rdev->qp_list);
 	mutex_init(&rdev->qp_lock);
+	mutex_init(&rdev->cc_lock);
 	atomic_set(&rdev->qp_count, 0);
 	atomic_set(&rdev->cq_count, 0);
 	atomic_set(&rdev->srq_count, 0);
@@ -889,8 +890,11 @@ static int bnxt_re_update_gid(struct bnxt_re_dev *rdev)
 			continue;
 		/* need to modify the VLAN enable setting of non VLAN GID only
 		 * as setting is done for VLAN GID while adding GID
+		 *
+		 * If vlan_tx_disable is enable, then we'll need to remove the
+		 * vlan entry from the sgid_tbl.
 		 */
-		if (sgid_tbl->vlan[index])
+		if (sgid_tbl->vlan[index] && !rdev->cc_param.vlan_tx_disable)
 			continue;
 
 		memcpy(&gid, &sgid_tbl->tbl[index], sizeof(gid));
@@ -902,7 +906,7 @@ static int bnxt_re_update_gid(struct bnxt_re_dev *rdev)
 	return rc;
 }
 
-static u32 bnxt_re_get_priority_mask(struct bnxt_re_dev *rdev)
+static u32 bnxt_re_get_priority_mask(struct bnxt_re_dev *rdev, u8 selector)
 {
 	u32 prio_map = 0, tmp_map = 0;
 	struct net_device *netdev;
@@ -911,15 +915,19 @@ static u32 bnxt_re_get_priority_mask(struct bnxt_re_dev *rdev)
 	netdev = rdev->netdev;
 
 	memset(&app, 0, sizeof(app));
-	app.selector = IEEE_8021QAZ_APP_SEL_ETHERTYPE;
-	app.protocol = ETH_P_IBOE;
-	tmp_map = dcb_ieee_getapp_mask(netdev, &app);
-	prio_map = tmp_map;
+	if (selector & IEEE_8021QAZ_APP_SEL_ETHERTYPE) {
+		app.selector = IEEE_8021QAZ_APP_SEL_ETHERTYPE;
+		app.protocol = ETH_P_IBOE;
+		tmp_map = dcb_ieee_getapp_mask(netdev, &app);
+		prio_map = tmp_map;
+	}
 
-	app.selector = IEEE_8021QAZ_APP_SEL_DGRAM;
-	app.protocol = ROCE_V2_UDP_DPORT;
-	tmp_map = dcb_ieee_getapp_mask(netdev, &app);
-	prio_map |= tmp_map;
+	if (selector & IEEE_8021QAZ_APP_SEL_DGRAM) {
+		app.selector = IEEE_8021QAZ_APP_SEL_DGRAM;
+		app.protocol = ROCE_V2_UDP_DPORT;
+		tmp_map = dcb_ieee_getapp_mask(netdev, &app);
+		prio_map |= tmp_map;
+	}
 
 	return prio_map;
 }
@@ -946,8 +954,9 @@ static int bnxt_re_setup_qos(struct bnxt_re_dev *rdev)
 	int rc;
 
 	/* Get priority for roce */
-	prio_map = bnxt_re_get_priority_mask(rdev);
-
+	prio_map = bnxt_re_get_priority_mask(rdev,
+					     (IEEE_8021QAZ_APP_SEL_ETHERTYPE |
+					      IEEE_8021QAZ_APP_SEL_DGRAM));
 	if (prio_map == rdev->cur_prio_map)
 		return 0;
 	rdev->cur_prio_map = prio_map;
@@ -973,9 +982,188 @@ static int bnxt_re_setup_qos(struct bnxt_re_dev *rdev)
 	 */
 	if ((prio_map == 0 && rdev->qplib_res.prio) ||
 	    (prio_map != 0 && !rdev->qplib_res.prio)) {
-		rdev->qplib_res.prio = prio_map ? true : false;
+		if (!rdev->cc_param.vlan_tx_disable) {
+			rdev->qplib_res.prio = prio_map ? true : false;
+			bnxt_re_update_gid(rdev);
+		}
+	}
+
+	return 0;
+}
+
+int bnxt_re_query_hwrm_dscp2pri(struct bnxt_re_dev *rdev,
+				struct bnxt_re_dscp2pri *d2p, u16 count)
+{
+	struct bnxt_en_dev *en_dev = rdev->en_dev;
+	struct bnxt *bp = netdev_priv(rdev->netdev);
+	struct hwrm_queue_dscp2pri_qcfg_input req = {0};
+	struct hwrm_queue_dscp2pri_qcfg_output resp;
+	struct bnxt_fw_msg fw_msg;
+	struct bnxt_re_dscp2pri *dscp2pri;
+	int i, rc = 0, data_len = 3 * 256; /*FIXME: Hard coding */
+	dma_addr_t dma_handle;
+	u16 entry_cnt = 0;
+	u8 *kmem;
+
+	bnxt_re_init_hwrm_hdr(rdev, (void *)&req,
+			      HWRM_QUEUE_DSCP2PRI_QCFG, -1, -1);
+	req.port_id = bp->pf.port_id;
+	kmem = dma_alloc_coherent(&bp->pdev->dev, data_len, &dma_handle,
+				  GFP_KERNEL);
+	if (!kmem) {
+		dev_err(rdev_to_dev(rdev),
+			"dma_alloc_coherent failure, length = %u\n",
+			(unsigned)data_len);
+		return -ENOMEM;
+	}
+	req.dest_data_addr = cpu_to_le64(dma_handle);
+	req.dest_data_buffer_size = cpu_to_le16(data_len);
+	memset(&fw_msg, 0, sizeof(fw_msg));
+	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
+			    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
+	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, BNXT_ROCE_ULP, &fw_msg);
+	if (rc)
+		goto out;
+
+	/* Upload the DSCP-MASK-PRI tuple(s) */
+	dscp2pri = (struct bnxt_re_dscp2pri *)kmem;
+	entry_cnt = le16_to_cpu(resp.entry_cnt);
+	for (i = 0; i < entry_cnt && i < count; i++) {
+		d2p[i].dscp = dscp2pri->dscp;
+		d2p[i].mask = dscp2pri->mask;
+		d2p[i].pri = dscp2pri->pri;
+		dscp2pri++;
+	}
+out:
+	dma_free_coherent(&bp->pdev->dev, data_len, kmem, dma_handle);
+	return rc;
+}
+
+int bnxt_re_vlan_tx_disable(struct bnxt_re_dev *rdev)
+{
+	/* Remove the VLAN from the GID entry */
+	if (!rdev->cur_prio_map)
+		return 0;
+
+	rdev->qplib_res.prio = false;
+	return bnxt_re_update_gid(rdev);
+}
+
+int bnxt_re_set_hwrm_dscp2pri(struct bnxt_re_dev *rdev,
+			      struct bnxt_re_dscp2pri *d2p, u16 count)
+{
+	struct bnxt_en_dev *en_dev = rdev->en_dev;
+	struct bnxt *bp = netdev_priv(rdev->netdev);
+	struct hwrm_queue_dscp2pri_cfg_input req = {0};
+	struct hwrm_queue_dscp2pri_cfg_output resp;
+	struct bnxt_fw_msg fw_msg;
+	struct bnxt_re_dscp2pri *dscp2pri;
+	int i, rc, data_len = 3 * 256;
+	dma_addr_t dma_handle;
+	u8 *kmem;
+
+	bnxt_re_init_hwrm_hdr(rdev, (void *)&req,
+			      HWRM_QUEUE_DSCP2PRI_CFG, -1, -1);
+	req.port_id = bp->pf.port_id;
+	kmem = dma_alloc_coherent(&bp->pdev->dev, data_len, &dma_handle,
+				  GFP_KERNEL);
+	if (!kmem) {
+		dev_err(rdev_to_dev(rdev),
+			"dma_alloc_coherent failure, length = %u\n",
+			(unsigned)data_len);
+		return -ENOMEM;
+	}
+	req.src_data_addr = cpu_to_le64(dma_handle);
+
+	/* Download the DSCP-MASK-PRI tuple(s) */
+	dscp2pri = (struct bnxt_re_dscp2pri *)kmem;
+	for (i = 0; i < count; i++) {
+		dscp2pri->dscp = d2p[i].dscp;
+		dscp2pri->mask = d2p[i].mask;
+		dscp2pri->pri = d2p[i].pri;
+		dscp2pri++;
+	}
+
+	req.entry_cnt = cpu_to_le16(count);
+	memset(&fw_msg, 0, sizeof(fw_msg));
+	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
+			    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
+	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, BNXT_ROCE_ULP, &fw_msg);
+	dma_free_coherent(&bp->pdev->dev, data_len, kmem, dma_handle);
+	return rc;
+}
+
+static u8 bnxt_re_get_prio(u8 prio_map)
+{
+	u8 prio = 0;
+
+	for (prio = 0; prio < 8; prio++) {
+		if (prio_map & (1UL << prio))
+			break;
+	}
+
+	return prio;
+}
+
+static int bnxt_re_setup_dscp(struct bnxt_re_dev *rdev, u8 need_init)
+{
+	u8 prio_map = 0, pri;
+	struct bnxt_re_dscp2pri d2p;
+	int rc;
+
+	prio_map = bnxt_re_get_priority_mask(rdev, IEEE_8021QAZ_APP_SEL_DGRAM);
+	if (!prio_map) {
+		dev_dbg(rdev_to_dev(rdev), "no priority to map\n");
+		if (need_init) {
+			rdev->cc_param.mask = 0;
+			rc = bnxt_qplib_init_cc_param(&rdev->qplib_res,
+						      &rdev->cc_param);
+			if (rc)
+				dev_warn(rdev_to_dev(rdev),
+					 "init cc failed rc = 0x%x\n", rc);
+		}
+		return 0;
+	}
+
+	pri = bnxt_re_get_prio(prio_map);
+
+	rc = bnxt_re_query_hwrm_dscp2pri(rdev, &d2p, 1);
+	if (rc) {
+		dev_warn(rdev_to_dev(rdev), "query dscp config failed\n");
+		return rc;
+	}
 
-		bnxt_re_update_gid(rdev);
+	if (need_init) {
+		rdev->cc_param.alt_vlan_pcp = pri;
+		rdev->cc_param.mask |=
+			CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_ALT_VLAN_PCP;
+		rdev->cc_param.alt_tos_dscp = d2p.dscp;
+		rdev->cc_param.mask |=
+			CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_ALT_TOS_DSCP;
+		rdev->cc_param.tos_dscp = d2p.dscp;
+		rdev->cc_param.mask |=
+			CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_TOS_DSCP;
+		rc = bnxt_qplib_init_cc_param(&rdev->qplib_res,
+					      &rdev->cc_param);
+		if (rc)
+			dev_warn(rdev_to_dev(rdev), "init cc failed\n");
+	}
+
+	mutex_lock(&rdev->cc_lock);
+	if ((pri == rdev->dscp_prio) && (rdev->cc_param.tos_dscp == d2p.dscp)) {
+		mutex_unlock(&rdev->cc_lock);
+		return 0;
+	}
+	d2p.dscp = rdev->cc_param.tos_dscp;
+	rdev->dscp_prio = pri;
+	d2p.pri = rdev->dscp_prio;
+	mutex_unlock(&rdev->cc_lock);
+	d2p.mask = 0x3F;
+
+	rc = bnxt_re_set_hwrm_dscp2pri(rdev, &d2p, 1);
+	if (rc) {
+		dev_warn(rdev_to_dev(rdev), "no dscp for prio %d\n", d2p.pri);
+		return rc;
 	}
 
 	return 0;
@@ -1044,6 +1232,7 @@ static void bnxt_re_worker(struct work_struct *work)
 						worker.work);
 
 	bnxt_re_setup_qos(rdev);
+	bnxt_re_setup_dscp(rdev, false);
 	schedule_delayed_work(&rdev->worker, msecs_to_jiffies(30000));
 }
 
@@ -1136,6 +1325,10 @@ static int bnxt_re_ib_reg(struct bnxt_re_dev *rdev)
 	if (rc)
 		pr_info("RoCE priority not yet configured\n");
 
+	rc = bnxt_re_setup_dscp(rdev, true);
+	if (rc)
+		pr_info("DSCP init failed, may not be functional.\n");
+
 	INIT_DELAYED_WORK(&rdev->worker, bnxt_re_worker);
 	set_bit(BNXT_RE_FLAG_QOS_WORK_REG, &rdev->flags);
 	schedule_delayed_work(&rdev->worker, msecs_to_jiffies(30000));
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index 2438477..1e7889c 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -762,3 +762,59 @@ int bnxt_qplib_modify_cc(struct bnxt_qplib_res *res,
 					  (void *)&resp, NULL, 0);
 	return rc;
 }
+
+int bnxt_qplib_init_cc_param(struct bnxt_qplib_res *res,
+			     struct bnxt_qplib_cc_param *cc_param)
+{
+	struct bnxt_qplib_rcfw *rcfw = res->rcfw;
+	struct cmdq_query_roce_cc req;
+	struct creq_query_roce_cc_resp resp;
+	struct bnxt_qplib_rcfw_sbuf *sbuf;
+	struct creq_query_roce_cc_resp_sb *sb;
+	u16 cmd_flags = 0;
+	int rc;
+
+	/* Query the parameters from chip */
+	RCFW_CMD_PREP(req, QUERY_CC, cmd_flags);
+	sbuf = bnxt_qplib_rcfw_alloc_sbuf(rcfw, sizeof(*sb));
+	if (!sbuf) {
+		dev_warn(&res->pdev->dev, "init cc no buffer\n");
+		return -ENOMEM;
+	}
+
+	sb = sbuf->sb;
+	req.resp_size = sizeof(*sb) / BNXT_QPLIB_CMDQE_UNITS;
+	rc = bnxt_qplib_rcfw_send_message(res->rcfw, (void *)&req,
+					  (void *)&resp, (void *)sbuf, 0);
+	if (rc) {
+		dev_warn(&res->pdev->dev, "QUERY_ROCE_CC error\n");
+		goto out;
+	}
+	cc_param->enable = sb->enable_cc & CREQ_QUERY_ROCE_CC_RESP_SB_ENABLE_CC;
+	cc_param->tos_ecn = (sb->tos_dscp_tos_ecn &
+			     CREQ_QUERY_ROCE_CC_RESP_SB_TOS_ECN_MASK) >>
+			     CREQ_QUERY_ROCE_CC_RESP_SB_TOS_ECN_SFT;
+	cc_param->tos_dscp = (sb->tos_dscp_tos_ecn &
+			      CREQ_QUERY_ROCE_CC_RESP_SB_TOS_DSCP_MASK) >>
+			      CREQ_QUERY_ROCE_CC_RESP_SB_TOS_DSCP_SFT;
+	cc_param->g = (sb->g & CREQ_QUERY_ROCE_CC_RESP_SB_G_MASK) >>
+		       CREQ_QUERY_ROCE_CC_RESP_SB_G_SFT;
+	cc_param->nph_per_state = sb->num_phases_per_state;
+	cc_param->init_cr = le16_to_cpu(sb->init_cr);
+	cc_param->init_tr = le16_to_cpu(sb->init_tr);
+
+	/* There's currently no way to extract these values so we are
+	 * initializing them to driver defaults
+	 */
+	cc_param->cc_mode = 0;
+	cc_param->inact_th = 0x1388;
+	cc_param->rtt = 0x64;
+	cc_param->tcp_cp = 0;
+	cc_param->mask |= (CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_CC_MODE |
+			   CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_INACTIVITY_CP |
+			   CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_RTT |
+			   CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_TCP_CP);
+	rc = bnxt_qplib_modify_cc(res, cc_param);
+out:
+	return rc;
+}
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.h b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
index 87173701..0d6496f 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
@@ -133,7 +133,9 @@ struct bnxt_qplib_cc_param {
 	u8 tos_ecn;
 	u8 tos_dscp;
 	u16 tcp_cp;
+	u8 vlan_tx_disable;
 	u32 mask;
+#define BNXT_QPLIB_CC_PARAM_MASK_VLAN_TX_DISABLE	0x4000
 };
 
 #define BNXT_QPLIB_ACCESS_LOCAL_WRITE	BIT(0)
@@ -183,4 +185,6 @@ int bnxt_qplib_free_fast_reg_page_list(struct bnxt_qplib_res *res,
 int bnxt_qplib_map_tc2cos(struct bnxt_qplib_res *res, u16 *cids);
 int bnxt_qplib_modify_cc(struct bnxt_qplib_res *res,
 			 struct bnxt_qplib_cc_param *cc_param);
+int bnxt_qplib_init_cc_param(struct bnxt_qplib_res *res,
+			     struct bnxt_qplib_cc_param *cc_param);
 #endif /* __BNXT_QPLIB_SP_H__*/
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
