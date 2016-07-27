From: kys-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org
Subject: [PATCH 1/1] Drivers: infiniband: hw: vmbus-nd: NetworkDirect driver for Linux
Date: Tue, 26 Jul 2016 19:05:37 -0700
Message-ID: <1469585137-31229-1-git-send-email-kys@exchange.microsoft.com>
Reply-To: kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, olaf-QOLJcTWqO2uzQB+pC5nmwQ@public.gmane.org, apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leann.ogasawara-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org
Cc: "K. Y. Srinivasan" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: K. Y. Srinivasan <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

This driver is a bridge driver that surfaces a Mellanox device in the Linux guest and plugs into
the "NetworkDirect" RDMA infrastructure on the Windows host. Only a subset of the ibverbs are
implemented (this decision is based on the verbs supported by the Windows host).
The control path is implemented over the vmbus using the NetworkDirect protocol for
virtualized environments. The data path bypasses the guest and host kernel and the NIC is able to RDMA
into guest addresses.

Signed-off-by: K. Y. Srinivasan <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 drivers/infiniband/Kconfig                  |    1 +
 drivers/infiniband/hw/Makefile              |    1 +
 drivers/infiniband/hw/vmbus-nd/Kconfig      |    5 +
 drivers/infiniband/hw/vmbus-nd/Makefile     |    3 +
 drivers/infiniband/hw/vmbus-nd/hvnd_addr.c  |  292 +++
 drivers/infiniband/hw/vmbus-nd/mx_abi.h     |  232 ++
 drivers/infiniband/hw/vmbus-nd/provider.c   | 2844 ++++++++++++++++++++++++
 drivers/infiniband/hw/vmbus-nd/vmbus_rdma.c | 3086 +++++++++++++++++++++++++++
 drivers/infiniband/hw/vmbus-nd/vmbus_rdma.h | 2205 +++++++++++++++++++
 9 files changed, 8669 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/hw/vmbus-nd/Kconfig
 create mode 100644 drivers/infiniband/hw/vmbus-nd/Makefile
 create mode 100644 drivers/infiniband/hw/vmbus-nd/hvnd_addr.c
 create mode 100644 drivers/infiniband/hw/vmbus-nd/mx_abi.h
 create mode 100644 drivers/infiniband/hw/vmbus-nd/provider.c
 create mode 100644 drivers/infiniband/hw/vmbus-nd/vmbus_rdma.c
 create mode 100644 drivers/infiniband/hw/vmbus-nd/vmbus_rdma.h

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 2137adf..768d5b7 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -70,6 +70,7 @@ source "drivers/infiniband/hw/cxgb3/Kconfig"
 source "drivers/infiniband/hw/cxgb4/Kconfig"
 source "drivers/infiniband/hw/i40iw/Kconfig"
 source "drivers/infiniband/hw/mlx4/Kconfig"
+source "drivers/infiniband/hw/vmbus-nd/Kconfig"
 source "drivers/infiniband/hw/mlx5/Kconfig"
 source "drivers/infiniband/hw/nes/Kconfig"
 source "drivers/infiniband/hw/ocrdma/Kconfig"
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index c0c7cf8..4126124 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_INFINIBAND_CXGB3)		+= cxgb3/
 obj-$(CONFIG_INFINIBAND_CXGB4)		+= cxgb4/
 obj-$(CONFIG_INFINIBAND_I40IW)		+= i40iw/
 obj-$(CONFIG_MLX4_INFINIBAND)		+= mlx4/
+obj-$(CONFIG_HYPERV_INFINIBAND_ND)	+= vmbus-nd/
 obj-$(CONFIG_MLX5_INFINIBAND)		+= mlx5/
 obj-$(CONFIG_INFINIBAND_NES)		+= nes/
 obj-$(CONFIG_INFINIBAND_OCRDMA)		+= ocrdma/
diff --git a/drivers/infiniband/hw/vmbus-nd/Kconfig b/drivers/infiniband/hw/vmbus-nd/Kconfig
new file mode 100644
index 0000000..63254bb
--- /dev/null
+++ b/drivers/infiniband/hw/vmbus-nd/Kconfig
@@ -0,0 +1,5 @@
+config HYPERV_INFINIBAND_ND
+	tristate "Microsoft Hyper-V Network Direct"
+	depends on PCI && INET && INFINIBAND && HYPERV
+	---help---
+	  This is a low-level driver for Vmbus based NetworkDirect.
diff --git a/drivers/infiniband/hw/vmbus-nd/Makefile b/drivers/infiniband/hw/vmbus-nd/Makefile
new file mode 100644
index 0000000..579faec
--- /dev/null
+++ b/drivers/infiniband/hw/vmbus-nd/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_HYPERV_INFINIBAND_ND)	+= hv_network_direct.o
+
+hv_network_direct-y := provider.o vmbus_rdma.o hvnd_addr.o
diff --git a/drivers/infiniband/hw/vmbus-nd/hvnd_addr.c b/drivers/infiniband/hw/vmbus-nd/hvnd_addr.c
new file mode 100644
index 0000000..281f731
--- /dev/null
+++ b/drivers/infiniband/hw/vmbus-nd/hvnd_addr.c
@@ -0,0 +1,292 @@
+/*
+ * Copyright (c) 2014, Microsoft Corporation.
+ *
+ * Author:
+ *   K. Y. Srinivasan <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * Bug fixes/enhancements: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
+ */
+
+#include <linux/completion.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/hyperv.h>
+#include <linux/efi.h>
+#include <linux/slab.h>
+#include <linux/cred.h>
+#include <linux/uidgid.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <linux/completion.h>
+#include <linux/scatterlist.h>
+#include <rdma/ib_umem.h>
+#include <rdma/ib_addr.h>
+
+#include "vmbus_rdma.h"
+
+
+#include <linux/semaphore.h>
+#include <linux/fs.h>
+#include <linux/nls.h>
+#include <linux/workqueue.h>
+#include <linux/cdev.h>
+#include <linux/hyperv.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/miscdevice.h>
+#include <linux/hyperv.h>
+
+
+/*
+ * Create a char device that can support read/write for passing
+ * the payload.
+ */
+
+static struct completion ip_event;
+static bool opened;
+
+char hvnd_ip_addr[4];
+char hvnd_mac_addr[6];
+bool hvnd_addr_set;
+
+int hvnd_get_ip_addr(char **ip_addr, char **mac_addr)
+{
+	int t;
+
+	/*
+	 * Now wait for the user level daemon to get us the
+	 * IP addresses bound to the MAC address.
+	 */
+	if (!hvnd_addr_set) {
+		t = wait_for_completion_timeout(&ip_event, 600*HZ);
+		if (t == 0)
+			return -ETIMEDOUT;
+	}
+
+	if (hvnd_addr_set) {
+		*ip_addr = hvnd_ip_addr;
+		*mac_addr = hvnd_mac_addr;
+		return 0;
+	}
+
+	return -ENODATA;
+}
+
+static ssize_t hvnd_write(struct file *file, const char __user *buf,
+			size_t count, loff_t *ppos)
+{
+	char input[120];
+	int scaned, i;
+	unsigned int mac_addr[6], ip_addr[4];
+
+	if (hvnd_addr_set) {
+		hvnd_error("IP/MAC address already set, ignoring input\n");
+		return count;
+	}
+
+	if (count > sizeof(input)-1)
+		return -EINVAL;
+
+	if (copy_from_user(input, buf, count))
+		return -EFAULT;
+
+	input[count] = 0;
+
+	/*
+	 * Wakeup the context that may be waiting for this.
+	 */
+	hvnd_debug("get user mode input: %s\n", input);
+
+	scaned = sscanf(input,
+		"rdmaMacAddress=\"%x:%x:%x:%x:%x:%x\" rdmaIPv4Address=\"%u.%u.%u.%u\"",
+		&mac_addr[0],
+		&mac_addr[1],
+		&mac_addr[2],
+		&mac_addr[3],
+		&mac_addr[4],
+		&mac_addr[5],
+		&ip_addr[0],
+		&ip_addr[1],
+		&ip_addr[2],
+		&ip_addr[3]);
+
+	if (scaned == 10) {
+
+		for (i = 0; i < 6; i++)
+			hvnd_mac_addr[i] = (char) mac_addr[i];
+		for (i = 0; i < 4; i++)
+			hvnd_ip_addr[i] = (char) ip_addr[i];
+
+		hvnd_error("Scanned IP address: %pI4 Mac address: %pM\n",
+			   hvnd_ip_addr, hvnd_mac_addr);
+
+		hvnd_addr_set = true;
+		complete(&ip_event);
+	}
+
+	return count;
+}
+
+static int hvnd_open(struct inode *inode, struct file *f)
+{
+	/*
+	 * The user level daemon that will open this device is
+	 * really an extension of this driver. We can have only
+	 * active open at a time.
+	 */
+	if (opened)
+		return -EBUSY;
+
+	/*
+	 * The daemon is alive; setup the state.
+	 */
+	opened = true;
+	return 0;
+}
+
+static int hvnd_release(struct inode *inode, struct file *f)
+{
+	/*
+	 * The daemon has exited; reset the state.
+	 */
+	opened = false;
+	return 0;
+}
+
+
+static const struct file_operations hvnd_fops = {
+	.write          = hvnd_write,
+	.release	= hvnd_release,
+	.open		= hvnd_open,
+};
+
+static struct miscdevice hvnd_misc = {
+	.minor          = MISC_DYNAMIC_MINOR,
+	.name           = "hvnd_rdma",
+	.fops           = &hvnd_fops,
+};
+
+static int hvnd_dev_init(void)
+{
+	init_completion(&ip_event);
+	return misc_register(&hvnd_misc);
+}
+
+static void hvnd_dev_deinit(void)
+{
+
+	/*
+	 * The device is going away - perhaps because the
+	 * host has rescinded the channel. Setup state so that
+	 * user level daemon can gracefully exit if it is blocked
+	 * on the read semaphore.
+	 */
+	opened = false;
+	/*
+	 * Signal the semaphore as the device is
+	 * going away.
+	 */
+	misc_deregister(&hvnd_misc);
+}
+
+int hvnd_get_outgoing_rdma_addr(struct hvnd_dev *nd_dev,
+				struct hvnd_ucontext *uctx,
+				union nd_sockaddr_inet *og_addr)
+{
+	int ret;
+	/*
+	 * Query the host and select the first address.
+	 */
+	struct pkt_query_addr_list pkt;
+
+	/* KYS: Avoid zeroing everything */
+	memset(&pkt, 0, sizeof(pkt));
+
+	hvnd_init_hdr(&pkt.hdr,
+		      (sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1)),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_ADAPTER_QUERY_ADDRESS_LIST, 0, 0, 0);
+
+	pkt.ioctl.in.version = ND_VERSION_1;
+	pkt.ioctl.in.reserved = 0;
+	pkt.ioctl.in.handle = uctx->adaptor_hdl;
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr,
+				  sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		return ret;
+
+	/*
+	 * Copy the address out.
+	 */
+
+	memcpy(og_addr, &pkt.ioctl.out[0], sizeof(*og_addr));
+	return 0;
+
+}
+
+static struct rdma_addr_client self;
+
+struct resolve_cb_context {
+	struct rdma_dev_addr *addr;
+	struct completion comp;
+};
+
+void hvnd_addr_init(void)
+{
+	rdma_addr_register_client(&self);
+	hvnd_dev_init();
+	return;
+}
+
+void hvnd_addr_deinit(void)
+{
+	rdma_addr_unregister_client(&self);
+	hvnd_dev_deinit();
+	return;
+}
+
+static void resolve_cb(int status, struct sockaddr *src_addr,
+	     struct rdma_dev_addr *addr, void *context)
+{
+	memcpy(((struct resolve_cb_context *)context)->addr, addr, sizeof(struct
+				rdma_dev_addr));
+	complete(&((struct resolve_cb_context *)context)->comp);
+}
+
+int hvnd_get_neigh_mac_addr(struct sockaddr *local,
+			    struct sockaddr *remote, char *mac_addr)
+{
+	struct rdma_dev_addr dev_addr;
+	struct resolve_cb_context ctx;
+	int ret;
+
+	memset(&dev_addr, 0, sizeof(dev_addr));
+	ctx.addr = &dev_addr;
+	init_completion(&ctx.comp);
+
+	ret = rdma_resolve_ip(&self, local, remote, &dev_addr,
+			      1000, resolve_cb, &ctx);
+
+	if (ret) {
+		hvnd_error("rdma_resolve_ip failed ret=%d\n", ret);
+		return ret;
+	}
+
+	wait_for_completion(&ctx.comp);
+	memcpy(mac_addr, dev_addr.dst_dev_addr, ETH_ALEN);
+	return ret;
+}
diff --git a/drivers/infiniband/hw/vmbus-nd/mx_abi.h b/drivers/infiniband/hw/vmbus-nd/mx_abi.h
new file mode 100644
index 0000000..ea3792e
--- /dev/null
+++ b/drivers/infiniband/hw/vmbus-nd/mx_abi.h
@@ -0,0 +1,232 @@
+/*
+ * Copyright (c) 2005 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005 Cisco Systems.  All rights reserved.
+ * Copyright (c) 2005 PathScale, Inc.  All rights reserved.
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
+ *
+ * KYS: made some modifications.
+ */
+
+#ifndef MX_ABI_H
+#define MX_ABI_H
+
+
+
+/*
+ * Make sure that all structs defined in this file remain laid out so
+ * that they pack the same way on 32-bit and 64-bit architectures (to
+ * avoid incompatibility between 32-bit userspace and 64-bit kernels).
+ * Specifically:
+ *  - Do not use pointer types -- pass pointers in UINT64 instead.
+ *  - Make sure that any structure larger than 4 bytes is padded to a
+ *    multiple of 8 bytes.  Otherwise the structure size will be
+ *    different between 32-bit and 64-bit architectures.
+ */
+
+enum ibv_get_context_mappings {
+	IBV_GET_CONTEXT_UAR,
+	IBV_GET_CONTEXT_BF,
+	IBV_GET_CONTEXT_MAPPING_MAX
+};
+
+struct ibv_get_context_req {
+
+	union nd_mapping mappings[IBV_GET_CONTEXT_MAPPING_MAX];
+};
+
+struct ibv_get_context_resp {
+
+	/* mmap UAR and BF */
+	struct nd_mapping_result  mapping_results[IBV_GET_CONTEXT_MAPPING_MAX];
+
+	/* mmap Blue Flame */
+	int bf_buf_size;
+	int bf_offset;
+
+	/* mlx4_query_device result */
+	int max_qp_wr;
+	int max_sge;
+	int max_cqe;
+
+	/* general parameters */
+	u32 cqe_size;
+	u32 vend_id;
+	u16 dev_id;
+	u16 bf_reg_size;
+	u16 bf_regs_per_page;
+	u16 reserved1;
+
+	/* ibv_cmd_get_context result  */
+	u32 qp_tab_size;
+
+	u32 reserved2;
+};
+
+struct ibv_alloc_pd_resp {
+	u64 pd_handle;
+	u32 pdn;
+	u32 reserved;
+};
+
+struct ibv_reg_mr {
+	u64 start;
+	u64 length;
+	u64 hca_va;
+	u32 access_flags;
+	u32 pdn;
+	u64 pd_handle;
+};
+
+struct ibv_reg_mr_resp {
+	u64 mr_handle;
+	u32 lkey;
+	u32 rkey;
+};
+
+
+enum mlx4_ib_create_cq_mapping {
+	MLX4_IB_CREATE_CQ_BUF,
+	MLX4_IB_CREATE_CQ_DB,
+	MLX4_IB_CREATE_CQ_ARM_SN,   /* Windows specific */
+	MLX4_IB_CREATE_CQ_MAPPING_MAX
+};
+
+#define MLX4_CQ_FLAGS_ARM_IN_KERNEL     1
+
+struct ibv_create_cq {
+	union nd_mapping mappings[MLX4_IB_CREATE_CQ_MAPPING_MAX];
+	u32  flags;
+};
+
+struct ibv_create_cq_resp {
+	struct nd_mapping_result mapping_results[MLX4_IB_CREATE_CQ_MAPPING_MAX];
+	u32  cqn;
+	u32  cqe;
+};
+
+enum mlx4_ib_create_srq_mappings {
+	MLX4_IB_CREATE_SRQ_BUF,
+	MLX4_IB_CREATE_SRQ_DB,
+	MLX4_IB_CREATE_SRQ_MAPPINGS_MAX
+};
+
+struct ibv_create_srq {
+	union nd_mapping mappings[MLX4_IB_CREATE_SRQ_MAPPINGS_MAX];
+};
+
+struct ibv_create_srq_resp {
+	struct nd_mapping_result mapping_results[MLX4_IB_CREATE_SRQ_MAPPINGS_MAX];
+};
+
+enum mlx4_ib_create_qp_mappings {
+	MLX4_IB_CREATE_QP_BUF,
+	MLX4_IB_CREATE_QP_DB,
+	MLX4_IB_CREATE_QP_MAPPINGS_MAX
+};
+
+struct ibv_create_qp {
+	union nd_mapping mappings[MLX4_IB_CREATE_QP_MAPPINGS_MAX];
+	u8	log_sq_bb_count;
+	u8	log_sq_stride;
+	u8	sq_no_prefetch;
+	u8	reserved;
+};
+
+struct ibv_create_qp_resp {
+	struct nd_mapping_result mapping_results[MLX4_IB_CREATE_QP_MAPPINGS_MAX];
+	/* struct ib_uverbs_create_qp_resp */
+	u64 qp_handle;
+	u32 qpn;
+	u32 max_send_wr;
+	u32 max_recv_wr;
+	u32 max_send_sge;
+	u32 max_recv_sge;
+	u32 max_inline_data;
+};
+
+enum ibv_qp_attr_mask {
+	IBV_QP_STATE			= 1 << 0,
+	IBV_QP_CUR_STATE		= 1 << 1,
+	IBV_QP_EN_SQD_ASYNC_NOTIFY	= 1 << 2,
+	IBV_QP_ACCESS_FLAGS		= 1 << 3,
+	IBV_QP_PKEY_INDEX		= 1 << 4,
+	IBV_QP_PORT			= 1 << 5,
+	IBV_QP_QKEY			= 1 << 6,
+	IBV_QP_AV			= 1 << 7,
+	IBV_QP_PATH_MTU			= 1 << 8,
+	IBV_QP_TIMEOUT			= 1 << 9,
+	IBV_QP_RETRY_CNT		= 1 << 10,
+	IBV_QP_RNR_RETRY		= 1 << 11,
+	IBV_QP_RQ_PSN			= 1 << 12,
+	IBV_QP_MAX_QP_RD_ATOMIC		= 1 << 13,
+	IBV_QP_ALT_PATH			= 1 << 14,
+	IBV_QP_MIN_RNR_TIMER		= 1 << 15,
+	IBV_QP_SQ_PSN			= 1 << 16,
+	IBV_QP_MAX_DEST_RD_ATOMIC	= 1 << 17,
+	IBV_QP_PATH_MIG_STATE		= 1 << 18,
+	IBV_QP_CAP			= 1 << 19,
+	IBV_QP_DEST_QPN			= 1 << 20
+};
+
+enum ibv_qp_state {
+	IBV_QPS_RESET,
+	IBV_QPS_INIT,
+	IBV_QPS_RTR,
+	IBV_QPS_RTS,
+	IBV_QPS_SQD,
+	IBV_QPS_SQE,
+	IBV_QPS_ERR
+};
+
+
+struct ibv_modify_qp_resp {
+	enum ibv_qp_attr_mask attr_mask;
+	u8 qp_state;
+	u8 reserved[3];
+};
+
+struct ibv_create_ah_resp {
+	u64 start;
+};
+
+/*
+ * Some mlx4 specific kernel definitions. Perhaps could be in
+ * separate file.
+ */
+
+struct mlx4_ib_user_db_page {
+	struct list_head        list;
+	struct ib_umem         *umem;
+	unsigned long           user_virt;
+	int                     refcnt;
+};
+
+
+#endif /* MX_ABI_H */
diff --git a/drivers/infiniband/hw/vmbus-nd/provider.c b/drivers/infiniband/hw/vmbus-nd/provider.c
new file mode 100644
index 0000000..d046b77e
--- /dev/null
+++ b/drivers/infiniband/hw/vmbus-nd/provider.c
@@ -0,0 +1,2844 @@
+/*
+ * Copyright (c) 2014, Microsoft Corporation.
+ *
+ * Author:
+ *   K. Y. Srinivasan <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * Bug fixes/enhancements: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/device.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/ethtool.h>
+#include <linux/rtnetlink.h>
+#include <linux/inetdevice.h>
+#include <linux/io.h>
+#include <linux/hyperv.h>
+#include <linux/completion.h>
+#include <rdma/iw_cm.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_umem.h>
+#include <rdma/ib_user_verbs.h>
+#include <rdma/rdma_cm.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include "vmbus_rdma.h"
+
+/*
+ * We are emulating mlx4. XXXKYS: May have to FIX.
+ */
+#include "../mlx4/user.h"
+
+int hvnd_log_level = HVND_ERROR;
+module_param(hvnd_log_level, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(hvnd_log_level,
+	"Logging level, "
+	"0 - Error (default), "
+	"1 - Warning, "
+	"2 - Info, "
+	"3 - Debug.");
+
+static int disable_cq_notify = 1;
+module_param(disable_cq_notify, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(disable_cq_notify,
+	"Disable CQ notification, "
+	"0 - Enable, "
+	"1 - Disable (default).");
+
+enum {
+	MLX4_USER_DEV_CAP_64B_CQE = 1L << 0
+};
+
+#define HVND_NODE_DESC "vmbus-RDMA"
+
+#undef MLX4_IB_UVERBS_ABI_VERSION
+#define MLX4_IB_UVERBS_ABI_VERSION             4
+
+struct mlx4_wqe_data_seg {
+	__be32                  byte_count;
+	__be32                  lkey;
+	__be64                  addr;
+};
+
+/* return value:
+	true: ep is running
+	false: ep is stopped
+*/
+bool ep_add_work_pending(struct hvnd_ep_obj *ep_object)
+{
+	bool ret = true;
+	atomic_inc(&ep_object->nr_requests_pending);
+	if (ep_object->stopping) {
+		if (atomic_dec_and_test(&ep_object->nr_requests_pending))
+			wake_up(&ep_object->wait_pending);
+		ret = false;
+	}
+	return ret;
+}
+
+void ep_del_work_pending(struct hvnd_ep_obj *ep_object)
+{
+	if (atomic_dec_and_test(&ep_object->nr_requests_pending))
+		wake_up(&ep_object->wait_pending);
+
+	if (atomic_read(&ep_object->nr_requests_pending) < 0) {
+		hvnd_error("ep_object->nr_requests_pending=%d type=%d cm_state=%d\n",
+			    atomic_read(&ep_object->nr_requests_pending),
+			    ep_object->type, ep_object->cm_state);
+		dump_stack();
+	}
+}
+
+void ep_stop(struct hvnd_ep_obj *ep_object)
+{
+	if (!ep_object->stopping) {
+		ep_object->stopping = true;
+		hvnd_cancel_io(ep_object);
+	}
+
+	if (atomic_read(&ep_object->nr_requests_pending) < 0) {
+		hvnd_error("IO canceled, ep_object->nr_requests_pending=%d type=%d cm_state=%d\n",
+			    atomic_read(&ep_object->nr_requests_pending),
+			    ep_object->type, ep_object->cm_state);
+		dump_stack();
+	}
+
+	wait_event(ep_object->wait_pending,
+		   !atomic_read(&ep_object->nr_requests_pending));
+}
+
+static int vmbus_dma_map_sg(struct device *dev, struct scatterlist *sgl,
+			    int nents, enum dma_data_direction direction,
+			    unsigned long attrs)
+{
+	struct scatterlist *sg;
+	u64 addr;
+	int i;
+	int ret = nents;
+
+	BUG_ON(!valid_dma_direction(direction));
+
+	for_each_sg(sgl, sg, nents, i) {
+		addr = (u64) page_address(sg_page(sg));
+		/* TODO: handle highmem pages */
+		if (!addr) {
+			ret = 0;
+			break;
+		}
+		sg->dma_address = addr + sg->offset;
+		sg->dma_length = sg->length;
+	}
+	return ret;
+}
+
+static void vmbus_dma_unmap_sg(struct device *dev,
+			 struct scatterlist *sg, int nents,
+			 enum dma_data_direction direction,
+			 unsigned long attrs)
+{
+	BUG_ON(!valid_dma_direction(direction));
+}
+
+
+static struct dma_map_ops vmbus_dma_ops = {
+	.map_sg = vmbus_dma_map_sg,
+	.unmap_sg = vmbus_dma_unmap_sg,
+};
+
+static int hvnd_get_incoming_connections(struct hvnd_ep_obj *listener,
+					 struct hvnd_dev *nd_dev,
+					 struct hvnd_ucontext *uctx);
+
+static struct hvnd_ep_obj *hvnd_setup_ep(struct iw_cm_id *cm_id, int ep_type,
+					struct hvnd_dev *nd_dev,
+					struct hvnd_ucontext *uctx);
+
+static void hvnd_deinit_ep(struct hvnd_ep_obj *ep)
+{
+	put_irp_handle(ep->nd_dev, ep->local_irp);
+}
+
+static void hvnd_destroy_ep(struct hvnd_ep_obj *ep)
+{
+	hvnd_debug("canceling work for ep %p\n", ep);
+	cancel_work_sync(&ep->wrk.work);
+	hvnd_deinit_ep(ep);
+	kfree(ep);
+}
+
+
+#define	UC(b)	(((int)b)&0xff)
+char *debug_inet_ntoa(struct in_addr in, char *b)
+{
+	register char *p;
+
+	p = (char *)&in;
+	(void)snprintf(b, 20,
+	    "%d.%d.%d.%d", UC(p[0]), UC(p[1]), UC(p[2]), UC(p[3]));
+	return b;
+}
+
+
+static int hvnd_init_ep(struct hvnd_ep_obj *ep_object,
+			 struct iw_cm_id *cm_id, int ep_type,
+			 struct hvnd_dev *nd_dev,
+			 struct hvnd_ucontext *uctx)
+{
+	int ret;
+
+	ep_object->type = ep_type;
+	ep_object->cm_id = cm_id;
+	ep_object->nd_dev = nd_dev;
+	ep_object->uctx = uctx;
+
+	ep_object->parent = NULL;
+
+	ep_object->wrk.callback_arg = ep_object;
+	INIT_WORK(&ep_object->wrk.work, hvnd_process_events);
+	INIT_LIST_HEAD(&ep_object->incoming_pkt_list);
+	spin_lock_init(&ep_object->incoming_pkt_list_lock);
+
+/*
+	spin_lock_init(&ep_object->ep_lk);
+	ep_object->to_be_destroyed = false;
+	ep_object->io_outstanding = false;
+	ep_object->stopped = false;
+*/
+	ep_object->stopping = false;
+	atomic_set(&ep_object->nr_requests_pending, 0);
+	init_waitqueue_head(&ep_object->wait_pending);
+
+	ret = get_irp_handle(nd_dev, &ep_object->local_irp, (void *)ep_object);
+
+	if (ret) {
+		hvnd_error("get_irp_handle() failed: err: %d\n", ret);
+		return ret;
+	}
+	return 0;
+
+}
+
+static int set_rq_size(struct hvnd_dev *dev, struct ib_qp_cap *cap,
+			struct hvnd_qp *qp)
+{
+
+	/* HW requires >= 1 RQ entry with >= 1 gather entry */
+	if (!cap->max_recv_wr || !cap->max_recv_sge)
+		return -EINVAL;
+
+	qp->rq_wqe_cnt   = roundup_pow_of_two(max(1U, cap->max_recv_wr));
+	qp->rq_max_gs    = roundup_pow_of_two(max(1U, cap->max_recv_sge));
+	qp->rq_wqe_shift = ilog2(qp->rq_max_gs *
+			   sizeof(struct mlx4_wqe_data_seg));
+
+
+	return 0;
+}
+
+static int set_user_sq_size(struct hvnd_dev *dev,
+			    struct hvnd_qp *qp,
+			    struct mlx4_ib_create_qp *ucmd)
+{
+	qp->sq_wqe_cnt   = 1 << ucmd->log_sq_bb_count;
+	qp->sq_wqe_shift = ucmd->log_sq_stride;
+
+	qp->buf_size = (qp->rq_wqe_cnt << qp->rq_wqe_shift) +
+			(qp->sq_wqe_cnt << qp->sq_wqe_shift);
+
+	return 0;
+}
+
+static int hvnd_db_map_user(struct hvnd_ucontext *uctx, unsigned long virt,
+			    struct ib_umem **db_umem)
+{
+	struct mlx4_ib_user_db_page *page;
+	int err = 0;
+
+	mutex_lock(&uctx->db_page_mutex);
+
+	list_for_each_entry(page, &uctx->db_page_list, list)
+		if (page->user_virt == (virt & PAGE_MASK))
+			goto found;
+
+	page = kmalloc(sizeof *page, GFP_KERNEL);
+	if (!page) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	page->user_virt = (virt & PAGE_MASK);
+	page->refcnt    = 0;
+	page->umem      = ib_umem_get(&uctx->ibucontext, virt & PAGE_MASK,
+				      PAGE_SIZE, 0, 0);
+	if (IS_ERR(page->umem)) {
+		hvnd_error("ib_umem_get failure\n");
+		err = PTR_ERR(page->umem);
+		kfree(page);
+		goto out;
+	}
+
+	list_add(&page->list, &uctx->db_page_list);
+
+found:
+	++page->refcnt;
+out:
+	mutex_unlock(&uctx->db_page_mutex);
+	if (!err)
+		*db_umem = page->umem;
+
+	return err;
+}
+
+static void hvnd_db_unmap_user(struct hvnd_ucontext *uctx, u64 db_addr)
+{
+	struct mlx4_ib_user_db_page *page;
+
+	mutex_lock(&uctx->db_page_mutex);
+	list_for_each_entry(page, &uctx->db_page_list, list)
+		if (page->user_virt == (db_addr & PAGE_MASK))
+			goto found;
+
+found:
+	if (!--page->refcnt) {
+		list_del(&page->list);
+		ib_umem_release(page->umem);
+		kfree(page);
+	}
+
+	mutex_unlock(&uctx->db_page_mutex);
+}
+
+
+static void debug_check(const char *func, int line)
+{
+	hvnd_debug("func is: %s; line is %d\n", func, line);
+
+	if (in_interrupt()) {
+		hvnd_error("In interrupt func is: %s; line is %d\n",
+			   func, line);
+		return;
+	}
+}
+
+static struct ib_ah *hvnd_ah_create(struct ib_pd *pd,
+				    struct ib_ah_attr *ah_attr)
+{
+	debug_check(__func__, __LINE__);
+	return ERR_PTR(-ENOSYS);
+}
+
+static int hvnd_ah_destroy(struct ib_ah *ah)
+{
+	debug_check(__func__, __LINE__);
+	return -ENOSYS;
+}
+
+static int hvnd_multicast_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
+{
+	debug_check(__func__, __LINE__);
+	return -ENOSYS;
+}
+
+static int hvnd_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
+{
+	debug_check(__func__, __LINE__);
+	return -ENOSYS;
+}
+
+void hvnd_acquire_uctx_ref(struct hvnd_ucontext *uctx)
+{
+	atomic_inc(&uctx->refcnt);
+}
+
+void hvnd_drop_uctx_ref(struct hvnd_dev *nd_dev,
+			struct hvnd_ucontext *uctx)
+{
+	if (atomic_dec_and_test(&uctx->refcnt)) {
+		hvnd_debug("uctx ref cnt dropped it is %d\n",
+			   atomic_read(&uctx->refcnt));
+		hvnd_debug("About to close adaptor\n");
+		hvnd_close_adaptor(nd_dev, uctx);
+	} else {
+		hvnd_debug("uctx ref cnt dropped it is %d\n",
+			   atomic_read(&uctx->refcnt));
+	}
+}
+
+
+static int hvnd_dealloc_ucontext(struct ib_ucontext *context)
+{
+	struct hvnd_dev *nd_dev;
+	struct hvnd_ucontext *uctx;
+
+	uctx = to_nd_context(context);
+	nd_dev = to_nd_dev(context->device);
+
+	hvnd_debug("calling %s\n", __func__);
+
+	hvnd_drop_uctx_ref(nd_dev, uctx);
+
+	return 0;
+}
+
+static struct ib_ucontext *hvnd_alloc_ucontext(struct ib_device *ibdev,
+					       struct ib_udata *udata)
+{
+	struct hvnd_dev *nd_dev = to_nd_dev(ibdev);
+	struct hvnd_ucontext *uctx;
+	struct mlx4_ib_alloc_ucontext_resp resp;
+	int ret;
+
+	if (!nd_dev->ib_active) {
+		hvnd_error("ib device is not active, try again\n");
+		return ERR_PTR(-EAGAIN);
+	}
+
+	uctx = get_uctx(nd_dev, current_pid());
+	if (uctx) {
+		/* it is already opened, just increase its reference count */
+		hvnd_acquire_uctx_ref(uctx);
+	} else {
+
+		/*
+		 * The Windows host expects the following to be done:
+		 * 1. Successfully send struct ndv_pkt_hdr_create_1
+		 * 2. INIT PROVIDER
+		 * 3. Open Adapter
+		 * Before we can complete this call.
+		 */
+
+		uctx = kzalloc(sizeof(struct hvnd_ucontext), GFP_KERNEL);
+		if (!uctx)
+			return ERR_PTR(-ENOMEM);
+
+		atomic_set(&uctx->refcnt, 1);
+		INIT_LIST_HEAD(&uctx->db_page_list);
+		mutex_init(&uctx->db_page_mutex);
+
+		/*
+		 * Stash away the context with the calling PID.
+		 */
+		ret = insert_handle(nd_dev, &nd_dev->uctxidr,
+				    uctx, current_pid());
+		if (ret) {
+			hvnd_error("Uctx ID insertion failed; ret is %d\n",
+				   ret);
+			goto err1;
+		}
+
+		hvnd_debug("Opening adaptor pid is %d\n", current_pid());
+
+		ret = hvnd_open_adaptor(nd_dev, uctx);
+		if (ret) {
+			hvnd_error("hvnd_open_adaptor failed ret=%d\n", ret);
+			goto err1;
+		}
+
+	}
+
+	/*
+	 * Copy the response out.
+	 */
+
+	resp.dev_caps         =	MLX4_USER_DEV_CAP_64B_CQE;
+	resp.qp_tab_size      =
+		uctx->o_adap_pkt.mappings.ctx_output.qp_tab_size;
+	resp.bf_reg_size      =
+		uctx->o_adap_pkt.mappings.ctx_output.bf_reg_size;
+	resp.bf_regs_per_page =
+		uctx->o_adap_pkt.mappings.ctx_output.bf_regs_per_page;
+	resp.cqe_size         =	uctx->o_adap_pkt.mappings.ctx_output.cqe_size;
+
+	ret = ib_copy_to_udata(udata, &resp, sizeof(resp));
+	if (ret) {
+		hvnd_error("ib_copy_to_udata failed ret=%d\n", ret);
+		goto err1;
+	}
+
+	return &uctx->ibucontext;
+
+err1:
+	kfree(uctx);
+	return ERR_PTR(ret);
+}
+
+static int hvnd_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
+{
+	struct hvnd_ucontext *uctx = to_nd_context(context);
+
+	if (vma->vm_end - vma->vm_start != PAGE_SIZE) {
+		hvnd_error("vma not a page size, actual size=%lu\n",
+			   vma->vm_end - vma->vm_start);
+		return -EINVAL;
+	}
+
+	if (vma->vm_pgoff == 0) {
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+		if (io_remap_pfn_range(vma, vma->vm_start,
+					(uctx->uar_base >> PAGE_SHIFT),
+					PAGE_SIZE, vma->vm_page_prot)) {
+			hvnd_error("io_remap_pfn_range failure\n");
+			return -EAGAIN;
+		}
+	} else if (vma->vm_pgoff == 1 && uctx->bf_buf_size != 0) {
+		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+
+		if (io_remap_pfn_range(vma, vma->vm_start,
+					(uctx->uar_base >> PAGE_SHIFT) + 1,
+					PAGE_SIZE, vma->vm_page_prot)) {
+			hvnd_error("io_remap_pfn_range failure\n");
+			return -EAGAIN;
+		}
+	} else {
+		hvnd_error("check code\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int hvnd_deallocate_pd(struct ib_pd *pd)
+{
+
+	struct hvnd_ucontext *uctx;
+	struct hvnd_dev *nd_dev;
+	struct hvnd_ib_pd *hvnd_pd;
+	struct ib_ucontext *ibuctx = pd->uobject->context;
+
+	hvnd_pd = to_nd_pd(pd);
+	nd_dev = to_nd_dev(pd->device);
+	uctx = to_nd_context(ibuctx);
+
+	hvnd_free_handle(nd_dev, uctx, hvnd_pd->handle,
+			 IOCTL_ND_PD_FREE);
+
+	hvnd_drop_uctx_ref(nd_dev, uctx);
+	return 0;
+}
+
+static struct ib_pd *hvnd_allocate_pd(struct ib_device *ibdev,
+				      struct ib_ucontext *context,
+				      struct ib_udata *udata)
+{
+	struct hvnd_ucontext *uctx;
+	struct hvnd_dev *nd_dev;
+	int ret;
+	struct hvnd_ib_pd *hvnd_pd;
+
+
+	hvnd_pd = kzalloc(sizeof(struct hvnd_ib_pd), GFP_KERNEL);
+
+	if (!hvnd_pd)
+		return ERR_PTR(-ENOMEM);
+
+	uctx = to_nd_context(context);
+	nd_dev = to_nd_dev(ibdev);
+
+	ret = hvnd_create_pd(uctx, nd_dev, hvnd_pd);
+	if (ret) {
+		hvnd_error("hvnd_create_pd failure ret=%d\n", ret);
+		goto error_cr_pd;
+	}
+
+	if (context) {
+		if (ib_copy_to_udata(udata, &hvnd_pd->pdn, sizeof(__u32))) {
+			hvnd_error("ib_copy_to_udata failure\n");
+			ret = -EFAULT;
+			goto error_fault;
+		}
+	}
+
+	hvnd_acquire_uctx_ref(uctx);
+	return &hvnd_pd->ibpd;
+
+error_fault:
+	hvnd_free_handle(nd_dev, uctx, hvnd_pd->handle,
+			 IOCTL_ND_PD_FREE);
+
+error_cr_pd:
+	kfree(hvnd_pd);
+	return ERR_PTR(ret);
+}
+
+static int hvnd_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
+			   u16 *pkey)
+{
+	debug_check(__func__, __LINE__);
+	*pkey = 0;
+	return 0;
+}
+
+static int hvnd_query_gid(struct ib_device *ibdev, u8 port, int index,
+			  union ib_gid *gid)
+{
+	char *ip_addr, *mac_addr;
+	int ret;
+
+	debug_check(__func__, __LINE__);
+	ret = hvnd_get_ip_addr(&ip_addr, &mac_addr);
+	if (ret)
+		return ret;
+
+	memset(&(gid->raw[0]), 0, sizeof(gid->raw));
+	memcpy(&(gid->raw[0]), mac_addr, 6);
+	return 0;
+}
+
+static int hvnd_query_device(struct ib_device *ibdev,
+			     struct ib_device_attr *props,
+			     struct ib_udata *udata)
+{
+	struct hvnd_dev *nd_dev = to_nd_dev(ibdev);
+	struct adapter_info_v2 *adap_info;
+
+	if (!nd_dev->query_pkt_set) {
+		hvnd_error("query packet not received yet\n");
+		return -ENODATA;
+	}
+
+	adap_info = &nd_dev->query_pkt.ioctl.ad_info;
+
+	memset(props, 0, sizeof *props);
+
+	/*
+	 * Copy the relevant properties out.
+	 */
+	props->fw_ver = 0;
+	props->device_cap_flags    = 0;
+#ifdef NOTYET
+	props->device_cap_flags |= IB_DEVICE_BAD_PKEY_CNTR;
+	props->device_cap_flags |= IB_DEVICE_BAD_QKEY_CNTR;
+	props->device_cap_flags |= IB_DEVICE_XRC;
+#endif
+
+	props->vendor_id           =  0x15b3;
+	props->vendor_part_id      = adap_info->device_id;
+
+	props->max_mr_size         = ~0ull;
+	props->page_size_cap       = PAGE_SIZE;
+	props->max_qp              = 16384;
+	props->max_qp_wr           = min(adap_info->max_recv_q_depth,
+					 adap_info->max_initiator_q_depth);
+
+	props->max_sge             = min(adap_info->max_initiator_sge,
+					 adap_info->max_recv_sge);
+	props->max_cq              = 0x1FFFF;
+	props->max_cqe             = adap_info->max_completion_q_depth;
+	props->max_mr              = 16384;
+	props->max_pd              = 16384;
+
+	props->max_qp_rd_atom      = adap_info->max_inbound_read_limit;
+	props->max_qp_init_rd_atom = adap_info->max_outbound_read_limit;
+	props->max_res_rd_atom     = props->max_qp_rd_atom * props->max_qp;
+	props->max_srq             = 16384;
+	props->max_srq_wr          = adap_info->max_recv_q_depth;
+	props->max_srq_sge         = adap_info->max_recv_sge;
+
+	return 0;
+}
+
+static int hvnd_query_port(struct ib_device *ibdev, u8 port,
+			   struct ib_port_attr *props)
+{
+	memset(props, 0, sizeof(struct ib_port_attr));
+
+	props->max_mtu = IB_MTU_4096;
+	props->active_mtu = IB_MTU_4096;
+
+	/*
+	 * KYS: TBD need to base this on netdev.
+	 */
+	props->state = IB_PORT_ACTIVE;
+
+	props->port_cap_flags = IB_PORT_CM_SUP;
+
+	props->gid_tbl_len = 1;
+	props->pkey_tbl_len = 1;
+	props->active_width = 1;
+	props->active_speed = IB_SPEED_DDR; /* KYS: check */
+	props->max_msg_sz = -1;
+
+	return 0;
+}
+
+static enum rdma_link_layer
+hvnd_get_link_layer(struct ib_device *device, u8 port)
+{
+	return IB_LINK_LAYER_ETHERNET;
+}
+
+static ssize_t hvnd_show_rev(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	return 0;
+}
+
+static ssize_t hvnd_show_fw_ver(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	return 0;
+}
+
+static ssize_t hvnd_show_hca(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	return 0;
+}
+
+static ssize_t hvnd_show_board(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	return 0;
+}
+
+
+static struct ib_qp *hvnd_ib_create_qp(struct ib_pd *pd,
+				       struct ib_qp_init_attr *attrs,
+				       struct ib_udata *udata)
+{
+	struct hvnd_ucontext *uctx;
+	struct hvnd_dev *nd_dev;
+	struct mlx4_ib_create_qp ucmd;
+	struct hvnd_qp *qp;
+	int ret = 0;
+	struct hvnd_ib_pd *hvnd_pd = to_nd_pd(pd);
+	struct hvnd_cq *send_cq = to_nd_cq(attrs->send_cq);
+	struct hvnd_cq *recv_cq = to_nd_cq(attrs->recv_cq);
+
+	uctx = get_uctx_from_pd(pd);
+	nd_dev = to_nd_dev(pd->device);
+
+	if (attrs->qp_type != IB_QPT_RC) {
+		hvnd_error("attrs->qp_type=%d not IB_QPT_RC\n", attrs->qp_type);
+		return ERR_PTR(-EINVAL);
+	}
+
+	qp = kzalloc(sizeof *qp, GFP_KERNEL);
+	if (!qp) {
+		ret = -ENOMEM;
+		goto err_done;
+	}
+
+	qp->uctx = uctx;
+
+	if (ib_copy_from_udata(&ucmd, udata, sizeof ucmd)) {
+		hvnd_error("ib_copy_from_udata failed\n");
+		ret = -EFAULT;
+		goto err_ucpy;
+	}
+
+	qp->qp_buf = (void *)ucmd.buf_addr;
+	qp->db_addr = (void *)ucmd.db_addr;
+	qp->log_sq_bb_count = ucmd.log_sq_bb_count;
+	qp->log_sq_stride = ucmd.log_sq_stride;
+	qp->sq_no_prefetch = ucmd.sq_no_prefetch;
+	qp->port = attrs->port_num;
+
+	init_waitqueue_head(&qp->wait);
+	atomic_set(&qp->refcnt, 1);
+
+
+	qp->recv_cq = recv_cq;
+	qp->send_cq = send_cq;
+	qp->nd_dev = nd_dev;
+
+	qp->receive_cq_handle = recv_cq->cq_handle;
+	qp->initiator_cq_handle = send_cq->cq_handle;
+	qp->pd_handle = hvnd_pd->handle;
+	qp->cq_notify = false;
+
+	qp->ibqp.qp_num = attrs->qp_type == IB_QPT_SMI ? 0 : 1;
+
+	qp->max_inline_data = attrs->cap.max_inline_data;
+
+	qp->initiator_q_depth = attrs->cap.max_send_wr;
+	qp->initiator_request_sge = attrs->cap.max_send_sge;
+
+
+	qp->receive_q_depth = attrs->cap.max_recv_wr;
+	qp->receive_request_sge = attrs->cap.max_recv_sge;
+
+	set_rq_size(nd_dev, &attrs->cap, qp);
+
+	set_user_sq_size(nd_dev, qp, &ucmd);
+
+	qp->umem = ib_umem_get(&uctx->ibucontext, ucmd.buf_addr,
+				qp->buf_size, 0, 0);
+	if (IS_ERR(qp->umem)) {
+		ret = PTR_ERR(qp->umem);
+		hvnd_error("ib_umem_get failed ret=%d\n", ret);
+		goto err_ucpy;
+	}
+
+	ret =  hvnd_db_map_user(uctx, ucmd.db_addr, &qp->db_umem);
+
+	if (ret) {
+		hvnd_error("hvnd_db_map_user failed ret=%d\n", ret);
+		goto err_db_map;
+	}
+
+	ret = hvnd_create_qp(nd_dev, uctx, qp);
+
+	if (ret) {
+		hvnd_error("hvnd_create_qp failed ret=%d\n", ret);
+		goto err_qp;
+	}
+
+	hvnd_acquire_uctx_ref(uctx);
+
+	qp->ibqp.qp_num = qp->qpn;
+	qp->ibqp.qp_type = IB_QPT_RC;
+
+
+	return &qp->ibqp;
+
+err_qp:
+	hvnd_db_unmap_user(uctx, ucmd.db_addr);
+
+err_db_map:
+	ib_umem_release(qp->umem);
+
+err_ucpy:
+	kfree(qp);
+err_done:
+	return ERR_PTR(ret);
+}
+
+static int hvnd_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+			     int attr_mask, struct ib_udata *udata)
+{
+	struct hvnd_qp *qp = to_nd_qp(ibqp);
+	struct hvnd_dev *nd_dev = to_nd_dev(ibqp->device);
+	enum ib_qp_state cur_state, new_state;
+	int ret = 0;
+
+
+	cur_state = attr_mask & IB_QP_CUR_STATE ?
+		    attr->cur_qp_state : qp->qp_state;
+	new_state = attr_mask & IB_QP_STATE ? attr->qp_state : cur_state;
+
+	if (attr != NULL) {
+		hvnd_debug("qp->qp_state is %d new state is %d\n",
+			   qp->qp_state, new_state);
+		hvnd_debug("current qp state is %d\n", cur_state);
+		if (attr_mask & IB_QP_STATE) {
+			/* Ensure the state is valid */
+			if (attr->qp_state < 0 ||
+			    attr->qp_state > IB_QPS_ERR) {
+				hvnd_error("incorrect qp state attr->qp_state=%d\n",
+					   attr->qp_state);
+				return -EINVAL;
+			}
+
+			if (qp->qp_state != new_state) {
+				qp->qp_state = new_state;
+				/*
+				 * The only state transition supported is
+				 * the transition to
+				 * error state.
+				 */
+				switch (new_state) {
+				case IB_QPS_ERR:
+				case IB_QPS_SQD:
+					ret = hvnd_flush_qp(nd_dev,
+							    qp->uctx, qp);
+
+					if (ret)
+						hvnd_error("hvnd_flush_qp failed ret=%d\n", ret);
+
+					/*
+					 * Immediately notify the upper layer
+					 * on disconnection
+					 */
+					if (!ret && qp->connector)
+						hvnd_process_notify_disconnect(
+							qp->connector,
+							STATUS_SUCCESS);
+
+					return ret;
+
+				default:
+					break;
+				}
+			}
+		}
+	}
+	return 0;
+}
+
+
+static int hvnd_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+		     int attr_mask, struct ib_qp_init_attr *init_attr)
+{
+	struct hvnd_qp *qp = to_nd_qp(ibqp);
+
+	memset(attr, 0, sizeof *attr);
+	memset(init_attr, 0, sizeof *init_attr);
+
+	attr->qp_state = qp->qp_state;
+
+	init_attr->cap.max_send_wr = qp->max_send_wr;
+	init_attr->cap.max_recv_wr = qp->max_recv_wr;
+
+	init_attr->cap.max_send_sge = qp->max_send_sge;
+	init_attr->cap.max_recv_sge = qp->max_recv_sge;
+	init_attr->cap.max_inline_data = qp->max_inline_data;
+
+	init_attr->sq_sig_type = IB_SIGNAL_ALL_WR;
+
+	return 0;
+}
+
+static void hvnd_refuse_connection(struct hvnd_ep_obj *connector, int status);
+static int hvnd_destroy_qp(struct ib_qp *ib_qp)
+{
+	int ret;
+	struct hvnd_qp *qp = to_nd_qp(ib_qp);
+	struct hvnd_dev *nd_dev = to_nd_dev(ib_qp->device);
+	u64 jiffies;
+
+	if (!qp->connector) {
+		hvnd_warn("error: connector is NULL; skip destroying connector\n");
+		goto free_qp;
+	}
+
+	/*
+	 * Should we flush the qp first on ctrl-C? , no
+	 * need to disconnect on abrupt shutdown?
+	 */
+
+	if (qp->qp_state != IB_QPS_ERR && qp->qp_state != IB_QPS_SQD) {
+		hvnd_warn("qp_state=%d, doing abrupt disconnect\n",
+			  qp->qp_state);
+		hvnd_flush_qp(nd_dev, qp->uctx, qp);
+
+		ep_stop(qp->connector);
+
+		/* now no pending activity is possible on the connector */
+
+		switch (qp->connector->cm_state) {
+
+		case hvnd_cm_idle:
+		case hvnd_cm_connect_reply_refused:
+		case hvnd_cm_connect_request_sent:
+		case hvnd_cm_close_sent:
+			hvnd_warn("cm_state = %d not doing anything\n",
+				  qp->connector->cm_state);
+			break;
+
+		case hvnd_cm_connect_received:
+			hvnd_warn("cm_state = %d refusing pending connection request\n", qp->connector->cm_state);
+			hvnd_refuse_connection(qp->connector, -ECONNREFUSED);
+			break;
+
+		case hvnd_cm_connect_reply_sent:
+		case hvnd_cm_established_sent:
+		case hvnd_cm_accept_sent:
+			hvnd_warn("cm_state = %d notifying disconnect on existing connection\n", qp->connector->cm_state);
+			hvnd_process_notify_disconnect(qp->connector,
+						       STATUS_CANCELLED);
+			break;
+
+		default:
+			hvnd_error("unknown cm_state = %d\n",
+				   qp->connector->cm_state);
+
+		}
+		goto free_connector;
+	} else {
+		hvnd_debug("qp_state=%d, doing normal disconnect\n",
+			   qp->qp_state);
+	}
+
+	if (!ep_add_work_pending(qp->connector))
+		goto free_connector;
+
+	init_completion(&qp->connector->disconnect_event);
+
+	/*
+	 * First issue a disconnect on the connector.
+	 */
+
+	hvnd_debug("calling hvnd_connector_disconnect\n");
+	ret = hvnd_connector_disconnect(nd_dev, qp->uctx,
+					qp->connector->ep_handle,
+					qp->connector);
+	if (ret) {
+		ep_del_work_pending(qp->connector);
+		hvnd_error("disconnect: retval is %d\n", ret);
+		ep_stop(qp->connector);
+		goto free_connector;
+	}
+	/*
+	 * Now wait for the disconnect.
+	 */
+	jiffies = get_jiffies_64();
+	wait_for_completion(&qp->connector->disconnect_event);
+	hvnd_debug("Completed disconnect connector=%p jiffies=%llu\n",
+		   qp->connector, get_jiffies_64() - jiffies);
+
+	/*
+	 * Now free up the connector and drop the reference on uctx.
+	 */
+
+	ep_stop(qp->connector);
+
+free_connector:
+	hvnd_debug("destroying connector handle: %p\n",
+		   (void *) qp->connector->ep_handle);
+	hvnd_free_handle(nd_dev, qp->uctx,
+			 qp->connector->ep_handle,
+			 IOCTL_ND_CONNECTOR_FREE);
+
+	hvnd_drop_uctx_ref(nd_dev, qp->uctx);
+	hvnd_destroy_ep(qp->connector);
+	qp->connector = NULL;
+free_qp:
+	atomic_dec(&qp->refcnt);
+	hvnd_debug("Waiting for the ref cnt to go to 0\n");
+
+	wait_event(qp->wait, !atomic_read(&qp->refcnt));
+
+	hvnd_debug("About to destroy qp\n");
+	hvnd_db_unmap_user(qp->uctx, (u64)qp->db_addr);
+	ib_umem_release(qp->umem);
+
+	hvnd_debug("About to free qp\n");
+	ret = hvnd_free_qp(nd_dev, qp->uctx, qp);
+
+	if (ret == 0) {
+		hvnd_drop_uctx_ref(nd_dev, qp->uctx);
+		kfree(qp);
+	} else {
+		hvnd_error("free qp failed: ret is %d\n", ret);
+	}
+
+	return ret;
+}
+
+static struct ib_cq *hvnd_ib_create_cq(struct ib_device *ibdev,
+				    const struct ib_cq_init_attr *attr,
+				    struct ib_ucontext *ib_context,
+				    struct ib_udata *udata)
+{
+	struct hvnd_ucontext *uctx;
+	struct hvnd_dev *nd_dev;
+	struct mlx4_ib_create_cq ucmd;
+	struct hvnd_cq *cq;
+	int ret = 0;
+	int entries = attr->cqe;
+
+	uctx = to_nd_context(ib_context);
+	nd_dev = to_nd_dev(ibdev);
+
+	if (entries < 1 || entries > uctx->max_cqe) {
+		hvnd_error("incorrct entries=%d\n", entries);
+		ret = -EINVAL;
+		goto err_done;
+	}
+
+	cq = kzalloc(sizeof *cq, GFP_KERNEL);
+	if (!cq) {
+		ret = -ENOMEM;
+		goto err_done;
+	}
+
+	entries      = roundup_pow_of_two(entries + 1);
+	cq->ibcq.cqe = entries - 1;
+	cq->entries = entries;
+	cq->uctx = uctx;
+
+	if (ib_copy_from_udata(&ucmd, udata, sizeof ucmd)) {
+		hvnd_error("ib_copy_from_udata failed\n");
+		ret = -EFAULT;
+		goto err_ucpy;
+	}
+
+	cq->cq_buf = (void *)ucmd.buf_addr;
+	cq->db_addr = (void *)ucmd.db_addr;
+	cq->arm_sn = 0;
+
+	/*
+	 * Initialize the IRP state. Need to have a separate irp state
+	 * for CQ; for now share it with Listener/connector.
+	 */
+	ret = hvnd_init_ep(&cq->ep_object, NULL, ND_CQ, nd_dev, uctx);
+
+	if (ret) {
+		hvnd_error("hvnd_init_ep failed ret=%d\n", ret);
+		goto  err_ucpy;
+	}
+
+	cq->ep_object.cq = cq;
+	cq->monitor = true;
+
+	cq->umem = ib_umem_get(ib_context, ucmd.buf_addr,
+				(entries * uctx->cqe_size),
+				IB_ACCESS_LOCAL_WRITE, 1);
+	if (IS_ERR(cq->umem)) {
+		ret = IS_ERR(cq->umem);
+		hvnd_error("ib_umem_get failed ret=%d\n", ret);
+		goto err_ucpy;
+	}
+
+	ret =  hvnd_db_map_user(uctx, ucmd.db_addr, &cq->db_umem);
+
+	if (ret) {
+		hvnd_error("hvnd_db_map_user failed ret=%d\n", ret);
+		goto err_db_map;
+	}
+
+	ret = hvnd_create_cq(nd_dev, uctx, cq);
+
+	if (ret) {
+		hvnd_error("hvnd_create_cq failed ret=%d\n", ret);
+		goto err_cq;
+	}
+
+	cq->ep_object.ep_handle = cq->cq_handle;
+
+	if (ib_copy_to_udata(udata, &cq->cqn, sizeof(__u32))) {
+		hvnd_error("ib_copy_to_udata failed\n");
+		ret = -EFAULT;
+		goto err_ucpy_out;
+	}
+
+	if (!disable_cq_notify) {
+
+		if (!ep_add_work_pending(&cq->ep_object))
+			goto err_ucpy_out;
+
+		ret = hvnd_notify_cq(nd_dev, cq, ND_CQ_NOTIFY_ANY,
+			     (u64)&cq->ep_object);
+
+		if (ret) {
+			ep_del_work_pending(&cq->ep_object);
+			hvnd_error("hvnd_notify_cq failed ret=%d\n", ret);
+			goto err_ucpy_out;
+		}
+	}
+
+	hvnd_acquire_uctx_ref(uctx);
+
+	return &cq->ibcq;
+
+err_ucpy_out:
+	hvnd_destroy_cq(nd_dev, cq);
+
+err_cq:
+	hvnd_db_unmap_user(uctx, ucmd.db_addr);
+
+err_db_map:
+	ib_umem_release(cq->umem);
+
+err_ucpy:
+	kfree(cq);
+err_done:
+	return ERR_PTR(ret);
+}
+
+static struct ib_qp *hvnd_get_qp(struct ib_device *dev, int qpn)
+{
+	struct hvnd_dev *nd_dev;
+	struct hvnd_qp *qp = NULL;
+
+	nd_dev = to_nd_dev(dev);
+	qp = get_qpp(nd_dev, qpn);
+	return qp ? &qp->ibqp : NULL;
+}
+
+static int hvnd_ib_destroy_cq(struct ib_cq *ib_cq)
+{
+	struct hvnd_ucontext *uctx;
+	struct hvnd_dev *nd_dev;
+	struct hvnd_cq *cq;
+
+	cq = to_nd_cq(ib_cq);
+	uctx = cq->uctx;
+	nd_dev = to_nd_dev(uctx->ibucontext.device);
+
+	cq->monitor = false;
+
+	/* hvnd_cancel_io(&cq->ep_object); */
+	ep_stop(&cq->ep_object);
+
+	hvnd_deinit_ep(&cq->ep_object);
+
+	hvnd_db_unmap_user(uctx, (u64)cq->db_addr);
+	ib_umem_release(cq->umem);
+
+	hvnd_destroy_cq(nd_dev, cq);
+
+	hvnd_drop_uctx_ref(nd_dev, uctx);
+	kfree(cq);
+
+	return 0;
+}
+
+static int hvnd_resize_cq(struct ib_cq *cq, int cqe, struct ib_udata *udata)
+{
+	/*
+	 * NDDirect does not support resizing CQ.
+	 */
+	hvnd_info("check code\n");
+	return -ENOSYS;
+}
+
+static int hvnd_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
+{
+	hvnd_info("check code\n");
+	return 0;
+}
+
+static struct ib_mr *hvnd_get_dma_mr(struct ib_pd *pd, int acc)
+{
+	hvnd_info("check code\n");
+	return NULL;
+}
+
+
+static void debug_dump_umem(struct ib_umem *umem)
+{
+#ifdef HVND_MEM_DEBUG
+	struct ib_umem_chunk *chunk;
+	struct scatterlist *sg;
+	int len, j, entry;
+	int shift = ffs(umem->page_size) - 1;
+
+	hvnd_debug("umem=%p\n", umem);
+	hvnd_debug("context=%p length=%lu offset=%d page_size=%d writable=%d hugetlb=%d\n",
+		umem->context,
+		umem->length,
+		umem->offset,
+		umem->page_size,
+		umem->writable,
+		umem->hugetlb);
+
+	list_for_each_entry(chunk, &umem->chunk_list, list) {
+		hvnd_debug("chunk->nmap=%d\n", chunk->nmap);
+		for (j = 0; j < chunk->nmap; ++j) {
+			sg = &chunk->page_list[j];
+			hvnd_debug("sg_dma_len=%d sg_dma_address=%llx\n",
+				   sg_dma_len(sg), sg_dma_address(sg));
+			hvnd_debug("page_link=%lx offset=%u length=%u\n",
+				   sg->page_link, sg->offset, sg->length);
+			len = sg_dma_len(&chunk->page_list[j]) >> shift;
+			for_each_sg(&chunk->page_list[j], sg, len, entry) {
+				hvnd_debug("PFN=%lu\n",
+					   page_to_pfn(sg_page(sg)));
+			}
+		}
+	}
+#endif
+}
+
+
+static struct ib_mr *hvnd_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
+				      u64 virt, int acc, struct ib_udata *udata)
+{
+	int err = 0;
+	struct hvnd_ib_pd *hvndpd = to_nd_pd(pd);
+	struct hvnd_mr *mr;
+
+	mr = kmalloc(sizeof(*mr), GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+	mr->pd = hvndpd;
+
+	mr->umem = ib_umem_get(pd->uobject->context, start, length, acc, 0);
+	if (IS_ERR(mr->umem)) {
+		err = PTR_ERR(mr->umem);
+		hvnd_error("ib_umem_get failed ret=%d\n", err);
+		kfree(mr);
+		return ERR_PTR(err);
+	}
+
+	debug_dump_umem(mr->umem);
+
+	mr->start = start;
+	mr->length = length;
+	mr->virt = virt;
+	mr->acc = acc;
+
+	hvnd_debug("start=%llx length=%llx virt=%llx acc=%d\n",
+		   start, length, virt, acc);
+
+	/*
+	 * First create a memory region.
+	 */
+	err = hvnd_cr_mr(to_nd_dev(pd->device),
+			to_nd_context(pd->uobject->context), hvndpd->handle,
+			&mr->mr_handle);
+	if (err) {
+		hvnd_error("cr_mr failed; ret is %d\n", err);
+		goto err;
+	}
+
+	err =  hvnd_mr_register(to_nd_dev(pd->device),
+				to_nd_context(pd->uobject->context), mr);
+
+	if (err)
+		goto err0;
+
+	hvnd_acquire_uctx_ref(to_nd_context(pd->uobject->context));
+
+	return &mr->ibmr;
+
+err0:
+	hvnd_free_mr(to_nd_dev(pd->device),
+		to_nd_context(pd->uobject->context), mr->mr_handle);
+err:
+	ib_umem_release(mr->umem);
+	kfree(mr);
+	return ERR_PTR(err);
+}
+
+
+
+static int hvnd_dereg_mr(struct ib_mr *ib_mr)
+{
+	int ret;
+	struct hvnd_mr *mr = to_nd_mr(ib_mr);
+	struct hvnd_ucontext *uctx = to_nd_context(ib_mr->pd->uobject->context);
+	struct hvnd_dev *nd_dev = to_nd_dev(ib_mr->device);
+
+
+	hvnd_debug("dereg_mr entering\n");
+
+	ret = hvnd_deregister_mr(nd_dev, uctx, mr->mr_handle);
+
+	if (ret) {
+		hvnd_error("hvnd_deregister_mr() failed: %x\n", ret);
+		return ret;
+	}
+	/*
+	 * Now free up the memory region.
+	 */
+
+	ret = hvnd_free_mr(nd_dev, uctx, mr->mr_handle);
+	if (ret) {
+		hvnd_error("hvnd_free_mr() failed: %x\n", ret);
+		return ret;
+	}
+
+	ib_umem_release(mr->umem);
+
+	hvnd_drop_uctx_ref(nd_dev, uctx);
+	kfree(mr);
+
+	hvnd_debug("dereg_mr done\n");
+	return 0;
+}
+
+static struct ib_mw *hvnd_alloc_mw(struct ib_pd *pd, enum ib_mw_type type,
+				   struct ib_udata *udata)
+{
+	hvnd_info("check code\n");
+	return NULL;
+}
+
+static int hvnd_dealloc_mw(struct ib_mw *mw)
+{
+	debug_check(__func__, __LINE__);
+	return 0;
+}
+
+
+
+static int hvnd_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
+{
+	struct hvnd_ucontext *uctx;
+	struct hvnd_dev *nd_dev;
+	struct hvnd_cq *cq;
+
+	cq = to_nd_cq(ibcq);
+	uctx = cq->uctx;
+	nd_dev = to_nd_dev(uctx->ibucontext.device);
+
+
+	debug_check(__func__, __LINE__);
+
+	return 0;
+}
+
+static int hvnd_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
+			  struct ib_send_wr **bad_wr)
+{
+	debug_check(__func__, __LINE__);
+	return 0;
+}
+
+int hvnd_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
+		      struct ib_recv_wr **bad_wr)
+{
+	debug_check(__func__, __LINE__);
+	return 0;
+}
+
+static int hvnd_resolve_addr(struct sockaddr_in *laddr,
+			     struct sockaddr_in *raddr,
+			     struct if_physical_addr *phys_addrstruct)
+{
+	int ret;
+
+	phys_addrstruct->length = ETH_ALEN;
+	ret = hvnd_get_neigh_mac_addr((struct sockaddr *)laddr,
+					(struct sockaddr *)raddr,
+					phys_addrstruct->addr);
+
+	hvnd_debug("Dest MAC is %pM\n", phys_addrstruct->addr);
+	return ret;
+}
+
+static int hvnd_connect(struct iw_cm_id *cm_id,
+			struct iw_cm_conn_param *conn_param)
+{
+	int ret = 0;
+	struct hvnd_dev *nd_dev;
+	struct hvnd_ep_obj  *ep_object;
+	struct sockaddr_in *raddr = (struct sockaddr_in *)&cm_id->remote_addr;
+	struct sockaddr_in *laddr = (struct sockaddr_in *)&cm_id->local_addr;
+	struct hvnd_qp *qp;
+	struct if_physical_addr phys_addrstruct;
+	union nd_sockaddr_inet dest_addr;
+	u64 connector_handle;
+	union nd_sockaddr_inet addr;
+	char addr_buf[50];
+
+	if (cm_id->remote_addr.ss_family != AF_INET) {
+		hvnd_error("cm_id->remote_addr.ss_family=%d not AF_INET\n",
+			   cm_id->remote_addr.ss_family);
+		return -ENOSYS;
+	}
+
+	qp = get_qpp(to_nd_dev(cm_id->device), conn_param->qpn);
+
+	if (!qp) {
+		hvnd_error("failed to find qp conn_param->qpn=%d\n",
+			   conn_param->qpn);
+		return -EINVAL;
+	}
+
+	cm_id->provider_data = qp;
+	cm_id->add_ref(cm_id);
+	qp->cm_id = cm_id;
+
+	/*
+	 * Set the read/write limits.
+	 * Can we change the limits on a created QP? Luke?
+	 */
+	nd_dev = to_nd_dev(cm_id->device);
+	ep_object = hvnd_setup_ep(cm_id, ND_CONNECTOR, nd_dev, qp->uctx);
+	hvnd_debug("active connection: local irp is %d\n",
+		   ep_object->local_irp);
+	if (!ep_object) {
+		hvnd_error("hvnd_setup_ep failure\n");
+		ret = -ENOMEM;
+		goto err_limit;
+	}
+
+	ret = hvnd_cr_connector(nd_dev, qp->uctx,
+				&connector_handle);
+
+	if (ret) {
+		hvnd_error("hvnd_cr_connector failure ret=%d\n", ret);
+		goto err_cr_connector;
+	}
+
+	hvnd_acquire_uctx_ref(qp->uctx);
+	ep_object->ep_handle = connector_handle;
+	ep_object->incoming = false;
+	qp->connector = ep_object;
+
+	/*
+	 * Bind the local address to the connector.
+	 */
+	hvnd_debug("Connect local address is %s\n",
+		   debug_inet_ntoa(laddr->sin_addr, addr_buf));
+
+	memcpy(&addr.ipv4, laddr, sizeof(struct sockaddr_in));
+	hvnd_debug("CONNECT AF %d port %d addr %s\n",
+		   addr.ipv4.sin_family, addr.ipv4.sin_port,
+		   debug_inet_ntoa(addr.ipv4.sin_addr, addr_buf));
+
+	ret = hvnd_bind_connector(nd_dev, qp->uctx,
+				connector_handle,
+				&addr);
+
+	if (ret) {
+		hvnd_error("hvnd_bind_connector failed ret=%d\n", ret);
+		goto err_bind_connector;
+	}
+
+	ret = hvnd_resolve_addr(laddr, raddr, &phys_addrstruct);
+	if (ret) {
+		hvnd_error("hvnd_resolve_addr failed ret=%d\n", ret);
+		goto err_bind_connector;
+	}
+
+	memcpy(&dest_addr.ipv4, raddr, sizeof(struct sockaddr_in));
+
+
+
+	/*
+	 * Now attempt to connect.
+	 */
+
+	hvnd_debug("About to initiate connection\n");
+
+	if (!ep_add_work_pending(ep_object))
+		goto err_bind_connector;
+
+	ep_object->cm_state = hvnd_cm_connect_received;
+	ret = hvnd_connector_connect(nd_dev, qp->uctx,
+					ep_object->ep_handle,
+					conn_param->ird, conn_param->ord,
+					conn_param->private_data_len,
+					(u8 *)conn_param->private_data,
+					qp->qp_handle,
+					&phys_addrstruct, &dest_addr,
+					ep_object);
+
+	if (ret == 0) {
+		return 0;
+	} else {
+		ep_object->cm_state = hvnd_cm_idle;
+		ep_del_work_pending(ep_object);
+		hvnd_error("hvnd_connector_connect failed ret=%d\n", ret);
+	}
+
+err_bind_connector:
+	qp->connector = NULL;
+	hvnd_free_connector(nd_dev, qp->uctx,
+			    connector_handle);
+	hvnd_drop_uctx_ref(nd_dev, qp->uctx);
+
+err_cr_connector:
+	kfree(ep_object);
+
+err_limit:
+	cm_id->provider_data = NULL;
+	qp->cm_id = NULL;
+	cm_id->rem_ref(cm_id);
+	return ret;
+}
+
+static int hvnd_accept_cr(struct iw_cm_id *cm_id,
+			  struct iw_cm_conn_param *conn_param)
+{
+	int ret = 0;
+	struct hvnd_dev *nd_dev;
+	struct hvnd_qp *qp;
+	struct hvnd_ep_obj *connector;
+	enum ibv_qp_state new_qp_state;
+
+	hvnd_debug("Accepting connection - PASSIVE\n");
+	nd_dev = to_nd_dev(cm_id->device);
+	qp = get_qpp(to_nd_dev(cm_id->device), conn_param->qpn);
+
+	if (!qp) {
+		hvnd_error("get_qpp failed conn_param->qpn=%d\n",
+			   conn_param->qpn);
+		return -EINVAL;
+	}
+
+
+	connector = (struct hvnd_ep_obj *)cm_id->provider_data;
+	qp->connector = connector;
+	connector->cq = qp->recv_cq;
+
+	if (connector == NULL) {
+		hvnd_error("NULL connector!\n");
+		return -EINVAL;
+	}
+	hvnd_debug("connector's cm_id is %p caller cm_id=%p\n",
+		   connector->cm_id, cm_id);
+
+
+	/*
+	 * Setup state for the accepted connection.
+	 */
+	cm_id->add_ref(cm_id);
+	connector->cm_id = cm_id;
+	if (conn_param != NULL) {
+		connector->ord = conn_param->ord;
+		connector->ird = conn_param->ird;
+	}
+
+	if (!ep_add_work_pending(connector))
+		goto error;
+
+	init_completion(&connector->connector_accept_event);
+
+	ret = hvnd_connector_accept(nd_dev, qp->uctx, connector->ep_handle,
+				    qp->qp_handle, conn_param->ird,
+				    conn_param->ord,
+				    conn_param->private_data_len,
+				    conn_param->private_data,
+				    &new_qp_state, connector);
+
+	if (ret) {
+		ep_del_work_pending(connector);
+		hvnd_error("connector accept failed\n");
+		goto error;
+	}
+
+	wait_for_completion(&connector->connector_accept_event);
+	ret = connector->connector_accept_status;
+
+	if (ret) {
+		hvnd_error("connector_accept failed status=%x\n", ret);
+		ret = -EIO;
+		goto error;
+	}
+
+	hvnd_debug("Passive Connection Accepted; new qp state is %d\n",
+		   new_qp_state);
+	connector->cm_state = hvnd_cm_accept_sent;
+	return 0;
+
+error:
+	ep_stop(connector);
+	connector->cm_id = NULL;
+	connector->cm_state = hvnd_cm_idle;
+
+	qp->connector = NULL;
+	cm_id->rem_ref(cm_id);
+
+	return ret;
+}
+
+static int hvnd_reject_cr(struct iw_cm_id *cm_id, const void *pdata,
+			  u8 pdata_len)
+{
+	debug_check(__func__, __LINE__);
+	return 0;
+}
+
+void hvnd_process_disconnect(struct hvnd_ep_obj *ep_object, int status)
+{
+	struct iw_cm_event cm_event;
+
+	switch (status) {
+	case STATUS_SUCCESS:
+	case STATUS_CANCELLED:
+		break;
+
+	default:
+		hvnd_warn("disconnect complete failed: status:%d\n", status);
+	}
+
+
+	hvnd_debug("active disconnect processed\n");
+	memset(&cm_event, 0, sizeof(cm_event));
+
+	complete(&ep_object->disconnect_event);
+}
+
+
+void hvnd_process_notify_disconnect(struct hvnd_ep_obj *ep_object, int status)
+{
+	struct iw_cm_event cm_event;
+
+	/* make sure we only disconnect once */
+	if (atomic_xchg(&ep_object->disconnect_notified, 1))
+		return;
+
+	/*
+	 * Turn off CQ monitoring.
+	 */
+	if (ep_object->cq)
+		ep_object->cq->monitor = false;
+
+	switch (ep_object->cm_state) {
+	case hvnd_cm_connect_reply_sent:
+	case hvnd_cm_established_sent:
+	case hvnd_cm_accept_sent:
+		break;
+
+	default:
+		hvnd_error("unexpected cm_state=%d\n", ep_object->cm_state);
+		return;
+	}
+
+	switch (status) {
+	case STATUS_SUCCESS:
+	case STATUS_CANCELLED:
+	case STATUS_DISCONNECTED:
+		break;
+
+	default:
+		hvnd_warn("notify disconnect complete failed: status:%d\n",
+			  status);
+	}
+
+	hvnd_debug("passive disconnect notified\n");
+	memset(&cm_event, 0, sizeof(cm_event));
+
+	/*
+	 * Other end disconnected.
+	 * Connection has been disconnected;
+	 * notify the cm layer.
+	 */
+	cm_event.status = -ECONNRESET;
+	cm_event.event = IW_CM_EVENT_CLOSE;
+
+	if ((ep_object->cm_id) &&
+	    (ep_object->cm_id->event_handler)) {
+
+		ep_object->cm_id->event_handler(ep_object->cm_id, &cm_event);
+
+		ep_object->cm_id->rem_ref(ep_object->cm_id);
+		ep_object->cm_state = hvnd_cm_close_sent;
+	}
+}
+
+void hvnd_process_connector_accept(struct hvnd_ep_obj *ep_object, int status)
+{
+	struct iw_cm_event cm_event;
+	int ret;
+
+	/*
+	 * This is the problem area the return status may be
+	 * 1: 0xc00000b5 (3221225653) - {Device Timeout}.
+	 *    The specified I/O operation  was not completed
+	 *    before the time-out period expired.
+	 *
+	 * 2: NTSTATUS 0xc0000241 (3221226049) - The transport
+	 *    connection was aborted by the local system.
+	 *    if we do nothing here, iwcm will wait for
+	 *    IW_CM_EVENT_ESTABLISHED forever, and unable to clean shutdown
+	 *    need to fail the call eariler on accept
+	 */
+
+	ep_object->connector_accept_status = status;
+
+	if (status) {
+		hvnd_error("Connector accept failed; status is %x\n", status);
+		complete(&ep_object->connector_accept_event);
+		return;
+	}
+
+	memset(&cm_event, 0, sizeof(cm_event));
+	cm_event.event = IW_CM_EVENT_ESTABLISHED;
+	cm_event.ird = ep_object->ird;
+	cm_event.ord = ep_object->ord;
+	cm_event.provider_data = (void *)ep_object;
+
+	/*
+	 * We have successfully passively accepted the
+	 * incoming connection.
+	 */
+
+	hvnd_debug("Passive connection accepted!!\n");
+	if ((ep_object->cm_id) &&
+	    (ep_object->cm_id->event_handler)) {
+		ep_object->cm_id->event_handler(ep_object->cm_id, &cm_event);
+		ep_object->cm_state = hvnd_cm_established_sent;
+	}
+
+	complete(&ep_object->connector_accept_event);
+
+	/*
+	 * Request notification if the other end
+	 * were to disconnect.
+	 */
+	if (!ep_add_work_pending(ep_object))
+		return;
+
+	ret = hvnd_connector_notify_disconnect(ep_object->nd_dev,
+						   ep_object->uctx,
+						   ep_object->ep_handle,
+						   ep_object);
+
+	if (ret) {
+		ep_del_work_pending(ep_object);
+		hvnd_error("Connector notify disconnect failed; ret: %d\n",
+			   ret);
+	}
+}
+
+
+void hvnd_process_cq_event_pending(struct hvnd_ep_obj *ep_object,
+					 int status)
+{
+
+	struct ib_cq *ibcq;
+	struct hvnd_cq *cq;
+
+	cq = ep_object->cq;
+	ibcq = &ep_object->cq->ibcq;
+
+	if (!cq->monitor)
+		return;
+
+	/* call the previous CQ complete */
+	if (status == STATUS_PENDING && cq->upcall_pending &&
+	    ibcq->comp_handler) {
+		ibcq->comp_handler(ibcq, ibcq->cq_context);
+		cq->upcall_pending = false;
+		hvnd_debug("CQ comp_handler called arm_sn=%d\n", cq->arm_sn);
+	}
+
+	if (status != STATUS_PENDING && ibcq->comp_handler &&
+	    ibcq->cq_context) {
+		ibcq->comp_handler(ibcq, ibcq->cq_context);
+		hvnd_error("CQ comp_handler called status=%x\n", status);
+	}
+}
+
+void hvnd_process_cq_event_complete(struct hvnd_ep_obj *ep_object,
+					 int status)
+{
+	struct ib_cq *ibcq;
+	struct hvnd_cq *cq;
+	int ret;
+
+	cq = ep_object->cq;
+	ibcq = &ep_object->cq->ibcq;
+
+	/* call hte previous CQ complete */
+	if (cq->upcall_pending && ibcq->comp_handler) {
+		ibcq->comp_handler(ibcq, ibcq->cq_context);
+		cq->upcall_pending = false;
+		hvnd_debug("CQ comp_handler called arm_sn=%d\n", cq->arm_sn);
+	}
+
+	cq->upcall_pending = true;
+	if (!ep_add_work_pending(ep_object))
+		return;
+
+	ret = hvnd_notify_cq(ep_object->nd_dev,
+			ep_object->cq,
+			ND_CQ_NOTIFY_ANY,
+			(u64)ep_object);
+
+	if (ret) {
+		ep_del_work_pending(ep_object);
+		/*hvnd_manage_io_state(ep_object, true); */
+		hvnd_error("hvnd_notify_cq failed ret=%d\n", ret);
+	}
+
+	if ((status != 0) && (status != STATUS_CANCELLED)) {
+		if (ibcq->event_handler) {
+			struct ib_event event;
+			event.device = ibcq->device;
+			event.event = IB_EVENT_CQ_ERR;
+			event.element.cq = ibcq;
+			ibcq->event_handler(&event, ibcq->cq_context);
+
+			hvnd_warn("CQ event_handler called status=%x\n",
+				  status);
+		}
+	}
+}
+
+int init_cm_event(struct hvnd_ep_obj *ep_object, struct iw_cm_event *cm_event,
+		  int event)
+{
+	struct sockaddr_in *laddr = (struct sockaddr_in *)&cm_event->local_addr;
+	struct sockaddr_in *raddr =
+		(struct sockaddr_in *)&cm_event->remote_addr;
+	struct nd_read_limits rd_limits;
+	union nd_sockaddr_inet local_addr;
+	union nd_sockaddr_inet remote_addr;
+	int ret;
+
+	/*
+	 * Now get the local address.
+	 */
+	ret = hvnd_connector_get_local_addr(ep_object->nd_dev,
+					    ep_object->uctx,
+					    ep_object->ep_handle,
+					    &local_addr);
+
+	if (ret) {
+		hvnd_error("Connector get addr failed; ret: %d\n", ret);
+		return ret;
+	}
+	/*
+	 * Now get the remote address.
+	 */
+	ret = hvnd_connector_get_peer_addr(ep_object->nd_dev,
+					   ep_object->uctx,
+					   ep_object->ep_handle,
+					   &remote_addr);
+
+	if (ret) {
+		hvnd_error("Connector get peer addr failed; ret: %d\n", ret);
+		return ret;
+	}
+
+	/*
+	 * Get other connection parameters.
+	 */
+
+	ret = hvnd_connector_get_rd_limits(ep_object->nd_dev,
+					   ep_object->uctx,
+					   ep_object->ep_handle,
+					   &rd_limits);
+
+	if (ret) {
+		hvnd_error("Connector rd limits failed; ret: %d\n", ret);
+		return ret;
+	}
+
+	/*
+	 * XXXKYS: Luke: What about the length of the priv data?
+	 */
+	ret = hvnd_connector_get_priv_data(ep_object->nd_dev,
+					   ep_object->uctx,
+					   ep_object->ep_handle,
+					   ep_object->priv_data);
+
+	if (ret) {
+		hvnd_error("Connector get priv data failed; ret: %d\n", ret);
+		return ret;
+	}
+	/*
+	 * Initialize CM structure.
+	 */
+	laddr->sin_addr.s_addr = local_addr.ipv4.sin_addr.s_addr;
+	hvnd_debug("Local addr is %d\n", laddr->sin_addr.s_addr);
+	laddr->sin_port = local_addr.ipv4.sin_port;
+	laddr->sin_family = AF_INET;
+
+	raddr->sin_addr.s_addr = remote_addr.ipv4.sin_addr.s_addr;
+	hvnd_debug("Remote addr is %d\n", raddr->sin_addr.s_addr);
+	raddr->sin_port = remote_addr.ipv4.sin_port;
+	raddr->sin_family = AF_INET;
+
+	cm_event->private_data_len = MAX_PRIVATE_DATA_LEN;
+	cm_event->private_data = ep_object->priv_data;
+
+	cm_event->ird = rd_limits.inbound;
+	cm_event->ord = rd_limits.outbound;
+	cm_event->event = event;
+
+	ep_object->ird = cm_event->ird;
+	ep_object->ord = cm_event->ord;
+
+	return 0;
+}
+
+static void hvnd_refuse_connection(struct hvnd_ep_obj *connector, int status)
+{
+	struct iw_cm_event cm_event;
+
+	memset(&cm_event, 0, sizeof(cm_event));
+
+	cm_event.event = IW_CM_EVENT_CONNECT_REPLY;
+	cm_event.status = status;
+
+	hvnd_debug("returning status %d on connector %p\n", status, connector);
+
+	if (connector->cm_id && connector->cm_id->event_handler) {
+		connector->cm_id->event_handler(connector->cm_id, &cm_event);
+		connector->cm_id->rem_ref(connector->cm_id);
+		connector->cm_state = hvnd_cm_connect_reply_refused;
+	}
+}
+
+void hvnd_process_events(struct work_struct *work)
+{
+	struct hvnd_work *wrk;
+	struct nd_read_limits rd_limits;
+	struct hvnd_ep_obj *ep_object;
+	struct hvnd_ep_obj *parent;
+	struct iw_cm_event cm_event;
+	struct sockaddr_in *laddr = (struct sockaddr_in *)&cm_event.local_addr;
+	struct sockaddr_in *raddr = (struct sockaddr_in *)&cm_event.remote_addr;
+	struct ndv_packet_hdr_control_1 *ctrl_hdr;
+	union nd_sockaddr_inet local_addr;
+	union nd_sockaddr_inet remote_addr;
+	struct pkt_nd_get_connection_listener *connection_pkt;
+	struct iw_cm_id *cm_id = NULL;
+	int status;
+	int ioctl;
+	int ret;
+	char priv_data[MAX_PRIVATE_DATA_LEN];
+	enum ibv_qp_state new_qp_state;
+	struct incoming_pkt *incoming_pkt;
+	unsigned long flags;
+
+	memset(&cm_event, 0, sizeof(cm_event));
+	memset(&priv_data, 0, MAX_PRIVATE_DATA_LEN);
+
+
+	wrk = container_of(work, struct hvnd_work, work);
+
+	/*
+	 * Now call into the connection manager.
+	 */
+	ep_object = (struct hvnd_ep_obj *)wrk->callback_arg;
+	parent = ep_object->parent;
+
+process_next:
+	incoming_pkt = NULL;
+	spin_lock_irqsave(&ep_object->incoming_pkt_list_lock, flags);
+	if (!list_empty(&ep_object->incoming_pkt_list)) {
+		incoming_pkt = list_first_entry(&ep_object->incoming_pkt_list,
+						struct incoming_pkt,
+						list_entry);
+		list_del(&incoming_pkt->list_entry);
+	}
+	spin_unlock_irqrestore(&ep_object->incoming_pkt_list_lock, flags);
+	if (incoming_pkt == NULL)
+		return;
+
+	ctrl_hdr = (struct ndv_packet_hdr_control_1 *)incoming_pkt->pkt;
+	status = ctrl_hdr->io_status;
+	ioctl = ctrl_hdr->io_cntrl_code;
+
+	hvnd_debug("Process Events IOCTL is: %s; iostatus failure: %x in work queue\n",
+		   hvnd_get_op_name(ioctl), status);
+
+	if (status != 0) {
+		bool log_error = true;
+
+		if (ioctl == IOCTL_ND_CONNECTOR_NOTIFY_DISCONNECT &&
+		    status == STATUS_DISCONNECTED)
+			log_error = false;
+
+		if (log_error)
+			hvnd_warn("Process Events IOCTL is: %s; iostatus failure: %x\n",
+				  hvnd_get_op_name(ioctl), status);
+	}
+
+	cm_event.status = status;
+
+	switch (ep_object->type) {
+	case ND_CONNECTOR:
+		switch (ioctl) {
+		case IOCTL_ND_LISTENER_GET_CONNECTION_REQUEST:
+
+			if (ep_object->parent != NULL) {
+
+				/*
+				 * Do nothing with this connection request if
+				 * listener is stopping
+				 */
+				if (!ep_add_work_pending(ep_object->parent))
+					break;
+
+				cm_id = ep_object->parent->cm_id; /* Listener */
+			}
+
+			connection_pkt =
+			(struct pkt_nd_get_connection_listener *) ctrl_hdr;
+
+			if ((status == 0) || (status == STATUS_CANCELLED)) {
+				hvnd_get_incoming_connections(ep_object->parent,
+					ep_object->parent->nd_dev,
+					ep_object->uctx);
+			}
+
+			if (status)
+				goto get_connection_request_done;
+
+			/*
+			 * Now get the local address.
+			 */
+			ret = hvnd_connector_get_local_addr(ep_object->nd_dev,
+						     ep_object->uctx,
+						     ep_object->ep_handle,
+						     &local_addr);
+
+			if (ret) {
+				hvnd_error("Connector get addr failed; ret: %d\n",
+					   ret);
+				goto get_connection_request_done;
+			}
+			/*
+			 * Now get the remote address.
+			 */
+			ret = hvnd_connector_get_peer_addr(ep_object->nd_dev,
+						     ep_object->uctx,
+						     ep_object->ep_handle,
+						     &remote_addr);
+
+			if (ret) {
+				hvnd_error("Connector get peer addr failed; ret: %d\n",
+					   ret);
+				goto get_connection_request_done;
+			}
+			/*
+			 * Get other connection parameters.
+			 */
+
+			ret = hvnd_connector_get_rd_limits(ep_object->nd_dev,
+							   ep_object->uctx,
+							   ep_object->ep_handle,
+							   &rd_limits);
+
+			if (ret) {
+				hvnd_error("Connector rd limits failed; ret: %d\n",
+					   ret);
+				goto get_connection_request_done;
+			}
+
+			ret = hvnd_connector_get_priv_data(ep_object->nd_dev,
+							ep_object->uctx,
+							ep_object->ep_handle,
+							ep_object->priv_data);
+
+			if (ret) {
+				hvnd_error("Connector get priv data failed; ret: %d\n", ret);
+				goto get_connection_request_done;
+			}
+
+			cm_event.event = IW_CM_EVENT_CONNECT_REQUEST;
+			cm_event.provider_data = (void *)ep_object;
+
+			laddr->sin_addr.s_addr = local_addr.ipv4.sin_addr.s_addr;
+			hvnd_debug("Local addr is %d\n",
+				   laddr->sin_addr.s_addr);
+			laddr->sin_port = local_addr.ipv4.sin_port;
+			laddr->sin_family = AF_INET;
+
+			raddr->sin_addr.s_addr = remote_addr.ipv4.sin_addr.s_addr;
+			hvnd_debug("Remote addr is %d\n",
+				   raddr->sin_addr.s_addr);
+			raddr->sin_port = remote_addr.ipv4.sin_port;
+			raddr->sin_family = AF_INET;
+
+			/* KYS: LUke: is it always 148 bytes? */
+			cm_event.private_data_len = MAX_PRIVATE_DATA_LEN;
+			cm_event.private_data = ep_object->priv_data;
+
+			cm_event.ird = rd_limits.inbound;
+			cm_event.ord = rd_limits.outbound;
+
+			ep_object->ird = cm_event.ird;
+			ep_object->ord = cm_event.ord;
+
+
+			if ((cm_id != NULL) && cm_id->event_handler) {
+				cm_id->event_handler(cm_id, &cm_event);
+				ep_object->cm_state =
+					hvnd_cm_connect_request_sent;
+			}
+
+get_connection_request_done:
+			if (ep_object->parent != NULL)
+				ep_del_work_pending(ep_object->parent);
+
+			break;
+
+		case IOCTL_ND_CONNECTOR_CONNECT:
+
+			cm_event.event = IW_CM_EVENT_CONNECT_REPLY;
+			if (status == STATUS_TIMEOUT &&
+			    ep_object->connector_connect_retry < 3) {
+
+				if (!ep_add_work_pending(ep_object))
+					goto refuse_connection;
+
+				hvnd_warn("Connector connect timed out, reconnecting... retry count: %d\n",
+					  ep_object->connector_connect_retry);
+				ep_object->connector_connect_retry++;
+					ret = hvnd_send_ioctl_pkt(
+					ep_object->nd_dev,
+					&ep_object->connector_connect_pkt.hdr,
+					sizeof(ep_object->connector_connect_pkt),
+					(u64)&ep_object->connector_connect_pkt);
+
+				if (ret) {
+					hvnd_error("Connector on time out failed: %d\n", ret);
+					ep_del_work_pending(ep_object);
+					goto refuse_connection;
+				}
+				break;
+			}
+
+refuse_connection:
+			if (status) {
+				cm_event.status = -ECONNREFUSED;
+				if (status == STATUS_TIMEOUT)
+					cm_event.status = -ETIMEDOUT;
+
+				hvnd_refuse_connection(ep_object,
+						       cm_event.status);
+				break;
+			}
+
+			hvnd_debug("ACTIVE Connection ACCEPTED\n");
+			ret = init_cm_event(ep_object, &cm_event,
+					    IW_CM_EVENT_CONNECT_REPLY);
+			if (ret) {
+				hvnd_error("init_cm_event failed ret=%d\n",
+					   ret);
+				goto process_done;
+			}
+
+			ret = hvnd_connector_complete_connect(ep_object->nd_dev,
+						ep_object->uctx,
+						ep_object->ep_handle,
+						&new_qp_state);
+			if (ret) {
+				hvnd_error("connector_complete failed\n");
+				goto process_done;
+			}
+
+			cm_event.provider_data = (void *)ep_object;
+
+			if ((ep_object->cm_id) &&
+				(ep_object->cm_id->event_handler)) {
+				ep_object->cm_id->event_handler(
+					ep_object->cm_id, &cm_event);
+				ep_object->cm_state =
+					hvnd_cm_connect_reply_sent;
+			}
+			/*
+			 * Rquest notification if the other end
+			 * were to disconnect.
+			 */
+			if (!ep_add_work_pending(ep_object))
+				goto process_done;
+
+			ret = hvnd_connector_notify_disconnect(
+							   ep_object->nd_dev,
+							   ep_object->uctx,
+							   ep_object->ep_handle,
+							   ep_object);
+
+			if (ret) {
+				ep_del_work_pending(ep_object);
+				hvnd_error("Connector notify disconnect failed; ret: %d\n", ret);
+			}
+
+			break;
+
+		case IOCTL_ND_CONNECTOR_NOTIFY_DISCONNECT:
+			hvnd_process_notify_disconnect(ep_object, status);
+			break;
+
+
+		default:
+			hvnd_error("Unknown Connector IOCTL\n");
+			break;
+		}
+		break;
+	default:
+		hvnd_error("Unknown endpoint object\n");
+		break;
+	}
+process_done:
+	kfree(incoming_pkt);
+	ep_del_work_pending(ep_object);
+
+	goto process_next;
+}
+
+
+static struct hvnd_ep_obj *hvnd_setup_ep(struct iw_cm_id *cm_id, int ep_type,
+					struct hvnd_dev *nd_dev,
+					struct hvnd_ucontext *uctx)
+{
+	struct hvnd_ep_obj *ep_object;
+	int ret;
+
+	ep_object = kzalloc(sizeof(struct hvnd_ep_obj), GFP_KERNEL);
+
+	if (!ep_object)
+		return NULL;
+
+	ret = hvnd_init_ep(ep_object, cm_id, ep_type, nd_dev, uctx);
+
+	if (ret) {
+		hvnd_error("hvnd_init_ep failed ret=%d\n", ret);
+		kfree(ep_object);
+		return NULL;
+	}
+
+	return ep_object;
+}
+
+static int hvnd_get_incoming_connections(struct hvnd_ep_obj *listener,
+					 struct hvnd_dev *nd_dev,
+					 struct hvnd_ucontext *uctx)
+{
+	struct hvnd_ep_obj *connector;
+	u64 connector_handle;
+	int ret;
+
+	/*
+	 * First handle the protocol for
+	 * destruction - outstanding I/O.
+	 */
+
+	/*
+	 * Create a connector.
+	 */
+	connector = hvnd_setup_ep(listener->cm_id, ND_CONNECTOR, nd_dev, uctx);
+	if (!connector) {
+		hvnd_error("hvnd_setup_ep failed\n");
+		ret = -ENOMEM;
+		goto con_alloc_err;
+	}
+
+	ret = hvnd_cr_connector(nd_dev, uctx,
+				&connector_handle);
+	if (ret) {
+		hvnd_error("hvnd_cr_connector failed ret=%d\n", ret);
+		goto con_cr_err;
+	}
+
+	/*
+	 * Now get a connection if one is pending.
+	 */
+	connector->ep_handle = connector_handle;
+	connector->parent = listener;
+
+	if (!ep_add_work_pending(connector))
+		goto get_connection_err;
+
+	ret = hvnd_get_connection_listener(nd_dev, uctx,
+					listener->ep_handle,
+					connector_handle,
+					(u64)connector);
+
+	if (ret) {
+		hvnd_debug("listener_get_connection failed\n");
+		ep_del_work_pending(connector);
+		goto get_connection_err;
+	}
+
+	hvnd_acquire_uctx_ref(uctx);
+	listener->outstanding_handle = connector_handle;
+	listener->outstanding_ep = connector;
+	hvnd_debug("outstanding handle is %p\n", (void *)connector_handle);
+	return 0;
+
+get_connection_err:
+	hvnd_free_handle(nd_dev, uctx,
+			connector_handle,
+			IOCTL_ND_CONNECTOR_FREE);
+
+con_cr_err:
+	kfree(connector);
+con_alloc_err:
+	/*hvnd_manage_io_state(listener, true); */
+	return ret;
+}
+
+static int hvnd_create_listen(struct iw_cm_id *cm_id, int backlog)
+{
+	int ret = 0;
+	struct hvnd_dev *nd_dev;
+	struct hvnd_ucontext *uctx;
+	struct hvnd_ep_obj *ep_object;
+	union nd_sockaddr_inet addr;
+	union nd_sockaddr_inet local_addr;
+	u64 listener_handle;
+	struct sockaddr_in *laddr = (struct sockaddr_in *)&cm_id->local_addr;
+	union nd_sockaddr_inet og_addr;
+
+
+	nd_dev = to_nd_dev(cm_id->device);
+	uctx = get_uctx(nd_dev, current_pid());
+	hvnd_debug("uctx is %p; pid is %d\n", uctx, current_pid());
+
+	if (cm_id->local_addr.ss_family != AF_INET) {
+		hvnd_error("cm_id->local_addr.ss_family =%d not AF_INET\n",
+			   cm_id->local_addr.ss_family);
+		return -ENOSYS;
+	}
+
+	/*
+	 * If the local address is LOOPBACK or INADDR_ANY, get an an address
+	 * to bind the listener. For now, just get the first address
+	 * available.
+	 */
+
+	if (IN_LOOPBACK(ntohl(laddr->sin_addr.s_addr)) ||
+		(laddr->sin_addr.s_addr == INADDR_ANY)) {
+
+		hvnd_debug("need to get an address\n");
+		ret = hvnd_get_outgoing_rdma_addr(nd_dev, uctx, &og_addr);
+
+		if (ret) {
+			hvnd_error("failed to get the og address\n");
+			return ret;
+		}
+
+		laddr->sin_addr.s_addr = og_addr.ipv4.sin_addr.s_addr;
+	}
+
+	cm_id->add_ref(cm_id);
+
+	ep_object = hvnd_setup_ep(cm_id, ND_LISTENER, nd_dev, uctx);
+
+	if (!ep_object) {
+		hvnd_error("hvnd_setup_ep returned NULL\n");
+		goto alloc_err;
+	}
+
+	ret = hvnd_cr_listener(nd_dev, uctx,
+				&listener_handle);
+	if (ret) {
+		hvnd_error("hvnd_cr_listener failed ret=%d\n", ret);
+		goto cr_err;
+	}
+
+	ep_object->ep_handle = listener_handle;
+
+	cm_id->provider_data = ep_object;
+
+	/*
+	 * Now bind the listener.
+	 * IPV4 support only.
+	 */
+	memcpy(&addr.ipv4, laddr, sizeof(struct sockaddr_in));
+
+	ret = hvnd_bind_listener(nd_dev, uctx,
+				listener_handle,
+				&addr);
+	if (ret) {
+		hvnd_error("hvnd_bind_listener failed ret=%d\n", ret);
+		goto bind_err;
+	}
+
+	/*
+	 * Now get the local address.
+	 */
+	ret = hvnd_get_addr_listener(nd_dev, uctx,
+					listener_handle,
+					&local_addr);
+	if (ret) {
+		hvnd_error("hvnd_get_addr_listener failed ret=%d\n", ret);
+		goto bind_err;
+	}
+
+	/*
+	 * Now put the listener in the listen mode.
+	 */
+
+	ret = hvnd_listen_listener(nd_dev, uctx,
+				listener_handle,
+				backlog);
+
+	if (ret) {
+		hvnd_error("hvnd_listen_listener failed ret=%d\n", ret);
+		goto bind_err;
+	}
+
+
+	/*
+	 * Now get a pending connection if one is pending.
+	 */
+	ret = hvnd_get_incoming_connections(ep_object, nd_dev, uctx);
+	if (ret) {
+		hvnd_error("hvnd_get_incoming_connections failed ret=%d\n",
+			   ret);
+		goto bind_err;
+	}
+
+	hvnd_acquire_uctx_ref(uctx);
+	hvnd_debug("cm_id=%p\n", cm_id);
+	return 0;
+
+bind_err:
+	hvnd_free_handle(nd_dev, uctx,
+			listener_handle,
+			IOCTL_ND_LISTENER_FREE);
+cr_err:
+	kfree(ep_object);
+alloc_err:
+	cm_id->provider_data = NULL;
+	cm_id->rem_ref(cm_id);
+	return ret;
+}
+
+static int hvnd_destroy_listen(struct iw_cm_id *cm_id)
+{
+	struct hvnd_dev *nd_dev;
+	struct hvnd_ucontext *uctx;
+	struct hvnd_ep_obj *ep_object;
+
+	nd_dev = to_nd_dev(cm_id->device);
+
+	ep_object = (struct hvnd_ep_obj *)cm_id->provider_data;
+
+	hvnd_debug("uctx is %p\n", ep_object->uctx);
+	hvnd_debug("Destroying Listener cm_id=%p\n", cm_id);
+	uctx = ep_object->uctx;
+
+	/* make sure there is nothing in progress on this ep */
+	ep_stop(ep_object);
+
+	hvnd_free_handle(nd_dev, uctx,
+			ep_object->ep_handle,
+			IOCTL_ND_LISTENER_FREE);
+
+	/*
+	 * We may have an ouststanding connector for
+	 * incoming connection requests; clean it up.
+	 */
+
+	if (ep_object->outstanding_handle != 0) {
+
+		/* make sure there is nothing in progress on this ep */
+		ep_stop(ep_object->outstanding_ep);
+
+		hvnd_free_handle(nd_dev, uctx,
+				ep_object->outstanding_handle,
+				IOCTL_ND_CONNECTOR_FREE);
+
+
+		hvnd_drop_uctx_ref(nd_dev, uctx);
+		hvnd_destroy_ep(ep_object->outstanding_ep);
+	}
+
+	/*
+	 * Now everything should have stopped
+	 */
+
+	cm_id->rem_ref(cm_id);
+	hvnd_destroy_ep(ep_object);
+	cm_id->provider_data = NULL;
+	hvnd_drop_uctx_ref(nd_dev, uctx);
+
+	hvnd_debug("cm_id=%p\n", cm_id);
+	return 0;
+}
+
+static void hvnd_qp_add_ref(struct ib_qp *ibqp)
+{
+	struct hvnd_qp *qp = to_nd_qp(ibqp);
+	atomic_inc(&qp->refcnt);
+}
+
+void hvnd_qp_rem_ref(struct ib_qp *ibqp)
+{
+	struct hvnd_qp *qp = to_nd_qp(ibqp);
+	if (atomic_dec_and_test(&qp->refcnt))
+		wake_up(&qp->wait);
+}
+
+static DEVICE_ATTR(hw_rev, S_IRUGO, hvnd_show_rev, NULL);
+static DEVICE_ATTR(fw_ver, S_IRUGO, hvnd_show_fw_ver, NULL);
+static DEVICE_ATTR(hca_type, S_IRUGO, hvnd_show_hca, NULL);
+static DEVICE_ATTR(board_id, S_IRUGO, hvnd_show_board, NULL);
+
+static struct device_attribute *hvnd_class_attributes[] = {
+	&dev_attr_hw_rev,
+	&dev_attr_fw_ver,
+	&dev_attr_hca_type,
+	&dev_attr_board_id,
+};
+
+int hvnd_register_device(struct hvnd_dev *dev)
+{
+	int ret;
+	int i;
+	char *ip_addr, *mac_addr;
+
+	ret = hvnd_get_ip_addr(&ip_addr, &mac_addr);
+	if (ret) {
+		hvnd_error("hvnd_get_ip_addr failed ret=%d\n", ret);
+		return ret;
+	}
+
+	dev->ibdev.owner = THIS_MODULE;
+	dev->device_cap_flags = IB_DEVICE_LOCAL_DMA_LKEY | IB_DEVICE_MEM_WINDOW;
+	dev->ibdev.local_dma_lkey = 0;
+	dev->ibdev.uverbs_cmd_mask =
+	    (1ull << IB_USER_VERBS_CMD_GET_CONTEXT) |
+	    (1ull << IB_USER_VERBS_CMD_QUERY_DEVICE) |
+	    (1ull << IB_USER_VERBS_CMD_QUERY_PORT) |
+	    (1ull << IB_USER_VERBS_CMD_ALLOC_PD) |
+	    (1ull << IB_USER_VERBS_CMD_DEALLOC_PD) |
+	    (1ull << IB_USER_VERBS_CMD_REG_MR) |
+	    (1ull << IB_USER_VERBS_CMD_DEREG_MR) |
+	    (1ull << IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL) |
+	    (1ull << IB_USER_VERBS_CMD_CREATE_CQ) |
+	    (1ull << IB_USER_VERBS_CMD_DESTROY_CQ) |
+	    (1ull << IB_USER_VERBS_CMD_REQ_NOTIFY_CQ) |
+	    (1ull << IB_USER_VERBS_CMD_CREATE_QP) |
+	    (1ull << IB_USER_VERBS_CMD_MODIFY_QP) |
+	    (1ull << IB_USER_VERBS_CMD_QUERY_QP) |
+	    (1ull << IB_USER_VERBS_CMD_POLL_CQ) |
+	    (1ull << IB_USER_VERBS_CMD_DESTROY_QP) |
+	    (1ull << IB_USER_VERBS_CMD_POST_SEND) |
+	    (1ull << IB_USER_VERBS_CMD_POST_RECV);
+	dev->ibdev.node_type = RDMA_NODE_RNIC;
+	memcpy(dev->ibdev.node_desc, HVND_NODE_DESC, sizeof(HVND_NODE_DESC));
+	memcpy(&dev->ibdev.node_guid, mac_addr, 6);
+	dev->ibdev.phys_port_cnt = 1; /* dev->nports; */
+	dev->ibdev.num_comp_vectors = 1;
+	dev->ibdev.dma_device = &(dev->hvdev->device);
+	dev->ibdev.query_device = hvnd_query_device;
+	dev->ibdev.query_port = hvnd_query_port;
+	dev->ibdev.get_link_layer = hvnd_get_link_layer;
+	dev->ibdev.query_pkey = hvnd_query_pkey;
+	dev->ibdev.query_gid = hvnd_query_gid;
+	dev->ibdev.alloc_ucontext = hvnd_alloc_ucontext;
+	dev->ibdev.dealloc_ucontext = hvnd_dealloc_ucontext;
+	dev->ibdev.mmap = hvnd_mmap;
+	dev->ibdev.alloc_pd = hvnd_allocate_pd;
+	dev->ibdev.dealloc_pd = hvnd_deallocate_pd;
+	dev->ibdev.create_ah = hvnd_ah_create;
+	dev->ibdev.destroy_ah = hvnd_ah_destroy;
+	dev->ibdev.create_qp = hvnd_ib_create_qp;
+	dev->ibdev.modify_qp = hvnd_ib_modify_qp;
+	dev->ibdev.query_qp = hvnd_ib_query_qp;
+	dev->ibdev.destroy_qp = hvnd_destroy_qp;
+	dev->ibdev.create_cq = hvnd_ib_create_cq;
+	dev->ibdev.destroy_cq = hvnd_ib_destroy_cq;
+	dev->ibdev.resize_cq = hvnd_resize_cq;
+	dev->ibdev.poll_cq = hvnd_poll_cq;
+	dev->ibdev.get_dma_mr = hvnd_get_dma_mr;
+	dev->ibdev.reg_user_mr = hvnd_reg_user_mr;
+	dev->ibdev.dereg_mr = hvnd_dereg_mr;
+	dev->ibdev.alloc_mw = hvnd_alloc_mw;
+	dev->ibdev.dealloc_mw = hvnd_dealloc_mw;
+	dev->ibdev.attach_mcast = hvnd_multicast_attach;
+	dev->ibdev.detach_mcast = hvnd_multicast_detach;
+	dev->ibdev.req_notify_cq = hvnd_arm_cq;
+	dev->ibdev.post_send = hvnd_post_send;
+	dev->ibdev.post_recv = hvnd_post_receive;
+	dev->ibdev.uverbs_abi_ver = MLX4_IB_UVERBS_ABI_VERSION;
+
+	/* DMA ops for mapping all possible addresses */
+	dev->ibdev.dma_device->archdata.dma_ops = &vmbus_dma_ops;
+
+	dev->ibdev.iwcm = kmalloc(sizeof(struct iw_cm_verbs), GFP_KERNEL);
+	if (!dev->ibdev.iwcm)
+		return -ENOMEM;
+
+	dev->ibdev.iwcm->connect = hvnd_connect;
+	dev->ibdev.iwcm->accept = hvnd_accept_cr;
+	dev->ibdev.iwcm->reject = hvnd_reject_cr;
+	dev->ibdev.iwcm->create_listen = hvnd_create_listen;
+	dev->ibdev.iwcm->destroy_listen = hvnd_destroy_listen;
+	dev->ibdev.iwcm->add_ref = hvnd_qp_add_ref;
+	dev->ibdev.iwcm->rem_ref = hvnd_qp_rem_ref;
+	dev->ibdev.iwcm->get_qp = hvnd_get_qp;
+
+	strlcpy(dev->ibdev.name, "mlx4_%d", IB_DEVICE_NAME_MAX);
+	ret = ib_register_device(&dev->ibdev, NULL);
+	if (ret) {
+		hvnd_error("ib_register_device failed ret=%d\n", ret);
+		goto bail1;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(hvnd_class_attributes); ++i) {
+		ret = device_create_file(&dev->ibdev.dev,
+					 hvnd_class_attributes[i]);
+		if (ret) {
+			hvnd_error("device_create_file failed ret=%d\n", ret);
+			goto bail2;
+		}
+	}
+
+	dev->ib_active = true;
+
+	return 0;
+bail2:
+	ib_unregister_device(&dev->ibdev);
+bail1:
+	kfree(dev->ibdev.iwcm);
+	return ret;
+}
+
+void hvnd_unregister_device(struct hvnd_dev *dev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(hvnd_class_attributes); ++i)
+		device_remove_file(&dev->ibdev.dev,
+				   hvnd_class_attributes[i]);
+	ib_unregister_device(&dev->ibdev);
+	kfree(dev->ibdev.iwcm);
+	ib_dealloc_device((struct ib_device *)dev);
+	return;
+}
+
+static void hvnd_probe_delayed_work(struct work_struct *work)
+{
+	int ret;
+	struct hvnd_dev *nd_dev = container_of(work, struct hvnd_dev,
+					probe_delayed_work);
+
+	/*
+	* Bind the NIC.
+	*/
+	ret = hvnd_bind_nic(nd_dev, false);
+	if (ret) {
+		hvnd_error("hvnd_bind_nic failed ret=%d\n", ret);
+		goto err;
+	}
+
+	ret = hvnd_register_device(nd_dev);
+
+	if (ret == 0)
+		return;
+	else
+		hvnd_error("hvnd_register_device failed ret=%d\n", ret);
+
+/* roll back all allocated resources on error */
+err:
+	iounmap(nd_dev->mmio_virt);
+	release_resource(&nd_dev->mmio_resource);
+
+	vmbus_close(nd_dev->hvdev->channel);
+
+	ib_dealloc_device((struct ib_device *)nd_dev);
+}
+
+static int hvnd_probe(struct hv_device *dev,
+		      const struct hv_vmbus_device_id *dev_id)
+{
+	struct hvnd_dev *nd_dev;
+	int ret = 0;
+
+	hvnd_debug("hvnd starting\n");
+
+	nd_dev = (struct hvnd_dev *)ib_alloc_device(sizeof(struct hvnd_dev));
+	if (!nd_dev) {
+		ret = -ENOMEM;
+		goto err_out0;
+	}
+
+	nd_dev->hvdev = dev;
+	/*
+	 * We are going to masquerade as MLX4 device;
+	 * Set the vendor and device ID accordingly.
+	 */
+	dev->vendor_id = 0x15b3; /* Mellanox */
+	dev->device_id = 0x1003; /* Mellanox HCA */
+	INIT_LIST_HEAD(&nd_dev->listentry);
+	spin_lock_init(&nd_dev->uctxt_lk);
+	nd_dev->ib_active = false;
+
+	/*
+	 * Initialize the state for the id table.
+	 */
+	spin_lock_init(&nd_dev->id_lock);
+	idr_init(&nd_dev->cqidr);
+	idr_init(&nd_dev->qpidr);
+	idr_init(&nd_dev->mmidr);
+	idr_init(&nd_dev->irpidr);
+	idr_init(&nd_dev->uctxidr);
+
+	atomic_set(&nd_dev->open_cnt, 0);
+
+	sema_init(&nd_dev->query_pkt_sem, 1);
+
+	ret = vmbus_open(dev->channel, HVND_RING_SZ, HVND_RING_SZ, NULL, 0,
+			 hvnd_callback, dev);
+
+	if (ret) {
+		hvnd_error("vmbus_open failed ret=%d\n", ret);
+		goto err_out1;
+	}
+
+	hv_set_drvdata(dev, nd_dev);
+
+	ret = hvnd_negotiate_version(nd_dev);
+
+	if (ret) {
+		hvnd_error("hvnd_negotiate_version failed ret=%d\n", ret);
+		goto err_out2;
+	}
+
+	/*
+	 * Register resources with the host.
+	 */
+	ret = hvnd_init_resources(nd_dev);
+	if (ret) {
+		hvnd_error("hvnd_init_resources failed ret=%d\n", ret);
+		goto err_out2;
+	}
+
+	/*
+	 * We need to get IP/MAC address from the Azure
+	 * Linux agent to continue initialization
+	 */
+	INIT_WORK(&nd_dev->probe_delayed_work, hvnd_probe_delayed_work);
+	schedule_work(&nd_dev->probe_delayed_work);
+	return 0;
+
+err_out2:
+	vmbus_close(dev->channel);
+
+err_out1:
+	ib_dealloc_device((struct ib_device *)nd_dev);
+
+err_out0:
+	return ret;
+}
+
+static int hvnd_remove(struct hv_device *dev)
+{
+	struct hvnd_dev *nd_dev = hv_get_drvdata(dev);
+
+	hvnd_bind_nic(nd_dev, true);
+	vmbus_close(dev->channel);
+	iounmap(nd_dev->mmio_virt);
+	release_resource(&nd_dev->mmio_resource);
+	hvnd_unregister_device(nd_dev);
+	return 0;
+}
+
+static const struct hv_vmbus_device_id id_table[] = {
+	/* VMBUS RDMA class guid */
+	/* 8c2eaf3d-32a7-4b09-ab99-bd1f1c86b501 */
+	{ HV_ND_GUID, },
+	{ },
+};
+
+MODULE_DEVICE_TABLE(vmbus, id_table);
+
+static  struct hv_driver hvnd_drv = {
+	.name = "hv_guest_rdma",
+	.id_table = id_table,
+	.probe =  hvnd_probe,
+	.remove =  hvnd_remove,
+};
+
+
+static int __init init_hvnd_drv(void)
+{
+
+	pr_info("Registered HyperV networkDirect Driver\n");
+	hvnd_addr_init();
+	return vmbus_driver_register(&hvnd_drv);
+
+}
+
+static void exit_hvnd_drv(void)
+{
+	pr_info("De-Registered HyperV networkDirect Driver\n");
+	hvnd_addr_deinit();
+	vmbus_driver_unregister(&hvnd_drv);
+}
+
+
+module_init(init_hvnd_drv);
+module_exit(exit_hvnd_drv);
+
+MODULE_DESCRIPTION("Hyper-V NetworkDirect Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/infiniband/hw/vmbus-nd/vmbus_rdma.c b/drivers/infiniband/hw/vmbus-nd/vmbus_rdma.c
new file mode 100644
index 0000000..c622e39
--- /dev/null
+++ b/drivers/infiniband/hw/vmbus-nd/vmbus_rdma.c
@@ -0,0 +1,3086 @@
+/*
+ * Copyright (c) 2014, Microsoft Corporation.
+ *
+ * Author:
+ *   K. Y. Srinivasan <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * Bug fixes/enhancements: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
+ */
+
+#include <linux/completion.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/hyperv.h>
+#include <linux/efi.h>
+#include <linux/slab.h>
+#include <linux/cred.h>
+#include <linux/uidgid.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <linux/scatterlist.h>
+#include <rdma/ib_umem.h>
+#include <rdma/ib_user_verbs.h>
+#include <asm-generic/delay.h>
+
+#include "vmbus_rdma.h"
+
+/*
+ * We only have a single rdma device on the host;
+ * have a single receive buffer.
+ */
+
+
+static char hvnd_recv_buffer[PAGE_SIZE * 4];
+
+static atomic_t irp_local_hdl;
+
+char *hvnd_get_op_name(int ioctl)
+{
+	switch (ioctl) {
+	case IOCTL_ND_PROVIDER_INIT:
+		return "IOCTL_ND_PROVIDER_INIT\n";
+	case IOCTL_ND_PROVIDER_BIND_FILE:
+		return "IOCTL_ND_PROVIDER_BIND_FILE\n";
+	case IOCTL_ND_ADAPTER_OPEN:
+		return "IOCTL_ND_ADAPTER_OPEN\n";
+
+	case IOCTL_ND_ADAPTER_CLOSE:
+		return "IOCTL_ND_ADAPTER_CLOSE\n";
+
+	case IOCTL_ND_ADAPTER_QUERY:
+		return "IOCTL_ND_ADAPTER_QUERY\n";
+
+	case IOCTL_ND_PD_CREATE:
+		return "IOCTL_ND_PD_CREATE\n";
+
+	case IOCTL_ND_PD_FREE:
+		return "IOCTL_ND_PD_FREE\n";
+
+	case IOCTL_ND_CQ_CREATE:
+		return "IOCTL_ND_CQ_CREATE\n";
+
+	case IOCTL_ND_CQ_FREE:
+		return "IOCTL_ND_CQ_FREE\n";
+	case IOCTL_ND_CQ_CANCEL_IO:
+		return "IOCTL_ND_CQ_CANCEL_IO\n";
+	case IOCTL_ND_CQ_GET_AFFINITY:
+		return "IOCTL_ND_CQ_GET_AAFINITY\n";
+	case IOCTL_ND_CQ_MODIFY:
+		return "IOCTL_ND_CQ_MODIFY\n";
+
+	case IOCTL_ND_CQ_NOTIFY:
+		return "IOCTL_ND_CQ_NOTIFY\n";
+
+
+	case IOCTL_ND_LISTENER_CREATE:
+		return "IOCTL_ND_LISTENER_CREATE\n";
+
+	case IOCTL_ND_LISTENER_FREE:
+		return "IOCTL_ND_LISTENER_FREE\n";
+
+	case IOCTL_ND_QP_FREE:
+		return "IOCTL_ND_QP_FREE\n";
+
+	case IOCTL_ND_CONNECTOR_CANCEL_IO:
+		return "IOCTL_ND_CONNECTOR_CANCEL_IO\n";
+
+	case IOCTL_ND_LISTENER_CANCEL_IO:
+		return "IOCTL_ND_LISTENER_CANCEL_IO\n";
+
+	case IOCTL_ND_LISTENER_BIND:
+		return "IOCTL_ND_LISTENER_BIND\n";
+
+	case IOCTL_ND_LISTENER_LISTEN:
+		return "IOCTL_ND_LISTENER_LISTEN\n";
+
+	case IOCTL_ND_LISTENER_GET_ADDRESS:
+		return "IOCTL_ND_LISTENER_GET_ADDRESS\n";
+
+	case IOCTL_ND_LISTENER_GET_CONNECTION_REQUEST:
+		return "IOCTL_ND_LISTENER_GET_CONNECTION_REQUEST\n";
+
+
+
+	case IOCTL_ND_CONNECTOR_CREATE:
+		return "IOCTL_ND_CONNECTOR_CREATE\n";
+
+	case IOCTL_ND_CONNECTOR_FREE:
+		return "IOCTL_ND_CONNECTOR_FREE\n";
+
+	case IOCTL_ND_CONNECTOR_BIND:
+		return "IOCTL_ND_CONNECTOR_BIND\n";
+
+	case IOCTL_ND_CONNECTOR_CONNECT: /* KYS: ALERT: ASYNCH Operation */
+		return "IOCTL_ND_CONNECTOR_CONNECT\n";
+
+	case IOCTL_ND_CONNECTOR_COMPLETE_CONNECT:
+		return "IOCTL_ND_CONNECTOR_COMPLETE_CONNECT\n";
+
+	case IOCTL_ND_CONNECTOR_ACCEPT: /* KYS: ALERT: ASYNCH Operation */
+		return "IOCTL_ND_CONNECTOR_ACCEPT\n";
+
+	case IOCTL_ND_CONNECTOR_REJECT:
+		return "IOCTL_ND_CONNECTOR_REJECT\n";
+
+	case IOCTL_ND_CONNECTOR_GET_READ_LIMITS:
+		return "IOCTL_ND_CONNECTOR_GET_READ_LIMITS\n";
+
+	case IOCTL_ND_CONNECTOR_GET_PRIVATE_DATA:
+		return "IOCTL_ND_CONNECTOR_GET_PRIVATE_DATA\n";
+
+	case IOCTL_ND_CONNECTOR_GET_PEER_ADDRESS:
+		return "IOCTL_ND_CONNECTOR_GET_PEER_ADDRESS\n";
+
+	case IOCTL_ND_CONNECTOR_GET_ADDRESS:
+		return "IOCTL_ND_CONNECTOR_GET_ADDRESS\n";
+
+	case IOCTL_ND_CONNECTOR_NOTIFY_DISCONNECT:
+		return "IOCTL_ND_CONNECTOR_NOTIFY_DISCONNECT\n";
+
+	case IOCTL_ND_CONNECTOR_DISCONNECT:
+		return "IOCTL_ND_CONNECTOR_DISCONNECT\n";
+
+
+
+	case IOCTL_ND_QP_CREATE:
+		return "IOCTL_ND_QP_CREATE\n";
+
+	case IOCTL_ND_MR_CREATE:
+		return "IOCTL_ND_MR_CREATE\n";
+
+	case IOCTL_ND_MR_FREE:
+		return "IOCTL_ND_MR_FREE\n";
+	case IOCTL_ND_MR_REGISTER:
+		return "IOCTL_ND_MR_REGISTER\n";
+	case IOCTL_ND_MR_DEREGISTER:
+		return "IOCTL_ND_MR_DEREGISTER\n";
+	case IOCTL_ND_MR_CANCEL_IO:
+		return "IOCTL_ND_MR_CANCEL_IO\n";
+	case IOCTL_ND_ADAPTER_QUERY_ADDRESS_LIST:
+		return "IOCTL_ND_ADAPTER_QUERY_ADDRESS_LIST\n";
+	case IOCTL_ND_QP_FLUSH:
+		return "IOCTL_ND_QP_FLUSH\n";
+
+	default:
+		return "Unknown IOCTL\n";
+	}
+}
+int get_irp_handle(struct hvnd_dev *nd_dev, u32 *local, void *irp_ctx)
+{
+	unsigned int local_handle;
+	int ret;
+
+	local_handle = atomic_inc_return(&irp_local_hdl);
+	*local = local_handle;
+
+	/*
+	 * Now asssociate the local handle with the pointer.
+	 */
+	ret = insert_handle(nd_dev, &nd_dev->irpidr, irp_ctx, local_handle);
+	hvnd_debug("irp_ctx=%p local_handle=%u\n", irp_ctx, local_handle);
+
+	if (ret) {
+		hvnd_error("insert_handle failed ret=%d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+void put_irp_handle(struct hvnd_dev *nd_dev, u32 irp)
+{
+	remove_handle(nd_dev, &nd_dev->irpidr, irp);
+
+}
+
+static void init_pfn(u64 *pfn, void *addr, u32 length)
+{
+	int i;
+	u32 offset = offset_in_page(addr);
+	u32 num_pfn = DIV_ROUND_UP(offset + length, PAGE_SIZE);
+
+	for (i = 0; i < num_pfn; i++)
+		pfn[i] = virt_to_phys((u8 *)addr + (PAGE_SIZE * i)) >>
+			 PAGE_SHIFT;
+
+}
+
+
+static void user_va_init_pfn(u64 *pfn, struct ib_umem *umem)
+{
+	int entry;
+	struct scatterlist *sg;
+	int i = 0;
+
+	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
+		pfn[i++] = page_to_pfn(sg_page(sg));
+	}
+}
+
+static u32 get_local_handle(void *p)
+{
+	u64 val = (unsigned long)p;
+
+	return (u32)val;
+}
+
+static int hvnd_send_pg_buffer(struct hvnd_dev *nd_dev,
+				struct vmbus_packet_mpb_array *desc,
+				u32 desc_size,
+				void *buffer,
+				u32 bufferlen, u64 cookie)
+{
+	int ret;
+	int t;
+	struct hvnd_cookie hvnd_cookie;
+
+	hvnd_cookie.pkt = (void *)cookie;
+	init_completion(&hvnd_cookie.host_event);
+
+	ret = vmbus_sendpacket_mpb_desc(nd_dev->hvdev->channel,
+					desc,
+					desc_size,
+					buffer, bufferlen,
+					(u64)(&hvnd_cookie));
+
+	if (ret) {
+		hvnd_error("vmbus_sendpacket_mpb_desc failed ret=%d\n", ret);
+		goto err;
+	}
+
+	t = wait_for_completion_timeout(&hvnd_cookie.host_event, 500*HZ);
+
+	if (t == 0) {
+		hvnd_error("wait_for_completion_timeout timed out\n");
+		ret = -ETIMEDOUT;
+	}
+
+err:
+	return ret;
+}
+
+static int hvnd_send_packet(struct hvnd_dev *nd_dev, void *buffer,
+			    u32 bufferlen, u64 cookie, bool block)
+{
+	int ret;
+	int t;
+	struct hvnd_cookie hvnd_cookie;
+
+	hvnd_cookie.pkt = (void *)cookie;
+	init_completion(&hvnd_cookie.host_event);
+
+	ret = vmbus_sendpacket(nd_dev->hvdev->channel, buffer, bufferlen,
+			       (u64)(&hvnd_cookie), VM_PKT_DATA_INBAND,
+			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
+
+	if (ret) {
+		hvnd_error("vmbus_send pkt failed: %d\n", ret);
+		goto err;
+	}
+
+	if (!block)
+		return ret;
+
+	t = wait_for_completion_timeout(&hvnd_cookie.host_event, 500*HZ);
+
+	if (t == 0) {
+		hvnd_error("wait_for_completion_timeout timed out\n");
+		ret = -ETIMEDOUT;
+	}
+
+err:
+	return ret;
+}
+
+static int  hvnd_send_pgbuf_ioctl_pkt(struct hvnd_dev *nd_dev,
+				struct vmbus_packet_mpb_array *desc,
+				u32 desc_size,
+				struct ndv_packet_hdr_control_1 *hdr,
+				u32 pkt_size, u64 cookie)
+{
+	int ret;
+	int ioctl;
+
+	ioctl = hdr->io_cntrl_code;
+
+
+	ret = hvnd_send_pg_buffer(nd_dev, desc, desc_size,
+				hdr, pkt_size, cookie);
+
+	if (ret)
+		return ret;
+
+	if (hdr->pkt_hdr.status != 0) {
+		hvnd_error("IOCTL: %s failed; status is %x\n",
+			hvnd_get_op_name(ioctl),
+			hdr->pkt_hdr.status);
+		return -EINVAL;
+	}
+
+	switch (hdr->io_status) {
+	case STATUS_SUCCESS:
+	case STATUS_PENDING:
+		return 0;
+
+	default:
+		hvnd_error("IOCTL: %s failed io status is %x\n",
+			   hvnd_get_op_name(ioctl),
+			hdr->io_status);
+		return  -EINVAL;
+	}
+}
+
+int  hvnd_send_ioctl_pkt(struct hvnd_dev *nd_dev,
+				struct ndv_packet_hdr_control_1 *hdr,
+				u32 pkt_size, u64 cookie)
+{
+	int ret;
+	int ioctl;
+	bool block;
+
+	block = (hdr->irp_handle.val64 == 0) ? true : false;
+
+
+	ioctl = hdr->io_cntrl_code;
+
+	ret = hvnd_send_packet(nd_dev, hdr, pkt_size, cookie, block);
+
+	if (ret)
+		return ret;
+
+	if (!block)
+		return ret;
+
+	if (hdr->pkt_hdr.status != 0) {
+		hvnd_error("IOCTL: %s failed; status is %x\n",
+			   hvnd_get_op_name(ioctl),
+			hdr->pkt_hdr.status);
+		return -EINVAL;
+	}
+
+	switch (hdr->io_status) {
+	case STATUS_SUCCESS:
+	case STATUS_PENDING:
+		return 0;
+
+	default:
+		hvnd_warn("IOCTL: %s failed io status is %x\n",
+			  hvnd_get_op_name(ioctl),
+			  hdr->io_status);
+		return -EINVAL;
+	}
+}
+
+void hvnd_init_hdr(struct ndv_packet_hdr_control_1 *hdr,
+			  u32 data_sz, u32 local, u32 remote,
+			  u32 ioctl_code,
+			  u32 ext_data_sz, u32 ext_data_offset,
+			  u64 irp_handle)
+
+{
+	int pkt_type;
+
+	pkt_type = NDV_PKT_ID1_CONTROL;
+	NDV_ADD_PACKET_OPTION(pkt_type, NDV_PACKET_OPTIONS_REQUIRES_PASSIVE);
+	hdr->pkt_hdr.packet_type = pkt_type;
+	hdr->pkt_hdr.hdr_sz = sizeof(struct ndv_packet_hdr_control_1);
+	hdr->pkt_hdr.data_sz = data_sz;
+
+	hdr->pkt_hdr.status = 0;
+
+	hdr->file_handle.local = local;
+	hdr->file_handle.remote = remote;
+	hdr->irp_handle.val64 = irp_handle;
+
+	hdr->io_cntrl_code = ioctl_code;
+	hdr->output_buf_sz = data_sz - ext_data_sz;
+	hdr->input_buf_sz = data_sz - ext_data_sz;
+
+	hdr->input_output_buf_offset = 0;
+
+	hdr->extended_data.size = ext_data_sz;
+	hdr->extended_data.offset = ext_data_offset;
+}
+
+
+int hvnd_create_file(struct hvnd_dev *nd_dev, void  *uctx,
+		     struct ndv_pkt_hdr_create_1 *create, u32 file_flags)
+{
+	int ret;
+	int pkt_type;
+
+
+	pkt_type = NDV_PKT_ID1_CREATE;
+	NDV_ADD_PACKET_OPTION(pkt_type, NDV_PACKET_OPTIONS_REQUIRES_PASSIVE);
+	create->pkt_hdr.packet_type = pkt_type;
+	create->pkt_hdr.hdr_sz = sizeof(struct ndv_pkt_hdr_create_1);
+	create->pkt_hdr.data_sz = 0;
+
+	create->handle.local = get_local_handle(uctx);
+	create->access_mask = STANDARD_RIGHTS_ALL;
+	create->open_options = OPEN_EXISTING;
+	create->file_attributes = FILE_ATTRIBUTE_NORMAL | file_flags;
+	create->share_access = FILE_SHARE_ALL;
+
+	ret = hvnd_send_packet(nd_dev, create,
+			       sizeof(struct ndv_pkt_hdr_create_1),
+			       (unsigned long)create, true);
+	return ret;
+}
+
+int hvnd_cleanup_file(struct hvnd_dev *nd_dev, u32 local, u32 remote)
+{
+	int ret;
+	int pkt_type;
+	struct ndv_pkt_hdr_cleanup_1 cleanup_pkt;
+
+
+	pkt_type = NDV_PKT_ID1_CLEANUP;
+	NDV_ADD_PACKET_OPTION(pkt_type, NDV_PACKET_OPTIONS_REQUIRES_PASSIVE);
+
+	cleanup_pkt.pkt_hdr.packet_type = pkt_type;
+	cleanup_pkt.pkt_hdr.hdr_sz = sizeof(struct ndv_pkt_hdr_create_1);
+	cleanup_pkt.pkt_hdr.data_sz = 0;
+
+	cleanup_pkt.handle.local = local;
+	cleanup_pkt.handle.remote = remote;
+
+	ret = hvnd_send_packet(nd_dev, &cleanup_pkt,
+			       sizeof(struct ndv_pkt_hdr_create_1),
+			       (unsigned long)&cleanup_pkt, true);
+	return ret;
+}
+
+
+static int  hvnd_do_ioctl(struct hvnd_dev *nd_dev, u32 ioctl,
+		     struct pkt_nd_provider_ioctl *pkt,
+		     union ndv_context_handle *hdr_handle,
+		     struct nd_handle  *ioctl_handle,
+		     u8 *buf, u32 buf_len, bool c_in, bool c_out, u64 irp_val)
+{
+	int ret;
+	int pkt_type;
+
+	pkt_type = NDV_PKT_ID1_CONTROL;
+	NDV_ADD_PACKET_OPTION(pkt_type, NDV_PACKET_OPTIONS_REQUIRES_PASSIVE);
+
+	pkt->hdr.pkt_hdr.packet_type = pkt_type;
+	pkt->hdr.pkt_hdr.hdr_sz = sizeof(struct ndv_packet_hdr_control_1);
+	pkt->hdr.pkt_hdr.data_sz = (sizeof(struct pkt_nd_provider_ioctl) -
+				   sizeof(struct ndv_packet_hdr_control_1));
+
+	pkt->hdr.file_handle.local = hdr_handle->local;
+	pkt->hdr.file_handle.remote = hdr_handle->remote;
+	hvnd_debug("create handle local: %x remote: %x\n", hdr_handle->local,
+		   hdr_handle->remote);
+
+	pkt->hdr.irp_handle.val64 = irp_val;
+
+	pkt->hdr.io_cntrl_code = ioctl;
+	pkt->hdr.output_buf_sz = sizeof(struct nd_ioctl);
+	pkt->hdr.input_buf_sz = sizeof(struct nd_ioctl);
+	pkt->hdr.input_output_buf_offset = 0;
+	memset(&pkt->ioctl.handle, 0, sizeof(struct nd_handle));
+	pkt->ioctl.handle.version = ND_VERSION_1;
+
+	switch (ioctl) {
+	case IOCTL_ND_PROVIDER_BIND_FILE:
+		pkt->ioctl.handle.handle = ioctl_handle->handle;
+		break;
+	default:
+		break;
+	};
+
+	/*
+	 * Copy the input buffer, if needed.
+	 */
+
+	if (c_in && (buf != NULL))
+		memcpy(pkt->ioctl.raw_buffer, buf, buf_len);
+
+	ret = hvnd_send_packet(nd_dev, pkt,
+			       sizeof(struct pkt_nd_provider_ioctl),
+			       (unsigned long)pkt, true);
+
+	if (ret)
+		return ret;
+
+	if (c_out && (buf != NULL))
+		memcpy(buf, pkt->ioctl.raw_buffer, buf_len);
+
+	return ret;
+}
+
+static int idr_callback(int id, void *p, void *data)
+{
+	if (p == data)
+		return id;
+	return 0;
+}
+
+void remove_uctx(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx)
+{
+	int pid = current_pid();
+	unsigned long flags;
+	int id;
+
+	if (get_uctx(nd_dev, pid) == uctx)
+		remove_handle(nd_dev, &nd_dev->uctxidr, pid);
+	else {
+		hvnd_warn("uctx %p not found on pid %d, doing a idr search\n",
+			  uctx, current_pid());
+
+		spin_lock_irqsave(&nd_dev->id_lock, flags);
+		id = idr_for_each(&nd_dev->uctxidr, idr_callback, uctx);
+		spin_unlock_irqrestore(&nd_dev->id_lock, flags);
+
+		if (id)
+			remove_handle(nd_dev, &nd_dev->uctxidr, id);
+		else {
+			hvnd_error("uctx %p not found in idr table\n", uctx);
+			return;
+		}
+	}
+
+	kfree(uctx);
+}
+
+int hvnd_close_adaptor(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx)
+{
+	int ret;
+
+	/*
+	 * First close the adaptor.
+	 */
+
+	ret = hvnd_free_handle(nd_dev, uctx,
+				uctx->adaptor_hdl,
+				IOCTL_ND_ADAPTER_CLOSE);
+
+	if (ret)
+		hvnd_error("Adaptor close failed; ret is %x\n", ret);
+
+	/*
+	 * Now close the two files we created.
+	 */
+
+	ret = hvnd_cleanup_file(nd_dev, uctx->file_handle_ovl.local,
+				uctx->file_handle_ovl.remote);
+
+	if (ret)
+		hvnd_error("file cleanup failed; ret is %x\n", ret);
+
+	ret = hvnd_cleanup_file(nd_dev, uctx->file_handle.local,
+				uctx->file_handle.remote);
+
+	if (ret)
+		hvnd_error("File cleanup failed; ret is %x\n", ret);
+
+	/*
+	 * Remove the uctx from the ID table.
+	 */
+	remove_uctx(nd_dev, uctx);
+
+	return 0;
+}
+
+int hvnd_open_adaptor(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx)
+{
+	int ret;
+	struct pkt_nd_provider_ioctl *pr_init = &uctx->pr_init_pkt;
+	int pkt_type;
+	struct nd_handle ioctl_handle;
+	struct pkt_nd_open_adapter *pr_o_adap = &uctx->o_adap_pkt;
+
+	ret = hvnd_create_file(nd_dev, uctx, &uctx->create_pkt, 0);
+	if (ret) {
+		hvnd_error("hvnd_create_file failed ret=%d\n", ret);
+		goto error_cr;
+	}
+
+	if (uctx->create_pkt.pkt_hdr.status != 0) {
+		hvnd_error("create File failed; status is %d\n",
+			uctx->create_pkt.pkt_hdr.status);
+		ret = -EINVAL;
+		goto error_cr;
+	}
+
+	uctx->file_handle.local = uctx->create_pkt.handle.local;
+	uctx->file_handle.remote = uctx->create_pkt.handle.remote;
+	hvnd_debug("INITIALIZE PROVIDER\n");
+	/*
+	 * Now Initialize the Provider.
+	 */
+	ioctl_handle.handle = 0;
+	ret = hvnd_do_ioctl(nd_dev, IOCTL_ND_PROVIDER_INIT, pr_init,
+			    &uctx->create_pkt.handle,
+			    &ioctl_handle, NULL, 0, false, false, 0);
+
+	if (ret) {
+		ret = -EINVAL;
+		goto error_pr_init;
+	}
+
+	if (pr_init->hdr.pkt_hdr.status != 0) {
+		hvnd_error("Provider INIT failed; status is %d\n",
+			pr_init->hdr.pkt_hdr.status);
+		ret = -EINVAL;
+		goto error_pr_init;
+	}
+
+	if (pr_init->hdr.io_status != 0) {
+		hvnd_error("Provider INIT failed; io status is %d\n",
+			pr_init->hdr.io_status);
+		ret = -EINVAL;
+		goto error_pr_init;
+	}
+
+	/*
+	 * Now create the overlap file.
+	 */
+
+	hvnd_debug("CREATE OVERLAP FILE\n");
+	ret = hvnd_create_file(nd_dev, uctx, &uctx->create_pkt_ovl,
+			       FILE_FLAG_OVERLAPPED);
+	if (ret) {
+		hvnd_error("hvnd_create_file failed ret=%d\n", ret);
+		goto error_pr_init;
+	}
+
+	if (uctx->create_pkt_ovl.pkt_hdr.status != 0) {
+		hvnd_error("create Overlap File failed; status is %d\n",
+			uctx->create_pkt_ovl.pkt_hdr.status);
+		ret = -EINVAL;
+		goto error_pr_init;
+	}
+	uctx->file_handle_ovl.local = uctx->create_pkt_ovl.handle.local;
+	uctx->file_handle_ovl.remote = uctx->create_pkt_ovl.handle.remote;
+
+	/*
+	 * Now bind the two file handles together.
+	 */
+
+	hvnd_debug("BIND FILE IOCTL remote handle: %d local handle: %d\n",
+		uctx->create_pkt_ovl.handle.remote,
+		uctx->create_pkt_ovl.handle.local);
+
+	ioctl_handle.handle = uctx->create_pkt_ovl.handle.val64;
+	ret = hvnd_do_ioctl(nd_dev, IOCTL_ND_PROVIDER_BIND_FILE, pr_init,
+			    &uctx->create_pkt.handle,
+			    &ioctl_handle, NULL, 0, false, false, 0);
+
+	if (ret) {
+		ret = -EINVAL;
+		goto error_file_bind;
+	}
+	if (pr_init->hdr.pkt_hdr.status != 0) {
+		hvnd_error("Provider File bind failed; status is %d\n",
+			pr_init->hdr.pkt_hdr.status);
+		ret = -EINVAL;
+		goto error_file_bind;
+	}
+	if (pr_init->hdr.io_status != 0) {
+		hvnd_error("Provider INIT failed; io status is %d\n",
+			pr_init->hdr.io_status);
+		ret = -EINVAL;
+		goto error_file_bind;
+	}
+
+	/*
+	 * Now open the adaptor.
+	 */
+
+	hvnd_debug("OPENING THE ADAPTOR\n");
+
+	pkt_type = NDV_PKT_ID1_CONTROL;
+	NDV_ADD_PACKET_OPTION(pkt_type, NDV_PACKET_OPTIONS_REQUIRES_PASSIVE);
+	pr_o_adap->hdr.pkt_hdr.packet_type = pkt_type;
+	pr_o_adap->hdr.pkt_hdr.hdr_sz = sizeof(struct ndv_packet_hdr_control_1);
+	pr_o_adap->hdr.pkt_hdr.data_sz = (sizeof(struct pkt_nd_open_adapter) -
+				sizeof(struct ndv_packet_hdr_control_1));
+
+	pr_o_adap->hdr.pkt_hdr.status = 0;
+
+	hvnd_debug("hdr sz is %d\n", pr_o_adap->hdr.pkt_hdr.hdr_sz);
+	hvnd_debug("data sz is %d\n", pr_o_adap->hdr.pkt_hdr.data_sz);
+
+	pr_o_adap->hdr.file_handle.local = uctx->create_pkt.handle.local;
+	pr_o_adap->hdr.file_handle.remote = uctx->create_pkt.handle.remote;
+	hvnd_debug("create handle local is %x\n",
+		   uctx->create_pkt.handle.local);
+	hvnd_debug("create handle remote is %x\n",
+		   uctx->create_pkt.handle.remote);
+	pr_o_adap->hdr.irp_handle.val64 = 0;
+
+	pr_o_adap->hdr.io_cntrl_code = IOCTL_ND_ADAPTER_OPEN;
+	pr_o_adap->hdr.output_buf_sz = pr_o_adap->hdr.pkt_hdr.data_sz -
+					sizeof(struct extended_data_oad);
+	pr_o_adap->hdr.input_buf_sz = pr_o_adap->hdr.pkt_hdr.data_sz -
+					sizeof(struct extended_data_oad);
+
+	hvnd_debug("output buf sz is %d\n", pr_o_adap->hdr.output_buf_sz);
+	hvnd_debug("input buf sz is %d\n", pr_o_adap->hdr.input_buf_sz);
+	hvnd_debug("packet size is %d\n",
+		   (int)sizeof(struct pkt_nd_open_adapter));
+
+	pr_o_adap->hdr.input_output_buf_offset = 0;
+
+
+	pr_o_adap->hdr.extended_data.size = sizeof(struct extended_data_oad);
+	pr_o_adap->hdr.extended_data.offset =
+		offsetof(struct pkt_nd_open_adapter, ext_data) -
+		sizeof(struct ndv_packet_hdr_control_1);
+
+	hvnd_debug("size of the extended data size: %d\n",
+		   (int)sizeof(struct extended_data_oad));
+	hvnd_debug("offset of extended data: %d\n",
+		   pr_o_adap->hdr.extended_data.offset);
+
+	/*
+	 * Now fill out the ioctl section.
+	 */
+
+	pr_o_adap->ioctl.input.version = ND_VERSION_1;
+	pr_o_adap->ioctl.input.ce_mapping_cnt =
+		RTL_NUMBER_OF(pr_o_adap->mappings.ctx_input.mappings);
+
+	hvnd_debug("ce_mapping cnt is %d\n",
+		   pr_o_adap->ioctl.input.ce_mapping_cnt);
+
+	pr_o_adap->ioctl.input.cb_mapping_offset = sizeof(union oad_ioctl);
+	hvnd_debug("cb_mapping offset is %d\n",
+		   pr_o_adap->ioctl.input.cb_mapping_offset);
+	pr_o_adap->ioctl.input.adapter_id = (u64)nd_dev;
+
+	pr_o_adap->mappings.ctx_input.mappings[IBV_GET_CONTEXT_UAR].map_type =
+		ND_MAP_IOSPACE;
+	pr_o_adap->mappings.ctx_input.mappings[IBV_GET_CONTEXT_UAR].
+		map_io_space.cache_type = ND_NON_CACHED;
+	pr_o_adap->mappings.ctx_input.mappings[IBV_GET_CONTEXT_UAR].
+		map_io_space.cb_length = 4096;
+
+	pr_o_adap->mappings.ctx_input.mappings[IBV_GET_CONTEXT_BF].map_type =
+		ND_MAP_IOSPACE;
+	pr_o_adap->mappings.ctx_input.mappings[IBV_GET_CONTEXT_BF].
+		map_io_space.cache_type = ND_WRITE_COMBINED;
+	pr_o_adap->mappings.ctx_input.mappings[IBV_GET_CONTEXT_BF].
+		map_io_space.cb_length = 4096;
+
+	/*
+	 * Fill in the extended data.
+	 */
+	pr_o_adap->ext_data.cnt = IBV_GET_CONTEXT_MAPPING_MAX;
+
+	ret = hvnd_send_packet(nd_dev, pr_o_adap,
+			       sizeof(struct pkt_nd_open_adapter),
+			       (unsigned long)pr_o_adap, true);
+	if (ret) {
+		ret = -EINVAL;
+		goto error_file_bind;
+	}
+
+	if (pr_o_adap->hdr.pkt_hdr.status != 0) {
+		hvnd_error("Open adaptor failed; status is %d\n",
+			pr_o_adap->hdr.pkt_hdr.status);
+		ret = -EINVAL;
+		goto error_file_bind;
+	}
+
+	if (pr_o_adap->hdr.io_status != 0) {
+		hvnd_error("Open adaptor failed;io status is %d\n",
+			pr_o_adap->hdr.io_status);
+		ret = -EINVAL;
+		goto error_file_bind;
+	}
+
+	/*
+	 * Copy the necessary response from the host.
+	 */
+
+	uctx->adaptor_hdl = pr_o_adap->ioctl.resrc_desc.handle;
+
+
+	hvnd_debug("adaptor handle: %p\n", (void *)uctx->adaptor_hdl);
+
+	uctx->uar_base =
+	pr_o_adap->mappings.ctx_output.
+	mapping_results[IBV_GET_CONTEXT_UAR].info;
+	hvnd_debug("uar base: %p\n", (void *)uctx->uar_base);
+
+	uctx->bf_base =
+	pr_o_adap->mappings.ctx_output.mapping_results[IBV_GET_CONTEXT_BF].info;
+	hvnd_debug("bf base: %p\n", (void *)uctx->bf_base);
+
+	uctx->bf_buf_size =
+	pr_o_adap->mappings.ctx_output.bf_buf_size;
+	hvnd_debug("bf buf size: %d\n", uctx->bf_buf_size);
+
+	uctx->bf_offset =
+	pr_o_adap->mappings.ctx_output.bf_offset;
+	hvnd_debug("bf offset: %d\n", uctx->bf_offset);
+
+	uctx->cqe_size =
+	pr_o_adap->mappings.ctx_output.cqe_size;
+	hvnd_debug("cqe size: %d\n", uctx->cqe_size);
+
+	uctx->max_qp_wr =
+	pr_o_adap->mappings.ctx_output.max_qp_wr;
+	hvnd_debug("max qp wr: %d\n", uctx->max_qp_wr);
+
+	uctx->max_sge =
+	pr_o_adap->mappings.ctx_output.max_sge;
+	hvnd_debug("max sge: %d\n", uctx->max_sge);
+
+	uctx->max_cqe =
+	pr_o_adap->mappings.ctx_output.max_cqe;
+	hvnd_debug("max cqe: %d\n", uctx->max_cqe);
+
+	uctx->num_qps =
+	pr_o_adap->mappings.ctx_output.qp_tab_size;
+	hvnd_debug("num qps: %d\n", uctx->num_qps);
+
+	/*
+	 * Now query the adaptor and stash away the adaptor info.
+	 */
+
+	ret = hvnd_query_adaptor(nd_dev, uctx);
+	if (ret) {
+		hvnd_error("Query Adaptor failed; ret is %d\n", ret);
+		goto query_err;
+	}
+
+	return ret;
+
+query_err:
+	hvnd_free_handle(nd_dev, uctx,
+			uctx->adaptor_hdl,
+			IOCTL_ND_ADAPTER_CLOSE);
+
+	hvnd_error("Open Adaptor Failed!!\n");
+
+error_file_bind:
+	hvnd_cleanup_file(nd_dev, uctx->file_handle_ovl.local,
+			uctx->file_handle_ovl.remote);
+
+error_pr_init:
+	hvnd_cleanup_file(nd_dev, uctx->file_handle.local,
+			uctx->file_handle.remote);
+
+error_cr:
+	if (get_uctx(nd_dev, current_pid()) != NULL)
+		remove_handle(nd_dev, &nd_dev->uctxidr, current_pid());
+
+	return ret;
+}
+
+int hvnd_create_cq(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+		   struct hvnd_cq *cq)
+{
+	int ret;
+	struct pkt_nd_create_cq *pkt;
+	int num_pfn, num_db_pfn, num_sn_pfn;
+	int cq_pkt_size;
+	unsigned int cq_buf_size, offset;
+	u32 ext_data_sz;
+	u32 ext_data_offset;
+
+	/*
+	 * Now create CQ.
+	 * First compute the number of PFNs we need to accomodate:
+	 * One each for door bell and arm_sn and pages in cq buffer.
+	 */
+	cq_buf_size = (cq->entries * uctx->cqe_size);
+	offset = offset_in_page(cq->cq_buf);
+	num_pfn = DIV_ROUND_UP(offset + cq_buf_size, PAGE_SIZE);
+
+	offset = offset_in_page(cq->db_addr);
+	num_db_pfn = DIV_ROUND_UP(offset + 8, PAGE_SIZE);
+
+	offset = offset_in_page(&cq->arm_sn);
+	num_sn_pfn = DIV_ROUND_UP(offset + 4, PAGE_SIZE);
+
+	cq_pkt_size = sizeof(struct pkt_nd_create_cq) +
+		(num_pfn  * sizeof(u64));
+
+	ext_data_sz = sizeof(struct create_cq_ext_data) +
+			(num_pfn * sizeof(u64));
+	ext_data_offset = offsetof(struct pkt_nd_create_cq, ext_data) -
+					sizeof(struct ndv_packet_hdr_control_1);
+
+	hvnd_debug("CREATE CQ, num user addr pfns is %d\n", num_pfn);
+	hvnd_debug("CREATE CQ, num db pfns is %d\n", num_db_pfn);
+
+	pkt = kzalloc(cq_pkt_size, GFP_KERNEL);
+
+	if (!pkt)
+		return -ENOMEM;
+
+	hvnd_init_hdr(&pkt->hdr,
+			(cq_pkt_size -
+			sizeof(struct ndv_packet_hdr_control_1)),
+			uctx->create_pkt.handle.local,
+			uctx->create_pkt.handle.remote,
+			IOCTL_ND_CQ_CREATE,
+			ext_data_sz,
+			ext_data_offset,
+			0);
+
+	/*
+	 * Now fill out the ioctl section.
+	 */
+
+	pkt->ioctl.input.version = ND_VERSION_1;
+	pkt->ioctl.input.queue_depth = cq->entries;
+	pkt->ioctl.input.ce_mapping_cnt = MLX4_IB_CREATE_CQ_MAPPING_MAX;
+	pkt->ioctl.input.cb_mapping_offset = sizeof(union create_cq_ioctl);
+
+	hvnd_debug("ce_mapping cnt is %d\n",  pkt->ioctl.input.ce_mapping_cnt);
+	hvnd_debug("cb_mapping offset is %d\n",
+		   pkt->ioctl.input.cb_mapping_offset);
+
+	pkt->ioctl.input.adapter_handle = uctx->adaptor_hdl;
+	pkt->ioctl.input.affinity.mask = 0;
+	pkt->ioctl.input.affinity.group = -1;
+
+	/* 0 for usermode CQ arming */
+	pkt->mappings.cq_in.flags = 0;
+
+	pkt->mappings.cq_in.mappings[MLX4_IB_CREATE_CQ_BUF].
+		map_memory.map_type = ND_MAP_MEMORY;
+	pkt->mappings.cq_in.mappings[MLX4_IB_CREATE_CQ_BUF].
+		map_memory.access_type = ND_MODIFY_ACCESS;
+	pkt->mappings.cq_in.mappings[MLX4_IB_CREATE_CQ_BUF].
+		map_memory.address = (u64)cq->cq_buf;
+	pkt->mappings.cq_in.mappings[MLX4_IB_CREATE_CQ_BUF].
+		map_memory.cb_length = (cq->entries * uctx->cqe_size);
+
+	pkt->mappings.cq_in.mappings[MLX4_IB_CREATE_CQ_DB].
+		map_memory.map_type = ND_MAP_MEMORY_COALLESCE;
+	pkt->mappings.cq_in.mappings[MLX4_IB_CREATE_CQ_DB].
+		map_memory.access_type = ND_WRITE_ACCESS;
+	pkt->mappings.cq_in.mappings[MLX4_IB_CREATE_CQ_DB].
+		map_memory.address = (u64)cq->db_addr;
+	pkt->mappings.cq_in.mappings[MLX4_IB_CREATE_CQ_DB].
+		map_memory.cb_length = 8; /* size of two ints */
+
+
+	pkt->mappings.cq_in.mappings[MLX4_IB_CREATE_CQ_ARM_SN].
+		map_memory.map_type = ND_MAP_MEMORY;
+	pkt->mappings.cq_in.mappings[MLX4_IB_CREATE_CQ_ARM_SN].
+		map_memory.access_type = ND_MODIFY_ACCESS;
+	pkt->mappings.cq_in.mappings[MLX4_IB_CREATE_CQ_ARM_SN].
+		map_memory.address = (u64)&cq->arm_sn;
+	pkt->mappings.cq_in.mappings[MLX4_IB_CREATE_CQ_ARM_SN].
+		map_memory.cb_length = 4; /* size of one int */
+	/*
+	 * Fill in the extended data.
+	 */
+
+	pkt->ext_data.cnt = 3;
+	pkt->ext_data.fields[MLX4_IB_CREATE_CQ_BUF].size =
+		(sizeof(struct gpa_range) + (num_pfn * sizeof(u64)));
+	pkt->ext_data.fields[MLX4_IB_CREATE_CQ_BUF].offset =
+		offsetof(struct create_cq_ext_data, cqbuf_gpa);
+
+	pkt->ext_data.fields[MLX4_IB_CREATE_CQ_DB].size =
+		sizeof(struct cq_db_gpa);
+	pkt->ext_data.fields[MLX4_IB_CREATE_CQ_DB].offset =
+		offsetof(struct create_cq_ext_data, db_gpa);
+
+	pkt->ext_data.fields[MLX4_IB_CREATE_CQ_ARM_SN].size =
+		sizeof(struct cq_db_gpa);
+	pkt->ext_data.fields[MLX4_IB_CREATE_CQ_ARM_SN].offset =
+		offsetof(struct create_cq_ext_data, sn_gpa);
+
+	/*
+	 * Fill up the gpa range for cq buffer.
+	 */
+
+	pkt->ext_data.db_gpa.byte_count = 8;
+	pkt->ext_data.db_gpa.byte_offset = offset_in_page(cq->db_addr);
+	user_va_init_pfn(&pkt->ext_data.db_gpa.pfn_array[0], cq->db_umem);
+
+	pkt->ext_data.sn_gpa.byte_count = 4;
+	pkt->ext_data.sn_gpa.byte_offset = offset_in_page(&cq->arm_sn);
+	init_pfn(&pkt->ext_data.sn_gpa.pfn_array[0],
+		 &cq->arm_sn,
+		 4);
+
+	pkt->ext_data.cqbuf_gpa.byte_count = (cq->entries * uctx->cqe_size);
+	pkt->ext_data.cqbuf_gpa.byte_offset = offset_in_page(cq->cq_buf);
+	user_va_init_pfn(&pkt->ext_data.cqbuf_gpa.pfn_array[0], cq->umem);
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt->hdr, cq_pkt_size, (u64)pkt);
+
+	if (ret)
+		goto cr_cq_err;
+
+	/*
+	 * Copy the necessary response from the host.
+	 */
+	cq->cqn = pkt->mappings.cq_resp.cqn;
+	cq->cqe = pkt->mappings.cq_resp.cqe;
+	cq->cq_handle = pkt->ioctl.resrc_desc.handle;
+
+	ret = insert_handle(nd_dev, &nd_dev->cqidr, cq, cq->cqn);
+
+	if (ret)
+		goto cr_cq_err;
+	hvnd_debug("CQ create after success cqn is %d\n", cq->cqn);
+	hvnd_debug("CQ create after success cqe is %d\n", cq->cqe);
+	hvnd_debug("CQ create after success cq handle is %p\n",
+		   (void *)cq->cq_handle);
+
+cr_cq_err:
+	kfree(pkt);
+	return ret;
+}
+
+int hvnd_destroy_cq(struct hvnd_dev *nd_dev, struct hvnd_cq *cq)
+{
+	struct pkt_nd_free_cq free_cq_pkt;
+	int ret;
+
+	/* KYS try to avoid having to zero everything */
+	memset(&free_cq_pkt, 0, sizeof(free_cq_pkt));
+	hvnd_init_hdr(&free_cq_pkt.hdr,
+		      sizeof(struct pkt_nd_free_cq) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      cq->uctx->create_pkt.handle.local,
+		      cq->uctx->create_pkt.handle.remote,
+		      IOCTL_ND_CQ_FREE, 0, 0, 0);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	free_cq_pkt.ioctl.in.version = ND_VERSION_1;
+	free_cq_pkt.ioctl.in.handle = cq->cq_handle;
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &free_cq_pkt.hdr,
+			       sizeof(struct pkt_nd_free_cq),
+			       (u64)&free_cq_pkt);
+
+	if (ret)
+		goto free_cq_err;
+
+	remove_handle(nd_dev, &nd_dev->cqidr, cq->cqn);
+
+	return 0;
+
+free_cq_err:
+	return ret;
+}
+
+
+int hvnd_notify_cq(struct hvnd_dev *nd_dev, struct hvnd_cq *cq,
+		   u32 notify_type, u64 irp_handle)
+{
+	struct pkt_nd_notify_cq notify_cq_pkt;
+	int ret;
+	union ndv_context_handle irp_fhandle;
+
+	irp_fhandle.local = cq->ep_object.local_irp;
+
+
+	/* KYS try to avoid having to zero everything */
+	memset(&notify_cq_pkt, 0, sizeof(notify_cq_pkt));
+	hvnd_init_hdr(&notify_cq_pkt.hdr,
+		      sizeof(struct pkt_nd_notify_cq) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      cq->uctx->create_pkt.handle.local,
+		      cq->uctx->create_pkt.handle.remote,
+		      IOCTL_ND_CQ_NOTIFY, 0, 0, irp_fhandle.val64);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	notify_cq_pkt.ioctl.in.version = ND_VERSION_1;
+	notify_cq_pkt.ioctl.in.cq_handle = cq->cq_handle;
+	notify_cq_pkt.ioctl.in.type = notify_type;
+
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &notify_cq_pkt.hdr,
+			       sizeof(struct pkt_nd_notify_cq),
+			       (u64)&notify_cq_pkt);
+
+	return ret;
+}
+
+/*
+ * Memory region operations.
+ */
+int hvnd_cr_mr(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+		u64 pd_handle, u64 *mr_handle)
+{
+	struct pkt_nd_create_mr pkt;
+	int ret;
+
+	/* KYS try to avoid having to zero everything */
+	memset(&pkt, 0, sizeof(pkt));
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_MR_CREATE, 0, 0, 0);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.version = ND_VERSION_1;
+	pkt.ioctl.in.handle = pd_handle;
+	hvnd_debug("PD handle is %p\n", (void *)pd_handle);
+	pkt.ioctl.in.reserved = 0;
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr, sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	/*
+	 * Copy the  handle.
+	 */
+	hvnd_debug("mr handle is %p\n", (void *)pkt.ioctl.out);
+	*mr_handle = pkt.ioctl.out;
+
+	return 0;
+
+err:
+	hvnd_error("create mr failed: %d\n", ret);
+	return ret;
+
+}
+
+int hvnd_free_mr(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+		 u64 handle)
+{
+	return hvnd_free_handle(nd_dev, uctx, handle, IOCTL_ND_MR_FREE);
+}
+
+int hvnd_deregister_mr(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 handle)
+{
+	struct pkt_nd_deregister_mr pkt;
+	int ret;
+
+	/* KYS try to avoid having to zero everything */
+	memset(&pkt, 0, sizeof(pkt));
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_MR_DEREGISTER, 0, 0, 0);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.version = ND_VERSION_1;
+	pkt.ioctl.in.handle = handle;
+	pkt.ioctl.in.reserved = 0;
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr, sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	hvnd_error("de-register mr failed: %d\n", ret);
+	return ret;
+
+}
+
+static inline u32 hvnd_convert_access(int acc)
+{
+	return (acc & IB_ACCESS_REMOTE_WRITE ?
+		ND_MR_FLAG_ALLOW_REMOTE_WRITE : 0) |
+		(acc & IB_ACCESS_REMOTE_READ ?
+		ND_MR_FLAG_ALLOW_REMOTE_READ : 0) |
+		(acc & IB_ACCESS_LOCAL_WRITE ?
+		ND_MR_FLAG_ALLOW_LOCAL_WRITE : 0);
+}
+
+
+int hvnd_mr_register(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+		     struct hvnd_mr *mr)
+{
+	struct pkt_nd_register_mr pkt;
+	int ret;
+	struct hv_mpb_array *pb;
+	struct vmbus_packet_mpb_array *tpb;
+	int sz_leaf;
+	int num_pgs;
+	int i = 0;
+	int ext_data_sz;
+	u32 acc_flags;
+	u32 desc_size;
+	int pkt_type;
+
+	/*
+	 * The user address is passed in via a two level structure.
+	 * An Array of struct hv_page_buffer will be used to describe
+	 * the user memory. The pages containing this array will be descibed
+	 * in another array of struct hv_page_buffer. We pass this seconed level
+	 * array to the host.
+	 */
+
+	hvnd_debug("ib_umem_page_count(mr->umem)=%d\n",
+		   ib_umem_page_count(mr->umem));
+
+	sz_leaf = ib_umem_page_count(mr->umem) * sizeof(u64) +
+		  sizeof(struct hv_mpb_array);
+
+	pb = (struct hv_mpb_array *)
+		__get_free_pages(GFP_KERNEL|__GFP_ZERO, get_order(sz_leaf));
+
+	if (pb == NULL)
+		return -ENOMEM;
+	/*
+	 * Allocate an array of hv_page_buffer to describe the first level.
+	 */
+	num_pgs = DIV_ROUND_UP(sz_leaf, PAGE_SIZE);
+	hvnd_debug("num pages in the top array is %d\n", num_pgs);
+
+	desc_size = (num_pgs * sizeof(u64) +
+			sizeof(struct vmbus_packet_mpb_array));
+	tpb = (struct vmbus_packet_mpb_array *)
+		__get_free_pages(GFP_KERNEL|__GFP_ZERO, get_order(desc_size));
+
+	if (tpb == NULL) {
+		free_pages((unsigned long)pb, get_order(sz_leaf));
+		return -ENOMEM;
+	}
+
+	hvnd_debug("sz leaf: %d; pgs in top %d\n", sz_leaf, num_pgs);
+
+	/*
+	 * Now fill the leaf level array.
+	 */
+	pb->len = mr->length;
+	pb->offset = offset_in_page(mr->start);
+	user_va_init_pfn(pb->pfn_array, mr->umem);
+
+	/*
+	 * Now fill out the top level array.
+	 */
+	for (i = 0; i < num_pgs; i++) {
+		tpb->range.pfn_array[i] = virt_to_phys((u8 *)pb +
+					  (PAGE_SIZE * i)) >> PAGE_SHIFT;
+		hvnd_debug("virtual address = %p\n",
+			   (u8 *)pb + (PAGE_SIZE * i));
+		hvnd_debug("physical address = %llx\n",
+			   virt_to_phys((u8 *)pb + (PAGE_SIZE * i)));
+		hvnd_debug("tpb->range.pfn_array[%d]=%llx\n", i,
+			   tpb->range.pfn_array[i]);
+	}
+
+	tpb->range.offset = 8;
+	tpb->range.len = ib_umem_page_count(mr->umem) * sizeof(u64);
+
+
+	/* KYS try to avoid having to zero everything */
+	memset(&pkt, 0, sizeof(pkt));
+	ext_data_sz = (ib_umem_page_count(mr->umem) * sizeof(u64));
+	acc_flags = ND_MR_FLAG_DO_NOT_SECURE_VM | hvnd_convert_access(mr->acc);
+	hvnd_debug("memory register access flags are: %x\n", acc_flags);
+
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_MR_REGISTER, 0, 0, 0);
+
+	/*
+	 * The memory registration call uses a different mechanism to pass
+	 * pfn information.
+	 */
+
+	pkt_type = pkt.hdr.pkt_hdr.packet_type;
+	NDV_ADD_PACKET_OPTION(pkt_type, NDV_PACKET_OPTION_EXTERNAL_DATA);
+	pkt.hdr.pkt_hdr.packet_type = pkt_type;
+
+	pkt.hdr.extended_data.size = ext_data_sz;
+	pkt.hdr.extended_data.offset = 0;
+	/*
+	 * Now fill out the ioctl.
+	 */
+
+	pkt.ioctl.in.header.version = ND_VERSION_1;
+	pkt.ioctl.in.header.flags = acc_flags;
+	pkt.ioctl.in.header.cb_length = mr->length;
+	pkt.ioctl.in.header.target_addr = mr->virt;
+	pkt.ioctl.in.header.mr_handle = mr->mr_handle;
+	pkt.ioctl.in.address = mr->virt;
+
+	/*
+	 * Now send the packet to the host.
+	 */
+
+	ret = hvnd_send_pgbuf_ioctl_pkt(nd_dev,
+					tpb, desc_size,
+					&pkt.hdr,
+					sizeof(pkt),
+					(unsigned long)&pkt);
+
+	if (ret)
+		goto err;
+
+	hvnd_info("MR REGISTRATION SUCCESS\n");
+	/*
+	 * Copy the mr registration data.
+	 */
+	hvnd_debug("mr registration lkey %x\n", pkt.ioctl.out.lkey);
+	hvnd_debug("mr registration rkey %x\n", pkt.ioctl.out.rkey);
+
+	mr->mr_lkey = pkt.ioctl.out.lkey;
+	mr->mr_rkey = pkt.ioctl.out.rkey;
+
+	mr->ibmr.lkey = mr->mr_lkey;
+	mr->ibmr.rkey = be32_to_cpu(mr->mr_rkey);
+	hvnd_debug("ibmr registration lkey %x\n", mr->ibmr.lkey);
+	hvnd_debug("ibmr registration rkey  %x\n", mr->ibmr.rkey);
+
+	free_pages((unsigned long)pb, get_order(sz_leaf));
+	free_pages((unsigned long)tpb, get_order(desc_size));
+
+	return 0;
+
+err:
+	free_pages((unsigned long)pb, get_order(sz_leaf));
+	free_pages((unsigned long)tpb, get_order(desc_size));
+
+	hvnd_error("mr register failed: %d\n", ret);
+	return ret;
+}
+
+/*
+ * Listener operations.
+ */
+int hvnd_cr_listener(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+		     u64 *listener_handle)
+{
+	struct pkt_nd_cr_listener pkt;
+	int ret;
+
+	/* KYS try to avoid having to zero everything */
+	memset(&pkt, 0, sizeof(pkt));
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_LISTENER_CREATE, 0, 0, 0);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.hdr.version = ND_VERSION_1;
+	pkt.ioctl.in.hdr.handle = uctx->adaptor_hdl;
+	hvnd_debug("Adaptor handle is %p\n", (void *)uctx->adaptor_hdl);
+	pkt.ioctl.in.hdr.reserved = 0;
+	pkt.ioctl.in.to_semantics = false;
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr, sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	/*
+	 * Copy the listener handle.
+	 */
+	hvnd_debug("listener handle is %p\n", (void *)pkt.ioctl.out);
+	*listener_handle = pkt.ioctl.out;
+
+	return 0;
+
+err:
+	hvnd_error("create listener failed: ret=%d uctx=%p adaptor handle=%llu\n",
+		   ret, uctx, uctx->adaptor_hdl);
+	return ret;
+
+}
+
+int hvnd_free_listener(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 listener_handle)
+{
+	struct pkt_nd_free_listener pkt;
+	int ret;
+
+	memset(&pkt, 0, sizeof(pkt));
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_LISTENER_FREE, 0, 0, 0);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.version = ND_VERSION_1;
+	pkt.ioctl.in.handle = listener_handle;
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr, sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	hvnd_error("free listener failed: %d\n", ret);
+	return ret;
+}
+
+int hvnd_bind_listener(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 listener_handle, union nd_sockaddr_inet *addr)
+{
+	struct pkt_nd_bind_listener pkt;
+	kuid_t uid = current_uid();
+	int ret;
+
+	memset(&pkt, 0, sizeof(pkt));
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_LISTENER_BIND, 0, 0, 0);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.hdr.version = ND_VERSION_1;
+	pkt.ioctl.in.hdr.handle = listener_handle;
+	pkt.ioctl.in.hdr.reserved = 0;
+
+	pkt.ioctl.in.authentication_id = (u32)uid.val;
+	pkt.ioctl.in.is_admin = false;
+
+	memcpy(&pkt.ioctl.in.hdr.address, addr, sizeof(*addr));
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr, sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	hvnd_error("bind listener failed: %d\n", ret);
+	return ret;
+}
+
+int hvnd_listen_listener(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 listener_handle, u32 backlog)
+{
+	struct pkt_nd_listen_listener pkt;
+	int ret;
+
+	memset(&pkt, 0, sizeof(pkt));
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_LISTENER_LISTEN, 0, 0, 0);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.version = ND_VERSION_1;
+	pkt.ioctl.in.listener_handle = listener_handle;
+	pkt.ioctl.in.back_log = backlog;
+
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr, sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	hvnd_error("listen listener failed: %d\n", ret);
+	return ret;
+}
+
+int hvnd_get_addr_listener(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 listener_handle, union nd_sockaddr_inet *addr)
+{
+	struct pkt_nd_get_addr_listener pkt;
+	int ret;
+
+	/* KYS try to avoid having to zero everything */
+	memset(&pkt, 0, sizeof(pkt));
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_LISTENER_GET_ADDRESS, 0, 0, 0);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.version = ND_VERSION_1;
+	pkt.ioctl.in.handle = listener_handle;
+
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr, sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	/*
+	 * Copy the adddress.
+	 */
+
+	memcpy(addr, &pkt.ioctl.out, sizeof(union nd_sockaddr_inet));
+
+	return 0;
+
+err:
+	hvnd_error("listen listener failed: %d\n", ret);
+	return ret;
+}
+
+int hvnd_get_connection_listener(struct hvnd_dev *nd_dev,
+			struct hvnd_ucontext *uctx,
+			u64 listener_handle, u64 connector_handle,
+			u64 irp_handle)
+{
+	struct pkt_nd_get_connection_listener pkt;
+	int ret;
+	union ndv_context_handle irp_fhandle;
+
+	ret = get_irp_handle(nd_dev, &irp_fhandle.local, (void *)irp_handle);
+
+	if (ret) {
+		hvnd_error("get_irp_handle() failed: err: %d\n", ret);
+		return ret;
+	}
+
+	/* KYS try to avoid having to zero everything */
+	memset(&pkt, 0, sizeof(pkt));
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_LISTENER_GET_CONNECTION_REQUEST, 0, 0,
+		      irp_fhandle.val64);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.version = ND_VERSION_1;
+	pkt.ioctl.in.listener_handle = listener_handle;
+	pkt.ioctl.in.connector_handle = connector_handle;
+
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr, sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	hvnd_error("get connection listener failed: %d\n", ret);
+	return ret;
+}
+
+/*
+ * Connector APIs.
+ */
+
+int hvnd_cr_connector(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+		     u64 *connector_handle)
+{
+	struct pkt_nd_cr_connector pkt;
+	int ret;
+
+	memset(&pkt, 0, sizeof(pkt));
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(struct pkt_nd_cr_listener) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_CONNECTOR_CREATE, 0, 0, 0);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.hdr.version = ND_VERSION_1;
+	pkt.ioctl.in.hdr.handle = uctx->adaptor_hdl;
+	pkt.ioctl.in.to_semantics = false;
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr, sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	/*
+	 * Copy the listener handle.
+	 */
+	hvnd_debug("connector handle is %p\n", (void *)pkt.ioctl.out);
+	*connector_handle = pkt.ioctl.out;
+
+	return 0;
+
+err:
+	return ret;
+}
+
+int hvnd_free_connector(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 handle)
+{
+	struct pkt_nd_free_connector pkt;
+	int ret;
+
+	/* KYS try to avoid having to zero everything */
+	memset(&pkt, 0, sizeof(pkt));
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_CONNECTOR_FREE, 0, 0, 0);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.version = ND_VERSION_1;
+	pkt.ioctl.in.handle = handle;
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr, sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	return ret;
+}
+
+int hvnd_bind_connector(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 handle, union nd_sockaddr_inet *addr)
+{
+	struct pkt_nd_bind_connector pkt;
+	int ret;
+	kuid_t uid = current_uid();
+
+	/* KYS try to avoid having to zero everything */
+	memset(&pkt, 0, sizeof(pkt));
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_CONNECTOR_BIND, 0, 0, 0);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.hdr.version = ND_VERSION_1;
+	pkt.ioctl.in.hdr.handle = handle;
+
+	memcpy(&pkt.ioctl.in.hdr.address, addr, sizeof(*addr));
+
+	pkt.ioctl.in.authentication_id = (u32)uid.val;
+	pkt.ioctl.in.is_admin = false;
+
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr, sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	return ret;
+}
+
+int hvnd_connector_connect(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 connector_handle, u32 in_rd_limit, u32 out_rd_limit,
+			u32 priv_data_length, const u8 *priv_data,
+			u64 qp_handle, struct if_physical_addr *phys_addr,
+			union nd_sockaddr_inet *dest_addr,
+			struct hvnd_ep_obj *ep)
+{
+	struct pkt_nd_connector_connect *pkt = &ep->connector_connect_pkt;
+	int ret;
+	union ndv_context_handle irp_fhandle;
+
+	hvnd_debug("local irp is %d\n", ep->local_irp);
+	irp_fhandle.local = ep->local_irp;
+
+	if (priv_data_length > MAX_PRIVATE_DATA_LEN) {
+		hvnd_error("priv_data_length=%d\n", priv_data_length);
+		return -EINVAL;
+	}
+
+	/* KYS try to avoid having to zero everything */
+	memset(pkt, 0, sizeof(*pkt));
+	hvnd_init_hdr(&pkt->hdr,
+		      sizeof(*pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_CONNECTOR_CONNECT, 0, 0, irp_fhandle.val64);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt->ioctl.in.hdr.version = ND_VERSION_1;
+	pkt->ioctl.in.hdr.connector_handle = connector_handle;
+	pkt->ioctl.in.hdr.read_limits.inbound = in_rd_limit;
+	pkt->ioctl.in.hdr.read_limits.outbound = out_rd_limit;
+	pkt->ioctl.in.hdr.cb_private_data_length = priv_data_length;
+	pkt->ioctl.in.hdr.cb_private_data_offset =
+		offsetof(union connector_connect_ioctl, in.priv_data);
+	pkt->ioctl.in.hdr.qp_handle = qp_handle;
+
+	memcpy(&pkt->ioctl.in.hdr.phys_addr, phys_addr,
+		sizeof(struct if_physical_addr));
+
+	/*
+	 * Luke's code does not copy the ip address.
+	 */
+	memcpy(&pkt->ioctl.in.hdr.destination_address, dest_addr,
+		sizeof(union nd_sockaddr_inet));
+
+	pkt->ioctl.in.retry_cnt = 7;
+	pkt->ioctl.in.rnr_retry_cnt = 7;
+	memcpy(pkt->ioctl.in.priv_data, priv_data, priv_data_length);
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt->hdr, sizeof(*pkt), (u64)pkt);
+
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	return ret;
+}
+
+int hvnd_connector_complete_connect(struct hvnd_dev *nd_dev,
+				    struct hvnd_ucontext *uctx,
+				    u64 connector_handle,
+				    enum ibv_qp_state *qp_state)
+{
+	struct pkt_nd_connector_connect_complete pkt;
+	int ret;
+
+	memset(&pkt, 0, sizeof(pkt));
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_CONNECTOR_COMPLETE_CONNECT, 0, 0, 0);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.hdr.version = ND_VERSION_1;
+	pkt.ioctl.in.hdr.handle = connector_handle;
+	pkt.ioctl.in.rnr_nak_to = 0;
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr, sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	*qp_state = pkt.ioctl.out.state;
+	return 0;
+
+err:
+	return ret;
+}
+
+int hvnd_connector_accept(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 connector_handle,
+			u64 qp_handle,
+			u32 in_rd_limit, u32 out_rd_limit,
+			u32 priv_data_length, const u8 *priv_data,
+			enum ibv_qp_state *qp_state, struct hvnd_ep_obj *ep)
+{
+	struct pkt_nd_connector_accept pkt;
+	int ret;
+	union ndv_context_handle irp_fhandle;
+
+	irp_fhandle.local = ep->local_irp;
+
+	if (priv_data_length > MAX_PRIVATE_DATA_LEN) {
+		hvnd_error("priv_data_length=%d\n", priv_data_length);
+		return -EINVAL;
+	}
+
+	memset(&pkt, 0, sizeof(pkt));
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_CONNECTOR_ACCEPT, 0, 0, irp_fhandle.val64);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.hdr.version = ND_VERSION_1;
+	pkt.ioctl.in.hdr.reserved = 0;
+	pkt.ioctl.in.hdr.read_limits.inbound = in_rd_limit;
+	pkt.ioctl.in.hdr.read_limits.outbound = out_rd_limit;
+	pkt.ioctl.in.hdr.cb_private_data_length = priv_data_length;
+
+	pkt.ioctl.in.hdr.cb_private_data_offset =
+		offsetof(struct connector_accept_in, private_data);
+
+	pkt.ioctl.in.hdr.connector_handle = connector_handle;
+	pkt.ioctl.in.hdr.qp_handle = qp_handle;
+
+	pkt.ioctl.in.rnr_nak_to = 0;
+	pkt.ioctl.in.rnr_retry_cnt = 7;
+
+
+	memcpy(pkt.ioctl.in.private_data, priv_data, priv_data_length);
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr, sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	*qp_state = pkt.ioctl.out.state;
+	return 0;
+
+err:
+	return ret;
+}
+
+int hvnd_connector_reject(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 connector_handle,
+			u32 priv_data_length, u8 *priv_data,
+			enum ibv_qp_state *qp_state)
+{
+	struct pkt_nd_connector_reject pkt;
+	int ret;
+
+	if (priv_data_length > MAX_PRIVATE_DATA_LEN) {
+		hvnd_error("priv_data_length=%d\n", priv_data_length);
+		return -EINVAL;
+	}
+
+	/* KYS try to avoid having to zero everything */
+	memset(&pkt, 0, sizeof(pkt));
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_CONNECTOR_REJECT, 0, 0, 0);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.hdr.version = ND_VERSION_1;
+	pkt.ioctl.in.hdr.reserved = 0;
+	pkt.ioctl.in.hdr.cb_private_data_length = priv_data_length;
+
+	pkt.ioctl.in.hdr.cb_private_data_offset =
+		offsetof(struct connector_reject_in, private_data);
+
+	pkt.ioctl.in.hdr.connector_handle = connector_handle;
+
+	memcpy(pkt.ioctl.in.private_data, priv_data, priv_data_length);
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr, sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	*qp_state = pkt.ioctl.out.state;
+	return 0;
+
+err:
+	return ret;
+}
+
+int hvnd_connector_get_rd_limits(struct hvnd_dev *nd_dev,
+			struct hvnd_ucontext *uctx,
+			u64 connector_handle,
+			struct nd_read_limits *rd_limits)
+{
+	struct pkt_nd_connector_get_rd_limits pkt;
+	int ret;
+
+
+	memset(&pkt, 0, sizeof(pkt));
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_CONNECTOR_GET_READ_LIMITS, 0, 0, 0);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.in.version = ND_VERSION_1;
+	pkt.ioctl.in.in.reserved = 0;
+	pkt.ioctl.in.in.handle = connector_handle;
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr, sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	*rd_limits = pkt.ioctl.out.out;
+	return 0;
+
+err:
+	return ret;
+}
+
+int hvnd_connector_get_priv_data(struct hvnd_dev *nd_dev,
+			struct hvnd_ucontext *uctx,
+			u64 connector_handle,
+			u8 *priv_data)
+{
+	struct pkt_nd_connector_get_priv_data pkt;
+	int ret;
+
+
+	/* KYS try to avoid having to zero everything */
+	memset(&pkt, 0, sizeof(pkt));
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_CONNECTOR_GET_PRIVATE_DATA, 0, 0, 0);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.version = ND_VERSION_1;
+	pkt.ioctl.in.reserved = 0;
+	pkt.ioctl.in.handle = connector_handle;
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr, sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	memcpy(priv_data, pkt.ioctl.out, MAX_PRIVATE_DATA_LEN);
+	return 0;
+
+err:
+	return ret;
+}
+
+int hvnd_connector_get_peer_addr(struct hvnd_dev *nd_dev,
+			struct hvnd_ucontext *uctx,
+			u64 connector_handle,
+			union nd_sockaddr_inet *peer_addr)
+{
+	struct pkt_nd_connector_get_peer_addr pkt;
+	int ret;
+
+
+	/* KYS try to avoid having to zero everything */
+	memset(&pkt, 0, sizeof(pkt));
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_CONNECTOR_GET_PEER_ADDRESS, 0, 0, 0);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.version = ND_VERSION_1;
+	pkt.ioctl.in.reserved = 0;
+	pkt.ioctl.in.handle = connector_handle;
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr, sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	memcpy(peer_addr, &pkt.ioctl.out, sizeof(union nd_sockaddr_inet));
+	return 0;
+
+err:
+	return ret;
+}
+
+int hvnd_connector_get_local_addr(struct hvnd_dev *nd_dev,
+			struct hvnd_ucontext *uctx,
+			u64 connector_handle,
+			union nd_sockaddr_inet *addr)
+{
+	struct pkt_nd_connector_get_addr pkt;
+	int ret;
+
+
+	/* KYS try to avoid having to zero everything */
+	memset(&pkt, 0, sizeof(pkt));
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_CONNECTOR_GET_ADDRESS, 0, 0, 0);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.version = ND_VERSION_1;
+	pkt.ioctl.in.reserved = 0;
+	pkt.ioctl.in.handle = connector_handle;
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr, sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	memcpy(addr, &pkt.ioctl.out, sizeof(union nd_sockaddr_inet));
+	return 0;
+
+err:
+	return ret;
+}
+
+
+int hvnd_connector_notify_disconnect(struct hvnd_dev *nd_dev,
+			struct hvnd_ucontext *uctx,
+			u64 connector_handle, struct hvnd_ep_obj *ep)
+{
+	struct pkt_nd_connector_notify_disconnect pkt;
+	int ret;
+	union ndv_context_handle irp_fhandle;
+
+	irp_fhandle .local = ep->local_irp;
+
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_CONNECTOR_NOTIFY_DISCONNECT, 0, 0,
+		      irp_fhandle.val64);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.version = ND_VERSION_1;
+	pkt.ioctl.in.reserved = 0;
+	pkt.ioctl.in.handle = connector_handle;
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr, sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	return ret;
+}
+
+
+/* ASYNCH call */
+int hvnd_connector_disconnect(struct hvnd_dev *nd_dev,
+			struct hvnd_ucontext *uctx,
+			u64 connector_handle, struct hvnd_ep_obj *ep)
+{
+	struct pkt_nd_connector_disconnect pkt;
+	int ret;
+	union ndv_context_handle irp_fhandle;
+
+	irp_fhandle.local = ep->local_irp;
+
+
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_CONNECTOR_DISCONNECT, 0, 0, irp_fhandle.val64);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.version = ND_VERSION_1;
+	pkt.ioctl.in.reserved = 0;
+	pkt.ioctl.in.handle = connector_handle;
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr, sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	return ret;
+}
+
+/*
+ * QP operations.
+ */
+int hvnd_create_qp(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+		   struct hvnd_qp *qp)
+{
+	int ret;
+	struct pkt_nd_create_qp *pkt;
+	int num_pfn, num_db_pfn;
+	int qp_pkt_size;
+	unsigned int  offset;
+	u32 ext_data_offset;
+	u32 ext_data_size;
+
+	/*
+	 * Now create QP.
+	 * First compute the number of PFNs we need to accomodate:
+	 * One each for door bell and arm_sn and pages in cq buffer.
+	 */
+	offset = offset_in_page(qp->qp_buf);
+	num_pfn = DIV_ROUND_UP(offset + qp->buf_size, PAGE_SIZE);
+
+	offset = offset_in_page(qp->db_addr);
+	num_db_pfn = DIV_ROUND_UP(offset + 4, PAGE_SIZE);
+
+	qp_pkt_size = sizeof(struct pkt_nd_create_qp) +
+		(num_pfn  * sizeof(u64));
+
+	hvnd_debug("CREATE QP, num pfns is %d\n", num_pfn);
+	hvnd_debug("CREATE QP, num DB pfns is %d\n", num_db_pfn);
+
+	pkt = kzalloc(qp_pkt_size, GFP_KERNEL);
+
+	if (!pkt)
+		return -ENOMEM;
+
+	hvnd_debug("offset of nd_create_qp is %d\n",
+		(int)offsetof(struct pkt_nd_create_qp, ioctl.input));
+
+	ext_data_offset = offsetof(struct pkt_nd_create_qp, ext_data) -
+				sizeof(struct ndv_packet_hdr_control_1);
+
+	ext_data_size = sizeof(struct create_qp_ext_data) +
+			(num_pfn  * sizeof(u64));
+
+	hvnd_init_hdr(&pkt->hdr,
+		      qp_pkt_size -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_QP_CREATE,
+		      ext_data_size,
+		      ext_data_offset,
+		      0);
+
+	/*
+	 * Now fill out the ioctl section.
+	 */
+
+	pkt->ioctl.input.hdr.version = ND_VERSION_1;
+
+	if (qp->max_inline_data >
+		 nd_dev->query_pkt.ioctl.ad_info.inline_request_threshold) {
+			qp->max_inline_data =
+			nd_dev->query_pkt.ioctl.ad_info.inline_request_threshold;
+	}
+	pkt->ioctl.input.hdr.cb_max_inline_data = qp->max_inline_data;
+
+	hvnd_debug("pkt->ioctl.input.hdr.cb_max_inline_data=%d\n",
+		   pkt->ioctl.input.hdr.cb_max_inline_data);
+
+	pkt->ioctl.input.hdr.ce_mapping_cnt = MLX4_IB_CREATE_QP_MAPPINGS_MAX;
+	pkt->ioctl.input.hdr.cb_mapping_offset = sizeof(union create_qp_ioctl);
+
+	pkt->ioctl.input.hdr.initiator_queue_depth = qp->initiator_q_depth;
+	pkt->ioctl.input.hdr.max_initiator_request_sge =
+		qp->initiator_request_sge;
+
+	hvnd_debug("recv cq handle is %p\n", (void *)qp->receive_cq_handle);
+	hvnd_debug("send cq handle is %p\n", (void *)qp->initiator_cq_handle);
+	hvnd_debug("pd handle is %p\n", (void *)qp->pd_handle);
+	pkt->ioctl.input.hdr.receive_cq_handle = qp->receive_cq_handle;
+	pkt->ioctl.input.hdr.initiator_cq_handle = qp->initiator_cq_handle;
+	pkt->ioctl.input.hdr.pd_handle = qp->pd_handle;
+
+
+	hvnd_debug("ce_mapping cnt is %d\n",
+		   pkt->ioctl.input.hdr.ce_mapping_cnt);
+	hvnd_debug("cb_mapping offset is %d\n",
+		   pkt->ioctl.input.hdr.cb_mapping_offset);
+
+	pkt->ioctl.input.receive_queue_depth = qp->receive_q_depth;
+	pkt->ioctl.input.max_receive_request_sge = qp->receive_request_sge;
+
+
+	pkt->mappings.qp_in.mappings[MLX4_IB_CREATE_QP_BUF].
+		map_memory.map_type = ND_MAP_MEMORY;
+	pkt->mappings.qp_in.mappings[MLX4_IB_CREATE_QP_BUF].
+		map_memory.access_type = ND_MODIFY_ACCESS;
+	pkt->mappings.qp_in.mappings[MLX4_IB_CREATE_QP_BUF].
+		map_memory.address = (u64)qp->qp_buf;
+	pkt->mappings.qp_in.mappings[MLX4_IB_CREATE_QP_BUF].
+		map_memory.cb_length = qp->buf_size;
+
+	pkt->mappings.qp_in.mappings[MLX4_IB_CREATE_QP_DB].
+		map_memory.map_type = ND_MAP_MEMORY_COALLESCE;
+	pkt->mappings.qp_in.mappings[MLX4_IB_CREATE_QP_DB].
+		map_memory.access_type = ND_WRITE_ACCESS;
+	pkt->mappings.qp_in.mappings[MLX4_IB_CREATE_QP_DB].
+		map_memory.address = (u64)qp->db_addr;
+	pkt->mappings.qp_in.mappings[MLX4_IB_CREATE_QP_DB].
+		map_memory.cb_length = 4;
+
+	pkt->mappings.qp_in.log_sq_bb_count = qp->log_sq_bb_count;
+	pkt->mappings.qp_in.log_sq_stride = qp->log_sq_stride;
+	pkt->mappings.qp_in.sq_no_prefetch = qp->sq_no_prefetch;
+
+
+	/*
+	 * Fill in the extended data.
+	 */
+
+	pkt->ext_data.cnt = 2;
+	pkt->ext_data.fields[MLX4_IB_CREATE_QP_BUF].size =
+		sizeof(struct gpa_range) + (num_pfn * sizeof(u64));
+	pkt->ext_data.fields[MLX4_IB_CREATE_QP_BUF].offset =
+		offsetof(struct create_qp_ext_data, qpbuf_gpa);
+
+	pkt->ext_data.fields[MLX4_IB_CREATE_QP_DB].size =
+		sizeof(struct qp_db_gpa);
+	pkt->ext_data.fields[MLX4_IB_CREATE_QP_DB].offset =
+		offsetof(struct create_qp_ext_data, db_gpa);
+
+	/*
+	 * Fill up the gpa range for qp  buffer.
+	 */
+
+	pkt->ext_data.db_gpa.byte_count = 4;
+	pkt->ext_data.db_gpa.byte_offset = offset_in_page(qp->db_addr);
+	user_va_init_pfn(&pkt->ext_data.db_gpa.pfn_array[0], qp->db_umem);
+
+	pkt->ext_data.qpbuf_gpa.byte_count = qp->buf_size;
+	pkt->ext_data.qpbuf_gpa.byte_offset = offset_in_page(qp->qp_buf);
+	user_va_init_pfn(&pkt->ext_data.qpbuf_gpa.pfn_array[0], qp->umem);
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt->hdr, qp_pkt_size, (u64)pkt);
+
+	if (ret)
+		goto cr_qp_err;
+
+	/*
+	 * Copy the necessary response from the host.
+	 */
+	qp->qp_handle = pkt->ioctl.resrc_desc.handle;
+
+	qp->qpn = pkt->mappings.qp_resp.qpn;
+	qp->max_send_wr = pkt->mappings.qp_resp.max_send_wr;
+	qp->max_recv_wr = pkt->mappings.qp_resp.max_recv_wr;
+	qp->max_send_sge = pkt->mappings.qp_resp.max_send_sge;
+	qp->max_recv_sge = pkt->mappings.qp_resp.max_recv_sge;
+
+
+	hvnd_debug("qp->max_send_wr=%d max_recv_wr=%d max_send_sge=%d max_recv_sge=%d max_inline_data=%d\n",
+		   qp->max_send_wr, qp->max_recv_wr, qp->max_send_sge,
+		   qp->max_recv_sge, qp->max_inline_data);
+
+	ret = insert_handle(nd_dev, &nd_dev->qpidr, qp, qp->qpn);
+
+	if (ret)
+		goto cr_qp_err;
+
+	hvnd_debug("QP create after success qpn:%d qp:%p handle:%llu\n",
+		   qp->qpn, qp, qp->qp_handle);
+
+cr_qp_err:
+	kfree(pkt);
+	return ret;
+}
+
+int hvnd_free_qp(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+		 struct hvnd_qp *qp)
+{
+	int ret;
+	ret = hvnd_free_handle(nd_dev, uctx, qp->qp_handle, IOCTL_ND_QP_FREE);
+	if (ret == 0)
+		remove_handle(nd_dev, &nd_dev->qpidr, qp->qpn);
+	return ret;
+}
+
+int hvnd_flush_qp(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+		  struct hvnd_qp *qp)
+{
+	struct pkt_nd_flush_qp pkt;
+	int ret;
+
+	/* KYS try to avoid having to zero everything */
+	memset(&pkt, 0, sizeof(pkt));
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      IOCTL_ND_QP_FLUSH, 0, 0, 0);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.version = ND_VERSION_1;
+	pkt.ioctl.in.reserved = 0;
+	pkt.ioctl.in.handle = qp->qp_handle;
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr, sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	return ret;
+}
+
+
+int hvnd_bind_nic(struct hvnd_dev *nd_dev, bool un_bind)
+{
+	int ret;
+	int pkt_type = NDV_PKT_ID1_BIND;
+	char *ip_addr, *mac_addr;
+
+	ret = hvnd_get_ip_addr(&ip_addr, &mac_addr);
+	if (ret)
+		return ret;
+
+	/*
+	 * Send the bind information over to the host.
+	 * For now, we will have a single ip and MAC address that we
+	 * will deal with. Down the road we will need to expand support
+	 * for multiple IP and MAC addresses and also deal with changing
+	 * IP addresses.
+	 */
+
+	NDV_ADD_PACKET_OPTION(pkt_type, NDV_PACKET_OPTIONS_REQUIRES_PASSIVE);
+	hvnd_debug("bind packet type is %d ID:%d\n",
+		   pkt_type, NDV_PACKET_TYPE_ID(pkt_type));
+	nd_dev->bind_pkt.pkt_hdr.packet_type = pkt_type;
+
+	nd_dev->bind_pkt.pkt_hdr.hdr_sz = sizeof(struct ndv_pkt_hdr_bind_1);
+	hvnd_debug("bind packet size is %d\n",
+		   (int)sizeof(struct ndv_pkt_hdr_bind_1));
+	nd_dev->bind_pkt.pkt_hdr.data_sz = 0;
+	nd_dev->bind_pkt.unbind = un_bind;
+	nd_dev->bind_pkt.ip_address.address_family = AF_INET;
+	nd_dev->bind_pkt.ip_address.ipv4.sin_family = AF_INET;
+	nd_dev->bind_pkt.ip_address.ipv4.sin_port = 0;
+	nd_dev->bind_pkt.ip_address.ipv4.sin_addr.s_addr =
+		*(unsigned int *)ip_addr;
+
+	nd_dev->bind_pkt.phys_addr.length = ETH_ALEN;
+	memcpy(nd_dev->bind_pkt.phys_addr.addr, mac_addr, ETH_ALEN);
+
+	/*
+	 * This is the adapter handle; needs to be unique for each
+	 * MAC, ip address tuple.
+	 */
+	nd_dev->bind_pkt.guest_id = (u64)nd_dev;
+
+	ret = hvnd_send_packet(nd_dev, &nd_dev->bind_pkt,
+				sizeof(struct ndv_pkt_hdr_bind_1),
+				(u64)NULL,
+				true);
+	return ret;
+}
+
+int hvnd_init_resources(struct hvnd_dev *nd_dev)
+{
+	unsigned long mmio_sz;
+	struct resource *resrc;
+	int ret = -ENOMEM;
+
+	resrc = &iomem_resource;
+
+	mmio_sz = (nd_dev->hvdev->channel->offermsg.offer.mmio_megabytes *
+		   1024 * 1024);
+	nd_dev->mmio_sz = mmio_sz;
+	nd_dev->mmio_resource.name = KBUILD_MODNAME;
+	nd_dev->mmio_resource.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+
+	ret = allocate_resource(resrc, &nd_dev->mmio_resource,
+				mmio_sz, 0, -1, mmio_sz, NULL, NULL);
+
+	if (ret) {
+		hvnd_error("Unable to allocate mmio resources\n");
+		return ret;
+	}
+	hvnd_debug("MMIO start is %p\n", (void *)nd_dev->mmio_resource.start);
+
+	/*
+	 * Send the mmio information over to the host.
+	 */
+	nd_dev->resources.pkt_hdr.packet_type = NDV_PKT_ID1_INIT_RESOURCES;
+	nd_dev->resources.pkt_hdr.hdr_sz = sizeof(union ndv_packet_hdr);
+	nd_dev->resources.pkt_hdr.data_sz = 0;
+
+	nd_dev->resources.io_space_sz_mb = mmio_sz;
+	nd_dev->resources.io_space_start = nd_dev->mmio_resource.start;
+
+	ret = hvnd_send_packet(nd_dev, &nd_dev->resources,
+				sizeof(struct ndv_pkt_hdr_init_resources_1),
+				(u64)NULL,
+				true);
+	return ret;
+}
+
+int hvnd_query_adaptor(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx)
+{
+	struct pkt_nd_query_adaptor *pkt;
+	int ret;
+	int pkt_type;
+
+	hvnd_debug("Performing Adapter query nd_dev=%p\n", nd_dev);
+
+	/* check if there is a need to do query */
+	if (nd_dev->query_pkt_set)
+		return 0;
+
+	/* need a lock, multiple process can call this at the same time */
+
+	down(&nd_dev->query_pkt_sem);
+	if (nd_dev->query_pkt_set) {
+		up(&nd_dev->query_pkt_sem);
+		return 0;
+	}
+
+	/*
+	 * Now query the adaptor.
+	 */
+
+	pkt = &nd_dev->query_pkt;
+
+	pkt_type = NDV_PKT_ID1_CONTROL;
+	NDV_ADD_PACKET_OPTION(pkt_type, NDV_PACKET_OPTIONS_REQUIRES_PASSIVE);
+
+	pkt->hdr.pkt_hdr.packet_type = pkt_type;
+	pkt->hdr.pkt_hdr.hdr_sz = sizeof(struct ndv_packet_hdr_control_1);
+	pkt->hdr.pkt_hdr.data_sz = sizeof(struct pkt_nd_query_adaptor) -
+				   sizeof(struct ndv_packet_hdr_control_1);
+
+
+	pkt->hdr.file_handle.local = uctx->file_handle.local;
+	pkt->hdr.file_handle.remote = uctx->file_handle.remote;
+
+	pkt->hdr.irp_handle.val64 = 0;
+
+	pkt->hdr.io_cntrl_code = IOCTL_ND_ADAPTER_QUERY;
+	pkt->hdr.output_buf_sz = sizeof(struct nd_adap_query_ioctl);
+	pkt->hdr.input_buf_sz = sizeof(struct nd_adap_query_ioctl);
+	pkt->hdr.input_output_buf_offset = 0;
+	memset(&pkt->ioctl.ad_q, 0, sizeof(struct nd_adap_query_ioctl));
+
+	pkt->ioctl.ad_q.version = ND_VERSION_1;
+	pkt->ioctl.ad_q.info_version = ND_VERSION_2;
+	pkt->ioctl.ad_q.adapter_handle = uctx->adaptor_hdl;
+
+	ret = hvnd_send_packet(nd_dev, pkt,
+				sizeof(struct pkt_nd_query_adaptor),
+				(unsigned long)pkt, true);
+
+	hvnd_debug("pkt->ioctl.ad_info.inline_request_threshold=%d\n",
+		   pkt->ioctl.ad_info.inline_request_threshold);
+
+	/* how about host returning PENDING */
+	up(&nd_dev->query_pkt_sem);
+
+	if (ret)
+		return ret;
+
+	hvnd_debug("Query Adaptor Succeeded\n");
+	nd_dev->query_pkt_set = true;
+
+	return 0;
+}
+
+
+int  hvnd_create_pd(struct hvnd_ucontext *uctx, struct hvnd_dev *nd_dev,
+		    struct hvnd_ib_pd *hvnd_pd)
+{
+	struct pkt_nd_pd_create *pkt = &uctx->pd_cr_pkt;
+	int ret;
+	int pkt_type;
+
+	hvnd_debug("Create Protection Domain\n");
+
+	pkt_type = NDV_PKT_ID1_CONTROL;
+	NDV_ADD_PACKET_OPTION(pkt_type, NDV_PACKET_OPTIONS_REQUIRES_PASSIVE);
+
+	pkt->hdr.pkt_hdr.packet_type = pkt_type;
+	pkt->hdr.pkt_hdr.hdr_sz = sizeof(struct ndv_packet_hdr_control_1);
+	pkt->hdr.pkt_hdr.data_sz = sizeof(struct pkt_nd_pd_create) -
+				   sizeof(struct ndv_packet_hdr_control_1);
+
+	hvnd_debug("pdcreate packet size: %d\n",
+		   (int)sizeof(struct pkt_nd_pd_create));
+	hvnd_debug("pdcreate hdr size: %d\n",
+		   (int)sizeof(struct ndv_packet_hdr_control_1));
+	hvnd_debug("pdcreate data size: %d\n", pkt->hdr.pkt_hdr.data_sz);
+
+	pkt->hdr.file_handle.local = uctx->create_pkt.handle.local;
+	pkt->hdr.file_handle.remote = uctx->create_pkt.handle.remote;
+
+	hvnd_debug("create pd uctx is %p\n", uctx);
+	hvnd_debug("create pd local file is %d\n",
+		   uctx->create_pkt.handle.local);
+	hvnd_debug("create pd local file is %d\n",
+		   uctx->create_pkt.handle.remote);
+
+	pkt->hdr.irp_handle.val64 = 0;
+	pkt->hdr.io_cntrl_code = IOCTL_ND_PD_CREATE;
+
+	pkt->hdr.output_buf_sz = sizeof(struct nd_create_pd_ioctl);
+	pkt->hdr.input_buf_sz =  sizeof(struct nd_create_pd_ioctl);
+	pkt->hdr.input_output_buf_offset = 0;
+
+	hvnd_debug("output/input buf size: %d\n",
+		   pkt->hdr.output_buf_sz);
+	/*
+	 * Fill the ioctl section.
+	 */
+
+	pkt->ioctl.in.version = ND_VERSION_1;
+	pkt->ioctl.in.reserved = 0;
+	pkt->ioctl.in.handle = uctx->adaptor_hdl;
+
+
+	ret = hvnd_send_packet(nd_dev, pkt,
+				sizeof(struct pkt_nd_pd_create),
+				(unsigned long)pkt, true);
+
+	if (ret)
+		return ret;
+
+	if (pkt->hdr.pkt_hdr.status != 0) {
+		hvnd_error("Create PD failed; status is %d\n",
+			pkt->hdr.pkt_hdr.status);
+		return -EINVAL;
+	}
+	if (pkt->hdr.io_status != 0) {
+		hvnd_error("Create PD failed;io status is %d\n",
+			pkt->hdr.io_status);
+		return -EINVAL;
+	}
+
+	hvnd_debug("Create PD Succeeded\n");
+
+	hvnd_debug("pd_handle is %p\n", (void *)pkt->ioctl.resp.pd_handle);
+	hvnd_debug("pdn is %d\n", (int)pkt->ioctl.resp.pdn);
+
+	hvnd_pd->pdn = pkt->ioctl.resp.pdn;
+	hvnd_pd->handle = pkt->ioctl.out_handle;
+
+	return 0;
+}
+
+int hvnd_cancel_io(struct hvnd_ep_obj *ep_object)
+{
+	struct pkt_nd_cancel_io pkt;
+	int ret;
+	u32 ioctl;
+
+	switch (ep_object->type) {
+	case ND_LISTENER:
+		hvnd_debug("LISTENER I/O Cancelled\n");
+		ioctl = IOCTL_ND_LISTENER_CANCEL_IO;
+		break;
+	case ND_CONNECTOR:
+		hvnd_debug("CONNECTOR I/O Cancelled\n");
+		ioctl = IOCTL_ND_CONNECTOR_CANCEL_IO;
+		break;
+	case ND_MR:
+		hvnd_debug("MR I/O Cancelled\n");
+		ioctl = IOCTL_ND_MR_CANCEL_IO;
+		break;
+	case ND_CQ:
+		hvnd_debug("CQ I/O Cancelled\n");
+		ioctl = IOCTL_ND_CQ_CANCEL_IO;
+		break;
+	default:
+		hvnd_error("UNKNOWN object type\n");
+		return -EINVAL;
+	}
+
+	/* KYS try to avoid having to zero everything */
+	memset(&pkt, 0, sizeof(pkt));
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      ep_object->uctx->create_pkt.handle.local,
+		      ep_object->uctx->create_pkt.handle.remote,
+		      ioctl, 0, 0, 0);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.version = ND_VERSION_1;
+	pkt.ioctl.in.reserved = 0;
+	pkt.ioctl.in.handle = ep_object->ep_handle;
+	hvnd_debug("cancel io handle is %p\n", (void *)ep_object->ep_handle);
+
+	ret = hvnd_send_ioctl_pkt(ep_object->nd_dev, &pkt.hdr,
+				sizeof(pkt),
+				(u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	/*
+	 * Now that we have cancelled all I/Os,
+	 */
+
+	return 0;
+
+err:
+	hvnd_error("cancel I/O operation failed\n");
+	return ret;
+}
+
+
+int hvnd_free_handle(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 handle, u32 ioctl)
+{
+	struct pkt_nd_free_handle pkt;
+	int ret;
+
+	hvnd_debug("Freeing handle ioctl is %s; handle is %p\n",
+		hvnd_get_op_name(ioctl), (void *)handle);
+
+	hvnd_debug("uctx is %p\n", uctx);
+	hvnd_debug("nd_dev is %p\n", nd_dev);
+
+	/* KYS try to avoid having to zero everything */
+	memset(&pkt, 0, sizeof(pkt));
+	hvnd_init_hdr(&pkt.hdr,
+		      sizeof(pkt) -
+		      sizeof(struct ndv_packet_hdr_control_1),
+		      uctx->create_pkt.handle.local,
+		      uctx->create_pkt.handle.remote,
+		      ioctl, 0, 0, 0);
+
+	/*
+	 * Now fill in the ioctl section.
+	 */
+	pkt.ioctl.in.version = ND_VERSION_1;
+	pkt.ioctl.in.reserved = 0;
+	pkt.ioctl.in.handle = handle;
+
+	ret = hvnd_send_ioctl_pkt(nd_dev, &pkt.hdr, sizeof(pkt), (u64)&pkt);
+
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	hvnd_error("%s: ret=%d\n", __func__, ret);
+	return ret;
+}
+
+int hvnd_negotiate_version(struct hvnd_dev *nd_dev)
+{
+	union ndv_packet_init *pkt = &nd_dev->init_pkt;
+	int ret;
+
+	nd_dev->negotiated_version = NDV_PROTOCOL_VAERSION_INVALID;
+
+	pkt->packet_type = NDV_PACKET_TYPE_INIT;
+	pkt->protocol_version = NDV_PROTOCOL_VERSION_CURRENT;
+	pkt->flags = 0; /* KYS are the flags 0? */
+
+	ret = hvnd_send_packet(nd_dev, pkt,
+			       sizeof(union ndv_packet_init), (u64)NULL, true);
+
+	return ret;
+}
+
+void hvnd_callback(void *context)
+{
+	struct hv_device *dev = context;
+	struct hvnd_dev *nd_dev = hv_get_drvdata(dev);
+	int copy_sz = 0;
+	struct ndv_packet_hdr_control_1 *ctrl_hdr;
+	union ndv_packet_init *pkt_init;
+	u32 recvlen;
+	u32 local_irp;
+	u64 requestid;
+	u32 *pkt_type;
+	u32 pkt_id;
+	struct hvnd_ep_obj *ep_object;
+	struct incoming_pkt *incoming_pkt; /* Used only for asynch calls */
+	char *incoming_pkt_start;
+	struct vmpacket_descriptor *desc;
+	int status;
+	struct hvnd_cookie *hvnd_cookie;
+	unsigned long flags;
+
+	vmbus_recvpacket_raw(dev->channel, hvnd_recv_buffer,
+			 (PAGE_SIZE * 4), &recvlen, &requestid);
+
+	if (recvlen <= 0)
+		return;
+
+	desc = (struct vmpacket_descriptor *)hvnd_recv_buffer;
+	incoming_pkt_start = hvnd_recv_buffer + (desc->offset8 << 3);
+	recvlen -= desc->offset8 << 3;
+
+	pkt_type = (u32 *)incoming_pkt_start;
+	pkt_id = *pkt_type;
+	if (pkt_id != NDV_PACKET_TYPE_INIT)
+		pkt_id = NDV_PACKET_TYPE_ID(pkt_id);
+
+	switch (pkt_id) {
+	case NDV_PACKET_TYPE_INIT:
+		/*
+		 * Host is responding to our init packet.
+		 */
+		pkt_init = (union ndv_packet_init *)incoming_pkt_start;
+		nd_dev->negotiated_version = pkt_init->protocol_version;
+		copy_sz = 0;
+		break;
+
+	case NDV_PKT_ID1_INIT_RESOURCES:
+		copy_sz = 0;
+		break;
+
+	case NDV_PKT_ID1_BIND:
+		copy_sz = 0;
+		break;
+
+	case NDV_PKT_ID1_COMPLETE:
+		ctrl_hdr = (struct ndv_packet_hdr_control_1 *)
+			    incoming_pkt_start;
+		status = ctrl_hdr->io_status;
+
+		local_irp = ctrl_hdr->irp_handle.local;
+		ep_object = (struct hvnd_ep_obj *)
+			     map_irp_to_ctx(nd_dev, local_irp);
+
+		if (!ep_object) {
+			hvnd_error("irp could not be mapped; irp is %d ioctl is %s",
+				local_irp,
+				hvnd_get_op_name(ctrl_hdr->io_cntrl_code));
+			goto complete;
+		}
+
+		if (ctrl_hdr->io_cntrl_code != IOCTL_ND_CQ_NOTIFY)
+			hvnd_debug("completion packet; iostatus is %x, ioctl is %s",
+				   ctrl_hdr->io_status,
+				   hvnd_get_op_name(ctrl_hdr->io_cntrl_code));
+
+		switch (ctrl_hdr->io_cntrl_code) {
+
+		case IOCTL_ND_CQ_NOTIFY:
+			hvnd_process_cq_event_complete(ep_object, status);
+
+			ep_del_work_pending(ep_object);
+			goto complete;
+
+		case IOCTL_ND_CONNECTOR_ACCEPT:
+
+			hvnd_process_connector_accept(ep_object, status);
+
+			ep_del_work_pending(ep_object);
+			goto complete;
+
+		case IOCTL_ND_CONNECTOR_DISCONNECT:
+			hvnd_debug("disconnected: ep opj is %p; status: %d\n",
+				   ep_object, status);
+			hvnd_process_disconnect(ep_object, status);
+
+			ep_del_work_pending(ep_object);
+			goto complete;
+
+		default:
+			break;
+		}
+
+		/*
+		 * This is the completion notification;
+		 * the IRP cookie is the state through which
+		 * we will invoke the callback.
+		 */
+		incoming_pkt = (struct incoming_pkt *)
+		kmalloc(recvlen + sizeof(struct incoming_pkt), GFP_ATOMIC);
+		if (incoming_pkt == NULL) {
+			hvnd_error("Could not alloc memory in callback\n");
+			ep_del_work_pending(ep_object);
+			goto complete;
+		}
+		memcpy(incoming_pkt->pkt, incoming_pkt_start, recvlen);
+
+		spin_lock_irqsave(&ep_object->incoming_pkt_list_lock, flags);
+		list_add_tail(&incoming_pkt->list_entry,
+			      &ep_object->incoming_pkt_list);
+		spin_unlock_irqrestore(&ep_object->incoming_pkt_list_lock,
+					flags);
+
+		schedule_work(&ep_object->wrk.work);
+
+		goto complete;
+
+	case NDV_PKT_ID1_CREATE:
+		copy_sz = sizeof(struct ndv_pkt_hdr_create_1);
+		break;
+
+	case NDV_PKT_ID1_CLEANUP:
+		copy_sz = sizeof(struct ndv_pkt_hdr_cleanup_1);
+		break;
+
+	case NDV_PKT_ID1_CONTROL:
+		ctrl_hdr = (struct ndv_packet_hdr_control_1 *)
+			incoming_pkt_start;
+		status = ctrl_hdr->io_status;
+
+		if (ctrl_hdr->io_cntrl_code != IOCTL_ND_CQ_NOTIFY)
+			hvnd_debug("packet; iostatus is %x ioctl is %s",
+				ctrl_hdr->io_status,
+				hvnd_get_op_name(ctrl_hdr->io_cntrl_code));
+
+		switch (ctrl_hdr->io_cntrl_code) {
+
+		case IOCTL_ND_PROVIDER_INIT:
+			copy_sz = sizeof(struct pkt_nd_provider_ioctl);
+			break;
+
+		case IOCTL_ND_PROVIDER_BIND_FILE:
+			copy_sz = sizeof(struct pkt_nd_provider_ioctl);
+			break;
+
+		case IOCTL_ND_ADAPTER_OPEN:
+			copy_sz = sizeof(struct pkt_nd_open_adapter);
+			break;
+
+		case IOCTL_ND_ADAPTER_CLOSE:
+			copy_sz = sizeof(struct pkt_nd_free_handle);
+			break;
+
+		case IOCTL_ND_ADAPTER_QUERY:
+			copy_sz = sizeof(struct pkt_nd_query_adaptor);
+			break;
+
+		case IOCTL_ND_PD_CREATE:
+			copy_sz = sizeof(struct pkt_nd_pd_create);
+			break;
+
+		case IOCTL_ND_PD_FREE:
+			copy_sz = sizeof(struct pkt_nd_free_handle);
+			break;
+
+		case IOCTL_ND_CQ_CREATE:
+			copy_sz = sizeof(struct pkt_nd_create_cq);
+			break;
+
+		case IOCTL_ND_CQ_FREE:
+			copy_sz = sizeof(struct pkt_nd_free_cq);
+			break;
+
+		case IOCTL_ND_CQ_NOTIFY: /* FIXME check ep stop state */
+			local_irp = ctrl_hdr->irp_handle.local;
+			ep_object = (struct hvnd_ep_obj *)
+				    map_irp_to_ctx(nd_dev, local_irp);
+			if (!ep_object) {
+				hvnd_error("irp could not be mapped\n");
+				goto complete;
+				return;
+			}
+			copy_sz = sizeof(struct pkt_nd_notify_cq);
+			hvnd_process_cq_event_pending(ep_object, status);
+			goto complete;
+			return;
+
+		case IOCTL_ND_LISTENER_CREATE:
+			copy_sz = sizeof(struct pkt_nd_cr_listener);
+			break;
+
+		case IOCTL_ND_LISTENER_FREE:
+			copy_sz = sizeof(struct pkt_nd_free_listener);
+			break;
+
+		case IOCTL_ND_QP_FREE:
+			copy_sz = sizeof(struct pkt_nd_free_handle);
+			break;
+
+		case IOCTL_ND_CONNECTOR_CANCEL_IO:
+		case IOCTL_ND_MR_CANCEL_IO:
+		case IOCTL_ND_CQ_CANCEL_IO:
+		case IOCTL_ND_LISTENER_CANCEL_IO:
+			copy_sz = sizeof(struct pkt_nd_cancel_io);
+			break;
+
+		case IOCTL_ND_LISTENER_BIND:
+			copy_sz = sizeof(struct pkt_nd_bind_listener);
+			break;
+
+		case IOCTL_ND_LISTENER_LISTEN:
+			copy_sz = sizeof(struct pkt_nd_listen_listener);
+			break;
+
+		case IOCTL_ND_LISTENER_GET_ADDRESS:
+			copy_sz = sizeof(struct pkt_nd_get_addr_listener);
+			break;
+
+		case IOCTL_ND_LISTENER_GET_CONNECTION_REQUEST:
+			copy_sz = sizeof(struct pkt_nd_get_connection_listener);
+			goto complete; /* non-block */
+
+		case IOCTL_ND_CONNECTOR_CREATE:
+			copy_sz = sizeof(struct pkt_nd_cr_connector);
+			break;
+
+		case IOCTL_ND_CONNECTOR_FREE:
+			copy_sz = sizeof(struct pkt_nd_free_connector);
+			break;
+
+		case IOCTL_ND_CONNECTOR_BIND:
+			copy_sz = sizeof(struct pkt_nd_free_connector);
+			break;
+
+		case IOCTL_ND_CONNECTOR_CONNECT:
+			copy_sz = sizeof(struct pkt_nd_connector_connect);
+			goto complete; /* non-block */
+
+		case IOCTL_ND_CONNECTOR_COMPLETE_CONNECT:
+			copy_sz =
+			sizeof(struct pkt_nd_connector_connect_complete);
+			break;
+
+		case IOCTL_ND_CONNECTOR_ACCEPT:
+			copy_sz = sizeof(struct pkt_nd_connector_accept);
+			goto complete; /* non-block */
+
+		case IOCTL_ND_CONNECTOR_REJECT:
+			copy_sz = sizeof(struct pkt_nd_connector_reject);
+			break;
+
+		case IOCTL_ND_CONNECTOR_GET_READ_LIMITS:
+			copy_sz = sizeof(struct pkt_nd_connector_get_rd_limits);
+			break;
+
+		case IOCTL_ND_CONNECTOR_GET_PRIVATE_DATA:
+			copy_sz = sizeof(struct pkt_nd_connector_get_priv_data);
+			break;
+
+		case IOCTL_ND_CONNECTOR_GET_PEER_ADDRESS:
+			copy_sz = sizeof(struct pkt_nd_connector_get_peer_addr);
+			break;
+
+		case IOCTL_ND_CONNECTOR_GET_ADDRESS:
+			copy_sz = sizeof(struct pkt_nd_connector_get_addr);
+			break;
+
+		case IOCTL_ND_CONNECTOR_NOTIFY_DISCONNECT:
+			copy_sz = sizeof(
+				  struct pkt_nd_connector_notify_disconnect);
+			goto complete; /* non-block */
+
+		case IOCTL_ND_CONNECTOR_DISCONNECT:
+			hvnd_debug("IOCTL_ND_CONNECTOR_DISCONNECT\n");
+			copy_sz =
+			 sizeof(struct pkt_nd_connector_notify_disconnect);
+			goto complete; /* non-block*/
+
+		case IOCTL_ND_QP_CREATE:
+			copy_sz = sizeof(struct pkt_nd_create_qp);
+			break;
+
+		case IOCTL_ND_MR_CREATE:
+			copy_sz = sizeof(struct pkt_nd_create_mr);
+			break;
+
+		case IOCTL_ND_MR_FREE:
+			copy_sz = sizeof(struct pkt_nd_free_handle);
+			break;
+
+		case IOCTL_ND_MR_REGISTER:
+			copy_sz = sizeof(struct pkt_nd_register_mr);
+			break;
+
+		case IOCTL_ND_MR_DEREGISTER:
+			copy_sz = sizeof(struct pkt_nd_deregister_mr);
+			break;
+
+		case IOCTL_ND_ADAPTER_QUERY_ADDRESS_LIST:
+			copy_sz = sizeof(struct pkt_query_addr_list);
+			break;
+
+		case IOCTL_ND_QP_FLUSH:
+			copy_sz = sizeof(struct pkt_nd_flush_qp);
+			break;
+
+		default:
+			hvnd_warn("Got unknown ioctl: %d\n",
+				ctrl_hdr->io_cntrl_code);
+			copy_sz = 0;
+			break;
+		}
+
+		break;
+	default:
+		hvnd_warn("Got an unknown packet type %d\n", *pkt_type);
+		break;
+	}
+
+	hvnd_cookie = (struct hvnd_cookie *)requestid;
+	memcpy(hvnd_cookie->pkt, incoming_pkt_start, copy_sz);
+	complete(&hvnd_cookie->host_event);
+
+complete:
+	/* send out ioctl completion patcket */
+	if (desc->flags & VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED) {
+		int retry = 5;
+		while (true) {
+			int ret;
+			ret = vmbus_sendpacket(dev->channel, NULL, 0,
+					       requestid, VM_PKT_COMP, 0);
+			if (ret == 0) {
+				break;
+			} else if (ret == -EAGAIN) {
+				if (--retry == 0) {
+					hvnd_error("give up retrying send completion packet\n");
+					break;
+				}
+				hvnd_warn("retrying send completion packet\n");
+				udelay(100);
+			} else {
+				hvnd_error("unable to send completion packet ret=%d\n", ret);
+				break;
+			}
+		}
+	}
+
+}
diff --git a/drivers/infiniband/hw/vmbus-nd/vmbus_rdma.h b/drivers/infiniband/hw/vmbus-nd/vmbus_rdma.h
new file mode 100644
index 0000000..ef956e0
--- /dev/null
+++ b/drivers/infiniband/hw/vmbus-nd/vmbus_rdma.h
@@ -0,0 +1,2205 @@
+/*
+ * Copyright (c) 2014, Microsoft Corporation.
+ *
+ * Author:
+ *   K. Y. Srinivasan <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * Bug fixes/enhancements: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
+ */
+
+
+#ifndef _VMBUS_RDMA_H
+#define _VMBUS_RDMA_H
+
+
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <rdma/ib_verbs.h>
+#include <linux/idr.h>
+
+/* NetworkDirect version Numbers.
+ */
+#define ND_VERSION_1    0x1
+#define ND_VERSION_2    0x20000
+
+#ifndef NDVER
+#define NDVER      ND_VERSION_2
+#endif
+
+#define ND_ADAPTER_FLAG_IN_ORDER_DMA_SUPPORTED              0x00000001
+#define ND_ADAPTER_FLAG_CQ_INTERRUPT_MODERATION_SUPPORTED   0x00000004
+#define ND_ADAPTER_FLAG_MULTI_ENGINE_SUPPORTED              0x00000008
+#define ND_ADAPTER_FLAG_CQ_RESIZE_SUPPORTED                 0x00000100
+#define ND_ADAPTER_FLAG_LOOPBACK_CONNECTIONS_SUPPORTED      0x00010000
+
+#define ND_CQ_NOTIFY_ERRORS                                 0
+#define ND_CQ_NOTIFY_ANY                                    1
+#define ND_CQ_NOTIFY_SOLICITED                              2
+
+#define ND_MR_FLAG_ALLOW_LOCAL_WRITE                        0x00000001
+#define ND_MR_FLAG_ALLOW_REMOTE_READ                        0x00000002
+#define ND_MR_FLAG_ALLOW_REMOTE_WRITE                       0x00000005
+#define ND_MR_FLAG_RDMA_READ_SINK                           0x00000008
+#define ND_MR_FLAG_DO_NOT_SECURE_VM                         0x80000000
+
+#define ND_OP_FLAG_SILENT_SUCCESS                           0x00000001
+#define ND_OP_FLAG_READ_FENCE                               0x00000002
+#define ND_OP_FLAG_SEND_AND_SOLICIT_EVENT                   0x00000004
+#define ND_OP_FLAG_ALLOW_READ                               0x00000008
+#define ND_OP_FLAG_ALLOW_WRITE                              0x00000010
+
+#if NDVER >= ND_VERSION_2
+#define ND_OP_FLAG_INLINE                                   0x00000020
+#endif
+
+#define ND_AF_INET6	23
+#define IF_MAX_ADDR_LENGTH 32
+
+struct group_affinity {
+	u64 mask; /* KYS: usually 0 */
+	u16 group; /* KYS usually -1 */
+	u16 reserved[3];
+};
+
+struct if_physical_addr {
+	u16 length;
+	u8 addr[IF_MAX_ADDR_LENGTH];
+};
+
+struct adapter_info_v2 {
+	u32 info_version;
+	u16 vendor_id;
+	u16 device_id;
+	u64 adapter_id;
+	size_t max_registration_size;
+	size_t max_window_size;
+	u32 max_initiator_sge;
+	u32 max_recv_sge;
+	u32 max_read_sge;
+	u32 max_transfer_length;
+	u32 max_inline_data_size;
+	u32 max_inbound_read_limit;
+	u32 max_outbound_read_limit;
+	u32 max_recv_q_depth;
+	u32 max_initiator_q_depth;
+	u32 max_shared_recv_q_depth;
+	u32 max_completion_q_depth;
+	u32 inline_request_threshold;
+	u32 large_request_threshold;
+	u32 max_caller_data;
+	u32 max_callee_data;
+	u32 adapter_flags;
+} __packed;
+
+struct nd2_adapter_info_32 {
+	u32 info_version;
+	u16 vendor_id;
+	u16 devic_id;
+	u64 adapter_id;
+	u32 max_registration_size;
+	u32 max_window_size;
+	u32 max_initiator_sge;
+	u32 max_recv_sge;
+	u32 max_read_sge;
+	u32 max_transfer_length;
+	u32 max_inline_data_size;
+	u32 max_inbound_read_limit;
+	u32 max_outbound_read_limit;
+	u32 max_recv_q_depth;
+	u32 max_initiator_q_depth;
+	u32 max_shared_recv_q_depth;
+	u32 max_completion_q_depth;
+	u32 inline_request_threshold;
+	u32 large_request_threshold;
+	u32 max_caller_data;
+	u32 max_callee_data;
+	u32 adapter_flags;
+} __packed;
+
+enum nd2_request_type {
+	ND2_RT_RECEIVE,
+	ND2_RT_SEND,
+	ND2_RT_BIND,
+	ND2_RT_INVALIDATE,
+	ND2_RT_READ,
+	ND2_RT_WRITE
+};
+
+struct nd2_result {
+	u32 status;
+	u32 bytes_transferred;
+	void *qp_ctx;
+	void *request_ctx;
+	enum nd2_request_type request_type;
+} __packed;
+
+struct nd2_sge {
+	void *buffer;
+	u32 buffer_length;
+	u32 mr_token;
+} __packed;
+
+/*
+ * The communication with the host via ioctls using VMBUS
+ * as the transport.
+ */
+
+#define ND_IOCTL_VERSION    1
+
+enum nd_mapping_type {
+	ND_MAP_IOSPACE,
+	ND_MAP_MEMORY,
+	ND_MAP_MEMORY_COALLESCE,
+	ND_MAP_PAGES,
+	ND_MAP_PAGES_COALLESCE,
+	ND_UNMAP_IOSPACE,
+	ND_UNMAP_MEMORY,
+	ND_MAX_MAP_TYPE
+};
+
+enum nd_caching_type {
+	ND_NON_CACHED = 0,
+	ND_CACHED,
+	ND_WRITE_COMBINED,
+	ND_MAX_CACHE_TYPE
+};
+
+enum nd_aceess_type {
+	ND_READ_ACCESS = 0,
+	ND_WRITE_ACCESS,
+	ND_MODIFY_ACCESS
+};
+
+struct nd_map_io_space {
+	enum nd_mapping_type map_type;
+	enum nd_caching_type cache_type;
+	u32 cb_length;
+};
+
+struct nd_map_memory {
+	enum nd_mapping_type map_type;
+	enum nd_aceess_type access_type;
+	u64 address;
+	u32 cb_length;
+};
+
+struct nd_mapping_id {
+	enum nd_mapping_type map_type;
+	u64 id;
+};
+
+struct ndk_map_pages {
+	struct nd_map_memory header;
+	u32 page_offset;
+};
+
+union nd_mapping {
+	enum nd_mapping_type map_type;
+	struct nd_map_io_space map_io_space;
+	struct nd_map_memory map_memory;
+	struct nd_mapping_id mapping_id;
+	struct ndk_map_pages map_pages;
+};
+
+struct nd_mapping_result {
+	u64 id;
+	u64 info;
+};
+
+struct nd_resource_descriptor {
+	u64 handle;
+	u32 ce_mapping_results;
+	u32 cb_mapping_results_offset;
+};
+
+struct nd_handle {
+	u32 version;
+	u32 reserved;
+	u64 handle;
+};
+
+union nd_sockaddr_inet {
+	struct sockaddr_in ipv4;
+	struct sockaddr_in6 ipv6;
+	u16 address_family;
+};
+
+struct nd_address_element {
+	union nd_sockaddr_inet addr;
+	char mac_addr[ETH_ALEN];
+};
+
+struct nd_resolve_address {
+	u32 version;
+	u32 reserved;
+	union nd_sockaddr_inet address;
+};
+
+struct nd_open_adapter {
+	u32 version;
+	u32 reserved;
+	u32 ce_mapping_cnt;
+	u32 cb_mapping_offset;
+	u64 adapter_id;
+};
+
+struct nd_adapter_query {
+	u32 version;
+	u32 info_version;
+	u64 adapter_handle;
+};
+
+struct nd_create_cq {
+	u32 version;
+	u32 queue_depth;
+	u32 ce_mapping_cnt;
+	u32 cb_mapping_offset;
+	u64 adapter_handle;
+	struct group_affinity affinity;
+};
+
+struct nd_create_srq {
+	u32 version;
+	u32 queue_depth;
+	u32 ce_mapping_cnt;
+	u32 cb_mapping_offset;
+	u32 max_request_sge;
+	u32 notify_threshold;
+	u64 pd_handle;
+	struct group_affinity affinity;
+};
+
+struct nd_create_qp_hdr {
+	u32 version;
+	u32 cb_max_inline_data;
+	u32 ce_mapping_cnt;
+	u32 cb_mapping_offset;
+	u32 initiator_queue_depth;
+	u32 max_initiator_request_sge;
+	u64 receive_cq_handle;
+	u64 initiator_cq_handle;
+	u64 pd_handle;
+};
+
+struct nd_create_qp {
+	struct nd_create_qp_hdr hdr;
+	u32 receive_queue_depth;
+	u32 max_receive_request_sge;
+};
+
+struct nd_create_qp_with_srq {
+	struct nd_create_qp_hdr header;
+	u64 srq_handle;
+};
+
+struct nd_srq_modify {
+	u32 version;
+	u32 queue_depth;
+	u32 ce_mapping_cnt;
+	u32 cb_mapping_offset;
+	u32 notify_threshold;
+	u32 reserved;
+	u64 srq_handle;
+};
+
+struct nd_cq_modify {
+	u32 version;
+	u32 queue_depth;
+	u32 ce_mapping_count;
+	u32 cb_mappings_offset;
+	u64 cq_handle;
+};
+
+struct nd_cq_notify {
+	u32 version;
+	u32 type;
+	u64 cq_handle;
+};
+
+struct nd_mr_register_hdr {
+	u32 version;
+	u32 flags;
+	u64 cb_length;
+	u64 target_addr;
+	u64 mr_handle;
+};
+
+struct nd_mr_register {
+	struct nd_mr_register_hdr header;
+	u64 address;
+};
+
+struct nd_bind {
+	u32 version;
+	u32 reserved;
+	u64 handle;
+	union nd_sockaddr_inet address;
+};
+
+struct nd_read_limits {
+	u32 inbound;
+	u32 outbound;
+};
+
+struct nd_connect {
+	u32 version;
+	u32 reserved;
+	struct nd_read_limits read_limits;
+	u32 cb_private_data_length;
+	u32 cb_private_data_offset;
+	u64 connector_handle;
+	u64 qp_handle;
+	union nd_sockaddr_inet destination_address;
+	struct if_physical_addr phys_addr;
+};
+
+struct nd_accept {
+	u32 version;
+	u32 reserved;
+	struct nd_read_limits read_limits;
+	u32 cb_private_data_length;
+	u32 cb_private_data_offset;
+	u64 connector_handle;
+	u64 qp_handle;
+};
+
+struct nd_reject {
+	u32 version;
+	u32 reserved;
+	u32 cb_private_data_length;
+	u32 cb_private_data_offset;
+	u64 connector_handle;
+};
+
+struct nd_listen {
+	u32 version;
+	u32 back_log;
+	u64 listener_handle;
+};
+
+struct nd_get_connection_request {
+	u32 version;
+	u32 reserved;
+	u64 listener_handle;
+	u64 connector_handle;
+};
+
+enum ndv_mmio_type {
+	ND_PARTITION_KERNEL_VIRTUAL,
+	ND_PARTITION_SYSTEM_PHYSICAL,
+	ND_PARTITION_GUEST_PHYSICAL,
+	ND_MAXIMUM_MMIO_TYPE
+};
+
+struct ndv_resolve_adapter_id {
+	u32 version;
+	struct if_physical_addr phys_addr;
+};
+
+struct ndv_partition_create {
+	u32 version;
+	enum ndv_mmio_type mmio_type;
+	u64 adapter_id;
+	u64 xmit_cap;
+};
+
+struct ndv_partition_bind_luid {
+	u32 version;
+	u32 reserved;
+	u64 partition_handle;
+	struct if_physical_addr phys_addr;
+	/*IF_LUID luid;*/
+};
+
+struct ndv_partition_bind_address {
+	u32 version;
+	u32 reserved;
+	u64 partition_handle;
+	union nd_sockaddr_inet address;
+	struct if_physical_addr guest_phys_addr;
+	struct if_physical_addr phys_addr;
+};
+
+struct ndk_mr_register {
+	struct nd_mr_register_hdr hdr;
+	u32 cb_logical_page_addresses_offset;
+};
+
+struct ndk_bind {
+	struct nd_bind hdr;
+	u64 authentication_id;
+	bool is_admin;
+};
+
+#define FDN 0x12
+#define METHOD_BUFFERED 0x0
+#define FAA 0x0
+
+#define CTL_CODE(DeviceType, Function, Method, Access) ( \
+	((DeviceType) << 16) | ((Access) << 14) | ((Function) << 2) | (Method) \
+)
+
+#define ND_FUNCTION(r_, i_)    ((r_) << 6 | (i_))
+#define IOCTL_ND(r_, i_) \
+		 CTL_CODE(FDN, ND_FUNCTION((r_), (i_)), METHOD_BUFFERED, FAA)
+
+#define ND_FUNCTION_FROM_CTL_CODE(ctrlCode_)     ((ctrlCode_ >> 2) & 0xFFF)
+#define ND_RESOURCE_FROM_CTL_CODE(ctrlCode_)     (ND_FUNCTION_FROM_CTL_CODE(ctrlCode_) >> 6)
+#define ND_OPERATION_FROM_CTRL_CODE(ctrlCode_)   (ND_FUNCTION_FROM_CTL_CODE(ctrlCode_) & 0x3F)
+
+#define ND_DOS_DEVICE_NAME L"\\DosDevices\\Global\\NetworkDirect"
+#define ND_WIN32_DEVICE_NAME L"\\\\.\\NetworkDirect"
+
+enum nd_resource_type {
+	ND_PROVIDER = 0,
+	ND_ADAPTER,
+	ND_PD,
+	ND_CQ,
+	ND_MR,
+	ND_MW,
+	ND_SRQ,
+	ND_CONNECTOR,
+	ND_LISTENER,
+	ND_QP,
+	ND_VIRTUAL_PARTITION,
+	ND_RESOURCE_TYPE_COUNT
+};
+
+#define ND_OPERATION_COUNT 14
+
+#define IOCTL_ND_PROVIDER(i_)		IOCTL_ND(ND_PROVIDER, i_)
+#define IOCTL_ND_ADAPTER(i_)		IOCTL_ND(ND_ADAPTER, i_)
+#define IOCTL_ND_PD(i_)			IOCTL_ND(ND_PD, i_)
+#define IOCTL_ND_CQ(i_)			IOCTL_ND(ND_CQ, i_)
+#define IOCTL_ND_MR(i_)			IOCTL_ND(ND_MR, i_)
+#define IOCTL_ND_MW(i_)			IOCTL_ND(ND_MW, i_)
+#define IOCTL_ND_SRQ(i_)		IOCTL_ND(ND_SRQ, i_)
+#define IOCTL_ND_CONNECTOR(i_)		IOCTL_ND(ND_CONNECTOR, i_)
+#define IOCTL_ND_LISTENER(i_)		IOCTL_ND(ND_LISTENER, i_)
+#define IOCTL_ND_QP(i_)			IOCTL_ND(ND_QP, i_)
+#define IOCTL_ND_VIRTUAL_PARTITION(i_)	IOCTL_ND(ND_VIRTUAL_PARTITION, i_)
+
+/* Provider IOCTLs */
+#define IOCTL_ND_PROVIDER_INIT				IOCTL_ND_PROVIDER(0)
+#define IOCTL_ND_PROVIDER_BIND_FILE			IOCTL_ND_PROVIDER(1)
+#define IOCTL_ND_PROVIDER_QUERY_ADDRESS_LIST		IOCTL_ND_PROVIDER(2)
+#define IOCTL_ND_PROVIDER_RESOLVE_ADDRESS		IOCTL_ND_PROVIDER(3)
+#define IOCTL_ND_PROVIDER_MAX_OPERATION			4
+
+/* Adapter IOCTLs */
+#define IOCTL_ND_ADAPTER_OPEN				IOCTL_ND_ADAPTER(0)
+#define IOCTL_ND_ADAPTER_CLOSE				IOCTL_ND_ADAPTER(1)
+#define IOCTL_ND_ADAPTER_QUERY				IOCTL_ND_ADAPTER(2)
+#define IOCTL_ND_ADAPTER_QUERY_ADDRESS_LIST		IOCTL_ND_ADAPTER(3)
+#define IOCTL_ND_ADAPTER_MAX_OPERATION			4
+
+/* Protection Domain IOCTLs */
+#define IOCTL_ND_PD_CREATE				IOCTL_ND_PD(0)
+#define IOCTL_ND_PD_FREE				IOCTL_ND_PD(1)
+#define IOCTL_ND_PD_MAX_OPERATION			2
+
+/* Completion Queue IOCTLs */
+#define IOCTL_ND_CQ_CREATE				IOCTL_ND_CQ(0)
+#define IOCTL_ND_CQ_FREE				IOCTL_ND_CQ(1)
+#define IOCTL_ND_CQ_CANCEL_IO				IOCTL_ND_CQ(2)
+#define IOCTL_ND_CQ_GET_AFFINITY			IOCTL_ND_CQ(3)
+#define IOCTL_ND_CQ_MODIFY				IOCTL_ND_CQ(4)
+#define IOCTL_ND_CQ_NOTIFY				IOCTL_ND_CQ(5)
+#define IOCTL_ND_CQ_MAX_OPERATION			6
+
+/* Memory Region IOCTLs */
+#define IOCTL_ND_MR_CREATE				IOCTL_ND_MR(0)
+#define IOCTL_ND_MR_FREE				IOCTL_ND_MR(1)
+#define IOCTL_ND_MR_CANCEL_IO				IOCTL_ND_MR(2)
+#define IOCTL_ND_MR_REGISTER				IOCTL_ND_MR(3)
+#define IOCTL_ND_MR_DEREGISTER				IOCTL_ND_MR(4)
+#define IOCTL_NDK_MR_REGISTER				IOCTL_ND_MR(5)
+#define IOCTL_ND_MR_MAX_OPERATION			6
+
+/* Memory Window IOCTLs */
+#define IOCTL_ND_MW_CREATE				IOCTL_ND_MW(0)
+#define IOCTL_ND_MW_FREE				IOCTL_ND_MW(1)
+#define IOCTL_ND_MW_MAX_OPERATION			2
+
+/* Shared Receive Queue IOCTLs */
+#define IOCTL_ND_SRQ_CREATE				IOCTL_ND_SRQ(0)
+#define IOCTL_ND_SRQ_FREE				IOCTL_ND_SRQ(1)
+#define IOCTL_ND_SRQ_CANCEL_IO				IOCTL_ND_SRQ(2)
+#define IOCTL_ND_SRQ_GET_AFFINITY			IOCTL_ND_SRQ(3)
+#define IOCTL_ND_SRQ_MODIFY				IOCTL_ND_SRQ(4)
+#define IOCTL_ND_SRQ_NOTIFY				IOCTL_ND_SRQ(5)
+#define IOCTL_ND_SRQ_MAX_OPERATION			6
+
+/* Connector IOCTLs */
+#define IOCTL_ND_CONNECTOR_CREATE			IOCTL_ND_CONNECTOR(0)
+#define IOCTL_ND_CONNECTOR_FREE				IOCTL_ND_CONNECTOR(1)
+#define IOCTL_ND_CONNECTOR_CANCEL_IO			IOCTL_ND_CONNECTOR(2)
+#define IOCTL_ND_CONNECTOR_BIND				IOCTL_ND_CONNECTOR(3)
+#define IOCTL_ND_CONNECTOR_CONNECT			IOCTL_ND_CONNECTOR(4)
+#define IOCTL_ND_CONNECTOR_COMPLETE_CONNECT		IOCTL_ND_CONNECTOR(5)
+#define IOCTL_ND_CONNECTOR_ACCEPT			IOCTL_ND_CONNECTOR(6)
+#define IOCTL_ND_CONNECTOR_REJECT			IOCTL_ND_CONNECTOR(7)
+#define IOCTL_ND_CONNECTOR_GET_READ_LIMITS		IOCTL_ND_CONNECTOR(8)
+#define IOCTL_ND_CONNECTOR_GET_PRIVATE_DATA		IOCTL_ND_CONNECTOR(9)
+#define IOCTL_ND_CONNECTOR_GET_PEER_ADDRESS		IOCTL_ND_CONNECTOR(10)
+#define IOCTL_ND_CONNECTOR_GET_ADDRESS			IOCTL_ND_CONNECTOR(11)
+#define IOCTL_ND_CONNECTOR_NOTIFY_DISCONNECT		IOCTL_ND_CONNECTOR(12)
+#define IOCTL_ND_CONNECTOR_DISCONNECT			IOCTL_ND_CONNECTOR(13)
+#define IOCTL_ND_CONNECTOR_MAX_OPERATION		14
+
+/* Listener IOCTLs */
+#define IOCTL_ND_LISTENER_CREATE			IOCTL_ND_LISTENER(0)
+#define IOCTL_ND_LISTENER_FREE				IOCTL_ND_LISTENER(1)
+#define IOCTL_ND_LISTENER_CANCEL_IO			IOCTL_ND_LISTENER(2)
+#define IOCTL_ND_LISTENER_BIND				IOCTL_ND_LISTENER(3)
+#define IOCTL_ND_LISTENER_LISTEN			IOCTL_ND_LISTENER(4)
+#define IOCTL_ND_LISTENER_GET_ADDRESS			IOCTL_ND_LISTENER(5)
+#define IOCTL_ND_LISTENER_GET_CONNECTION_REQUEST	IOCTL_ND_LISTENER(6)
+#define IOCTL_ND_LISTENER_MAX_OPERATION			7
+
+/* Queue Pair IOCTLs */
+#define IOCTL_ND_QP_CREATE				IOCTL_ND_QP(0)
+#define IOCTL_ND_QP_CREATE_WITH_SRQ			IOCTL_ND_QP(1)
+#define IOCTL_ND_QP_FREE				IOCTL_ND_QP(2)
+#define IOCTL_ND_QP_FLUSH				IOCTL_ND_QP(3)
+#define IOCTL_ND_QP_MAX_OPERATION			4
+
+/* Kernel-mode only IOCTLs (IRP_MJ_INTERNAL_DEVICE_CONTROL) */
+#define IOCTL_NDV_PARTITION_RESOLVE_ADAPTER_ID	IOCTL_ND_VIRTUAL_PARTITION(0)
+#define IOCTL_NDV_PARTITION_CREATE		IOCTL_ND_VIRTUAL_PARTITION(1)
+#define IOCTL_NDV_PARTITION_FREE		IOCTL_ND_VIRTUAL_PARTITION(2)
+#define IOCTL_NDV_PARTITION_BIND		IOCTL_ND_VIRTUAL_PARTITION(3)
+#define IOCTL_NDV_PARTITION_UNBIND		IOCTL_ND_VIRTUAL_PARTITION(4)
+#define IOCTL_NDV_PARTITION_BIND_LUID		IOCTL_ND_VIRTUAL_PARTITION(5)
+#define IOCTL_NDV_PARTITION_MAX_OPERATION	6
+
+
+#define MB_SHIFT 20
+
+
+/* Ringbuffer size for the channel */
+#define NDV_NUM_PAGES_IN_RING_BUFFER 64
+
+#define NDV_MAX_PACKETS_PER_RECEIVE 8
+
+#define NDV_MAX_PACKET_COUNT    16304
+
+#define NDV_MAX_NUM_OUTSTANDING_RECEIVED_PACKETS (16304)
+#define NDV_MAX_HANDLE_TABLE_SIZE (16304)
+#define NDV_HOST_MAX_HANDLE_TABLE_SIZE (NDV_MAX_HANDLE_TABLE_SIZE * 16)
+
+
+#define NDV_MAX_MAPPINGS 4
+
+#define NDV_STATE_NONE			0x00000000
+#define NDV_STATE_CREATED		0x00000001
+#define NDV_STATE_CONNECTING		0x00000002
+#define NDV_STATE_INITIALIZING		0x00000003
+#define NDV_STATE_OPERATIONAL		0xEFFFFFFF
+#define NDV_STATE_FAILED		0xFFFFFFFF
+
+
+#define NDV_MAX_PRIVATE_DATA_SIZE 64
+#define NDV_MAX_IOCTL_SIZE        256
+
+/* max size of buffer for vector of ND_MAPPING */
+#define NDV_MAX_MAPPING_BUFFER_SIZE \
+	(NDV_MAX_MAPPINGS * sizeof(union nd_mapping))
+
+/* max expected ioctl buffer size from users */
+#define NDV_MAX_IOCTL_BUFFER_SIZE \
+	(NDV_MAX_IOCTL_SIZE + \
+	NDV_MAX_MAPPING_BUFFER_SIZE + \
+	NDV_MAX_PRIVATE_DATA_SIZE)
+
+/*  max PFN array for inline buffers */
+#define NDV_MAX_INLINE_PFN_ARRAY_LENGTH 32
+
+/* Field header size for inline buffer */
+#define NDV_MAX_MAPPING_PACKET_FILED_BUFFER_SIZE \
+	(NDV_MAX_MAPPINGS * sizeof(NDV_PACKET_FIELD))
+
+/* Max for a single field */
+
+#define NDV_MAX_SINGLE_MAPPING_FIELD  (sizeof(GPA_RANGE) + \
+	(sizeof(PFN_NUMBER) * NDV_MAX_INLINE_PFN_ARRAY_LENGTH))
+
+/* Max for all inine data */
+
+#define NDV_MAX_MAPPING_DATA_SIZE (NDV_MAX_MAPPING_PACKET_FILED_BUFFER_SIZE + \
+	(NDV_MAX_MAPPINGS * NDV_MAX_SINGLE_MAPPING_FIELD))
+
+
+#define NDV_MAX_PACKET_HEADER_SIZE 256
+
+#define NDV_MAX_PACKET_SIZE    (NDV_MAX_PACKET_HEADER_SIZE + \
+				NDV_MAX_IOCTL_BUFFER_SIZE + \
+				NDV_MAX_MAPPING_DATA_SIZE)
+
+/* Well known message type INIT is defined for the channel
+ * not for the protocol.
+ */
+
+#define NDV_PACKET_TYPE_INIT  0xFFFFFFFF
+
+/* Invalid protocol version to to identify uninitialized channels */
+
+#define NDV_PROTOCOL_VERSION_INVALID  0xFFFFFFFF
+
+/* Flags that control the bahavior of packet handling */
+
+enum ndv_packet_options {
+	NDV_PACKET_OPTION_NONE = 0x00,
+
+	/* Indicates that the ExternalDataMdl parameter is expectected to be
+	 * passed and must be handled in the reciever.  This call must be
+	 * handled specially to ensure that the MDL can be created correctly.
+	 */
+	NDV_PACKET_OPTION_EXTERNAL_DATA = 0x01,
+
+	/* Inicates that the reciever must execution the handler at passive. */
+	NDV_PACKET_OPTIONS_REQUIRES_PASSIVE = 0x02,
+
+	/* Indicates that the sender does not expect and is not waiting for a
+	 * response packet.
+	 */
+	NDV_PACKET_OPTIONS_POST = 0x04,
+};
+
+#define NDV_PACKET_TYPE(id_, opt_) \
+	(((opt_)<<24) | (id_))
+
+#define NDV_PACKET_TYPE_OPTIONS(type_) \
+	(((type_) >> 24) & 0xFF)
+
+#define NDV_PACKET_TYPE_ID(type_) \
+	((type_) & 0xFFFFFF) \
+
+#define NDV_ADD_PACKET_OPTION(type_, opt_) \
+	((type_) |= (opt_<<24))
+
+/* The header value sent on all packets */
+union ndv_packet_hdr {
+
+	struct {
+		/* The type of packet.
+		 * This value should be created with the NDV_PACKET_TYPE macro
+		 * to include all packet options within the packet type.
+		 */
+		u32 packet_type;
+		/* The size of the entire fixed message structure that exists
+		 * before the data. This must be >= sizeof(NDV_PACKET_HEADER)
+		 */
+		u32 hdr_sz;
+		/* This size of the data that follows the message
+		 * data_sz + hdr_sz size gives the total size of
+		 * the buffer that is used.
+		 */
+		u32 data_sz;
+		/* The status code used to indicate success or failure.
+		 * It is only used in completions and during responses.
+		 */
+		u32 status; /* KYS: NTSTATUS? */
+	};
+
+	u64 padding[2];
+};
+
+
+/* The core INIT packet.  This message is defined in the channel
+ * not in the protocol.  This message should never change size
+ * or behavior, as it could impact compatibility in the future.
+ * This packet is used to negotiate the protocol version, so chaning
+ * this size could break backward compat.
+ */
+
+union ndv_packet_init {
+	struct {
+		u32 packet_type;
+		u32 protocol_version;
+		u32 flags;
+	};
+	u64 padding[2];
+}  __packed;
+
+#define NDV_PACKET_INIT_SIZE 16
+
+/* Data packing flags used for accessing the dynamic fields inside a packet */
+#define NDV_DATA_PACKING_2 0x1
+#define NDV_DATA_PACKING_4 0x3
+#define NDV_DATA_PACKING_8 0x7
+
+
+#define NDV_PROTOCOL_VERSION_1        0x0100
+#define NDV_PROTOCOL_VERSION_CURRENT  NDV_PROTOCOL_VERSION_1
+#define NDV_PROTOCOL_VERSION_COUNT    1
+
+struct ndv_pkt_field {
+	u32 size;
+	u32 offset;
+};
+
+enum ndv_pkt_id {
+	NDV_PKT_UNKNOWN = 0,
+	/* Version 1 Message ID's */
+	NDV_PKT_ID1_BIND,
+	NDV_PKT_ID1_CREATE,
+	NDV_PKT_ID1_CLEANUP,
+	NDV_PKT_ID1_CANCEL,
+	NDV_PKT_ID1_CONTROL,
+	NDV_PKT_ID1_COMPLETE,
+	NDV_PKT_ID1_INIT_RESOURCES,
+};
+
+/* The guest will send this as the first messages just after init
+ * The resources are reserved per channel.
+ */
+
+struct ndv_pkt_hdr_init_resources_1 {
+
+	union ndv_packet_hdr    pkt_hdr;
+	u16 io_space_sz_mb;
+	u64 io_space_start;
+
+};
+
+
+
+/* The guest will send this packet to the host after channel init
+ * to query support for the adapters that are registered.
+ */
+
+struct ndv_pkt_hdr_bind_1 {
+	union ndv_packet_hdr    pkt_hdr;
+	bool unbind;
+	union nd_sockaddr_inet ip_address;
+	struct if_physical_addr phys_addr;
+	u64 guest_id;
+};
+
+union ndv_context_handle {
+	u64 val64;
+	struct {
+		u32 local;
+		u32 remote;
+	};
+};
+
+struct ndv_pkt_hdr_create_1 {
+	union ndv_packet_hdr    pkt_hdr;
+
+	/* Identifies the object used to track this file handle on both
+	 * the guest and the host.  When sent from the guest, it will contain
+	 * the guest handle.  On success, the host will populate and return
+	 * it's handle value as well.
+	 */
+
+	union ndv_context_handle handle;
+
+	/* The parameters sent to the CreateFile call */
+	u32  access_mask;
+	u32 open_options;
+
+	u16 file_attributes; /* KYS: This field must be 64 bit aligned */
+
+	u16 share_access;
+
+	u32 kys_padding;
+
+	u16  ea_length; /* KYS; needs to be 64 bit aligned */
+};
+
+
+struct ndv_pkt_hdr_cleanup_1 {
+	union ndv_packet_hdr    pkt_hdr;
+
+	/* Identifies the object used to track this file handle on both
+	 * the guest and the host.  When sent from the guest, it will contain
+	 * the both the guest and host handle values.  The host will use this
+	 * value to cleanup its resource, then update its portion of the handle
+	 * to NDV_HANDLE_NULL before returning the data back to the guest.
+	 */
+	union ndv_context_handle handle;
+};
+
+struct ndv_pkt_hdr_cancel_1 {
+	union ndv_packet_hdr    pkt_hdr;
+	union ndv_context_handle file_handle;
+	union ndv_context_handle irp_handle;
+};
+
+struct ndv_bind_port_info {
+	bool is_admin;
+};
+
+struct ndv_extended_data_flds {
+	union {
+		u32 field_count;
+		u64 padding;
+	};
+
+};
+
+
+struct ndv_packet_hdr_control_1 {
+	union ndv_packet_hdr    pkt_hdr;
+	/* Identifies the object used to track this file handle on both
+	 * the guest and the host.  This should always have both guest
+	 * and host handle values inside it.
+	 */
+
+	union ndv_context_handle file_handle;
+
+	/* The handle information for the allocated irp context object.
+	 * This information is used when the host/guest starts the cancelation
+	 */
+	union ndv_context_handle irp_handle;
+
+	/* The input data describing in the IO control parameters */
+
+	u32 io_cntrl_code;
+	u32 output_buf_sz;
+	u32 input_buf_sz;
+	u32 input_output_buf_offset;
+
+	/* These are used in the return message to indicate the status of the IO
+	 * operation and the amount of data written to the output buffer.
+	 */
+	u32 io_status; /* KYS: NTSTATUS? */
+	u32 bytes_returned;
+
+	/* This contains the field information for additional data that is sent
+	 * with the packet that is IOCTL specific.
+	 */
+
+	struct ndv_pkt_field extended_data;
+};
+
+/*
+ * Include MLX specific defines.
+ */
+
+#include "mx_abi.h"
+
+/* Driver specific state.
+ */
+
+/*
+ * We need to have host open a file; some
+ * Windows constants for open.
+ */
+#define STANDARD_RIGHTS_ALL   (0x001F0000L)
+#define FILE_ATTRIBUTE_NORMAL (0x80)
+#define FILE_SHARE_READ	 (0x00000001)
+#define FILE_SHARE_WRITE (0x00000002)
+#define FILE_SHARE_DELETE (0x00000004)
+#define FILE_FLAG_OVERLAPPED (0x40000000)
+#define FILE_SHARE_ALL (FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE)
+#define CREATE_ALWAYS (2)
+#define OPEN_EXISTING (3)
+
+#define RTL_NUMBER_OF(_x) \
+		(sizeof(_x)/sizeof(_x[0]))
+/*
+ * The context structure tracks the open state.
+ */
+
+/*
+ * Packet layout for open adaptor.
+ */
+
+/*
+ * Packet for querying the address list.
+ */
+
+union query_addr_list_ioctl {
+	struct nd_handle in;
+	union nd_sockaddr_inet out[16]; /* KYS a max of 16 addresses */
+};
+
+struct pkt_query_addr_list {
+	struct ndv_packet_hdr_control_1 hdr;
+	union query_addr_list_ioctl ioctl;
+	unsigned long activity_id;
+};
+
+
+struct pkt_fld {
+	u32 size;
+	u32 offset;
+};
+
+struct fld_data {
+	union {
+		u64 padding;
+	};
+};
+
+struct extended_data_oad {
+	union {
+		u32 cnt;
+		u64 padding;
+	};
+	/* offsets are from start of extended data struct
+	 * and should start on 8 byte boundary
+	 */
+	struct pkt_fld fields[IBV_GET_CONTEXT_MAPPING_MAX];
+};
+
+union oad_ioctl {
+	struct nd_open_adapter input;
+	struct nd_resource_descriptor resrc_desc;
+};
+
+union oad_mappings {
+	struct ibv_get_context_req ctx_input;
+	struct ibv_get_context_resp ctx_output;
+};
+
+struct pkt_nd_open_adapter {
+	struct ndv_packet_hdr_control_1 hdr;
+
+	union oad_ioctl ioctl;
+	union oad_mappings mappings;
+
+	/*
+	 * Extended data.
+	 */
+	struct extended_data_oad ext_data;
+};
+
+/*
+ * Create CQ IOCTL.
+ */
+
+struct cq_db_gpa {
+	u32 byte_count;
+	u32 byte_offset;
+	u64 pfn_array[2];
+};
+
+struct cq_sn_gpa {
+	u32 byte_count;
+	u32 byte_offset;
+	u64 pfn_array[2];
+};
+
+struct create_cq_ext_data {
+	union {
+		u32 cnt;
+		u64 padding;
+	};
+	/* offsets are from start of extended data struct
+	 * and should start on 8 byte boundary
+	 */
+	struct pkt_fld fields[MLX4_IB_CREATE_CQ_MAPPING_MAX];
+	struct cq_db_gpa db_gpa;
+	struct cq_sn_gpa sn_gpa;
+	struct gpa_range cqbuf_gpa;
+};
+
+union create_cq_ioctl {
+	struct nd_create_cq input;
+	struct nd_resource_descriptor resrc_desc;
+};
+
+union create_cq_mappings {
+	struct ibv_create_cq cq_in;
+	struct ibv_create_cq_resp cq_resp;
+};
+
+struct pkt_nd_create_cq {
+	struct ndv_packet_hdr_control_1 hdr;
+
+	union create_cq_ioctl ioctl;
+	union create_cq_mappings mappings;
+
+	/*
+	 * Extended data.
+	 */
+	struct create_cq_ext_data ext_data;
+};
+
+/*
+ * IOCTL to free CQ.
+ */
+struct free_cq_ioctl {
+	struct nd_handle in;
+};
+
+struct pkt_nd_free_cq {
+	struct ndv_packet_hdr_control_1 hdr;
+
+	struct  free_cq_ioctl ioctl;
+};
+
+
+/*
+ * IOCTL to QUERY CQ - CQ NOTIFY
+ */
+
+struct notify_cq_ioctl {
+	struct nd_cq_notify in;
+};
+
+struct pkt_nd_notify_cq {
+	struct ndv_packet_hdr_control_1 hdr;
+	struct notify_cq_ioctl ioctl;
+};
+
+/*
+ * IOCTL to Create a listner
+ */
+
+struct nd_ep_create {
+	struct nd_handle hdr;
+	bool to_semantics;
+	unsigned long activity_id;
+};
+
+union listener_cr_ioctl {
+	struct nd_ep_create in;
+	u64  out;
+};
+
+struct pkt_nd_cr_listener {
+	struct ndv_packet_hdr_control_1 hdr;
+	union listener_cr_ioctl ioctl;
+};
+
+/*
+ * IOCTL to free listener.
+ */
+
+struct listener_free_ioctl {
+	struct nd_handle in;
+};
+
+struct pkt_nd_free_listener {
+	struct ndv_packet_hdr_control_1 hdr;
+	struct listener_free_ioctl ioctl;
+};
+
+/*
+ * IOCTL for listener cancel IO.
+ */
+struct listener_cancelio_ioctl {
+	struct nd_handle in;
+};
+
+struct pkt_nd_cancelio_listener {
+	struct ndv_packet_hdr_control_1 hdr;
+	struct listener_cancelio_ioctl ioctl;
+};
+
+/*
+ * IOCTL for LISTENER BIND
+ */
+
+union listener_bind_ioctl {
+	struct ndk_bind  in;
+};
+
+struct pkt_nd_bind_listener {
+	struct ndv_packet_hdr_control_1 hdr;
+	union listener_bind_ioctl ioctl;
+};
+
+/*
+ * After the listener is bound, enable
+ * listening.
+ */
+
+union listener_listen_ioctl {
+	struct nd_listen  in;
+};
+
+struct pkt_nd_listen_listener {
+	struct ndv_packet_hdr_control_1 hdr;
+	union listener_listen_ioctl ioctl;
+};
+
+/*
+ * IOCTL for getting the adddress from listener.
+ *
+ */
+
+union listener_get_addr_ioctl {
+	struct nd_handle  in;
+	union nd_sockaddr_inet out;
+};
+
+struct pkt_nd_get_addr_listener {
+	struct ndv_packet_hdr_control_1 hdr;
+	union listener_get_addr_ioctl ioctl;
+};
+
+/*
+ * IOCTL to get a connection from a listener.
+ */
+
+union listener_get_connection_ioctl {
+	struct nd_get_connection_request  in;
+	union nd_sockaddr_inet out;
+};
+
+struct pkt_nd_get_connection_listener {
+	struct ndv_packet_hdr_control_1 hdr;
+	union listener_get_connection_ioctl ioctl;
+};
+
+
+/*
+ * Connector IOCTLs
+ */
+
+/*
+ * IOCTL to create connector.
+ */
+
+union connector_cr_ioctl {
+	struct nd_ep_create in;
+	u64  out;
+};
+
+struct pkt_nd_cr_connector {
+	struct ndv_packet_hdr_control_1 hdr;
+	union connector_cr_ioctl ioctl;
+};
+
+/*
+ * IOCTL to free connector.
+ */
+
+struct connector_free_ioctl {
+	struct nd_handle in;
+};
+
+struct pkt_nd_free_connector {
+	struct ndv_packet_hdr_control_1 hdr;
+	struct connector_free_ioctl ioctl;
+};
+
+/*
+ * IOCTL to cancel I/O on a connector.
+ */
+
+struct connector_cancelio_ioctl {
+	struct nd_handle in;
+};
+
+struct pkt_nd_cancelio_connector {
+	struct ndv_packet_hdr_control_1 hdr;
+	struct connector_cancelio_ioctl ioctl;
+};
+
+/*
+ * IOCTL to Bind an address to the connector.
+ */
+
+union connector_bind_ioctl {
+	struct ndk_bind  in;
+};
+
+struct pkt_nd_bind_connector {
+	struct ndv_packet_hdr_control_1 hdr;
+	union connector_bind_ioctl ioctl;
+};
+
+/*
+ * IOCTL to connect a connector.
+ */
+
+struct connector_connect_in {
+	struct nd_connect hdr;
+	u8 retry_cnt;
+	u8 rnr_retry_cnt;
+	u8 priv_data[56];
+	unsigned long activity_id;
+};
+
+union connector_connect_ioctl {
+	struct connector_connect_in in;
+};
+
+struct pkt_nd_connector_connect {
+	struct ndv_packet_hdr_control_1 hdr;
+	union connector_connect_ioctl ioctl;
+};
+
+/*
+ * IOCTL for connector complete connect
+ */
+
+struct complete_connect_in {
+	struct nd_handle hdr;
+	u8 rnr_nak_to;
+	unsigned long activity_id;
+};
+
+struct complete_connect_out {
+	enum ibv_qp_state state;
+};
+
+union connector_complete_connect_ioctl {
+	struct complete_connect_in in;
+	struct complete_connect_out out;
+};
+
+struct pkt_nd_connector_connect_complete {
+	struct ndv_packet_hdr_control_1 hdr;
+	union connector_complete_connect_ioctl ioctl;
+};
+
+
+#define MAX_PRIVATE_DATA_LEN	148
+
+/*
+ * IOCTL for connector accept.
+ */
+
+struct connector_accept_in {
+	struct nd_accept hdr;
+	u8 rnr_retry_cnt;
+	u8 rnr_nak_to;
+	u8 private_data[MAX_PRIVATE_DATA_LEN];
+	unsigned long activity_id;
+};
+
+struct connector_accept_out {
+	enum ibv_qp_state state;
+};
+
+union connector_accept_ioctl {
+	struct connector_accept_in in;
+	struct connector_accept_out out;
+};
+
+struct pkt_nd_connector_accept {
+	struct ndv_packet_hdr_control_1 hdr;
+	union connector_accept_ioctl ioctl;
+};
+
+/*
+ * IOCTL for connector to reject a connection.
+ */
+
+struct connector_reject_in {
+	struct nd_reject hdr;
+	u8 private_data[MAX_PRIVATE_DATA_LEN];
+};
+
+struct connector_reject_out {
+	enum ibv_qp_state state;
+};
+
+union connector_reject_ioctl {
+	struct connector_reject_in in;
+	struct connector_reject_out out;
+};
+
+struct pkt_nd_connector_reject {
+	struct ndv_packet_hdr_control_1 hdr;
+	union connector_reject_ioctl ioctl;
+};
+
+/*
+ * IOCTL to get connector read limits.
+ */
+
+struct connector_get_rd_limits_in {
+	struct nd_handle in;
+};
+
+struct connector_get_rd_limits_out {
+	struct nd_read_limits out;
+};
+
+union connector_get_rd_limits_ioctl {
+	struct connector_get_rd_limits_in in;
+	struct connector_get_rd_limits_out out;
+};
+
+struct pkt_nd_connector_get_rd_limits {
+	struct ndv_packet_hdr_control_1 hdr;
+	union connector_get_rd_limits_ioctl ioctl;
+};
+
+/*
+ * IOCTL to get connector private data.
+ */
+union connector_get_priv_data_ioctl {
+	struct nd_handle in;
+	u8 out[MAX_PRIVATE_DATA_LEN];
+};
+
+struct pkt_nd_connector_get_priv_data {
+	struct ndv_packet_hdr_control_1 hdr;
+	union connector_get_priv_data_ioctl ioctl;
+};
+
+
+/*
+ * IOCTL get peer address.
+ */
+
+union connector_get_peer_addr_ioctl {
+	struct nd_handle in;
+	union nd_sockaddr_inet out;
+};
+
+struct pkt_nd_connector_get_peer_addr {
+	struct ndv_packet_hdr_control_1 hdr;
+	union connector_get_peer_addr_ioctl ioctl;
+};
+
+/*
+ * IOCTL to get connector address.
+ */
+
+union connector_get_addr_ioctl {
+	struct nd_handle in;
+	union nd_sockaddr_inet out;
+};
+
+struct pkt_nd_connector_get_addr {
+	struct ndv_packet_hdr_control_1 hdr;
+	union connector_get_addr_ioctl ioctl;
+};
+
+/*
+ * IOCTL for disconnect notification.
+ */
+
+union connector_notify_disconnect_ioctl {
+	struct nd_handle in;
+};
+
+struct pkt_nd_connector_notify_disconnect {
+	struct ndv_packet_hdr_control_1 hdr;
+	union connector_notify_disconnect_ioctl ioctl;
+};
+
+union connector_disconnect_ioctl {
+	struct nd_handle in;
+};
+
+struct pkt_nd_connector_disconnect {
+	struct ndv_packet_hdr_control_1 hdr;
+	union connector_notify_disconnect_ioctl ioctl;
+};
+
+/*
+ * IOCTLs for QP operations.
+ */
+
+/*
+ * Create qp IOCTL.
+ */
+
+struct qp_db_gpa {
+	u32 byte_count;
+	u32 byte_offset;
+	u64 pfn_array[1];
+};
+
+struct create_qp_ext_data {
+	union {
+		u32 cnt;
+		u64 padding;
+	};
+	/* offsets are from start of extended data struct
+	 * and should start on 8 byte boundary
+	 */
+	struct pkt_fld fields[MLX4_IB_CREATE_QP_MAPPINGS_MAX];
+	struct qp_db_gpa db_gpa;
+	struct gpa_range qpbuf_gpa;
+};
+
+union create_qp_ioctl {
+	struct nd_create_qp input;
+	struct nd_resource_descriptor resrc_desc;
+};
+
+union create_qp_mappings {
+	struct ibv_create_qp qp_in;
+	struct ibv_create_qp_resp qp_resp;
+};
+
+struct pkt_nd_create_qp {
+	struct ndv_packet_hdr_control_1 hdr;
+
+	union create_qp_ioctl ioctl;
+	union create_qp_mappings mappings;
+
+	/*
+	 * Extended data.
+	 */
+	struct create_qp_ext_data ext_data;
+};
+
+/*
+ * IOCTL to flush a QP.
+ */
+struct flush_qp_ioctl {
+	struct nd_handle in;
+	enum ibv_qp_state out;
+};
+
+struct pkt_nd_flush_qp {
+	struct ndv_packet_hdr_control_1 hdr;
+	struct flush_qp_ioctl ioctl;
+};
+
+/*
+ * Memory Region IOCTLS
+ */
+union create_mr_ioctl {
+	struct nd_handle in;
+	u64 out;
+};
+
+struct pkt_nd_create_mr {
+	struct ndv_packet_hdr_control_1 hdr;
+	union create_mr_ioctl ioctl;
+};
+
+struct mr_out {
+	u32 lkey;
+	u32 rkey;
+	unsigned long activity_id;
+};
+
+
+union register_mr_ioctl {
+	struct nd_mr_register in;
+	struct mr_out out;
+};
+
+struct pkt_nd_register_mr {
+	struct ndv_packet_hdr_control_1 hdr;
+	union  register_mr_ioctl ioctl;
+};
+
+struct deregister_mr_ioctl {
+	struct nd_handle in;
+};
+
+struct pkt_nd_deregister_mr {
+	struct ndv_packet_hdr_control_1 hdr;
+	struct deregister_mr_ioctl ioctl;
+};
+
+/*
+ * IOCTL to disconnect connector
+ */
+
+/*
+ * Create PD IOCTL.
+ */
+struct nd_create_pd_ioctl {
+	union {
+		struct nd_handle in;
+		u64 out_handle;
+	};
+	struct ibv_alloc_pd_resp resp;
+};
+
+struct pkt_nd_pd_create {
+	struct ndv_packet_hdr_control_1 hdr;
+	struct nd_create_pd_ioctl ioctl;
+};
+
+/*
+ * Free Handle. Check the layout with Luke.
+ *
+ */
+struct free_handle_ioctl {
+	struct nd_handle in;
+};
+
+struct pkt_nd_free_handle {
+	struct ndv_packet_hdr_control_1 hdr;
+	struct free_handle_ioctl ioctl;
+};
+
+/*
+ * Cancel I/O.
+ */
+
+struct cancel_io_ioctl {
+	struct nd_handle in;
+};
+
+struct pkt_nd_cancel_io {
+	struct ndv_packet_hdr_control_1 hdr;
+	struct cancel_io_ioctl ioctl;
+};
+
+/*
+ * Connector states:
+ */
+
+enum connector_state {
+	HVND_CON_INCOMING,
+	HVND_CON_INCOMING_ESTABLISHED,
+	HVND_CON_INCOMING_REJECTED,
+	HVND_CON_OUTGOING_REQUEST
+};
+
+
+/*
+ * Adaptor query IOCTL.
+ */
+struct nd_adap_query_ioctl {
+	union {
+		struct nd_adapter_query ad_q;
+		struct adapter_info_v2 ad_info;
+	};
+};
+
+struct pkt_nd_query_adaptor {
+	struct ndv_packet_hdr_control_1 hdr;
+	struct nd_adap_query_ioctl ioctl;
+};
+
+struct  nd_ioctl {
+	union {
+		struct nd_handle handle;
+		u8 raw_buffer[NDV_MAX_IOCTL_BUFFER_SIZE];
+	};
+};
+
+struct pkt_nd_provider_ioctl {
+	struct ndv_packet_hdr_control_1 hdr;
+	struct nd_ioctl ioctl;
+};
+
+struct hvnd_ib_pd {
+	struct ib_pd ibpd;
+	u32	pdn;
+	u64	handle;
+};
+
+struct hvnd_work {
+	struct work_struct work;
+	void *callback_arg;
+};
+
+struct hvnd_disconnect_work {
+	struct work_struct work;
+	int status;
+	void *callback_arg;
+};
+
+/*
+struct hvnd_delayed_work {
+	struct delayed_work work;
+	void *callback_arg;
+};
+*/
+
+enum hvnd_cm_state {
+	hvnd_cm_idle = 0,
+	hvnd_cm_connect_reply_sent,	/* active */
+	hvnd_cm_connect_reply_refused,
+	hvnd_cm_connect_received,	/* active */
+	hvnd_cm_connect_request_sent,	/* passive */
+	hvnd_cm_accept_sent,
+	hvnd_cm_close_sent,
+	hvnd_cm_established_sent,
+};
+
+struct incoming_pkt {
+	struct list_head list_entry;
+	char pkt[0];
+};
+
+struct hvnd_ep_obj {
+#ifdef NOTYET
+	spinlock_t ep_lk;
+	bool to_be_destroyed;
+	bool io_outstanding;
+
+	wait_queue_head_t wait;
+	bool stopped;
+	atomic_t process_refcnt;
+#endif
+	bool stopping;
+	wait_queue_head_t wait_pending;
+	atomic_t nr_requests_pending;
+
+	enum nd_resource_type type;
+	enum connector_state state;
+	struct iw_cm_id *cm_id;
+	enum hvnd_cm_state cm_state;
+	struct completion block_event;
+	struct completion disconnect_event;
+	struct completion connector_accept_event;
+	int connector_accept_status;
+	u64 ep_handle;
+	spinlock_t      incoming_pkt_list_lock;
+	struct list_head incoming_pkt_list;
+	struct hvnd_ep_obj *parent;
+	struct hvnd_dev *nd_dev;
+	struct hvnd_ucontext *uctx;
+	struct hvnd_work wrk;
+	struct hvnd_cq *cq;
+	u8 ord;
+	u8 ird;
+	char priv_data[MAX_PRIVATE_DATA_LEN];
+	bool incoming;
+	atomic_t disconnect_notified;
+	u64 outstanding_handle;
+	u32 local_irp;
+	struct hvnd_ep_obj *outstanding_ep;
+	struct pkt_nd_connector_connect connector_connect_pkt;
+	int connector_connect_retry;
+};
+
+struct hvnd_ucontext {
+	struct ib_ucontext      ibucontext;
+	struct list_head listentry;
+	struct ndv_pkt_hdr_create_1 create_pkt;
+	struct ndv_pkt_hdr_create_1 create_pkt_ovl; /* Overlap handle */
+	struct pkt_nd_provider_ioctl pr_init_pkt;
+	union ndv_context_handle file_handle;
+	union ndv_context_handle file_handle_ovl;
+
+	struct pkt_nd_open_adapter o_adap_pkt;
+
+	u64 adaptor_hdl;
+
+	/*
+	 * Protection domain state.
+	 */
+	struct pkt_nd_pd_create pd_cr_pkt;
+
+	u64 uar_base;
+	u64 bf_base;
+	u32 bf_buf_size;
+	u32 bf_offset;
+	u32 cqe_size;
+	u32 max_qp_wr;
+	u32 max_sge;
+	u32 max_cqe;
+	u32 num_qps;
+
+	/*
+	 * State to manage dorbell pages:
+	 */
+	struct list_head        db_page_list;
+	struct mutex            db_page_mutex;
+
+	atomic_t refcnt;
+
+};
+
+struct hvnd_dev {
+	struct ib_device ibdev;
+	struct hv_device *hvdev;
+	u32 device_cap_flags;
+	unsigned char nports;
+	bool ib_active;
+
+	/* State to manage interaction with the host.
+	 */
+
+	spinlock_t uctxt_lk;
+	struct list_head listentry;
+
+	unsigned long mmio_sz;
+	unsigned long mmio_start_addr;
+	struct resource mmio_resource;
+	void *mmio_virt;
+
+	unsigned long negotiated_version;
+	union ndv_packet_init init_pkt;
+	struct ndv_pkt_hdr_init_resources_1 resources;
+	struct ndv_pkt_hdr_bind_1 bind_pkt;
+
+	struct ndv_pkt_hdr_create_1 global_create_pkt;
+	union ndv_context_handle global_file_handle;
+
+	struct semaphore query_pkt_sem;
+	bool query_pkt_set;
+	struct pkt_nd_query_adaptor query_pkt;
+
+	/*
+	 * ID tables.
+	 */
+	spinlock_t id_lock;
+
+	struct idr cqidr;
+	struct idr qpidr;
+	struct idr mmidr;
+	struct idr irpidr;
+	struct idr uctxidr;
+	atomic_t open_cnt;
+
+	struct work_struct probe_delayed_work;
+};
+
+struct hvnd_cq {
+	struct ib_cq ibcq;
+	void *cq_buf;
+	void *db_addr;
+	u32 arm_sn;
+	u32 entries;
+
+	u32 cqn;
+	u32 cqe;
+	u64 cq_handle;
+
+	struct ib_umem         *umem;
+	struct ib_umem	*db_umem;
+	struct mlx4_ib_user_db_page user_db_page;
+	struct hvnd_ucontext *uctx;
+	struct hvnd_ep_obj ep_object;
+	bool monitor;
+	bool upcall_pending;
+};
+
+struct hvnd_qp {
+	struct ib_qp ibqp;
+	void *qp_buf;
+	void *db_addr;
+	u32  buf_size;
+	u8   port;
+	struct hvnd_dev *nd_dev;
+
+	__u8    log_sq_bb_count;
+	__u8    log_sq_stride;
+	__u8    sq_no_prefetch;
+
+	int rq_wqe_cnt;
+	int rq_wqe_shift;
+	int rq_max_gs;
+
+	int sq_wqe_cnt;
+	int sq_wqe_shift;
+	int sq_max_gs;
+
+	u32 max_inline_data;
+
+	u32 initiator_q_depth;
+	u32 initiator_request_sge;
+
+	u32 receive_q_depth;
+	u32 receive_request_sge;
+
+	struct hvnd_cq *recv_cq;
+	struct hvnd_cq *send_cq;
+
+	u64 receive_cq_handle;
+	u64 initiator_cq_handle;
+	u64 pd_handle;
+
+	u64 qp_handle;
+	u32 qpn;
+	u32 max_send_wr;
+	u32 max_recv_wr;
+	u32 max_send_sge;
+	u32 max_recv_sge;
+
+	struct ib_umem         *umem;
+	struct ib_umem	*db_umem;
+	struct mlx4_ib_user_db_page user_db_page;
+	struct hvnd_ucontext *uctx;
+	struct iw_cm_id *cm_id;
+
+	/*
+	 * Current QP state; need to look at locking.
+	 * XXXKYS
+	 */
+	enum ib_qp_state qp_state;
+	bool cq_notify;
+	wait_queue_head_t wait;
+	atomic_t refcnt;
+	struct hvnd_ep_obj *connector;
+};
+
+struct hvnd_mr {
+	struct ib_mr ibmr;
+	struct hvnd_ib_pd *pd;
+	struct ib_umem *umem;
+	u64 start;
+	u64 length;
+	u64 virt;
+	int acc;
+	u64 mr_handle;
+	u32 mr_lkey;
+	u32 mr_rkey;
+};
+
+struct hvnd_cookie {
+	struct completion host_event;
+	void *pkt;
+};
+
+/*
+ * Definitions to retrieve the IP address.
+ */
+
+#define HVND_CURRENT_VERSION 0
+
+struct hvnd_ipaddr_tuple {
+	char mac_address[ETH_ALEN];
+	struct sockaddr addr;
+};
+
+struct hvnd_msg {
+	int status;
+	struct hvnd_ipaddr_tuple ip_tuple;
+};
+
+static inline struct hvnd_ib_pd *to_nd_pd(struct ib_pd *pd)
+{
+	return container_of(pd, struct hvnd_ib_pd, ibpd);
+}
+
+static inline struct hvnd_dev *to_nd_dev(struct ib_device *ibdev)
+{
+	return container_of(ibdev, struct hvnd_dev, ibdev);
+}
+
+static inline struct hvnd_cq *to_nd_cq(struct ib_cq *ibcq)
+{
+	return container_of(ibcq, struct hvnd_cq, ibcq);
+}
+
+static inline struct hvnd_qp *to_nd_qp(struct ib_qp *ibqp)
+{
+	return container_of(ibqp, struct hvnd_qp, ibqp);
+}
+
+static inline struct hvnd_ucontext *to_nd_context(struct ib_ucontext *
+						  ibucontext)
+{
+	return container_of(ibucontext, struct hvnd_ucontext, ibucontext);
+}
+
+static inline struct hvnd_ucontext *get_uctx_from_pd(struct ib_pd *pd)
+{
+	return to_nd_context(pd->uobject->context);
+}
+
+static inline struct hvnd_mr *to_nd_mr(struct ib_mr *ibmr)
+{
+	return container_of(ibmr, struct hvnd_mr, ibmr);
+}
+/*
+ * ID management.
+ */
+
+static inline int insert_handle(struct hvnd_dev *dev, struct idr *idr,
+				void *handle, u32 id)
+{
+	int ret;
+	unsigned long flags;
+
+	idr_preload(GFP_KERNEL);
+	spin_lock_irqsave(&dev->id_lock, flags);
+
+	ret = idr_alloc(idr, handle, id, id + 1, GFP_ATOMIC);
+
+	spin_unlock_irqrestore(&dev->id_lock, flags);
+	idr_preload_end();
+
+	BUG_ON(ret == -ENOSPC);
+	return ret < 0 ? ret : 0;
+}
+
+static inline void remove_handle(struct hvnd_dev *dev, struct idr *idr,
+				 u32 id)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->id_lock, flags);
+	idr_remove(idr, id);
+	spin_unlock_irqrestore(&dev->id_lock, flags);
+}
+
+static inline struct hvnd_cq *get_cqp(struct hvnd_dev *dev, u32 cqid)
+{
+	struct hvnd_cq *cqp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->id_lock, flags);
+	cqp =  idr_find(&dev->cqidr, cqid);
+	spin_unlock_irqrestore(&dev->id_lock, flags);
+
+	return cqp;
+}
+
+static inline struct hvnd_qp *get_qpp(struct hvnd_dev *dev, u32 qpid)
+{
+	struct hvnd_qp *qpp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->id_lock, flags);
+	qpp = idr_find(&dev->qpidr, qpid);
+	spin_unlock_irqrestore(&dev->id_lock, flags);
+
+	return qpp;
+}
+
+static inline struct hvnd_ucontext *get_uctx(struct hvnd_dev *dev, u32 pid)
+{
+	struct hvnd_ucontext *uctx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->id_lock, flags);
+	uctx = idr_find(&dev->uctxidr, pid);
+	spin_unlock_irqrestore(&dev->id_lock, flags);
+
+	return uctx;
+}
+
+
+static inline void *map_irp_to_ctx(struct hvnd_dev *nd_dev, u32 irp)
+{
+	void *ctx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&nd_dev->id_lock, flags);
+	ctx = idr_find(&nd_dev->irpidr, irp);
+	spin_unlock_irqrestore(&nd_dev->id_lock, flags);
+
+	return ctx;
+}
+
+
+
+void hvnd_callback(void *context);
+int hvnd_negotiate_version(struct hvnd_dev *nd_dev);
+int hvnd_init_resources(struct hvnd_dev *nd_dev);
+int hvnd_bind_nic(struct hvnd_dev *nd_dev, bool un_bind);
+int hvnd_open_adaptor(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx);
+int hvnd_close_adaptor(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx);
+int hvnd_query_adaptor(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx);
+int  hvnd_create_pd(struct hvnd_ucontext *uctx, struct hvnd_dev *nd_dev,
+		    struct hvnd_ib_pd *hvnd_pd);
+
+/*
+ * CQ operations.
+ */
+int hvnd_create_cq(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+		   struct hvnd_cq *cq);
+int hvnd_destroy_cq(struct hvnd_dev *nd_dev, struct hvnd_cq *cq);
+int hvnd_notify_cq(struct hvnd_dev *nd_dev, struct hvnd_cq *cq,
+		   u32 notify_type, u64 irp_handle);
+
+/*
+ * QP operations.
+ */
+int hvnd_create_qp(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+		   struct hvnd_qp *qp);
+
+int hvnd_free_qp(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+		 struct hvnd_qp *qp);
+
+int hvnd_flush_qp(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+		 struct hvnd_qp *qp);
+
+/*
+ * MR operations.
+ */
+
+int hvnd_cr_mr(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+		u64 pd_handle, u64 *mr_handle);
+
+int hvnd_free_mr(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 handle);
+
+int hvnd_mr_register(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+		     struct hvnd_mr *mr);
+int hvnd_deregister_mr(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 handle);
+
+/*
+ * Listner operations
+ */
+int hvnd_cr_listener(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 *handle);
+
+
+int hvnd_free_listener(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 listener_handle);
+
+int hvnd_bind_listener(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 listener_handle, union nd_sockaddr_inet *addr);
+
+int hvnd_listen_listener(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 listener_handle, u32 backlog);
+
+int hvnd_get_addr_listener(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 listener_handle, union nd_sockaddr_inet *addr);
+
+int hvnd_get_connection_listener(struct hvnd_dev *nd_dev,
+			struct hvnd_ucontext *uctx,
+			u64 listener_handle, u64 connector_handle,
+			u64 irp_handle);
+
+/*
+ * Connector operations.
+ */
+int hvnd_cr_connector(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 *connector_handle);
+
+int hvnd_free_connector(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 handle);
+
+int hvnd_cancelio_connector(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 handle);
+int hvnd_bind_connector(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 handle, union nd_sockaddr_inet *addr);
+
+int hvnd_connector_connect(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 connector_handle, u32 in_rd_limit, u32 out_rd_limit,
+			u32 priv_data_length, const u8 *priv_data,
+			u64 qp_handle, struct if_physical_addr *phys_addr,
+			union nd_sockaddr_inet *dest_addr,
+			struct hvnd_ep_obj *ep);
+
+int hvnd_connector_complete_connect(struct hvnd_dev *nd_dev,
+			struct hvnd_ucontext *uctx,
+			u64 connector_handle,  enum ibv_qp_state *qp_state);
+
+int hvnd_connector_accept(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 connector_handle,
+			u64 qp_handle,
+			u32 in_rd_limit, u32 out_rd_limit,
+			u32 priv_data_length, const u8 *priv_data,
+			enum ibv_qp_state *qp_state, struct hvnd_ep_obj *ep);
+
+int hvnd_connector_reject(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 connector_handle,
+			u32 priv_data_length, u8 *priv_data,
+			enum ibv_qp_state *qp_state);
+
+int hvnd_connector_get_rd_limits(struct hvnd_dev *nd_dev,
+			struct hvnd_ucontext *uctx,
+			u64 connector_handle,
+			struct nd_read_limits *rd_limits);
+
+int hvnd_connector_get_priv_data(struct hvnd_dev *nd_dev,
+			struct hvnd_ucontext *uctx,
+			u64 connector_handle,
+			u8 *priv_data);
+
+int hvnd_connector_get_peer_addr(struct hvnd_dev *nd_dev,
+			struct hvnd_ucontext *uctx,
+			u64 connector_handle,
+			union nd_sockaddr_inet *peer_addr);
+
+int hvnd_connector_get_local_addr(struct hvnd_dev *nd_dev,
+			struct hvnd_ucontext *uctx,
+			u64 connector_handle,
+			union nd_sockaddr_inet *local_addr);
+
+int hvnd_connector_notify_disconnect(struct hvnd_dev *nd_dev,
+			struct hvnd_ucontext *uctx,
+			u64 connector_handle, struct hvnd_ep_obj *ep);
+
+
+int hvnd_connector_disconnect(struct hvnd_dev *nd_dev,
+			struct hvnd_ucontext *uctx,
+			u64 connector_handle, struct hvnd_ep_obj *ep);
+
+int hvnd_free_handle(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx,
+			u64 handle, u32 ioctl);
+
+int hvnd_cancel_io(struct hvnd_ep_obj *ep_object);
+
+char *hvnd_get_op_name(int ioctl);
+
+void hvnd_acquire_uctx_ref(struct hvnd_ucontext *uctx);
+void hvnd_drop_uctx_ref(struct hvnd_dev *nd_dev, struct hvnd_ucontext *uctx);
+void hvnd_process_events(struct work_struct *work);
+
+void hvnd_process_cq_event_pending(struct hvnd_ep_obj *ep, int status);
+void hvnd_process_cq_event_complete(struct hvnd_ep_obj *ep, int status);
+void hvnd_process_connector_accept(struct hvnd_ep_obj *ep_object, int status);
+void hvnd_process_notify_disconnect(struct hvnd_ep_obj *ep_object, int status);
+void hvnd_process_disconnect(struct hvnd_ep_obj *ep_object, int status);
+
+void put_irp_handle(struct hvnd_dev *nd_dev, u32 irp);
+int get_irp_handle(struct hvnd_dev *nd_dev, u32 *local, void *irp_ctx);
+
+void hvnd_init_hdr(struct ndv_packet_hdr_control_1 *hdr,
+			  u32 data_sz, u32 local, u32 remote,
+			  u32 ioctl_code,
+			  u32 ext_data_sz, u32 ext_data_offset,
+			  u64 irp_handle);
+
+int  hvnd_send_ioctl_pkt(struct hvnd_dev *nd_dev,
+				struct ndv_packet_hdr_control_1 *hdr,
+				u32 pkt_size, u64 cookie);
+
+int hvnd_get_outgoing_rdma_addr(struct hvnd_dev *nd_dev,
+				struct hvnd_ucontext *uctx,
+				union nd_sockaddr_inet *og_addr);
+
+int hvnd_get_neigh_mac_addr(struct sockaddr *local, struct sockaddr *remote,
+			    char *mac_addr);
+
+void hvnd_addr_init(void);
+
+void hvnd_addr_deinit(void);
+
+int hvnd_get_ip_addr(char **ip_addr, char **mac_addr);
+
+bool ep_add_work_pending(struct hvnd_ep_obj *ep_object);
+void ep_del_work_pending(struct hvnd_ep_obj *ep_object);
+void ep_stop(struct hvnd_ep_obj *ep_object);
+
+#define current_pid()           (current->pid)
+/*
+ * NT STATUS defines.
+ */
+
+#define STATUS_SUCCESS 0x0
+#define STATUS_PENDING 0x00000103
+#define STATUS_CANCELLED 0xC0000120
+#define STATUS_DISCONNECTED 0xC000020C
+#define STATUS_TIMEOUT 0xC00000B5
+
+void inc_ioctl_counter_request(unsigned ioctl);
+void inc_ioctl_counter_response(unsigned ioctl);
+
+#define NDV_PROTOCOL_VAERSION_INVALID -1
+#define NDV_PACKET_INIT_SIZE 16 /* Size of the INIT packet */
+
+#define HVND_RING_SZ (PAGE_SIZE * 64)
+
+/* logging levels */
+#define HVND_ERROR 0
+#define HVND_WARN 1
+#define HVND_INFO 2
+#define HVND_DEBUG 3
+
+extern int hvnd_log_level;
+
+#define hvnd_error(fmt, args...)	hvnd_log(HVND_ERROR, fmt, ##args)
+#define hvnd_warn(fmt, args...)		hvnd_log(HVND_WARN, fmt, ##args)
+#define hvnd_info(fmt, args...)		hvnd_log(HVND_INFO, fmt, ##args)
+#define hvnd_debug(fmt, args...)	hvnd_log(HVND_DEBUG, fmt, ##args)
+
+#define hvnd_log(level, fmt, args...) \
+do { \
+	if (unlikely(hvnd_log_level >= (level))) \
+		printk(KERN_ERR "hvnd %s[%u]: " fmt, __func__, __LINE__, ##args); \
+} while (0)
+
+#endif /* _VMBUS_RDMA_H */
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
