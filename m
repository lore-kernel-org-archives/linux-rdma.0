From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 02/14] IB/mad: Create an RMPP Base header
Date: Wed, 20 May 2015 04:13:23 -0400
Message-ID: <1432109615-19564-3-git-send-email-ira.weiny@intel.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432109615-19564-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

OPA RMPP MADs share the same RMPP base header as IB MADs.  Create a common
structure in anticipation of sharing that header with OPA MADs in a future
patch.

Update existing RMPP code to use the new base header.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c      |  18 +++---
 drivers/infiniband/core/mad_rmpp.c | 124 ++++++++++++++++++-------------------
 drivers/infiniband/core/user_mad.c |  16 ++---
 include/rdma/ib_mad.h              |   6 +-
 4 files changed, 84 insertions(+), 80 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index deefe5df9697..9cd4ce8dfbd0 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -873,7 +873,7 @@ static int alloc_send_rmpp_list(struct ib_mad_send_wr_private *send_wr,
 				gfp_t gfp_mask)
 {
 	struct ib_mad_send_buf *send_buf = &send_wr->send_buf;
-	struct ib_rmpp_mad *rmpp_mad = send_buf->mad;
+	struct ib_rmpp_base *rmpp_base = send_buf->mad;
 	struct ib_rmpp_segment *seg = NULL;
 	int left, seg_size, pad;
 
@@ -899,10 +899,10 @@ static int alloc_send_rmpp_list(struct ib_mad_send_wr_private *send_wr,
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
@@ -1737,14 +1737,14 @@ out:
 static int is_rmpp_data_mad(const struct ib_mad_agent_private *mad_agent_priv,
 			    const struct ib_mad_hdr *mad_hdr)
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
 
 static inline int rcv_has_same_class(const struct ib_mad_send_wr_private *wr,
@@ -1886,7 +1886,7 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 			spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
 			if (!ib_mad_kernel_rmpp_agent(&mad_agent_priv->agent)
 			   && ib_is_mad_class_rmpp(mad_recv_wc->recv_buf.mad->mad_hdr.mgmt_class)
-			   && (ib_get_rmpp_flags(&((struct ib_rmpp_mad *)mad_recv_wc->recv_buf.mad)->rmpp_hdr)
+			   && (ib_get_rmpp_flags(&((struct ib_rmpp_base *)mad_recv_wc->recv_buf.mad)->rmpp_hdr)
 					& IB_MGMT_RMPP_FLAG_ACTIVE)) {
 				/* user rmpp is in effect
 				 * and this is an active RMPP MAD
diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index f37878c9c06e..13279826342f 100644
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
@@ -143,7 +143,7 @@ static void ack_recv(struct mad_rmpp_recv *rmpp_recv,
 	if (IS_ERR(msg))
 		return;
 
-	format_ack(msg, (struct ib_rmpp_mad *) recv_wc->recv_buf.mad, rmpp_recv);
+	format_ack(msg, (struct ib_rmpp_base *) recv_wc->recv_buf.mad, rmpp_recv);
 	msg->ah = rmpp_recv->ah;
 	ret = ib_post_send_mad(msg, NULL);
 	if (ret)
@@ -180,20 +180,20 @@ static void ack_ds_ack(struct ib_mad_agent_private *agent,
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
@@ -213,23 +213,23 @@ static void nack_recv(struct ib_mad_agent_private *agent,
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
@@ -371,18 +371,18 @@ insert_rmpp_recv(struct ib_mad_agent_private *agent,
 
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
@@ -429,14 +429,14 @@ static void update_seg_num(struct mad_rmpp_recv *rmpp_recv,
 
 static inline int get_mad_len(struct mad_rmpp_recv *rmpp_recv)
 {
-	struct ib_rmpp_mad *rmpp_mad;
+	struct ib_rmpp_base *rmpp_base;
 	int hdr_size, data_size, pad;
 
-	rmpp_mad = (struct ib_rmpp_mad *)rmpp_recv->cur_seg_buf->mad;
+	rmpp_base = (struct ib_rmpp_base *)rmpp_recv->cur_seg_buf->mad;
 
-	hdr_size = ib_get_mad_data_offset(rmpp_mad->mad_hdr.mgmt_class);
+	hdr_size = ib_get_mad_data_offset(rmpp_base->mad_hdr.mgmt_class);
 	data_size = sizeof(struct ib_rmpp_mad) - hdr_size;
-	pad = IB_MGMT_RMPP_DATA - be32_to_cpu(rmpp_mad->rmpp_hdr.paylen_newwin);
+	pad = IB_MGMT_RMPP_DATA - be32_to_cpu(rmpp_base->rmpp_hdr.paylen_newwin);
 	if (pad > IB_MGMT_RMPP_DATA || pad < 0)
 		pad = 0;
 
@@ -565,20 +565,20 @@ static int send_next_seg(struct ib_mad_send_wr_private *mad_send_wr)
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
@@ -642,19 +642,19 @@ static void process_rmpp_ack(struct ib_mad_agent_private *agent,
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
@@ -739,7 +739,7 @@ process_rmpp_data(struct ib_mad_agent_private *agent,
 	struct ib_rmpp_hdr *rmpp_hdr;
 	u8 rmpp_status;
 
-	rmpp_hdr = &((struct ib_rmpp_mad *)mad_recv_wc->recv_buf.mad)->rmpp_hdr;
+	rmpp_hdr = &((struct ib_rmpp_base *)mad_recv_wc->recv_buf.mad)->rmpp_hdr;
 
 	if (rmpp_hdr->rmpp_status) {
 		rmpp_status = IB_MGMT_RMPP_STATUS_BAD_STATUS;
@@ -768,30 +768,30 @@ bad:
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
@@ -801,16 +801,16 @@ ib_process_rmpp_recv_wc(struct ib_mad_agent_private *agent,
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
@@ -871,11 +871,11 @@ int ib_send_rmpp_mad(struct ib_mad_send_wr_private *mad_send_wr)
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
@@ -893,15 +893,15 @@ int ib_send_rmpp_mad(struct ib_mad_send_wr_private *mad_send_wr)
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
@@ -931,11 +931,11 @@ int ib_process_rmpp_send_wc(struct ib_mad_send_wr_private *mad_send_wr,
 
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
index e58d701b7791..acff2f4bb6dd 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -447,7 +447,7 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 	struct ib_mad_agent *agent;
 	struct ib_ah_attr ah_attr;
 	struct ib_ah *ah;
-	struct ib_rmpp_mad *rmpp_mad;
+	struct ib_rmpp_base *rmpp_base;
 	__be64 *tid;
 	int ret, data_len, hdr_len, copy_offset, rmpp_active;
 
@@ -503,13 +503,13 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
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
@@ -556,12 +556,12 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
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
index c0ea51f90a03..1b37b493b2b4 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -181,9 +181,13 @@ struct ib_mad {
 	u8			data[IB_MGMT_MAD_DATA];
 };
 
-struct ib_rmpp_mad {
+struct ib_rmpp_base {
 	struct ib_mad_hdr	mad_hdr;
 	struct ib_rmpp_hdr	rmpp_hdr;
+} __packed;
+
+struct ib_rmpp_mad {
+	struct ib_rmpp_base	base;
 	u8			data[IB_MGMT_RMPP_DATA];
 };
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
