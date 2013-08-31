From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/4] RDMA/cxgb4: Add support for iWARP Port Mapper user space
 service
Date: Sat, 31 Aug 2013 14:47:18 -0500
Message-ID: <20130831194718.GA7552@TENIKOLO-MOBL1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add support for iWARP Port Mapper (IWPM) user space service

Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

---
 drivers/infiniband/hw/cxgb4/Makefile       |    2 +-
 drivers/infiniband/hw/cxgb4/c4iw_netlink.c | 1021 ++++++++++++++++++++++++++++
 drivers/infiniband/hw/cxgb4/c4iw_netlink.h |  273 ++++++++
 drivers/infiniband/hw/cxgb4/cm.c           |  138 ++++-
 drivers/infiniband/hw/cxgb4/device.c       |   24 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h     |   16 +
 6 files changed, 1448 insertions(+), 26 deletions(-)
 create mode 100644 drivers/infiniband/hw/cxgb4/c4iw_netlink.c
 create mode 100644 drivers/infiniband/hw/cxgb4/c4iw_netlink.h

diff --git a/drivers/infiniband/hw/cxgb4/Makefile b/drivers/infiniband/hw/cxgb4/Makefile
index e11cf72..7e4d948 100644
--- a/drivers/infiniband/hw/cxgb4/Makefile
+++ b/drivers/infiniband/hw/cxgb4/Makefile
@@ -2,4 +2,4 @@ ccflags-y := -Idrivers/net/ethernet/chelsio/cxgb4
 
 obj-$(CONFIG_INFINIBAND_CXGB4) += iw_cxgb4.o
 
-iw_cxgb4-y :=  device.o cm.o provider.o mem.o cq.o qp.o resource.o ev.o id_table.o
+iw_cxgb4-y :=  device.o cm.o provider.o mem.o cq.o qp.o resource.o ev.o id_table.o c4iw_netlink.o
diff --git a/drivers/infiniband/hw/cxgb4/c4iw_netlink.c b/drivers/infiniband/hw/cxgb4/c4iw_netlink.c
new file mode 100644
index 0000000..001c0e3
--- /dev/null
+++ b/drivers/infiniband/hw/cxgb4/c4iw_netlink.c
@@ -0,0 +1,1021 @@
+/*
+ * Copyright (c) 2009-2010 Chelsio, Inc. All rights reserved.
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
+ *        disclaimer in the documentation and/or other  materials
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
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/mii.h>
+#include <linux/if_vlan.h>
+#include <linux/crc32.h>
+#include <linux/in.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/if_arp.h>
+#include <linux/highmem.h>
+#include <linux/io.h>
+#include <asm/irq.h>
+#include <asm/byteorder.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_pack.h>
+#include <rdma/iw_cm.h>
+#include <net/netlink.h>
+
+#include "iw_cxgb4.h"
+#include "c4iw_netlink.h"
+
+spinlock_t c4iw_nlmsg_lock;
+struct list_head c4iw_nlmsg_request_list;
+struct list_head c4iw_mapping_info_list;
+spinlock_t c4iw_mapping_lock;
+atomic_t c4iw_nlmsg_seq;
+atomic_t echo_nlmsg_seq;
+
+int c4iw_iwpm_pid = C4IW_IWPM_PID_UNDEFINED;
+static char iwpm_ulib_name[] = "iWarpPortMapperUser";
+static int iwpm_ulib_version = 3;
+
+static char c4iw_ifname[IWPM_IFNAME_SIZE];
+static char c4iw_ibdev[IWPM_DEVNAME_SIZE];
+
+static struct c4iw_nlmsg_request *c4iw_get_nlmsg_request(void);
+static int c4iw_send_mapping_info(void);
+static int c4iw_send_mapping_count(u32);
+static int c4iw_parse_nlmsg(struct netlink_callback *, int,
+			    const struct nla_policy *, struct nlattr *[],
+			    const char *);
+
+/* c4iw netlink callbacks */
+static int c4iw_register_iwpm_pid_cb(struct sk_buff *,
+				     struct netlink_callback *);
+static int c4iw_add_mapping_cb(struct sk_buff *, struct netlink_callback *);
+static int c4iw_add_and_query_mapping_cb(struct sk_buff *,
+					 struct netlink_callback *);
+static int c4iw_mapping_error_cb(struct sk_buff *, struct netlink_callback *);
+static int c4iw_mapping_info_cb(struct sk_buff *, struct netlink_callback *);
+static int c4iw_ack_mapping_info_cb(struct sk_buff *,
+				    struct netlink_callback *);
+
+static struct c4iw_nlmsg_request *c4iw_get_nlmsg_request(void)
+{
+	unsigned long flags;
+	struct c4iw_nlmsg_request *nlmsg_request = NULL;
+
+	nlmsg_request = kzalloc(sizeof(struct c4iw_nlmsg_request), GFP_ATOMIC);
+	if (!nlmsg_request) {
+		pr_err("%s Unable to allocate a nlmsg_request\n", __func__);
+		return NULL;
+	}
+	spin_lock_irqsave(&c4iw_nlmsg_lock, flags);
+	list_add_tail(&nlmsg_request->inprocess_list, &c4iw_nlmsg_request_list);
+	spin_unlock_irqrestore(&c4iw_nlmsg_lock, flags);
+
+	atomic_set(&nlmsg_request->refcount, 1);
+	nlmsg_request->nlmsg_seq = atomic_inc_return(&c4iw_nlmsg_seq);
+	nlmsg_request->request_done = 0;
+	nlmsg_request->async = 0;
+	nlmsg_request->err_code = 0;
+	return nlmsg_request;
+}
+
+static int c4iw_parse_nlmsg(struct netlink_callback *cb, int policy_max,
+			    const struct nla_policy *nlmsg_policy,
+			    struct nlattr *nltb[], const char *msg_type)
+{
+	int nlh_len = 0;
+	int ret;
+	const char *err_str = "";
+
+	ret = nlmsg_validate(cb->nlh, nlh_len, policy_max-1, nlmsg_policy);
+	if (ret) {
+		err_str = "Invalid attribute";
+		goto parse_nlmsg_error;
+	}
+	ret = nlmsg_parse(cb->nlh, nlh_len, nltb, policy_max-1, nlmsg_policy);
+	if (ret) {
+		err_str = "Unable to parse the nlmsg";
+		goto parse_nlmsg_error;
+	}
+	ret = c4iw_validate_nlmsg_attr(nltb, policy_max);
+	if (ret) {
+		err_str = "Invalid NULL attribute";
+		goto parse_nlmsg_error;
+	}
+	return 0;
+parse_nlmsg_error:
+	pr_warn("%s %s (msg type %s ret = %d)\n",
+		__func__, err_str, msg_type, ret);
+	return ret;
+}
+
+static void c4iw_nlmsg_req_timer_free(unsigned long data)
+{
+	struct c4iw_nlmsg_request *nlmsg_request = (struct c4iw_nlmsg_request *)
+						    data;
+
+	if (!nlmsg_request->request_done && !nlmsg_request->err_code)
+		c4iw_iwpm_pid = C4IW_IWPM_PID_UNAVAILABLE;
+
+	if (c4iw_iwpm_pid < 0)
+		pr_info("%s Port Mapper isn't available (err code = %d)\n"
+			, __func__, nlmsg_request->err_code);
+	rem_ref_nlmsg_request(nlmsg_request);
+}
+
+static void c4iw_mapinfo_timer_send(unsigned long data)
+{
+	int mapping_num;
+
+	c4iw_nlmsg_req_timer_free(data);
+
+	if (c4iw_iwpm_pid < 0)
+		return;
+	mapping_num = c4iw_send_mapping_info();
+	if (mapping_num < 0) {
+		pr_info("%s Unable to send mapping info\n", __func__);
+		return;
+	}
+	PDBG("%s Sending Mapping count msg (num = %d)\n", __func__
+	     , mapping_num);
+
+	c4iw_send_mapping_count(mapping_num);
+}
+
+static void c4iw_start_nlmsg_req_timer(struct c4iw_nlmsg_request *nlmsg_request,
+				       void (*timer_func)(unsigned long),
+				       u32 delay)
+{
+	init_timer(&nlmsg_request->service_timer);
+	setup_timer(&nlmsg_request->service_timer, timer_func,
+		    (unsigned long) nlmsg_request);
+	mod_timer(&nlmsg_request->service_timer, jiffies + delay);
+}
+
+/*
+ * Send a netlink query for the iwarp port mapper pid to the userspace
+ * nlmsg attributes:
+ *      [IWPM_NLA_REG_PID_SEQ]
+ *      [IWPM_NLA_REG_IF_NAME]
+ *	[IWPM_NLA_REG_IBDEV_NAME]
+ *	[IWPM_NLA_REG_ULIB_NAME]
+ */
+int c4iw_register_iwpm_pid(char *netdev_name, char *dev_name, int async,
+			   void (*req_timer_func)(unsigned long))
+{
+	struct sk_buff *skb = NULL;
+	struct c4iw_nlmsg_request *nlmsg_request = NULL;
+	struct nlmsghdr *nlh;
+	struct nlmsghdr **nlh_next = &nlh;
+	u32 msg_seq;
+	const char *err_str = "";
+	int ret = -ENOMEM;
+
+	skb = c4iw_create_nlmsg(RDMA_NL_IWPM_REG_PID, nlh_next);
+	if (!skb) {
+		err_str = "Unable to create a nlmsg";
+		goto pid_query_error;
+	}
+	nlmsg_request = c4iw_get_nlmsg_request();
+	if (!nlmsg_request) {
+		err_str = "Unable to allocate netlink request";
+		goto pid_query_error;
+	}
+	msg_seq = atomic_read(&echo_nlmsg_seq);
+
+	/* fill in the pid request message */
+	nlh->nlmsg_seq = nlmsg_request->nlmsg_seq;
+	err_str = "Unable to put attribute of the nlmsg";
+	ret = ibnl_put_attr(skb, nlh, sizeof(u32), &msg_seq,
+			    IWPM_NLA_REG_PID_SEQ);
+	if (ret)
+		goto pid_query_error;
+	ret = ibnl_put_attr(skb, nlh, IWPM_IFNAME_SIZE, netdev_name,
+			    IWPM_NLA_REG_IF_NAME);
+	if (ret)
+		goto pid_query_error;
+	ret = ibnl_put_attr(skb, nlh, IWPM_DEVNAME_SIZE, dev_name,
+			    IWPM_NLA_REG_IBDEV_NAME);
+	if (ret)
+		goto pid_query_error;
+	ret = ibnl_put_attr(skb, nlh, IWPM_ULIBNAME_SIZE, iwpm_ulib_name,
+			    IWPM_NLA_REG_ULIB_NAME);
+	if (ret)
+		goto pid_query_error;
+	memcpy(c4iw_ibdev, dev_name, IWPM_DEVNAME_SIZE);
+	memcpy(c4iw_ifname, netdev_name, IWPM_IFNAME_SIZE);
+	PDBG("%s Multicasting a nlmsg (echo seq = %u ibdevname = %s ifname = %s iwpm ulib name = %s) nlmsg len = %d request seq = %u\n"
+	     , __func__, msg_seq, dev_name, netdev_name, iwpm_ulib_name
+	     , nlh->nlmsg_len, nlmsg_request->nlmsg_seq);
+
+	ret = ibnl_multicast(skb, nlh, RDMA_NL_GROUP_IWPM, GFP_KERNEL);
+	if (ret) {
+		skb = NULL; /* already freed in the netlink send-op handling */
+		err_str = "Unable to send a nlmsg";
+		goto pid_query_error;
+	}
+	nlmsg_request->async = async;
+	if (async)
+		c4iw_start_nlmsg_req_timer(nlmsg_request, req_timer_func,
+					   C4IW_IWPM_NL_TIMEOUT);
+	else
+		ret = wait_complete_nlmsg_req(nlmsg_request,
+					      C4IW_IWPM_PID_UNAVAILABLE);
+	return ret;
+pid_query_error:
+	pr_warn("%s %s\n", __func__, err_str);
+	if (skb)
+		dev_kfree_skb(skb);
+	if (nlmsg_request)
+		free_nlmsg_request(nlmsg_request);
+	return ret;
+}
+
+/*
+ * Send a netlink add mapping request
+ * for the listener ip/tcp address to the userspace port mapper
+ * nlmsg attributes:
+ *	[IWPM_NLA_MANAGE_MAPPING_SEQ]
+ *	[IWPM_NLA_MANAGE_ADDR]
+ */
+int c4iw_add_mapping(struct c4iw_listen_ep *ep)
+{
+	struct sk_buff *skb = NULL;
+	struct c4iw_nlmsg_request *nlmsg_request = NULL;
+	struct nlmsghdr *nlh;
+	struct nlmsghdr **nlh_next = &nlh;
+	u32 msg_seq;
+	struct sockaddr_in *laddr = (struct sockaddr_in *)
+				    &ep->com.local_addr;
+	struct sockaddr_in6 *laddr6 = (struct sockaddr_in6 *)
+				      &ep->com.local_addr;
+	const char *err_str = "";
+	int ret = -ENOMEM;
+
+	skb = c4iw_create_nlmsg(RDMA_NL_IWPM_ADD_MAPPING, nlh_next);
+	if (!skb) {
+		err_str = "Unable to create a nlmsg";
+		goto add_mapping_error;
+	}
+
+	nlmsg_request = c4iw_get_nlmsg_request();
+	if (!nlmsg_request) {
+		err_str = "Unable to allocate netlink request";
+		goto add_mapping_error;
+	}
+
+	msg_seq = atomic_read(&echo_nlmsg_seq);
+
+	/* fill in the add mapping message */
+	nlh->nlmsg_seq = nlmsg_request->nlmsg_seq;
+	err_str = "Unable to put attribute of the nlmsg";
+	ret = ibnl_put_attr(skb, nlh, sizeof(u32), &msg_seq,
+			    IWPM_NLA_MANAGE_MAPPING_SEQ);
+	if (ret)
+		goto add_mapping_error;
+	ret = ibnl_put_attr(skb, nlh, sizeof(struct sockaddr_storage),
+			    &ep->com.local_addr, IWPM_NLA_MANAGE_ADDR);
+	if (ret)
+		goto add_mapping_error;
+
+	nlmsg_request->request_buffer = ep;
+	if (ep->com.local_addr.ss_family == AF_INET)
+		PDBG("%s Send a nlmsg (echo seq = %u, Local addr %pI4 [0x%04X]) request seq = %u\n"
+		     , __func__, msg_seq, &laddr->sin_addr.s_addr
+		     , ntohs(laddr->sin_port), nlmsg_request->nlmsg_seq);
+	else
+		PDBG("%s Send a nlmsg (echo seq = %u, Local addr %pI6 [0x%04X]) request seq = %u\n"
+		     , __func__, msg_seq, &laddr6->sin6_addr.s6_addr
+		     , ntohs(laddr6->sin6_port), nlmsg_request->nlmsg_seq);
+
+	ret = ibnl_unicast(skb, nlh, c4iw_iwpm_pid);
+	if (ret) {
+		c4iw_iwpm_pid = C4IW_IWPM_PID_UNDEFINED; /* ret = -111 */
+		skb = NULL; /* already freed in the netlink send-op handling */
+		err_str = "Unable to send a nlmsg";
+		goto add_mapping_error;
+	}
+	ret = wait_complete_nlmsg_req(nlmsg_request, C4IW_IWPM_PID_UNDEFINED);
+	return ret;
+add_mapping_error:
+	pr_warn("%s %s\n", __func__, err_str);
+	if (skb)
+		dev_kfree_skb(skb);
+	if (nlmsg_request)
+		free_nlmsg_request(nlmsg_request);
+	return ret;
+}
+
+/*
+ * Send both a netlink add mapping request for the connecting
+ * side ip/tcp address and a query for the accepting remote peer
+ * mapped ip/tcp address to the userspace port mapper
+ * nlmsg attributes:
+ *      [IWPM_NLA_QUERY_MAPPING_SEQ]
+ *	[IWPM_NLA_QUERY_LOCAL_ADDR]
+ *	[IWPM_NLA_QUERY_REMOTE_ADDR]
+ */
+int c4iw_add_and_query_mapping(struct c4iw_ep *ep)
+{
+	struct sk_buff *skb = NULL;
+	struct c4iw_nlmsg_request *nlmsg_request = NULL;
+	struct nlmsghdr *nlh;
+	struct nlmsghdr **nlh_next = &nlh;
+	u32 msg_seq;
+	struct sockaddr_in *laddr = (struct sockaddr_in *)
+				     &ep->com.local_addr;
+	struct sockaddr_in6 *laddr6 = (struct sockaddr_in6 *)
+				      &ep->com.local_addr;
+	struct sockaddr_in *raddr = (struct sockaddr_in *)
+				     &ep->com.remote_addr;
+	struct sockaddr_in6 *raddr6 = (struct sockaddr_in6 *)
+				      &ep->com.remote_addr;
+	const char *err_str = "";
+	int ret = -ENOMEM;
+
+	skb = c4iw_create_nlmsg(RDMA_NL_IWPM_QUERY_MAPPING, nlh_next);
+	if (!skb) {
+		err_str = "Unable to create a nlmsg";
+		goto query_mapping_error;
+	}
+	nlmsg_request = c4iw_get_nlmsg_request();
+	if (!nlmsg_request) {
+		err_str = "Unable to allocate netlink request";
+		goto query_mapping_error;
+	}
+
+	msg_seq = atomic_read(&echo_nlmsg_seq);
+	/* fill in the query message */
+	nlh->nlmsg_seq = nlmsg_request->nlmsg_seq;
+	err_str = "Unable to put attribute of the nlmsg";
+	ret = ibnl_put_attr(skb, nlh, sizeof(u32), &msg_seq,
+			    IWPM_NLA_QUERY_MAPPING_SEQ);
+	if (ret)
+		goto query_mapping_error;
+	ret = ibnl_put_attr(skb, nlh, sizeof(struct sockaddr_storage),
+			    &ep->com.local_addr,
+			    IWPM_NLA_QUERY_LOCAL_ADDR);
+	if (ret)
+		goto query_mapping_error;
+	ret = ibnl_put_attr(skb, nlh, sizeof(struct sockaddr_storage),
+			    &ep->com.remote_addr,
+			    IWPM_NLA_QUERY_REMOTE_ADDR);
+	if (ret)
+		goto query_mapping_error;
+
+	nlmsg_request->request_buffer = ep;
+	if (ep->com.local_addr.ss_family == AF_INET)
+		PDBG("%s Send a nlmsg (echo seq = %u, Local addr %pI4 [0x%04X]) Remote addr %pI4 [0x%04X]) request seq = %u\n"
+		     , __func__, msg_seq, &laddr->sin_addr.s_addr
+		     , ntohs(laddr->sin_port), &raddr->sin_addr.s_addr
+		     , ntohs(raddr->sin_port), nlmsg_request->nlmsg_seq);
+	else
+		PDBG("%s Send a nlmsg (echo seq = %u, Local addr %pI6 [0x%04X]) Remote addr %pI6 [0x%04X]) request seq = %u\n"
+		     , __func__, msg_seq, &laddr6->sin6_addr.s6_addr
+		     , ntohs(laddr6->sin6_port), &raddr6->sin6_addr.s6_addr
+		     , ntohs(raddr6->sin6_port), nlmsg_request->nlmsg_seq);
+
+	ret = ibnl_unicast(skb, nlh, c4iw_iwpm_pid);
+	if (ret) {
+		c4iw_iwpm_pid = C4IW_IWPM_PID_UNDEFINED;
+		skb = NULL; /* already freed in the netlink send-op handling */
+		err_str = "Unable to send a nlmsg";
+		goto query_mapping_error;
+	}
+	ret = wait_complete_nlmsg_req(nlmsg_request, C4IW_IWPM_PID_UNDEFINED);
+	return ret;
+query_mapping_error:
+	pr_warn("%s %s\n", __func__, err_str);
+	if (skb)
+		dev_kfree_skb(skb);
+	if (nlmsg_request)
+		free_nlmsg_request(nlmsg_request);
+	return ret;
+}
+
+/*
+ * Send a netlink remove mapping request to the userspace port mapper
+ * nlmsg attributes:
+ *	[IWPM_NLA_MANAGE_MAPPING_SEQ]
+ *	[IWPM_NLA_MANAGE_ADDR]
+ */
+int c4iw_remove_mapping(struct sockaddr_storage *mapped_local_addr)
+{
+	struct sk_buff *skb;
+	struct nlmsghdr *nlh;
+	struct nlmsghdr **nlh_next = &nlh;
+	u32 msg_seq;
+	struct sockaddr_in *mapped_la = (struct sockaddr_in *)
+					mapped_local_addr;
+	struct sockaddr_in6 *mapped_la6 = (struct sockaddr_in6 *)
+					  mapped_local_addr;
+	const char *err_str = "";
+	int ret;
+
+	if (c4iw_remove_mapinfo(mapped_local_addr)) {
+		if (mapped_local_addr->ss_family == AF_INET)
+			pr_warn("%s Fail to remove mapinfo (port = 0x%04X).\n"
+				, __func__, ntohs(mapped_la->sin_port));
+		else
+			pr_warn("%s Fail to remove mapinfo (port = 0x%04X).\n"
+				, __func__, ntohs(mapped_la6->sin6_port));
+		return -EINVAL;
+	}
+	if (c4iw_iwpm_pid < 0)
+		return 0;
+
+	skb = c4iw_create_nlmsg(RDMA_NL_IWPM_REMOVE_MAPPING, nlh_next);
+	if (!skb) {
+		ret = -ENOMEM;
+		err_str = "Unable to create a nlmsg";
+		goto remove_mapping_error;
+	}
+	msg_seq = atomic_read(&echo_nlmsg_seq);
+
+	nlh->nlmsg_seq = atomic_inc_return(&c4iw_nlmsg_seq);
+	err_str = "Unable to put attribute of the nlmsg";
+	ret = ibnl_put_attr(skb, nlh, sizeof(u32), &msg_seq,
+			    IWPM_NLA_MANAGE_MAPPING_SEQ);
+	if (ret)
+		goto remove_mapping_error;
+	ret = ibnl_put_attr(skb, nlh, sizeof(struct sockaddr_storage),
+			    mapped_local_addr, IWPM_NLA_MANAGE_ADDR);
+	if (ret)
+		goto remove_mapping_error;
+
+	if (mapped_local_addr->ss_family == AF_INET)
+		PDBG("%s Send a nlmsg (echo seq = %u, Mapped local addr %pI4 [0x%04X])\n"
+		     , __func__, msg_seq, &mapped_la->sin_addr.s_addr
+		     , ntohs(mapped_la->sin_port));
+	else
+		PDBG("%s Send a nlmsg (echo seq = %u, Mapped local addr %pI6 [0x%04X])\n"
+		     , __func__, msg_seq, mapped_la6->sin6_addr.s6_addr
+		     , ntohs(mapped_la6->sin6_port));
+
+	ret = ibnl_unicast(skb, nlh, c4iw_iwpm_pid);
+	if (ret) {
+		c4iw_iwpm_pid = C4IW_IWPM_PID_UNDEFINED;
+		skb = NULL;
+		err_str = "Unable to send a nlmsg";
+		goto remove_mapping_error;
+	}
+	return 0;
+remove_mapping_error:
+	pr_warn("%s %s\n", __func__, err_str);
+	if (skb)
+		dev_kfree_skb(skb);
+	return ret;
+}
+
+/* registered netlink c4iw callbacks */
+struct ibnl_client_cbs c4iw_nl_cb_table[] = {
+	[RDMA_NL_IWPM_REG_PID] = {.dump = c4iw_register_iwpm_pid_cb},
+	[RDMA_NL_IWPM_ADD_MAPPING] = {.dump = c4iw_add_mapping_cb},
+	[RDMA_NL_IWPM_QUERY_MAPPING] = {.dump = c4iw_add_and_query_mapping_cb},
+	[RDMA_NL_IWPM_HANDLE_ERR] = {.dump = c4iw_mapping_error_cb},
+	[RDMA_NL_IWPM_MAP_INFO] = {.dump = c4iw_mapping_info_cb},
+	[RDMA_NL_IWPM_MAP_INFO_NUM] = {.dump = c4iw_ack_mapping_info_cb}
+};
+
+static const struct nla_policy resp_reg_policy[IWPM_NLA_RREG_PID_MAX] = {
+	[IWPM_NLA_RREG_PID_SEQ]     = { .type = NLA_U32 },
+	[IWPM_NLA_RREG_IBDEV_NAME]  = { .type = NLA_STRING,
+					.len = IWPM_DEVNAME_SIZE - 1 },
+	[IWPM_NLA_RREG_ULIB_NAME]   = { .type = NLA_STRING,
+					.len = IWPM_ULIBNAME_SIZE - 1 },
+	[IWPM_NLA_RREG_ULIB_VER]    = { .type = NLA_U16 },
+	[IWPM_NLA_RREG_PID_ERR]     = { .type = NLA_U16 }
+};
+
+static int c4iw_register_iwpm_pid_cb(struct sk_buff *skb,
+				     struct netlink_callback *cb)
+{
+	struct c4iw_nlmsg_request *nlmsg_request = NULL;
+	struct nlattr *nltb[IWPM_NLA_RREG_PID_MAX];
+	char *dev_name, *iwpm_name;
+	u32 msg_seq;
+	u16 iwpm_version;
+	const char *msg_type = "Register Pid response";
+
+	c4iw_iwpm_pid = C4IW_IWPM_PID_ERROR;
+
+	if (c4iw_parse_nlmsg(cb, IWPM_NLA_RREG_PID_MAX, resp_reg_policy,
+			     nltb, msg_type))
+		return -EINVAL;
+
+	msg_seq = nla_get_u32(nltb[IWPM_NLA_RREG_PID_SEQ]);
+	nlmsg_request = c4iw_find_nlmsg_request(msg_seq);
+	if (!nlmsg_request) {
+		pr_warn("%s Could not find a matching request (seq = %u)\n"
+			, __func__, msg_seq);
+		return -EINVAL;
+	}
+	dev_name = (char *)nla_data(nltb[IWPM_NLA_RREG_IBDEV_NAME]);
+	iwpm_name = (char *)nla_data(nltb[IWPM_NLA_RREG_ULIB_NAME]);
+	iwpm_version = nla_get_u16(nltb[IWPM_NLA_RREG_ULIB_VER]);
+
+	/* check device name, ulib name and version */
+	if (strcmp(c4iw_ibdev, dev_name) || strcmp(iwpm_ulib_name, iwpm_name) ||
+		   iwpm_version != iwpm_ulib_version) {
+		pr_info("%s Incorrect info (dev = %s name = %s version = %d)\n"
+			, __func__, dev_name, iwpm_name, iwpm_version);
+		nlmsg_request->err_code = IWPM_USER_LIB_INFO_ERR;
+		goto register_pid_response_exit;
+	}
+	PDBG("%s Received info (dev = %s name = %s version = %d) request seq = %u\n"
+	     , __func__, dev_name, iwpm_name, iwpm_version
+	     , nlmsg_request->nlmsg_seq);
+
+	c4iw_iwpm_pid = cb->nlh->nlmsg_pid;
+	atomic_set(&echo_nlmsg_seq, cb->nlh->nlmsg_seq);
+	pr_info("%s iWarp Port Mapper (pid = %d) is successfully registered.\n"
+		, __func__, c4iw_iwpm_pid);
+register_pid_response_exit:
+	nlmsg_request->request_done = 1;
+	/* always for found nlmsg_request */
+	rem_ref_nlmsg_request(nlmsg_request);
+	barrier();
+	if (!nlmsg_request->async)
+		wake_up(&nlmsg_request->waitq);
+	return 0;
+}
+
+static const struct nla_policy resp_add_policy[IWPM_NLA_RMANAGE_MAPPING_MAX] = {
+	[IWPM_NLA_MANAGE_MAPPING_SEQ]     = { .type = NLA_U32 },
+	[IWPM_NLA_MANAGE_ADDR]            = {
+				.len = sizeof(struct sockaddr_storage) },
+	[IWPM_NLA_MANAGE_MAPPED_LOC_ADDR] = {
+				.len = sizeof(struct sockaddr_storage) },
+	[IWPM_NLA_RMANAGE_MAPPING_ERR]	  = { .type = NLA_U16 }
+};
+
+static int c4iw_add_mapping_cb(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct c4iw_listen_ep *ep;
+	struct c4iw_nlmsg_request *nlmsg_request = NULL;
+	struct nlattr *nltb[IWPM_NLA_RMANAGE_MAPPING_MAX];
+	u32 msg_seq;
+	struct sockaddr_storage *local_sockaddr, *mapped_sockaddr;
+	const char *msg_type;
+
+	msg_type = "Add Mapping response";
+	if (c4iw_parse_nlmsg(cb, IWPM_NLA_RMANAGE_MAPPING_MAX, resp_add_policy,
+			     nltb, msg_type))
+		return -EINVAL;
+
+	msg_seq = nla_get_u32(nltb[IWPM_NLA_MANAGE_MAPPING_SEQ]);
+	nlmsg_request = c4iw_find_nlmsg_request(msg_seq);
+	if (!nlmsg_request) {
+		pr_warn("%s Could not find a matching request (seq = %u)\n"
+			, __func__, msg_seq);
+		return -EINVAL;
+	}
+	ep = nlmsg_request->request_buffer;
+	local_sockaddr = (struct sockaddr_storage *)
+			 nla_data(nltb[IWPM_NLA_MANAGE_ADDR]);
+	mapped_sockaddr = (struct sockaddr_storage *)
+			  nla_data(nltb[IWPM_NLA_MANAGE_MAPPED_LOC_ADDR]);
+
+	if (memcmp(&ep->com.local_addr, local_sockaddr,
+		   sizeof(ep->com.local_addr))) {
+		print_addr(&ep->com.local_addr,
+			   "Invalid ip/tcp address Local: expected");
+		print_addr(local_sockaddr,
+			   "Invalid ip/tcp address Local: received");
+		nlmsg_request->err_code = IWPM_USER_LIB_INFO_ERR;
+		goto add_mapping_response_exit;
+	}
+
+	atomic_set(&echo_nlmsg_seq, cb->nlh->nlmsg_seq);
+	memcpy(&ep->com.mapped_local_addr, mapped_sockaddr,
+	       sizeof(ep->com.mapped_local_addr));
+add_mapping_response_exit:
+	print_addr(mapped_sockaddr, "Received a new mapping mapped local");
+	nlmsg_request->request_done = 1;
+	/* always for found nlmsg_request */
+	rem_ref_nlmsg_request(nlmsg_request);
+	barrier();
+	wake_up(&nlmsg_request->waitq);
+	return 0;
+}
+
+static const struct nla_policy
+		resp_query_policy[IWPM_NLA_RQUERY_MAPPING_MAX] = {
+	[IWPM_NLA_QUERY_MAPPING_SEQ]      = { .type = NLA_U32 },
+	[IWPM_NLA_QUERY_LOCAL_ADDR]       = {
+				.len = sizeof(struct sockaddr_storage) },
+	[IWPM_NLA_QUERY_REMOTE_ADDR]      = {
+				.len = sizeof(struct sockaddr_storage) },
+	[IWPM_NLA_RQUERY_MAPPED_LOC_ADDR] = {
+				.len = sizeof(struct sockaddr_storage) },
+	[IWPM_NLA_RQUERY_MAPPED_REM_ADDR] = {
+				.len = sizeof(struct sockaddr_storage) },
+	[IWPM_NLA_RQUERY_MAPPING_ERR]	  = { .type = NLA_U16 }
+};
+
+static int c4iw_add_and_query_mapping_cb(struct sk_buff *skb,
+					 struct netlink_callback *cb)
+{
+	struct c4iw_ep *ep;
+	struct c4iw_nlmsg_request *nlmsg_request = NULL;
+	struct nlattr *nltb[IWPM_NLA_RQUERY_MAPPING_MAX];
+	u32 msg_seq;
+	struct sockaddr_storage *local_sockaddr, *remote_sockaddr;
+	struct sockaddr_storage *mapped_loc_sockaddr, *mapped_rem_sockaddr;
+	struct sockaddr_in *laddr;
+	struct sockaddr_in6 *laddr6;
+	struct sockaddr_in *raddr;
+	struct sockaddr_in6 *raddr6;
+	struct sockaddr_in *map_laddr;
+	struct sockaddr_in6 *map_laddr6;
+	struct sockaddr_in *map_raddr;
+	struct sockaddr_in6 *map_raddr6;
+	const char *msg_type;
+	u16 err_code;
+
+	msg_type = "Query Mapping response";
+	if (c4iw_parse_nlmsg(cb, IWPM_NLA_RQUERY_MAPPING_MAX,
+			     resp_query_policy, nltb, msg_type))
+		return -EINVAL;
+	msg_seq = nla_get_u32(nltb[IWPM_NLA_QUERY_MAPPING_SEQ]);
+	nlmsg_request = c4iw_find_nlmsg_request(msg_seq);
+	if (!nlmsg_request) {
+		pr_warn("%s Could not find a matching request (seq = %u)\n"
+			, __func__, msg_seq);
+			return -EINVAL;
+	}
+	ep = nlmsg_request->request_buffer;
+	local_sockaddr = (struct sockaddr_storage *)
+			  nla_data(nltb[IWPM_NLA_QUERY_LOCAL_ADDR]);
+	remote_sockaddr = (struct sockaddr_storage *)
+			   nla_data(nltb[IWPM_NLA_QUERY_REMOTE_ADDR]);
+	mapped_loc_sockaddr = (struct sockaddr_storage *)
+			       nla_data(nltb[IWPM_NLA_RQUERY_MAPPED_LOC_ADDR]);
+	mapped_rem_sockaddr = (struct sockaddr_storage *)
+			       nla_data(nltb[IWPM_NLA_RQUERY_MAPPED_REM_ADDR]);
+	map_laddr = (struct sockaddr_in *)mapped_loc_sockaddr;
+	map_laddr6 = (struct sockaddr_in6 *)mapped_loc_sockaddr;
+	map_raddr = (struct sockaddr_in *)mapped_rem_sockaddr;
+	map_raddr6 = (struct sockaddr_in6 *) mapped_rem_sockaddr;
+	laddr = (struct sockaddr_in *)&ep->com.mapped_local_addr;
+	laddr6 = (struct sockaddr_in6 *)&ep->com.mapped_local_addr;
+	raddr = (struct sockaddr_in *)&ep->com.mapped_remote_addr;
+	raddr6 = (struct sockaddr_in6 *)&ep->com.mapped_remote_addr;
+
+	err_code = nla_get_u16(nltb[IWPM_NLA_RQUERY_MAPPING_ERR]);
+	if (err_code == IWPM_REMOTE_QUERY_REJECT) {
+		pr_info("%s Received a Query Reject nlmsg. nlmsg (pid = %u, seq = %u) echo seq = %u.\n"
+			, __func__, cb->nlh->nlmsg_pid, cb->nlh->nlmsg_seq
+			, msg_seq);
+		nlmsg_request->err_code = IWPM_REMOTE_QUERY_REJECT;
+	}
+	if (memcmp(&ep->com.local_addr, local_sockaddr,
+		   sizeof(ep->com.local_addr) != 0) ||
+	    memcmp(&ep->com.remote_addr, remote_sockaddr,
+		   sizeof(ep->com.remote_addr) != 0)) {
+		print_addr(&ep->com.local_addr,
+			   "Invalid ip/tcp address Local: expected");
+		print_addr(local_sockaddr,
+			   "Invalid ip/tcp address Local: received");
+		print_addr(&ep->com.remote_addr,
+			   "Invalid ip/tcp address Remote: expected");
+		print_addr(remote_sockaddr,
+			   "Invalid ip/tcp address Remote: received");
+		nlmsg_request->err_code = IWPM_USER_LIB_INFO_ERR;
+		goto query_mapping_response_exit;
+	}
+
+	atomic_set(&echo_nlmsg_seq, cb->nlh->nlmsg_seq);
+	if (ep->com.local_addr.ss_family == AF_INET) {
+		laddr->sin_addr.s_addr = map_laddr->sin_addr.s_addr,
+		laddr->sin_port = map_laddr->sin_port;
+		raddr->sin_addr.s_addr = map_raddr->sin_addr.s_addr,
+		raddr->sin_port = map_raddr->sin_port;
+	} else {
+		memcpy(laddr6->sin6_addr.s6_addr, map_laddr6->sin6_addr.s6_addr,
+		       IWPM_IPADDR_SIZE);
+		laddr6->sin6_port = map_laddr6->sin6_port;
+		memcpy(raddr6->sin6_addr.s6_addr, map_raddr6->sin6_addr.s6_addr,
+		       IWPM_IPADDR_SIZE);
+		raddr6->sin6_port = map_raddr6->sin6_port;
+	}
+query_mapping_response_exit:
+	print_addr(mapped_loc_sockaddr, "Received a new mapping mapped local");
+	print_addr(mapped_rem_sockaddr, "Received a new mapping mapped remote");
+	nlmsg_request->request_done = 1;
+	/* always for found nlmsg_request */
+	rem_ref_nlmsg_request(nlmsg_request);
+	barrier();
+	wake_up(&nlmsg_request->waitq);
+	return 0;
+}
+
+static const struct nla_policy resp_mapinfo_policy[IWPM_NLA_MAPINFO_REQ_MAX] = {
+	[IWPM_NLA_MAPINFO_ULIB_NAME] = { .type = NLA_STRING,
+					.len = IWPM_ULIBNAME_SIZE - 1 },
+	[IWPM_NLA_MAPINFO_ULIB_VER]  = { .type = NLA_U16 }
+};
+
+static int c4iw_mapping_info_cb(struct sk_buff *skb,
+				struct netlink_callback *cb)
+{
+	struct nlattr *nltb[IWPM_NLA_MAPINFO_REQ_MAX];
+	char *iwpm_name;
+	u16 iwpm_version;
+	const char *msg_type = "Mapping Info response";
+	void (*req_timer_func)(unsigned long) = NULL;
+	int async = 1;
+
+	if (c4iw_parse_nlmsg(cb, IWPM_NLA_MAPINFO_REQ_MAX, resp_mapinfo_policy,
+			     nltb, msg_type))
+		return -EINVAL;
+
+	iwpm_name = (char *)nla_data(nltb[IWPM_NLA_MAPINFO_ULIB_NAME]);
+	iwpm_version = nla_get_u16(nltb[IWPM_NLA_MAPINFO_ULIB_VER]);
+	if (strcmp(iwpm_ulib_name, iwpm_name) ||
+		   iwpm_version != iwpm_ulib_version) {
+		pr_info("%s Invalid iWarpPortMapper info (name = %s version = %d)\n"
+			, __func__, iwpm_name, iwpm_version);
+		return -EINVAL;
+	}
+	if (list_empty(&c4iw_mapping_info_list))
+		req_timer_func = &c4iw_nlmsg_req_timer_free;
+	else
+		req_timer_func = &c4iw_mapinfo_timer_send;
+
+	c4iw_register_iwpm_pid(c4iw_ifname, c4iw_ibdev, async, req_timer_func);
+	return 0;
+}
+
+static int c4iw_send_mapping_count(u32 mapping_num)
+{
+	struct c4iw_nlmsg_request *nlmsg_request = NULL;
+	struct sk_buff *skb = NULL;
+	struct nlmsghdr *nlh;
+	struct nlmsghdr **nlh_next = &nlh;
+	u32 msg_seq;
+	const char *err_str = "";
+	int ret = -EINVAL;
+
+	skb = c4iw_create_nlmsg(RDMA_NL_IWPM_MAP_INFO_NUM, nlh_next);
+	if (!skb) {
+		err_str = "Unable to create a nlmsg";
+		goto mapping_count_exit;
+	}
+	nlmsg_request = c4iw_get_nlmsg_request();
+	if (!nlmsg_request) {
+		err_str = "Unable to allocate netlink request";
+		goto mapping_count_exit;
+	}
+
+	/* fill in the pid request message */
+	msg_seq = atomic_read(&echo_nlmsg_seq);
+	nlh->nlmsg_seq = nlmsg_request->nlmsg_seq;
+	err_str = "Unable to put attribute of map count nlmsg";
+	ret = ibnl_put_attr(skb, nlh, sizeof(u32), &msg_seq,
+			    IWPM_NLA_MAPINFO_SEQ);
+	if (ret)
+		goto mapping_count_exit;
+	ret = ibnl_put_attr(skb, nlh, sizeof(u32), &mapping_num,
+			    IWPM_NLA_MAPINFO_NUMBER);
+	if (ret)
+		goto mapping_count_exit;
+
+	ret = ibnl_unicast(skb, nlh, c4iw_iwpm_pid);
+	if (ret) {
+		c4iw_iwpm_pid = C4IW_IWPM_PID_UNDEFINED;
+		/* already freed in the netlink send-op handling */
+		skb = NULL;
+		err_str = "Unable to send a nlmsg";
+		goto mapping_count_exit;
+	}
+	nlmsg_request->mapcount = mapping_num;
+	nlmsg_request->async = 1;
+	c4iw_start_nlmsg_req_timer(nlmsg_request, c4iw_nlmsg_req_timer_free,
+				   C4IW_IWPM_NL_TIMEOUT);
+	return 0;
+mapping_count_exit:
+	if (skb)
+		dev_kfree_skb(skb);
+	if (nlmsg_request)
+		free_nlmsg_request(nlmsg_request);
+	pr_warn("%s %s (ret = %d)\n", __func__, err_str, ret);
+	return ret;
+}
+
+static int c4iw_send_nlmsg_done(struct sk_buff *skb)
+{
+	struct nlmsghdr *nlh = NULL;
+	int ret;
+	if (!(ibnl_put_msg(skb, &nlh, 0, 0, RDMA_NL_C4IW,
+			   RDMA_NL_IWPM_MAP_INFO, NLM_F_MULTI))) {
+		pr_warn("%s Unable to put NLMSG_DONE\n", __func__);
+		return -ENOMEM;
+	}
+	nlh->nlmsg_type = NLMSG_DONE;
+	ret = ibnl_unicast(skb, (struct nlmsghdr *)skb->data, c4iw_iwpm_pid);
+	if (ret) {
+		c4iw_iwpm_pid = C4IW_IWPM_PID_UNDEFINED;
+		pr_warn("%s Unable to send a nlmsg\n", __func__);
+	}
+	return ret;
+}
+
+static int c4iw_send_mapping_info(void)
+{
+	struct sk_buff *skb = NULL;
+	struct c4iw_mapping_info *map_info;
+	struct nlmsghdr *nlh;
+	int skb_num = 0, mapping_num = 0, nlmsg_bytes = 0;
+	unsigned long flags;
+	const char *err_str = "";
+	int ret;
+
+	skb = dev_alloc_skb(NLMSG_GOODSIZE);
+	if (!skb) {
+		ret = -ENOMEM;
+		err_str = "Unable to allocate skb";
+		goto send_mapping_info_exit;
+	}
+	skb_num++;
+	spin_lock_irqsave(&c4iw_mapping_lock, flags);
+	list_for_each_entry(map_info, &c4iw_mapping_info_list, mapping_list) {
+		nlh = NULL;
+		if (!(ibnl_put_msg(skb, &nlh, 0, 0, RDMA_NL_C4IW,
+				   RDMA_NL_IWPM_MAP_INFO, NLM_F_MULTI))) {
+			ret = -ENOMEM;
+			err_str = "Unable to put the nlmsg header";
+			spin_unlock_irqrestore(&c4iw_mapping_lock, flags);
+			goto send_mapping_info_exit;
+		}
+		err_str = "Unable to put attribute of the nlmsg";
+		ret = ibnl_put_attr(skb, nlh,
+				    sizeof(struct sockaddr_storage),
+				    &map_info->local_sockaddr,
+				    IWPM_NLA_MAPINFO_LOCAL_ADDR);
+		if (ret) {
+			spin_unlock_irqrestore(&c4iw_mapping_lock, flags);
+			goto send_mapping_info_exit;
+		}
+		ret = ibnl_put_attr(skb, nlh,
+				    sizeof(struct sockaddr_storage),
+				    &map_info->mapped_sockaddr,
+				    IWPM_NLA_MAPINFO_MAPPED_ADDR);
+		if (ret) {
+			spin_unlock_irqrestore(&c4iw_mapping_lock, flags);
+			goto send_mapping_info_exit;
+		}
+		mapping_num++;
+		nlmsg_bytes += nlh->nlmsg_len;
+
+		/* check if all mappings can fit in one skb */
+		if (NLMSG_GOODSIZE - nlmsg_bytes < nlh->nlmsg_len*2) {
+			nlmsg_bytes = 0;
+			skb_num++;
+			PDBG("%s Mappings Sent %d (nlmsg_bytes = %d nlmsg_len = %d). Allocating another skb (num = %d size = %lu)\n"
+			     , __func__, mapping_num, nlmsg_bytes
+			     , nlh->nlmsg_len, skb_num
+			     , NLMSG_GOODSIZE);
+			/* and leave room for NLMSG_DONE */
+			spin_unlock_irqrestore(&c4iw_mapping_lock, flags);
+			/* send the skb */
+			ret = c4iw_send_nlmsg_done(skb);
+			skb = NULL;
+			if (ret) {
+				err_str = "Unable to send map info";
+				goto send_mapping_info_exit;
+			}
+			if (skb_num == C4IW_MAP_INFO_SKB_COUNT) {
+				ret = -ENOMEM;
+				err_str = "Insufficient skbs for map info";
+				goto send_mapping_info_exit;
+			}
+			skb = dev_alloc_skb(NLMSG_GOODSIZE);
+			if (!skb) {
+				ret = -ENOMEM;
+				err_str = "Unable to allocate skb";
+				goto send_mapping_info_exit;
+			}
+			spin_lock_irqsave(&c4iw_mapping_lock, flags);
+		}
+	}
+	spin_unlock_irqrestore(&c4iw_mapping_lock, flags);
+	if (skb)
+		c4iw_send_nlmsg_done(skb);
+	return mapping_num;
+send_mapping_info_exit:
+	if (skb)
+		dev_kfree_skb(skb);
+	if (ret > 0)
+		ret = -ret;
+	pr_warn("%s %s (ret = %d)\n", __func__, err_str, ret);
+	return ret;
+}
+
+static const struct nla_policy
+	ack_mapinfo_policy[IWPM_NLA_MAPINFO_COUNT_MAX] = {
+	[IWPM_NLA_MAPINFO_SEQ]    = { .type = NLA_U32 },
+	[IWPM_NLA_MAPINFO_NUMBER] = { .type = NLA_U32 }
+};
+
+static int c4iw_ack_mapping_info_cb(struct sk_buff *skb,
+				    struct netlink_callback *cb)
+{
+	struct c4iw_nlmsg_request *nlmsg_request = NULL;
+	struct nlattr *nltb[IWPM_NLA_MAPINFO_COUNT_MAX];
+	u32 msg_seq, mapping_num;
+	const char *msg_type = "Mapping Info Ack";
+
+	if (c4iw_parse_nlmsg(cb, IWPM_NLA_MAPINFO_COUNT_MAX, ack_mapinfo_policy
+			     , nltb, msg_type))
+		return -EINVAL;
+	msg_seq = nla_get_u32(nltb[IWPM_NLA_MAPINFO_SEQ]);
+	nlmsg_request = c4iw_find_nlmsg_request(msg_seq);
+	if (!nlmsg_request) {
+		pr_warn("%s Could not find a matching request with seq = %u\n"
+			, __func__, msg_seq);
+		return -EINVAL;
+	}
+	mapping_num = nla_get_u32(nltb[IWPM_NLA_MAPINFO_NUMBER]);
+	if (nlmsg_request->mapcount != mapping_num) {
+		pr_info("%s Invalid map info count (sent = %u ack-ed = %u)\n"
+			, __func__, nlmsg_request->mapcount, mapping_num);
+	}
+	PDBG("%s Received ack for mapping count = %u\n", __func__, mapping_num);
+	atomic_set(&echo_nlmsg_seq, cb->nlh->nlmsg_seq);
+	nlmsg_request->request_done = 1;
+	/* always for found nlmsg_request */
+	rem_ref_nlmsg_request(nlmsg_request);
+	return 0;
+}
+
+static const struct nla_policy map_error_policy[IWPM_NLA_ERR_MAX] = {
+	[IWPM_NLA_ERR_SEQ]        = { .type = NLA_U32 },
+	[IWPM_NLA_ERR_CODE]       = { .type = NLA_U16 },
+};
+
+static int c4iw_mapping_error_cb(struct sk_buff *skb,
+				 struct netlink_callback *cb)
+{
+	struct c4iw_nlmsg_request *nlmsg_request = NULL;
+	struct nlattr *nltb[IWPM_NLA_ERR_MAX];
+	u32 msg_seq;
+	u16 err_code;
+	const char *msg_type = "Mapping Error Msg";
+
+	if (c4iw_parse_nlmsg(cb, IWPM_NLA_ERR_MAX, map_error_policy,
+			     nltb, msg_type))
+		return -EINVAL;
+
+	msg_seq = nla_get_u32(nltb[IWPM_NLA_ERR_SEQ]);
+	err_code = nla_get_u16(nltb[IWPM_NLA_ERR_CODE]);
+	pr_warn("%s Received msg_seq = %u err_code = %u\n"
+		, __func__, msg_seq, err_code);
+	/* look for nlmsg_request */
+	nlmsg_request = c4iw_find_nlmsg_request(msg_seq);
+	if (!nlmsg_request) {
+		/* not all errors have associated requests */
+		PDBG("%s Could not find a matching request with seq = %u\n"
+		     , __func__, msg_seq);
+		return -EINVAL;
+	}
+	atomic_set(&echo_nlmsg_seq, cb->nlh->nlmsg_seq);
+	nlmsg_request->err_code = err_code;
+	nlmsg_request->request_done = 1;
+	/* always for found nlmsg_request */
+	rem_ref_nlmsg_request(nlmsg_request);
+	barrier();
+	if (!nlmsg_request->async)
+		wake_up(&nlmsg_request->waitq);
+	return 0;
+}
diff --git a/drivers/infiniband/hw/cxgb4/c4iw_netlink.h b/drivers/infiniband/hw/cxgb4/c4iw_netlink.h
new file mode 100644
index 0000000..aa1b66c
--- /dev/null
+++ b/drivers/infiniband/hw/cxgb4/c4iw_netlink.h
@@ -0,0 +1,273 @@
+/*
+ * Copyright (c) 2009-2010 Chelsio, Inc. All rights reserved.
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
+ *        disclaimer in the documentation and/or other  materials
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
+#ifndef __C4IW_NETLINK_H
+#define __C4IW_NETLINK_H
+
+#include <rdma/rdma_netlink.h>
+#include <linux/errno.h>
+
+#define C4IW_IWPM_PID_UNDEFINED    -1
+#define C4IW_IWPM_PID_UNAVAILABLE  -2
+#define C4IW_IWPM_PID_ERROR	   -3
+
+#define C4IW_IWPM_NL_RETRANS	3
+#define C4IW_IWPM_NL_TIMEOUT     10000
+#define C4IW_MAP_INFO_SKB_COUNT  20
+
+#define IWPM_ULIBNAME_SIZE 32
+#define IWPM_DEVNAME_SIZE  32
+#define IWPM_IFNAME_SIZE   16
+#define IWPM_IPADDR_SIZE   16
+
+extern struct list_head c4iw_nlmsg_request_list;
+extern struct list_head c4iw_mapping_info_list;
+extern spinlock_t c4iw_nlmsg_lock;
+extern spinlock_t c4iw_mapping_lock;
+extern atomic_t c4iw_nlmsg_seq;
+extern atomic_t echo_nlmsg_seq;
+
+extern struct ibnl_client_cbs c4iw_nl_cb_table[];
+extern int c4iw_iwpm_pid;
+
+struct c4iw_nlmsg_request {
+	struct list_head	inprocess_list;
+	__u32			nlmsg_seq;
+	void                    *request_buffer;
+	u8			request_done;
+	u8			async;
+	union {
+		wait_queue_head_t  waitq;
+		struct timer_list  service_timer;
+	};
+
+	atomic_t  refcount;
+	u16       err_code;
+	int       mapcount;
+
+};
+
+struct c4iw_mapping_info {
+	struct list_head mapping_list;
+	struct sockaddr_storage local_sockaddr;
+	struct sockaddr_storage mapped_sockaddr;
+};
+
+enum {
+	IWPM_INVALID_NLMSG_ERR = 10,
+	IWPM_CREATE_MAPPING_ERR,
+	IWPM_DUPLICATE_MAPPING_ERR,
+	IWPM_UNKNOWN_MAPPING_ERR,
+	IWPM_CLIENT_DEV_INFO_ERR,
+	IWPM_USER_LIB_INFO_ERR,
+	IWPM_REMOTE_QUERY_REJECT
+};
+
+int c4iw_register_iwpm_pid(char *, char *, int,
+			   void (*req_timer_func)(unsigned long));
+int c4iw_add_mapping(struct c4iw_listen_ep *ep);
+int c4iw_add_and_query_mapping(struct c4iw_ep *ep);
+int c4iw_remove_mapping(struct sockaddr_storage *mapped_local_addr);
+void c4iw_timer_send_mapinfo(unsigned long);
+
+static inline int c4iw_validate_nlmsg_attr(struct nlattr *nltb[],
+					   int nla_count)
+{
+	int i;
+	for (i = 1; i < nla_count; i++) {
+		if (!nltb[i])
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static inline void c4iw_create_sockaddr(__be32 s_addr, __be16 s_port,
+					struct sockaddr_in *cm_sockaddr)
+{
+	cm_sockaddr->sin_family = AF_INET;
+	memcpy(&cm_sockaddr->sin_addr.s_addr, &s_addr, sizeof(__be32));
+	cm_sockaddr->sin_port = s_port;
+}
+
+static inline struct sk_buff *c4iw_create_nlmsg(u32 nl_op,
+						struct nlmsghdr **nlh)
+{
+	struct sk_buff *skb = NULL;
+
+	skb = dev_alloc_skb(NLMSG_GOODSIZE);
+	if (!skb) {
+		pr_err("%s Unable to allocate skb\n", __func__);
+		goto create_nlmsg_exit;
+	}
+	if (!(ibnl_put_msg(skb, nlh, 0, 0, RDMA_NL_C4IW, nl_op,
+			   NLM_F_REQUEST))) {
+		pr_warn("%s Unable to put the nlmsg header\n", __func__);
+		dev_kfree_skb(skb);
+		skb = NULL;
+	}
+create_nlmsg_exit:
+	return skb;
+}
+
+static inline void free_nlmsg_request(struct c4iw_nlmsg_request *nlmsg_request)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&c4iw_nlmsg_lock, flags);
+	list_del_init(&nlmsg_request->inprocess_list);
+	spin_unlock_irqrestore(&c4iw_nlmsg_lock, flags);
+
+	if (nlmsg_request->async)
+		del_timer(&nlmsg_request->service_timer);
+
+	if (!nlmsg_request->request_done)
+		pr_warn("%s Freeing incomplete nlmsg request (seq = %u).\n",
+			__func__, nlmsg_request->nlmsg_seq);
+	kfree(nlmsg_request);
+}
+
+static void rem_ref_nlmsg_request(struct c4iw_nlmsg_request *nlmsg_request)
+{
+	if (atomic_dec_and_test(&nlmsg_request->refcount))
+		free_nlmsg_request(nlmsg_request);
+}
+
+static inline int wait_complete_nlmsg_req(struct c4iw_nlmsg_request
+					  *nlmsg_request, int iwpm_pid)
+{
+	int ret;
+	init_waitqueue_head(&nlmsg_request->waitq);
+
+	ret = wait_event_timeout(nlmsg_request->waitq,
+				 (nlmsg_request->request_done != 0),
+				 C4IW_IWPM_NL_TIMEOUT);
+	if (!ret) {
+		c4iw_iwpm_pid = iwpm_pid;
+		pr_warn("%s: Timeout %d sec for netlink request (seq = %u)\n"
+			, __func__, (C4IW_IWPM_NL_TIMEOUT/HZ)
+			, nlmsg_request->nlmsg_seq);
+	} else
+		ret = nlmsg_request->err_code;
+
+	rem_ref_nlmsg_request(nlmsg_request);
+	return ret;
+}
+
+static inline struct c4iw_nlmsg_request *c4iw_find_nlmsg_request(__u32 echo_seq)
+{
+	struct c4iw_nlmsg_request *nlmsg_request;
+	struct c4iw_nlmsg_request *found_request = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&c4iw_nlmsg_lock, flags);
+	list_for_each_entry(nlmsg_request, &c4iw_nlmsg_request_list,
+			    inprocess_list) {
+		PDBG("Looking at a request with seq = %u\n"
+		     , nlmsg_request->nlmsg_seq);
+		if (nlmsg_request->nlmsg_seq == echo_seq) {
+			found_request = nlmsg_request;
+			atomic_inc(&nlmsg_request->refcount);
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&c4iw_nlmsg_lock, flags);
+	return found_request;
+}
+
+static inline int c4iw_create_mapinfo(struct sockaddr_storage *local_sockaddr,
+				      struct sockaddr_storage *mapped_sockaddr,
+				      const char *msg_type)
+{
+	struct c4iw_mapping_info *map_info;
+	unsigned long flags;
+
+	map_info = kzalloc(sizeof(struct c4iw_mapping_info), GFP_KERNEL);
+	if (!map_info) {
+		pr_err("%s: Unable to allocate a mapping info\n", __func__);
+		return -ENOMEM;
+	}
+
+	memcpy(&map_info->local_sockaddr, local_sockaddr,
+	       sizeof(struct sockaddr_storage));
+	memcpy(&map_info->mapped_sockaddr, mapped_sockaddr,
+	       sizeof(struct sockaddr_storage));
+
+	spin_lock_irqsave(&c4iw_mapping_lock, flags);
+	list_add_tail(&map_info->mapping_list, &c4iw_mapping_info_list);
+	spin_unlock_irqrestore(&c4iw_mapping_lock, flags);
+
+	return 0;
+}
+
+static inline int c4iw_remove_mapinfo(struct sockaddr_storage
+				      *mapped_local_addr)
+{
+	struct c4iw_mapping_info *map_info = NULL;
+	unsigned long flags;
+	int ret = -EINVAL;
+	const char *msg = "Remove mapped";
+
+	print_addr(mapped_local_addr, msg);
+
+	spin_lock_irqsave(&c4iw_mapping_lock, flags);
+	list_for_each_entry(map_info, &c4iw_mapping_info_list, mapping_list) {
+		print_addr(&map_info->mapped_sockaddr
+			   , "Going through mapinfo mapped local");
+		if (!memcmp(&map_info->mapped_sockaddr,	mapped_local_addr,
+			    sizeof(struct sockaddr_storage))) {
+			list_del_init(&map_info->mapping_list);
+			kfree(map_info);
+			ret = 0;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&c4iw_mapping_lock, flags);
+	return ret;
+}
+
+static inline void c4iw_destroy_mapinfo_list(void)
+{
+	struct c4iw_mapping_info *map_info, *map_info_tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&c4iw_mapping_lock, flags);
+	list_for_each_entry_safe(map_info, map_info_tmp,
+				 &c4iw_mapping_info_list, mapping_list) {
+		print_addr(&map_info->mapped_sockaddr,
+			   "Delete mapinfo mapped local");
+		list_del(&map_info->mapping_list);
+		kfree(map_info);
+	}
+	spin_unlock_irqrestore(&c4iw_mapping_lock, flags);
+}
+
+#endif /* __C4IW_NETLINK_H */
diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 12fef76..b8e2117 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -39,6 +39,7 @@
 #include <linux/ip.h>
 #include <linux/tcp.h>
 #include <linux/if_vlan.h>
+#include <linux/fcntl.h>
 
 #include <net/neighbour.h>
 #include <net/netevent.h>
@@ -48,6 +49,7 @@
 #include <net/addrconf.h>
 
 #include "iw_cxgb4.h"
+#include "c4iw_netlink.h"
 
 static char *states[] = {
 	"idle",
@@ -586,10 +588,14 @@ static int send_connect(struct c4iw_ep *ep)
 	int sizev6 = is_t4(ep->com.dev->rdev.lldi.adapter_type) ?
 				sizeof(struct cpl_act_open_req6) :
 				sizeof(struct cpl_t5_act_open_req6);
-	struct sockaddr_in *la = (struct sockaddr_in *)&ep->com.local_addr;
-	struct sockaddr_in *ra = (struct sockaddr_in *)&ep->com.remote_addr;
-	struct sockaddr_in6 *la6 = (struct sockaddr_in6 *)&ep->com.local_addr;
-	struct sockaddr_in6 *ra6 = (struct sockaddr_in6 *)&ep->com.remote_addr;
+	struct sockaddr_in *la = (struct sockaddr_in *)
+				 &ep->com.mapped_local_addr;
+	struct sockaddr_in *ra = (struct sockaddr_in *)
+				 &ep->com.mapped_remote_addr;
+	struct sockaddr_in6 *la6 = (struct sockaddr_in6 *)
+				   &ep->com.mapped_local_addr;
+	struct sockaddr_in6 *ra6 = (struct sockaddr_in6 *)
+				   &ep->com.mapped_remote_addr;
 
 	wrlen = (ep->com.remote_addr.ss_family == AF_INET) ?
 			roundup(sizev4, 16) :
@@ -1612,6 +1618,9 @@ static int abort_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	}
 	mutex_unlock(&ep->com.mutex);
 
+	print_addr(&ep->com.mapped_local_addr, "Delete mapped local");
+	c4iw_remove_mapping(&ep->com.mapped_local_addr);
+
 	if (release)
 		release_ep_resources(ep);
 	return 0;
@@ -1866,10 +1875,10 @@ static int act_open_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	struct sockaddr_in6 *ra6;
 
 	ep = lookup_atid(t, atid);
-	la = (struct sockaddr_in *)&ep->com.local_addr;
-	ra = (struct sockaddr_in *)&ep->com.remote_addr;
-	la6 = (struct sockaddr_in6 *)&ep->com.local_addr;
-	ra6 = (struct sockaddr_in6 *)&ep->com.remote_addr;
+	la = (struct sockaddr_in *)&ep->com.mapped_local_addr;
+	ra = (struct sockaddr_in *)&ep->com.mapped_remote_addr;
+	la6 = (struct sockaddr_in6 *)&ep->com.mapped_local_addr;
+	ra6 = (struct sockaddr_in6 *)&ep->com.mapped_remote_addr;
 
 	PDBG("%s ep %p atid %u status %u errno %d\n", __func__, ep, atid,
 	     status, status2errno(status));
@@ -1971,6 +1980,10 @@ static int close_listsrv_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 
 	PDBG("%s ep %p\n", __func__, ep);
 	c4iw_wake_up(&ep->com.wr_wait, status2errno(rpl->status));
+
+	print_addr(&ep->com.mapped_local_addr, "Delete mapped local");
+	c4iw_remove_mapping(&ep->com.mapped_local_addr);
+
 	return 0;
 }
 
@@ -2422,6 +2435,9 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 	rpl->cmd = CPL_ABORT_NO_RST;
 	c4iw_ofld_send(&ep->com.dev->rdev, rpl_skb);
 out:
+	print_addr(&ep->com.mapped_local_addr, "Delete mapped local");
+	c4iw_remove_mapping(&ep->com.mapped_local_addr);
+
 	if (release)
 		release_ep_resources(ep);
 	else if (ep->retry_with_mpa_v1) {
@@ -2476,6 +2492,9 @@ static int close_con_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 		break;
 	}
 	mutex_unlock(&ep->com.mutex);
+	print_addr(&ep->com.mapped_local_addr, "Delete mapped local");
+	c4iw_remove_mapping(&ep->com.mapped_local_addr);
+
 	if (release)
 		release_ep_resources(ep);
 	return 0;
@@ -2721,13 +2740,15 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	struct c4iw_dev *dev = to_c4iw_dev(cm_id->device);
 	struct c4iw_ep *ep;
 	int err = 0;
-	struct sockaddr_in *laddr = (struct sockaddr_in *)&cm_id->local_addr;
-	struct sockaddr_in *raddr = (struct sockaddr_in *)&cm_id->remote_addr;
-	struct sockaddr_in6 *laddr6 = (struct sockaddr_in6 *)&cm_id->local_addr;
-	struct sockaddr_in6 *raddr6 = (struct sockaddr_in6 *)
-				      &cm_id->remote_addr;
+	struct sockaddr_in *laddr;
+	struct sockaddr_in *raddr;
+	struct sockaddr_in6 *laddr6;
+	struct sockaddr_in6 *raddr6;
 	__u8 *ra;
 	int iptype;
+	const char *msg_type = "Create Connect Mapping";
+	int async = 0;
+	int iwpm_err = 0;
 
 	if ((conn_param->ord > c4iw_max_read_depth) ||
 	    (conn_param->ird > c4iw_max_read_depth)) {
@@ -2775,6 +2796,44 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	}
 	insert_handle(dev, &dev->atid_idr, ep, ep->atid);
 
+	memcpy(&ep->com.local_addr, &cm_id->local_addr,
+	       sizeof(ep->com.local_addr));
+	memcpy(&ep->com.remote_addr, &cm_id->remote_addr,
+	       sizeof(ep->com.remote_addr));
+
+	/* No port mapper available, go with the specified peer information */
+	memcpy(&ep->com.mapped_local_addr, &cm_id->local_addr,
+	       sizeof(ep->com.mapped_local_addr));
+	memcpy(&ep->com.mapped_remote_addr, &cm_id->remote_addr,
+	       sizeof(ep->com.mapped_remote_addr));
+	laddr = (struct sockaddr_in *)&ep->com.mapped_local_addr;
+	raddr = (struct sockaddr_in *)&ep->com.mapped_remote_addr;
+	laddr6 = (struct sockaddr_in6 *)&ep->com.mapped_local_addr;
+	raddr6 = (struct sockaddr_in6 *) &ep->com.mapped_remote_addr;
+
+	if (c4iw_iwpm_pid == C4IW_IWPM_PID_UNDEFINED) {
+		iwpm_err = c4iw_register_iwpm_pid(dev->rdev.lldi.ports[0]->name,
+						  dev->ibdev.name, async, NULL);
+		if (iwpm_err) {
+			c4iw_iwpm_pid = C4IW_IWPM_PID_ERROR;
+			PDBG("%s Port Mapper register pid failure (err_code = %d).\n"
+			     , __func__, iwpm_err);
+		}
+	}
+	if (c4iw_iwpm_pid > 0) { /* valid iwpm pid */
+		iwpm_err = c4iw_add_and_query_mapping(ep);
+		if (iwpm_err)
+			PDBG("%s Port Mapper query failure (err_code = %d).\n"
+			     , __func__, iwpm_err);
+	} else
+		pr_warn("%s iWarp Port Mapper (pid = %d) is not available.\n"
+			, __func__, c4iw_iwpm_pid);
+	if (c4iw_create_mapinfo(&ep->com.local_addr, &ep->com.mapped_local_addr,
+				msg_type)) {
+		err = -ENOMEM;
+		goto fail3;
+	}
+
 	if (cm_id->remote_addr.ss_family == AF_INET) {
 		iptype = 4;
 		ra = (__u8 *)&raddr->sin_addr;
@@ -2809,10 +2868,11 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		}
 
 		/* find a route */
-		PDBG("%s saddr %pI6 sport 0x%x raddr %pI6 rport 0x%x\n",
+		PDBG("%s saddr %pI6 sport 0x%x raddr %pI6 rport 0x%x sin6_scope_id %d\n",
 		     __func__, laddr6->sin6_addr.s6_addr,
 		     ntohs(laddr6->sin6_port),
-		     raddr6->sin6_addr.s6_addr, ntohs(raddr6->sin6_port));
+		     raddr6->sin6_addr.s6_addr, ntohs(raddr6->sin6_port),
+		     raddr6->sin6_scope_id);
 		ep->dst = find_route6(dev, laddr6->sin6_addr.s6_addr,
 				      raddr6->sin6_addr.s6_addr,
 				      laddr6->sin6_port, raddr6->sin6_port, 0,
@@ -2836,10 +2896,6 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 
 	state_set(&ep->com, CONNECTING);
 	ep->tos = 0;
-	memcpy(&ep->com.local_addr, &cm_id->local_addr,
-	       sizeof(ep->com.local_addr));
-	memcpy(&ep->com.remote_addr, &cm_id->remote_addr,
-	       sizeof(ep->com.remote_addr));
 
 	/* send connect request to rnic */
 	err = send_connect(ep);
@@ -2850,6 +2906,8 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 fail4:
 	dst_release(ep->dst);
 fail3:
+	print_addr(&ep->com.mapped_local_addr, "Delete mapped local");
+	c4iw_remove_mapping(&ep->com.mapped_local_addr);
 	remove_handle(ep->com.dev, &ep->com.dev->atid_idr, ep->atid);
 	cxgb4_free_atid(ep->com.dev->rdev.lldi.tids, ep->atid);
 fail2:
@@ -2862,7 +2920,8 @@ out:
 static int create_server6(struct c4iw_dev *dev, struct c4iw_listen_ep *ep)
 {
 	int err;
-	struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)&ep->com.local_addr;
+	struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)
+				    &ep->com.mapped_local_addr;
 
 	c4iw_init_wr_wait(&ep->com.wr_wait);
 	err = cxgb4_create_server6(ep->com.dev->rdev.lldi.ports[0],
@@ -2883,7 +2942,8 @@ static int create_server6(struct c4iw_dev *dev, struct c4iw_listen_ep *ep)
 static int create_server4(struct c4iw_dev *dev, struct c4iw_listen_ep *ep)
 {
 	int err;
-	struct sockaddr_in *sin = (struct sockaddr_in *)&ep->com.local_addr;
+	struct sockaddr_in *sin = (struct sockaddr_in *)
+				  &ep->com.mapped_local_addr;
 
 	if (dev->rdev.lldi.enable_fw_ofld_conn) {
 		do {
@@ -2918,6 +2978,9 @@ int c4iw_create_listen(struct iw_cm_id *cm_id, int backlog)
 	int err = 0;
 	struct c4iw_dev *dev = to_c4iw_dev(cm_id->device);
 	struct c4iw_listen_ep *ep;
+	const char *msg_type = "Create Listen Mapping";
+	int async = 0;
+	int iwpm_err = 0;
 
 	might_sleep();
 
@@ -2932,6 +2995,7 @@ int c4iw_create_listen(struct iw_cm_id *cm_id, int backlog)
 	ep->com.cm_id = cm_id;
 	ep->com.dev = dev;
 	ep->backlog = backlog;
+
 	memcpy(&ep->com.local_addr, &cm_id->local_addr,
 	       sizeof(ep->com.local_addr));
 
@@ -2951,6 +3015,34 @@ int c4iw_create_listen(struct iw_cm_id *cm_id, int backlog)
 		goto fail2;
 	}
 	insert_handle(dev, &dev->stid_idr, ep, ep->stid);
+
+	/* No port mapper available, go with the specified info */
+	memcpy(&ep->com.mapped_local_addr, &cm_id->local_addr,
+	       sizeof(ep->com.mapped_local_addr));
+
+	if (c4iw_iwpm_pid == C4IW_IWPM_PID_UNDEFINED) {
+		iwpm_err = c4iw_register_iwpm_pid(dev->rdev.lldi.ports[0]->name,
+						  dev->ibdev.name, async, NULL);
+		if (iwpm_err) {
+			c4iw_iwpm_pid = C4IW_IWPM_PID_ERROR;
+			PDBG("%s Port Mapper register pid failure (err_code = %d).\n"
+			     , __func__, iwpm_err);
+		}
+	}
+	if (c4iw_iwpm_pid > 0) { /* valid iwpm pid */
+		iwpm_err = c4iw_add_mapping(ep);
+		if (iwpm_err)
+			PDBG("%s Port Mapper query failure (err_code = %d).\n"
+			     , __func__, iwpm_err);
+	} else
+		pr_warn("%s iWarp Port Mapper (pid = %d) is not available.\n"
+			, __func__, c4iw_iwpm_pid);
+	if (c4iw_create_mapinfo(&ep->com.local_addr, &ep->com.mapped_local_addr,
+				msg_type)) {
+		err = -ENOMEM;
+		goto fail3;
+	}
+
 	state_set(&ep->com, LISTEN);
 	if (ep->com.local_addr.ss_family == AF_INET)
 		err = create_server4(dev, ep);
@@ -2960,6 +3052,10 @@ int c4iw_create_listen(struct iw_cm_id *cm_id, int backlog)
 		cm_id->provider_data = ep;
 		goto out;
 	}
+
+fail3:
+	print_addr(&ep->com.mapped_local_addr, "Delete mapped local");
+	c4iw_remove_mapping(&ep->com.mapped_local_addr);
 	cxgb4_free_stid(ep->com.dev->rdev.lldi.tids, ep->stid,
 			ep->com.local_addr.ss_family);
 fail2:
diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 33d2cc6..8810f78 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -37,6 +37,7 @@
 #include <rdma/ib_verbs.h>
 
 #include "iw_cxgb4.h"
+#include "c4iw_netlink.h"
 
 #define DRV_VERSION "0.1"
 
@@ -106,9 +107,9 @@ static int dump_qp(int id, void *p, void *data)
 	if (qp->ep) {
 		if (qp->ep->com.local_addr.ss_family == AF_INET) {
 			struct sockaddr_in *lsin = (struct sockaddr_in *)
-				&qp->ep->com.local_addr;
+				&qp->ep->com.mapped_local_addr;
 			struct sockaddr_in *rsin = (struct sockaddr_in *)
-				&qp->ep->com.remote_addr;
+				&qp->ep->com.mapped_remote_addr;
 
 			cc = snprintf(qpd->buf + qpd->pos, space,
 				      "rc qp sq id %u rq id %u state %u "
@@ -122,9 +123,9 @@ static int dump_qp(int id, void *p, void *data)
 				      &rsin->sin_addr, ntohs(rsin->sin_port));
 		} else {
 			struct sockaddr_in6 *lsin6 = (struct sockaddr_in6 *)
-				&qp->ep->com.local_addr;
+				&qp->ep->com.mapped_local_addr;
 			struct sockaddr_in6 *rsin6 = (struct sockaddr_in6 *)
-				&qp->ep->com.remote_addr;
+				&qp->ep->com.mapped_remote_addr;
 
 			cc = snprintf(qpd->buf + qpd->pos, space,
 				      "rc qp sq id %u rq id %u state %u "
@@ -1210,6 +1211,19 @@ static int __init c4iw_init_module(void)
 		printk(KERN_WARNING MOD
 		       "could not create debugfs entry, continuing\n");
 
+	spin_lock_init(&c4iw_nlmsg_lock);
+	spin_lock_init(&c4iw_mapping_lock);
+
+	/* List of submitted requests, searched for completions */
+	INIT_LIST_HEAD(&c4iw_nlmsg_request_list);
+	/* List of iwpm mappings in use */
+	INIT_LIST_HEAD(&c4iw_mapping_info_list);
+
+	if (ibnl_add_client(RDMA_NL_C4IW, RDMA_NL_IWPM_NUM_OPS,
+			c4iw_nl_cb_table))
+		pr_err("%s[%u]: Failed to add netlink callback\n"
+			, __func__, __LINE__);
+
 	cxgb4_register_uld(CXGB4_ULD_RDMA, &c4iw_uld_info);
 
 	return 0;
@@ -1227,6 +1241,8 @@ static void __exit c4iw_exit_module(void)
 	}
 	mutex_unlock(&dev_mutex);
 	cxgb4_unregister_uld(CXGB4_ULD_RDMA);
+	ibnl_remove_client(RDMA_NL_C4IW);
+	c4iw_destroy_mapinfo_list();
 	c4iw_cm_term();
 	debugfs_remove_recursive(c4iw_debugfs_root);
 }
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 23eaeab..7b3405d 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -152,6 +152,20 @@ struct c4iw_rdev {
 	struct c4iw_stats stats;
 };
 
+static inline void print_addr(struct sockaddr_storage *addr,
+			      const char *msg)
+{
+	struct sockaddr_in *laddr = (struct sockaddr_in *)addr;
+	struct sockaddr_in6 *laddr6 = (struct sockaddr_in6 *)addr;
+
+	if (addr->ss_family == AF_INET)
+		PDBG("%s %s addr %pI4 port 0x%04X\n", __func__, msg
+		     , &laddr->sin_addr.s_addr, ntohs(laddr->sin_port));
+	else
+		PDBG("%s %s addr %pI6 port 0x%04X\n", __func__, msg
+		     , laddr6->sin6_addr.s6_addr, ntohs(laddr6->sin6_port));
+}
+
 static inline int c4iw_fatal_error(struct c4iw_rdev *rdev)
 {
 	return rdev->flags & T4_FATAL_ERROR;
@@ -754,6 +768,8 @@ struct c4iw_ep_common {
 	struct mutex mutex;
 	struct sockaddr_storage local_addr;
 	struct sockaddr_storage remote_addr;
+	struct sockaddr_storage mapped_local_addr;
+	struct sockaddr_storage mapped_remote_addr;
 	struct c4iw_wr_wait wr_wait;
 	unsigned long flags;
 	unsigned long history;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
