From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 1/2] infiniband: nes: Remove duplicate function names
Date: Fri,  6 Feb 2015 01:09:04 +0100
Message-ID: <1423181345-18449-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Faisal Latif <faisal.latif@intel.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The macro nes_debug already ensures that __func__ (and __LINE__) is
part of the output, so there's no reason to duplicate the function
name in the format string itself.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/infiniband/hw/nes/nes.c       | 2 +-
 drivers/infiniband/hw/nes/nes_cm.c    | 8 ++++----
 drivers/infiniband/hw/nes/nes_verbs.c | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 3b2a6dc8ea99..65665bdd6c51 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -148,7 +148,7 @@ static int nes_inetaddr_event(struct notifier_block *notifier,
 	struct nes_vnic *nesvnic;
 	unsigned int is_bonded;
 
-	nes_debug(NES_DBG_NETDEV, "nes_inetaddr_event: ip address %pI4, netmask %pI4.\n",
+	nes_debug(NES_DBG_NETDEV, "ip address %pI4, netmask %pI4.\n",
 		  &ifa->ifa_address, &ifa->ifa_mask);
 	list_for_each_entry(nesdev, &nes_dev_list, list) {
 		nes_debug(NES_DBG_NETDEV, "Nesdev list entry = 0x%p. (%s)\n",
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 6f09a72e78d7..3a45f06d20e4 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -2270,7 +2270,7 @@ static void passive_open_err(struct nes_cm_node *cm_node, struct sk_buff *skb,
 	cleanup_retrans_entry(cm_node);
 	cm_node->state = NES_CM_STATE_CLOSED;
 	if (reset) {
-		nes_debug(NES_DBG_CM, "passive_open_err sending RST for "
+		nes_debug(NES_DBG_CM, "sending RST for "
 			  "cm_node=%p state =%d\n", cm_node, cm_node->state);
 		send_reset(cm_node, skb);
 	} else {
@@ -2319,7 +2319,7 @@ static void process_packet(struct nes_cm_node *cm_node, struct sk_buff *skb,
 
 	skb_pull(skb, ip_hdr(skb)->ihl << 2);
 
-	nes_debug(NES_DBG_CM, "process_packet: cm_node=%p state =%d syn=%d "
+	nes_debug(NES_DBG_CM, "cm_node=%p state =%d syn=%d "
 		  "ack=%d rst=%d fin=%d\n", cm_node, cm_node->state, tcph->syn,
 		  tcph->ack, tcph->rst, tcph->fin);
 
@@ -3218,7 +3218,7 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	adapter = nesdev->nesadapter;
 
 	cm_node = (struct nes_cm_node *)cm_id->provider_data;
-	nes_debug(NES_DBG_CM, "nes_accept: cm_node= %p nesvnic=%p, netdev=%p,"
+	nes_debug(NES_DBG_CM, "cm_node= %p nesvnic=%p, netdev=%p,"
 		"%s\n", cm_node, nesvnic, nesvnic->netdev,
 		nesvnic->netdev->name);
 
@@ -3745,7 +3745,7 @@ static void cm_event_connected(struct nes_cm_event *event)
 	/* get all our handles */
 	cm_node = event->cm_node;
 	cm_id = cm_node->cm_id;
-	nes_debug(NES_DBG_CM, "cm_event_connected - %p - cm_id = %p\n", cm_node, cm_id);
+	nes_debug(NES_DBG_CM, "%p - cm_id = %p\n", cm_node, cm_id);
 	nesqp = (struct nes_qp *)cm_id->provider_data;
 	nesvnic = to_nesvnic(nesqp->ibqp.device);
 	nesdev = nesvnic->nesdev;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index c0d0296e7a00..a8d73188c276 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -300,7 +300,7 @@ static int alloc_fast_reg_mr(struct nes_device *nesdev, struct nes_pd *nespd,
 		nes_debug(NES_DBG_MR, "Failed to get a cqp_request.\n");
 		return -ENOMEM;
 	}
-	nes_debug(NES_DBG_MR, "alloc_fast_reg_mr: page_count = %d, "
+	nes_debug(NES_DBG_MR, "page_count = %d, "
 			      "region_length = %llu\n",
 			      page_count, region_length);
 	cqp_request->waiting = 1;
-- 
2.1.3
