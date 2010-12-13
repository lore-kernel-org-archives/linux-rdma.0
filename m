From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 1/6] IB Netlink Infrastructure
Date: Mon, 13 Dec 2010 18:22:45 +0200
Message-ID: <1292257370-24391-2-git-send-email-nirm@voltaire.com>
References: <1292257370-24391-1-git-send-email-nirm@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292257370-24391-1-git-send-email-nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org, nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The basic IB netlink infrastructure.
It allows for registration of IB clients for which data is to be exported.
It supplies message construction callbacks.

Signed-off-by: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/netlink.c |  179 +++++++++++++++++++++++++++++++++++++
 include/linux/netlink.h           |    1 +
 include/rdma/ib_netlink.h         |   59 ++++++++++++
 3 files changed, 239 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/core/netlink.c
 create mode 100644 include/rdma/ib_netlink.h

diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
new file mode 100644
index 0000000..c004f90
--- /dev/null
+++ b/drivers/infiniband/core/netlink.c
@@ -0,0 +1,179 @@
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
+#include <linux/netlink.h>
+
+#include <net/netlink.h>
+#include <net/net_namespace.h>
+#include <net/sock.h>
+#include <rdma/ib_netlink.h>
+
+struct ibnl_client {
+	struct list_head list;
+	int index;
+	int nops;
+	int (**cb_table)(struct sk_buff *skb,
+			struct netlink_callback *nlcb);
+};
+
+static DEFINE_MUTEX(ibnl_mutex);
+static struct sock *nls;
+static LIST_HEAD(client_list);
+
+int ibnl_add_client(int index, int nops,
+		    int (*cb_table[])(struct sk_buff *skb,
+				      struct netlink_callback *nlcb))
+{
+	struct ibnl_client *cur;
+	struct ibnl_client *nl_client = kmalloc(sizeof *nl_client, GFP_ATOMIC);
+
+	if (!nl_client)
+		return -ENOMEM;
+	nl_client->index = index;
+	nl_client->nops = nops;
+	nl_client->cb_table = cb_table;
+	mutex_lock(&ibnl_mutex);
+	list_for_each_entry(cur, &client_list, list) {
+		if (cur->index == index) {
+			pr_warn("Client for %d already exists\n", index);
+			mutex_unlock(&ibnl_mutex);
+			kfree(nl_client);
+			return -EINVAL;
+		}
+	}
+	list_add_tail(&nl_client->list, &client_list);
+	mutex_unlock(&ibnl_mutex);
+	return 0;
+}
+EXPORT_SYMBOL(ibnl_add_client);
+
+int ibnl_remove_client(int index)
+{
+	struct ibnl_client *cur, *next;
+
+	mutex_lock(&ibnl_mutex);
+	list_for_each_entry_safe(cur, next, &client_list, list) {
+		if (cur->index == index) {
+			list_del(&(cur->list));
+			mutex_unlock(&ibnl_mutex);
+			kfree(cur);
+			return 0;
+		}
+	}
+	pr_warn("Can't remove callback for client idx %d. Not found\n", index);
+	mutex_unlock(&ibnl_mutex);
+	return -EINVAL;
+}
+EXPORT_SYMBOL(ibnl_remove_client);
+
+void *ibnl_put_msg(struct sk_buff *skb, struct nlmsghdr **nlh, int seq,
+		   int len, int client, int op)
+{
+	unsigned char *prev_tail;
+
+	prev_tail = skb_tail_pointer(skb);
+	*nlh = NLMSG_NEW(skb, 0, seq, IBNL_GET_TYPE(client, op),
+			len, NLM_F_MULTI);
+	(*nlh)->nlmsg_len = skb_tail_pointer(skb) - prev_tail;
+	return NLMSG_DATA(*nlh);
+nlmsg_failure:
+	nlmsg_trim(skb, prev_tail);
+	return NULL;
+}
+EXPORT_SYMBOL(ibnl_put_msg);
+
+int ibnl_put_attr(struct sk_buff *skb, struct nlmsghdr *nlh,
+		  int len, void *data, int type)
+{
+	unsigned char *prev_tail;
+
+	prev_tail = skb_tail_pointer(skb);
+	NLA_PUT(skb, type, len, data);
+	nlh->nlmsg_len += skb_tail_pointer(skb) - prev_tail;
+	return 0;
+nla_put_failure:
+	nlmsg_trim(skb, prev_tail - nlh->nlmsg_len);
+	return -EMSGSIZE;
+}
+EXPORT_SYMBOL(ibnl_put_attr);
+
+static int ibnl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
+{
+	struct ibnl_client *client;
+	int type = nlh->nlmsg_type;
+	int index = IBNL_GET_CLIENT(type);
+	int op = IBNL_GET_OP(type);
+	list_for_each_entry(client, &client_list, list) {
+		if (client->index == index) {
+			if (op < 0 || op >= client->nops ||
+			    !client->cb_table[IBNL_GET_OP(op)])
+				return -EINVAL;
+			return netlink_dump_start(nls, skb, nlh,
+						  client->cb_table[op], NULL);
+		}
+	}
+	pr_info("Index %d wasn't found in client list\n", index);
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
+int ibnl_init(void)
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
+void ibnl_cleanup(void)
+{
+	struct ibnl_client *cur, *next;
+
+	mutex_lock(&ibnl_mutex);
+	list_for_each_entry_safe(cur, next, &client_list, list) {
+		list_del(&(cur->list));
+		kfree(cur);
+	}
+	mutex_unlock(&ibnl_mutex);
+	netlink_kernel_release(nls);
+}
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
 
diff --git a/include/rdma/ib_netlink.h b/include/rdma/ib_netlink.h
new file mode 100644
index 0000000..0db338c
--- /dev/null
+++ b/include/rdma/ib_netlink.h
@@ -0,0 +1,59 @@
+#ifndef _IBNETLINK_H
+#define _IBNETLINK_H
+
+#define IBNL_GET_CLIENT(type) ((type & (((1 << 6) - 1) << 10)) >> 10)
+#define IBNL_GET_OP(type) (type & ((1 << 10) - 1))
+#define IBNL_GET_TYPE(client, op) ((client << 10) + op)
+
+#ifdef __KERNEL__
+
+int ibnl_init(void);
+void ibnl_cleanup(void);
+
+/**
+ * Add a a client to the list of IB netlink exporters.
+ * @index: Index of the added client
+ * @nops: Number of supported ops by the added client.
+ * @cb_table: A table for op->callback
+ *
+ * Returns 0 on success or a negative error code.
+ */
+int ibnl_add_client(int index, int nops,
+		    int (*cb_table[])(struct sk_buff *skb,
+				      struct netlink_callback *nlcb));
+
+/**
+ * Remove a client from IB netlink.
+ * @index: Index of the removed IB client.
+ *
+ * Returns 0 on success or a negative error code.
+ */
+int ibnl_remove_client(int index);
+
+/**
+ * Put a new message in a supplied skb.
+ * @skb: The netlink skb.
+ * @nlh: Pointer to put the header of the new netlink message.
+ * @seq: The message sequence number.
+ * @len: The requested message length to allocate.
+ * @client: Calling IB netlink client.
+ * @op: message content op.
+ * Returns the allocated buffer on success and NULL on failure.
+ */
+void *ibnl_put_msg(struct sk_buff *skb, struct nlmsghdr **nlh, int seq,
+		   int len, int client, int op);
+/**
+ * Put a new attribute in a supplied skb.
+ * @skb: The netlink skb.
+ * @nlh: Header of the netlink message to append the attribute to.
+ * @len: The length of the attribute data.
+ * @data: The attribute data to put.
+ * @type: The attribute type.
+ * Returns the 0 and a negative error code on failure.
+ */
+int ibnl_put_attr(struct sk_buff *skb, struct nlmsghdr *nlh,
+		  int len, void *data, int type);
+
+#endif /* __KERNEL__ */
+
+#endif /* _IBNETLINK_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
