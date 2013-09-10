From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V2 3/4] IB/usnic: Cisco VIC - driver part 2/3
Date: Tue, 10 Sep 2013 03:38:53 +0000
Message-ID: <47A33601BBFF7E4B8F0D5D0C96F3022C013CF372@xmb-rcd-x09.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Content-ID: <97AEE1260D13854FA6490C6F88BCD100-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Christian Benvenuti (benve)" <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic.h                |  29 +
 drivers/infiniband/hw/usnic/usnic_common_pkt_hdr.h |  27 +
 drivers/infiniband/hw/usnic/usnic_common_util.h    |  51 ++
 drivers/infiniband/hw/usnic/usnic_debugfs.c        |  71 +++
 drivers/infiniband/hw/usnic/usnic_debugfs.h        |  25 +
 drivers/infiniband/hw/usnic/usnic_fwd.c            | 243 +++++++++
 drivers/infiniband/hw/usnic/usnic_fwd.h            |  58 ++
 drivers/infiniband/hw/usnic/usnic_log.h            |  58 ++
 drivers/infiniband/hw/usnic/usnic_transport.c      | 125 +++++
 drivers/infiniband/hw/usnic/usnic_transport.h      |  27 +
 drivers/infiniband/hw/usnic/usnic_uiom.c           | 599 +++++++++++++++++++++
 drivers/infiniband/hw/usnic/usnic_uiom.h           |  80 +++
 .../infiniband/hw/usnic/usnic_uiom_interval_tree.c | 237 ++++++++
 .../infiniband/hw/usnic/usnic_uiom_interval_tree.h |  74 +++
 drivers/infiniband/hw/usnic/usnic_vnic.c           | 473 ++++++++++++++++
 drivers/infiniband/hw/usnic/usnic_vnic.h           | 105 ++++
 16 files changed, 2282 insertions(+)
 create mode 100644 drivers/infiniband/hw/usnic/usnic.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_common_pkt_hdr.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_common_util.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_debugfs.c
 create mode 100644 drivers/infiniband/hw/usnic/usnic_debugfs.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_fwd.c
 create mode 100644 drivers/infiniband/hw/usnic/usnic_fwd.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_log.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_transport.c
 create mode 100644 drivers/infiniband/hw/usnic/usnic_transport.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_uiom.c
 create mode 100644 drivers/infiniband/hw/usnic/usnic_uiom.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c
 create mode 100644 drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_vnic.c
 create mode 100644 drivers/infiniband/hw/usnic/usnic_vnic.h

diff --git a/drivers/infiniband/hw/usnic/usnic.h b/drivers/infiniband/hw/usnic/usnic.h
new file mode 100644
index 0000000..d741c76
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic.h
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
+#ifndef USNIC_H_
+#define USNIC_H_
+
+#define DRV_NAME	"usnic_verbs"
+
+#define PCI_DEVICE_ID_CISCO_VIC_USPACE_NIC	0x00cf	/* User space NIC */
+
+#define DRV_VERSION    "1.0.2"
+#define DRV_RELDATE    "September 09, 2013"
+
+#endif /* USNIC_H_ */
diff --git a/drivers/infiniband/hw/usnic/usnic_common_pkt_hdr.h b/drivers/infiniband/hw/usnic/usnic_common_pkt_hdr.h
new file mode 100644
index 0000000..3935672
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_common_pkt_hdr.h
@@ -0,0 +1,27 @@
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
+#ifndef USNIC_CMN_PKT_HDR_H
+#define USNIC_CMN_PKT_HDR_H
+
+#define USNIC_ROCE_ETHERTYPE		(0x8915)
+#define USNIC_ROCE_GRH_VER              (8)
+#define USNIC_PROTO_VER                 (1)
+#define USNIC_ROCE_GRH_VER_SHIFT        (4)
+
+#endif /* USNIC_COMMON_PKT_HDR_H */
diff --git a/drivers/infiniband/hw/usnic/usnic_common_util.h b/drivers/infiniband/hw/usnic/usnic_common_util.h
new file mode 100644
index 0000000..128550a
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_common_util.h
@@ -0,0 +1,51 @@
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
+#ifndef USNIC_CMN_UTIL_H
+#define USNIC_CMN_UTIL_H
+
+static inline void
+usnic_mac_to_gid(const char *const mac, char *raw_gid)
+{
+	raw_gid[0] = 0xfe;
+	raw_gid[1] = 0x80;
+	memset(&raw_gid[2], 0, 6);
+	raw_gid[8] = mac[0]^2;
+	raw_gid[9] = mac[1];
+	raw_gid[10] = mac[2];
+	raw_gid[11] = 0xff;
+	raw_gid[12] = 0xfe;
+	raw_gid[13] = mac[3];
+	raw_gid[14] = mac[4];
+	raw_gid[15] = mac[5];
+}
+
+static inline void
+usnic_write_gid_if_id_from_mac(char *mac, char *raw_gid)
+{
+	raw_gid[8] = mac[0]^2;
+	raw_gid[9] = mac[1];
+	raw_gid[10] = mac[2];
+	raw_gid[11] = 0xff;
+	raw_gid[12] = 0xfe;
+	raw_gid[13] = mac[3];
+	raw_gid[14] = mac[4];
+	raw_gid[15] = mac[5];
+}
+
+#endif /* USNIC_COMMON_UTIL_H */
diff --git a/drivers/infiniband/hw/usnic/usnic_debugfs.c b/drivers/infiniband/hw/usnic/usnic_debugfs.c
new file mode 100644
index 0000000..91386df
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_debugfs.c
@@ -0,0 +1,71 @@
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
+#include <linux/debugfs.h>
+#include <linux/module.h>
+
+#include "usnic.h"
+#include "usnic_log.h"
+#include "usnic_debugfs.h"
+
+static struct dentry *debugfs_root;
+
+static ssize_t usnic_debugfs_buildinfo_read(struct file *f, char __user *data,
+						size_t count, loff_t *ppos)
+{
+	char buf[500];
+	int res;
+
+	if (*ppos > 0)
+		return 0;
+
+	res = scnprintf(buf, sizeof(buf),
+			"version:       %s\n"
+			"build date:    %s\n",
+			DRV_VERSION, DRV_RELDATE);
+
+	return simple_read_from_buffer(data, count, ppos, buf, res);
+}
+
+static const struct file_operations usnic_debugfs_buildinfo_ops = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.read = usnic_debugfs_buildinfo_read
+};
+
+void usnic_debugfs_init(void)
+{
+	debugfs_root = debugfs_create_dir(DRV_NAME, NULL);
+	if (IS_ERR(debugfs_root)) {
+		usnic_err("Failed to create debugfs root dir, check if debugfs is enabled in kernel configuration\n");
+		debugfs_root = NULL;
+		return;
+	}
+
+	debugfs_create_file("build-info", S_IRUGO, debugfs_root,
+				NULL, &usnic_debugfs_buildinfo_ops);
+}
+
+void usnic_debugfs_exit(void)
+{
+	if (!debugfs_root)
+		return;
+
+	debugfs_remove_recursive(debugfs_root);
+	debugfs_root = NULL;
+}
diff --git a/drivers/infiniband/hw/usnic/usnic_debugfs.h b/drivers/infiniband/hw/usnic/usnic_debugfs.h
new file mode 100644
index 0000000..914a330
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_debugfs.h
@@ -0,0 +1,25 @@
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
+#ifndef USNIC_DEBUGFS_H_
+#define USNIC_DEBUGFS_H_
+
+void usnic_debugfs_init(void);
+
+void usnic_debugfs_exit(void);
+
+#endif /*!USNIC_DEBUGFS_H_ */
diff --git a/drivers/infiniband/hw/usnic/usnic_fwd.c b/drivers/infiniband/hw/usnic/usnic_fwd.c
new file mode 100644
index 0000000..b5719fc
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_fwd.c
@@ -0,0 +1,243 @@
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
+#include <linux/netdevice.h>
+#include <linux/pci.h>
+
+#include "enic_api.h"
+#include "usnic_common_pkt_hdr.h"
+#include "usnic_fwd.h"
+#include "usnic_log.h"
+
+struct usnic_fwd_dev *usnic_fwd_dev_alloc(struct pci_dev *pdev)
+{
+	struct usnic_fwd_dev *ufdev;
+
+	ufdev = kzalloc(sizeof(*ufdev), GFP_KERNEL);
+	if (!ufdev)
+		return NULL;
+
+	ufdev->pdev = pdev;
+	ufdev->netdev = pci_get_drvdata(pdev);
+	spin_lock_init(&ufdev->lock);
+
+	return ufdev;
+}
+
+void usnic_fwd_dev_free(struct usnic_fwd_dev *ufdev)
+{
+	kfree(ufdev);
+}
+
+static int usnic_fwd_devcmd(struct usnic_fwd_dev *ufdev, int vnic_idx,
+				enum vnic_devcmd_cmd cmd, u64 *a0, u64 *a1)
+{
+	int status;
+	struct net_device *netdev = ufdev->netdev;
+
+	spin_lock(&ufdev->lock);
+	status = enic_api_devcmd_proxy_by_index(netdev,
+			vnic_idx,
+			cmd,
+			a0, a1,
+			1000);
+	spin_unlock(&ufdev->lock);
+	if (status) {
+		if (status == ERR_EINVAL && cmd == CMD_DEL_FILTER) {
+			usnic_dbg("Dev %s vnic idx %u cmd %u already deleted",
+					netdev_name(netdev), vnic_idx, cmd);
+		} else {
+			usnic_err("Dev %s vnic idx %u cmd %u failed with status %d\n",
+					netdev_name(netdev), vnic_idx, cmd,
+					status);
+		}
+	} else {
+		usnic_dbg("Dev %s vnic idx %u cmd %u success",
+				netdev_name(netdev), vnic_idx,
+				cmd);
+	}
+
+	return status;
+}
+
+int usnic_fwd_add_usnic_filter(struct usnic_fwd_dev *ufdev, int vnic_idx,
+				int rq_idx, struct usnic_fwd_filter *fwd_filter,
+				struct usnic_fwd_filter_hndl **filter_hndl)
+{
+	struct filter_tlv *tlv, *tlv_va;
+	struct filter *filter;
+	struct filter_action *action;
+	struct pci_dev *pdev;
+	struct usnic_fwd_filter_hndl *usnic_filter_hndl;
+	int status;
+	u64 a0, a1;
+	u64 tlv_size;
+	dma_addr_t tlv_pa;
+
+	pdev = ufdev->pdev;
+	tlv_size = (2*sizeof(struct filter_tlv) +
+		sizeof(struct filter) +
+		sizeof(struct filter_action));
+	tlv = pci_alloc_consistent(pdev, tlv_size, &tlv_pa);
+	if (!tlv) {
+		usnic_err("Failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	usnic_filter_hndl = kzalloc(sizeof(*usnic_filter_hndl), GFP_KERNEL);
+	if (!usnic_filter_hndl) {
+		usnic_err("Failed to allocate memory for hndl\n");
+		pci_free_consistent(pdev, tlv_size, tlv, tlv_pa);
+		return -ENOMEM;
+	}
+
+	tlv_va = tlv;
+	a0 = tlv_pa;
+	a1 = tlv_size;
+	memset(tlv, 0, tlv_size);
+	tlv->type = CLSF_TLV_FILTER;
+	tlv->length = sizeof(struct filter);
+	filter = (struct filter *)&tlv->val;
+	filter->type = FILTER_USNIC_ID;
+	filter->u.usnic.ethtype = USNIC_ROCE_ETHERTYPE;
+	filter->u.usnic.flags = FILTER_FIELD_USNIC_ETHTYPE |
+					FILTER_FIELD_USNIC_ID |
+					FILTER_FIELD_USNIC_PROTO;
+	filter->u.usnic.proto_version = (USNIC_ROCE_GRH_VER <<
+						USNIC_ROCE_GRH_VER_SHIFT)
+							| USNIC_PROTO_VER;
+	filter->u.usnic.usnic_id = fwd_filter->port_num;
+	tlv = (struct filter_tlv *)((char *)tlv + sizeof(struct filter_tlv) +
+			sizeof(struct filter));
+	tlv->type = CLSF_TLV_ACTION;
+	tlv->length = sizeof(struct filter_action);
+	action = (struct filter_action *)&tlv->val;
+	action->type = FILTER_ACTION_RQ_STEERING;
+	action->u.rq_idx = rq_idx;
+
+	status = usnic_fwd_devcmd(ufdev, vnic_idx, CMD_ADD_FILTER, &a0, &a1);
+	pci_free_consistent(pdev, tlv_size, tlv_va, tlv_pa);
+	if (status) {
+		usnic_err("VF %s Filter add failed with status:%d",
+				pci_name(pdev),
+				status);
+		kfree(usnic_filter_hndl);
+		return status;
+	} else {
+		usnic_dbg("VF %s FILTER ID:%u",
+				pci_name(pdev),
+				(u32)a0);
+	}
+
+	usnic_filter_hndl->type = FILTER_USNIC_ID;
+	usnic_filter_hndl->id = (u32)a0;
+	usnic_filter_hndl->vnic_idx = vnic_idx;
+	usnic_filter_hndl->ufdev = ufdev;
+	usnic_filter_hndl->filter = fwd_filter;
+	*filter_hndl = usnic_filter_hndl;
+
+	return status;
+}
+
+int usnic_fwd_del_filter(struct usnic_fwd_filter_hndl *filter_hndl)
+{
+	int status;
+	u64 a0, a1;
+	struct net_device *netdev;
+
+	netdev = filter_hndl->ufdev->netdev;
+	a0 = filter_hndl->id;
+
+	status = usnic_fwd_devcmd(filter_hndl->ufdev, filter_hndl->vnic_idx,
+					CMD_DEL_FILTER, &a0, &a1);
+	if (status) {
+		if (status == ERR_EINVAL) {
+			usnic_dbg("Filter %u already deleted for VF Idx %u pf: %s status: %d",
+					filter_hndl->id, filter_hndl->vnic_idx,
+					netdev_name(netdev), status);
+			status = 0;
+			kfree(filter_hndl);
+		} else {
+			usnic_err("PF %s VF Idx %u Filter: %u FILTER DELETE failed with status %d",
+					netdev_name(netdev),
+					filter_hndl->vnic_idx, filter_hndl->id,
+					status);
+		}
+	} else {
+		usnic_dbg("PF %s VF Idx %u Filter: %u FILTER DELETED",
+				netdev_name(netdev), filter_hndl->vnic_idx,
+				filter_hndl->id);
+		kfree(filter_hndl);
+	}
+
+	return status;
+}
+
+int usnic_fwd_enable_rq(struct usnic_fwd_dev *ufdev, int vnic_idx, int rq_idx)
+{
+	int status;
+	struct net_device *pf_netdev;
+	u64 a0, a1;
+
+	pf_netdev = ufdev->netdev;
+	a0 = rq_idx;
+	a1 = CMD_QP_RQWQ;
+
+	status = usnic_fwd_devcmd(ufdev, vnic_idx, CMD_QP_ENABLE, &a0, &a1);
+
+	if (status) {
+		usnic_err("PF %s VNIC Index %u RQ Index: %u ENABLE Failed with status %d",
+				netdev_name(pf_netdev),
+				vnic_idx,
+				rq_idx,
+				status);
+	} else {
+		usnic_dbg("PF %s VNIC Index %u RQ Index: %u ENABLED",
+				netdev_name(pf_netdev),
+				vnic_idx, rq_idx);
+	}
+
+	return status;
+}
+
+int usnic_fwd_disable_rq(struct usnic_fwd_dev *ufdev, int vnic_idx, int rq_idx)
+{
+	int status;
+	u64 a0, a1;
+	struct net_device *pf_netdev;
+
+	pf_netdev = ufdev->netdev;
+	a0 = rq_idx;
+	a1 = CMD_QP_RQWQ;
+
+	status = usnic_fwd_devcmd(ufdev, vnic_idx, CMD_QP_DISABLE, &a0, &a1);
+
+	if (status) {
+		usnic_err("PF %s VNIC Index %u RQ Index: %u DISABLE Failed with status %d",
+				netdev_name(pf_netdev),
+				vnic_idx,
+				rq_idx,
+				status);
+	} else {
+		usnic_dbg("PF %s VNIC Index %u RQ Index: %u DISABLED",
+				netdev_name(pf_netdev),
+				vnic_idx,
+				rq_idx);
+	}
+
+	return status;
+}
diff --git a/drivers/infiniband/hw/usnic/usnic_fwd.h b/drivers/infiniband/hw/usnic/usnic_fwd.h
new file mode 100644
index 0000000..6973901
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_fwd.h
@@ -0,0 +1,58 @@
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
+#ifndef USNIC_FWD_H_
+#define USNIC_FWD_H_
+
+#include <linux/if.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+
+#include "usnic_abi.h"
+#include "vnic_devcmd.h"
+
+struct usnic_fwd_dev {
+	struct pci_dev			*pdev;
+	struct net_device		*netdev;
+	spinlock_t			lock;
+};
+
+struct usnic_fwd_filter {
+	enum usnic_transport_type	transport;
+	u16				port_num;
+};
+
+struct usnic_fwd_filter_hndl {
+	enum filter_type		type;
+	u32				id;
+	u32				vnic_idx;
+	struct usnic_fwd_dev		*ufdev;
+	struct list_head		link;
+	struct usnic_fwd_filter		*filter;
+};
+
+struct usnic_fwd_dev *usnic_fwd_dev_alloc(struct pci_dev *pdev);
+void usnic_fwd_dev_free(struct usnic_fwd_dev *ufdev);
+int usnic_fwd_add_usnic_filter(struct usnic_fwd_dev *ufdev, int vnic_idx,
+				int rq_idx, struct usnic_fwd_filter *filter,
+				struct usnic_fwd_filter_hndl **filter_hndl);
+int usnic_fwd_del_filter(struct usnic_fwd_filter_hndl *filter_hndl);
+int usnic_fwd_enable_rq(struct usnic_fwd_dev *ufdev, int vnic_idx, int rq_idx);
+int usnic_fwd_disable_rq(struct usnic_fwd_dev *ufdev, int vnic_idx, int rq_idx);
+
+#endif /* !USNIC_FWD_H_ */
diff --git a/drivers/infiniband/hw/usnic/usnic_log.h b/drivers/infiniband/hw/usnic/usnic_log.h
new file mode 100644
index 0000000..75777a6
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_log.h
@@ -0,0 +1,58 @@
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
+#ifndef USNIC_LOG_H_
+#define USNIC_LOG_H_
+
+#include "usnic.h"
+
+extern unsigned int usnic_log_lvl;
+
+#define USNIC_LOG_LVL_NONE		(0)
+#define USNIC_LOG_LVL_ERR		(1)
+#define USNIC_LOG_LVL_INFO		(2)
+#define USNIC_LOG_LVL_DBG		(3)
+
+#define usnic_printk(lvl, args...) \
+	do { \
+		printk(lvl "%s:%s:%d: ", DRV_NAME, __func__, \
+				__LINE__); \
+		printk(args); \
+	} while (0)
+
+#define usnic_dbg(args...) \
+	do { \
+		if (unlikely(usnic_log_lvl >= USNIC_LOG_LVL_DBG)) { \
+			usnic_printk(KERN_INFO, args); \
+	} \
+} while (0)
+
+#define usnic_info(args...) \
+do { \
+	if (usnic_log_lvl >= USNIC_LOG_LVL_INFO) { \
+			usnic_printk(KERN_INFO, args); \
+	} \
+} while (0)
+
+#define usnic_err(args...) \
+	do { \
+		if (usnic_log_lvl >= USNIC_LOG_LVL_ERR) { \
+			usnic_printk(KERN_ERR, args); \
+		} \
+	} while (0)
+#endif /* !USNIC_LOG_H_ */
diff --git a/drivers/infiniband/hw/usnic/usnic_transport.c b/drivers/infiniband/hw/usnic/usnic_transport.c
new file mode 100644
index 0000000..6f3d245
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_transport.c
@@ -0,0 +1,125 @@
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
+#include <linux/bitmap.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include "usnic_transport.h"
+#include "usnic_log.h"
+
+/* ROCE */
+static unsigned long *roce_bitmap;
+static u16 roce_next_port = 1;
+#define ROCE_BITMAP_SZ ((1 << (8 /*CHAR_BIT*/ * sizeof(u16)))/8 /*CHAR BIT*/)
+DEFINE_SPINLOCK(roce_bitmap_lock);
+
+static const char *transport_to_str(enum usnic_transport_type type)
+{
+	switch (type) {
+	case USNIC_TRANSPORT_UNKNOWN:
+		return "Unknown";
+	case USNIC_TRANSPORT_ROCE_CUSTOM:
+		return "roce custom";
+	case USNIC_TRANSPORT_MAX:
+		return "Max?";
+	default:
+		return "Not known";
+	}
+}
+
+/*
+ * reserve a port number.  if "0" specified, we will try to pick one
+ * starting at roce_next_port.  roce_next_port will take on the values
+ * 1..4096
+ */
+u16 usnic_transport_rsrv_port(enum usnic_transport_type type, u16 port_num)
+{
+	if (type == USNIC_TRANSPORT_ROCE_CUSTOM) {
+		spin_lock(&roce_bitmap_lock);
+		if (!port_num) {
+			port_num = bitmap_find_next_zero_area(roce_bitmap,
+						ROCE_BITMAP_SZ,
+						roce_next_port /* start */,
+						1 /* nr */,
+						0 /* align */);
+			roce_next_port = (port_num & 4095) + 1;
+		} else if (test_bit(port_num, roce_bitmap)) {
+			usnic_err("Failed to allocate port for %s\n",
+					transport_to_str(type));
+			spin_unlock(&roce_bitmap_lock);
+			goto out_fail;
+		}
+		bitmap_set(roce_bitmap, port_num, 1);
+		spin_unlock(&roce_bitmap_lock);
+	} else {
+		usnic_err("Failed to allocate port - transport %s unsupported\n",
+				transport_to_str(type));
+		goto out_fail;
+	}
+
+	usnic_dbg("Allocating port %hu for %s\n", port_num,
+			transport_to_str(type));
+	return port_num;
+
+out_fail:
+	return 0;
+}
+
+void usnic_transport_unrsrv_port(enum usnic_transport_type type, u16 port_num)
+{
+	if (type == USNIC_TRANSPORT_ROCE_CUSTOM) {
+		spin_lock(&roce_bitmap_lock);
+		if (!port_num) {
+			usnic_err("Unreserved unvalid port num 0 for %s\n",
+					transport_to_str(type));
+			goto out_roce_custom;
+		}
+
+		if (!test_bit(port_num, roce_bitmap)) {
+			usnic_err("Unreserving invalid %hu for %s\n",
+					port_num,
+					transport_to_str(type));
+			goto out_roce_custom;
+		}
+		bitmap_clear(roce_bitmap, port_num, 1);
+		usnic_dbg("Freeing port %hu for %s\n", port_num,
+				transport_to_str(type));
+out_roce_custom:
+		spin_unlock(&roce_bitmap_lock);
+	} else {
+		usnic_err("Freeing invalid port %hu for %d\n", port_num, type);
+	}
+}
+
+int usnic_transport_init()
+{
+	roce_bitmap = kzalloc(ROCE_BITMAP_SZ, GFP_KERNEL);
+	if (!roce_bitmap) {
+		usnic_err("Failed to allocate bit map");
+		return -ENOMEM;
+	}
+
+	/* Do not ever allocate bit 0, hence set it here */
+	bitmap_set(roce_bitmap, 0, 1);
+	return 0;
+}
+
+void usnic_transport_fini(void)
+{
+	kfree(roce_bitmap);
+}
diff --git a/drivers/infiniband/hw/usnic/usnic_transport.h b/drivers/infiniband/hw/usnic/usnic_transport.h
new file mode 100644
index 0000000..e4c924e
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_transport.h
@@ -0,0 +1,27 @@
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
+#ifndef USNIC_TRANSPORT_H_
+#define USNIC_TRANSPORT_H_
+
+#include "usnic_abi.h"
+
+u16 usnic_transport_rsrv_port(enum usnic_transport_type type, u16 port_num);
+void usnic_transport_unrsrv_port(enum usnic_transport_type type, u16 port_num);
+int usnic_transport_init(void);
+#endif /* !USNIC_TRANSPORT_H */
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
new file mode 100644
index 0000000..c44acbc
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -0,0 +1,599 @@
+/*
+ * Copyright (c) 2005 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2013 Cisco Systems.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/mm.h>
+#include <linux/dma-mapping.h>
+#include <linux/sched.h>
+#include <linux/hugetlb.h>
+#include <linux/dma-attrs.h>
+#include <linux/iommu.h>
+#include <linux/workqueue.h>
+#include <linux/list.h>
+#include <linux/pci.h>
+
+#include "usnic_log.h"
+#include "usnic_uiom.h"
+#include "usnic_uiom_interval_tree.h"
+
+struct workqueue_struct *usnic_uiom_wq;
+
+#define USNIC_UIOM_PAGE_CHUNK						\
+	((PAGE_SIZE - offsetof(struct usnic_uiom_chunk, page_list))	/\
+	((void *) &((struct usnic_uiom_chunk *) 0)->page_list[1] -	\
+	(void *) &((struct usnic_uiom_chunk *) 0)->page_list[0]))
+
+static void usnic_uiom_reg_account(struct work_struct *work)
+{
+	struct usnic_uiom_reg *umem = container_of(work,
+						struct usnic_uiom_reg, work);
+
+	down_write(&umem->mm->mmap_sem);
+	umem->mm->locked_vm -= umem->diff;
+	up_write(&umem->mm->mmap_sem);
+	mmput(umem->mm);
+	kfree(umem);
+}
+
+static int usnic_uiom_dma_fault(struct iommu_domain *domain,
+				struct device *dev,
+				unsigned long iova, int flags,
+				void *token)
+{
+	usnic_err("Device %s iommu fault domain 0x%pK va 0x%lx flags 0x%x\n",
+		dev_name(dev),
+		domain, iova, flags);
+	return -ENOSYS;
+}
+
+static void usnic_uiom_put_pages(struct list_head *chunk_list, int dirty)
+{
+	struct usnic_uiom_chunk *chunk, *tmp;
+	struct page *page;
+	int i;
+
+	list_for_each_entry_safe(chunk, tmp, chunk_list, list) {
+		for (i = 0; i < chunk->nents; i++) {
+			page = sg_page(&chunk->page_list[i]);
+			if (dirty)
+				set_page_dirty_lock(page);
+			put_page(page);
+			usnic_dbg("pa: 0x%llx\n",
+					sg_phys(&chunk->page_list[i]));
+		}
+		kfree(chunk);
+	}
+}
+
+static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
+				int dmasync, struct list_head *chunk_list)
+{
+	struct page **page_list;
+	struct usnic_uiom_chunk *chunk;
+	unsigned long locked;
+	unsigned long lock_limit;
+	unsigned long cur_base;
+	unsigned long npages;
+	int ret;
+	int off;
+	int i;
+	int flags;
+	DEFINE_DMA_ATTRS(attrs);
+
+	if (dmasync)
+		dma_set_attr(DMA_ATTR_WRITE_BARRIER, &attrs);
+
+	if (!can_do_mlock())
+		return -EPERM;
+
+	INIT_LIST_HEAD(chunk_list);
+
+	page_list = (struct page **) __get_free_page(GFP_KERNEL);
+	if (!page_list)
+		return -ENOMEM;
+
+	npages = PAGE_ALIGN(size + (addr & ~PAGE_MASK)) >> PAGE_SHIFT;
+
+	down_write(&current->mm->mmap_sem);
+
+	locked = npages + current->mm->locked_vm;
+	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+
+	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	flags = IOMMU_READ | IOMMU_CACHE;
+	flags |= (writable) ? IOMMU_WRITE : 0;
+	cur_base = addr & PAGE_MASK;
+	ret = 0;
+
+	while (npages) {
+		ret = get_user_pages(current, current->mm, cur_base,
+					min_t(unsigned long, npages,
+					PAGE_SIZE / sizeof(struct page *)),
+					1, !writable, page_list, NULL);
+
+		if (ret < 0)
+			goto out;
+
+		npages -= ret;
+		off = 0;
+
+		while (ret) {
+			chunk = kmalloc(sizeof(*chunk) +
+					sizeof(struct scatterlist) *
+					min_t(int, ret, USNIC_UIOM_PAGE_CHUNK),
+					GFP_KERNEL);
+			if (!chunk) {
+				ret = -ENOMEM;
+				goto out;
+			}
+
+			chunk->nents = min_t(int, ret, USNIC_UIOM_PAGE_CHUNK);
+			sg_init_table(chunk->page_list, chunk->nents);
+			for (i = 0; i < chunk->nents; ++i) {
+				sg_set_page(&chunk->page_list[i],
+							page_list[i + off],
+							PAGE_SIZE, 0);
+				usnic_dbg("va: 0x%lx pa: 0x%llx\n",
+						cur_base + i*PAGE_SIZE,
+						sg_phys(&chunk->page_list[i]));
+			}
+			cur_base += chunk->nents * PAGE_SIZE;
+			ret -= chunk->nents;
+			off += chunk->nents;
+			list_add_tail(&chunk->list, chunk_list);
+		}
+
+		ret = 0;
+	}
+
+out:
+	if (ret < 0)
+		usnic_uiom_put_pages(chunk_list, 0);
+	else
+		current->mm->locked_vm = locked;
+
+	up_write(&current->mm->mmap_sem);
+	free_page((unsigned long) page_list);
+	return ret;
+}
+
+static void usnic_uiom_unmap_sorted_intervals(struct list_head *intervals,
+						struct usnic_uiom_pd *pd)
+{
+	struct usnic_uiom_interval_node *interval, *tmp;
+	long unsigned va, size;
+
+	list_for_each_entry_safe(interval, tmp, intervals, link) {
+		va = interval->start << PAGE_SHIFT;
+		size = ((interval->last - interval->start) + 1) << PAGE_SHIFT;
+		while (size > 0) {
+			/* Workaround for RH 970401 */
+			usnic_dbg("va 0x%lx size 0x%lx", va, PAGE_SIZE);
+			iommu_unmap(pd->domain, va, PAGE_SIZE);
+			va += PAGE_SIZE;
+			size -= PAGE_SIZE;
+		}
+	}
+}
+
+static void __usnic_uiom_reg_release(struct usnic_uiom_pd *pd,
+					struct usnic_uiom_reg *uiomr,
+					int dirty)
+{
+	int npages;
+	unsigned long vpn_start, vpn_last;
+	struct usnic_uiom_interval_node *interval, *tmp;
+	int writable = 0;
+	LIST_HEAD(rm_intervals);
+
+	npages = PAGE_ALIGN(uiomr->length + uiomr->offset) >> PAGE_SHIFT;
+	vpn_start = (uiomr->va & PAGE_MASK) >> PAGE_SHIFT;
+	vpn_last = vpn_start + npages - 1;
+
+	spin_lock(&pd->lock);
+	usnic_uiom_remove_interval(&pd->rb_root, vpn_start,
+					vpn_last, &rm_intervals);
+	usnic_uiom_unmap_sorted_intervals(&rm_intervals, pd);
+
+	list_for_each_entry_safe(interval, tmp, &rm_intervals, link) {
+		if (interval->flags & IOMMU_WRITE)
+			writable = 1;
+		list_del(&interval->link);
+		kfree(interval);
+	}
+
+	usnic_uiom_put_pages(&uiomr->chunk_list, dirty & writable);
+	spin_unlock(&pd->lock);
+}
+
+static int usnic_uiom_map_sorted_intervals(struct list_head *intervals,
+						struct usnic_uiom_reg *uiomr)
+{
+	int i, err;
+	size_t size;
+	struct usnic_uiom_chunk *chunk;
+	struct usnic_uiom_interval_node *interval_node;
+	long int pa, pa_start, pa_end;
+	long int va_start = -EINVAL;
+	struct usnic_uiom_pd *pd = uiomr->pd;
+	long int va = uiomr->va & PAGE_MASK;
+	int flags = IOMMU_READ | IOMMU_CACHE;
+
+	flags |= (uiomr->writable) ? IOMMU_WRITE : 0;
+	chunk = list_first_entry(&uiomr->chunk_list, struct usnic_uiom_chunk,
+									list);
+	list_for_each_entry(interval_node, intervals, link) {
+iter_chunk:
+		for (i = 0; i < chunk->nents; i++, va += PAGE_SIZE) {
+			pa = sg_phys(&chunk->page_list[i]);
+			if ((va >> PAGE_SHIFT) < interval_node->start)
+				continue;
+
+			if ((va >> PAGE_SHIFT) == interval_node->start) {
+				/* First page of the interval */
+				va_start = va;
+				pa_start = pa;
+				pa_end = pa;
+			}
+
+			BUG_ON(va_start == -EINVAL);
+
+			if ((pa_end + PAGE_SIZE != pa) &&
+					(pa != pa_start)) {
+				/* PAs are not contiguous */
+				size = pa_end - pa_start + PAGE_SIZE;
+				usnic_dbg("va 0x%lx pa 0x%lx size 0x%lx flags 0x%x",
+					va_start, pa_start, size, flags);
+				err = iommu_map(pd->domain, va_start, pa_start,
+							size, flags);
+				if (err) {
+					usnic_err("Failed to map va 0x%lx pa 0x%lx size 0x%zx with err %d\n",
+						va_start, pa_start, size, err);
+					goto err_out;
+				}
+				va_start = va;
+				pa_start = pa;
+				pa_end = pa;
+			}
+
+			if ((va >> PAGE_SHIFT) == interval_node->last) {
+				/* Last page of the interval */
+				size = pa - pa_start + PAGE_SIZE;
+				usnic_dbg("va 0x%lx pa 0x%lx size 0x%lx flags 0x%x\n",
+					va_start, pa_start, size, flags);
+				err = iommu_map(pd->domain, va_start, pa_start,
+						size, flags);
+				if (err) {
+					usnic_err("Failed to map va 0x%lx pa 0x%lx size 0x%zx with err %d\n",
+						va_start, pa_start, size, err);
+					goto err_out;
+				}
+				break;
+			}
+
+			if (pa != pa_start)
+				pa_end += PAGE_SIZE;
+		}
+
+		if (i == chunk->nents) {
+			/*
+			 * Hit last entry of the chunk,
+			 * hence advance to next chunk
+			 */
+			chunk = list_first_entry(&chunk->list,
+							struct usnic_uiom_chunk,
+							list);
+			goto iter_chunk;
+		}
+	}
+
+	return 0;
+
+err_out:
+	usnic_uiom_unmap_sorted_intervals(intervals, pd);
+	return err;
+}
+
+struct usnic_uiom_reg *usnic_uiom_reg_get(struct usnic_uiom_pd *pd,
+						unsigned long addr, size_t size,
+						int writable, int dmasync)
+{
+	struct usnic_uiom_reg *uiomr;
+	unsigned long va_base, vpn_start, vpn_last;
+	unsigned long npages;
+	int offset, err;
+	LIST_HEAD(sorted_diff_intervals);
+
+	/*
+	 * Intel IOMMU map throws an error if a translation entry is
+	 * changed from read to write.  This module may not unmap
+	 * and then remap the entry after fixing the permission
+	 * b/c this open up a small windows where hw DMA may page fault
+	 * Hence, make all entries to be writable.
+	 */
+	writable = 1;
+
+	va_base = addr & PAGE_MASK;
+	offset = addr & ~PAGE_MASK;
+	npages = PAGE_ALIGN(size + offset) >> PAGE_SHIFT;
+	vpn_start = (addr & PAGE_MASK) >> PAGE_SHIFT;
+	vpn_last = vpn_start + npages - 1;
+
+	uiomr = kmalloc(sizeof(*uiomr), GFP_KERNEL);
+	if (!uiomr)
+		return ERR_PTR(-ENOMEM);
+
+	uiomr->va = va_base;
+	uiomr->offset = offset;
+	uiomr->length = size;
+	uiomr->writable = writable;
+	uiomr->pd = pd;
+
+	err = usnic_uiom_get_pages(addr, size, writable, dmasync,
+					&uiomr->chunk_list);
+	if (err) {
+		usnic_err("Failed get_pages vpn [0x%lx,0x%lx] err %d\n",
+				vpn_start, vpn_last, err);
+		goto out_free_uiomr;
+	}
+
+	spin_lock(&pd->lock);
+	err = usnic_uiom_get_intervals_diff(vpn_start, vpn_last,
+						(writable) ? IOMMU_WRITE : 0,
+						IOMMU_WRITE,
+						&pd->rb_root,
+						&sorted_diff_intervals);
+	if (err) {
+		usnic_err("Failed disjoint interval vpn [0x%lx,0x%lx] err %d\n",
+						vpn_start, vpn_last, err);
+		goto out_put_pages;
+	}
+
+	err = usnic_uiom_map_sorted_intervals(&sorted_diff_intervals, uiomr);
+	if (err) {
+		usnic_err("Failed map interval vpn [0x%lx,0x%lx] err %d\n",
+						vpn_start, vpn_last, err);
+		goto out_put_intervals;
+
+	}
+
+	err = usnic_uiom_insert_interval(&pd->rb_root, vpn_start, vpn_last,
+					(writable) ? IOMMU_WRITE : 0);
+	if (err) {
+		usnic_err("Failed insert interval vpn [0x%lx,0x%lx] err %d\n",
+						vpn_start, vpn_last, err);
+		goto out_unmap_intervals;
+	}
+
+	usnic_uiom_put_interval_set(&sorted_diff_intervals);
+	spin_unlock(&pd->lock);
+
+	return uiomr;
+
+out_unmap_intervals:
+	usnic_uiom_unmap_sorted_intervals(&sorted_diff_intervals, pd);
+out_put_intervals:
+	usnic_uiom_put_interval_set(&sorted_diff_intervals);
+out_put_pages:
+	usnic_uiom_put_pages(&uiomr->chunk_list, 0);
+	spin_unlock(&pd->lock);
+out_free_uiomr:
+	kfree(uiomr);
+	return ERR_PTR(err);
+}
+
+void usnic_uiom_reg_release(struct usnic_uiom_reg *uiomr, int closing)
+{
+	struct mm_struct *mm;
+	unsigned long diff;
+
+	__usnic_uiom_reg_release(uiomr->pd, uiomr, 1);
+
+	mm = get_task_mm(current);
+	if (!mm) {
+		kfree(uiomr);
+		return;
+	}
+
+	diff = PAGE_ALIGN(uiomr->length + uiomr->offset) >> PAGE_SHIFT;
+
+	/*
+	 * We may be called with the mm's mmap_sem already held.  This
+	 * can happen when a userspace munmap() is the call that drops
+	 * the last reference to our file and calls our release
+	 * method.  If there are memory regions to destroy, we'll end
+	 * up here and not be able to take the mmap_sem.  In that case
+	 * we defer the vm_locked accounting to the system workqueue.
+	 */
+	if (closing) {
+		if (!down_write_trylock(&mm->mmap_sem)) {
+			INIT_WORK(&uiomr->work, usnic_uiom_reg_account);
+			uiomr->mm = mm;
+			uiomr->diff = diff;
+
+			queue_work(usnic_uiom_wq, &uiomr->work);
+			return;
+		}
+	} else
+		down_write(&mm->mmap_sem);
+
+	current->mm->locked_vm -= diff;
+	up_write(&mm->mmap_sem);
+	mmput(mm);
+	kfree(uiomr);
+}
+
+struct usnic_uiom_pd *usnic_uiom_alloc_pd(void)
+{
+	struct usnic_uiom_pd *pd;
+	void *domain;
+
+	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
+	if (!pd)
+		return ERR_PTR(-ENOMEM);
+
+	pd->domain = domain = iommu_domain_alloc(&pci_bus_type);
+	if (IS_ERR_OR_NULL(domain)) {
+		usnic_err("Failed to allocate IOMMU domain with err %ld\n",
+				PTR_ERR(pd->domain));
+		kfree(pd);
+		return ERR_PTR(domain ? PTR_ERR(domain) : -ENOMEM);
+	}
+
+	iommu_set_fault_handler(pd->domain, usnic_uiom_dma_fault, NULL);
+
+	spin_lock_init(&pd->lock);
+	INIT_LIST_HEAD(&pd->devs);
+
+	return pd;
+}
+
+void usnic_uiom_dealloc_pd(struct usnic_uiom_pd *pd)
+{
+	iommu_domain_free(pd->domain);
+	kfree(pd);
+}
+
+int usnic_uiom_attach_dev_to_pd(struct usnic_uiom_pd *pd, struct device *dev)
+{
+	struct usnic_uiom_dev *uiom_dev;
+	int err;
+
+	uiom_dev = kzalloc(sizeof(*uiom_dev), GFP_KERNEL);
+	if (!uiom_dev)
+		return -ENOMEM;
+	uiom_dev->dev = dev;
+
+	err = iommu_attach_device(pd->domain, dev);
+	if (err)
+		goto out_free_dev;
+
+	if (!iommu_domain_has_cap(pd->domain, IOMMU_CAP_CACHE_COHERENCY)) {
+		usnic_err("IOMMU of %s does not support cache coherency\n",
+				dev_name(dev));
+		err = -EINVAL;
+		goto out_detach_device;
+	}
+
+	spin_lock(&pd->lock);
+	list_add_tail(&uiom_dev->link, &pd->devs);
+	pd->dev_cnt++;
+	spin_unlock(&pd->lock);
+
+	return 0;
+
+out_detach_device:
+	iommu_detach_device(pd->domain, dev);
+out_free_dev:
+	kfree(uiom_dev);
+	return err;
+}
+
+void usnic_uiom_detach_dev_from_pd(struct usnic_uiom_pd *pd, struct device *dev)
+{
+	struct usnic_uiom_dev *uiom_dev;
+	int found = 0;
+
+	spin_lock(&pd->lock);
+	list_for_each_entry(uiom_dev, &pd->devs, link) {
+		if (uiom_dev->dev == dev) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (!found) {
+		usnic_err("Unable to free dev %s - not found\n",
+				dev_name(dev));
+		spin_unlock(&pd->lock);
+		return;
+	}
+
+	list_del(&uiom_dev->link);
+	pd->dev_cnt--;
+	spin_unlock(&pd->lock);
+
+	return iommu_detach_device(pd->domain, dev);
+}
+
+struct device **usnic_uiom_get_dev_list(struct usnic_uiom_pd *pd)
+{
+	struct usnic_uiom_dev *uiom_dev;
+	struct device **devs;
+	int i = 0;
+
+	spin_lock(&pd->lock);
+	devs = kzalloc(sizeof(*devs)*(pd->dev_cnt + 1), GFP_KERNEL);
+	if (!devs) {
+		devs = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+
+	list_for_each_entry(uiom_dev, &pd->devs, link) {
+		devs[i++] = uiom_dev->dev;
+	}
+out:
+	spin_unlock(&pd->lock);
+	return devs;
+}
+
+void usnic_uiom_free_dev_list(struct device **devs)
+{
+	kfree(devs);
+}
+
+int usnic_uiom_init(char *drv_name)
+{
+	if (!iommu_present(&pci_bus_type)) {
+		usnic_err("IOMMU required but not present or enabled.  USNIC QPs will not function w/o enabling IOMMU\n");
+		return -EPERM;
+	}
+
+	usnic_uiom_wq = create_workqueue(drv_name);
+	if (!usnic_uiom_wq) {
+		usnic_err("Unable to alloc wq for drv %s\n", drv_name);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+void usnic_uiom_fini(void)
+{
+	flush_workqueue(usnic_uiom_wq);
+	destroy_workqueue(usnic_uiom_wq);
+}
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.h b/drivers/infiniband/hw/usnic/usnic_uiom.h
new file mode 100644
index 0000000..7044099
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.h
@@ -0,0 +1,80 @@
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
+#ifndef USNIC_UIOM_H_
+#define USNIC_UIOM_H_
+
+#include <linux/list.h>
+#include <linux/scatterlist.h>
+
+#include "usnic_uiom_interval_tree.h"
+
+#define USNIC_UIOM_READ			(1)
+#define USNIC_UIOM_WRITE		(2)
+
+#define USNIC_UIOM_MAX_PD_CNT		(1000)
+#define USNIC_UIOM_MAX_MR_CNT		(1000000)
+#define USNIC_UIOM_MAX_MR_SIZE		(~0UL)
+#define USNIC_UIOM_PAGE_SIZE		(PAGE_SIZE)
+
+struct usnic_uiom_dev {
+	struct device			*dev;
+	struct list_head		link;
+};
+
+struct usnic_uiom_pd {
+	struct iommu_domain		*domain;
+	spinlock_t			lock;
+	struct rb_root			rb_root;
+	struct list_head		devs;
+	int				dev_cnt;
+};
+
+struct usnic_uiom_reg {
+	struct usnic_uiom_pd		*pd;
+	unsigned long			va;
+	size_t				length;
+	int				offset;
+	int				page_size;
+	int				writable;
+	struct list_head		chunk_list;
+	struct work_struct		work;
+	struct mm_struct		*mm;
+	unsigned long			diff;
+};
+
+struct usnic_uiom_chunk {
+	struct list_head		list;
+	int				nents;
+	struct scatterlist		page_list[0];
+};
+
+struct usnic_uiom_pd *usnic_uiom_alloc_pd(void);
+void usnic_uiom_dealloc_pd(struct usnic_uiom_pd *pd);
+int usnic_uiom_attach_dev_to_pd(struct usnic_uiom_pd *pd, struct device *dev);
+void usnic_uiom_detach_dev_from_pd(struct usnic_uiom_pd *pd,
+					struct device *dev);
+struct device **usnic_uiom_get_dev_list(struct usnic_uiom_pd *pd);
+void usnic_uiom_free_dev_list(struct device **devs);
+struct usnic_uiom_reg *usnic_uiom_reg_get(struct usnic_uiom_pd *pd,
+						unsigned long addr, size_t size,
+						int access, int dmasync);
+void usnic_uiom_reg_release(struct usnic_uiom_reg *uiomr, int closing);
+int usnic_uiom_init(char *drv_name);
+void usnic_uiom_fini(void);
+#endif /* USNIC_UIOM_H_ */
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c b/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c
new file mode 100644
index 0000000..b6e3a6b
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c
@@ -0,0 +1,237 @@
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/list_sort.h>
+#include <linux/version.h>
+
+#include <linux/interval_tree_generic.h>
+#include "usnic_uiom_interval_tree.h"
+
+#define START(node) ((node)->start)
+#define LAST(node) ((node)->last)
+
+#define MAKE_NODE(node, start, end, ref_cnt, flags, err, err_out)	\
+		do {							\
+			node = usnic_uiom_interval_node_alloc(start,	\
+					end, ref_cnt, flags);		\
+				if (!node) {				\
+					err = -ENOMEM;			\
+					goto err_out;			\
+				}					\
+		} while (0)
+
+#define MARK_FOR_ADD(node, list) (list_add_tail(&node->link, list))
+
+#define MAKE_NODE_AND_APPEND(node, start, end, ref_cnt, flags, err,	\
+				err_out, list)				\
+				do {					\
+					MAKE_NODE(node, start, end,	\
+						ref_cnt, flags, err,	\
+						err_out);		\
+					MARK_FOR_ADD(node, list);	\
+				} while (0)
+
+#define FLAGS_EQUAL(flags1, flags2, mask)				\
+			(((flags1) & (mask)) == ((flags2) & (mask)))
+
+static struct usnic_uiom_interval_node*
+usnic_uiom_interval_node_alloc(long int start, long int last, int ref_cnt,
+				int flags)
+{
+	struct usnic_uiom_interval_node *interval = kzalloc(sizeof(*interval),
+								GFP_KERNEL);
+	if (!interval)
+		return NULL;
+
+	interval->start = start;
+	interval->last = last;
+	interval->flags = flags;
+	interval->ref_cnt = ref_cnt;
+
+	return interval;
+}
+
+static int interval_cmp(void *priv, struct list_head *a, struct list_head *b)
+{
+	struct usnic_uiom_interval_node *node_a, *node_b;
+
+	node_a = list_entry(a, struct usnic_uiom_interval_node, link);
+	node_b = list_entry(b, struct usnic_uiom_interval_node, link);
+
+	/* long to int */
+	if (node_a->start < node_b->start)
+		return -1;
+	else if (node_a->start > node_b->start)
+		return 1;
+
+	return 0;
+}
+
+static void
+find_intervals_intersection_sorted(struct rb_root *root, unsigned long start,
+					unsigned long last,
+					struct list_head *list)
+{
+	struct usnic_uiom_interval_node *node;
+
+	INIT_LIST_HEAD(list);
+
+	for (node = usnic_uiom_interval_tree_iter_first(root, start, last);
+		node;
+		node = usnic_uiom_interval_tree_iter_next(node, start, last))
+		list_add_tail(&node->link, list);
+
+	list_sort(NULL, list, interval_cmp);
+}
+
+int usnic_uiom_get_intervals_diff(unsigned long start, unsigned long last,
+					int flags, int flag_mask,
+					struct rb_root *root,
+					struct list_head *diff_set)
+{
+	struct usnic_uiom_interval_node *interval, *tmp;
+	int err = 0;
+	long int pivot = start;
+	LIST_HEAD(intersection_set);
+
+	INIT_LIST_HEAD(diff_set);
+
+	find_intervals_intersection_sorted(root, start, last,
+						&intersection_set);
+
+	list_for_each_entry(interval, &intersection_set, link) {
+		if (pivot < interval->start) {
+			MAKE_NODE_AND_APPEND(tmp, pivot, interval->start - 1,
+						1, flags, err, err_out,
+						diff_set);
+			pivot = interval->start;
+		}
+
+		/*
+		 * Invariant: Set [start, pivot] is either in diff_set or root,
+		 * but not in both.
+		 */
+
+		if (pivot > interval->last) {
+			continue;
+		} else if (pivot <= interval->last &&
+				FLAGS_EQUAL(interval->flags, flags,
+				flag_mask)) {
+			pivot = interval->last + 1;
+		}
+	}
+
+	if (pivot <= last)
+		MAKE_NODE_AND_APPEND(tmp, pivot, last, 1, flags, err, err_out,
+					diff_set);
+
+	return 0;
+
+err_out:
+	list_for_each_entry_safe(interval, tmp, diff_set, link) {
+		list_del(&interval->link);
+		kfree(interval);
+	}
+
+	return err;
+}
+
+void usnic_uiom_put_interval_set(struct list_head *intervals)
+{
+	struct usnic_uiom_interval_node *interval, *tmp;
+	list_for_each_entry_safe(interval, tmp, intervals, link)
+		kfree(interval);
+}
+
+int usnic_uiom_insert_interval(struct rb_root *root, unsigned long start,
+				unsigned long last, int flags)
+{
+	struct usnic_uiom_interval_node *interval, *tmp;
+	unsigned long istart, ilast;
+	int iref_cnt, iflags;
+	unsigned long lpivot = start;
+	int err = 0;
+	LIST_HEAD(to_add);
+	LIST_HEAD(intersection_set);
+
+	find_intervals_intersection_sorted(root, start, last,
+						&intersection_set);
+
+	list_for_each_entry(interval, &intersection_set, link) {
+		/*
+		 * Invariant - lpivot is the left edge of next interval to be
+		 * inserted
+		 */
+		istart = interval->start;
+		ilast = interval->last;
+		iref_cnt = interval->ref_cnt;
+		iflags = interval->flags;
+
+		if (istart < lpivot) {
+			MAKE_NODE_AND_APPEND(tmp, istart, lpivot - 1, iref_cnt,
+						iflags, err, err_out, &to_add);
+		} else if (istart > lpivot) {
+			MAKE_NODE_AND_APPEND(tmp, lpivot, istart - 1, 1, flags,
+						err, err_out, &to_add);
+			lpivot = istart;
+		} else {
+			lpivot = istart;
+		}
+
+		if (ilast > last) {
+			MAKE_NODE_AND_APPEND(tmp, lpivot, last, iref_cnt + 1,
+						iflags | flags, err, err_out,
+						&to_add);
+			MAKE_NODE_AND_APPEND(tmp, last + 1, ilast, iref_cnt,
+						iflags, err, err_out, &to_add);
+		} else {
+			MAKE_NODE_AND_APPEND(tmp, lpivot, ilast, iref_cnt + 1,
+						iflags | flags, err, err_out,
+						&to_add);
+		}
+
+		lpivot = ilast + 1;
+	}
+
+	if (lpivot <= last)
+		MAKE_NODE_AND_APPEND(tmp, lpivot, last, 1, flags, err, err_out,
+					&to_add);
+
+	list_for_each_entry_safe(interval, tmp, &intersection_set, link) {
+		usnic_uiom_interval_tree_remove(interval, root);
+		kfree(interval);
+	}
+
+	list_for_each_entry(interval, &to_add, link)
+		usnic_uiom_interval_tree_insert(interval, root);
+
+	return 0;
+
+err_out:
+	list_for_each_entry_safe(interval, tmp, &to_add, link)
+		kfree(interval);
+
+	return err;
+}
+
+void usnic_uiom_remove_interval(struct rb_root *root, unsigned long start,
+				unsigned long last, struct list_head *removed)
+{
+	struct usnic_uiom_interval_node *interval;
+
+	for (interval = usnic_uiom_interval_tree_iter_first(root, start, last);
+			interval;
+			interval = usnic_uiom_interval_tree_iter_next(interval,
+									start,
+									last)) {
+		if (--interval->ref_cnt == 0)
+			list_add_tail(&interval->link, removed);
+	}
+
+	list_for_each_entry(interval, removed, link)
+		usnic_uiom_interval_tree_remove(interval, root);
+}
+
+INTERVAL_TREE_DEFINE(struct usnic_uiom_interval_node, rb,
+			unsigned long, __subtree_last,
+			START, LAST, , usnic_uiom_interval_tree)
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h b/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h
new file mode 100644
index 0000000..030ba6e
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h
@@ -0,0 +1,74 @@
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
+#ifndef USNIC_UIOM_INTERVAL_TREE_H_
+#define USNIC_UIOM_INTERVAL_TREE_H_
+
+#include <linux/version.h>
+#include <linux/rbtree.h>
+
+struct usnic_uiom_interval_node {
+	struct rb_node			rb;
+	struct list_head		link;
+	unsigned long			start;
+	unsigned long			last;
+	unsigned long			__subtree_last;
+	unsigned int			ref_cnt;
+	int				flags;
+};
+
+extern void
+usnic_uiom_interval_tree_insert(struct usnic_uiom_interval_node *node,
+					struct rb_root *root);
+extern void
+usnic_uiom_interval_tree_remove(struct usnic_uiom_interval_node *node,
+					struct rb_root *root);
+extern struct usnic_uiom_interval_node *
+usnic_uiom_interval_tree_iter_first(struct rb_root *root,
+					unsigned long start,
+					unsigned long last);
+extern struct usnic_uiom_interval_node *
+usnic_uiom_interval_tree_iter_next(struct usnic_uiom_interval_node *node,
+			unsigned long start, unsigned long last);
+/*
+ * Inserts {start...last} into {root}.  If there are overlaps,
+ * nodes will be broken up and merged
+ */
+int usnic_uiom_insert_interval(struct rb_root *root,
+				unsigned long start, unsigned long last,
+				int flags);
+/*
+ * Removed {start...last} from {root}.  The nodes removed are returned in
+ * 'removed.' The caller is responsibile for freeing memory of nodes in
+ * 'removed.'
+ */
+void usnic_uiom_remove_interval(struct rb_root *root,
+				unsigned long start, unsigned long last,
+				struct list_head *removed);
+/*
+ * Returns {start...last} - {root} (relative complement of {start...last} in
+ * {root}) in diff_set sorted ascendingly
+ */
+int usnic_uiom_get_intervals_diff(unsigned long start,
+					unsigned long last, int flags,
+					int flag_mask,
+					struct rb_root *root,
+					struct list_head *diff_set);
+/* Call this to free diff_set returned by usnic_uiom_get_intervals_diff */
+void usnic_uiom_put_interval_set(struct list_head *intervals);
+#endif /* USNIC_UIOM_INTERVAL_TREE_H_ */
diff --git a/drivers/infiniband/hw/usnic/usnic_vnic.c b/drivers/infiniband/hw/usnic/usnic_vnic.c
new file mode 100644
index 0000000..11c2449
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_vnic.c
@@ -0,0 +1,473 @@
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
+#include <linux/pci.h>
+
+#include "usnic_ib.h"
+#include "vnic_resource.h"
+#include "usnic_log.h"
+#include "usnic_vnic.h"
+
+struct usnic_vnic {
+	struct vnic_dev			*vdev;
+	struct vnic_dev_bar		bar[PCI_NUM_RESOURCES];
+	struct usnic_vnic_res_chunk	chunks[USNIC_VNIC_RES_TYPE_MAX];
+	spinlock_t			res_lock;
+};
+
+static enum vnic_res_type _to_vnic_res_type(enum usnic_vnic_res_type res_type)
+{
+#define DEFINE_USNIC_VNIC_RES_AT(usnic_vnic_res_t, vnic_res_type, desc, val) \
+		vnic_res_type,
+#define DEFINE_USNIC_VNIC_RES(usnic_vnic_res_t, vnic_res_type, desc) \
+		vnic_res_type,
+	static enum vnic_res_type usnic_vnic_type_2_vnic_type[] = {
+						USNIC_VNIC_RES_TYPES};
+#undef DEFINE_USNIC_VNIC_RES
+#undef DEFINE_USNIC_VNIC_RES_AT
+
+	if (res_type >= USNIC_VNIC_RES_TYPE_MAX)
+		return RES_TYPE_MAX;
+
+	return usnic_vnic_type_2_vnic_type[res_type];
+}
+
+const char *usnic_vnic_res_type_to_str(enum usnic_vnic_res_type res_type)
+{
+#define DEFINE_USNIC_VNIC_RES_AT(usnic_vnic_res_t, vnic_res_type, desc, val) \
+		desc,
+#define DEFINE_USNIC_VNIC_RES(usnic_vnic_res_t, vnic_res_type, desc) \
+		desc,
+	static const char * const usnic_vnic_res_type_desc[] = {
+						USNIC_VNIC_RES_TYPES};
+#undef DEFINE_USNIC_VNIC_RES
+#undef DEFINE_USNIC_VNIC_RES_AT
+
+	if (res_type >= USNIC_VNIC_RES_TYPE_MAX)
+		return "unknown";
+
+	return usnic_vnic_res_type_desc[res_type];
+
+}
+
+const char *usnic_vnic_pci_name(struct usnic_vnic *vnic)
+{
+	return pci_name(usnic_vnic_get_pdev(vnic));
+}
+
+int usnic_vnic_dump(struct usnic_vnic *vnic, char *buf,
+			int buf_sz,
+			void *hdr_obj,
+			int (*printtitle)(void *, char*, int),
+			int (*printcols)(char *, int),
+			int (*printrow)(void *, char *, int))
+{
+	struct usnic_vnic_res_chunk *chunk;
+	struct usnic_vnic_res *res;
+	struct vnic_dev_bar *bar0;
+	int i, j, offset;
+
+	offset = 0;
+	bar0 = usnic_vnic_get_bar(vnic, 0);
+	offset += scnprintf(buf + offset, buf_sz - offset,
+			"VF:%hu BAR0 bus_addr=0x%llx vaddr=0x%p size=%ld ",
+			usnic_vnic_get_index(vnic),
+			bar0->bus_addr,
+			bar0->vaddr, bar0->len);
+	if (printtitle)
+		offset += printtitle(hdr_obj, buf + offset, buf_sz - offset);
+	offset += scnprintf(buf + offset, buf_sz - offset, "\n");
+	offset += scnprintf(buf + offset, buf_sz - offset,
+			"|RES\t|CTRL_PIN\t\t|IN_USE\t");
+	if (printcols)
+		offset += printcols(buf + offset, buf_sz - offset);
+	offset += scnprintf(buf + offset, buf_sz - offset, "\n");
+
+	spin_lock(&vnic->res_lock);
+	for (i = 0; i < ARRAY_SIZE(vnic->chunks); i++) {
+		chunk = &vnic->chunks[i];
+		if (chunk->cnt == 0)
+			continue;
+		for (j = 0; j < chunk->cnt; j++) {
+			res = chunk->res[j];
+			offset += scnprintf(buf + offset, buf_sz - offset,
+					"|%s[%u]\t|0x%p\t|%u\t",
+					usnic_vnic_res_type_to_str(res->type),
+					res->vnic_idx, res->ctrl, !!res->owner);
+			if (printrow) {
+				offset += printrow(res->owner, buf + offset,
+							buf_sz - offset);
+			}
+			offset += scnprintf(buf + offset, buf_sz - offset,
+						"\n");
+		}
+	}
+	spin_unlock(&vnic->res_lock);
+	return offset;
+}
+
+void usnic_vnic_res_spec_update(struct usnic_vnic_res_spec *spec,
+				enum usnic_vnic_res_type trgt_type,
+				u16 cnt)
+{
+	int i;
+
+	for (i = 0; i < USNIC_VNIC_RES_TYPE_MAX; i++) {
+		if (spec->resources[i].type == trgt_type) {
+			spec->resources[i].cnt = cnt;
+			return;
+		}
+	}
+
+	WARN_ON(1);
+}
+
+int usnic_vnic_res_spec_satisfied(const struct usnic_vnic_res_spec
+					const *min_spec,
+					const struct usnic_vnic_res_spec
+					const *res_spec)
+{
+	int found, i, j;
+
+	for (i = 0; i < USNIC_VNIC_RES_TYPE_MAX; i++) {
+		found = 0;
+
+		for (j = 0; j < USNIC_VNIC_RES_TYPE_MAX; j++) {
+			if (res_spec->resources[i].type !=
+				min_spec->resources[i].type)
+				continue;
+			found = 1;
+			if (min_spec->resources[i].cnt >
+					res_spec->resources[i].cnt)
+				return -EINVAL;
+			break;
+		}
+
+		if (!found)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+int usnic_vnic_spec_dump(char *buf, int buf_sz, const struct usnic_vnic_res_spec
+						const *res_spec)
+{
+	enum usnic_vnic_res_type res_type;
+	int res_cnt;
+	int i;
+	int offset = 0;
+
+	for (i = 0; i < USNIC_VNIC_RES_TYPE_MAX; i++) {
+		res_type = res_spec->resources[i].type;
+		res_cnt = res_spec->resources[i].cnt;
+		offset += scnprintf(buf + offset, buf_sz - offset,
+				"Res: %s Cnt: %d ",
+				usnic_vnic_res_type_to_str(res_type),
+				res_cnt);
+	}
+
+	offset += scnprintf(buf + offset, buf_sz - offset,
+				"\n");
+	return offset;
+}
+
+int usnic_vnic_check_room(struct usnic_vnic *vnic,
+			const struct usnic_vnic_res_spec const *res_spec)
+{
+	int i;
+	enum usnic_vnic_res_type res_type;
+	int res_cnt;
+
+	for (i = 0; i < USNIC_VNIC_RES_TYPE_MAX; i++) {
+		res_type = res_spec->resources[i].type;
+		res_cnt = res_spec->resources[i].cnt;
+
+		if (res_type == USNIC_VNIC_RES_TYPE_EOL)
+			break;
+
+		if (res_cnt > usnic_vnic_res_free_cnt(vnic, res_type))
+			return -EBUSY;
+	}
+
+	return 0;
+}
+
+int usnic_vnic_res_cnt(struct usnic_vnic *vnic,
+				enum usnic_vnic_res_type type)
+{
+	return vnic->chunks[type].cnt;
+}
+
+int usnic_vnic_res_free_cnt(struct usnic_vnic *vnic,
+				enum usnic_vnic_res_type type)
+{
+	return vnic->chunks[type].free_cnt;
+}
+
+struct usnic_vnic_res_chunk *
+usnic_vnic_get_resources(struct usnic_vnic *vnic, enum usnic_vnic_res_type type,
+				int cnt, void *owner)
+{
+	struct usnic_vnic_res_chunk *src, *ret;
+	struct usnic_vnic_res *res;
+	int i;
+
+	if (usnic_vnic_res_free_cnt(vnic, type) < cnt || cnt < 1 || !owner)
+		return ERR_PTR(-EINVAL);
+
+	ret = kzalloc(sizeof(*ret), GFP_KERNEL);
+	if (!ret) {
+		usnic_err("Failed to allocate chunk for %s - Out of memory\n",
+				usnic_vnic_pci_name(vnic));
+		return ERR_PTR(-ENOMEM);
+	}
+
+	ret->res = kzalloc(sizeof(*(ret->res))*cnt, GFP_KERNEL);
+	if (!ret->res) {
+		usnic_err("Failed to allocate resources for %s. Out of memory\n",
+				usnic_vnic_pci_name(vnic));
+		kfree(ret);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	spin_lock(&vnic->res_lock);
+	src = &vnic->chunks[type];
+	for (i = 0; i < src->cnt && ret->cnt < cnt; i++) {
+		res = src->res[i];
+		if (!res->owner) {
+			src->free_cnt--;
+			res->owner = owner;
+			ret->res[ret->cnt++] = res;
+		}
+	}
+
+	spin_unlock(&vnic->res_lock);
+	ret->type = type;
+	ret->vnic = vnic;
+	WARN_ON(ret->cnt != cnt);
+
+	return ret;
+}
+
+void usnic_vnic_put_resources(struct usnic_vnic_res_chunk *chunk)
+{
+
+	struct usnic_vnic_res *res;
+	int i;
+	struct usnic_vnic *vnic = chunk->vnic;
+
+	spin_lock(&vnic->res_lock);
+	while ((i = --chunk->cnt) >= 0) {
+		res = chunk->res[i];
+		chunk->res[i] = NULL;
+		res->owner = NULL;
+		vnic->chunks[res->type].free_cnt++;
+	}
+	spin_unlock(&vnic->res_lock);
+
+	kfree(chunk->res);
+	kfree(chunk);
+}
+
+u16 usnic_vnic_get_index(struct usnic_vnic *vnic)
+{
+	return usnic_vnic_get_pdev(vnic)->devfn - 1;
+}
+
+static int usnic_vnic_alloc_res_chunk(struct usnic_vnic *vnic,
+					enum usnic_vnic_res_type type,
+					struct usnic_vnic_res_chunk *chunk)
+{
+	int cnt, err, i;
+	struct usnic_vnic_res *res;
+
+	cnt = vnic_dev_get_res_count(vnic->vdev, _to_vnic_res_type(type));
+	if (cnt < 1)
+		return -EINVAL;
+
+	chunk->cnt = chunk->free_cnt = cnt;
+	chunk->res = kzalloc(sizeof(*(chunk->res))*cnt, GFP_KERNEL);
+	if (!chunk->res)
+		return -ENOMEM;
+
+	for (i = 0; i < cnt; i++) {
+		res = kzalloc(sizeof(*res), GFP_KERNEL);
+		if (!res) {
+			err = -ENOMEM;
+			goto fail;
+		}
+		res->type = type;
+		res->vnic_idx = i;
+		res->vnic = vnic;
+		res->ctrl = vnic_dev_get_res(vnic->vdev,
+						_to_vnic_res_type(type), i);
+		chunk->res[i] = res;
+	}
+
+	chunk->vnic = vnic;
+	return 0;
+fail:
+	for (i--; i >= 0; i--)
+		kfree(chunk->res[i]);
+	kfree(chunk->res);
+	return err;
+}
+
+static void usnic_vnic_free_res_chunk(struct usnic_vnic_res_chunk *chunk)
+{
+	int i;
+	for (i = 0; i < chunk->cnt; i++)
+		kfree(chunk->res[i]);
+	kfree(chunk->res);
+}
+
+static int usnic_vnic_discover_resources(struct pci_dev *pdev,
+						struct usnic_vnic *vnic)
+{
+	enum usnic_vnic_res_type res_type;
+	int i;
+	int err = 0;
+
+	for (i = 0; i < ARRAY_SIZE(vnic->bar); i++) {
+		if (!(pci_resource_flags(pdev, i) & IORESOURCE_MEM))
+			continue;
+		vnic->bar[i].len = pci_resource_len(pdev, i);
+		vnic->bar[i].vaddr = pci_iomap(pdev, i, vnic->bar[i].len);
+		if (!vnic->bar[i].vaddr) {
+			usnic_err("Cannot memory-map BAR %d, aborting\n",
+					i);
+			err = -ENODEV;
+			goto out_clean_bar;
+		}
+		vnic->bar[i].bus_addr = pci_resource_start(pdev, i);
+	}
+
+	vnic->vdev = vnic_dev_register(NULL, pdev, pdev, vnic->bar,
+			ARRAY_SIZE(vnic->bar));
+	if (!vnic->vdev) {
+		usnic_err("Failed to register device %s\n",
+				pci_name(pdev));
+		err = -EINVAL;
+		goto out_clean_bar;
+	}
+
+	for (res_type = USNIC_VNIC_RES_TYPE_EOL + 1;
+			res_type < USNIC_VNIC_RES_TYPE_MAX; res_type++) {
+		err = usnic_vnic_alloc_res_chunk(vnic, res_type,
+						&vnic->chunks[res_type]);
+		if (err) {
+			usnic_err("Failed to alloc res %s with err %d\n",
+					usnic_vnic_res_type_to_str(res_type),
+					err);
+			goto out_clean_chunks;
+		}
+	}
+
+	return 0;
+
+out_clean_chunks:
+	for (res_type--; res_type > USNIC_VNIC_RES_TYPE_EOL; res_type--)
+		usnic_vnic_free_res_chunk(&vnic->chunks[res_type]);
+	vnic_dev_unregister(vnic->vdev);
+out_clean_bar:
+	for (i = 0; i < ARRAY_SIZE(vnic->bar); i++) {
+		if (!(pci_resource_flags(pdev, i) & IORESOURCE_MEM))
+			continue;
+		if (!vnic->bar[i].vaddr)
+			break;
+
+		iounmap(vnic->bar[i].vaddr);
+	}
+
+	return err;
+}
+
+struct pci_dev *usnic_vnic_get_pdev(struct usnic_vnic *vnic)
+{
+	return vnic_dev_get_pdev(vnic->vdev);
+}
+
+struct vnic_dev_bar *usnic_vnic_get_bar(struct usnic_vnic *vnic,
+				int bar_num)
+{
+	return (bar_num < ARRAY_SIZE(vnic->bar)) ? &vnic->bar[bar_num] : NULL;
+}
+
+static void usnic_vnic_release_resources(struct usnic_vnic *vnic)
+{
+	int i;
+	struct pci_dev *pdev;
+	enum usnic_vnic_res_type res_type;
+
+	pdev = usnic_vnic_get_pdev(vnic);
+
+	for (res_type = USNIC_VNIC_RES_TYPE_EOL + 1;
+			res_type < USNIC_VNIC_RES_TYPE_MAX; res_type++)
+		usnic_vnic_free_res_chunk(&vnic->chunks[res_type]);
+
+	vnic_dev_unregister(vnic->vdev);
+
+	for (i = 0; i < ARRAY_SIZE(vnic->bar); i++) {
+		if (!(pci_resource_flags(pdev, i) & IORESOURCE_MEM))
+			continue;
+		iounmap(vnic->bar[i].vaddr);
+	}
+}
+
+struct usnic_vnic *usnic_vnic_alloc(struct pci_dev *pdev)
+{
+	struct usnic_vnic *vnic;
+	int err = 0;
+
+	if (!pci_is_enabled(pdev)) {
+		usnic_err("PCI dev %s is disabled\n", pci_name(pdev));
+		return ERR_PTR(-EINVAL);
+	}
+
+	vnic = kzalloc(sizeof(*vnic), GFP_KERNEL);
+	if (!vnic) {
+		usnic_err("Failed to alloc vnic for %s - out of memory\n",
+				pci_name(pdev));
+		return ERR_PTR(-ENOMEM);
+	}
+
+	spin_lock_init(&vnic->res_lock);
+
+	err = usnic_vnic_discover_resources(pdev, vnic);
+	if (err) {
+		usnic_err("Failed to discover %s resources with err %d\n",
+				pci_name(pdev), err);
+		goto out_free_vnic;
+	}
+
+	usnic_dbg("Allocated vnic for %s\n", usnic_vnic_pci_name(vnic));
+
+	return vnic;
+
+out_free_vnic:
+	kfree(vnic);
+
+	return ERR_PTR(err);
+}
+
+void usnic_vnic_free(struct usnic_vnic *vnic)
+{
+	usnic_vnic_release_resources(vnic);
+	kfree(vnic);
+}
diff --git a/drivers/infiniband/hw/usnic/usnic_vnic.h b/drivers/infiniband/hw/usnic/usnic_vnic.h
new file mode 100644
index 0000000..0a69a5d
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/usnic_vnic.h
@@ -0,0 +1,105 @@
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
+#ifndef USNIC_VNIC_H_
+#define USNIC_VNIC_H_
+
+#include <linux/pci.h>
+
+#include "vnic_dev.h"
+
+/*                      =USNIC_VNIC_RES_TYPE= =VNIC_RES=   =DESC= */
+#define USNIC_VNIC_RES_TYPES \
+	DEFINE_USNIC_VNIC_RES_AT(EOL, RES_TYPE_EOL, "EOL", 0) \
+	DEFINE_USNIC_VNIC_RES(WQ, RES_TYPE_WQ, "WQ") \
+	DEFINE_USNIC_VNIC_RES(RQ, RES_TYPE_RQ, "RQ") \
+	DEFINE_USNIC_VNIC_RES(CQ, RES_TYPE_CQ, "CQ") \
+	DEFINE_USNIC_VNIC_RES(INTR, RES_TYPE_INTR_CTRL, "INT") \
+	DEFINE_USNIC_VNIC_RES(MAX, RES_TYPE_MAX, "MAX")\
+
+#define DEFINE_USNIC_VNIC_RES_AT(usnic_vnic_res_t, vnic_res_type, desc, val) \
+	USNIC_VNIC_RES_TYPE_##usnic_vnic_res_t = val,
+#define DEFINE_USNIC_VNIC_RES(usnic_vnic_res_t, vnic_res_type, desc) \
+	USNIC_VNIC_RES_TYPE_##usnic_vnic_res_t,
+enum usnic_vnic_res_type {
+	USNIC_VNIC_RES_TYPES
+};
+#undef DEFINE_USNIC_VNIC_RES
+#undef DEFINE_USNIC_VNIC_RES_AT
+
+struct usnic_vnic_res {
+	enum usnic_vnic_res_type	type;
+	unsigned int			vnic_idx;
+	struct usnic_vnic		*vnic;
+	void __iomem			*ctrl;
+	void				*owner;
+};
+
+struct usnic_vnic_res_chunk {
+	enum usnic_vnic_res_type	type;
+	int				cnt;
+	int				free_cnt;
+	struct usnic_vnic_res		**res;
+	struct usnic_vnic		*vnic;
+};
+
+struct usnic_vnic_res_desc {
+	enum usnic_vnic_res_type	type;
+	uint16_t			cnt;
+};
+
+struct usnic_vnic_res_spec {
+	struct usnic_vnic_res_desc resources[USNIC_VNIC_RES_TYPE_MAX];
+};
+
+const char *usnic_vnic_res_type_to_str(enum usnic_vnic_res_type res_type);
+const char *usnic_vnic_pci_name(struct usnic_vnic *vnic);
+int usnic_vnic_dump(struct usnic_vnic *vnic, char *buf, int buf_sz,
+			void *hdr_obj,
+			int (*printtitle)(void *, char*, int),
+			int (*printcols)(char *, int),
+			int (*printrow)(void *, char *, int));
+void usnic_vnic_res_spec_update(struct usnic_vnic_res_spec *spec,
+				enum usnic_vnic_res_type trgt_type,
+				u16 cnt);
+int usnic_vnic_res_spec_satisfied(const struct usnic_vnic_res_spec
+					const *min_spec,
+					const struct usnic_vnic_res_spec
+					const *res_spec);
+int usnic_vnic_spec_dump(char *buf, int buf_sz, const struct usnic_vnic_res_spec
+						const *res_spec);
+int usnic_vnic_check_room(struct usnic_vnic *vnic,
+			const struct usnic_vnic_res_spec const *res_spec);
+int usnic_vnic_res_cnt(struct usnic_vnic *vnic,
+				enum usnic_vnic_res_type type);
+int usnic_vnic_res_free_cnt(struct usnic_vnic *vnic,
+				enum usnic_vnic_res_type type);
+struct usnic_vnic_res_chunk *
+usnic_vnic_get_resources(struct usnic_vnic *vnic,
+				enum usnic_vnic_res_type type,
+				int cnt,
+				void *owner);
+void usnic_vnic_put_resources(struct usnic_vnic_res_chunk *chunk);
+struct pci_dev *usnic_vnic_get_pdev(struct usnic_vnic *vnic);
+struct vnic_dev_bar *usnic_vnic_get_bar(struct usnic_vnic *vnic,
+				int bar_num);
+struct usnic_vnic *usnic_vnic_alloc(struct pci_dev *pdev);
+void usnic_vnic_free(struct usnic_vnic *vnic);
+u16 usnic_vnic_get_index(struct usnic_vnic *vnic);
+
+#endif /*!USNIC_VNIC_H_*/
--
1.8.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
