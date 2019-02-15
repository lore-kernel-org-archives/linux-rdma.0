From: Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [RFC v1 04/19] RDMA/irdma: Add driver framework definitions
Date: Fri, 15 Feb 2019 11:10:51 -0600
Message-ID: <20190215171107.6464-5-shiraz.saleem@intel.com>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190215171107.6464-1-shiraz.saleem@intel.com>
Sender: netdev-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca, davem@davemloft.net
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com, Shiraz Saleem <shiraz.saleem@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail@intel.com>

Add definitions to setup irdma as a module, establish the
interface with all recognized LAN peers, initialize HW,
and register to receive netdev notifications

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/irdma/i40iw_if.c | 250 ++++++++++++
 drivers/infiniband/hw/irdma/irdma_if.c | 430 ++++++++++++++++++++
 drivers/infiniband/hw/irdma/main.c     | 489 +++++++++++++++++++++++
 drivers/infiniband/hw/irdma/main.h     | 709 +++++++++++++++++++++++++++++++++
 4 files changed, 1878 insertions(+)
 create mode 100644 drivers/infiniband/hw/irdma/i40iw_if.c
 create mode 100644 drivers/infiniband/hw/irdma/irdma_if.c
 create mode 100644 drivers/infiniband/hw/irdma/main.c
 create mode 100644 drivers/infiniband/hw/irdma/main.h

diff --git a/drivers/infiniband/hw/irdma/i40iw_if.c b/drivers/infiniband/hw/irdma/i40iw_if.c
new file mode 100644
index 0000000..782ea61
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/i40iw_if.c
@@ -0,0 +1,250 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2019, Intel Corporation. */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <net/addrconf.h>
+#include "main.h"
+#include "i40iw_hw.h"
+#include "i40e_client.h"
+#define CLIENT_IW_INTERFACE_VERSION_MAJOR 0
+#define CLIENT_IW_INTERFACE_VERSION_MINOR 01
+#define CLIENT_IW_INTERFACE_VERSION_BUILD 00
+
+/**
+ * i40iw_request_reset - Request a reset
+ * @rf: RDMA PCI function
+ *
+ */
+void i40iw_request_reset(struct irdma_pci_f *rf)
+{
+	struct i40e_info *ldev = (struct i40e_info *)rf->ldev.if_ldev;
+
+	ldev->ops->request_reset(ldev, rf->ldev.if_client, 1);
+}
+
+/**
+ * i40iw_open - client interface operation open for iwarp/uda device
+ * @ldev: lan device information
+ * @client: iwarp client information, provided during registration
+ *
+ * Called by the lan driver during the processing of client register
+ * Create device resources, set up queues, pble and hmc objects and
+ * register the device with the ib verbs interface
+ * Return 0 if successful, otherwise return error
+ */
+static int i40iw_open(struct i40e_info *ldev, struct i40e_client *client)
+{
+	struct irdma_device *iwdev = NULL;
+	struct irdma_handler *hdl = NULL;
+	struct irdma_priv_ldev   *pldev;
+	struct irdma_sc_dev *dev;
+	struct irdma_pci_f *rf;
+	struct irdma_l2params l2params = {};
+	int err_code = -EIO;
+	int i;
+	u16 qset;
+	u16 last_qset = IRDMA_NO_QSET;
+
+	hdl = irdma_find_handler(ldev->pcidev);
+	if (hdl)
+		return 0;
+
+	hdl = kzalloc((sizeof(*hdl) + sizeof(*iwdev)), GFP_KERNEL);
+	if (!hdl)
+		return -ENOMEM;
+
+	iwdev = (struct irdma_device *)((u8 *)hdl + sizeof(*hdl));
+
+	iwdev->param_wq = alloc_ordered_workqueue("l2params", WQ_MEM_RECLAIM);
+	if (!iwdev->param_wq)
+		goto error;
+
+	rf = &hdl->rf;
+	rf->hdl = hdl;
+	dev = &rf->sc_dev;
+	dev->back_dev = rf;
+	rf->rdma_ver = IRDMA_GEN_1;
+	irdma_init_rf_params(rf);
+	rf->init_hw = i40iw_init_hw;
+	rf->hw.hw_addr = ldev->hw_addr;
+	rf->pdev = ldev->pcidev;
+	rf->netdev = ldev->netdev;
+
+	iwdev->rf = rf;
+	iwdev->hdl = hdl;
+	iwdev->ldev = &rf->ldev;
+	iwdev->init_state = INITIAL_STATE;
+	iwdev->rcv_wnd = IRDMA_CM_DEFAULT_RCV_WND_SCALED;
+	iwdev->rcv_wscale = IRDMA_CM_DEFAULT_RCV_WND_SCALE;
+	iwdev->netdev = ldev->netdev;
+	iwdev->create_ilq = true;
+	iwdev->vsi_num = 0;
+
+	pldev = &rf->ldev;
+	hdl->ldev = pldev;
+	pldev->if_client = client;
+	pldev->if_ldev = ldev;
+	pldev->fn_num = ldev->fid;
+	pldev->ftype = ldev->ftype;
+	pldev->pf_vsi_num = 0;
+	pldev->msix_count = ldev->msix_count;
+	pldev->msix_entries = ldev->msix_entries;
+
+	if (irdma_ctrl_init_hw(rf))
+		goto error;
+
+	l2params.mtu =
+		(ldev->params.mtu) ? ldev->params.mtu : IRDMA_DEFAULT_MTU;
+	for (i = 0; i < I40E_CLIENT_MAX_USER_PRIORITY; i++) {
+		qset = ldev->params.qos.prio_qos[i].qs_handle;
+		l2params.up2tc[i] = ldev->params.qos.prio_qos[i].tc;
+		l2params.qs_handle_list[i] = qset;
+		if (last_qset == IRDMA_NO_QSET)
+			last_qset = qset;
+		else if ((qset != last_qset) && (qset != IRDMA_NO_QSET))
+			iwdev->dcb = true;
+	}
+
+	if (irdma_rt_init_hw(rf, iwdev, &l2params)) {
+		irdma_deinit_ctrl_hw(rf);
+		goto error;
+	}
+
+	irdma_add_handler(hdl);
+	irdma_probe_inc_ref(ldev->netdev);
+	return 0;
+error:
+	kfree(hdl);
+	return err_code;
+}
+
+/**
+ * i40iw_l2params_worker - worker for l2 params change
+ * @work: work pointer for l2 params
+ */
+static void i40iw_l2params_worker(struct work_struct *work)
+{
+	struct l2params_work *dwork =
+	    container_of(work, struct l2params_work, work);
+	struct irdma_device *iwdev = dwork->iwdev;
+
+	irdma_change_l2params(&iwdev->vsi, &dwork->l2params);
+	atomic_dec(&iwdev->params_busy);
+	kfree(work);
+}
+
+/**
+ * i40iw_l2param_change - handle qs handles for qos and mss change
+ * @ldev: lan device information
+ * @client: client for parameter change
+ * @params: new parameters from L2
+ */
+static void i40iw_l2param_change(struct i40e_info *ldev, struct i40e_client *client,
+				 struct i40e_params *params)
+{
+	struct irdma_handler *hdl;
+	struct irdma_l2params *l2params;
+	struct l2params_work *work;
+	struct irdma_device *iwdev;
+	int i;
+
+	hdl = irdma_find_handler(ldev->pcidev);
+	if (!hdl)
+		return;
+
+	iwdev = (struct irdma_device *)((u8 *)hdl + sizeof(*hdl));
+
+	if (atomic_read(&iwdev->params_busy))
+		return;
+	work = kzalloc(sizeof(*work), GFP_KERNEL);
+	if (!work)
+		return;
+
+	atomic_inc(&iwdev->params_busy);
+	work->iwdev = iwdev;
+	l2params = &work->l2params;
+	for (i = 0; i < I40E_CLIENT_MAX_USER_PRIORITY; i++)
+		l2params->qs_handle_list[i] = params->qos.prio_qos[i].qs_handle;
+
+	l2params->mtu = (params->mtu) ? params->mtu : iwdev->vsi.mtu;
+
+	INIT_WORK(&work->work, i40iw_l2params_worker);
+	queue_work(iwdev->param_wq, &work->work);
+}
+
+/**
+ * i40iw_close - client interface operation close for iwarp/uda device
+ * @ldev: lan device information
+ * @client: client to close
+ *
+ * Called by the lan driver during the processing of client unregister
+ * Destroy and clean up the driver resources
+ */
+static void i40iw_close(struct i40e_info *ldev, struct i40e_client *client, bool reset)
+{
+	struct irdma_handler *hdl;
+	struct irdma_pci_f *rf;
+	struct irdma_device *iwdev;
+
+	hdl = irdma_find_handler(ldev->pcidev);
+	if (!hdl)
+		return;
+	rf = &hdl->rf;
+	iwdev = (struct irdma_device *)((u8 *)hdl + sizeof(*hdl));
+	iwdev->closing = true;
+
+	if (iwdev->param_wq)
+		destroy_workqueue(iwdev->param_wq);
+
+	if (reset)
+		iwdev->reset = true;
+
+	irdma_deinit_rt_device(iwdev);
+	irdma_deinit_ctrl_hw(rf);
+	irdma_del_handler(irdma_find_handler(ldev->pcidev));
+	kfree(hdl);
+	irdma_probe_dec_ref(ldev->netdev);
+	irdma_pr_info("IRDMA hardware deinitialization complete\n");
+}
+
+/* client interface functions */
+static const struct i40e_client_ops i40e_ops = {
+	.open = i40iw_open,
+	.close = i40iw_close,
+	.l2_param_change = i40iw_l2param_change,
+	.virtchnl_receive = NULL,
+	.vf_reset = NULL,
+	.vf_enable = NULL,
+	.vf_capable = NULL
+};
+
+static struct i40e_client i40iw_client = {
+	.version.major = CLIENT_IW_INTERFACE_VERSION_MAJOR,
+	.version.minor = CLIENT_IW_INTERFACE_VERSION_MINOR,
+	.version.build = CLIENT_IW_INTERFACE_VERSION_BUILD,
+	.ops = &i40e_ops,
+	.name = "irdma",
+	.type = I40E_CLIENT_IWARP,
+};
+
+int i40iw_reg_peer_driver(struct irdma_peer *peer, struct net_device *netdev)
+{
+	struct idc_srv_provider *sp;
+
+	sp = (struct idc_srv_provider *)netdev_priv(netdev);
+	if (sp->signature != IDC_SIGNATURE)
+		return -EINVAL;
+
+	peer->reg_peer_driver = (int (*)(void *))sp->reg_peer_driver;
+	peer->unreg_peer_driver = (int (*)(void *))sp->unreg_peer_driver;
+
+	return peer->reg_peer_driver(&i40iw_client);
+}
+
+void i40iw_unreg_peer_driver(struct irdma_peer *peer)
+{
+	peer->unreg_peer_driver(&i40iw_client);
+}
diff --git a/drivers/infiniband/hw/irdma/irdma_if.c b/drivers/infiniband/hw/irdma/irdma_if.c
new file mode 100644
index 0000000..f7b89e9
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/irdma_if.c
@@ -0,0 +1,430 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2019, Intel Corporation. */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <ice_idc.h>
+#include "main.h"
+#include "ws.h"
+#include "icrdma_hw.h"
+
+void irdma_add_dev_ref(struct irdma_sc_dev *dev)
+{
+	try_module_get(THIS_MODULE);
+}
+
+void irdma_put_dev_ref(struct irdma_sc_dev *dev)
+{
+	module_put(THIS_MODULE);
+}
+
+/**
+ * irdma_lan_register_qset - Register qset with LAN driver
+ * @vsi: vsi structure
+ * @tc_node: Traffic class node
+ */
+enum irdma_status_code irdma_lan_register_qset(struct irdma_sc_vsi *vsi,
+					       struct irdma_ws_node *tc_node)
+{
+	struct irdma_device *iwdev = vsi->back_vsi;
+	struct ice_peer_dev *ldev = (struct ice_peer_dev *)iwdev->ldev->if_ldev;
+	struct ice_res rdma_qset_res = {};
+	int ret;
+
+	if (ldev->ops->alloc_res) {
+		rdma_qset_res.cnt_req = 1;
+		rdma_qset_res.res_type = ICE_RDMA_QSETS_TXSCHED;
+		rdma_qset_res.res[0].res.qsets.qs_handle = tc_node->qs_handle;
+		rdma_qset_res.res[0].res.qsets.tc = tc_node->traffic_class;
+		rdma_qset_res.res[0].res.qsets.vsi_id = vsi->vsi_idx;
+		ret = ldev->ops->alloc_res(ldev, &rdma_qset_res, 0);
+		if (ret) {
+			irdma_debug(vsi->dev, IRDMA_DEBUG_WS,
+				    "LAN alloc_res for rdma qset failed.\n");
+			return IRDMA_ERR_NO_MEMORY;
+		}
+
+		tc_node->l2_sched_node_id = rdma_qset_res.res[0].res.qsets.teid;
+		vsi->qos[tc_node->user_pri].l2_sched_node_id =
+					rdma_qset_res.res[0].res.qsets.teid;
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_lan_unregister_qset - Unregister qset with LAN driver
+ * @vsi: vsi structure
+ * @tc_node: Traffic class node
+ */
+void irdma_lan_unregister_qset(struct irdma_sc_vsi *vsi,
+			       struct irdma_ws_node *tc_node)
+{
+	struct irdma_device *iwdev = vsi->back_vsi;
+	struct ice_peer_dev *ldev = (struct ice_peer_dev *)iwdev->ldev->if_ldev;
+	struct ice_res rdma_qset_res = {};
+
+	if (ldev->ops->free_res) {
+		rdma_qset_res.res_allocated = 1;
+		rdma_qset_res.res_type = ICE_RDMA_QSETS_TXSCHED;
+		rdma_qset_res.res[0].res.qsets.vsi_id = vsi->vsi_idx;
+		rdma_qset_res.res[0].res.qsets.teid = tc_node->l2_sched_node_id;
+		rdma_qset_res.res[0].res.qsets.qs_handle = tc_node->qs_handle;
+
+		if (ldev->ops->free_res(ldev, &rdma_qset_res))
+			irdma_debug(vsi->dev, IRDMA_DEBUG_WS, "LAN free_res for rdma qset failed.\n");
+	}
+}
+
+/**
+ * irdma_log_invalid_mtu: log warning on invalid mtu
+ * @mtu: maximum tranmission unit
+ */
+static void irdma_log_invalid_mtu(u16 mtu)
+{
+	if (mtu < IRDMA_MIN_MTU_IPV4)
+		irdma_pr_warn("Current MTU setting of %d is too low for RDMA traffic. Minimum MTU is 576 for IPv4 and 1280 for IPv6\n",
+			      mtu);
+	else if (mtu < IRDMA_MIN_MTU_IPV6)
+		irdma_pr_warn("Current MTU setting of %d is too low for IPv6 RDMA traffic, the minimum is 1280\n",
+			      mtu);
+}
+
+/**
+ * irdma_event_handler - Called by LAN driver to notify events
+ * @peer_dev: Peer device structure
+ * @event: event from LAN driver
+ */
+static void irdma_event_handler(struct ice_peer_dev *ldev,
+				struct ice_event *event)
+{
+	struct irdma_l2params l2params = {};
+	struct irdma_device *iwdev;
+	u8 first_tc;
+	int i;
+
+	iwdev = irdma_find_netdev(ldev->netdev);
+	if (!iwdev)
+		return;
+
+	if (test_bit(ICE_EVENT_LINK_CHANGE, event->type)) {
+		irdma_debug(&iwdev->rf->sc_dev, IRDMA_DEBUG_CLNT, "LINK_CHANGE event\n");
+	} else if (test_bit(ICE_EVENT_MTU_CHANGE, event->type)) {
+		irdma_debug(&iwdev->rf->sc_dev, IRDMA_DEBUG_CLNT,
+			    "new MTU = %d\n", event->info.mtu);
+		if (iwdev->vsi.mtu != event->info.mtu) {
+			l2params.mtu = event->info.mtu;
+			l2params.mtu_changed = true;
+			irdma_log_invalid_mtu(l2params.mtu);
+			irdma_change_l2params(&iwdev->vsi, &l2params);
+		}
+	} else if (test_bit(ICE_EVENT_TC_CHANGE, event->type)) {
+		if (iwdev->vsi.tc_change_pending)
+			return;
+		iwdev->vsi.tc_change_pending = true;
+		irdma_suspend_qps(&iwdev->vsi);
+
+		/* Wait for all qp's to suspend */
+		wait_event_timeout(iwdev->suspend_wq,
+				   !atomic_read(&iwdev->vsi.qp_suspend_reqs),
+				   IRDMA_EVENT_TIMEOUT);
+		irdma_ws_reset(&iwdev->vsi);
+	} else if (test_bit(ICE_EVENT_TC_CHANGE, event->type)) {
+		if (!iwdev->vsi.tc_change_pending)
+			return;
+		l2params.tc_changed = true;
+		irdma_debug(&iwdev->rf->sc_dev, IRDMA_DEBUG_CLNT, "TC Change\n");
+		first_tc = event->info.port_qos.up2tc[0];
+		iwdev->dcb = false;
+		for (i = 0; i < ICE_IDC_MAX_USER_PRIORITY; ++i) {
+			l2params.up2tc[i] = event->info.port_qos.up2tc[i];
+			if (first_tc != l2params.up2tc[i])
+				iwdev->dcb = true;
+		}
+		irdma_change_l2params(&iwdev->vsi, &l2params);
+	} else if (test_bit(ICE_EVENT_API_CHANGE, event->type)) {
+		irdma_debug(&iwdev->rf->sc_dev, IRDMA_DEBUG_CLNT, "API_CHANGE\n");
+	}
+}
+
+static void irdma_enable_lb(struct irdma_device *iwdev)
+{
+	u32 val;
+
+	val = rd32(iwdev->rf->sc_dev.hw, VSI_RXSWCTRL(iwdev->vsi.vsi_idx));
+	val &= ~VSI_RXSWCTRL_SRCPRUNEENABLE_M;
+	wr32(iwdev->rf->sc_dev.hw, (0x00205000 + (iwdev->vsi.vsi_idx * 4)), val);
+}
+
+/**
+ * irdma_open - client interface operation open for RDMA device
+ * @ldev: lan device information
+ *
+ * Called by the lan driver during the processing of client
+ * register.
+ */
+static void irdma_open(struct ice_peer_dev *ldev)
+{
+	struct irdma_handler *hdl;
+	struct irdma_device *iwdev;
+	struct irdma_sc_dev *dev;
+	enum irdma_status_code status;
+	struct ice_event events = {};
+	struct irdma_pci_f *rf;
+	struct irdma_priv_ldev *pldev;
+	struct irdma_l2params l2params = {};
+	int i;
+
+	hdl = irdma_find_handler(ldev->pdev);
+	if (!hdl)
+		return;
+	rf = &hdl->rf;
+	if (rf->init_state != CEQ0_CREATED)
+		return;
+	iwdev = irdma_find_netdev(ldev->netdev);
+	if (iwdev)
+		return;
+	iwdev = kzalloc(sizeof(*iwdev), GFP_KERNEL);
+	if (!iwdev)
+		return;
+
+	iwdev->hdl = hdl;
+	iwdev->rf = rf;
+	iwdev->ldev = &rf->ldev;
+	pldev = &rf->ldev;
+	pldev->pf_vsi_num = ldev->pf_vsi_num;
+
+	/* Set configfs default values */
+	iwdev->push_mode = 0;
+	iwdev->rcv_wnd = IRDMA_CM_DEFAULT_RCV_WND_SCALED;
+	iwdev->rcv_wscale = IRDMA_CM_DEFAULT_RCV_WND_SCALE;
+
+	dev = &hdl->rf.sc_dev;
+	iwdev->netdev = ldev->netdev;
+	iwdev->create_ilq = true;
+	if (rf->roce_ena & (1 << ldev->index)) { /* A bit per port */
+		iwdev->roce_mode = true;
+		iwdev->create_ilq = false;
+	}
+	l2params.mtu = ldev->initial_mtu;
+
+	l2params.num_tc = ldev->initial_qos_info.num_tc;
+	l2params.num_apps = ldev->initial_qos_info.num_apps;
+	l2params.vsi_prio_type = ldev->initial_qos_info.vsi_priority_type;
+	l2params.vsi_rel_bw = ldev->initial_qos_info.vsi_relative_bw;
+	for (i = 0; i < l2params.num_tc; i++) {
+		l2params.tc_info[i].egress_virt_up =
+			ldev->initial_qos_info.tc_info[i].egress_virt_up;
+		l2params.tc_info[i].ingress_virt_up =
+			ldev->initial_qos_info.tc_info[i].ingress_virt_up;
+		l2params.tc_info[i].prio_type =
+			ldev->initial_qos_info.tc_info[i].prio_type;
+		l2params.tc_info[i].rel_bw =
+			ldev->initial_qos_info.tc_info[i].rel_bw;
+		l2params.tc_info[i].tc_ctx =
+			ldev->initial_qos_info.tc_info[i].tc_ctx;
+	}
+	for (i = 0; i < ICE_IDC_MAX_USER_PRIORITY; i++)
+		l2params.up2tc[i] = ldev->initial_qos_info.up2tc[i];
+
+	iwdev->vsi_num = ldev->pf_vsi_num;
+	ldev->ops->update_vsi_filter(ldev, ICE_RDMA_FILTER_BOTH, true);
+
+	status = irdma_rt_init_hw(rf, iwdev, &l2params);
+	if (status)
+		goto error;
+
+	events.reporter = ldev;
+	set_bit(ICE_EVENT_LINK_CHANGE, events.type);
+	set_bit(ICE_EVENT_MTU_CHANGE, events.type);
+	set_bit(ICE_EVENT_TC_CHANGE, events.type);
+	set_bit(ICE_EVENT_API_CHANGE, events.type);
+
+	if (ldev->ops->reg_for_notification)
+		ldev->ops->reg_for_notification(ldev, &events);
+	irdma_enable_lb(iwdev);
+	irdma_dev_info(dev, "IRDMA VSI Open Successful");
+	init_waitqueue_head(&iwdev->close_wq);
+	init_waitqueue_head(&iwdev->suspend_wq);
+
+	return;
+error:
+	list_del(&iwdev->list);
+	kfree(iwdev);
+}
+
+/**
+ * irdma_close - client interface operation close for iwarp/uda device
+ * @ldev: lan device information
+ * @client: client to close
+ *
+ * Called by the lan driver during the processing of client unregister
+ * Destroy and clean up the driver resources
+ */
+static void irdma_close(struct ice_peer_dev *ldev, enum ice_close_reason reason)
+{
+	struct irdma_device *iwdev;
+
+	iwdev = irdma_find_netdev(ldev->netdev);
+	if (!iwdev)
+		return;
+
+	iwdev->closing = true;
+	if (reason == ICE_REASON_HW_RESET_PENDING) {
+		iwdev->reset = true;
+		iwdev->rf->reset = true;
+	}
+
+	if (iwdev->init_state >= CEQ0_CREATED)
+		irdma_deinit_rt_device(iwdev);
+
+	kfree(iwdev);
+	ldev->ops->update_vsi_filter(ldev, ICE_RDMA_FILTER_BOTH, false);
+	irdma_pr_info("IRDMA VSI close complete\n");
+}
+
+/**
+ * irdma_remove - client interface remove operation for RDMA
+ * @ldev: lan device information
+ *
+ * Called on module unload.
+ */
+static int irdma_remove(struct ice_peer_dev *ldev)
+{
+	struct irdma_handler *hdl;
+	struct irdma_pci_f *rf;
+
+	hdl = irdma_find_handler(ldev->pdev);
+	if (!hdl)
+		return 0;
+
+	if (!list_empty(&hdl->rf.vsi_dev_list))
+		return -EBUSY;
+
+	rf = &hdl->rf;
+	if (rf->init_state != CEQ0_CREATED)
+		return -EBUSY;
+
+	destroy_workqueue(rf->free_qp_wq);
+	irdma_deinit_ctrl_hw(rf);
+	irdma_del_handler(hdl);
+	kfree(hdl);
+	irdma_probe_dec_ref(ldev->netdev);
+	irdma_pr_info("IRDMA hardware deinitialization complete\n");
+
+	return 0;
+}
+
+static const struct ice_peer_ops irdma_peer_ops = {
+	.event_handler = irdma_event_handler,
+	.close = irdma_close,
+	.open = irdma_open,
+};
+
+/**
+ * irdma_probe - client interface probe operation for RDMA dev
+ * @ldev: lan device information
+ *
+ * Called by the lan driver during the processing of client register
+ * Create device resources, set up queues, pble and hmc objects.
+ * Return 0 if successful, otherwise return error
+ */
+static int irdma_probe(struct ice_peer_dev *ldev)
+{
+	struct irdma_handler *hdl;
+	struct irdma_pci_f *rf;
+	struct irdma_sc_dev *dev;
+	struct irdma_priv_ldev *pldev;
+
+	irdma_pr_info("probe: ldev=%p, ldev->dev.pdev.bus->number=%d, ldev->netdev=%p\n",
+		      ldev, ldev->pdev->bus->number, ldev->netdev);
+	hdl = irdma_find_handler(ldev->pdev);
+	if (hdl)
+		return -EBUSY;
+
+	hdl = kzalloc(sizeof(*hdl), GFP_KERNEL);
+	if (!hdl)
+		return IRDMA_ERR_NO_MEMORY;
+
+	rf = &hdl->rf;
+	pldev = &rf->ldev;
+	hdl->ldev = pldev;
+	rf->hdl = hdl;
+	dev = &rf->sc_dev;
+	dev->back_dev = rf;
+	rf->init_hw = icrdma_init_hw;
+	pldev->if_ldev = ldev;
+	rf->rdma_ver = IRDMA_GEN_2;
+	irdma_init_rf_params(rf);
+	if (rf->roce_ena & (1 << ldev->index))
+		rf->protocol_used = IRDMA_ROCE_PROTOCOL_ONLY;
+	else
+		rf->protocol_used = IRDMA_IWARP_PROTOCOL_ONLY;
+	dev->pci_rev = ldev->pdev->revision;
+	rf->default_vsi.vsi_idx = ldev->pf_vsi_num;
+	/* save information from ldev to priv_ldev*/
+	pldev->fn_num = ldev->fn_num;
+	rf->hw.hw_addr = ldev->hw_addr;
+	rf->pdev = ldev->pdev;
+	rf->netdev = ldev->netdev;
+	pldev->ftype = ldev->ftype;
+	pldev->msix_count = ldev->msix_count;
+	pldev->msix_entries = ldev->msix_entries;
+	irdma_add_handler(hdl);
+	if (irdma_ctrl_init_hw(rf)) {
+		irdma_del_handler(hdl);
+		kfree(hdl);
+		return -EIO;
+	}
+	ldev->peer_ops = &irdma_peer_ops;
+
+	irdma_probe_inc_ref(ldev->netdev);
+
+	return 0;
+}
+
+static struct ice_peer_drv irdma_client = {
+	.name = KBUILD_MODNAME,
+	.driver_id = ICE_PEER_RDMA_DRIVER,
+	.ver.major = ICE_PEER_MAJOR_VER,
+	.ver.minor = ICE_PEER_MINOR_VER,
+	.dev_id.vendor = PCI_VENDOR_ID_INTEL,
+	.dev_id.device = ICE_PEER_RDMA_DEV,
+	.probe = irdma_probe,
+	.remove = irdma_remove,
+	.driver.name = "irdma",
+	.driver.mod_name = "irdma",
+	.driver.owner = THIS_MODULE
+};
+
+/**
+ * icrdma_request_reset - Request a reset
+ * @rf: RDMA PCI function
+ *
+ */
+void icrdma_request_reset(struct irdma_pci_f *rf)
+{
+	struct ice_peer_dev *ldev = (struct ice_peer_dev *)rf->ldev.if_ldev;
+
+	if (ldev && ldev->ops && ldev->ops->request_reset)
+		ldev->ops->request_reset(ldev, ICE_PEER_PFR);
+}
+
+int icrdma_reg_peer_driver(struct irdma_peer *peer, struct net_device *netdev)
+{
+	struct idc_srv_provider *sp;
+
+	sp = (struct idc_srv_provider *)netdev_priv(netdev);
+	if (sp->signature != IDC_SIGNATURE)
+		return -EINVAL;
+
+	peer->reg_peer_driver = (int (*)(void *))sp->reg_peer_driver;
+	peer->unreg_peer_driver = (int (*)(void *))sp->unreg_peer_driver;
+
+	return peer->reg_peer_driver(&irdma_client);
+}
+
+void icrdma_unreg_peer_driver(struct irdma_peer *peer)
+{
+	peer->unreg_peer_driver(&irdma_client);
+}
diff --git a/drivers/infiniband/hw/irdma/main.c b/drivers/infiniband/hw/irdma/main.c
new file mode 100644
index 0000000..3a9c24c
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/main.c
@@ -0,0 +1,489 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2019, Intel Corporation. */
+
+#include "main.h"
+
+#ifndef CONFIG_DYNAMIC_DEBUG
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "debug flags: 0=disabled (default), 0x7fffffff=all");
+#endif
+
+static int resource_profile;
+module_param(resource_profile, int, 0644);
+MODULE_PARM_DESC(resource_profile, "Resource Profile: 0=PF only, 1=Weighted VF, 2=Even Distribution");
+
+static int max_rdma_vfs = 32;
+module_param(max_rdma_vfs, int, 0644);
+MODULE_PARM_DESC(max_rdma_vfs, "Maximum VF count: 0-32 32=default");
+static int roce_ena;
+module_param(roce_ena, int, 0644);
+MODULE_PARM_DESC(roce_ena, "RoCE enable bitmap: 1=port0,2=port1....0=disabled, not supported on X722");
+
+static int limits_sel;
+module_param(limits_sel, int, 0644);
+MODULE_PARM_DESC(limits_sel, "Resource limits selector, Range: 0-3");
+
+MODULE_AUTHOR("Intel Corporation, <e1000-rdma@lists.sourceforge.net>");
+MODULE_DESCRIPTION("Intel(R) Ethernet Connection RDMA Driver");
+MODULE_LICENSE("Dual BSD/GPL");
+/* Add an alias for i40iw once its deprecated from kernel.
+ * If required add push_mode and mpa_version as deprecated
+ * module params for i40iw compat.
+ */
+
+LIST_HEAD(irdma_handlers);
+DEFINE_SPINLOCK(irdma_handler_lock);
+
+static struct notifier_block irdma_inetaddr_notifier = {
+	.notifier_call = irdma_inetaddr_event
+};
+
+static struct notifier_block irdma_inetaddr6_notifier = {
+	.notifier_call = irdma_inet6addr_event
+};
+
+static struct notifier_block irdma_net_notifier = {
+	.notifier_call = irdma_net_event
+};
+
+static struct notifier_block irdma_netdevice_notifier = {
+	.notifier_call = irdma_netdevice_event
+};
+
+void irdma_init_rf_params(struct irdma_pci_f *rf)
+{
+	rf->limits_sel = limits_sel;
+	if (rf->rdma_ver != IRDMA_GEN_1)
+		rf->roce_ena = roce_ena;
+	rf->rsrc_profile = (resource_profile < IRDMA_HMC_PROFILE_EQUAL) ?
+			    (u8)resource_profile + IRDMA_HMC_PROFILE_DEFAULT :
+			    IRDMA_HMC_PROFILE_DEFAULT;
+	rf->max_rdma_vfs = (rf->rsrc_profile != IRDMA_HMC_PROFILE_DEFAULT) ?
+			    max_rdma_vfs : 0;
+	rf->max_ena_vfs = rf->max_rdma_vfs;
+#ifndef CONFIG_DYNAMIC_DEBUG
+	rf->debug = debug;
+#endif
+}
+
+/**
+ * irdma_find_netdev - find a vsi device given a netdev
+ * @netdev: pointer to net_device
+ */
+struct irdma_device *irdma_find_netdev(struct net_device *netdev)
+{
+	struct irdma_device *iwdev;
+	struct irdma_handler *hdl;
+	struct list_head *pos;
+	struct list_head *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&irdma_handler_lock, flags);
+	list_for_each_entry(hdl, &irdma_handlers, list) {
+		list_for_each_safe(pos, tmp, &hdl->rf.vsi_dev_list) {
+			iwdev = container_of(pos, struct irdma_device, list);
+			if (netdev == iwdev->netdev) {
+				spin_unlock_irqrestore(&irdma_handler_lock,
+						       flags);
+				return iwdev;
+			}
+		}
+	}
+	spin_unlock_irqrestore(&irdma_handler_lock, flags);
+
+	return NULL;
+}
+
+/**
+ * irdma_find_ice_handler - find a handler given a client info
+ * @ldev: pointer to a client info
+ */
+struct irdma_handler *irdma_find_handler(struct pci_dev *pdev)
+{
+	struct irdma_handler *hdl;
+	unsigned long flags;
+
+	spin_lock_irqsave(&irdma_handler_lock, flags);
+	list_for_each_entry(hdl, &irdma_handlers, list) {
+		if (hdl->rf.pdev->devfn == pdev->devfn &&
+		    hdl->rf.pdev->bus->number == pdev->bus->number) {
+			spin_unlock_irqrestore(&irdma_handler_lock, flags);
+			return hdl;
+		}
+	}
+	spin_unlock_irqrestore(&irdma_handler_lock, flags);
+
+	return NULL;
+}
+
+/**
+ * irdma_find_iwdev - find a vsi device given a name
+ * @name: name of iwdev
+ */
+struct irdma_device *irdma_find_iwdev(const char *name)
+{
+	struct irdma_handler *hdl;
+	struct list_head *pos;
+	struct list_head *tmp;
+	struct irdma_device *iwdev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&irdma_handler_lock, flags);
+	list_for_each_entry(hdl, &irdma_handlers, list) {
+		list_for_each_safe(pos, tmp, &hdl->rf.vsi_dev_list) {
+			iwdev = container_of(pos, struct irdma_device, list);
+			if (!strcmp(name, iwdev->iwibdev->ibdev.name)) {
+				spin_unlock_irqrestore(&irdma_handler_lock,
+						       flags);
+				return iwdev;
+			}
+		}
+	}
+	spin_unlock_irqrestore(&irdma_handler_lock, flags);
+
+	return NULL;
+}
+
+/**
+ * irdma_add_handler - add a handler to the list
+ * @hdl: handler to be added to the handler list
+ */
+void irdma_add_handler(struct irdma_handler *hdl)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&irdma_handler_lock, flags);
+	list_add(&hdl->list, &irdma_handlers);
+	spin_unlock_irqrestore(&irdma_handler_lock, flags);
+}
+
+/**
+ * irdma_del_handler - delete a handler from the list
+ * @hdl: handler to be deleted from the handler list
+ */
+void irdma_del_handler(struct irdma_handler *hdl)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&irdma_handler_lock, flags);
+	list_del(&hdl->list);
+	spin_unlock_irqrestore(&irdma_handler_lock, flags);
+}
+
+/**
+ * irdma_register_notifiers - register tcp ip notifiers
+ */
+void irdma_register_notifiers(void)
+{
+	register_inetaddr_notifier(&irdma_inetaddr_notifier);
+	register_inet6addr_notifier(&irdma_inetaddr6_notifier);
+	register_netevent_notifier(&irdma_net_notifier);
+	register_netdevice_notifier(&irdma_netdevice_notifier);
+}
+
+void irdma_unregister_notifiers(void)
+{
+	unregister_netevent_notifier(&irdma_net_notifier);
+	unregister_inetaddr_notifier(&irdma_inetaddr_notifier);
+	unregister_inet6addr_notifier(&irdma_inetaddr6_notifier);
+	unregister_netdevice_notifier(&irdma_netdevice_notifier);
+}
+
+/**
+ * irdma_add_ipv6_addr - add ipv6 address to the hw arp table
+ * @iwdev: iwarp device
+ */
+static void irdma_add_ipv6_addr(struct irdma_device *iwdev)
+{
+	struct net_device *ip_dev;
+	struct inet6_dev *idev;
+	struct inet6_ifaddr *ifp, *tmp;
+	u32 local_ipaddr6[4];
+
+	rcu_read_lock();
+	for_each_netdev_rcu(&init_net, ip_dev) {
+		if (((rdma_vlan_dev_vlan_id(ip_dev) < 0xFFFF &&
+		      rdma_vlan_dev_real_dev(ip_dev) == iwdev->netdev) ||
+		      ip_dev == iwdev->netdev) && ip_dev->flags & IFF_UP) {
+			idev = __in6_dev_get(ip_dev);
+			if (!idev) {
+				irdma_dev_err(&iwdev->rf->sc_dev,
+					      "ipv6 inet device not found\n");
+				break;
+			}
+			list_for_each_entry_safe(ifp, tmp, &idev->addr_list, if_list) {
+				irdma_dev_info(&iwdev->rf->sc_dev,
+					       "IP=%pI6, vlan_id=%d, MAC=%pM\n",
+					       &ifp->addr,
+					       rdma_vlan_dev_vlan_id(ip_dev),
+					       ip_dev->dev_addr);
+
+				irdma_copy_ip_ntohl(local_ipaddr6,
+						    ifp->addr.in6_u.u6_addr32);
+				irdma_manage_arp_cache(iwdev->rf,
+						       ip_dev->dev_addr,
+						       local_ipaddr6,
+						       false,
+						       IRDMA_ARP_ADD);
+			}
+		}
+	}
+	rcu_read_unlock();
+}
+
+/**
+ * irdma_add_ipv4_addr - add ipv4 address to the hw arp table
+ * @iwdev: iwarp device
+ */
+static void irdma_add_ipv4_addr(struct irdma_device *iwdev)
+{
+	struct net_device *dev;
+	struct in_device *idev;
+	bool got_lock = true;
+	u32 ip_addr;
+
+	if (!rtnl_trylock())
+		got_lock = false;
+
+	for_each_netdev(&init_net, dev) {
+		if (((rdma_vlan_dev_vlan_id(dev) < 0xFFFF &&
+		      rdma_vlan_dev_real_dev(dev) == iwdev->netdev) ||
+		      dev == iwdev->netdev) && dev->flags & IFF_UP) {
+			idev = in_dev_get(dev);
+			for_ifa(idev) {
+				irdma_debug(&iwdev->rf->sc_dev, IRDMA_DEBUG_CM,
+					    "IP=%pI4, vlan_id=%d, MAC=%pM\n",
+					    &ifa->ifa_address,
+					    rdma_vlan_dev_vlan_id(dev),
+					    dev->dev_addr);
+
+				ip_addr = ntohl(ifa->ifa_address);
+				irdma_manage_arp_cache(iwdev->rf,
+						       dev->dev_addr,
+						       &ip_addr,
+						       true,
+						       IRDMA_ARP_ADD);
+			}
+			endfor_ifa(idev);
+			in_dev_put(idev);
+		}
+	}
+	if (got_lock)
+		rtnl_unlock();
+}
+
+/**
+ * irdma_add_ip - add ip addresses
+ * @iwdev: iwarp device
+ *
+ * Add ipv4/ipv6 addresses to the arp cache
+ */
+void irdma_add_ip(struct irdma_device *iwdev)
+{
+	irdma_add_ipv4_addr(iwdev);
+	irdma_add_ipv6_addr(iwdev);
+}
+
+/**
+ * irdma_request_reset - Request a reset
+ * @rf: RDMA PCI function
+ *
+ */
+void irdma_request_reset(struct irdma_pci_f *rf)
+{
+	irdma_dev_warn(&rf->sc_dev, "Requesting a a reset from LAN driver\n");
+	if (rf->rdma_ver == IRDMA_GEN_1)
+		i40iw_request_reset(rf);
+	else
+		icrdma_request_reset(rf);
+}
+
+static struct irdma_peer_drvs_list *irdma_peer_drvs;
+
+/**
+ * irdma_probe_inc_ref - Increment ref count for a probe
+ * @netdev: netdev pointer
+ */
+void irdma_probe_inc_ref(struct net_device *netdev)
+{
+	struct irdma_peer *peer;
+	u32 i;
+
+	for (i = 0; i < IRDMA_MAX_PEERS; i++) {
+		peer = &irdma_peer_drvs->peer[i];
+		if (!strncmp(netdev->dev.parent->driver->name, peer->name,
+			     sizeof(peer->name)))
+			break;
+	}
+
+	if (i != IRDMA_MAX_PEERS)
+		atomic_inc(&peer->ref_count);
+}
+
+/**
+ * irdma_probe_dec_ref - Decrement ref count for a probe
+ * @netdev: netdev pointer
+ */
+void irdma_probe_dec_ref(struct net_device *netdev)
+{
+	struct irdma_peer *peer;
+	u32 i;
+
+	for (i = 0; i < IRDMA_MAX_PEERS; i++) {
+		peer = &irdma_peer_drvs->peer[i];
+		if (!strcmp(netdev->dev.parent->driver->name, peer->name)) {
+			if (peer->state == IRDMA_STATE_VALID &&
+			    atomic_dec_and_test(&peer->ref_count)) {
+				peer->state = IRDMA_STATE_INVALID;
+				switch (i) {
+				case I40E_PEER_TYPE:
+					if (IS_ENABLED(CONFIG_INFINIBAND_I40IW))
+						return;
+
+					i40iw_unreg_peer_driver(peer);
+					break;
+				case ICE_PEER_TYPE:
+					icrdma_unreg_peer_driver(peer);
+					break;
+				default:
+					return;
+				}
+				module_put(peer->module);
+			}
+			break;
+		}
+	}
+}
+
+/**
+ * irdma_handle_netdev - Find peer driver and register with it
+ * @netdev: netdev of peer driver
+ */
+void irdma_handle_netdev(struct net_device *netdev)
+{
+	struct irdma_peer *peer;
+	int ret;
+	u32 i;
+
+	for (i = 0; i < IRDMA_MAX_PEERS; i++) {
+		peer = &irdma_peer_drvs->peer[i];
+		if (netdev->dev.parent && netdev->dev.parent->driver &&
+		    !strncmp(netdev->dev.parent->driver->name, peer->name,
+			     sizeof(peer->name)))
+			break;
+	}
+
+	if (i == IRDMA_MAX_PEERS || peer->state == IRDMA_STATE_VALID)
+		return;
+
+	/* Found the driver */
+	peer = &irdma_peer_drvs->peer[i];
+	peer->module = netdev->dev.parent->driver->owner;
+
+	switch (i) {
+	case I40E_PEER_TYPE:
+		if (IS_ENABLED(CONFIG_INFINIBAND_I40IW))
+			return;
+
+		ret = i40iw_reg_peer_driver(peer, netdev);
+		break;
+	case ICE_PEER_TYPE:
+		ret = icrdma_reg_peer_driver(peer, netdev);
+		break;
+	default:
+		return;
+	}
+
+	/* call the register routine */
+	if (!ret) {
+		peer->state = IRDMA_STATE_VALID;
+		try_module_get(peer->module);
+	} else {
+		peer->state = IRDMA_STATE_REG_FAILED;
+	}
+}
+
+/**
+ * irdma_find_peers - Search netdevs for a peer drivers
+ */
+static void irdma_find_peers(void)
+{
+	struct net_device *dev;
+
+	rtnl_lock();
+	for_each_netdev(&init_net, dev)
+		irdma_handle_netdev(dev);
+	rtnl_unlock();
+}
+
+/**
+ * irdma_unreg_peers - Unregister with all peers
+ */
+static void irdma_unreg_peers(void)
+{
+	struct irdma_peer *peer;
+	u32 i;
+
+	for (i = 0; i < IRDMA_MAX_PEERS; i++) {
+		peer = &irdma_peer_drvs->peer[i];
+		if (peer->state == IRDMA_STATE_VALID) {
+			peer->state = IRDMA_STATE_INVALID;
+			switch (i) {
+			case I40E_PEER_TYPE:
+				if (IS_ENABLED(CONFIG_INFINIBAND_I40IW))
+					return;
+
+				i40iw_unreg_peer_driver(peer);
+				break;
+			case ICE_PEER_TYPE:
+				icrdma_unreg_peer_driver(peer);
+				break;
+			default:
+				return;
+			}
+			module_put(peer->module);
+		}
+	}
+}
+
+/**
+ * irdma_init_module - driver initialization function
+ *
+ * First function to call when the driver is loaded
+ * Register the driver as ice client and port mapper client
+ */
+static int __init irdma_init_module(void)
+{
+	int ret = 0;
+	struct irdma_peer *peer;
+
+	irdma_peer_drvs = kzalloc(sizeof(*irdma_peer_drvs), GFP_KERNEL);
+	if (!irdma_peer_drvs)
+		return -ENOMEM;
+	peer = &irdma_peer_drvs->peer[I40E_PEER_TYPE];
+	strncpy(peer->name, "i40e", sizeof(peer->name));
+	peer = &irdma_peer_drvs->peer[ICE_PEER_TYPE];
+	strncpy(peer->name, "ice", sizeof(peer->name));
+	irdma_find_peers();
+
+	irdma_register_notifiers();
+
+	return ret;
+}
+
+/**
+ * irdma_exit_module - driver exit clean up function
+ *
+ * The function is called just before the driver is unloaded
+ * Unregister the driver as ice client and port mapper client
+ */
+static void __exit irdma_exit_module(void)
+{
+	irdma_unregister_notifiers();
+	irdma_unreg_peers();
+	kfree(irdma_peer_drvs);
+}
+
+module_init(irdma_init_module);
+module_exit(irdma_exit_module);
diff --git a/drivers/infiniband/hw/irdma/main.h b/drivers/infiniband/hw/irdma/main.h
new file mode 100644
index 0000000..198c27f
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/main.h
@@ -0,0 +1,709 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2019, Intel Corporation. */
+
+#ifndef IRDMA_MAIN_H
+#define IRDMA_MAIN_H
+
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/if_vlan.h>
+#include <net/addrconf.h>
+#include <net/netevent.h>
+#include <linux/netdevice.h>
+#include <linux/inetdevice.h>
+#include <linux/spinlock.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/pci.h>
+#include <linux/dma-mapping.h>
+#include <linux/workqueue.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/crc32c.h>
+#include <linux/kthread.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_pack.h>
+#include <rdma/rdma_cm.h>
+#include <rdma/iw_cm.h>
+#include <crypto/hash.h>
+#include "status.h"
+#include "osdep.h"
+#include "defs.h"
+#include "hmc.h"
+#include "type.h"
+#include "protos.h"
+#include "pble.h"
+#include "verbs.h"
+#include "cm.h"
+#include "user.h"
+#include "puda.h"
+#include <rdma/irdma-abi.h>
+
+extern struct list_head irdma_handlers;
+extern spinlock_t irdma_handler_lock;
+
+#define IRDMA_FW_VER	2
+#define IRDMA_HW_VER	2
+
+#define IRDMA_ARP_ADD		1
+#define IRDMA_ARP_DELETE	2
+#define IRDMA_ARP_RESOLVE	3
+
+#define IRDMA_MACIP_ADD		1
+#define IRDMA_MACIP_DELETE	2
+
+#define IW_CCQ_SIZE	(IRDMA_CQP_SW_SQSIZE_2048 + 1)
+#define IW_CEQ_SIZE	2048
+#define IW_AEQ_SIZE	2048
+
+#define RX_BUF_SIZE	(1536 + 8)
+#define IW_REG0_SIZE	(4 * 1024)
+#define IW_TX_TIMEOUT	(6 * HZ)
+#define IW_FIRST_QPN	1
+
+#define IW_SW_CONTEXT_ALIGN	1024
+
+#define MAX_DPC_ITERATIONS	128
+
+#define IRDMA_EVENT_TIMEOUT		100000
+#define IRDMA_VCHNL_EVENT_TIMEOUT	100000
+
+#define	IRDMA_NO_VLAN	0xffff
+#define	IRDMA_NO_QSET	0xffff
+
+#define IW_CFG_FPM_QP_COUNT		32768
+#define IRDMA_MAX_PAGES_PER_FMR		512
+#define IRDMA_MIN_PAGES_PER_FMR		1
+#define IRDMA_CQP_COMPL_RQ_WQE_FLUSHED	2
+#define IRDMA_CQP_COMPL_SQ_WQE_FLUSHED	3
+
+#define IRDMA_Q_TYPE_PE_AEQ	0x80
+#define IRDMA_Q_INVALID_IDX	0xffff
+
+#define IRDMA_DRV_OPT_ENA_MPA_VER_0		0x00000001
+#define IRDMA_DRV_OPT_DISABLE_MPA_CRC		0x00000002
+#define IRDMA_DRV_OPT_DISABLE_FIRST_WRITE	0x00000004
+#define IRDMA_DRV_OPT_DISABLE_INTF		0x00000008
+#define IRDMA_DRV_OPT_ENA_MSI			0x00000010
+#define IRDMA_DRV_OPT_DUAL_LOGICAL_PORT		0x00000020
+#define IRDMA_DRV_OPT_NO_INLINE_DATA		0x00000080
+#define IRDMA_DRV_OPT_DISABLE_INT_MOD		0x00000100
+#define IRDMA_DRV_OPT_DISABLE_VIRT_WQ		0x00000200
+#define IRDMA_DRV_OPT_ENA_PAU			0x00000400
+#define IRDMA_DRV_OPT_MCAST_LOGPORT_MAP		0x00000800
+
+#define IW_HMC_OBJ_TYPE_NUM	ARRAY_SIZE(iw_hmc_obj_types)
+#define VSI_RXSWCTRL(_VSI)			(0x00205000 + ((_VSI) * 4))
+#define VSI_RXSWCTRL_MACVSIPRUNEENABLE_M	BIT(8)
+#define VSI_RXSWCTRL_SRCPRUNEENABLE_M		BIT(13)
+
+enum init_completion_state {
+	INVALID_STATE = 0,
+	INITIAL_STATE,
+	CQP_CREATED,
+	HMC_OBJS_CREATED,
+	CCQ_CREATED,
+	AEQ_CREATED,
+	CEQ0_CREATED,	/* Last state of probe */
+	CEQS_CREATED,
+	ILQ_CREATED,
+	IEQ_CREATED,
+	PBLE_CHUNK_MEM,
+	IP_ADDR_REGISTERED,
+	RDMA_DEV_REGISTERED, /* Last state of open */
+};
+
+enum IRDMA_IDC_STATE {
+	IRDMA_STATE_INVALID,
+	IRDMA_STATE_VALID,
+	IRDMA_STATE_REG_FAILED
+};
+
+enum irdma_peer_type {
+	I40E_PEER_TYPE,
+	ICE_PEER_TYPE,
+	IRDMA_MAX_PEERS,
+};
+
+struct irdma_rsrc_limits {
+	u32 qplimit;
+	u32 mrlimit;
+	u32 cqlimit;
+};
+
+struct irdma_cqp_compl_info {
+	u32 op_ret_val;
+	u16 maj_err_code;
+	u16 min_err_code;
+	bool error;
+	u8 op_code;
+};
+
+struct irdma_cqp_request {
+	struct cqp_cmds_info info;
+	wait_queue_head_t waitq;
+	struct list_head list;
+	atomic_t refcount;
+	void (*callback_fcn)(struct irdma_cqp_request *cqp_request, u32 num);
+	void *param;
+	struct irdma_cqp_compl_info compl_info;
+	bool waiting;
+	bool request_done;
+	bool dynamic;
+};
+
+struct irdma_cqp {
+	struct irdma_sc_cqp sc_cqp;
+	spinlock_t req_lock; /* protect CQP request list */
+	spinlock_t compl_lock; /* protect CQP completion processing */
+	wait_queue_head_t waitq;
+	wait_queue_head_t remove_wq;
+	struct irdma_dma_mem sq;
+	struct irdma_dma_mem host_ctx;
+	u64 *scratch_array;
+	struct irdma_cqp_request *cqp_requests;
+	struct list_head cqp_avail_reqs;
+	struct list_head cqp_pending_reqs;
+	struct task_struct *cqp_compl_thread;
+	struct semaphore cqp_compl_sem;
+};
+
+struct irdma_ccq {
+	struct irdma_sc_cq sc_cq;
+	struct irdma_dma_mem mem_cq;
+	struct irdma_dma_mem shadow_area;
+};
+
+struct irdma_ceq {
+	struct irdma_sc_ceq sc_ceq;
+	struct irdma_dma_mem mem;
+	u32 irq;
+	u32 msix_idx;
+	struct irdma_pci_f *rf;
+	struct tasklet_struct dpc_tasklet;
+};
+
+struct irdma_aeq {
+	struct irdma_sc_aeq sc_aeq;
+	struct irdma_dma_mem mem;
+};
+
+struct irdma_arp_entry {
+	u32 ip_addr[4];
+	u8 mac_addr[ETH_ALEN];
+};
+
+struct irdma_msix_vector {
+	u32 idx;
+	u32 irq;
+	u32 cpu_affinity;
+	u32 ceq_id;
+	cpumask_t mask;
+};
+
+struct l2params_work {
+	struct work_struct work;
+	struct irdma_device *iwdev;
+	struct irdma_l2params l2params;
+};
+
+struct virtchnl_work {
+	struct work_struct work;
+	union {
+		struct irdma_cqp_request *cqp_request;
+		struct irdma_virtchnl_work_info work_info;
+	};
+};
+
+struct irdma_mc_table_info {
+	bool ipv4_valid;
+	u32 mgn;
+	u32 dest_ip[4];
+	bool lan_fwd;
+};
+
+struct mc_table_list {
+	struct list_head list;
+	struct irdma_mc_table_info mc_info;
+	struct irdma_mcast_grp_info mc_grp_ctx;
+};
+
+struct irdma_qv_info {
+	u32 v_idx; /* msix_vector */
+	u16 ceq_idx;
+	u16 aeq_idx;
+	u8 itr_idx;
+};
+
+struct irdma_qvlist_info {
+	u32 num_vectors;
+	struct irdma_qv_info qv_info[1];
+};
+
+struct irdma_priv_ldev {
+	unsigned int fn_num;
+	bool ftype;
+	u16 pf_vsi_num;
+	u16 msix_count;
+	struct msix_entry *msix_entries;
+	void *if_client;
+	void *if_ldev;
+};
+
+struct irdma_pci_f {
+	bool ooo;
+	bool reset;
+	bool rsrc_created;
+	bool stop_cqp_thread;
+	bool msix_shared;
+	u8 rsrc_profile;
+	u8 max_rdma_vfs;
+	u8 max_ena_vfs;
+	u8 *hmc_info_mem;
+	u8 *mem_rsrc;
+	u8 rdma_ver;
+	enum irdma_protocol_used protocol_used;
+	u32 sd_type;
+	u32 msix_count;
+	u32 max_mr;
+	u32 max_qp;
+	u32 max_cq;
+	u32 max_ah;
+	u32 next_ah;
+	u32 max_mcg;
+	u32 next_mcg;
+	u32 roce_ena;
+	u32 max_pd;
+	u32 next_qp;
+	u32 next_cq;
+	u32 next_pd;
+	u32 max_mr_size;
+	u32 max_cqe;
+	u32 mr_stagmask;
+	u32 used_pds;
+	u32 used_cqs;
+	u32 used_mrs;
+	u32 used_qps;
+	u32 arp_table_size;
+	u32 next_arp_index;
+	u32 ceqs_count;
+	u32 next_ws_node_id;
+	u32 max_ws_node_id;
+	u32 limits_sel;
+#ifndef CONFIG_DYNAMIC_DEBUG
+	u32 debug;
+#endif
+	unsigned long *allocated_ws_nodes;
+	unsigned long *allocated_qps;
+	unsigned long *allocated_cqs;
+	unsigned long *allocated_mrs;
+	unsigned long *allocated_pds;
+	unsigned long *allocated_mcgs;
+	unsigned long *allocated_ahs;
+	unsigned long *allocated_arps;
+	enum init_completion_state init_state;
+	struct irdma_sc_dev sc_dev;
+	struct list_head vsi_dev_list;
+	struct irdma_priv_ldev ldev;
+	struct irdma_handler *hdl;
+	struct pci_dev *pdev;
+	struct net_device *netdev;
+	struct irdma_hw hw;
+	struct irdma_cqp cqp;
+	struct irdma_ccq ccq;
+	struct irdma_aeq aeq;
+	struct irdma_ceq *ceqlist;
+	struct irdma_hmc_pble_rsrc *pble_rsrc;
+	struct irdma_arp_entry *arp_table;
+	spinlock_t rsrc_lock; /* protect HW resource array access */
+	spinlock_t qptable_lock; /*protect QP table access*/
+	struct irdma_qp **qp_table;
+	spinlock_t qh_list_lock;	/* protect mc_qht_list */
+	struct mc_table_list mc_qht_list;
+	struct irdma_msix_vector *iw_msixtbl;
+	struct irdma_qvlist_info *iw_qvlist;
+	struct tasklet_struct dpc_tasklet;
+	struct irdma_dma_mem obj_mem;
+	struct irdma_dma_mem obj_next;
+	atomic_t vchnl_msgs;
+	wait_queue_head_t vchnl_waitq;
+	struct workqueue_struct *free_qp_wq;
+	struct virtchnl_work virtchnl_w[IRDMA_MAX_PE_ENA_VF_COUNT];
+	struct irdma_sc_vsi default_vsi;
+	void *back_fcn;
+	void (*init_hw)(struct irdma_sc_dev *dev);
+};
+
+struct irdma_device {
+	struct irdma_ib_device *iwibdev;
+	struct list_head list;
+	struct irdma_pci_f *rf;
+	struct irdma_priv_ldev *ldev;
+	struct net_device *netdev;
+	struct irdma_handler *hdl;
+	struct irdma_sc_vsi vsi;
+	struct irdma_cm_core cm_core;
+	bool roce_mode;
+	u32 vendor_id;
+	u32 vendor_part_id;
+	u32 device_cap_flags;
+	u32 push_mode;
+	u32 rcv_wnd;
+	u16 mac_ip_table_idx;
+	u8 rcv_wscale;
+	bool dctcp_en;
+	bool ecn_en;
+	u16  vsi_num;
+	bool create_ilq;
+	bool roce_timely_en;
+	bool roce_dcqcn_en;
+	u8 iw_status;
+	struct tasklet_struct dpc_tasklet;
+	enum init_completion_state init_state;
+	bool dcb;
+	bool closing;
+	bool reset;
+	wait_queue_head_t close_wq;
+	wait_queue_head_t suspend_wq;
+	atomic64_t use_count;
+	struct workqueue_struct *param_wq;
+	atomic_t params_busy;
+};
+
+struct irdma_ib_device {
+	struct ib_device ibdev;
+	struct irdma_device *iwdev;
+};
+
+struct irdma_handler {
+	struct list_head list;
+	struct irdma_pci_f rf;
+	struct irdma_priv_ldev *ldev;
+	bool shared_res_created;
+};
+
+struct irdma_peer {
+	struct module *module;
+#define IRDMA_MAX_PEER_NAME_SIZE	8
+	char name[IRDMA_MAX_PEER_NAME_SIZE];
+	enum IRDMA_IDC_STATE state;
+	atomic_t ref_count;
+	int (*reg_peer_driver)(void *peer_info);
+	int (*unreg_peer_driver)(void *peer_info);
+};
+
+struct irdma_peer_drvs_list {
+	struct irdma_peer peer[IRDMA_MAX_PEERS];
+};
+/***********************************************************/
+/**
+ * to_iwdev - get device
+ * @ibdev: ib device
+ **/
+static inline struct irdma_device *to_iwdev(struct ib_device *ibdev)
+{
+	return container_of(ibdev, struct irdma_ib_device, ibdev)->iwdev;
+}
+
+/**
+ * to_ucontext - get user context
+ * @ibucontext: ib user context
+ **/
+static inline struct irdma_ucontext *to_ucontext(struct ib_ucontext *ibucontext)
+{
+	return container_of(ibucontext, struct irdma_ucontext, ibucontext);
+}
+
+/**
+ * to_iwpd - get protection domain
+ * @ibpd: ib pd
+ **/
+static inline struct irdma_pd *to_iwpd(struct ib_pd *ibpd)
+{
+	return container_of(ibpd, struct irdma_pd, ibpd);
+}
+
+/**
+ * to_iwah - get device ah
+ * @ibdev: ib ah
+ **/
+static inline struct irdma_ah *to_iwah(struct ib_ah *ibah)
+{
+	return container_of(ibah, struct irdma_ah, ibah);
+}
+
+/**
+ * to_iwmr - get device memory region
+ * @ibdev: ib memory region
+ **/
+static inline struct irdma_mr *to_iwmr(struct ib_mr *ibmr)
+{
+	return container_of(ibmr, struct irdma_mr, ibmr);
+}
+
+/**
+ * to_iwmr_from_ibfmr - get device memory region
+ * @ibfmr: ib fmr
+ **/
+static inline struct irdma_mr *to_iwmr_from_ibfmr(struct ib_fmr *ibfmr)
+{
+	return container_of(ibfmr, struct irdma_mr, ibfmr);
+}
+
+/**
+ * to_iwmw - get device memory window
+ * @ibmw: ib memory window
+ **/
+static inline struct irdma_mr *to_iwmw(struct ib_mw *ibmw)
+{
+	return container_of(ibmw, struct irdma_mr, ibmw);
+}
+
+/**
+ * to_iwcq - get completion queue
+ * @ibcq: ib cqdevice
+ **/
+static inline struct irdma_cq *to_iwcq(struct ib_cq *ibcq)
+{
+	return container_of(ibcq, struct irdma_cq, ibcq);
+}
+
+/**
+ * to_iwqp - get device qp
+ * @ibqp: ib qp
+ **/
+static inline struct irdma_qp *to_iwqp(struct ib_qp *ibqp)
+{
+	return container_of(ibqp, struct irdma_qp, ibqp);
+}
+
+/**
+ * irdma_alloc_resource - allocate a resource
+ * @iwdev: device pointer
+ * @resource_array: resource bit array:
+ * @max_resources: maximum resource number
+ * @req_resources_num: Allocated resource number
+ * @next: next free id
+ **/
+static inline int irdma_alloc_rsrc(struct irdma_pci_f *rf,
+				   unsigned long *rsrc_array,
+				   u32 max_rsrc,
+				   u32 *req_rsrc_num,
+				   u32 *next)
+{
+	u32 rsrc_num;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rf->rsrc_lock, flags);
+	rsrc_num = find_next_zero_bit(rsrc_array, max_rsrc, *next);
+	if (rsrc_num >= max_rsrc) {
+		rsrc_num =
+			find_first_zero_bit(rsrc_array, max_rsrc);
+		if (rsrc_num >= max_rsrc) {
+			spin_unlock_irqrestore(&rf->rsrc_lock, flags);
+			irdma_debug(&rf->sc_dev, IRDMA_DEBUG_ERR,
+				    "resource [%d] allocation failed\n",
+				    rsrc_num);
+			return -EOVERFLOW;
+		}
+	}
+	set_bit(rsrc_num, rsrc_array);
+	*next = rsrc_num + 1;
+	if (*next == max_rsrc)
+		*next = 0;
+	*req_rsrc_num = rsrc_num;
+	spin_unlock_irqrestore(&rf->rsrc_lock, flags);
+
+	return 0;
+}
+
+/**
+ * irdma_is_resource_allocated - detrmine if resource is
+ * allocated
+ * @iwdev: device pointer
+ * @resource_array: resource array for the resource_num
+ * @resource_num: resource number to check
+ **/
+static inline bool irdma_is_rsrc_allocated(struct irdma_pci_f *rf,
+					   unsigned long *rsrc_array,
+					   u32 rsrc_num)
+{
+	bool bit_is_set;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rf->rsrc_lock, flags);
+
+	bit_is_set = test_bit(rsrc_num, rsrc_array);
+	spin_unlock_irqrestore(&rf->rsrc_lock, flags);
+
+	return bit_is_set;
+}
+
+/**
+ * irdma_free_resource - free a resource
+ * @iwdev: device pointer
+ * @resource_array: resource array for the resource_num
+ * @resource_num: resource number to free
+ **/
+static inline void irdma_free_rsrc(struct irdma_pci_f *rf,
+				   unsigned long *rsrc_array,
+				   u32 rsrc_num)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rf->rsrc_lock, flags);
+	clear_bit(rsrc_num, rsrc_array);
+	spin_unlock_irqrestore(&rf->rsrc_lock, flags);
+}
+
+void irdma_init_rf_params(struct irdma_pci_f *rf);
+enum irdma_status_code irdma_ctrl_init_hw(struct irdma_pci_f *rf);
+void irdma_deinit_ctrl_hw(struct irdma_pci_f *rf);
+enum irdma_status_code irdma_rt_init_hw(struct irdma_pci_f *rf, struct irdma_device *iwdev,
+					struct irdma_l2params *l2params);
+void irdma_deinit_rt_device(struct irdma_device *iwdev);
+void irdma_add_ref(struct ib_qp *ibqp);
+void irdma_rem_ref(struct ib_qp *ibqp);
+struct ib_qp *irdma_get_qp(struct ib_device *ibdev, int qpn);
+void irdma_flush_wqes(struct irdma_pci_f *rf,
+		      struct irdma_qp *qp);
+void irdma_manage_arp_cache(struct irdma_pci_f *rf,
+			    unsigned char *mac_addr,
+			    u32 *ip_addr,
+			    bool ipv4,
+			    u32 action);
+int irdma_manage_apbvt(struct irdma_device *iwdev,
+		       u16 accel_local_port,
+		       bool add_port);
+struct irdma_cqp_request *irdma_get_cqp_request(struct irdma_cqp *cqp,
+						bool wait);
+void irdma_free_cqp_request(struct irdma_cqp *cqp,
+			    struct irdma_cqp_request *cqp_request);
+void irdma_put_cqp_request(struct irdma_cqp *cqp,
+			   struct irdma_cqp_request *cqp_request);
+struct irdma_device *irdma_find_netdev(struct net_device *netdev);
+struct irdma_handler *irdma_find_handler(struct pci_dev *pdev);
+struct irdma_device *irdma_find_iwdev(const char *name);
+void irdma_add_handler(struct irdma_handler *hdl);
+void irdma_del_handler(struct irdma_handler *hdl);
+void irdma_add_ip(struct irdma_device *iwdev);
+int irdma_alloc_local_mac_entry(struct irdma_pci_f *rf,
+				u16 *mac_tbl_idx);
+int irdma_add_local_mac_entry(struct irdma_pci_f *rf,
+			      u8 *mac_addr,
+			      u16 idx);
+void irdma_del_local_mac_entry(struct irdma_pci_f *rf, u16 idx);
+
+u32 irdma_initialize_hw_rsrc(struct irdma_pci_f *rf);
+int irdma_register_rdma_device(struct irdma_device *iwdev);
+void irdma_port_ibevent(struct irdma_device *iwdev);
+void irdma_cm_disconn(struct irdma_qp *qp);
+
+enum irdma_status_code irdma_handle_cqp_op(struct irdma_pci_f *rf,
+					   struct irdma_cqp_request *cqp_request);
+
+int irdma_modify_qp(struct ib_qp *ibqp,
+		    struct ib_qp_attr *attr,
+		    int attr_mask,
+		    struct ib_udata *udata);
+int irdma_modify_qp_roce(struct ib_qp *ibqp,
+			 struct ib_qp_attr *attr,
+			 int attr_mask,
+			 struct ib_udata *udata);
+void irdma_cq_wq_destroy(struct irdma_pci_f *rf, struct irdma_sc_cq *cq);
+
+void irdma_cleanup_pending_cqp_op(struct irdma_pci_f *rf);
+void irdma_rem_pdusecount(struct irdma_pd *iwpd, struct irdma_device *iwdev);
+void irdma_add_pdusecount(struct irdma_pd *iwpd);
+void irdma_rem_devusecount(struct irdma_device *iwdev);
+void irdma_add_devusecount(struct irdma_device *iwdev);
+enum irdma_status_code  irdma_hw_modify_qp(struct irdma_device *iwdev,
+					   struct irdma_qp *iwqp,
+					   struct irdma_modify_qp_info *info,
+					   bool wait);
+enum irdma_status_code irdma_qp_suspend_resume(struct irdma_sc_qp *qp,
+					       bool suspend);
+enum irdma_status_code
+irdma_manage_qhash(struct irdma_device *iwdev,
+		   struct irdma_cm_info *cminfo,
+		   enum irdma_quad_entry_type etype,
+		   enum irdma_quad_hash_manage_type mtype,
+		   void *cmnode,
+		   bool wait);
+void irdma_receive_ilq(struct irdma_sc_vsi *vsi, struct irdma_puda_buf *rbuf);
+void irdma_free_sqbuf(struct irdma_sc_vsi *vsi, void *bufp);
+void irdma_free_qp_rsrc(struct irdma_device *iwdev,
+			struct irdma_qp *iwqp,
+			u32 qp_num);
+void irdma_request_reset(struct irdma_pci_f *rf);
+void irdma_destroy_rdma_device(struct irdma_ib_device *iwibdev);
+void irdma_setup_cm_core(struct irdma_device *iwdev, u8 ver);
+void irdma_cleanup_cm_core(struct irdma_cm_core *cm_core);
+void irdma_process_ceq(struct irdma_pci_f *rf, struct irdma_ceq *iwceq);
+void irdma_process_aeq(struct irdma_pci_f *rf);
+void irdma_next_iw_state(struct irdma_qp *iwqp,
+			 u8 state, u8 del_hash,
+			 u8 term, u8 term_len);
+int irdma_send_syn(struct irdma_cm_node *cm_node, u32 sendack);
+int irdma_send_reset(struct irdma_cm_node *cm_node);
+struct irdma_cm_node *irdma_find_node(struct irdma_cm_core *cm_core,
+				      u16 rem_port,
+				      u32 *rem_addr,
+				      u16 loc_port,
+				      u32 *loc_addr,
+				      bool add_refcnt,
+				      bool accelerated_list);
+enum irdma_status_code irdma_hw_flush_wqes(struct irdma_pci_f *rf,
+					   struct irdma_sc_qp *qp,
+					   struct irdma_qp_flush_info *info,
+					   bool wait);
+void irdma_gen_ae(struct irdma_pci_f *rf,
+		  struct irdma_sc_qp *qp,
+		  struct irdma_gen_ae_info *info,
+		  bool wait);
+void irdma_copy_ip_ntohl(u32 *dst, __be32 *src);
+void irdma_copy_ip_htonl(__be32 *dst, u32 *src);
+u16 irdma_get_vlan_ipv4(u32 *addr);
+struct net_device *irdma_netdev_vlan_ipv6(u32 *addr, u16 *vlan_id, u8 *mac);
+struct ib_mr *irdma_reg_phys_mr(struct ib_pd *ib_pd,
+				u64 addr,
+				u64 size,
+				int acc,
+				u64 *iova_start);
+int cqp_compl_thread(void *context);
+int irdma_inetaddr_event(struct notifier_block *notifier,
+			 unsigned long event,
+			 void *ptr);
+int irdma_inet6addr_event(struct notifier_block *notifier,
+			  unsigned long event,
+			  void *ptr);
+int irdma_net_event(struct notifier_block *notifier,
+		    unsigned long event,
+		    void *ptr);
+int irdma_netdevice_event(struct notifier_block *notifier,
+			  unsigned long event,
+			  void *ptr);
+int i40iw_reg_peer_driver(struct irdma_peer *peer, struct net_device *netdev);
+int icrdma_reg_peer_driver(struct irdma_peer *peer, struct net_device *netdev);
+void i40iw_unreg_peer_driver(struct irdma_peer *peer);
+void icrdma_unreg_peer_driver(struct irdma_peer *peer);
+void i40iw_request_reset(struct irdma_pci_f *rf);
+void icrdma_request_reset(struct irdma_pci_f *rf);
+void irdma_probe_inc_ref(struct net_device *netdev);
+void irdma_probe_dec_ref(struct net_device *netdev);
+void irdma_handle_netdev(struct net_device *netdev);
+void irdma_register_notifiers(void);
+void irdma_unregister_notifiers(void);
+void irdma_cqp_ce_handler(struct irdma_pci_f *rf, struct irdma_sc_cq *cq);
+int irdma_ah_cqp_op(struct irdma_pci_f *rf,
+		    struct irdma_sc_ah *sc_ah,
+		    u8 cmd,
+		    bool wait,
+		    void (*callback_fcn)(struct irdma_cqp_request *cqp_request, u32 num),
+		    void *cb_param);
+void irdma_gsi_ud_qp_ah_cb(struct irdma_cqp_request *cqp_request, u32 unused);
+void irdma_destroy_ah_cb(struct irdma_cqp_request *cqp_request, u32 unused);
+int irdma_configfs_init(void);
+void irdma_configfs_exit(void);
+#endif /* IRDMA_MAIN_H */
-- 
1.8.3.1
