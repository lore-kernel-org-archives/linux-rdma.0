From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 15/19] IB/mad: Create jumbo_mad data structures
Date: Mon, 26 Jan 2015 14:07:48 -0500
Message-ID: <1422299272-15898-16-git-send-email-ira.weiny@intel.com>
References: <1422299272-15898-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422299272-15898-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Define jumbo_mad and jumbo_rmpp_mad.

Jumbo MAD structures are 2K versions of ib_mad and ib_rmpp_mad structures.
Currently only OPA base version MADs are of this type.

Create an RMPP Base header to share between ib_rmpp_mad and jumbo_rmpp_mad

Update existing code to use the new structures.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---

Changes from V2:
	Reword commit msg

 drivers/infiniband/core/mad.c      |  18 +++---
 drivers/infiniband/core/mad_priv.h |   2 +
 drivers/infiniband/core/mad_rmpp.c | 120 ++++++++++++++++++-------------------
 drivers/infiniband/core/user_mad.c |  16 ++---
 include/rdma/ib_mad.h              |  26 +++++++-
 5 files changed, 103 insertions(+), 79 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 2145294..316b4b2 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -883,7 +883,7 @@ static int alloc_send_rmpp_list(struct ib_mad_send_wr_private *send_wr,
 				gfp_t gfp_mask)
 {
 	struct ib_mad_send_buf *send_buf = &send_wr->send_buf;
-	struct ib_rmpp_mad *rmpp_mad = send_buf->mad;
+	struct ib_rmpp_base *rmpp_base = send_buf->mad;
 	struct ib_rmpp_segment *seg = NULL;
 	int left, seg_size, pad;
 
@@ -909,10 +909,10 @@ static int alloc_send_rmpp_list(struct ib_mad_send_wr_private *send_wr,
 	if (pad)
 		memset(seg->data + seg_size - pad, 0, pad);
 
-	rmpp_mad->rmpp_hdr.rmpp_version = send_wr->mad_agent_priv->
+	rmpp_base->rmpp_hdr.rmpp_version = send_wr->mad_agent_priv->
 					  agent.rmpp_version;
-	rmpp_mad->rmpp_hdr.rmpp_type = IB_MGMT_RMPP_TYPE_DATA;
-	ib_set_rmpp_flags(&rmpp_mad->rmpp_hdr, IB_MGMT_RMPP_FLAG_ACTIVE);
+	rmpp_base->rmpp_hdr.rmpp_type = IB_MGMT_RMPP_TYPE_DATA;
+	ib_set_rmpp_flags(&rmpp_base->rmpp_hdr, IB_MGMT_RMPP_FLAG_ACTIVE);
 
 	send_wr->cur_seg = container_of(send_wr->rmpp_list.next,
 					struct ib_rmpp_segment, list);
@@ -1748,14 +1748,14 @@ out:
 static int is_rmpp_data_mad(struct ib_mad_agent_private *mad_agent_priv,
 		       struct ib_mad_hdr *mad_hdr)
 {
-	struct ib_rmpp_mad *rmpp_mad;
+	struct ib_rmpp_base *rmpp_base;
 
-	rmpp_mad = (struct ib_rmpp_mad *)mad_hdr;
+	rmpp_base = (struct ib_rmpp_base *)mad_hdr;
 	return !mad_agent_priv->agent.rmpp_version ||
 		!ib_mad_kernel_rmpp_agent(&mad_agent_priv->agent) ||
-		!(ib_get_rmpp_flags(&rmpp_mad->rmpp_hdr) &
+		!(ib_get_rmpp_flags(&rmpp_base->rmpp_hdr) &
 				    IB_MGMT_RMPP_FLAG_ACTIVE) ||
-		(rmpp_mad->rmpp_hdr.rmpp_type == IB_MGMT_RMPP_TYPE_DATA);
+		(rmpp_base->rmpp_hdr.rmpp_type == IB_MGMT_RMPP_TYPE_DATA);
 }
 
 static inline int rcv_has_same_class(struct ib_mad_send_wr_private *wr,
@@ -1897,7 +1897,7 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 			spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
 			if (!ib_mad_kernel_rmpp_agent(&mad_agent_priv->agent)
 			   && ib_is_mad_class_rmpp(mad_recv_wc->recv_buf.mad->mad_hdr.mgmt_class)
-			   && (ib_get_rmpp_flags(&((struct ib_rmpp_mad *)mad_recv_wc->recv_buf.mad)->rmpp_hdr)
+			   && (ib_get_rmpp_flags(&((struct ib_rmpp_base *)mad_recv_wc->recv_buf.mad)->rmpp_hdr)
 					& IB_MGMT_RMPP_FLAG_ACTIVE)) {
 				/* user rmpp is in effect
 				 * and this is an active RMPP MAD
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index d1a0b0e..d71ddcc 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -80,6 +80,8 @@ struct ib_mad_private {
 		struct ib_mad mad;
 		struct ib_rmpp_mad rmpp_mad;
 		struct ib_smp smp;
+		struct jumbo_mad jumbo_mad;
+		struct jumbo_rmpp_mad jumbo_rmpp_mad;
 	} mad;
 } __attribute__ ((packed));
 
diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index 2379e2d..7184530 100644
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -111,10 +111,10 @@ void ib_cancel_rmpp_recvs(struct ib_mad_agent_private *agent)
 }
 
 static void format_ack(struct ib_mad_send_buf *msg,
-		       struct ib_rmpp_mad *data,
+		       struct ib_rmpp_base *data,
 		       struct mad_rmpp_recv *rmpp_recv)
 {
-	struct ib_rmpp_mad *ack = msg->mad;
+	struct ib_rmpp_base *ack = msg->mad;
 	unsigned long flags;
 
 	memcpy(ack, &data->mad_hdr, msg->hdr_len);
@@ -144,7 +144,7 @@ static void ack_recv(struct mad_rmpp_recv *rmpp_recv,
 	if (IS_ERR(msg))
 		return;
 
-	format_ack(msg, (struct ib_rmpp_mad *) recv_wc->recv_buf.mad, rmpp_recv);
+	format_ack(msg, (struct ib_rmpp_base *) recv_wc->recv_buf.mad, rmpp_recv);
 	msg->ah = rmpp_recv->ah;
 	ret = ib_post_send_mad(msg, NULL);
 	if (ret)
@@ -182,20 +182,20 @@ static void ack_ds_ack(struct ib_mad_agent_private *agent,
 		       struct ib_mad_recv_wc *recv_wc)
 {
 	struct ib_mad_send_buf *msg;
-	struct ib_rmpp_mad *rmpp_mad;
+	struct ib_rmpp_base *rmpp_base;
 	int ret;
 
 	msg = alloc_response_msg(&agent->agent, recv_wc);
 	if (IS_ERR(msg))
 		return;
 
-	rmpp_mad = msg->mad;
-	memcpy(rmpp_mad, recv_wc->recv_buf.mad, msg->hdr_len);
+	rmpp_base = msg->mad;
+	memcpy(rmpp_base, recv_wc->recv_buf.mad, msg->hdr_len);
 
-	rmpp_mad->mad_hdr.method ^= IB_MGMT_METHOD_RESP;
-	ib_set_rmpp_flags(&rmpp_mad->rmpp_hdr, IB_MGMT_RMPP_FLAG_ACTIVE);
-	rmpp_mad->rmpp_hdr.seg_num = 0;
-	rmpp_mad->rmpp_hdr.paylen_newwin = cpu_to_be32(1);
+	rmpp_base->mad_hdr.method ^= IB_MGMT_METHOD_RESP;
+	ib_set_rmpp_flags(&rmpp_base->rmpp_hdr, IB_MGMT_RMPP_FLAG_ACTIVE);
+	rmpp_base->rmpp_hdr.seg_num = 0;
+	rmpp_base->rmpp_hdr.paylen_newwin = cpu_to_be32(1);
 
 	ret = ib_post_send_mad(msg, NULL);
 	if (ret) {
@@ -215,23 +215,23 @@ static void nack_recv(struct ib_mad_agent_private *agent,
 		      struct ib_mad_recv_wc *recv_wc, u8 rmpp_status)
 {
 	struct ib_mad_send_buf *msg;
-	struct ib_rmpp_mad *rmpp_mad;
+	struct ib_rmpp_base *rmpp_base;
 	int ret;
 
 	msg = alloc_response_msg(&agent->agent, recv_wc);
 	if (IS_ERR(msg))
 		return;
 
-	rmpp_mad = msg->mad;
-	memcpy(rmpp_mad, recv_wc->recv_buf.mad, msg->hdr_len);
+	rmpp_base = msg->mad;
+	memcpy(rmpp_base, recv_wc->recv_buf.mad, msg->hdr_len);
 
-	rmpp_mad->mad_hdr.method ^= IB_MGMT_METHOD_RESP;
-	rmpp_mad->rmpp_hdr.rmpp_version = IB_MGMT_RMPP_VERSION;
-	rmpp_mad->rmpp_hdr.rmpp_type = IB_MGMT_RMPP_TYPE_ABORT;
-	ib_set_rmpp_flags(&rmpp_mad->rmpp_hdr, IB_MGMT_RMPP_FLAG_ACTIVE);
-	rmpp_mad->rmpp_hdr.rmpp_status = rmpp_status;
-	rmpp_mad->rmpp_hdr.seg_num = 0;
-	rmpp_mad->rmpp_hdr.paylen_newwin = 0;
+	rmpp_base->mad_hdr.method ^= IB_MGMT_METHOD_RESP;
+	rmpp_base->rmpp_hdr.rmpp_version = IB_MGMT_RMPP_VERSION;
+	rmpp_base->rmpp_hdr.rmpp_type = IB_MGMT_RMPP_TYPE_ABORT;
+	ib_set_rmpp_flags(&rmpp_base->rmpp_hdr, IB_MGMT_RMPP_FLAG_ACTIVE);
+	rmpp_base->rmpp_hdr.rmpp_status = rmpp_status;
+	rmpp_base->rmpp_hdr.seg_num = 0;
+	rmpp_base->rmpp_hdr.paylen_newwin = 0;
 
 	ret = ib_post_send_mad(msg, NULL);
 	if (ret) {
@@ -373,18 +373,18 @@ insert_rmpp_recv(struct ib_mad_agent_private *agent,
 
 static inline int get_last_flag(struct ib_mad_recv_buf *seg)
 {
-	struct ib_rmpp_mad *rmpp_mad;
+	struct ib_rmpp_base *rmpp_base;
 
-	rmpp_mad = (struct ib_rmpp_mad *) seg->mad;
-	return ib_get_rmpp_flags(&rmpp_mad->rmpp_hdr) & IB_MGMT_RMPP_FLAG_LAST;
+	rmpp_base = (struct ib_rmpp_base *) seg->mad;
+	return ib_get_rmpp_flags(&rmpp_base->rmpp_hdr) & IB_MGMT_RMPP_FLAG_LAST;
 }
 
 static inline int get_seg_num(struct ib_mad_recv_buf *seg)
 {
-	struct ib_rmpp_mad *rmpp_mad;
+	struct ib_rmpp_base *rmpp_base;
 
-	rmpp_mad = (struct ib_rmpp_mad *) seg->mad;
-	return be32_to_cpu(rmpp_mad->rmpp_hdr.seg_num);
+	rmpp_base = (struct ib_rmpp_base *) seg->mad;
+	return be32_to_cpu(rmpp_base->rmpp_hdr.seg_num);
 }
 
 static inline struct ib_mad_recv_buf * get_next_seg(struct list_head *rmpp_list,
@@ -436,9 +436,9 @@ static inline int get_mad_len(struct mad_rmpp_recv *rmpp_recv)
 
 	rmpp_mad = (struct ib_rmpp_mad *)rmpp_recv->cur_seg_buf->mad;
 
-	hdr_size = ib_get_mad_data_offset(rmpp_mad->mad_hdr.mgmt_class);
+	hdr_size = ib_get_mad_data_offset(rmpp_mad->base.mad_hdr.mgmt_class);
 	data_size = sizeof(struct ib_rmpp_mad) - hdr_size;
-	pad = IB_MGMT_RMPP_DATA - be32_to_cpu(rmpp_mad->rmpp_hdr.paylen_newwin);
+	pad = IB_MGMT_RMPP_DATA - be32_to_cpu(rmpp_mad->base.rmpp_hdr.paylen_newwin);
 	if (pad > IB_MGMT_RMPP_DATA || pad < 0)
 		pad = 0;
 
@@ -567,20 +567,20 @@ static int send_next_seg(struct ib_mad_send_wr_private *mad_send_wr)
 	u32 paylen = 0;
 
 	rmpp_mad = mad_send_wr->send_buf.mad;
-	ib_set_rmpp_flags(&rmpp_mad->rmpp_hdr, IB_MGMT_RMPP_FLAG_ACTIVE);
-	rmpp_mad->rmpp_hdr.seg_num = cpu_to_be32(++mad_send_wr->seg_num);
+	ib_set_rmpp_flags(&rmpp_mad->base.rmpp_hdr, IB_MGMT_RMPP_FLAG_ACTIVE);
+	rmpp_mad->base.rmpp_hdr.seg_num = cpu_to_be32(++mad_send_wr->seg_num);
 
 	if (mad_send_wr->seg_num == 1) {
-		rmpp_mad->rmpp_hdr.rmpp_rtime_flags |= IB_MGMT_RMPP_FLAG_FIRST;
+		rmpp_mad->base.rmpp_hdr.rmpp_rtime_flags |= IB_MGMT_RMPP_FLAG_FIRST;
 		paylen = mad_send_wr->send_buf.seg_count * IB_MGMT_RMPP_DATA -
 			 mad_send_wr->pad;
 	}
 
 	if (mad_send_wr->seg_num == mad_send_wr->send_buf.seg_count) {
-		rmpp_mad->rmpp_hdr.rmpp_rtime_flags |= IB_MGMT_RMPP_FLAG_LAST;
+		rmpp_mad->base.rmpp_hdr.rmpp_rtime_flags |= IB_MGMT_RMPP_FLAG_LAST;
 		paylen = IB_MGMT_RMPP_DATA - mad_send_wr->pad;
 	}
-	rmpp_mad->rmpp_hdr.paylen_newwin = cpu_to_be32(paylen);
+	rmpp_mad->base.rmpp_hdr.paylen_newwin = cpu_to_be32(paylen);
 
 	/* 2 seconds for an ACK until we can find the packet lifetime */
 	timeout = mad_send_wr->send_buf.timeout_ms;
@@ -644,19 +644,19 @@ static void process_rmpp_ack(struct ib_mad_agent_private *agent,
 			     struct ib_mad_recv_wc *mad_recv_wc)
 {
 	struct ib_mad_send_wr_private *mad_send_wr;
-	struct ib_rmpp_mad *rmpp_mad;
+	struct ib_rmpp_base *rmpp_base;
 	unsigned long flags;
 	int seg_num, newwin, ret;
 
-	rmpp_mad = (struct ib_rmpp_mad *)mad_recv_wc->recv_buf.mad;
-	if (rmpp_mad->rmpp_hdr.rmpp_status) {
+	rmpp_base = (struct ib_rmpp_base *)mad_recv_wc->recv_buf.mad;
+	if (rmpp_base->rmpp_hdr.rmpp_status) {
 		abort_send(agent, mad_recv_wc, IB_MGMT_RMPP_STATUS_BAD_STATUS);
 		nack_recv(agent, mad_recv_wc, IB_MGMT_RMPP_STATUS_BAD_STATUS);
 		return;
 	}
 
-	seg_num = be32_to_cpu(rmpp_mad->rmpp_hdr.seg_num);
-	newwin = be32_to_cpu(rmpp_mad->rmpp_hdr.paylen_newwin);
+	seg_num = be32_to_cpu(rmpp_base->rmpp_hdr.seg_num);
+	newwin = be32_to_cpu(rmpp_base->rmpp_hdr.paylen_newwin);
 	if (newwin < seg_num) {
 		abort_send(agent, mad_recv_wc, IB_MGMT_RMPP_STATUS_W2S);
 		nack_recv(agent, mad_recv_wc, IB_MGMT_RMPP_STATUS_W2S);
@@ -741,7 +741,7 @@ process_rmpp_data(struct ib_mad_agent_private *agent,
 	struct ib_rmpp_hdr *rmpp_hdr;
 	u8 rmpp_status;
 
-	rmpp_hdr = &((struct ib_rmpp_mad *)mad_recv_wc->recv_buf.mad)->rmpp_hdr;
+	rmpp_hdr = &((struct ib_rmpp_base *)mad_recv_wc->recv_buf.mad)->rmpp_hdr;
 
 	if (rmpp_hdr->rmpp_status) {
 		rmpp_status = IB_MGMT_RMPP_STATUS_BAD_STATUS;
@@ -770,30 +770,30 @@ bad:
 static void process_rmpp_stop(struct ib_mad_agent_private *agent,
 			      struct ib_mad_recv_wc *mad_recv_wc)
 {
-	struct ib_rmpp_mad *rmpp_mad;
+	struct ib_rmpp_base *rmpp_base;
 
-	rmpp_mad = (struct ib_rmpp_mad *)mad_recv_wc->recv_buf.mad;
+	rmpp_base = (struct ib_rmpp_base *)mad_recv_wc->recv_buf.mad;
 
-	if (rmpp_mad->rmpp_hdr.rmpp_status != IB_MGMT_RMPP_STATUS_RESX) {
+	if (rmpp_base->rmpp_hdr.rmpp_status != IB_MGMT_RMPP_STATUS_RESX) {
 		abort_send(agent, mad_recv_wc, IB_MGMT_RMPP_STATUS_BAD_STATUS);
 		nack_recv(agent, mad_recv_wc, IB_MGMT_RMPP_STATUS_BAD_STATUS);
 	} else
-		abort_send(agent, mad_recv_wc, rmpp_mad->rmpp_hdr.rmpp_status);
+		abort_send(agent, mad_recv_wc, rmpp_base->rmpp_hdr.rmpp_status);
 }
 
 static void process_rmpp_abort(struct ib_mad_agent_private *agent,
 			       struct ib_mad_recv_wc *mad_recv_wc)
 {
-	struct ib_rmpp_mad *rmpp_mad;
+	struct ib_rmpp_base *rmpp_base;
 
-	rmpp_mad = (struct ib_rmpp_mad *)mad_recv_wc->recv_buf.mad;
+	rmpp_base = (struct ib_rmpp_base *)mad_recv_wc->recv_buf.mad;
 
-	if (rmpp_mad->rmpp_hdr.rmpp_status < IB_MGMT_RMPP_STATUS_ABORT_MIN ||
-	    rmpp_mad->rmpp_hdr.rmpp_status > IB_MGMT_RMPP_STATUS_ABORT_MAX) {
+	if (rmpp_base->rmpp_hdr.rmpp_status < IB_MGMT_RMPP_STATUS_ABORT_MIN ||
+	    rmpp_base->rmpp_hdr.rmpp_status > IB_MGMT_RMPP_STATUS_ABORT_MAX) {
 		abort_send(agent, mad_recv_wc, IB_MGMT_RMPP_STATUS_BAD_STATUS);
 		nack_recv(agent, mad_recv_wc, IB_MGMT_RMPP_STATUS_BAD_STATUS);
 	} else
-		abort_send(agent, mad_recv_wc, rmpp_mad->rmpp_hdr.rmpp_status);
+		abort_send(agent, mad_recv_wc, rmpp_base->rmpp_hdr.rmpp_status);
 }
 
 struct ib_mad_recv_wc *
@@ -803,16 +803,16 @@ ib_process_rmpp_recv_wc(struct ib_mad_agent_private *agent,
 	struct ib_rmpp_mad *rmpp_mad;
 
 	rmpp_mad = (struct ib_rmpp_mad *)mad_recv_wc->recv_buf.mad;
-	if (!(rmpp_mad->rmpp_hdr.rmpp_rtime_flags & IB_MGMT_RMPP_FLAG_ACTIVE))
+	if (!(rmpp_mad->base.rmpp_hdr.rmpp_rtime_flags & IB_MGMT_RMPP_FLAG_ACTIVE))
 		return mad_recv_wc;
 
-	if (rmpp_mad->rmpp_hdr.rmpp_version != IB_MGMT_RMPP_VERSION) {
+	if (rmpp_mad->base.rmpp_hdr.rmpp_version != IB_MGMT_RMPP_VERSION) {
 		abort_send(agent, mad_recv_wc, IB_MGMT_RMPP_STATUS_UNV);
 		nack_recv(agent, mad_recv_wc, IB_MGMT_RMPP_STATUS_UNV);
 		goto out;
 	}
 
-	switch (rmpp_mad->rmpp_hdr.rmpp_type) {
+	switch (rmpp_mad->base.rmpp_hdr.rmpp_type) {
 	case IB_MGMT_RMPP_TYPE_DATA:
 		return process_rmpp_data(agent, mad_recv_wc);
 	case IB_MGMT_RMPP_TYPE_ACK:
@@ -873,11 +873,11 @@ int ib_send_rmpp_mad(struct ib_mad_send_wr_private *mad_send_wr)
 	int ret;
 
 	rmpp_mad = mad_send_wr->send_buf.mad;
-	if (!(ib_get_rmpp_flags(&rmpp_mad->rmpp_hdr) &
+	if (!(ib_get_rmpp_flags(&rmpp_mad->base.rmpp_hdr) &
 	      IB_MGMT_RMPP_FLAG_ACTIVE))
 		return IB_RMPP_RESULT_UNHANDLED;
 
-	if (rmpp_mad->rmpp_hdr.rmpp_type != IB_MGMT_RMPP_TYPE_DATA) {
+	if (rmpp_mad->base.rmpp_hdr.rmpp_type != IB_MGMT_RMPP_TYPE_DATA) {
 		mad_send_wr->seg_num = 1;
 		return IB_RMPP_RESULT_INTERNAL;
 	}
@@ -895,15 +895,15 @@ int ib_send_rmpp_mad(struct ib_mad_send_wr_private *mad_send_wr)
 int ib_process_rmpp_send_wc(struct ib_mad_send_wr_private *mad_send_wr,
 			    struct ib_mad_send_wc *mad_send_wc)
 {
-	struct ib_rmpp_mad *rmpp_mad;
+	struct ib_rmpp_base *rmpp_base;
 	int ret;
 
-	rmpp_mad = mad_send_wr->send_buf.mad;
-	if (!(ib_get_rmpp_flags(&rmpp_mad->rmpp_hdr) &
+	rmpp_base = mad_send_wr->send_buf.mad;
+	if (!(ib_get_rmpp_flags(&rmpp_base->rmpp_hdr) &
 	      IB_MGMT_RMPP_FLAG_ACTIVE))
 		return IB_RMPP_RESULT_UNHANDLED; /* RMPP not active */
 
-	if (rmpp_mad->rmpp_hdr.rmpp_type != IB_MGMT_RMPP_TYPE_DATA)
+	if (rmpp_base->rmpp_hdr.rmpp_type != IB_MGMT_RMPP_TYPE_DATA)
 		return IB_RMPP_RESULT_INTERNAL;	 /* ACK, STOP, or ABORT */
 
 	if (mad_send_wc->status != IB_WC_SUCCESS ||
@@ -933,11 +933,11 @@ int ib_process_rmpp_send_wc(struct ib_mad_send_wr_private *mad_send_wr,
 
 int ib_retry_rmpp(struct ib_mad_send_wr_private *mad_send_wr)
 {
-	struct ib_rmpp_mad *rmpp_mad;
+	struct ib_rmpp_base *rmpp_base;
 	int ret;
 
-	rmpp_mad = mad_send_wr->send_buf.mad;
-	if (!(ib_get_rmpp_flags(&rmpp_mad->rmpp_hdr) &
+	rmpp_base = mad_send_wr->send_buf.mad;
+	if (!(ib_get_rmpp_flags(&rmpp_base->rmpp_hdr) &
 	      IB_MGMT_RMPP_FLAG_ACTIVE))
 		return IB_RMPP_RESULT_UNHANDLED; /* RMPP not active */
 
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 9628494..ac33d34 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -448,7 +448,7 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 	struct ib_mad_agent *agent;
 	struct ib_ah_attr ah_attr;
 	struct ib_ah *ah;
-	struct ib_rmpp_mad *rmpp_mad;
+	struct ib_rmpp_base *rmpp_base;
 	__be64 *tid;
 	int ret, data_len, hdr_len, copy_offset, rmpp_active;
 
@@ -504,13 +504,13 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 		goto err_up;
 	}
 
-	rmpp_mad = (struct ib_rmpp_mad *) packet->mad.data;
-	hdr_len = ib_get_mad_data_offset(rmpp_mad->mad_hdr.mgmt_class);
+	rmpp_base = (struct ib_rmpp_base *) packet->mad.data;
+	hdr_len = ib_get_mad_data_offset(rmpp_base->mad_hdr.mgmt_class);
 
-	if (ib_is_mad_class_rmpp(rmpp_mad->mad_hdr.mgmt_class)
+	if (ib_is_mad_class_rmpp(rmpp_base->mad_hdr.mgmt_class)
 	    && ib_mad_kernel_rmpp_agent(agent)) {
 		copy_offset = IB_MGMT_RMPP_HDR;
-		rmpp_active = ib_get_rmpp_flags(&rmpp_mad->rmpp_hdr) &
+		rmpp_active = ib_get_rmpp_flags(&rmpp_base->rmpp_hdr) &
 						IB_MGMT_RMPP_FLAG_ACTIVE;
 	} else {
 		copy_offset = IB_MGMT_MAD_HDR;
@@ -558,12 +558,12 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 		tid = &((struct ib_mad_hdr *) packet->msg->mad)->tid;
 		*tid = cpu_to_be64(((u64) agent->hi_tid) << 32 |
 				   (be64_to_cpup(tid) & 0xffffffff));
-		rmpp_mad->mad_hdr.tid = *tid;
+		rmpp_base->mad_hdr.tid = *tid;
 	}
 
 	if (!ib_mad_kernel_rmpp_agent(agent)
-	   && ib_is_mad_class_rmpp(rmpp_mad->mad_hdr.mgmt_class)
-	   && (ib_get_rmpp_flags(&rmpp_mad->rmpp_hdr) & IB_MGMT_RMPP_FLAG_ACTIVE)) {
+	   && ib_is_mad_class_rmpp(rmpp_base->mad_hdr.mgmt_class)
+	   && (ib_get_rmpp_flags(&rmpp_base->rmpp_hdr) & IB_MGMT_RMPP_FLAG_ACTIVE)) {
 		spin_lock_irq(&file->send_lock);
 		list_add_tail(&packet->list, &file->send_list);
 		spin_unlock_irq(&file->send_lock);
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index 00a5e51..80e7cf4 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -136,6 +136,11 @@ enum {
 	IB_MGMT_DEVICE_HDR = 64,
 	IB_MGMT_DEVICE_DATA = 192,
 	IB_MGMT_MAD_SIZE = IB_MGMT_MAD_HDR + IB_MGMT_MAD_DATA,
+	JUMBO_MGMT_MAD_HDR = IB_MGMT_MAD_HDR,
+	JUMBO_MGMT_MAD_DATA = 2024,
+	JUMBO_MGMT_RMPP_HDR = IB_MGMT_RMPP_HDR,
+	JUMBO_MGMT_RMPP_DATA = 2012,
+	JUMBO_MGMT_MAD_SIZE = JUMBO_MGMT_MAD_HDR + JUMBO_MGMT_MAD_DATA,
 };
 
 struct ib_mad_hdr {
@@ -182,12 +187,26 @@ struct ib_mad {
 	u8			data[IB_MGMT_MAD_DATA];
 };
 
-struct ib_rmpp_mad {
+struct jumbo_mad {
+	struct ib_mad_hdr	mad_hdr;
+	u8			data[JUMBO_MGMT_MAD_DATA];
+};
+
+struct ib_rmpp_base {
 	struct ib_mad_hdr	mad_hdr;
 	struct ib_rmpp_hdr	rmpp_hdr;
+} __packed;
+
+struct ib_rmpp_mad {
+	struct ib_rmpp_base	base;
 	u8			data[IB_MGMT_RMPP_DATA];
 };
 
+struct jumbo_rmpp_mad {
+	struct ib_rmpp_base	base;
+	u8			data[JUMBO_MGMT_RMPP_DATA];
+};
+
 struct ib_sa_mad {
 	struct ib_mad_hdr	mad_hdr;
 	struct ib_rmpp_hdr	rmpp_hdr;
@@ -402,7 +421,10 @@ struct ib_mad_send_wc {
 struct ib_mad_recv_buf {
 	struct list_head	list;
 	struct ib_grh		*grh;
-	struct ib_mad		*mad;
+	union {
+		struct ib_mad		*mad;
+		struct jumbo_mad	*jumbo_mad;
+	};
 };
 
 /**
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
