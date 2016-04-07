From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RDMA PATCH 14/16] i40iw: Fix endian issues and warnings
Date: Thu,  7 Apr 2016 11:31:02 -0500
Message-ID: <1460046664-552-15-git-send-email-mustafa.ismail@intel.com>
References: <1460046664-552-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460046664-552-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix endian warnings and errors due to u32 stored to u16.

Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw.h       |  4 +--
 drivers/infiniband/hw/i40iw/i40iw_cm.c    | 57 ++++++++++++++++---------------
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c  | 10 +++---
 drivers/infiniband/hw/i40iw/i40iw_hw.c    |  4 +--
 drivers/infiniband/hw/i40iw/i40iw_main.c  |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_puda.c  |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_type.h  |  4 +--
 drivers/infiniband/hw/i40iw/i40iw_utils.c | 27 +++++++--------
 8 files changed, 54 insertions(+), 56 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw.h b/drivers/infiniband/hw/i40iw/i40iw.h
index f299001..8b95320 100644
--- a/drivers/infiniband/hw/i40iw/i40iw.h
+++ b/drivers/infiniband/hw/i40iw/i40iw.h
@@ -391,7 +391,7 @@ void i40iw_flush_wqes(struct i40iw_device *iwdev,
 
 void i40iw_manage_arp_cache(struct i40iw_device *iwdev,
 			    unsigned char *mac_addr,
-			    __be32 *ip_addr,
+			    u32 *ip_addr,
 			    bool ipv4,
 			    u32 action);
 
@@ -549,7 +549,7 @@ enum i40iw_status_code i40iw_hw_flush_wqes(struct i40iw_device *iwdev,
 					   struct i40iw_qp_flush_info *info,
 					   bool wait);
 
-void i40iw_copy_ip_ntohl(u32 *dst, u32 *src);
+void i40iw_copy_ip_ntohl(u32 *dst, __be32 *src);
 struct ib_mr *i40iw_reg_phys_mr(struct ib_pd *ib_pd,
 				u64 addr,
 				u64 size,
diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index ab6eb0b..8cb4b87 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -771,6 +771,7 @@ static void i40iw_build_mpa_v2(struct i40iw_cm_node *cm_node,
 {
 	struct ietf_mpa_v2 *mpa_frame = (struct ietf_mpa_v2 *)start_addr;
 	struct ietf_rtr_msg *rtr_msg = &mpa_frame->rtr_msg;
+	u16 ctrl_ird, ctrl_ord;
 
 	/* initialize the upper 5 bytes of the frame */
 	i40iw_build_mpa_v1(cm_node, start_addr, mpa_key);
@@ -779,38 +780,38 @@ static void i40iw_build_mpa_v2(struct i40iw_cm_node *cm_node,
 
 	/* initialize RTR msg */
 	if (cm_node->mpav2_ird_ord == IETF_NO_IRD_ORD) {
-		rtr_msg->ctrl_ird = IETF_NO_IRD_ORD;
-		rtr_msg->ctrl_ord = IETF_NO_IRD_ORD;
+		ctrl_ird = IETF_NO_IRD_ORD;
+		ctrl_ord = IETF_NO_IRD_ORD;
 	} else {
-		rtr_msg->ctrl_ird = (cm_node->ird_size > IETF_NO_IRD_ORD) ?
+		ctrl_ird = (cm_node->ird_size > IETF_NO_IRD_ORD) ?
 			IETF_NO_IRD_ORD : cm_node->ird_size;
-		rtr_msg->ctrl_ord = (cm_node->ord_size > IETF_NO_IRD_ORD) ?
+		ctrl_ord = (cm_node->ord_size > IETF_NO_IRD_ORD) ?
 			IETF_NO_IRD_ORD : cm_node->ord_size;
 	}
 
-	rtr_msg->ctrl_ird |= IETF_PEER_TO_PEER;
-	rtr_msg->ctrl_ird |= IETF_FLPDU_ZERO_LEN;
+	ctrl_ird |= IETF_PEER_TO_PEER;
+	ctrl_ird |= IETF_FLPDU_ZERO_LEN;
 
 	switch (mpa_key) {
 	case MPA_KEY_REQUEST:
-		rtr_msg->ctrl_ord |= IETF_RDMA0_WRITE;
-		rtr_msg->ctrl_ord |= IETF_RDMA0_READ;
+		ctrl_ord |= IETF_RDMA0_WRITE;
+		ctrl_ord |= IETF_RDMA0_READ;
 		break;
 	case MPA_KEY_REPLY:
 		switch (cm_node->send_rdma0_op) {
 		case SEND_RDMA_WRITE_ZERO:
-			rtr_msg->ctrl_ord |= IETF_RDMA0_WRITE;
+			ctrl_ord |= IETF_RDMA0_WRITE;
 			break;
 		case SEND_RDMA_READ_ZERO:
-			rtr_msg->ctrl_ord |= IETF_RDMA0_READ;
+			ctrl_ord |= IETF_RDMA0_READ;
 			break;
 		}
 		break;
 	default:
 		break;
 	}
-	rtr_msg->ctrl_ird = htons(rtr_msg->ctrl_ird);
-	rtr_msg->ctrl_ord = htons(rtr_msg->ctrl_ord);
+	rtr_msg->ctrl_ird = htons(ctrl_ird);
+	rtr_msg->ctrl_ord = htons(ctrl_ord);
 }
 
 /**
@@ -2160,7 +2161,7 @@ static struct i40iw_cm_node *i40iw_make_cm_node(
 	cm_node->tcp_cntxt.rcv_wnd =
 			I40IW_CM_DEFAULT_RCV_WND_SCALED >> I40IW_CM_DEFAULT_RCV_WND_SCALE;
 	ts = current_kernel_time();
-	cm_node->tcp_cntxt.loc_seq_num = htonl(ts.tv_nsec);
+	cm_node->tcp_cntxt.loc_seq_num = ts.tv_nsec;
 	cm_node->tcp_cntxt.mss = iwdev->mss;
 
 	cm_node->iwdev = iwdev;
@@ -2234,7 +2235,7 @@ static void i40iw_rem_ref_cm_node(struct i40iw_cm_node *cm_node)
 	if (cm_node->listener) {
 		i40iw_dec_refcnt_listen(cm_core, cm_node->listener, 0, true);
 	} else {
-		if (!i40iw_listen_port_in_use(cm_core, htons(cm_node->loc_port)) &&
+		if (!i40iw_listen_port_in_use(cm_core, cm_node->loc_port) &&
 		    cm_node->apbvt_set && cm_node->iwdev) {
 			i40iw_manage_apbvt(cm_node->iwdev,
 					   cm_node->loc_port,
@@ -2921,7 +2922,6 @@ static struct i40iw_cm_node *i40iw_create_cm_node(
 	memcpy(cm_node->pdata_buf, private_data, private_data_len);
 
 	cm_node->state = I40IW_CM_STATE_SYN_SENT;
-
 	return cm_node;
 }
 
@@ -3242,11 +3242,13 @@ static void i40iw_init_tcp_ctx(struct i40iw_cm_node *cm_node,
 
 		tcp_info->dest_ip_addr3 = cpu_to_le32(cm_node->rem_addr[0]);
 		tcp_info->local_ipaddr3 = cpu_to_le32(cm_node->loc_addr[0]);
-		tcp_info->arp_idx = cpu_to_le32(i40iw_arp_table(iwqp->iwdev,
-								&tcp_info->dest_ip_addr3,
-								true,
-								NULL,
-								I40IW_ARP_RESOLVE));
+		tcp_info->arp_idx =
+			cpu_to_le16((u16)i40iw_arp_table(
+							 iwqp->iwdev,
+							 &tcp_info->dest_ip_addr3,
+							 true,
+							 NULL,
+							 I40IW_ARP_RESOLVE));
 	} else {
 		tcp_info->src_port = cpu_to_le16(cm_node->loc_port);
 		tcp_info->dst_port = cpu_to_le16(cm_node->rem_port);
@@ -3258,12 +3260,13 @@ static void i40iw_init_tcp_ctx(struct i40iw_cm_node *cm_node,
 		tcp_info->local_ipaddr1 = cpu_to_le32(cm_node->loc_addr[1]);
 		tcp_info->local_ipaddr2 = cpu_to_le32(cm_node->loc_addr[2]);
 		tcp_info->local_ipaddr3 = cpu_to_le32(cm_node->loc_addr[3]);
-		tcp_info->arp_idx = cpu_to_le32(i40iw_arp_table(
-							iwqp->iwdev,
-							&tcp_info->dest_ip_addr0,
-							false,
-							NULL,
-							I40IW_ARP_RESOLVE));
+		tcp_info->arp_idx =
+			cpu_to_le16((u16)i40iw_arp_table(
+							 iwqp->iwdev,
+							 &tcp_info->dest_ip_addr0,
+							 false,
+							 NULL,
+							 I40IW_ARP_RESOLVE));
 	}
 }
 
@@ -3540,7 +3543,6 @@ int i40iw_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	struct i40iw_cm_node *cm_node;
 	struct ib_qp_attr attr;
 	int passive_state;
-	struct i40iw_ib_device *iwibdev;
 	struct ib_mr *ibmr;
 	struct i40iw_pd *iwpd;
 	u16 buf_len = 0;
@@ -3603,7 +3605,6 @@ int i40iw_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	     !i40iw_ipv4_is_loopback(cm_node->loc_addr[0], cm_node->rem_addr[0])) ||
 	    (!cm_node->ipv4 &&
 	     !i40iw_ipv6_is_loopback(cm_node->loc_addr, cm_node->rem_addr))) {
-		iwibdev = iwdev->iwibdev;
 		iwpd = iwqp->iwpd;
 		tagged_offset = (uintptr_t)iwqp->ietf_mem.va;
 		ibmr = i40iw_reg_phys_mr(&iwpd->ibpd,
diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index 6e5a73b..83cae7d 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -3970,11 +3970,11 @@ enum i40iw_status_code i40iw_process_bh(struct i40iw_sc_dev *dev)
  */
 static u32 i40iw_iwarp_opcode(struct i40iw_aeqe_info *info, u8 *pkt)
 {
-	u16 *mpa;
+	__be16 *mpa;
 	u32 opcode = 0xffffffff;
 
 	if (info->q2_data_written) {
-		mpa = (u16 *)pkt;
+		mpa = (__be16 *)pkt;
 		opcode = ntohs(mpa[1]) & 0xf;
 	}
 	return opcode;
@@ -4036,7 +4036,7 @@ static int i40iw_bld_terminate_hdr(struct i40iw_sc_qp *qp,
 	if (info->q2_data_written) {
 		/* Use data from offending packet to fill in ddp & rdma hdrs */
 		pkt = i40iw_locate_mpa(pkt);
-		ddp_seg_len = ntohs(*(u16 *)pkt);
+		ddp_seg_len = ntohs(*(__be16 *)pkt);
 		if (ddp_seg_len) {
 			copy_len = 2;
 			termhdr->hdrct = DDP_LEN_FLAG;
@@ -4247,13 +4247,13 @@ void i40iw_terminate_connection(struct i40iw_sc_qp *qp, struct i40iw_aeqe_info *
 void i40iw_terminate_received(struct i40iw_sc_qp *qp, struct i40iw_aeqe_info *info)
 {
 	u8 *pkt = qp->q2_buf + Q2_BAD_FRAME_OFFSET;
-	u32 *mpa;
+	__be32 *mpa;
 	u8 ddp_ctl;
 	u8 rdma_ctl;
 	u16 aeq_id = 0;
 	struct i40iw_terminate_hdr *termhdr;
 
-	mpa = (u32 *)i40iw_locate_mpa(pkt);
+	mpa = (__be32 *)i40iw_locate_mpa(pkt);
 	if (info->q2_data_written) {
 		/* did not validate the frame - do it now */
 		ddp_ctl = (ntohl(mpa[0]) >> 8) & 0xff;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_hw.c b/drivers/infiniband/hw/i40iw/i40iw_hw.c
index 27cfdd8..615e115 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_hw.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_hw.c
@@ -467,7 +467,7 @@ int i40iw_manage_apbvt(struct i40iw_device *iwdev, u16 accel_local_port, bool ad
  */
 void i40iw_manage_arp_cache(struct i40iw_device *iwdev,
 			    unsigned char *mac_addr,
-			    __be32 *ip_addr,
+			    u32 *ip_addr,
 			    bool ipv4,
 			    u32 action)
 {
@@ -488,7 +488,7 @@ void i40iw_manage_arp_cache(struct i40iw_device *iwdev,
 		cqp_info->cqp_cmd = OP_ADD_ARP_CACHE_ENTRY;
 		info = &cqp_info->in.u.add_arp_cache_entry.info;
 		memset(info, 0, sizeof(*info));
-		info->arp_index = cpu_to_le32(arp_index);
+		info->arp_index = cpu_to_le16((u16)arp_index);
 		info->permanent = true;
 		ether_addr_copy(info->mac_addr, mac_addr);
 		cqp_info->in.u.add_arp_cache_entry.scratch = (uintptr_t)cqp_request;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index e7b7724..72a10a1 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -1162,7 +1162,7 @@ static void i40iw_add_ipv6_addr(struct i40iw_device *iwdev)
 	struct net_device *ip_dev;
 	struct inet6_dev *idev;
 	struct inet6_ifaddr *ifp;
-	__be32 local_ipaddr6[4];
+	u32 local_ipaddr6[4];
 
 	rcu_read_lock();
 	for_each_netdev_rcu(&init_net, ip_dev) {
diff --git a/drivers/infiniband/hw/i40iw/i40iw_puda.c b/drivers/infiniband/hw/i40iw/i40iw_puda.c
index 8eb400d8..e9c6e82 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_puda.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_puda.c
@@ -1194,7 +1194,7 @@ static enum i40iw_status_code i40iw_ieq_process_buf(struct i40iw_puda_rsrc *ieq,
 
 	ioffset = (u16)(buf->data - (u8 *)buf->mem.va);
 	while (datalen) {
-		fpdu_len = i40iw_ieq_get_fpdu_length(ntohs(*(u16 *)datap));
+		fpdu_len = i40iw_ieq_get_fpdu_length(ntohs(*(__be16 *)datap));
 		if (fpdu_len > pfpdu->max_fpdu_data) {
 			i40iw_debug(ieq->dev, I40IW_DEBUG_IEQ,
 				    "%s: error bad fpdu_len\n", __func__);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_type.h b/drivers/infiniband/hw/i40iw/i40iw_type.h
index c926198..e8c9491 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_type.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_type.h
@@ -890,8 +890,8 @@ struct i40iw_qhash_table_info {
 	u32 qp_num;
 	u32 dest_ip[4];
 	u32 src_ip[4];
-	u32 dest_port;
-	u32 src_port;
+	u16 dest_port;
+	u16 src_port;
 };
 
 struct i40iw_local_mac_ipaddr_entry_info {
diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniband/hw/i40iw/i40iw_utils.c
index cddd639..0e8db0a 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
@@ -59,7 +59,7 @@
  * @action: modify, delete or add
  */
 int i40iw_arp_table(struct i40iw_device *iwdev,
-		    __be32 *ip_addr,
+		    u32 *ip_addr,
 		    bool ipv4,
 		    u8 *mac_addr,
 		    u32 action)
@@ -152,7 +152,7 @@ int i40iw_inetaddr_event(struct notifier_block *notifier,
 	struct net_device *upper_dev;
 	struct i40iw_device *iwdev;
 	struct i40iw_handler *hdl;
-	__be32 local_ipaddr;
+	u32 local_ipaddr;
 
 	hdl = i40iw_find_netdev(event_netdev);
 	if (!hdl)
@@ -167,11 +167,10 @@ int i40iw_inetaddr_event(struct notifier_block *notifier,
 	switch (event) {
 	case NETDEV_DOWN:
 		if (upper_dev)
-			local_ipaddr =
-				((struct in_device *)upper_dev->ip_ptr)->ifa_list->ifa_address;
+			local_ipaddr = ntohl(
+				((struct in_device *)upper_dev->ip_ptr)->ifa_list->ifa_address);
 		else
-			local_ipaddr = ifa->ifa_address;
-		local_ipaddr = ntohl(local_ipaddr);
+			local_ipaddr = ntohl(ifa->ifa_address);
 		i40iw_manage_arp_cache(iwdev,
 				       netdev->dev_addr,
 				       &local_ipaddr,
@@ -180,11 +179,10 @@ int i40iw_inetaddr_event(struct notifier_block *notifier,
 		return NOTIFY_OK;
 	case NETDEV_UP:
 		if (upper_dev)
-			local_ipaddr =
-				((struct in_device *)upper_dev->ip_ptr)->ifa_list->ifa_address;
+			local_ipaddr = ntohl(
+				((struct in_device *)upper_dev->ip_ptr)->ifa_list->ifa_address);
 		else
-			local_ipaddr = ifa->ifa_address;
-		local_ipaddr = ntohl(local_ipaddr);
+			local_ipaddr = ntohl(ifa->ifa_address);
 		i40iw_manage_arp_cache(iwdev,
 				       netdev->dev_addr,
 				       &local_ipaddr,
@@ -194,12 +192,11 @@ int i40iw_inetaddr_event(struct notifier_block *notifier,
 	case NETDEV_CHANGEADDR:
 		/* Add the address to the IP table */
 		if (upper_dev)
-			local_ipaddr =
-				((struct in_device *)upper_dev->ip_ptr)->ifa_list->ifa_address;
+			local_ipaddr = ntohl(
+				((struct in_device *)upper_dev->ip_ptr)->ifa_list->ifa_address);
 		else
-			local_ipaddr = ifa->ifa_address;
+			local_ipaddr = ntohl(ifa->ifa_address);
 
-		local_ipaddr = ntohl(local_ipaddr);
 		i40iw_manage_arp_cache(iwdev,
 				       netdev->dev_addr,
 				       &local_ipaddr,
@@ -227,7 +224,7 @@ int i40iw_inet6addr_event(struct notifier_block *notifier,
 	struct net_device *netdev;
 	struct i40iw_device *iwdev;
 	struct i40iw_handler *hdl;
-	__be32 local_ipaddr6[4];
+	u32 local_ipaddr6[4];
 
 	hdl = i40iw_find_netdev(event_netdev);
 	if (!hdl)
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
