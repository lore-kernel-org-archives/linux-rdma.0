From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [RFC][PATCH 2/4] IB/usnic: Cisco VIC - driver part 1/3
Date: Wed, 4 Sep 2013 03:47:09 +0000
Message-ID: <47A33601BBFF7E4B8F0D5D0C96F3022C013BC795@xmb-rcd-x09.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Content-ID: <54EE9A266F85544CB22D75E7A5D3B275-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Christian Benvenuti (benve)" <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
drivers/infiniband/hw/usnic/usnic_abi.h       |   55 ++
drivers/infiniband/hw/usnic/usnic_ib.h        |  115 ++++
drivers/infiniband/hw/usnic/usnic_ib_main.c   |  600 ++++++++++++++++++++
drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c |  542 ++++++++++++++++++
drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h |   97 ++++
drivers/infiniband/hw/usnic/usnic_ib_sysfs.c  |  349 ++++++++++++
drivers/infiniband/hw/usnic/usnic_ib_sysfs.h  |   29 +
drivers/infiniband/hw/usnic/usnic_ib_verbs.c  |  734 +++++++++++++++++++++++++
drivers/infiniband/hw/usnic/usnic_ib_verbs.h  |   72 +++
9 files changed, 2593 insertions(+), 0 deletions(-)
create mode 100644 drivers/infiniband/hw/usnic/usnic_abi.h
create mode 100644 drivers/infiniband/hw/usnic/usnic_ib.h
create mode 100644 drivers/infiniband/hw/usnic/usnic_ib_main.c
create mode 100644 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
create mode 100644 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h
create mode 100644 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
create mode 100644 drivers/infiniband/hw/usnic/usnic_ib_sysfs.h
create mode 100644 drivers/infiniband/hw/usnic/usnic_ib_verbs.c
create mode 100644 drivers/infiniband/hw/usnic/usnic_ib_verbs.h

diff --git a/drivers/infiniband/hw/usnic/usnic_abi.h b/drivers/infiniband/hw/usnic/usnic_abi.h
new file mode 100644
index 0000000..dc2f00d
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_abi.h
@@ -0,0 +1,55 @@
+/*
+ * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+
+#ifndef USNIC_ABI_H
+#define USNIC_ABI_H
+
+#define USNIC_UVERBS_ABI_VERSION	2
+
+#define USNIC_QP_GRP_MAX_WQS		8
+#define USNIC_QP_GRP_MAX_RQS		8
+#define USNIC_QP_GRP_MAX_CQS		16
+
+enum usnic_transport_type {
+	USNIC_TRANSPORT_UNKNOWN		= 0,
+	USNIC_TRANSPORT_ROCE_CUSTOM	= 1,
+	USNIC_TRANSPORT_MAX		= 2,
+};
+
+/*TODO: Future - usnic_modify_qp needs to pass in generic filters */
+struct usnic_ib_create_qp_resp {
+	u32				vfid;
+	u32				qp_grp_id;
+	u64				bar_bus_addr;
+	u32				bar_len;
+/*
+ * WQ, RQ, CQ are explicity specified bc exposing a generic resources inteface
+ * expands the scope of ABI to many files.
+ */
+	u32				wq_cnt;
+	u32				rq_cnt;
+	u32				cq_cnt;
+	u32				wq_idx[USNIC_QP_GRP_MAX_WQS];
+	u32				rq_idx[USNIC_QP_GRP_MAX_RQS];
+	u32				cq_idx[USNIC_QP_GRP_MAX_CQS];
+	u32				transport;
+	u64				reserved;
+};
+
+#endif /* USNIC_ABI_H */
diff --git a/drivers/infiniband/hw/usnic/usnic_ib.h b/drivers/infiniband/hw/usnic/usnic_ib.h
new file mode 100644
index 0000000..3511c85
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_ib.h
@@ -0,0 +1,115 @@
+/*
+ * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#ifndef USNIC_IB_H_
+#define USNIC_IB_H_
+
+#include <linux/iommu.h>
+#include <linux/netdevice.h>
+#include <linux/version.h>
+
+#include <rdma/ib_verbs.h>
+
+
+#include "usnic.h"
+#include "usnic_abi.h"
+#include "usnic_vnic.h"
+
+#define USNIC_IB_PORT_CNT		1
+#define USNIC_IB_NUM_COMP_VECTORS	1
+
+extern unsigned int usnic_ib_share_vf;
+
+struct usnic_ib_ucontext {
+	struct ib_ucontext		ibucontext;
+	/* Protected by usnic_ib_dev->usdev_lock */
+	struct list_head		qp_grp_list;
+	struct list_head		link;
+};
+
+struct usnic_ib_pd {
+	struct ib_pd			ibpd;
+	struct usnic_uiom_pd		*umem_pd;
+};
+
+struct usnic_ib_mr {
+	struct ib_mr			ibmr;
+	struct usnic_uiom_reg		*umem;
+};
+
+struct usnic_ib_dev {
+	struct ib_device		ib_dev;
+	struct pci_dev			*pdev;
+	struct net_device		*netdev;
+	struct usnic_fwd_dev		*ufdev;
+	bool				link_up;
+	struct list_head		ib_dev_link;
+	struct list_head		vf_dev_list;
+	struct list_head		ctx_list;
+	struct mutex			usdev_lock;
+	char				mac[ETH_ALEN];
+	unsigned int			mtu;
+
+	/* provisioning information */
+	struct kref			vf_cnt;
+	unsigned int			vf_res_cnt[USNIC_VNIC_RES_TYPE_MAX];
+
+	/* sysfs vars for QPN reporting */
+	struct kobject *qpn_kobj;
+};
+
+struct usnic_ib_vf {
+	struct usnic_ib_dev		*pf;
+	spinlock_t			lock;
+	struct usnic_vnic		*vnic;
+	unsigned int			qp_grp_ref_cnt;
+	struct usnic_ib_pd		*pd;
+	struct list_head		link;
+};
+
+static inline
+struct usnic_ib_dev *to_usdev(struct ib_device *ibdev)
+{
+	return container_of(ibdev, struct usnic_ib_dev, ib_dev);
+}
+
+static inline
+struct usnic_ib_ucontext *to_ucontext(struct ib_ucontext *ibucontext)
+{
+	return container_of(ibucontext, struct usnic_ib_ucontext, ibucontext);
+}
+
+static inline
+struct usnic_ib_pd *to_upd(struct ib_pd *ibpd)
+{
+	return container_of(ibpd, struct usnic_ib_pd, ibpd);
+}
+
+static inline
+struct usnic_ib_ucontext *to_uucontext(struct ib_ucontext *ibucontext)
+{
+	return container_of(ibucontext, struct usnic_ib_ucontext, ibucontext);
+}
+
+static inline
+struct usnic_ib_mr *to_umr(struct ib_mr *ibmr)
+{
+	return container_of(ibmr, struct usnic_ib_mr, ibmr);
+}
+void usnic_ib_log_vf(struct usnic_ib_vf *vf);
+#endif /* USNIC_IB_H_ */
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
new file mode 100644
index 0000000..5a26592
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -0,0 +1,600 @@
+/*
+ * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ * Author: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
+ * Author: Anant Deepak <anadeepa-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
+ * Author: Cesare Cantu' <cantuc-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
+ * Author: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
+ * Author: Kiran Thirumalai <kithirum-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
+ * Author: Xuyang Wang <xuywang-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
+ * Author: Reese Faucette <rfaucett-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/pci.h>
+#include <linux/netdevice.h>
+
+#include <rdma/ib_user_verbs.h>
+#include <rdma/ib_addr.h>
+
+#include "usnic_abi.h"
+#include "usnic_common_util.h"
+#include "usnic_ib.h"
+#include "usnic_ib_qp_grp.h"
+#include "usnic_log.h"
+#include "usnic_fwd.h"
+#include "usnic_debugfs.h"
+#include "usnic_ib_verbs.h"
+#include "usnic_transport.h"
+#include "usnic_uiom.h"
+#include "usnic_ib_sysfs.h"
+
+unsigned int usnic_log_lvl = USNIC_LOG_LVL_ERR;
+unsigned int usnic_ib_share_vf = 1;
+
+static const char usnic_version[] =
+	DRV_NAME ": Cisco VIC (USNIC) Verbs Driver v"
+	DRV_VERSION " (" DRV_RELDATE ")\n";
+
+static DEFINE_MUTEX(usnic_ib_ibdev_list_lock);
+static LIST_HEAD(usnic_ib_ibdev_list);
+
+/* Callback dump funcs */
+static int usnic_ib_dump_vf_hdr(void *obj, char *buf, int buf_sz)
+{
+	struct usnic_ib_vf *vf = obj;
+	return scnprintf(buf, buf_sz, "PF: %s ", vf->pf->ib_dev.name);
+}
+/* End callback dump funcs */
+
+static void usnic_ib_dump_vf(struct usnic_ib_vf *vf, char *buf, int buf_sz)
+{
+	usnic_vnic_dump(vf->vnic, buf, buf_sz, vf,
+			usnic_ib_dump_vf_hdr,
+			usnic_ib_qp_grp_dump_hdr, usnic_ib_qp_grp_dump_rows);
+}
+
+void usnic_ib_log_vf(struct usnic_ib_vf *vf)
+{
+	char buf[1024];
+	usnic_ib_dump_vf(vf, buf, sizeof(buf));
+	usnic_dbg(buf);
+}
+
+/* Start of netdev section */
+static inline const char *usnic_ib_netdev_event_to_string(unsigned long event)
+{
+	char *event2str[] = { "NETDEV_NONE", "NETDEV_UP", "NETDEV_DOWN",
+		"NETDEV_REBOOT", "NETDEV_CHANGE",
+		"NETDEV_REGISTER", "NETDEV_UNREGISTER", "NETDEV_CHANGEMTU",
+		"NETDEV_CHANGEADDR", "NETDEV_GOING_DOWN", "NETDEV_FEAT_CHANGE",
+		"NETDEV_BONDING_FAILOVER", "NETDEV_PRE_UP",
+		"NETDEV_PRE_TYPE_CHANGE", "NETDEV_POST_TYPE_CHANGE",
+		"NETDEV_POST_INT", "NETDEV_UNREGISTER_FINAL", "NETDEV_RELEASE",
+		"NETDEV_NOTIFY_PEERS", "NETDEV_JOIN"
+	};
+
+	if (event >= sizeof(event2str) / sizeof(event2str[0]))
+		return "UNKNOWN_NETDEV_EVENT";
+	else
+		return event2str[event];
+}
+
+static void usnic_ib_qp_grp_modify_active_to_err(struct usnic_ib_dev *us_ibdev)
+{
+	struct usnic_ib_ucontext *ctx;
+	struct usnic_ib_qp_grp *qp_grp;
+	enum ib_qp_state cur_state;
+	int status;
+
+	BUG_ON(!mutex_is_locked(&us_ibdev->usdev_lock));
+
+	list_for_each_entry(ctx, &us_ibdev->ctx_list, link) {
+		list_for_each_entry(qp_grp, &ctx->qp_grp_list, link) {
+			cur_state = qp_grp->state;
+			if (cur_state == IB_QPS_INIT ||
+				cur_state == IB_QPS_RTR ||
+				cur_state == IB_QPS_RTS) {
+				status = usnic_ib_qp_grp_modify(qp_grp,
+								IB_QPS_ERR,
+								NULL);
+				if (!status) {
+					usnic_err("Failed to transistion qp grp %u from %s to %s\n",
+						qp_grp->grp_id,
+						usnic_ib_qp_grp_state_to_string
+						(cur_state),
+						usnic_ib_qp_grp_state_to_string
+						(IB_QPS_ERR));
+				}
+			}
+		}
+	}
+}
+
+static void usnic_ib_handle_usdev_event(struct usnic_ib_dev *us_ibdev,
+					unsigned long event)
+{
+	struct net_device *netdev;
+	struct ib_event ib_event;
+
+	memset(&ib_event, 0, sizeof(ib_event));
+	mutex_lock(&us_ibdev->usdev_lock);
+
+	netdev = us_ibdev->netdev;
+	switch (event) {
+	case NETDEV_REBOOT:
+		usnic_info("PF Reset on %s\n", us_ibdev->ib_dev.name);
+		usnic_ib_qp_grp_modify_active_to_err(us_ibdev);
+		ib_event.event = IB_EVENT_PORT_ERR;
+		ib_event.device = &us_ibdev->ib_dev;
+		ib_event.element.port_num = 1;
+		ib_dispatch_event(&ib_event);
+		break;
+	case NETDEV_UP:
+		if (!us_ibdev->link_up) {
+			us_ibdev->link_up = true;
+			usnic_info("Link UP on %s\n", us_ibdev->ib_dev.name);
+			ib_event.event = IB_EVENT_PORT_ACTIVE;
+			ib_event.device = &us_ibdev->ib_dev;
+			ib_event.element.port_num = 1;
+			ib_dispatch_event(&ib_event);
+		} else {
+			usnic_dbg("Ignorning Link UP on %s\n",
+					us_ibdev->ib_dev.name);
+		}
+		break;
+	case NETDEV_DOWN:
+		if (us_ibdev->link_up) {
+			us_ibdev->link_up = false;
+			usnic_info("Link DOWN on %s\n", us_ibdev->ib_dev.name);
+			usnic_ib_qp_grp_modify_active_to_err(us_ibdev);
+			ib_event.event = IB_EVENT_PORT_ERR;
+			ib_event.device = &us_ibdev->ib_dev;
+			ib_event.element.port_num = 1;
+			ib_dispatch_event(&ib_event);
+		} else {
+			usnic_dbg("Ignorning Link DOWN on %s\n",
+					us_ibdev->ib_dev.name);
+		}
+		break;
+	case NETDEV_CHANGEADDR:
+		if (!memcmp(us_ibdev->mac, netdev->dev_addr,
+				sizeof(us_ibdev->mac))) {
+			usnic_dbg("Ignorning addr change on %s\n",
+					us_ibdev->ib_dev.name);
+		} else {
+			usnic_info(" %s old mac: %pM new mac: %pM\n",
+					us_ibdev->ib_dev.name,
+					us_ibdev->mac,
+					netdev->dev_addr);
+			memcpy(us_ibdev->mac, netdev->dev_addr,
+				sizeof(us_ibdev->mac));
+			usnic_ib_qp_grp_modify_active_to_err(us_ibdev);
+			ib_event.event = IB_EVENT_GID_CHANGE;
+			ib_event.device = &us_ibdev->ib_dev;
+			ib_event.element.port_num = 1;
+			ib_dispatch_event(&ib_event);
+		}
+
+		break;
+	case NETDEV_CHANGEMTU:
+		if (us_ibdev->mtu != netdev->mtu) {
+			usnic_info("MTU Change on %s old: %u new: %u\n",
+					us_ibdev->ib_dev.name,
+					us_ibdev->mtu, netdev->mtu);
+			us_ibdev->mtu = netdev->mtu;
+			usnic_ib_qp_grp_modify_active_to_err(us_ibdev);
+		} else {
+			usnic_dbg("Ignoring MTU change on %s\n",
+					us_ibdev->ib_dev.name);
+		}
+		break;
+	default:
+		usnic_dbg("Ignorning event %s on %s",
+				usnic_ib_netdev_event_to_string(event),
+				us_ibdev->ib_dev.name);
+	}
+	mutex_unlock(&us_ibdev->usdev_lock);
+}
+
+static int usnic_ib_netdevice_event(struct notifier_block *notifier,
+					unsigned long event, void *ptr)
+{
+	struct usnic_ib_dev *us_ibdev;
+
+	struct net_device *netdev = ptr;
+
+	mutex_lock(&usnic_ib_ibdev_list_lock);
+	list_for_each_entry(us_ibdev, &usnic_ib_ibdev_list, ib_dev_link) {
+		if (us_ibdev->netdev == netdev) {
+			usnic_ib_handle_usdev_event(us_ibdev, event);
+			break;
+		}
+	}
+	mutex_unlock(&usnic_ib_ibdev_list_lock);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block usnic_ib_netdevice_notifier = {
+	.notifier_call = usnic_ib_netdevice_event
+};
+/* End of netdev section */
+
+/* Start of PF discovery section */
+static void *usnic_ib_device_add(struct pci_dev *dev)
+{
+	struct usnic_ib_dev *us_ibdev;
+	union ib_gid gid;
+
+	usnic_dbg("\n");
+
+	us_ibdev = (struct usnic_ib_dev *)ib_alloc_device(sizeof(*us_ibdev));
+
+	if (IS_ERR_OR_NULL(us_ibdev)) {
+		usnic_err("Device %s context alloc failed\n",
+				netdev_name(pci_get_drvdata(dev)));
+		return ERR_PTR(us_ibdev ? PTR_ERR(us_ibdev) : -EFAULT);
+	}
+
+	us_ibdev->ufdev = usnic_fwd_dev_alloc(dev);
+	if (IS_ERR_OR_NULL(us_ibdev->ufdev)) {
+		usnic_err("Failed to alloc ufdev for %s with err %ld\n",
+				pci_name(dev), PTR_ERR(us_ibdev->ufdev));
+		goto err_dealloc;
+	}
+
+	mutex_init(&us_ibdev->usdev_lock);
+	INIT_LIST_HEAD(&us_ibdev->vf_dev_list);
+	INIT_LIST_HEAD(&us_ibdev->ctx_list);
+
+	us_ibdev->pdev = dev;
+	us_ibdev->netdev = pci_get_drvdata(dev);
+	us_ibdev->ib_dev.owner = THIS_MODULE;
+	us_ibdev->ib_dev.node_type = RDMA_NODE_USNIC;
+	us_ibdev->ib_dev.phys_port_cnt = USNIC_IB_PORT_CNT;
+	us_ibdev->ib_dev.num_comp_vectors = USNIC_IB_NUM_COMP_VECTORS;
+	us_ibdev->ib_dev.dma_device = &dev->dev;
+	us_ibdev->ib_dev.uverbs_abi_ver = USNIC_UVERBS_ABI_VERSION;
+	strlcpy(us_ibdev->ib_dev.name, "usnic_%d", IB_DEVICE_NAME_MAX);
+
+	us_ibdev->ib_dev.uverbs_cmd_mask =
+		(1ull << IB_USER_VERBS_CMD_GET_CONTEXT) |
+		(1ull << IB_USER_VERBS_CMD_QUERY_DEVICE) |
+		(1ull << IB_USER_VERBS_CMD_QUERY_PORT) |
+		(1ull << IB_USER_VERBS_CMD_ALLOC_PD) |
+		(1ull << IB_USER_VERBS_CMD_DEALLOC_PD) |
+		(1ull << IB_USER_VERBS_CMD_REG_MR) |
+		(1ull << IB_USER_VERBS_CMD_DEREG_MR) |
+		(1ull << IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL) |
+		(1ull << IB_USER_VERBS_CMD_CREATE_CQ) |
+		(1ull << IB_USER_VERBS_CMD_DESTROY_CQ) |
+		(1ull << IB_USER_VERBS_CMD_CREATE_QP) |
+		(1ull << IB_USER_VERBS_CMD_MODIFY_QP) |
+		(1ull << IB_USER_VERBS_CMD_QUERY_QP) |
+		(1ull << IB_USER_VERBS_CMD_DESTROY_QP) |
+		(1ull << IB_USER_VERBS_CMD_ATTACH_MCAST) |
+		(1ull << IB_USER_VERBS_CMD_DETACH_MCAST) |
+		(1ull << IB_USER_VERBS_CMD_OPEN_QP);
+
+	us_ibdev->ib_dev.query_device = usnic_ib_query_device;
+	us_ibdev->ib_dev.query_port = usnic_ib_query_port;
+	us_ibdev->ib_dev.query_pkey = usnic_ib_query_pkey;
+	us_ibdev->ib_dev.query_gid = usnic_ib_query_gid;
+	us_ibdev->ib_dev.get_link_layer = usnic_ib_port_link_layer;
+	us_ibdev->ib_dev.alloc_pd = usnic_ib_alloc_pd;
+	us_ibdev->ib_dev.dealloc_pd = usnic_ib_dealloc_pd;
+	us_ibdev->ib_dev.create_qp = usnic_ib_create_qp;
+	us_ibdev->ib_dev.modify_qp = usnic_ib_modify_qp;
+	us_ibdev->ib_dev.query_qp = usnic_ib_query_qp;
+	us_ibdev->ib_dev.destroy_qp = usnic_ib_destroy_qp;
+	us_ibdev->ib_dev.create_cq = usnic_ib_create_cq;
+	us_ibdev->ib_dev.destroy_cq = usnic_ib_destroy_cq;
+	us_ibdev->ib_dev.reg_user_mr = usnic_ib_reg_mr;
+	us_ibdev->ib_dev.dereg_mr = usnic_ib_dereg_mr;
+	us_ibdev->ib_dev.alloc_ucontext = usnic_ib_alloc_ucontext;
+	us_ibdev->ib_dev.dealloc_ucontext = usnic_ib_dealloc_ucontext;
+	us_ibdev->ib_dev.mmap = usnic_ib_mmap;
+	us_ibdev->ib_dev.create_ah = usnic_ib_create_ah;
+	us_ibdev->ib_dev.destroy_ah = usnic_ib_destroy_ah;
+	us_ibdev->ib_dev.post_send = usnic_ib_post_send;
+	us_ibdev->ib_dev.post_recv = usnic_ib_post_recv;
+	us_ibdev->ib_dev.poll_cq = usnic_ib_poll_cq;
+	us_ibdev->ib_dev.req_notify_cq = usnic_ib_req_notify_cq;
+	us_ibdev->ib_dev.get_dma_mr = usnic_ib_get_dma_mr;
+
+
+	if (ib_register_device(&us_ibdev->ib_dev, NULL))
+		goto err_fwd_dealloc;
+
+	us_ibdev->link_up = netif_carrier_ok(us_ibdev->netdev);
+	us_ibdev->mtu = us_ibdev->netdev->mtu;
+	memcpy(&us_ibdev->mac, us_ibdev->netdev->dev_addr,
+		sizeof(us_ibdev->mac));
+	usnic_mac_to_gid(us_ibdev->netdev->perm_addr, &gid.raw[0]);
+	memcpy(&us_ibdev->ib_dev.node_guid, &gid.global.interface_id,
+		sizeof(gid.global.interface_id));
+	kref_init(&us_ibdev->vf_cnt);
+
+	usnic_info("Added ibdev: %s netdev: %s with mac %pM Link: %u MTU: %u\n",
+			us_ibdev->ib_dev.name, netdev_name(us_ibdev->netdev),
+			us_ibdev->mac, us_ibdev->link_up, us_ibdev->mtu);
+	return us_ibdev;
+
+err_fwd_dealloc:
+	usnic_fwd_dev_free(us_ibdev->ufdev);
+err_dealloc:
+	usnic_err("failed -- deallocing device\n");
+	ib_dealloc_device(&us_ibdev->ib_dev);
+	return NULL;
+}
+
+static void usnic_ib_device_remove(struct usnic_ib_dev *us_ibdev)
+{
+	usnic_info("Unregistering %s\n", us_ibdev->ib_dev.name);
+	usnic_ib_sysfs_unregister_usdev(us_ibdev);
+	usnic_fwd_dev_free(us_ibdev->ufdev);
+	ib_unregister_device(&us_ibdev->ib_dev);
+	ib_dealloc_device(&us_ibdev->ib_dev);
+}
+
+static void usnic_ib_undiscover_pf(struct kref *kref)
+{
+	struct usnic_ib_dev *us_ibdev, *tmp;
+	struct pci_dev *dev;
+	bool found = false;
+
+	dev = container_of(kref, struct usnic_ib_dev, vf_cnt)->pdev;
+	mutex_lock(&usnic_ib_ibdev_list_lock);
+	list_for_each_entry_safe(us_ibdev, tmp,
+				&usnic_ib_ibdev_list, ib_dev_link) {
+		if (us_ibdev->pdev == dev) {
+			list_del(&us_ibdev->ib_dev_link);
+			usnic_ib_device_remove(us_ibdev);
+			found = true;
+			break;
+		}
+	}
+
+	if (!found)
+		WARN("Failed to remove PF %s\n", pci_name(dev));
+
+	mutex_unlock(&usnic_ib_ibdev_list_lock);
+}
+
+static struct usnic_ib_dev *usnic_ib_discover_pf(struct usnic_vnic *vnic)
+{
+	struct usnic_ib_dev *us_ibdev;
+	struct pci_dev *parent_pci, *vf_pci;
+	int err;
+
+	vf_pci = usnic_vnic_get_pdev(vnic);
+	parent_pci = pci_physfn(vf_pci);
+
+	BUG_ON(!parent_pci);
+
+	mutex_lock(&usnic_ib_ibdev_list_lock);
+	list_for_each_entry(us_ibdev, &usnic_ib_ibdev_list, ib_dev_link) {
+		if (us_ibdev->pdev == parent_pci) {
+			kref_get(&us_ibdev->vf_cnt);
+			goto out;
+		}
+	}
+
+	us_ibdev = usnic_ib_device_add(parent_pci);
+	if (IS_ERR_OR_NULL(us_ibdev)) {
+		us_ibdev = ERR_PTR(-EINVAL);
+		goto out;
+	}
+
+	err = usnic_ib_sysfs_register_usdev(us_ibdev);
+	if (err) {
+		usnic_ib_device_remove(us_ibdev);
+		goto out;
+	}
+
+	list_add(&us_ibdev->ib_dev_link, &usnic_ib_ibdev_list);
+out:
+	mutex_unlock(&usnic_ib_ibdev_list_lock);
+	return us_ibdev;
+}
+/* End of PF discovery section */
+
+/* Start of PCI section */
+
+static DEFINE_PCI_DEVICE_TABLE(usnic_ib_pci_ids) = {
+	{PCI_DEVICE(PCI_VENDOR_ID_CISCO, PCI_DEVICE_ID_CISCO_VIC_USPACE_NIC)},
+	{0,}
+};
+
+int usnic_ib_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	int err;
+	struct usnic_ib_dev *pf;
+	struct usnic_ib_vf *vf;
+	enum usnic_vnic_res_type res_type;
+
+	vf = kzalloc(sizeof(*vf), GFP_KERNEL);
+	if (!vf)
+		return -ENOMEM;
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		usnic_err("Failed to enable %s with err %d\n",
+				pci_name(pdev), err);
+		goto out_clean_vf;
+	}
+
+	err = pci_request_regions(pdev, DRV_NAME);
+	if (err) {
+		usnic_err("Failed to request region for %s with err %d\n",
+				pci_name(pdev), err);
+		goto out_disable_device;
+	}
+
+	pci_set_master(pdev);
+	pci_set_drvdata(pdev, vf);
+
+	vf->vnic = usnic_vnic_alloc(pdev);
+	if (IS_ERR_OR_NULL(vf->vnic)) {
+		err = (vf->vnic ? PTR_ERR(vf->vnic) : -ENOMEM);
+		usnic_err("Failed to alloc vnic for %s with err %d\n",
+				pci_name(pdev), err);
+		goto out_release_regions;
+	}
+
+	pf = usnic_ib_discover_pf(vf->vnic);
+	if (!pf) {
+		usnic_err("Failed to discover pf of vnic %s with err%d\n",
+				pci_name(pdev), err);
+		goto out_clean_vnic;
+	}
+
+	vf->pf = pf;
+	spin_lock_init(&vf->lock);
+	mutex_lock(&pf->usdev_lock);
+	list_add_tail(&vf->link, &pf->vf_dev_list);
+	/*
+	 * Save max settings (will be same for each VF, easier to re-write than
+	 * to say "if (!set) { set_values(); set=1; }
+	 */
+	for (res_type = USNIC_VNIC_RES_TYPE_EOL+1;
+			res_type < USNIC_VNIC_RES_TYPE_MAX;
+			res_type++) {
+		pf->vf_res_cnt[res_type] = usnic_vnic_res_cnt(vf->vnic,
+								res_type);
+	}
+
+	mutex_unlock(&pf->usdev_lock);
+
+	usnic_info("Registering usnic VF %s into PF %s\n", pci_name(pdev),
+			pf->ib_dev.name);
+	usnic_ib_log_vf(vf);
+
+	return 0;
+
+out_clean_vnic:
+	usnic_vnic_free(vf->vnic);
+out_release_regions:
+	pci_set_drvdata(pdev, NULL);
+	pci_clear_master(pdev);
+	pci_release_regions(pdev);
+out_disable_device:
+	pci_disable_device(pdev);
+out_clean_vf:
+	kfree(vf);
+
+	return err;
+}
+
+static void usnic_ib_pci_remove(struct pci_dev *pdev)
+{
+	struct usnic_ib_vf *vf = pci_get_drvdata(pdev);
+	struct usnic_ib_dev *pf = vf->pf;
+
+	mutex_lock(&pf->usdev_lock);
+	list_del(&vf->link);
+	mutex_unlock(&pf->usdev_lock);
+
+	kref_put(&pf->vf_cnt, usnic_ib_undiscover_pf);
+	usnic_vnic_free(vf->vnic);
+	pci_set_drvdata(pdev, NULL);
+	pci_clear_master(pdev);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	kfree(vf);
+
+	usnic_info("Removed VF %s\n", pci_name(pdev));
+}
+
+/* PCI driver entry points */
+static struct pci_driver usnic_ib_pci_driver = {
+	.name = DRV_NAME,
+	.id_table = usnic_ib_pci_ids,
+	.probe = usnic_ib_pci_probe,
+	.remove = usnic_ib_pci_remove,
+};
+/* End of PCI section */
+
+/* Start of module section */
+static int __init usnic_ib_init(void)
+{
+	int err;
+
+	printk_once(KERN_INFO "%s", usnic_version);
+
+	err = usnic_uiom_init(DRV_NAME);
+	if (err) {
+		usnic_err("Unable to initalize umem with err %d\n", err);
+		return err;
+	}
+
+	if (pci_register_driver(&usnic_ib_pci_driver)) {
+		usnic_err("Unable to register with PCI\n");
+		goto out_umem_fini;
+	}
+
+	err = register_netdevice_notifier(&usnic_ib_netdevice_notifier);
+	if (err) {
+		usnic_err("Failed to register netdev notifier\n");
+		goto out_pci_unreg;
+	}
+
+	err = usnic_transport_init();
+	if (err) {
+		usnic_err("Failed to initialize transport\n");
+		goto out_unreg_netdev_notifier;
+	}
+
+	usnic_debugfs_init();
+
+	return 0;
+
+out_unreg_netdev_notifier:
+	unregister_netdevice_notifier(&usnic_ib_netdevice_notifier);
+out_pci_unreg:
+	pci_unregister_driver(&usnic_ib_pci_driver);
+out_umem_fini:
+	usnic_uiom_fini();
+
+	return err;
+}
+
+static void __exit usnic_ib_destroy(void)
+{
+	usnic_dbg("\n");
+	usnic_debugfs_exit();
+	unregister_netdevice_notifier(&usnic_ib_netdevice_notifier);
+	pci_unregister_driver(&usnic_ib_pci_driver);
+	usnic_uiom_fini();
+}
+
+MODULE_DESCRIPTION("Cisco VIC (usNIC) Verbs Driver");
+MODULE_AUTHOR("Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_VERSION(DRV_VERSION);
+module_param(usnic_log_lvl, uint, S_IRUGO | S_IWUSR);
+module_param(usnic_ib_share_vf, uint, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(usnic_log_lvl, " Off=0, Err=1, Info=2, Debug=3");
+MODULE_PARM_DESC(usnic_ib_share_vf, "Off=0, On=1 VF sharing amongst QPs");
+MODULE_DEVICE_TABLE(pci, usnic_ib_pci_ids);
+
+module_init(usnic_ib_init);
+module_exit(usnic_ib_destroy);
+/* End of module section */
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
new file mode 100644
index 0000000..2147148
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
@@ -0,0 +1,542 @@
+/*
+ * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+
+#include "usnic_log.h"
+#include "usnic_vnic.h"
+#include "usnic_fwd.h"
+#include "usnic_uiom.h"
+#include "usnic_ib_qp_grp.h"
+#include "usnic_ib_sysfs.h"
+#include "usnic_transport.h"
+
+const char *usnic_ib_qp_grp_state_to_string(enum ib_qp_state state)
+{
+	switch (state) {
+	case IB_QPS_RESET:
+		return "Rst";
+	case IB_QPS_INIT:
+		return "Init";
+	case IB_QPS_RTR:
+		return "RTR";
+	case IB_QPS_RTS:
+		return "RTS";
+	case IB_QPS_SQD:
+		return "SQD";
+	case IB_QPS_SQE:
+		return "SQE";
+	case IB_QPS_ERR:
+		return "ERR";
+	default:
+		return "UNKOWN STATE";
+
+	}
+}
+
+int usnic_ib_qp_grp_dump_hdr(char *buf, int buf_sz)
+{
+	return scnprintf(buf, buf_sz, "|QPN\t|State\t|PID\t|VF Idx\t|Fil ID");
+}
+
+int usnic_ib_qp_grp_dump_rows(void *obj, char *buf, int buf_sz)
+{
+	struct usnic_ib_qp_grp *qp_grp = obj;
+	struct usnic_fwd_filter_hndl *default_filter_hndl;
+	if (obj) {
+		default_filter_hndl = list_first_entry(&qp_grp->filter_hndls,
+					struct usnic_fwd_filter_hndl, link);
+		return scnprintf(buf, buf_sz, "|%d\t|%s\t|%d\t|%hu\t|%d",
+					qp_grp->ibqp.qp_num,
+					usnic_ib_qp_grp_state_to_string(
+							qp_grp->state),
+					qp_grp->owner_pid,
+					usnic_vnic_get_index(qp_grp->vf->vnic),
+					default_filter_hndl->id);
+	} else {
+		return scnprintf(buf, buf_sz, "|N/A\t|N/A\t|N/A\t|N/A\t|N/A");
+	}
+}
+
+static int add_fwd_filter(struct usnic_ib_qp_grp *qp_grp,
+				struct usnic_fwd_filter *fwd_filter)
+{
+	struct usnic_fwd_filter_hndl *filter_hndl;
+	int status;
+	struct usnic_vnic_res_chunk *chunk;
+	int rq_idx;
+
+	BUG_ON(!spin_is_locked(&qp_grp->lock));
+
+	chunk = usnic_ib_qp_grp_get_chunk(qp_grp, USNIC_VNIC_RES_TYPE_RQ);
+
+	if (IS_ERR_OR_NULL(chunk) || chunk->cnt < 1) {
+		usnic_err("Failed to get RQ info for qp_grp %u\n",
+				qp_grp->grp_id);
+		return -EFAULT;
+	}
+	rq_idx = chunk->res[0]->vnic_idx;
+
+	switch (qp_grp->transport) {
+	case USNIC_TRANSPORT_ROCE_CUSTOM:
+		status = usnic_fwd_add_usnic_filter(qp_grp->ufdev,
+					usnic_vnic_get_index(qp_grp->vf->vnic),
+					rq_idx,
+					fwd_filter,
+					&filter_hndl);
+		break;
+	default:
+		usnic_err("Unable to install filter for qp_grp %u for transport %d",
+				qp_grp->grp_id, qp_grp->transport);
+		status = -EINVAL;
+	}
+
+	if (status)
+		return status;
+
+	list_add_tail(&filter_hndl->link, &qp_grp->filter_hndls);
+	return 0;
+}
+
+static int del_all_filters(struct usnic_ib_qp_grp *qp_grp)
+{
+	int err, status;
+	struct usnic_fwd_filter_hndl *filter_hndl, *tmp;
+
+	BUG_ON(!spin_is_locked(&qp_grp->lock));
+
+	status = 0;
+	list_for_each_entry_safe(filter_hndl, tmp,
+					&qp_grp->filter_hndls, link) {
+		list_del(&filter_hndl->link);
+		err = usnic_fwd_del_filter(filter_hndl);
+		if (err) {
+			usnic_err("Failed to delete filter %u of qp_grp %d\n",
+					filter_hndl->id, qp_grp->grp_id);
+		}
+		status |= err;
+	}
+
+	return status;
+}
+
+static int enable_qp_grp(struct usnic_ib_qp_grp *qp_grp)
+{
+
+	int status;
+	int i, vnic_idx;
+	struct usnic_vnic_res_chunk *res_chunk;
+	struct usnic_vnic_res *res;
+
+	BUG_ON(!spin_is_locked(&qp_grp->lock));
+
+	vnic_idx = usnic_vnic_get_index(qp_grp->vf->vnic);
+
+	res_chunk = usnic_ib_qp_grp_get_chunk(qp_grp, USNIC_VNIC_RES_TYPE_RQ);
+	if (IS_ERR_OR_NULL(res_chunk)) {
+		usnic_err("Unable to get %s with err %ld\n",
+			usnic_vnic_res_type_to_str(USNIC_VNIC_RES_TYPE_RQ),
+			PTR_ERR(res_chunk));
+		return res_chunk ? PTR_ERR(res_chunk) : -ENOMEM;
+	}
+
+	for (i = 0; i < res_chunk->cnt; i++) {
+		res = res_chunk->res[i];
+		status = usnic_fwd_enable_rq(qp_grp->ufdev, vnic_idx,
+						res->vnic_idx);
+		if (status) {
+			usnic_err("Failed to enable rq %d of %s:%d\n with err %d\n",
+					res->vnic_idx,
+					netdev_name(qp_grp->ufdev->netdev),
+					vnic_idx, status);
+			goto out_err;
+		}
+	}
+
+	return 0;
+
+out_err:
+	for (i--; i >= 0; i--) {
+		res = res_chunk->res[i];
+		usnic_fwd_disable_rq(qp_grp->ufdev, vnic_idx,
+					res->vnic_idx);
+	}
+	return status;
+}
+
+static int disable_qp_grp(struct usnic_ib_qp_grp *qp_grp)
+{
+	int i, vnic_idx;
+	struct usnic_vnic_res_chunk *res_chunk;
+	struct usnic_vnic_res *res;
+	int status = 0;
+
+	BUG_ON(!spin_is_locked(&qp_grp->lock));
+	vnic_idx = usnic_vnic_get_index(qp_grp->vf->vnic);
+
+	res_chunk = usnic_ib_qp_grp_get_chunk(qp_grp, USNIC_VNIC_RES_TYPE_RQ);
+	if (IS_ERR_OR_NULL(res_chunk)) {
+		usnic_err("Unable to get %s with err %ld\n",
+			usnic_vnic_res_type_to_str(USNIC_VNIC_RES_TYPE_RQ),
+			PTR_ERR(res_chunk));
+		return res_chunk ? PTR_ERR(res_chunk) : -ENOMEM;
+	}
+
+	for (i = 0; i < res_chunk->cnt; i++) {
+		res = res_chunk->res[i];
+		status = usnic_fwd_disable_rq(qp_grp->ufdev, vnic_idx,
+						res->vnic_idx);
+		if (status) {
+			usnic_err("Failed to disable rq %d of %s:%d\n with err %d\n",
+					res->vnic_idx,
+					netdev_name(qp_grp->ufdev->netdev),
+					vnic_idx, status);
+		}
+	}
+
+	return status;
+
+}
+
+int usnic_ib_qp_grp_modify(struct usnic_ib_qp_grp *qp_grp,
+				enum ib_qp_state new_state,
+				struct usnic_fwd_filter *fwd_filter)
+{
+	int status = 0;
+	int vnic_idx;
+	struct ib_event ib_event;
+	enum ib_qp_state old_state;
+
+	old_state = qp_grp->state;
+	vnic_idx = usnic_vnic_get_index(qp_grp->vf->vnic);
+
+	spin_lock(&qp_grp->lock);
+
+	switch (new_state) {
+	case IB_QPS_RESET:
+		switch (old_state) {
+		case IB_QPS_RESET:
+			/* NO-OP */
+			break;
+		case IB_QPS_INIT:
+			status = del_all_filters(qp_grp);
+			break;
+		case IB_QPS_RTR:
+		case IB_QPS_RTS:
+		case IB_QPS_ERR:
+			status = disable_qp_grp(qp_grp);
+			status &= del_all_filters(qp_grp);
+			break;
+		default:
+			status = -EINVAL;
+		}
+		break;
+	case IB_QPS_INIT:
+		switch (old_state) {
+		case IB_QPS_RESET:
+			status = add_fwd_filter(qp_grp, fwd_filter);
+			break;
+		case IB_QPS_INIT:
+			status = add_fwd_filter(qp_grp, fwd_filter);
+			break;
+		case IB_QPS_RTR:
+			status = disable_qp_grp(qp_grp);
+			break;
+		case IB_QPS_RTS:
+			status = disable_qp_grp(qp_grp);
+			break;
+		default:
+			status = -EINVAL;
+		}
+		break;
+	case IB_QPS_RTR:
+		switch (old_state) {
+		case IB_QPS_INIT:
+			status = enable_qp_grp(qp_grp);
+			break;
+		default:
+			status = -EINVAL;
+		}
+		break;
+	case IB_QPS_RTS:
+		switch (old_state) {
+		case IB_QPS_RTR:
+			/* NO-OP FOR NOW */
+			break;
+		default:
+			status = -EINVAL;
+		}
+		break;
+	case IB_QPS_ERR:
+		ib_event.device = &qp_grp->vf->pf->ib_dev;
+		ib_event.element.qp = &qp_grp->ibqp;
+		ib_event.event = IB_EVENT_QP_FATAL;
+
+		switch (old_state) {
+		case IB_QPS_RESET:
+			qp_grp->ibqp.event_handler(&ib_event,
+					qp_grp->ibqp.qp_context);
+			break;
+		case IB_QPS_INIT:
+			status = del_all_filters(qp_grp);
+			qp_grp->ibqp.event_handler(&ib_event,
+					qp_grp->ibqp.qp_context);
+			break;
+		case IB_QPS_RTR:
+		case IB_QPS_RTS:
+			status = disable_qp_grp(qp_grp);
+			status &= del_all_filters(qp_grp);
+			qp_grp->ibqp.event_handler(&ib_event,
+					qp_grp->ibqp.qp_context);
+			break;
+		default:
+			status = -EINVAL;
+		}
+		break;
+	default:
+		status = -EINVAL;
+	}
+	spin_unlock(&qp_grp->lock);
+
+	if (!status) {
+		qp_grp->state = new_state;
+		usnic_info("Transistioned %u from %s to %s",
+		qp_grp->grp_id,
+		usnic_ib_qp_grp_state_to_string(old_state),
+		usnic_ib_qp_grp_state_to_string(new_state));
+	} else {
+		usnic_err("Failed to transistion %u from %s to %s",
+		qp_grp->grp_id,
+		usnic_ib_qp_grp_state_to_string(old_state),
+		usnic_ib_qp_grp_state_to_string(new_state));
+	}
+
+	return status;
+}
+
+struct usnic_vnic_res_chunk**
+alloc_res_chunk_list(struct usnic_vnic *vnic, const struct usnic_vnic_res_spec
+			const *res_spec, void *owner_obj)
+{
+	enum usnic_vnic_res_type res_type;
+	struct usnic_vnic_res_chunk **res_chunk_list;
+	int err, i, res_cnt, res_lst_sz;
+
+	for (res_lst_sz = 0;
+		res_spec->resources[res_lst_sz].type != USNIC_VNIC_RES_TYPE_EOL;
+		res_lst_sz++) {
+		/* Do Nothing */
+	}
+
+	res_chunk_list = kzalloc(sizeof(*res_chunk_list)*(res_lst_sz+1),
+					GFP_KERNEL);
+
+	if (!res_chunk_list)
+		return ERR_PTR(-ENOMEM);
+
+	for (i = 0; res_spec->resources[i].type != USNIC_VNIC_RES_TYPE_EOL;
+		i++) {
+		res_type = res_spec->resources[i].type;
+		res_cnt = res_spec->resources[i].cnt;
+
+		res_chunk_list[i] = usnic_vnic_get_resources(vnic, res_type,
+					res_cnt, owner_obj);
+		if (IS_ERR_OR_NULL(res_chunk_list[i])) {
+			err = (res_chunk_list[i] ?
+					PTR_ERR(res_chunk_list[i]) : -ENOMEM);
+			usnic_err("Failed to get %s from %s with err %d\n",
+				usnic_vnic_res_type_to_str(res_type),
+				usnic_vnic_pci_name(vnic),
+				err);
+			goto out_free_res;
+		}
+	}
+
+	return res_chunk_list;
+
+out_free_res:
+	for (i--; i > 0; i--)
+		usnic_vnic_put_resources(res_chunk_list[i]);
+	kfree(res_chunk_list);
+
+	return ERR_PTR(err);
+}
+
+void free_qp_grp_res(struct usnic_vnic_res_chunk **res_chunk_list)
+{
+	int i;
+	for (i = 0; res_chunk_list[i]; i++)
+		usnic_vnic_put_resources(res_chunk_list[i]);
+	kfree(res_chunk_list);
+}
+
+static int qp_grp_and_vf_bind(struct usnic_ib_vf *vf,
+				struct usnic_ib_pd *pd,
+				struct usnic_ib_qp_grp *qp_grp)
+{
+	int err;
+	struct pci_dev *pdev;
+
+	BUG_ON(!spin_is_locked(&vf->lock));
+
+	pdev = usnic_vnic_get_pdev(vf->vnic);
+	if (vf->qp_grp_ref_cnt++ == 0) {
+		vf->pd = pd;
+		err = usnic_uiom_attach_dev_to_pd(pd->umem_pd, &pdev->dev);
+		if (err) {
+			usnic_err("Failed to attach %s to domain\n",
+					pci_name(pdev));
+			return err;
+		}
+	}
+
+	WARN_ON(vf->pd != pd);
+	qp_grp->vf = vf;
+
+	return 0;
+}
+
+static void qp_grp_and_vf_unbind(struct usnic_ib_qp_grp *qp_grp)
+{
+	struct pci_dev *pdev;
+	struct usnic_ib_pd *pd;
+
+	BUG_ON(!spin_is_locked(&qp_grp->vf->lock));
+
+	pd = qp_grp->vf->pd;
+	pdev = usnic_vnic_get_pdev(qp_grp->vf->vnic);
+	if (--qp_grp->vf->qp_grp_ref_cnt == 0) {
+		qp_grp->vf->pd = NULL;
+		usnic_uiom_detach_dev_from_pd(pd->umem_pd, &pdev->dev);
+	}
+	qp_grp->vf = NULL;
+}
+
+static void log_spec(const struct usnic_vnic_res_spec
+					const *res_spec)
+{
+	char buf[1024];
+	usnic_vnic_spec_dump(buf, sizeof(buf), res_spec);
+	usnic_dbg(buf);
+}
+
+struct usnic_ib_qp_grp *usnic_ib_qp_grp_create(struct usnic_fwd_dev *ufdev,
+				struct usnic_ib_vf *vf,
+				struct usnic_ib_pd *pd,
+				const struct usnic_vnic_res_spec
+				const *res_spec,
+				enum usnic_transport_type transport)
+{
+	struct usnic_ib_qp_grp *qp_grp;
+	u16 port_num;
+	int err;
+
+	BUG_ON(!spin_is_locked(&vf->lock));
+
+	err = usnic_vnic_res_spec_satisfied(&min_transport_spec[transport],
+						res_spec);
+	if (err) {
+		usnic_err("Spec does not meet miniumum req for transport %d\n",
+				transport);
+		log_spec(res_spec);
+		return ERR_PTR(err);
+	}
+
+	port_num = usnic_transport_rsrv_port(transport, 0);
+	if (!port_num) {
+		usnic_err("Unable to allocate port for %s\n",
+				netdev_name(ufdev->netdev));
+		return ERR_PTR(-EINVAL);
+	}
+
+	qp_grp = kzalloc(sizeof(*qp_grp), GFP_KERNEL);
+	if (!qp_grp) {
+		usnic_err("Unable to alloc qp_grp - Out of memory\n");
+		return NULL;
+	}
+
+	qp_grp->res_chunk_list = alloc_res_chunk_list(vf->vnic, res_spec,
+							qp_grp);
+	if (IS_ERR_OR_NULL(qp_grp->res_chunk_list)) {
+		err = qp_grp->res_chunk_list ?
+				PTR_ERR(qp_grp->res_chunk_list) : -ENOMEM;
+		usnic_err("Unable to alloc res for %d with err %d\n",
+				qp_grp->grp_id, err);
+		goto out_free_port;
+	}
+
+	INIT_LIST_HEAD(&qp_grp->filter_hndls);
+	spin_lock_init(&qp_grp->lock);
+	qp_grp->ufdev = ufdev;
+	qp_grp->transport = transport;
+	qp_grp->filters[DFLT_FILTER_IDX].transport = transport;
+	qp_grp->filters[DFLT_FILTER_IDX].port_num = port_num;
+	qp_grp->state = IB_QPS_RESET;
+	qp_grp->owner_pid = current->pid;
+
+	/* qp_num is same as default filter port_num */
+	qp_grp->ibqp.qp_num = qp_grp->filters[DFLT_FILTER_IDX].port_num;
+	qp_grp->grp_id = qp_grp->ibqp.qp_num;
+
+	err = qp_grp_and_vf_bind(vf, pd, qp_grp);
+	if (err)
+		goto out_free_port;
+
+	usnic_ib_sysfs_qpn_add(qp_grp);
+
+	return qp_grp;
+
+out_free_port:
+	kfree(qp_grp);
+	usnic_transport_unrsrv_port(transport, port_num);
+
+	return ERR_PTR(err);
+}
+
+void usnic_ib_qp_grp_destroy(struct usnic_ib_qp_grp *qp_grp)
+{
+	u16 default_port_num;
+	enum usnic_transport_type transport;
+
+	WARN_ON(qp_grp->state != IB_QPS_RESET);
+	BUG_ON(!spin_is_locked(&qp_grp->vf->lock));
+
+	transport = qp_grp->filters[DFLT_FILTER_IDX].transport;
+	default_port_num = qp_grp->filters[DFLT_FILTER_IDX].port_num;
+
+	usnic_ib_sysfs_qpn_remove(qp_grp);
+	qp_grp_and_vf_unbind(qp_grp);
+	free_qp_grp_res(qp_grp->res_chunk_list);
+	kfree(qp_grp);
+	usnic_transport_unrsrv_port(transport, default_port_num);
+}
+
+struct usnic_vnic_res_chunk*
+usnic_ib_qp_grp_get_chunk(struct usnic_ib_qp_grp *qp_grp,
+				enum usnic_vnic_res_type res_type)
+{
+	int i;
+
+	for (i = 0; qp_grp->res_chunk_list[i]; i++) {
+		if (qp_grp->res_chunk_list[i]->type == res_type)
+			return qp_grp->res_chunk_list[i];
+	}
+
+	return ERR_PTR(-EINVAL);
+}
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h
new file mode 100644
index 0000000..193c9df
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h
@@ -0,0 +1,97 @@
+/*
+ * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#ifndef USNIC_IB_QP_GRP_H_
+#define USNIC_IB_QP_GRP_H_
+
+#include <rdma/ib_verbs.h>
+
+#include "usnic_ib.h"
+#include "usnic_abi.h"
+#include "usnic_fwd.h"
+#include "usnic_vnic.h"
+
+#define MAX_QP_GRP_FILTERS	10
+#define DFLT_FILTER_IDX		0
+
+/*
+ * The qp group struct represents all the hw resources needed to present a ib_qp
+ */
+struct usnic_ib_qp_grp {
+	struct ib_qp			ibqp;
+	enum ib_qp_state		state;
+	int				grp_id;
+
+	struct usnic_fwd_dev		*ufdev;
+	short unsigned			filter_cnt;
+	struct usnic_fwd_filter		filters[MAX_QP_GRP_FILTERS];
+	struct list_head		filter_hndls;
+	enum usnic_transport_type	transport;
+	struct usnic_ib_ucontext	*ctx;
+
+	struct usnic_vnic_res_chunk	**res_chunk_list;
+
+	pid_t				owner_pid;
+	struct usnic_ib_vf		*vf;
+	struct list_head		link;
+
+	spinlock_t			lock;
+
+	struct kobject			kobj;
+};
+
+static const struct
+usnic_vnic_res_spec min_transport_spec[USNIC_TRANSPORT_MAX] = {
+	{ /*USNIC_TRANSPORT_UNKNOWN*/
+		.resources = {
+			{.type = USNIC_VNIC_RES_TYPE_EOL,	.cnt = 0,},
+		},
+	},
+	{ /*USNIC_TRANSPORT_ROCE_CUSTOM*/
+		.resources = {
+			{.type = USNIC_VNIC_RES_TYPE_WQ,	.cnt = 1,},
+			{.type = USNIC_VNIC_RES_TYPE_RQ,	.cnt = 1,},
+			{.type = USNIC_VNIC_RES_TYPE_CQ,	.cnt = 1,},
+			{.type = USNIC_VNIC_RES_TYPE_EOL,	.cnt = 0,},
+		},
+	},
+};
+
+const char *usnic_ib_qp_grp_state_to_string(enum ib_qp_state state);
+int usnic_ib_qp_grp_dump_hdr(char *buf, int buf_sz);
+int usnic_ib_qp_grp_dump_rows(void *obj, char *buf, int buf_sz);
+struct usnic_ib_qp_grp *usnic_ib_qp_grp_create(struct usnic_fwd_dev *ufdev,
+						struct usnic_ib_vf *vf,
+						struct usnic_ib_pd *pd,
+						const struct usnic_vnic_res_spec
+						const *res_spec,
+						enum usnic_transport_type
+							transport);
+void usnic_ib_qp_grp_destroy(struct usnic_ib_qp_grp *qp_grp);
+int usnic_ib_qp_grp_modify(struct usnic_ib_qp_grp *qp_grp,
+				enum ib_qp_state new_state,
+				struct usnic_fwd_filter *fwd_filter);
+struct usnic_vnic_res_chunk
+*usnic_ib_qp_grp_get_chunk(struct usnic_ib_qp_grp *qp_grp,
+				enum usnic_vnic_res_type type);
+static inline
+struct usnic_ib_qp_grp *to_uqp_grp(struct ib_qp *ibqp)
+{
+	return container_of(ibqp, struct usnic_ib_qp_grp, ibqp);
+}
+#endif /* USNIC_IB_QP_GRP_H_ */
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
new file mode 100644
index 0000000..246236e
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
@@ -0,0 +1,349 @@
+/*
+ * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+
+#include <rdma/ib_user_verbs.h>
+#include <rdma/ib_addr.h>
+
+#include "usnic_common_util.h"
+#include "usnic_ib.h"
+#include "usnic_ib_qp_grp.h"
+#include "usnic_vnic.h"
+#include "usnic_ib_verbs.h"
+#include "usnic_log.h"
+
+#define UPDATE_PTR_LEFT(N, P, L)			\
+do {							\
+	L -= (N);					\
+	P += (N);					\
+} while (0)
+
+static ssize_t usnic_ib_show_fw_ver(struct device *device,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct usnic_ib_dev *us_ibdev =
+		container_of(device, struct usnic_ib_dev, ib_dev.dev);
+	struct ethtool_drvinfo info;
+
+	mutex_lock(&us_ibdev->usdev_lock);
+	us_ibdev->netdev->ethtool_ops->get_drvinfo(us_ibdev->netdev, &info);
+	mutex_unlock(&us_ibdev->usdev_lock);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", info.fw_version);
+}
+
+static ssize_t usnic_ib_show_board(struct device *device,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct usnic_ib_dev *us_ibdev =
+		container_of(device, struct usnic_ib_dev, ib_dev.dev);
+	unsigned short subsystem_device_id;
+
+	mutex_lock(&us_ibdev->usdev_lock);
+	subsystem_device_id = us_ibdev->pdev->subsystem_device;
+	mutex_unlock(&us_ibdev->usdev_lock);
+	return scnprintf(buf, PAGE_SIZE, "%hu\n", subsystem_device_id);
+}
+
+/*
+ * Report the configuration for this PF
+ */
+static ssize_t
+usnic_ib_show_config(struct device *device, struct device_attribute *attr,
+			char *buf)
+{
+	struct usnic_ib_dev *us_ibdev;
+	char *ptr;
+	unsigned left;
+	unsigned n;
+	enum usnic_vnic_res_type res_type;
+
+	us_ibdev = container_of(device, struct usnic_ib_dev, ib_dev.dev);
+
+	/* Buffer space limit is 1 page */
+	ptr = buf;
+	left = PAGE_SIZE;
+
+	mutex_lock(&us_ibdev->usdev_lock);
+	if (atomic_read(&us_ibdev->vf_cnt.refcount) > 0) {
+		char *busname;
+
+		/*
+		 * bus name seems to come with annoying prefix.
+		 * Remove it if it is predictable
+		 */
+		busname = us_ibdev->pdev->bus->name;
+		if (strncmp(busname, "PCI Bus ", 8) == 0)
+			busname += 8;
+
+		n = scnprintf(ptr, left,
+			"%s: %s:%d.%d, %s, %pM, %u VFs\n Per VF:",
+			us_ibdev->ib_dev.name,
+			busname,
+			PCI_SLOT(us_ibdev->pdev->devfn),
+			PCI_FUNC(us_ibdev->pdev->devfn),
+			netdev_name(us_ibdev->netdev),
+			us_ibdev->mac,
+			atomic_read(&us_ibdev->vf_cnt.refcount));
+		UPDATE_PTR_LEFT(n, ptr, left);
+
+		for (res_type = USNIC_VNIC_RES_TYPE_EOL;
+				res_type < USNIC_VNIC_RES_TYPE_MAX;
+				res_type++) {
+			if (us_ibdev->vf_res_cnt[res_type] == 0)
+				continue;
+			n = scnprintf(ptr, left, " %d %s%s",
+				us_ibdev->vf_res_cnt[res_type],
+				usnic_vnic_res_type_to_str(res_type),
+				(res_type < (USNIC_VNIC_RES_TYPE_MAX - 1)) ?
+				 "," : "");
+			UPDATE_PTR_LEFT(n, ptr, left);
+		}
+		n = scnprintf(ptr, left, "\n");
+		UPDATE_PTR_LEFT(n, ptr, left);
+	} else {
+		n = scnprintf(ptr, left, "%s: no VFs\n",
+				us_ibdev->ib_dev.name);
+		UPDATE_PTR_LEFT(n, ptr, left);
+	}
+	mutex_unlock(&us_ibdev->usdev_lock);
+
+	return ptr - buf;
+}
+
+static ssize_t
+usnic_ib_show_iface(struct device *device, struct device_attribute *attr,
+			char *buf)
+{
+	struct usnic_ib_dev *us_ibdev;
+
+	us_ibdev = container_of(device, struct usnic_ib_dev, ib_dev.dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%s\n",
+			netdev_name(us_ibdev->netdev));
+}
+
+static ssize_t
+usnic_ib_show_max_vf(struct device *device, struct device_attribute *attr,
+			char *buf)
+{
+	struct usnic_ib_dev *us_ibdev;
+
+	us_ibdev = container_of(device, struct usnic_ib_dev, ib_dev.dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n",
+			atomic_read(&us_ibdev->vf_cnt.refcount));
+}
+
+static ssize_t
+usnic_ib_show_qp_per_vf(struct device *device, struct device_attribute *attr,
+			char *buf)
+{
+	struct usnic_ib_dev *us_ibdev;
+	int qp_per_vf;
+
+	us_ibdev = container_of(device, struct usnic_ib_dev, ib_dev.dev);
+	qp_per_vf = max(us_ibdev->vf_res_cnt[USNIC_VNIC_RES_TYPE_WQ],
+			us_ibdev->vf_res_cnt[USNIC_VNIC_RES_TYPE_RQ]);
+
+	return scnprintf(buf, PAGE_SIZE,
+				"%d\n", qp_per_vf);
+}
+
+static ssize_t
+usnic_ib_show_cq_per_vf(struct device *device, struct device_attribute *attr,
+			char *buf)
+{
+	struct usnic_ib_dev *us_ibdev;
+
+	us_ibdev = container_of(device, struct usnic_ib_dev, ib_dev.dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n",
+			us_ibdev->vf_res_cnt[USNIC_VNIC_RES_TYPE_CQ]);
+}
+
+static DEVICE_ATTR(fw_ver, S_IRUGO, usnic_ib_show_fw_ver, NULL);
+static DEVICE_ATTR(board_id, S_IRUGO, usnic_ib_show_board, NULL);
+static DEVICE_ATTR(config, S_IRUGO, usnic_ib_show_config, NULL);
+static DEVICE_ATTR(iface, S_IRUGO, usnic_ib_show_iface, NULL);
+static DEVICE_ATTR(max_vf, S_IRUGO, usnic_ib_show_max_vf, NULL);
+static DEVICE_ATTR(qp_per_vf, S_IRUGO, usnic_ib_show_qp_per_vf, NULL);
+static DEVICE_ATTR(cq_per_vf, S_IRUGO, usnic_ib_show_cq_per_vf, NULL);
+
+static struct device_attribute *usnic_class_attributes[] = {
+	&dev_attr_fw_ver,
+	&dev_attr_board_id,
+	&dev_attr_config,
+	&dev_attr_iface,
+	&dev_attr_max_vf,
+	&dev_attr_qp_per_vf,
+	&dev_attr_cq_per_vf,
+};
+
+struct qpn_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct usnic_ib_qp_grp *, char *buf);
+};
+
+/*
+ * Definitions for supporting QPN entries in sysfs
+ */
+static ssize_t
+usnic_ib_qpn_attr_show(struct kobject *kobj, struct attribute *attr, char *buf)
+{
+	struct usnic_ib_qp_grp *qp_grp;
+	struct qpn_attribute *qpn_attr;
+
+	qp_grp = container_of(kobj, struct usnic_ib_qp_grp, kobj);
+	qpn_attr = container_of(attr, struct qpn_attribute, attr);
+
+	return qpn_attr->show(qp_grp, buf);
+}
+
+static const struct sysfs_ops usnic_ib_qpn_sysfs_ops = {
+	.show = usnic_ib_qpn_attr_show
+};
+
+#define QPN_ATTR_RO(NAME) \
+struct qpn_attribute qpn_attr_##NAME = __ATTR_RO(NAME)
+
+static ssize_t context_show(struct usnic_ib_qp_grp *qp_grp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "0x%p\n", qp_grp->ctx);
+}
+
+static ssize_t summary_show(struct usnic_ib_qp_grp *qp_grp, char *buf)
+{
+	int i, j, n;
+	int left;
+	char *ptr;
+	struct usnic_vnic_res_chunk *res_chunk;
+	struct usnic_fwd_filter_hndl *default_filter_hndl;
+	struct usnic_vnic_res *vnic_res;
+
+	left = PAGE_SIZE;
+	ptr = buf;
+	default_filter_hndl = list_first_entry(&qp_grp->filter_hndls,
+					struct usnic_fwd_filter_hndl, link);
+
+	n = scnprintf(ptr, left,
+			"QPN: %d State: (%s) PID: %u VF Idx: %hu Filter ID: 0x%x ",
+			qp_grp->ibqp.qp_num,
+			usnic_ib_qp_grp_state_to_string(qp_grp->state),
+			qp_grp->owner_pid,
+			usnic_vnic_get_index(qp_grp->vf->vnic),
+			default_filter_hndl->id);
+	UPDATE_PTR_LEFT(n, ptr, left);
+
+	for (i = 0; qp_grp->res_chunk_list[i]; i++) {
+		res_chunk = qp_grp->res_chunk_list[i];
+		for (j = 0; j < res_chunk->cnt; j++) {
+			vnic_res = res_chunk->res[j];
+			n = scnprintf(ptr, left, "%s[%d] ",
+				usnic_vnic_res_type_to_str(vnic_res->type),
+				vnic_res->vnic_idx);
+			UPDATE_PTR_LEFT(n, ptr, left);
+		}
+	}
+
+	n = scnprintf(ptr, left, "\n");
+	UPDATE_PTR_LEFT(n, ptr, left);
+
+	return ptr - buf;
+}
+
+static QPN_ATTR_RO(context);
+static QPN_ATTR_RO(summary);
+
+static struct attribute *usnic_ib_qpn_default_attrs[] = {
+	&qpn_attr_context.attr,
+	&qpn_attr_summary.attr,
+	NULL
+};
+
+struct kobj_type usnic_ib_qpn_type = {
+	.sysfs_ops = &usnic_ib_qpn_sysfs_ops,
+	.default_attrs = usnic_ib_qpn_default_attrs
+};
+
+int usnic_ib_sysfs_register_usdev(struct usnic_ib_dev *us_ibdev)
+{
+	int i;
+	int err;
+	for (i = 0; i < ARRAY_SIZE(usnic_class_attributes); ++i) {
+		err = device_create_file(&us_ibdev->ib_dev.dev,
+						usnic_class_attributes[i]);
+		if (err) {
+			usnic_err("Failed to create device file %d for %s eith err %d",
+				i, us_ibdev->ib_dev.name, err);
+			return -EINVAL;
+		}
+	}
+
+	/* create kernel object for looking at individual QPs */
+	kobject_get(&us_ibdev->ib_dev.dev.kobj);
+	us_ibdev->qpn_kobj = kobject_create_and_add("qpn",
+			&us_ibdev->ib_dev.dev.kobj);
+	if (us_ibdev->qpn_kobj == NULL) {
+		kobject_put(&us_ibdev->ib_dev.dev.kobj);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+void usnic_ib_sysfs_unregister_usdev(struct usnic_ib_dev *us_ibdev)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(usnic_class_attributes); ++i) {
+		device_remove_file(&us_ibdev->ib_dev.dev,
+					usnic_class_attributes[i]);
+	}
+
+	kobject_put(us_ibdev->qpn_kobj);
+}
+
+void usnic_ib_sysfs_qpn_add(struct usnic_ib_qp_grp *qp_grp)
+{
+	struct usnic_ib_dev *us_ibdev;
+	int err;
+
+	us_ibdev = qp_grp->vf->pf;
+
+	err = kobject_init_and_add(&qp_grp->kobj, &usnic_ib_qpn_type,
+			kobject_get(us_ibdev->qpn_kobj),
+			"%d", qp_grp->grp_id);
+	if (err) {
+		kobject_put(us_ibdev->qpn_kobj);
+		return;
+	}
+}
+
+void usnic_ib_sysfs_qpn_remove(struct usnic_ib_qp_grp *qp_grp)
+{
+	struct usnic_ib_dev *us_ibdev;
+
+	us_ibdev = qp_grp->vf->pf;
+
+	kobject_put(&qp_grp->kobj);
+	kobject_put(us_ibdev->qpn_kobj);
+}
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.h b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.h
new file mode 100644
index 0000000..0d09b49
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#ifndef USNIC_IB_SYSFS_H_
+#define USNIC_IB_SYSFS_H_
+
+#include "usnic_ib.h"
+
+int usnic_ib_sysfs_register_usdev(struct usnic_ib_dev *us_ibdev);
+void usnic_ib_sysfs_unregister_usdev(struct usnic_ib_dev *us_ibdev);
+void usnic_ib_sysfs_qpn_add(struct usnic_ib_qp_grp *qp_grp);
+void usnic_ib_sysfs_qpn_remove(struct usnic_ib_qp_grp *qp_grp);
+
+#endif /* !USNIC_IB_SYSFS_H_ */
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
new file mode 100644
index 0000000..e1fe20a
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -0,0 +1,734 @@
+/*
+ * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+
+#include <rdma/ib_user_verbs.h>
+#include <rdma/ib_addr.h>
+
+#include "usnic_abi.h"
+#include "usnic_ib.h"
+#include "usnic_common_util.h"
+#include "usnic_ib_qp_grp.h"
+#include "usnic_fwd.h"
+#include "usnic_log.h"
+#include "usnic_uiom.h"
+#include "usnic_transport.h"
+
+#define USNIC_DEFAULT_TRANSPORT USNIC_TRANSPORT_ROCE_CUSTOM
+
+static void usnic_ib_fw_string_to_u64(char *fw_ver_str, u64 *fw_ver)
+{
+	*fw_ver = (u64) *fw_ver_str;
+}
+
+static int usnic_ib_fill_create_qp_resp(struct usnic_ib_qp_grp *qp_grp,
+					struct ib_udata *udata)
+{
+	struct usnic_ib_dev *us_ibdev;
+	struct usnic_ib_create_qp_resp resp;
+	struct pci_dev *pdev;
+	struct vnic_dev_bar *bar;
+	struct usnic_vnic_res_chunk *chunk;
+	int i, err;
+
+	us_ibdev = qp_grp->vf->pf;
+	pdev = usnic_vnic_get_pdev(qp_grp->vf->vnic);
+	if (!pdev) {
+		usnic_err("Failed to get pdev of qp_grp %d\n",
+				qp_grp->grp_id);
+		return -EFAULT;
+	}
+
+	bar = usnic_vnic_get_bar(qp_grp->vf->vnic, 0);
+	if (!bar) {
+		usnic_err("Failed to get bar0 of qp_grp %d vf %s",
+				qp_grp->grp_id, pci_name(pdev));
+		return -EFAULT;
+	}
+
+	resp.vfid = usnic_vnic_get_index(qp_grp->vf->vnic);
+	resp.bar_bus_addr = bar->bus_addr;
+	resp.bar_len = bar->len;
+	resp.transport = qp_grp->transport;
+
+	chunk = usnic_ib_qp_grp_get_chunk(qp_grp, USNIC_VNIC_RES_TYPE_RQ);
+	if (IS_ERR_OR_NULL(chunk)) {
+		usnic_err("Failed to get chunk %s for qp_grp %d with err %ld\n",
+			usnic_vnic_res_type_to_str(USNIC_VNIC_RES_TYPE_RQ),
+			qp_grp->grp_id,
+			PTR_ERR(chunk));
+		return chunk ? PTR_ERR(chunk) : -ENOMEM;
+	}
+	WARN_ON(chunk->type != USNIC_VNIC_RES_TYPE_RQ);
+	resp.rq_cnt = chunk->cnt;
+	for (i = 0; i < chunk->cnt; i++)
+		resp.rq_idx[i] = chunk->res[i]->vnic_idx;
+
+	chunk = usnic_ib_qp_grp_get_chunk(qp_grp, USNIC_VNIC_RES_TYPE_WQ);
+	if (IS_ERR_OR_NULL(chunk)) {
+		usnic_err("Failed to get chunk %s for qp_grp %d with err %ld\n",
+			usnic_vnic_res_type_to_str(USNIC_VNIC_RES_TYPE_WQ),
+			qp_grp->grp_id,
+			PTR_ERR(chunk));
+		return chunk ? PTR_ERR(chunk) : -ENOMEM;
+	}
+	WARN_ON(chunk->type != USNIC_VNIC_RES_TYPE_WQ);
+	resp.wq_cnt = chunk->cnt;
+	for (i = 0; i < chunk->cnt; i++)
+		resp.wq_idx[i] = chunk->res[i]->vnic_idx;
+
+	chunk = usnic_ib_qp_grp_get_chunk(qp_grp, USNIC_VNIC_RES_TYPE_CQ);
+	if (IS_ERR_OR_NULL(chunk)) {
+		usnic_err("Failed to get chunk %s for qp_grp %d with err %ld\n",
+			usnic_vnic_res_type_to_str(USNIC_VNIC_RES_TYPE_CQ),
+			qp_grp->grp_id,
+			PTR_ERR(chunk));
+		return chunk ? PTR_ERR(chunk) : -ENOMEM;
+	}
+	WARN_ON(chunk->type != USNIC_VNIC_RES_TYPE_CQ);
+	resp.cq_cnt = chunk->cnt;
+	for (i = 0; i < chunk->cnt; i++)
+		resp.cq_idx[i] = chunk->res[i]->vnic_idx;
+
+	err = ib_copy_to_udata(udata, &resp, sizeof(resp));
+	if (err) {
+		usnic_err("Failed to copy udata for %s", us_ibdev->ib_dev.name);
+		return err;
+	}
+	return 0;
+}
+
+static struct usnic_ib_qp_grp*
+find_free_vf_and_create_qp_grp(struct usnic_ib_dev *us_ibdev,
+				struct usnic_ib_pd *pd,
+				enum usnic_transport_type transport,
+				struct usnic_vnic_res_spec *res_spec)
+{
+	struct usnic_ib_vf *vf;
+	struct usnic_vnic *vnic;
+	struct usnic_ib_qp_grp *qp_grp;
+	struct device *dev, **dev_list;
+	int i, found = 0;
+
+	BUG_ON(!mutex_is_locked(&us_ibdev->usdev_lock));
+
+	if (list_empty(&us_ibdev->vf_dev_list)) {
+		usnic_info("No vfs to allocate\n");
+		return NULL;
+	}
+
+	if (!us_ibdev->link_up) {
+		usnic_info("Cannot allocate qp b/c PF link is down\n");
+		return NULL;
+	}
+
+	if (usnic_ib_share_vf) {
+		/* Try to find resouces on a used vf which is in pd */
+		dev_list = usnic_uiom_get_dev_list(pd->umem_pd);
+		for (i = 0; dev_list[i]; i++) {
+			dev = dev_list[i];
+			vf = pci_get_drvdata(to_pci_dev(dev));
+			spin_lock(&vf->lock);
+			vnic = vf->vnic;
+			if (!usnic_vnic_check_room(vnic, res_spec)) {
+				usnic_dbg("Found used vnic %s from %s\n",
+						us_ibdev->ib_dev.name,
+						pci_name(usnic_vnic_get_pdev(
+									vnic)));
+				found = 1;
+				break;
+			}
+			spin_unlock(&vf->lock);
+
+		}
+		usnic_uiom_free_dev_list(dev_list);
+	}
+
+	if (!found) {
+		/* Try to find resources on an unused vf */
+		list_for_each_entry(vf, &us_ibdev->vf_dev_list, link) {
+			spin_lock(&vf->lock);
+			vnic = vf->vnic;
+			if (vf->qp_grp_ref_cnt == 0 &&
+				usnic_vnic_check_room(vnic, res_spec) == 0) {
+				found = 1;
+				break;
+			}
+			spin_unlock(&vf->lock);
+		}
+	}
+
+	if (!found) {
+		usnic_info("No free qp grp found on %s\n",
+				us_ibdev->ib_dev.name);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	qp_grp = usnic_ib_qp_grp_create(us_ibdev->ufdev, vf, pd, res_spec,
+						transport);
+	spin_unlock(&vf->lock);
+
+	if (IS_ERR_OR_NULL(qp_grp)) {
+		usnic_err("Failed to allocate qp_grp\n");
+		return ERR_PTR(qp_grp ? PTR_ERR(qp_grp) : -ENOMEM);
+	}
+
+	return qp_grp;
+}
+
+static void qp_grp_destroy(struct usnic_ib_qp_grp *qp_grp)
+{
+	struct usnic_ib_vf *vf = qp_grp->vf;
+
+	WARN_ON(qp_grp->state != IB_QPS_RESET);
+
+	spin_lock(&vf->lock);
+	usnic_ib_qp_grp_destroy(qp_grp);
+	spin_unlock(&vf->lock);
+}
+
+static void eth_speed_to_ib_speed(int speed, u8 *active_speed,
+					u8 *active_width)
+{
+	if (speed <= 10000) {
+		*active_width = IB_WIDTH_1X;
+		*active_speed = IB_SPEED_FDR10;
+	} else if (speed <= 20000) {
+		*active_width = IB_WIDTH_4X;
+		*active_speed = IB_SPEED_DDR;
+	} else if (speed <= 30000) {
+		*active_width = IB_WIDTH_4X;
+		*active_speed = IB_SPEED_QDR;
+	} else if (speed <= 40000) {
+		*active_width = IB_WIDTH_4X;
+		*active_speed = IB_SPEED_FDR10;
+	} else {
+		*active_width = IB_WIDTH_4X;
+		*active_speed = IB_SPEED_EDR;
+	}
+}
+
+/* Start of ib callback functions */
+
+enum rdma_link_layer usnic_ib_port_link_layer(struct ib_device *device,
+						u8 port_num)
+{
+	return IB_LINK_LAYER_ETHERNET;
+}
+
+int usnic_ib_query_device(struct ib_device *ibdev,
+				struct ib_device_attr *props)
+{
+	struct usnic_ib_dev *us_ibdev = to_usdev(ibdev);
+	union ib_gid gid;
+	struct ethtool_drvinfo info;
+	struct ethtool_cmd cmd;
+	int qp_per_vf;
+
+	usnic_dbg("\n");
+	mutex_lock(&us_ibdev->usdev_lock);
+	us_ibdev->netdev->ethtool_ops->get_drvinfo(us_ibdev->netdev, &info);
+	us_ibdev->netdev->ethtool_ops->get_settings(us_ibdev->netdev, &cmd);
+	memset(props, 0, sizeof(*props));
+	usnic_mac_to_gid(us_ibdev->mac, &gid.raw[0]);
+	memcpy(&props->sys_image_guid, &gid.global.interface_id,
+		sizeof(gid.global.interface_id));
+	usnic_ib_fw_string_to_u64(&info.fw_version[0], &props->fw_ver);
+	props->max_mr_size = USNIC_UIOM_MAX_MR_SIZE;
+	props->page_size_cap = USNIC_UIOM_PAGE_SIZE;
+	props->vendor_id = PCI_VENDOR_ID_CISCO;
+	props->vendor_part_id = PCI_DEVICE_ID_CISCO_VIC_USPACE_NIC;
+	props->hw_ver = us_ibdev->pdev->subsystem_device;
+	qp_per_vf = max(us_ibdev->vf_res_cnt[USNIC_VNIC_RES_TYPE_WQ],
+			us_ibdev->vf_res_cnt[USNIC_VNIC_RES_TYPE_RQ]);
+	props->max_qp = qp_per_vf *
+		atomic_read(&us_ibdev->vf_cnt.refcount);
+	props->device_cap_flags = IB_DEVICE_PORT_ACTIVE_EVENT |
+		IB_DEVICE_SYS_IMAGE_GUID | IB_DEVICE_BLOCK_MULTICAST_LOOPBACK;
+	props->max_cq = us_ibdev->vf_res_cnt[USNIC_VNIC_RES_TYPE_CQ] *
+		atomic_read(&us_ibdev->vf_cnt.refcount);
+	props->max_pd = USNIC_UIOM_MAX_PD_CNT;
+	props->max_mr = USNIC_UIOM_MAX_MR_CNT;
+	props->local_ca_ack_delay = 0;
+	props->max_pkeys = 0;
+	props->atomic_cap = IB_ATOMIC_NONE;
+	props->masked_atomic_cap = props->atomic_cap;
+	props->max_qp_rd_atom = 0;
+	props->max_qp_init_rd_atom = 0;
+	props->max_res_rd_atom = 0;
+	props->max_srq = 0;
+	props->max_srq_wr = 0;
+	props->max_srq_sge = 0;
+	props->max_fast_reg_page_list_len = 0;
+	props->max_mcast_grp = 0;
+	props->max_mcast_qp_attach = 0;
+	props->max_total_mcast_qp_attach = 0;
+	props->max_map_per_fmr = 0;
+
+	/* Owned by Userspace
+	 * max_qp_wr, max_sge, max_sge_rd, max_cqe */
+	mutex_unlock(&us_ibdev->usdev_lock);
+	return 0;
+}
+
+int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
+				struct ib_port_attr *props)
+{
+	struct usnic_ib_dev *us_ibdev = to_usdev(ibdev);
+	struct ethtool_cmd cmd;
+
+	usnic_dbg("\n");
+
+	mutex_lock(&us_ibdev->usdev_lock);
+	us_ibdev->netdev->ethtool_ops->get_settings(us_ibdev->netdev, &cmd);
+	memset(props, 0, sizeof(*props));
+
+	props->lid = 0;
+	props->lmc = 1;
+	props->sm_lid = 0;
+	props->sm_sl = 0;
+
+	if (us_ibdev->link_up) {
+		props->state = IB_PORT_ACTIVE;
+		props->phys_state = 5;
+	} else {
+		props->state = IB_PORT_DOWN;
+		props->phys_state = 3;
+	}
+
+	props->port_cap_flags = 0;
+	props->gid_tbl_len = 1;
+	props->pkey_tbl_len = 1;
+	props->bad_pkey_cntr = 0;
+	props->qkey_viol_cntr = 0;
+	eth_speed_to_ib_speed(cmd.speed, &props->active_speed,
+				&props->active_width);
+	props->max_mtu = IB_MTU_4096;
+	props->active_mtu = iboe_get_mtu(us_ibdev->mtu);
+	/* Userspace will adjust for hdrs */
+	props->max_msg_sz = us_ibdev->mtu;
+	props->max_vl_num = 1;
+
+	mutex_unlock(&us_ibdev->usdev_lock);
+	return 0;
+}
+
+int usnic_ib_query_qp(struct ib_qp *qp, struct ib_qp_attr *qp_attr,
+				int qp_attr_mask,
+				struct ib_qp_init_attr *qp_init_attr)
+{
+	struct usnic_ib_qp_grp *qp_grp;
+	struct usnic_ib_vf *vf;
+	int err;
+
+	usnic_dbg("\n");
+
+	memset(qp_attr, 0, sizeof(*qp_attr));
+	memset(qp_init_attr, 0, sizeof(*qp_init_attr));
+
+	qp_grp = to_uqp_grp(qp);
+	vf = qp_grp->vf;
+	mutex_lock(&vf->pf->usdev_lock);
+	usnic_dbg("\n");
+	qp_attr->qp_state = qp_grp->state;
+	qp_attr->cur_qp_state = qp_grp->state;
+
+	switch (qp_grp->ibqp.qp_type) {
+	case IB_QPT_UD:
+		qp_attr->qkey = 0;
+		break;
+	default:
+		usnic_err("Unexpected qp_type %d\n", qp_grp->ibqp.qp_type);
+		err = -EINVAL;
+		goto err_out;
+	}
+
+	mutex_unlock(&vf->pf->usdev_lock);
+	return 0;
+
+err_out:
+	mutex_unlock(&vf->pf->usdev_lock);
+	return err;
+}
+
+int usnic_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
+				union ib_gid *gid)
+{
+
+	struct usnic_ib_dev *us_ibdev = to_usdev(ibdev);
+	usnic_dbg("\n");
+
+	if (index > 1)
+		return -EINVAL;
+
+	mutex_lock(&us_ibdev->usdev_lock);
+	memset(&(gid->raw[0]), 0, sizeof(gid->raw));
+	usnic_mac_to_gid(us_ibdev->mac, &gid->raw[0]);
+	mutex_unlock(&us_ibdev->usdev_lock);
+
+	return 0;
+}
+
+int usnic_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
+				u16 *pkey)
+{
+	if (index > 1)
+		return -EINVAL;
+
+	*pkey = 0xffff;
+	return 0;
+}
+
+struct ib_pd *usnic_ib_alloc_pd(struct ib_device *ibdev,
+					struct ib_ucontext *context,
+					struct ib_udata *udata)
+{
+	struct usnic_ib_pd *pd;
+	void *umem_pd;
+
+	usnic_dbg("\n");
+
+	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
+	if (!pd)
+		return ERR_PTR(-ENOMEM);
+
+	umem_pd = pd->umem_pd = usnic_uiom_alloc_pd();
+	if (IS_ERR_OR_NULL(umem_pd)) {
+		kfree(pd);
+		return ERR_PTR(umem_pd ? PTR_ERR(umem_pd) : -ENOMEM);
+	}
+
+	usnic_info("domain 0x%p allocated for context 0x%p and device %s\n",
+			pd, context, ibdev->name);
+
+	return &pd->ibpd;
+}
+
+int usnic_ib_dealloc_pd(struct ib_pd *pd)
+{
+	usnic_info("freeing domain 0x%p\n", pd);
+
+	usnic_uiom_dealloc_pd((to_upd(pd))->umem_pd);
+	kfree(pd);
+	return 0;
+}
+
+struct ib_qp *usnic_ib_create_qp(struct ib_pd *pd,
+					struct ib_qp_init_attr *init_attr,
+					struct ib_udata *udata)
+{
+	int err;
+	struct usnic_ib_dev *us_ibdev;
+	struct usnic_ib_qp_grp *qp_grp;
+	struct usnic_ib_ucontext *ucontext;
+	int cq_cnt;
+	struct usnic_vnic_res_spec res_spec;
+
+	usnic_dbg("\n");
+
+	ucontext = to_uucontext(pd->uobject->context);
+	us_ibdev = to_usdev(pd->device);
+
+	if (init_attr->qp_type != IB_QPT_UD) {
+		usnic_err("%s asked to make a non-UD QP: %d\n",
+				us_ibdev->ib_dev.name, init_attr->qp_type);
+		return ERR_PTR(-EINVAL);
+	}
+
+	mutex_lock(&us_ibdev->usdev_lock);
+	cq_cnt = (init_attr->send_cq == init_attr->recv_cq) ? 1 : 2,
+	res_spec = min_transport_spec[USNIC_DEFAULT_TRANSPORT];
+	usnic_vnic_res_spec_update(&res_spec, USNIC_VNIC_RES_TYPE_CQ, cq_cnt);
+	qp_grp = find_free_vf_and_create_qp_grp(us_ibdev, to_upd(pd),
+						USNIC_DEFAULT_TRANSPORT,
+						&res_spec);
+	if (IS_ERR_OR_NULL(qp_grp)) {
+		err = (qp_grp ? PTR_ERR(qp_grp) : -ENOMEM);
+		goto out_release_mutex;
+	}
+
+	err = usnic_ib_fill_create_qp_resp(qp_grp, udata);
+	if (err) {
+		err = -EBUSY;
+		goto out_release_qp_grp;
+	}
+
+	qp_grp->ctx = ucontext;
+	list_add_tail(&qp_grp->link, &ucontext->qp_grp_list);
+	usnic_ib_log_vf(qp_grp->vf);
+	mutex_unlock(&us_ibdev->usdev_lock);
+	return &qp_grp->ibqp;
+
+out_release_qp_grp:
+	qp_grp_destroy(qp_grp);
+out_release_mutex:
+	mutex_unlock(&us_ibdev->usdev_lock);
+
+	return ERR_PTR(err);
+}
+
+int usnic_ib_destroy_qp(struct ib_qp *qp)
+{
+	struct usnic_ib_qp_grp *qp_grp;
+	struct usnic_ib_vf *vf;
+
+	usnic_dbg("\n");
+
+	qp_grp = to_uqp_grp(qp);
+	vf = qp_grp->vf;
+	mutex_lock(&vf->pf->usdev_lock);
+	if (usnic_ib_qp_grp_modify(qp_grp, IB_QPS_RESET, NULL)) {
+		usnic_err("Failed to move qp grp %u to reset\n",
+				qp_grp->grp_id);
+	}
+
+	list_del(&qp_grp->link);
+	qp_grp_destroy(qp_grp);
+	mutex_unlock(&vf->pf->usdev_lock);
+
+	return 0;
+}
+
+int usnic_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+				int attr_mask, struct ib_udata *udata)
+{
+	struct usnic_ib_qp_grp *qp_grp;
+	int status;
+	usnic_dbg("\n");
+
+	qp_grp = to_uqp_grp(ibqp);
+
+	/* TODO: Future Support All States */
+	mutex_lock(&qp_grp->vf->pf->usdev_lock);
+	if ((attr_mask & IB_QP_STATE) && attr->qp_state == IB_QPS_INIT) {
+		status = usnic_ib_qp_grp_modify(qp_grp, IB_QPS_INIT,
+					&qp_grp->filters[DFLT_FILTER_IDX]);
+	} else if ((attr_mask & IB_QP_STATE) && attr->qp_state == IB_QPS_RTR) {
+		status = usnic_ib_qp_grp_modify(qp_grp, IB_QPS_RTR, NULL);
+	} else if ((attr_mask & IB_QP_STATE) && attr->qp_state == IB_QPS_RTS) {
+		status = usnic_ib_qp_grp_modify(qp_grp, IB_QPS_RTS, NULL);
+	} else {
+		usnic_err("Unexpected combination mask: %u state: %u\n",
+				attr_mask & IB_QP_STATE, attr->qp_state);
+		status = -EINVAL;
+	}
+
+	mutex_unlock(&qp_grp->vf->pf->usdev_lock);
+	return status;
+}
+
+struct ib_cq *usnic_ib_create_cq(struct ib_device *ibdev, int entries,
+					int vector, struct ib_ucontext *context,
+					struct ib_udata *udata)
+{
+	struct ib_cq *cq;
+
+	usnic_dbg("\n");
+	cq = kzalloc(sizeof(*cq), GFP_KERNEL);
+	if (!cq)
+		return ERR_PTR(-EBUSY);
+
+	return cq;
+}
+
+int usnic_ib_destroy_cq(struct ib_cq *cq)
+{
+	usnic_dbg("\n");
+	kfree(cq);
+	return 0;
+}
+
+struct ib_mr *usnic_ib_reg_mr(struct ib_pd *pd, u64 start, u64 length,
+					u64 virt_addr, int access_flags,
+					struct ib_udata *udata)
+{
+	struct usnic_ib_mr *mr;
+	int err;
+
+	usnic_dbg("start 0x%llx va 0x%llx length 0x%llx\n", start,
+			virt_addr, length);
+
+	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+	if (IS_ERR_OR_NULL(mr))
+		return ERR_PTR(mr ? PTR_ERR(mr) : -ENOMEM);
+
+	mr->umem = usnic_uiom_reg_get(to_upd(pd)->umem_pd, start, length,
+					access_flags, 0);
+	if (IS_ERR_OR_NULL(mr->umem)) {
+		err = PTR_ERR(mr->umem);
+		goto err_free;
+	}
+
+	mr->ibmr.lkey = mr->ibmr.rkey = 0;
+	return &mr->ibmr;
+
+err_free:
+	kfree(mr);
+
+	return ERR_PTR(err);
+}
+
+int usnic_ib_dereg_mr(struct ib_mr *ibmr)
+{
+	struct usnic_ib_mr *mr = to_umr(ibmr);
+
+	usnic_dbg("va 0x%lx length 0x%lx\n", mr->umem->va, mr->umem->length);
+
+	usnic_uiom_reg_release(mr->umem, ibmr->pd->uobject->context->closing);
+	kfree(mr);
+	return 0;
+}
+
+struct ib_ucontext *usnic_ib_alloc_ucontext(struct ib_device *ibdev,
+							struct ib_udata *udata)
+{
+	struct usnic_ib_ucontext *context;
+	struct usnic_ib_dev *us_ibdev = to_usdev(ibdev);
+	usnic_dbg("\n");
+
+	context = kmalloc(sizeof(*context), GFP_KERNEL);
+	if (!context)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&context->qp_grp_list);
+	mutex_lock(&us_ibdev->usdev_lock);
+	list_add_tail(&context->link, &us_ibdev->ctx_list);
+	mutex_unlock(&us_ibdev->usdev_lock);
+
+	return &context->ibucontext;
+}
+
+int usnic_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
+{
+	struct usnic_ib_ucontext *context = to_uucontext(ibcontext);
+	struct usnic_ib_dev *us_ibdev = to_usdev(ibcontext->device);
+	usnic_dbg("\n");
+
+	mutex_lock(&us_ibdev->usdev_lock);
+	BUG_ON(!list_empty(&context->qp_grp_list));
+	list_del(&context->link);
+	mutex_unlock(&us_ibdev->usdev_lock);
+	kfree(context);
+	return 0;
+}
+
+int usnic_ib_mmap(struct ib_ucontext *context,
+				struct vm_area_struct *vma)
+{
+	struct usnic_ib_ucontext *uctx = to_ucontext(context);
+	struct usnic_ib_dev *us_ibdev;
+	struct usnic_ib_qp_grp *qp_grp;
+	struct usnic_ib_vf *vf;
+	struct vnic_dev_bar *bar;
+	dma_addr_t bus_addr;
+	unsigned int len;
+	unsigned int vfid;
+
+	usnic_dbg("\n");
+
+	us_ibdev = to_usdev(context->device);
+	vma->vm_flags |= VM_IO;
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	vfid = vma->vm_pgoff;
+	usnic_dbg("Page Offset %lu PAGE_SHIFT %u VFID %u\n",
+			vma->vm_pgoff, PAGE_SHIFT, vfid);
+
+	mutex_lock(&us_ibdev->usdev_lock);
+	list_for_each_entry(qp_grp, &uctx->qp_grp_list, link) {
+		vf = qp_grp->vf;
+		if (usnic_vnic_get_index(vf->vnic) == vfid) {
+			bar = usnic_vnic_get_bar(vf->vnic, 0);
+			if ((vma->vm_end - vma->vm_start) != bar->len) {
+				usnic_err("Bar0 Len %lu - Request map %lu\n",
+						bar->len,
+						vma->vm_end - vma->vm_start);
+				mutex_unlock(&us_ibdev->usdev_lock);
+				return -EINVAL;
+			}
+			bus_addr = bar->bus_addr;
+			len = bar->len;
+			usnic_dbg("bus: 0x%llx vaddr: %p size: %ld\n",
+					bus_addr, bar->vaddr, bar->len);
+			mutex_unlock(&us_ibdev->usdev_lock);
+
+			return remap_pfn_range(vma,
+						vma->vm_start,
+						bus_addr >> PAGE_SHIFT,
+						len, vma->vm_page_prot);
+		}
+	}
+
+	mutex_unlock(&us_ibdev->usdev_lock);
+	usnic_err("No VF %u found\n", vfid);
+	return -EINVAL;
+}
+
+/* In ib callbacks section -  Start of stub funcs */
+struct ib_ah *usnic_ib_create_ah(struct ib_pd *pd,
+					struct ib_ah_attr *ah_attr)
+{
+	usnic_dbg("\n");
+	return ERR_PTR(-EPERM);
+}
+
+int usnic_ib_destroy_ah(struct ib_ah *ah)
+{
+	usnic_dbg("\n");
+	return -EINVAL;
+}
+
+int usnic_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
+				struct ib_send_wr **bad_wr)
+{
+	usnic_dbg("\n");
+	return -EINVAL;
+}
+
+int usnic_ib_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
+				struct ib_recv_wr **bad_wr)
+{
+	usnic_dbg("\n");
+	return -EINVAL;
+}
+
+int usnic_ib_poll_cq(struct ib_cq *ibcq, int num_entries,
+				struct ib_wc *wc)
+{
+	usnic_dbg("\n");
+	return -EINVAL;
+}
+
+int usnic_ib_req_notify_cq(struct ib_cq *cq,
+					enum ib_cq_notify_flags flags)
+{
+	usnic_dbg("\n");
+	return -EINVAL;
+}
+
+struct ib_mr *usnic_ib_get_dma_mr(struct ib_pd *pd, int acc)
+{
+	usnic_dbg("\n");
+	return ERR_PTR(-ENOMEM);
+}
+
+
+/* In ib callbacks section - End of stub funcs */
+/* End of ib callbacks section */
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
new file mode 100644
index 0000000..bb864f5
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
@@ -0,0 +1,72 @@
+/*
+ * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#ifndef USNIC_IB_VERBS_H_
+#define USNIC_IB_VERBS_H_
+
+#include "usnic_ib.h"
+
+enum rdma_link_layer usnic_ib_port_link_layer(struct ib_device *device,
+						u8 port_num);
+int usnic_ib_query_device(struct ib_device *ibdev,
+				struct ib_device_attr *props);
+int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
+				struct ib_port_attr *props);
+int usnic_ib_query_qp(struct ib_qp *qp, struct ib_qp_attr *qp_attr,
+				int qp_attr_mask,
+				struct ib_qp_init_attr *qp_init_attr);
+int usnic_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
+				union ib_gid *gid);
+int usnic_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
+				u16 *pkey);
+struct ib_pd *usnic_ib_alloc_pd(struct ib_device *ibdev,
+				struct ib_ucontext *context,
+				struct ib_udata *udata);
+int usnic_ib_dealloc_pd(struct ib_pd *pd);
+struct ib_qp *usnic_ib_create_qp(struct ib_pd *pd,
+					struct ib_qp_init_attr *init_attr,
+					struct ib_udata *udata);
+int usnic_ib_destroy_qp(struct ib_qp *qp);
+int usnic_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+				int attr_mask, struct ib_udata *udata);
+struct ib_cq *usnic_ib_create_cq(struct ib_device *ibdev, int entries,
+					int vector, struct ib_ucontext *context,
+					struct ib_udata *udata);
+int usnic_ib_destroy_cq(struct ib_cq *cq);
+struct ib_mr *usnic_ib_reg_mr(struct ib_pd *pd, u64 start, u64 length,
+				u64 virt_addr, int access_flags,
+				struct ib_udata *udata);
+int usnic_ib_dereg_mr(struct ib_mr *ibmr);
+struct ib_ucontext *usnic_ib_alloc_ucontext(struct ib_device *ibdev,
+						struct ib_udata *udata);
+int usnic_ib_dealloc_ucontext(struct ib_ucontext *ibcontext);
+int usnic_ib_mmap(struct ib_ucontext *context,
+			struct vm_area_struct *vma);
+struct ib_ah *usnic_ib_create_ah(struct ib_pd *pd,
+					struct ib_ah_attr *ah_attr);
+int usnic_ib_destroy_ah(struct ib_ah *ah);
+int usnic_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
+			struct ib_send_wr **bad_wr);
+int usnic_ib_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
+			struct ib_recv_wr **bad_wr);
+int usnic_ib_poll_cq(struct ib_cq *ibcq, int num_entries,
+			struct ib_wc *wc);
+int usnic_ib_req_notify_cq(struct ib_cq *cq,
+				enum ib_cq_notify_flags flags);
+struct ib_mr *usnic_ib_get_dma_mr(struct ib_pd *pd, int acc);
+#endif /* !USNIC_IB_VERBS_H */
--
1.7.1--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
