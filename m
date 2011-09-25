From: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 4/4] RDMA/nes: Adds support for MPA frame Version 2
Date: Sun, 25 Sep 2011 20:17:46 +0530
Message-ID: <1316962066-28701-5-git-send-email-kumaras@chelsio.com>
References: <1316962066-28701-1-git-send-email-kumaras@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1316962066-28701-1-git-send-email-kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Tatyana <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

MPA V2 changes are based on a IETF STORM Draft, which will update RFC5043 and RFC5044.
MPA V2 extends the configuration negotiation for RDMA connection establishment.
For backwards compatibility, MPA V2 enabled driver reverts to MPA V1,
if the remote node doesn't support MPA V2

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif<Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c    | 1101 +++++++++++++++++++--------------
 drivers/infiniband/hw/nes/nes_cm.h    |   73 ++-
 drivers/infiniband/hw/nes/nes_verbs.h |    3 +-
 3 files changed, 703 insertions(+), 474 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index c118663..0bfb588 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -77,26 +77,19 @@ atomic_t cm_nodes_destroyed;
 atomic_t cm_accel_dropped_pkts;
 atomic_t cm_resets_recvd;
 
-static inline int mini_cm_accelerated(struct nes_cm_core *,
-	struct nes_cm_node *);
-static struct nes_cm_listener *mini_cm_listen(struct nes_cm_core *,
-	struct nes_vnic *, struct nes_cm_info *);
+static inline int mini_cm_accelerated(struct nes_cm_core *, struct nes_cm_node *);
+static struct nes_cm_listener *mini_cm_listen(struct nes_cm_core *, struct nes_vnic *, struct nes_cm_info *);
 static int mini_cm_del_listen(struct nes_cm_core *, struct nes_cm_listener *);
-static struct nes_cm_node *mini_cm_connect(struct nes_cm_core *,
-	struct nes_vnic *, u16, void *, struct nes_cm_info *);
+static struct nes_cm_node *mini_cm_connect(struct nes_cm_core *, struct nes_vnic *, u16, void *, struct nes_cm_info *);
 static int mini_cm_close(struct nes_cm_core *, struct nes_cm_node *);
-static int mini_cm_accept(struct nes_cm_core *, struct ietf_mpa_frame *,
-	struct nes_cm_node *);
-static int mini_cm_reject(struct nes_cm_core *, struct ietf_mpa_frame *,
-	struct nes_cm_node *);
-static int mini_cm_recv_pkt(struct nes_cm_core *, struct nes_vnic *,
-	struct sk_buff *);
+static int mini_cm_accept(struct nes_cm_core *, struct nes_cm_node *);
+static int mini_cm_reject(struct nes_cm_core *, struct nes_cm_node *);
+static int mini_cm_recv_pkt(struct nes_cm_core *, struct nes_vnic *, struct sk_buff *);
 static int mini_cm_dealloc_core(struct nes_cm_core *);
 static int mini_cm_get(struct nes_cm_core *);
 static int mini_cm_set(struct nes_cm_core *, u32, u32);
 
-static void form_cm_frame(struct sk_buff *, struct nes_cm_node *,
-	void *, u32, void *, u32, u8);
+static void form_cm_frame(struct sk_buff *, struct nes_cm_node *, void *, u32, void *, u32, u8);
 static int add_ref_cm_node(struct nes_cm_node *);
 static int rem_ref_cm_node(struct nes_cm_core *, struct nes_cm_node *);
 
@@ -111,16 +104,14 @@ static int send_syn(struct nes_cm_node *, u32, struct sk_buff *);
 static int send_reset(struct nes_cm_node *, struct sk_buff *);
 static int send_ack(struct nes_cm_node *cm_node, struct sk_buff *skb);
 static int send_fin(struct nes_cm_node *cm_node, struct sk_buff *skb);
-static void process_packet(struct nes_cm_node *, struct sk_buff *,
-	struct nes_cm_core *);
+static void process_packet(struct nes_cm_node *, struct sk_buff *, struct nes_cm_core *);
 
 static void active_open_err(struct nes_cm_node *, struct sk_buff *, int);
 static void passive_open_err(struct nes_cm_node *, struct sk_buff *, int);
 static void cleanup_retrans_entry(struct nes_cm_node *);
 static void handle_rcv_mpa(struct nes_cm_node *, struct sk_buff *);
 static void free_retrans_entry(struct nes_cm_node *cm_node);
-static int handle_tcp_options(struct nes_cm_node *cm_node, struct tcphdr *tcph,
-	struct sk_buff *skb, int optionsize, int passive);
+static int handle_tcp_options(struct nes_cm_node *cm_node, struct tcphdr *tcph, struct sk_buff *skb, int optionsize, int passive);
 
 /* CM event handler functions */
 static void cm_event_connected(struct nes_cm_event *);
@@ -130,6 +121,12 @@ static void cm_event_mpa_req(struct nes_cm_event *);
 static void cm_event_mpa_reject(struct nes_cm_event *);
 static void handle_recv_entry(struct nes_cm_node *cm_node, u32 rem_node);
 
+/* MPA build functions */
+static int cm_build_mpa_frame(struct nes_cm_node *, u8 **, u16 *, u8 *, u8);
+static void build_mpa_v2(struct nes_cm_node *, void *, u8);
+static void build_mpa_v1(struct nes_cm_node *, void *, u8);
+static void build_rdma0_msg(struct nes_cm_node *, struct nes_qp **);
+
 static void print_core(struct nes_cm_core *core);
 
 /* External CM API Interface */
@@ -163,8 +160,8 @@ atomic_t cm_rejects;
 /**
  * create_event
  */
-static struct nes_cm_event *create_event(struct nes_cm_node *cm_node,
-		enum nes_cm_event_type type)
+static struct nes_cm_event *create_event(struct nes_cm_node *	cm_node,
+					 enum nes_cm_event_type type)
 {
 	struct nes_cm_event *event;
 
@@ -186,10 +183,10 @@ static struct nes_cm_event *create_event(struct nes_cm_node *cm_node,
 	event->cm_info.cm_id = cm_node->cm_id;
 
 	nes_debug(NES_DBG_CM, "cm_node=%p Created event=%p, type=%u, "
-		"dst_addr=%08x[%x], src_addr=%08x[%x]\n",
-		cm_node, event, type, event->cm_info.loc_addr,
-		event->cm_info.loc_port, event->cm_info.rem_addr,
-		event->cm_info.rem_port);
+		  "dst_addr=%08x[%x], src_addr=%08x[%x]\n",
+		  cm_node, event, type, event->cm_info.loc_addr,
+		  event->cm_info.loc_port, event->cm_info.rem_addr,
+		  event->cm_info.rem_port);
 
 	nes_cm_post_event(event);
 	return event;
@@ -201,14 +198,19 @@ static struct nes_cm_event *create_event(struct nes_cm_node *cm_node,
  */
 static int send_mpa_request(struct nes_cm_node *cm_node, struct sk_buff *skb)
 {
+	u8 start_addr = 0;
+	u8 *start_ptr = &start_addr;
+	u8 **start_buff = &start_ptr;
+	u16 buff_len = 0;
+
 	if (!skb) {
 		nes_debug(NES_DBG_CM, "skb set to NULL\n");
 		return -1;
 	}
 
 	/* send an MPA Request frame */
-	form_cm_frame(skb, cm_node, NULL, 0, &cm_node->mpa_frame,
-			cm_node->mpa_frame_size, SET_ACK);
+	cm_build_mpa_frame(cm_node, start_buff, &buff_len, NULL, MPA_KEY_REQUEST);
+	form_cm_frame(skb, cm_node, NULL, 0, *start_buff, buff_len, SET_ACK);
 
 	return schedule_nes_timer(cm_node, skb, NES_TIMER_TYPE_SEND, 1, 0);
 }
@@ -217,7 +219,11 @@ static int send_mpa_request(struct nes_cm_node *cm_node, struct sk_buff *skb)
 
 static int send_mpa_reject(struct nes_cm_node *cm_node)
 {
-	struct sk_buff  *skb = NULL;
+	struct sk_buff *skb = NULL;
+	u8 start_addr = 0;
+	u8 *start_ptr = &start_addr;
+	u8 **start_buff = &start_ptr;
+	u16 buff_len = 0;
 
 	skb = dev_alloc_skb(MAX_CM_BUFFER);
 	if (!skb) {
@@ -226,8 +232,8 @@ static int send_mpa_reject(struct nes_cm_node *cm_node)
 	}
 
 	/* send an MPA reject frame */
-	form_cm_frame(skb, cm_node, NULL, 0, &cm_node->mpa_frame,
-			cm_node->mpa_frame_size, SET_ACK | SET_FIN);
+	cm_build_mpa_frame(cm_node, start_buff, &buff_len, NULL, MPA_KEY_REPLY);
+	form_cm_frame(skb, cm_node, NULL, 0, *start_buff, buff_len, SET_ACK | SET_FIN);
 
 	cm_node->state = NES_CM_STATE_FIN_WAIT1;
 	return schedule_nes_timer(cm_node, skb, NES_TIMER_TYPE_SEND, 1, 0);
@@ -239,24 +245,31 @@ static int send_mpa_reject(struct nes_cm_node *cm_node)
  * IETF MPA frame
  */
 static int parse_mpa(struct nes_cm_node *cm_node, u8 *buffer, u32 *type,
-		u32 len)
+		     u32 len)
 {
-	struct ietf_mpa_frame *mpa_frame;
+	struct ietf_mpa_v1 *mpa_frame;
+	struct ietf_mpa_v2 *mpa_v2_frame;
+	struct ietf_rtr_msg *rtr_msg;
+	int mpa_hdr_len;
+	int priv_data_len;
 
 	*type = NES_MPA_REQUEST_ACCEPT;
 
 	/* assume req frame is in tcp data payload */
-	if (len < sizeof(struct ietf_mpa_frame)) {
+	if (len < sizeof(struct ietf_mpa_v1)) {
 		nes_debug(NES_DBG_CM, "The received ietf buffer was too small (%x)\n", len);
 		return -EINVAL;
 	}
 
-	mpa_frame = (struct ietf_mpa_frame *)buffer;
-	cm_node->mpa_frame_size = ntohs(mpa_frame->priv_data_len);
+	/* points to the beginning of the frame, which could be MPA V1 or V2 */
+	mpa_frame = (struct ietf_mpa_v1 *)buffer;
+	mpa_hdr_len = sizeof(struct ietf_mpa_v1);
+	priv_data_len = ntohs(mpa_frame->priv_data_len);
+
 	/* make sure mpa private data len is less than 512 bytes */
-	if (cm_node->mpa_frame_size > IETF_MAX_PRIV_DATA_LEN) {
+	if (priv_data_len > IETF_MAX_PRIV_DATA_LEN) {
 		nes_debug(NES_DBG_CM, "The received Length of Private"
-			" Data field exceeds 512 octets\n");
+			  " Data field exceeds 512 octets\n");
 		return -EINVAL;
 	}
 	/*
@@ -264,11 +277,22 @@ static int parse_mpa(struct nes_cm_node *cm_node, u8 *buffer, u32 *type,
 	 * received MPA version and MPA key information
 	 *
 	 */
-	if (mpa_frame->rev != mpa_version) {
+	if (mpa_frame->rev != IETF_MPA_V1 && mpa_frame->rev != IETF_MPA_V2) {
+		nes_debug(NES_DBG_CM, "The received mpa version"
+			  " is not supported\n");
+		return -EINVAL;
+	}
+	/*
+	* backwards compatibility only
+	*/
+	if (mpa_frame->rev > cm_node->mpa_frame_rev) {
 		nes_debug(NES_DBG_CM, "The received mpa version"
-				" can not be interoperated\n");
+			" can not be interoperated\n");
 		return -EINVAL;
+	} else {
+		cm_node->mpa_frame_rev = mpa_frame->rev;
 	}
+
 	if (cm_node->state != NES_CM_STATE_MPAREQ_SENT) {
 		if (memcmp(mpa_frame->key, IEFT_MPA_KEY_REQ, IETF_MPA_KEY_SIZE)) {
 			nes_debug(NES_DBG_CM, "Unexpected MPA Key received \n");
@@ -281,25 +305,75 @@ static int parse_mpa(struct nes_cm_node *cm_node, u8 *buffer, u32 *type,
 		}
 	}
 
-	if (cm_node->mpa_frame_size + sizeof(struct ietf_mpa_frame) != len) {
+
+	if (priv_data_len + mpa_hdr_len != len) {
 		nes_debug(NES_DBG_CM, "The received ietf buffer was not right"
-				" complete (%x + %x != %x)\n",
-				cm_node->mpa_frame_size,
-				(u32)sizeof(struct ietf_mpa_frame), len);
+			" complete (%x + %x != %x)\n",
+			priv_data_len, mpa_hdr_len, len);
 		return -EINVAL;
 	}
 	/* make sure it does not exceed the max size */
 	if (len > MAX_CM_BUFFER) {
 		nes_debug(NES_DBG_CM, "The received ietf buffer was too large"
-				" (%x + %x != %x)\n",
-				cm_node->mpa_frame_size,
-				(u32)sizeof(struct ietf_mpa_frame), len);
+			" (%x + %x != %x)\n",
+			priv_data_len, mpa_hdr_len, len);
 		return -EINVAL;
 	}
 
+	cm_node->mpa_frame_size = priv_data_len;
+
+	switch (mpa_frame->rev) {
+	case IETF_MPA_V2: {
+		u16 ird_size;
+		u16 ord_size;
+		mpa_v2_frame = (struct ietf_mpa_v2 *)buffer;
+		mpa_hdr_len += IETF_RTR_MSG_SIZE;
+		cm_node->mpa_frame_size -= IETF_RTR_MSG_SIZE;
+		rtr_msg = &mpa_v2_frame->rtr_msg;
+
+		/* parse rtr message */
+		rtr_msg->ctrl_ird = ntohs(rtr_msg->ctrl_ird);
+		rtr_msg->ctrl_ord = ntohs(rtr_msg->ctrl_ord);
+		ird_size = rtr_msg->ctrl_ird & IETF_NO_IRD_ORD;
+		ord_size = rtr_msg->ctrl_ord & IETF_NO_IRD_ORD;
+
+		if (!(rtr_msg->ctrl_ird & IETF_PEER_TO_PEER)) {
+			/* send reset */
+			return -EINVAL;
+		}
+
+		if (cm_node->state != NES_CM_STATE_MPAREQ_SENT) {
+			/* responder */
+			if (cm_node->ord_size > ird_size)
+				cm_node->ord_size = ird_size;
+		} else {
+			/* initiator */
+			if (cm_node->ord_size > ird_size)
+				cm_node->ord_size = ird_size;
+
+			if (cm_node->ird_size < ord_size) {
+				/* no resources available */
+				/* send terminate message */
+				return -EINVAL;
+			}
+		}
+
+		if (rtr_msg->ctrl_ord & IETF_RDMA0_READ) {
+			cm_node->send_rdma0_op = SEND_RDMA_READ_ZERO;
+		} else if (rtr_msg->ctrl_ord & IETF_RDMA0_WRITE) {
+			cm_node->send_rdma0_op = SEND_RDMA_WRITE_ZERO;
+		} else {        /* Not supported RDMA0 operation */
+			return -EINVAL;
+		}
+		break;
+	}
+	case IETF_MPA_V1:
+	default:
+		break;
+	}
+
 	/* copy entire MPA frame to our cm_node's frame */
-	memcpy(cm_node->mpa_frame_buf, buffer + sizeof(struct ietf_mpa_frame),
-			cm_node->mpa_frame_size);
+	memcpy(cm_node->mpa_frame_buf, buffer + mpa_hdr_len, cm_node->mpa_frame_size);
 
 	if (mpa_frame->flags & IETF_MPA_FLAGS_REJECT)
 		*type = NES_MPA_REQUEST_REJECT;
@@ -312,8 +386,8 @@ static int parse_mpa(struct nes_cm_node *cm_node, u8 *buffer, u32 *type,
  * node info to build.
  */
 static void form_cm_frame(struct sk_buff *skb,
-	struct nes_cm_node *cm_node, void *options, u32 optionsize,
-	void *data, u32 datasize, u8 flags)
+			  struct nes_cm_node *cm_node, void *options, u32 optionsize,
+			  void *data, u32 datasize, u8 flags)
 {
 	struct tcphdr *tcph;
 	struct iphdr *iph;
@@ -322,14 +396,14 @@ static void form_cm_frame(struct sk_buff *skb,
 	u16 packetsize = sizeof(*iph);
 
 	packetsize += sizeof(*tcph);
-	packetsize +=  optionsize + datasize;
+	packetsize += optionsize + datasize;
 
+	skb_trim(skb, 0);
 	memset(skb->data, 0x00, ETH_HLEN + sizeof(*iph) + sizeof(*tcph));
 
-	skb->len = 0;
 	buf = skb_put(skb, packetsize + ETH_HLEN);
 
-	ethh = (struct ethhdr *) buf;
+	ethh = (struct ethhdr *)buf;
 	buf += ETH_HLEN;
 
 	iph = (struct iphdr *)buf;
@@ -337,7 +411,7 @@ static void form_cm_frame(struct sk_buff *skb,
 	tcph = (struct tcphdr *)buf;
 	skb_reset_mac_header(skb);
 	skb_set_network_header(skb, ETH_HLEN);
-	skb_set_transport_header(skb, ETH_HLEN+sizeof(*iph));
+	skb_set_transport_header(skb, ETH_HLEN + sizeof(*iph));
 	buf += sizeof(*tcph);
 
 	skb->ip_summed = CHECKSUM_PARTIAL;
@@ -350,14 +424,14 @@ static void form_cm_frame(struct sk_buff *skb,
 	ethh->h_proto = htons(0x0800);
 
 	iph->version = IPVERSION;
-	iph->ihl = 5;		/* 5 * 4Byte words, IP headr len */
+	iph->ihl = 5;           /* 5 * 4Byte words, IP headr len */
 	iph->tos = 0;
 	iph->tot_len = htons(packetsize);
 	iph->id = htons(++cm_node->tcp_cntxt.loc_id);
 
 	iph->frag_off = htons(0x4000);
 	iph->ttl = 0x40;
-	iph->protocol = 0x06;	/* IPPROTO_TCP */
+	iph->protocol = 0x06;   /* IPPROTO_TCP */
 
 	iph->saddr = htonl(cm_node->loc_addr);
 	iph->daddr = htonl(cm_node->rem_addr);
@@ -370,14 +444,16 @@ static void form_cm_frame(struct sk_buff *skb,
 		cm_node->tcp_cntxt.loc_ack_num = cm_node->tcp_cntxt.rcv_nxt;
 		tcph->ack_seq = htonl(cm_node->tcp_cntxt.loc_ack_num);
 		tcph->ack = 1;
-	} else
+	} else {
 		tcph->ack_seq = 0;
+	}
 
 	if (flags & SET_SYN) {
 		cm_node->tcp_cntxt.loc_seq_num++;
 		tcph->syn = 1;
-	} else
+	} else {
 		cm_node->tcp_cntxt.loc_seq_num += datasize;
+	}
 
 	if (flags & SET_FIN) {
 		cm_node->tcp_cntxt.loc_seq_num++;
@@ -398,10 +474,8 @@ static void form_cm_frame(struct sk_buff *skb,
 
 	skb_shinfo(skb)->nr_frags = 0;
 	cm_packets_created++;
-
 }
 
-
 /**
  * print_core - dump a cm core
  */
@@ -413,7 +487,7 @@ static void print_core(struct nes_cm_core *core)
 		return;
 	nes_debug(NES_DBG_CM, "---------------------------------------------\n");
 
-	nes_debug(NES_DBG_CM, "State         : %u \n",  core->state);
+	nes_debug(NES_DBG_CM, "State         : %u \n", core->state);
 
 	nes_debug(NES_DBG_CM, "Listen Nodes  : %u \n", atomic_read(&core->listen_node_cnt));
 	nes_debug(NES_DBG_CM, "Active Nodes  : %u \n", atomic_read(&core->node_cnt));
@@ -423,6 +497,147 @@ static void print_core(struct nes_cm_core *core)
 	nes_debug(NES_DBG_CM, "-------------- end core ---------------\n");
 }
 
+/**
+ * cm_build_mpa_frame - build a MPA V1 frame or MPA V2 frame
+ */
+static int cm_build_mpa_frame(struct nes_cm_node *cm_node, u8 **start_buff,
+			      u16 *buff_len, u8 *pci_mem, u8 mpa_key)
+{
+	int ret = 0;
+
+	*start_buff = (pci_mem) ? pci_mem : &cm_node->mpa_frame_buf[0];
+
+	switch (cm_node->mpa_frame_rev) {
+	case IETF_MPA_V1:
+		*start_buff = (u8 *)*start_buff + sizeof(struct ietf_rtr_msg);
+		*buff_len = sizeof(struct ietf_mpa_v1) + cm_node->mpa_frame_size;
+		build_mpa_v1(cm_node, *start_buff, mpa_key);
+		break;
+	case IETF_MPA_V2:
+		*buff_len = sizeof(struct ietf_mpa_v2) + cm_node->mpa_frame_size;
+		build_mpa_v2(cm_node, *start_buff, mpa_key);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+/**
+ * build_mpa_v2 - build a MPA V2 frame
+ */
+static void build_mpa_v2(struct nes_cm_node *cm_node,
+			 void *start_addr, u8 mpa_key)
+{
+	struct ietf_mpa_v2 *mpa_frame = (struct ietf_mpa_v2 *)start_addr;
+	struct ietf_rtr_msg *rtr_msg = &mpa_frame->rtr_msg;
+
+	/* initialize the upper 5 bytes of the frame */
+	build_mpa_v1(cm_node, start_addr, mpa_key);
+	mpa_frame->flags |= IETF_MPA_V2_FLAG; /* set a bit to indicate MPA V2 */
+	mpa_frame->priv_data_len += htons(IETF_RTR_MSG_SIZE);
+
+	/* initialize RTR msg */
+	rtr_msg->ctrl_ird = (cm_node->ird_size > IETF_NO_IRD_ORD) ?
+			    IETF_NO_IRD_ORD : cm_node->ird_size;
+	rtr_msg->ctrl_ord = (cm_node->ord_size > IETF_NO_IRD_ORD) ?
+			    IETF_NO_IRD_ORD : cm_node->ord_size;
+
+	rtr_msg->ctrl_ird |= IETF_PEER_TO_PEER;
+	rtr_msg->ctrl_ird |= IETF_FLPDU_ZERO_LEN;
+
+	switch (mpa_key) {
+	case MPA_KEY_REQUEST:
+		rtr_msg->ctrl_ord |= IETF_RDMA0_WRITE;
+		rtr_msg->ctrl_ord |= IETF_RDMA0_READ;
+		break;
+	case MPA_KEY_REPLY:
+		switch (cm_node->send_rdma0_op) {
+		case SEND_RDMA_WRITE_ZERO:
+			rtr_msg->ctrl_ord |= IETF_RDMA0_WRITE;
+			break;
+		case SEND_RDMA_READ_ZERO:
+			rtr_msg->ctrl_ord |= IETF_RDMA0_READ;
+			break;
+		}
+	}
+	rtr_msg->ctrl_ird = htons(rtr_msg->ctrl_ird);
+	rtr_msg->ctrl_ord = htons(rtr_msg->ctrl_ord);
+}
+
+/**
+ * build_mpa_v1 - build a MPA V1 frame
+ */
+static void build_mpa_v1(struct nes_cm_node *cm_node, void *start_addr, u8 mpa_key)
+{
+	struct ietf_mpa_v1 *mpa_frame = (struct ietf_mpa_v1 *)start_addr;
+
+	switch (mpa_key) {
+	case MPA_KEY_REQUEST:
+		memcpy(mpa_frame->key, IEFT_MPA_KEY_REQ, IETF_MPA_KEY_SIZE);
+		break;
+	case MPA_KEY_REPLY:
+		memcpy(mpa_frame->key, IEFT_MPA_KEY_REP, IETF_MPA_KEY_SIZE);
+		break;
+	}
+	mpa_frame->flags = IETF_MPA_FLAGS_CRC;
+	mpa_frame->rev = cm_node->mpa_frame_rev;
+	mpa_frame->priv_data_len = htons(cm_node->mpa_frame_size);
+}
+
+static void build_rdma0_msg(struct nes_cm_node *cm_node, struct nes_qp **nesqp_addr)
+{
+	u64 u64temp;
+	struct nes_qp *nesqp = *nesqp_addr;
+	struct nes_hw_qp_wqe *wqe = &nesqp->hwqp.sq_vbase[0];
+
+	u64temp = (unsigned long)nesqp;
+	u64temp |= NES_SW_CONTEXT_ALIGN >> 1;
+	set_wqe_64bit_value(wqe->wqe_words, NES_IWARP_SQ_WQE_COMP_CTX_LOW_IDX, u64temp);
+
+	wqe->wqe_words[NES_IWARP_SQ_WQE_FRAG0_LOW_IDX] = 0;
+	wqe->wqe_words[NES_IWARP_SQ_WQE_FRAG0_HIGH_IDX] = 0;
+
+	switch (cm_node->send_rdma0_op) {
+	case SEND_RDMA_WRITE_ZERO:
+		nes_debug(NES_DBG_CM, "Sending first write.\n");
+		wqe->wqe_words[NES_IWARP_SQ_WQE_MISC_IDX] =
+			cpu_to_le32(NES_IWARP_SQ_OP_RDMAW);
+		wqe->wqe_words[NES_IWARP_SQ_WQE_TOTAL_PAYLOAD_IDX] = 0;
+		wqe->wqe_words[NES_IWARP_SQ_WQE_LENGTH0_IDX] = 0;
+		wqe->wqe_words[NES_IWARP_SQ_WQE_STAG0_IDX] = 0;
+		break;
+
+	case SEND_RDMA_READ_ZERO:
+	default:
+		if (cm_node->send_rdma0_op != SEND_RDMA_READ_ZERO) {
+			printk(KERN_ERR "%s[%u]: Unsupported RDMA0 len operation=%u\n",
+				 __func__, __LINE__, cm_node->send_rdma0_op);
+			WARN_ON(1);
+		}
+		nes_debug(NES_DBG_CM, "Sending first rdma operation.\n");
+		wqe->wqe_words[NES_IWARP_SQ_WQE_MISC_IDX] =
+			cpu_to_le32(NES_IWARP_SQ_OP_RDMAR);
+		wqe->wqe_words[NES_IWARP_SQ_WQE_RDMA_TO_LOW_IDX] = 1;
+		wqe->wqe_words[NES_IWARP_SQ_WQE_RDMA_TO_HIGH_IDX] = 0;
+		wqe->wqe_words[NES_IWARP_SQ_WQE_RDMA_LENGTH_IDX] = 0;
+		wqe->wqe_words[NES_IWARP_SQ_WQE_RDMA_STAG_IDX] = 1;
+		wqe->wqe_words[NES_IWARP_SQ_WQE_STAG0_IDX] = 1;
+		break;
+	}
+
+	if (nesqp->sq_kmapped) {
+		nesqp->sq_kmapped = 0;
+		kunmap(nesqp->page);
+	}
+
+	/*use the reserved spot on the WQ for the extra first WQE*/
+	nesqp->nesqp_context->ird_ord_sizes &= cpu_to_le32(~(NES_QPCONTEXT_ORDIRD_LSMM_PRESENT |
+							     NES_QPCONTEXT_ORDIRD_WRPDU |
+							     NES_QPCONTEXT_ORDIRD_ALSMM));
+	nesqp->skip_lsmm = 1;
+	nesqp->hwqp.sq_tail = 0;
+}
 
 /**
  * schedule_nes_timer
@@ -430,10 +645,10 @@ static void print_core(struct nes_cm_core *core)
  *			rem_ref_cm_node(cm_core, cm_node);add_ref_cm_node(cm_node);
  */
 int schedule_nes_timer(struct nes_cm_node *cm_node, struct sk_buff *skb,
-		enum nes_timer_type type, int send_retrans,
-		int close_when_complete)
+		       enum nes_timer_type type, int send_retrans,
+		       int close_when_complete)
 {
-	unsigned long  flags;
+	unsigned long flags;
 	struct nes_cm_core *cm_core = cm_node->cm_core;
 	struct nes_timer_entry *new_send;
 	int ret = 0;
@@ -454,7 +669,7 @@ int schedule_nes_timer(struct nes_cm_node *cm_node, struct sk_buff *skb,
 	new_send->close_when_complete = close_when_complete;
 
 	if (type == NES_TIMER_TYPE_CLOSE) {
-		new_send->timetosend += (HZ/10);
+		new_send->timetosend += (HZ / 10);
 		if (cm_node->recv_entry) {
 			kfree(new_send);
 			WARN_ON(1);
@@ -475,7 +690,7 @@ int schedule_nes_timer(struct nes_cm_node *cm_node, struct sk_buff *skb,
 		ret = nes_nic_cm_xmit(new_send->skb, cm_node->netdev);
 		if (ret != NETDEV_TX_OK) {
 			nes_debug(NES_DBG_CM, "Error sending packet %p "
-				"(jiffies = %lu)\n", new_send, jiffies);
+				  "(jiffies = %lu)\n", new_send, jiffies);
 			new_send->timetosend = jiffies;
 			ret = NETDEV_TX_OK;
 		} else {
@@ -504,6 +719,7 @@ static void nes_retrans_expired(struct nes_cm_node *cm_node)
 	struct iw_cm_id *cm_id = cm_node->cm_id;
 	enum nes_cm_node_state state = cm_node->state;
 	cm_node->state = NES_CM_STATE_CLOSED;
+
 	switch (state) {
 	case NES_CM_STATE_SYN_RCVD:
 	case NES_CM_STATE_CLOSING:
@@ -536,10 +752,10 @@ static void handle_recv_entry(struct nes_cm_node *cm_node, u32 rem_node)
 		spin_lock_irqsave(&nesqp->lock, qplockflags);
 		if (nesqp->cm_id) {
 			nes_debug(NES_DBG_CM, "QP%u: cm_id = %p, "
-				"refcount = %d: HIT A "
-				"NES_TIMER_TYPE_CLOSE with something "
-				"to do!!!\n", nesqp->hwqp.qp_id, cm_id,
-				atomic_read(&nesqp->refcount));
+				  "refcount = %d: HIT A "
+				  "NES_TIMER_TYPE_CLOSE with something "
+				  "to do!!!\n", nesqp->hwqp.qp_id, cm_id,
+				  atomic_read(&nesqp->refcount));
 			nesqp->hw_tcp_state = NES_AEQE_TCP_STATE_CLOSED;
 			nesqp->last_aeq = NES_AEQE_AEID_RESET_SENT;
 			nesqp->ibqp_state = IB_QPS_ERR;
@@ -548,10 +764,10 @@ static void handle_recv_entry(struct nes_cm_node *cm_node, u32 rem_node)
 		} else {
 			spin_unlock_irqrestore(&nesqp->lock, qplockflags);
 			nes_debug(NES_DBG_CM, "QP%u: cm_id = %p, "
-				"refcount = %d: HIT A "
-				"NES_TIMER_TYPE_CLOSE with nothing "
-				"to do!!!\n", nesqp->hwqp.qp_id, cm_id,
-				atomic_read(&nesqp->refcount));
+				  "refcount = %d: HIT A "
+				  "NES_TIMER_TYPE_CLOSE with nothing "
+				  "to do!!!\n", nesqp->hwqp.qp_id, cm_id,
+				  atomic_read(&nesqp->refcount));
 		}
 	} else if (rem_node) {
 		/* TIME_WAIT state */
@@ -580,11 +796,12 @@ static void nes_cm_timer_tick(unsigned long pass)
 	int ret = NETDEV_TX_OK;
 
 	struct list_head timer_list;
+
 	INIT_LIST_HEAD(&timer_list);
 	spin_lock_irqsave(&cm_core->ht_lock, flags);
 
 	list_for_each_safe(list_node, list_core_temp,
-				&cm_core->connected_nodes) {
+			   &cm_core->connected_nodes) {
 		cm_node = container_of(list_node, struct nes_cm_node, list);
 		if ((cm_node->recv_entry) || (cm_node->send_entry)) {
 			add_ref_cm_node(cm_node);
@@ -595,18 +812,19 @@ static void nes_cm_timer_tick(unsigned long pass)
 
 	list_for_each_safe(list_node, list_core_temp, &timer_list) {
 		cm_node = container_of(list_node, struct nes_cm_node,
-					timer_entry);
+				       timer_entry);
 		recv_entry = cm_node->recv_entry;
 
 		if (recv_entry) {
 			if (time_after(recv_entry->timetosend, jiffies)) {
 				if (nexttimeout > recv_entry->timetosend ||
-						!settimer) {
+				    !settimer) {
 					nexttimeout = recv_entry->timetosend;
 					settimer = 1;
 				}
-			} else
+			} else {
 				handle_recv_entry(cm_node, 1);
+			}
 		}
 
 		spin_lock_irqsave(&cm_node->retrans_list_lock, flags);
@@ -617,8 +835,8 @@ static void nes_cm_timer_tick(unsigned long pass)
 			if (time_after(send_entry->timetosend, jiffies)) {
 				if (cm_node->state != NES_CM_STATE_TSA) {
 					if ((nexttimeout >
-						send_entry->timetosend) ||
-						!settimer) {
+					     send_entry->timetosend) ||
+					    !settimer) {
 						nexttimeout =
 							send_entry->timetosend;
 						settimer = 1;
@@ -630,13 +848,13 @@ static void nes_cm_timer_tick(unsigned long pass)
 			}
 
 			if ((cm_node->state == NES_CM_STATE_TSA) ||
-				(cm_node->state == NES_CM_STATE_CLOSED)) {
+			    (cm_node->state == NES_CM_STATE_CLOSED)) {
 				free_retrans_entry(cm_node);
 				break;
 			}
 
 			if (!send_entry->retranscount ||
-				!send_entry->retrycount) {
+			    !send_entry->retrycount) {
 				cm_packets_dropped++;
 				free_retrans_entry(cm_node);
 
@@ -645,28 +863,28 @@ static void nes_cm_timer_tick(unsigned long pass)
 				nes_retrans_expired(cm_node);
 				cm_node->state = NES_CM_STATE_CLOSED;
 				spin_lock_irqsave(&cm_node->retrans_list_lock,
-					flags);
+						  flags);
 				break;
 			}
 			atomic_inc(&send_entry->skb->users);
 			cm_packets_retrans++;
 			nes_debug(NES_DBG_CM, "Retransmitting send_entry %p "
-				"for node %p, jiffies = %lu, time to send = "
-				"%lu, retranscount = %u, send_entry->seq_num = "
-				"0x%08X, cm_node->tcp_cntxt.rem_ack_num = "
-				"0x%08X\n", send_entry, cm_node, jiffies,
-				send_entry->timetosend,
-				send_entry->retranscount,
-				send_entry->seq_num,
-				cm_node->tcp_cntxt.rem_ack_num);
+				  "for node %p, jiffies = %lu, time to send = "
+				  "%lu, retranscount = %u, send_entry->seq_num = "
+				  "0x%08X, cm_node->tcp_cntxt.rem_ack_num = "
+				  "0x%08X\n", send_entry, cm_node, jiffies,
+				  send_entry->timetosend,
+				  send_entry->retranscount,
+				  send_entry->seq_num,
+				  cm_node->tcp_cntxt.rem_ack_num);
 
 			spin_unlock_irqrestore(&cm_node->retrans_list_lock,
-				flags);
+					       flags);
 			ret = nes_nic_cm_xmit(send_entry->skb, cm_node->netdev);
 			spin_lock_irqsave(&cm_node->retrans_list_lock, flags);
 			if (ret != NETDEV_TX_OK) {
 				nes_debug(NES_DBG_CM, "rexmit failed for "
-					"node=%p\n", cm_node);
+					  "node=%p\n", cm_node);
 				cm_packets_bounced++;
 				send_entry->retrycount--;
 				nexttimeout = jiffies + NES_SHORT_TIME;
@@ -676,18 +894,18 @@ static void nes_cm_timer_tick(unsigned long pass)
 				cm_packets_sent++;
 			}
 			nes_debug(NES_DBG_CM, "Packet Sent: retrans count = "
-				"%u, retry count = %u.\n",
-				send_entry->retranscount,
-				send_entry->retrycount);
+				  "%u, retry count = %u.\n",
+				  send_entry->retranscount,
+				  send_entry->retrycount);
 			if (send_entry->send_retrans) {
 				send_entry->retranscount--;
 				timetosend = (NES_RETRY_TIMEOUT <<
-					(NES_DEFAULT_RETRANS - send_entry->retranscount));
+					      (NES_DEFAULT_RETRANS - send_entry->retranscount));
 
 				send_entry->timetosend = jiffies +
-					min(timetosend, NES_MAX_TIMEOUT);
+							 min(timetosend, NES_MAX_TIMEOUT);
 				if (nexttimeout > send_entry->timetosend ||
-					!settimer) {
+				    !settimer) {
 					nexttimeout = send_entry->timetosend;
 					settimer = 1;
 				}
@@ -696,11 +914,11 @@ static void nes_cm_timer_tick(unsigned long pass)
 				close_when_complete =
 					send_entry->close_when_complete;
 				nes_debug(NES_DBG_CM, "cm_node=%p state=%d\n",
-					cm_node, cm_node->state);
+					  cm_node, cm_node->state);
 				free_retrans_entry(cm_node);
 				if (close_when_complete)
 					rem_ref_cm_node(cm_node->cm_core,
-						cm_node);
+							cm_node);
 			}
 		} while (0);
 
@@ -710,7 +928,7 @@ static void nes_cm_timer_tick(unsigned long pass)
 
 	if (settimer) {
 		if (!timer_pending(&cm_core->tcp_timer)) {
-			cm_core->tcp_timer.expires  = nexttimeout;
+			cm_core->tcp_timer.expires = nexttimeout;
 			add_timer(&cm_core->tcp_timer);
 		}
 	}
@@ -721,13 +939,13 @@ static void nes_cm_timer_tick(unsigned long pass)
  * send_syn
  */
 static int send_syn(struct nes_cm_node *cm_node, u32 sendack,
-	struct sk_buff *skb)
+		    struct sk_buff *skb)
 {
 	int ret;
 	int flags = SET_SYN;
 	char optionsbuffer[sizeof(struct option_mss) +
-		sizeof(struct option_windowscale) + sizeof(struct option_base) +
-		TCP_OPTIONS_PADDING];
+			   sizeof(struct option_windowscale) + sizeof(struct option_base) +
+			   TCP_OPTIONS_PADDING];
 
 	int optionssize = 0;
 	/* Sending MSS option */
@@ -854,7 +1072,7 @@ static int send_fin(struct nes_cm_node *cm_node, struct sk_buff *skb)
  * find_node - find a cm node that matches the reference cm node
  */
 static struct nes_cm_node *find_node(struct nes_cm_core *cm_core,
-		u16 rem_port, nes_addr_t rem_addr, u16 loc_port, nes_addr_t loc_addr)
+				     u16 rem_port, nes_addr_t rem_addr, u16 loc_port, nes_addr_t loc_addr)
 {
 	unsigned long flags;
 	struct list_head *hte;
@@ -868,12 +1086,12 @@ static struct nes_cm_node *find_node(struct nes_cm_core *cm_core,
 	list_for_each_entry(cm_node, hte, list) {
 		/* compare quad, return node handle if a match */
 		nes_debug(NES_DBG_CM, "finding node %x:%x =? %x:%x ^ %x:%x =? %x:%x\n",
-				cm_node->loc_addr, cm_node->loc_port,
-				loc_addr, loc_port,
-				cm_node->rem_addr, cm_node->rem_port,
-				rem_addr, rem_port);
+			  cm_node->loc_addr, cm_node->loc_port,
+			  loc_addr, loc_port,
+			  cm_node->rem_addr, cm_node->rem_port,
+			  rem_addr, rem_port);
 		if ((cm_node->loc_addr == loc_addr) && (cm_node->loc_port == loc_port) &&
-				(cm_node->rem_addr == rem_addr) && (cm_node->rem_port == rem_port)) {
+		    (cm_node->rem_addr == rem_addr) && (cm_node->rem_port == rem_port)) {
 			add_ref_cm_node(cm_node);
 			spin_unlock_irqrestore(&cm_core->ht_lock, flags);
 			return cm_node;
@@ -890,7 +1108,7 @@ static struct nes_cm_node *find_node(struct nes_cm_core *cm_core,
  * find_listener - find a cm node listening on this addr-port pair
  */
 static struct nes_cm_listener *find_listener(struct nes_cm_core *cm_core,
-		nes_addr_t dst_addr, u16 dst_port, enum nes_cm_listener_state listener_state)
+					     nes_addr_t dst_addr, u16 dst_port, enum nes_cm_listener_state listener_state)
 {
 	unsigned long flags;
 	struct nes_cm_listener *listen_node;
@@ -900,9 +1118,9 @@ static struct nes_cm_listener *find_listener(struct nes_cm_core *cm_core,
 	list_for_each_entry(listen_node, &cm_core->listen_list.list, list) {
 		/* compare node pair, return node handle if a match */
 		if (((listen_node->loc_addr == dst_addr) ||
-				listen_node->loc_addr == 0x00000000) &&
-				(listen_node->loc_port == dst_port) &&
-				(listener_state & listen_node->listener_state)) {
+		     listen_node->loc_addr == 0x00000000) &&
+		    (listen_node->loc_port == dst_port) &&
+		    (listener_state & listen_node->listener_state)) {
 			atomic_inc(&listen_node->ref_count);
 			spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
 			return listen_node;
@@ -927,7 +1145,7 @@ static int add_hte_node(struct nes_cm_core *cm_core, struct nes_cm_node *cm_node
 		return -EINVAL;
 
 	nes_debug(NES_DBG_CM, "Adding Node %p to Active Connection HT\n",
-		cm_node);
+		  cm_node);
 
 	spin_lock_irqsave(&cm_core->ht_lock, flags);
 
@@ -946,7 +1164,7 @@ static int add_hte_node(struct nes_cm_core *cm_core, struct nes_cm_node *cm_node
  * mini_cm_dec_refcnt_listen
  */
 static int mini_cm_dec_refcnt_listen(struct nes_cm_core *cm_core,
-	struct nes_cm_listener *listener, int free_hanging_nodes)
+				     struct nes_cm_listener *listener, int free_hanging_nodes)
 {
 	int ret = -EINVAL;
 	int err = 0;
@@ -957,8 +1175,8 @@ static int mini_cm_dec_refcnt_listen(struct nes_cm_core *cm_core,
 	struct list_head reset_list;
 
 	nes_debug(NES_DBG_CM, "attempting listener= %p free_nodes= %d, "
-		"refcnt=%d\n", listener, free_hanging_nodes,
-		atomic_read(&listener->ref_count));
+		  "refcnt=%d\n", listener, free_hanging_nodes,
+		  atomic_read(&listener->ref_count));
 	/* free non-accelerated child nodes for this listener */
 	INIT_LIST_HEAD(&reset_list);
 	if (free_hanging_nodes) {
@@ -966,7 +1184,7 @@ static int mini_cm_dec_refcnt_listen(struct nes_cm_core *cm_core,
 		list_for_each_safe(list_pos, list_temp,
 				   &g_cm_core->connected_nodes) {
 			cm_node = container_of(list_pos, struct nes_cm_node,
-				list);
+					       list);
 			if ((cm_node->listener == listener) &&
 			    (!cm_node->accelerated)) {
 				add_ref_cm_node(cm_node);
@@ -978,7 +1196,7 @@ static int mini_cm_dec_refcnt_listen(struct nes_cm_core *cm_core,
 
 	list_for_each_safe(list_pos, list_temp, &reset_list) {
 		cm_node = container_of(list_pos, struct nes_cm_node,
-				reset_entry);
+				       reset_entry);
 		{
 			struct nes_cm_node *loopback = cm_node->loopbackpartner;
 			enum nes_cm_node_state old_state;
@@ -990,7 +1208,7 @@ static int mini_cm_dec_refcnt_listen(struct nes_cm_core *cm_core,
 					err = send_reset(cm_node, NULL);
 					if (err) {
 						cm_node->state =
-							 NES_CM_STATE_CLOSED;
+							NES_CM_STATE_CLOSED;
 						WARN_ON(1);
 					} else {
 						old_state = cm_node->state;
@@ -1035,10 +1253,9 @@ static int mini_cm_dec_refcnt_listen(struct nes_cm_core *cm_core,
 
 		spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
 
-		if (listener->nesvnic) {
+		if (listener->nesvnic)
 			nes_manage_apbvt(listener->nesvnic, listener->loc_port,
-					PCI_FUNC(listener->nesvnic->nesdev->pcidev->devfn), NES_MANAGE_APBVT_DEL);
-		}
+					 PCI_FUNC(listener->nesvnic->nesdev->pcidev->devfn), NES_MANAGE_APBVT_DEL);
 
 		nes_debug(NES_DBG_CM, "destroying listener (%p)\n", listener);
 
@@ -1052,8 +1269,8 @@ static int mini_cm_dec_refcnt_listen(struct nes_cm_core *cm_core,
 	if (listener) {
 		if (atomic_read(&listener->pend_accepts_cnt) > 0)
 			nes_debug(NES_DBG_CM, "destroying listener (%p)"
-					" with non-zero pending accepts=%u\n",
-					listener, atomic_read(&listener->pend_accepts_cnt));
+				  " with non-zero pending accepts=%u\n",
+				  listener, atomic_read(&listener->pend_accepts_cnt));
 	}
 
 	return ret;
@@ -1064,7 +1281,7 @@ static int mini_cm_dec_refcnt_listen(struct nes_cm_core *cm_core,
  * mini_cm_del_listen
  */
 static int mini_cm_del_listen(struct nes_cm_core *cm_core,
-		struct nes_cm_listener *listener)
+			      struct nes_cm_listener *listener)
 {
 	listener->listener_state = NES_CM_LISTENER_PASSIVE_STATE;
 	listener->cm_id = NULL; /* going to be destroyed pretty soon */
@@ -1076,9 +1293,10 @@ static int mini_cm_del_listen(struct nes_cm_core *cm_core,
  * mini_cm_accelerated
  */
 static inline int mini_cm_accelerated(struct nes_cm_core *cm_core,
-		struct nes_cm_node *cm_node)
+				      struct nes_cm_node *cm_node)
 {
 	u32 was_timer_set;
+
 	cm_node->accelerated = 1;
 
 	if (cm_node->accept_pend) {
@@ -1112,7 +1330,7 @@ static int nes_addr_resolve_neigh(struct nes_vnic *nesvnic, u32 dst_ip, int arpi
 	rt = ip_route_output(&init_net, htonl(dst_ip), 0, 0, 0);
 	if (IS_ERR(rt)) {
 		printk(KERN_ERR "%s: ip_route_output_key failed for 0x%08X\n",
-				__func__, dst_ip);
+		       __func__, dst_ip);
 		return rc;
 	}
 
@@ -1130,7 +1348,7 @@ static int nes_addr_resolve_neigh(struct nes_vnic *nesvnic, u32 dst_ip, int arpi
 
 			if (arpindex >= 0) {
 				if (!memcmp(nesadapter->arp_table[arpindex].mac_addr,
-							neigh->ha, ETH_ALEN)){
+					    neigh->ha, ETH_ALEN)) {
 					/* Mac address same as in nes_arp_table */
 					neigh_release(neigh);
 					ip_rt_put(rt);
@@ -1138,8 +1356,8 @@ static int nes_addr_resolve_neigh(struct nes_vnic *nesvnic, u32 dst_ip, int arpi
 				}
 
 				nes_manage_arp_cache(nesvnic->netdev,
-						nesadapter->arp_table[arpindex].mac_addr,
-						dst_ip, NES_ARP_DELETE);
+						     nesadapter->arp_table[arpindex].mac_addr,
+						     dst_ip, NES_ARP_DELETE);
 			}
 
 			nes_manage_arp_cache(nesvnic->netdev, neigh->ha,
@@ -1161,8 +1379,8 @@ static int nes_addr_resolve_neigh(struct nes_vnic *nesvnic, u32 dst_ip, int arpi
  * make_cm_node - create a new instance of a cm node
  */
 static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
-		struct nes_vnic *nesvnic, struct nes_cm_info *cm_info,
-		struct nes_cm_listener *listener)
+					struct nes_vnic *nesvnic, struct nes_cm_info *cm_info,
+					struct nes_cm_listener *listener)
 {
 	struct nes_cm_node *cm_node;
 	struct timespec ts;
@@ -1181,7 +1399,12 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
 	cm_node->rem_addr = cm_info->rem_addr;
 	cm_node->loc_port = cm_info->loc_port;
 	cm_node->rem_port = cm_info->rem_port;
-	cm_node->send_write0 = send_first;
+
+	cm_node->mpa_frame_rev = mpa_version;
+	cm_node->send_rdma0_op = SEND_RDMA_READ_ZERO;
+	cm_node->ird_size = IETF_NO_IRD_ORD;
+	cm_node->ord_size = IETF_NO_IRD_ORD;
+
 	nes_debug(NES_DBG_CM, "Make node addresses : loc = %pI4:%x, rem = %pI4:%x\n",
 		  &cm_node->loc_addr, cm_node->loc_port,
 		  &cm_node->rem_addr, cm_node->rem_port);
@@ -1191,7 +1414,7 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
 	memcpy(cm_node->loc_mac, nesvnic->netdev->dev_addr, ETH_ALEN);
 
 	nes_debug(NES_DBG_CM, "listener=%p, cm_id=%p\n", cm_node->listener,
-			cm_node->cm_id);
+		  cm_node->cm_id);
 
 	spin_lock_init(&cm_node->retrans_list_lock);
 
@@ -1202,11 +1425,11 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
 	cm_node->tcp_cntxt.loc_id = NES_CM_DEF_LOCAL_ID;
 	cm_node->tcp_cntxt.rcv_wscale = NES_CM_DEFAULT_RCV_WND_SCALE;
 	cm_node->tcp_cntxt.rcv_wnd = NES_CM_DEFAULT_RCV_WND_SCALED >>
-			NES_CM_DEFAULT_RCV_WND_SCALE;
+				     NES_CM_DEFAULT_RCV_WND_SCALE;
 	ts = current_kernel_time();
 	cm_node->tcp_cntxt.loc_seq_num = htonl(ts.tv_nsec);
 	cm_node->tcp_cntxt.mss = nesvnic->max_frame_size - sizeof(struct iphdr) -
-			sizeof(struct tcphdr) - ETH_HLEN - VLAN_HLEN;
+				 sizeof(struct tcphdr) - ETH_HLEN - VLAN_HLEN;
 	cm_node->tcp_cntxt.rcv_nxt = 0;
 	/* get a unique session ID , add thread_id to an upcounter to handle race */
 	atomic_inc(&cm_core->node_cnt);
@@ -1222,12 +1445,11 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
 	cm_node->loopbackpartner = NULL;
 
 	/* get the mac addr for the remote node */
-	if (ipv4_is_loopback(htonl(cm_node->rem_addr)))
+	if (ipv4_is_loopback(htonl(cm_node->rem_addr))) {
 		arpindex = nes_arp_table(nesdev, ntohl(nesvnic->local_ipaddr), NULL, NES_ARP_RESOLVE);
-	else {
+	} else {
 		oldarpindex = nes_arp_table(nesdev, cm_node->rem_addr, NULL, NES_ARP_RESOLVE);
 		arpindex = nes_addr_resolve_neigh(nesvnic, cm_info->rem_addr, oldarpindex);
-
 	}
 	if (arpindex < 0) {
 		kfree(cm_node);
@@ -1260,7 +1482,7 @@ static int add_ref_cm_node(struct nes_cm_node *cm_node)
  * rem_ref_cm_node - destroy an instance of a cm node
  */
 static int rem_ref_cm_node(struct nes_cm_core *cm_core,
-	struct nes_cm_node *cm_node)
+			   struct nes_cm_node *cm_node)
 {
 	unsigned long flags;
 	struct nes_qp *nesqp;
@@ -1291,9 +1513,9 @@ static int rem_ref_cm_node(struct nes_cm_core *cm_core,
 	} else {
 		if (cm_node->apbvt_set && cm_node->nesvnic) {
 			nes_manage_apbvt(cm_node->nesvnic, cm_node->loc_port,
-				PCI_FUNC(
-				cm_node->nesvnic->nesdev->pcidev->devfn),
-				NES_MANAGE_APBVT_DEL);
+					 PCI_FUNC(
+						 cm_node->nesvnic->nesdev->pcidev->devfn),
+					 NES_MANAGE_APBVT_DEL);
 		}
 	}
 
@@ -1314,7 +1536,7 @@ static int rem_ref_cm_node(struct nes_cm_core *cm_core,
  * process_options
  */
 static int process_options(struct nes_cm_node *cm_node, u8 *optionsloc,
-	u32 optionsize, u32 syn_packet)
+			   u32 optionsize, u32 syn_packet)
 {
 	u32 tmp;
 	u32 offset = 0;
@@ -1332,15 +1554,15 @@ static int process_options(struct nes_cm_node *cm_node, u8 *optionsloc,
 			continue;
 		case OPTION_NUMBER_MSS:
 			nes_debug(NES_DBG_CM, "%s: MSS Length: %d Offset: %d "
-				"Size: %d\n", __func__,
-				all_options->as_mss.length, offset, optionsize);
+				  "Size: %d\n", __func__,
+				  all_options->as_mss.length, offset, optionsize);
 			got_mss_option = 1;
 			if (all_options->as_mss.length != 4) {
 				return 1;
 			} else {
 				tmp = ntohs(all_options->as_mss.mss);
 				if (tmp > 0 && tmp <
-					cm_node->tcp_cntxt.mss)
+				    cm_node->tcp_cntxt.mss)
 					cm_node->tcp_cntxt.mss = tmp;
 			}
 			break;
@@ -1348,12 +1570,9 @@ static int process_options(struct nes_cm_node *cm_node, u8 *optionsloc,
 			cm_node->tcp_cntxt.snd_wscale =
 				all_options->as_windowscale.shiftcount;
 			break;
-		case OPTION_NUMBER_WRITE0:
-			cm_node->send_write0 = 1;
-			break;
 		default:
 			nes_debug(NES_DBG_CM, "TCP Option not understood: %x\n",
-				all_options->as_base.optionnum);
+				  all_options->as_base.optionnum);
 			break;
 		}
 		offset += all_options->as_base.length;
@@ -1372,8 +1591,8 @@ static void drop_packet(struct sk_buff *skb)
 static void handle_fin_pkt(struct nes_cm_node *cm_node)
 {
 	nes_debug(NES_DBG_CM, "Received FIN, cm_node = %p, state = %u. "
-		"refcnt=%d\n", cm_node, cm_node->state,
-		atomic_read(&cm_node->ref_count));
+		  "refcnt=%d\n", cm_node, cm_node->state,
+		  atomic_read(&cm_node->ref_count));
 	switch (cm_node->state) {
 	case NES_CM_STATE_SYN_RCVD:
 	case NES_CM_STATE_SYN_SENT:
@@ -1439,7 +1658,20 @@ static void handle_rst_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
 		nes_debug(NES_DBG_CM, "%s[%u] create abort for cm_node=%p "
 			"listener=%p state=%d\n", __func__, __LINE__, cm_node,
 			cm_node->listener, cm_node->state);
-		active_open_err(cm_node, skb, reset);
+		switch (cm_node->mpa_frame_rev) {
+		case IETF_MPA_V2:
+			cm_node->mpa_frame_rev = IETF_MPA_V1;
+			/* send a syn and goto syn sent state */
+			cm_node->state = NES_CM_STATE_SYN_SENT;
+			if (send_syn(cm_node, 0, NULL)) {
+				active_open_err(cm_node, skb, reset);
+			}
+			break;
+		case IETF_MPA_V1:
+		default:
+			active_open_err(cm_node, skb, reset);
+			break;
+		}
 		break;
 	case NES_CM_STATE_MPAREQ_RCVD:
 		atomic_inc(&cm_node->passive_state);
@@ -1475,21 +1707,21 @@ static void handle_rst_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
 
 static void handle_rcv_mpa(struct nes_cm_node *cm_node, struct sk_buff *skb)
 {
-
-	int	ret = 0;
+	int ret = 0;
 	int datasize = skb->len;
 	u8 *dataloc = skb->data;
 
 	enum nes_cm_event_type type = NES_CM_EVENT_UNKNOWN;
-	u32     res_type;
+	u32 res_type;
+
 	ret = parse_mpa(cm_node, dataloc, &res_type, datasize);
 	if (ret) {
 		nes_debug(NES_DBG_CM, "didn't like MPA Request\n");
 		if (cm_node->state == NES_CM_STATE_MPAREQ_SENT) {
 			nes_debug(NES_DBG_CM, "%s[%u] create abort for "
-				"cm_node=%p listener=%p state=%d\n", __func__,
-				__LINE__, cm_node, cm_node->listener,
-				cm_node->state);
+				  "cm_node=%p listener=%p state=%d\n", __func__,
+				  __LINE__, cm_node, cm_node->listener,
+				  cm_node->state);
 			active_open_err(cm_node, skb, 1);
 		} else {
 			passive_open_err(cm_node, skb, 1);
@@ -1499,16 +1731,15 @@ static void handle_rcv_mpa(struct nes_cm_node *cm_node, struct sk_buff *skb)
 
 	switch (cm_node->state) {
 	case NES_CM_STATE_ESTABLISHED:
-		if (res_type == NES_MPA_REQUEST_REJECT) {
+		if (res_type == NES_MPA_REQUEST_REJECT)
 			/*BIG problem as we are receiving the MPA.. So should
-			* not be REJECT.. This is Passive Open.. We can
-			* only receive it Reject for Active Open...*/
+			 * not be REJECT.. This is Passive Open.. We can
+			 * only receive it Reject for Active Open...*/
 			WARN_ON(1);
-		}
 		cm_node->state = NES_CM_STATE_MPAREQ_RCVD;
 		type = NES_CM_EVENT_MPA_REQ;
 		atomic_set(&cm_node->passive_state,
-				NES_PASSIVE_STATE_INDICATED);
+			   NES_PASSIVE_STATE_INDICATED);
 		break;
 	case NES_CM_STATE_MPAREQ_SENT:
 		cleanup_retrans_entry(cm_node);
@@ -1535,8 +1766,8 @@ static void indicate_pkt_err(struct nes_cm_node *cm_node, struct sk_buff *skb)
 	case NES_CM_STATE_SYN_SENT:
 	case NES_CM_STATE_MPAREQ_SENT:
 		nes_debug(NES_DBG_CM, "%s[%u] create abort for cm_node=%p "
-			"listener=%p state=%d\n", __func__, __LINE__, cm_node,
-			cm_node->listener, cm_node->state);
+			  "listener=%p state=%d\n", __func__, __LINE__, cm_node,
+			  cm_node->listener, cm_node->state);
 		active_open_err(cm_node, skb, 1);
 		break;
 	case NES_CM_STATE_ESTABLISHED:
@@ -1550,11 +1781,11 @@ static void indicate_pkt_err(struct nes_cm_node *cm_node, struct sk_buff *skb)
 }
 
 static int check_syn(struct nes_cm_node *cm_node, struct tcphdr *tcph,
-	struct sk_buff *skb)
+		     struct sk_buff *skb)
 {
 	int err;
 
-	err = ((ntohl(tcph->ack_seq) == cm_node->tcp_cntxt.loc_seq_num))? 0 : 1;
+	err = ((ntohl(tcph->ack_seq) == cm_node->tcp_cntxt.loc_seq_num)) ? 0 : 1;
 	if (err)
 		active_open_err(cm_node, skb, 1);
 
@@ -1562,7 +1793,7 @@ static int check_syn(struct nes_cm_node *cm_node, struct tcphdr *tcph,
 }
 
 static int check_seq(struct nes_cm_node *cm_node, struct tcphdr *tcph,
-	struct sk_buff *skb)
+		     struct sk_buff *skb)
 {
 	int err = 0;
 	u32 seq;
@@ -1570,21 +1801,22 @@ static int check_seq(struct nes_cm_node *cm_node, struct tcphdr *tcph,
 	u32 loc_seq_num = cm_node->tcp_cntxt.loc_seq_num;
 	u32 rcv_nxt = cm_node->tcp_cntxt.rcv_nxt;
 	u32 rcv_wnd;
+
 	seq = ntohl(tcph->seq);
 	ack_seq = ntohl(tcph->ack_seq);
 	rcv_wnd = cm_node->tcp_cntxt.rcv_wnd;
 	if (ack_seq != loc_seq_num)
 		err = 1;
-	else if (!between(seq, rcv_nxt, (rcv_nxt+rcv_wnd)))
+	else if (!between(seq, rcv_nxt, (rcv_nxt + rcv_wnd)))
 		err = 1;
 	if (err) {
 		nes_debug(NES_DBG_CM, "%s[%u] create abort for cm_node=%p "
-			"listener=%p state=%d\n", __func__, __LINE__, cm_node,
-			cm_node->listener, cm_node->state);
+			  "listener=%p state=%d\n", __func__, __LINE__, cm_node,
+			  cm_node->listener, cm_node->state);
 		indicate_pkt_err(cm_node, skb);
 		nes_debug(NES_DBG_CM, "seq ERROR cm_node =%p seq=0x%08X "
-			"rcv_nxt=0x%08X rcv_wnd=0x%x\n", cm_node, seq, rcv_nxt,
-			rcv_wnd);
+			  "rcv_nxt=0x%08X rcv_wnd=0x%x\n", cm_node, seq, rcv_nxt,
+			  rcv_wnd);
 	}
 	return err;
 }
@@ -1594,9 +1826,8 @@ static int check_seq(struct nes_cm_node *cm_node, struct tcphdr *tcph,
  * is created with a listener or it may comein as rexmitted packet which in
  * that case will be just dropped.
  */
-
 static void handle_syn_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
-	struct tcphdr *tcph)
+			   struct tcphdr *tcph)
 {
 	int ret;
 	u32 inc_sequence;
@@ -1615,15 +1846,15 @@ static void handle_syn_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
 	case NES_CM_STATE_LISTENING:
 		/* Passive OPEN */
 		if (atomic_read(&cm_node->listener->pend_accepts_cnt) >
-				cm_node->listener->backlog) {
+		    cm_node->listener->backlog) {
 			nes_debug(NES_DBG_CM, "drop syn due to backlog "
-				"pressure \n");
+				  "pressure \n");
 			cm_backlog_drops++;
 			passive_open_err(cm_node, skb, 0);
 			break;
 		}
 		ret = handle_tcp_options(cm_node, tcph, skb, optionsize,
-			1);
+					 1);
 		if (ret) {
 			passive_open_err(cm_node, skb, 0);
 			/* drop pkt */
@@ -1657,9 +1888,8 @@ static void handle_syn_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
 }
 
 static void handle_synack_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
-	struct tcphdr *tcph)
+			      struct tcphdr *tcph)
 {
-
 	int ret;
 	u32 inc_sequence;
 	int optionsize;
@@ -1678,7 +1908,7 @@ static void handle_synack_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
 		ret = handle_tcp_options(cm_node, tcph, skb, optionsize, 0);
 		if (ret) {
 			nes_debug(NES_DBG_CM, "cm_node=%p tcp_options failed\n",
-				cm_node);
+				  cm_node);
 			break;
 		}
 		cleanup_retrans_entry(cm_node);
@@ -1717,12 +1947,13 @@ static void handle_synack_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
 }
 
 static int handle_ack_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
-	struct tcphdr *tcph)
+			  struct tcphdr *tcph)
 {
 	int datasize = 0;
 	u32 inc_sequence;
 	int ret = 0;
 	int optionsize;
+
 	optionsize = (tcph->doff << 2) - sizeof(struct tcphdr);
 
 	if (check_seq(cm_node, tcph, skb))
@@ -1743,8 +1974,9 @@ static int handle_ack_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
 		if (datasize) {
 			cm_node->tcp_cntxt.rcv_nxt = inc_sequence + datasize;
 			handle_rcv_mpa(cm_node, skb);
-		} else  /* rcvd ACK only */
+		} else { /* rcvd ACK only */
 			dev_kfree_skb_any(skb);
+		}
 		break;
 	case NES_CM_STATE_ESTABLISHED:
 		/* Passive OPEN */
@@ -1752,16 +1984,18 @@ static int handle_ack_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
 		if (datasize) {
 			cm_node->tcp_cntxt.rcv_nxt = inc_sequence + datasize;
 			handle_rcv_mpa(cm_node, skb);
-		} else
+		} else {
 			drop_packet(skb);
+		}
 		break;
 	case NES_CM_STATE_MPAREQ_SENT:
 		cm_node->tcp_cntxt.rem_ack_num = ntohl(tcph->ack_seq);
 		if (datasize) {
 			cm_node->tcp_cntxt.rcv_nxt = inc_sequence + datasize;
 			handle_rcv_mpa(cm_node, skb);
-		} else  /* Could be just an ack pkt.. */
+		} else { /* Could be just an ack pkt.. */
 			dev_kfree_skb_any(skb);
+		}
 		break;
 	case NES_CM_STATE_LISTENING:
 		cleanup_retrans_entry(cm_node);
@@ -1802,14 +2036,15 @@ static int handle_ack_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
 
 
 static int handle_tcp_options(struct nes_cm_node *cm_node, struct tcphdr *tcph,
-	struct sk_buff *skb, int optionsize, int passive)
+			      struct sk_buff *skb, int optionsize, int passive)
 {
 	u8 *optionsloc = (u8 *)&tcph[1];
+
 	if (optionsize) {
 		if (process_options(cm_node, optionsloc, optionsize,
-			(u32)tcph->syn)) {
+				    (u32)tcph->syn)) {
 			nes_debug(NES_DBG_CM, "%s: Node %p, Sending RESET\n",
-				__func__, cm_node);
+				  __func__, cm_node);
 			if (passive)
 				passive_open_err(cm_node, skb, 1);
 			else
@@ -1819,7 +2054,7 @@ static int handle_tcp_options(struct nes_cm_node *cm_node, struct tcphdr *tcph,
 	}
 
 	cm_node->tcp_cntxt.snd_wnd = ntohs(tcph->window) <<
-			cm_node->tcp_cntxt.snd_wscale;
+				     cm_node->tcp_cntxt.snd_wscale;
 
 	if (cm_node->tcp_cntxt.snd_wnd > cm_node->tcp_cntxt.max_snd_wnd)
 		cm_node->tcp_cntxt.max_snd_wnd = cm_node->tcp_cntxt.snd_wnd;
@@ -1830,18 +2065,18 @@ static int handle_tcp_options(struct nes_cm_node *cm_node, struct tcphdr *tcph,
  * active_open_err() will send reset() if flag set..
  * It will also send ABORT event.
  */
-
 static void active_open_err(struct nes_cm_node *cm_node, struct sk_buff *skb,
-	int reset)
+			    int reset)
 {
 	cleanup_retrans_entry(cm_node);
 	if (reset) {
 		nes_debug(NES_DBG_CM, "ERROR active err called for cm_node=%p, "
-				"state=%d\n", cm_node, cm_node->state);
+			  "state=%d\n", cm_node, cm_node->state);
 		add_ref_cm_node(cm_node);
 		send_reset(cm_node, skb);
-	} else
+	} else {
 		dev_kfree_skb_any(skb);
+	}
 
 	cm_node->state = NES_CM_STATE_CLOSED;
 	create_event(cm_node, NES_CM_EVENT_ABORTED);
@@ -1851,15 +2086,14 @@ static void active_open_err(struct nes_cm_node *cm_node, struct sk_buff *skb,
  * passive_open_err() will either do a reset() or will free up the skb and
  * remove the cm_node.
  */
-
 static void passive_open_err(struct nes_cm_node *cm_node, struct sk_buff *skb,
-	int reset)
+			     int reset)
 {
 	cleanup_retrans_entry(cm_node);
 	cm_node->state = NES_CM_STATE_CLOSED;
 	if (reset) {
 		nes_debug(NES_DBG_CM, "passive_open_err sending RST for "
-			"cm_node=%p state =%d\n", cm_node, cm_node->state);
+			  "cm_node=%p state =%d\n", cm_node, cm_node->state);
 		send_reset(cm_node, skb);
 	} else {
 		dev_kfree_skb_any(skb);
@@ -1874,6 +2108,7 @@ static void passive_open_err(struct nes_cm_node *cm_node, struct sk_buff *skb,
 static void free_retrans_entry(struct nes_cm_node *cm_node)
 {
 	struct nes_timer_entry *send_entry;
+
 	send_entry = cm_node->send_entry;
 	if (send_entry) {
 		cm_node->send_entry = NULL;
@@ -1897,26 +2132,28 @@ static void cleanup_retrans_entry(struct nes_cm_node *cm_node)
  * Returns skb if to be freed, else it will return NULL if already used..
  */
 static void process_packet(struct nes_cm_node *cm_node, struct sk_buff *skb,
-	struct nes_cm_core *cm_core)
+			   struct nes_cm_core *cm_core)
 {
-	enum nes_tcpip_pkt_type	pkt_type = NES_PKT_TYPE_UNKNOWN;
+	enum nes_tcpip_pkt_type pkt_type = NES_PKT_TYPE_UNKNOWN;
 	struct tcphdr *tcph = tcp_hdr(skb);
-	u32     fin_set = 0;
+	u32 fin_set = 0;
 	int ret = 0;
+
 	skb_pull(skb, ip_hdr(skb)->ihl << 2);
 
 	nes_debug(NES_DBG_CM, "process_packet: cm_node=%p state =%d syn=%d "
-		"ack=%d rst=%d fin=%d\n", cm_node, cm_node->state, tcph->syn,
-		tcph->ack, tcph->rst, tcph->fin);
+		  "ack=%d rst=%d fin=%d\n", cm_node, cm_node->state, tcph->syn,
+		  tcph->ack, tcph->rst, tcph->fin);
 
-	if (tcph->rst)
+	if (tcph->rst) {
 		pkt_type = NES_PKT_TYPE_RST;
-	else if (tcph->syn) {
+	} else if (tcph->syn) {
 		pkt_type = NES_PKT_TYPE_SYN;
 		if (tcph->ack)
 			pkt_type = NES_PKT_TYPE_SYNACK;
-	} else if (tcph->ack)
+	} else if (tcph->ack) {
 		pkt_type = NES_PKT_TYPE_ACK;
+	}
 	if (tcph->fin)
 		fin_set = 1;
 
@@ -1947,17 +2184,17 @@ static void process_packet(struct nes_cm_node *cm_node, struct sk_buff *skb,
  * mini_cm_listen - create a listen node with params
  */
 static struct nes_cm_listener *mini_cm_listen(struct nes_cm_core *cm_core,
-	struct nes_vnic *nesvnic, struct nes_cm_info *cm_info)
+					      struct nes_vnic *nesvnic, struct nes_cm_info *cm_info)
 {
 	struct nes_cm_listener *listener;
 	unsigned long flags;
 
 	nes_debug(NES_DBG_CM, "Search for 0x%08x : 0x%04x\n",
-		cm_info->loc_addr, cm_info->loc_port);
+		  cm_info->loc_addr, cm_info->loc_port);
 
 	/* cannot have multiple matching listeners */
 	listener = find_listener(cm_core, htonl(cm_info->loc_addr),
-			htons(cm_info->loc_port), NES_CM_LISTENER_EITHER_STATE);
+				 htons(cm_info->loc_port), NES_CM_LISTENER_EITHER_STATE);
 	if (listener && listener->listener_state == NES_CM_LISTENER_ACTIVE_STATE) {
 		/* find automatically incs ref count ??? */
 		atomic_dec(&listener->ref_count);
@@ -2003,9 +2240,9 @@ static struct nes_cm_listener *mini_cm_listen(struct nes_cm_core *cm_core,
 	}
 
 	nes_debug(NES_DBG_CM, "Api - listen(): addr=0x%08X, port=0x%04x,"
-			" listener = %p, backlog = %d, cm_id = %p.\n",
-			cm_info->loc_addr, cm_info->loc_port,
-			listener, listener->backlog, listener->cm_id);
+		  " listener = %p, backlog = %d, cm_id = %p.\n",
+		  cm_info->loc_addr, cm_info->loc_port,
+		  listener, listener->backlog, listener->cm_id);
 
 	return listener;
 }
@@ -2015,26 +2252,20 @@ static struct nes_cm_listener *mini_cm_listen(struct nes_cm_core *cm_core,
  * mini_cm_connect - make a connection node with params
  */
 static struct nes_cm_node *mini_cm_connect(struct nes_cm_core *cm_core,
-	struct nes_vnic *nesvnic, u16 private_data_len,
-	void *private_data, struct nes_cm_info *cm_info)
+					   struct nes_vnic *nesvnic, u16 private_data_len,
+					   void *private_data, struct nes_cm_info *cm_info)
 {
 	int ret = 0;
 	struct nes_cm_node *cm_node;
 	struct nes_cm_listener *loopbackremotelistener;
 	struct nes_cm_node *loopbackremotenode;
 	struct nes_cm_info loopback_cm_info;
-	u16 mpa_frame_size = sizeof(struct ietf_mpa_frame) + private_data_len;
-	struct ietf_mpa_frame *mpa_frame = NULL;
+	u8 *start_buff;
 
 	/* create a CM connection node */
 	cm_node = make_cm_node(cm_core, nesvnic, cm_info, NULL);
 	if (!cm_node)
 		return NULL;
-	mpa_frame = &cm_node->mpa_frame;
-	memcpy(mpa_frame->key, IEFT_MPA_KEY_REQ, IETF_MPA_KEY_SIZE);
-	mpa_frame->flags = IETF_MPA_FLAGS_CRC;
-	mpa_frame->rev =  IETF_MPA_VERSION;
-	mpa_frame->priv_data_len = htons(private_data_len);
 
 	/* set our node side to client (active) side */
 	cm_node->tcp_cntxt.client = 1;
@@ -2042,8 +2273,8 @@ static struct nes_cm_node *mini_cm_connect(struct nes_cm_core *cm_core,
 
 	if (cm_info->loc_addr == cm_info->rem_addr) {
 		loopbackremotelistener = find_listener(cm_core,
-				ntohl(nesvnic->local_ipaddr), cm_node->rem_port,
-				NES_CM_LISTENER_ACTIVE_STATE);
+						       ntohl(nesvnic->local_ipaddr), cm_node->rem_port,
+						       NES_CM_LISTENER_ACTIVE_STATE);
 		if (loopbackremotelistener == NULL) {
 			create_event(cm_node, NES_CM_EVENT_ABORTED);
 		} else {
@@ -2052,7 +2283,7 @@ static struct nes_cm_node *mini_cm_connect(struct nes_cm_core *cm_core,
 			loopback_cm_info.rem_port = cm_info->loc_port;
 			loopback_cm_info.cm_id = loopbackremotelistener->cm_id;
 			loopbackremotenode = make_cm_node(cm_core, nesvnic,
-				&loopback_cm_info, loopbackremotelistener);
+							  &loopback_cm_info, loopbackremotelistener);
 			if (!loopbackremotenode) {
 				rem_ref_cm_node(cm_node->cm_core, cm_node);
 				return NULL;
@@ -2063,7 +2294,7 @@ static struct nes_cm_node *mini_cm_connect(struct nes_cm_core *cm_core,
 				NES_CM_DEFAULT_RCV_WND_SCALE;
 			cm_node->loopbackpartner = loopbackremotenode;
 			memcpy(loopbackremotenode->mpa_frame_buf, private_data,
-				private_data_len);
+			       private_data_len);
 			loopbackremotenode->mpa_frame_size = private_data_len;
 
 			/* we are done handling this state. */
@@ -2091,12 +2322,10 @@ static struct nes_cm_node *mini_cm_connect(struct nes_cm_core *cm_core,
 		return cm_node;
 	}
 
-	/* set our node side to client (active) side */
-	cm_node->tcp_cntxt.client = 1;
-	/* init our MPA frame ptr */
-	memcpy(mpa_frame->priv_data, private_data, private_data_len);
+	start_buff = &cm_node->mpa_frame_buf[0] + sizeof(struct ietf_mpa_v2);
+	cm_node->mpa_frame_size = private_data_len;
 
-	cm_node->mpa_frame_size = mpa_frame_size;
+	memcpy(start_buff, private_data, private_data_len);
 
 	/* send a syn and goto syn sent state */
 	cm_node->state = NES_CM_STATE_SYN_SENT;
@@ -2105,18 +2334,19 @@ static struct nes_cm_node *mini_cm_connect(struct nes_cm_core *cm_core,
 	if (ret) {
 		/* error in sending the syn free up the cm_node struct */
 		nes_debug(NES_DBG_CM, "Api - connect() FAILED: dest "
-			"addr=0x%08X, port=0x%04x, cm_node=%p, cm_id = %p.\n",
-			cm_node->rem_addr, cm_node->rem_port, cm_node,
-			cm_node->cm_id);
+			  "addr=0x%08X, port=0x%04x, cm_node=%p, cm_id = %p.\n",
+			  cm_node->rem_addr, cm_node->rem_port, cm_node,
+			  cm_node->cm_id);
 		rem_ref_cm_node(cm_node->cm_core, cm_node);
 		cm_node = NULL;
 	}
 
-	if (cm_node)
+	if (cm_node) {
 		nes_debug(NES_DBG_CM, "Api - connect(): dest addr=0x%08X,"
-			"port=0x%04x, cm_node=%p, cm_id = %p.\n",
-			cm_node->rem_addr, cm_node->rem_port, cm_node,
-			cm_node->cm_id);
+			  "port=0x%04x, cm_node=%p, cm_id = %p.\n",
+			  cm_node->rem_addr, cm_node->rem_port, cm_node,
+			  cm_node->cm_id);
+	}
 
 	return cm_node;
 }
@@ -2126,8 +2356,7 @@ static struct nes_cm_node *mini_cm_connect(struct nes_cm_core *cm_core,
  * mini_cm_accept - accept a connection
  * This function is never called
  */
-static int mini_cm_accept(struct nes_cm_core *cm_core,
-	struct ietf_mpa_frame *mpa_frame, struct nes_cm_node *cm_node)
+static int mini_cm_accept(struct nes_cm_core *cm_core, struct nes_cm_node *cm_node)
 {
 	return 0;
 }
@@ -2136,8 +2365,7 @@ static int mini_cm_accept(struct nes_cm_core *cm_core,
 /**
  * mini_cm_reject - reject and teardown a connection
  */
-static int mini_cm_reject(struct nes_cm_core *cm_core,
-	struct ietf_mpa_frame *mpa_frame, struct nes_cm_node *cm_node)
+static int mini_cm_reject(struct nes_cm_core *cm_core, struct nes_cm_node *cm_node)
 {
 	int ret = 0;
 	int err = 0;
@@ -2147,7 +2375,7 @@ static int mini_cm_reject(struct nes_cm_core *cm_core,
 	struct nes_cm_node *loopback = cm_node->loopbackpartner;
 
 	nes_debug(NES_DBG_CM, "%s cm_node=%p type=%d state=%d\n",
-		__func__, cm_node, cm_node->tcp_cntxt.client, cm_node->state);
+		  __func__, cm_node, cm_node->tcp_cntxt.client, cm_node->state);
 
 	if (cm_node->tcp_cntxt.client)
 		return ret;
@@ -2168,8 +2396,9 @@ static int mini_cm_reject(struct nes_cm_core *cm_core,
 					err = send_reset(cm_node, NULL);
 					if (err)
 						WARN_ON(1);
-				} else
+				} else {
 					cm_id->add_ref(cm_id);
+				}
 			}
 		}
 	} else {
@@ -2244,7 +2473,7 @@ static int mini_cm_close(struct nes_cm_core *cm_core, struct nes_cm_node *cm_nod
 	case NES_CM_STATE_TSA:
 		if (cm_node->send_entry)
 			printk(KERN_ERR "ERROR Close got called from STATE_TSA "
-				"send_entry=%p\n", cm_node->send_entry);
+			       "send_entry=%p\n", cm_node->send_entry);
 		ret = rem_ref_cm_node(cm_core, cm_node);
 		break;
 	}
@@ -2257,7 +2486,7 @@ static int mini_cm_close(struct nes_cm_core *cm_core, struct nes_cm_node *cm_nod
  * node state machine
  */
 static int mini_cm_recv_pkt(struct nes_cm_core *cm_core,
-	struct nes_vnic *nesvnic, struct sk_buff *skb)
+			    struct nes_vnic *nesvnic, struct sk_buff *skb)
 {
 	struct nes_cm_node *cm_node = NULL;
 	struct nes_cm_listener *listener = NULL;
@@ -2269,9 +2498,8 @@ static int mini_cm_recv_pkt(struct nes_cm_core *cm_core,
 
 	if (!skb)
 		return 0;
-	if (skb->len < sizeof(struct iphdr) + sizeof(struct tcphdr)) {
+	if (skb->len < sizeof(struct iphdr) + sizeof(struct tcphdr))
 		return 0;
-	}
 
 	iph = (struct iphdr *)skb->data;
 	tcph = (struct tcphdr *)(skb->data + sizeof(struct iphdr));
@@ -2289,8 +2517,8 @@ static int mini_cm_recv_pkt(struct nes_cm_core *cm_core,
 
 	do {
 		cm_node = find_node(cm_core,
-			nfo.rem_port, nfo.rem_addr,
-			nfo.loc_port, nfo.loc_addr);
+				    nfo.rem_port, nfo.rem_addr,
+				    nfo.loc_port, nfo.loc_addr);
 
 		if (!cm_node) {
 			/* Only type of packet accepted are for */
@@ -2300,8 +2528,8 @@ static int mini_cm_recv_pkt(struct nes_cm_core *cm_core,
 				break;
 			}
 			listener = find_listener(cm_core, nfo.loc_addr,
-				nfo.loc_port,
-				NES_CM_LISTENER_ACTIVE_STATE);
+						 nfo.loc_port,
+						 NES_CM_LISTENER_ACTIVE_STATE);
 			if (!listener) {
 				nfo.cm_id = NULL;
 				nfo.conn_type = 0;
@@ -2312,10 +2540,10 @@ static int mini_cm_recv_pkt(struct nes_cm_core *cm_core,
 			nfo.cm_id = listener->cm_id;
 			nfo.conn_type = listener->conn_type;
 			cm_node = make_cm_node(cm_core, nesvnic, &nfo,
-				listener);
+					       listener);
 			if (!cm_node) {
 				nes_debug(NES_DBG_CM, "Unable to allocate "
-					"node\n");
+					  "node\n");
 				cm_packets_dropped++;
 				atomic_dec(&listener->ref_count);
 				dev_kfree_skb_any(skb);
@@ -2363,7 +2591,7 @@ static struct nes_cm_core *nes_cm_alloc_core(void)
 	init_timer(&cm_core->tcp_timer);
 	cm_core->tcp_timer.function = nes_cm_timer_tick;
 
-	cm_core->mtu   = NES_CM_DEFAULT_MTU;
+	cm_core->mtu = NES_CM_DEFAULT_MTU;
 	cm_core->state = NES_CM_STATE_INITED;
 	cm_core->free_tx_pkt_max = NES_CM_DEFAULT_FREE_PKTS;
 
@@ -2401,9 +2629,8 @@ static int mini_cm_dealloc_core(struct nes_cm_core *cm_core)
 
 	barrier();
 
-	if (timer_pending(&cm_core->tcp_timer)) {
+	if (timer_pending(&cm_core->tcp_timer))
 		del_timer(&cm_core->tcp_timer);
-	}
 
 	destroy_workqueue(cm_core->event_wq);
 	destroy_workqueue(cm_core->disconn_wq);
@@ -2458,8 +2685,8 @@ static int nes_cm_init_tsa_conn(struct nes_qp *nesqp, struct nes_cm_node *cm_nod
 		return -EINVAL;
 
 	nesqp->nesqp_context->misc |= cpu_to_le32(NES_QPCONTEXT_MISC_IPV4 |
-			NES_QPCONTEXT_MISC_NO_NAGLE | NES_QPCONTEXT_MISC_DO_NOT_FRAG |
-			NES_QPCONTEXT_MISC_DROS);
+						  NES_QPCONTEXT_MISC_NO_NAGLE | NES_QPCONTEXT_MISC_DO_NOT_FRAG |
+						  NES_QPCONTEXT_MISC_DROS);
 
 	if (cm_node->tcp_cntxt.snd_wscale || cm_node->tcp_cntxt.rcv_wscale)
 		nesqp->nesqp_context->misc |= cpu_to_le32(NES_QPCONTEXT_MISC_WSCALE);
@@ -2469,15 +2696,15 @@ static int nes_cm_init_tsa_conn(struct nes_qp *nesqp, struct nes_cm_node *cm_nod
 	nesqp->nesqp_context->mss |= cpu_to_le32(((u32)cm_node->tcp_cntxt.mss) << 16);
 
 	nesqp->nesqp_context->tcp_state_flow_label |= cpu_to_le32(
-			(u32)NES_QPCONTEXT_TCPSTATE_EST << NES_QPCONTEXT_TCPFLOW_TCP_STATE_SHIFT);
+		(u32)NES_QPCONTEXT_TCPSTATE_EST << NES_QPCONTEXT_TCPFLOW_TCP_STATE_SHIFT);
 
 	nesqp->nesqp_context->pd_index_wscale |= cpu_to_le32(
-			(cm_node->tcp_cntxt.snd_wscale << NES_QPCONTEXT_PDWSCALE_SND_WSCALE_SHIFT) &
-			NES_QPCONTEXT_PDWSCALE_SND_WSCALE_MASK);
+		(cm_node->tcp_cntxt.snd_wscale << NES_QPCONTEXT_PDWSCALE_SND_WSCALE_SHIFT) &
+		NES_QPCONTEXT_PDWSCALE_SND_WSCALE_MASK);
 
 	nesqp->nesqp_context->pd_index_wscale |= cpu_to_le32(
-			(cm_node->tcp_cntxt.rcv_wscale << NES_QPCONTEXT_PDWSCALE_RCV_WSCALE_SHIFT) &
-			NES_QPCONTEXT_PDWSCALE_RCV_WSCALE_MASK);
+		(cm_node->tcp_cntxt.rcv_wscale << NES_QPCONTEXT_PDWSCALE_RCV_WSCALE_SHIFT) &
+		NES_QPCONTEXT_PDWSCALE_RCV_WSCALE_MASK);
 
 	nesqp->nesqp_context->keepalive = cpu_to_le32(0x80);
 	nesqp->nesqp_context->ts_recent = 0;
@@ -2486,24 +2713,24 @@ static int nes_cm_init_tsa_conn(struct nes_qp *nesqp, struct nes_cm_node *cm_nod
 	nesqp->nesqp_context->snd_wnd = cpu_to_le32(cm_node->tcp_cntxt.snd_wnd);
 	nesqp->nesqp_context->rcv_nxt = cpu_to_le32(cm_node->tcp_cntxt.rcv_nxt);
 	nesqp->nesqp_context->rcv_wnd = cpu_to_le32(cm_node->tcp_cntxt.rcv_wnd <<
-			cm_node->tcp_cntxt.rcv_wscale);
+						    cm_node->tcp_cntxt.rcv_wscale);
 	nesqp->nesqp_context->snd_max = cpu_to_le32(cm_node->tcp_cntxt.loc_seq_num);
 	nesqp->nesqp_context->snd_una = cpu_to_le32(cm_node->tcp_cntxt.loc_seq_num);
 	nesqp->nesqp_context->srtt = 0;
 	nesqp->nesqp_context->rttvar = cpu_to_le32(0x6);
 	nesqp->nesqp_context->ssthresh = cpu_to_le32(0x3FFFC000);
-	nesqp->nesqp_context->cwnd = cpu_to_le32(2*cm_node->tcp_cntxt.mss);
+	nesqp->nesqp_context->cwnd = cpu_to_le32(2 * cm_node->tcp_cntxt.mss);
 	nesqp->nesqp_context->snd_wl1 = cpu_to_le32(cm_node->tcp_cntxt.rcv_nxt);
 	nesqp->nesqp_context->snd_wl2 = cpu_to_le32(cm_node->tcp_cntxt.loc_seq_num);
 	nesqp->nesqp_context->max_snd_wnd = cpu_to_le32(cm_node->tcp_cntxt.max_snd_wnd);
 
 	nes_debug(NES_DBG_CM, "QP%u: rcv_nxt = 0x%08X, snd_nxt = 0x%08X,"
-			" Setting MSS to %u, PDWscale = 0x%08X, rcv_wnd = %u, context misc = 0x%08X.\n",
-			nesqp->hwqp.qp_id, le32_to_cpu(nesqp->nesqp_context->rcv_nxt),
-			le32_to_cpu(nesqp->nesqp_context->snd_nxt),
-			cm_node->tcp_cntxt.mss, le32_to_cpu(nesqp->nesqp_context->pd_index_wscale),
-			le32_to_cpu(nesqp->nesqp_context->rcv_wnd),
-			le32_to_cpu(nesqp->nesqp_context->misc));
+		  " Setting MSS to %u, PDWscale = 0x%08X, rcv_wnd = %u, context misc = 0x%08X.\n",
+		  nesqp->hwqp.qp_id, le32_to_cpu(nesqp->nesqp_context->rcv_nxt),
+		  le32_to_cpu(nesqp->nesqp_context->snd_nxt),
+		  cm_node->tcp_cntxt.mss, le32_to_cpu(nesqp->nesqp_context->pd_index_wscale),
+		  le32_to_cpu(nesqp->nesqp_context->rcv_wnd),
+		  le32_to_cpu(nesqp->nesqp_context->misc));
 	nes_debug(NES_DBG_CM, "  snd_wnd  = 0x%08X.\n", le32_to_cpu(nesqp->nesqp_context->snd_wnd));
 	nes_debug(NES_DBG_CM, "  snd_cwnd = 0x%08X.\n", le32_to_cpu(nesqp->nesqp_context->cwnd));
 	nes_debug(NES_DBG_CM, "  max_swnd = 0x%08X.\n", le32_to_cpu(nesqp->nesqp_context->max_snd_wnd));
@@ -2524,7 +2751,7 @@ int nes_cm_disconn(struct nes_qp *nesqp)
 
 	work = kzalloc(sizeof *work, GFP_ATOMIC);
 	if (!work)
-		return -ENOMEM; /* Timer will clean up */
+		return -ENOMEM;  /* Timer will clean up */
 
 	nes_add_ref(&nesqp->ibqp);
 	work->nesqp = nesqp;
@@ -2544,7 +2771,7 @@ static void nes_disconnect_worker(struct work_struct *work)
 
 	kfree(dwork);
 	nes_debug(NES_DBG_CM, "processing AEQE id 0x%04X for QP%u.\n",
-			nesqp->last_aeq, nesqp->hwqp.qp_id);
+		  nesqp->last_aeq, nesqp->hwqp.qp_id);
 	nes_cm_disconn_true(nesqp);
 	nes_rem_ref(&nesqp->ibqp);
 }
@@ -2580,7 +2807,7 @@ static int nes_cm_disconn_true(struct nes_qp *nesqp)
 	/* make sure we havent already closed this connection */
 	if (!cm_id) {
 		nes_debug(NES_DBG_CM, "QP%u disconnect_worker cmid is NULL\n",
-				nesqp->hwqp.qp_id);
+			  nesqp->hwqp.qp_id);
 		spin_unlock_irqrestore(&nesqp->lock, flags);
 		return -1;
 	}
@@ -2589,7 +2816,7 @@ static int nes_cm_disconn_true(struct nes_qp *nesqp)
 	nes_debug(NES_DBG_CM, "Disconnecting QP%u\n", nesqp->hwqp.qp_id);
 
 	original_hw_tcp_state = nesqp->hw_tcp_state;
-	original_ibqp_state   = nesqp->ibqp_state;
+	original_ibqp_state = nesqp->ibqp_state;
 	last_ae = nesqp->last_aeq;
 
 	if (nesqp->term_flags) {
@@ -2647,16 +2874,16 @@ static int nes_cm_disconn_true(struct nes_qp *nesqp)
 			cm_event.private_data_len = 0;
 
 			nes_debug(NES_DBG_CM, "Generating a CM Disconnect Event"
-				" for  QP%u, SQ Head = %u, SQ Tail = %u. "
-				"cm_id = %p, refcount = %u.\n",
-				nesqp->hwqp.qp_id, nesqp->hwqp.sq_head,
-				nesqp->hwqp.sq_tail, cm_id,
-				atomic_read(&nesqp->refcount));
+				  " for  QP%u, SQ Head = %u, SQ Tail = %u. "
+				  "cm_id = %p, refcount = %u.\n",
+				  nesqp->hwqp.qp_id, nesqp->hwqp.sq_head,
+				  nesqp->hwqp.sq_tail, cm_id,
+				  atomic_read(&nesqp->refcount));
 
 			ret = cm_id->event_handler(cm_id, &cm_event);
 			if (ret)
 				nes_debug(NES_DBG_CM, "OFA CM event_handler "
-					"returned, ret=%d\n", ret);
+					  "returned, ret=%d\n", ret);
 		}
 
 		if (issue_close) {
@@ -2674,9 +2901,8 @@ static int nes_cm_disconn_true(struct nes_qp *nesqp)
 			cm_event.private_data_len = 0;
 
 			ret = cm_id->event_handler(cm_id, &cm_event);
-			if (ret) {
+			if (ret)
 				nes_debug(NES_DBG_CM, "OFA CM event_handler returned, ret=%d\n", ret);
-			}
 
 			cm_id->rem_ref(cm_id);
 		}
@@ -2716,8 +2942,8 @@ static int nes_disconnect(struct nes_qp *nesqp, int abrupt)
 			if (nesqp->lsmm_mr)
 				nesibdev->ibdev.dereg_mr(nesqp->lsmm_mr);
 			pci_free_consistent(nesdev->pcidev,
-					nesqp->private_data_len+sizeof(struct ietf_mpa_frame),
-					nesqp->ietf_frame, nesqp->ietf_frame_pbase);
+					    nesqp->private_data_len + nesqp->ietf_frame_size,
+					    nesqp->ietf_frame, nesqp->ietf_frame_pbase);
 		}
 	}
 
@@ -2756,6 +2982,12 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	struct ib_phys_buf ibphysbuf;
 	struct nes_pd *nespd;
 	u64 tagged_offset;
+	u8 mpa_frame_offset = 0;
+	struct ietf_mpa_v2 *mpa_v2_frame;
+	u8 start_addr = 0;
+	u8 *start_ptr = &start_addr;
+	u8 **start_buff = &start_ptr;
+	u16 buff_len = 0;
 
 	ibqp = nes_get_qp(cm_id->device, conn_param->qpn);
 	if (!ibqp)
@@ -2796,53 +3028,49 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	nes_debug(NES_DBG_CM, "netdev refcnt = %u.\n",
 			netdev_refcnt_read(nesvnic->netdev));
 
+	nesqp->ietf_frame_size = sizeof(struct ietf_mpa_v2);
 	/* allocate the ietf frame and space for private data */
 	nesqp->ietf_frame = pci_alloc_consistent(nesdev->pcidev,
-		sizeof(struct ietf_mpa_frame) + conn_param->private_data_len,
-		&nesqp->ietf_frame_pbase);
+						 nesqp->ietf_frame_size + conn_param->private_data_len,
+						 &nesqp->ietf_frame_pbase);
 
 	if (!nesqp->ietf_frame) {
-		nes_debug(NES_DBG_CM, "Unable to allocate memory for private "
-			"data\n");
+		nes_debug(NES_DBG_CM, "Unable to allocate memory for private data\n");
 		return -ENOMEM;
 	}
+	mpa_v2_frame = (struct ietf_mpa_v2 *)nesqp->ietf_frame;
 
+	if (cm_node->mpa_frame_rev == IETF_MPA_V1)
+		mpa_frame_offset = 4;
 
-	/* setup the MPA frame */
-	nesqp->private_data_len = conn_param->private_data_len;
-	memcpy(nesqp->ietf_frame->key, IEFT_MPA_KEY_REP, IETF_MPA_KEY_SIZE);
-
-	memcpy(nesqp->ietf_frame->priv_data, conn_param->private_data,
-			conn_param->private_data_len);
+	memcpy(mpa_v2_frame->priv_data, conn_param->private_data,
+	       conn_param->private_data_len);
 
-	nesqp->ietf_frame->priv_data_len =
-		cpu_to_be16(conn_param->private_data_len);
-	nesqp->ietf_frame->rev = mpa_version;
-	nesqp->ietf_frame->flags = IETF_MPA_FLAGS_CRC;
+	cm_build_mpa_frame(cm_node, start_buff, &buff_len, nesqp->ietf_frame, MPA_KEY_REPLY);
+	nesqp->private_data_len = conn_param->private_data_len;
 
 	/* setup our first outgoing iWarp send WQE (the IETF frame response) */
 	wqe = &nesqp->hwqp.sq_vbase[0];
 
 	if (cm_id->remote_addr.sin_addr.s_addr !=
-			cm_id->local_addr.sin_addr.s_addr) {
+	    cm_id->local_addr.sin_addr.s_addr) {
 		u64temp = (unsigned long)nesqp;
 		nesibdev = nesvnic->nesibdev;
 		nespd = nesqp->nespd;
-		ibphysbuf.addr = nesqp->ietf_frame_pbase;
-		ibphysbuf.size = conn_param->private_data_len +
-					sizeof(struct ietf_mpa_frame);
-		tagged_offset = (u64)(unsigned long)nesqp->ietf_frame;
+		ibphysbuf.addr = nesqp->ietf_frame_pbase + mpa_frame_offset;
+		ibphysbuf.size = buff_len;
+		tagged_offset = (u64)(unsigned long)*start_buff;
 		ibmr = nesibdev->ibdev.reg_phys_mr((struct ib_pd *)nespd,
-						&ibphysbuf, 1,
-						IB_ACCESS_LOCAL_WRITE,
-						&tagged_offset);
+						   &ibphysbuf, 1,
+						   IB_ACCESS_LOCAL_WRITE,
+						   &tagged_offset);
 		if (!ibmr) {
 			nes_debug(NES_DBG_CM, "Unable to register memory region"
-					"for lSMM for cm_node = %p \n",
-					cm_node);
+				  "for lSMM for cm_node = %p \n",
+				  cm_node);
 			pci_free_consistent(nesdev->pcidev,
-				nesqp->private_data_len+sizeof(struct ietf_mpa_frame),
-				nesqp->ietf_frame, nesqp->ietf_frame_pbase);
+					    nesqp->private_data_len + nesqp->ietf_frame_size,
+					    nesqp->ietf_frame, nesqp->ietf_frame_pbase);
 			return -ENOMEM;
 		}
 
@@ -2850,22 +3078,20 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		ibmr->device = nespd->ibpd.device;
 		nesqp->lsmm_mr = ibmr;
 
-		u64temp |= NES_SW_CONTEXT_ALIGN>>1;
+		u64temp |= NES_SW_CONTEXT_ALIGN >> 1;
 		set_wqe_64bit_value(wqe->wqe_words,
-			NES_IWARP_SQ_WQE_COMP_CTX_LOW_IDX,
-			u64temp);
+				    NES_IWARP_SQ_WQE_COMP_CTX_LOW_IDX,
+				    u64temp);
 		wqe->wqe_words[NES_IWARP_SQ_WQE_MISC_IDX] =
 			cpu_to_le32(NES_IWARP_SQ_WQE_STREAMING |
-			NES_IWARP_SQ_WQE_WRPDU);
+				    NES_IWARP_SQ_WQE_WRPDU);
 		wqe->wqe_words[NES_IWARP_SQ_WQE_TOTAL_PAYLOAD_IDX] =
-			cpu_to_le32(conn_param->private_data_len +
-			sizeof(struct ietf_mpa_frame));
+			cpu_to_le32(buff_len);
 		set_wqe_64bit_value(wqe->wqe_words,
-					NES_IWARP_SQ_WQE_FRAG0_LOW_IDX,
-					(u64)(unsigned long)nesqp->ietf_frame);
+				    NES_IWARP_SQ_WQE_FRAG0_LOW_IDX,
+				    (u64)(unsigned long)(*start_buff));
 		wqe->wqe_words[NES_IWARP_SQ_WQE_LENGTH0_IDX] =
-			cpu_to_le32(conn_param->private_data_len +
-			sizeof(struct ietf_mpa_frame));
+			cpu_to_le32(buff_len);
 		wqe->wqe_words[NES_IWARP_SQ_WQE_STAG0_IDX] = ibmr->lkey;
 		if (nesqp->sq_kmapped) {
 			nesqp->sq_kmapped = 0;
@@ -2874,7 +3100,7 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 
 		nesqp->nesqp_context->ird_ord_sizes |=
 			cpu_to_le32(NES_QPCONTEXT_ORDIRD_LSMM_PRESENT |
-			NES_QPCONTEXT_ORDIRD_WRPDU);
+				    NES_QPCONTEXT_ORDIRD_WRPDU);
 	} else {
 		nesqp->nesqp_context->ird_ord_sizes |=
 			cpu_to_le32(NES_QPCONTEXT_ORDIRD_WRPDU);
@@ -2888,11 +3114,11 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 
 	/*  nesqp->cm_node = (void *)cm_id->provider_data; */
 	cm_id->provider_data = nesqp;
-	nesqp->active_conn   = 0;
+	nesqp->active_conn = 0;
 
 	if (cm_node->state == NES_CM_STATE_TSA)
 		nes_debug(NES_DBG_CM, "Already state = TSA for cm_node=%p\n",
-			cm_node);
+			  cm_node);
 
 	nes_cm_init_tsa_conn(nesqp, cm_node);
 
@@ -2909,13 +3135,13 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 			cpu_to_le32(ntohl(cm_id->remote_addr.sin_addr.s_addr));
 
 	nesqp->nesqp_context->misc2 |= cpu_to_le32(
-			(u32)PCI_FUNC(nesdev->pcidev->devfn) <<
-			NES_QPCONTEXT_MISC2_SRC_IP_SHIFT);
+		(u32)PCI_FUNC(nesdev->pcidev->devfn) <<
+		NES_QPCONTEXT_MISC2_SRC_IP_SHIFT);
 
 	nesqp->nesqp_context->arp_index_vlan |=
 		cpu_to_le32(nes_arp_table(nesdev,
-			le32_to_cpu(nesqp->nesqp_context->ip0), NULL,
-			NES_ARP_RESOLVE) << 16);
+					  le32_to_cpu(nesqp->nesqp_context->ip0), NULL,
+					  NES_ARP_RESOLVE) << 16);
 
 	nesqp->nesqp_context->ts_val_delta = cpu_to_le32(
 		jiffies - nes_read_indexed(nesdev, NES_IDX_TCP_NOW));
@@ -2941,7 +3167,7 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	crc_value = get_crc_value(&nes_quad);
 	nesqp->hte_index = cpu_to_be32(crc_value ^ 0xffffffff);
 	nes_debug(NES_DBG_CM, "HTE Index = 0x%08X, CRC = 0x%08X\n",
-		nesqp->hte_index, nesqp->hte_index & adapter->hte_index_mask);
+		  nesqp->hte_index, nesqp->hte_index & adapter->hte_index_mask);
 
 	nesqp->hte_index &= adapter->hte_index_mask;
 	nesqp->nesqp_context->hte_index = cpu_to_le32(nesqp->hte_index);
@@ -2949,16 +3175,15 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	cm_node->cm_core->api->accelerated(cm_node->cm_core, cm_node);
 
 	nes_debug(NES_DBG_CM, "QP%u, Destination IP = 0x%08X:0x%04X, local = "
-			"0x%08X:0x%04X, rcv_nxt=0x%08X, snd_nxt=0x%08X, mpa + "
-			"private data length=%zu.\n", nesqp->hwqp.qp_id,
-			ntohl(cm_id->remote_addr.sin_addr.s_addr),
-			ntohs(cm_id->remote_addr.sin_port),
-			ntohl(cm_id->local_addr.sin_addr.s_addr),
-			ntohs(cm_id->local_addr.sin_port),
-			le32_to_cpu(nesqp->nesqp_context->rcv_nxt),
-			le32_to_cpu(nesqp->nesqp_context->snd_nxt),
-			conn_param->private_data_len +
-			sizeof(struct ietf_mpa_frame));
+		  "0x%08X:0x%04X, rcv_nxt=0x%08X, snd_nxt=0x%08X, mpa + "
+		  "private data length=%zu.\n", nesqp->hwqp.qp_id,
+		  ntohl(cm_id->remote_addr.sin_addr.s_addr),
+		  ntohs(cm_id->remote_addr.sin_port),
+		  ntohl(cm_id->local_addr.sin_addr.s_addr),
+		  ntohs(cm_id->local_addr.sin_port),
+		  le32_to_cpu(nesqp->nesqp_context->rcv_nxt),
+		  le32_to_cpu(nesqp->nesqp_context->snd_nxt),
+		  buff_len);
 
 
 	/* notify OF layer that accept event was successful */
@@ -2980,12 +3205,12 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 			nesqp->private_data_len;
 		/* copy entire MPA frame to our cm_node's frame */
 		memcpy(cm_node->loopbackpartner->mpa_frame_buf,
-			nesqp->ietf_frame->priv_data, nesqp->private_data_len);
+		       conn_param->private_data, conn_param->private_data_len);
 		create_event(cm_node->loopbackpartner, NES_CM_EVENT_CONNECTED);
 	}
 	if (ret)
 		printk(KERN_ERR "%s[%u] OFA CM event_handler returned, "
-			"ret=%d\n", __func__, __LINE__, ret);
+		       "ret=%d\n", __func__, __LINE__, ret);
 
 	return 0;
 }
@@ -2998,34 +3223,28 @@ int nes_reject(struct iw_cm_id *cm_id, const void *pdata, u8 pdata_len)
 {
 	struct nes_cm_node *cm_node;
 	struct nes_cm_node *loopback;
-
 	struct nes_cm_core *cm_core;
+	u8 *start_buff;
 
 	atomic_inc(&cm_rejects);
-	cm_node = (struct nes_cm_node *) cm_id->provider_data;
+	cm_node = (struct nes_cm_node *)cm_id->provider_data;
 	loopback = cm_node->loopbackpartner;
 	cm_core = cm_node->cm_core;
 	cm_node->cm_id = cm_id;
-	cm_node->mpa_frame_size = sizeof(struct ietf_mpa_frame) + pdata_len;
 
-	if (cm_node->mpa_frame_size > MAX_CM_BUFFER)
+	if (pdata_len + sizeof(struct ietf_mpa_v2) > MAX_CM_BUFFER)
 		return -EINVAL;
 
-	memcpy(&cm_node->mpa_frame.key[0], IEFT_MPA_KEY_REP, IETF_MPA_KEY_SIZE);
 	if (loopback) {
 		memcpy(&loopback->mpa_frame.priv_data, pdata, pdata_len);
 		loopback->mpa_frame.priv_data_len = pdata_len;
-		loopback->mpa_frame_size = sizeof(struct ietf_mpa_frame) +
-				pdata_len;
+		loopback->mpa_frame_size = pdata_len;
 	} else {
-		memcpy(&cm_node->mpa_frame.priv_data, pdata, pdata_len);
-		cm_node->mpa_frame.priv_data_len = cpu_to_be16(pdata_len);
+		start_buff = &cm_node->mpa_frame_buf[0] + sizeof(struct ietf_mpa_v2);
+		cm_node->mpa_frame_size = pdata_len;
+		memcpy(start_buff, pdata, pdata_len);
 	}
-
-	cm_node->mpa_frame.rev = mpa_version;
-	cm_node->mpa_frame.flags = IETF_MPA_FLAGS_CRC | IETF_MPA_FLAGS_REJECT;
-
-	return cm_core->api->reject(cm_core, &cm_node->mpa_frame, cm_node);
+	return cm_core->api->reject(cm_core, cm_node);
 }
 
 
@@ -3052,7 +3271,7 @@ int nes_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	nesvnic = to_nesvnic(nesqp->ibqp.device);
 	if (!nesvnic)
 		return -EINVAL;
-	nesdev  = nesvnic->nesdev;
+	nesdev = nesvnic->nesdev;
 	if (!nesdev)
 		return -EINVAL;
 
@@ -3060,12 +3279,12 @@ int nes_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		return -EINVAL;
 
 	nes_debug(NES_DBG_CM, "QP%u, current IP = 0x%08X, Destination IP = "
-		"0x%08X:0x%04X, local = 0x%08X:0x%04X.\n", nesqp->hwqp.qp_id,
-		ntohl(nesvnic->local_ipaddr),
-		ntohl(cm_id->remote_addr.sin_addr.s_addr),
-		ntohs(cm_id->remote_addr.sin_port),
-		ntohl(cm_id->local_addr.sin_addr.s_addr),
-		ntohs(cm_id->local_addr.sin_port));
+		  "0x%08X:0x%04X, local = 0x%08X:0x%04X.\n", nesqp->hwqp.qp_id,
+		  ntohl(nesvnic->local_ipaddr),
+		  ntohl(cm_id->remote_addr.sin_addr.s_addr),
+		  ntohs(cm_id->remote_addr.sin_port),
+		  ntohl(cm_id->local_addr.sin_addr.s_addr),
+		  ntohs(cm_id->local_addr.sin_port));
 
 	atomic_inc(&cm_connects);
 	nesqp->active_conn = 1;
@@ -3079,12 +3298,12 @@ int nes_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	nesqp->nesqp_context->ird_ord_sizes |= cpu_to_le32((u32)conn_param->ord);
 	nes_debug(NES_DBG_CM, "requested ord = 0x%08X.\n", (u32)conn_param->ord);
 	nes_debug(NES_DBG_CM, "mpa private data len =%u\n",
-		conn_param->private_data_len);
+		  conn_param->private_data_len);
 
 	if (cm_id->local_addr.sin_addr.s_addr !=
-		cm_id->remote_addr.sin_addr.s_addr) {
+	    cm_id->remote_addr.sin_addr.s_addr) {
 		nes_manage_apbvt(nesvnic, ntohs(cm_id->local_addr.sin_port),
-			PCI_FUNC(nesdev->pcidev->devfn), NES_MANAGE_APBVT_ADD);
+				 PCI_FUNC(nesdev->pcidev->devfn), NES_MANAGE_APBVT_ADD);
 		apbvt_set = 1;
 	}
 
@@ -3100,13 +3319,13 @@ int nes_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 
 	/* create a connect CM node connection */
 	cm_node = g_cm_core->api->connect(g_cm_core, nesvnic,
-		conn_param->private_data_len, (void *)conn_param->private_data,
-		&cm_info);
+					  conn_param->private_data_len, (void *)conn_param->private_data,
+					  &cm_info);
 	if (!cm_node) {
 		if (apbvt_set)
 			nes_manage_apbvt(nesvnic, ntohs(cm_id->local_addr.sin_port),
-				PCI_FUNC(nesdev->pcidev->devfn),
-				NES_MANAGE_APBVT_DEL);
+					 PCI_FUNC(nesdev->pcidev->devfn),
+					 NES_MANAGE_APBVT_DEL);
 
 		cm_id->rem_ref(cm_id);
 		return -ENOMEM;
@@ -3156,7 +3375,7 @@ int nes_create_listen(struct iw_cm_id *cm_id, int backlog)
 	cm_node = g_cm_core->api->listen(g_cm_core, nesvnic, &cm_info);
 	if (!cm_node) {
 		printk(KERN_ERR "%s[%u] Error returned from listen API call\n",
-				__func__, __LINE__);
+		       __func__, __LINE__);
 		return -ENOMEM;
 	}
 
@@ -3164,12 +3383,12 @@ int nes_create_listen(struct iw_cm_id *cm_id, int backlog)
 
 	if (!cm_node->reused_node) {
 		err = nes_manage_apbvt(nesvnic,
-			ntohs(cm_id->local_addr.sin_port),
-			PCI_FUNC(nesvnic->nesdev->pcidev->devfn),
-			NES_MANAGE_APBVT_ADD);
+				       ntohs(cm_id->local_addr.sin_port),
+				       PCI_FUNC(nesvnic->nesdev->pcidev->devfn),
+				       NES_MANAGE_APBVT_ADD);
 		if (err) {
 			printk(KERN_ERR "nes_manage_apbvt call returned %d.\n",
-				err);
+			       err);
 			g_cm_core->api->stop_listener(g_cm_core, (void *)cm_node);
 			return err;
 		}
@@ -3206,13 +3425,13 @@ int nes_destroy_listen(struct iw_cm_id *cm_id)
 int nes_cm_recv(struct sk_buff *skb, struct net_device *netdevice)
 {
 	int rc = 0;
+
 	cm_packets_received++;
-	if ((g_cm_core) && (g_cm_core->api)) {
+	if ((g_cm_core) && (g_cm_core->api))
 		rc = g_cm_core->api->recv_pkt(g_cm_core, netdev_priv(netdevice), skb);
-	} else {
+	else
 		nes_debug(NES_DBG_CM, "Unable to process packet for CM,"
-				" cm is not setup properly.\n");
-	}
+			  " cm is not setup properly.\n");
 
 	return rc;
 }
@@ -3227,11 +3446,10 @@ int nes_cm_start(void)
 	nes_debug(NES_DBG_CM, "\n");
 	/* create the primary CM core, pass this handle to subsequent core inits */
 	g_cm_core = nes_cm_alloc_core();
-	if (g_cm_core) {
+	if (g_cm_core)
 		return 0;
-	} else {
+	else
 		return -ENOMEM;
-	}
 }
 
 
@@ -3252,7 +3470,6 @@ int nes_cm_stop(void)
  */
 static void cm_event_connected(struct nes_cm_event *event)
 {
-	u64 u64temp;
 	struct nes_qp *nesqp;
 	struct nes_vnic *nesvnic;
 	struct nes_device *nesdev;
@@ -3261,7 +3478,6 @@ static void cm_event_connected(struct nes_cm_event *event)
 	struct ib_qp_attr attr;
 	struct iw_cm_id *cm_id;
 	struct iw_cm_event cm_event;
-	struct nes_hw_qp_wqe *wqe;
 	struct nes_v4_quad nes_quad;
 	u32 crc_value;
 	int ret;
@@ -3275,17 +3491,16 @@ static void cm_event_connected(struct nes_cm_event *event)
 	nesdev = nesvnic->nesdev;
 	nesadapter = nesdev->nesadapter;
 
-	if (nesqp->destroyed) {
+	if (nesqp->destroyed)
 		return;
-	}
 	atomic_inc(&cm_connecteds);
 	nes_debug(NES_DBG_CM, "QP%u attempting to connect to  0x%08X:0x%04X on"
-			" local port 0x%04X. jiffies = %lu.\n",
-			nesqp->hwqp.qp_id,
-			ntohl(cm_id->remote_addr.sin_addr.s_addr),
-			ntohs(cm_id->remote_addr.sin_port),
-			ntohs(cm_id->local_addr.sin_port),
-			jiffies);
+		  " local port 0x%04X. jiffies = %lu.\n",
+		  nesqp->hwqp.qp_id,
+		  ntohl(cm_id->remote_addr.sin_addr.s_addr),
+		  ntohs(cm_id->remote_addr.sin_port),
+		  ntohs(cm_id->local_addr.sin_port),
+		  jiffies);
 
 	nes_cm_init_tsa_conn(nesqp, cm_node);
 
@@ -3316,40 +3531,12 @@ static void cm_event_connected(struct nes_cm_event *event)
 			NES_QPCONTEXT_ORDIRD_IWARP_MODE_SHIFT);
 
 	/* Adjust tail for not having a LSMM */
-	nesqp->hwqp.sq_tail = 1;
+	/*nesqp->hwqp.sq_tail = 1;*/
 
-#if defined(NES_SEND_FIRST_WRITE)
-	if (cm_node->send_write0) {
-		nes_debug(NES_DBG_CM, "Sending first write.\n");
-		wqe = &nesqp->hwqp.sq_vbase[0];
-		u64temp = (unsigned long)nesqp;
-		u64temp |= NES_SW_CONTEXT_ALIGN>>1;
-		set_wqe_64bit_value(wqe->wqe_words,
-				NES_IWARP_SQ_WQE_COMP_CTX_LOW_IDX, u64temp);
-		wqe->wqe_words[NES_IWARP_SQ_WQE_MISC_IDX] =
-			cpu_to_le32(NES_IWARP_SQ_OP_RDMAW);
-		wqe->wqe_words[NES_IWARP_SQ_WQE_TOTAL_PAYLOAD_IDX] = 0;
-		wqe->wqe_words[NES_IWARP_SQ_WQE_FRAG0_LOW_IDX] = 0;
-		wqe->wqe_words[NES_IWARP_SQ_WQE_FRAG0_HIGH_IDX] = 0;
-		wqe->wqe_words[NES_IWARP_SQ_WQE_LENGTH0_IDX] = 0;
-		wqe->wqe_words[NES_IWARP_SQ_WQE_STAG0_IDX] = 0;
+	build_rdma0_msg(cm_node, &nesqp);
 
-		if (nesqp->sq_kmapped) {
-			nesqp->sq_kmapped = 0;
-			kunmap(nesqp->page);
-		}
-
-		/* use the reserved spot on the WQ for the extra first WQE */
-		nesqp->nesqp_context->ird_ord_sizes &=
-			cpu_to_le32(~(NES_QPCONTEXT_ORDIRD_LSMM_PRESENT |
-						NES_QPCONTEXT_ORDIRD_WRPDU |
-						NES_QPCONTEXT_ORDIRD_ALSMM));
-		nesqp->skip_lsmm = 1;
-		nesqp->hwqp.sq_tail = 0;
-		nes_write32(nesdev->regs + NES_WQE_ALLOC,
-				(1 << 24) | 0x00800000 | nesqp->hwqp.qp_id);
-	}
-#endif
+	nes_write32(nesdev->regs + NES_WQE_ALLOC,
+		    (1 << 24) | 0x00800000 | nesqp->hwqp.qp_id);
 
 	memset(&nes_quad, 0, sizeof(nes_quad));
 
@@ -3366,13 +3553,13 @@ static void cm_event_connected(struct nes_cm_event *event)
 	crc_value = get_crc_value(&nes_quad);
 	nesqp->hte_index = cpu_to_be32(crc_value ^ 0xffffffff);
 	nes_debug(NES_DBG_CM, "HTE Index = 0x%08X, After CRC = 0x%08X\n",
-			nesqp->hte_index, nesqp->hte_index & nesadapter->hte_index_mask);
+		  nesqp->hte_index, nesqp->hte_index & nesadapter->hte_index_mask);
 
 	nesqp->hte_index &= nesadapter->hte_index_mask;
 	nesqp->nesqp_context->hte_index = cpu_to_le32(nesqp->hte_index);
 
 	nesqp->ietf_frame = &cm_node->mpa_frame;
-	nesqp->private_data_len = (u8) cm_node->mpa_frame_size;
+	nesqp->private_data_len = (u8)cm_node->mpa_frame_size;
 	cm_node->cm_core->api->accelerated(cm_node->cm_core, cm_node);
 
 	/* notify OF layer we successfully created the requested connection */
@@ -3384,7 +3571,9 @@ static void cm_event_connected(struct nes_cm_event *event)
 	cm_event.remote_addr = cm_id->remote_addr;
 
 	cm_event.private_data = (void *)event->cm_node->mpa_frame_buf;
-	cm_event.private_data_len = (u8) event->cm_node->mpa_frame_size;
+	cm_event.private_data_len = (u8)event->cm_node->mpa_frame_size;
+	cm_event.ird = cm_node->ird_size;
+	cm_event.ord = cm_node->ord_size;
 
 	cm_event.local_addr.sin_addr.s_addr = event->cm_info.rem_addr;
 	ret = cm_id->event_handler(cm_id, &cm_event);
@@ -3392,12 +3581,12 @@ static void cm_event_connected(struct nes_cm_event *event)
 
 	if (ret)
 		printk(KERN_ERR "%s[%u] OFA CM event_handler returned, "
-			"ret=%d\n", __func__, __LINE__, ret);
+		       "ret=%d\n", __func__, __LINE__, ret);
 	attr.qp_state = IB_QPS_RTS;
 	nes_modify_qp(&nesqp->ibqp, &attr, IB_QP_STATE, NULL);
 
 	nes_debug(NES_DBG_CM, "Exiting connect thread for QP%u. jiffies = "
-		"%lu\n", nesqp->hwqp.qp_id, jiffies);
+		  "%lu\n", nesqp->hwqp.qp_id, jiffies);
 
 	return;
 }
@@ -3418,16 +3607,14 @@ static void cm_event_connect_error(struct nes_cm_event *event)
 		return;
 
 	cm_id = event->cm_node->cm_id;
-	if (!cm_id) {
+	if (!cm_id)
 		return;
-	}
 
 	nes_debug(NES_DBG_CM, "cm_node=%p, cm_id=%p\n", event->cm_node, cm_id);
 	nesqp = cm_id->provider_data;
 
-	if (!nesqp) {
+	if (!nesqp)
 		return;
-	}
 
 	/* notify OF layer about this connection error event */
 	/* cm_id->rem_ref(cm_id); */
@@ -3442,14 +3629,14 @@ static void cm_event_connect_error(struct nes_cm_event *event)
 	cm_event.private_data_len = 0;
 
 	nes_debug(NES_DBG_CM, "call CM_EVENT REJECTED, local_addr=%08x, "
-		"remove_addr=%08x\n", cm_event.local_addr.sin_addr.s_addr,
-		cm_event.remote_addr.sin_addr.s_addr);
+		  "remove_addr=%08x\n", cm_event.local_addr.sin_addr.s_addr,
+		  cm_event.remote_addr.sin_addr.s_addr);
 
 	ret = cm_id->event_handler(cm_id, &cm_event);
 	nes_debug(NES_DBG_CM, "OFA CM event_handler returned, ret=%d\n", ret);
 	if (ret)
 		printk(KERN_ERR "%s[%u] OFA CM event_handler returned, "
-			"ret=%d\n", __func__, __LINE__, ret);
+		       "ret=%d\n", __func__, __LINE__, ret);
 	cm_id->rem_ref(cm_id);
 
 	rem_ref_cm_node(event->cm_node->cm_core, event->cm_node);
@@ -3519,7 +3706,7 @@ static void cm_event_reset(struct nes_cm_event *event)
  */
 static void cm_event_mpa_req(struct nes_cm_event *event)
 {
-	struct iw_cm_id   *cm_id;
+	struct iw_cm_id *cm_id;
 	struct iw_cm_event cm_event;
 	int ret;
 	struct nes_cm_node *cm_node;
@@ -3531,7 +3718,7 @@ static void cm_event_mpa_req(struct nes_cm_event *event)
 
 	atomic_inc(&cm_connect_reqs);
 	nes_debug(NES_DBG_CM, "cm_node = %p - cm_id = %p, jiffies = %lu\n",
-			cm_node, cm_id, jiffies);
+		  cm_node, cm_id, jiffies);
 
 	cm_event.event = IW_CM_EVENT_CONNECT_REQUEST;
 	cm_event.status = 0;
@@ -3545,19 +3732,21 @@ static void cm_event_mpa_req(struct nes_cm_event *event)
 	cm_event.remote_addr.sin_port = htons(event->cm_info.rem_port);
 	cm_event.remote_addr.sin_addr.s_addr = htonl(event->cm_info.rem_addr);
 	cm_event.private_data = cm_node->mpa_frame_buf;
-	cm_event.private_data_len  = (u8) cm_node->mpa_frame_size;
+	cm_event.private_data_len = (u8)cm_node->mpa_frame_size;
+	cm_event.ird = cm_node->ird_size;
+	cm_event.ord = cm_node->ord_size;
 
 	ret = cm_id->event_handler(cm_id, &cm_event);
 	if (ret)
 		printk(KERN_ERR "%s[%u] OFA CM event_handler returned, ret=%d\n",
-				__func__, __LINE__, ret);
+		       __func__, __LINE__, ret);
 	return;
 }
 
 
 static void cm_event_mpa_reject(struct nes_cm_event *event)
 {
-	struct iw_cm_id   *cm_id;
+	struct iw_cm_id *cm_id;
 	struct iw_cm_event cm_event;
 	struct nes_cm_node *cm_node;
 	int ret;
@@ -3569,7 +3758,7 @@ static void cm_event_mpa_reject(struct nes_cm_event *event)
 
 	atomic_inc(&cm_connect_reqs);
 	nes_debug(NES_DBG_CM, "cm_node = %p - cm_id = %p, jiffies = %lu\n",
-			cm_node, cm_id, jiffies);
+		  cm_node, cm_id, jiffies);
 
 	cm_event.event = IW_CM_EVENT_CONNECT_REPLY;
 	cm_event.status = -ECONNREFUSED;
@@ -3584,17 +3773,17 @@ static void cm_event_mpa_reject(struct nes_cm_event *event)
 	cm_event.remote_addr.sin_addr.s_addr = htonl(event->cm_info.rem_addr);
 
 	cm_event.private_data = cm_node->mpa_frame_buf;
-	cm_event.private_data_len = (u8) cm_node->mpa_frame_size;
+	cm_event.private_data_len = (u8)cm_node->mpa_frame_size;
 
 	nes_debug(NES_DBG_CM, "call CM_EVENT_MPA_REJECTED, local_addr=%08x, "
-			"remove_addr=%08x\n",
-			cm_event.local_addr.sin_addr.s_addr,
-			cm_event.remote_addr.sin_addr.s_addr);
+		  "remove_addr=%08x\n",
+		  cm_event.local_addr.sin_addr.s_addr,
+		  cm_event.remote_addr.sin_addr.s_addr);
 
 	ret = cm_id->event_handler(cm_id, &cm_event);
 	if (ret)
 		printk(KERN_ERR "%s[%u] OFA CM event_handler returned, ret=%d\n",
-				__func__, __LINE__, ret);
+		       __func__, __LINE__, ret);
 
 	return;
 }
@@ -3613,7 +3802,7 @@ static int nes_cm_post_event(struct nes_cm_event *event)
 	event->cm_info.cm_id->add_ref(event->cm_info.cm_id);
 	INIT_WORK(&event->event_work, nes_cm_event_handler);
 	nes_debug(NES_DBG_CM, "cm_node=%p queue_work, event=%p\n",
-		event->cm_node, event);
+		  event->cm_node, event);
 
 	queue_work(event->cm_node->cm_core->event_wq, &event->event_work);
 
@@ -3630,7 +3819,7 @@ static int nes_cm_post_event(struct nes_cm_event *event)
 static void nes_cm_event_handler(struct work_struct *work)
 {
 	struct nes_cm_event *event = container_of(work, struct nes_cm_event,
-			event_work);
+						  event_work);
 	struct nes_cm_core *cm_core;
 
 	if ((!event) || (!event->cm_node) || (!event->cm_node->cm_core))
@@ -3638,29 +3827,29 @@ static void nes_cm_event_handler(struct work_struct *work)
 
 	cm_core = event->cm_node->cm_core;
 	nes_debug(NES_DBG_CM, "event=%p, event->type=%u, events posted=%u\n",
-		event, event->type, atomic_read(&cm_core->events_posted));
+		  event, event->type, atomic_read(&cm_core->events_posted));
 
 	switch (event->type) {
 	case NES_CM_EVENT_MPA_REQ:
 		cm_event_mpa_req(event);
 		nes_debug(NES_DBG_CM, "cm_node=%p CM Event: MPA REQUEST\n",
-			event->cm_node);
+			  event->cm_node);
 		break;
 	case NES_CM_EVENT_RESET:
 		nes_debug(NES_DBG_CM, "cm_node = %p CM Event: RESET\n",
-			event->cm_node);
+			  event->cm_node);
 		cm_event_reset(event);
 		break;
 	case NES_CM_EVENT_CONNECTED:
 		if ((!event->cm_node->cm_id) ||
-			(event->cm_node->state != NES_CM_STATE_TSA))
+		    (event->cm_node->state != NES_CM_STATE_TSA))
 			break;
 		cm_event_connected(event);
 		nes_debug(NES_DBG_CM, "CM Event: CONNECTED\n");
 		break;
 	case NES_CM_EVENT_MPA_REJECT:
 		if ((!event->cm_node->cm_id) ||
-				(event->cm_node->state == NES_CM_STATE_TSA))
+		    (event->cm_node->state == NES_CM_STATE_TSA))
 			break;
 		cm_event_mpa_reject(event);
 		nes_debug(NES_DBG_CM, "CM Event: REJECT\n");
@@ -3668,7 +3857,7 @@ static void nes_cm_event_handler(struct work_struct *work)
 
 	case NES_CM_EVENT_ABORTED:
 		if ((!event->cm_node->cm_id) ||
-			(event->cm_node->state == NES_CM_STATE_TSA))
+		    (event->cm_node->state == NES_CM_STATE_TSA))
 			break;
 		cm_event_connect_error(event);
 		nes_debug(NES_DBG_CM, "CM Event: ABORTED\n");
diff --git a/drivers/infiniband/hw/nes/nes_cm.h b/drivers/infiniband/hw/nes/nes_cm.h
index d9825fd..85f53d9 100644
--- a/drivers/infiniband/hw/nes/nes_cm.h
+++ b/drivers/infiniband/hw/nes/nes_cm.h
@@ -48,7 +48,16 @@
 #define IETF_MPA_KEY_SIZE 16
 #define IETF_MPA_VERSION  1
 #define IETF_MAX_PRIV_DATA_LEN 512
-#define IETF_MPA_FRAME_SIZE     20
+#define IETF_MPA_FRAME_SIZE    20
+#define IETF_RTR_MSG_SIZE      4
+#define IETF_MPA_V2_FLAG       0x10
+
+/* IETF RTR MSG Fields               */
+#define IETF_PEER_TO_PEER       0x8000
+#define IETF_FLPDU_ZERO_LEN     0x4000
+#define IETF_RDMA0_WRITE        0x8000
+#define IETF_RDMA0_READ         0x4000
+#define IETF_NO_IRD_ORD         0x3FFF
 
 enum ietf_mpa_flags {
 	IETF_MPA_FLAGS_MARKERS = 0x80,	/* receive Markers */
@@ -56,7 +65,7 @@ enum ietf_mpa_flags {
 	IETF_MPA_FLAGS_REJECT  = 0x20,	/* Reject */
 };
 
-struct ietf_mpa_frame {
+struct ietf_mpa_v1 {
 	u8 key[IETF_MPA_KEY_SIZE];
 	u8 flags;
 	u8 rev;
@@ -66,6 +75,20 @@ struct ietf_mpa_frame {
 
 #define ietf_mpa_req_resp_frame ietf_mpa_frame
 
+struct ietf_rtr_msg {
+	__be16 ctrl_ird;
+	__be16 ctrl_ord;
+};
+
+struct ietf_mpa_v2 {
+	u8 key[IETF_MPA_KEY_SIZE];
+	u8 flags;
+	u8 rev;
+	 __be16 priv_data_len;
+	struct ietf_rtr_msg rtr_msg;
+	u8 priv_data[0];
+};
+
 struct nes_v4_quad {
 	u32 rsvd0;
 	__le32 DstIpAdrIndex;	/* Only most significant 5 bits are valid */
@@ -171,8 +194,7 @@ struct nes_timer_entry {
 
 #define NES_CM_DEF_SEQ2      0x18ed5740
 #define NES_CM_DEF_LOCAL_ID2 0xb807
-#define	MAX_CM_BUFFER	(IETF_MPA_FRAME_SIZE + IETF_MAX_PRIV_DATA_LEN)
-
+#define	MAX_CM_BUFFER	(IETF_MPA_FRAME_SIZE + IETF_RTR_MSG_SIZE + IETF_MAX_PRIV_DATA_LEN)
 
 typedef u32 nes_addr_t;
 
@@ -204,6 +226,21 @@ enum nes_cm_node_state {
 	NES_CM_STATE_CLOSED
 };
 
+enum mpa_frame_version {
+	IETF_MPA_V1 = 1,
+	IETF_MPA_V2 = 2
+};
+
+enum mpa_frame_key {
+	MPA_KEY_REQUEST,
+	MPA_KEY_REPLY
+};
+
+enum send_rdma0 {
+	SEND_RDMA_READ_ZERO = 1,
+	SEND_RDMA_WRITE_ZERO = 2
+};
+
 enum nes_tcpip_pkt_type {
 	NES_PKT_TYPE_UNKNOWN,
 	NES_PKT_TYPE_SYN,
@@ -245,9 +282,9 @@ struct nes_cm_tcp_context {
 
 
 enum nes_cm_listener_state {
-	NES_CM_LISTENER_PASSIVE_STATE=1,
-	NES_CM_LISTENER_ACTIVE_STATE=2,
-	NES_CM_LISTENER_EITHER_STATE=3
+	NES_CM_LISTENER_PASSIVE_STATE = 1,
+	NES_CM_LISTENER_ACTIVE_STATE = 2,
+	NES_CM_LISTENER_EITHER_STATE = 3
 };
 
 struct nes_cm_listener {
@@ -283,16 +320,20 @@ struct nes_cm_node {
 
 	struct nes_cm_node        *loopbackpartner;
 
-	struct nes_timer_entry	*send_entry;
-
+	struct nes_timer_entry	  *send_entry;
+	struct nes_timer_entry    *recv_entry;
 	spinlock_t                retrans_list_lock;
-	struct nes_timer_entry  *recv_entry;
+	enum send_rdma0           send_rdma0_op;
 
-	int                       send_write0;
 	union {
-		struct ietf_mpa_frame mpa_frame;
-		u8                    mpa_frame_buf[MAX_CM_BUFFER];
+		struct ietf_mpa_v1 mpa_frame;
+		struct ietf_mpa_v2 mpa_v2_frame;
+		u8                 mpa_frame_buf[MAX_CM_BUFFER];
 	};
+	enum mpa_frame_version    mpa_frame_rev;
+	u16			  ird_size;
+	u16                       ord_size;
+
 	u16                       mpa_frame_size;
 	struct iw_cm_id           *cm_id;
 	struct list_head          list;
@@ -399,10 +440,8 @@ struct nes_cm_ops {
 			struct nes_vnic *, u16, void *,
 			struct nes_cm_info *);
 	int (*close)(struct nes_cm_core *, struct nes_cm_node *);
-	int (*accept)(struct nes_cm_core *, struct ietf_mpa_frame *,
-			struct nes_cm_node *);
-	int (*reject)(struct nes_cm_core *, struct ietf_mpa_frame *,
-			struct nes_cm_node *);
+	int (*accept)(struct nes_cm_core *, struct nes_cm_node *);
+	int (*reject)(struct nes_cm_core *, struct nes_cm_node *);
 	int (*recv_pkt)(struct nes_cm_core *, struct nes_vnic *,
 			struct sk_buff *);
 	int (*destroy_cm_core)(struct nes_cm_core *);
diff --git a/drivers/infiniband/hw/nes/nes_verbs.h b/drivers/infiniband/hw/nes/nes_verbs.h
index 2df9993..854316d 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.h
+++ b/drivers/infiniband/hw/nes/nes_verbs.h
@@ -139,7 +139,8 @@ struct nes_qp {
 	struct nes_cq         *nesrcq;
 	struct nes_pd         *nespd;
 	void *cm_node; /* handle of the node this QP is associated with */
-	struct ietf_mpa_frame *ietf_frame;
+	void                  *ietf_frame;
+	u8                    ietf_frame_size;
 	dma_addr_t            ietf_frame_pbase;
 	struct ib_mr          *lsmm_mr;
 	struct nes_hw_qp      hwqp;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
