From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/3] IB Netlink Infrastructure
Date: Sun, 14 Nov 2010 18:12:49 +0200
Message-ID: <4CE00A81.3010401@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The basic IB netlink infrastructure and makefile addons.
A new kernel module is implemented which doesn't depend on IB modules.
It allows for registration of IB module for which data is to be exported.

Signed-off-by: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/Kconfig        |    8 ++
 drivers/infiniband/core/Makefile  |    6 +
 drivers/infiniband/core/netlink.c |  182 +++++++++++++++++++++++++++++++++++++
 include/linux/netlink.h           |    1 +
 include/net/ib_netlink.h          |   41 ++++++++
 5 files changed, 238 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/core/netlink.c
 create mode 100644 include/net/ib_netlink.h

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 6e35ecc..8d8a40a 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -30,6 +30,14 @@ config INFINIBAND_USER_ACCESS
 	  libibverbs, libibcm and a hardware driver library from
 	  <http://www.openfabrics.org/git/>.
 
+config INFINIBAND_NETLINK
+	tristate "InfiniBand netlink interface"
+	---help---
+	  Infiniband netlink infrastrucure and modules. This allows
+	  for IB module data to be exported into userspace using
+	  netlink socket applications.
+	  <http://www.openib.org>.
+
 config INFINIBAND_USER_MEM
 	bool
 	depends on INFINIBAND_USER_ACCESS != n
diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index cb1ab3e..c088233 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -7,6 +7,8 @@ obj-$(CONFIG_INFINIBAND_USER_MAD) +=	ib_umad.o
 obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
 					$(user_access-y)
 
+obj-$(CONFIG_INFINIBAND_NETLINK) +=	ib_netlink.o ib_netlink_rdma_cm.o
+
 ib_core-y :=			packer.o ud_header.o verbs.o sysfs.o \
 				device.o fmr_pool.o cache.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
@@ -30,3 +32,7 @@ ib_umad-y :=			user_mad.o
 ib_ucm-y :=			ucm.o
 
 ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o
+
+ib_netlink-y :=			netlink.o
+
+ib_netlink_rdma_cm-y :=			netlink_cma.o
diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
new file mode 100644
index 0000000..41fab69
--- /dev/null
+++ b/drivers/infiniband/core/netlink.c
@@ -0,0 +1,182 @@
+/*
+ * Copyright (c) 2010 Voltaire Inc.  All rights reserved.
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
+#define pr_fmt(fmt) "%s:%s: " fmt, KBUILD_MODNAME, __func__
+
+#include <linux/module.h>
+#include <linux/netlink.h>
+
+#include <net/netlink.h>
+#include <net/net_namespace.h>
+#include <net/ib_netlink.h>
+
+MODULE_AUTHOR("Nir Muchtar");
+MODULE_DESCRIPTION("IB Netlink Adapter");
+MODULE_LICENSE("Dual BSD/GPL");
+
+struct ibnl_cb {
+	struct list_head	list;
+	int module;
+	int (*get_size)(int op, int *size);
+	int (*get_data)(int op, char *buf, int len);
+};
+
+static DEFINE_MUTEX(ibnl_mutex);
+static struct sock *nls;
+static LIST_HEAD(cb_list);
+
+int ibnl_add_cb(int module, int (*get_size)(int op, int *size),
+		int (*get_data)(int op, char *buf, int len))
+{
+	struct ibnl_cb *cur;
+	struct ibnl_cb *nl_cb = kmalloc(sizeof *nl_cb, GFP_KERNEL);
+
+	if (!nl_cb)
+		return -ENOMEM;
+	nl_cb->module = module;
+	nl_cb->get_size = get_size;
+	nl_cb->get_data = get_data;
+	mutex_lock(&ibnl_mutex);
+	list_for_each_entry(cur, &cb_list, list) {
+		if (cur->module == module) {
+			pr_warn("Callback for %d already exists\n", module);
+			mutex_unlock(&ibnl_mutex);
+			return -EINVAL;
+		}
+	}
+	list_add_tail(&nl_cb->list, &cb_list);
+	mutex_unlock(&ibnl_mutex);
+	return 0;
+}
+EXPORT_SYMBOL(ibnl_add_cb);
+
+int ibnl_remove_cb(int module)
+{
+	struct ibnl_cb *cur, *next;
+
+	mutex_lock(&ibnl_mutex);
+	list_for_each_entry_safe(cur, next, &cb_list, list) {
+		if (cur->module == module) {
+			list_del(&(cur->list));
+			kfree(cur);
+			mutex_unlock(&ibnl_mutex);
+			return 0;
+		}
+	}
+	pr_warn("Can't remove callback for module %d. Not found\n", module);
+	mutex_unlock(&ibnl_mutex);
+	return -EINVAL;
+}
+EXPORT_SYMBOL(ibnl_remove_cb);
+
+static int ibnl_send_unicast(int pid, int op, struct ibnl_cb *cb)
+{
+	void *data;
+	struct nlmsghdr *nl_hdr;
+	int size, ret;
+	struct sk_buff *nl_skb = NULL;
+
+	ret = cb->get_size(op, &size);
+	if (ret)
+		goto err;
+	nl_skb = alloc_skb(NLMSG_SPACE(size), GFP_KERNEL);
+	if (!nl_skb) {
+		pr_info("Couldn't allocate skb\n");
+		goto nlmsg_failure;
+	}
+	nl_hdr = NLMSG_PUT(nl_skb, 0, 0, 0, size);
+	data = NLMSG_DATA(nl_hdr);
+	ret = cb->get_data(op, data, size);
+	/* We send all available data even if the buffer was too small. */
+	if (ret && ret != -ENOMEM)
+		goto err;
+	netlink_unicast(nls, nl_skb, pid, MSG_DONTWAIT);
+	return 0;
+
+nlmsg_failure:
+	if (nl_skb)
+		kfree_skb(nl_skb);
+	return -ENOMEM;
+err:
+	if (nl_skb)
+		kfree_skb(nl_skb);
+	return ret;
+}
+
+static int ibnl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
+{
+	struct ibnl_cb *cb;
+	int type = nlh->nlmsg_type;
+	int pid = nlh->nlmsg_pid;
+	int module = IBNL_GET_MODULE(type);
+
+	list_for_each_entry(cb, &cb_list, list) {
+		if (cb->module == module)
+			return ibnl_send_unicast(pid, IBNL_GET_OP(type), cb);
+	}
+	pr_info("Callback for module %d not found\n", module);
+	return -EINVAL;
+}
+
+static void ibnl_rcv(struct sk_buff *skb)
+{
+	mutex_lock(&ibnl_mutex);
+	netlink_rcv_skb(skb, &ibnl_rcv_msg);
+	mutex_unlock(&ibnl_mutex);
+}
+
+static int __init ibnl_init(void)
+{
+	nls = netlink_kernel_create(&init_net, NETLINK_INFINIBAND, 0, ibnl_rcv,
+				    NULL, THIS_MODULE);
+	if (!nls) {
+		pr_warn("Failed to create netlink socket\n");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static void __exit ibnl_cleanup(void)
+{
+	struct ibnl_cb *cur, *next;
+
+	mutex_lock(&ibnl_mutex);
+	list_for_each_entry_safe(cur, next, &cb_list, list) {
+		list_del(&(cur->list));
+		kfree(cur);
+	}
+	mutex_unlock(&ibnl_mutex);
+	netlink_kernel_release(nls);
+}
+
+module_init(ibnl_init);
+module_exit(ibnl_cleanup);
diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 1235669..c9693f9 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -24,6 +24,7 @@
 /* leave room for NETLINK_DM (DM Events) */
 #define NETLINK_SCSITRANSPORT	18	/* SCSI Transports */
 #define NETLINK_ECRYPTFS	19
+#define NETLINK_INFINIBAND	20
 
 #define MAX_LINKS 32		
 
diff --git a/include/net/ib_netlink.h b/include/net/ib_netlink.h
new file mode 100644
index 0000000..3cf0e84
--- /dev/null
+++ b/include/net/ib_netlink.h
@@ -0,0 +1,41 @@
+#ifndef _IBNETLINK_H
+#define _IBNETLINK_H
+
+#include <rdma/rdma_cm.h>
+
+enum {
+	IBNL_RDMA_CM = 1
+};
+
+enum {
+	IBNL_RDMA_CM_STATS = 0
+};
+
+#define IBNL_GET_MODULE(type) ((type & (((1 << 6) - 1) << 10)) >> 10)
+#define IBNL_GET_OP(type) (type & ((1 << 10) - 1))
+#define IBNL_GET_TYPE(module, op) ((module << 10) + op)
+
+#ifdef __KERNEL__
+
+/**
+ * Add a callback for an IB module to the IB netlink module.
+ * @module: The added IB module
+ * @get_size: A callback for obtaining the necessary size for the returned data
+ * @get_data: A callback for obtaining the data
+ *
+ * Returns 0 on success or a negative error code.
+ */
+int ibnl_add_cb(int module, int (*get_size)(int op, int *size),
+		int (*get_data)(int op, char *buf, int len));
+
+/**
+ * Remove a callback for a registered IB module
+ * @module: The removed IB module
+ *
+ * Returns 0 on success or a negative error code.
+ */
+int ibnl_remove_cb(int module);
+
+#endif /* __KERNEL__ */
+
+#endif /* _IBNETLINK_H */
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
