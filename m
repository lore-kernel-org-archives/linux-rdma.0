From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH for-next 1/6] IB/MAD: Add send path trace points
Date: Fri, 31 Mar 2017 13:04:52 -0400
Message-ID: <1490979892-19031-2-git-send-email-ira.weiny@intel.com>
References: <1490979892-19031-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490979892-19031-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use the standard Linux trace mechanism to trace MADs being sent.  3 trace
points are added, when the MAD is posted to the qp, when the MAD is completed,
and when the MAD completes in error.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes since v1:
	move be64_to_cpu to print rather than fast assign
	Clean up trace statements
	Update copyright dates.
---
 drivers/infiniband/core/mad.c |  53 +++++++++++-
 include/trace/events/ib_mad.h | 191 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 243 insertions(+), 1 deletion(-)
 create mode 100644 include/trace/events/ib_mad.h

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index a009f7132c73..64f55bd85277 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2005 Intel Corporation.  All rights reserved.
  * Copyright (c) 2005 Mellanox Technologies Ltd.  All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
- * Copyright (c) 2014 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2014,2017 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -49,6 +49,31 @@
 #include "agent.h"
 #include "core_priv.h"
 
+struct ib_mad_addr {
+	u16 dlid;
+	u8 sl;
+	u16 pkey;
+	u32 rqpn;
+	u32 rqkey;
+};
+static void trace_create_mad_addr(struct ib_device *dev, u8 pnum,
+				  struct ib_ud_wr *wr,
+				  struct ib_mad_addr *addr)
+{
+	struct ib_ah_attr attr;
+
+	memset(&attr, 0, sizeof(attr));
+	ib_query_ah(wr->ah, &attr);
+
+	addr->dlid = attr.dlid;
+	addr->sl = attr.sl;
+	ib_query_pkey(dev, pnum, wr->pkey_index, &addr->pkey);
+	addr->rqpn = wr->remote_qpn;
+	addr->rqkey = wr->remote_qkey;
+}
+#define CREATE_TRACE_POINTS
+#include <trace/events/ib_mad.h>
+
 static int mad_sendq_size = IB_MAD_QP_SEND_SIZE;
 static int mad_recvq_size = IB_MAD_QP_RECV_SIZE;
 
@@ -1175,6 +1200,14 @@ int ib_send_mad(struct ib_mad_send_wr_private *mad_send_wr)
 
 	spin_lock_irqsave(&qp_info->send_queue.lock, flags);
 	if (qp_info->send_queue.count < qp_info->send_queue.max_active) {
+		if (trace_ib_mad_ib_send_mad_enabled()) {
+			struct ib_mad_addr addr;
+
+			trace_create_mad_addr(qp_info->port_priv->device,
+					      qp_info->port_priv->port_num,
+					      &mad_send_wr->send_wr, &addr);
+			trace_ib_mad_ib_send_mad(mad_send_wr, &addr);
+		}
 		ret = ib_post_send(mad_agent->qp, &mad_send_wr->send_wr.wr,
 				   &bad_send_wr);
 		list = &qp_info->send_queue.list;
@@ -2431,6 +2464,8 @@ static void ib_mad_send_done(struct ib_cq *cq, struct ib_wc *wc)
 	send_queue = mad_list->mad_queue;
 	qp_info = send_queue->qp_info;
 
+	trace_ib_mad_send_done_handler(mad_send_wr, wc);
+
 retry:
 	ib_dma_unmap_single(mad_send_wr->send_buf.mad_agent->device,
 			    mad_send_wr->header_mapping,
@@ -2462,6 +2497,14 @@ static void ib_mad_send_done(struct ib_cq *cq, struct ib_wc *wc)
 	ib_mad_complete_send_wr(mad_send_wr, &mad_send_wc);
 
 	if (queued_send_wr) {
+		if (trace_ib_mad_send_done_resend_enabled()) {
+			struct ib_mad_addr addr;
+
+			trace_create_mad_addr(qp_info->port_priv->device,
+					      qp_info->port_priv->port_num,
+					      &mad_send_wr->send_wr, &addr);
+			trace_ib_mad_send_done_resend(queued_send_wr, &addr);
+		}
 		ret = ib_post_send(qp_info->qp, &queued_send_wr->send_wr.wr,
 				   &bad_send_wr);
 		if (ret) {
@@ -2511,6 +2554,14 @@ static bool ib_mad_send_error(struct ib_mad_port_private *port_priv,
 			struct ib_send_wr *bad_send_wr;
 
 			mad_send_wr->retry = 0;
+			if (trace_ib_mad_mad_error_handler_enabled()) {
+				struct ib_mad_addr addr;
+
+				trace_create_mad_addr(qp_info->port_priv->device,
+						      qp_info->port_priv->port_num,
+						      &mad_send_wr->send_wr, &addr);
+				trace_ib_mad_mad_error_handler(mad_send_wr, &addr);
+			}
 			ret = ib_post_send(qp_info->qp, &mad_send_wr->send_wr.wr,
 					&bad_send_wr);
 			if (!ret)
diff --git a/include/trace/events/ib_mad.h b/include/trace/events/ib_mad.h
new file mode 100644
index 000000000000..0b7ed004a025
--- /dev/null
+++ b/include/trace/events/ib_mad.h
@@ -0,0 +1,191 @@
+/*
+ * Copyright (c) 2017 Intel Corporation.  All rights reserved.
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
+ *        disclaimer in the documentation and/or other materials
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
+ *
+ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ib_mad
+
+#if !defined(_TRACE_IB_MAD_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_IB_MAD_H
+
+#include <linux/tracepoint.h>
+#include <rdma/ib_mad.h>
+
+DECLARE_EVENT_CLASS(ib_mad_send_template,
+	TP_PROTO(struct ib_mad_send_wr_private *wr, struct ib_mad_addr *addr),
+	TP_ARGS(wr, addr),
+
+	TP_STRUCT__entry(
+		__array(char,           dev_name, IB_DEVICE_NAME_MAX )
+		__field(u8,             port_num                     )
+		__field(u32,            qp_num                       )
+		__field(void *,         agent_priv                   )
+		__field(u64,            wrtid                        )
+		__field(int,            retries_left                 )
+		__field(int,            max_retries                  )
+		__field(int,            retry                        )
+		__field(unsigned long,  timeout                      )
+		__field(u32,            length                       )
+		__field(u8,             base_version                 )
+		__field(u8,             mgmt_class                   )
+		__field(u8,             class_version                )
+		__field(u8,             method                       )
+		__field(u16,            status                       )
+		__field(u16,            class_specific               )
+		__field(u64,            tid                          )
+		__field(u16,            attr_id                      )
+		__field(u32,            attr_mod                     )
+		__field(u16,            dlid                         )
+		__field(u8,             sl                           )
+		__field(u16,            pkey                         )
+		__field(u32,            rqpn                         )
+		__field(u32,            rqkey                        )
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->dev_name, wr->mad_agent_priv->agent.device->name, IB_DEVICE_NAME_MAX);
+		__entry->port_num = wr->mad_agent_priv->agent.port_num;
+		__entry->qp_num = wr->mad_agent_priv->qp_info->qp->qp_num;
+		__entry->agent_priv = wr->mad_agent_priv;
+		__entry->wrtid = wr->tid;
+		__entry->max_retries = wr->max_retries;
+		__entry->retries_left = wr->retries_left;
+		__entry->retry = wr->retry;
+		__entry->timeout = wr->timeout;
+		__entry->length = wr->send_buf.hdr_len +
+				  wr->send_buf.data_len;
+		__entry->base_version = ((struct ib_mad_hdr *)wr->send_buf.mad)->base_version;
+		__entry->mgmt_class = ((struct ib_mad_hdr *)wr->send_buf.mad)->mgmt_class;
+		__entry->class_version = ((struct ib_mad_hdr *)wr->send_buf.mad)->class_version;
+		__entry->method = ((struct ib_mad_hdr *)wr->send_buf.mad)->method;
+		__entry->status = ((struct ib_mad_hdr *)wr->send_buf.mad)->status;
+		__entry->class_specific = ((struct ib_mad_hdr *)wr->send_buf.mad)->class_specific;
+		__entry->tid = ((struct ib_mad_hdr *)wr->send_buf.mad)->tid;
+		__entry->attr_id = ((struct ib_mad_hdr *)wr->send_buf.mad)->attr_id;
+		__entry->attr_mod = ((struct ib_mad_hdr *)wr->send_buf.mad)->attr_mod;
+		__entry->dlid = addr->dlid;
+		__entry->sl = addr->sl;
+		__entry->pkey = addr->pkey;
+		__entry->rqpn = addr->rqpn;
+		__entry->rqkey = addr->rqkey;
+	),
+
+	TP_printk("%s:%d QP%d agent %p: " \
+		  "wrtid 0x%llx; %d/%d retries(%d); timeout %lu length %d : hdr : " \
+		  "base_ver 0x%x class 0x%x class_ver 0x%x method 0x%x " \
+		  "status 0x%x class_specific 0x%x tid 0x%llx attr_id 0x%x attr_mod 0x%x " \
+		  " => dlid 0x%x sl %d pkey 0x%x rpqn 0x%x rqpkey 0x%x",
+		__entry->dev_name, __entry->port_num, __entry->qp_num,
+		__entry->agent_priv, be64_to_cpu(__entry->wrtid),
+		__entry->retries_left, __entry->max_retries,
+		__entry->retry, __entry->timeout, __entry->length,
+		__entry->base_version, __entry->mgmt_class, __entry->class_version,
+		__entry->method, be16_to_cpu(__entry->status),
+		be16_to_cpu(__entry->class_specific),
+		be64_to_cpu(__entry->tid), be16_to_cpu(__entry->attr_id),
+		be32_to_cpu(__entry->attr_mod),
+		be16_to_cpu(__entry->dlid), __entry->sl, __entry->pkey, __entry->rqpn,
+		__entry->rqkey
+	)
+);
+
+DEFINE_EVENT(ib_mad_send_template, ib_mad_mad_error_handler,
+	TP_PROTO(struct ib_mad_send_wr_private *wr, struct ib_mad_addr *addr),
+	TP_ARGS(wr, addr));
+DEFINE_EVENT(ib_mad_send_template, ib_mad_ib_send_mad,
+	TP_PROTO(struct ib_mad_send_wr_private *wr, struct ib_mad_addr *addr),
+	TP_ARGS(wr, addr));
+DEFINE_EVENT(ib_mad_send_template, ib_mad_send_done_resend,
+	TP_PROTO(struct ib_mad_send_wr_private *wr, struct ib_mad_addr *addr),
+	TP_ARGS(wr, addr));
+
+TRACE_EVENT(ib_mad_send_done_handler,
+	TP_PROTO(struct ib_mad_send_wr_private *wr, struct ib_wc *wc),
+	TP_ARGS(wr, wc),
+
+	TP_STRUCT__entry(
+		__array(char,           dev_name, IB_DEVICE_NAME_MAX )
+		__field(u8,             port_num                     )
+		__field(u32,            qp_num                       )
+		__field(void *,         agent_priv                   )
+		__field(u64,            wrtid                        )
+		__field(int,            retries_left                 )
+		__field(int,            max_retries                  )
+		__field(int,            retry                        )
+		__field(unsigned long,  timeout                      )
+		__field(u8,             base_version                 )
+		__field(u8,             mgmt_class                   )
+		__field(u8,             class_version                )
+		__field(u8,             method                       )
+		__field(u16,            status                       )
+		__field(u16,            wc_status                    )
+		__field(u32,            length                       )
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->dev_name, wr->mad_agent_priv->agent.device->name, IB_DEVICE_NAME_MAX);
+		__entry->port_num = wr->mad_agent_priv->agent.port_num;
+		__entry->qp_num = wr->mad_agent_priv->qp_info->qp->qp_num;
+		__entry->agent_priv = wr->mad_agent_priv;
+		__entry->wrtid = wr->tid;
+		__entry->max_retries = wr->max_retries;
+		__entry->retries_left = wr->retries_left;
+		__entry->retry = wr->retry;
+		__entry->timeout = wr->timeout;
+		__entry->base_version = ((struct ib_mad_hdr *)wr->send_buf.mad)->base_version;
+		__entry->mgmt_class = ((struct ib_mad_hdr *)wr->send_buf.mad)->mgmt_class;
+		__entry->class_version = ((struct ib_mad_hdr *)wr->send_buf.mad)->class_version;
+		__entry->method = ((struct ib_mad_hdr *)wr->send_buf.mad)->method;
+		__entry->status = ((struct ib_mad_hdr *)wr->send_buf.mad)->status;
+		__entry->wc_status = wc->status;
+		__entry->length = wc->byte_len;
+	),
+
+	TP_printk("%s:%d QP%d : SEND WC Status %d : agent %p: " \
+		  "wrtid 0x%llx %d/%d retries(%d) timeout %lu length %d: hdr : " \
+		  "base_ver 0x%x class 0x%x class_ver 0x%x method 0x%x " \
+		  "status 0x%x",
+		__entry->dev_name, __entry->port_num, __entry->qp_num,
+		__entry->wc_status,
+		__entry->agent_priv, be64_to_cpu(__entry->wrtid),
+		__entry->retries_left, __entry->max_retries,
+		__entry->retry, __entry->timeout,
+		__entry->length,
+		__entry->base_version, __entry->mgmt_class, __entry->class_version,
+		__entry->method, be16_to_cpu(__entry->status)
+	)
+);
+
+
+#endif /* _TRACE_IB_MAD_H */
+
+#include <trace/define_trace.h>
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
