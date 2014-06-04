From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 02/15] RDMA/ocrdma: Query and initalize the PFC SL
Date: Wed, 4 Jun 2014 23:49:02 +0530
Message-ID: <1a37ae20-3265-4252-9c5a-f611bc4af7e2@CMEXHTCAS1.ad.emulex.com>
References: <1401905955-28117-1-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-2-git-send-email-selvin.xavier@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1401905955-28117-2-git-send-email-selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Query the PFC service level configured on the adapter

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h      |   21 ++++
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c   |    2 +
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c   |  172 ++++++++++++++++++++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h   |    2 +
 drivers/infiniband/hw/ocrdma/ocrdma_main.c |    1 +
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h  |   81 +++++++++++++-
 6 files changed, 278 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 19011db..5cd65c2 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -236,6 +236,9 @@ struct ocrdma_dev {
 	struct rcu_head rcu;
 	int id;
 	u64 stag_arr[OCRDMA_MAX_STAG];
+	u8 sl; /* service level */
+	bool pfc_state;
+	atomic_t update_sl;
 	u16 pvid;
 	u32 asic_id;
 
@@ -518,4 +521,22 @@ static inline u8 ocrdma_get_asic_type(struct ocrdma_dev *dev)
 				OCRDMA_SLI_ASIC_GEN_NUM_SHIFT;
 }
 
+static inline u8 ocrdma_get_pfc_prio(u8 *pfc, u8 prio)
+{
+	return *(pfc + prio);
+}
+
+static inline u8 ocrdma_get_app_prio(u8 *app_prio, u8 prio)
+{
+	return *(app_prio + prio);
+}
+
+static inline u8 ocrdma_is_enabled_and_synced(u32 state)
+{	/* May also be used to interpret TC-state, QCN-state
+	 * Appl-state and Logical-link-state in future.
+	 */
+	return (state & OCRDMA_STATE_FLAG_ENABLED) &&
+		(state & OCRDMA_STATE_FLAG_SYNC);
+}
+
 #endif
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index d4cc01f..a023234 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -100,6 +100,8 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 	if (!(attr->ah_flags & IB_AH_GRH))
 		return ERR_PTR(-EINVAL);
 
+	if (atomic_cmpxchg(&dev->update_sl, 1, 0))
+		ocrdma_init_service_level(dev);
 	ah = kzalloc(sizeof(*ah), GFP_ATOMIC);
 	if (!ah)
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index bce4adf..e6463cb 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -771,6 +771,10 @@ static void ocrdma_process_grp5_aync(struct ocrdma_dev *dev,
 					OCRDMA_AE_PVID_MCQE_TAG_MASK) >>
 					OCRDMA_AE_PVID_MCQE_TAG_SHIFT);
 		break;
+
+	case OCRDMA_ASYNC_EVENT_COS_VALUE:
+		atomic_set(&dev->update_sl, 1);
+		break;
 	default:
 		/* Not interested evts. */
 		break;
@@ -2265,6 +2269,8 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 
 	if ((ah_attr->ah_flags & IB_AH_GRH) == 0)
 		return -EINVAL;
+	if (atomic_cmpxchg(&qp->dev->update_sl, 1, 0))
+		ocrdma_init_service_level(qp->dev);
 	cmd->params.tclass_sq_psn |=
 	    (ah_attr->grh.traffic_class << OCRDMA_QP_PARAMS_TCLASS_SHIFT);
 	cmd->params.rnt_rc_sl_fl |=
@@ -2298,6 +2304,10 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 		cmd->params.vlan_dmac_b4_to_b5 |=
 		    vlan_id << OCRDMA_QP_PARAMS_VLAN_SHIFT;
 		cmd->flags |= OCRDMA_QP_PARA_VLAN_EN_VALID;
+		/* override the sl with default priority if 0 */
+		cmd->params.rnt_rc_sl_fl |=
+			(ah_attr->sl ? ah_attr->sl :
+				qp->dev->sl) << OCRDMA_QP_PARAMS_SL_SHIFT;
 	}
 	return 0;
 }
@@ -2605,6 +2615,168 @@ int ocrdma_mbx_destroy_srq(struct ocrdma_dev *dev, struct ocrdma_srq *srq)
 	return status;
 }
 
+static int ocrdma_mbx_get_dcbx_config(struct ocrdma_dev *dev, u32 ptype,
+				      struct ocrdma_dcbx_cfg *dcbxcfg)
+{
+	int status = 0;
+	dma_addr_t pa;
+	struct ocrdma_mqe cmd;
+
+	struct ocrdma_get_dcbx_cfg_req *req = NULL;
+	struct ocrdma_get_dcbx_cfg_rsp *rsp = NULL;
+	struct pci_dev *pdev = dev->nic_info.pdev;
+	struct ocrdma_mqe_sge *mqe_sge = cmd.u.nonemb_req.sge;
+
+	memset(&cmd, 0, sizeof(struct ocrdma_mqe));
+	cmd.hdr.pyld_len = max_t (u32, sizeof(struct ocrdma_get_dcbx_cfg_rsp),
+					sizeof(struct ocrdma_get_dcbx_cfg_req));
+	req = dma_alloc_coherent(&pdev->dev, cmd.hdr.pyld_len, &pa, GFP_KERNEL);
+	if (!req) {
+		status = -ENOMEM;
+		goto mem_err;
+	}
+
+	cmd.hdr.spcl_sge_cnt_emb |= (1 << OCRDMA_MQE_HDR_SGE_CNT_SHIFT) &
+					OCRDMA_MQE_HDR_SGE_CNT_MASK;
+	mqe_sge->pa_lo = (u32) (pa & 0xFFFFFFFFUL);
+	mqe_sge->pa_hi = (u32) upper_32_bits(pa);
+	mqe_sge->len = cmd.hdr.pyld_len;
+
+	memset(req, 0, sizeof(struct ocrdma_get_dcbx_cfg_req));
+	ocrdma_init_mch(&req->hdr, OCRDMA_CMD_GET_DCBX_CONFIG,
+			OCRDMA_SUBSYS_DCBX, cmd.hdr.pyld_len);
+	req->param_type = ptype;
+
+	status = ocrdma_mbx_cmd(dev, &cmd);
+	if (status)
+		goto mbx_err;
+
+	rsp = (struct ocrdma_get_dcbx_cfg_rsp *)req;
+	ocrdma_le32_to_cpu(rsp, sizeof(struct ocrdma_get_dcbx_cfg_rsp));
+	memcpy(dcbxcfg, &rsp->cfg, sizeof(struct ocrdma_dcbx_cfg));
+
+mbx_err:
+	dma_free_coherent(&pdev->dev, cmd.hdr.pyld_len, req, pa);
+mem_err:
+	return status;
+}
+
+#define OCRDMA_MAX_SERVICE_LEVEL_INDEX	0x08
+#define OCRDMA_DEFAULT_SERVICE_LEVEL	0x05
+
+static int ocrdma_parse_dcbxcfg_rsp(struct ocrdma_dev *dev, int ptype,
+				    struct ocrdma_dcbx_cfg *dcbxcfg,
+				    u8 *srvc_lvl)
+{
+	int status = -EINVAL, indx, slindx;
+	int ventry_cnt;
+	struct ocrdma_app_parameter *app_param;
+	u8 valid, proto_sel;
+	u8 app_prio, pfc_prio;
+	u16 proto;
+
+	if (!(dcbxcfg->tcv_aev_opv_st & OCRDMA_DCBX_STATE_MASK)) {
+		pr_info("%s ocrdma%d DCBX is disabled\n",
+			dev_name(&dev->nic_info.pdev->dev), dev->id);
+		goto out;
+	}
+
+	if (!ocrdma_is_enabled_and_synced(dcbxcfg->pfc_state)) {
+		pr_info("%s ocrdma%d priority flow control(%s) is %s%s\n",
+			dev_name(&dev->nic_info.pdev->dev), dev->id,
+			(ptype > 0 ? "operational" : "admin"),
+			(dcbxcfg->pfc_state & OCRDMA_STATE_FLAG_ENABLED) ?
+			"enabled" : "disabled",
+			(dcbxcfg->pfc_state & OCRDMA_STATE_FLAG_SYNC) ?
+			"" : ", not sync'ed");
+		goto out;
+	} else {
+		pr_info("%s ocrdma%d priority flow control is enabled and sync'ed\n",
+			dev_name(&dev->nic_info.pdev->dev), dev->id);
+	}
+
+	ventry_cnt = (dcbxcfg->tcv_aev_opv_st >>
+				OCRDMA_DCBX_APP_ENTRY_SHIFT)
+				& OCRDMA_DCBX_STATE_MASK;
+
+	for (indx = 0; indx < ventry_cnt; indx++) {
+		app_param = &dcbxcfg->app_param[indx];
+		valid = (app_param->valid_proto_app >>
+				OCRDMA_APP_PARAM_VALID_SHIFT)
+				& OCRDMA_APP_PARAM_VALID_MASK;
+		proto_sel = (app_param->valid_proto_app
+				>>  OCRDMA_APP_PARAM_PROTO_SEL_SHIFT)
+				& OCRDMA_APP_PARAM_PROTO_SEL_MASK;
+		proto = app_param->valid_proto_app &
+				OCRDMA_APP_PARAM_APP_PROTO_MASK;
+
+		if (
+			valid && proto == OCRDMA_APP_PROTO_ROCE &&
+			proto_sel == OCRDMA_PROTO_SELECT_L2) {
+			for (slindx = 0; slindx <
+				OCRDMA_MAX_SERVICE_LEVEL_INDEX; slindx++) {
+				app_prio = ocrdma_get_app_prio(
+						(u8 *)app_param->app_prio,
+						slindx);
+				pfc_prio = ocrdma_get_pfc_prio(
+						(u8 *)dcbxcfg->pfc_prio,
+						slindx);
+
+				if (app_prio && pfc_prio) {
+					*srvc_lvl = slindx;
+					status = 0;
+					goto out;
+				}
+			}
+			if (slindx == OCRDMA_MAX_SERVICE_LEVEL_INDEX) {
+				pr_info("%s ocrdma%d application priority not set for 0x%x protocol\n",
+					dev_name(&dev->nic_info.pdev->dev),
+					dev->id, proto);
+			}
+		}
+	}
+
+out:
+	return status;
+}
+
+void ocrdma_init_service_level(struct ocrdma_dev *dev)
+{
+	int status = 0, indx;
+	struct ocrdma_dcbx_cfg dcbxcfg;
+	u8 srvc_lvl = OCRDMA_DEFAULT_SERVICE_LEVEL;
+	int ptype = OCRDMA_PARAMETER_TYPE_OPER;
+
+	for (indx = 0; indx < 2; indx++) {
+		status = ocrdma_mbx_get_dcbx_config(dev, ptype, &dcbxcfg);
+		if (status) {
+			pr_err("%s(): status=%d\n", __func__, status);
+			ptype = OCRDMA_PARAMETER_TYPE_ADMIN;
+			continue;
+		}
+
+		status = ocrdma_parse_dcbxcfg_rsp(dev, ptype,
+						  &dcbxcfg, &srvc_lvl);
+		if (status) {
+			ptype = OCRDMA_PARAMETER_TYPE_ADMIN;
+			continue;
+		}
+
+		break;
+	}
+
+	if (status)
+		pr_info("%s ocrdma%d service level default\n",
+			dev_name(&dev->nic_info.pdev->dev), dev->id);
+	else
+		pr_info("%s ocrdma%d service level %d\n",
+			dev_name(&dev->nic_info.pdev->dev), dev->id,
+			srvc_lvl);
+
+	dev->pfc_state = ocrdma_is_enabled_and_synced(dcbxcfg.pfc_state);
+	dev->sl = srvc_lvl;
+}
+
 int ocrdma_alloc_av(struct ocrdma_dev *dev, struct ocrdma_ah *ah)
 {
 	int i;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.h b/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
index e513f72..6eed8f1 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
@@ -135,4 +135,6 @@ int ocrdma_get_irq(struct ocrdma_dev *dev, struct ocrdma_eq *eq);
 
 int ocrdma_mbx_rdma_stats(struct ocrdma_dev *, bool reset);
 char *port_speed_string(struct ocrdma_dev *dev);
+void ocrdma_init_service_level(struct ocrdma_dev *);
+
 #endif				/* __OCRDMA_HW_H__ */
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 7c504e0..9368d52 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -399,6 +399,7 @@ static struct ocrdma_dev *ocrdma_add(struct be_dev_info *dev_info)
 	if (status)
 		goto alloc_err;
 
+	ocrdma_init_service_level(dev);
 	status = ocrdma_register_device(dev);
 	if (status)
 		goto alloc_err;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 96c9ee6..4defae8 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -422,7 +422,12 @@ struct ocrdma_ae_qp_mcqe {
 
 #define OCRDMA_ASYNC_RDMA_EVE_CODE 0x14
 #define OCRDMA_ASYNC_GRP5_EVE_CODE 0x5
-#define OCRDMA_ASYNC_EVENT_PVID_STATE 0x3
+
+enum ocrdma_async_grp5_events {
+	OCRDMA_ASYNC_EVENT_QOS_VALUE	= 0x01,
+	OCRDMA_ASYNC_EVENT_COS_VALUE	= 0x02,
+	OCRDMA_ASYNC_EVENT_PVID_STATE	= 0x03
+};
 
 enum OCRDMA_ASYNC_EVENT_TYPE {
 	OCRDMA_CQ_ERROR			= 0x00,
@@ -1949,5 +1954,79 @@ struct ocrdma_get_ctrl_attribs_rsp {
 	struct mgmt_controller_attrib ctrl_attribs;
 };
 
+#define OCRDMA_SUBSYS_DCBX 0x10
+
+enum OCRDMA_DCBX_OPCODE {
+	OCRDMA_CMD_GET_DCBX_CONFIG = 0x01
+};
+
+enum OCRDMA_DCBX_PARAM_TYPE {
+	OCRDMA_PARAMETER_TYPE_ADMIN	= 0x00,
+	OCRDMA_PARAMETER_TYPE_OPER	= 0x01,
+	OCRDMA_PARAMETER_TYPE_PEER	= 0x02
+};
+
+enum OCRDMA_DCBX_APP_PROTO {
+	OCRDMA_APP_PROTO_ROCE	= 0x8915
+};
+
+enum OCRDMA_DCBX_PROTO {
+	OCRDMA_PROTO_SELECT_L2	= 0x00,
+	OCRDMA_PROTO_SELECT_L4	= 0x01
+};
+
+enum OCRDMA_DCBX_APP_PARAM {
+	OCRDMA_APP_PARAM_APP_PROTO_MASK = 0xFFFF,
+	OCRDMA_APP_PARAM_PROTO_SEL_MASK = 0xFF,
+	OCRDMA_APP_PARAM_PROTO_SEL_SHIFT = 0x10,
+	OCRDMA_APP_PARAM_VALID_MASK	= 0xFF,
+	OCRDMA_APP_PARAM_VALID_SHIFT	= 0x18
+};
+
+enum OCRDMA_DCBX_STATE_FLAGS {
+	OCRDMA_STATE_FLAG_ENABLED	= 0x01,
+	OCRDMA_STATE_FLAG_ADDVERTISED	= 0x02,
+	OCRDMA_STATE_FLAG_WILLING	= 0x04,
+	OCRDMA_STATE_FLAG_SYNC		= 0x08,
+	OCRDMA_STATE_FLAG_UNSUPPORTED	= 0x40000000,
+	OCRDMA_STATE_FLAG_NEG_FAILD	= 0x80000000
+};
+
+enum OCRDMA_TCV_AEV_OPV_ST {
+	OCRDMA_DCBX_TC_SUPPORT_MASK	= 0xFF,
+	OCRDMA_DCBX_TC_SUPPORT_SHIFT	= 0x18,
+	OCRDMA_DCBX_APP_ENTRY_SHIFT	= 0x10,
+	OCRDMA_DCBX_OP_PARAM_SHIFT	= 0x08,
+	OCRDMA_DCBX_STATE_MASK		= 0xFF
+};
+
+struct ocrdma_app_parameter {
+	u32 valid_proto_app;
+	u32 oui;
+	u32 app_prio[2];
+};
+
+struct ocrdma_dcbx_cfg {
+	u32 tcv_aev_opv_st;
+	u32 tc_state;
+	u32 pfc_state;
+	u32 qcn_state;
+	u32 appl_state;
+	u32 ll_state;
+	u32 tc_bw[2];
+	u32 tc_prio[8];
+	u32 pfc_prio[2];
+	struct ocrdma_app_parameter app_param[15];
+};
+
+struct ocrdma_get_dcbx_cfg_req {
+	struct ocrdma_mbx_hdr hdr;
+	u32 param_type;
+} __packed;
+
+struct ocrdma_get_dcbx_cfg_rsp {
+	struct ocrdma_mbx_rsp hdr;
+	struct ocrdma_dcbx_cfg cfg;
+} __packed;
 
 #endif				/* __OCRDMA_SLI_H__ */
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
