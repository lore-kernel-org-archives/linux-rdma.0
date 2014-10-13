From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] RDMA/nes: Report the actual address of the remote
 connecting peer
Date: Mon, 13 Oct 2014 15:42:41 -0500
Message-ID: <20141013204241.GA10700@TENIKOLO-MOBL2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Get the actual (non-mapped) ip/tcp address of the remote connecting peer
from the port mapper and report the address info to the user space application
at the time of connection establishment

Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes.c    |    1 +
 drivers/infiniband/hw/nes/nes_cm.c |   65 ++++++++++++++++++++++++++---------
 2 files changed, 49 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 3b2a6dc..9f9d5c5 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -116,6 +116,7 @@ static struct ibnl_client_cbs nes_nl_cb_table[] = {
 	[RDMA_NL_IWPM_REG_PID] = {.dump = iwpm_register_pid_cb},
 	[RDMA_NL_IWPM_ADD_MAPPING] = {.dump = iwpm_add_mapping_cb},
 	[RDMA_NL_IWPM_QUERY_MAPPING] = {.dump = iwpm_add_and_query_mapping_cb},
+	[RDMA_NL_IWPM_REMOTE_INFO] = {.dump = iwpm_remote_info_cb},
 	[RDMA_NL_IWPM_HANDLE_ERR] = {.dump = iwpm_mapping_error_cb},
 	[RDMA_NL_IWPM_MAPINFO] = {.dump = iwpm_mapping_info_cb},
 	[RDMA_NL_IWPM_MAPINFO_NUM] = {.dump = iwpm_ack_mapping_info_cb}
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 6f09a72..785c2fa 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -596,27 +596,52 @@ static void nes_form_reg_msg(struct nes_vnic *nesvnic,
 	memcpy(pm_msg->if_name, nesvnic->netdev->name, IWPM_IFNAME_SIZE);
 }
 
+static void record_sockaddr_info(struct sockaddr_storage *addr_info,
+					nes_addr_t *ip_addr, u16 *port_num)
+{
+	struct sockaddr_in *in_addr = (struct sockaddr_in *)addr_info;
+
+	if (in_addr->sin_family == AF_INET) {
+		*ip_addr = ntohl(in_addr->sin_addr.s_addr);
+		*port_num = ntohs(in_addr->sin_port);
+	}
+}
+
 /*
  * nes_record_pm_msg - Save the received mapping info
  */
 static void nes_record_pm_msg(struct nes_cm_info *cm_info,
 			struct iwpm_sa_data *pm_msg)
 {
-	struct sockaddr_in *mapped_loc_addr =
-			(struct sockaddr_in *)&pm_msg->mapped_loc_addr;
-	struct sockaddr_in *mapped_rem_addr =
-			(struct sockaddr_in *)&pm_msg->mapped_rem_addr;
-
-	if (mapped_loc_addr->sin_family == AF_INET) {
-		cm_info->mapped_loc_addr =
-			ntohl(mapped_loc_addr->sin_addr.s_addr);
-		cm_info->mapped_loc_port = ntohs(mapped_loc_addr->sin_port);
-	}
-	if (mapped_rem_addr->sin_family == AF_INET) {
-		cm_info->mapped_rem_addr =
-			ntohl(mapped_rem_addr->sin_addr.s_addr);
-		cm_info->mapped_rem_port = ntohs(mapped_rem_addr->sin_port);
-	}
+	record_sockaddr_info(&pm_msg->mapped_loc_addr,
+		&cm_info->mapped_loc_addr, &cm_info->mapped_loc_port);
+
+	record_sockaddr_info(&pm_msg->mapped_rem_addr,
+		&cm_info->mapped_rem_addr, &cm_info->mapped_rem_port);
+}
+
+/*
+ * nes_get_reminfo - Get the address info of the remote connecting peer
+ */
+static int nes_get_remote_addr(struct nes_cm_node *cm_node)
+{
+	struct sockaddr_storage mapped_loc_addr, mapped_rem_addr;
+	struct sockaddr_storage remote_addr;
+	int ret;
+
+	nes_create_sockaddr(htonl(cm_node->mapped_loc_addr),
+			htons(cm_node->mapped_loc_port), &mapped_loc_addr);
+	nes_create_sockaddr(htonl(cm_node->mapped_rem_addr),
+			htons(cm_node->mapped_rem_port), &mapped_rem_addr);
+
+	ret = iwpm_get_remote_info(&mapped_loc_addr, &mapped_rem_addr,
+				&remote_addr, RDMA_NL_NES);
+	if (ret)
+		nes_debug(NES_DBG_CM, "Unable to find remote peer address info\n");
+	else
+		record_sockaddr_info(&remote_addr, &cm_node->rem_addr,
+				&cm_node->rem_port);
+	return ret;
 }
 
 /**
@@ -1566,9 +1591,14 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
 		return NULL;
 
 	/* set our node specific transport info */
-	cm_node->loc_addr = cm_info->loc_addr;
+	if (listener) {
+		cm_node->loc_addr = listener->loc_addr;
+		cm_node->loc_port = listener->loc_port;
+	} else {
+		cm_node->loc_addr = cm_info->loc_addr;
+		cm_node->loc_port = cm_info->loc_port;
+	}
 	cm_node->rem_addr = cm_info->rem_addr;
-	cm_node->loc_port = cm_info->loc_port;
 	cm_node->rem_port = cm_info->rem_port;
 
 	cm_node->mapped_loc_addr = cm_info->mapped_loc_addr;
@@ -2151,6 +2181,7 @@ static int handle_ack_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
 		cm_node->state = NES_CM_STATE_ESTABLISHED;
 		if (datasize) {
 			cm_node->tcp_cntxt.rcv_nxt = inc_sequence + datasize;
+			nes_get_remote_addr(cm_node);
 			handle_rcv_mpa(cm_node, skb);
 		} else { /* rcvd ACK only */
 			dev_kfree_skb_any(skb);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
