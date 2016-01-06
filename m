From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] RXE: A Soft RoCE back-end for the RVT
Date: Wed,  6 Jan 2016 20:56:19 +0200
Message-ID: <1452106579-4081-1-git-send-email-monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch introduces an implementation of a back-end that works with
RVT to make RoCE Verbs transport over any Ethernet network device.

Example:

After loading ib_rxe_net.ko
	echo eth1 > /sys/module/ib_rxe_net/parameters/add
will create rvt0 IB device in RVT with Ethernet link layer
---
 drivers/infiniband/Kconfig            |    1 +
 drivers/infiniband/sw/Makefile        |    1 +
 drivers/infiniband/sw/rxe/Kconfig     |   23 ++
 drivers/infiniband/sw/rxe/Makefile    |    5 +
 drivers/infiniband/sw/rxe/rxe_net.c   |  580 +++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/rxe/rxe_net.h   |   89 +++++
 drivers/infiniband/sw/rxe/rxe_sysfs.c |  167 ++++++++++
 7 files changed, 866 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/sw/rxe/Kconfig
 create mode 100644 drivers/infiniband/sw/rxe/Makefile
 create mode 100644 drivers/infiniband/sw/rxe/rxe_net.c
 create mode 100644 drivers/infiniband/sw/rxe/rxe_net.h
 create mode 100644 drivers/infiniband/sw/rxe/rxe_sysfs.c

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 1e82984..ef23047 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -75,6 +75,7 @@ source "drivers/infiniband/hw/ocrdma/Kconfig"
 source "drivers/infiniband/hw/usnic/Kconfig"
 
 source "drivers/infiniband/sw/rdmavt/Kconfig"
+source "drivers/infiniband/sw/rxe/Kconfig"
 
 source "drivers/infiniband/ulp/ipoib/Kconfig"
 
diff --git a/drivers/infiniband/sw/Makefile b/drivers/infiniband/sw/Makefile
index c1f6377..9b9f68d 100644
--- a/drivers/infiniband/sw/Makefile
+++ b/drivers/infiniband/sw/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_INFINIBAND_RDMAVT)		+= rdmavt/
+obj-$(CONFIG_INFINIBAND_RXE)		+= rxe/
 
diff --git a/drivers/infiniband/sw/rxe/Kconfig b/drivers/infiniband/sw/rxe/Kconfig
new file mode 100644
index 0000000..d32843a
--- /dev/null
+++ b/drivers/infiniband/sw/rxe/Kconfig
@@ -0,0 +1,23 @@
+config INFINIBAND_RXE
+	tristate "RoCE RDMAVT backend driver"
+	depends on INET && PCI && INFINIBAND_RDMAVT
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
diff --git a/drivers/infiniband/sw/rxe/Makefile b/drivers/infiniband/sw/rxe/Makefile
new file mode 100644
index 0000000..3f6c05b
--- /dev/null
+++ b/drivers/infiniband/sw/rxe/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_INFINIBAND_RXE) += ib_rxe_net.o
+
+ib_rxe_net-y := \
+	rxe_net.o \
+	rxe_sysfs.o
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
new file mode 100644
index 0000000..84c9606
--- /dev/null
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -0,0 +1,580 @@
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
+#include <linux/if_arp.h>
+#include <linux/netdevice.h>
+#include <linux/if.h>
+#include <linux/if_vlan.h>
+#include <net/udp_tunnel.h>
+#include <net/sch_generic.h>
+#include <linux/netfilter.h>
+#include <rdma/ib_addr.h>
+#include <rdma/ib_user_rvt.h>
+#include <uapi/rdma/ib_user_rvt.h>
+
+#include "rxe_net.h"
+
+MODULE_AUTHOR("Bob Pearson, Frank Zago, John Groves");
+MODULE_DESCRIPTION("RDMA transport over Converged Enhanced Ethernet");
+MODULE_LICENSE("Dual BSD/GPL");
+
+/*
+ * note: this table is a replacement for a protocol specific pointer
+ * in struct net_device which exists for other ethertypes
+ * this allows us to not have to patch that data structure
+ * eventually we want to get our own when we're famous
+ */
+struct rxe_net_info net_info[RXE_MAX_IF_INDEX];
+spinlock_t net_info_lock; /* spinlock for net_info array */
+struct rxe_recv_sockets recv_sockets;
+
+static __be64 rxe_mac_to_eui64(struct net_device *ndev)
+{
+	unsigned char *mac_addr = ndev->dev_addr;
+	__be64 eui64;
+	unsigned char *dst = (unsigned char *)&eui64;
+
+	dst[0] = mac_addr[0] ^ 2;
+	dst[1] = mac_addr[1];
+	dst[2] = mac_addr[2];
+	dst[3] = 0xff;
+	dst[4] = 0xfe;
+	dst[5] = mac_addr[3];
+	dst[6] = mac_addr[4];
+	dst[7] = mac_addr[5];
+
+	return eui64;
+}
+
+static __be64 node_guid(struct rvt_dev *rdev)
+{
+	struct rxe_dev *xdev = to_xdev(rdev);
+	
+	if (xdev && xdev->ndev)
+		return rxe_mac_to_eui64(xdev->ndev);
+	else
+		return 0LL;
+}
+
+static __be64 port_guid(struct rvt_dev *rdev, unsigned int port_num)
+{
+	struct rxe_dev *xdev = to_xdev(rdev);
+
+	if (xdev && xdev->ndev)
+		return rxe_mac_to_eui64(xdev->ndev) + port_num;
+	else
+		return 0LL;
+}
+
+static __be16 port_speed(struct rvt_dev *rdev, unsigned int port_num)
+{
+	struct rxe_dev *xdev = to_xdev(rdev);
+	struct ethtool_cmd cmd;
+
+	xdev->ndev->ethtool_ops->get_settings(xdev->ndev, &cmd);
+	return cmd.speed;
+}
+
+static struct device *dma_device(struct rvt_dev *rdev)
+{
+	struct rxe_dev	*xdev = to_xdev(rdev);
+	struct net_device *ndev = xdev->ndev;
+
+	if (ndev->priv_flags & IFF_802_1Q_VLAN)
+		ndev = vlan_dev_real_dev(ndev);
+
+	return ndev->dev.parent;
+}
+
+static int mcast_add(struct rvt_dev *rdev, union ib_gid *mgid)
+{
+	int err;
+	unsigned char ll_addr[ETH_ALEN];
+	struct rxe_dev	*xdev = to_xdev(rdev);
+
+	ipv6_eth_mc_map((struct in6_addr *)mgid->raw, ll_addr);
+	err = dev_mc_add(xdev->ndev, ll_addr);
+
+	return err;
+}
+
+static int mcast_delete(struct rvt_dev *rdev, union ib_gid *mgid)
+{
+	int err;
+	unsigned char ll_addr[ETH_ALEN];
+	struct rxe_dev	*xdev = to_xdev(rdev);
+
+	ipv6_eth_mc_map((struct in6_addr *)mgid->raw, ll_addr);
+	err = dev_mc_del(xdev->ndev, ll_addr);
+
+	return err;
+}
+
+static int rxe_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
+{
+	struct net_device *ndev = skb->dev;
+	struct rxe_dev *xdev = net_to_xdev(ndev);
+	struct rvt_dev *rdev = &xdev->rdev;
+
+	if (!xdev)
+		goto drop;
+
+	if (skb_linearize(skb)) {
+		pr_err("skb_linearize failed\n");
+		goto drop;
+	}
+
+	return rvt_rcv(skb, rdev, net_to_port(ndev));
+drop:
+	kfree_skb(skb);
+	return 0;
+}
+
+static struct socket *rxe_setup_udp_tunnel(struct net *net, __be16 port,
+		bool ipv6)
+{
+	int err;
+	struct socket *sock;
+	struct udp_port_cfg udp_cfg;
+	struct udp_tunnel_sock_cfg tnl_cfg;
+
+	memset(&udp_cfg, 0, sizeof(udp_cfg));
+
+	if (ipv6) {
+		udp_cfg.family = AF_INET6;
+		udp_cfg.ipv6_v6only = 1;
+	} else {
+		udp_cfg.family = AF_INET;
+	}
+
+	udp_cfg.local_udp_port = port;
+
+	/* Create UDP socket */
+	err = udp_sock_create(net, &udp_cfg, &sock);
+	if (err < 0) {
+		pr_err("failed to create udp socket. err = %d\n", err);
+		return ERR_PTR(err);
+	}
+
+	tnl_cfg.sk_user_data = NULL;
+	tnl_cfg.encap_type = 1;
+	tnl_cfg.encap_rcv = rxe_udp_encap_recv;
+	tnl_cfg.encap_destroy = NULL;
+
+	/* Setup UDP tunnel */
+	setup_udp_tunnel_sock(net, sock, &tnl_cfg);
+
+	return sock;
+}
+
+static void rxe_release_udp_tunnel(struct socket *sk)
+{
+	udp_tunnel_sock_release(sk);
+}
+
+static void rxe_skb_tx_dtor(struct sk_buff *skb)
+{
+	struct sock *sk = skb->sk;
+
+	rvt_send_done(sk->sk_user_data);
+
+}
+
+static int send(struct rvt_dev *rdev, struct rvt_av *av,
+		struct sk_buff *skb, void *flow)
+{
+	struct sk_buff *nskb;
+	int sent_bytes;
+	int err;
+	struct rxe_dev  *xdev = to_xdev(rdev);
+	struct socket *sk = (struct socket *)flow;
+
+	nskb = skb_clone(skb, GFP_ATOMIC);
+	if (!nskb)
+		return -ENOMEM;
+
+	nskb->destructor = rxe_skb_tx_dtor;
+	nskb->sk = sk->sk;
+
+	sent_bytes = nskb->len;
+	if (av->network_type == RDMA_NETWORK_IPV4) {
+		err = ip_local_out(dev_net(xdev->ndev), nskb->sk, nskb);
+	} else if (av->network_type == RDMA_NETWORK_IPV6) {
+		err = ip6_local_out(dev_net(xdev->ndev), nskb->sk, nskb);
+	} else {
+		pr_err("Unknown layer 3 protocol: %d\n", av->network_type);
+		kfree_skb(nskb);
+		return -EINVAL;
+	}
+
+	if (unlikely(net_xmit_eval(err))) {
+		pr_debug("error sending packet: %d\n", err);
+		return -EAGAIN;
+	}
+
+	kfree_skb(skb);
+
+	return 0;
+}
+
+static int loopback(struct sk_buff *skb)
+{
+	struct net_device *ndev = skb->dev;
+	struct rxe_dev *xdev = net_to_xdev(ndev);
+	struct rvt_dev *rdev = &xdev->rdev;
+
+	return rvt_rcv(skb, rdev, net_to_port(ndev));
+}
+
+static struct sk_buff *alloc_sendbuf(struct rvt_dev *rdev, struct rvt_av *av, int paylen)
+{
+	unsigned int hdr_len;
+	struct sk_buff *skb;
+	struct rxe_dev  *xdev = to_xdev(rdev);
+
+	if (av->network_type == RDMA_NETWORK_IPV4)
+		hdr_len = ETH_HLEN + sizeof(struct udphdr) +
+			sizeof(struct iphdr);
+	else
+		hdr_len = ETH_HLEN + sizeof(struct udphdr) +
+			sizeof(struct ipv6hdr);
+
+	skb = alloc_skb(paylen + hdr_len + LL_RESERVED_SPACE(xdev->ndev),
+			GFP_ATOMIC);
+	if (unlikely(!skb))
+		return NULL;
+
+	skb_reserve(skb, hdr_len + LL_RESERVED_SPACE(xdev->ndev));
+
+	skb->dev	= xdev->ndev;
+	if (av->network_type == RDMA_NETWORK_IPV4)
+		skb->protocol = htons(ETH_P_IP);
+	else
+		skb->protocol = htons(ETH_P_IPV6);
+
+	return skb;
+}
+/*
+ * this is required by rxe_cfg to match rxe devices in
+ * /sys/class/infiniband up with their underlying ethernet devices
+ */
+static char *parent_name(struct rvt_dev *rdev, unsigned int port_num)
+{
+	struct rxe_dev  *xdev = to_xdev(rdev);
+	return xdev->ndev->name;
+}
+
+static enum rdma_link_layer link_layer(struct rvt_dev *rxe,
+				       unsigned int port_num)
+{
+	return IB_LINK_LAYER_ETHERNET;
+}
+
+static struct net_device *get_netdev(struct rvt_dev *rdev,
+				     unsigned int port_num)
+{
+	struct rxe_dev  *xdev = to_xdev(rdev);
+
+	return xdev->ndev;
+}
+
+int create_flow(struct rvt_dev *rdev, void **ctx, void *rvt_ctx)
+{
+	struct socket *sk;
+	int err;
+
+	*ctx = NULL;
+	err = sock_create_kern(&init_net, AF_INET, SOCK_DGRAM, 0, &sk);
+	if (err) {
+		pr_err("rxe: Failed to create socket for flow %p (%d)\n", rvt_ctx, err);
+		return err;
+	}
+	sk->sk->sk_user_data = rvt_ctx;
+	*ctx = sk;
+	return 0;
+}
+
+void destroy_flow(struct rvt_dev *rdev, void *ctx)
+{
+	struct socket *sk = (struct socket *)ctx;
+
+	kernel_sock_shutdown(sk, SHUT_RDWR);
+}
+
+static struct rvt_ifc_ops ifc_ops = {
+	.node_guid		= node_guid,
+	.port_guid		= port_guid,
+	.port_speed		= port_speed,
+	.dma_device		= dma_device,
+	.mcast_add		= mcast_add,
+	.mcast_delete		= mcast_delete,
+	.create_flow		= create_flow,
+	.destroy_flow		= destroy_flow,
+	.send			= send,
+	.loopback		= loopback,
+	.alloc_sendbuf		= alloc_sendbuf,
+	.parent_name		= parent_name,
+	.link_layer		= link_layer,
+	.get_netdev		= get_netdev,
+};
+
+/* Caller must hold net_info_lock */
+int rxe_net_add(struct net_device *ndev)
+{
+	struct rxe_dev *xdev;
+	unsigned port_num;
+	int err;
+
+	xdev = (struct rxe_dev *)rvt_alloc_device(sizeof *xdev);
+	if (!xdev)
+		return -ENOMEM;
+
+	xdev->ndev = ndev;
+	xdev->rdev.num_ports = 1;
+
+	err = rvt_register_device(&xdev->rdev, &ifc_ops, ndev->mtu);
+	if (err)
+		return err;
+
+
+	/* for now we always assign port = 1 */
+	port_num = 1;
+
+	xdev->ndev = ndev;
+
+
+	pr_info("rxe_net: added %s to %s\n",
+		xdev->rdev.ib_dev.name, ndev->name);
+
+	net_info[ndev->ifindex].xdev = xdev;
+	net_info[ndev->ifindex].port = port_num;
+	net_info[ndev->ifindex].ndev = ndev;
+	return 0;
+}
+
+/* Caller must hold net_info_lock */
+void rxe_net_up(struct net_device *ndev)
+{
+	struct rxe_dev *xdev;
+	struct rvt_dev *rdev;
+	struct rvt_port *port;
+	u8 port_num;
+
+	if (ndev->ifindex >= RXE_MAX_IF_INDEX)
+		goto out;
+
+	net_info[ndev->ifindex].status = IB_PORT_ACTIVE;
+
+	xdev = net_to_xdev(ndev);
+	if (!xdev)
+		goto out;
+	rdev = &xdev->rdev;
+
+	port_num = net_to_port(ndev);
+	port = &rdev->port[port_num - 1];
+	port->attr.state = IB_PORT_ACTIVE;
+	port->attr.phys_state = IB_PHYS_STATE_LINK_UP;
+
+	pr_info("rxe_net: set %s active for %s\n",
+		rdev->ib_dev.name, ndev->name);
+out:
+	return;
+}
+
+/* Caller must hold net_info_lock */
+void rxe_net_down(struct net_device *ndev)
+{
+	struct rxe_dev *xdev;
+	struct rvt_dev *rdev;
+	struct rvt_port *port;
+	u8 port_num;
+
+	if (ndev->ifindex >= RXE_MAX_IF_INDEX)
+		goto out;
+
+	net_info[ndev->ifindex].status = IB_PORT_DOWN;
+
+	xdev = net_to_xdev(ndev);
+	if (!xdev)
+		goto out;
+	rdev = &xdev->rdev;
+
+	port_num = net_to_port(ndev);
+	port = &rdev->port[port_num - 1];
+	port->attr.state = IB_PORT_DOWN;
+	port->attr.phys_state = 3;
+
+	pr_info("rxe_net: set %s down for %s\n",
+		rdev->ib_dev.name, ndev->name);
+out:
+	return;
+}
+
+static int can_support_rxe(struct net_device *ndev)
+{
+	int rc = 0;
+
+	if (ndev->ifindex >= RXE_MAX_IF_INDEX) {
+		pr_debug("%s index %d: too large for rxe ndev table\n",
+			 ndev->name, ndev->ifindex);
+		goto out;
+	}
+
+	/* Let's says we support all ethX devices */
+	if (ndev->type == ARPHRD_ETHER)
+		rc = 1;
+
+out:
+	return rc;
+}
+
+static int rxe_notify(struct notifier_block *not_blk,
+		      unsigned long event,
+		      void *arg)
+{
+	struct rxe_dev *xdev;
+	struct net_device *ndev = netdev_notifier_info_to_dev(arg);
+
+	if (!can_support_rxe(ndev))
+		goto out;
+
+	spin_lock_bh(&net_info_lock);
+	switch (event) {
+	case NETDEV_REGISTER:
+		/* Keep a record of this NIC. */
+		net_info[ndev->ifindex].status = IB_PORT_DOWN;
+		net_info[ndev->ifindex].xdev = NULL;
+		net_info[ndev->ifindex].port = 1;
+		net_info[ndev->ifindex].ndev = ndev;
+		break;
+
+	case NETDEV_UNREGISTER:
+		if (net_info[ndev->ifindex].xdev) {
+			xdev = net_info[ndev->ifindex].xdev;
+			net_info[ndev->ifindex].xdev = NULL;
+			spin_unlock_bh(&net_info_lock);
+			rvt_unregister_device(&xdev->rdev);
+			spin_lock_bh(&net_info_lock);
+		}
+		net_info[ndev->ifindex].status = 0;
+		net_info[ndev->ifindex].port = 0;
+		net_info[ndev->ifindex].ndev = NULL;
+		break;
+
+	case NETDEV_UP:
+		rxe_net_up(ndev);
+		break;
+
+	case NETDEV_DOWN:
+		rxe_net_down(ndev);
+		break;
+
+	case NETDEV_CHANGEMTU:
+		xdev = net_to_xdev(ndev);
+		if (xdev) {
+			pr_info("rxe_net: %s changed mtu to %d\n",
+				ndev->name, ndev->mtu);
+			rvt_set_mtu(&xdev->rdev, ndev->mtu, net_to_port(ndev));
+		}
+		break;
+
+	case NETDEV_REBOOT:
+	case NETDEV_CHANGE:
+	case NETDEV_GOING_DOWN:
+	case NETDEV_CHANGEADDR:
+	case NETDEV_CHANGENAME:
+	case NETDEV_FEAT_CHANGE:
+	default:
+		pr_info("rxe_net: ignoring netdev event = %ld for %s\n",
+			event, ndev->name);
+		break;
+	}
+	spin_unlock_bh(&net_info_lock);
+
+out:
+	return NOTIFY_OK;
+}
+
+static struct notifier_block rxe_net_notifier = {
+	.notifier_call = rxe_notify,
+};
+
+static int rxe_net_init(void)
+{
+	int err;
+
+	spin_lock_init(&net_info_lock);
+
+	recv_sockets.sk6 = rxe_setup_udp_tunnel(&init_net,
+			htons(ROCE_V2_UDP_DPORT), true);
+	if (IS_ERR(recv_sockets.sk6)) {
+		recv_sockets.sk6 = NULL;
+		pr_err("rxe: Failed to create IPv6 UDP tunnel\n");
+		return -1;
+	}
+
+	recv_sockets.sk4 = rxe_setup_udp_tunnel(&init_net,
+			htons(ROCE_V2_UDP_DPORT), false);
+	if (IS_ERR(recv_sockets.sk4)) {
+		rxe_release_udp_tunnel(recv_sockets.sk6);
+		recv_sockets.sk4 = NULL;
+		recv_sockets.sk6 = NULL;
+		pr_err("rxe: Failed to create IPv4 UDP tunnel\n");
+		return -1;
+	}
+
+
+	err = register_netdevice_notifier(&rxe_net_notifier);
+	if (err) {
+		rxe_release_udp_tunnel(recv_sockets.sk6);
+		rxe_release_udp_tunnel(recv_sockets.sk4);
+		pr_err("rxe: Failed to rigister netdev notifier\n");
+	}
+
+	return err;
+}
+
+static void rxe_net_exit(void)
+{
+	if (recv_sockets.sk6)
+		rxe_release_udp_tunnel(recv_sockets.sk6);
+
+	if (recv_sockets.sk4)
+		rxe_release_udp_tunnel(recv_sockets.sk4);
+
+	unregister_netdevice_notifier(&rxe_net_notifier);
+}
+
+module_init(rxe_net_init);
+module_exit(rxe_net_exit);
diff --git a/drivers/infiniband/sw/rxe/rxe_net.h b/drivers/infiniband/sw/rxe/rxe_net.h
new file mode 100644
index 0000000..04d4978
--- /dev/null
+++ b/drivers/infiniband/sw/rxe/rxe_net.h
@@ -0,0 +1,89 @@
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
+#ifndef RXE_NET_H
+#define RXE_NET_H
+
+#include <net/sock.h>
+#include <net/if_inet6.h>
+#include <linux/module.h>
+#include <linux/crc32.h>
+#include <rdma/ib_rvt.h>
+
+#define RXE_MAX_IF_INDEX	(384)
+#define RXE_ROCE_V2_SPORT	(0xc000)
+
+struct rxe_dev {
+	struct rvt_dev	  rdev;
+	struct net_device *ndev;
+};
+
+struct rxe_net_info {
+	struct rxe_dev		*xdev;
+	u8			port;
+	struct net_device	*ndev;
+	int			status;
+};
+
+struct rxe_recv_sockets {
+	struct socket *sk4;
+	struct socket *sk6;
+};
+
+extern struct rxe_recv_sockets recv_sockets;
+extern struct rxe_net_info net_info[RXE_MAX_IF_INDEX];
+extern spinlock_t net_info_lock;
+
+static inline struct rxe_dev *to_xdev(struct rvt_dev *rdev)
+{
+	return rdev ? container_of(rdev, struct rxe_dev, rdev) : NULL;
+}
+
+/* caller must hold net_dev_lock */
+static inline struct rxe_dev *net_to_xdev(struct net_device *ndev)
+{
+	return (ndev->ifindex >= RXE_MAX_IF_INDEX) ?
+		NULL : net_info[ndev->ifindex].xdev;
+}
+
+static inline u8 net_to_port(struct net_device *ndev)
+{
+	return net_info[ndev->ifindex].port;
+}
+
+int rxe_net_add(struct net_device *ndev);
+void rxe_net_up(struct net_device *ndev);
+void rxe_net_down(struct net_device *ndev);
+
+
+#endif /* RXE_NET_H */
diff --git a/drivers/infiniband/sw/rxe/rxe_sysfs.c b/drivers/infiniband/sw/rxe/rxe_sysfs.c
new file mode 100644
index 0000000..ee05da9
--- /dev/null
+++ b/drivers/infiniband/sw/rxe/rxe_sysfs.c
@@ -0,0 +1,167 @@
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
+#include "rxe_net.h"
+
+/* Copy argument and remove trailing CR. Return the new length. */
+static int sanitize_arg(const char *val, char *intf, int intf_len)
+{
+	int len;
+
+	if (!val)
+		return 0;
+
+	/* Remove newline. */
+	for (len = 0; len < intf_len - 1 && val[len] && val[len] != '\n'; len++)
+		intf[len] = val[len];
+	intf[len] = 0;
+
+	if (len == 0 || (val[len] != 0 && val[len] != '\n'))
+		return 0;
+
+	return len;
+}
+
+/* Caller must hold net_info_lock */
+static void rxe_set_port_state(struct net_device *ndev)
+{
+	struct rxe_dev *xdev;
+
+	xdev = net_to_xdev(ndev);
+	if (!xdev)
+		goto out;
+
+	if (net_info[ndev->ifindex].status == IB_PORT_ACTIVE)
+		rxe_net_up(ndev);
+	else
+		rxe_net_down(ndev); /* down for unknown state */
+out:
+	return;
+}
+
+static int rxe_param_set_add(const char *val, struct kernel_param *kp)
+{
+	int i, len, err;
+	char intf[32];
+
+	len = sanitize_arg(val, intf, sizeof(intf));
+	if (!len) {
+		pr_err("rxe: add: invalid interface name\n");
+		return -EINVAL;
+	}
+
+	spin_lock_bh(&net_info_lock);
+	for (i = 0; i < RXE_MAX_IF_INDEX; i++) {
+		struct net_device *ndev = net_info[i].ndev;
+
+		if (ndev && (0 == strncmp(intf, ndev->name, len))) {
+			spin_unlock_bh(&net_info_lock);
+			if (net_info[i].xdev)
+				pr_info("rxe: already configured on %s\n",
+					intf);
+			else {
+				err = rxe_net_add(ndev);
+				if (!err && net_info[i].xdev) {
+					rxe_set_port_state(ndev);
+				} else {
+					pr_err("rxe: add appears to have failed for %s (index %d)\n",
+					       intf, i);
+				}
+			}
+			return 0;
+		}
+	}
+	spin_unlock_bh(&net_info_lock);
+
+	pr_warn("interface %s not found\n", intf);
+
+	return 0;
+}
+
+static void rxe_remove_all(void)
+{
+	int i;
+	struct rxe_dev *xdev;
+
+	for (i = 0; i < RXE_MAX_IF_INDEX; i++) {
+		if (net_info[i].xdev) {
+			spin_lock_bh(&net_info_lock);
+			xdev = net_info[i].xdev;
+			net_info[i].xdev = NULL;
+			spin_unlock_bh(&net_info_lock);
+
+			rvt_unregister_device(&xdev->rdev);
+		}
+	}
+}
+
+static int rxe_param_set_remove(const char *val, struct kernel_param *kp)
+{
+	int i, len;
+	char intf[32];
+	struct rxe_dev *xdev;
+
+	len = sanitize_arg(val, intf, sizeof(intf));
+	if (!len) {
+		pr_err("xdev: remove: invalid interface name\n");
+		return -EINVAL;
+	}
+
+	if (strncmp("all", intf, len) == 0) {
+		pr_info("xdev_sys: remove all");
+		rxe_remove_all();
+		return 0;
+	}
+
+	spin_lock_bh(&net_info_lock);
+	for (i = 0; i < RXE_MAX_IF_INDEX; i++) {
+		if (!net_info[i].xdev || !net_info[i].ndev)
+			continue;
+
+		if (0 == strncmp(intf, net_info[i].xdev->rdev.ib_dev.name, len)) {
+			xdev = net_info[i].xdev;
+			net_info[i].xdev = NULL;
+			spin_unlock_bh(&net_info_lock);
+
+			rvt_unregister_device(&xdev->rdev);
+			return 0;
+		}
+	}
+	spin_unlock_bh(&net_info_lock);
+	pr_warn("xdev_sys: instance %s not found\n", intf);
+
+	return 0;
+}
+
+module_param_call(add, rxe_param_set_add, NULL, NULL, 0200);
+module_param_call(remove, rxe_param_set_remove, NULL, NULL, 0200);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
