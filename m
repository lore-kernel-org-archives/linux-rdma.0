From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [for-next 1/3] RDMA/bnxt_re: expose cc parameters through configfs
Date: Tue, 22 Aug 2017 07:49:45 -0400
Message-ID: <1503402587-24669-2-git-send-email-devesh.sharma@broadcom.com>
References: <1503402587-24669-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503402587-24669-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch adds per port entry in configfs to allow
configuring the congestion control parameters.
The newly configured vaules will not apply to the h/w
until "echo -n 1 > apply" is issued.

Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/Makefile   |   3 +-
 drivers/infiniband/hw/bnxt_re/bnxt_re.h  |   1 +
 drivers/infiniband/hw/bnxt_re/configfs.c | 707 +++++++++++++++++++++++++++++++
 drivers/infiniband/hw/bnxt_re/configfs.h |  93 ++++
 drivers/infiniband/hw/bnxt_re/main.c     |   8 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.c |  32 ++
 drivers/infiniband/hw/bnxt_re/qplib_sp.h |  19 +
 drivers/infiniband/hw/bnxt_re/roce_hsi.h | 152 +++++--
 8 files changed, 979 insertions(+), 36 deletions(-)
 create mode 100644 drivers/infiniband/hw/bnxt_re/configfs.c
 create mode 100644 drivers/infiniband/hw/bnxt_re/configfs.h

diff --git a/drivers/infiniband/hw/bnxt_re/Makefile b/drivers/infiniband/hw/bnxt_re/Makefile
index afbaa0e..2a406a7 100644
--- a/drivers/infiniband/hw/bnxt_re/Makefile
+++ b/drivers/infiniband/hw/bnxt_re/Makefile
@@ -3,4 +3,5 @@ ccflags-y := -Idrivers/net/ethernet/broadcom/bnxt
 obj-$(CONFIG_INFINIBAND_BNXT_RE) += bnxt_re.o
 bnxt_re-y := main.o ib_verbs.o \
 	     qplib_res.o qplib_rcfw.o	\
-	     qplib_sp.o qplib_fp.o  hw_counters.o
+	     qplib_sp.o qplib_fp.o  hw_counters.o \
+	     configfs.o
diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index b3ad37f..ade6698 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -123,6 +123,7 @@ struct bnxt_re_dev {
 	struct bnxt_qplib_ctx		qplib_ctx;
 	struct bnxt_qplib_res		qplib_res;
 	struct bnxt_qplib_dpi		dpi_privileged;
+	struct bnxt_qplib_cc_param	cc_param;
 
 	atomic_t			qp_count;
 	struct mutex			qp_lock;	/* protect qp list */
diff --git a/drivers/infiniband/hw/bnxt_re/configfs.c b/drivers/infiniband/hw/bnxt_re/configfs.c
new file mode 100644
index 0000000..d05e239
--- /dev/null
+++ b/drivers/infiniband/hw/bnxt_re/configfs.c
@@ -0,0 +1,707 @@
+/*
+ * Copyright (c) 2015-2017, Broadcom. All rights reserved.  The term
+ * Broadcom refers to Broadcom Limited and/or its subsidiaries.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS''
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
+ * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
+ * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
+ * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
+ * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
+ * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *
+ * Description: Enables configfs interface
+ */
+
+#include "configfs.h"
+
+static struct bnxt_re_dev *__get_rdev_from_name(const char *name)
+{
+	struct bnxt_re_dev *rdev;
+	u8 found = false;
+
+	mutex_lock(&bnxt_re_dev_lock);
+	list_for_each_entry(rdev, &bnxt_re_dev_list, list) {
+		if (!strcmp(name, rdev->ibdev.name)) {
+			found = true;
+			break;
+		}
+	}
+	mutex_unlock(&bnxt_re_dev_lock);
+
+	return found ? rdev : ERR_PTR(-ENODEV);
+}
+
+static struct bnxt_re_cc_group * __get_cc_group(struct config_item *item)
+{
+	struct config_group *group = container_of(item, struct config_group,
+						  cg_item);
+	struct bnxt_re_cc_group *ccgrp =
+			container_of(group, struct bnxt_re_cc_group, group);
+        return ccgrp;
+}
+
+static ssize_t apply_show(struct config_item *item, char *buf)
+{
+	return 0;
+}
+
+static ssize_t apply_store(struct config_item *item, const char *buf,
+			   size_t count)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+	unsigned int val;
+	int rc = 0;
+
+	if (!ccgrp)
+		return -EINVAL;
+
+	rdev = ccgrp->rdev;
+	sscanf(buf, "%x\n", &val);
+	if (val == BNXT_RE_MODIFY_CC) {
+		rc = bnxt_qplib_modify_cc(&rdev->qplib_res,
+					  &rdev->cc_param);
+		if (rc)
+			dev_err(rdev_to_dev(rdev),
+				"Failed to apply cc settings\n");
+	}
+
+	return rc ? -EINVAL : strnlen(buf, count);
+}
+CONFIGFS_ATTR(, apply);
+
+
+static ssize_t alt_tos_dscp_show(struct config_item *item, char *buf)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+
+	if (!ccgrp)
+		return -EINVAL;
+
+	rdev = ccgrp->rdev;
+	return sprintf(buf,"%#x\n", rdev->cc_param.alt_tos_dscp);
+}
+
+static ssize_t alt_tos_dscp_store(struct config_item *item, const char *buf,
+				   size_t count)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+	unsigned int val;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+	sscanf(buf, "%x\n", &val);
+	rdev->cc_param.alt_tos_dscp = val & 0xFF;
+	rdev->cc_param.mask |= CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_ALT_TOS_DSCP;
+
+	return strnlen(buf, count);
+}
+
+CONFIGFS_ATTR(, alt_tos_dscp);
+
+
+static ssize_t alt_vlan_pcp_show(struct config_item *item, char *buf)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	return sprintf(buf,"%#x\n", rdev->cc_param.alt_vlan_pcp);
+}
+
+static ssize_t alt_vlan_pcp_store(struct config_item *item, const char *buf,
+				  size_t count)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+	unsigned int val;
+
+	if (!ccgrp)
+		return -EINVAL;
+
+	rdev = ccgrp->rdev;
+	sscanf(buf, "%x\n", &val);
+	rdev->cc_param.alt_vlan_pcp = val & 0xFF;
+	rdev->cc_param.mask |= CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_ALT_VLAN_PCP;
+
+	return strnlen(buf, count);
+}
+CONFIGFS_ATTR(, alt_vlan_pcp);
+
+static ssize_t cc_mode_show(struct config_item *item, char *buf)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	return sprintf(buf,"%#x\n", rdev->cc_param.cc_mode);
+}
+
+static ssize_t cc_mode_store(struct config_item *item, const char *buf,
+			     size_t count)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+	unsigned int val;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	sscanf(buf, "%x\n", &val);
+	rdev->cc_param.cc_mode = val & 0xFF;
+	rdev->cc_param.mask |= CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_CC_MODE;
+
+	return strnlen(buf, count);
+}
+CONFIGFS_ATTR(, cc_mode);
+
+
+static ssize_t enable_show(struct config_item *item, char *buf)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	return sprintf(buf,"%#x\n", rdev->cc_param.enable);
+}
+
+static ssize_t enable_store(struct config_item *item, const char *buf,
+			    size_t count)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+	unsigned int val;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	sscanf(buf, "%x\n", &val);
+	rdev->cc_param.enable = val & 0xFF;
+	rdev->cc_param.mask |= CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_ENABLE_CC;
+
+	return strnlen(buf, count);
+}
+CONFIGFS_ATTR(, enable);
+
+
+static ssize_t g_show(struct config_item *item, char *buf)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	return sprintf(buf,"%#x\n", rdev->cc_param.g);
+}
+
+static ssize_t g_store(struct config_item *item, const char *buf,
+		       size_t count)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+	unsigned int val;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	sscanf(buf, "%x\n", &val);
+	rdev->cc_param.g = val & 0xFF;
+	rdev->cc_param.mask |= CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_G;
+
+	return strnlen(buf, count);
+}
+CONFIGFS_ATTR(, g);
+
+
+static ssize_t init_cr_show(struct config_item *item, char *buf)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	return sprintf(buf,"%#x\n", rdev->cc_param.init_cr);
+}
+
+static ssize_t init_cr_store(struct config_item *item, const char *buf,
+			     size_t count)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+	unsigned int val;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	sscanf(buf, "%x\n", &val);
+	rdev->cc_param.init_cr = val & 0xFFFF;
+	rdev->cc_param.mask |= CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_INIT_CR;
+
+	return strnlen(buf, count);
+}
+CONFIGFS_ATTR(, init_cr);
+
+static ssize_t inact_th_show(struct config_item *item, char *buf)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	return sprintf(buf,"%#x\n", rdev->cc_param.inact_th);
+}
+
+static ssize_t inact_th_store(struct config_item *item, const char *buf,
+			      size_t count)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+	unsigned int val;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	sscanf(buf, "%x\n", &val);
+	rdev->cc_param.inact_th = val & 0xFFFF;
+	rdev->cc_param.mask |= CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_INACTIVITY_CP;
+
+	return strnlen(buf, count);
+}
+CONFIGFS_ATTR(, inact_th);
+
+static ssize_t init_tr_show(struct config_item *item, char *buf)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	return sprintf(buf,"%#x\n", rdev->cc_param.init_tr);
+}
+
+static ssize_t init_tr_store(struct config_item *item, const char *buf,
+			     size_t count)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+	unsigned int val;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	sscanf(buf, "%x\n", &val);
+	rdev->cc_param.init_tr = val & 0xFFFF;
+	rdev->cc_param.mask |= CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_INIT_TR;
+
+	return strnlen(buf, count);
+}
+CONFIGFS_ATTR(, init_tr);
+
+static ssize_t nph_per_state_show(struct config_item *item, char *buf)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	return sprintf(buf,"%#x\n", rdev->cc_param.nph_per_state);
+}
+
+static ssize_t nph_per_state_store(struct config_item *item, const char *buf,
+			   size_t count)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+	unsigned int val;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	sscanf(buf, "%x\n", &val);
+	rdev->cc_param.nph_per_state = val & 0xFF;
+	rdev->cc_param.mask |=
+		CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_NUMPHASEPERSTATE;
+
+	return strnlen(buf, count);
+}
+CONFIGFS_ATTR(, nph_per_state);
+
+static ssize_t rtt_show(struct config_item *item, char *buf)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	return sprintf(buf,"%#x\n", rdev->cc_param.rtt);
+}
+
+static ssize_t rtt_store(struct config_item *item, const char *buf,
+			 size_t count)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+	unsigned int val;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	sscanf(buf, "%x\n", &val);
+	rdev->cc_param.rtt = val & 0xFFFF;
+	rdev->cc_param.mask |= CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_RTT;
+
+	return strnlen(buf, count);
+}
+CONFIGFS_ATTR(, rtt);
+
+static ssize_t tcp_cp_show(struct config_item *item, char *buf)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	return sprintf(buf,"%#x\n", rdev->cc_param.tcp_cp);
+}
+
+static ssize_t tcp_cp_store(struct config_item *item, const char *buf,
+			    size_t count)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+	unsigned int val;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	sscanf(buf, "%x\n", &val);
+	rdev->cc_param.tcp_cp = val & 0xFFFF;
+	rdev->cc_param.mask |= CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_TCP_CP;
+
+	return strnlen(buf, count);
+}
+CONFIGFS_ATTR(, tcp_cp);
+
+static ssize_t tos_dscp_show(struct config_item *item, char *buf)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	return sprintf(buf,"%#x\n", rdev->cc_param.tos_dscp);
+}
+
+static ssize_t tos_dscp_store(struct config_item *item, const char *buf,
+			      size_t count)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+	unsigned int val;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	sscanf(buf, "%x\n", &val);
+	rdev->cc_param.tos_dscp = val & 0xFF;
+	rdev->cc_param.mask |= CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_TOS_DSCP;
+
+	return strnlen(buf, count);
+}
+CONFIGFS_ATTR(, tos_dscp);
+
+static ssize_t tos_ecn_show(struct config_item *item, char *buf)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	return sprintf(buf,"%#x\n", rdev->cc_param.tos_ecn);
+}
+
+static ssize_t tos_ecn_store(struct config_item *item, const char *buf,
+			     size_t count)
+{
+	struct bnxt_re_cc_group *ccgrp = __get_cc_group(item);
+	struct bnxt_re_dev *rdev;
+	unsigned int val;
+
+	if (!ccgrp)
+		return -EINVAL;
+	rdev = ccgrp->rdev;
+
+	sscanf(buf, "%x\n", &val);
+	rdev->cc_param.tos_ecn = val & 0xFF;
+	rdev->cc_param.mask |= CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_TOS_ECN;
+
+	return strnlen(buf, count);
+}
+CONFIGFS_ATTR(, tos_ecn);
+
+static struct configfs_attribute *bnxt_re_cc_attrs[] = {
+	&attr_apply,
+	&attr_alt_tos_dscp,
+	&attr_alt_vlan_pcp,
+	&attr_cc_mode,
+	&attr_enable,
+	&attr_g,
+	&attr_init_cr,
+	&attr_inact_th,
+	&attr_init_tr,
+	&attr_nph_per_state,
+	&attr_rtt,
+	&attr_tcp_cp,
+	&attr_tos_dscp,
+	&attr_tos_ecn,
+	NULL,
+};
+
+static struct config_item_type bnxt_re_ccgrp_type = {
+	.ct_attrs = bnxt_re_cc_attrs,
+	.ct_owner = THIS_MODULE,
+};
+
+static int make_bnxt_re_cc(struct bnxt_re_port_group *portgrp,
+			   struct bnxt_re_dev *rdev)
+{
+	struct bnxt_re_cc_group *ccgrp;
+	int rc;
+
+	ccgrp = kzalloc(sizeof(*ccgrp), GFP_KERNEL);
+	if (!ccgrp) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	ccgrp->rdev = rdev;
+	config_group_init_type_name(&ccgrp->group, "cc", &bnxt_re_ccgrp_type);
+	configfs_add_default_group(&ccgrp->group, &portgrp->nportgrp);
+	portgrp->ccgrp = ccgrp;
+
+	return 0;
+out:
+	kfree(ccgrp);
+	return rc;
+}
+
+
+static void bnxt_re_release_nport_group(struct config_item *item)
+{
+	struct config_group *group = container_of(item, struct config_group,
+						  cg_item);
+	struct bnxt_re_port_group *portgrp =
+				container_of(group, struct bnxt_re_port_group,
+					     nportgrp);
+	kfree(portgrp->ccgrp);
+}
+
+static struct configfs_item_operations bnxt_re_nport_item_ops = {
+        .release = bnxt_re_release_nport_group
+};
+
+static struct config_item_type bnxt_re_nportgrp_type = {
+        .ct_item_ops = &bnxt_re_nport_item_ops,
+        .ct_owner = THIS_MODULE,
+};
+
+static int make_bnxt_re_ports(struct bnxt_re_dev_group *devgrp,
+			      struct bnxt_re_dev *rdev)
+{
+	struct bnxt_re_port_group *ports;
+	struct ib_device *ibdev;
+	int nports, rc, indx;
+
+	if (!rdev)
+		return -ENODEV;
+	ibdev = &rdev->ibdev;
+	nports = ibdev->phys_port_cnt;
+	ports = kcalloc(nports, sizeof(*ports), GFP_KERNEL);
+	if (!ports) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	for (indx = 0; indx < nports; indx++) {
+		char port_name[10];
+		ports[indx].port_num = indx + 1;
+		snprintf(port_name, sizeof(port_name), "%u", indx + 1);
+		ports[indx].devgrp = devgrp;
+		config_group_init_type_name(&ports[indx].nportgrp,
+					    port_name, &bnxt_re_nportgrp_type);
+		rc = make_bnxt_re_cc(&ports[indx], rdev);
+		if (rc)
+			goto out;
+		configfs_add_default_group(&ports[indx].nportgrp,
+					   &devgrp->port_group);
+	}
+	devgrp->ports = ports;
+
+	return 0;
+out:
+	kfree(ports);
+	return rc;
+}
+
+static void bnxt_re_release_device_group(struct config_item *item)
+{
+	struct config_group *group = container_of(item, struct config_group,
+						  cg_item);
+	struct bnxt_re_dev_group *devgrp =
+				container_of(group, struct bnxt_re_dev_group,
+					     dev_group);
+	kfree(devgrp);
+}
+
+static void bnxt_re_release_ports_group(struct config_item *item)
+{
+	struct config_group *group = container_of(item, struct config_group,
+						  cg_item);
+	struct bnxt_re_dev_group *devgrp =
+				 container_of(group, struct bnxt_re_dev_group,
+					      port_group);
+	kfree(devgrp->ports);
+	devgrp->ports = NULL;
+}
+
+static struct configfs_item_operations bnxt_re_ports_item_ops = {
+	.release = bnxt_re_release_ports_group
+};
+
+static struct config_item_type bnxt_re_ports_group_type = {
+	.ct_item_ops = &bnxt_re_ports_item_ops,
+	.ct_owner = THIS_MODULE,
+};
+
+static struct configfs_item_operations bnxt_re_dev_item_ops = {
+	.release = bnxt_re_release_device_group
+};
+
+static struct config_item_type bnxt_re_dev_group_type = {
+	.ct_item_ops = &bnxt_re_dev_item_ops,
+	.ct_owner = THIS_MODULE,
+};
+
+static struct config_group *make_bnxt_re_dev(struct config_group *group,
+					     const char *name)
+{
+	struct bnxt_re_dev *rdev;
+	struct bnxt_re_dev_group *devgrp = NULL;
+	int rc = -ENODEV;
+
+	rdev = __get_rdev_from_name(name);
+	if (PTR_ERR(rdev) == -ENODEV)
+		goto out;
+
+	devgrp = kzalloc(sizeof(*devgrp), GFP_KERNEL);
+	if (!devgrp) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	strncpy(devgrp->name, name, sizeof(devgrp->name));
+	config_group_init_type_name(&devgrp->port_group, "ports",
+                                    &bnxt_re_ports_group_type);
+	rc = make_bnxt_re_ports(devgrp, rdev);
+	if (rc)
+		goto out;
+	config_group_init_type_name(&devgrp->dev_group, name,
+                                    &bnxt_re_dev_group_type);
+	configfs_add_default_group(&devgrp->port_group,
+				   &devgrp->dev_group);
+	return &devgrp->dev_group;
+out:
+	kfree(devgrp);
+	return ERR_PTR(rc);
+}
+
+static struct configfs_group_operations bnxt_re_group_ops = {
+	.make_group = &make_bnxt_re_dev
+};
+
+static struct config_item_type bnxt_re_subsys_type = {
+	.ct_group_ops	= &bnxt_re_group_ops,
+	.ct_owner	= THIS_MODULE,
+};
+
+static struct configfs_subsystem bnxt_re_subsys = {
+	.su_group	= {
+		.cg_item	= {
+			.ci_namebuf	= "bnxt_re",
+			.ci_type	= &bnxt_re_subsys_type,
+		},
+	},
+};
+
+int bnxt_re_configfs_init(void)
+{
+	config_group_init(&bnxt_re_subsys.su_group);
+	mutex_init(&bnxt_re_subsys.su_mutex);
+	return configfs_register_subsystem(&bnxt_re_subsys);
+}
+
+void bnxt_re_configfs_exit(void)
+{
+	configfs_unregister_subsystem(&bnxt_re_subsys);
+}
diff --git a/drivers/infiniband/hw/bnxt_re/configfs.h b/drivers/infiniband/hw/bnxt_re/configfs.h
new file mode 100644
index 0000000..88f7edc
--- /dev/null
+++ b/drivers/infiniband/hw/bnxt_re/configfs.h
@@ -0,0 +1,93 @@
+/*
+ * Copyright (c) 2015-2017, Broadcom. All rights reserved.  The term
+ * Broadcom refers to Broadcom Limited and/or its subsidiaries.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS''
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
+ * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
+ * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
+ * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
+ * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
+ * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *
+ * Description: defines data-structure for configfs interface
+ */
+#ifndef __BNXT_RE_CONFIGFS_H__
+#define __BNXT_RE_CONFIGFS_H__
+
+#include <linux/module.h>
+#include <linux/configfs.h>
+
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_user_verbs.h>
+#include <rdma/ib_umem.h>
+#include <rdma/ib_addr.h>
+
+#include "bnxt_ulp.h"
+#include "roce_hsi.h"
+#include "qplib_res.h"
+#include "qplib_sp.h"
+#include "qplib_fp.h"
+#include "qplib_rcfw.h"
+#include "bnxt_re.h"
+
+extern struct list_head bnxt_re_dev_list;
+extern u32 adapter_count;
+extern struct mutex bnxt_re_dev_lock;
+
+enum bnxt_re_configfs_cmd {
+	BNXT_RE_MODIFY_CC = 0x01,
+};
+
+struct bnxt_re_cc_group;
+struct bnxt_re_port_group;
+struct bnxt_re_dev_group;
+
+struct bnxt_re_cc_group
+{
+	struct bnxt_re_dev *rdev;
+	struct bnxt_re_port_group *portgrp;
+	struct config_group group;
+};
+
+struct bnxt_re_port_group
+{
+	unsigned int port_num;
+	struct bnxt_re_dev_group *devgrp;
+	struct bnxt_re_cc_group *ccgrp;
+	struct config_group nportgrp;
+};
+
+struct bnxt_re_dev_group
+{
+	char name[IB_DEVICE_NAME_MAX];
+	struct config_group dev_group;
+	struct config_group port_group;
+	struct bnxt_re_port_group *ports;
+};
+
+int bnxt_re_configfs_init(void);
+void bnxt_re_configfs_exit(void);
+#endif
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 82d1cbc..6ea3ae8 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -65,6 +65,7 @@
 #include <rdma/bnxt_re-abi.h>
 #include "bnxt.h"
 #include "hw_counters.h"
+#include "configfs.h"
 
 static char version[] =
 		BNXT_RE_DESC " v" ROCE_DRV_MODULE_VERSION "\n";
@@ -74,9 +75,9 @@
 MODULE_LICENSE("Dual BSD/GPL");
 
 /* globals */
-static struct list_head bnxt_re_dev_list = LIST_HEAD_INIT(bnxt_re_dev_list);
+struct list_head bnxt_re_dev_list = LIST_HEAD_INIT(bnxt_re_dev_list);
 /* Mutex to protect the list of bnxt_re devices added */
-static DEFINE_MUTEX(bnxt_re_dev_lock);
+DEFINE_MUTEX(bnxt_re_dev_lock);
 static struct workqueue_struct *bnxt_re_wq;
 
 /* for handling bnxt_en callbacks later */
@@ -1357,6 +1358,7 @@ static int __init bnxt_re_mod_init(void)
 	if (!bnxt_re_wq)
 		return -ENOMEM;
 
+	bnxt_re_configfs_init();
 	INIT_LIST_HEAD(&bnxt_re_dev_list);
 
 	rc = register_netdevice_notifier(&bnxt_re_netdev_notifier);
@@ -1368,6 +1370,7 @@ static int __init bnxt_re_mod_init(void)
 	return 0;
 
 err_netdev:
+	bnxt_re_configfs_exit();
 	destroy_workqueue(bnxt_re_wq);
 
 	return rc;
@@ -1376,6 +1379,7 @@ static int __init bnxt_re_mod_init(void)
 static void __exit bnxt_re_mod_exit(void)
 {
 	unregister_netdevice_notifier(&bnxt_re_netdev_notifier);
+	bnxt_re_configfs_exit();
 	if (bnxt_re_wq)
 		destroy_workqueue(bnxt_re_wq);
 }
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index e277e54..2438477 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -730,3 +730,35 @@ int bnxt_qplib_map_tc2cos(struct bnxt_qplib_res *res, u16 *cids)
 					  (void *)&resp, NULL, 0);
 	return 0;
 }
+
+int bnxt_qplib_modify_cc(struct bnxt_qplib_res *res,
+			 struct bnxt_qplib_cc_param *cc_param)
+{
+	struct cmdq_modify_roce_cc req;
+	struct creq_modify_roce_cc_resp resp;
+	u16 cmd_flags = 0;
+	int rc;
+
+	RCFW_CMD_PREP(req, MODIFY_CC, cmd_flags);
+	req.modify_mask = cpu_to_le32(cc_param->mask);
+	cc_param->mask = 0x00; /* reset mask for next. */
+	req.enable_cc = cc_param->enable;
+	req.g = cc_param->g;
+	req.num_phases_per_state = cc_param->nph_per_state;
+	req.init_cr = cpu_to_le16(cc_param->init_cr);
+	req.init_tr = cpu_to_le16(cc_param->init_tr);
+	req.tos_dscp_tos_ecn = (cc_param->tos_dscp <<
+				CMDQ_MODIFY_ROCE_CC_TOS_DSCP_SFT) |
+			        (cc_param->tos_ecn &
+				CMDQ_MODIFY_ROCE_CC_TOS_ECN_MASK);
+	req.alt_vlan_pcp = cc_param->alt_vlan_pcp;
+	req.alt_tos_dscp = cpu_to_le16(cc_param->alt_tos_dscp);
+	req.rtt = cpu_to_le16(cc_param->rtt);
+	req.tcp_cp = cpu_to_le16(cc_param->tcp_cp);
+	req.cc_mode = cc_param->cc_mode;
+	req.inactivity_th = cpu_to_le16(cc_param->inact_th);
+
+	rc = bnxt_qplib_rcfw_send_message(res->rcfw, (void *)&req,
+					  (void *)&resp, NULL, 0);
+	return rc;
+}
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.h b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
index 1132258..87173701 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
@@ -119,6 +119,23 @@ struct bnxt_qplib_frpl {
 	struct bnxt_qplib_hwq		hwq;
 };
 
+struct bnxt_qplib_cc_param {
+	u8 alt_vlan_pcp;
+	u8 alt_tos_dscp;
+	u8 cc_mode;
+	u8 enable;
+	u16 inact_th;
+	u16 init_cr;
+	u16 init_tr;
+	u16 rtt;
+	u8 g;
+	u8 nph_per_state;
+	u8 tos_ecn;
+	u8 tos_dscp;
+	u16 tcp_cp;
+	u32 mask;
+};
+
 #define BNXT_QPLIB_ACCESS_LOCAL_WRITE	BIT(0)
 #define BNXT_QPLIB_ACCESS_REMOTE_READ	BIT(1)
 #define BNXT_QPLIB_ACCESS_REMOTE_WRITE	BIT(2)
@@ -164,4 +181,6 @@ int bnxt_qplib_alloc_fast_reg_page_list(struct bnxt_qplib_res *res,
 int bnxt_qplib_free_fast_reg_page_list(struct bnxt_qplib_res *res,
 				       struct bnxt_qplib_frpl *frpl);
 int bnxt_qplib_map_tc2cos(struct bnxt_qplib_res *res, u16 *cids);
+int bnxt_qplib_modify_cc(struct bnxt_qplib_res *res,
+			 struct bnxt_qplib_cc_param *cc_param);
 #endif /* __BNXT_QPLIB_SP_H__*/
diff --git a/drivers/infiniband/hw/bnxt_re/roce_hsi.h b/drivers/infiniband/hw/bnxt_re/roce_hsi.h
index eeb55b2..60b61cb 100644
--- a/drivers/infiniband/hw/bnxt_re/roce_hsi.h
+++ b/drivers/infiniband/hw/bnxt_re/roce_hsi.h
@@ -1853,6 +1853,95 @@ struct cmdq_query_version {
 	__le64 resp_addr;
 };
 
+/* Modify congestion control command (56 bytes) */
+struct cmdq_modify_roce_cc {
+	u8 opcode;
+	#define CMDQ_MODIFY_ROCE_CC_OPCODE_MODIFY_ROCE_CC		0x8cUL
+	u8 cmd_size;
+	__le16 flags;
+	__le16 cookie;
+	u8 resp_size;
+	u8 reserved8;
+	__le64 resp_addr;
+	__le32 modify_mask;
+	#define CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_ENABLE_CC		0x1UL
+	#define CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_G			0x2UL
+	#define CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_NUMPHASEPERSTATE	0x4UL
+	#define CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_INIT_CR			0x8UL
+	#define CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_INIT_TR			0x10UL
+	#define CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_TOS_ECN			0x20UL
+	#define CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_TOS_DSCP		0x40UL
+	#define CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_ALT_VLAN_PCP		0x80UL
+	#define CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_ALT_TOS_DSCP		0x100UL
+	#define CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_RTT			0x200UL
+	#define CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_CC_MODE			0x400UL
+	#define CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_TCP_CP			0x800UL
+	#define CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_TX_QUEUE		0x1000UL
+	#define CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_INACTIVITY_CP		0x2000UL
+	u8 enable_cc;
+	#define CMDQ_MODIFY_ROCE_CC_ENABLE_CC				0x1UL
+	#define CMDQ_MODIFY_ROCE_CC_RSVD1_MASK				0xfeUL
+	#define CMDQ_MODIFY_ROCE_CC_RSVD1_SFT				1
+	u8 g;
+	#define CMDQ_MODIFY_ROCE_CC_G_MASK				0x7UL
+	#define CMDQ_MODIFY_ROCE_CC_G_SFT				0
+	#define CMDQ_MODIFY_ROCE_CC_RSVD2_MASK				0xf8UL
+	#define CMDQ_MODIFY_ROCE_CC_RSVD2_SFT				3
+	u8 num_phases_per_state;
+	u8 rsvd9;
+	__le16 init_cr;
+	__le16 init_tr;
+	u8 tos_dscp_tos_ecn;
+	#define CMDQ_MODIFY_ROCE_CC_TOS_ECN_MASK			0x3UL
+	#define CMDQ_MODIFY_ROCE_CC_TOS_ECN_SFT				0
+	#define CMDQ_MODIFY_ROCE_CC_TOS_DSCP_MASK			0xfcUL
+	#define CMDQ_MODIFY_ROCE_CC_TOS_DSCP_SFT			2
+	u8 alt_vlan_pcp;
+	#define CMDQ_MODIFY_ROCE_CC_ALT_VLAN_PCP_MASK			0x7UL
+	#define CMDQ_MODIFY_ROCE_CC_ALT_VLAN_PCP_SFT			0
+	#define CMDQ_MODIFY_ROCE_CC_RSVD3_MASK				0xf8UL
+	#define CMDQ_MODIFY_ROCE_CC_RSVD3_SFT				3
+	__le16 alt_tos_dscp;
+	#define CMDQ_MODIFY_ROCE_CC_ALT_TOS_DSCP_MASK			0x3fUL
+	#define CMDQ_MODIFY_ROCE_CC_ALT_TOS_DSCP_SFT			0
+	#define CMDQ_MODIFY_ROCE_CC_RSVD4_MASK				0xffc0UL
+	#define CMDQ_MODIFY_ROCE_CC_RSVD4_SFT				6
+	__le16 rtt;
+	#define CMDQ_MODIFY_ROCE_CC_RTT_MASK				0x3fffUL
+	#define CMDQ_MODIFY_ROCE_CC_RTT_SFT				0
+	#define CMDQ_MODIFY_ROCE_CC_RSVD5_MASK				0xc000UL
+	#define CMDQ_MODIFY_ROCE_CC_RSVD5_SFT				14
+	__le16 tcp_cp;
+	#define CMDQ_MODIFY_ROCE_CC_TCP_CP_MASK				0x3ffUL
+	#define CMDQ_MODIFY_ROCE_CC_TCP_CP_SFT				0
+	#define CMDQ_MODIFY_ROCE_CC_RSVD6_MASK				0xfc00UL
+	#define CMDQ_MODIFY_ROCE_CC_RSVD6_SFT				10
+	u8 cc_mode;
+	#define CMDQ_MODIFY_ROCE_CC_CC_MODE				0x1UL
+	#define CMDQ_MODIFY_ROCE_CC_RSVD7_MASK				0xfeUL
+	#define CMDQ_MODIFY_ROCE_CC_RSVD7_SFT				1
+	u8 tx_queue;
+	#define CMDQ_MODIFY_ROCE_CC_TX_QUEUE_MASK			0x3UL
+	#define CMDQ_MODIFY_ROCE_CC_TX_QUEUE_SFT			0
+	#define CMDQ_MODIFY_ROCE_CC_RSVD8_MASK				0xfcUL
+	#define CMDQ_MODIFY_ROCE_CC_RSVD8_SFT				2
+	__le16 inactivity_th;
+	__le64 reserved64;
+	__le64 reserved64_1;
+};
+
+/* Query congestion control command (16 bytes) */
+struct cmdq_query_roce_cc {
+	u8 opcode;
+	#define CMDQ_QUERY_ROCE_CC_OPCODE_QUERY_ROCE_CC		0x8dUL
+	u8 cmd_size;
+	__le16 flags;
+	__le16 cookie;
+	u8 resp_size;
+	u8 reserved8;
+	__le64 resp_addr;
+};
+
 /* Command-Response Event Queue (CREQ) Structures */
 /* Base CREQ Record (16 bytes) */
 struct creq_base {
@@ -2715,70 +2804,67 @@ struct creq_query_version_resp {
 };
 
 /* Modify congestion control command response (16 bytes) */
-struct creq_modify_cc_resp {
+struct creq_modify_roce_cc_resp {
 	u8 type;
-	#define CREQ_MODIFY_CC_RESP_TYPE_MASK			    0x3fUL
-	#define CREQ_MODIFY_CC_RESP_TYPE_SFT			    0
-	#define CREQ_MODIFY_CC_RESP_TYPE_QP_EVENT		   0x38UL
-	#define CREQ_MODIFY_CC_RESP_RESERVED2_MASK		    0xc0UL
-	#define CREQ_MODIFY_CC_RESP_RESERVED2_SFT		    6
+	#define CREQ_MODIFY_ROCE_CC_RESP_TYPE_MASK			0x3fUL
+	#define CREQ_MODIFY_ROCE_CC_RESP_TYPE_SFT			0
+	#define CREQ_MODIFY_ROCE_CC_RESP_TYPE_QP_EVENT			0x38UL
+	#define CREQ_MODIFY_ROCE_CC_RESP_RESERVED2_MASK			0xc0UL
+	#define CREQ_MODIFY_ROCE_CC_RESP_RESERVED2_SFT			6
 	u8 status;
 	__le16 cookie;
 	__le32 reserved32;
 	u8 v;
-	#define CREQ_MODIFY_CC_RESP_V				    0x1UL
-	#define CREQ_MODIFY_CC_RESP_RESERVED7_MASK		    0xfeUL
-	#define CREQ_MODIFY_CC_RESP_RESERVED7_SFT		    1
+	#define CREQ_MODIFY_ROCE_CC_RESP_V				0x1UL
+	#define CREQ_MODIFY_ROCE_CC_RESP_RESERVED7_MASK			0xfeUL
+	#define CREQ_MODIFY_ROCE_CC_RESP_RESERVED7_SFT			1
 	u8 event;
-	#define CREQ_MODIFY_CC_RESP_EVENT_MODIFY_CC		   0x8cUL
+	#define CREQ_MODIFY_ROCE_CC_RESP_EVENT_MODIFY_ROCE_CC		0x8cUL
 	__le16 reserved48[3];
 };
 
 /* Query congestion control command response (16 bytes) */
-struct creq_query_cc_resp {
+struct creq_query_roce_cc_resp {
 	u8 type;
-	#define CREQ_QUERY_CC_RESP_TYPE_MASK			    0x3fUL
-	#define CREQ_QUERY_CC_RESP_TYPE_SFT			    0
-	#define CREQ_QUERY_CC_RESP_TYPE_QP_EVENT		   0x38UL
-	#define CREQ_QUERY_CC_RESP_RESERVED2_MASK		    0xc0UL
-	#define CREQ_QUERY_CC_RESP_RESERVED2_SFT		    6
+	#define CREQ_QUERY_ROCE_CC_RESP_TYPE_MASK			0x3fUL
+	#define CREQ_QUERY_ROCE_CC_RESP_TYPE_SFT			0
+	#define CREQ_QUERY_ROCE_CC_RESP_TYPE_QP_EVENT			0x38UL
+	#define CREQ_QUERY_ROCE_CC_RESP_RESERVED2_MASK			0xc0UL
+	#define CREQ_QUERY_ROCE_CC_RESP_RESERVED2_SFT			6
 	u8 status;
 	__le16 cookie;
 	__le32 size;
 	u8 v;
-	#define CREQ_QUERY_CC_RESP_V				    0x1UL
-	#define CREQ_QUERY_CC_RESP_RESERVED7_MASK		    0xfeUL
-	#define CREQ_QUERY_CC_RESP_RESERVED7_SFT		    1
+	#define CREQ_QUERY_ROCE_CC_RESP_V				0x1UL
+	#define CREQ_QUERY_ROCE_CC_RESP_RESERVED7_MASK			0xfeUL
+	#define CREQ_QUERY_ROCE_CC_RESP_RESERVED7_SFT			1
 	u8 event;
-	#define CREQ_QUERY_CC_RESP_EVENT_QUERY_CC		   0x8dUL
+	#define CREQ_QUERY_ROCE_CC_RESP_EVENT_QUERY_ROCE_CC		0x8dUL
 	__le16 reserved48[3];
 };
 
 /* Query congestion control command response side buffer structure (32 bytes) */
-struct creq_query_cc_resp_sb {
+struct creq_query_roce_cc_resp_sb {
 	u8 opcode;
-	#define CREQ_QUERY_CC_RESP_SB_OPCODE_QUERY_CC		   0x8dUL
+	#define CREQ_QUERY_ROCE_CC_RESP_SB_OPCODE_QUERY_ROCE_CC		0x8dUL
 	u8 status;
 	__le16 cookie;
 	__le16 flags;
 	u8 resp_size;
 	u8 reserved8;
 	u8 enable_cc;
-	#define CREQ_QUERY_CC_RESP_SB_ENABLE_CC		    0x1UL
+	#define CREQ_QUERY_ROCE_CC_RESP_SB_ENABLE_CC			0x1UL
+	u8 tos_dscp_tos_ecn;
+	#define CREQ_QUERY_ROCE_CC_RESP_SB_TOS_ECN_MASK			0x3UL
+	#define CREQ_QUERY_ROCE_CC_RESP_SB_TOS_ECN_SFT			0
+	#define CREQ_QUERY_ROCE_CC_RESP_SB_TOS_DSCP_MASK		0xfcUL
+	#define CREQ_QUERY_ROCE_CC_RESP_SB_TOS_DSCP_SFT			2
 	u8 g;
-	#define CREQ_QUERY_CC_RESP_SB_G_MASK			    0x7UL
-	#define CREQ_QUERY_CC_RESP_SB_G_SFT			    0
+	#define CREQ_QUERY_ROCE_CC_RESP_SB_G_MASK			0x7UL
+	#define CREQ_QUERY_ROCE_CC_RESP_SB_G_SFT			0
 	u8 num_phases_per_state;
 	__le16 init_cr;
-	u8 unused_2;
-	__le16 unused_3;
-	u8 unused_4;
 	__le16 init_tr;
-	u8 tos_dscp_tos_ecn;
-	#define CREQ_QUERY_CC_RESP_SB_TOS_ECN_MASK		    0x3UL
-	#define CREQ_QUERY_CC_RESP_SB_TOS_ECN_SFT		    0
-	#define CREQ_QUERY_CC_RESP_SB_TOS_DSCP_MASK		    0xfcUL
-	#define CREQ_QUERY_CC_RESP_SB_TOS_DSCP_SFT		    2
 	__le64 reserved64;
 	__le64 reserved64_1;
 };
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
