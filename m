From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] RDMA/nes: Add support for iWARP Port Mapper user space
 service (Version 2)
Date: Wed, 26 Mar 2014 17:07:57 -0500
Message-ID: <20140326220757.GA15880@TENIKOLO-MOBL1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add support for iWarp Port Mapper (Version 2) 

Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes.c    |   25 +++-
 drivers/infiniband/hw/nes/nes.h    |    3 +
 drivers/infiniband/hw/nes/nes_cm.c |  320 +++++++++++++++++++++++++++++-------
 drivers/infiniband/hw/nes/nes_cm.h |   12 +-
 4 files changed, 296 insertions(+), 64 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 353c7b0..3b2a6dc 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -68,7 +68,6 @@ MODULE_VERSION(DRV_VERSION);
 int max_mtu = 9000;
 int interrupt_mod_interval = 0;
 
-
 /* Interoperability */
 int mpa_version = 1;
 module_param(mpa_version, int, 0644);
@@ -112,6 +111,16 @@ static struct pci_device_id nes_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, nes_pci_table);
 
+/* registered nes netlink callbacks */
+static struct ibnl_client_cbs nes_nl_cb_table[] = {
+	[RDMA_NL_IWPM_REG_PID] = {.dump = iwpm_register_pid_cb},
+	[RDMA_NL_IWPM_ADD_MAPPING] = {.dump = iwpm_add_mapping_cb},
+	[RDMA_NL_IWPM_QUERY_MAPPING] = {.dump = iwpm_add_and_query_mapping_cb},
+	[RDMA_NL_IWPM_HANDLE_ERR] = {.dump = iwpm_mapping_error_cb},
+	[RDMA_NL_IWPM_MAPINFO] = {.dump = iwpm_mapping_info_cb},
+	[RDMA_NL_IWPM_MAPINFO_NUM] = {.dump = iwpm_ack_mapping_info_cb}
+};
+
 static int nes_inetaddr_event(struct notifier_block *, unsigned long, void *);
 static int nes_net_event(struct notifier_block *, unsigned long, void *);
 static int nes_notifiers_registered;
@@ -672,6 +681,17 @@ static int nes_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 	}
 	nes_notifiers_registered++;
 
+	if (ibnl_add_client(RDMA_NL_NES, RDMA_NL_IWPM_NUM_OPS, nes_nl_cb_table))
+		printk(KERN_ERR PFX "%s[%u]: Failed to add netlink callback\n",
+			__func__, __LINE__);
+
+	ret = iwpm_init(RDMA_NL_NES);
+	if (ret) {
+		printk(KERN_ERR PFX "%s: port mapper initialization failed\n",
+				pci_name(pcidev));
+		goto bail7;
+	}
+
 	INIT_DELAYED_WORK(&nesdev->work, nes_recheck_link_status);
 
 	/* Initialize network devices */
@@ -710,6 +730,7 @@ static int nes_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 
 	nes_debug(NES_DBG_INIT, "netdev_count=%d, nesadapter->netdev_count=%d\n",
 			nesdev->netdev_count, nesdev->nesadapter->netdev_count);
+	ibnl_remove_client(RDMA_NL_NES);
 
 	nes_notifiers_registered--;
 	if (nes_notifiers_registered == 0) {
@@ -773,6 +794,8 @@ static void nes_remove(struct pci_dev *pcidev)
 				nesdev->nesadapter->netdev_count--;
 			}
 		}
+	ibnl_remove_client(RDMA_NL_NES);
+	iwpm_exit(RDMA_NL_NES);
 
 	nes_notifiers_registered--;
 	if (nes_notifiers_registered == 0) {
diff --git a/drivers/infiniband/hw/nes/nes.h b/drivers/infiniband/hw/nes/nes.h
index 33cc589..bd9d132 100644
--- a/drivers/infiniband/hw/nes/nes.h
+++ b/drivers/infiniband/hw/nes/nes.h
@@ -51,6 +51,8 @@
 #include <rdma/ib_pack.h>
 #include <rdma/rdma_cm.h>
 #include <rdma/iw_cm.h>
+#include <rdma/rdma_netlink.h>
+#include <rdma/iw_portmap.h>
 
 #define NES_SEND_FIRST_WRITE
 
@@ -130,6 +132,7 @@
 #define NES_DBG_IW_TX       0x00040000
 #define NES_DBG_SHUTDOWN    0x00080000
 #define NES_DBG_PAU         0x00100000
+#define NES_DBG_NLMSG       0x00200000
 #define NES_DBG_RSVD1       0x10000000
 #define NES_DBG_RSVD2       0x20000000
 #define NES_DBG_RSVD3       0x40000000
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index dfa9df4..6f09a72 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006 - 2011 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2006 - 2014 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -59,6 +59,7 @@
 #include <net/route.h>
 #include <net/ip_fib.h>
 #include <net/tcp.h>
+#include <linux/fcntl.h>
 
 #include "nes.h"
 
@@ -166,7 +167,6 @@ int nes_rem_ref_cm_node(struct nes_cm_node *cm_node)
 {
 	return rem_ref_cm_node(cm_node->cm_core, cm_node);
 }
-
 /**
  * create_event
  */
@@ -482,11 +482,11 @@ static void form_cm_frame(struct sk_buff *skb,
 	iph->ttl = 0x40;
 	iph->protocol = 0x06;   /* IPPROTO_TCP */
 
-	iph->saddr = htonl(cm_node->loc_addr);
-	iph->daddr = htonl(cm_node->rem_addr);
+	iph->saddr = htonl(cm_node->mapped_loc_addr);
+	iph->daddr = htonl(cm_node->mapped_rem_addr);
 
-	tcph->source = htons(cm_node->loc_port);
-	tcph->dest = htons(cm_node->rem_port);
+	tcph->source = htons(cm_node->mapped_loc_port);
+	tcph->dest = htons(cm_node->mapped_rem_port);
 	tcph->seq = htonl(cm_node->tcp_cntxt.loc_seq_num);
 
 	if (flags & SET_ACK) {
@@ -525,6 +525,100 @@ static void form_cm_frame(struct sk_buff *skb,
 	cm_packets_created++;
 }
 
+/*
+ * nes_create_sockaddr - Record ip addr and tcp port in a sockaddr struct
+ */
+static void nes_create_sockaddr(__be32 ip_addr, __be16 port,
+				struct sockaddr_storage *addr)
+{
+	struct sockaddr_in *nes_sockaddr = (struct sockaddr_in *)addr;
+	nes_sockaddr->sin_family = AF_INET;
+	memcpy(&nes_sockaddr->sin_addr.s_addr, &ip_addr, sizeof(__be32));
+	nes_sockaddr->sin_port = port;
+}
+
+/*
+ * nes_create_mapinfo - Create a mapinfo object in the port mapper data base
+ */
+static int nes_create_mapinfo(struct nes_cm_info *cm_info)
+{
+	struct sockaddr_storage local_sockaddr;
+	struct sockaddr_storage mapped_sockaddr;
+
+	nes_create_sockaddr(htonl(cm_info->loc_addr), htons(cm_info->loc_port),
+				&local_sockaddr);
+	nes_create_sockaddr(htonl(cm_info->mapped_loc_addr),
+			htons(cm_info->mapped_loc_port), &mapped_sockaddr);
+
+	return iwpm_create_mapinfo(&local_sockaddr,
+				&mapped_sockaddr, RDMA_NL_NES);
+}
+
+/*
+ * nes_remove_mapinfo - Remove a mapinfo object from the port mapper data base
+ *                      and send a remove mapping op message to
+ *                      the userspace port mapper
+ */
+static int nes_remove_mapinfo(u32 loc_addr, u16 loc_port,
+			u32 mapped_loc_addr, u16 mapped_loc_port)
+{
+	struct sockaddr_storage local_sockaddr;
+	struct sockaddr_storage mapped_sockaddr;
+
+	nes_create_sockaddr(htonl(loc_addr), htons(loc_port), &local_sockaddr);
+	nes_create_sockaddr(htonl(mapped_loc_addr), htons(mapped_loc_port),
+				&mapped_sockaddr);
+
+	iwpm_remove_mapinfo(&local_sockaddr, &mapped_sockaddr);
+	return iwpm_remove_mapping(&local_sockaddr, RDMA_NL_NES);
+}
+
+/*
+ * nes_form_pm_msg - Form a port mapper message with mapping info
+ */
+static void nes_form_pm_msg(struct nes_cm_info *cm_info,
+				struct iwpm_sa_data *pm_msg)
+{
+	nes_create_sockaddr(htonl(cm_info->loc_addr), htons(cm_info->loc_port),
+				&pm_msg->loc_addr);
+	nes_create_sockaddr(htonl(cm_info->rem_addr), htons(cm_info->rem_port),
+				&pm_msg->rem_addr);
+}
+
+/*
+ * nes_form_reg_msg - Form a port mapper message with dev info
+ */
+static void nes_form_reg_msg(struct nes_vnic *nesvnic,
+			struct iwpm_dev_data *pm_msg)
+{
+	memcpy(pm_msg->dev_name, nesvnic->nesibdev->ibdev.name,
+				IWPM_DEVNAME_SIZE);
+	memcpy(pm_msg->if_name, nesvnic->netdev->name, IWPM_IFNAME_SIZE);
+}
+
+/*
+ * nes_record_pm_msg - Save the received mapping info
+ */
+static void nes_record_pm_msg(struct nes_cm_info *cm_info,
+			struct iwpm_sa_data *pm_msg)
+{
+	struct sockaddr_in *mapped_loc_addr =
+			(struct sockaddr_in *)&pm_msg->mapped_loc_addr;
+	struct sockaddr_in *mapped_rem_addr =
+			(struct sockaddr_in *)&pm_msg->mapped_rem_addr;
+
+	if (mapped_loc_addr->sin_family == AF_INET) {
+		cm_info->mapped_loc_addr =
+			ntohl(mapped_loc_addr->sin_addr.s_addr);
+		cm_info->mapped_loc_port = ntohs(mapped_loc_addr->sin_port);
+	}
+	if (mapped_rem_addr->sin_family == AF_INET) {
+		cm_info->mapped_rem_addr =
+			ntohl(mapped_rem_addr->sin_addr.s_addr);
+		cm_info->mapped_rem_port = ntohs(mapped_rem_addr->sin_port);
+	}
+}
+
 /**
  * print_core - dump a cm core
  */
@@ -1147,8 +1241,11 @@ static struct nes_cm_node *find_node(struct nes_cm_core *cm_core,
 			  loc_addr, loc_port,
 			  cm_node->rem_addr, cm_node->rem_port,
 			  rem_addr, rem_port);
-		if ((cm_node->loc_addr == loc_addr) && (cm_node->loc_port == loc_port) &&
-		    (cm_node->rem_addr == rem_addr) && (cm_node->rem_port == rem_port)) {
+		if ((cm_node->mapped_loc_addr == loc_addr) &&
+			(cm_node->mapped_loc_port == loc_port) &&
+			(cm_node->mapped_rem_addr == rem_addr) &&
+			(cm_node->mapped_rem_port == rem_port)) {
+
 			add_ref_cm_node(cm_node);
 			spin_unlock_irqrestore(&cm_core->ht_lock, flags);
 			return cm_node;
@@ -1165,18 +1262,28 @@ static struct nes_cm_node *find_node(struct nes_cm_core *cm_core,
  * find_listener - find a cm node listening on this addr-port pair
  */
 static struct nes_cm_listener *find_listener(struct nes_cm_core *cm_core,
-					     nes_addr_t dst_addr, u16 dst_port, enum nes_cm_listener_state listener_state)
+					nes_addr_t dst_addr, u16 dst_port,
+					enum nes_cm_listener_state listener_state, int local)
 {
 	unsigned long flags;
 	struct nes_cm_listener *listen_node;
+	nes_addr_t listen_addr;
+	u16 listen_port;
 
 	/* walk list and find cm_node associated with this session ID */
 	spin_lock_irqsave(&cm_core->listen_list_lock, flags);
 	list_for_each_entry(listen_node, &cm_core->listen_list.list, list) {
+		if (local) {
+			listen_addr = listen_node->loc_addr;
+			listen_port = listen_node->loc_port;
+		} else {
+			listen_addr = listen_node->mapped_loc_addr;
+			listen_port = listen_node->mapped_loc_port;
+		}
 		/* compare node pair, return node handle if a match */
-		if (((listen_node->loc_addr == dst_addr) ||
-		     listen_node->loc_addr == 0x00000000) &&
-		    (listen_node->loc_port == dst_port) &&
+		if (((listen_addr == dst_addr) ||
+		     listen_addr == 0x00000000) &&
+		    (listen_port == dst_port) &&
 		    (listener_state & listen_node->listener_state)) {
 			atomic_inc(&listen_node->ref_count);
 			spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
@@ -1189,7 +1296,6 @@ static struct nes_cm_listener *find_listener(struct nes_cm_core *cm_core,
 	return NULL;
 }
 
-
 /**
  * add_hte_node - add a cm node to the hash table
  */
@@ -1310,9 +1416,20 @@ static int mini_cm_dec_refcnt_listen(struct nes_cm_core *cm_core,
 
 		spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
 
-		if (listener->nesvnic)
-			nes_manage_apbvt(listener->nesvnic, listener->loc_port,
-					 PCI_FUNC(listener->nesvnic->nesdev->pcidev->devfn), NES_MANAGE_APBVT_DEL);
+		if (listener->nesvnic) {
+			nes_manage_apbvt(listener->nesvnic,
+				listener->mapped_loc_port,
+				PCI_FUNC(listener->nesvnic->nesdev->pcidev->devfn),
+				NES_MANAGE_APBVT_DEL);
+
+			nes_remove_mapinfo(listener->loc_addr,
+					listener->loc_port,
+					listener->mapped_loc_addr,
+					listener->mapped_loc_port);
+			nes_debug(NES_DBG_NLMSG,
+					"Delete APBVT mapped_loc_port = %04X\n",
+					listener->mapped_loc_port);
+		}
 
 		nes_debug(NES_DBG_CM, "destroying listener (%p)\n", listener);
 
@@ -1454,6 +1571,11 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
 	cm_node->loc_port = cm_info->loc_port;
 	cm_node->rem_port = cm_info->rem_port;
 
+	cm_node->mapped_loc_addr = cm_info->mapped_loc_addr;
+	cm_node->mapped_rem_addr = cm_info->mapped_rem_addr;
+	cm_node->mapped_loc_port = cm_info->mapped_loc_port;
+	cm_node->mapped_rem_port = cm_info->mapped_rem_port;
+
 	cm_node->mpa_frame_rev = mpa_version;
 	cm_node->send_rdma0_op = SEND_RDMA_READ_ZERO;
 	cm_node->mpav2_ird_ord = 0;
@@ -1500,8 +1622,10 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
 	cm_node->loopbackpartner = NULL;
 
 	/* get the mac addr for the remote node */
-	oldarpindex = nes_arp_table(nesdev, cm_node->rem_addr, NULL, NES_ARP_RESOLVE);
-	arpindex = nes_addr_resolve_neigh(nesvnic, cm_info->rem_addr, oldarpindex);
+	oldarpindex = nes_arp_table(nesdev, cm_node->mapped_rem_addr,
+				NULL, NES_ARP_RESOLVE);
+	arpindex = nes_addr_resolve_neigh(nesvnic,
+				cm_node->mapped_rem_addr, oldarpindex);
 	if (arpindex < 0) {
 		kfree(cm_node);
 		return NULL;
@@ -1563,11 +1687,14 @@ static int rem_ref_cm_node(struct nes_cm_core *cm_core,
 		mini_cm_dec_refcnt_listen(cm_core, cm_node->listener, 0);
 	} else {
 		if (cm_node->apbvt_set && cm_node->nesvnic) {
-			nes_manage_apbvt(cm_node->nesvnic, cm_node->loc_port,
-					 PCI_FUNC(
-						 cm_node->nesvnic->nesdev->pcidev->devfn),
+			nes_manage_apbvt(cm_node->nesvnic, cm_node->mapped_loc_port,
+					 PCI_FUNC(cm_node->nesvnic->nesdev->pcidev->devfn),
 					 NES_MANAGE_APBVT_DEL);
 		}
+		nes_debug(NES_DBG_NLMSG, "Delete APBVT mapped_loc_port = %04X\n",
+					cm_node->mapped_loc_port);
+		nes_remove_mapinfo(cm_node->loc_addr, cm_node->loc_port,
+			cm_node->mapped_loc_addr, cm_node->mapped_loc_port);
 	}
 
 	atomic_dec(&cm_core->node_cnt);
@@ -2235,17 +2362,21 @@ static void process_packet(struct nes_cm_node *cm_node, struct sk_buff *skb,
  * mini_cm_listen - create a listen node with params
  */
 static struct nes_cm_listener *mini_cm_listen(struct nes_cm_core *cm_core,
-					      struct nes_vnic *nesvnic, struct nes_cm_info *cm_info)
+			struct nes_vnic *nesvnic, struct nes_cm_info *cm_info)
 {
 	struct nes_cm_listener *listener;
+	struct iwpm_dev_data pm_reg_msg;
+	struct iwpm_sa_data pm_msg;
 	unsigned long flags;
+	int iwpm_err = 0;
 
 	nes_debug(NES_DBG_CM, "Search for 0x%08x : 0x%04x\n",
 		  cm_info->loc_addr, cm_info->loc_port);
 
 	/* cannot have multiple matching listeners */
-	listener = find_listener(cm_core, htonl(cm_info->loc_addr),
-				 htons(cm_info->loc_port), NES_CM_LISTENER_EITHER_STATE);
+	listener = find_listener(cm_core, cm_info->loc_addr, cm_info->loc_port,
+				NES_CM_LISTENER_EITHER_STATE, 1);
+
 	if (listener && listener->listener_state == NES_CM_LISTENER_ACTIVE_STATE) {
 		/* find automatically incs ref count ??? */
 		atomic_dec(&listener->ref_count);
@@ -2254,6 +2385,22 @@ static struct nes_cm_listener *mini_cm_listen(struct nes_cm_core *cm_core,
 	}
 
 	if (!listener) {
+		nes_form_reg_msg(nesvnic, &pm_reg_msg);
+		iwpm_err = iwpm_register_pid(&pm_reg_msg, RDMA_NL_NES);
+		if (iwpm_err) {
+			nes_debug(NES_DBG_NLMSG,
+			"Port Mapper reg pid fail (err = %d).\n", iwpm_err);
+		}
+		if (iwpm_valid_pid() && !iwpm_err) {
+			nes_form_pm_msg(cm_info, &pm_msg);
+			iwpm_err = iwpm_add_mapping(&pm_msg, RDMA_NL_NES);
+			if (iwpm_err)
+				nes_debug(NES_DBG_NLMSG,
+				"Port Mapper query fail (err = %d).\n", iwpm_err);
+			else
+				nes_record_pm_msg(cm_info, &pm_msg);
+		}
+
 		/* create a CM listen node (1/2 node to compare incoming traffic to) */
 		listener = kzalloc(sizeof(*listener), GFP_ATOMIC);
 		if (!listener) {
@@ -2261,8 +2408,10 @@ static struct nes_cm_listener *mini_cm_listen(struct nes_cm_core *cm_core,
 			return NULL;
 		}
 
-		listener->loc_addr = htonl(cm_info->loc_addr);
-		listener->loc_port = htons(cm_info->loc_port);
+		listener->loc_addr = cm_info->loc_addr;
+		listener->loc_port = cm_info->loc_port;
+		listener->mapped_loc_addr = cm_info->mapped_loc_addr;
+		listener->mapped_loc_port = cm_info->mapped_loc_port;
 		listener->reused_node = 0;
 
 		atomic_set(&listener->ref_count, 1);
@@ -2324,14 +2473,18 @@ static struct nes_cm_node *mini_cm_connect(struct nes_cm_core *cm_core,
 
 	if (cm_info->loc_addr == cm_info->rem_addr) {
 		loopbackremotelistener = find_listener(cm_core,
-						       ntohl(nesvnic->local_ipaddr), cm_node->rem_port,
-						       NES_CM_LISTENER_ACTIVE_STATE);
+			cm_node->mapped_loc_addr, cm_node->mapped_rem_port,
+			NES_CM_LISTENER_ACTIVE_STATE, 0);
 		if (loopbackremotelistener == NULL) {
 			create_event(cm_node, NES_CM_EVENT_ABORTED);
 		} else {
 			loopback_cm_info = *cm_info;
 			loopback_cm_info.loc_port = cm_info->rem_port;
 			loopback_cm_info.rem_port = cm_info->loc_port;
+			loopback_cm_info.mapped_loc_port =
+				cm_info->mapped_rem_port;
+			loopback_cm_info.mapped_rem_port =
+				cm_info->mapped_loc_port;
 			loopback_cm_info.cm_id = loopbackremotelistener->cm_id;
 			loopbackremotenode = make_cm_node(cm_core, nesvnic,
 							  &loopback_cm_info, loopbackremotelistener);
@@ -2560,6 +2713,12 @@ static int mini_cm_recv_pkt(struct nes_cm_core *cm_core,
 	nfo.rem_addr = ntohl(iph->saddr);
 	nfo.rem_port = ntohs(tcph->source);
 
+	/* If port mapper is available these should be mapped address info */
+	nfo.mapped_loc_addr = ntohl(iph->daddr);
+	nfo.mapped_loc_port = ntohs(tcph->dest);
+	nfo.mapped_rem_addr = ntohl(iph->saddr);
+	nfo.mapped_rem_port = ntohs(tcph->source);
+
 	tmp_daddr = cpu_to_be32(iph->daddr);
 	tmp_saddr = cpu_to_be32(iph->saddr);
 
@@ -2568,8 +2727,8 @@ static int mini_cm_recv_pkt(struct nes_cm_core *cm_core,
 
 	do {
 		cm_node = find_node(cm_core,
-				    nfo.rem_port, nfo.rem_addr,
-				    nfo.loc_port, nfo.loc_addr);
+				    nfo.mapped_rem_port, nfo.mapped_rem_addr,
+				    nfo.mapped_loc_port, nfo.mapped_loc_addr);
 
 		if (!cm_node) {
 			/* Only type of packet accepted are for */
@@ -2578,9 +2737,9 @@ static int mini_cm_recv_pkt(struct nes_cm_core *cm_core,
 				skb_handled = 0;
 				break;
 			}
-			listener = find_listener(cm_core, nfo.loc_addr,
-						 nfo.loc_port,
-						 NES_CM_LISTENER_ACTIVE_STATE);
+			listener = find_listener(cm_core, nfo.mapped_loc_addr,
+					nfo.mapped_loc_port,
+					NES_CM_LISTENER_ACTIVE_STATE, 0);
 			if (!listener) {
 				nfo.cm_id = NULL;
 				nfo.conn_type = 0;
@@ -3184,10 +3343,12 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 
 	nes_cm_init_tsa_conn(nesqp, cm_node);
 
-	nesqp->nesqp_context->tcpPorts[0] = cpu_to_le16(ntohs(laddr->sin_port));
-	nesqp->nesqp_context->tcpPorts[1] = cpu_to_le16(ntohs(raddr->sin_port));
+	nesqp->nesqp_context->tcpPorts[0] =
+				cpu_to_le16(cm_node->mapped_loc_port);
+	nesqp->nesqp_context->tcpPorts[1] =
+				cpu_to_le16(cm_node->mapped_rem_port);
 
-	nesqp->nesqp_context->ip0 = cpu_to_le32(ntohl(raddr->sin_addr.s_addr));
+	nesqp->nesqp_context->ip0 = cpu_to_le32(cm_node->mapped_rem_addr);
 
 	nesqp->nesqp_context->misc2 |= cpu_to_le32(
 		(u32)PCI_FUNC(nesdev->pcidev->devfn) <<
@@ -3211,9 +3372,9 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	memset(&nes_quad, 0, sizeof(nes_quad));
 	nes_quad.DstIpAdrIndex =
 		cpu_to_le32((u32)PCI_FUNC(nesdev->pcidev->devfn) << 24);
-	nes_quad.SrcIpadr = raddr->sin_addr.s_addr;
-	nes_quad.TcpPorts[0] = raddr->sin_port;
-	nes_quad.TcpPorts[1] = laddr->sin_port;
+	nes_quad.SrcIpadr = htonl(cm_node->mapped_rem_addr);
+	nes_quad.TcpPorts[0] = htons(cm_node->mapped_rem_port);
+	nes_quad.TcpPorts[1] = htons(cm_node->mapped_loc_port);
 
 	/* Produce hash key */
 	crc_value = get_crc_value(&nes_quad);
@@ -3315,6 +3476,9 @@ int nes_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	int apbvt_set = 0;
 	struct sockaddr_in *laddr = (struct sockaddr_in *)&cm_id->local_addr;
 	struct sockaddr_in *raddr = (struct sockaddr_in *)&cm_id->remote_addr;
+	struct iwpm_dev_data pm_reg_msg;
+	struct iwpm_sa_data pm_msg;
+	int iwpm_err = 0;
 
 	if (cm_id->remote_addr.ss_family != AF_INET)
 		return -ENOSYS;
@@ -3352,20 +3516,44 @@ int nes_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	nes_debug(NES_DBG_CM, "mpa private data len =%u\n",
 		  conn_param->private_data_len);
 
+	/* set up the connection params for the node */
+	cm_info.loc_addr = ntohl(laddr->sin_addr.s_addr);
+	cm_info.loc_port = ntohs(laddr->sin_port);
+	cm_info.rem_addr = ntohl(raddr->sin_addr.s_addr);
+	cm_info.rem_port = ntohs(raddr->sin_port);
+	cm_info.cm_id = cm_id;
+	cm_info.conn_type = NES_CM_IWARP_CONN_TYPE;
+
+	/* No port mapper available, go with the specified peer information */
+	cm_info.mapped_loc_addr = cm_info.loc_addr;
+	cm_info.mapped_loc_port = cm_info.loc_port;
+	cm_info.mapped_rem_addr = cm_info.rem_addr;
+	cm_info.mapped_rem_port = cm_info.rem_port;
+
+	nes_form_reg_msg(nesvnic, &pm_reg_msg);
+	iwpm_err = iwpm_register_pid(&pm_reg_msg, RDMA_NL_NES);
+	if (iwpm_err) {
+		nes_debug(NES_DBG_NLMSG,
+			"Port Mapper reg pid fail (err = %d).\n", iwpm_err);
+	}
+	if (iwpm_valid_pid() && !iwpm_err) {
+		nes_form_pm_msg(&cm_info, &pm_msg);
+		iwpm_err = iwpm_add_and_query_mapping(&pm_msg, RDMA_NL_NES);
+		if (iwpm_err)
+			nes_debug(NES_DBG_NLMSG,
+			"Port Mapper query fail (err = %d).\n", iwpm_err);
+		else
+			nes_record_pm_msg(&cm_info, &pm_msg);
+	}
+
 	if (laddr->sin_addr.s_addr != raddr->sin_addr.s_addr) {
-		nes_manage_apbvt(nesvnic, ntohs(laddr->sin_port),
-				 PCI_FUNC(nesdev->pcidev->devfn),
-				 NES_MANAGE_APBVT_ADD);
+		nes_manage_apbvt(nesvnic, cm_info.mapped_loc_port,
+			PCI_FUNC(nesdev->pcidev->devfn), NES_MANAGE_APBVT_ADD);
 		apbvt_set = 1;
 	}
 
-	/* set up the connection params for the node */
-	cm_info.loc_addr = htonl(laddr->sin_addr.s_addr);
-	cm_info.loc_port = htons(laddr->sin_port);
-	cm_info.rem_addr = htonl(raddr->sin_addr.s_addr);
-	cm_info.rem_port = htons(raddr->sin_port);
-	cm_info.cm_id = cm_id;
-	cm_info.conn_type = NES_CM_IWARP_CONN_TYPE;
+	if (nes_create_mapinfo(&cm_info))
+		return -ENOMEM;
 
 	cm_id->add_ref(cm_id);
 
@@ -3375,10 +3563,14 @@ int nes_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 					  &cm_info);
 	if (!cm_node) {
 		if (apbvt_set)
-			nes_manage_apbvt(nesvnic, ntohs(laddr->sin_port),
+			nes_manage_apbvt(nesvnic, cm_info.mapped_loc_port,
 					 PCI_FUNC(nesdev->pcidev->devfn),
 					 NES_MANAGE_APBVT_DEL);
 
+		nes_debug(NES_DBG_NLMSG, "Delete mapped_loc_port = %04X\n",
+				cm_info.mapped_loc_port);
+		nes_remove_mapinfo(cm_info.loc_addr, cm_info.loc_port,
+			cm_info.mapped_loc_addr, cm_info.mapped_loc_port);
 		cm_id->rem_ref(cm_id);
 		return -ENOMEM;
 	}
@@ -3424,13 +3616,16 @@ int nes_create_listen(struct iw_cm_id *cm_id, int backlog)
 			nesvnic->local_ipaddr, laddr->sin_addr.s_addr);
 
 	/* setup listen params in our api call struct */
-	cm_info.loc_addr = nesvnic->local_ipaddr;
-	cm_info.loc_port = laddr->sin_port;
+	cm_info.loc_addr = ntohl(nesvnic->local_ipaddr);
+	cm_info.loc_port = ntohs(laddr->sin_port);
 	cm_info.backlog = backlog;
 	cm_info.cm_id = cm_id;
 
 	cm_info.conn_type = NES_CM_IWARP_CONN_TYPE;
 
+	/* No port mapper available, go with the specified info */
+	cm_info.mapped_loc_addr = cm_info.loc_addr;
+	cm_info.mapped_loc_port = cm_info.loc_port;
 
 	cm_node = g_cm_core->api->listen(g_cm_core, nesvnic, &cm_info);
 	if (!cm_node) {
@@ -3442,7 +3637,10 @@ int nes_create_listen(struct iw_cm_id *cm_id, int backlog)
 	cm_id->provider_data = cm_node;
 
 	if (!cm_node->reused_node) {
-		err = nes_manage_apbvt(nesvnic, ntohs(laddr->sin_port),
+		if (nes_create_mapinfo(&cm_info))
+			return -ENOMEM;
+
+		err = nes_manage_apbvt(nesvnic, cm_node->mapped_loc_port,
 				       PCI_FUNC(nesvnic->nesdev->pcidev->devfn),
 				       NES_MANAGE_APBVT_ADD);
 		if (err) {
@@ -3567,9 +3765,11 @@ static void cm_event_connected(struct nes_cm_event *event)
 	nes_cm_init_tsa_conn(nesqp, cm_node);
 
 	/* set the QP tsa context */
-	nesqp->nesqp_context->tcpPorts[0] = cpu_to_le16(ntohs(laddr->sin_port));
-	nesqp->nesqp_context->tcpPorts[1] = cpu_to_le16(ntohs(raddr->sin_port));
-	nesqp->nesqp_context->ip0 = cpu_to_le32(ntohl(raddr->sin_addr.s_addr));
+	nesqp->nesqp_context->tcpPorts[0] =
+			cpu_to_le16(cm_node->mapped_loc_port);
+	nesqp->nesqp_context->tcpPorts[1] =
+			cpu_to_le16(cm_node->mapped_rem_port);
+	nesqp->nesqp_context->ip0 = cpu_to_le32(cm_node->mapped_rem_addr);
 
 	nesqp->nesqp_context->misc2 |= cpu_to_le32(
 			(u32)PCI_FUNC(nesdev->pcidev->devfn) <<
@@ -3599,9 +3799,9 @@ static void cm_event_connected(struct nes_cm_event *event)
 
 	nes_quad.DstIpAdrIndex =
 		cpu_to_le32((u32)PCI_FUNC(nesdev->pcidev->devfn) << 24);
-	nes_quad.SrcIpadr = raddr->sin_addr.s_addr;
-	nes_quad.TcpPorts[0] = raddr->sin_port;
-	nes_quad.TcpPorts[1] = laddr->sin_port;
+	nes_quad.SrcIpadr = htonl(cm_node->mapped_rem_addr);
+	nes_quad.TcpPorts[0] = htons(cm_node->mapped_rem_port);
+	nes_quad.TcpPorts[1] = htons(cm_node->mapped_loc_port);
 
 	/* Produce hash key */
 	crc_value = get_crc_value(&nes_quad);
@@ -3629,7 +3829,7 @@ static void cm_event_connected(struct nes_cm_event *event)
 	cm_event.ird = cm_node->ird_size;
 	cm_event.ord = cm_node->ord_size;
 
-	cm_event_laddr->sin_addr.s_addr = event->cm_info.rem_addr;
+	cm_event_laddr->sin_addr.s_addr = htonl(event->cm_info.rem_addr);
 	ret = cm_id->event_handler(cm_id, &cm_event);
 	nes_debug(NES_DBG_CM, "OFA CM event_handler returned, ret=%d\n", ret);
 
diff --git a/drivers/infiniband/hw/nes/nes_cm.h b/drivers/infiniband/hw/nes/nes_cm.h
index 522c99c..f522cf6 100644
--- a/drivers/infiniband/hw/nes/nes_cm.h
+++ b/drivers/infiniband/hw/nes/nes_cm.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006 - 2011 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2006 - 2014 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -293,8 +293,8 @@ struct nes_cm_listener {
 	struct list_head           list;
 	struct nes_cm_core         *cm_core;
 	u8                         loc_mac[ETH_ALEN];
-	nes_addr_t                 loc_addr;
-	u16                        loc_port;
+	nes_addr_t                 loc_addr, mapped_loc_addr;
+	u16                        loc_port, mapped_loc_port;
 	struct iw_cm_id            *cm_id;
 	enum nes_cm_conn_type      conn_type;
 	atomic_t                   ref_count;
@@ -308,7 +308,9 @@ struct nes_cm_listener {
 /* per connection node and node state information */
 struct nes_cm_node {
 	nes_addr_t                loc_addr, rem_addr;
+	nes_addr_t                mapped_loc_addr, mapped_rem_addr;
 	u16                       loc_port, rem_port;
+	u16                       mapped_loc_port, mapped_rem_port;
 
 	u8                        loc_mac[ETH_ALEN];
 	u8                        rem_mac[ETH_ALEN];
@@ -364,6 +366,10 @@ struct nes_cm_info {
 	u16 rem_port;
 	nes_addr_t loc_addr;
 	nes_addr_t rem_addr;
+	u16 mapped_loc_port;
+	u16 mapped_rem_port;
+	nes_addr_t mapped_loc_addr;
+	nes_addr_t mapped_rem_addr;
 
 	enum nes_cm_conn_type  conn_type;
 	int backlog;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
