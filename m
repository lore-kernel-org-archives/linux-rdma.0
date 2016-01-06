From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] [RFC] RVT: implementation of a generic IB transport module
Date: Wed,  6 Jan 2016 20:55:51 +0200
Message-ID: <1452106551-3907-1-git-send-email-monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

http://www.spinics.net/lists/linux-rdma/msg31762.html introduces the concept of
a software implementation for a generic InfiniBand transport module.
This patch offers such an implementation for the Linux kernel - RVT.

struct rvt_ifc_ops defines the interface that the back-end has to implement in
order to work with RVT. Any back-end that implements it can complete RVT
to make a Verbs provider

- node_guid - get GUID for the node
- port_guid - get GUID for a port
- port_speed - get port speed
- dma_device - get the dma device
- mcast_add - add multicast entry
- mcast_delete - remove multicast entry
- create_flow - create context for a new flow
- destroy_flow - destroy a flow context
- send - put a packet on the wire
- loopback - send a loopback packet
- alloc_sendbuf - allocate a buffer for send
- get_netdev - get netdev of a port

A back-end interacts with RVT with the following API

- rvt_alloc_device - allocate a new rvt device
- rvt_register_device - register a new rvt device
- rvt_unregister_device - unregister a rvt device
- rvt_send_done - notify rvt that a send has ended
---
 MAINTAINERS                               |    8 +
 drivers/infiniband/Kconfig                |    2 +
 drivers/infiniband/Makefile               |    1 +
 drivers/infiniband/sw/Makefile            |    2 +
 drivers/infiniband/sw/rdmavt/Kconfig      |   23 +
 drivers/infiniband/sw/rdmavt/Makefile     |   22 +
 drivers/infiniband/sw/rdmavt/rvt.c        |  146 +++
 drivers/infiniband/sw/rdmavt/rvt_av.c     |  281 +++++
 drivers/infiniband/sw/rdmavt/rvt_comp.c   |  726 ++++++++++++
 drivers/infiniband/sw/rdmavt/rvt_cq.c     |  164 +++
 drivers/infiniband/sw/rdmavt/rvt_dma.c    |  165 +++
 drivers/infiniband/sw/rdmavt/rvt_hdr.h    |  952 ++++++++++++++++
 drivers/infiniband/sw/rdmavt/rvt_icrc.c   |  103 ++
 drivers/infiniband/sw/rdmavt/rvt_loc.h    |  310 ++++++
 drivers/infiniband/sw/rdmavt/rvt_mcast.c  |  189 ++++
 drivers/infiniband/sw/rdmavt/rvt_mmap.c   |  172 +++
 drivers/infiniband/sw/rdmavt/rvt_mr.c     |  765 +++++++++++++
 drivers/infiniband/sw/rdmavt/rvt_opcode.c |  955 ++++++++++++++++
 drivers/infiniband/sw/rdmavt/rvt_opcode.h |  128 +++
 drivers/infiniband/sw/rdmavt/rvt_param.h  |  179 +++
 drivers/infiniband/sw/rdmavt/rvt_pool.c   |  510 +++++++++
 drivers/infiniband/sw/rdmavt/rvt_pool.h   |   98 ++
 drivers/infiniband/sw/rdmavt/rvt_qp.c     |  836 ++++++++++++++
 drivers/infiniband/sw/rdmavt/rvt_queue.c  |  216 ++++
 drivers/infiniband/sw/rdmavt/rvt_queue.h  |  178 +++
 drivers/infiniband/sw/rdmavt/rvt_recv.c   |  376 +++++++
 drivers/infiniband/sw/rdmavt/rvt_req.c    |  686 ++++++++++++
 drivers/infiniband/sw/rdmavt/rvt_resp.c   | 1375 +++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/rvt_srq.c    |  194 ++++
 drivers/infiniband/sw/rdmavt/rvt_task.c   |  154 +++
 drivers/infiniband/sw/rdmavt/rvt_task.h   |   94 ++
 drivers/infiniband/sw/rdmavt/rvt_verbs.c  | 1695 +++++++++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/rvt_verbs.h  |  434 ++++++++
 include/rdma/ib_pack.h                    |    4 +
 include/rdma/ib_rvt.h                     |  203 ++++
 include/uapi/rdma/Kbuild                  |    1 +
 include/uapi/rdma/ib_user_rvt.h           |  139 +++
 37 files changed, 12486 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/sw/Makefile
 create mode 100644 drivers/infiniband/sw/rdmavt/Kconfig
 create mode 100644 drivers/infiniband/sw/rdmavt/Makefile
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt.c
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_av.c
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_comp.c
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_cq.c
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_dma.c
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_hdr.h
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_icrc.c
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_loc.h
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_mcast.c
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_mmap.c
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_mr.c
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_opcode.c
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_opcode.h
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_param.h
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_pool.c
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_pool.h
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_qp.c
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_queue.c
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_queue.h
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_recv.c
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_req.c
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_resp.c
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_srq.c
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_task.c
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_task.h
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_verbs.c
 create mode 100644 drivers/infiniband/sw/rdmavt/rvt_verbs.h
 create mode 100644 include/rdma/ib_rvt.h
 create mode 100644 include/uapi/rdma/ib_user_rvt.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 978526c..e5b4034 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6945,6 +6945,14 @@ W:	http://www.mellanox.com
 Q:	http://patchwork.ozlabs.org/project/netdev/list/
 F:	drivers/net/ethernet/mellanox/mlxsw/
 
+RDMA VERBS TRANSPORT DRIVER (rvt)
+M:	Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+M:	Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+F:	drivers/infiniband/sw/rdmavt
+F:	include/rdma/ib_rvt.h
+F:	include/uapi/rdma/ib_user_rvt.h
+
 MEMBARRIER SUPPORT
 M:	Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
 M:	"Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 8a8440c..1e82984 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -74,6 +74,8 @@ source "drivers/infiniband/hw/nes/Kconfig"
 source "drivers/infiniband/hw/ocrdma/Kconfig"
 source "drivers/infiniband/hw/usnic/Kconfig"
 
+source "drivers/infiniband/sw/rdmavt/Kconfig"
+
 source "drivers/infiniband/ulp/ipoib/Kconfig"
 
 source "drivers/infiniband/ulp/srp/Kconfig"
diff --git a/drivers/infiniband/Makefile b/drivers/infiniband/Makefile
index dc21836..fad0b44 100644
--- a/drivers/infiniband/Makefile
+++ b/drivers/infiniband/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_INFINIBAND)		+= core/
 obj-$(CONFIG_INFINIBAND)		+= hw/
 obj-$(CONFIG_INFINIBAND)		+= ulp/
+obj-$(CONFIG_INFINIBAND)		+= sw/
diff --git a/drivers/infiniband/sw/Makefile b/drivers/infiniband/sw/Makefile
new file mode 100644
index 0000000..c1f6377
--- /dev/null
+++ b/drivers/infiniband/sw/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_INFINIBAND_RDMAVT)		+= rdmavt/
+
diff --git a/drivers/infiniband/sw/rdmavt/Kconfig b/drivers/infiniband/sw/rdmavt/Kconfig
new file mode 100644
index 0000000..3d7d422
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/Kconfig
@@ -0,0 +1,23 @@
+config INFINIBAND_RDMAVT
+	tristate "Software RDMA driver"
+	depends on INFINIBAND
+	---help---
+	This driver implements the InfiniBand RDMA transport over
+	the Linux network stack. It enables a system with a
+	standard Ethernet adapter to interoperate with a RoCE
+	adapter or with another system running the RXE driver.
+	Documentation on InfiniBand and RoCE can be downloaded at
+	www.infinibandta.org and www.openfabrics.org. (See also
+	siw which is a similar software driver for iWARP.)
+
+	The driver is split into two layers, one interfaces with the
+	Linux RDMA stack and implements a kernel or user space
+	verbs API. The user space verbs API requires a support
+	library named librxe which is loaded by the generic user
+	space verbs API, libibverbs. The other layer interfaces
+	with the Linux network stack at layer 3.
+
+	To configure and work with soft-RoCE driver please use the
+	following wiki page under "configure Soft-RoCE (RXE)" section:
+
+	https://github.com/SoftRoCE/rxe-dev/wiki/rxe-dev:-Home
diff --git a/drivers/infiniband/sw/rdmavt/Makefile b/drivers/infiniband/sw/rdmavt/Makefile
new file mode 100644
index 0000000..6d146fe
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/Makefile
@@ -0,0 +1,22 @@
+obj-$(CONFIG_INFINIBAND_RDMAVT) += rdmavt.o
+
+rdmavt-y := \
+	rvt.o \
+	rvt_comp.o \
+	rvt_req.o \
+	rvt_resp.o \
+	rvt_recv.o \
+	rvt_pool.o \
+	rvt_queue.o \
+	rvt_verbs.o \
+	rvt_av.o \
+	rvt_srq.o \
+	rvt_qp.o \
+	rvt_cq.o \
+	rvt_mr.o \
+	rvt_dma.o \
+	rvt_opcode.o \
+	rvt_mmap.o \
+	rvt_mcast.o \
+	rvt_icrc.o \
+	rvt_task.o
diff --git a/drivers/infiniband/sw/rdmavt/rvt.c b/drivers/infiniband/sw/rdmavt/rvt.c
new file mode 100644
index 0000000..d6f37e5
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt.c
@@ -0,0 +1,146 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#include "rvt_loc.h"
+
+MODULE_AUTHOR("Bob Pearson, Frank Zago, John Groves, Kamal Heib");
+MODULE_DESCRIPTION("Soft RDMA transport");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_VERSION("0.2");
+
+/* free resources for all ports on a device */
+void rvt_cleanup_ports(struct rvt_dev *rvt)
+{
+	unsigned int port_num;
+	struct rvt_port *port;
+
+	for (port_num = 1; port_num <= rvt->num_ports; port_num++) {
+		port = &rvt->port[port_num - 1];
+
+		kfree(port->pkey_tbl);
+		port->pkey_tbl = NULL;
+	}
+
+	kfree(rvt->port);
+	rvt->port = NULL;
+}
+
+/* free resources for a rvt device all objects created for this device must
+ * have been destroyed
+ */
+static void rvt_cleanup(struct rvt_dev *rvt)
+{
+	rvt_pool_cleanup(&rvt->uc_pool);
+	rvt_pool_cleanup(&rvt->pd_pool);
+	rvt_pool_cleanup(&rvt->ah_pool);
+	rvt_pool_cleanup(&rvt->srq_pool);
+	rvt_pool_cleanup(&rvt->qp_pool);
+	rvt_pool_cleanup(&rvt->cq_pool);
+	rvt_pool_cleanup(&rvt->mr_pool);
+	rvt_pool_cleanup(&rvt->fmr_pool);
+	rvt_pool_cleanup(&rvt->mw_pool);
+	rvt_pool_cleanup(&rvt->mc_grp_pool);
+	rvt_pool_cleanup(&rvt->mc_elem_pool);
+
+	rvt_cleanup_ports(rvt);
+}
+
+/* called when all references have been dropped */
+void rvt_release(struct kref *kref)
+{
+	struct rvt_dev *rvt = container_of(kref, struct rvt_dev, ref_cnt);
+
+	rvt_cleanup(rvt);
+	ib_dealloc_device(&rvt->ib_dev);
+}
+
+void rvt_dev_put(struct rvt_dev *rvt)
+{
+	kref_put(&rvt->ref_cnt, rvt_release);
+}
+EXPORT_SYMBOL_GPL(rvt_dev_put);
+
+int rvt_set_mtu(struct rvt_dev *rvt, unsigned int ndev_mtu,
+		unsigned int port_num)
+{
+	struct rvt_port *port = &rvt->port[port_num - 1];
+	enum ib_mtu mtu;
+
+	mtu = eth_mtu_int_to_enum(ndev_mtu);
+
+	/* Make sure that new MTU in range */
+	mtu = mtu ? min_t(enum ib_mtu, mtu, RVT_PORT_MAX_MTU) : IB_MTU_256;
+
+	port->attr.active_mtu = mtu;
+	port->mtu_cap = ib_mtu_enum_to_int(mtu);
+
+	return 0;
+}
+EXPORT_SYMBOL(rvt_set_mtu);
+
+void rvt_send_done(void *rvt_ctx)
+{
+	struct rvt_qp *qp = (struct rvt_qp *)rvt_ctx;
+	int skb_out = atomic_dec_return(&qp->skb_out);
+
+	if (unlikely(qp->need_req_skb &&
+		     skb_out < RVT_INFLIGHT_SKBS_PER_QP_LOW))
+		rvt_run_task(&qp->req.task, 1);
+}
+EXPORT_SYMBOL(rvt_send_done);
+
+static int __init rvt_module_init(void)
+{
+	int err;
+
+	/* initialize slab caches for managed objects */
+	err = rvt_cache_init();
+	if (err) {
+		pr_err("rvt: unable to init object pools\n");
+		return err;
+	}
+
+	pr_info("rvt: loaded\n");
+
+	return 0;
+}
+
+static void __exit rvt_module_exit(void)
+{
+	rvt_cache_exit();
+
+	pr_info("rvt: unloaded\n");
+}
+
+module_init(rvt_module_init);
+module_exit(rvt_module_exit);
diff --git a/drivers/infiniband/sw/rdmavt/rvt_av.c b/drivers/infiniband/sw/rdmavt/rvt_av.c
new file mode 100644
index 0000000..f0d183f
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_av.c
@@ -0,0 +1,281 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *	   Redistribution and use in source and binary forms, with or
+ *	   without modification, are permitted provided that the following
+ *	   conditions are met:
+ *
+ *		- Redistributions of source code must retain the above
+ *		  copyright notice, this list of conditions and the following
+ *		  disclaimer.
+ *
+ *		- Redistributions in binary form must reproduce the above
+ *		  copyright notice, this list of conditions and the following
+ *		  disclaimer in the documentation and/or other materials
+ *		  provided with the distribution.
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
+#include <linux/skbuff.h>
+#include <linux/if_arp.h>
+#include <linux/netdevice.h>
+#include <linux/if.h>
+#include <linux/if_vlan.h>
+#include <net/udp_tunnel.h>
+#include <net/sch_generic.h>
+#include <linux/netfilter.h>
+#include <rdma/ib_addr.h>
+
+#include "rvt_loc.h"
+
+int rvt_av_chk_attr(struct rvt_dev *rvt, struct ib_ah_attr *attr)
+{
+	struct rvt_port *port;
+
+	if (attr->port_num < 1 || attr->port_num > rvt->num_ports) {
+		pr_info("rvt: invalid port_num = %d\n", attr->port_num);
+		return -EINVAL;
+	}
+
+	port = &rvt->port[attr->port_num - 1];
+
+	if (attr->ah_flags & IB_AH_GRH) {
+		if (attr->grh.sgid_index > port->attr.gid_tbl_len) {
+			pr_info("rvt: invalid sgid index = %d\n",
+				attr->grh.sgid_index);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+int rvt_av_from_attr(struct rvt_dev *rvt, u8 port_num,
+		     struct rvt_av *av, struct ib_ah_attr *attr)
+{
+	memset(av, 0, sizeof(*av));
+	memcpy(&av->grh, &attr->grh, sizeof(attr->grh));
+	av->port_num = port_num;
+	return 0;
+}
+
+int rvt_av_to_attr(struct rvt_dev *rvt, struct rvt_av *av,
+		   struct ib_ah_attr *attr)
+{
+	memcpy(&attr->grh, &av->grh, sizeof(av->grh));
+	attr->port_num = av->port_num;
+	return 0;
+}
+
+int rvt_av_fill_ip_info(struct rvt_dev *rvt,
+			struct rvt_av *av,
+			struct ib_ah_attr *attr,
+			struct ib_gid_attr *sgid_attr,
+			union ib_gid *sgid)
+{
+	rdma_gid2ip(&av->sgid_addr._sockaddr, sgid);
+	rdma_gid2ip(&av->dgid_addr._sockaddr, &attr->grh.dgid);
+	av->network_type = ib_gid_to_network_type(sgid_attr->gid_type, sgid);
+
+	return 0;
+}
+
+static struct rtable *rvt_find_route4(struct in_addr *saddr,
+				      struct in_addr *daddr)
+{
+	struct rtable *rt;
+	struct flowi4 fl = { { 0 } };
+
+	memset(&fl, 0, sizeof(fl));
+	memcpy(&fl.saddr, saddr, sizeof(*saddr));
+	memcpy(&fl.daddr, daddr, sizeof(*daddr));
+	fl.flowi4_proto = IPPROTO_UDP;
+
+	rt = ip_route_output_key(&init_net, &fl);
+	if (IS_ERR(rt)) {
+		pr_err("no route to %pI4\n", &daddr->s_addr);
+		return NULL;
+	}
+
+	return rt;
+}
+
+static struct dst_entry *rvt_find_route6(struct net_device *ndev,
+					 struct in6_addr *saddr,
+					 struct in6_addr *daddr)
+{
+	/* TODO get rid of ipv6_stub */
+	/*
+	struct dst_entry *ndst;
+	struct flowi6 fl6 = { { 0 } };
+
+	memset(&fl6, 0, sizeof(fl6));
+	fl6.flowi6_oif = ndev->ifindex;
+	memcpy(&fl6.saddr, saddr, sizeof(*saddr));
+	memcpy(&fl6.daddr, daddr, sizeof(*daddr));
+	fl6.flowi6_proto = IPPROTO_UDP;
+
+	if (unlikely(ipv6_stub->ipv6_dst_lookup(sock_net(recv_sockets.sk6->sk),
+					recv_sockets.sk6->sk, &ndst, &fl6))) {
+		pr_err("no route to %pI6\n", daddr);
+		goto put;
+	}
+
+	if (unlikely(ndst->error)) {
+		pr_err("no route to %pI6\n", daddr);
+		goto put;
+	}
+
+	return ndst;
+put:
+	dst_release(ndst);
+	*/
+	return NULL;
+}
+
+static void prepare_ipv4_hdr(struct rtable *rt, struct sk_buff *skb,
+			     __be32 src, __be32 dst, __u8 proto,
+			     __u8 tos, __u8 ttl, __be16 df, bool xnet)
+{
+	struct iphdr *iph;
+
+	skb_scrub_packet(skb, xnet);
+
+	skb_clear_hash(skb);
+	skb_dst_set(skb, &rt->dst);
+	memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
+
+	skb_push(skb, sizeof(struct iphdr));
+	skb_reset_network_header(skb);
+
+	iph = ip_hdr(skb);
+
+	iph->version	=	IPVERSION;
+	iph->ihl	=	sizeof(struct iphdr) >> 2;
+	iph->frag_off	=	df;
+	iph->protocol	=	proto;
+	iph->tos	=	tos;
+	iph->daddr	=	dst;
+	iph->saddr	=	src;
+	iph->ttl	=	ttl;
+	__ip_select_ident(dev_net(rt->dst.dev), iph,
+			  skb_shinfo(skb)->gso_segs ?: 1);
+	iph->tot_len = htons(skb->len);
+	ip_send_check(iph);
+}
+
+static void prepare_ipv6_hdr(struct dst_entry *dst, struct sk_buff *skb,
+			     struct in6_addr *saddr, struct in6_addr *daddr,
+			     __u8 proto, __u8 prio, __u8 ttl)
+{
+	struct ipv6hdr *ip6h;
+
+	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
+	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED
+			    | IPSKB_REROUTED);
+	skb_dst_set(skb, dst);
+
+	__skb_push(skb, sizeof(*ip6h));
+	skb_reset_network_header(skb);
+	ip6h		  = ipv6_hdr(skb);
+	ip6_flow_hdr(ip6h, prio, htonl(0));
+	ip6h->payload_len = htons(skb->len);
+	ip6h->nexthdr     = proto;
+	ip6h->hop_limit   = ttl;
+	ip6h->daddr	  = *daddr;
+	ip6h->saddr	  = *saddr;
+	ip6h->payload_len = htons(skb->len - sizeof(*ip6h));
+}
+
+static void prepare_udp_hdr(struct sk_buff *skb, __be16 src_port,
+			    __be16 dst_port)
+{
+	struct udphdr *udph;
+
+	__skb_push(skb, sizeof(*udph));
+	skb_reset_transport_header(skb);
+	udph = udp_hdr(skb);
+
+	udph->dest = dst_port;
+	udph->source = src_port;
+	udph->len = htons(skb->len);
+	udph->check = 0;
+}
+
+static int prepare4(struct sk_buff *skb, struct rvt_av *av)
+{
+	struct rtable *rt;
+	bool xnet = false;
+	__be16 df = htons(IP_DF);
+	struct in_addr *saddr = &av->sgid_addr._sockaddr_in.sin_addr;
+	struct in_addr *daddr = &av->dgid_addr._sockaddr_in.sin_addr;
+
+	rt = rvt_find_route4(saddr, daddr);
+	if (!rt) {
+		pr_err("Host not reachable\n");
+		return -EHOSTUNREACH;
+	}
+
+	prepare_udp_hdr(skb, htons(ROCE_V2_UDP_SPORT),
+			htons(ROCE_V2_UDP_DPORT));
+
+	prepare_ipv4_hdr(rt, skb, saddr->s_addr, daddr->s_addr, IPPROTO_UDP,
+			 av->grh.traffic_class, av->grh.hop_limit, df, xnet);
+	return 0;
+}
+
+static int prepare6(struct rvt_dev *rdev, struct sk_buff *skb, struct rvt_av *av)
+{
+	struct dst_entry *dst;
+	struct in6_addr *saddr = &av->sgid_addr._sockaddr_in6.sin6_addr;
+	struct in6_addr *daddr = &av->dgid_addr._sockaddr_in6.sin6_addr;
+	struct net_device *ndev = rdev->ifc_ops->get_netdev ?
+		rdev->ifc_ops->get_netdev(rdev, av->port_num) : NULL;
+
+	if (!ndev)
+		return -EHOSTUNREACH;
+
+	dst = rvt_find_route6(ndev, saddr, daddr);
+	if (!dst) {
+		pr_err("Host not reachable\n");
+		return -EHOSTUNREACH;
+	}
+
+	prepare_udp_hdr(skb, htons(ROCE_V2_UDP_SPORT),
+			htons(ROCE_V2_UDP_DPORT));
+
+	prepare_ipv6_hdr(dst, skb, saddr, daddr, IPPROTO_UDP,
+			 av->grh.traffic_class,
+			 av->grh.hop_limit);
+	return 0;
+}
+int rvt_prepare(struct rvt_dev *rdev, struct rvt_pkt_info *pkt,
+		   struct sk_buff *skb, u32 *crc)
+{
+	int err = 0;
+	struct rvt_av *av = get_av(pkt);
+
+	if (av->network_type == RDMA_NETWORK_IPV4)
+		err = prepare4(skb, av);
+	else if (av->network_type == RDMA_NETWORK_IPV6)
+		err = prepare6(rdev, skb, av);
+
+	*crc = rvt_icrc_hdr(pkt, skb);
+
+	return err;
+}
diff --git a/drivers/infiniband/sw/rdmavt/rvt_comp.c b/drivers/infiniband/sw/rdmavt/rvt_comp.c
new file mode 100644
index 0000000..c0eba03
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_comp.c
@@ -0,0 +1,726 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#include <linux/skbuff.h>
+
+#include "rvt_loc.h"
+#include "rvt_queue.h"
+#include "rvt_task.h"
+
+enum comp_state {
+	COMPST_GET_ACK,
+	COMPST_GET_WQE,
+	COMPST_COMP_WQE,
+	COMPST_COMP_ACK,
+	COMPST_CHECK_PSN,
+	COMPST_CHECK_ACK,
+	COMPST_READ,
+	COMPST_ATOMIC,
+	COMPST_WRITE_SEND,
+	COMPST_UPDATE_COMP,
+	COMPST_ERROR_RETRY,
+	COMPST_RNR_RETRY,
+	COMPST_ERROR,
+	COMPST_EXIT, /* We have an issue, and we want to rerun the completer */
+	COMPST_DONE, /* The completer finished successflly */
+};
+
+static char *comp_state_name[] =  {
+	[COMPST_GET_ACK]		= "GET ACK",
+	[COMPST_GET_WQE]		= "GET WQE",
+	[COMPST_COMP_WQE]		= "COMP WQE",
+	[COMPST_COMP_ACK]		= "COMP ACK",
+	[COMPST_CHECK_PSN]		= "CHECK PSN",
+	[COMPST_CHECK_ACK]		= "CHECK ACK",
+	[COMPST_READ]			= "READ",
+	[COMPST_ATOMIC]			= "ATOMIC",
+	[COMPST_WRITE_SEND]		= "WRITE/SEND",
+	[COMPST_UPDATE_COMP]		= "UPDATE COMP",
+	[COMPST_ERROR_RETRY]		= "ERROR RETRY",
+	[COMPST_RNR_RETRY]		= "RNR RETRY",
+	[COMPST_ERROR]			= "ERROR",
+	[COMPST_EXIT]			= "EXIT",
+	[COMPST_DONE]			= "DONE",
+};
+
+static unsigned long rnrnak_usec[32] = {
+	[IB_RNR_TIMER_655_36] = 655360,
+	[IB_RNR_TIMER_000_01] = 10,
+	[IB_RNR_TIMER_000_02] = 20,
+	[IB_RNR_TIMER_000_03] = 30,
+	[IB_RNR_TIMER_000_04] = 40,
+	[IB_RNR_TIMER_000_06] = 60,
+	[IB_RNR_TIMER_000_08] = 80,
+	[IB_RNR_TIMER_000_12] = 120,
+	[IB_RNR_TIMER_000_16] = 160,
+	[IB_RNR_TIMER_000_24] = 240,
+	[IB_RNR_TIMER_000_32] = 320,
+	[IB_RNR_TIMER_000_48] = 480,
+	[IB_RNR_TIMER_000_64] = 640,
+	[IB_RNR_TIMER_000_96] = 960,
+	[IB_RNR_TIMER_001_28] = 1280,
+	[IB_RNR_TIMER_001_92] = 1920,
+	[IB_RNR_TIMER_002_56] = 2560,
+	[IB_RNR_TIMER_003_84] = 3840,
+	[IB_RNR_TIMER_005_12] = 5120,
+	[IB_RNR_TIMER_007_68] = 7680,
+	[IB_RNR_TIMER_010_24] = 10240,
+	[IB_RNR_TIMER_015_36] = 15360,
+	[IB_RNR_TIMER_020_48] = 20480,
+	[IB_RNR_TIMER_030_72] = 30720,
+	[IB_RNR_TIMER_040_96] = 40960,
+	[IB_RNR_TIMER_061_44] = 61410,
+	[IB_RNR_TIMER_081_92] = 81920,
+	[IB_RNR_TIMER_122_88] = 122880,
+	[IB_RNR_TIMER_163_84] = 163840,
+	[IB_RNR_TIMER_245_76] = 245760,
+	[IB_RNR_TIMER_327_68] = 327680,
+	[IB_RNR_TIMER_491_52] = 491520,
+};
+
+static inline unsigned long rnrnak_jiffies(u8 timeout)
+{
+	return max_t(unsigned long,
+		usecs_to_jiffies(rnrnak_usec[timeout]), 1);
+}
+
+static enum ib_wc_opcode wr_to_wc_opcode(enum ib_wr_opcode opcode)
+{
+	switch (opcode) {
+	case IB_WR_RDMA_WRITE:			return IB_WC_RDMA_WRITE;
+	case IB_WR_RDMA_WRITE_WITH_IMM:		return IB_WC_RDMA_WRITE;
+	case IB_WR_SEND:			return IB_WC_SEND;
+	case IB_WR_SEND_WITH_IMM:		return IB_WC_SEND;
+	case IB_WR_RDMA_READ:			return IB_WC_RDMA_READ;
+	case IB_WR_ATOMIC_CMP_AND_SWP:		return IB_WC_COMP_SWAP;
+	case IB_WR_ATOMIC_FETCH_AND_ADD:	return IB_WC_FETCH_ADD;
+	case IB_WR_LSO:				return IB_WC_LSO;
+	case IB_WR_SEND_WITH_INV:		return IB_WC_SEND;
+	case IB_WR_RDMA_READ_WITH_INV:		return IB_WC_RDMA_READ;
+	case IB_WR_LOCAL_INV:			return IB_WC_LOCAL_INV;
+
+	default:
+		return 0xff;
+	}
+}
+
+void retransmit_timer(unsigned long data)
+{
+	struct rvt_qp *qp = (struct rvt_qp *)data;
+
+	if (qp->valid) {
+		qp->comp.timeout = 1;
+		rvt_run_task(&qp->comp.task, 1);
+	}
+}
+
+void rvt_comp_queue_pkt(struct rvt_dev *rvt, struct rvt_qp *qp,
+			struct sk_buff *skb)
+{
+	int must_sched;
+
+	skb_queue_tail(&qp->resp_pkts, skb);
+
+	must_sched = skb_queue_len(&qp->resp_pkts) > 1;
+	rvt_run_task(&qp->comp.task, must_sched);
+}
+
+static inline enum comp_state get_wqe(struct rvt_qp *qp,
+				      struct rvt_pkt_info *pkt,
+				      struct rvt_send_wqe **wqe_p)
+{
+	struct rvt_send_wqe *wqe;
+
+	/* we come here whether or not we found a response packet to see if
+	 * there are any posted WQEs
+	 */
+	wqe = queue_head(qp->sq.queue);
+	*wqe_p = wqe;
+
+	/* no WQE or requester has not started it yet */
+	if (!wqe || wqe->state == wqe_state_posted)
+		return pkt ? COMPST_DONE : COMPST_EXIT;
+
+	/* WQE does not require an ack */
+	if (wqe->state == wqe_state_done)
+		return COMPST_COMP_WQE;
+
+	/* WQE caused an error */
+	if (wqe->state == wqe_state_error)
+		return COMPST_ERROR;
+
+	/* we have a WQE, if we also have an ack check its PSN */
+	return pkt ? COMPST_CHECK_PSN : COMPST_EXIT;
+}
+
+static inline void reset_retry_counters(struct rvt_qp *qp)
+{
+	qp->comp.retry_cnt = qp->attr.retry_cnt;
+	qp->comp.rnr_retry = qp->attr.rnr_retry;
+}
+
+static inline enum comp_state check_psn(struct rvt_qp *qp,
+					struct rvt_pkt_info *pkt,
+					struct rvt_send_wqe *wqe)
+{
+	s32 diff;
+
+	/* check to see if response is past the oldest WQE. if it is, complete
+	 * send/write or error read/atomic
+	 */
+	diff = psn_compare(pkt->psn, wqe->last_psn);
+	if (diff > 0) {
+		if (wqe->state == wqe_state_pending) {
+			if (wqe->mask & WR_ATOMIC_OR_READ_MASK)
+				return COMPST_ERROR_RETRY;
+
+			reset_retry_counters(qp);
+			return COMPST_COMP_WQE;
+		} else {
+			return COMPST_DONE;
+		}
+	}
+
+	/* compare response packet to expected response */
+	diff = psn_compare(pkt->psn, qp->comp.psn);
+	if (diff < 0) {
+		/* response is most likely a retried packet if it matches an
+		 * uncompleted WQE go complete it else ignore it
+		 */
+		if (pkt->psn == wqe->last_psn)
+			return COMPST_COMP_ACK;
+		else
+			return COMPST_DONE;
+	} else if ((diff > 0) && (wqe->mask & WR_ATOMIC_OR_READ_MASK)) {
+		return COMPST_ERROR_RETRY;
+	} else {
+		return COMPST_CHECK_ACK;
+	}
+}
+
+static inline enum comp_state check_ack(struct rvt_qp *qp,
+					struct rvt_pkt_info *pkt,
+					struct rvt_send_wqe *wqe)
+{
+	unsigned int mask = pkt->mask;
+	u8 syn;
+
+	/* Check the sequence only */
+	switch (qp->comp.opcode) {
+	case -1:
+		/* Will catch all *_ONLY cases. */
+		if (!(mask & RVT_START_MASK))
+			return COMPST_ERROR;
+
+		break;
+
+	case IB_OPCODE_RC_RDMA_READ_RESPONSE_FIRST:
+	case IB_OPCODE_RC_RDMA_READ_RESPONSE_MIDDLE:
+		if (pkt->opcode != IB_OPCODE_RC_RDMA_READ_RESPONSE_MIDDLE &&
+		    pkt->opcode != IB_OPCODE_RC_RDMA_READ_RESPONSE_LAST) {
+			return COMPST_ERROR;
+		}
+		break;
+	default:
+		WARN_ON(1);
+	}
+
+	/* Check operation validity. */
+	switch (pkt->opcode) {
+	case IB_OPCODE_RC_RDMA_READ_RESPONSE_FIRST:
+	case IB_OPCODE_RC_RDMA_READ_RESPONSE_LAST:
+	case IB_OPCODE_RC_RDMA_READ_RESPONSE_ONLY:
+		syn = aeth_syn(pkt);
+
+		if ((syn & AETH_TYPE_MASK) != AETH_ACK)
+			return COMPST_ERROR;
+
+		/* Fall through (IB_OPCODE_RC_RDMA_READ_RESPONSE_MIDDLE
+		 * doesn't have an AETH)
+		 */
+	case IB_OPCODE_RC_RDMA_READ_RESPONSE_MIDDLE:
+		if (wqe->wr.opcode != IB_WR_RDMA_READ &&
+		    wqe->wr.opcode != IB_WR_RDMA_READ_WITH_INV) {
+			return COMPST_ERROR;
+		}
+		reset_retry_counters(qp);
+		return COMPST_READ;
+
+	case IB_OPCODE_RC_ATOMIC_ACKNOWLEDGE:
+		syn = aeth_syn(pkt);
+
+		if ((syn & AETH_TYPE_MASK) != AETH_ACK)
+			return COMPST_ERROR;
+
+		if (wqe->wr.opcode != IB_WR_ATOMIC_CMP_AND_SWP &&
+		    wqe->wr.opcode != IB_WR_ATOMIC_FETCH_AND_ADD)
+			return COMPST_ERROR;
+		reset_retry_counters(qp);
+		return COMPST_ATOMIC;
+
+	case IB_OPCODE_RC_ACKNOWLEDGE:
+		syn = aeth_syn(pkt);
+		switch (syn & AETH_TYPE_MASK) {
+		case AETH_ACK:
+			reset_retry_counters(qp);
+			return COMPST_WRITE_SEND;
+
+		case AETH_RNR_NAK:
+			return COMPST_RNR_RETRY;
+
+		case AETH_NAK:
+			switch (syn) {
+			case AETH_NAK_PSN_SEQ_ERROR:
+				/* a nak implicitly acks all packets with psns
+				 * before
+				 */
+				if (psn_compare(pkt->psn, qp->comp.psn) > 0) {
+					qp->comp.psn = pkt->psn;
+					if (qp->req.wait_psn) {
+						qp->req.wait_psn = 0;
+						rvt_run_task(&qp->req.task, 1);
+					}
+				}
+				return COMPST_ERROR_RETRY;
+
+			case AETH_NAK_INVALID_REQ:
+				wqe->status = IB_WC_REM_INV_REQ_ERR;
+				return COMPST_ERROR;
+
+			case AETH_NAK_REM_ACC_ERR:
+				wqe->status = IB_WC_REM_ACCESS_ERR;
+				return COMPST_ERROR;
+
+			case AETH_NAK_REM_OP_ERR:
+				wqe->status = IB_WC_REM_OP_ERR;
+				return COMPST_ERROR;
+
+			default:
+				pr_warn("unexpected nak %x\n", syn);
+				wqe->status = IB_WC_REM_OP_ERR;
+				return COMPST_ERROR;
+			}
+
+		default:
+			return COMPST_ERROR;
+		}
+		break;
+
+	default:
+		pr_warn("unexpected opcode\n");
+	}
+
+	return COMPST_ERROR;
+}
+
+static inline enum comp_state do_read(struct rvt_qp *qp,
+				      struct rvt_pkt_info *pkt,
+				      struct rvt_send_wqe *wqe)
+{
+	struct rvt_dev *rvt = to_rdev(qp->ibqp.device);
+	int ret;
+
+	ret = copy_data(rvt, qp->pd, IB_ACCESS_LOCAL_WRITE,
+			&wqe->dma, payload_addr(pkt),
+			payload_size(pkt), to_mem_obj, NULL);
+	if (ret)
+		return COMPST_ERROR;
+
+	if (wqe->dma.resid == 0 && (pkt->mask & RVT_END_MASK))
+		return COMPST_COMP_ACK;
+	else
+		return COMPST_UPDATE_COMP;
+}
+
+static inline enum comp_state do_atomic(struct rvt_qp *qp,
+					struct rvt_pkt_info *pkt,
+					struct rvt_send_wqe *wqe)
+{
+	struct rvt_dev *rvt = to_rdev(qp->ibqp.device);
+	int ret;
+
+	u64 atomic_orig = atmack_orig(pkt);
+
+	ret = copy_data(rvt, qp->pd, IB_ACCESS_LOCAL_WRITE,
+			&wqe->dma, &atomic_orig,
+			sizeof(u64), to_mem_obj, NULL);
+	if (ret)
+		return COMPST_ERROR;
+	else
+		return COMPST_COMP_ACK;
+}
+
+static void make_send_cqe(struct rvt_qp *qp, struct rvt_send_wqe *wqe,
+			  struct rvt_cqe *cqe)
+{
+	memset(cqe, 0, sizeof(*cqe));
+
+	if (!qp->is_user) {
+		struct ib_wc		*wc	= &cqe->ibwc;
+
+		wc->wr_id		= wqe->wr.wr_id;
+		wc->status		= wqe->status;
+		wc->opcode		= wr_to_wc_opcode(wqe->wr.opcode);
+		wc->byte_len		= wqe->dma.length;
+		wc->qp			= &qp->ibqp;
+	} else {
+		struct ib_uverbs_wc	*uwc	= &cqe->uibwc;
+
+		uwc->wr_id		= wqe->wr.wr_id;
+		uwc->status		= wqe->status;
+		uwc->opcode		= wr_to_wc_opcode(wqe->wr.opcode);
+		uwc->byte_len		= wqe->dma.length;
+		uwc->qp_num		= qp->ibqp.qp_num;
+	}
+}
+
+static void do_complete(struct rvt_qp *qp, struct rvt_send_wqe *wqe)
+{
+	struct rvt_cqe cqe;
+
+	if ((qp->sq_sig_type == IB_SIGNAL_ALL_WR) ||
+	    (wqe->wr.send_flags & IB_SEND_SIGNALED) ||
+	    (qp->req.state == QP_STATE_ERROR)) {
+		make_send_cqe(qp, wqe, &cqe);
+		rvt_cq_post(qp->scq, &cqe, 0);
+	}
+
+	advance_consumer(qp->sq.queue);
+
+	/*
+	 * we completed something so let req run again
+	 * if it is trying to fence
+	 */
+	if (qp->req.wait_fence) {
+		qp->req.wait_fence = 0;
+		rvt_run_task(&qp->req.task, 1);
+	}
+}
+
+static inline enum comp_state complete_ack(struct rvt_qp *qp,
+					   struct rvt_pkt_info *pkt,
+					   struct rvt_send_wqe *wqe)
+{
+	unsigned long flags;
+
+	if (wqe->has_rd_atomic) {
+		wqe->has_rd_atomic = 0;
+		atomic_inc(&qp->req.rd_atomic);
+		if (qp->req.need_rd_atomic) {
+			qp->comp.timeout_retry = 0;
+			qp->req.need_rd_atomic = 0;
+			rvt_run_task(&qp->req.task, 1);
+		}
+	}
+
+	if (unlikely(qp->req.state == QP_STATE_DRAIN)) {
+		/* state_lock used by requester & completer */
+		spin_lock_irqsave(&qp->state_lock, flags);
+		if ((qp->req.state == QP_STATE_DRAIN) &&
+		    (qp->comp.psn == qp->req.psn)) {
+			qp->req.state = QP_STATE_DRAINED;
+			spin_unlock_irqrestore(&qp->state_lock, flags);
+
+			if (qp->ibqp.event_handler) {
+				struct ib_event ev;
+
+				ev.device = qp->ibqp.device;
+				ev.element.qp = &qp->ibqp;
+				ev.event = IB_EVENT_SQ_DRAINED;
+				qp->ibqp.event_handler(&ev,
+					qp->ibqp.qp_context);
+			}
+		} else {
+			spin_unlock_irqrestore(&qp->state_lock, flags);
+		}
+	}
+
+	do_complete(qp, wqe);
+
+	if (psn_compare(pkt->psn, qp->comp.psn) >= 0)
+		return COMPST_UPDATE_COMP;
+	else
+		return COMPST_DONE;
+}
+
+static inline enum comp_state complete_wqe(struct rvt_qp *qp,
+					   struct rvt_pkt_info *pkt,
+					   struct rvt_send_wqe *wqe)
+{
+	qp->comp.opcode = -1;
+
+	if (pkt) {
+		if (psn_compare(pkt->psn, qp->comp.psn) >= 0)
+			qp->comp.psn = (pkt->psn + 1) & BTH_PSN_MASK;
+
+		if (qp->req.wait_psn) {
+			qp->req.wait_psn = 0;
+			rvt_run_task(&qp->req.task, 1);
+		}
+	}
+
+	do_complete(qp, wqe);
+
+	return COMPST_GET_WQE;
+}
+
+int rvt_completer(void *arg)
+{
+	struct rvt_qp *qp = (struct rvt_qp *)arg;
+	struct rvt_send_wqe *wqe = wqe;
+	struct sk_buff *skb = NULL;
+	struct rvt_pkt_info *pkt = NULL;
+	enum comp_state state;
+
+	if (!qp->valid) {
+		while ((skb = skb_dequeue(&qp->resp_pkts))) {
+			rvt_drop_ref(qp);
+			kfree_skb(skb);
+		}
+		skb = NULL;
+		pkt = NULL;
+
+		while (queue_head(qp->sq.queue))
+			advance_consumer(qp->sq.queue);
+
+		goto exit;
+	}
+
+	if (qp->req.state == QP_STATE_ERROR) {
+		while ((skb = skb_dequeue(&qp->resp_pkts))) {
+			rvt_drop_ref(qp);
+			kfree_skb(skb);
+		}
+		skb = NULL;
+		pkt = NULL;
+
+		while ((wqe = queue_head(qp->sq.queue))) {
+			wqe->status = IB_WC_WR_FLUSH_ERR;
+			do_complete(qp, wqe);
+		}
+
+		goto exit;
+	}
+
+	if (qp->req.state == QP_STATE_RESET) {
+		while ((skb = skb_dequeue(&qp->resp_pkts))) {
+			rvt_drop_ref(qp);
+			kfree_skb(skb);
+		}
+		skb = NULL;
+		pkt = NULL;
+
+		while (queue_head(qp->sq.queue))
+			advance_consumer(qp->sq.queue);
+
+		goto exit;
+	}
+
+	if (qp->comp.timeout) {
+		qp->comp.timeout_retry = 1;
+		qp->comp.timeout = 0;
+	} else {
+		qp->comp.timeout_retry = 0;
+	}
+
+	if (qp->req.need_retry)
+		goto exit;
+
+	state = COMPST_GET_ACK;
+
+	while (1) {
+		pr_debug("state = %s\n", comp_state_name[state]);
+		switch (state) {
+		case COMPST_GET_ACK:
+			skb = skb_dequeue(&qp->resp_pkts);
+			if (skb) {
+				pkt = SKB_TO_PKT(skb);
+				qp->comp.timeout_retry = 0;
+			}
+			state = COMPST_GET_WQE;
+			break;
+
+		case COMPST_GET_WQE:
+			state = get_wqe(qp, pkt, &wqe);
+			break;
+
+		case COMPST_CHECK_PSN:
+			state = check_psn(qp, pkt, wqe);
+			break;
+
+		case COMPST_CHECK_ACK:
+			state = check_ack(qp, pkt, wqe);
+			break;
+
+		case COMPST_READ:
+			state = do_read(qp, pkt, wqe);
+			break;
+
+		case COMPST_ATOMIC:
+			state = do_atomic(qp, pkt, wqe);
+			break;
+
+		case COMPST_WRITE_SEND:
+			if (wqe->state == wqe_state_pending &&
+			    wqe->last_psn == pkt->psn)
+				state = COMPST_COMP_ACK;
+			else
+				state = COMPST_UPDATE_COMP;
+			break;
+
+		case COMPST_COMP_ACK:
+			state = complete_ack(qp, pkt, wqe);
+			break;
+
+		case COMPST_COMP_WQE:
+			state = complete_wqe(qp, pkt, wqe);
+			break;
+
+		case COMPST_UPDATE_COMP:
+			if (pkt->mask & RVT_END_MASK)
+				qp->comp.opcode = -1;
+			else
+				qp->comp.opcode = pkt->opcode;
+
+			if (psn_compare(pkt->psn, qp->comp.psn) >= 0)
+				qp->comp.psn = (pkt->psn + 1) & BTH_PSN_MASK;
+
+			if (qp->req.wait_psn) {
+				qp->req.wait_psn = 0;
+				rvt_run_task(&qp->req.task, 1);
+			}
+
+			state = COMPST_DONE;
+			break;
+
+		case COMPST_DONE:
+			if (pkt) {
+				rvt_drop_ref(pkt->qp);
+				kfree_skb(skb);
+			}
+			goto done;
+
+		case COMPST_EXIT:
+			if (qp->comp.timeout_retry && wqe) {
+				state = COMPST_ERROR_RETRY;
+				break;
+			}
+
+			/* re reset the timeout counter if
+			 * (1) QP is type RC
+			 * (2) the QP is alive
+			 * (3) there is a packet sent by the requester that
+			 *     might be acked (we still might get spurious
+			 *     timeouts but try to keep them as few as possible)
+			 * (4) the timeout parameter is set
+			 */
+			if ((qp_type(qp) == IB_QPT_RC) &&
+			    (qp->req.state == QP_STATE_READY) &&
+			    (psn_compare(qp->req.psn, qp->comp.psn) > 0) &&
+			    qp->qp_timeout_jiffies)
+				mod_timer(&qp->retrans_timer,
+					  jiffies + qp->qp_timeout_jiffies);
+			goto exit;
+
+		case COMPST_ERROR_RETRY:
+			/* we come here if the retry timer fired and we did
+			 * not receive a response packet. try to retry the send
+			 * queue if that makes sense and the limits have not
+			 * been exceeded. remember that some timeouts are
+			 * spurious since we do not reset the timer but kick
+			 * it down the road or let it expire
+			 */
+
+			/* there is nothing to retry in this case */
+			if (!wqe || (wqe->state == wqe_state_posted))
+				goto exit;
+
+			if (qp->comp.retry_cnt > 0) {
+				if (qp->comp.retry_cnt != 7)
+					qp->comp.retry_cnt--;
+
+				/* no point in retrying if we have already
+				 * seen the last ack that the requester could
+				 * have caused
+				 */
+				if (psn_compare(qp->req.psn,
+						qp->comp.psn) > 0) {
+					/* tell the requester to retry the
+					 * send send queue next time around
+					 */
+					qp->req.need_retry = 1;
+					rvt_run_task(&qp->req.task, 1);
+				}
+				goto exit;
+			} else {
+				wqe->status = IB_WC_RETRY_EXC_ERR;
+				state = COMPST_ERROR;
+			}
+			break;
+
+		case COMPST_RNR_RETRY:
+			if (qp->comp.rnr_retry > 0) {
+				if (qp->comp.rnr_retry != 7)
+					qp->comp.rnr_retry--;
+
+				qp->req.need_retry = 1;
+				pr_debug("set rnr nak timer\n");
+				mod_timer(&qp->rnr_nak_timer,
+					  jiffies + rnrnak_jiffies(aeth_syn(pkt)
+						& ~AETH_TYPE_MASK));
+				goto exit;
+			} else {
+				wqe->status = IB_WC_RNR_RETRY_EXC_ERR;
+				state = COMPST_ERROR;
+			}
+			break;
+
+		case COMPST_ERROR:
+			do_complete(qp, wqe);
+			rvt_qp_error(qp);
+			goto exit;
+		}
+	}
+
+exit:
+	/* we come here if we are done with processing and want the task to
+	 * exit from the loop calling us
+	 */
+	return -EAGAIN;
+
+done:
+	/* we come here if we have processed a packet we want the task to call
+	 * us again to see if there is anything else to do
+	 */
+	return 0;
+}
diff --git a/drivers/infiniband/sw/rdmavt/rvt_cq.c b/drivers/infiniband/sw/rdmavt/rvt_cq.c
new file mode 100644
index 0000000..d14b2cc
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_cq.c
@@ -0,0 +1,164 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *	   Redistribution and use in source and binary forms, with or
+ *	   without modification, are permitted provided that the following
+ *	   conditions are met:
+ *
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#include "rvt_loc.h"
+#include "rvt_queue.h"
+
+int rvt_cq_chk_attr(struct rvt_dev *rvt, struct rvt_cq *cq,
+		    int cqe, int comp_vector, struct ib_udata *udata)
+{
+	int count;
+
+	if (cqe <= 0) {
+		pr_warn("cqe(%d) <= 0\n", cqe);
+		goto err1;
+	}
+
+	if (cqe > rvt->attr.max_cqe) {
+		pr_warn("cqe(%d) > max_cqe(%d)\n",
+			cqe, rvt->attr.max_cqe);
+		goto err1;
+	}
+
+	if (cq) {
+		count = queue_count(cq->queue);
+		if (cqe < count) {
+			pr_warn("cqe(%d) < current # elements in queue (%d)",
+				cqe, count);
+			goto err1;
+		}
+	}
+
+	return 0;
+
+err1:
+	return -EINVAL;
+}
+
+static void rvt_send_complete(unsigned long data)
+{
+	struct rvt_cq *cq = (struct rvt_cq *)data;
+
+	cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
+}
+
+int rvt_cq_from_init(struct rvt_dev *rvt, struct rvt_cq *cq, int cqe,
+		     int comp_vector, struct ib_ucontext *context,
+		     struct ib_udata *udata)
+{
+	int err;
+
+	cq->queue = rvt_queue_init(rvt, &cqe,
+				   sizeof(struct rvt_cqe));
+	if (!cq->queue) {
+		pr_warn("unable to create cq\n");
+		return -ENOMEM;
+	}
+
+	err = do_mmap_info(rvt, udata, false, context, cq->queue->buf,
+			   cq->queue->buf_size, &cq->queue->ip);
+	if (err) {
+		kvfree(cq->queue->buf);
+		kfree(cq->queue);
+		return err;
+	}
+
+	if (udata)
+		cq->is_user = 1;
+
+	tasklet_init(&cq->comp_task, rvt_send_complete, (unsigned long)cq);
+
+	spin_lock_init(&cq->cq_lock);
+	cq->ibcq.cqe = cqe;
+	return 0;
+}
+
+int rvt_cq_resize_queue(struct rvt_cq *cq, int cqe, struct ib_udata *udata)
+{
+	int err;
+
+	err = rvt_queue_resize(cq->queue, (unsigned int *)&cqe,
+			       sizeof(struct rvt_cqe),
+			       cq->queue->ip ? cq->queue->ip->context : NULL,
+			       udata, NULL, &cq->cq_lock);
+	if (!err)
+		cq->ibcq.cqe = cqe;
+
+	return err;
+}
+
+int rvt_cq_post(struct rvt_cq *cq, struct rvt_cqe *cqe, int solicited)
+{
+	struct ib_event ev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cq->cq_lock, flags);
+
+	if (unlikely(queue_full(cq->queue))) {
+		spin_unlock_irqrestore(&cq->cq_lock, flags);
+		if (cq->ibcq.event_handler) {
+			ev.device = cq->ibcq.device;
+			ev.element.cq = &cq->ibcq;
+			ev.event = IB_EVENT_CQ_ERR;
+			cq->ibcq.event_handler(&ev, cq->ibcq.cq_context);
+		}
+
+		return -EBUSY;
+	}
+
+	memcpy(producer_addr(cq->queue), cqe, sizeof(*cqe));
+
+	/* make sure all changes to the CQ are written before we update the
+	 * producer pointer
+	 */
+	smp_wmb();
+
+	advance_producer(cq->queue);
+	spin_unlock_irqrestore(&cq->cq_lock, flags);
+
+	if ((cq->notify == IB_CQ_NEXT_COMP) ||
+	    (cq->notify == IB_CQ_SOLICITED && solicited)) {
+		cq->notify++;
+		tasklet_schedule(&cq->comp_task);
+	}
+
+	return 0;
+}
+
+void rvt_cq_cleanup(void *arg)
+{
+	struct rvt_cq *cq = arg;
+
+	if (cq->queue)
+		rvt_queue_cleanup(cq->queue);
+}
diff --git a/drivers/infiniband/sw/rdmavt/rvt_dma.c b/drivers/infiniband/sw/rdmavt/rvt_dma.c
new file mode 100644
index 0000000..1139719
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_dma.c
@@ -0,0 +1,165 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#include "rvt_loc.h"
+
+#define DMA_BAD_ADDER ((u64)0)
+
+static int rvt_mapping_error(struct ib_device *dev, u64 dma_addr)
+{
+	return dma_addr == DMA_BAD_ADDER;
+}
+
+static u64 rvt_dma_map_single(struct ib_device *dev,
+			      void *cpu_addr, size_t size,
+			      enum dma_data_direction direction)
+{
+	WARN_ON(!valid_dma_direction(direction));
+	return (u64)cpu_addr;
+}
+
+static void rvt_dma_unmap_single(struct ib_device *dev,
+				 u64 addr, size_t size,
+				 enum dma_data_direction direction)
+{
+	WARN_ON(!valid_dma_direction(direction));
+}
+
+static u64 rvt_dma_map_page(struct ib_device *dev,
+			    struct page *page,
+			    unsigned long offset,
+			    size_t size, enum dma_data_direction direction)
+{
+	u64 addr;
+
+	WARN_ON(!valid_dma_direction(direction));
+
+	if (offset + size > PAGE_SIZE) {
+		addr = DMA_BAD_ADDER;
+		goto done;
+	}
+
+	addr = (u64)page_address(page);
+	if (addr)
+		addr += offset;
+
+done:
+	return addr;
+}
+
+static void rvt_dma_unmap_page(struct ib_device *dev,
+			       u64 addr, size_t size,
+			       enum dma_data_direction direction)
+{
+	WARN_ON(!valid_dma_direction(direction));
+}
+
+static int rvt_map_sg(struct ib_device *dev, struct scatterlist *sgl,
+		      int nents, enum dma_data_direction direction)
+{
+	struct scatterlist *sg;
+	u64 addr;
+	int i;
+	int ret = nents;
+
+	WARN_ON(!valid_dma_direction(direction));
+
+	for_each_sg(sgl, sg, nents, i) {
+		addr = (u64)page_address(sg_page(sg));
+		if (!addr) {
+			ret = 0;
+			break;
+		}
+		sg->dma_address = addr + sg->offset;
+#ifdef CONFIG_NEED_SG_DMA_LENGTH
+		sg->dma_length = sg->length;
+#endif
+	}
+
+	return ret;
+}
+
+static void rvt_unmap_sg(struct ib_device *dev,
+			 struct scatterlist *sg, int nents,
+			 enum dma_data_direction direction)
+{
+	WARN_ON(!valid_dma_direction(direction));
+}
+
+static void rvt_sync_single_for_cpu(struct ib_device *dev,
+				    u64 addr,
+				    size_t size, enum dma_data_direction dir)
+{
+}
+
+static void rvt_sync_single_for_device(struct ib_device *dev,
+				       u64 addr,
+				       size_t size, enum dma_data_direction dir)
+{
+}
+
+static void *rvt_dma_alloc_coherent(struct ib_device *dev, size_t size,
+				    u64 *dma_handle, gfp_t flag)
+{
+	struct page *p;
+	void *addr = NULL;
+
+	p = alloc_pages(flag, get_order(size));
+	if (p)
+		addr = page_address(p);
+
+	if (dma_handle)
+		*dma_handle = (u64)addr;
+
+	return addr;
+}
+
+static void rvt_dma_free_coherent(struct ib_device *dev, size_t size,
+				  void *cpu_addr, u64 dma_handle)
+{
+	free_pages((unsigned long)cpu_addr, get_order(size));
+}
+
+struct ib_dma_mapping_ops rvt_dma_mapping_ops = {
+	.mapping_error		= rvt_mapping_error,
+	.map_single		= rvt_dma_map_single,
+	.unmap_single		= rvt_dma_unmap_single,
+	.map_page		= rvt_dma_map_page,
+	.unmap_page		= rvt_dma_unmap_page,
+	.map_sg			= rvt_map_sg,
+	.unmap_sg		= rvt_unmap_sg,
+	.sync_single_for_cpu	= rvt_sync_single_for_cpu,
+	.sync_single_for_device	= rvt_sync_single_for_device,
+	.alloc_coherent		= rvt_dma_alloc_coherent,
+	.free_coherent		= rvt_dma_free_coherent
+};
diff --git a/drivers/infiniband/sw/rdmavt/rvt_hdr.h b/drivers/infiniband/sw/rdmavt/rvt_hdr.h
new file mode 100644
index 0000000..1294ac3
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_hdr.h
@@ -0,0 +1,952 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#ifndef RVT_HDR_H
+#define RVT_HDR_H
+
+#include "rvt_opcode.h"
+
+/* extracted information about a packet carried in an sk_buff struct fits in
+ * the skbuff cb array. Must be at most 48 bytes.
+ */
+struct rvt_pkt_info {
+	struct rvt_dev		*rdev;		/* device that owns packet */
+	struct rvt_qp		*qp;		/* qp that owns packet */
+	struct rvt_send_wqe	*wqe;		/* send wqe */
+	u8			*hdr;		/* points to bth */
+	u32			mask;		/* useful info about pkt */
+	u32			psn;		/* bth psn of packet */
+	u16			pkey_index;	/* partition of pkt */
+	u16			paylen;		/* length of bth - icrc */
+	u8			port_num;	/* port pkt received on */
+	u8			opcode;		/* bth opcode of packet */
+	u8			offset;		/* bth offset from pkt->hdr */
+};
+
+#define SKB_TO_PKT(skb) ((struct rvt_pkt_info *)(skb)->cb)
+#define PKT_TO_SKB(pkt) container_of((void *)(pkt), struct sk_buff, cb)
+
+/*
+ * IBA header types and methods
+ *
+ * Some of these are for reference and completeness only since
+ * rvt does not currently support RD transport
+ * most of this could be moved into IB core. ib_pack.h has
+ * part of this but is incomplete
+ *
+ * Header specific routines to insert/extract values to/from headers
+ * the routines that are named __hhh_(set_)fff() take a pointer to a
+ * hhh header and get(set) the fff field. The routines named
+ * hhh_(set_)fff take a packet info struct and find the
+ * header and field based on the opcode in the packet.
+ * Conversion to/from network byte order from cpu order is also done.
+ */
+
+#define RVT_ICRC_SIZE		(4)
+#define RVT_MAX_HDR_LENGTH	(80)
+
+/******************************************************************************
+ * Base Transport Header
+ ******************************************************************************/
+struct rvt_bth {
+	u8			opcode;
+	u8			flags;
+	__be16			pkey;
+	__be32			qpn;
+	__be32			apsn;
+};
+
+#define BTH_TVER		(0)
+#define BTH_DEF_PKEY		(0xffff)
+
+#define BTH_SE_MASK		(0x80)
+#define BTH_MIG_MASK		(0x40)
+#define BTH_PAD_MASK		(0x30)
+#define BTH_TVER_MASK		(0x0f)
+#define BTH_FECN_MASK		(0x80000000)
+#define BTH_BECN_MASK		(0x40000000)
+#define BTH_RESV6A_MASK		(0x3f000000)
+#define BTH_QPN_MASK		(0x00ffffff)
+#define BTH_ACK_MASK		(0x80000000)
+#define BTH_RESV7_MASK		(0x7f000000)
+#define BTH_PSN_MASK		(0x00ffffff)
+
+static inline u8 __bth_opcode(void *arg)
+{
+	struct rvt_bth *bth = arg;
+
+	return bth->opcode;
+}
+
+static inline void __bth_set_opcode(void *arg, u8 opcode)
+{
+	struct rvt_bth *bth = arg;
+
+	bth->opcode = opcode;
+}
+
+static inline u8 __bth_se(void *arg)
+{
+	struct rvt_bth *bth = arg;
+
+	return 0 != (BTH_SE_MASK & bth->flags);
+}
+
+static inline void __bth_set_se(void *arg, int se)
+{
+	struct rvt_bth *bth = arg;
+
+	if (se)
+		bth->flags |= BTH_SE_MASK;
+	else
+		bth->flags &= ~BTH_SE_MASK;
+}
+
+static inline u8 __bth_mig(void *arg)
+{
+	struct rvt_bth *bth = arg;
+
+	return 0 != (BTH_MIG_MASK & bth->flags);
+}
+
+static inline void __bth_set_mig(void *arg, u8 mig)
+{
+	struct rvt_bth *bth = arg;
+
+	if (mig)
+		bth->flags |= BTH_MIG_MASK;
+	else
+		bth->flags &= ~BTH_MIG_MASK;
+}
+
+static inline u8 __bth_pad(void *arg)
+{
+	struct rvt_bth *bth = arg;
+
+	return (BTH_PAD_MASK & bth->flags) >> 4;
+}
+
+static inline void __bth_set_pad(void *arg, u8 pad)
+{
+	struct rvt_bth *bth = arg;
+
+	bth->flags = (BTH_PAD_MASK & (pad << 4)) |
+			(~BTH_PAD_MASK & bth->flags);
+}
+
+static inline u8 __bth_tver(void *arg)
+{
+	struct rvt_bth *bth = arg;
+
+	return BTH_TVER_MASK & bth->flags;
+}
+
+static inline void __bth_set_tver(void *arg, u8 tver)
+{
+	struct rvt_bth *bth = arg;
+
+	bth->flags = (BTH_TVER_MASK & tver) |
+			(~BTH_TVER_MASK & bth->flags);
+}
+
+static inline u16 __bth_pkey(void *arg)
+{
+	struct rvt_bth *bth = arg;
+
+	return be16_to_cpu(bth->pkey);
+}
+
+static inline void __bth_set_pkey(void *arg, u16 pkey)
+{
+	struct rvt_bth *bth = arg;
+
+	bth->pkey = cpu_to_be16(pkey);
+}
+
+static inline u32 __bth_qpn(void *arg)
+{
+	struct rvt_bth *bth = arg;
+
+	return BTH_QPN_MASK & be32_to_cpu(bth->qpn);
+}
+
+static inline void __bth_set_qpn(void *arg, u32 qpn)
+{
+	struct rvt_bth *bth = arg;
+	u32 resvqpn = be32_to_cpu(bth->qpn);
+
+	bth->qpn = cpu_to_be32((BTH_QPN_MASK & qpn) |
+			       (~BTH_QPN_MASK & resvqpn));
+}
+
+static inline int __bth_fecn(void *arg)
+{
+	struct rvt_bth *bth = arg;
+
+	return 0 != (cpu_to_be32(BTH_FECN_MASK) & bth->qpn);
+}
+
+static inline void __bth_set_fecn(void *arg, int fecn)
+{
+	struct rvt_bth *bth = arg;
+
+	if (fecn)
+		bth->qpn |= cpu_to_be32(BTH_FECN_MASK);
+	else
+		bth->qpn &= ~cpu_to_be32(BTH_FECN_MASK);
+}
+
+static inline int __bth_becn(void *arg)
+{
+	struct rvt_bth *bth = arg;
+
+	return 0 != (cpu_to_be32(BTH_BECN_MASK) & bth->qpn);
+}
+
+static inline void __bth_set_becn(void *arg, int becn)
+{
+	struct rvt_bth *bth = arg;
+
+	if (becn)
+		bth->qpn |= cpu_to_be32(BTH_BECN_MASK);
+	else
+		bth->qpn &= ~cpu_to_be32(BTH_BECN_MASK);
+}
+
+static inline u8 __bth_resv6a(void *arg)
+{
+	struct rvt_bth *bth = arg;
+
+	return (BTH_RESV6A_MASK & be32_to_cpu(bth->qpn)) >> 24;
+}
+
+static inline void __bth_set_resv6a(void *arg)
+{
+	struct rvt_bth *bth = arg;
+
+	bth->qpn = cpu_to_be32(~BTH_RESV6A_MASK);
+}
+
+static inline int __bth_ack(void *arg)
+{
+	struct rvt_bth *bth = arg;
+
+	return 0 != (cpu_to_be32(BTH_ACK_MASK) & bth->apsn);
+}
+
+static inline void __bth_set_ack(void *arg, int ack)
+{
+	struct rvt_bth *bth = arg;
+
+	if (ack)
+		bth->apsn |= cpu_to_be32(BTH_ACK_MASK);
+	else
+		bth->apsn &= ~cpu_to_be32(BTH_ACK_MASK);
+}
+
+static inline void __bth_set_resv7(void *arg)
+{
+	struct rvt_bth *bth = arg;
+
+	bth->apsn &= ~cpu_to_be32(BTH_RESV7_MASK);
+}
+
+static inline u32 __bth_psn(void *arg)
+{
+	struct rvt_bth *bth = arg;
+
+	return BTH_PSN_MASK & be32_to_cpu(bth->apsn);
+}
+
+static inline void __bth_set_psn(void *arg, u32 psn)
+{
+	struct rvt_bth *bth = arg;
+	u32 apsn = be32_to_cpu(bth->apsn);
+
+	bth->apsn = cpu_to_be32((BTH_PSN_MASK & psn) |
+			(~BTH_PSN_MASK & apsn));
+}
+
+static inline u8 bth_opcode(struct rvt_pkt_info *pkt)
+{
+	return __bth_opcode(pkt->hdr + pkt->offset);
+}
+
+static inline void bth_set_opcode(struct rvt_pkt_info *pkt, u8 opcode)
+{
+	__bth_set_opcode(pkt->hdr + pkt->offset, opcode);
+}
+
+static inline u8 bth_se(struct rvt_pkt_info *pkt)
+{
+	return __bth_se(pkt->hdr + pkt->offset);
+}
+
+static inline void bth_set_se(struct rvt_pkt_info *pkt, int se)
+{
+	__bth_set_se(pkt->hdr + pkt->offset, se);
+}
+
+static inline u8 bth_mig(struct rvt_pkt_info *pkt)
+{
+	return __bth_mig(pkt->hdr + pkt->offset);
+}
+
+static inline void bth_set_mig(struct rvt_pkt_info *pkt, u8 mig)
+{
+	__bth_set_mig(pkt->hdr + pkt->offset, mig);
+}
+
+static inline u8 bth_pad(struct rvt_pkt_info *pkt)
+{
+	return __bth_pad(pkt->hdr + pkt->offset);
+}
+
+static inline void bth_set_pad(struct rvt_pkt_info *pkt, u8 pad)
+{
+	__bth_set_pad(pkt->hdr + pkt->offset, pad);
+}
+
+static inline u8 bth_tver(struct rvt_pkt_info *pkt)
+{
+	return __bth_tver(pkt->hdr + pkt->offset);
+}
+
+static inline void bth_set_tver(struct rvt_pkt_info *pkt, u8 tver)
+{
+	__bth_set_tver(pkt->hdr + pkt->offset, tver);
+}
+
+static inline u16 bth_pkey(struct rvt_pkt_info *pkt)
+{
+	return __bth_pkey(pkt->hdr + pkt->offset);
+}
+
+static inline void bth_set_pkey(struct rvt_pkt_info *pkt, u16 pkey)
+{
+	__bth_set_pkey(pkt->hdr + pkt->offset, pkey);
+}
+
+static inline u32 bth_qpn(struct rvt_pkt_info *pkt)
+{
+	return __bth_qpn(pkt->hdr + pkt->offset);
+}
+
+static inline void bth_set_qpn(struct rvt_pkt_info *pkt, u32 qpn)
+{
+	__bth_set_qpn(pkt->hdr + pkt->offset, qpn);
+}
+
+static inline int bth_fecn(struct rvt_pkt_info *pkt)
+{
+	return __bth_fecn(pkt->hdr + pkt->offset);
+}
+
+static inline void bth_set_fecn(struct rvt_pkt_info *pkt, int fecn)
+{
+	__bth_set_fecn(pkt->hdr + pkt->offset, fecn);
+}
+
+static inline int bth_becn(struct rvt_pkt_info *pkt)
+{
+	return __bth_becn(pkt->hdr + pkt->offset);
+}
+
+static inline void bth_set_becn(struct rvt_pkt_info *pkt, int becn)
+{
+	__bth_set_becn(pkt->hdr + pkt->offset, becn);
+}
+
+static inline u8 bth_resv6a(struct rvt_pkt_info *pkt)
+{
+	return __bth_resv6a(pkt->hdr + pkt->offset);
+}
+
+static inline void bth_set_resv6a(struct rvt_pkt_info *pkt)
+{
+	__bth_set_resv6a(pkt->hdr + pkt->offset);
+}
+
+static inline int bth_ack(struct rvt_pkt_info *pkt)
+{
+	return __bth_ack(pkt->hdr + pkt->offset);
+}
+
+static inline void bth_set_ack(struct rvt_pkt_info *pkt, int ack)
+{
+	__bth_set_ack(pkt->hdr + pkt->offset, ack);
+}
+
+static inline void bth_set_resv7(struct rvt_pkt_info *pkt)
+{
+	__bth_set_resv7(pkt->hdr + pkt->offset);
+}
+
+static inline u32 bth_psn(struct rvt_pkt_info *pkt)
+{
+	return __bth_psn(pkt->hdr + pkt->offset);
+}
+
+static inline void bth_set_psn(struct rvt_pkt_info *pkt, u32 psn)
+{
+	__bth_set_psn(pkt->hdr + pkt->offset, psn);
+}
+
+static inline void bth_init(struct rvt_pkt_info *pkt, u8 opcode, int se,
+			    int mig, int pad, u16 pkey, u32 qpn, int ack_req,
+			    u32 psn)
+{
+	struct rvt_bth *bth = (struct rvt_bth *)(pkt->hdr + pkt->offset);
+
+	bth->opcode = opcode;
+	bth->flags = (pad << 4) & BTH_PAD_MASK;
+	if (se)
+		bth->flags |= BTH_SE_MASK;
+	if (mig)
+		bth->flags |= BTH_MIG_MASK;
+	bth->pkey = cpu_to_be16(pkey);
+	bth->qpn = cpu_to_be32(qpn & BTH_QPN_MASK);
+	psn &= BTH_PSN_MASK;
+	if (ack_req)
+		psn |= BTH_ACK_MASK;
+	bth->apsn = cpu_to_be32(psn);
+}
+
+/******************************************************************************
+ * Reliable Datagram Extended Transport Header
+ ******************************************************************************/
+struct rvt_rdeth {
+	__be32			een;
+};
+
+#define RDETH_EEN_MASK		(0x00ffffff)
+
+static inline u8 __rdeth_een(void *arg)
+{
+	struct rvt_rdeth *rdeth = arg;
+
+	return RDETH_EEN_MASK & be32_to_cpu(rdeth->een);
+}
+
+static inline void __rdeth_set_een(void *arg, u32 een)
+{
+	struct rvt_rdeth *rdeth = arg;
+
+	rdeth->een = cpu_to_be32(RDETH_EEN_MASK & een);
+}
+
+static inline u8 rdeth_een(struct rvt_pkt_info *pkt)
+{
+	return __rdeth_een(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_RDETH]);
+}
+
+static inline void rdeth_set_een(struct rvt_pkt_info *pkt, u32 een)
+{
+	__rdeth_set_een(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_RDETH], een);
+}
+
+/******************************************************************************
+ * Datagram Extended Transport Header
+ ******************************************************************************/
+struct rvt_deth {
+	__be32			qkey;
+	__be32			sqp;
+};
+
+#define GSI_QKEY		(0x80010000)
+#define DETH_SQP_MASK		(0x00ffffff)
+
+static inline u32 __deth_qkey(void *arg)
+{
+	struct rvt_deth *deth = arg;
+
+	return be32_to_cpu(deth->qkey);
+}
+
+static inline void __deth_set_qkey(void *arg, u32 qkey)
+{
+	struct rvt_deth *deth = arg;
+
+	deth->qkey = cpu_to_be32(qkey);
+}
+
+static inline u32 __deth_sqp(void *arg)
+{
+	struct rvt_deth *deth = arg;
+
+	return DETH_SQP_MASK & be32_to_cpu(deth->sqp);
+}
+
+static inline void __deth_set_sqp(void *arg, u32 sqp)
+{
+	struct rvt_deth *deth = arg;
+
+	deth->sqp = cpu_to_be32(DETH_SQP_MASK & sqp);
+}
+
+static inline u32 deth_qkey(struct rvt_pkt_info *pkt)
+{
+	return __deth_qkey(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_DETH]);
+}
+
+static inline void deth_set_qkey(struct rvt_pkt_info *pkt, u32 qkey)
+{
+	__deth_set_qkey(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_DETH], qkey);
+}
+
+static inline u32 deth_sqp(struct rvt_pkt_info *pkt)
+{
+	return __deth_sqp(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_DETH]);
+}
+
+static inline void deth_set_sqp(struct rvt_pkt_info *pkt, u32 sqp)
+{
+	__deth_set_sqp(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_DETH], sqp);
+}
+
+/******************************************************************************
+ * RDMA Extended Transport Header
+ ******************************************************************************/
+struct rvt_reth {
+	__be64			va;
+	__be32			rkey;
+	__be32			len;
+};
+
+static inline u64 __reth_va(void *arg)
+{
+	struct rvt_reth *reth = arg;
+
+	return be64_to_cpu(reth->va);
+}
+
+static inline void __reth_set_va(void *arg, u64 va)
+{
+	struct rvt_reth *reth = arg;
+
+	reth->va = cpu_to_be64(va);
+}
+
+static inline u32 __reth_rkey(void *arg)
+{
+	struct rvt_reth *reth = arg;
+
+	return be32_to_cpu(reth->rkey);
+}
+
+static inline void __reth_set_rkey(void *arg, u32 rkey)
+{
+	struct rvt_reth *reth = arg;
+
+	reth->rkey = cpu_to_be32(rkey);
+}
+
+static inline u32 __reth_len(void *arg)
+{
+	struct rvt_reth *reth = arg;
+
+	return be32_to_cpu(reth->len);
+}
+
+static inline void __reth_set_len(void *arg, u32 len)
+{
+	struct rvt_reth *reth = arg;
+
+	reth->len = cpu_to_be32(len);
+}
+
+static inline u64 reth_va(struct rvt_pkt_info *pkt)
+{
+	return __reth_va(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_RETH]);
+}
+
+static inline void reth_set_va(struct rvt_pkt_info *pkt, u64 va)
+{
+	__reth_set_va(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_RETH], va);
+}
+
+static inline u32 reth_rkey(struct rvt_pkt_info *pkt)
+{
+	return __reth_rkey(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_RETH]);
+}
+
+static inline void reth_set_rkey(struct rvt_pkt_info *pkt, u32 rkey)
+{
+	__reth_set_rkey(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_RETH], rkey);
+}
+
+static inline u32 reth_len(struct rvt_pkt_info *pkt)
+{
+	return __reth_len(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_RETH]);
+}
+
+static inline void reth_set_len(struct rvt_pkt_info *pkt, u32 len)
+{
+	__reth_set_len(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_RETH], len);
+}
+
+/******************************************************************************
+ * Atomic Extended Transport Header
+ ******************************************************************************/
+struct rvt_atmeth {
+	__be64			va;
+	__be32			rkey;
+	__be64			swap_add;
+	__be64			comp;
+} __attribute__((__packed__));
+
+static inline u64 __atmeth_va(void *arg)
+{
+	struct rvt_atmeth *atmeth = arg;
+
+	return be64_to_cpu(atmeth->va);
+}
+
+static inline void __atmeth_set_va(void *arg, u64 va)
+{
+	struct rvt_atmeth *atmeth = arg;
+
+	atmeth->va = cpu_to_be64(va);
+}
+
+static inline u32 __atmeth_rkey(void *arg)
+{
+	struct rvt_atmeth *atmeth = arg;
+
+	return be32_to_cpu(atmeth->rkey);
+}
+
+static inline void __atmeth_set_rkey(void *arg, u32 rkey)
+{
+	struct rvt_atmeth *atmeth = arg;
+
+	atmeth->rkey = cpu_to_be32(rkey);
+}
+
+static inline u64 __atmeth_swap_add(void *arg)
+{
+	struct rvt_atmeth *atmeth = arg;
+
+	return be64_to_cpu(atmeth->swap_add);
+}
+
+static inline void __atmeth_set_swap_add(void *arg, u64 swap_add)
+{
+	struct rvt_atmeth *atmeth = arg;
+
+	atmeth->swap_add = cpu_to_be64(swap_add);
+}
+
+static inline u64 __atmeth_comp(void *arg)
+{
+	struct rvt_atmeth *atmeth = arg;
+
+	return be64_to_cpu(atmeth->comp);
+}
+
+static inline void __atmeth_set_comp(void *arg, u64 comp)
+{
+	struct rvt_atmeth *atmeth = arg;
+
+	atmeth->comp = cpu_to_be64(comp);
+}
+
+static inline u64 atmeth_va(struct rvt_pkt_info *pkt)
+{
+	return __atmeth_va(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_ATMETH]);
+}
+
+static inline void atmeth_set_va(struct rvt_pkt_info *pkt, u64 va)
+{
+	__atmeth_set_va(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_ATMETH], va);
+}
+
+static inline u32 atmeth_rkey(struct rvt_pkt_info *pkt)
+{
+	return __atmeth_rkey(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_ATMETH]);
+}
+
+static inline void atmeth_set_rkey(struct rvt_pkt_info *pkt, u32 rkey)
+{
+	__atmeth_set_rkey(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_ATMETH], rkey);
+}
+
+static inline u64 atmeth_swap_add(struct rvt_pkt_info *pkt)
+{
+	return __atmeth_swap_add(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_ATMETH]);
+}
+
+static inline void atmeth_set_swap_add(struct rvt_pkt_info *pkt, u64 swap_add)
+{
+	__atmeth_set_swap_add(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_ATMETH], swap_add);
+}
+
+static inline u64 atmeth_comp(struct rvt_pkt_info *pkt)
+{
+	return __atmeth_comp(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_ATMETH]);
+}
+
+static inline void atmeth_set_comp(struct rvt_pkt_info *pkt, u64 comp)
+{
+	__atmeth_set_comp(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_ATMETH], comp);
+}
+
+/******************************************************************************
+ * Ack Extended Transport Header
+ ******************************************************************************/
+struct rvt_aeth {
+	__be32			smsn;
+};
+
+#define AETH_SYN_MASK		(0xff000000)
+#define AETH_MSN_MASK		(0x00ffffff)
+
+enum aeth_syndrome {
+	AETH_TYPE_MASK		= 0xe0,
+	AETH_ACK		= 0x00,
+	AETH_RNR_NAK		= 0x20,
+	AETH_RSVD		= 0x40,
+	AETH_NAK		= 0x60,
+	AETH_ACK_UNLIMITED	= 0x1f,
+	AETH_NAK_PSN_SEQ_ERROR	= 0x60,
+	AETH_NAK_INVALID_REQ	= 0x61,
+	AETH_NAK_REM_ACC_ERR	= 0x62,
+	AETH_NAK_REM_OP_ERR	= 0x63,
+	AETH_NAK_INV_RD_REQ	= 0x64,
+};
+
+static inline u8 __aeth_syn(void *arg)
+{
+	struct rvt_aeth *aeth = arg;
+
+	return (AETH_SYN_MASK & be32_to_cpu(aeth->smsn)) >> 24;
+}
+
+static inline void __aeth_set_syn(void *arg, u8 syn)
+{
+	struct rvt_aeth *aeth = arg;
+	u32 smsn = be32_to_cpu(aeth->smsn);
+
+	aeth->smsn = cpu_to_be32((AETH_SYN_MASK & (syn << 24)) |
+			 (~AETH_SYN_MASK & smsn));
+}
+
+static inline u32 __aeth_msn(void *arg)
+{
+	struct rvt_aeth *aeth = arg;
+
+	return AETH_MSN_MASK & be32_to_cpu(aeth->smsn);
+}
+
+static inline void __aeth_set_msn(void *arg, u32 msn)
+{
+	struct rvt_aeth *aeth = arg;
+	u32 smsn = be32_to_cpu(aeth->smsn);
+
+	aeth->smsn = cpu_to_be32((AETH_MSN_MASK & msn) |
+			 (~AETH_MSN_MASK & smsn));
+}
+
+static inline u8 aeth_syn(struct rvt_pkt_info *pkt)
+{
+	return __aeth_syn(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_AETH]);
+}
+
+static inline void aeth_set_syn(struct rvt_pkt_info *pkt, u8 syn)
+{
+	__aeth_set_syn(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_AETH], syn);
+}
+
+static inline u32 aeth_msn(struct rvt_pkt_info *pkt)
+{
+	return __aeth_msn(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_AETH]);
+}
+
+static inline void aeth_set_msn(struct rvt_pkt_info *pkt, u32 msn)
+{
+	__aeth_set_msn(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_AETH], msn);
+}
+
+/******************************************************************************
+ * Atomic Ack Extended Transport Header
+ ******************************************************************************/
+struct rvt_atmack {
+	__be64			orig;
+};
+
+static inline u64 __atmack_orig(void *arg)
+{
+	struct rvt_atmack *atmack = arg;
+
+	return be64_to_cpu(atmack->orig);
+}
+
+static inline void __atmack_set_orig(void *arg, u64 orig)
+{
+	struct rvt_atmack *atmack = arg;
+
+	atmack->orig = cpu_to_be64(orig);
+}
+
+static inline u64 atmack_orig(struct rvt_pkt_info *pkt)
+{
+	return __atmack_orig(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_ATMACK]);
+}
+
+static inline void atmack_set_orig(struct rvt_pkt_info *pkt, u64 orig)
+{
+	__atmack_set_orig(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_ATMACK], orig);
+}
+
+/******************************************************************************
+ * Immediate Extended Transport Header
+ ******************************************************************************/
+struct rvt_immdt {
+	__be32			imm;
+};
+
+static inline __be32 __immdt_imm(void *arg)
+{
+	struct rvt_immdt *immdt = arg;
+
+	return immdt->imm;
+}
+
+static inline void __immdt_set_imm(void *arg, __be32 imm)
+{
+	struct rvt_immdt *immdt = arg;
+
+	immdt->imm = imm;
+}
+
+static inline __be32 immdt_imm(struct rvt_pkt_info *pkt)
+{
+	return __immdt_imm(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_IMMDT]);
+}
+
+static inline void immdt_set_imm(struct rvt_pkt_info *pkt, __be32 imm)
+{
+	__immdt_set_imm(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_IMMDT], imm);
+}
+
+/******************************************************************************
+ * Invalidate Extended Transport Header
+ ******************************************************************************/
+struct rvt_ieth {
+	__be32			rkey;
+};
+
+static inline u32 __ieth_rkey(void *arg)
+{
+	struct rvt_ieth *ieth = arg;
+
+	return be32_to_cpu(ieth->rkey);
+}
+
+static inline void __ieth_set_rkey(void *arg, u32 rkey)
+{
+	struct rvt_ieth *ieth = arg;
+
+	ieth->rkey = cpu_to_be32(rkey);
+}
+
+static inline u32 ieth_rkey(struct rvt_pkt_info *pkt)
+{
+	return __ieth_rkey(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_IETH]);
+}
+
+static inline void ieth_set_rkey(struct rvt_pkt_info *pkt, u32 rkey)
+{
+	__ieth_set_rkey(pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_IETH], rkey);
+}
+
+enum rvt_hdr_length {
+	RVT_BTH_BYTES		= sizeof(struct rvt_bth),
+	RVT_DETH_BYTES		= sizeof(struct rvt_deth),
+	RVT_IMMDT_BYTES		= sizeof(struct rvt_immdt),
+	RVT_RETH_BYTES		= sizeof(struct rvt_reth),
+	RVT_AETH_BYTES		= sizeof(struct rvt_aeth),
+	RVT_ATMACK_BYTES	= sizeof(struct rvt_atmack),
+	RVT_ATMETH_BYTES	= sizeof(struct rvt_atmeth),
+	RVT_IETH_BYTES		= sizeof(struct rvt_ieth),
+	RVT_RDETH_BYTES		= sizeof(struct rvt_rdeth),
+};
+
+static inline size_t header_size(struct rvt_pkt_info *pkt)
+{
+	return pkt->offset + rvt_opcode[pkt->opcode].length;
+}
+
+static inline void *payload_addr(struct rvt_pkt_info *pkt)
+{
+	return pkt->hdr + pkt->offset
+		+ rvt_opcode[pkt->opcode].offset[RVT_PAYLOAD];
+}
+
+static inline size_t payload_size(struct rvt_pkt_info *pkt)
+{
+	return pkt->paylen - rvt_opcode[pkt->opcode].offset[RVT_PAYLOAD]
+		- bth_pad(pkt) - RVT_ICRC_SIZE;
+}
+
+#endif /* RVT_HDR_H */
diff --git a/drivers/infiniband/sw/rdmavt/rvt_icrc.c b/drivers/infiniband/sw/rdmavt/rvt_icrc.c
new file mode 100644
index 0000000..a64ce43
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_icrc.c
@@ -0,0 +1,103 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#include <linux/skbuff.h>
+#include <linux/crc32.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <uapi/linux/ip.h>
+#include <uapi/linux/ipv6.h>
+#include <uapi/linux/udp.h>
+
+#include "rvt_hdr.h"
+
+/* Compute a partial ICRC for all the IB transport headers. */
+u32 rvt_icrc_hdr(struct rvt_pkt_info *pkt, struct sk_buff *skb)
+{
+	unsigned int bth_offset = 0;
+	struct iphdr *ip4h = NULL;
+	struct ipv6hdr *ip6h = NULL;
+	struct udphdr *udph;
+	struct rvt_bth *bth;
+	int crc;
+	int length;
+	int hdr_size = sizeof(struct udphdr) +
+		(skb->protocol == htons(ETH_P_IP) ?
+		sizeof(struct iphdr) : sizeof(struct ipv6hdr));
+	/* pseudo header buffer size is calculate using ipv6 header size since
+	 * it is bigger than ipv4
+	 */
+	u8 pshdr[sizeof(struct udphdr) +
+		sizeof(struct ipv6hdr) +
+		RVT_BTH_BYTES];
+
+	/* This seed is the result of computing a CRC with a seed of
+	 * 0xfffffff and 8 bytes of 0xff representing a masked LRH.
+	 */
+	crc = 0xdebb20e3;
+
+	if (skb->protocol == htons(ETH_P_IP)) { /* IPv4 */
+		memcpy(pshdr, ip_hdr(skb), hdr_size);
+		ip4h = (struct iphdr *)pshdr;
+		udph = (struct udphdr *)(ip4h + 1);
+
+		ip4h->ttl = 0xff;
+		ip4h->check = CSUM_MANGLED_0;
+		ip4h->tos = 0xff;
+	} else {				/* IPv6 */
+		memcpy(pshdr, ipv6_hdr(skb), hdr_size);
+		ip6h = (struct ipv6hdr *)pshdr;
+		udph = (struct udphdr *)(ip6h + 1);
+
+		memset(ip6h->flow_lbl, 0xff, sizeof(ip6h->flow_lbl));
+		ip6h->priority = 0xf;
+		ip6h->hop_limit = 0xff;
+	}
+	udph->check = CSUM_MANGLED_0;
+
+	bth_offset += hdr_size;
+
+	memcpy(&pshdr[bth_offset], pkt->hdr, RVT_BTH_BYTES);
+	bth = (struct rvt_bth *)&pshdr[bth_offset];
+
+	/* exclude bth.resv8a */
+	bth->qpn |= cpu_to_be32(~BTH_QPN_MASK);
+
+	length = hdr_size + RVT_BTH_BYTES;
+	crc = crc32_le(crc, pshdr, length);
+
+	/* And finish to compute the CRC on the remainder of the headers. */
+	crc = crc32_le(crc, pkt->hdr + RVT_BTH_BYTES,
+		       rvt_opcode[pkt->opcode].length - RVT_BTH_BYTES);
+	return crc;
+}
diff --git a/drivers/infiniband/sw/rdmavt/rvt_loc.h b/drivers/infiniband/sw/rdmavt/rvt_loc.h
new file mode 100644
index 0000000..e06a7e9
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_loc.h
@@ -0,0 +1,310 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#ifndef RVT_LOC_H
+#define RVT_LOC_H
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_rvt.h>
+#include <uapi/rdma/ib_user_rvt.h>
+
+
+#include "rvt_task.h"
+#include "rvt_verbs.h"
+#include "rvt_param.h"
+#include "rvt_hdr.h"
+#include "rvt_opcode.h"
+
+
+/* rvt_av.c */
+int rvt_av_chk_attr(struct rvt_dev *rvt, struct ib_ah_attr *attr);
+
+int rvt_av_from_attr(struct rvt_dev *rvt, u8 port_num,
+		     struct rvt_av *av, struct ib_ah_attr *attr);
+
+int rvt_av_to_attr(struct rvt_dev *rvt, struct rvt_av *av,
+		   struct ib_ah_attr *attr);
+
+int rvt_av_fill_ip_info(struct rvt_dev *rvt,
+			struct rvt_av *av,
+			struct ib_ah_attr *attr,
+			struct ib_gid_attr *sgid_attr,
+			union ib_gid *sgid);
+
+/* rvt_cq.c */
+int rvt_cq_chk_attr(struct rvt_dev *rvt, struct rvt_cq *cq,
+		    int cqe, int comp_vector, struct ib_udata *udata);
+
+int rvt_cq_from_init(struct rvt_dev *rvt, struct rvt_cq *cq, int cqe,
+		     int comp_vector, struct ib_ucontext *context,
+		     struct ib_udata *udata);
+
+int rvt_cq_resize_queue(struct rvt_cq *cq, int new_cqe, struct ib_udata *udata);
+
+int rvt_cq_post(struct rvt_cq *cq, struct rvt_cqe *cqe, int solicited);
+
+void rvt_cq_cleanup(void *arg);
+
+/* rvt_mcast.c */
+int rvt_mcast_get_grp(struct rvt_dev *rvt, union ib_gid *mgid,
+		      struct rvt_mc_grp **grp_p);
+
+int rvt_mcast_add_grp_elem(struct rvt_dev *rvt, struct rvt_qp *qp,
+			   struct rvt_mc_grp *grp);
+
+int rvt_mcast_drop_grp_elem(struct rvt_dev *rvt, struct rvt_qp *qp,
+			    union ib_gid *mgid);
+
+void rvt_drop_all_mcast_groups(struct rvt_qp *qp);
+
+void rvt_mc_cleanup(void *arg);
+
+/* rvt_mmap.c */
+struct rvt_mmap_info {
+	struct list_head	pending_mmaps;
+	struct ib_ucontext	*context;
+	struct kref		ref;
+	void			*obj;
+
+	struct mminfo info;
+};
+
+void rvt_mmap_release(struct kref *ref);
+
+struct rvt_mmap_info *rvt_create_mmap_info(struct rvt_dev *dev,
+					   u32 size,
+					   struct ib_ucontext *context,
+					   void *obj);
+
+int rvt_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
+
+/* rvt_mr.c */
+enum copy_direction {
+	to_mem_obj,
+	from_mem_obj,
+};
+
+int rvt_mem_init_dma(struct rvt_dev *rvt, struct rvt_pd *pd,
+		     int access, struct rvt_mem *mem);
+
+int rvt_mem_init_phys(struct rvt_dev *rvt, struct rvt_pd *pd,
+		      int access, u64 iova, struct rvt_phys_buf *buf,
+		      int num_buf, struct rvt_mem *mem);
+
+int rvt_mem_init_user(struct rvt_dev *rvt, struct rvt_pd *pd, u64 start,
+		      u64 length, u64 iova, int access, struct ib_udata *udata,
+		      struct rvt_mem *mr);
+
+int rvt_mem_init_fast(struct rvt_dev *rvt, struct rvt_pd *pd,
+		      int max_pages, struct rvt_mem *mem);
+
+int rvt_mem_init_mw(struct rvt_dev *rvt, struct rvt_pd *pd,
+		    struct rvt_mem *mw);
+
+int rvt_mem_init_fmr(struct rvt_dev *rvt, struct rvt_pd *pd, int access,
+		     struct ib_fmr_attr *attr, struct rvt_mem *fmr);
+
+int rvt_mem_copy(struct rvt_mem *mem, u64 iova, void *addr,
+		 int length, enum copy_direction dir, u32 *crcp);
+
+int copy_data(struct rvt_dev *rvt, struct rvt_pd *pd, int access,
+	      struct rvt_dma_info *dma, void *addr, int length,
+	      enum copy_direction dir, u32 *crcp);
+
+void *iova_to_vaddr(struct rvt_mem *mem, u64 iova, int length);
+
+enum lookup_type {
+	lookup_local,
+	lookup_remote,
+};
+
+struct rvt_mem *lookup_mem(struct rvt_pd *pd, int access, u32 key,
+			   enum lookup_type type);
+
+int mem_check_range(struct rvt_mem *mem, u64 iova, size_t length);
+
+int rvt_mem_map_pages(struct rvt_dev *rvt, struct rvt_mem *mem,
+		      u64 *page, int num_pages, u64 iova);
+
+void rvt_mem_cleanup(void *arg);
+
+int advance_dma_data(struct rvt_dma_info *dma, unsigned int length);
+
+/* rvt_qp.c */
+int rvt_qp_chk_init(struct rvt_dev *rvt, struct ib_qp_init_attr *init);
+
+int rvt_qp_from_init(struct rvt_dev *rvt, struct rvt_qp *qp, struct rvt_pd *pd,
+		     struct ib_qp_init_attr *init, struct ib_udata *udata,
+		     struct ib_pd *ibpd);
+
+int rvt_qp_to_init(struct rvt_qp *qp, struct ib_qp_init_attr *init);
+
+int rvt_qp_chk_attr(struct rvt_dev *rvt, struct rvt_qp *qp,
+		    struct ib_qp_attr *attr, int mask);
+
+int rvt_qp_from_attr(struct rvt_qp *qp, struct ib_qp_attr *attr,
+		     int mask, struct ib_udata *udata);
+
+int rvt_qp_to_attr(struct rvt_qp *qp, struct ib_qp_attr *attr, int mask);
+
+void rvt_qp_error(struct rvt_qp *qp);
+
+void rvt_qp_destroy(struct rvt_qp *qp);
+
+void rvt_qp_cleanup(void *arg);
+
+static inline int qp_num(struct rvt_qp *qp)
+{
+	return qp->ibqp.qp_num;
+}
+
+static inline enum ib_qp_type qp_type(struct rvt_qp *qp)
+{
+	return qp->ibqp.qp_type;
+}
+
+static struct rvt_av *get_av(struct rvt_pkt_info *pkt)
+{
+	if (qp_type(pkt->qp) == IB_QPT_RC || qp_type(pkt->qp) == IB_QPT_UC)
+		return &pkt->qp->pri_av;
+
+	return &pkt->wqe->av;
+}
+
+static inline enum ib_qp_state qp_state(struct rvt_qp *qp)
+{
+	return qp->attr.qp_state;
+}
+
+static inline int qp_mtu(struct rvt_qp *qp)
+{
+	if (qp->ibqp.qp_type == IB_QPT_RC || qp->ibqp.qp_type == IB_QPT_UC)
+		return qp->attr.path_mtu;
+	else
+		return RVT_PORT_MAX_MTU;
+}
+
+static inline int rcv_wqe_size(int max_sge)
+{
+	return sizeof(struct rvt_recv_wqe) +
+		max_sge * sizeof(struct ib_sge);
+}
+
+void free_rd_atomic_resource(struct rvt_qp *qp, struct resp_res *res);
+
+static inline void rvt_advance_resp_resource(struct rvt_qp *qp)
+{
+	qp->resp.res_head++;
+	if (unlikely(qp->resp.res_head == qp->attr.max_rd_atomic))
+		qp->resp.res_head = 0;
+}
+
+void retransmit_timer(unsigned long data);
+void rnr_nak_timer(unsigned long data);
+
+void dump_qp(struct rvt_qp *qp);
+
+/* rvt_srq.c */
+#define IB_SRQ_INIT_MASK (~IB_SRQ_LIMIT)
+
+int rvt_srq_chk_attr(struct rvt_dev *rvt, struct rvt_srq *srq,
+		     struct ib_srq_attr *attr, enum ib_srq_attr_mask mask);
+
+int rvt_srq_from_init(struct rvt_dev *rvt, struct rvt_srq *srq,
+		      struct ib_srq_init_attr *init,
+		      struct ib_ucontext *context, struct ib_udata *udata);
+
+int rvt_srq_from_attr(struct rvt_dev *rvt, struct rvt_srq *srq,
+		      struct ib_srq_attr *attr, enum ib_srq_attr_mask mask,
+		      struct ib_udata *udata);
+
+extern struct ib_dma_mapping_ops rvt_dma_mapping_ops;
+
+void rvt_release(struct kref *kref);
+
+int rvt_completer(void *arg);
+int rvt_requester(void *arg);
+int rvt_responder(void *arg);
+
+u32 rvt_icrc_hdr(struct rvt_pkt_info *pkt, struct sk_buff *skb);
+
+void rvt_resp_queue_pkt(struct rvt_dev *rvt,
+			struct rvt_qp *qp, struct sk_buff *skb);
+
+void rvt_comp_queue_pkt(struct rvt_dev *rvt,
+			struct rvt_qp *qp, struct sk_buff *skb);
+
+static inline unsigned wr_opcode_mask(int opcode, struct rvt_qp *qp)
+{
+	return rvt_wr_opcode_info[opcode].mask[qp->ibqp.qp_type];
+}
+
+static inline int rvt_xmit_packet(struct rvt_dev *rvt, struct rvt_qp *qp,
+				  struct rvt_pkt_info *pkt, struct sk_buff *skb)
+{
+	int err;
+	int is_request = pkt->mask & RVT_REQ_MASK;
+
+	if ((is_request && (qp->req.state != QP_STATE_READY)) ||
+	    (!is_request && (qp->resp.state != QP_STATE_READY))) {
+		pr_info("Packet dropped. QP is not in ready state\n");
+		goto drop;
+	}
+
+	if (pkt->mask & RVT_LOOPBACK_MASK)
+		err = rvt->ifc_ops->loopback(skb);
+	else
+		err = rvt->ifc_ops->send(rvt, get_av(pkt), skb, qp->flow);
+
+	if (err) {
+		rvt->xmit_errors++;
+		return err;
+	}
+
+	atomic_inc(&qp->skb_out);
+
+	if ((qp_type(qp) != IB_QPT_RC) &&
+	    (pkt->mask & RVT_END_MASK)) {
+		pkt->wqe->state = wqe_state_done;
+		rvt_run_task(&qp->comp.task, 1);
+	}
+
+	goto done;
+
+drop:
+	kfree_skb(skb);
+	err = 0;
+done:
+	return err;
+}
+
+#endif /* RVT_LOC_H */
diff --git a/drivers/infiniband/sw/rdmavt/rvt_mcast.c b/drivers/infiniband/sw/rdmavt/rvt_mcast.c
new file mode 100644
index 0000000..b8d70af
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_mcast.c
@@ -0,0 +1,189 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *	   Redistribution and use in source and binary forms, with or
+ *	   without modification, are permitted provided that the following
+ *	   conditions are met:
+ *
+ *		- Redistributions of source code must retain the above
+ *		  copyright notice, this list of conditions and the following
+ *		  disclaimer.
+ *
+ *		- Redistributions in binary form must reproduce the above
+ *		  copyright notice, this list of conditions and the following
+ *		  disclaimer in the documentation and/or other materials
+ *		  provided with the distribution.
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
+#include "rvt_loc.h"
+
+int rvt_mcast_get_grp(struct rvt_dev *rvt, union ib_gid *mgid,
+		      struct rvt_mc_grp **grp_p)
+{
+	int err;
+	struct rvt_mc_grp *grp;
+
+	if (rvt->attr.max_mcast_qp_attach == 0) {
+		err = -EINVAL;
+		goto err1;
+	}
+
+	grp = rvt_pool_get_key(&rvt->mc_grp_pool, mgid);
+	if (grp)
+		goto done;
+
+	grp = rvt_alloc(&rvt->mc_grp_pool);
+	if (!grp) {
+		err = -ENOMEM;
+		goto err1;
+	}
+
+	INIT_LIST_HEAD(&grp->qp_list);
+	spin_lock_init(&grp->mcg_lock);
+	grp->rvt = rvt;
+
+	rvt_add_key(grp, mgid);
+
+	err = rvt->ifc_ops->mcast_add(rvt, mgid);
+	if (err)
+		goto err2;
+
+done:
+	*grp_p = grp;
+	return 0;
+
+err2:
+	rvt_drop_ref(grp);
+err1:
+	return err;
+}
+
+int rvt_mcast_add_grp_elem(struct rvt_dev *rvt, struct rvt_qp *qp,
+			   struct rvt_mc_grp *grp)
+{
+	int err;
+	struct rvt_mc_elem *elem;
+
+	/* check to see of the qp is already a member of the group */
+	spin_lock_bh(&qp->grp_lock);
+	spin_lock_bh(&grp->mcg_lock);
+	list_for_each_entry(elem, &grp->qp_list, qp_list) {
+		if (elem->qp == qp) {
+			err = 0;
+			goto out;
+		}
+	}
+
+	if (grp->num_qp >= rvt->attr.max_mcast_qp_attach) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	elem = rvt_alloc(&rvt->mc_elem_pool);
+	if (!elem) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	/* each qp holds a ref on the grp */
+	rvt_add_ref(grp);
+
+	grp->num_qp++;
+	elem->qp = qp;
+	elem->grp = grp;
+
+	list_add(&elem->qp_list, &grp->qp_list);
+	list_add(&elem->grp_list, &qp->grp_list);
+
+	err = 0;
+out:
+	spin_unlock_bh(&grp->mcg_lock);
+	spin_unlock_bh(&qp->grp_lock);
+	return err;
+}
+
+int rvt_mcast_drop_grp_elem(struct rvt_dev *rvt, struct rvt_qp *qp,
+			    union ib_gid *mgid)
+{
+	struct rvt_mc_grp *grp;
+	struct rvt_mc_elem *elem, *tmp;
+
+	grp = rvt_pool_get_key(&rvt->mc_grp_pool, mgid);
+	if (!grp)
+		goto err1;
+
+	spin_lock_bh(&qp->grp_lock);
+	spin_lock_bh(&grp->mcg_lock);
+
+	list_for_each_entry_safe(elem, tmp, &grp->qp_list, qp_list) {
+		if (elem->qp == qp) {
+			list_del(&elem->qp_list);
+			list_del(&elem->grp_list);
+			grp->num_qp--;
+
+			spin_unlock_bh(&grp->mcg_lock);
+			spin_unlock_bh(&qp->grp_lock);
+			rvt_drop_ref(elem);
+			rvt_drop_ref(grp);	/* ref held by QP */
+			rvt_drop_ref(grp);	/* ref from get_key */
+			return 0;
+		}
+	}
+
+	spin_unlock_bh(&grp->mcg_lock);
+	spin_unlock_bh(&qp->grp_lock);
+	rvt_drop_ref(grp);			/* ref from get_key */
+err1:
+	return -EINVAL;
+}
+
+void rvt_drop_all_mcast_groups(struct rvt_qp *qp)
+{
+	struct rvt_mc_grp *grp;
+	struct rvt_mc_elem *elem;
+
+	while (1) {
+		spin_lock_bh(&qp->grp_lock);
+		if (list_empty(&qp->grp_list)) {
+			spin_unlock_bh(&qp->grp_lock);
+			break;
+		}
+		elem = list_first_entry(&qp->grp_list, struct rvt_mc_elem,
+					grp_list);
+		list_del(&elem->grp_list);
+		spin_unlock_bh(&qp->grp_lock);
+
+		grp = elem->grp;
+		spin_lock_bh(&grp->mcg_lock);
+		list_del(&elem->qp_list);
+		grp->num_qp--;
+		spin_unlock_bh(&grp->mcg_lock);
+		rvt_drop_ref(grp);
+		rvt_drop_ref(elem);
+	}
+}
+
+void rvt_mc_cleanup(void *arg)
+{
+	struct rvt_mc_grp *grp = arg;
+	struct rvt_dev *rvt = grp->rvt;
+
+	rvt_drop_key(grp);
+	rvt->ifc_ops->mcast_delete(rvt, &grp->mgid);
+}
diff --git a/drivers/infiniband/sw/rdmavt/rvt_mmap.c b/drivers/infiniband/sw/rdmavt/rvt_mmap.c
new file mode 100644
index 0000000..aca2722
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_mmap.c
@@ -0,0 +1,172 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
+#include <linux/errno.h>
+#include <asm/pgtable.h>
+
+#include "rvt_loc.h"
+#include "rvt_queue.h"
+
+void rvt_mmap_release(struct kref *ref)
+{
+	struct rvt_mmap_info *ip = container_of(ref,
+					struct rvt_mmap_info, ref);
+	struct rvt_dev *rvt = to_rdev(ip->context->device);
+
+	spin_lock_bh(&rvt->pending_lock);
+
+	if (!list_empty(&ip->pending_mmaps))
+		list_del(&ip->pending_mmaps);
+
+	spin_unlock_bh(&rvt->pending_lock);
+
+	vfree(ip->obj);		/* buf */
+	kfree(ip);
+}
+
+/*
+ * open and close keep track of how many times the memory region is mapped,
+ * to avoid releasing it.
+ */
+static void rvt_vma_open(struct vm_area_struct *vma)
+{
+	struct rvt_mmap_info *ip = vma->vm_private_data;
+
+	kref_get(&ip->ref);
+}
+
+static void rvt_vma_close(struct vm_area_struct *vma)
+{
+	struct rvt_mmap_info *ip = vma->vm_private_data;
+
+	kref_put(&ip->ref, rvt_mmap_release);
+}
+
+static struct vm_operations_struct rvt_vm_ops = {
+	.open = rvt_vma_open,
+	.close = rvt_vma_close,
+};
+
+/**
+ * rvt_mmap - create a new mmap region
+ * @context: the IB user context of the process making the mmap() call
+ * @vma: the VMA to be initialized
+ * Return zero if the mmap is OK. Otherwise, return an errno.
+ */
+int rvt_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
+{
+	struct rvt_dev *rvt = to_rdev(context->device);
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long size = vma->vm_end - vma->vm_start;
+	struct rvt_mmap_info *ip, *pp;
+	int ret;
+
+	/*
+	 * Search the device's list of objects waiting for a mmap call.
+	 * Normally, this list is very short since a call to create a
+	 * CQ, QP, or SRQ is soon followed by a call to mmap().
+	 */
+	spin_lock_bh(&rvt->pending_lock);
+	list_for_each_entry_safe(ip, pp, &rvt->pending_mmaps, pending_mmaps) {
+		if (context != ip->context || (__u64)offset != ip->info.offset)
+			continue;
+
+		/* Don't allow a mmap larger than the object. */
+		if (size > ip->info.size) {
+			pr_err("mmap region is larger than the object!\n");
+			spin_unlock_bh(&rvt->pending_lock);
+			ret = -EINVAL;
+			goto done;
+		}
+
+		goto found_it;
+	}
+	pr_warn("unable to find pending mmap info\n");
+	spin_unlock_bh(&rvt->pending_lock);
+	ret = -EINVAL;
+	goto done;
+
+found_it:
+	list_del_init(&ip->pending_mmaps);
+	spin_unlock_bh(&rvt->pending_lock);
+
+	ret = remap_vmalloc_range(vma, ip->obj, 0);
+	if (ret) {
+		pr_err("rvt: err %d from remap_vmalloc_range\n", ret);
+		goto done;
+	}
+
+	vma->vm_ops = &rvt_vm_ops;
+	vma->vm_private_data = ip;
+	rvt_vma_open(vma);
+done:
+	return ret;
+}
+
+/*
+ * Allocate information for rvt_mmap
+ */
+struct rvt_mmap_info *rvt_create_mmap_info(struct rvt_dev *rvt,
+					   u32 size,
+					   struct ib_ucontext *context,
+					   void *obj)
+{
+	struct rvt_mmap_info *ip;
+
+	ip = kmalloc(sizeof(*ip), GFP_KERNEL);
+	if (!ip)
+		return NULL;
+
+	size = PAGE_ALIGN(size);
+
+	spin_lock_bh(&rvt->mmap_offset_lock);
+
+	if (rvt->mmap_offset == 0)
+		rvt->mmap_offset = PAGE_SIZE;
+
+	ip->info.offset = rvt->mmap_offset;
+	rvt->mmap_offset += size;
+
+	spin_unlock_bh(&rvt->mmap_offset_lock);
+
+	INIT_LIST_HEAD(&ip->pending_mmaps);
+	ip->info.size = size;
+	ip->context = context;
+	ip->obj = obj;
+	kref_init(&ip->ref);
+
+	return ip;
+}
diff --git a/drivers/infiniband/sw/rdmavt/rvt_mr.c b/drivers/infiniband/sw/rdmavt/rvt_mr.c
new file mode 100644
index 0000000..27b809d
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_mr.c
@@ -0,0 +1,765 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#include <linux/crc32.h>
+
+#include "rvt_loc.h"
+
+/*
+ * lfsr (linear feedback shift register) with period 255
+ */
+static u8 rvt_get_key(void)
+{
+	static unsigned key = 1;
+
+	key = key << 1;
+
+	key |= (0 != (key & 0x100)) ^ (0 != (key & 0x10))
+		^ (0 != (key & 0x80)) ^ (0 != (key & 0x40));
+
+	key &= 0xff;
+
+	return key;
+}
+
+int mem_check_range(struct rvt_mem *mem, u64 iova, size_t length)
+{
+	switch (mem->type) {
+	case RVT_MEM_TYPE_DMA:
+		return 0;
+
+	case RVT_MEM_TYPE_MR:
+	case RVT_MEM_TYPE_FMR:
+		return ((iova < mem->iova) ||
+			((iova + length) > (mem->iova + mem->length))) ?
+			-EFAULT : 0;
+
+	default:
+		return -EFAULT;
+	}
+}
+
+#define IB_ACCESS_REMOTE	(IB_ACCESS_REMOTE_READ		\
+				| IB_ACCESS_REMOTE_WRITE	\
+				| IB_ACCESS_REMOTE_ATOMIC)
+
+static void rvt_mem_init(int access, struct rvt_mem *mem)
+{
+	u32 lkey = mem->pelem.index << 8 | rvt_get_key();
+	u32 rkey = (access & IB_ACCESS_REMOTE) ? lkey : 0;
+
+	if (mem->pelem.pool->type == RVT_TYPE_MR) {
+		mem->ibmr.lkey		= lkey;
+		mem->ibmr.rkey		= rkey;
+	} else {
+		mem->ibfmr.lkey		= lkey;
+		mem->ibfmr.rkey		= rkey;
+	}
+
+	mem->pd			= NULL;
+	mem->umem		= NULL;
+	mem->lkey		= lkey;
+	mem->rkey		= rkey;
+	mem->state		= RVT_MEM_STATE_INVALID;
+	mem->type		= RVT_MEM_TYPE_NONE;
+	mem->va			= 0;
+	mem->iova		= 0;
+	mem->length		= 0;
+	mem->offset		= 0;
+	mem->access		= 0;
+	mem->page_shift		= 0;
+	mem->page_mask		= 0;
+	mem->map_shift		= ilog2(RVT_BUF_PER_MAP);
+	mem->map_mask		= 0;
+	mem->num_buf		= 0;
+	mem->max_buf		= 0;
+	mem->num_map		= 0;
+	mem->map		= NULL;
+}
+
+void rvt_mem_cleanup(void *arg)
+{
+	struct rvt_mem *mem = arg;
+	int i;
+
+	if (mem->umem)
+		ib_umem_release(mem->umem);
+
+	if (mem->map) {
+		for (i = 0; i < mem->num_map; i++)
+			kfree(mem->map[i]);
+
+		kfree(mem->map);
+	}
+}
+
+static int rvt_mem_alloc(struct rvt_dev *rvt, struct rvt_mem *mem, int num_buf)
+{
+	int i;
+	int num_map;
+	struct rvt_map **map = mem->map;
+
+	num_map = (num_buf + RVT_BUF_PER_MAP - 1) / RVT_BUF_PER_MAP;
+
+	mem->map = kmalloc_array(num_map, sizeof(*map), GFP_KERNEL);
+	if (!mem->map)
+		goto err1;
+
+	for (i = 0; i < num_map; i++) {
+		mem->map[i] = kmalloc(sizeof(**map), GFP_KERNEL);
+		if (!mem->map[i])
+			goto err2;
+	}
+
+	WARN_ON(!is_power_of_2(RVT_BUF_PER_MAP));
+
+	mem->map_shift	= ilog2(RVT_BUF_PER_MAP);
+	mem->map_mask	= RVT_BUF_PER_MAP - 1;
+
+	mem->num_buf = num_buf;
+	mem->num_map = num_map;
+	mem->max_buf = num_map * RVT_BUF_PER_MAP;
+
+	return 0;
+
+err2:
+	for (i--; i >= 0; i--)
+		kfree(mem->map[i]);
+
+	kfree(mem->map);
+err1:
+	return -ENOMEM;
+}
+
+int rvt_mem_init_dma(struct rvt_dev *rvt, struct rvt_pd *pd,
+		     int access, struct rvt_mem *mem)
+{
+	rvt_mem_init(access, mem);
+
+	mem->pd			= pd;
+	mem->access		= access;
+	mem->state		= RVT_MEM_STATE_VALID;
+	mem->type		= RVT_MEM_TYPE_DMA;
+
+	return 0;
+}
+
+int rvt_mem_init_phys(struct rvt_dev *rvt, struct rvt_pd *pd, int access,
+		      u64 iova, struct rvt_phys_buf *phys_buf, int num_buf,
+		      struct rvt_mem *mem)
+{
+	int i;
+	struct rvt_map **map;
+	struct rvt_phys_buf *buf;
+	size_t length;
+	int err;
+	size_t min_size = (size_t)(-1L);
+	size_t max_size = 0;
+	int n;
+
+	rvt_mem_init(access, mem);
+
+	err = rvt_mem_alloc(rvt, mem, num_buf);
+	if (err)
+		goto err1;
+
+	length			= 0;
+	map			= mem->map;
+	buf			= map[0]->buf;
+	n			= 0;
+
+	for (i = 0; i < num_buf; i++) {
+		length	+= phys_buf->size;
+		max_size = max_t(int, max_size, phys_buf->size);
+		min_size = min_t(int, min_size, phys_buf->size);
+		*buf++	= *phys_buf++;
+		n++;
+
+		if (n == RVT_BUF_PER_MAP) {
+			map++;
+			buf = map[0]->buf;
+			n = 0;
+		}
+	}
+
+	if (max_size == min_size && is_power_of_2(max_size)) {
+		mem->page_shift		= ilog2(max_size);
+		mem->page_mask		= max_size - 1;
+	}
+
+	mem->pd			= pd;
+	mem->access		= access;
+	mem->iova		= iova;
+	mem->va			= iova;
+	mem->length		= length;
+	mem->state		= RVT_MEM_STATE_VALID;
+	mem->type		= RVT_MEM_TYPE_MR;
+
+	return 0;
+
+err1:
+	return err;
+}
+
+int rvt_mem_init_user(struct rvt_dev *rvt, struct rvt_pd *pd, u64 start,
+		      u64 length, u64 iova, int access, struct ib_udata *udata,
+	struct rvt_mem *mem)
+{
+	int			entry;
+	struct rvt_map		**map;
+	struct rvt_phys_buf	*buf = NULL;
+	struct ib_umem		*umem;
+	struct scatterlist	*sg;
+	int			num_buf;
+	void			*vaddr;
+	int err;
+
+	umem = ib_umem_get(pd->ibpd.uobject->context, start, length, access, 0);
+	if (IS_ERR(umem)) {
+		pr_warn("err %d from rvt_umem_get\n",
+			(int)PTR_ERR(umem));
+		err = -EINVAL;
+		goto err1;
+	}
+
+	mem->umem = umem;
+	num_buf = umem->nmap;
+
+	rvt_mem_init(access, mem);
+
+	err = rvt_mem_alloc(rvt, mem, num_buf);
+	if (err) {
+		pr_warn("err %d from rvt_mem_alloc\n", err);
+		ib_umem_release(umem);
+		goto err1;
+	}
+
+	WARN_ON(!is_power_of_2(umem->page_size));
+
+	mem->page_shift		= ilog2(umem->page_size);
+	mem->page_mask		= umem->page_size - 1;
+
+	num_buf			= 0;
+	map			= mem->map;
+	if (length > 0) {
+		buf = map[0]->buf;
+
+		for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
+			vaddr = page_address(sg_page(sg));
+			if (!vaddr) {
+				pr_warn("null vaddr\n");
+				err = -ENOMEM;
+				goto err1;
+			}
+
+			buf->addr = (uintptr_t)vaddr;
+			buf->size = umem->page_size;
+			num_buf++;
+			buf++;
+
+			if (num_buf >= RVT_BUF_PER_MAP) {
+				map++;
+				buf = map[0]->buf;
+				num_buf = 0;
+			}
+		}
+	}
+
+	mem->pd			= pd;
+	mem->umem		= umem;
+	mem->access		= access;
+	mem->length		= length;
+	mem->iova		= iova;
+	mem->va			= start;
+	mem->offset		= ib_umem_offset(umem);
+	mem->state		= RVT_MEM_STATE_VALID;
+	mem->type		= RVT_MEM_TYPE_MR;
+
+	return 0;
+
+err1:
+	return err;
+}
+
+int rvt_mem_init_fast(struct rvt_dev *rvt, struct rvt_pd *pd,
+		      int max_pages, struct rvt_mem *mem)
+{
+	int err;
+
+	rvt_mem_init(0, mem);
+
+	err = rvt_mem_alloc(rvt, mem, max_pages);
+	if (err)
+		goto err1;
+
+	mem->pd			= pd;
+	mem->max_buf		= max_pages;
+	mem->state		= RVT_MEM_STATE_FREE;
+	mem->type		= RVT_MEM_TYPE_MR;
+
+	return 0;
+
+err1:
+	return err;
+}
+
+int rvt_mem_init_mw(struct rvt_dev *rvt, struct rvt_pd *pd,
+		    struct rvt_mem *mem)
+{
+	rvt_mem_init(0, mem);
+
+	mem->pd			= pd;
+	mem->state		= RVT_MEM_STATE_FREE;
+	mem->type		= RVT_MEM_TYPE_MW;
+
+	return 0;
+}
+
+int rvt_mem_init_fmr(struct rvt_dev *rvt, struct rvt_pd *pd, int access,
+		     struct ib_fmr_attr *attr, struct rvt_mem *mem)
+{
+	int err;
+
+	if (attr->max_maps > rvt->attr.max_map_per_fmr) {
+		pr_warn("max_mmaps = %d too big, max_map_per_fmr = %d\n",
+			attr->max_maps, rvt->attr.max_map_per_fmr);
+		err = -EINVAL;
+		goto err1;
+	}
+
+	rvt_mem_init(access, mem);
+
+	err = rvt_mem_alloc(rvt, mem, attr->max_pages);
+	if (err)
+		goto err1;
+
+	mem->pd			= pd;
+	mem->access		= access;
+	mem->page_shift		 = attr->page_shift;
+	mem->page_mask		= (1 << attr->page_shift) - 1;
+	mem->max_buf		= attr->max_pages;
+	mem->state		= RVT_MEM_STATE_FREE;
+	mem->type		= RVT_MEM_TYPE_FMR;
+
+	return 0;
+
+err1:
+	return err;
+}
+
+static void lookup_iova(
+	struct rvt_mem	*mem,
+	u64			iova,
+	int			*m_out,
+	int			*n_out,
+	size_t			*offset_out)
+{
+	size_t			offset = iova - mem->iova + mem->offset;
+	int			map_index;
+	int			buf_index;
+	u64			length;
+
+	if (likely(mem->page_shift)) {
+		*offset_out = offset & mem->page_mask;
+		offset >>= mem->page_shift;
+		*n_out = offset & mem->map_mask;
+		*m_out = offset >> mem->map_shift;
+	} else {
+		map_index = 0;
+		buf_index = 0;
+
+		length = mem->map[map_index]->buf[buf_index].size;
+
+		while (offset >= length) {
+			offset -= length;
+			buf_index++;
+
+			if (buf_index == RVT_BUF_PER_MAP) {
+				map_index++;
+				buf_index = 0;
+			}
+			length = mem->map[map_index]->buf[buf_index].size;
+		}
+
+		*m_out = map_index;
+		*n_out = buf_index;
+		*offset_out = offset;
+	}
+}
+
+void *iova_to_vaddr(struct rvt_mem *mem, u64 iova, int length)
+{
+	size_t offset;
+	int m, n;
+	void *addr;
+
+	if (mem->state != RVT_MEM_STATE_VALID) {
+		pr_warn("mem not in valid state\n");
+		addr = NULL;
+		goto out;
+	}
+
+	if (!mem->map) {
+		addr = (void *)(uintptr_t)iova;
+		goto out;
+	}
+
+	if (mem_check_range(mem, iova, length)) {
+		pr_warn("range violation\n");
+		addr = NULL;
+		goto out;
+	}
+
+	lookup_iova(mem, iova, &m, &n, &offset);
+
+	if (offset + length > mem->map[m]->buf[n].size) {
+		pr_warn("crosses page boundary\n");
+		addr = NULL;
+		goto out;
+	}
+
+	addr = (void *)(uintptr_t)mem->map[m]->buf[n].addr + offset;
+
+out:
+	return addr;
+}
+
+/* copy data from a range (vaddr, vaddr+length-1) to or from
+   a mem object starting at iova. Compute incremental value of
+   crc32 if crcp is not zero. caller must hold a reference to mem */
+int rvt_mem_copy(struct rvt_mem *mem, u64 iova, void *addr, int length,
+		 enum copy_direction dir, u32 *crcp)
+{
+	int			err;
+	int			bytes;
+	u8			*va;
+	struct rvt_map		**map;
+	struct rvt_phys_buf	*buf;
+	int			m;
+	int			i;
+	size_t			offset;
+	u32			crc = crcp ? (*crcp) : 0;
+
+	if (mem->type == RVT_MEM_TYPE_DMA) {
+		u8 *src, *dest;
+
+		src  = (dir == to_mem_obj) ?
+			addr : ((void *)(uintptr_t)iova);
+
+		dest = (dir == to_mem_obj) ?
+			((void *)(uintptr_t)iova) : addr;
+
+		if (crcp)
+			*crcp = crc32_le(*crcp, src, length);
+
+		memcpy(dest, src, length);
+
+		return 0;
+	}
+
+	WARN_ON(!mem->map);
+
+	err = mem_check_range(mem, iova, length);
+	if (err) {
+		err = -EFAULT;
+		goto err1;
+	}
+
+	lookup_iova(mem, iova, &m, &i, &offset);
+
+	map	= mem->map + m;
+	buf	= map[0]->buf + i;
+
+	while (length > 0) {
+		u8 *src, *dest;
+
+		va	= (u8 *)(uintptr_t)buf->addr + offset;
+		src  = (dir == to_mem_obj) ? addr : va;
+		dest = (dir == to_mem_obj) ? va : addr;
+
+		bytes	= buf->size - offset;
+
+		if (bytes > length)
+			bytes = length;
+
+		if (crcp)
+			crc = crc32_le(crc, src, bytes);
+
+		memcpy(dest, src, bytes);
+
+		length	-= bytes;
+		addr	+= bytes;
+
+		offset	= 0;
+		buf++;
+		i++;
+
+		if (i == RVT_BUF_PER_MAP) {
+			i = 0;
+			map++;
+			buf = map[0]->buf;
+		}
+	}
+
+	if (crcp)
+		*crcp = crc;
+
+	return 0;
+
+err1:
+	return err;
+}
+
+/* copy data in or out of a wqe, i.e. sg list
+   under the control of a dma descriptor */
+int copy_data(
+	struct rvt_dev		*rvt,
+	struct rvt_pd		*pd,
+	int			access,
+	struct rvt_dma_info	*dma,
+	void			*addr,
+	int			length,
+	enum copy_direction	dir,
+	u32			*crcp)
+{
+	int			bytes;
+	struct rvt_sge		*sge	= &dma->sge[dma->cur_sge];
+	int			offset	= dma->sge_offset;
+	int			resid	= dma->resid;
+	struct rvt_mem		*mem	= NULL;
+	u64			iova;
+	int			err;
+
+	if (length == 0)
+		return 0;
+
+	if (length > resid) {
+		err = -EINVAL;
+		goto err2;
+	}
+
+	if (sge->length && (offset < sge->length)) {
+		mem = lookup_mem(pd, access, sge->lkey, lookup_local);
+		if (!mem) {
+			err = -EINVAL;
+			goto err1;
+		}
+	}
+
+	while (length > 0) {
+		bytes = length;
+
+		if (offset >= sge->length) {
+			if (mem) {
+				rvt_drop_ref(mem);
+				mem = NULL;
+			}
+			sge++;
+			dma->cur_sge++;
+			offset = 0;
+
+			if (dma->cur_sge >= dma->num_sge) {
+				err = -ENOSPC;
+				goto err2;
+			}
+
+			if (sge->length) {
+				mem = lookup_mem(pd, access, sge->lkey,
+						 lookup_local);
+				if (!mem) {
+					err = -EINVAL;
+					goto err1;
+				}
+			} else {
+				continue;
+			}
+		}
+
+		if (bytes > sge->length - offset)
+			bytes = sge->length - offset;
+
+		if (bytes > 0) {
+			iova = sge->addr + offset;
+
+			err = rvt_mem_copy(mem, iova, addr, bytes, dir, crcp);
+			if (err)
+				goto err2;
+
+			offset	+= bytes;
+			resid	-= bytes;
+			length	-= bytes;
+			addr	+= bytes;
+		}
+	}
+
+	dma->sge_offset = offset;
+	dma->resid	= resid;
+
+	if (mem)
+		rvt_drop_ref(mem);
+
+	return 0;
+
+err2:
+	if (mem)
+		rvt_drop_ref(mem);
+err1:
+	return err;
+}
+
+int advance_dma_data(struct rvt_dma_info *dma, unsigned int length)
+{
+	struct rvt_sge		*sge	= &dma->sge[dma->cur_sge];
+	int			offset	= dma->sge_offset;
+	int			resid	= dma->resid;
+
+	while (length) {
+		unsigned int bytes;
+
+		if (offset >= sge->length) {
+			sge++;
+			dma->cur_sge++;
+			offset = 0;
+			if (dma->cur_sge >= dma->num_sge)
+				return -ENOSPC;
+		}
+
+		bytes = length;
+
+		if (bytes > sge->length - offset)
+			bytes = sge->length - offset;
+
+		offset	+= bytes;
+		resid	-= bytes;
+		length	-= bytes;
+	}
+
+	dma->sge_offset = offset;
+	dma->resid	= resid;
+
+	return 0;
+}
+
+/* (1) find the mem (mr, fmr or mw) corresponding to lkey/rkey
+ *     depending on lookup_type
+ * (2) verify that the (qp) pd matches the mem pd
+ * (3) verify that the mem can support the requested access
+ * (4) verify that mem state is valid
+ */
+struct rvt_mem *lookup_mem(struct rvt_pd *pd, int access, u32 key,
+			   enum lookup_type type)
+{
+	struct rvt_mem *mem;
+	struct rvt_dev *rvt = to_rdev(pd->ibpd.device);
+	int index = key >> 8;
+
+	if (index >= RVT_MIN_MR_INDEX && index <= RVT_MAX_MR_INDEX) {
+		mem = rvt_pool_get_index(&rvt->mr_pool, index);
+		if (!mem)
+			goto err1;
+	} else if (index >= RVT_MIN_FMR_INDEX && index <= RVT_MAX_FMR_INDEX) {
+		mem = rvt_pool_get_index(&rvt->fmr_pool, index);
+		if (!mem)
+			goto err1;
+	} else if (index >= RVT_MIN_MW_INDEX && index <= RVT_MAX_MW_INDEX) {
+		mem = rvt_pool_get_index(&rvt->mw_pool, index);
+		if (!mem)
+			goto err1;
+	} else {
+		goto err1;
+	}
+
+	if ((type == lookup_local && mem->lkey != key) ||
+	    (type == lookup_remote && mem->rkey != key))
+		goto err2;
+
+	if (mem->pd != pd)
+		goto err2;
+
+	if (access && !(access & mem->access))
+		goto err2;
+
+	if (mem->state != RVT_MEM_STATE_VALID)
+		goto err2;
+
+	return mem;
+
+err2:
+	rvt_drop_ref(mem);
+err1:
+	return NULL;
+}
+
+int rvt_mem_map_pages(struct rvt_dev *rvt, struct rvt_mem *mem,
+		      u64 *page, int num_pages, u64 iova)
+{
+	int i;
+	int num_buf;
+	int err;
+	struct rvt_map **map;
+	struct rvt_phys_buf *buf;
+	int page_size;
+
+	if (num_pages > mem->max_buf) {
+		err = -EINVAL;
+		goto err1;
+	}
+
+	num_buf		= 0;
+	page_size	= 1 << mem->page_shift;
+	map		= mem->map;
+	buf		= map[0]->buf;
+
+	for (i = 0; i < num_pages; i++) {
+		buf->addr = *page++;
+		buf->size = page_size;
+		buf++;
+		num_buf++;
+
+		if (num_buf == RVT_BUF_PER_MAP) {
+			map++;
+			buf = map[0]->buf;
+			num_buf = 0;
+		}
+	}
+
+	mem->iova	= iova;
+	mem->va		= iova;
+	mem->length	= num_pages << mem->page_shift;
+	mem->state	= RVT_MEM_STATE_VALID;
+
+	return 0;
+
+err1:
+	return err;
+}
diff --git a/drivers/infiniband/sw/rdmavt/rvt_opcode.c b/drivers/infiniband/sw/rdmavt/rvt_opcode.c
new file mode 100644
index 0000000..95ab068
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_opcode.c
@@ -0,0 +1,955 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#include <rdma/ib_pack.h>
+#include "rvt_opcode.h"
+#include "rvt_hdr.h"
+
+/* useful information about work request opcodes and pkt opcodes in
+ * table form
+ */
+struct rvt_wr_opcode_info rvt_wr_opcode_info[] = {
+	[IB_WR_RDMA_WRITE]				= {
+		.name	= "IB_WR_RDMA_WRITE",
+		.mask	= {
+			[IB_QPT_RC]	= WR_INLINE_MASK | WR_WRITE_MASK,
+			[IB_QPT_UC]	= WR_INLINE_MASK | WR_WRITE_MASK,
+		},
+	},
+	[IB_WR_RDMA_WRITE_WITH_IMM]			= {
+		.name	= "IB_WR_RDMA_WRITE_WITH_IMM",
+		.mask	= {
+			[IB_QPT_RC]	= WR_INLINE_MASK | WR_WRITE_MASK,
+			[IB_QPT_UC]	= WR_INLINE_MASK | WR_WRITE_MASK,
+		},
+	},
+	[IB_WR_SEND]					= {
+		.name	= "IB_WR_SEND",
+		.mask	= {
+			[IB_QPT_SMI]	= WR_INLINE_MASK | WR_SEND_MASK,
+			[IB_QPT_GSI]	= WR_INLINE_MASK | WR_SEND_MASK,
+			[IB_QPT_RC]	= WR_INLINE_MASK | WR_SEND_MASK,
+			[IB_QPT_UC]	= WR_INLINE_MASK | WR_SEND_MASK,
+			[IB_QPT_UD]	= WR_INLINE_MASK | WR_SEND_MASK,
+		},
+	},
+	[IB_WR_SEND_WITH_IMM]				= {
+		.name	= "IB_WR_SEND_WITH_IMM",
+		.mask	= {
+			[IB_QPT_SMI]	= WR_INLINE_MASK | WR_SEND_MASK,
+			[IB_QPT_GSI]	= WR_INLINE_MASK | WR_SEND_MASK,
+			[IB_QPT_RC]	= WR_INLINE_MASK | WR_SEND_MASK,
+			[IB_QPT_UC]	= WR_INLINE_MASK | WR_SEND_MASK,
+			[IB_QPT_UD]	= WR_INLINE_MASK | WR_SEND_MASK,
+		},
+	},
+	[IB_WR_RDMA_READ]				= {
+		.name	= "IB_WR_RDMA_READ",
+		.mask	= {
+			[IB_QPT_RC]	= WR_READ_MASK,
+		},
+	},
+	[IB_WR_ATOMIC_CMP_AND_SWP]			= {
+		.name	= "IB_WR_ATOMIC_CMP_AND_SWP",
+		.mask	= {
+			[IB_QPT_RC]	= WR_ATOMIC_MASK,
+		},
+	},
+	[IB_WR_ATOMIC_FETCH_AND_ADD]			= {
+		.name	= "IB_WR_ATOMIC_FETCH_AND_ADD",
+		.mask	= {
+			[IB_QPT_RC]	= WR_ATOMIC_MASK,
+		},
+	},
+	[IB_WR_LSO]					= {
+		.name	= "IB_WR_LSO",
+		.mask	= {
+			/* not supported */
+		},
+	},
+	[IB_WR_SEND_WITH_INV]				= {
+		.name	= "IB_WR_SEND_WITH_INV",
+		.mask	= {
+			[IB_QPT_RC]	= WR_INLINE_MASK | WR_SEND_MASK,
+			[IB_QPT_UC]	= WR_INLINE_MASK | WR_SEND_MASK,
+			[IB_QPT_UD]	= WR_INLINE_MASK | WR_SEND_MASK,
+		},
+	},
+	[IB_WR_RDMA_READ_WITH_INV]			= {
+		.name	= "IB_WR_RDMA_READ_WITH_INV",
+		.mask	= {
+			[IB_QPT_RC]	= WR_READ_MASK,
+		},
+	},
+	[IB_WR_LOCAL_INV]				= {
+		.name	= "IB_WR_LOCAL_INV",
+		.mask	= {
+			/* not supported */
+		},
+	},
+};
+
+struct rvt_opcode_info rvt_opcode[RVT_NUM_OPCODE] = {
+	[IB_OPCODE_RC_SEND_FIRST]			= {
+		.name	= "IB_OPCODE_RC_SEND_FIRST",
+		.mask	= RVT_PAYLOAD_MASK | RVT_REQ_MASK | RVT_RWR_MASK
+				| RVT_SEND_MASK | RVT_START_MASK,
+		.length = RVT_BTH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_SEND_MIDDLE]		= {
+		.name	= "IB_OPCODE_RC_SEND_MIDDLE]",
+		.mask	= RVT_PAYLOAD_MASK | RVT_REQ_MASK | RVT_SEND_MASK
+				| RVT_MIDDLE_MASK,
+		.length = RVT_BTH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_SEND_LAST]			= {
+		.name	= "IB_OPCODE_RC_SEND_LAST",
+		.mask	= RVT_PAYLOAD_MASK | RVT_REQ_MASK | RVT_COMP_MASK
+				| RVT_SEND_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_SEND_LAST_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_RC_SEND_LAST_WITH_IMMEDIATE",
+		.mask	= RVT_IMMDT_MASK | RVT_PAYLOAD_MASK | RVT_REQ_MASK
+				| RVT_COMP_MASK | RVT_SEND_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_IMMDT_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_IMMDT]	= RVT_BTH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_IMMDT_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_SEND_ONLY]			= {
+		.name	= "IB_OPCODE_RC_SEND_ONLY",
+		.mask	= RVT_PAYLOAD_MASK | RVT_REQ_MASK | RVT_COMP_MASK
+				| RVT_RWR_MASK | RVT_SEND_MASK
+				| RVT_START_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_SEND_ONLY_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_RC_SEND_ONLY_WITH_IMMEDIATE",
+		.mask	= RVT_IMMDT_MASK | RVT_PAYLOAD_MASK | RVT_REQ_MASK
+				| RVT_COMP_MASK | RVT_RWR_MASK | RVT_SEND_MASK
+				| RVT_START_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_IMMDT_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_IMMDT]	= RVT_BTH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_IMMDT_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_RDMA_WRITE_FIRST]		= {
+		.name	= "IB_OPCODE_RC_RDMA_WRITE_FIRST",
+		.mask	= RVT_RETH_MASK | RVT_PAYLOAD_MASK | RVT_REQ_MASK
+				| RVT_WRITE_MASK | RVT_START_MASK,
+		.length = RVT_BTH_BYTES + RVT_RETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RETH]	= RVT_BTH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_RDMA_WRITE_MIDDLE]		= {
+		.name	= "IB_OPCODE_RC_RDMA_WRITE_MIDDLE",
+		.mask	= RVT_PAYLOAD_MASK | RVT_REQ_MASK | RVT_WRITE_MASK
+				| RVT_MIDDLE_MASK,
+		.length = RVT_BTH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_RDMA_WRITE_LAST]			= {
+		.name	= "IB_OPCODE_RC_RDMA_WRITE_LAST",
+		.mask	= RVT_PAYLOAD_MASK | RVT_REQ_MASK | RVT_WRITE_MASK
+				| RVT_END_MASK,
+		.length = RVT_BTH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_RDMA_WRITE_LAST_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_RC_RDMA_WRITE_LAST_WITH_IMMEDIATE",
+		.mask	= RVT_IMMDT_MASK | RVT_PAYLOAD_MASK | RVT_REQ_MASK
+				| RVT_WRITE_MASK | RVT_COMP_MASK | RVT_RWR_MASK
+				| RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_IMMDT_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_IMMDT]	= RVT_BTH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_IMMDT_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_RDMA_WRITE_ONLY]			= {
+		.name	= "IB_OPCODE_RC_RDMA_WRITE_ONLY",
+		.mask	= RVT_RETH_MASK | RVT_PAYLOAD_MASK | RVT_REQ_MASK
+				| RVT_WRITE_MASK | RVT_START_MASK
+				| RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_RETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RETH]	= RVT_BTH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_RDMA_WRITE_ONLY_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_RC_RDMA_WRITE_ONLY_WITH_IMMEDIATE",
+		.mask	= RVT_RETH_MASK | RVT_IMMDT_MASK | RVT_PAYLOAD_MASK
+				| RVT_REQ_MASK | RVT_WRITE_MASK
+				| RVT_COMP_MASK | RVT_RWR_MASK
+				| RVT_START_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_IMMDT_BYTES + RVT_RETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RETH]	= RVT_BTH_BYTES,
+			[RVT_IMMDT]	= RVT_BTH_BYTES
+						+ RVT_RETH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RETH_BYTES
+						+ RVT_IMMDT_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_RDMA_READ_REQUEST]			= {
+		.name	= "IB_OPCODE_RC_RDMA_READ_REQUEST",
+		.mask	= RVT_RETH_MASK | RVT_REQ_MASK | RVT_READ_MASK
+				| RVT_START_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_RETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RETH]	= RVT_BTH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_RDMA_READ_RESPONSE_FIRST]		= {
+		.name	= "IB_OPCODE_RC_RDMA_READ_RESPONSE_FIRST",
+		.mask	= RVT_AETH_MASK | RVT_PAYLOAD_MASK | RVT_ACK_MASK
+				| RVT_START_MASK,
+		.length = RVT_BTH_BYTES + RVT_AETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_AETH]	= RVT_BTH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_AETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_RDMA_READ_RESPONSE_MIDDLE]		= {
+		.name	= "IB_OPCODE_RC_RDMA_READ_RESPONSE_MIDDLE",
+		.mask	= RVT_PAYLOAD_MASK | RVT_ACK_MASK | RVT_MIDDLE_MASK,
+		.length = RVT_BTH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_RDMA_READ_RESPONSE_LAST]		= {
+		.name	= "IB_OPCODE_RC_RDMA_READ_RESPONSE_LAST",
+		.mask	= RVT_AETH_MASK | RVT_PAYLOAD_MASK | RVT_ACK_MASK
+				| RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_AETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_AETH]	= RVT_BTH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_AETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_RDMA_READ_RESPONSE_ONLY]		= {
+		.name	= "IB_OPCODE_RC_RDMA_READ_RESPONSE_ONLY",
+		.mask	= RVT_AETH_MASK | RVT_PAYLOAD_MASK | RVT_ACK_MASK
+				| RVT_START_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_AETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_AETH]	= RVT_BTH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_AETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_ACKNOWLEDGE]			= {
+		.name	= "IB_OPCODE_RC_ACKNOWLEDGE",
+		.mask	= RVT_AETH_MASK | RVT_ACK_MASK | RVT_START_MASK
+				| RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_AETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_AETH]	= RVT_BTH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_AETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_ATOMIC_ACKNOWLEDGE]			= {
+		.name	= "IB_OPCODE_RC_ATOMIC_ACKNOWLEDGE",
+		.mask	= RVT_AETH_MASK | RVT_ATMACK_MASK | RVT_ACK_MASK
+				| RVT_START_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_ATMACK_BYTES + RVT_AETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_AETH]	= RVT_BTH_BYTES,
+			[RVT_ATMACK]	= RVT_BTH_BYTES
+						+ RVT_AETH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+					+ RVT_ATMACK_BYTES + RVT_AETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_COMPARE_SWAP]			= {
+		.name	= "IB_OPCODE_RC_COMPARE_SWAP",
+		.mask	= RVT_ATMETH_MASK | RVT_REQ_MASK | RVT_ATOMIC_MASK
+				| RVT_START_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_ATMETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_ATMETH]	= RVT_BTH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_ATMETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_FETCH_ADD]			= {
+		.name	= "IB_OPCODE_RC_FETCH_ADD",
+		.mask	= RVT_ATMETH_MASK | RVT_REQ_MASK | RVT_ATOMIC_MASK
+				| RVT_START_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_ATMETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_ATMETH]	= RVT_BTH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_ATMETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_SEND_LAST_INV]		= {
+		.name	= "IB_OPCODE_RC_SEND_LAST_INV",
+		.mask	= RVT_IETH_MASK | RVT_PAYLOAD_MASK | RVT_REQ_MASK
+				| RVT_COMP_MASK | RVT_SEND_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_IETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_IETH]	= RVT_BTH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_IETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_SEND_ONLY_INV]		= {
+		.name	= "IB_OPCODE_RC_SEND_ONLY_INV",
+		.mask	= RVT_IETH_MASK | RVT_PAYLOAD_MASK | RVT_REQ_MASK
+				| RVT_COMP_MASK | RVT_RWR_MASK | RVT_SEND_MASK
+				| RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_IETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_IETH]	= RVT_BTH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_IETH_BYTES,
+		}
+	},
+
+	/* UC */
+	[IB_OPCODE_UC_SEND_FIRST]			= {
+		.name	= "IB_OPCODE_UC_SEND_FIRST",
+		.mask	= RVT_PAYLOAD_MASK | RVT_REQ_MASK | RVT_RWR_MASK
+				| RVT_SEND_MASK | RVT_START_MASK,
+		.length = RVT_BTH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_UC_SEND_MIDDLE]		= {
+		.name	= "IB_OPCODE_UC_SEND_MIDDLE",
+		.mask	= RVT_PAYLOAD_MASK | RVT_REQ_MASK | RVT_SEND_MASK
+				| RVT_MIDDLE_MASK,
+		.length = RVT_BTH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_UC_SEND_LAST]			= {
+		.name	= "IB_OPCODE_UC_SEND_LAST",
+		.mask	= RVT_PAYLOAD_MASK | RVT_REQ_MASK | RVT_COMP_MASK
+				| RVT_SEND_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_UC_SEND_LAST_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_UC_SEND_LAST_WITH_IMMEDIATE",
+		.mask	= RVT_IMMDT_MASK | RVT_PAYLOAD_MASK | RVT_REQ_MASK
+				| RVT_COMP_MASK | RVT_SEND_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_IMMDT_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_IMMDT]	= RVT_BTH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_IMMDT_BYTES,
+		}
+	},
+	[IB_OPCODE_UC_SEND_ONLY]			= {
+		.name	= "IB_OPCODE_UC_SEND_ONLY",
+		.mask	= RVT_PAYLOAD_MASK | RVT_REQ_MASK | RVT_COMP_MASK
+				| RVT_RWR_MASK | RVT_SEND_MASK
+				| RVT_START_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_UC_SEND_ONLY_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_UC_SEND_ONLY_WITH_IMMEDIATE",
+		.mask	= RVT_IMMDT_MASK | RVT_PAYLOAD_MASK | RVT_REQ_MASK
+				| RVT_COMP_MASK | RVT_RWR_MASK | RVT_SEND_MASK
+				| RVT_START_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_IMMDT_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_IMMDT]	= RVT_BTH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_IMMDT_BYTES,
+		}
+	},
+	[IB_OPCODE_UC_RDMA_WRITE_FIRST]		= {
+		.name	= "IB_OPCODE_UC_RDMA_WRITE_FIRST",
+		.mask	= RVT_RETH_MASK | RVT_PAYLOAD_MASK | RVT_REQ_MASK
+				| RVT_WRITE_MASK | RVT_START_MASK,
+		.length = RVT_BTH_BYTES + RVT_RETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RETH]	= RVT_BTH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RETH_BYTES,
+		}
+	},
+	[IB_OPCODE_UC_RDMA_WRITE_MIDDLE]		= {
+		.name	= "IB_OPCODE_UC_RDMA_WRITE_MIDDLE",
+		.mask	= RVT_PAYLOAD_MASK | RVT_REQ_MASK | RVT_WRITE_MASK
+				| RVT_MIDDLE_MASK,
+		.length = RVT_BTH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_UC_RDMA_WRITE_LAST]			= {
+		.name	= "IB_OPCODE_UC_RDMA_WRITE_LAST",
+		.mask	= RVT_PAYLOAD_MASK | RVT_REQ_MASK | RVT_WRITE_MASK
+				| RVT_END_MASK,
+		.length = RVT_BTH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_UC_RDMA_WRITE_LAST_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_UC_RDMA_WRITE_LAST_WITH_IMMEDIATE",
+		.mask	= RVT_IMMDT_MASK | RVT_PAYLOAD_MASK | RVT_REQ_MASK
+				| RVT_WRITE_MASK | RVT_COMP_MASK | RVT_RWR_MASK
+				| RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_IMMDT_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_IMMDT]	= RVT_BTH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_IMMDT_BYTES,
+		}
+	},
+	[IB_OPCODE_UC_RDMA_WRITE_ONLY]			= {
+		.name	= "IB_OPCODE_UC_RDMA_WRITE_ONLY",
+		.mask	= RVT_RETH_MASK | RVT_PAYLOAD_MASK | RVT_REQ_MASK
+				| RVT_WRITE_MASK | RVT_START_MASK
+				| RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_RETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RETH]	= RVT_BTH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RETH_BYTES,
+		}
+	},
+	[IB_OPCODE_UC_RDMA_WRITE_ONLY_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_UC_RDMA_WRITE_ONLY_WITH_IMMEDIATE",
+		.mask	= RVT_RETH_MASK | RVT_IMMDT_MASK | RVT_PAYLOAD_MASK
+				| RVT_REQ_MASK | RVT_WRITE_MASK
+				| RVT_COMP_MASK | RVT_RWR_MASK
+				| RVT_START_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_IMMDT_BYTES + RVT_RETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RETH]	= RVT_BTH_BYTES,
+			[RVT_IMMDT]	= RVT_BTH_BYTES
+						+ RVT_RETH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RETH_BYTES
+						+ RVT_IMMDT_BYTES,
+		}
+	},
+
+	/* RD */
+	[IB_OPCODE_RD_SEND_FIRST]			= {
+		.name	= "IB_OPCODE_RD_SEND_FIRST",
+		.mask	= RVT_RDETH_MASK | RVT_DETH_MASK | RVT_PAYLOAD_MASK
+				| RVT_REQ_MASK | RVT_RWR_MASK | RVT_SEND_MASK
+				| RVT_START_MASK,
+		.length = RVT_BTH_BYTES + RVT_DETH_BYTES + RVT_RDETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RDETH]	= RVT_BTH_BYTES,
+			[RVT_DETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_DETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_SEND_MIDDLE]		= {
+		.name	= "IB_OPCODE_RD_SEND_MIDDLE",
+		.mask	= RVT_RDETH_MASK | RVT_DETH_MASK | RVT_PAYLOAD_MASK
+				| RVT_REQ_MASK | RVT_SEND_MASK
+				| RVT_MIDDLE_MASK,
+		.length = RVT_BTH_BYTES + RVT_DETH_BYTES + RVT_RDETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RDETH]	= RVT_BTH_BYTES,
+			[RVT_DETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_DETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_SEND_LAST]			= {
+		.name	= "IB_OPCODE_RD_SEND_LAST",
+		.mask	= RVT_RDETH_MASK | RVT_DETH_MASK | RVT_PAYLOAD_MASK
+				| RVT_REQ_MASK | RVT_COMP_MASK | RVT_SEND_MASK
+				| RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_DETH_BYTES + RVT_RDETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RDETH]	= RVT_BTH_BYTES,
+			[RVT_DETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_DETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_SEND_LAST_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_RD_SEND_LAST_WITH_IMMEDIATE",
+		.mask	= RVT_RDETH_MASK | RVT_DETH_MASK | RVT_IMMDT_MASK
+				| RVT_PAYLOAD_MASK | RVT_REQ_MASK
+				| RVT_COMP_MASK | RVT_SEND_MASK
+				| RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_IMMDT_BYTES + RVT_DETH_BYTES
+				+ RVT_RDETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RDETH]	= RVT_BTH_BYTES,
+			[RVT_DETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES,
+			[RVT_IMMDT]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_DETH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_DETH_BYTES
+						+ RVT_IMMDT_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_SEND_ONLY]			= {
+		.name	= "IB_OPCODE_RD_SEND_ONLY",
+		.mask	= RVT_RDETH_MASK | RVT_DETH_MASK | RVT_PAYLOAD_MASK
+				| RVT_REQ_MASK | RVT_COMP_MASK | RVT_RWR_MASK
+				| RVT_SEND_MASK | RVT_START_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_DETH_BYTES + RVT_RDETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RDETH]	= RVT_BTH_BYTES,
+			[RVT_DETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_DETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_SEND_ONLY_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_RD_SEND_ONLY_WITH_IMMEDIATE",
+		.mask	= RVT_RDETH_MASK | RVT_DETH_MASK | RVT_IMMDT_MASK
+				| RVT_PAYLOAD_MASK | RVT_REQ_MASK
+				| RVT_COMP_MASK | RVT_RWR_MASK | RVT_SEND_MASK
+				| RVT_START_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_IMMDT_BYTES + RVT_DETH_BYTES
+				+ RVT_RDETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RDETH]	= RVT_BTH_BYTES,
+			[RVT_DETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES,
+			[RVT_IMMDT]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_DETH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_DETH_BYTES
+						+ RVT_IMMDT_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_RDMA_WRITE_FIRST]		= {
+		.name	= "IB_OPCODE_RD_RDMA_WRITE_FIRST",
+		.mask	= RVT_RDETH_MASK | RVT_DETH_MASK | RVT_RETH_MASK
+				| RVT_PAYLOAD_MASK | RVT_REQ_MASK
+				| RVT_WRITE_MASK | RVT_START_MASK,
+		.length = RVT_BTH_BYTES + RVT_RETH_BYTES + RVT_DETH_BYTES
+				+ RVT_RDETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RDETH]	= RVT_BTH_BYTES,
+			[RVT_DETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES,
+			[RVT_RETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_DETH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_DETH_BYTES
+						+ RVT_RETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_RDMA_WRITE_MIDDLE]		= {
+		.name	= "IB_OPCODE_RD_RDMA_WRITE_MIDDLE",
+		.mask	= RVT_RDETH_MASK | RVT_DETH_MASK | RVT_PAYLOAD_MASK
+				| RVT_REQ_MASK | RVT_WRITE_MASK
+				| RVT_MIDDLE_MASK,
+		.length = RVT_BTH_BYTES + RVT_DETH_BYTES + RVT_RDETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RDETH]	= RVT_BTH_BYTES,
+			[RVT_DETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_DETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_RDMA_WRITE_LAST]			= {
+		.name	= "IB_OPCODE_RD_RDMA_WRITE_LAST",
+		.mask	= RVT_RDETH_MASK | RVT_DETH_MASK | RVT_PAYLOAD_MASK
+				| RVT_REQ_MASK | RVT_WRITE_MASK
+				| RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_DETH_BYTES + RVT_RDETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RDETH]	= RVT_BTH_BYTES,
+			[RVT_DETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_DETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_RDMA_WRITE_LAST_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_RD_RDMA_WRITE_LAST_WITH_IMMEDIATE",
+		.mask	= RVT_RDETH_MASK | RVT_DETH_MASK | RVT_IMMDT_MASK
+				| RVT_PAYLOAD_MASK | RVT_REQ_MASK
+				| RVT_WRITE_MASK | RVT_COMP_MASK | RVT_RWR_MASK
+				| RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_IMMDT_BYTES + RVT_DETH_BYTES
+				+ RVT_RDETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RDETH]	= RVT_BTH_BYTES,
+			[RVT_DETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES,
+			[RVT_IMMDT]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_DETH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_DETH_BYTES
+						+ RVT_IMMDT_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_RDMA_WRITE_ONLY]			= {
+		.name	= "IB_OPCODE_RD_RDMA_WRITE_ONLY",
+		.mask	= RVT_RDETH_MASK | RVT_DETH_MASK | RVT_RETH_MASK
+				| RVT_PAYLOAD_MASK | RVT_REQ_MASK
+				| RVT_WRITE_MASK | RVT_START_MASK
+				| RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_RETH_BYTES + RVT_DETH_BYTES
+				+ RVT_RDETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RDETH]	= RVT_BTH_BYTES,
+			[RVT_DETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES,
+			[RVT_RETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_DETH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_DETH_BYTES
+						+ RVT_RETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_RDMA_WRITE_ONLY_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_RD_RDMA_WRITE_ONLY_WITH_IMMEDIATE",
+		.mask	= RVT_RDETH_MASK | RVT_DETH_MASK | RVT_RETH_MASK
+				| RVT_IMMDT_MASK | RVT_PAYLOAD_MASK
+				| RVT_REQ_MASK | RVT_WRITE_MASK
+				| RVT_COMP_MASK | RVT_RWR_MASK
+				| RVT_START_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_IMMDT_BYTES + RVT_RETH_BYTES
+				+ RVT_DETH_BYTES + RVT_RDETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RDETH]	= RVT_BTH_BYTES,
+			[RVT_DETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES,
+			[RVT_RETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_DETH_BYTES,
+			[RVT_IMMDT]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_DETH_BYTES
+						+ RVT_RETH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_DETH_BYTES
+						+ RVT_RETH_BYTES
+						+ RVT_IMMDT_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_RDMA_READ_REQUEST]			= {
+		.name	= "IB_OPCODE_RD_RDMA_READ_REQUEST",
+		.mask	= RVT_RDETH_MASK | RVT_DETH_MASK | RVT_RETH_MASK
+				| RVT_REQ_MASK | RVT_READ_MASK
+				| RVT_START_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_RETH_BYTES + RVT_DETH_BYTES
+				+ RVT_RDETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RDETH]	= RVT_BTH_BYTES,
+			[RVT_DETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES,
+			[RVT_RETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_DETH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RETH_BYTES
+						+ RVT_DETH_BYTES
+						+ RVT_RDETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_RDMA_READ_RESPONSE_FIRST]		= {
+		.name	= "IB_OPCODE_RD_RDMA_READ_RESPONSE_FIRST",
+		.mask	= RVT_RDETH_MASK | RVT_AETH_MASK
+				| RVT_PAYLOAD_MASK | RVT_ACK_MASK
+				| RVT_START_MASK,
+		.length = RVT_BTH_BYTES + RVT_AETH_BYTES + RVT_RDETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RDETH]	= RVT_BTH_BYTES,
+			[RVT_AETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_AETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_RDMA_READ_RESPONSE_MIDDLE]		= {
+		.name	= "IB_OPCODE_RD_RDMA_READ_RESPONSE_MIDDLE",
+		.mask	= RVT_RDETH_MASK | RVT_PAYLOAD_MASK | RVT_ACK_MASK
+				| RVT_MIDDLE_MASK,
+		.length = RVT_BTH_BYTES + RVT_RDETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RDETH]	= RVT_BTH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_RDMA_READ_RESPONSE_LAST]		= {
+		.name	= "IB_OPCODE_RD_RDMA_READ_RESPONSE_LAST",
+		.mask	= RVT_RDETH_MASK | RVT_AETH_MASK | RVT_PAYLOAD_MASK
+				| RVT_ACK_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_AETH_BYTES + RVT_RDETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RDETH]	= RVT_BTH_BYTES,
+			[RVT_AETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_AETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_RDMA_READ_RESPONSE_ONLY]		= {
+		.name	= "IB_OPCODE_RD_RDMA_READ_RESPONSE_ONLY",
+		.mask	= RVT_RDETH_MASK | RVT_AETH_MASK | RVT_PAYLOAD_MASK
+				| RVT_ACK_MASK | RVT_START_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_AETH_BYTES + RVT_RDETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RDETH]	= RVT_BTH_BYTES,
+			[RVT_AETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_AETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_ACKNOWLEDGE]			= {
+		.name	= "IB_OPCODE_RD_ACKNOWLEDGE",
+		.mask	= RVT_RDETH_MASK | RVT_AETH_MASK | RVT_ACK_MASK
+				| RVT_START_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_AETH_BYTES + RVT_RDETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RDETH]	= RVT_BTH_BYTES,
+			[RVT_AETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_ATOMIC_ACKNOWLEDGE]			= {
+		.name	= "IB_OPCODE_RD_ATOMIC_ACKNOWLEDGE",
+		.mask	= RVT_RDETH_MASK | RVT_AETH_MASK | RVT_ATMACK_MASK
+				| RVT_ACK_MASK | RVT_START_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_ATMACK_BYTES + RVT_AETH_BYTES
+				+ RVT_RDETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RDETH]	= RVT_BTH_BYTES,
+			[RVT_AETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES,
+			[RVT_ATMACK]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_AETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_COMPARE_SWAP]			= {
+		.name	= "RD_COMPARE_SWAP",
+		.mask	= RVT_RDETH_MASK | RVT_DETH_MASK | RVT_ATMETH_MASK
+				| RVT_REQ_MASK | RVT_ATOMIC_MASK
+				| RVT_START_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_ATMETH_BYTES + RVT_DETH_BYTES
+				+ RVT_RDETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RDETH]	= RVT_BTH_BYTES,
+			[RVT_DETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES,
+			[RVT_ATMETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_DETH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES +
+						+ RVT_ATMETH_BYTES
+						+ RVT_DETH_BYTES +
+						+ RVT_RDETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_FETCH_ADD]			= {
+		.name	= "IB_OPCODE_RD_FETCH_ADD",
+		.mask	= RVT_RDETH_MASK | RVT_DETH_MASK | RVT_ATMETH_MASK
+				| RVT_REQ_MASK | RVT_ATOMIC_MASK
+				| RVT_START_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_ATMETH_BYTES + RVT_DETH_BYTES
+				+ RVT_RDETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_RDETH]	= RVT_BTH_BYTES,
+			[RVT_DETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES,
+			[RVT_ATMETH]	= RVT_BTH_BYTES
+						+ RVT_RDETH_BYTES
+						+ RVT_DETH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES +
+						+ RVT_ATMETH_BYTES
+						+ RVT_DETH_BYTES +
+						+ RVT_RDETH_BYTES,
+		}
+	},
+
+	/* UD */
+	[IB_OPCODE_UD_SEND_ONLY]			= {
+		.name	= "IB_OPCODE_UD_SEND_ONLY",
+		.mask	= RVT_DETH_MASK | RVT_PAYLOAD_MASK | RVT_REQ_MASK
+				| RVT_COMP_MASK | RVT_RWR_MASK | RVT_SEND_MASK
+				| RVT_START_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_DETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_DETH]	= RVT_BTH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_DETH_BYTES,
+		}
+	},
+	[IB_OPCODE_UD_SEND_ONLY_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_UD_SEND_ONLY_WITH_IMMEDIATE",
+		.mask	= RVT_DETH_MASK | RVT_IMMDT_MASK | RVT_PAYLOAD_MASK
+				| RVT_REQ_MASK | RVT_COMP_MASK | RVT_RWR_MASK
+				| RVT_SEND_MASK | RVT_START_MASK | RVT_END_MASK,
+		.length = RVT_BTH_BYTES + RVT_IMMDT_BYTES + RVT_DETH_BYTES,
+		.offset = {
+			[RVT_BTH]	= 0,
+			[RVT_DETH]	= RVT_BTH_BYTES,
+			[RVT_IMMDT]	= RVT_BTH_BYTES
+						+ RVT_DETH_BYTES,
+			[RVT_PAYLOAD]	= RVT_BTH_BYTES
+						+ RVT_DETH_BYTES
+						+ RVT_IMMDT_BYTES,
+		}
+	},
+
+};
diff --git a/drivers/infiniband/sw/rdmavt/rvt_opcode.h b/drivers/infiniband/sw/rdmavt/rvt_opcode.h
new file mode 100644
index 0000000..d5fc4c6
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_opcode.h
@@ -0,0 +1,128 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#ifndef RVT_OPCODE_H
+#define RVT_OPCODE_H
+
+/*
+ * contains header bit mask definitions and header lengths
+ * declaration of the rvt_opcode_info struct and
+ * rvt_wr_opcode_info struct
+ */
+
+enum rvt_wr_mask {
+	WR_INLINE_MASK			= BIT(0),
+	WR_ATOMIC_MASK			= BIT(1),
+	WR_SEND_MASK			= BIT(2),
+	WR_READ_MASK			= BIT(3),
+	WR_WRITE_MASK			= BIT(4),
+	WR_LOCAL_MASK			= BIT(5),
+
+	WR_READ_OR_WRITE_MASK		= WR_READ_MASK | WR_WRITE_MASK,
+	WR_READ_WRITE_OR_SEND_MASK	= WR_READ_OR_WRITE_MASK | WR_SEND_MASK,
+	WR_WRITE_OR_SEND_MASK		= WR_WRITE_MASK | WR_SEND_MASK,
+	WR_ATOMIC_OR_READ_MASK		= WR_ATOMIC_MASK | WR_READ_MASK,
+};
+
+#define WR_MAX_QPT		(8)
+
+struct rvt_wr_opcode_info {
+	char			*name;
+	enum rvt_wr_mask	mask[WR_MAX_QPT];
+};
+
+enum rvt_hdr_type {
+	RVT_LRH,
+	RVT_GRH,
+	RVT_BTH,
+	RVT_RETH,
+	RVT_AETH,
+	RVT_ATMETH,
+	RVT_ATMACK,
+	RVT_IETH,
+	RVT_RDETH,
+	RVT_DETH,
+	RVT_IMMDT,
+	RVT_PAYLOAD,
+	NUM_HDR_TYPES
+};
+
+enum rvt_hdr_mask {
+	RVT_LRH_MASK		= BIT(RVT_LRH),
+	RVT_GRH_MASK		= BIT(RVT_GRH),
+	RVT_BTH_MASK		= BIT(RVT_BTH),
+	RVT_IMMDT_MASK		= BIT(RVT_IMMDT),
+	RVT_RETH_MASK		= BIT(RVT_RETH),
+	RVT_AETH_MASK		= BIT(RVT_AETH),
+	RVT_ATMETH_MASK		= BIT(RVT_ATMETH),
+	RVT_ATMACK_MASK		= BIT(RVT_ATMACK),
+	RVT_IETH_MASK		= BIT(RVT_IETH),
+	RVT_RDETH_MASK		= BIT(RVT_RDETH),
+	RVT_DETH_MASK		= BIT(RVT_DETH),
+	RVT_PAYLOAD_MASK	= BIT(RVT_PAYLOAD),
+
+	RVT_REQ_MASK		= BIT(NUM_HDR_TYPES + 0),
+	RVT_ACK_MASK		= BIT(NUM_HDR_TYPES + 1),
+	RVT_SEND_MASK		= BIT(NUM_HDR_TYPES + 2),
+	RVT_WRITE_MASK		= BIT(NUM_HDR_TYPES + 3),
+	RVT_READ_MASK		= BIT(NUM_HDR_TYPES + 4),
+	RVT_ATOMIC_MASK		= BIT(NUM_HDR_TYPES + 5),
+
+	RVT_RWR_MASK		= BIT(NUM_HDR_TYPES + 6),
+	RVT_COMP_MASK		= BIT(NUM_HDR_TYPES + 7),
+
+	RVT_START_MASK		= BIT(NUM_HDR_TYPES + 8),
+	RVT_MIDDLE_MASK		= BIT(NUM_HDR_TYPES + 9),
+	RVT_END_MASK		= BIT(NUM_HDR_TYPES + 10),
+
+	RVT_LOOPBACK_MASK	= BIT(NUM_HDR_TYPES + 12),
+
+	RVT_READ_OR_ATOMIC	= (RVT_READ_MASK | RVT_ATOMIC_MASK),
+	RVT_WRITE_OR_SEND	= (RVT_WRITE_MASK | RVT_SEND_MASK),
+};
+
+extern struct rvt_wr_opcode_info rvt_wr_opcode_info[];
+
+#define OPCODE_NONE		(-1)
+#define RVT_NUM_OPCODE		256
+
+struct rvt_opcode_info {
+	char			*name;
+	enum rvt_hdr_mask	mask;
+	int			length;
+	int			offset[NUM_HDR_TYPES];
+};
+
+extern struct rvt_opcode_info rvt_opcode[RVT_NUM_OPCODE];
+
+#endif /* RVT_OPCODE_H */
diff --git a/drivers/infiniband/sw/rdmavt/rvt_param.h b/drivers/infiniband/sw/rdmavt/rvt_param.h
new file mode 100644
index 0000000..38635a8
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_param.h
@@ -0,0 +1,179 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#ifndef RVT_PARAM_H
+#define RVT_PARAM_H
+
+#include "rvt_hdr.h"
+
+static inline enum ib_mtu rvt_mtu_int_to_enum(int mtu)
+{
+	if (mtu < 256)
+		return 0;
+	else if (mtu < 512)
+		return IB_MTU_256;
+	else if (mtu < 1024)
+		return IB_MTU_512;
+	else if (mtu < 2048)
+		return IB_MTU_1024;
+	else if (mtu < 4096)
+		return IB_MTU_2048;
+	else
+		return IB_MTU_4096;
+}
+
+/* Find the IB mtu for a given network MTU. */
+static inline enum ib_mtu eth_mtu_int_to_enum(int mtu)
+{
+	mtu -= RVT_MAX_HDR_LENGTH;
+
+	return rvt_mtu_int_to_enum(mtu);
+}
+
+/* default/initial rvt device parameter settings */
+enum rvt_device_param {
+	RVT_FW_VER			= 0,
+	RVT_MAX_MR_SIZE			= -1ull,
+	RVT_PAGE_SIZE_CAP		= 0xfffff000,
+	RVT_VENDOR_ID			= 0,
+	RVT_VENDOR_PART_ID		= 0,
+	RVT_HW_VER			= 0,
+	RVT_MAX_QP			= 0x10000,
+	RVT_MAX_QP_WR			= 0x4000,
+	RVT_MAX_INLINE_DATA		= 400,
+	RVT_DEVICE_CAP_FLAGS		= IB_DEVICE_BAD_PKEY_CNTR
+					| IB_DEVICE_BAD_QKEY_CNTR
+					| IB_DEVICE_AUTO_PATH_MIG
+					| IB_DEVICE_CHANGE_PHY_PORT
+					| IB_DEVICE_UD_AV_PORT_ENFORCE
+					| IB_DEVICE_PORT_ACTIVE_EVENT
+					| IB_DEVICE_SYS_IMAGE_GUID
+					| IB_DEVICE_RC_RNR_NAK_GEN
+					| IB_DEVICE_SRQ_RESIZE,
+	RVT_MAX_SGE			= 27,
+	RVT_MAX_SGE_RD			= 0,
+	RVT_MAX_CQ			= 16384,
+	RVT_MAX_LOG_CQE			= 13,
+	RVT_MAX_MR			= 2 * 1024,
+	RVT_MAX_PD			= 0x7ffc,
+	RVT_MAX_QP_RD_ATOM		= 128,
+	RVT_MAX_EE_RD_ATOM		= 0,
+	RVT_MAX_RES_RD_ATOM		= 0x3f000,
+	RVT_MAX_QP_INIT_RD_ATOM		= 128,
+	RVT_MAX_EE_INIT_RD_ATOM		= 0,
+	RVT_ATOMIC_CAP			= 1,
+	RVT_MAX_EE			= 0,
+	RVT_MAX_RDD			= 0,
+	RVT_MAX_MW			= 0,
+	RVT_MAX_RAW_IPV6_QP		= 0,
+	RVT_MAX_RAW_ETHY_QP		= 0,
+	RVT_MAX_MCAST_GRP		= 8192,
+	RVT_MAX_MCAST_QP_ATTACH		= 56,
+	RVT_MAX_TOT_MCAST_QP_ATTACH	= 0x70000,
+	RVT_MAX_AH			= 100,
+	RVT_MAX_FMR			= 2 * 1024,
+	RVT_MAX_MAP_PER_FMR		= 100,
+	RVT_MAX_SRQ			= 960,
+	RVT_MAX_SRQ_WR			= 0x4000,
+	RVT_MIN_SRQ_WR			= 1,
+	RVT_MAX_SRQ_SGE			= 27,
+	RVT_MIN_SRQ_SGE			= 1,
+	RVT_MAX_FMR_PAGE_LIST_LEN	= 0,
+	RVT_MAX_PKEYS			= 64,
+	RVT_LOCAL_CA_ACK_DELAY		= 15,
+
+	RVT_MAX_UCONTEXT		= 512,
+
+	RVT_NUM_PORT			= 1,
+	RVT_NUM_COMP_VECTORS		= 1,
+
+	RVT_MIN_QP_INDEX		= 16,
+	RVT_MAX_QP_INDEX		= 0x00020000,
+
+	RVT_MIN_SRQ_INDEX		= 0x00020001,
+	RVT_MAX_SRQ_INDEX		= 0x00040000,
+
+	RVT_MIN_MR_INDEX		= 0x00000001,
+	RVT_MAX_MR_INDEX		= 0x00020000,
+	RVT_MIN_FMR_INDEX		= 0x00020001,
+	RVT_MAX_FMR_INDEX		= 0x00040000,
+	RVT_MIN_MW_INDEX		= 0x00040001,
+	RVT_MAX_MW_INDEX		= 0x00060000,
+	RVT_MAX_PKT_PER_ACK		= 64,
+
+	/* PSN window in RC, to prevent mixing new packets PSN with
+	 * old ones. According to IB SPEC this number is half of
+	 * the PSN range (2^24).
+	 */
+	RVT_MAX_UNACKED_PSNS		= 0x800000,
+
+	/* Max inflight SKBs per queue pair */
+	RVT_INFLIGHT_SKBS_PER_QP_HIGH	= 64,
+	RVT_INFLIGHT_SKBS_PER_QP_LOW	= 16,
+
+	/* Delay before calling arbiter timer */
+	RVT_NSEC_ARB_TIMER_DELAY	= 200,
+};
+
+/* default/initial rvt port parameters */
+enum rvt_port_param {
+	RVT_PORT_STATE			= IB_PORT_DOWN,
+	RVT_PORT_MAX_MTU		= IB_MTU_4096,
+	RVT_PORT_ACTIVE_MTU		= IB_MTU_256,
+	RVT_PORT_GID_TBL_LEN		= 32,
+	RVT_PORT_PORT_CAP_FLAGS		= RDMA_CORE_CAP_PROT_ROCE_UDP_ENCAP,
+	RVT_PORT_MAX_MSG_SZ		= 0x800000,
+	RVT_PORT_BAD_PKEY_CNTR		= 0,
+	RVT_PORT_QKEY_VIOL_CNTR		= 0,
+	RVT_PORT_LID			= 0,
+	RVT_PORT_SM_LID			= 0,
+	RVT_PORT_SM_SL			= 0,
+	RVT_PORT_LMC			= 0,
+	RVT_PORT_MAX_VL_NUM		= 1,
+	RVT_PORT_SUBNET_TIMEOUT		= 0,
+	RVT_PORT_INIT_TYPE_REPLY	= 0,
+	RVT_PORT_ACTIVE_WIDTH		= IB_WIDTH_1X,
+	RVT_PORT_ACTIVE_SPEED		= 1,
+	RVT_PORT_PKEY_TBL_LEN		= 64,
+	RVT_PORT_PHYS_STATE		= 2,
+	RVT_PORT_SUBNET_PREFIX		= 0xfe80000000000000ULL,
+};
+
+/* default/initial port info parameters */
+enum rvt_port_info_param {
+	RVT_PORT_INFO_VL_CAP		= 4,	/* 1-8 */
+	RVT_PORT_INFO_MTU_CAP		= 5,	/* 4096 */
+	RVT_PORT_INFO_OPER_VL		= 1,	/* 1 */
+};
+
+#endif /* RVT_PARAM_H */
diff --git a/drivers/infiniband/sw/rdmavt/rvt_pool.c b/drivers/infiniband/sw/rdmavt/rvt_pool.c
new file mode 100644
index 0000000..500a2b9
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_pool.c
@@ -0,0 +1,510 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *	   Redistribution and use in source and binary forms, with or
+ *	   without modification, are permitted provided that the following
+ *	   conditions are met:
+ *
+ *		- Redistributions of source code must retain the above
+ *		  copyright notice, this list of conditions and the following
+ *		  disclaimer.
+ *
+ *		- Redistributions in binary form must reproduce the above
+ *		  copyright notice, this list of conditions and the following
+ *		  disclaimer in the documentation and/or other materials
+ *		  provided with the distribution.
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
+#include "rvt_loc.h"
+
+/* info about object pools
+   note that mr, fmr and mw share a single index space
+   so that one can map an lkey to the correct type of object */
+struct rvt_type_info rvt_type_info[RVT_NUM_TYPES] = {
+	[RVT_TYPE_UC] = {
+		.name		= "uc",
+		.size		= sizeof(struct rvt_ucontext),
+	},
+	[RVT_TYPE_PD] = {
+		.name		= "pd",
+		.size		= sizeof(struct rvt_pd),
+	},
+	[RVT_TYPE_AH] = {
+		.name		= "ah",
+		.size		= sizeof(struct rvt_ah),
+		.flags		= RVT_POOL_ATOMIC,
+	},
+	[RVT_TYPE_SRQ] = {
+		.name		= "srq",
+		.size		= sizeof(struct rvt_srq),
+		.flags		= RVT_POOL_INDEX,
+		.min_index	= RVT_MIN_SRQ_INDEX,
+		.max_index	= RVT_MAX_SRQ_INDEX,
+	},
+	[RVT_TYPE_QP] = {
+		.name		= "qp",
+		.size		= sizeof(struct rvt_qp),
+		.cleanup	= rvt_qp_cleanup,
+		.flags		= RVT_POOL_INDEX,
+		.min_index	= RVT_MIN_QP_INDEX,
+		.max_index	= RVT_MAX_QP_INDEX,
+	},
+	[RVT_TYPE_CQ] = {
+		.name		= "cq",
+		.size		= sizeof(struct rvt_cq),
+		.cleanup	= rvt_cq_cleanup,
+	},
+	[RVT_TYPE_MR] = {
+		.name		= "mr",
+		.size		= sizeof(struct rvt_mem),
+		.cleanup	= rvt_mem_cleanup,
+		.flags		= RVT_POOL_INDEX,
+		.max_index	= RVT_MAX_MR_INDEX,
+		.min_index	= RVT_MIN_MR_INDEX,
+	},
+	[RVT_TYPE_FMR] = {
+		.name		= "fmr",
+		.size		= sizeof(struct rvt_mem),
+		.cleanup	= rvt_mem_cleanup,
+		.flags		= RVT_POOL_INDEX,
+		.max_index	= RVT_MAX_FMR_INDEX,
+		.min_index	= RVT_MIN_FMR_INDEX,
+	},
+	[RVT_TYPE_MW] = {
+		.name		= "mw",
+		.size		= sizeof(struct rvt_mem),
+		.flags		= RVT_POOL_INDEX,
+		.max_index	= RVT_MAX_MW_INDEX,
+		.min_index	= RVT_MIN_MW_INDEX,
+	},
+	[RVT_TYPE_MC_GRP] = {
+		.name		= "mc_grp",
+		.size		= sizeof(struct rvt_mc_grp),
+		.cleanup	= rvt_mc_cleanup,
+		.flags		= RVT_POOL_KEY,
+		.key_offset	= offsetof(struct rvt_mc_grp, mgid),
+		.key_size	= sizeof(union ib_gid),
+	},
+	[RVT_TYPE_MC_ELEM] = {
+		.name		= "mc_elem",
+		.size		= sizeof(struct rvt_mc_elem),
+		.flags		= RVT_POOL_ATOMIC,
+	},
+};
+
+static inline char *pool_name(struct rvt_pool *pool)
+{
+	return rvt_type_info[pool->type].name;
+}
+
+static inline struct kmem_cache *pool_cache(struct rvt_pool *pool)
+{
+	return rvt_type_info[pool->type].cache;
+}
+
+static inline enum rvt_elem_type rvt_type(void *arg)
+{
+	struct rvt_pool_entry *elem = arg;
+
+	return elem->pool->type;
+}
+
+int __init rvt_cache_init(void)
+{
+	int err;
+	int i;
+	size_t size;
+	struct rvt_type_info *type;
+
+	for (i = 0; i < RVT_NUM_TYPES; i++) {
+		type = &rvt_type_info[i];
+		size = ALIGN(type->size, RVT_POOL_ALIGN);
+		type->cache = kmem_cache_create(type->name, size,
+				RVT_POOL_ALIGN,
+				RVT_POOL_CACHE_FLAGS, NULL);
+		if (!type->cache) {
+			pr_err("Unable to init kmem cache for %s\n",
+				type->name);
+			err = -ENOMEM;
+			goto err1;
+		}
+	}
+
+	return 0;
+
+err1:
+	while (--i >= 0) {
+		kmem_cache_destroy(type->cache);
+		type->cache = NULL;
+	}
+
+	return err;
+}
+
+void __exit rvt_cache_exit(void)
+{
+	int i;
+	struct rvt_type_info *type;
+
+	for (i = 0; i < RVT_NUM_TYPES; i++) {
+		type = &rvt_type_info[i];
+		kmem_cache_destroy(type->cache);
+		type->cache = NULL;
+	}
+}
+
+static int rvt_pool_init_index(struct rvt_pool *pool, u32 max, u32 min)
+{
+	int err = 0;
+	size_t size;
+
+	if ((max - min + 1) < pool->max_elem) {
+		pr_warn("not enough indices for max_elem\n");
+		err = -EINVAL;
+		goto out;
+	}
+
+	pool->max_index = max;
+	pool->min_index = min;
+
+	size = BITS_TO_LONGS(max - min + 1) * sizeof(long);
+	pool->table = kmalloc(size, GFP_KERNEL);
+	if (!pool->table) {
+		pr_warn("no memory for bit table\n");
+		err = -ENOMEM;
+		goto out;
+	}
+
+	pool->table_size = size;
+	bitmap_zero(pool->table, max - min + 1);
+
+out:
+	return err;
+}
+
+int rvt_pool_init(
+	struct rvt_dev		*rvt,
+	struct rvt_pool		*pool,
+	enum rvt_elem_type	type,
+	unsigned		max_elem)
+{
+	int			err = 0;
+	size_t			size = rvt_type_info[type].size;
+
+	memset(pool, 0, sizeof(*pool));
+
+	pool->rvt		= rvt;
+	pool->type		= type;
+	pool->max_elem		= max_elem;
+	pool->elem_size		= ALIGN(size, RVT_POOL_ALIGN);
+	pool->flags		= rvt_type_info[type].flags;
+	pool->tree		= RB_ROOT;
+	pool->cleanup		= rvt_type_info[type].cleanup;
+
+	atomic_set(&pool->num_elem, 0);
+
+	kref_init(&pool->ref_cnt);
+
+	spin_lock_init(&pool->pool_lock);
+
+	if (rvt_type_info[type].flags & RVT_POOL_INDEX) {
+		err = rvt_pool_init_index(pool,
+					  rvt_type_info[type].max_index,
+					  rvt_type_info[type].min_index);
+		if (err)
+			goto out;
+	}
+
+	if (rvt_type_info[type].flags & RVT_POOL_KEY) {
+		pool->key_offset = rvt_type_info[type].key_offset;
+		pool->key_size = rvt_type_info[type].key_size;
+	}
+
+	pool->state = rvt_pool_valid;
+
+out:
+	return err;
+}
+
+static void rvt_pool_release(struct kref *kref)
+{
+	struct rvt_pool *pool = container_of(kref, struct rvt_pool, ref_cnt);
+
+	pool->state = rvt_pool_invalid;
+	kfree(pool->table);
+}
+
+void rvt_pool_put(struct rvt_pool *pool)
+{
+	kref_put(&pool->ref_cnt, rvt_pool_release);
+}
+
+
+int rvt_pool_cleanup(struct rvt_pool *pool)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&pool->pool_lock, flags);
+	pool->state = rvt_pool_invalid;
+	spin_unlock_irqrestore(&pool->pool_lock, flags);
+
+	if (atomic_read(&pool->num_elem) > 0)
+		pr_warn("%s pool destroyed with unfree'd elem\n",
+			pool_name(pool));
+
+	rvt_pool_put(pool);
+
+	return 0;
+}
+
+static u32 alloc_index(struct rvt_pool *pool)
+{
+	u32 index;
+	u32 range = pool->max_index - pool->min_index + 1;
+
+	index = find_next_zero_bit(pool->table, range, pool->last);
+	if (index >= range)
+		index = find_first_zero_bit(pool->table, range);
+
+	set_bit(index, pool->table);
+	pool->last = index;
+	return index + pool->min_index;
+}
+
+static void insert_index(struct rvt_pool *pool, struct rvt_pool_entry *new)
+{
+	struct rb_node **link = &pool->tree.rb_node;
+	struct rb_node *parent = NULL;
+	struct rvt_pool_entry *elem;
+
+	while (*link) {
+		parent = *link;
+		elem = rb_entry(parent, struct rvt_pool_entry, node);
+
+		if (elem->index == new->index) {
+			pr_warn("element already exists!\n");
+			goto out;
+		}
+
+		if (elem->index > new->index)
+			link = &(*link)->rb_left;
+		else
+			link = &(*link)->rb_right;
+	}
+
+	rb_link_node(&new->node, parent, link);
+	rb_insert_color(&new->node, &pool->tree);
+out:
+	return;
+}
+
+static void insert_key(struct rvt_pool *pool, struct rvt_pool_entry *new)
+{
+	struct rb_node **link = &pool->tree.rb_node;
+	struct rb_node *parent = NULL;
+	struct rvt_pool_entry *elem;
+	int cmp;
+
+	while (*link) {
+		parent = *link;
+		elem = rb_entry(parent, struct rvt_pool_entry, node);
+
+		cmp = memcmp((u8 *)elem + pool->key_offset,
+			     (u8 *)new + pool->key_offset, pool->key_size);
+
+		if (cmp == 0) {
+			pr_warn("key already exists!\n");
+			goto out;
+		}
+
+		if (cmp > 0)
+			link = &(*link)->rb_left;
+		else
+			link = &(*link)->rb_right;
+	}
+
+	rb_link_node(&new->node, parent, link);
+	rb_insert_color(&new->node, &pool->tree);
+out:
+	return;
+}
+
+void rvt_add_key(void *arg, void *key)
+{
+	struct rvt_pool_entry *elem = arg;
+	struct rvt_pool *pool = elem->pool;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pool->pool_lock, flags);
+	memcpy((u8 *)elem + pool->key_offset, key, pool->key_size);
+	insert_key(pool, elem);
+	spin_unlock_irqrestore(&pool->pool_lock, flags);
+}
+
+void rvt_drop_key(void *arg)
+{
+	struct rvt_pool_entry *elem = arg;
+	struct rvt_pool *pool = elem->pool;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pool->pool_lock, flags);
+	rb_erase(&elem->node, &pool->tree);
+	spin_unlock_irqrestore(&pool->pool_lock, flags);
+}
+
+void rvt_add_index(void *arg)
+{
+	struct rvt_pool_entry *elem = arg;
+	struct rvt_pool *pool = elem->pool;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pool->pool_lock, flags);
+	elem->index = alloc_index(pool);
+	insert_index(pool, elem);
+	spin_unlock_irqrestore(&pool->pool_lock, flags);
+}
+
+void rvt_drop_index(void *arg)
+{
+	struct rvt_pool_entry *elem = arg;
+	struct rvt_pool *pool = elem->pool;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pool->pool_lock, flags);
+	clear_bit(elem->index - pool->min_index, pool->table);
+	rb_erase(&elem->node, &pool->tree);
+	spin_unlock_irqrestore(&pool->pool_lock, flags);
+}
+
+void *rvt_alloc(struct rvt_pool *pool)
+{
+	struct rvt_pool_entry *elem;
+	unsigned long flags;
+
+	might_sleep_if(!(pool->flags & RVT_POOL_ATOMIC));
+
+	spin_lock_irqsave(&pool->pool_lock, flags);
+	if (pool->state != rvt_pool_valid) {
+		spin_unlock_irqrestore(&pool->pool_lock, flags);
+		return NULL;
+	}
+	kref_get(&pool->ref_cnt);
+	spin_unlock_irqrestore(&pool->pool_lock, flags);
+
+	kref_get(&pool->rvt->ref_cnt);
+
+	if (atomic_inc_return(&pool->num_elem) > pool->max_elem) {
+		atomic_dec(&pool->num_elem);
+		rvt_dev_put(pool->rvt);
+		rvt_pool_put(pool);
+		return NULL;
+	}
+
+	elem = kmem_cache_zalloc(pool_cache(pool),
+				 (pool->flags & RVT_POOL_ATOMIC) ?
+				 GFP_ATOMIC : GFP_KERNEL);
+
+	elem->pool = pool;
+	kref_init(&elem->ref_cnt);
+
+	return elem;
+}
+
+void rvt_elem_release(struct kref *kref)
+{
+	struct rvt_pool_entry *elem =
+		container_of(kref, struct rvt_pool_entry, ref_cnt);
+	struct rvt_pool *pool = elem->pool;
+
+	if (pool->cleanup)
+		pool->cleanup(elem);
+
+	kmem_cache_free(pool_cache(pool), elem);
+	atomic_dec(&pool->num_elem);
+	rvt_dev_put(pool->rvt);
+	rvt_pool_put(pool);
+}
+
+void *rvt_pool_get_index(struct rvt_pool *pool, u32 index)
+{
+	struct rb_node *node = NULL;
+	struct rvt_pool_entry *elem = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pool->pool_lock, flags);
+
+	if (pool->state != rvt_pool_valid)
+		goto out;
+
+	node = pool->tree.rb_node;
+
+	while (node) {
+		elem = rb_entry(node, struct rvt_pool_entry, node);
+
+		if (elem->index > index)
+			node = node->rb_left;
+		else if (elem->index < index)
+			node = node->rb_right;
+		else
+			break;
+	}
+
+	if (node)
+		kref_get(&elem->ref_cnt);
+
+out:
+	spin_unlock_irqrestore(&pool->pool_lock, flags);
+	return node ? (void *)elem : NULL;
+}
+
+void *rvt_pool_get_key(struct rvt_pool *pool, void *key)
+{
+	struct rb_node *node = NULL;
+	struct rvt_pool_entry *elem = NULL;
+	int cmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pool->pool_lock, flags);
+
+	if (pool->state != rvt_pool_valid)
+		goto out;
+
+	node = pool->tree.rb_node;
+
+	while (node) {
+		elem = rb_entry(node, struct rvt_pool_entry, node);
+
+		cmp = memcmp((u8 *)elem + pool->key_offset,
+			     key, pool->key_size);
+
+		if (cmp > 0)
+			node = node->rb_left;
+		else if (cmp < 0)
+			node = node->rb_right;
+		else
+			break;
+	}
+
+	if (node)
+		kref_get(&elem->ref_cnt);
+
+out:
+	spin_unlock_irqrestore(&pool->pool_lock, flags);
+	return node ? ((void *)elem) : NULL;
+}
diff --git a/drivers/infiniband/sw/rdmavt/rvt_pool.h b/drivers/infiniband/sw/rdmavt/rvt_pool.h
new file mode 100644
index 0000000..71f0030
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_pool.h
@@ -0,0 +1,98 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *	   Redistribution and use in source and binary forms, with or
+ *	   without modification, are permitted provided that the following
+ *	   conditions are met:
+ *
+ *		- Redistributions of source code must retain the above
+ *		  copyright notice, this list of conditions and the following
+ *		  disclaimer.
+ *
+ *		- Redistributions in binary form must reproduce the above
+ *		  copyright notice, this list of conditions and the following
+ *		  disclaimer in the documentation and/or other materials
+ *		  provided with the distribution.
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
+#ifndef RVT_POOL_H
+#define RVT_POOL_H
+
+struct rvt_type_info {
+	char			*name;
+	size_t			size;
+	void			(*cleanup)(void *obj);
+	enum rvt_pool_flags	flags;
+	u32			max_index;
+	u32			min_index;
+	size_t			key_offset;
+	size_t			key_size;
+	struct kmem_cache	*cache;
+};
+
+extern struct rvt_type_info rvt_type_info[];
+
+/* initialize slab caches for managed objects */
+int __init rvt_cache_init(void);
+
+/* cleanup slab caches for managed objects */
+void __exit rvt_cache_exit(void);
+
+/* initialize a pool of objects with given limit on
+   number of elements. gets parameters from rvt_type_info
+   pool elements will be allocated out of a slab cache */
+int rvt_pool_init(struct rvt_dev *rvt, struct rvt_pool *pool,
+		  enum rvt_elem_type type, u32 max_elem);
+
+/* free resources from object pool */
+int rvt_pool_cleanup(struct rvt_pool *pool);
+
+/* allocate an object from pool */
+void *rvt_alloc(struct rvt_pool *pool);
+
+/* assign an index to an indexed object and insert object into
+   pool's rb tree */
+void rvt_add_index(void *elem);
+
+/* drop an index and remove object from rb tree */
+void rvt_drop_index(void *elem);
+
+/* assign a key to a keyed object and insert object into
+   pool's rb tree */
+void rvt_add_key(void *elem, void *key);
+
+/* remove elem from rb tree */
+void rvt_drop_key(void *elem);
+
+/* lookup an indexed object from index. takes a reference on object */
+void *rvt_pool_get_index(struct rvt_pool *pool, u32 index);
+
+/* lookup keyed object from key. takes a reference on the object */
+void *rvt_pool_get_key(struct rvt_pool *pool, void *key);
+
+/* cleanup an object when all references are dropped */
+void rvt_elem_release(struct kref *kref);
+
+/* take a reference on an object */
+#define rvt_add_ref(elem) kref_get(&(elem)->pelem.ref_cnt)
+
+/* drop a reference on an object */
+#define rvt_drop_ref(elem) kref_put(&(elem)->pelem.ref_cnt, rvt_elem_release)
+
+#endif /* RVT_POOL_H */
diff --git a/drivers/infiniband/sw/rdmavt/rvt_qp.c b/drivers/infiniband/sw/rdmavt/rvt_qp.c
new file mode 100644
index 0000000..847c6bd
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_qp.c
@@ -0,0 +1,836 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *	   Redistribution and use in source and binary forms, with or
+ *	   without modification, are permitted provided that the following
+ *	   conditions are met:
+ *
+ *		- Redistributions of source code must retain the above
+ *		  copyright notice, this list of conditions and the following
+ *		  disclaimer.
+ *
+ *		- Redistributions in binary form must reproduce the above
+ *		  copyright notice, this list of conditions and the following
+ *		  disclaimer in the documentation and/or other materials
+ *		  provided with the distribution.
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
+#include <linux/skbuff.h>
+#include <linux/delay.h>
+#include <linux/sched.h>
+
+#include "rvt_loc.h"
+#include "rvt_queue.h"
+#include "rvt_task.h"
+
+char *rvt_qp_state_name[] = {
+	[QP_STATE_RESET]	= "RESET",
+	[QP_STATE_INIT]		= "INIT",
+	[QP_STATE_READY]	= "READY",
+	[QP_STATE_DRAIN]	= "DRAIN",
+	[QP_STATE_DRAINED]	= "DRAINED",
+	[QP_STATE_ERROR]	= "ERROR",
+};
+
+static int rvt_qp_chk_cap(struct rvt_dev *rvt, struct ib_qp_cap *cap,
+			  int has_srq)
+{
+	if (cap->max_send_wr > rvt->attr.max_qp_wr) {
+		pr_warn("invalid send wr = %d > %d\n",
+			cap->max_send_wr, rvt->attr.max_qp_wr);
+		goto err1;
+	}
+
+	if (cap->max_send_sge > rvt->attr.max_sge) {
+		pr_warn("invalid send sge = %d > %d\n",
+			cap->max_send_sge, rvt->attr.max_sge);
+		goto err1;
+	}
+
+	if (!has_srq) {
+		if (cap->max_recv_wr > rvt->attr.max_qp_wr) {
+			pr_warn("invalid recv wr = %d > %d\n",
+				cap->max_recv_wr, rvt->attr.max_qp_wr);
+			goto err1;
+		}
+
+		if (cap->max_recv_sge > rvt->attr.max_sge) {
+			pr_warn("invalid recv sge = %d > %d\n",
+				cap->max_recv_sge, rvt->attr.max_sge);
+			goto err1;
+		}
+	}
+
+	if (cap->max_inline_data > rvt->max_inline_data) {
+		pr_warn("invalid max inline data = %d > %d\n",
+			cap->max_inline_data, rvt->max_inline_data);
+		goto err1;
+	}
+
+	return 0;
+
+err1:
+	return -EINVAL;
+}
+
+int rvt_qp_chk_init(struct rvt_dev *rvt, struct ib_qp_init_attr *init)
+{
+	struct ib_qp_cap *cap = &init->cap;
+	struct rvt_port *port;
+	int port_num = init->port_num;
+
+	if (!init->recv_cq || !init->send_cq) {
+		pr_warn("missing cq\n");
+		goto err1;
+	}
+
+	if (rvt_qp_chk_cap(rvt, cap, !!init->srq))
+		goto err1;
+
+	if (init->qp_type == IB_QPT_SMI || init->qp_type == IB_QPT_GSI) {
+		if (port_num < 1 || port_num > rvt->num_ports) {
+			pr_warn("invalid port = %d\n", port_num);
+			goto err1;
+		}
+
+		port = &rvt->port[port_num - 1];
+
+		if (init->qp_type == IB_QPT_SMI && port->qp_smi_index) {
+			pr_warn("SMI QP exists for port %d\n", port_num);
+			goto err1;
+		}
+
+		if (init->qp_type == IB_QPT_GSI && port->qp_gsi_index) {
+			pr_warn("GSI QP exists for port %d\n", port_num);
+			goto err1;
+		}
+	}
+
+	return 0;
+
+err1:
+	return -EINVAL;
+}
+
+static int alloc_rd_atomic_resources(struct rvt_qp *qp, unsigned int n)
+{
+	qp->resp.res_head = 0;
+	qp->resp.res_tail = 0;
+	qp->resp.resources = kcalloc(n, sizeof(struct resp_res), GFP_KERNEL);
+
+	if (!qp->resp.resources)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void free_rd_atomic_resources(struct rvt_qp *qp)
+{
+	if (qp->resp.resources) {
+		int i;
+
+		for (i = 0; i < qp->attr.max_rd_atomic; i++) {
+			struct resp_res *res = &qp->resp.resources[i];
+
+			free_rd_atomic_resource(qp, res);
+		}
+		kfree(qp->resp.resources);
+		qp->resp.resources = NULL;
+	}
+}
+
+void free_rd_atomic_resource(struct rvt_qp *qp, struct resp_res *res)
+{
+	if (res->type == RVT_ATOMIC_MASK) {
+		rvt_drop_ref(qp);
+		kfree_skb(res->atomic.skb);
+	} else if (res->type == RVT_READ_MASK) {
+		if (res->read.mr)
+			rvt_drop_ref(res->read.mr);
+	}
+	res->type = 0;
+}
+
+static void cleanup_rd_atomic_resources(struct rvt_qp *qp)
+{
+	int i;
+	struct resp_res *res;
+
+	if (qp->resp.resources) {
+		for (i = 0; i < qp->attr.max_rd_atomic; i++) {
+			res = &qp->resp.resources[i];
+			free_rd_atomic_resource(qp, res);
+		}
+	}
+}
+
+static void rvt_qp_init_misc(struct rvt_dev *rvt, struct rvt_qp *qp,
+			     struct ib_qp_init_attr *init)
+{
+	struct rvt_port *port;
+	u32 qpn;
+
+	qp->sq_sig_type		= init->sq_sig_type;
+	qp->attr.path_mtu	= 1;
+	qp->mtu			= 256;
+
+	qpn			= qp->pelem.index;
+	port			= &rvt->port[init->port_num - 1];
+
+	switch (init->qp_type) {
+	case IB_QPT_SMI:
+		qp->ibqp.qp_num		= 0;
+		port->qp_smi_index	= qpn;
+		qp->attr.port_num	= init->port_num;
+		break;
+
+	case IB_QPT_GSI:
+		qp->ibqp.qp_num		= 1;
+		port->qp_gsi_index	= qpn;
+		qp->attr.port_num	= init->port_num;
+		break;
+
+	default:
+		qp->ibqp.qp_num		= qpn;
+		break;
+	}
+
+	INIT_LIST_HEAD(&qp->grp_list);
+
+	skb_queue_head_init(&qp->send_pkts);
+
+	spin_lock_init(&qp->grp_lock);
+	spin_lock_init(&qp->state_lock);
+
+	atomic_set(&qp->ssn, 0);
+	atomic_set(&qp->skb_out, 0);
+}
+
+static int rvt_qp_init_req(struct rvt_dev *rdev, struct rvt_qp *qp,
+			   struct ib_qp_init_attr *init,
+			   struct ib_ucontext *context, struct ib_udata *udata)
+{
+	int err;
+	int wqe_size;
+
+	err = rdev->ifc_ops->create_flow(rdev, &qp->flow, &qp);
+	if (err)
+		return err;
+
+	qp->sq.max_wr		= init->cap.max_send_wr;
+	qp->sq.max_sge		= init->cap.max_send_sge;
+	qp->sq.max_inline	= init->cap.max_inline_data;
+
+	wqe_size = max_t(int, sizeof(struct rvt_send_wqe) +
+			 qp->sq.max_sge * sizeof(struct ib_sge),
+			 sizeof(struct rvt_send_wqe) +
+			 qp->sq.max_inline);
+
+	qp->sq.queue		= rvt_queue_init(rdev,
+						 &qp->sq.max_wr,
+						 wqe_size);
+	if (!qp->sq.queue)
+		return -ENOMEM;
+
+	err = do_mmap_info(rdev, udata, true,
+			   context, qp->sq.queue->buf,
+			   qp->sq.queue->buf_size, &qp->sq.queue->ip);
+
+	if (err) {
+		kvfree(qp->sq.queue->buf);
+		kfree(qp->sq.queue);
+		return err;
+	}
+
+	qp->req.wqe_index	= producer_index(qp->sq.queue);
+	qp->req.state		= QP_STATE_RESET;
+	qp->req.opcode		= -1;
+	qp->comp.opcode		= -1;
+
+	spin_lock_init(&qp->sq.sq_lock);
+	skb_queue_head_init(&qp->req_pkts);
+
+	rvt_init_task(rdev, &qp->req.task, qp,
+		      rvt_requester, "req");
+	rvt_init_task(rdev, &qp->comp.task, qp,
+		      rvt_completer, "comp");
+
+	init_timer(&qp->rnr_nak_timer);
+	qp->rnr_nak_timer.function = rnr_nak_timer;
+	qp->rnr_nak_timer.data = (unsigned long)qp;
+
+	init_timer(&qp->retrans_timer);
+	qp->retrans_timer.function = retransmit_timer;
+	qp->retrans_timer.data = (unsigned long)qp;
+	qp->qp_timeout_jiffies = 0; /* Can't be set for UD/UC in modify_qp */
+
+	return 0;
+}
+
+static int rvt_qp_init_resp(struct rvt_dev *rdev, struct rvt_qp *qp,
+			    struct ib_qp_init_attr *init,
+			    struct ib_ucontext *context, struct ib_udata *udata)
+{
+	int err;
+	int wqe_size;
+
+	if (!qp->srq) {
+		qp->rq.max_wr		= init->cap.max_recv_wr;
+		qp->rq.max_sge		= init->cap.max_recv_sge;
+
+		wqe_size = rcv_wqe_size(qp->rq.max_sge);
+
+		pr_debug("max_wr = %d, max_sge = %d, wqe_size = %d\n",
+			 qp->rq.max_wr, qp->rq.max_sge, wqe_size);
+
+		qp->rq.queue		= rvt_queue_init(rdev,
+						&qp->rq.max_wr,
+						wqe_size);
+		if (!qp->rq.queue)
+			return -ENOMEM;
+
+		err = do_mmap_info(rdev, udata, false, context,
+				   qp->rq.queue->buf,
+				   qp->rq.queue->buf_size,
+				   &qp->rq.queue->ip);
+		if (err) {
+			kvfree(qp->rq.queue->buf);
+			kfree(qp->rq.queue);
+			return err;
+		}
+	}
+
+	spin_lock_init(&qp->rq.producer_lock);
+	spin_lock_init(&qp->rq.consumer_lock);
+
+	skb_queue_head_init(&qp->resp_pkts);
+
+	rvt_init_task(rdev, &qp->resp.task, qp,
+		      rvt_responder, "resp");
+
+	qp->resp.opcode		= OPCODE_NONE;
+	qp->resp.msn		= 0;
+	qp->resp.state		= QP_STATE_RESET;
+
+	return 0;
+}
+
+/* called by the create qp verb */
+int rvt_qp_from_init(struct rvt_dev *rdev, struct rvt_qp *qp, struct rvt_pd *pd,
+		     struct ib_qp_init_attr *init, struct ib_udata *udata,
+		     struct ib_pd *ibpd)
+{
+	int err;
+	struct rvt_cq *rcq = to_rcq(init->recv_cq);
+	struct rvt_cq *scq = to_rcq(init->send_cq);
+	struct rvt_srq *srq = init->srq ? to_rsrq(init->srq) : NULL;
+	struct ib_ucontext *context = udata ? ibpd->uobject->context : NULL;
+
+	rvt_add_ref(pd);
+	rvt_add_ref(rcq);
+	rvt_add_ref(scq);
+	if (srq)
+		rvt_add_ref(srq);
+
+	qp->pd			= pd;
+	qp->rcq			= rcq;
+	qp->scq			= scq;
+	qp->srq			= srq;
+
+	rvt_qp_init_misc(rdev, qp, init);
+
+	err = rvt_qp_init_req(rdev, qp, init, context, udata);
+	if (err)
+		goto err1;
+
+	err = rvt_qp_init_resp(rdev, qp, init, context, udata);
+	if (err)
+		goto err2;
+
+	qp->attr.qp_state = IB_QPS_RESET;
+	qp->valid = 1;
+
+	return 0;
+
+err2:
+	rvt_queue_cleanup(qp->sq.queue);
+err1:
+	if (srq)
+		rvt_drop_ref(srq);
+	rvt_drop_ref(scq);
+	rvt_drop_ref(rcq);
+	rvt_drop_ref(pd);
+
+	return err;
+}
+
+/* called by the query qp verb */
+int rvt_qp_to_init(struct rvt_qp *qp, struct ib_qp_init_attr *init)
+{
+	init->event_handler		= qp->ibqp.event_handler;
+	init->qp_context		= qp->ibqp.qp_context;
+	init->send_cq			= qp->ibqp.send_cq;
+	init->recv_cq			= qp->ibqp.recv_cq;
+	init->srq			= qp->ibqp.srq;
+
+	init->cap.max_send_wr		= qp->sq.max_wr;
+	init->cap.max_send_sge		= qp->sq.max_sge;
+	init->cap.max_inline_data	= qp->sq.max_inline;
+
+	if (!qp->srq) {
+		init->cap.max_recv_wr		= qp->rq.max_wr;
+		init->cap.max_recv_sge		= qp->rq.max_sge;
+	}
+
+	init->sq_sig_type		= qp->sq_sig_type;
+
+	init->qp_type			= qp->ibqp.qp_type;
+	init->port_num			= 1;
+
+	return 0;
+}
+
+/* called by the modify qp verb, this routine checks all the parameters before
+ * making any changes
+ */
+int rvt_qp_chk_attr(struct rvt_dev *rvt, struct rvt_qp *qp,
+		    struct ib_qp_attr *attr, int mask)
+{
+	enum ib_qp_state cur_state = (mask & IB_QP_CUR_STATE) ?
+					attr->cur_qp_state : qp->attr.qp_state;
+	enum ib_qp_state new_state = (mask & IB_QP_STATE) ?
+					attr->qp_state : cur_state;
+
+	if (!ib_modify_qp_is_ok(cur_state, new_state, qp_type(qp), mask,
+				IB_LINK_LAYER_ETHERNET)) {
+		pr_warn("invalid mask or state for qp\n");
+		goto err1;
+	}
+
+	if (mask & IB_QP_STATE) {
+		if (cur_state == IB_QPS_SQD) {
+			if (qp->req.state == QP_STATE_DRAIN &&
+			    new_state != IB_QPS_ERR)
+				goto err1;
+		}
+	}
+
+	if (mask & IB_QP_PORT) {
+		if (attr->port_num < 1 || attr->port_num > rvt->num_ports) {
+			pr_warn("invalid port %d\n", attr->port_num);
+			goto err1;
+		}
+	}
+
+	if (mask & IB_QP_CAP && rvt_qp_chk_cap(rvt, &attr->cap, !!qp->srq))
+		goto err1;
+
+	if (mask & IB_QP_AV && rvt_av_chk_attr(rvt, &attr->ah_attr))
+		goto err1;
+
+	if (mask & IB_QP_ALT_PATH && rvt_av_chk_attr(rvt, &attr->alt_ah_attr))
+		goto err1;
+
+	if (mask & IB_QP_PATH_MTU) {
+		struct rvt_port *port = &rvt->port[qp->attr.port_num - 1];
+		enum ib_mtu max_mtu = port->attr.max_mtu;
+		enum ib_mtu mtu = attr->path_mtu;
+
+		if (mtu > max_mtu) {
+			pr_debug("invalid mtu (%d) > (%d)\n",
+				 ib_mtu_enum_to_int(mtu),
+				 ib_mtu_enum_to_int(max_mtu));
+			goto err1;
+		}
+	}
+
+	if (mask & IB_QP_MAX_QP_RD_ATOMIC) {
+		if (attr->max_rd_atomic > rvt->attr.max_qp_rd_atom) {
+			pr_warn("invalid max_rd_atomic %d > %d\n",
+				attr->max_rd_atomic,
+				rvt->attr.max_qp_rd_atom);
+			goto err1;
+		}
+	}
+
+	if (mask & IB_QP_TIMEOUT) {
+		if (attr->timeout > 31) {
+			pr_warn("invalid QP timeout %d > 31\n",
+				attr->timeout);
+			goto err1;
+		}
+	}
+
+	return 0;
+
+err1:
+	return -EINVAL;
+}
+
+/* move the qp to the reset state */
+static void rvt_qp_reset(struct rvt_qp *qp)
+{
+	/* stop tasks from running */
+	rvt_disable_task(&qp->resp.task);
+
+	/* stop request/comp */
+	if (qp_type(qp) == IB_QPT_RC)
+		rvt_disable_task(&qp->comp.task);
+	rvt_disable_task(&qp->req.task);
+
+	/* move qp to the reset state */
+	qp->req.state = QP_STATE_RESET;
+	qp->resp.state = QP_STATE_RESET;
+
+	/* let state machines reset themselves drain work and packet queues
+	 * etc.
+	 */
+	__rvt_do_task(&qp->resp.task);
+
+	if (qp->sq.queue) {
+		__rvt_do_task(&qp->comp.task);
+		__rvt_do_task(&qp->req.task);
+	}
+
+	/* cleanup attributes */
+	atomic_set(&qp->ssn, 0);
+	qp->req.opcode = -1;
+	qp->req.need_retry = 0;
+	qp->req.noack_pkts = 0;
+	qp->resp.msn = 0;
+	qp->resp.opcode = -1;
+	qp->resp.drop_msg = 0;
+	qp->resp.goto_error = 0;
+	qp->resp.sent_psn_nak = 0;
+
+	if (qp->resp.mr) {
+		rvt_drop_ref(qp->resp.mr);
+		qp->resp.mr = NULL;
+	}
+
+	cleanup_rd_atomic_resources(qp);
+
+	/* reenable tasks */
+	rvt_enable_task(&qp->resp.task);
+
+	if (qp->sq.queue) {
+		if (qp_type(qp) == IB_QPT_RC)
+			rvt_enable_task(&qp->comp.task);
+
+		rvt_enable_task(&qp->req.task);
+	}
+}
+
+/* drain the send queue */
+static void rvt_qp_drain(struct rvt_qp *qp)
+{
+	if (qp->sq.queue) {
+		if (qp->req.state != QP_STATE_DRAINED) {
+			qp->req.state = QP_STATE_DRAIN;
+			if (qp_type(qp) == IB_QPT_RC)
+				rvt_run_task(&qp->comp.task, 1);
+			else
+				__rvt_do_task(&qp->comp.task);
+			rvt_run_task(&qp->req.task, 1);
+		}
+	}
+}
+
+/* move the qp to the error state */
+void rvt_qp_error(struct rvt_qp *qp)
+{
+	qp->req.state = QP_STATE_ERROR;
+	qp->resp.state = QP_STATE_ERROR;
+
+	/* drain work and packet queues */
+	rvt_run_task(&qp->resp.task, 1);
+
+	if (qp_type(qp) == IB_QPT_RC)
+		rvt_run_task(&qp->comp.task, 1);
+	else
+		__rvt_do_task(&qp->comp.task);
+	rvt_run_task(&qp->req.task, 1);
+}
+
+/* called by the modify qp verb */
+int rvt_qp_from_attr(struct rvt_qp *qp, struct ib_qp_attr *attr, int mask,
+		     struct ib_udata *udata)
+{
+	int err;
+	struct rvt_dev *rvt = to_rdev(qp->ibqp.device);
+	union ib_gid sgid;
+	struct ib_gid_attr sgid_attr;
+
+	if (mask & IB_QP_MAX_QP_RD_ATOMIC) {
+		int max_rd_atomic = __roundup_pow_of_two(attr->max_rd_atomic);
+
+		free_rd_atomic_resources(qp);
+
+		err = alloc_rd_atomic_resources(qp, max_rd_atomic);
+		if (err)
+			return err;
+
+		qp->attr.max_rd_atomic = max_rd_atomic;
+		atomic_set(&qp->req.rd_atomic, max_rd_atomic);
+	}
+
+	if (mask & IB_QP_CUR_STATE)
+		qp->attr.cur_qp_state = attr->qp_state;
+
+	if (mask & IB_QP_EN_SQD_ASYNC_NOTIFY)
+		qp->attr.en_sqd_async_notify = attr->en_sqd_async_notify;
+
+	if (mask & IB_QP_ACCESS_FLAGS)
+		qp->attr.qp_access_flags = attr->qp_access_flags;
+
+	if (mask & IB_QP_PKEY_INDEX)
+		qp->attr.pkey_index = attr->pkey_index;
+
+	if (mask & IB_QP_PORT)
+		qp->attr.port_num = attr->port_num;
+
+	if (mask & IB_QP_QKEY)
+		qp->attr.qkey = attr->qkey;
+
+	if (mask & IB_QP_AV) {
+		rcu_read_lock();
+		ib_get_cached_gid(&rvt->ib_dev, 1,
+				  attr->ah_attr.grh.sgid_index, &sgid,
+				  &sgid_attr);
+		rcu_read_unlock();
+		rvt_av_from_attr(rvt, attr->port_num, &qp->pri_av,
+				 &attr->ah_attr);
+		rvt_av_fill_ip_info(rvt, &qp->pri_av, &attr->ah_attr,
+				    &sgid_attr, &sgid);
+	}
+
+	if (mask & IB_QP_ALT_PATH) {
+		rcu_read_lock();
+		ib_get_cached_gid(&rvt->ib_dev, 1,
+				  attr->alt_ah_attr.grh.sgid_index, &sgid,
+				  &sgid_attr);
+		rcu_read_unlock();
+
+		rvt_av_from_attr(rvt, attr->alt_port_num, &qp->alt_av,
+				 &attr->alt_ah_attr);
+		rvt_av_fill_ip_info(rvt, &qp->alt_av, &attr->alt_ah_attr,
+				    &sgid_attr, &sgid);
+		qp->attr.alt_port_num = attr->alt_port_num;
+		qp->attr.alt_pkey_index = attr->alt_pkey_index;
+		qp->attr.alt_timeout = attr->alt_timeout;
+	}
+
+	if (mask & IB_QP_PATH_MTU) {
+		qp->attr.path_mtu = attr->path_mtu;
+		qp->mtu = ib_mtu_enum_to_int(attr->path_mtu);
+	}
+
+	if (mask & IB_QP_TIMEOUT) {
+		qp->attr.timeout = attr->timeout;
+		if (attr->timeout == 0) {
+			qp->qp_timeout_jiffies = 0;
+		} else {
+			int j = usecs_to_jiffies(4ULL << attr->timeout);
+
+			qp->qp_timeout_jiffies = j ? j : 1;
+		}
+	}
+
+	if (mask & IB_QP_RETRY_CNT) {
+		qp->attr.retry_cnt = attr->retry_cnt;
+		qp->comp.retry_cnt = attr->retry_cnt;
+		pr_debug("set retry count = %d\n", attr->retry_cnt);
+	}
+
+	if (mask & IB_QP_RNR_RETRY) {
+		qp->attr.rnr_retry = attr->rnr_retry;
+		qp->comp.rnr_retry = attr->rnr_retry;
+		pr_debug("set rnr retry count = %d\n", attr->rnr_retry);
+	}
+
+	if (mask & IB_QP_RQ_PSN) {
+		qp->attr.rq_psn = (attr->rq_psn & BTH_PSN_MASK);
+		qp->resp.psn = qp->attr.rq_psn;
+		pr_debug("set resp psn = 0x%x\n", qp->resp.psn);
+	}
+
+	if (mask & IB_QP_MIN_RNR_TIMER) {
+		qp->attr.min_rnr_timer = attr->min_rnr_timer;
+		pr_debug("set min rnr timer = 0x%x\n",
+			 attr->min_rnr_timer);
+	}
+
+	if (mask & IB_QP_SQ_PSN) {
+		qp->attr.sq_psn = (attr->sq_psn & BTH_PSN_MASK);
+		qp->req.psn = qp->attr.sq_psn;
+		qp->comp.psn = qp->attr.sq_psn;
+		pr_debug("set req psn = 0x%x\n", qp->req.psn);
+	}
+
+	if (mask & IB_QP_MAX_DEST_RD_ATOMIC) {
+		qp->attr.max_dest_rd_atomic =
+			__roundup_pow_of_two(attr->max_dest_rd_atomic);
+	}
+
+	if (mask & IB_QP_PATH_MIG_STATE)
+		qp->attr.path_mig_state = attr->path_mig_state;
+
+	if (mask & IB_QP_DEST_QPN)
+		qp->attr.dest_qp_num = attr->dest_qp_num;
+
+	if (mask & IB_QP_STATE) {
+		qp->attr.qp_state = attr->qp_state;
+
+		switch (attr->qp_state) {
+		case IB_QPS_RESET:
+			pr_debug("qp state -> RESET\n");
+			rvt_qp_reset(qp);
+			break;
+
+		case IB_QPS_INIT:
+			pr_debug("qp state -> INIT\n");
+			qp->req.state = QP_STATE_INIT;
+			qp->resp.state = QP_STATE_INIT;
+			break;
+
+		case IB_QPS_RTR:
+			pr_debug("qp state -> RTR\n");
+			qp->resp.state = QP_STATE_READY;
+			break;
+
+		case IB_QPS_RTS:
+			pr_debug("qp state -> RTS\n");
+			qp->req.state = QP_STATE_READY;
+			break;
+
+		case IB_QPS_SQD:
+			pr_debug("qp state -> SQD\n");
+			rvt_qp_drain(qp);
+			break;
+
+		case IB_QPS_SQE:
+			pr_warn("qp state -> SQE !!?\n");
+			/* Not possible from modify_qp. */
+			break;
+
+		case IB_QPS_ERR:
+			pr_debug("qp state -> ERR\n");
+			rvt_qp_error(qp);
+			break;
+		}
+	}
+
+	return 0;
+}
+
+/* called by the query qp verb */
+int rvt_qp_to_attr(struct rvt_qp *qp, struct ib_qp_attr *attr, int mask)
+{
+	struct rvt_dev *rvt = to_rdev(qp->ibqp.device);
+
+	*attr = qp->attr;
+
+	attr->rq_psn				= qp->resp.psn;
+	attr->sq_psn				= qp->req.psn;
+
+	attr->cap.max_send_wr			= qp->sq.max_wr;
+	attr->cap.max_send_sge			= qp->sq.max_sge;
+	attr->cap.max_inline_data		= qp->sq.max_inline;
+
+	if (!qp->srq) {
+		attr->cap.max_recv_wr		= qp->rq.max_wr;
+		attr->cap.max_recv_sge		= qp->rq.max_sge;
+	}
+
+	rvt_av_to_attr(rvt, &qp->pri_av, &attr->ah_attr);
+	rvt_av_to_attr(rvt, &qp->alt_av, &attr->alt_ah_attr);
+
+	if (qp->req.state == QP_STATE_DRAIN) {
+		attr->sq_draining = 1;
+		/* applications that get this state
+		 * typically spin on it. yield the
+		 * processor
+		 */
+		cond_resched();
+	} else {
+		attr->sq_draining = 0;
+	}
+
+	pr_debug("attr->sq_draining = %d\n", attr->sq_draining);
+
+	return 0;
+}
+
+/* called by the destroy qp verb */
+void rvt_qp_destroy(struct rvt_qp *qp)
+{
+	qp->valid = 0;
+	qp->qp_timeout_jiffies = 0;
+	rvt_cleanup_task(&qp->resp.task);
+
+	del_timer_sync(&qp->retrans_timer);
+	del_timer_sync(&qp->rnr_nak_timer);
+
+	rvt_cleanup_task(&qp->req.task);
+	if (qp_type(qp) == IB_QPT_RC)
+		rvt_cleanup_task(&qp->comp.task);
+
+	/* flush out any receive wr's or pending requests */
+	__rvt_do_task(&qp->req.task);
+	if (qp->sq.queue) {
+		__rvt_do_task(&qp->comp.task);
+		__rvt_do_task(&qp->req.task);
+	}
+}
+
+/* called when the last reference to the qp is dropped */
+void rvt_qp_cleanup(void *arg)
+{
+	struct rvt_qp *qp = arg;
+	struct rvt_dev *rdev;
+
+	rdev = to_rdev(qp->ibqp.device);
+	rvt_drop_all_mcast_groups(qp);
+
+	if (qp->sq.queue)
+		rvt_queue_cleanup(qp->sq.queue);
+
+	if (qp->srq)
+		rvt_drop_ref(qp->srq);
+
+	if (qp->rq.queue)
+		rvt_queue_cleanup(qp->rq.queue);
+
+	if (qp->scq)
+		rvt_drop_ref(qp->scq);
+	if (qp->rcq)
+		rvt_drop_ref(qp->rcq);
+	if (qp->pd)
+		rvt_drop_ref(qp->pd);
+
+	if (qp->resp.mr) {
+		rvt_drop_ref(qp->resp.mr);
+		qp->resp.mr = NULL;
+	}
+
+	free_rd_atomic_resources(qp);
+
+	if (rdev)
+		rdev->ifc_ops->destroy_flow(rdev, qp->flow);
+}
diff --git a/drivers/infiniband/sw/rdmavt/rvt_queue.c b/drivers/infiniband/sw/rdmavt/rvt_queue.c
new file mode 100644
index 0000000..b4f2276
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_queue.c
@@ -0,0 +1,216 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must retailuce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#include <linux/vmalloc.h>
+#include "rvt_loc.h"
+#include "rvt_queue.h"
+
+int do_mmap_info(struct rvt_dev *rvt,
+		 struct ib_udata *udata,
+		 bool is_req,
+		 struct ib_ucontext *context,
+		 struct rvt_queue_buf *buf,
+		 size_t buf_size,
+		 struct rvt_mmap_info **ip_p)
+{
+	int err;
+	u32 len, offset;
+	struct rvt_mmap_info *ip = NULL;
+
+	if (udata) {
+		if (is_req) {
+			len = udata->outlen - sizeof(struct mminfo);
+			offset = sizeof(struct mminfo);
+		} else {
+			len = udata->outlen;
+			offset = 0;
+		}
+
+		if (len < sizeof(ip->info))
+			goto err1;
+
+		ip = rvt_create_mmap_info(rvt, buf_size, context, buf);
+		if (!ip)
+			goto err1;
+
+		err = copy_to_user(udata->outbuf + offset, &ip->info,
+				   sizeof(ip->info));
+		if (err)
+			goto err2;
+
+		spin_lock_bh(&rvt->pending_lock);
+		list_add(&ip->pending_mmaps, &rvt->pending_mmaps);
+		spin_unlock_bh(&rvt->pending_lock);
+	}
+
+	*ip_p = ip;
+
+	return 0;
+
+err2:
+	kfree(ip);
+err1:
+	return -EINVAL;
+}
+
+struct rvt_queue *rvt_queue_init(struct rvt_dev *rvt,
+				 int *num_elem,
+				 unsigned int elem_size)
+{
+	struct rvt_queue *q;
+	size_t buf_size;
+	unsigned int num_slots;
+
+	/* num_elem == 0 is allowed, but uninteresting */
+	if (*num_elem < 0)
+		goto err1;
+
+	q = kmalloc(sizeof(*q), GFP_KERNEL);
+	if (!q)
+		goto err1;
+
+	q->rvt = rvt;
+
+	/* used in resize, only need to copy used part of queue */
+	q->elem_size = elem_size;
+
+	/* pad element up to at least a cacheline and always a power of 2 */
+	if (elem_size < cache_line_size())
+		elem_size = cache_line_size();
+	elem_size = roundup_pow_of_two(elem_size);
+
+	q->log2_elem_size = order_base_2(elem_size);
+
+	num_slots = *num_elem + 1;
+	num_slots = roundup_pow_of_two(num_slots);
+	q->index_mask = num_slots - 1;
+
+	buf_size = sizeof(struct rvt_queue_buf) + num_slots * elem_size;
+
+	q->buf = vmalloc_user(buf_size);
+	if (!q->buf)
+		goto err2;
+
+	q->buf->log2_elem_size = q->log2_elem_size;
+	q->buf->index_mask = q->index_mask;
+
+	q->buf_size = buf_size;
+
+	*num_elem = num_slots - 1;
+	return q;
+
+err2:
+	kfree(q);
+err1:
+	return NULL;
+}
+
+/* copies elements from original q to new q and then swaps the contents of the
+ * two q headers. This is so that if anyone is holding a pointer to q it will
+ * still work
+ */
+static int resize_finish(struct rvt_queue *q, struct rvt_queue *new_q,
+			 unsigned int num_elem)
+{
+	if (!queue_empty(q) && (num_elem < queue_count(q)))
+		return -EINVAL;
+
+	while (!queue_empty(q)) {
+		memcpy(producer_addr(new_q), consumer_addr(q),
+		       new_q->elem_size);
+		advance_producer(new_q);
+		advance_consumer(q);
+	}
+
+	swap(*q, *new_q);
+
+	return 0;
+}
+
+int rvt_queue_resize(struct rvt_queue *q,
+		     unsigned int *num_elem_p,
+		     unsigned int elem_size,
+		     struct ib_ucontext *context,
+		     struct ib_udata *udata,
+		     spinlock_t *producer_lock,
+		     spinlock_t *consumer_lock)
+{
+	struct rvt_queue *new_q;
+	unsigned int num_elem = *num_elem_p;
+	int err;
+	unsigned long flags = 0, flags1;
+
+	new_q = rvt_queue_init(q->rvt, &num_elem, elem_size);
+	if (!new_q)
+		return -ENOMEM;
+
+	err = do_mmap_info(new_q->rvt, udata, false, context, new_q->buf,
+			   new_q->buf_size, &new_q->ip);
+	if (err) {
+		vfree(new_q->buf);
+		kfree(new_q);
+		goto err1;
+	}
+
+	spin_lock_irqsave(consumer_lock, flags1);
+
+	if (producer_lock) {
+		spin_lock_irqsave(producer_lock, flags);
+		err = resize_finish(q, new_q, num_elem);
+		spin_unlock_irqrestore(producer_lock, flags);
+	} else {
+		err = resize_finish(q, new_q, num_elem);
+	}
+
+	spin_unlock_irqrestore(consumer_lock, flags1);
+
+	rvt_queue_cleanup(new_q);	/* new/old dep on err */
+	if (err)
+		goto err1;
+
+	*num_elem_p = num_elem;
+	return 0;
+
+err1:
+	return err;
+}
+
+void rvt_queue_cleanup(struct rvt_queue *q)
+{
+	if (q->ip)
+		kref_put(&q->ip->ref, rvt_mmap_release);
+	else
+		vfree(q->buf);
+
+	kfree(q);
+}
diff --git a/drivers/infiniband/sw/rdmavt/rvt_queue.h b/drivers/infiniband/sw/rdmavt/rvt_queue.h
new file mode 100644
index 0000000..bb1be90
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_queue.h
@@ -0,0 +1,178 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#ifndef RVT_QUEUE_H
+#define RVT_QUEUE_H
+
+/* implements a simple circular buffer that can optionally be
+ * shared between user space and the kernel and can be resized
+
+ * the requested element size is rounded up to a power of 2
+ * and the number of elements in the buffer is also rounded
+ * up to a power of 2. Since the queue is empty when the
+ * producer and consumer indices match the maximum capacity
+ * of the queue is one less than the number of element slots
+ */
+
+/* this data structure is shared between user space and kernel
+ * space for those cases where the queue is shared. It contains
+ * the producer and consumer indices. Is also contains a copy
+ * of the queue size parameters for user space to use but the
+ * kernel must use the parameters in the rvt_queue struct
+ * this MUST MATCH the corresponding librvt struct
+ * for performance reasons arrange to have producer and consumer
+ * pointers in separate cache lines
+ * the kernel should always mask the indices to avoid accessing
+ * memory outside of the data area
+ */
+struct rvt_queue_buf {
+	__u32			log2_elem_size;
+	__u32			index_mask;
+	__u32			pad_1[30];
+	__u32			producer_index;
+	__u32			pad_2[31];
+	__u32			consumer_index;
+	__u32			pad_3[31];
+	__u8			data[0];
+};
+
+struct rvt_queue {
+	struct rvt_dev		*rvt;
+	struct rvt_queue_buf	*buf;
+	struct rvt_mmap_info	*ip;
+	size_t			buf_size;
+	size_t			elem_size;
+	unsigned int		log2_elem_size;
+	unsigned int		index_mask;
+};
+
+int do_mmap_info(struct rvt_dev *rvt,
+		 struct ib_udata *udata,
+		 bool is_req,
+		 struct ib_ucontext *context,
+		 struct rvt_queue_buf *buf,
+		 size_t buf_size,
+		 struct rvt_mmap_info **ip_p);
+
+struct rvt_queue *rvt_queue_init(struct rvt_dev *rvt,
+				 int *num_elem,
+				 unsigned int elem_size);
+
+int rvt_queue_resize(struct rvt_queue *q,
+		     unsigned int *num_elem_p,
+		     unsigned int elem_size,
+		     struct ib_ucontext *context,
+		     struct ib_udata *udata,
+		     /* Protect producers while resizing queue */
+		     spinlock_t *producer_lock,
+		     /* Protect consumers while resizing queue */
+		     spinlock_t *consumer_lock);
+
+void rvt_queue_cleanup(struct rvt_queue *queue);
+
+static inline int next_index(struct rvt_queue *q, int index)
+{
+	return (index + 1) & q->buf->index_mask;
+}
+
+static inline int queue_empty(struct rvt_queue *q)
+{
+	return ((q->buf->producer_index - q->buf->consumer_index)
+			& q->index_mask) == 0;
+}
+
+static inline int queue_full(struct rvt_queue *q)
+{
+	return ((q->buf->producer_index + 1 - q->buf->consumer_index)
+			& q->index_mask) == 0;
+}
+
+static inline void advance_producer(struct rvt_queue *q)
+{
+	q->buf->producer_index = (q->buf->producer_index + 1)
+			& q->index_mask;
+}
+
+static inline void advance_consumer(struct rvt_queue *q)
+{
+	q->buf->consumer_index = (q->buf->consumer_index + 1)
+			& q->index_mask;
+}
+
+static inline void *producer_addr(struct rvt_queue *q)
+{
+	return q->buf->data + ((q->buf->producer_index & q->index_mask)
+				<< q->log2_elem_size);
+}
+
+static inline void *consumer_addr(struct rvt_queue *q)
+{
+	return q->buf->data + ((q->buf->consumer_index & q->index_mask)
+				<< q->log2_elem_size);
+}
+
+static inline unsigned int producer_index(struct rvt_queue *q)
+{
+	return q->buf->producer_index;
+}
+
+static inline unsigned int consumer_index(struct rvt_queue *q)
+{
+	return q->buf->consumer_index;
+}
+
+static inline void *addr_from_index(struct rvt_queue *q, unsigned int index)
+{
+	return q->buf->data + ((index & q->index_mask)
+				<< q->buf->log2_elem_size);
+}
+
+static inline unsigned int index_from_addr(const struct rvt_queue *q,
+					   const void *addr)
+{
+	return (((u8 *)addr - q->buf->data) >> q->log2_elem_size)
+		& q->index_mask;
+}
+
+static inline unsigned int queue_count(const struct rvt_queue *q)
+{
+	return (q->buf->producer_index - q->buf->consumer_index)
+		& q->index_mask;
+}
+
+static inline void *queue_head(struct rvt_queue *q)
+{
+	return queue_empty(q) ? NULL : consumer_addr(q);
+}
+
+#endif /* RVT_QUEUE_H */
diff --git a/drivers/infiniband/sw/rdmavt/rvt_recv.c b/drivers/infiniband/sw/rdmavt/rvt_recv.c
new file mode 100644
index 0000000..2881590
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_recv.c
@@ -0,0 +1,376 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#include <linux/skbuff.h>
+
+#include "rvt_loc.h"
+
+static int check_type_state(struct rvt_dev *rvt, struct rvt_pkt_info *pkt,
+			    struct rvt_qp *qp)
+{
+	if (unlikely(!qp->valid))
+		goto err1;
+
+	switch (qp_type(qp)) {
+	case IB_QPT_RC:
+		if (unlikely((pkt->opcode & IB_OPCODE_RC) != 0)) {
+			pr_warn_ratelimited("bad qp type\n");
+			goto err1;
+		}
+		break;
+	case IB_QPT_UC:
+		if (unlikely(!(pkt->opcode & IB_OPCODE_UC))) {
+			pr_warn_ratelimited("bad qp type\n");
+			goto err1;
+		}
+		break;
+	case IB_QPT_UD:
+	case IB_QPT_SMI:
+	case IB_QPT_GSI:
+		if (unlikely(!(pkt->opcode & IB_OPCODE_UD))) {
+			pr_warn_ratelimited("bad qp type\n");
+			goto err1;
+		}
+		break;
+	default:
+		pr_warn_ratelimited("unsupported qp type\n");
+		goto err1;
+	}
+
+	if (pkt->mask & RVT_REQ_MASK) {
+		if (unlikely(qp->resp.state != QP_STATE_READY))
+			goto err1;
+	} else if (unlikely(qp->req.state < QP_STATE_READY ||
+			qp->req.state > QP_STATE_DRAINED))
+			goto err1;
+
+	return 0;
+
+err1:
+	return -EINVAL;
+}
+
+static void set_bad_pkey_cntr(struct rvt_port *port)
+{
+	spin_lock_bh(&port->port_lock);
+	port->attr.bad_pkey_cntr = min((u32)0xffff,
+				       port->attr.bad_pkey_cntr + 1);
+	spin_unlock_bh(&port->port_lock);
+}
+
+static void set_qkey_viol_cntr(struct rvt_port *port)
+{
+	spin_lock_bh(&port->port_lock);
+	port->attr.qkey_viol_cntr = min((u32)0xffff,
+					port->attr.qkey_viol_cntr + 1);
+	spin_unlock_bh(&port->port_lock);
+}
+
+static int check_keys(struct rvt_dev *rvt, struct rvt_pkt_info *pkt,
+		      u32 qpn, struct rvt_qp *qp)
+{
+	int i;
+	int found_pkey = 0;
+	struct rvt_port *port = &rvt->port[pkt->port_num - 1];
+	u16 pkey = bth_pkey(pkt);
+
+	pkt->pkey_index = 0;
+
+	if (qpn == 1) {
+		for (i = 0; i < port->attr.pkey_tbl_len; i++) {
+			if (pkey_match(pkey, port->pkey_tbl[i])) {
+				pkt->pkey_index = i;
+				found_pkey = 1;
+				break;
+			}
+		}
+
+		if (!found_pkey) {
+			pr_warn_ratelimited("bad pkey = 0x%x\n", pkey);
+			set_bad_pkey_cntr(port);
+			goto err1;
+		}
+	} else if (qpn != 0) {
+		if (unlikely(!pkey_match(pkey,
+					 port->pkey_tbl[qp->attr.pkey_index]
+					))) {
+			pr_warn_ratelimited("bad pkey = 0x%0x\n", pkey);
+			set_bad_pkey_cntr(port);
+			goto err1;
+		}
+		pkt->pkey_index = qp->attr.pkey_index;
+	}
+
+	if ((qp_type(qp) == IB_QPT_UD || qp_type(qp) == IB_QPT_GSI) &&
+	    qpn != 0 && pkt->mask) {
+		u32 qkey = (qpn == 1) ? GSI_QKEY : qp->attr.qkey;
+
+		if (unlikely(deth_qkey(pkt) != qkey)) {
+			pr_warn_ratelimited("bad qkey, got 0x%x expected 0x%x for qpn 0x%x\n",
+				deth_qkey(pkt), qkey, qpn);
+			set_qkey_viol_cntr(port);
+			goto err1;
+		}
+	}
+
+	return 0;
+
+err1:
+	return -EINVAL;
+}
+
+static int check_addr(struct rvt_dev *rvt, struct rvt_pkt_info *pkt,
+		      struct rvt_qp *qp)
+{
+	struct sk_buff *skb = PKT_TO_SKB(pkt);
+
+	if (qp_type(qp) != IB_QPT_RC && qp_type(qp) != IB_QPT_UC)
+		goto done;
+
+	if (unlikely(pkt->port_num != qp->attr.port_num)) {
+		pr_warn_ratelimited("port %d != qp port %d\n",
+			pkt->port_num, qp->attr.port_num);
+		goto err1;
+	}
+
+	if (skb->protocol == htons(ETH_P_IP)) {
+		struct in_addr *saddr =
+			&qp->pri_av.sgid_addr._sockaddr_in.sin_addr;
+		struct in_addr *daddr =
+			&qp->pri_av.dgid_addr._sockaddr_in.sin_addr;
+
+		if (ip_hdr(skb)->daddr != saddr->s_addr) {
+			pr_warn_ratelimited("dst addr %pI4 != qp source addr %pI4\n",
+					    &ip_hdr(skb)->saddr,
+					    &saddr->s_addr);
+			goto err1;
+		}
+
+		if (ip_hdr(skb)->saddr != daddr->s_addr) {
+			pr_warn_ratelimited("source addr %pI4 != qp dst addr %pI4\n",
+					    &ip_hdr(skb)->daddr,
+					    &daddr->s_addr);
+			goto err1;
+		}
+
+	} else if (skb->protocol == htons(ETH_P_IPV6)) {
+		struct in6_addr *saddr =
+			&qp->pri_av.sgid_addr._sockaddr_in6.sin6_addr;
+		struct in6_addr *daddr =
+			&qp->pri_av.dgid_addr._sockaddr_in6.sin6_addr;
+
+		if (memcmp(&ipv6_hdr(skb)->daddr, saddr, sizeof(*saddr))) {
+			pr_warn_ratelimited("dst addr %pI6 != qp source addr %pI6\n",
+					    &ipv6_hdr(skb)->saddr, saddr);
+			goto err1;
+		}
+
+		if (memcmp(&ipv6_hdr(skb)->saddr, daddr, sizeof(*daddr))) {
+			pr_warn_ratelimited("source addr %pI6 != qp dst addr %pI6\n",
+					    &ipv6_hdr(skb)->daddr, daddr);
+			goto err1;
+		}
+	}
+
+done:
+	return 0;
+
+err1:
+	return -EINVAL;
+}
+
+static int hdr_check(struct rvt_pkt_info *pkt)
+{
+	struct rvt_dev *rdev = pkt->rdev;
+	struct rvt_port *port = &rdev->port[pkt->port_num - 1];
+	struct rvt_qp *qp = NULL;
+	u32 qpn = bth_qpn(pkt);
+	int index;
+	int err;
+
+	if (unlikely(bth_tver(pkt) != BTH_TVER)) {
+		pr_warn_ratelimited("bad tver\n");
+		goto err1;
+	}
+
+	if (qpn != IB_MULTICAST_QPN) {
+		index = (qpn == 0) ? port->qp_smi_index :
+			((qpn == 1) ? port->qp_gsi_index : qpn);
+		qp = rvt_pool_get_index(&rdev->qp_pool, index);
+		if (unlikely(!qp)) {
+			pr_warn_ratelimited("no qp matches qpn 0x%x\n", qpn);
+			goto err1;
+		}
+
+		err = check_type_state(rdev, pkt, qp);
+		if (unlikely(err))
+			goto err2;
+
+		err = check_addr(rdev, pkt, qp);
+		if (unlikely(err))
+			goto err2;
+
+		err = check_keys(rdev, pkt, qpn, qp);
+		if (unlikely(err))
+			goto err2;
+	} else {
+		if (unlikely((pkt->mask & RVT_GRH_MASK) == 0)) {
+			pr_warn_ratelimited("no grh for mcast qpn\n");
+			goto err1;
+		}
+	}
+
+	pkt->qp = qp;
+	return 0;
+
+err2:
+	if (qp)
+		rvt_drop_ref(qp);
+err1:
+	return -EINVAL;
+}
+
+static inline void rvt_rcv_pkt(struct rvt_dev *rvt,
+			       struct rvt_pkt_info *pkt,
+			       struct sk_buff *skb)
+{
+	if (pkt->mask & RVT_REQ_MASK)
+		rvt_resp_queue_pkt(rvt, pkt->qp, skb);
+	else
+		rvt_comp_queue_pkt(rvt, pkt->qp, skb);
+}
+
+static void rvt_rcv_mcast_pkt(struct rvt_dev *rvt, struct sk_buff *skb)
+{
+	struct rvt_pkt_info *pkt = SKB_TO_PKT(skb);
+	struct rvt_mc_grp *mcg;
+	struct sk_buff *skb_copy;
+	struct rvt_mc_elem *mce;
+	struct rvt_qp *qp;
+	union ib_gid dgid;
+	int err;
+
+	if (skb->protocol == htons(ETH_P_IP))
+		ipv6_addr_set_v4mapped(ip_hdr(skb)->daddr,
+				       (struct in6_addr *)&dgid);
+	else if (skb->protocol == htons(ETH_P_IPV6))
+		memcpy(&dgid, &ipv6_hdr(skb)->daddr, sizeof(dgid));
+
+	/* lookup mcast group corresponding to mgid, takes a ref */
+	mcg = rvt_pool_get_key(&rvt->mc_grp_pool, &dgid);
+	if (!mcg)
+		goto err1;	/* mcast group not registered */
+
+	spin_lock_bh(&mcg->mcg_lock);
+
+	list_for_each_entry(mce, &mcg->qp_list, qp_list) {
+		qp = mce->qp;
+		pkt = SKB_TO_PKT(skb);
+
+		/* validate qp for incoming packet */
+		err = check_type_state(rvt, pkt, qp);
+		if (err)
+			continue;
+
+		err = check_keys(rvt, pkt, bth_qpn(pkt), qp);
+		if (err)
+			continue;
+
+		/* if *not* the last qp in the list
+		   make a copy of the skb to post to the next qp */
+		skb_copy = (mce->qp_list.next != &mcg->qp_list) ?
+				skb_clone(skb, GFP_KERNEL) : NULL;
+
+		pkt->qp = qp;
+		rvt_add_ref(qp);
+		rvt_rcv_pkt(rvt, pkt, skb);
+
+		skb = skb_copy;
+		if (!skb)
+			break;
+	}
+
+	spin_unlock_bh(&mcg->mcg_lock);
+
+	rvt_drop_ref(mcg);	/* drop ref from rvt_pool_get_key. */
+
+err1:
+	if (skb)
+		kfree_skb(skb);
+}
+
+/* rvt_rcv is called from the interface driver */
+int rvt_rcv(struct sk_buff *skb, struct rvt_dev *rdev, u8 port_num)
+{
+	int err;
+	struct rvt_pkt_info *pkt = SKB_TO_PKT(skb);
+	struct udphdr *udph = udp_hdr(skb);
+
+	pkt->rdev = rdev;
+	pkt->port_num = port_num;
+	pkt->hdr = (u8 *)(udph + 1);
+	pkt->mask = RVT_GRH_MASK;
+	pkt->paylen = be16_to_cpu(udph->len) - sizeof(*udph);
+
+	pkt->offset = 0;
+
+	if (unlikely(skb->len < pkt->offset + RVT_BTH_BYTES))
+		goto drop;
+
+	pkt->opcode = bth_opcode(pkt);
+	pkt->psn = bth_psn(pkt);
+	pkt->qp = NULL;
+	pkt->mask |= rvt_opcode[pkt->opcode].mask;
+
+	if (unlikely(skb->len < header_size(pkt)))
+		goto drop;
+
+	err = hdr_check(pkt);
+	if (unlikely(err))
+		goto drop;
+
+	if (unlikely(bth_qpn(pkt) == IB_MULTICAST_QPN))
+		rvt_rcv_mcast_pkt(rdev, skb);
+	else
+		rvt_rcv_pkt(rdev, pkt, skb);
+
+	return 0;
+
+drop:
+	if (pkt->qp)
+		rvt_drop_ref(pkt->qp);
+
+	kfree_skb(skb);
+	return 0;
+}
+EXPORT_SYMBOL(rvt_rcv);
diff --git a/drivers/infiniband/sw/rdmavt/rvt_req.c b/drivers/infiniband/sw/rdmavt/rvt_req.c
new file mode 100644
index 0000000..0216922
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_req.c
@@ -0,0 +1,686 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#include <linux/skbuff.h>
+#include <linux/crc32.h>
+
+#include "rvt_loc.h"
+#include "rvt_queue.h"
+
+static int next_opcode(struct rvt_qp *qp, struct rvt_send_wqe *wqe,
+		       unsigned opcode);
+
+static inline void retry_first_write_send(struct rvt_qp *qp,
+					  struct rvt_send_wqe *wqe,
+					  unsigned mask, int npsn)
+{
+	int i;
+
+	for (i = 0; i < npsn; i++) {
+		int to_send = (wqe->dma.resid > qp->mtu) ?
+				qp->mtu : wqe->dma.resid;
+
+		qp->req.opcode = next_opcode(qp, wqe,
+					     wqe->wr.opcode);
+
+		if (wqe->wr.send_flags & IB_SEND_INLINE) {
+			wqe->dma.resid -= to_send;
+			wqe->dma.sge_offset += to_send;
+		} else {
+			advance_dma_data(&wqe->dma, to_send);
+		}
+		if (mask & WR_WRITE_MASK)
+			wqe->iova += qp->mtu;
+	}
+}
+
+static void req_retry(struct rvt_qp *qp)
+{
+	struct rvt_send_wqe *wqe;
+	unsigned int wqe_index;
+	unsigned int mask;
+	int npsn;
+	int first = 1;
+
+	wqe = queue_head(qp->sq.queue);
+	npsn = (qp->comp.psn - wqe->first_psn) & BTH_PSN_MASK;
+
+	qp->req.wqe_index	= consumer_index(qp->sq.queue);
+	qp->req.psn		= qp->comp.psn;
+	qp->req.opcode		= -1;
+
+	for (wqe_index = consumer_index(qp->sq.queue);
+		wqe_index != producer_index(qp->sq.queue);
+		wqe_index = next_index(qp->sq.queue, wqe_index)) {
+		wqe = addr_from_index(qp->sq.queue, wqe_index);
+		mask = wr_opcode_mask(wqe->wr.opcode, qp);
+
+		if (wqe->state == wqe_state_posted)
+			break;
+
+		if (wqe->state == wqe_state_done)
+			continue;
+
+		wqe->iova = (mask & WR_ATOMIC_MASK) ?
+			wqe->wr.wr.atomic.remote_addr :
+			wqe->wr.wr.rdma.remote_addr;
+
+		if (!first || (mask & WR_READ_MASK) == 0) {
+			wqe->dma.resid = wqe->dma.length;
+			wqe->dma.cur_sge = 0;
+			wqe->dma.sge_offset = 0;
+		}
+
+		if (first) {
+			first = 0;
+
+			if (mask & WR_WRITE_OR_SEND_MASK)
+				retry_first_write_send(qp, wqe, mask, npsn);
+
+			if (mask & WR_READ_MASK)
+				wqe->iova += npsn * qp->mtu;
+		}
+
+		wqe->state = wqe_state_posted;
+	}
+}
+
+void rnr_nak_timer(unsigned long data)
+{
+	struct rvt_qp *qp = (struct rvt_qp *)data;
+
+	pr_debug("rnr nak timer fired\n");
+	rvt_run_task(&qp->req.task, 1);
+}
+
+static struct rvt_send_wqe *req_next_wqe(struct rvt_qp *qp)
+{
+	struct rvt_send_wqe *wqe = queue_head(qp->sq.queue);
+	unsigned long flags;
+
+	if (unlikely(qp->req.state == QP_STATE_DRAIN)) {
+		/* check to see if we are drained;
+		 * state_lock used by requester and completer
+		 */
+		spin_lock_irqsave(&qp->state_lock, flags);
+		do {
+			if (qp->req.state != QP_STATE_DRAIN) {
+				/* comp just finished */
+				spin_unlock_irqrestore(&qp->state_lock,
+						       flags);
+				break;
+			}
+
+			if (wqe && ((qp->req.wqe_index !=
+				consumer_index(qp->sq.queue)) ||
+				(wqe->state != wqe_state_posted))) {
+				/* comp not done yet */
+				spin_unlock_irqrestore(&qp->state_lock,
+						       flags);
+				break;
+			}
+
+			qp->req.state = QP_STATE_DRAINED;
+			spin_unlock_irqrestore(&qp->state_lock, flags);
+
+			if (qp->ibqp.event_handler) {
+				struct ib_event ev;
+
+				ev.device = qp->ibqp.device;
+				ev.element.qp = &qp->ibqp;
+				ev.event = IB_EVENT_SQ_DRAINED;
+				qp->ibqp.event_handler(&ev,
+					qp->ibqp.qp_context);
+			}
+		} while (0);
+	}
+
+	if (qp->req.wqe_index == producer_index(qp->sq.queue))
+		return NULL;
+
+	wqe = addr_from_index(qp->sq.queue, qp->req.wqe_index);
+
+	if (unlikely((qp->req.state == QP_STATE_DRAIN ||
+		      qp->req.state == QP_STATE_DRAINED) &&
+		     (wqe->state != wqe_state_processing)))
+		return NULL;
+
+	if (unlikely((wqe->wr.send_flags & IB_SEND_FENCE) &&
+		     (qp->req.wqe_index != consumer_index(qp->sq.queue)))) {
+		qp->req.wait_fence = 1;
+		return NULL;
+	}
+
+	wqe->mask = wr_opcode_mask(wqe->wr.opcode, qp);
+	return wqe;
+}
+
+static int next_opcode_rc(struct rvt_qp *qp, unsigned opcode, int fits)
+{
+	switch (opcode) {
+	case IB_WR_RDMA_WRITE:
+		if (qp->req.opcode == IB_OPCODE_RC_RDMA_WRITE_FIRST ||
+		    qp->req.opcode == IB_OPCODE_RC_RDMA_WRITE_MIDDLE)
+			return fits ?
+				IB_OPCODE_RC_RDMA_WRITE_LAST :
+				IB_OPCODE_RC_RDMA_WRITE_MIDDLE;
+		else
+			return fits ?
+				IB_OPCODE_RC_RDMA_WRITE_ONLY :
+				IB_OPCODE_RC_RDMA_WRITE_FIRST;
+
+	case IB_WR_RDMA_WRITE_WITH_IMM:
+		if (qp->req.opcode == IB_OPCODE_RC_RDMA_WRITE_FIRST ||
+		    qp->req.opcode == IB_OPCODE_RC_RDMA_WRITE_MIDDLE)
+			return fits ?
+				IB_OPCODE_RC_RDMA_WRITE_LAST_WITH_IMMEDIATE :
+				IB_OPCODE_RC_RDMA_WRITE_MIDDLE;
+		else
+			return fits ?
+				IB_OPCODE_RC_RDMA_WRITE_ONLY_WITH_IMMEDIATE :
+				IB_OPCODE_RC_RDMA_WRITE_FIRST;
+
+	case IB_WR_SEND:
+		if (qp->req.opcode == IB_OPCODE_RC_SEND_FIRST ||
+		    qp->req.opcode == IB_OPCODE_RC_SEND_MIDDLE)
+			return fits ?
+				IB_OPCODE_RC_SEND_LAST :
+				IB_OPCODE_RC_SEND_MIDDLE;
+		else
+			return fits ?
+				IB_OPCODE_RC_SEND_ONLY :
+				IB_OPCODE_RC_SEND_FIRST;
+
+	case IB_WR_SEND_WITH_IMM:
+		if (qp->req.opcode == IB_OPCODE_RC_SEND_FIRST ||
+		    qp->req.opcode == IB_OPCODE_RC_SEND_MIDDLE)
+			return fits ?
+				IB_OPCODE_RC_SEND_LAST_WITH_IMMEDIATE :
+				IB_OPCODE_RC_SEND_MIDDLE;
+		else
+			return fits ?
+				IB_OPCODE_RC_SEND_ONLY_WITH_IMMEDIATE :
+				IB_OPCODE_RC_SEND_FIRST;
+
+	case IB_WR_RDMA_READ:
+		return IB_OPCODE_RC_RDMA_READ_REQUEST;
+
+	case IB_WR_ATOMIC_CMP_AND_SWP:
+		return IB_OPCODE_RC_COMPARE_SWAP;
+
+	case IB_WR_ATOMIC_FETCH_AND_ADD:
+		return IB_OPCODE_RC_FETCH_ADD;
+
+	case IB_WR_SEND_WITH_INV:
+		if (qp->req.opcode == IB_OPCODE_RC_SEND_FIRST ||
+		    qp->req.opcode == IB_OPCODE_RC_SEND_MIDDLE)
+			return fits ? IB_OPCODE_RC_SEND_LAST_INV :
+				IB_OPCODE_RC_SEND_MIDDLE;
+		else
+			return fits ? IB_OPCODE_RC_SEND_ONLY_INV :
+				IB_OPCODE_RC_SEND_FIRST;
+	}
+
+	return -EINVAL;
+}
+
+static int next_opcode_uc(struct rvt_qp *qp, unsigned opcode, int fits)
+{
+	switch (opcode) {
+	case IB_WR_RDMA_WRITE:
+		if (qp->req.opcode == IB_OPCODE_UC_RDMA_WRITE_FIRST ||
+		    qp->req.opcode == IB_OPCODE_UC_RDMA_WRITE_MIDDLE)
+			return fits ?
+				IB_OPCODE_UC_RDMA_WRITE_LAST :
+				IB_OPCODE_UC_RDMA_WRITE_MIDDLE;
+		else
+			return fits ?
+				IB_OPCODE_UC_RDMA_WRITE_ONLY :
+				IB_OPCODE_UC_RDMA_WRITE_FIRST;
+
+	case IB_WR_RDMA_WRITE_WITH_IMM:
+		if (qp->req.opcode == IB_OPCODE_UC_RDMA_WRITE_FIRST ||
+		    qp->req.opcode == IB_OPCODE_UC_RDMA_WRITE_MIDDLE)
+			return fits ?
+				IB_OPCODE_UC_RDMA_WRITE_LAST_WITH_IMMEDIATE :
+				IB_OPCODE_UC_RDMA_WRITE_MIDDLE;
+		else
+			return fits ?
+				IB_OPCODE_UC_RDMA_WRITE_ONLY_WITH_IMMEDIATE :
+				IB_OPCODE_UC_RDMA_WRITE_FIRST;
+
+	case IB_WR_SEND:
+		if (qp->req.opcode == IB_OPCODE_UC_SEND_FIRST ||
+		    qp->req.opcode == IB_OPCODE_UC_SEND_MIDDLE)
+			return fits ?
+				IB_OPCODE_UC_SEND_LAST :
+				IB_OPCODE_UC_SEND_MIDDLE;
+		else
+			return fits ?
+				IB_OPCODE_UC_SEND_ONLY :
+				IB_OPCODE_UC_SEND_FIRST;
+
+	case IB_WR_SEND_WITH_IMM:
+		if (qp->req.opcode == IB_OPCODE_UC_SEND_FIRST ||
+		    qp->req.opcode == IB_OPCODE_UC_SEND_MIDDLE)
+			return fits ?
+				IB_OPCODE_UC_SEND_LAST_WITH_IMMEDIATE :
+				IB_OPCODE_UC_SEND_MIDDLE;
+		else
+			return fits ?
+				IB_OPCODE_UC_SEND_ONLY_WITH_IMMEDIATE :
+				IB_OPCODE_UC_SEND_FIRST;
+	}
+
+	return -EINVAL;
+}
+
+static int next_opcode(struct rvt_qp *qp, struct rvt_send_wqe *wqe,
+		       unsigned opcode)
+{
+	int fits = (wqe->dma.resid <= qp->mtu);
+
+	switch (qp_type(qp)) {
+	case IB_QPT_RC:
+		return next_opcode_rc(qp, opcode, fits);
+
+	case IB_QPT_UC:
+		return next_opcode_uc(qp, opcode, fits);
+
+	case IB_QPT_SMI:
+	case IB_QPT_UD:
+	case IB_QPT_GSI:
+		switch (opcode) {
+		case IB_WR_SEND:
+			return IB_OPCODE_UD_SEND_ONLY;
+
+		case IB_WR_SEND_WITH_IMM:
+			return IB_OPCODE_UD_SEND_ONLY_WITH_IMMEDIATE;
+		}
+		break;
+
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
+static inline int check_init_depth(struct rvt_qp *qp, struct rvt_send_wqe *wqe)
+{
+	int depth;
+
+	if (wqe->has_rd_atomic)
+		return 0;
+
+	qp->req.need_rd_atomic = 1;
+	depth = atomic_dec_return(&qp->req.rd_atomic);
+
+	if (depth >= 0) {
+		qp->req.need_rd_atomic = 0;
+		wqe->has_rd_atomic = 1;
+		return 0;
+	}
+
+	atomic_inc(&qp->req.rd_atomic);
+	return -EAGAIN;
+}
+
+static inline int get_mtu(struct rvt_qp *qp, struct rvt_send_wqe *wqe)
+{
+	struct rvt_dev *rvt = to_rdev(qp->ibqp.device);
+	struct rvt_port *port;
+	struct rvt_av *av;
+
+	if ((qp_type(qp) == IB_QPT_RC) || (qp_type(qp) == IB_QPT_UC))
+		return qp->mtu;
+
+	av = &wqe->av;
+	port = &rvt->port[av->port_num - 1];
+
+	return port->mtu_cap;
+}
+
+static struct sk_buff *init_req_packet(struct rvt_qp *qp,
+				       struct rvt_send_wqe *wqe,
+				       int opcode, int payload,
+				       struct rvt_pkt_info *pkt)
+{
+	struct rvt_dev		*rdev = to_rdev(qp->ibqp.device);
+	struct rvt_port		*port = &rdev->port[qp->attr.port_num - 1];
+	struct sk_buff		*skb;
+	struct rvt_send_wr	*ibwr = &wqe->wr;
+	struct rvt_av		*av;
+	int			pad = (-payload) & 0x3;
+	int			paylen;
+	int			solicited;
+	u16			pkey;
+	u32			qp_num;
+	int			ack_req;
+
+	/* length from start of bth to end of icrc */
+	paylen = rvt_opcode[opcode].length + payload + pad + RVT_ICRC_SIZE;
+
+	if (qp_type(qp) == IB_QPT_RC || qp_type(qp) == IB_QPT_UC)
+		av = &qp->pri_av;
+	else
+		av = &wqe->av;
+
+	/* init skb */
+	skb = rdev->ifc_ops->alloc_sendbuf(rdev, av, paylen);
+	if (unlikely(!skb))
+		return NULL;
+
+	/* pkt->hdr, rdev, port_num, paylen and mask are initialized in ifc
+	 * layer
+	 */
+	pkt->rdev	= rdev;
+	pkt->port_num	= 1;
+	pkt->hdr	= skb_put(skb, paylen);
+	pkt->mask	= RVT_GRH_MASK;
+	pkt->opcode	= opcode;
+	pkt->qp		= qp;
+	pkt->psn	= qp->req.psn;
+	pkt->mask	|= rvt_opcode[opcode].mask;
+	pkt->paylen	= paylen;
+	pkt->offset	= 0;
+	pkt->wqe	= wqe;
+	if (addr_same(rdev, get_av(pkt))) {
+		pkt->mask |= RVT_LOOPBACK_MASK;
+	}
+
+	/* init bth */
+	solicited = (ibwr->send_flags & IB_SEND_SOLICITED) &&
+			(pkt->mask & RVT_END_MASK) &&
+			((pkt->mask & (RVT_SEND_MASK)) ||
+			(pkt->mask & (RVT_WRITE_MASK | RVT_IMMDT_MASK)) ==
+			(RVT_WRITE_MASK | RVT_IMMDT_MASK));
+
+	pkey = (qp_type(qp) == IB_QPT_GSI) ?
+		 port->pkey_tbl[ibwr->wr.ud.pkey_index] :
+		 port->pkey_tbl[qp->attr.pkey_index];
+
+	qp_num = (pkt->mask & RVT_DETH_MASK) ? ibwr->wr.ud.remote_qpn :
+					 qp->attr.dest_qp_num;
+
+	ack_req = ((pkt->mask & RVT_END_MASK) ||
+		(qp->req.noack_pkts++ > RVT_MAX_PKT_PER_ACK));
+	if (ack_req)
+		qp->req.noack_pkts = 0;
+
+	bth_init(pkt, pkt->opcode, solicited, 0, pad, pkey, qp_num,
+		 ack_req, pkt->psn);
+
+	/* init optional headers */
+	if (pkt->mask & RVT_RETH_MASK) {
+		reth_set_rkey(pkt, ibwr->wr.rdma.rkey);
+		reth_set_va(pkt, wqe->iova);
+		reth_set_len(pkt, wqe->dma.length);
+	}
+
+	if (pkt->mask & RVT_IMMDT_MASK)
+		immdt_set_imm(pkt, cpu_to_be32(ibwr->ex.imm_data));
+
+	if (pkt->mask & RVT_IETH_MASK)
+		ieth_set_rkey(pkt, ibwr->ex.invalidate_rkey);
+
+	if (pkt->mask & RVT_ATMETH_MASK) {
+		atmeth_set_va(pkt, wqe->iova);
+		if (opcode == IB_OPCODE_RC_COMPARE_SWAP ||
+		    opcode == IB_OPCODE_RD_COMPARE_SWAP) {
+			atmeth_set_swap_add(pkt, ibwr->wr.atomic.swap);
+			atmeth_set_comp(pkt, ibwr->wr.atomic.compare_add);
+		} else {
+			atmeth_set_swap_add(pkt, ibwr->wr.atomic.compare_add);
+		}
+		atmeth_set_rkey(pkt, ibwr->wr.atomic.rkey);
+	}
+
+	if (pkt->mask & RVT_DETH_MASK) {
+		if (qp->ibqp.qp_num == 1)
+			deth_set_qkey(pkt, GSI_QKEY);
+		else
+			deth_set_qkey(pkt, ibwr->wr.ud.remote_qkey);
+		deth_set_sqp(pkt, qp->ibqp.qp_num);
+	}
+
+	return skb;
+}
+
+static int fill_packet(struct rvt_qp *qp, struct rvt_send_wqe *wqe,
+		       struct rvt_pkt_info *pkt, struct sk_buff *skb,
+		       int payload)
+{
+	struct rvt_dev *rdev = to_rdev(qp->ibqp.device);
+	u32 crc = 0;
+	u32 *p;
+	int err;
+
+	err = rvt_prepare(rdev, pkt, skb, &crc);
+	if (err)
+		return err;
+
+	if (pkt->mask & RVT_WRITE_OR_SEND) {
+		if (wqe->wr.send_flags & IB_SEND_INLINE) {
+			u8 *tmp = &wqe->dma.inline_data[wqe->dma.sge_offset];
+
+			crc = crc32_le(crc, tmp, payload);
+
+			memcpy(payload_addr(pkt), tmp, payload);
+
+			wqe->dma.resid -= payload;
+			wqe->dma.sge_offset += payload;
+		} else {
+			err = copy_data(rdev, qp->pd, 0, &wqe->dma,
+					payload_addr(pkt), payload,
+					from_mem_obj,
+					&crc);
+			if (err)
+				return err;
+		}
+	}
+	p = payload_addr(pkt) + payload;
+
+	*p = ~crc;
+
+	return 0;
+}
+
+static void update_state(struct rvt_qp *qp, struct rvt_send_wqe *wqe,
+			 struct rvt_pkt_info *pkt, int payload)
+{
+	/* number of packets left to send including current one */
+	int num_pkt = (wqe->dma.resid + payload + qp->mtu - 1) / qp->mtu;
+
+	/* handle zero length packet case */
+	if (num_pkt == 0)
+		num_pkt = 1;
+
+	if (pkt->mask & RVT_START_MASK) {
+		wqe->first_psn = qp->req.psn;
+		wqe->last_psn = (qp->req.psn + num_pkt - 1) & BTH_PSN_MASK;
+	}
+
+	if (pkt->mask & RVT_READ_MASK)
+		qp->req.psn = (wqe->first_psn + num_pkt) & BTH_PSN_MASK;
+	else
+		qp->req.psn = (qp->req.psn + 1) & BTH_PSN_MASK;
+
+	qp->req.opcode = pkt->opcode;
+
+	if (pkt->mask & RVT_END_MASK) {
+		if (qp_type(qp) == IB_QPT_RC)
+			wqe->state = wqe_state_pending;
+
+		qp->req.wqe_index = next_index(qp->sq.queue,
+						qp->req.wqe_index);
+	} else {
+		wqe->state = wqe_state_processing;
+	}
+
+	qp->need_req_skb = 0;
+
+	if (qp->qp_timeout_jiffies && !timer_pending(&qp->retrans_timer))
+		mod_timer(&qp->retrans_timer,
+			  jiffies + qp->qp_timeout_jiffies);
+}
+
+int rvt_requester(void *arg)
+{
+	struct rvt_qp *qp = (struct rvt_qp *)arg;
+	struct rvt_pkt_info pkt;
+	struct sk_buff *skb;
+	struct rvt_send_wqe *wqe;
+	unsigned mask;
+	int payload;
+	int mtu;
+	int opcode;
+	int ret = 0;
+
+next_wqe:
+	if (unlikely(!qp->valid || qp->req.state == QP_STATE_ERROR))
+		goto exit;
+
+	if (unlikely(qp->req.state == QP_STATE_RESET)) {
+		qp->req.wqe_index = consumer_index(qp->sq.queue);
+		qp->req.opcode = -1;
+		qp->req.need_rd_atomic = 0;
+		qp->req.wait_psn = 0;
+		qp->req.need_retry = 0;
+		goto exit;
+	}
+
+	if (unlikely(qp->req.need_retry)) {
+		req_retry(qp);
+		qp->req.need_retry = 0;
+	}
+
+	wqe = req_next_wqe(qp);
+	if (unlikely(!wqe))
+		goto exit;
+
+	/* RC only, PSN window to prevent mixing new packets PSN
+	 * with old ones. According to IB SPEC this number is
+	 * half of the PSN range (2^24).
+	 */
+	if (unlikely(qp_type(qp) == IB_QPT_RC &&
+		     qp->req.psn > (qp->comp.psn + RVT_MAX_UNACKED_PSNS))) {
+		qp->req.wait_psn = 1;
+		goto exit;
+	}
+
+	/* Limit the number of inflight SKBs per QP */
+	if (unlikely(atomic_read(&qp->skb_out) >
+		     RVT_INFLIGHT_SKBS_PER_QP_HIGH)) {
+		qp->need_req_skb = 1;
+		goto exit;
+	}
+
+	opcode = next_opcode(qp, wqe, wqe->wr.opcode);
+	if (unlikely(opcode < 0)) {
+		wqe->status = IB_WC_LOC_QP_OP_ERR;
+		goto exit;
+	}
+
+	mask = rvt_opcode[opcode].mask;
+	if (unlikely(mask & RVT_READ_OR_ATOMIC)) {
+		if (check_init_depth(qp, wqe))
+			goto exit;
+	}
+
+	mtu = get_mtu(qp, wqe);
+	payload = (mask & RVT_WRITE_OR_SEND) ? wqe->dma.resid : 0;
+	if (payload > mtu) {
+		if (qp_type(qp) == IB_QPT_UD) {
+			/* believe it or not this is what the spec says to do */
+
+			/*
+			 * fake a successful UD send
+			 */
+			wqe->first_psn = qp->req.psn;
+			wqe->last_psn = qp->req.psn;
+			qp->req.psn = (qp->req.psn + 1) & BTH_PSN_MASK;
+			qp->req.opcode = IB_OPCODE_UD_SEND_ONLY;
+			qp->req.wqe_index = next_index(qp->sq.queue,
+						       qp->req.wqe_index);
+			wqe->state = wqe_state_done;
+			wqe->status = IB_WC_SUCCESS;
+			goto complete;
+		}
+		payload = mtu;
+	}
+
+	skb = init_req_packet(qp, wqe, opcode, payload, &pkt);
+	if (unlikely(!skb)) {
+		pr_err("Failed allocating skb\n");
+		goto err;
+	}
+
+	if (fill_packet(qp, wqe, &pkt, skb, payload)) {
+		pr_debug("Error during fill packet\n");
+		goto err;
+	}
+
+	ret = rvt_xmit_packet(to_rdev(qp->ibqp.device), qp, &pkt, skb);
+	if (ret) {
+		qp->need_req_skb = 1;
+		kfree_skb(skb);
+
+		if (-EAGAIN == ret) {
+			rvt_run_task(&qp->req.task, 1);
+			goto exit;
+		}
+
+		goto err;
+	}
+
+	update_state(qp, wqe, &pkt, payload);
+
+	goto next_wqe;
+
+err:
+	kfree_skb(skb);
+	wqe->status = IB_WC_LOC_PROT_ERR;
+	wqe->state = wqe_state_error;
+
+complete:
+	if (qp_type(qp) != IB_QPT_RC) {
+		while (rvt_completer(qp) == 0)
+			;
+	}
+
+	return 0;
+
+exit:
+	return -EAGAIN;
+}
diff --git a/drivers/infiniband/sw/rdmavt/rvt_resp.c b/drivers/infiniband/sw/rdmavt/rvt_resp.c
new file mode 100644
index 0000000..16e02e0
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_resp.c
@@ -0,0 +1,1375 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#include <linux/skbuff.h>
+
+#include "rvt_loc.h"
+#include "rvt_queue.h"
+
+enum resp_states {
+	RESPST_NONE,
+	RESPST_GET_REQ,
+	RESPST_CHK_PSN,
+	RESPST_CHK_OP_SEQ,
+	RESPST_CHK_OP_VALID,
+	RESPST_CHK_RESOURCE,
+	RESPST_CHK_LENGTH,
+	RESPST_CHK_RKEY,
+	RESPST_EXECUTE,
+	RESPST_READ_REPLY,
+	RESPST_COMPLETE,
+	RESPST_ACKNOWLEDGE,
+	RESPST_CLEANUP,
+	RESPST_DUPLICATE_REQUEST,
+	RESPST_ERR_MALFORMED_WQE,
+	RESPST_ERR_UNSUPPORTED_OPCODE,
+	RESPST_ERR_MISALIGNED_ATOMIC,
+	RESPST_ERR_PSN_OUT_OF_SEQ,
+	RESPST_ERR_MISSING_OPCODE_FIRST,
+	RESPST_ERR_MISSING_OPCODE_LAST_C,
+	RESPST_ERR_MISSING_OPCODE_LAST_D1E,
+	RESPST_ERR_TOO_MANY_RDMA_ATM_REQ,
+	RESPST_ERR_RNR,
+	RESPST_ERR_RKEY_VIOLATION,
+	RESPST_ERR_LENGTH,
+	RESPST_ERR_CQ_OVERFLOW,
+	RESPST_ERROR,
+	RESPST_RESET,
+	RESPST_DONE,
+	RESPST_EXIT,
+};
+
+static char *resp_state_name[] = {
+	[RESPST_NONE]				= "NONE",
+	[RESPST_GET_REQ]			= "GET_REQ",
+	[RESPST_CHK_PSN]			= "CHK_PSN",
+	[RESPST_CHK_OP_SEQ]			= "CHK_OP_SEQ",
+	[RESPST_CHK_OP_VALID]			= "CHK_OP_VALID",
+	[RESPST_CHK_RESOURCE]			= "CHK_RESOURCE",
+	[RESPST_CHK_LENGTH]			= "CHK_LENGTH",
+	[RESPST_CHK_RKEY]			= "CHK_RKEY",
+	[RESPST_EXECUTE]			= "EXECUTE",
+	[RESPST_READ_REPLY]			= "READ_REPLY",
+	[RESPST_COMPLETE]			= "COMPLETE",
+	[RESPST_ACKNOWLEDGE]			= "ACKNOWLEDGE",
+	[RESPST_CLEANUP]			= "CLEANUP",
+	[RESPST_DUPLICATE_REQUEST]		= "DUPLICATE_REQUEST",
+	[RESPST_ERR_MALFORMED_WQE]		= "ERR_MALFORMED_WQE",
+	[RESPST_ERR_UNSUPPORTED_OPCODE]		= "ERR_UNSUPPORTED_OPCODE",
+	[RESPST_ERR_MISALIGNED_ATOMIC]		= "ERR_MISALIGNED_ATOMIC",
+	[RESPST_ERR_PSN_OUT_OF_SEQ]		= "ERR_PSN_OUT_OF_SEQ",
+	[RESPST_ERR_MISSING_OPCODE_FIRST]	= "ERR_MISSING_OPCODE_FIRST",
+	[RESPST_ERR_MISSING_OPCODE_LAST_C]	= "ERR_MISSING_OPCODE_LAST_C",
+	[RESPST_ERR_MISSING_OPCODE_LAST_D1E]	= "ERR_MISSING_OPCODE_LAST_D1E",
+	[RESPST_ERR_TOO_MANY_RDMA_ATM_REQ]	= "ERR_TOO_MANY_RDMA_ATM_REQ",
+	[RESPST_ERR_RNR]			= "ERR_RNR",
+	[RESPST_ERR_RKEY_VIOLATION]		= "ERR_RKEY_VIOLATION",
+	[RESPST_ERR_LENGTH]			= "ERR_LENGTH",
+	[RESPST_ERR_CQ_OVERFLOW]		= "ERR_CQ_OVERFLOW",
+	[RESPST_ERROR]				= "ERROR",
+	[RESPST_RESET]				= "RESET",
+	[RESPST_DONE]				= "DONE",
+	[RESPST_EXIT]				= "EXIT",
+};
+
+/* rvt_recv calls here to add a request packet to the input queue */
+void rvt_resp_queue_pkt(struct rvt_dev *rvt, struct rvt_qp *qp,
+			struct sk_buff *skb)
+{
+	int must_sched;
+	struct rvt_pkt_info *pkt = SKB_TO_PKT(skb);
+
+	skb_queue_tail(&qp->req_pkts, skb);
+
+	must_sched = (pkt->opcode == IB_OPCODE_RC_RDMA_READ_REQUEST) ||
+			(skb_queue_len(&qp->req_pkts) > 1);
+
+	rvt_run_task(&qp->resp.task, must_sched);
+}
+
+static inline enum resp_states get_req(struct rvt_qp *qp,
+				       struct rvt_pkt_info **pkt_p)
+{
+	struct sk_buff *skb;
+
+	if (qp->resp.state == QP_STATE_ERROR) {
+		skb = skb_dequeue(&qp->req_pkts);
+		if (skb) {
+			/* drain request packet queue */
+			rvt_drop_ref(qp);
+			kfree_skb(skb);
+			return RESPST_GET_REQ;
+		}
+
+		/* go drain recv wr queue */
+		return RESPST_CHK_RESOURCE;
+	}
+
+	skb = skb_peek(&qp->req_pkts);
+	if (!skb)
+		return RESPST_EXIT;
+
+	*pkt_p = SKB_TO_PKT(skb);
+
+	return (qp->resp.res) ? RESPST_READ_REPLY : RESPST_CHK_PSN;
+}
+
+static enum resp_states check_psn(struct rvt_qp *qp,
+				  struct rvt_pkt_info *pkt)
+{
+	int diff = psn_compare(pkt->psn, qp->resp.psn);
+
+	switch (qp_type(qp)) {
+	case IB_QPT_RC:
+		if (diff > 0) {
+			if (qp->resp.sent_psn_nak)
+				return RESPST_CLEANUP;
+
+			qp->resp.sent_psn_nak = 1;
+			return RESPST_ERR_PSN_OUT_OF_SEQ;
+
+		} else if (diff < 0) {
+			return RESPST_DUPLICATE_REQUEST;
+		}
+
+		if (qp->resp.sent_psn_nak)
+			qp->resp.sent_psn_nak = 0;
+
+		break;
+
+	case IB_QPT_UC:
+		if (qp->resp.drop_msg || diff != 0) {
+			if (pkt->mask & RVT_START_MASK) {
+				qp->resp.drop_msg = 0;
+				return RESPST_CHK_OP_SEQ;
+			}
+
+			qp->resp.drop_msg = 1;
+			return RESPST_CLEANUP;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return RESPST_CHK_OP_SEQ;
+}
+
+static enum resp_states check_op_seq(struct rvt_qp *qp,
+				     struct rvt_pkt_info *pkt)
+{
+	switch (qp_type(qp)) {
+	case IB_QPT_RC:
+		switch (qp->resp.opcode) {
+		case IB_OPCODE_RC_SEND_FIRST:
+		case IB_OPCODE_RC_SEND_MIDDLE:
+			switch (pkt->opcode) {
+			case IB_OPCODE_RC_SEND_MIDDLE:
+			case IB_OPCODE_RC_SEND_LAST:
+			case IB_OPCODE_RC_SEND_LAST_WITH_IMMEDIATE:
+			case IB_OPCODE_RC_SEND_LAST_INV:
+				return RESPST_CHK_OP_VALID;
+			default:
+				return RESPST_ERR_MISSING_OPCODE_LAST_C;
+			}
+
+		case IB_OPCODE_RC_RDMA_WRITE_FIRST:
+		case IB_OPCODE_RC_RDMA_WRITE_MIDDLE:
+			switch (pkt->opcode) {
+			case IB_OPCODE_RC_RDMA_WRITE_MIDDLE:
+			case IB_OPCODE_RC_RDMA_WRITE_LAST:
+			case IB_OPCODE_RC_RDMA_WRITE_LAST_WITH_IMMEDIATE:
+				return RESPST_CHK_OP_VALID;
+			default:
+				return RESPST_ERR_MISSING_OPCODE_LAST_C;
+			}
+
+		default:
+			switch (pkt->opcode) {
+			case IB_OPCODE_RC_SEND_MIDDLE:
+			case IB_OPCODE_RC_SEND_LAST:
+			case IB_OPCODE_RC_SEND_LAST_WITH_IMMEDIATE:
+			case IB_OPCODE_RC_SEND_LAST_INV:
+			case IB_OPCODE_RC_RDMA_WRITE_MIDDLE:
+			case IB_OPCODE_RC_RDMA_WRITE_LAST:
+			case IB_OPCODE_RC_RDMA_WRITE_LAST_WITH_IMMEDIATE:
+				return RESPST_ERR_MISSING_OPCODE_FIRST;
+			default:
+				return RESPST_CHK_OP_VALID;
+			}
+		}
+		break;
+
+	case IB_QPT_UC:
+		switch (qp->resp.opcode) {
+		case IB_OPCODE_UC_SEND_FIRST:
+		case IB_OPCODE_UC_SEND_MIDDLE:
+			switch (pkt->opcode) {
+			case IB_OPCODE_UC_SEND_MIDDLE:
+			case IB_OPCODE_UC_SEND_LAST:
+			case IB_OPCODE_UC_SEND_LAST_WITH_IMMEDIATE:
+				return RESPST_CHK_OP_VALID;
+			default:
+				return RESPST_ERR_MISSING_OPCODE_LAST_D1E;
+			}
+
+		case IB_OPCODE_UC_RDMA_WRITE_FIRST:
+		case IB_OPCODE_UC_RDMA_WRITE_MIDDLE:
+			switch (pkt->opcode) {
+			case IB_OPCODE_UC_RDMA_WRITE_MIDDLE:
+			case IB_OPCODE_UC_RDMA_WRITE_LAST:
+			case IB_OPCODE_UC_RDMA_WRITE_LAST_WITH_IMMEDIATE:
+				return RESPST_CHK_OP_VALID;
+			default:
+				return RESPST_ERR_MISSING_OPCODE_LAST_D1E;
+			}
+
+		default:
+			switch (pkt->opcode) {
+			case IB_OPCODE_UC_SEND_MIDDLE:
+			case IB_OPCODE_UC_SEND_LAST:
+			case IB_OPCODE_UC_SEND_LAST_WITH_IMMEDIATE:
+			case IB_OPCODE_UC_RDMA_WRITE_MIDDLE:
+			case IB_OPCODE_UC_RDMA_WRITE_LAST:
+			case IB_OPCODE_UC_RDMA_WRITE_LAST_WITH_IMMEDIATE:
+				qp->resp.drop_msg = 1;
+				return RESPST_CLEANUP;
+			default:
+				return RESPST_CHK_OP_VALID;
+			}
+		}
+		break;
+
+	default:
+		return RESPST_CHK_OP_VALID;
+	}
+}
+
+static enum resp_states check_op_valid(struct rvt_qp *qp,
+				       struct rvt_pkt_info *pkt)
+{
+	switch (qp_type(qp)) {
+	case IB_QPT_RC:
+		if (((pkt->mask & RVT_READ_MASK) &&
+		     !(qp->attr.qp_access_flags & IB_ACCESS_REMOTE_READ)) ||
+		    ((pkt->mask & RVT_WRITE_MASK) &&
+		     !(qp->attr.qp_access_flags & IB_ACCESS_REMOTE_WRITE)) ||
+		    ((pkt->mask & RVT_ATOMIC_MASK) &&
+		     !(qp->attr.qp_access_flags & IB_ACCESS_REMOTE_ATOMIC))) {
+			return RESPST_ERR_UNSUPPORTED_OPCODE;
+		}
+
+		if (!pkt->mask)
+			return RESPST_ERR_UNSUPPORTED_OPCODE;
+		break;
+
+	case IB_QPT_UC:
+		if ((pkt->mask & RVT_WRITE_MASK) &&
+		    !(qp->attr.qp_access_flags & IB_ACCESS_REMOTE_WRITE)) {
+			qp->resp.drop_msg = 1;
+			return RESPST_CLEANUP;
+		}
+
+		if (!pkt->mask) {
+			qp->resp.drop_msg = 1;
+			return RESPST_CLEANUP;
+		}
+		break;
+
+	case IB_QPT_UD:
+	case IB_QPT_SMI:
+	case IB_QPT_GSI:
+		if (!pkt->mask)
+			return RESPST_CLEANUP;
+		break;
+
+	default:
+		WARN_ON(1);
+		break;
+	}
+
+	return RESPST_CHK_RESOURCE;
+}
+
+static enum resp_states get_srq_wqe(struct rvt_qp *qp)
+{
+	struct rvt_srq *srq = qp->srq;
+	struct rvt_queue *q = srq->rq.queue;
+	struct rvt_recv_wqe *wqe;
+	struct ib_event ev;
+
+	if (srq->error)
+		return RESPST_ERR_RNR;
+
+	spin_lock_bh(&srq->rq.consumer_lock);
+
+	wqe = queue_head(q);
+	if (!wqe) {
+		spin_unlock_bh(&srq->rq.consumer_lock);
+		return RESPST_ERR_RNR;
+	}
+
+	/* note kernel and user space recv wqes have same size */
+	memcpy(&qp->resp.srq_wqe, wqe, sizeof(qp->resp.srq_wqe));
+
+	qp->resp.wqe = &qp->resp.srq_wqe.wqe;
+	advance_consumer(q);
+
+	if (srq->limit && srq->ibsrq.event_handler &&
+	    (queue_count(q) < srq->limit)) {
+		srq->limit = 0;
+		goto event;
+	}
+
+	spin_unlock_bh(&srq->rq.consumer_lock);
+	return RESPST_CHK_LENGTH;
+
+event:
+	spin_unlock_bh(&srq->rq.consumer_lock);
+	ev.device = qp->ibqp.device;
+	ev.element.srq = qp->ibqp.srq;
+	ev.event = IB_EVENT_SRQ_LIMIT_REACHED;
+	srq->ibsrq.event_handler(&ev, srq->ibsrq.srq_context);
+	return RESPST_CHK_LENGTH;
+}
+
+static enum resp_states check_resource(struct rvt_qp *qp,
+				       struct rvt_pkt_info *pkt)
+{
+	struct rvt_srq *srq = qp->srq;
+
+	if (qp->resp.state == QP_STATE_ERROR) {
+		if (qp->resp.wqe) {
+			qp->resp.status = IB_WC_WR_FLUSH_ERR;
+			return RESPST_COMPLETE;
+		} else if (!srq) {
+			qp->resp.wqe = queue_head(qp->rq.queue);
+			if (qp->resp.wqe) {
+				qp->resp.status = IB_WC_WR_FLUSH_ERR;
+				return RESPST_COMPLETE;
+			} else {
+				return RESPST_EXIT;
+			}
+		} else {
+			return RESPST_EXIT;
+		}
+	}
+
+	if (pkt->mask & RVT_READ_OR_ATOMIC) {
+		/* it is the requesters job to not send
+		   too many read/atomic ops, we just
+		   recycle the responder resource queue */
+		if (likely(qp->attr.max_rd_atomic > 0))
+			return RESPST_CHK_LENGTH;
+		else
+			return RESPST_ERR_TOO_MANY_RDMA_ATM_REQ;
+	}
+
+	if (pkt->mask & RVT_RWR_MASK) {
+		if (srq)
+			return get_srq_wqe(qp);
+
+		qp->resp.wqe = queue_head(qp->rq.queue);
+		return (qp->resp.wqe) ? RESPST_CHK_LENGTH : RESPST_ERR_RNR;
+	}
+
+	return RESPST_CHK_LENGTH;
+}
+
+static enum resp_states check_length(struct rvt_qp *qp,
+				     struct rvt_pkt_info *pkt)
+{
+	switch (qp_type(qp)) {
+	case IB_QPT_RC:
+		return RESPST_CHK_RKEY;
+
+	case IB_QPT_UC:
+		return RESPST_CHK_RKEY;
+
+	default:
+		return RESPST_CHK_RKEY;
+	}
+}
+
+static enum resp_states check_rkey(struct rvt_qp *qp,
+				   struct rvt_pkt_info *pkt)
+{
+	struct rvt_mem *mem;
+	u64 va;
+	u32 rkey;
+	u32 resid;
+	u32 pktlen;
+	int mtu = qp->mtu;
+	enum resp_states state;
+	int access;
+
+	if (pkt->mask & (RVT_READ_MASK | RVT_WRITE_MASK)) {
+		if (pkt->mask & RVT_RETH_MASK) {
+			qp->resp.va = reth_va(pkt);
+			qp->resp.rkey = reth_rkey(pkt);
+			qp->resp.resid = reth_len(pkt);
+		}
+		access = (pkt->mask & RVT_READ_MASK) ? IB_ACCESS_REMOTE_READ
+						     : IB_ACCESS_REMOTE_WRITE;
+	} else if (pkt->mask & RVT_ATOMIC_MASK) {
+		qp->resp.va = atmeth_va(pkt);
+		qp->resp.rkey = atmeth_rkey(pkt);
+		qp->resp.resid = sizeof(u64);
+		access = IB_ACCESS_REMOTE_ATOMIC;
+	} else {
+		return RESPST_EXECUTE;
+	}
+
+	va	= qp->resp.va;
+	rkey	= qp->resp.rkey;
+	resid	= qp->resp.resid;
+	pktlen	= payload_size(pkt);
+
+	mem = lookup_mem(qp->pd, access, rkey, lookup_remote);
+	if (!mem) {
+		state = RESPST_ERR_RKEY_VIOLATION;
+		goto err1;
+	}
+
+	if (mem_check_range(mem, va, resid)) {
+		state = RESPST_ERR_RKEY_VIOLATION;
+		goto err2;
+	}
+
+	if (pkt->mask & RVT_WRITE_MASK)	 {
+		if (resid > mtu) {
+			if (pktlen != mtu || bth_pad(pkt)) {
+				state = RESPST_ERR_LENGTH;
+				goto err2;
+			}
+
+			resid = mtu;
+		} else {
+			if (pktlen != resid) {
+				state = RESPST_ERR_LENGTH;
+				goto err2;
+			}
+			if ((bth_pad(pkt) != (0x3 & (-resid)))) {
+				/* This case may not be exactly that
+				 * but nothing else fits. */
+				state = RESPST_ERR_LENGTH;
+				goto err2;
+			}
+		}
+	}
+
+	WARN_ON(qp->resp.mr);
+
+	qp->resp.mr = mem;
+	return RESPST_EXECUTE;
+
+err2:
+	rvt_drop_ref(mem);
+err1:
+	return state;
+}
+
+static enum resp_states send_data_in(struct rvt_qp *qp, void *data_addr,
+				     int data_len)
+{
+	int err;
+	struct rvt_dev *rvt = to_rdev(qp->ibqp.device);
+
+	err = copy_data(rvt, qp->pd, IB_ACCESS_LOCAL_WRITE, &qp->resp.wqe->dma,
+			data_addr, data_len, to_mem_obj, NULL);
+	if (unlikely(err))
+		return (err == -ENOSPC) ? RESPST_ERR_LENGTH
+					: RESPST_ERR_MALFORMED_WQE;
+
+	return RESPST_NONE;
+}
+
+static enum resp_states write_data_in(struct rvt_qp *qp,
+				      struct rvt_pkt_info *pkt)
+{
+	enum resp_states rc = RESPST_NONE;
+	int	err;
+	int data_len = payload_size(pkt);
+
+	err = rvt_mem_copy(qp->resp.mr, qp->resp.va, payload_addr(pkt),
+			   data_len, to_mem_obj, NULL);
+	if (err) {
+		rc = RESPST_ERR_RKEY_VIOLATION;
+		goto out;
+	}
+
+	qp->resp.va += data_len;
+	qp->resp.resid -= data_len;
+
+out:
+	return rc;
+}
+
+/* Guarantee atomicity of atomic operations at the machine level. */
+static DEFINE_SPINLOCK(atomic_ops_lock);
+
+static enum resp_states process_atomic(struct rvt_qp *qp,
+				       struct rvt_pkt_info *pkt)
+{
+	u64 iova = atmeth_va(pkt);
+	u64 *vaddr;
+	enum resp_states ret;
+	struct rvt_mem *mr = qp->resp.mr;
+
+	if (mr->state != RVT_MEM_STATE_VALID) {
+		ret = RESPST_ERR_RKEY_VIOLATION;
+		goto out;
+	}
+
+	vaddr = iova_to_vaddr(mr, iova, sizeof(u64));
+
+	/* check vaddr is 8 bytes aligned. */
+	if (!vaddr || (uintptr_t)vaddr & 7) {
+		ret = RESPST_ERR_MISALIGNED_ATOMIC;
+		goto out;
+	}
+
+	spin_lock_bh(&atomic_ops_lock);
+
+	qp->resp.atomic_orig = *vaddr;
+
+	if (pkt->opcode == IB_OPCODE_RC_COMPARE_SWAP ||
+	    pkt->opcode == IB_OPCODE_RD_COMPARE_SWAP) {
+		if (*vaddr == atmeth_comp(pkt))
+			*vaddr = atmeth_swap_add(pkt);
+	} else {
+		*vaddr += atmeth_swap_add(pkt);
+	}
+
+	spin_unlock_bh(&atomic_ops_lock);
+
+	ret = RESPST_NONE;
+out:
+	return ret;
+}
+
+static struct sk_buff *prepare_ack_packet(struct rvt_qp *qp,
+					  struct rvt_pkt_info *pkt,
+					  struct rvt_pkt_info *ack,
+					  int opcode,
+					  int payload,
+					  u32 psn,
+					  u8 syndrome)
+{
+	struct rvt_dev *rdev = to_rdev(qp->ibqp.device);
+	struct sk_buff *skb;
+	u32 crc = 0;
+	u32 *p;
+	int paylen;
+	int pad;
+	int err;
+
+	/*
+	 * allocate packet
+	 */
+	pad = (-payload) & 0x3;
+	paylen = rvt_opcode[opcode].length + payload + pad + RVT_ICRC_SIZE;
+
+	skb = rdev->ifc_ops->alloc_sendbuf(rdev, &qp->pri_av, paylen);
+	if (!skb)
+		return NULL;
+
+	pkt->rdev	= rdev;
+	ack->port_num	= 1;
+	ack->hdr	= skb_put(skb, paylen);
+	ack->mask	= RVT_GRH_MASK;
+	ack->qp = qp;
+	ack->opcode = opcode;
+	ack->mask |= rvt_opcode[opcode].mask;
+	ack->offset = pkt->offset;
+	ack->paylen = paylen;
+	if (addr_same(rdev, get_av(ack))) {
+		pkt->mask |= RVT_LOOPBACK_MASK;
+	}
+
+
+	/* fill in bth using the request packet headers */
+	memcpy(ack->hdr, pkt->hdr, pkt->offset + RVT_BTH_BYTES);
+
+	bth_set_opcode(ack, opcode);
+	bth_set_qpn(ack, qp->attr.dest_qp_num);
+	bth_set_pad(ack, pad);
+	bth_set_se(ack, 0);
+	bth_set_psn(ack, psn);
+	bth_set_ack(ack, 0);
+	ack->psn = psn;
+
+	if (ack->mask & RVT_AETH_MASK) {
+		aeth_set_syn(ack, syndrome);
+		aeth_set_msn(ack, qp->resp.msn);
+	}
+
+	if (ack->mask & RVT_ATMACK_MASK)
+		atmack_set_orig(ack, qp->resp.atomic_orig);
+
+	err = rvt_prepare(rdev, ack, skb, &crc);
+	if (err) {
+		kfree_skb(skb);
+		return NULL;
+	}
+
+	p = payload_addr(ack) + payload;
+	*p = ~crc;
+
+	return skb;
+}
+
+/* RDMA read response. If res is not NULL, then we have a current RDMA request
+ * being processed or replayed.
+ */
+static enum resp_states read_reply(struct rvt_qp *qp,
+				   struct rvt_pkt_info *req_pkt)
+{
+	struct rvt_dev *rvt = to_rdev(qp->ibqp.device);
+	struct rvt_pkt_info ack_pkt;
+	struct sk_buff *skb;
+	int mtu = qp->mtu;
+	enum resp_states state;
+	int payload;
+	int opcode;
+	int err;
+	struct resp_res *res = qp->resp.res;
+
+	if (!res) {
+		/* This is the first time we process that request. Get a
+		 * resource
+		 */
+		res = &qp->resp.resources[qp->resp.res_head];
+
+		free_rd_atomic_resource(qp, res);
+		rvt_advance_resp_resource(qp);
+
+		res->type		= RVT_READ_MASK;
+
+		res->read.va		= qp->resp.va;
+		res->read.va_org	= qp->resp.va;
+
+		res->first_psn		= req_pkt->psn;
+		res->last_psn		= req_pkt->psn +
+					  (reth_len(req_pkt) + mtu - 1) /
+					  mtu - 1;
+		res->cur_psn		= req_pkt->psn;
+
+		res->read.resid		= qp->resp.resid;
+		res->read.length	= qp->resp.resid;
+		res->read.rkey		= qp->resp.rkey;
+
+		/* note res inherits the reference to mr from qp */
+		res->read.mr		= qp->resp.mr;
+		qp->resp.mr		= NULL;
+
+		qp->resp.res		= res;
+		res->state		= rdatm_res_state_new;
+	}
+
+	if (res->state == rdatm_res_state_new) {
+		if (res->read.resid <= mtu)
+			opcode = IB_OPCODE_RC_RDMA_READ_RESPONSE_ONLY;
+		else
+			opcode = IB_OPCODE_RC_RDMA_READ_RESPONSE_FIRST;
+	} else {
+		if (res->read.resid > mtu)
+			opcode = IB_OPCODE_RC_RDMA_READ_RESPONSE_MIDDLE;
+		else
+			opcode = IB_OPCODE_RC_RDMA_READ_RESPONSE_LAST;
+	}
+
+	res->state = rdatm_res_state_next;
+
+	payload = min_t(int, res->read.resid, mtu);
+
+	skb = prepare_ack_packet(qp, req_pkt, &ack_pkt, opcode, payload,
+				 res->cur_psn, AETH_ACK_UNLIMITED);
+	if (!skb)
+		return RESPST_ERR_RNR;
+
+	err = rvt_mem_copy(res->read.mr, res->read.va, payload_addr(&ack_pkt),
+			   payload, from_mem_obj, NULL);
+	if (err)
+		pr_err("Failed copying memory\n");
+
+	err = rvt_xmit_packet(rvt, qp, &ack_pkt, skb);
+	if (err) {
+		pr_err("Failed sending RDMA reply.\n");
+		kfree_skb(skb);
+		return RESPST_ERR_RNR;
+	}
+
+	res->read.va += payload;
+	res->read.resid -= payload;
+	res->cur_psn = (res->cur_psn + 1) & BTH_PSN_MASK;
+
+	if (res->read.resid > 0) {
+		state = RESPST_DONE;
+	} else {
+		qp->resp.res = NULL;
+		qp->resp.opcode = -1;
+		qp->resp.psn = res->cur_psn;
+		state = RESPST_CLEANUP;
+	}
+
+	return state;
+}
+
+/* Executes a new request. A retried request never reach that function (send
+ * and writes are discarded, and reads and atomics are retried elsewhere.
+ */
+static enum resp_states execute(struct rvt_qp *qp, struct rvt_pkt_info *pkt)
+{
+	enum resp_states err;
+
+	if (pkt->mask & RVT_SEND_MASK) {
+		if (qp_type(qp) == IB_QPT_UD ||
+		    qp_type(qp) == IB_QPT_SMI ||
+		    qp_type(qp) == IB_QPT_GSI) {
+			struct ib_grh grh;
+			struct sk_buff *skb = PKT_TO_SKB(pkt);
+
+			memset(&grh, 0, sizeof(struct ib_grh));
+			if (skb->protocol == htons(ETH_P_IP)) {
+				__u8 tos = ip_hdr(skb)->tos;
+				struct in6_addr *s_addr =
+					(struct in6_addr *)&grh.sgid;
+				struct in6_addr *d_addr =
+					(struct in6_addr *)&grh.dgid;
+
+				grh.version_tclass_flow =
+					cpu_to_be32((IPVERSION << 28) |
+						    (tos << 24));
+				grh.paylen = ip_hdr(skb)->tot_len;
+				grh.hop_limit = ip_hdr(skb)->ttl;
+				grh.next_hdr = ip_hdr(skb)->protocol;
+				ipv6_addr_set_v4mapped(ip_hdr(skb)->saddr,
+						       s_addr);
+				ipv6_addr_set_v4mapped(ip_hdr(skb)->daddr,
+						       d_addr);
+			} else if (skb->protocol == htons(ETH_P_IPV6)) {
+				memcpy(&grh, ipv6_hdr(skb), sizeof(grh));
+			}
+
+			err = send_data_in(qp, &grh, sizeof(grh));
+			if (err)
+				return err;
+		}
+		err = send_data_in(qp, payload_addr(pkt), payload_size(pkt));
+		if (err)
+			return err;
+	} else if (pkt->mask & RVT_WRITE_MASK) {
+		err = write_data_in(qp, pkt);
+		if (err)
+			return err;
+	} else if (pkt->mask & RVT_READ_MASK) {
+		/* For RDMA Read we can increment the msn now. See C9-148. */
+		qp->resp.msn++;
+		return RESPST_READ_REPLY;
+	} else if (pkt->mask & RVT_ATOMIC_MASK) {
+		err = process_atomic(qp, pkt);
+		if (err)
+			return err;
+	} else
+		/* Unreachable */
+		WARN_ON(1);
+
+	/* We successfully processed this new request. */
+	qp->resp.msn++;
+
+	/* next expected psn, read handles this separately */
+	qp->resp.psn = (pkt->psn + 1) & BTH_PSN_MASK;
+
+	qp->resp.opcode = pkt->opcode;
+	qp->resp.status = IB_WC_SUCCESS;
+
+	if (pkt->mask & RVT_COMP_MASK)
+		return RESPST_COMPLETE;
+	else if (qp_type(qp) == IB_QPT_RC)
+		return RESPST_ACKNOWLEDGE;
+	else
+		return RESPST_CLEANUP;
+}
+
+static enum resp_states do_complete(struct rvt_qp *qp,
+				    struct rvt_pkt_info *pkt)
+{
+	struct rvt_cqe cqe;
+	struct ib_wc *wc = &cqe.ibwc;
+	struct ib_uverbs_wc *uwc = &cqe.uibwc;
+	struct rvt_recv_wqe *wqe = qp->resp.wqe;
+
+	if (unlikely(!wqe))
+		return RESPST_CLEANUP;
+
+	memset(&cqe, 0, sizeof(cqe));
+
+	wc->wr_id		= wqe->wr_id;
+	wc->status		= qp->resp.status;
+	wc->qp			= &qp->ibqp;
+
+	/* fields after status are not required for errors */
+	if (wc->status == IB_WC_SUCCESS) {
+		wc->opcode = (pkt->mask & RVT_IMMDT_MASK &&
+				pkt->mask & RVT_READ_MASK) ?
+					IB_WC_RECV_RDMA_WITH_IMM : IB_WC_RECV;
+		wc->vendor_err = 0;
+		wc->byte_len = wqe->dma.length - wqe->dma.resid;
+
+		/* fields after byte_len are offset between kernel and user
+		 * space
+		 */
+		if (qp->rcq->is_user) {
+			uwc->wc_flags		= IB_WC_GRH;
+
+			if (pkt->mask & RVT_IMMDT_MASK) {
+				uwc->wc_flags |= IB_WC_WITH_IMM;
+				uwc->ex.imm_data =
+					(__u32 __force)immdt_imm(pkt);
+			}
+
+			if (pkt->mask & RVT_IETH_MASK) {
+				uwc->wc_flags |= IB_WC_WITH_INVALIDATE;
+				uwc->ex.invalidate_rkey = ieth_rkey(pkt);
+			}
+
+			uwc->qp_num		= qp->ibqp.qp_num;
+
+			if (pkt->mask & RVT_DETH_MASK)
+				uwc->src_qp = deth_sqp(pkt);
+
+			uwc->port_num		= qp->attr.port_num;
+		} else {
+			wc->wc_flags		= IB_WC_GRH;
+
+			if (pkt->mask & RVT_IMMDT_MASK) {
+				wc->wc_flags |= IB_WC_WITH_IMM;
+				wc->ex.imm_data = immdt_imm(pkt);
+			}
+
+			if (pkt->mask & RVT_IETH_MASK) {
+				wc->wc_flags |= IB_WC_WITH_INVALIDATE;
+				wc->ex.invalidate_rkey = ieth_rkey(pkt);
+			}
+
+			wc->qp			= &qp->ibqp;
+
+			if (pkt->mask & RVT_DETH_MASK)
+				wc->src_qp = deth_sqp(pkt);
+
+			wc->port_num		= qp->attr.port_num;
+		}
+	}
+
+	/* have copy for srq and reference for !srq */
+	if (!qp->srq)
+		advance_consumer(qp->rq.queue);
+
+	qp->resp.wqe = NULL;
+
+	if (rvt_cq_post(qp->rcq, &cqe, pkt ? bth_se(pkt) : 1))
+		return RESPST_ERR_CQ_OVERFLOW;
+
+	if (qp->resp.state == QP_STATE_ERROR)
+		return RESPST_CHK_RESOURCE;
+
+	if (!pkt)
+		return RESPST_DONE;
+	else if (qp_type(qp) == IB_QPT_RC)
+		return RESPST_ACKNOWLEDGE;
+	else
+		return RESPST_CLEANUP;
+}
+
+static int send_ack(struct rvt_qp *qp, struct rvt_pkt_info *pkt,
+		    u8 syndrome, u32 psn)
+{
+	int err = 0;
+	struct rvt_pkt_info ack_pkt;
+	struct sk_buff *skb;
+	struct rvt_dev *rvt = to_rdev(qp->ibqp.device);
+
+	skb = prepare_ack_packet(qp, pkt, &ack_pkt, IB_OPCODE_RC_ACKNOWLEDGE,
+				 0, psn, syndrome);
+	if (!skb) {
+		err = -ENOMEM;
+		goto err1;
+	}
+
+	err = rvt_xmit_packet(rvt, qp, &ack_pkt, skb);
+	if (err) {
+		pr_err("Failed sending ack. This flow is not handled - skb ignored\n");
+		kfree_skb(skb);
+	}
+
+err1:
+	return err;
+}
+
+static int send_atomic_ack(struct rvt_qp *qp, struct rvt_pkt_info *pkt,
+			   u8 syndrome)
+{
+	int rc = 0;
+	struct rvt_pkt_info ack_pkt;
+	struct sk_buff *skb;
+	struct sk_buff *skb_copy;
+	struct rvt_dev *rvt = to_rdev(qp->ibqp.device);
+	struct resp_res *res;
+
+	skb = prepare_ack_packet(qp, pkt, &ack_pkt,
+				 IB_OPCODE_RC_ATOMIC_ACKNOWLEDGE, 0, pkt->psn,
+				 syndrome);
+	if (!skb) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	res = &qp->resp.resources[qp->resp.res_head];
+	free_rd_atomic_resource(qp, res);
+	rvt_advance_resp_resource(qp);
+
+	res->type = RVT_ATOMIC_MASK;
+	res->atomic.skb = skb;
+	res->first_psn = qp->resp.psn;
+	res->last_psn = qp->resp.psn;
+	res->cur_psn = qp->resp.psn;
+
+	skb_copy = skb_clone(skb, GFP_ATOMIC);
+	if (skb_copy)
+		rvt_add_ref(qp); /* for the new SKB */
+	else
+		pr_warn("Could not clone atomic response\n");
+
+	rc = rvt_xmit_packet(rvt, qp, &ack_pkt, skb_copy);
+	if (rc) {
+		pr_err("Failed sending atomic ack. This flow is not handled - skb ignored\n");
+		rvt_drop_ref(qp);
+		kfree_skb(skb_copy);
+	}
+
+out:
+	return rc;
+}
+
+static enum resp_states acknowledge(struct rvt_qp *qp,
+				    struct rvt_pkt_info *pkt)
+{
+	if (qp_type(qp) != IB_QPT_RC)
+		return RESPST_CLEANUP;
+
+	if (qp->resp.aeth_syndrome != AETH_ACK_UNLIMITED)
+		send_ack(qp, pkt, qp->resp.aeth_syndrome, pkt->psn);
+	else if (pkt->mask & RVT_ATOMIC_MASK)
+		send_atomic_ack(qp, pkt, AETH_ACK_UNLIMITED);
+	else if (bth_ack(pkt))
+		send_ack(qp, pkt, AETH_ACK_UNLIMITED, pkt->psn);
+
+	return RESPST_CLEANUP;
+}
+
+static enum resp_states cleanup(struct rvt_qp *qp,
+				struct rvt_pkt_info *pkt)
+{
+	struct sk_buff *skb;
+
+	if (pkt) {
+		skb = skb_dequeue(&qp->req_pkts);
+		rvt_drop_ref(qp);
+		kfree_skb(skb);
+	}
+
+	if (qp->resp.mr) {
+		rvt_drop_ref(qp->resp.mr);
+		qp->resp.mr = NULL;
+	}
+
+	return RESPST_DONE;
+}
+
+static struct resp_res *find_resource(struct rvt_qp *qp, u32 psn)
+{
+	int i;
+
+	for (i = 0; i < qp->attr.max_rd_atomic; i++) {
+		struct resp_res *res = &qp->resp.resources[i];
+
+		if (res->type == 0)
+			continue;
+
+		if (psn_compare(psn, res->first_psn) >= 0 &&
+		    psn_compare(psn, res->last_psn) <= 0) {
+			return res;
+		}
+	}
+
+	return NULL;
+}
+
+static enum resp_states duplicate_request(struct rvt_qp *qp,
+					  struct rvt_pkt_info *pkt)
+{
+	enum resp_states rc;
+
+	if (pkt->mask & RVT_SEND_MASK ||
+	    pkt->mask & RVT_WRITE_MASK) {
+		/* SEND. Ack again and cleanup. C9-105. */
+		if (bth_ack(pkt))
+			send_ack(qp, pkt, AETH_ACK_UNLIMITED, qp->resp.psn - 1);
+		rc = RESPST_CLEANUP;
+		goto out;
+	} else if (pkt->mask & RVT_READ_MASK) {
+		struct resp_res *res;
+
+		res = find_resource(qp, pkt->psn);
+		if (!res) {
+			/* Resource not found. Class D error.  Drop the
+			 * request.
+			 */
+			rc = RESPST_CLEANUP;
+			goto out;
+		} else {
+			/* Ensure this new request is the same as the previous
+			 * one or a subset of it.
+			 */
+			u64 iova = reth_va(pkt);
+			u32 resid = reth_len(pkt);
+
+			if (iova < res->read.va_org ||
+			    resid > res->read.length ||
+			    (iova + resid) > (res->read.va_org +
+					      res->read.length)) {
+				rc = RESPST_CLEANUP;
+				goto out;
+			}
+
+			if (reth_rkey(pkt) != res->read.rkey) {
+				rc = RESPST_CLEANUP;
+				goto out;
+			}
+
+			res->cur_psn = pkt->psn;
+			res->state = (pkt->psn == res->first_psn) ?
+					rdatm_res_state_new :
+					rdatm_res_state_replay;
+
+			/* Reset the resource, except length. */
+			res->read.va_org = iova;
+			res->read.va = iova;
+			res->read.resid = resid;
+
+			/* Replay the RDMA read reply. */
+			qp->resp.res = res;
+			rc = RESPST_READ_REPLY;
+			goto out;
+		}
+	} else {
+		struct resp_res *res;
+
+		WARN_ON((pkt->mask & RVT_ATOMIC_MASK) == 0);
+
+		/* Find the operation in our list of responder resources. */
+		res = find_resource(qp, pkt->psn);
+		if (res) {
+			struct sk_buff *skb_copy;
+
+			skb_copy = skb_clone(res->atomic.skb, GFP_ATOMIC);
+			if (skb_copy) {
+				rvt_add_ref(qp); /* for the new SKB */
+			} else {
+				pr_warn("Couldn't clone atomic resp\n");
+				rc = RESPST_CLEANUP;
+				goto out;
+			}
+			bth_set_psn(SKB_TO_PKT(skb_copy),
+				    qp->resp.psn - 1);
+			/* Resend the result. */
+			rc = rvt_xmit_packet(to_rdev(qp->ibqp.device), qp,
+					     pkt, skb_copy);
+			if (rc) {
+				pr_err("Failed resending result. This flow is not handled - skb ignored\n");
+				kfree_skb(skb_copy);
+				rc = RESPST_CLEANUP;
+				goto out;
+			}
+		}
+
+		/* Resource not found. Class D error. Drop the request. */
+		rc = RESPST_CLEANUP;
+		goto out;
+	}
+out:
+	return rc;
+}
+
+/* Process a class A or C. Both are treated the same in this implementation. */
+static void do_class_ac_error(struct rvt_qp *qp, u8 syndrome,
+			      enum ib_wc_status status)
+{
+	qp->resp.aeth_syndrome	= syndrome;
+	qp->resp.status		= status;
+
+	/* indicate that we should go through the ERROR state */
+	qp->resp.goto_error	= 1;
+}
+
+static enum resp_states do_class_d1e_error(struct rvt_qp *qp)
+{
+	/* UC */
+	if (qp->srq) {
+		/* Class E */
+		qp->resp.drop_msg = 1;
+		if (qp->resp.wqe) {
+			qp->resp.status = IB_WC_REM_INV_REQ_ERR;
+			return RESPST_COMPLETE;
+		} else {
+			return RESPST_CLEANUP;
+		}
+	} else {
+		/* Class D1. This packet may be the start of a
+		 * new message and could be valid. The previous
+		 * message is invalid and ignored. reset the
+		 * recv wr to its original state
+		 */
+		if (qp->resp.wqe) {
+			qp->resp.wqe->dma.resid = qp->resp.wqe->dma.length;
+			qp->resp.wqe->dma.cur_sge = 0;
+			qp->resp.wqe->dma.sge_offset = 0;
+			qp->resp.opcode = -1;
+		}
+
+		if (qp->resp.mr) {
+			rvt_drop_ref(qp->resp.mr);
+			qp->resp.mr = NULL;
+		}
+
+		return RESPST_CLEANUP;
+	}
+}
+
+int rvt_responder(void *arg)
+{
+	struct rvt_qp *qp = (struct rvt_qp *)arg;
+	enum resp_states state;
+	struct rvt_pkt_info *pkt = NULL;
+	int ret = 0;
+
+	qp->resp.aeth_syndrome = AETH_ACK_UNLIMITED;
+
+	if (!qp->valid) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	switch (qp->resp.state) {
+	case QP_STATE_RESET:
+		state = RESPST_RESET;
+		break;
+
+	default:
+		state = RESPST_GET_REQ;
+		break;
+	}
+
+	while (1) {
+		pr_debug("state = %s\n", resp_state_name[state]);
+		switch (state) {
+		case RESPST_GET_REQ:
+			state = get_req(qp, &pkt);
+			break;
+		case RESPST_CHK_PSN:
+			state = check_psn(qp, pkt);
+			break;
+		case RESPST_CHK_OP_SEQ:
+			state = check_op_seq(qp, pkt);
+			break;
+		case RESPST_CHK_OP_VALID:
+			state = check_op_valid(qp, pkt);
+			break;
+		case RESPST_CHK_RESOURCE:
+			state = check_resource(qp, pkt);
+			break;
+		case RESPST_CHK_LENGTH:
+			state = check_length(qp, pkt);
+			break;
+		case RESPST_CHK_RKEY:
+			state = check_rkey(qp, pkt);
+			break;
+		case RESPST_EXECUTE:
+			state = execute(qp, pkt);
+			break;
+		case RESPST_COMPLETE:
+			state = do_complete(qp, pkt);
+			break;
+		case RESPST_READ_REPLY:
+			state = read_reply(qp, pkt);
+			break;
+		case RESPST_ACKNOWLEDGE:
+			state = acknowledge(qp, pkt);
+			break;
+		case RESPST_CLEANUP:
+			state = cleanup(qp, pkt);
+			break;
+		case RESPST_DUPLICATE_REQUEST:
+			state = duplicate_request(qp, pkt);
+			break;
+		case RESPST_ERR_PSN_OUT_OF_SEQ:
+			/* RC only - Class B. Drop packet. */
+			send_ack(qp, pkt, AETH_NAK_PSN_SEQ_ERROR, qp->resp.psn);
+			state = RESPST_CLEANUP;
+			break;
+
+		case RESPST_ERR_TOO_MANY_RDMA_ATM_REQ:
+		case RESPST_ERR_MISSING_OPCODE_FIRST:
+		case RESPST_ERR_MISSING_OPCODE_LAST_C:
+		case RESPST_ERR_UNSUPPORTED_OPCODE:
+		case RESPST_ERR_MISALIGNED_ATOMIC:
+			/* RC Only - Class C. */
+			do_class_ac_error(qp, AETH_NAK_INVALID_REQ,
+					  IB_WC_REM_INV_REQ_ERR);
+			state = RESPST_COMPLETE;
+			break;
+
+		case RESPST_ERR_MISSING_OPCODE_LAST_D1E:
+			state = do_class_d1e_error(qp);
+			break;
+		case RESPST_ERR_RNR:
+			if (qp_type(qp) == IB_QPT_RC) {
+				/* RC - class B */
+				send_ack(qp, pkt, AETH_RNR_NAK |
+					 (~AETH_TYPE_MASK &
+					 qp->attr.min_rnr_timer),
+					 pkt->psn);
+			} else {
+				/* UD/UC - class D */
+				qp->resp.drop_msg = 1;
+			}
+			state = RESPST_CLEANUP;
+			break;
+
+		case RESPST_ERR_RKEY_VIOLATION:
+			if (qp_type(qp) == IB_QPT_RC) {
+				/* Class C */
+				do_class_ac_error(qp, AETH_NAK_REM_ACC_ERR,
+						  IB_WC_REM_ACCESS_ERR);
+				state = RESPST_COMPLETE;
+			} else {
+				qp->resp.drop_msg = 1;
+				if (qp->srq) {
+					/* UC/SRQ Class D */
+					qp->resp.status = IB_WC_REM_ACCESS_ERR;
+					state = RESPST_COMPLETE;
+				} else {
+					/* UC/non-SRQ Class E. */
+					state = RESPST_CLEANUP;
+				}
+			}
+			break;
+
+		case RESPST_ERR_LENGTH:
+			if (qp_type(qp) == IB_QPT_RC) {
+				/* Class C */
+				do_class_ac_error(qp, AETH_NAK_INVALID_REQ,
+						  IB_WC_REM_INV_REQ_ERR);
+				state = RESPST_COMPLETE;
+			} else if (qp->srq) {
+				/* UC/UD - class E */
+				qp->resp.status = IB_WC_REM_INV_REQ_ERR;
+				state = RESPST_COMPLETE;
+			} else {
+				/* UC/UD - class D */
+				qp->resp.drop_msg = 1;
+				state = RESPST_CLEANUP;
+			}
+			break;
+
+		case RESPST_ERR_MALFORMED_WQE:
+			/* All, Class A. */
+			do_class_ac_error(qp, AETH_NAK_REM_OP_ERR,
+					  IB_WC_LOC_QP_OP_ERR);
+			state = RESPST_COMPLETE;
+			break;
+
+		case RESPST_ERR_CQ_OVERFLOW:
+			/* All - Class G */
+			state = RESPST_ERROR;
+			break;
+
+		case RESPST_DONE:
+			if (qp->resp.goto_error) {
+				state = RESPST_ERROR;
+				break;
+			}
+
+			goto done;
+
+		case RESPST_EXIT:
+			if (qp->resp.goto_error) {
+				state = RESPST_ERROR;
+				break;
+			}
+
+			goto exit;
+
+		case RESPST_RESET: {
+			struct sk_buff *skb;
+
+			while ((skb = skb_dequeue(&qp->req_pkts))) {
+				rvt_drop_ref(qp);
+				kfree_skb(skb);
+			}
+
+			while (!qp->srq && qp->rq.queue &&
+			       queue_head(qp->rq.queue))
+				advance_consumer(qp->rq.queue);
+
+			qp->resp.wqe = NULL;
+			goto exit;
+		}
+
+		case RESPST_ERROR:
+			qp->resp.goto_error = 0;
+			pr_warn("qp#%d moved to error state\n", qp_num(qp));
+			rvt_qp_error(qp);
+			goto exit;
+
+		default:
+			WARN_ON(1);
+		}
+	}
+
+exit:
+	ret = -EAGAIN;
+done:
+	return ret;
+}
diff --git a/drivers/infiniband/sw/rdmavt/rvt_srq.c b/drivers/infiniband/sw/rdmavt/rvt_srq.c
new file mode 100644
index 0000000..690523c
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_srq.c
@@ -0,0 +1,194 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#include "rvt_loc.h"
+#include "rvt_queue.h"
+
+int rvt_srq_chk_attr(struct rvt_dev *rvt, struct rvt_srq *srq,
+		     struct ib_srq_attr *attr, enum ib_srq_attr_mask mask)
+{
+	if (srq && srq->error) {
+		pr_warn("srq in error state\n");
+		goto err1;
+	}
+
+	if (mask & IB_SRQ_MAX_WR) {
+		if (attr->max_wr > rvt->attr.max_srq_wr) {
+			pr_warn("max_wr(%d) > max_srq_wr(%d)\n",
+				attr->max_wr, rvt->attr.max_srq_wr);
+			goto err1;
+		}
+
+		if (attr->max_wr <= 0) {
+			pr_warn("max_wr(%d) <= 0\n", attr->max_wr);
+			goto err1;
+		}
+
+		if (srq && srq->limit && (attr->max_wr < srq->limit)) {
+			pr_warn("max_wr (%d) < srq->limit (%d)\n",
+				attr->max_wr, srq->limit);
+			goto err1;
+		}
+
+		if (attr->max_wr < RVT_MIN_SRQ_WR)
+			attr->max_wr = RVT_MIN_SRQ_WR;
+	}
+
+	if (mask & IB_SRQ_LIMIT) {
+		if (attr->srq_limit > rvt->attr.max_srq_wr) {
+			pr_warn("srq_limit(%d) > max_srq_wr(%d)\n",
+				attr->srq_limit, rvt->attr.max_srq_wr);
+			goto err1;
+		}
+
+		if (srq && (attr->srq_limit > srq->rq.queue->buf->index_mask)) {
+			pr_warn("srq_limit (%d) > cur limit(%d)\n",
+				attr->srq_limit,
+				 srq->rq.queue->buf->index_mask);
+			goto err1;
+		}
+	}
+
+	if (mask == IB_SRQ_INIT_MASK) {
+		if (attr->max_sge > rvt->attr.max_srq_sge) {
+			pr_warn("max_sge(%d) > max_srq_sge(%d)\n",
+				attr->max_sge, rvt->attr.max_srq_sge);
+			goto err1;
+		}
+
+		if (attr->max_sge < RVT_MIN_SRQ_SGE)
+			attr->max_sge = RVT_MIN_SRQ_SGE;
+	}
+
+	return 0;
+
+err1:
+	return -EINVAL;
+}
+
+int rvt_srq_from_init(struct rvt_dev *rvt, struct rvt_srq *srq,
+		      struct ib_srq_init_attr *init,
+		      struct ib_ucontext *context, struct ib_udata *udata)
+{
+	int err;
+	int srq_wqe_size;
+	struct rvt_queue *q;
+
+	srq->event_handler	= init->event_handler;
+	srq->context		= init->srq_context;
+	srq->limit		= init->attr.srq_limit;
+	srq->srq_num		= srq->pelem.index;
+	srq->rq.max_wr		= init->attr.max_wr;
+	srq->rq.max_sge		= init->attr.max_sge;
+
+	srq_wqe_size		= rcv_wqe_size(srq->rq.max_sge);
+
+	spin_lock_init(&srq->rq.producer_lock);
+	spin_lock_init(&srq->rq.consumer_lock);
+
+	q = rvt_queue_init(rvt, &srq->rq.max_wr,
+			   srq_wqe_size);
+	if (!q) {
+		pr_warn("unable to allocate queue for srq\n");
+		err = -ENOMEM;
+		goto err1;
+	}
+
+	srq->rq.queue = q;
+
+	err = do_mmap_info(rvt, udata, false, context, q->buf,
+			   q->buf_size, &q->ip);
+	if (err)
+		goto err1;
+
+	if (udata && udata->outlen >= sizeof(struct mminfo) + sizeof(u32))
+		return copy_to_user(udata->outbuf + sizeof(struct mminfo),
+			&srq->srq_num, sizeof(u32));
+	else
+		return 0;
+err1:
+	return err;
+}
+
+int rvt_srq_from_attr(struct rvt_dev *rvt, struct rvt_srq *srq,
+		      struct ib_srq_attr *attr, enum ib_srq_attr_mask mask,
+		      struct ib_udata *udata)
+{
+	int err;
+	struct rvt_queue *q = srq->rq.queue;
+	struct mminfo mi = { .offset = 1, .size = 0};
+
+	if (mask & IB_SRQ_MAX_WR) {
+		/* Check that we can write the mminfo struct to user space */
+		if (udata && udata->inlen >= sizeof(__u64)) {
+			__u64 mi_addr;
+
+			/* Get address of user space mminfo struct */
+			err = ib_copy_from_udata(&mi_addr, udata,
+						 sizeof(mi_addr));
+			if (err)
+				goto err1;
+
+			udata->outbuf = (void __user *)(unsigned long)mi_addr;
+			udata->outlen = sizeof(mi);
+
+			if (!access_ok(VERIFY_WRITE,
+					(void __user *) udata->outbuf,
+					udata->outlen)) {
+				err = -EFAULT;
+				goto err1;
+			}
+		}
+
+		err = rvt_queue_resize(q, (unsigned int *)&attr->max_wr,
+				       rcv_wqe_size(srq->rq.max_sge),
+				       srq->rq.queue->ip ?
+						srq->rq.queue->ip->context :
+						NULL,
+				       udata, &srq->rq.producer_lock,
+				       &srq->rq.consumer_lock);
+		if (err)
+			goto err2;
+	}
+
+	if (mask & IB_SRQ_LIMIT)
+		srq->limit = attr->srq_limit;
+
+	return 0;
+
+err2:
+	rvt_queue_cleanup(q);
+	srq->rq.queue = NULL;
+err1:
+	return err;
+}
diff --git a/drivers/infiniband/sw/rdmavt/rvt_task.c b/drivers/infiniband/sw/rdmavt/rvt_task.c
new file mode 100644
index 0000000..e67b4af
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_task.c
@@ -0,0 +1,154 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *	   Redistribution and use in source and binary forms, with or
+ *	   without modification, are permitted provided that the following
+ *	   conditions are met:
+ *
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/hardirq.h>
+
+#include "rvt_task.h"
+
+int __rvt_do_task(struct rvt_task *task)
+
+{
+	int ret;
+
+	while ((ret = task->func(task->arg)) == 0)
+		;
+
+	task->ret = ret;
+
+	return ret;
+}
+
+/*
+ * this locking is due to a potential race where
+ * a second caller finds the task already running
+ * but looks just after the last call to func
+ */
+void rvt_do_task(unsigned long data)
+{
+	int cont;
+	int ret;
+	unsigned long flags;
+	struct rvt_task *task = (struct rvt_task *)data;
+
+	spin_lock_irqsave(&task->state_lock, flags);
+	switch (task->state) {
+	case TASK_STATE_START:
+		task->state = TASK_STATE_BUSY;
+		spin_unlock_irqrestore(&task->state_lock, flags);
+		break;
+
+	case TASK_STATE_BUSY:
+		task->state = TASK_STATE_ARMED;
+		/* fall through to */
+	case TASK_STATE_ARMED:
+		spin_unlock_irqrestore(&task->state_lock, flags);
+		return;
+
+	default:
+		spin_unlock_irqrestore(&task->state_lock, flags);
+		pr_warn("bad state = %d in rvt_do_task\n", task->state);
+		return;
+	}
+
+	do {
+		cont = 0;
+		ret = task->func(task->arg);
+
+		spin_lock_irqsave(&task->state_lock, flags);
+		switch (task->state) {
+		case TASK_STATE_BUSY:
+			if (ret)
+				task->state = TASK_STATE_START;
+			else
+				cont = 1;
+			break;
+
+		/* soneone tried to run the task since the last time we called
+		 * func, so we will call one more time regardless of the
+		 * return value
+		 */
+		case TASK_STATE_ARMED:
+			task->state = TASK_STATE_BUSY;
+			cont = 1;
+			break;
+
+		default:
+			pr_warn("bad state = %d in rvt_do_task\n",
+				task->state);
+		}
+		spin_unlock_irqrestore(&task->state_lock, flags);
+	} while (cont);
+
+	task->ret = ret;
+}
+
+int rvt_init_task(void *obj, struct rvt_task *task,
+		  void *arg, int (*func)(void *), char *name)
+{
+	task->obj	= obj;
+	task->arg	= arg;
+	task->func	= func;
+	snprintf(task->name, sizeof(task->name), "%s", name);
+
+	tasklet_init(&task->tasklet, rvt_do_task, (unsigned long)task);
+
+	task->state = TASK_STATE_START;
+	spin_lock_init(&task->state_lock);
+
+	return 0;
+}
+
+void rvt_cleanup_task(struct rvt_task *task)
+{
+	tasklet_kill(&task->tasklet);
+}
+
+void rvt_run_task(struct rvt_task *task, int sched)
+{
+	if (sched)
+		tasklet_schedule(&task->tasklet);
+	else
+		rvt_do_task((unsigned long)task);
+}
+
+void rvt_disable_task(struct rvt_task *task)
+{
+	tasklet_disable(&task->tasklet);
+}
+
+void rvt_enable_task(struct rvt_task *task)
+{
+	tasklet_enable(&task->tasklet);
+}
diff --git a/drivers/infiniband/sw/rdmavt/rvt_task.h b/drivers/infiniband/sw/rdmavt/rvt_task.h
new file mode 100644
index 0000000..0561165
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_task.h
@@ -0,0 +1,94 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *	   Redistribution and use in source and binary forms, with or
+ *	   without modification, are permitted provided that the following
+ *	   conditions are met:
+ *
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#ifndef RVT_TASK_H
+#define RVT_TASK_H
+
+enum {
+	TASK_STATE_START	= 0,
+	TASK_STATE_BUSY		= 1,
+	TASK_STATE_ARMED	= 2,
+};
+
+struct rvt_task {
+	void			*obj;
+	struct tasklet_struct	tasklet;
+	int			state;
+	spinlock_t		state_lock; /* spinlock for task state */
+	void			*arg;
+	int			(*func)(void *arg);
+	int			ret;
+	char			name[16];
+};
+
+/* run a task, else schedule it to run as a tasklet, The decision
+ * to run or schedule tasklet is based on the parameter sched.
+ * */
+void rvt_run_task(struct rvt_task *task, int sched);
+/*
+ * data structure to describe a 'task' which is a short
+ * function that returns 0 as long as it needs to be
+ * called again.
+ */
+/*
+ * init rvt_task structure
+ *	arg  => parameter to pass to fcn
+ *	fcn  => function to call until it returns != 0
+ */
+int rvt_init_task(void *obj, struct rvt_task *task,
+		  void *arg, int (*func)(void *), char *name);
+
+/* cleanup task */
+void rvt_cleanup_task(struct rvt_task *task);
+
+/*
+ * raw call to func in loop without any checking
+ * can call when tasklets are disabled
+ */
+int __rvt_do_task(struct rvt_task *task);
+
+/*
+ * common function called by any of the main tasklets
+ * If there is any chance that there is additional
+ * work to do someone must reschedule the task before
+ * leaving
+ */
+void rvt_do_task(unsigned long data);
+
+/* keep a task from scheduling */
+void rvt_disable_task(struct rvt_task *task);
+
+/* allow task to run */
+void rvt_enable_task(struct rvt_task *task);
+
+#endif /* RVT_TASK_H */
diff --git a/drivers/infiniband/sw/rdmavt/rvt_verbs.c b/drivers/infiniband/sw/rdmavt/rvt_verbs.c
new file mode 100644
index 0000000..d74e24f
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_verbs.c
@@ -0,0 +1,1695 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#include "rvt_loc.h"
+#include "rvt_queue.h"
+
+void rvt_cleanup_ports(struct rvt_dev *rvt);
+
+static int rvt_query_device(struct ib_device *dev,
+			    struct ib_device_attr *attr,
+			    struct ib_udata *uhw)
+{
+	struct rvt_dev *rvt = to_rdev(dev);
+
+	if (uhw->inlen || uhw->outlen)
+		return -EINVAL;
+
+	*attr = rvt->attr;
+	return 0;
+}
+
+static void rvt_eth_speed_to_ib_speed(int speed, u8 *active_speed,
+		u8 *active_width)
+{
+	if (speed <= 1000) {
+		*active_width = IB_WIDTH_1X;
+		*active_speed = IB_SPEED_SDR;
+	} else if (speed <= 10000) {
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
+static int rvt_query_port(struct ib_device *dev,
+			  u8 port_num, struct ib_port_attr *attr)
+{
+	struct rvt_dev *rvt = to_rdev(dev);
+	struct rvt_port *port;
+
+	if (unlikely(port_num < 1 || port_num > rvt->num_ports)) {
+		pr_warn("invalid port_number %d\n", port_num);
+		goto err1;
+	}
+
+	port = &rvt->port[port_num - 1];
+
+	*attr = port->attr;
+	return 0;
+
+err1:
+	return -EINVAL;
+}
+
+static int rvt_query_gid(struct ib_device *device,
+			 u8 port_num, int index, union ib_gid *gid)
+{
+	int ret;
+
+	if (index > RVT_PORT_GID_TBL_LEN)
+		return -EINVAL;
+
+	ret = ib_get_cached_gid(device, port_num, index, gid, NULL);
+	if (ret == -EAGAIN) {
+		memcpy(gid, &zgid, sizeof(*gid));
+		return 0;
+	}
+
+	return ret;
+}
+
+static int rvt_add_gid(struct ib_device *device, u8 port_num, unsigned int
+		       index, const union ib_gid *gid,
+		       const struct ib_gid_attr *attr, void **context)
+{
+	return 0;
+}
+
+static int rvt_del_gid(struct ib_device *device, u8 port_num, unsigned int
+		       index, void **context)
+{
+	return 0;
+}
+
+static struct net_device *rvt_get_netdev(struct ib_device *device,
+					 u8 port_num)
+{
+	struct rvt_dev *rdev = to_rdev(device);
+
+	if (rdev->ifc_ops->get_netdev)
+		return rdev->ifc_ops->get_netdev(rdev, port_num);
+
+	return NULL;
+}
+
+static int rvt_query_pkey(struct ib_device *device,
+			  u8 port_num, u16 index, u16 *pkey)
+{
+	struct rvt_dev *rvt = to_rdev(device);
+	struct rvt_port *port;
+
+	if (unlikely(port_num < 1 || port_num > rvt->num_ports)) {
+		dev_warn(device->dma_device, "invalid port_num = %d\n",
+			 port_num);
+		goto err1;
+	}
+
+	port = &rvt->port[port_num - 1];
+
+	if (unlikely(index >= port->attr.pkey_tbl_len)) {
+		dev_warn(device->dma_device, "invalid index = %d\n",
+			 index);
+		goto err1;
+	}
+
+	*pkey = port->pkey_tbl[index];
+	return 0;
+
+err1:
+	return -EINVAL;
+}
+
+static int rvt_modify_device(struct ib_device *dev,
+			     int mask, struct ib_device_modify *attr)
+{
+	struct rvt_dev *rvt = to_rdev(dev);
+
+	if (mask & IB_DEVICE_MODIFY_SYS_IMAGE_GUID)
+		rvt->attr.sys_image_guid = cpu_to_be64(attr->sys_image_guid);
+
+	if (mask & IB_DEVICE_MODIFY_NODE_DESC) {
+		memcpy(rvt->ib_dev.node_desc,
+		       attr->node_desc, sizeof(rvt->ib_dev.node_desc));
+	}
+
+	return 0;
+}
+
+static int rvt_modify_port(struct ib_device *dev,
+			   u8 port_num, int mask, struct ib_port_modify *attr)
+{
+	struct rvt_dev *rvt = to_rdev(dev);
+	struct rvt_port *port;
+
+	if (unlikely(port_num < 1 || port_num > rvt->num_ports)) {
+		pr_warn("invalid port_num = %d\n", port_num);
+		goto err1;
+	}
+
+	port = &rvt->port[port_num - 1];
+
+	port->attr.port_cap_flags |= attr->set_port_cap_mask;
+	port->attr.port_cap_flags &= ~attr->clr_port_cap_mask;
+
+	if (mask & IB_PORT_RESET_QKEY_CNTR)
+		port->attr.qkey_viol_cntr = 0;
+
+	return 0;
+
+err1:
+	return -EINVAL;
+}
+
+static enum rdma_link_layer rvt_get_link_layer(struct ib_device *dev,
+					       u8 port_num)
+{
+	struct rvt_dev *rvt = to_rdev(dev);
+
+	return rvt->ifc_ops->link_layer(rvt, port_num);
+}
+
+static struct ib_ucontext *rvt_alloc_ucontext(struct ib_device *dev,
+					      struct ib_udata *udata)
+{
+	struct rvt_dev *rvt = to_rdev(dev);
+	struct rvt_ucontext *uc;
+
+	uc = rvt_alloc(&rvt->uc_pool);
+	return uc ? &uc->ibuc : ERR_PTR(-ENOMEM);
+}
+
+static int rvt_dealloc_ucontext(struct ib_ucontext *ibuc)
+{
+	struct rvt_ucontext *uc = to_ruc(ibuc);
+
+	rvt_drop_ref(uc);
+	return 0;
+}
+
+static int rvt_port_immutable(struct ib_device *dev, u8 port_num,
+			      struct ib_port_immutable *immutable)
+{
+	int err;
+	struct ib_port_attr attr;
+
+	err = rvt_query_port(dev, port_num, &attr);
+	if (err)
+		return err;
+
+	immutable->pkey_tbl_len = attr.pkey_tbl_len;
+	immutable->gid_tbl_len = attr.gid_tbl_len;
+	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP;
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
+
+	return 0;
+}
+
+static struct ib_pd *rvt_alloc_pd(struct ib_device *dev,
+				  struct ib_ucontext *context,
+				  struct ib_udata *udata)
+{
+	struct rvt_dev *rvt = to_rdev(dev);
+	struct rvt_pd *pd;
+
+	pd = rvt_alloc(&rvt->pd_pool);
+	return pd ? &pd->ibpd : ERR_PTR(-ENOMEM);
+}
+
+static int rvt_dealloc_pd(struct ib_pd *ibpd)
+{
+	struct rvt_pd *pd = to_rpd(ibpd);
+
+	rvt_drop_ref(pd);
+	return 0;
+}
+
+static int rvt_init_av(struct rvt_dev *rvt, struct ib_ah_attr *attr,
+		       union ib_gid *sgid, struct ib_gid_attr *sgid_attr,
+		       struct rvt_av *av)
+{
+	int err;
+
+	err = ib_get_cached_gid(&rvt->ib_dev, attr->port_num,
+				attr->grh.sgid_index, sgid,
+				sgid_attr);
+	if (err) {
+		pr_err("Failed to query sgid. err = %d\n", err);
+		return err;
+	}
+
+	err = rvt_av_from_attr(rvt, attr->port_num, av, attr);
+	if (err)
+		return err;
+
+	err = rvt_av_fill_ip_info(rvt, av, attr, sgid_attr, sgid);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static struct ib_ah *rvt_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
+{
+	int err;
+	struct rvt_dev *rvt = to_rdev(ibpd->device);
+	struct rvt_pd *pd = to_rpd(ibpd);
+	struct rvt_ah *ah;
+	union ib_gid sgid;
+	struct ib_gid_attr sgid_attr;
+
+	err = rvt_av_chk_attr(rvt, attr);
+	if (err)
+		goto err1;
+
+	ah = rvt_alloc(&rvt->ah_pool);
+	if (!ah) {
+		err = -ENOMEM;
+		goto err1;
+	}
+
+	rvt_add_ref(pd);
+	ah->pd = pd;
+
+	err = rvt_init_av(rvt, attr, &sgid, &sgid_attr, &ah->av);
+	if (err)
+		goto err2;
+
+	return &ah->ibah;
+
+err2:
+	rvt_drop_ref(pd);
+	rvt_drop_ref(ah);
+err1:
+	return ERR_PTR(err);
+}
+
+static int rvt_modify_ah(struct ib_ah *ibah, struct ib_ah_attr *attr)
+{
+	int err;
+	struct rvt_dev *rvt = to_rdev(ibah->device);
+	struct rvt_ah *ah = to_rah(ibah);
+	union ib_gid sgid;
+	struct ib_gid_attr sgid_attr;
+
+	err = rvt_av_chk_attr(rvt, attr);
+	if (err)
+		return err;
+
+	err = rvt_init_av(rvt, attr, &sgid, &sgid_attr, &ah->av);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int rvt_query_ah(struct ib_ah *ibah, struct ib_ah_attr *attr)
+{
+	struct rvt_dev *rvt = to_rdev(ibah->device);
+	struct rvt_ah *ah = to_rah(ibah);
+
+	rvt_av_to_attr(rvt, &ah->av, attr);
+	return 0;
+}
+
+static int rvt_destroy_ah(struct ib_ah *ibah)
+{
+	struct rvt_ah *ah = to_rah(ibah);
+
+	rvt_drop_ref(ah->pd);
+	rvt_drop_ref(ah);
+	return 0;
+}
+
+static int post_one_recv(struct rvt_rq *rq, struct ib_recv_wr *ibwr)
+{
+	int err;
+	int i;
+	u32 length;
+	struct rvt_recv_wqe *recv_wqe;
+	int num_sge = ibwr->num_sge;
+
+	if (unlikely(queue_full(rq->queue))) {
+		err = -ENOMEM;
+		goto err1;
+	}
+
+	if (unlikely(num_sge > rq->max_sge)) {
+		err = -EINVAL;
+		goto err1;
+	}
+
+	length = 0;
+	for (i = 0; i < num_sge; i++)
+		length += ibwr->sg_list[i].length;
+
+	recv_wqe = producer_addr(rq->queue);
+	recv_wqe->wr_id = ibwr->wr_id;
+	recv_wqe->num_sge = num_sge;
+
+	memcpy(recv_wqe->dma.sge, ibwr->sg_list,
+	       num_sge * sizeof(struct ib_sge));
+
+	recv_wqe->dma.length		= length;
+	recv_wqe->dma.resid		= length;
+	recv_wqe->dma.num_sge		= num_sge;
+	recv_wqe->dma.cur_sge		= 0;
+	recv_wqe->dma.sge_offset	= 0;
+
+	/* make sure all changes to the work queue are written before we
+	 * update the producer pointer
+	 */
+	smp_wmb();
+
+	advance_producer(rq->queue);
+	return 0;
+
+err1:
+	return err;
+}
+
+static struct ib_srq *rvt_create_srq(struct ib_pd *ibpd,
+				     struct ib_srq_init_attr *init,
+				     struct ib_udata *udata)
+{
+	int err;
+	struct rvt_dev *rvt = to_rdev(ibpd->device);
+	struct rvt_pd *pd = to_rpd(ibpd);
+	struct rvt_srq *srq;
+	struct ib_ucontext *context = udata ? ibpd->uobject->context : NULL;
+
+	err = rvt_srq_chk_attr(rvt, NULL, &init->attr, IB_SRQ_INIT_MASK);
+	if (err)
+		goto err1;
+
+	srq = rvt_alloc(&rvt->srq_pool);
+	if (!srq) {
+		err = -ENOMEM;
+		goto err1;
+	}
+
+	rvt_add_index(srq);
+	rvt_add_ref(pd);
+	srq->pd = pd;
+
+	err = rvt_srq_from_init(rvt, srq, init, context, udata);
+	if (err)
+		goto err2;
+
+	return &srq->ibsrq;
+
+err2:
+	rvt_drop_ref(pd);
+	rvt_drop_index(srq);
+	rvt_drop_ref(srq);
+err1:
+	return ERR_PTR(err);
+}
+
+static int rvt_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
+			  enum ib_srq_attr_mask mask,
+			  struct ib_udata *udata)
+{
+	int err;
+	struct rvt_srq *srq = to_rsrq(ibsrq);
+	struct rvt_dev *rvt = to_rdev(ibsrq->device);
+
+	err = rvt_srq_chk_attr(rvt, srq, attr, mask);
+	if (err)
+		goto err1;
+
+	err = rvt_srq_from_attr(rvt, srq, attr, mask, udata);
+	if (err)
+		goto err1;
+
+	return 0;
+
+err1:
+	return err;
+}
+
+static int rvt_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr)
+{
+	struct rvt_srq *srq = to_rsrq(ibsrq);
+
+	if (srq->error)
+		return -EINVAL;
+
+	attr->max_wr = srq->rq.queue->buf->index_mask;
+	attr->max_sge = srq->rq.max_sge;
+	attr->srq_limit = srq->limit;
+	return 0;
+}
+
+static int rvt_destroy_srq(struct ib_srq *ibsrq)
+{
+	struct rvt_srq *srq = to_rsrq(ibsrq);
+
+	if (srq->cq)
+		rvt_drop_ref(srq->cq);
+
+	if(srq->rq.queue)
+		rvt_queue_cleanup(srq->rq.queue);
+
+	rvt_drop_ref(srq->pd);
+	rvt_drop_index(srq);
+	rvt_drop_ref(srq);
+
+	return 0;
+}
+
+static int rvt_post_srq_recv(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
+			     struct ib_recv_wr **bad_wr)
+{
+	int err = 0;
+	unsigned long flags;
+	struct rvt_srq *srq = to_rsrq(ibsrq);
+
+	spin_lock_irqsave(&srq->rq.producer_lock, flags);
+
+	while (wr) {
+		err = post_one_recv(&srq->rq, wr);
+		if (unlikely(err))
+			break;
+		wr = wr->next;
+	}
+
+	spin_unlock_irqrestore(&srq->rq.producer_lock, flags);
+
+	if (err)
+		*bad_wr = wr;
+
+	return err;
+}
+
+static struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
+				   struct ib_qp_init_attr *init,
+				   struct ib_udata *udata)
+{
+	int err;
+	struct rvt_dev *rvt = to_rdev(ibpd->device);
+	struct rvt_pd *pd = to_rpd(ibpd);
+	struct rvt_qp *qp;
+
+	err = rvt_qp_chk_init(rvt, init);
+	if (err)
+		goto err1;
+
+	qp = rvt_alloc(&rvt->qp_pool);
+	if (!qp) {
+		err = -ENOMEM;
+		goto err1;
+	}
+
+	rvt_add_index(qp);
+
+	if (udata)
+		qp->is_user = 1;
+
+	err = rvt_qp_from_init(rvt, qp, pd, init, udata, ibpd);
+	if (err)
+		goto err2;
+
+	return &qp->ibqp;
+
+err2:
+	rvt_drop_index(qp);
+	rvt_drop_ref(qp);
+err1:
+	return ERR_PTR(err);
+}
+
+static int rvt_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+			 int mask, struct ib_udata *udata)
+{
+	int err;
+	struct rvt_dev *rvt = to_rdev(ibqp->device);
+	struct rvt_qp *qp = to_rqp(ibqp);
+
+	err = rvt_qp_chk_attr(rvt, qp, attr, mask);
+	if (err)
+		goto err1;
+
+	err = rvt_qp_from_attr(qp, attr, mask, udata);
+	if (err)
+		goto err1;
+
+	return 0;
+
+err1:
+	return err;
+}
+
+static int rvt_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+			int mask, struct ib_qp_init_attr *init)
+{
+	struct rvt_qp *qp = to_rqp(ibqp);
+
+	rvt_qp_to_init(qp, init);
+	rvt_qp_to_attr(qp, attr, mask);
+
+	return 0;
+}
+
+static int rvt_destroy_qp(struct ib_qp *ibqp)
+{
+	struct rvt_qp *qp = to_rqp(ibqp);
+
+	rvt_qp_destroy(qp);
+	rvt_drop_index(qp);
+	rvt_drop_ref(qp);
+	return 0;
+}
+
+static int validate_send_wr(struct rvt_qp *qp, struct ib_send_wr *ibwr,
+			    unsigned int mask, unsigned int length)
+{
+	int num_sge = ibwr->num_sge;
+	struct rvt_sq *sq = &qp->sq;
+
+	if (unlikely(num_sge > sq->max_sge))
+		goto err1;
+
+	if (unlikely(mask & WR_ATOMIC_MASK)) {
+		if (length < 8)
+			goto err1;
+
+		if (atomic_wr(ibwr)->remote_addr & 0x7)
+			goto err1;
+	}
+
+	if (unlikely((ibwr->send_flags & IB_SEND_INLINE) &&
+		     (length > sq->max_inline)))
+		goto err1;
+
+	return 0;
+
+err1:
+	return -EINVAL;
+}
+
+static void init_send_wr(struct rvt_qp *qp, struct rvt_send_wr *wr,
+			 struct ib_send_wr *ibwr)
+{
+	wr->wr_id = ibwr->wr_id;
+	wr->num_sge = ibwr->num_sge;
+	wr->opcode = ibwr->opcode;
+	wr->send_flags = ibwr->send_flags;
+
+	if (qp_type(qp) == IB_QPT_UD ||
+	    qp_type(qp) == IB_QPT_SMI ||
+	    qp_type(qp) == IB_QPT_GSI) {
+		wr->wr.ud.remote_qpn = ud_wr(ibwr)->remote_qpn;
+		wr->wr.ud.remote_qkey = ud_wr(ibwr)->remote_qkey;
+		if (qp_type(qp) == IB_QPT_GSI)
+			wr->wr.ud.pkey_index = ud_wr(ibwr)->pkey_index;
+		if (wr->opcode == IB_WR_SEND_WITH_IMM)
+			wr->ex.imm_data = ibwr->ex.imm_data;
+	} else {
+		switch (wr->opcode) {
+		case IB_WR_RDMA_WRITE_WITH_IMM:
+			wr->ex.imm_data = ibwr->ex.imm_data;
+		case IB_WR_RDMA_READ:
+		case IB_WR_RDMA_WRITE:
+			wr->wr.rdma.remote_addr = rdma_wr(ibwr)->remote_addr;
+			wr->wr.rdma.rkey	= rdma_wr(ibwr)->rkey;
+			break;
+		case IB_WR_SEND_WITH_IMM:
+			wr->ex.imm_data = ibwr->ex.imm_data;
+			break;
+		case IB_WR_SEND_WITH_INV:
+			wr->ex.invalidate_rkey = ibwr->ex.invalidate_rkey;
+			break;
+		case IB_WR_ATOMIC_CMP_AND_SWP:
+		case IB_WR_ATOMIC_FETCH_AND_ADD:
+			wr->wr.atomic.remote_addr =
+				atomic_wr(ibwr)->remote_addr;
+			wr->wr.atomic.compare_add =
+				atomic_wr(ibwr)->compare_add;
+			wr->wr.atomic.swap = atomic_wr(ibwr)->swap;
+			wr->wr.atomic.rkey = atomic_wr(ibwr)->rkey;
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+static int init_send_wqe(struct rvt_qp *qp, struct ib_send_wr *ibwr,
+			 unsigned int mask, unsigned int length,
+			 struct rvt_send_wqe *wqe)
+{
+	int num_sge = ibwr->num_sge;
+	struct ib_sge *sge;
+	int i;
+	u8 *p;
+
+	init_send_wr(qp, &wqe->wr, ibwr);
+
+	if (qp_type(qp) == IB_QPT_UD ||
+	    qp_type(qp) == IB_QPT_SMI ||
+	    qp_type(qp) == IB_QPT_GSI)
+		memcpy(&wqe->av, &to_rah(ud_wr(ibwr)->ah)->av, sizeof(wqe->av));
+
+	if (unlikely(ibwr->send_flags & IB_SEND_INLINE)) {
+		p = wqe->dma.inline_data;
+
+		sge = ibwr->sg_list;
+		for (i = 0; i < num_sge; i++, sge++) {
+			if (qp->is_user && copy_from_user(p, (__user void *)
+					    (uintptr_t)sge->addr, sge->length))
+				return -EFAULT;
+
+			else if (!qp->is_user)
+				memcpy(p, (void *)(uintptr_t)sge->addr,
+				       sge->length);
+
+			p += sge->length;
+		}
+	} else
+		memcpy(wqe->dma.sge, ibwr->sg_list,
+		       num_sge * sizeof(struct ib_sge));
+
+	wqe->iova		= (mask & WR_ATOMIC_MASK) ?
+					atomic_wr(ibwr)->remote_addr :
+					atomic_wr(ibwr)->remote_addr;
+	wqe->mask		= mask;
+	wqe->dma.length		= length;
+	wqe->dma.resid		= length;
+	wqe->dma.num_sge	= num_sge;
+	wqe->dma.cur_sge	= 0;
+	wqe->dma.sge_offset	= 0;
+	wqe->state		= wqe_state_posted;
+	wqe->ssn		= atomic_add_return(1, &qp->ssn);
+
+	return 0;
+}
+
+static int post_one_send(struct rvt_qp *qp, struct ib_send_wr *ibwr,
+			 unsigned mask, u32 length)
+{
+	int err;
+	struct rvt_sq *sq = &qp->sq;
+	struct rvt_send_wqe *send_wqe;
+	unsigned long flags;
+
+	err = validate_send_wr(qp, ibwr, mask, length);
+	if (err)
+		return err;
+
+	spin_lock_irqsave(&qp->sq.sq_lock, flags);
+
+	if (unlikely(queue_full(sq->queue))) {
+		err = -ENOMEM;
+		goto err1;
+	}
+
+	send_wqe = producer_addr(sq->queue);
+
+	err = init_send_wqe(qp, ibwr, mask, length, send_wqe);
+	if (unlikely(err))
+		goto err1;
+
+	/* make sure all changes to the work queue are
+	   written before we update the producer pointer */
+	smp_wmb();
+
+	advance_producer(sq->queue);
+	spin_unlock_irqrestore(&qp->sq.sq_lock, flags);
+
+	return 0;
+
+err1:
+	spin_unlock_irqrestore(&qp->sq.sq_lock, flags);
+	return err;
+}
+
+static int rvt_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
+			 struct ib_send_wr **bad_wr)
+{
+	int err = 0;
+	struct rvt_qp *qp = to_rqp(ibqp);
+	unsigned int mask;
+	unsigned int length = 0;
+	int i;
+	int must_sched;
+
+	if (unlikely(!qp->valid)) {
+		*bad_wr = wr;
+		return -EINVAL;
+	}
+
+	if (unlikely(qp->req.state < QP_STATE_READY)) {
+		*bad_wr = wr;
+		return -EINVAL;
+	}
+
+	while (wr) {
+		mask = wr_opcode_mask(wr->opcode, qp);
+		if (unlikely(!mask)) {
+			err = -EINVAL;
+			*bad_wr = wr;
+			break;
+		}
+
+		if (unlikely((wr->send_flags & IB_SEND_INLINE) &&
+			     !(mask & WR_INLINE_MASK))) {
+			err = -EINVAL;
+			*bad_wr = wr;
+			break;
+		}
+
+		length = 0;
+		for (i = 0; i < wr->num_sge; i++)
+			length += wr->sg_list[i].length;
+
+		err = post_one_send(qp, wr, mask, length);
+
+		if (err) {
+			*bad_wr = wr;
+			break;
+		}
+		wr = wr->next;
+	}
+
+	/*
+	 * Must sched in case of GSI QP because ib_send_mad() hold irq lock,
+	 * and the requester call ip_local_out_sk() that takes spin_lock_bh.
+	 */
+	must_sched = (qp_type(qp) == IB_QPT_GSI) ||
+			(queue_count(qp->sq.queue) > 1);
+
+	rvt_run_task(&qp->req.task, must_sched);
+
+	return err;
+}
+
+static int rvt_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
+			 struct ib_recv_wr **bad_wr)
+{
+	int err = 0;
+	struct rvt_qp *qp = to_rqp(ibqp);
+	struct rvt_rq *rq = &qp->rq;
+	unsigned long flags;
+
+	if (unlikely((qp_state(qp) < IB_QPS_INIT) || !qp->valid)) {
+		*bad_wr = wr;
+		err = -EINVAL;
+		goto err1;
+	}
+
+	if (unlikely(qp->srq)) {
+		*bad_wr = wr;
+		err = -EINVAL;
+		goto err1;
+	}
+
+	spin_lock_irqsave(&rq->producer_lock, flags);
+
+	while (wr) {
+		err = post_one_recv(rq, wr);
+		if (unlikely(err)) {
+			*bad_wr = wr;
+			break;
+		}
+		wr = wr->next;
+	}
+
+	spin_unlock_irqrestore(&rq->producer_lock, flags);
+
+err1:
+	return err;
+}
+
+static struct ib_cq *rvt_create_cq(struct ib_device *dev,
+				   const struct ib_cq_init_attr *attr,
+				   struct ib_ucontext *context,
+				   struct ib_udata *udata)
+{
+	int err;
+	struct rvt_dev *rvt = to_rdev(dev);
+	struct rvt_cq *cq;
+
+	if (attr->flags)
+		return ERR_PTR(-EINVAL);
+
+	err = rvt_cq_chk_attr(rvt, NULL, attr->cqe, attr->comp_vector, udata);
+	if (err)
+		goto err1;
+
+	cq = rvt_alloc(&rvt->cq_pool);
+	if (!cq) {
+		err = -ENOMEM;
+		goto err1;
+	}
+
+	err = rvt_cq_from_init(rvt, cq, attr->cqe, attr->comp_vector,
+			       context, udata);
+	if (err)
+		goto err2;
+
+	return &cq->ibcq;
+
+err2:
+	rvt_drop_ref(cq);
+err1:
+	return ERR_PTR(err);
+}
+
+static int rvt_destroy_cq(struct ib_cq *ibcq)
+{
+	struct rvt_cq *cq = to_rcq(ibcq);
+
+	rvt_drop_ref(cq);
+	return 0;
+}
+
+static int rvt_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
+{
+	int err;
+	struct rvt_cq *cq = to_rcq(ibcq);
+	struct rvt_dev *rvt = to_rdev(ibcq->device);
+
+	err = rvt_cq_chk_attr(rvt, cq, cqe, 0, udata);
+	if (err)
+		goto err1;
+
+	err = rvt_cq_resize_queue(cq, cqe, udata);
+	if (err)
+		goto err1;
+
+	return 0;
+
+err1:
+	return err;
+}
+
+static int rvt_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
+{
+	int i;
+	struct rvt_cq *cq = to_rcq(ibcq);
+	struct rvt_cqe *cqe;
+
+	for (i = 0; i < num_entries; i++) {
+		cqe = queue_head(cq->queue);
+		if (!cqe)
+			break;
+
+		memcpy(wc++, &cqe->ibwc, sizeof(*wc));
+		advance_consumer(cq->queue);
+	}
+
+	return i;
+}
+
+static int rvt_peek_cq(struct ib_cq *ibcq, int wc_cnt)
+{
+	struct rvt_cq *cq = to_rcq(ibcq);
+	int count = queue_count(cq->queue);
+
+	return (count > wc_cnt) ? wc_cnt : count;
+}
+
+static int rvt_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
+{
+	struct rvt_cq *cq = to_rcq(ibcq);
+
+	if (cq->notify != IB_CQ_NEXT_COMP)
+		cq->notify = flags & IB_CQ_SOLICITED_MASK;
+
+	return 0;
+}
+
+static struct ib_mr *rvt_get_dma_mr(struct ib_pd *ibpd, int access)
+{
+	struct rvt_dev *rvt = to_rdev(ibpd->device);
+	struct rvt_pd *pd = to_rpd(ibpd);
+	struct rvt_mem *mr;
+	int err;
+
+	mr = rvt_alloc(&rvt->mr_pool);
+	if (!mr) {
+		err = -ENOMEM;
+		goto err1;
+	}
+
+	rvt_add_index(mr);
+
+	rvt_add_ref(pd);
+
+	err = rvt_mem_init_dma(rvt, pd, access, mr);
+	if (err)
+		goto err2;
+
+	return &mr->ibmr;
+
+err2:
+	rvt_drop_ref(pd);
+	rvt_drop_index(mr);
+	rvt_drop_ref(mr);
+err1:
+	return ERR_PTR(err);
+}
+
+static struct ib_mr *rvt_reg_phys_mr(struct ib_pd *ibpd,
+				     struct rvt_phys_buf *phys_buf_array,
+				     int num_phys_buf,
+				     int access, u64 *iova_start)
+{
+	int err;
+	struct rvt_dev *rvt = to_rdev(ibpd->device);
+	struct rvt_pd *pd = to_rpd(ibpd);
+	struct rvt_mem *mr;
+	u64 iova = *iova_start;
+
+	mr = rvt_alloc(&rvt->mr_pool);
+	if (!mr) {
+		err = -ENOMEM;
+		goto err1;
+	}
+
+	rvt_add_index(mr);
+
+	rvt_add_ref(pd);
+
+	err = rvt_mem_init_phys(rvt, pd, access, iova,
+				phys_buf_array, num_phys_buf, mr);
+	if (err)
+		goto err2;
+
+	return &mr->ibmr;
+
+err2:
+	rvt_drop_ref(pd);
+	rvt_drop_index(mr);
+	rvt_drop_ref(mr);
+err1:
+	return ERR_PTR(err);
+}
+
+static struct ib_mr *rvt_reg_user_mr(struct ib_pd *ibpd,
+				     u64 start,
+				     u64 length,
+				     u64 iova,
+				     int access, struct ib_udata *udata)
+{
+	int err;
+	struct rvt_dev *rvt = to_rdev(ibpd->device);
+	struct rvt_pd *pd = to_rpd(ibpd);
+	struct rvt_mem *mr;
+
+	mr = rvt_alloc(&rvt->mr_pool);
+	if (!mr) {
+		err = -ENOMEM;
+		goto err2;
+	}
+
+	rvt_add_index(mr);
+
+	rvt_add_ref(pd);
+
+	err = rvt_mem_init_user(rvt, pd, start, length, iova,
+				access, udata, mr);
+	if (err)
+		goto err3;
+
+	return &mr->ibmr;
+
+err3:
+	rvt_drop_ref(pd);
+	rvt_drop_index(mr);
+	rvt_drop_ref(mr);
+err2:
+	return ERR_PTR(err);
+}
+
+static int rvt_dereg_mr(struct ib_mr *ibmr)
+{
+	struct rvt_mem *mr = to_rmr(ibmr);
+
+	mr->state = RVT_MEM_STATE_ZOMBIE;
+	rvt_drop_ref(mr->pd);
+	rvt_drop_index(mr);
+	rvt_drop_ref(mr);
+	return 0;
+}
+
+static struct ib_mr *rvt_alloc_mr(struct ib_pd *ibpd,
+				  enum ib_mr_type mr_type,
+				  u32 max_num_sg)
+{
+	struct rvt_dev *rvt = to_rdev(ibpd->device);
+	struct rvt_pd *pd = to_rpd(ibpd);
+	struct rvt_mem *mr;
+	int err;
+
+	if (mr_type != IB_MR_TYPE_MEM_REG)
+		return ERR_PTR(-EINVAL);
+
+	mr = rvt_alloc(&rvt->mr_pool);
+	if (!mr) {
+		err = -ENOMEM;
+		goto err1;
+	}
+
+	rvt_add_index(mr);
+
+	rvt_add_ref(pd);
+
+	err = rvt_mem_init_fast(rvt, pd, max_num_sg, mr);
+	if (err)
+		goto err2;
+
+	return &mr->ibmr;
+
+err2:
+	rvt_drop_ref(pd);
+	rvt_drop_index(mr);
+	rvt_drop_ref(mr);
+err1:
+	return ERR_PTR(err);
+}
+
+static struct ib_mw *rvt_alloc_mw(struct ib_pd *ibpd, enum ib_mw_type type)
+{
+	struct rvt_dev *rvt = to_rdev(ibpd->device);
+	struct rvt_pd *pd = to_rpd(ibpd);
+	struct rvt_mem *mw;
+	int err;
+
+	if (type != IB_MW_TYPE_1)
+		return ERR_PTR(-EINVAL);
+
+	mw = rvt_alloc(&rvt->mw_pool);
+	if (!mw) {
+		err = -ENOMEM;
+		goto err1;
+	}
+
+	rvt_add_index(mw);
+
+	rvt_add_ref(pd);
+
+	err = rvt_mem_init_mw(rvt, pd, mw);
+	if (err)
+		goto err2;
+
+	return &mw->ibmw;
+
+err2:
+	rvt_drop_ref(pd);
+	rvt_drop_index(mw);
+	rvt_drop_ref(mw);
+err1:
+	return ERR_PTR(err);
+}
+
+static int rvt_dealloc_mw(struct ib_mw *ibmw)
+{
+	struct rvt_mem *mw = to_rmw(ibmw);
+
+	mw->state = RVT_MEM_STATE_ZOMBIE;
+	rvt_drop_ref(mw->pd);
+	rvt_drop_index(mw);
+	rvt_drop_ref(mw);
+	return 0;
+}
+
+static struct ib_fmr *rvt_alloc_fmr(struct ib_pd *ibpd,
+				    int access, struct ib_fmr_attr *attr)
+{
+	struct rvt_dev *rvt = to_rdev(ibpd->device);
+	struct rvt_pd *pd = to_rpd(ibpd);
+	struct rvt_mem *fmr;
+	int err;
+
+	fmr = rvt_alloc(&rvt->fmr_pool);
+	if (!fmr) {
+		err = -ENOMEM;
+		goto err1;
+	}
+
+	rvt_add_index(fmr);
+
+	rvt_add_ref(pd);
+
+	err = rvt_mem_init_fmr(rvt, pd, access, attr, fmr);
+	if (err)
+		goto err2;
+
+	return &fmr->ibfmr;
+
+err2:
+	rvt_drop_ref(pd);
+	rvt_drop_index(fmr);
+	rvt_drop_ref(fmr);
+err1:
+	return ERR_PTR(err);
+}
+
+static int rvt_map_phys_fmr(struct ib_fmr *ibfmr,
+			    u64 *page_list, int list_length, u64 iova)
+{
+	struct rvt_mem *fmr = to_rfmr(ibfmr);
+	struct rvt_dev *rvt = to_rdev(ibfmr->device);
+
+	return rvt_mem_map_pages(rvt, fmr, page_list, list_length, iova);
+}
+
+static int rvt_unmap_fmr(struct list_head *fmr_list)
+{
+	struct rvt_mem *fmr;
+
+	list_for_each_entry(fmr, fmr_list, ibfmr.list) {
+		if (fmr->state != RVT_MEM_STATE_VALID)
+			continue;
+
+		fmr->va = 0;
+		fmr->iova = 0;
+		fmr->length = 0;
+		fmr->num_buf = 0;
+		fmr->state = RVT_MEM_STATE_FREE;
+	}
+
+	return 0;
+}
+
+static int rvt_dealloc_fmr(struct ib_fmr *ibfmr)
+{
+	struct rvt_mem *fmr = to_rfmr(ibfmr);
+
+	fmr->state = RVT_MEM_STATE_ZOMBIE;
+	rvt_drop_ref(fmr->pd);
+	rvt_drop_index(fmr);
+	rvt_drop_ref(fmr);
+	return 0;
+}
+
+static int rvt_attach_mcast(struct ib_qp *ibqp, union ib_gid *mgid, u16 mlid)
+{
+	int err;
+	struct rvt_dev *rvt = to_rdev(ibqp->device);
+	struct rvt_qp *qp = to_rqp(ibqp);
+	struct rvt_mc_grp *grp;
+
+	/* takes a ref on grp if successful */
+	err = rvt_mcast_get_grp(rvt, mgid, &grp);
+	if (err)
+		return err;
+
+	err = rvt_mcast_add_grp_elem(rvt, qp, grp);
+
+	rvt_drop_ref(grp);
+	return err;
+}
+
+static int rvt_detach_mcast(struct ib_qp *ibqp, union ib_gid *mgid, u16 mlid)
+{
+	struct rvt_dev *rvt = to_rdev(ibqp->device);
+	struct rvt_qp *qp = to_rqp(ibqp);
+
+	return rvt_mcast_drop_grp_elem(rvt, qp, mgid);
+}
+
+static ssize_t rvt_show_parent(struct device *device,
+			       struct device_attribute *attr, char *buf)
+{
+	struct rvt_dev *rvt = container_of(device, struct rvt_dev,
+					   ib_dev.dev);
+	char *name;
+
+	name = rvt->ifc_ops->parent_name(rvt, 1);
+	return snprintf(buf, 16, "%s\n", name);
+}
+
+static DEVICE_ATTR(parent, S_IRUGO, rvt_show_parent, NULL);
+
+static struct device_attribute *rvt_dev_attributes[] = {
+	&dev_attr_parent,
+};
+
+/* initialize port attributes */
+static int rvt_init_port_param(struct rvt_dev *rdev, unsigned int port_num)
+{
+	struct rvt_port *port = &rdev->port[port_num - 1];
+
+	port->attr.state		= RVT_PORT_STATE;
+	port->attr.max_mtu		= RVT_PORT_MAX_MTU;
+	port->attr.active_mtu		= RVT_PORT_ACTIVE_MTU;
+	port->attr.gid_tbl_len		= RVT_PORT_GID_TBL_LEN;
+	port->attr.port_cap_flags	= RVT_PORT_PORT_CAP_FLAGS;
+	port->attr.max_msg_sz		= RVT_PORT_MAX_MSG_SZ;
+	port->attr.bad_pkey_cntr	= RVT_PORT_BAD_PKEY_CNTR;
+	port->attr.qkey_viol_cntr	= RVT_PORT_QKEY_VIOL_CNTR;
+	port->attr.pkey_tbl_len		= RVT_PORT_PKEY_TBL_LEN;
+	port->attr.lid			= RVT_PORT_LID;
+	port->attr.sm_lid		= RVT_PORT_SM_LID;
+	port->attr.lmc			= RVT_PORT_LMC;
+	port->attr.max_vl_num		= RVT_PORT_MAX_VL_NUM;
+	port->attr.sm_sl		= RVT_PORT_SM_SL;
+	port->attr.subnet_timeout	= RVT_PORT_SUBNET_TIMEOUT;
+	port->attr.init_type_reply	= RVT_PORT_INIT_TYPE_REPLY;
+	port->attr.active_width		= RVT_PORT_ACTIVE_WIDTH;
+	port->attr.active_speed		= RVT_PORT_ACTIVE_SPEED;
+	port->attr.phys_state		= RVT_PORT_PHYS_STATE;
+	port->mtu_cap			= ib_mtu_enum_to_int(RVT_PORT_ACTIVE_MTU);
+	port->subnet_prefix		= cpu_to_be64(RVT_PORT_SUBNET_PREFIX);
+
+	return 0;
+}
+
+/* initialize port state, note IB convention that HCA ports are always
+ * numbered from 1
+ */
+static int rvt_init_ports(struct rvt_dev *rdev)
+{
+	int err;
+	unsigned int port_num;
+	struct rvt_port *port;
+
+	rdev->port = kcalloc(rdev->num_ports, sizeof(struct rvt_port),
+			    GFP_KERNEL);
+	if (!rdev->port)
+		return -ENOMEM;
+
+	for (port_num = 1; port_num <= rdev->num_ports; port_num++) {
+		port = &rdev->port[port_num - 1];
+
+		rvt_init_port_param(rdev, port_num);
+
+		if (!port->attr.pkey_tbl_len) {
+			err = -EINVAL;
+			goto err1;
+		}
+
+		port->pkey_tbl = kcalloc(port->attr.pkey_tbl_len,
+					 sizeof(*port->pkey_tbl), GFP_KERNEL);
+		if (!port->pkey_tbl) {
+			err = -ENOMEM;
+			goto err1;
+		}
+
+		port->pkey_tbl[0] = 0xffff;
+
+		if (!port->attr.gid_tbl_len) {
+			kfree(port->pkey_tbl);
+			err = -EINVAL;
+			goto err1;
+		}
+
+		port->port_guid = rdev->ifc_ops->port_guid(rdev, port_num);
+
+		spin_lock_init(&port->port_lock);
+	}
+
+	return 0;
+
+err1:
+	while (--port_num >= 1) {
+		port = &rdev->port[port_num - 1];
+		kfree(port->pkey_tbl);
+	}
+
+	kfree(rdev->port);
+	return err;
+}
+
+/* initialize rdev device parameters */
+static int rvt_init_device_param(struct rvt_dev *rdev)
+{
+	rdev->max_inline_data			= RVT_MAX_INLINE_DATA;
+
+	rdev->attr.fw_ver			= RVT_FW_VER;
+	rdev->attr.max_mr_size			= RVT_MAX_MR_SIZE;
+	rdev->attr.page_size_cap			= RVT_PAGE_SIZE_CAP;
+	rdev->attr.vendor_id			= RVT_VENDOR_ID;
+	rdev->attr.vendor_part_id		= RVT_VENDOR_PART_ID;
+	rdev->attr.hw_ver			= RVT_HW_VER;
+	rdev->attr.max_qp			= RVT_MAX_QP;
+	rdev->attr.max_qp_wr			= RVT_MAX_QP_WR;
+	rdev->attr.device_cap_flags		= RVT_DEVICE_CAP_FLAGS;
+	rdev->attr.max_sge			= RVT_MAX_SGE;
+	rdev->attr.max_sge_rd			= RVT_MAX_SGE_RD;
+	rdev->attr.max_cq			= RVT_MAX_CQ;
+	rdev->attr.max_cqe			= (1 << RVT_MAX_LOG_CQE) - 1;
+	rdev->attr.max_mr			= RVT_MAX_MR;
+	rdev->attr.max_pd			= RVT_MAX_PD;
+	rdev->attr.max_qp_rd_atom		= RVT_MAX_QP_RD_ATOM;
+	rdev->attr.max_ee_rd_atom		= RVT_MAX_EE_RD_ATOM;
+	rdev->attr.max_res_rd_atom		= RVT_MAX_RES_RD_ATOM;
+	rdev->attr.max_qp_init_rd_atom		= RVT_MAX_QP_INIT_RD_ATOM;
+	rdev->attr.max_ee_init_rd_atom		= RVT_MAX_EE_INIT_RD_ATOM;
+	rdev->attr.atomic_cap			= RVT_ATOMIC_CAP;
+	rdev->attr.max_ee			= RVT_MAX_EE;
+	rdev->attr.max_rdd			= RVT_MAX_RDD;
+	rdev->attr.max_mw			= RVT_MAX_MW;
+	rdev->attr.max_raw_ipv6_qp		= RVT_MAX_RAW_IPV6_QP;
+	rdev->attr.max_raw_ethy_qp		= RVT_MAX_RAW_ETHY_QP;
+	rdev->attr.max_mcast_grp			= RVT_MAX_MCAST_GRP;
+	rdev->attr.max_mcast_qp_attach		= RVT_MAX_MCAST_QP_ATTACH;
+	rdev->attr.max_total_mcast_qp_attach	= RVT_MAX_TOT_MCAST_QP_ATTACH;
+	rdev->attr.max_ah			= RVT_MAX_AH;
+	rdev->attr.max_fmr			= RVT_MAX_FMR;
+	rdev->attr.max_map_per_fmr		= RVT_MAX_MAP_PER_FMR;
+	rdev->attr.max_srq			= RVT_MAX_SRQ;
+	rdev->attr.max_srq_wr			= RVT_MAX_SRQ_WR;
+	rdev->attr.max_srq_sge			= RVT_MAX_SRQ_SGE;
+	rdev->attr.max_fast_reg_page_list_len	= RVT_MAX_FMR_PAGE_LIST_LEN;
+	rdev->attr.max_pkeys			= RVT_MAX_PKEYS;
+	rdev->attr.local_ca_ack_delay		= RVT_LOCAL_CA_ACK_DELAY;
+
+	rdev->max_ucontext			= RVT_MAX_UCONTEXT;
+
+	return 0;
+}
+
+/* init pools of managed objects */
+static int rvt_init_pools(struct rvt_dev *rdev)
+{
+	int err;
+
+	err = rvt_pool_init(rdev, &rdev->uc_pool, RVT_TYPE_UC,
+			    rdev->max_ucontext);
+	if (err)
+		goto err1;
+
+	err = rvt_pool_init(rdev, &rdev->pd_pool, RVT_TYPE_PD,
+			    rdev->attr.max_pd);
+	if (err)
+		goto err2;
+
+	err = rvt_pool_init(rdev, &rdev->ah_pool, RVT_TYPE_AH,
+			    rdev->attr.max_ah);
+	if (err)
+		goto err3;
+
+	err = rvt_pool_init(rdev, &rdev->srq_pool, RVT_TYPE_SRQ,
+			    rdev->attr.max_srq);
+	if (err)
+		goto err4;
+
+	err = rvt_pool_init(rdev, &rdev->qp_pool, RVT_TYPE_QP,
+			    rdev->attr.max_qp);
+	if (err)
+		goto err5;
+
+	err = rvt_pool_init(rdev, &rdev->cq_pool, RVT_TYPE_CQ,
+			    rdev->attr.max_cq);
+	if (err)
+		goto err6;
+
+	err = rvt_pool_init(rdev, &rdev->mr_pool, RVT_TYPE_MR,
+			    rdev->attr.max_mr);
+	if (err)
+		goto err7;
+
+	err = rvt_pool_init(rdev, &rdev->fmr_pool, RVT_TYPE_FMR,
+			    rdev->attr.max_fmr);
+	if (err)
+		goto err8;
+
+	err = rvt_pool_init(rdev, &rdev->mw_pool, RVT_TYPE_MW,
+			    rdev->attr.max_mw);
+	if (err)
+		goto err9;
+
+	err = rvt_pool_init(rdev, &rdev->mc_grp_pool, RVT_TYPE_MC_GRP,
+			    rdev->attr.max_mcast_grp);
+	if (err)
+		goto err10;
+
+	err = rvt_pool_init(rdev, &rdev->mc_elem_pool, RVT_TYPE_MC_ELEM,
+			    rdev->attr.max_total_mcast_qp_attach);
+	if (err)
+		goto err11;
+
+	return 0;
+
+err11:
+	rvt_pool_cleanup(&rdev->mc_grp_pool);
+err10:
+	rvt_pool_cleanup(&rdev->mw_pool);
+err9:
+	rvt_pool_cleanup(&rdev->fmr_pool);
+err8:
+	rvt_pool_cleanup(&rdev->mr_pool);
+err7:
+	rvt_pool_cleanup(&rdev->cq_pool);
+err6:
+	rvt_pool_cleanup(&rdev->qp_pool);
+err5:
+	rvt_pool_cleanup(&rdev->srq_pool);
+err4:
+	rvt_pool_cleanup(&rdev->ah_pool);
+err3:
+	rvt_pool_cleanup(&rdev->pd_pool);
+err2:
+	rvt_pool_cleanup(&rdev->uc_pool);
+err1:
+	return err;
+}
+
+/* initialize rdev device state */
+static int rvt_init(struct rvt_dev *rdev)
+{
+	int err;
+
+	/* init default device parameters */
+	rvt_init_device_param(rdev);
+
+	err = rvt_init_ports(rdev);
+	if (err)
+		goto err1;
+
+	err = rvt_init_pools(rdev);
+	if (err)
+		goto err2;
+
+	/* init pending mmap list */
+	spin_lock_init(&rdev->mmap_offset_lock);
+	spin_lock_init(&rdev->pending_lock);
+	INIT_LIST_HEAD(&rdev->pending_mmaps);
+
+	mutex_init(&rdev->usdev_lock);
+
+	return 0;
+
+err2:
+	rvt_cleanup_ports(rdev);
+err1:
+	return err;
+}
+
+struct rvt_dev* rvt_alloc_device(size_t size)
+{
+	struct rvt_dev *rdev;
+
+	rdev = (struct rvt_dev *)ib_alloc_device(size);
+	if (!rdev)
+		return NULL;
+
+	kref_init(&rdev->ref_cnt);
+	
+	return rdev;
+}
+EXPORT_SYMBOL_GPL(rvt_alloc_device);
+
+int rvt_register_device(struct rvt_dev *rdev,
+			struct rvt_ifc_ops *ops,
+			unsigned int mtu)
+{
+	int err;
+	int i;
+	struct ib_device *dev;
+
+	if (rdev->num_ports == 0)
+		return -EINVAL;
+
+	rdev->ifc_ops = ops;
+	err = rvt_init(rdev);
+	if (err)
+		goto err1;
+	for (i = 1; i <= rdev->num_ports; ++i) {
+		err = rvt_set_mtu(rdev, mtu, i);
+		if (err)
+			goto err1;
+	}
+
+	dev = &rdev->ib_dev;
+	strlcpy(dev->name, "rvt%d", IB_DEVICE_NAME_MAX);
+	strlcpy(dev->node_desc, "rvt", sizeof(dev->node_desc));
+
+	dev->owner = THIS_MODULE;
+	dev->node_type = RDMA_NODE_IB_CA;
+	dev->phys_port_cnt = rdev->num_ports;
+	dev->num_comp_vectors = RVT_NUM_COMP_VECTORS;
+	dev->dma_device = rdev->ifc_ops->dma_device(rdev);
+	dev->local_dma_lkey = 0;
+	dev->node_guid = rdev->ifc_ops->node_guid(rdev);
+	dev->dma_ops = &rvt_dma_mapping_ops;
+
+	dev->uverbs_abi_ver = RVT_UVERBS_ABI_VERSION;
+	dev->uverbs_cmd_mask = BIT_ULL(IB_USER_VERBS_CMD_GET_CONTEXT)
+	    | BIT_ULL(IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL)
+	    | BIT_ULL(IB_USER_VERBS_CMD_QUERY_DEVICE)
+	    | BIT_ULL(IB_USER_VERBS_CMD_QUERY_PORT)
+	    | BIT_ULL(IB_USER_VERBS_CMD_ALLOC_PD)
+	    | BIT_ULL(IB_USER_VERBS_CMD_DEALLOC_PD)
+	    | BIT_ULL(IB_USER_VERBS_CMD_CREATE_SRQ)
+	    | BIT_ULL(IB_USER_VERBS_CMD_MODIFY_SRQ)
+	    | BIT_ULL(IB_USER_VERBS_CMD_QUERY_SRQ)
+	    | BIT_ULL(IB_USER_VERBS_CMD_DESTROY_SRQ)
+	    | BIT_ULL(IB_USER_VERBS_CMD_POST_SRQ_RECV)
+	    | BIT_ULL(IB_USER_VERBS_CMD_CREATE_QP)
+	    | BIT_ULL(IB_USER_VERBS_CMD_MODIFY_QP)
+	    | BIT_ULL(IB_USER_VERBS_CMD_QUERY_QP)
+	    | BIT_ULL(IB_USER_VERBS_CMD_DESTROY_QP)
+	    | BIT_ULL(IB_USER_VERBS_CMD_POST_SEND)
+	    | BIT_ULL(IB_USER_VERBS_CMD_POST_RECV)
+	    | BIT_ULL(IB_USER_VERBS_CMD_CREATE_CQ)
+	    | BIT_ULL(IB_USER_VERBS_CMD_RESIZE_CQ)
+	    | BIT_ULL(IB_USER_VERBS_CMD_DESTROY_CQ)
+	    | BIT_ULL(IB_USER_VERBS_CMD_POLL_CQ)
+	    | BIT_ULL(IB_USER_VERBS_CMD_PEEK_CQ)
+	    | BIT_ULL(IB_USER_VERBS_CMD_REQ_NOTIFY_CQ)
+	    | BIT_ULL(IB_USER_VERBS_CMD_REG_MR)
+	    | BIT_ULL(IB_USER_VERBS_CMD_DEREG_MR)
+	    | BIT_ULL(IB_USER_VERBS_CMD_CREATE_AH)
+	    | BIT_ULL(IB_USER_VERBS_CMD_MODIFY_AH)
+	    | BIT_ULL(IB_USER_VERBS_CMD_QUERY_AH)
+	    | BIT_ULL(IB_USER_VERBS_CMD_DESTROY_AH)
+	    | BIT_ULL(IB_USER_VERBS_CMD_ATTACH_MCAST)
+	    | BIT_ULL(IB_USER_VERBS_CMD_DETACH_MCAST)
+	    ;
+
+	dev->query_device = rvt_query_device;
+	dev->modify_device = rvt_modify_device;
+	dev->query_port = rvt_query_port;
+	dev->modify_port = rvt_modify_port;
+	dev->get_link_layer = rvt_get_link_layer;
+	dev->query_gid = rvt_query_gid;
+	dev->get_netdev = rvt_get_netdev;
+	dev->add_gid = rvt_add_gid;
+	dev->del_gid = rvt_del_gid;
+	dev->query_pkey = rvt_query_pkey;
+	dev->alloc_ucontext = rvt_alloc_ucontext;
+	dev->dealloc_ucontext = rvt_dealloc_ucontext;
+	dev->mmap = rvt_mmap;
+	dev->get_port_immutable = rvt_port_immutable;
+	dev->alloc_pd = rvt_alloc_pd;
+	dev->dealloc_pd = rvt_dealloc_pd;
+	dev->create_ah = rvt_create_ah;
+	dev->modify_ah = rvt_modify_ah;
+	dev->query_ah = rvt_query_ah;
+	dev->destroy_ah = rvt_destroy_ah;
+	dev->create_srq = rvt_create_srq;
+	dev->modify_srq = rvt_modify_srq;
+	dev->query_srq = rvt_query_srq;
+	dev->destroy_srq = rvt_destroy_srq;
+	dev->post_srq_recv = rvt_post_srq_recv;
+	dev->create_qp = rvt_create_qp;
+	dev->modify_qp = rvt_modify_qp;
+	dev->query_qp = rvt_query_qp;
+	dev->destroy_qp = rvt_destroy_qp;
+	dev->post_send = rvt_post_send;
+	dev->post_recv = rvt_post_recv;
+	dev->create_cq = rvt_create_cq;
+	dev->destroy_cq = rvt_destroy_cq;
+	dev->resize_cq = rvt_resize_cq;
+	dev->poll_cq = rvt_poll_cq;
+	dev->peek_cq = rvt_peek_cq;
+	dev->req_notify_cq = rvt_req_notify_cq;
+	dev->get_dma_mr = rvt_get_dma_mr;
+	dev->reg_user_mr = rvt_reg_user_mr;
+	dev->dereg_mr = rvt_dereg_mr;
+	dev->alloc_mr = rvt_alloc_mr;
+	dev->alloc_mw = rvt_alloc_mw;
+	dev->dealloc_mw = rvt_dealloc_mw;
+	dev->alloc_fmr = rvt_alloc_fmr;
+	dev->map_phys_fmr = rvt_map_phys_fmr;
+	dev->unmap_fmr = rvt_unmap_fmr;
+	dev->dealloc_fmr = rvt_dealloc_fmr;
+	dev->attach_mcast = rvt_attach_mcast;
+	dev->detach_mcast = rvt_detach_mcast;
+
+	err = ib_register_device(dev, NULL);
+	if (err) {
+		pr_warn("rvt_register_device failed, err = %d\n", err);
+		goto err1;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(rvt_dev_attributes); ++i) {
+		err = device_create_file(&dev->dev, rvt_dev_attributes[i]);
+		if (err) {
+			pr_warn("device_create_file failed, i = %d, err = %d\n",
+				i, err);
+			goto err2;
+		}
+	}
+
+	return 0;
+
+err2:
+	ib_unregister_device(dev);
+err1:
+	rvt_dev_put(rdev);
+	return err;
+}
+EXPORT_SYMBOL_GPL(rvt_register_device);
+
+int rvt_unregister_device(struct rvt_dev *rdev)
+{
+	int i;
+	struct ib_device *dev = &rdev->ib_dev;
+
+	for (i = 0; i < ARRAY_SIZE(rvt_dev_attributes); ++i)
+		device_remove_file(&dev->dev, rvt_dev_attributes[i]);
+
+	ib_unregister_device(dev);
+
+	rvt_dev_put(rdev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rvt_unregister_device);
diff --git a/drivers/infiniband/sw/rdmavt/rvt_verbs.h b/drivers/infiniband/sw/rdmavt/rvt_verbs.h
new file mode 100644
index 0000000..736ec00
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rvt_verbs.h
@@ -0,0 +1,434 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *	   Redistribution and use in source and binary forms, with or
+ *	   without modification, are permitted provided that the following
+ *	   conditions are met:
+ *
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#ifndef RVT_VERBS_H
+#define RVT_VERBS_H
+
+#include <linux/interrupt.h>
+#include <rdma/ib_rvt.h>
+#include "rvt_pool.h"
+#include "rvt_task.h"
+#include "rvt_param.h"
+
+#define RVT_UVERBS_ABI_VERSION		(1)
+static inline int pkey_match(u16 key1, u16 key2)
+{
+	return (((key1 & 0x7fff) != 0) &&
+		((key1 & 0x7fff) == (key2 & 0x7fff)) &&
+		((key1 & 0x8000) || (key2 & 0x8000))) ? 1 : 0;
+}
+
+static inline int addr_same(struct rvt_dev *rdev, struct rvt_av *av)
+{
+	int port_num = 1;
+
+	return rdev->port[port_num - 1].port_guid
+			== av->grh.dgid.global.interface_id;
+}
+
+/* Return >0 if psn_a > psn_b
+ *	   0 if psn_a == psn_b
+ *	  <0 if psn_a < psn_b
+ */
+static inline int psn_compare(u32 psn_a, u32 psn_b)
+{
+	s32 diff;
+
+	diff = (psn_a - psn_b) << 8;
+	return diff;
+}
+
+struct rvt_ucontext {
+	struct rvt_pool_entry	pelem;
+	struct ib_ucontext	ibuc;
+};
+
+struct rvt_pd {
+	struct rvt_pool_entry	pelem;
+	struct ib_pd		ibpd;
+};
+
+struct rvt_ah {
+	struct rvt_pool_entry	pelem;
+	struct ib_ah		ibah;
+	struct rvt_pd		*pd;
+	struct rvt_av		av;
+};
+
+struct rvt_cqe {
+	union {
+		struct ib_wc		ibwc;
+		struct ib_uverbs_wc	uibwc;
+	};
+};
+
+struct rvt_cq {
+	struct rvt_pool_entry	pelem;
+	struct ib_cq		ibcq;
+	struct rvt_queue	*queue;
+	spinlock_t		cq_lock;
+	u8			notify;
+	int			is_user;
+	struct tasklet_struct	comp_task;
+};
+
+enum wqe_state {
+	wqe_state_posted,
+	wqe_state_processing,
+	wqe_state_pending,
+	wqe_state_done,
+	wqe_state_error,
+};
+
+struct rvt_sq {
+	int			max_wr;
+	int			max_sge;
+	int			max_inline;
+	spinlock_t		sq_lock;
+	struct rvt_queue	*queue;
+};
+
+struct rvt_rq {
+	int			max_wr;
+	int			max_sge;
+	spinlock_t		producer_lock;
+	spinlock_t		consumer_lock;
+	struct rvt_queue	*queue;
+};
+
+struct rvt_srq {
+	struct rvt_pool_entry	pelem;
+	struct ib_srq		ibsrq;
+	struct rvt_pd		*pd;
+	struct rvt_cq		*cq;
+	struct rvt_rq		rq;
+	u32			srq_num;
+
+	void			(*event_handler)(
+					struct ib_event *, void *);
+	void			*context;
+
+	int			limit;
+	int			error;
+};
+
+enum rvt_qp_state {
+	QP_STATE_RESET,
+	QP_STATE_INIT,
+	QP_STATE_READY,
+	QP_STATE_DRAIN,		/* req only */
+	QP_STATE_DRAINED,	/* req only */
+	QP_STATE_ERROR
+};
+
+extern char *rvt_qp_state_name[];
+
+struct rvt_req_info {
+	enum rvt_qp_state	state;
+	int			wqe_index;
+	u32			psn;
+	int			opcode;
+	atomic_t		rd_atomic;
+	int			wait_fence;
+	int			need_rd_atomic;
+	int			wait_psn;
+	int			need_retry;
+	int			noack_pkts;
+	struct rvt_task		task;
+};
+
+struct rvt_comp_info {
+	u32			psn;
+	int			opcode;
+	int			timeout;
+	int			timeout_retry;
+	u32			retry_cnt;
+	u32			rnr_retry;
+	struct rvt_task		task;
+};
+
+enum rdatm_res_state {
+	rdatm_res_state_next,
+	rdatm_res_state_new,
+	rdatm_res_state_replay,
+};
+
+struct resp_res {
+	int			type;
+	u32			first_psn;
+	u32			last_psn;
+	u32			cur_psn;
+	enum rdatm_res_state	state;
+
+	union {
+		struct {
+			struct sk_buff	*skb;
+		} atomic;
+		struct {
+			struct rvt_mem	*mr;
+			u64		va_org;
+			u32		rkey;
+			u32		length;
+			u64		va;
+			u32		resid;
+		} read;
+	};
+};
+
+struct rvt_resp_info {
+	enum rvt_qp_state	state;
+	u32			msn;
+	u32			psn;
+	int			opcode;
+	int			drop_msg;
+	int			goto_error;
+	int			sent_psn_nak;
+	enum ib_wc_status	status;
+	u8			aeth_syndrome;
+
+	/* Receive only */
+	struct rvt_recv_wqe	*wqe;
+
+	/* RDMA read / atomic only */
+	u64			va;
+	struct rvt_mem		*mr;
+	u32			resid;
+	u32			rkey;
+	u64			atomic_orig;
+
+	/* SRQ only */
+	struct {
+		struct rvt_recv_wqe	wqe;
+		struct ib_sge		sge[RVT_MAX_SGE];
+	} srq_wqe;
+
+	/* Responder resources. It's a circular list where the oldest
+	 * resource is dropped first.
+	 */
+	struct resp_res		*resources;
+	unsigned int		res_head;
+	unsigned int		res_tail;
+	struct resp_res		*res;
+	struct rvt_task		task;
+};
+
+struct rvt_qp {
+	struct rvt_pool_entry	pelem;
+	struct ib_qp		ibqp;
+	struct ib_qp_attr	attr;
+	unsigned int		valid;
+	unsigned int		mtu;
+	int			is_user;
+
+	struct rvt_pd		*pd;
+	struct rvt_srq		*srq;
+	struct rvt_cq		*scq;
+	struct rvt_cq		*rcq;
+
+	enum ib_sig_type	sq_sig_type;
+
+	struct rvt_sq		sq;
+	struct rvt_rq		rq;
+
+	void			*flow;
+
+	struct rvt_av		pri_av;
+	struct rvt_av		alt_av;
+
+	/* list of mcast groups qp has joined (for cleanup) */
+	struct list_head	grp_list;
+	spinlock_t		grp_lock;
+
+	struct sk_buff_head	req_pkts;
+	struct sk_buff_head	resp_pkts;
+	struct sk_buff_head	send_pkts;
+
+	struct rvt_req_info	req;
+	struct rvt_comp_info	comp;
+	struct rvt_resp_info	resp;
+
+	atomic_t		ssn;
+	atomic_t		skb_out;
+	int			need_req_skb;
+
+	/* Timer for retranmitting packet when ACKs have been lost. RC
+	 * only. The requester sets it when it is not already
+	 * started. The responder resets it whenever an ack is
+	 * received.
+	 */
+	struct timer_list retrans_timer;
+	u64 qp_timeout_jiffies;
+
+	/* Timer for handling RNR NAKS. */
+	struct timer_list rnr_nak_timer;
+
+	spinlock_t		state_lock;
+};
+
+enum rvt_mem_state {
+	RVT_MEM_STATE_ZOMBIE,
+	RVT_MEM_STATE_INVALID,
+	RVT_MEM_STATE_FREE,
+	RVT_MEM_STATE_VALID,
+};
+
+enum rvt_mem_type {
+	RVT_MEM_TYPE_NONE,
+	RVT_MEM_TYPE_DMA,
+	RVT_MEM_TYPE_MR,
+	RVT_MEM_TYPE_FMR,
+	RVT_MEM_TYPE_MW,
+};
+
+#define RVT_BUF_PER_MAP		(PAGE_SIZE / sizeof(struct rvt_phys_buf))
+
+struct rvt_phys_buf {
+	u64	addr;
+	u64	size;
+};
+
+struct rvt_map {
+	struct rvt_phys_buf	buf[RVT_BUF_PER_MAP];
+};
+
+struct rvt_mem {
+	struct rvt_pool_entry	pelem;
+	union {
+		struct ib_mr		ibmr;
+		struct ib_fmr		ibfmr;
+		struct ib_mw		ibmw;
+	};
+
+	struct rvt_pd		*pd;
+	struct ib_umem		*umem;
+
+	u32			lkey;
+	u32			rkey;
+
+	enum rvt_mem_state	state;
+	enum rvt_mem_type	type;
+	u64			va;
+	u64			iova;
+	size_t			length;
+	u32			offset;
+	int			access;
+
+	int			page_shift;
+	int			page_mask;
+	int			map_shift;
+	int			map_mask;
+
+	u32			num_buf;
+
+	u32			max_buf;
+	u32			num_map;
+
+	struct rvt_map		**map;
+};
+
+struct rvt_mc_grp {
+	struct rvt_pool_entry	pelem;
+	spinlock_t		mcg_lock;
+	struct rvt_dev		*rvt;
+	struct list_head	qp_list;
+	union ib_gid		mgid;
+	int			num_qp;
+	u32			qkey;
+	u16			pkey;
+};
+
+struct rvt_mc_elem {
+	struct rvt_pool_entry	pelem;
+	struct list_head	qp_list;
+	struct list_head	grp_list;
+	struct rvt_qp		*qp;
+	struct rvt_mc_grp	*grp;
+};
+
+int rvt_prepare(struct rvt_dev *rvt, struct rvt_pkt_info *pkt,
+		   struct sk_buff *skb, u32 *crc);
+
+static inline struct rvt_dev *to_rdev(struct ib_device *dev)
+{
+	return dev ? container_of(dev, struct rvt_dev, ib_dev) : NULL;
+}
+
+static inline struct rvt_ucontext *to_ruc(struct ib_ucontext *uc)
+{
+	return uc ? container_of(uc, struct rvt_ucontext, ibuc) : NULL;
+}
+
+static inline struct rvt_pd *to_rpd(struct ib_pd *pd)
+{
+	return pd ? container_of(pd, struct rvt_pd, ibpd) : NULL;
+}
+
+static inline struct rvt_ah *to_rah(struct ib_ah *ah)
+{
+	return ah ? container_of(ah, struct rvt_ah, ibah) : NULL;
+}
+
+static inline struct rvt_srq *to_rsrq(struct ib_srq *srq)
+{
+	return srq ? container_of(srq, struct rvt_srq, ibsrq) : NULL;
+}
+
+static inline struct rvt_qp *to_rqp(struct ib_qp *qp)
+{
+	return qp ? container_of(qp, struct rvt_qp, ibqp) : NULL;
+}
+
+static inline struct rvt_cq *to_rcq(struct ib_cq *cq)
+{
+	return cq ? container_of(cq, struct rvt_cq, ibcq) : NULL;
+}
+
+static inline struct rvt_mem *to_rmr(struct ib_mr *mr)
+{
+	return mr ? container_of(mr, struct rvt_mem, ibmr) : NULL;
+}
+
+static inline struct rvt_mem *to_rfmr(struct ib_fmr *fmr)
+{
+	return fmr ? container_of(fmr, struct rvt_mem, ibfmr) : NULL;
+}
+
+static inline struct rvt_mem *to_rmw(struct ib_mw *mw)
+{
+	return mw ? container_of(mw, struct rvt_mem, ibmw) : NULL;
+}
+
+
+void rvt_mc_cleanup(void *arg);
+
+#endif /* RVT_VERBS_H */
diff --git a/include/rdma/ib_pack.h b/include/rdma/ib_pack.h
index a193081..1d957fe 100644
--- a/include/rdma/ib_pack.h
+++ b/include/rdma/ib_pack.h
@@ -103,6 +103,8 @@ enum {
 	IB_OPCODE_ATOMIC_ACKNOWLEDGE                = 0x12,
 	IB_OPCODE_COMPARE_SWAP                      = 0x13,
 	IB_OPCODE_FETCH_ADD                         = 0x14,
+	IB_OPCODE_SEND_LAST_INV                     = 0x16,
+	IB_OPCODE_SEND_ONLY_INV                     = 0x17,
 
 	/* real constants follow -- see comment about above IB_OPCODE()
 	   macro for more details */
@@ -129,6 +131,8 @@ enum {
 	IB_OPCODE(RC, ATOMIC_ACKNOWLEDGE),
 	IB_OPCODE(RC, COMPARE_SWAP),
 	IB_OPCODE(RC, FETCH_ADD),
+	IB_OPCODE(RC, SEND_LAST_INV),
+	IB_OPCODE(RC, SEND_ONLY_INV),
 
 	/* UC */
 	IB_OPCODE(UC, SEND_FIRST),
diff --git a/include/rdma/ib_rvt.h b/include/rdma/ib_rvt.h
new file mode 100644
index 0000000..d0b7d15
--- /dev/null
+++ b/include/rdma/ib_rvt.h
@@ -0,0 +1,203 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#ifndef RXE_H
+#define RXE_H
+
+#include <linux/skbuff.h>
+
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_user_verbs.h>
+#include <rdma/ib_pack.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_umem.h>
+#include <rdma/ib_cache.h>
+#include <rdma/ib_addr.h>
+
+#include <uapi/rdma/ib_user_rvt.h>
+
+#define IB_PHYS_STATE_LINK_UP		(5)
+
+#define ROCE_V2_UDP_DPORT 	(4791)
+#define ROCE_V2_UDP_SPORT 	(0xC000)
+
+struct rvt_dev;
+
+/* callbacks from ib_rvt to network interface layer */
+struct rvt_ifc_ops {
+	void (*release)(struct rvt_dev *rvt);
+	__be64 (*node_guid)(struct rvt_dev *rvt);
+	__be64 (*port_guid)(struct rvt_dev *rvt, unsigned int port_num);
+	__be16 (*port_speed)(struct rvt_dev *rvt, unsigned int port_num);
+	struct device *(*dma_device)(struct rvt_dev *rvt);
+	int (*mcast_add)(struct rvt_dev *rvt, union ib_gid *mgid);
+	int (*mcast_delete)(struct rvt_dev *rvt, union ib_gid *mgid);
+	int (*create_flow)(struct rvt_dev *rvt, void **ctx, void *rvt_ctx);
+	void (*destroy_flow)(struct rvt_dev *rdev, void *ctx);
+	int (*send)(struct rvt_dev *rdev, struct rvt_av *av,
+		    struct sk_buff *skb, void *flow);
+	int (*loopback)(struct sk_buff *skb);
+	struct sk_buff *(*alloc_sendbuf)(struct rvt_dev *rdev, struct rvt_av *av, int paylen);
+	char *(*parent_name)(struct rvt_dev *rvt, unsigned int port_num);
+	enum rdma_link_layer (*link_layer)(struct rvt_dev *rvt,
+					   unsigned int port_num);
+	struct net_device *(*get_netdev)(struct rvt_dev *rvt,
+					 unsigned int port_num);
+};
+
+#define RVT_POOL_ALIGN		(16)
+#define RVT_POOL_CACHE_FLAGS	(0)
+
+enum rvt_pool_flags {
+	RVT_POOL_ATOMIC		= BIT(0),
+	RVT_POOL_INDEX		= BIT(1),
+	RVT_POOL_KEY		= BIT(2),
+};
+
+enum rvt_elem_type {
+	RVT_TYPE_UC,
+	RVT_TYPE_PD,
+	RVT_TYPE_AH,
+	RVT_TYPE_SRQ,
+	RVT_TYPE_QP,
+	RVT_TYPE_CQ,
+	RVT_TYPE_MR,
+	RVT_TYPE_MW,
+	RVT_TYPE_FMR,
+	RVT_TYPE_MC_GRP,
+	RVT_TYPE_MC_ELEM,
+	RVT_NUM_TYPES,		/* keep me last */
+};
+
+enum rvt_pool_state {
+	rvt_pool_invalid,
+	rvt_pool_valid,
+};
+
+struct rvt_pool_entry {
+	struct rvt_pool		*pool;
+	struct kref		ref_cnt;
+	struct list_head	list;
+
+	/* only used if indexed or keyed */
+	struct rb_node		node;
+	u32			index;
+};
+
+struct rvt_pool {
+	struct rvt_dev		*rvt;
+	spinlock_t              pool_lock; /* pool spinlock */
+	size_t			elem_size;
+	struct kref		ref_cnt;
+	void			(*cleanup)(void *obj);
+	enum rvt_pool_state	state;
+	enum rvt_pool_flags	flags;
+	enum rvt_elem_type	type;
+
+	unsigned int		max_elem;
+	atomic_t		num_elem;
+
+	/* only used if indexed or keyed */
+	struct rb_root		tree;
+	unsigned long		*table;
+	size_t			table_size;
+	u32			max_index;
+	u32			min_index;
+	u32			last;
+	size_t			key_offset;
+	size_t			key_size;
+};
+
+struct rvt_port {
+	struct ib_port_attr	attr;
+	u16			*pkey_tbl;
+	__be64			port_guid;
+	__be64			subnet_prefix;
+	spinlock_t		port_lock;
+	unsigned int		mtu_cap;
+	/* special QPs */
+	u32			qp_smi_index;
+	u32			qp_gsi_index;
+};
+
+struct rvt_dev {
+	struct ib_device	ib_dev;
+	struct ib_device_attr	attr;
+	int			max_ucontext;
+	int			max_inline_data;
+	struct kref		ref_cnt;
+	struct mutex	usdev_lock;
+
+	struct rvt_ifc_ops	*ifc_ops;
+
+
+	int			xmit_errors;
+
+	struct rvt_pool		uc_pool;
+	struct rvt_pool		pd_pool;
+	struct rvt_pool		ah_pool;
+	struct rvt_pool		srq_pool;
+	struct rvt_pool		qp_pool;
+	struct rvt_pool		cq_pool;
+	struct rvt_pool		mr_pool;
+	struct rvt_pool		mw_pool;
+	struct rvt_pool		fmr_pool;
+	struct rvt_pool		mc_grp_pool;
+	struct rvt_pool		mc_elem_pool;
+
+	spinlock_t		pending_lock;
+	struct list_head	pending_mmaps;
+
+	spinlock_t		mmap_offset_lock;
+	int			mmap_offset;
+
+	u8			num_ports;
+	struct rvt_port		*port;
+};
+
+struct rvt_dev* rvt_alloc_device(size_t size);
+int rvt_register_device(struct rvt_dev *rdev, 
+			struct rvt_ifc_ops *ops,
+			unsigned int mtu);
+int rvt_unregister_device(struct rvt_dev *rdev);
+
+int rvt_set_mtu(struct rvt_dev *rvt, unsigned int dev_mtu,
+		unsigned int port_num);
+
+int rvt_rcv(struct sk_buff *skb, struct rvt_dev *rdev, u8 port_num);
+
+void rvt_dev_put(struct rvt_dev *rvt);
+
+void rvt_send_done(void *rvt_ctx);
+
+#endif /* RXE_H */
diff --git a/include/uapi/rdma/Kbuild b/include/uapi/rdma/Kbuild
index 231901b..3e20f75 100644
--- a/include/uapi/rdma/Kbuild
+++ b/include/uapi/rdma/Kbuild
@@ -6,3 +6,4 @@ header-y += ib_user_verbs.h
 header-y += rdma_netlink.h
 header-y += rdma_user_cm.h
 header-y += hfi/
+header-y += ib_user_rvt.h
diff --git a/include/uapi/rdma/ib_user_rvt.h b/include/uapi/rdma/ib_user_rvt.h
new file mode 100644
index 0000000..7cbf332
--- /dev/null
+++ b/include/uapi/rdma/ib_user_rvt.h
@@ -0,0 +1,139 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#ifndef IB_USER_RVT_H
+#define IB_USER_RVT_H
+
+#include <linux/types.h>
+
+union rvt_gid {
+	__u8    raw[16];
+	struct {
+		__be64  subnet_prefix;
+		__be64  interface_id;
+	} global;
+};
+
+struct rvt_global_route {
+	union rvt_gid   dgid;
+	__u32           flow_label;
+	__u8            sgid_index;
+	__u8            hop_limit;
+	__u8            traffic_class;
+};
+
+struct rvt_av {
+	__u8			port_num;
+	__u8			network_type;
+	struct rvt_global_route	grh;
+	union {
+		struct sockaddr		_sockaddr;
+		struct sockaddr_in	_sockaddr_in;
+		struct sockaddr_in6	_sockaddr_in6;
+	} sgid_addr, dgid_addr;
+};
+
+struct rvt_send_wr {
+	__u64			wr_id;
+	__u32			num_sge;
+	__u32			opcode;
+	__u32			send_flags;
+	union {
+		__u32		imm_data;
+		__u32		invalidate_rkey;
+	} ex;
+	union {
+		struct {
+			__u64	remote_addr;
+			__u32	rkey;
+		} rdma;
+		struct {
+			__u64	remote_addr;
+			__u64	compare_add;
+			__u64	swap;
+			__u32	rkey;
+		} atomic;
+		struct {
+			__u32	remote_qpn;
+			__u32	remote_qkey;
+			__u16	pkey_index;
+		} ud;
+	} wr;
+};
+
+struct rvt_sge {
+	__u64	addr;
+	__u32	length;
+	__u32	lkey;
+};
+
+struct mminfo {
+	__u64			offset;
+	__u32			size;
+	__u32			pad;
+};
+
+struct rvt_dma_info {
+	__u32			length;
+	__u32			resid;
+	__u32			cur_sge;
+	__u32			num_sge;
+	__u32			sge_offset;
+	union {
+		__u8		inline_data[0];
+		struct rvt_sge	sge[0];
+	};
+};
+
+struct rvt_send_wqe {
+	struct rvt_send_wr	wr;
+	struct rvt_av		av;
+	__u32			status;
+	__u32			state;
+	__u64			iova;
+	__u32			mask;
+	__u32			first_psn;
+	__u32			last_psn;
+	__u32			ack_length;
+	__u32			ssn;
+	__u32			has_rd_atomic;
+	struct rvt_dma_info	dma;
+};
+
+struct rvt_recv_wqe {
+	__u64			wr_id;
+	__u32			num_sge;
+	__u32			padding;
+	struct rvt_dma_info	dma;
+};
+
+#endif /* IB_USER_RVT_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
