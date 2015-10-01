From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 4/5 RFC] IB/mad: Add umad trace points
Date: Thu,  1 Oct 2015 00:51:28 -0400
Message-ID: <1443675089-11786-5-git-send-email-ira.weiny@intel.com>
References: <1443675089-11786-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443675089-11786-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org, xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This could potentially benefit from a read trace point.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/user_mad.c |   5 +
 include/trace/events/ib_umad.h     | 312 +++++++++++++++++++++++++++++++++++++
 2 files changed, 317 insertions(+)
 create mode 100644 include/trace/events/ib_umad.h

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 57f281f8d686..4b53f4c70cdc 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -125,6 +125,9 @@ struct ib_umad_packet {
 	struct ib_user_mad mad;
 };
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/ib_umad.h>
+
 static struct class *umad_class;
 
 static const dev_t base_dev = MKDEV(IB_UMAD_MAJOR, IB_UMAD_MINOR_BASE);
@@ -481,6 +484,8 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 
 	mutex_lock(&file->mutex);
 
+	trace_ib_umad_write(file, &packet->mad);
+
 	agent = __get_agent(file, packet->mad.hdr.id);
 	if (!agent) {
 		ret = -EINVAL;
diff --git a/include/trace/events/ib_umad.h b/include/trace/events/ib_umad.h
new file mode 100644
index 000000000000..2a1c052acb37
--- /dev/null
+++ b/include/trace/events/ib_umad.h
@@ -0,0 +1,312 @@
+/*
+ * Copyright (c) 2015 Intel Corporation.  All rights reserved.
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
+#define TRACE_SYSTEM ib_umad
+
+#if !defined(_TRACE_IB_UMAD_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_IB_UMAD_H
+
+#include <linux/tracepoint.h>
+
+DECLARE_EVENT_CLASS(ib_umad_write_template,
+	TP_PROTO(struct ib_umad_file *file, struct ib_user_mad *mad),
+	TP_ARGS(file, mad),
+
+	TP_STRUCT__entry(
+		__array(char,           dev_name, IB_DEVICE_NAME_MAX )
+		__field(u8,             port_num                     )
+
+		__field(u32,            id                           )
+		__field(u32,            status                       )
+		__field(u32,            timeout_ms                   )
+		__field(u32,            retires                      )
+		__field(u32,            length                       )
+		__field(u32,            qpn                          )
+		__field(u32,            qkey                         )
+		__field(u16,            lid                          )
+		__field(u8,             sl                           )
+		__field(u8,             path_bits                    )
+		__field(u8,             grh_present                  )
+		__field(u8,             gid_index                    )
+		__field(u8,             hop_limit                    )
+		__field(u8,             traffic_class                )
+		__array(u8,             gid, 16                      )
+		__field(u32,            flow_label                   )
+		__field(u16,            pkey_index                   )
+
+		__field(u8,             base_version                 )
+		__field(u8,             mgmt_class                   )
+		__field(u8,             class_version                )
+		__field(u8,             method                       )
+		__field(u16,            mad_status                   )
+		__field(u16,            class_specific               )
+		__field(u64,            tid                          )
+		__field(u16,            attr_id                      )
+		__field(u32,            attr_mod                     )
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->dev_name, file->port->ib_dev->name, IB_DEVICE_NAME_MAX);
+		__entry->port_num = file->port->port_num;
+
+		__entry->id = mad->hdr.id;
+		__entry->status = mad->hdr.status;
+		__entry->timeout_ms = mad->hdr.timeout_ms;
+		__entry->retires = mad->hdr.retries;
+		__entry->length = mad->hdr.length;
+		__entry->qpn = mad->hdr.qpn;
+		__entry->qkey = mad->hdr.qkey;
+		__entry->lid = mad->hdr.lid;
+		__entry->sl = mad->hdr.sl;
+		__entry->path_bits = mad->hdr.path_bits;
+		__entry->grh_present = mad->hdr.grh_present;
+		__entry->gid_index = mad->hdr.gid_index;
+		__entry->hop_limit = mad->hdr.hop_limit;
+		__entry->traffic_class = mad->hdr.traffic_class;
+		/* FIXME Byte reversed???  better way to handle this??? */
+		memcpy(__entry->gid, mad->hdr.gid, sizeof(mad->hdr.gid));
+		__entry->flow_label = mad->hdr.flow_label;
+		__entry->pkey_index = mad->hdr.pkey_index;
+
+		__entry->base_version = ((struct ib_mad_hdr *)mad->data)->base_version;
+		__entry->mgmt_class = ((struct ib_mad_hdr *)mad->data)->mgmt_class;
+		__entry->class_version = ((struct ib_mad_hdr *)mad->data)->class_version;
+		__entry->method = ((struct ib_mad_hdr *)mad->data)->method;
+		__entry->mad_status = ((struct ib_mad_hdr *)mad->data)->status;
+		__entry->class_specific = ((struct ib_mad_hdr *)mad->data)->class_specific;
+		__entry->tid = ((struct ib_mad_hdr *)mad->data)->tid;
+		__entry->attr_id = ((struct ib_mad_hdr *)mad->data)->attr_id;
+		__entry->attr_mod = ((struct ib_mad_hdr *)mad->data)->attr_mod;
+	),
+
+/* FIXME go back and convert the other mad tracepoints to do the byte swap in
+ * the print. */
+	TP_printk("%s:%d umad_hdr: id %u status 0x%04x ms %u ret %u len %u QP%u " \
+		  "qkey 0x%08x lid 0x%04x sl %u path_bits 0x%x grh 0x%x gidi %u " \
+		  "hop_lim %u traf_cl %u gid %pI6c flow 0x%08x pkeyi %u  " \
+		  "MAD: base_ver 0x%x class 0x%x class_ver 0x%x method 0x%x " \
+		  "status 0x%04x class_specific 0x%04x tid 0x%016llx attr_id 0x%04x attr_mod 0x%08x ",
+		__entry->dev_name, __entry->port_num,
+		__entry->id, __entry->status, __entry->timeout_ms,
+		__entry->retires, __entry->length, be32_to_cpu(__entry->qpn),
+		be32_to_cpu(__entry->qkey), be16_to_cpu(__entry->lid), __entry->sl,
+		__entry->path_bits, __entry->grh_present, __entry->gid_index,
+		__entry->hop_limit, __entry->traffic_class, &__entry->gid,
+		be32_to_cpu(__entry->flow_label), __entry->pkey_index,
+		__entry->base_version, __entry->mgmt_class, __entry->class_version,
+		__entry->method, be16_to_cpu(__entry->mad_status), be16_to_cpu(__entry->class_specific),
+		be64_to_cpu(__entry->tid), be16_to_cpu(__entry->attr_id), be32_to_cpu(__entry->attr_mod)
+	)
+);
+
+DEFINE_EVENT(ib_umad_write_template, ib_umad_write,
+	TP_PROTO(struct ib_umad_file *file, struct ib_user_mad *mad),
+	TP_ARGS(file, mad));
+
+#if 0
+
+/* FIXME The below was copied from the ib_mad.h trace ... */
+
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
+		__field(u64,            atid                         )
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
+		__entry->atid = be64_to_cpu(wr->tid);
+		__entry->max_retries = wr->max_retries;
+		__entry->retries_left = wr->retries_left;
+		__entry->retry = wr->retry;
+		__entry->timeout = wr->timeout;
+		__entry->base_version = ((struct ib_mad_hdr *)wr->send_buf.mad)->base_version;
+		__entry->mgmt_class = ((struct ib_mad_hdr *)wr->send_buf.mad)->mgmt_class;
+		__entry->class_version = ((struct ib_mad_hdr *)wr->send_buf.mad)->class_version;
+		__entry->method = ((struct ib_mad_hdr *)wr->send_buf.mad)->method;
+		__entry->status = be16_to_cpu(((struct ib_mad_hdr *)wr->send_buf.mad)->status);
+		__entry->wc_status = wc->status;
+		__entry->length = wc->byte_len;
+	),
+
+	TP_printk("%s:%d QP%d : SEND WC Status %d : agent %p: " \
+		  "atid 0x%llx %d/%d retries(%d) timeout %lu length %d: " \
+		  "base_ver 0x%x class 0x%x class_ver 0x%x method 0x%x " \
+		  "status 0x%x",
+		__entry->dev_name, __entry->port_num, __entry->qp_num,
+		__entry->wc_status,
+		__entry->agent_priv, __entry->atid,
+		__entry->retries_left, __entry->max_retries,
+		__entry->retry, __entry->timeout,
+		__entry->length,
+		__entry->base_version, __entry->mgmt_class, __entry->class_version,
+		__entry->method, __entry->status
+	)
+);
+
+TRACE_EVENT(ib_mad_recv_done_handler,
+	TP_PROTO(struct ib_mad_qp_info *qp_info, struct ib_wc *wc, struct ib_mad_hdr *mad_hdr, u16 pkey),
+	TP_ARGS(qp_info, wc, mad_hdr, pkey),
+
+	TP_STRUCT__entry(
+		__array(char,           dev_name, IB_DEVICE_NAME_MAX )
+		__field(u8,             port_num                     )
+		__field(u32,            qp_num                       )
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
+		__field(u16,            slid                         )
+		__field(u16,            src_qp                       )
+		__field(u8,             sl                           )
+		__field(u16,            pkey                         )
+		__field(u16,            wc_status                    )
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->dev_name, qp_info->port_priv->device->name, IB_DEVICE_NAME_MAX);
+		__entry->port_num = qp_info->port_priv->port_num;
+		__entry->qp_num = qp_info->qp->qp_num;
+		__entry->length = wc->byte_len;
+		__entry->base_version = mad_hdr->base_version;
+		__entry->mgmt_class = mad_hdr->mgmt_class;
+		__entry->class_version = mad_hdr->class_version;
+		__entry->method = mad_hdr->method;
+		__entry->status = be16_to_cpu(mad_hdr->status);
+		__entry->class_specific = be16_to_cpu(mad_hdr->class_specific);
+		__entry->tid = be64_to_cpu(mad_hdr->tid);
+		__entry->attr_id = be16_to_cpu(mad_hdr->attr_id);
+		__entry->attr_mod = be32_to_cpu(mad_hdr->attr_mod);
+		__entry->slid = wc->slid;
+		__entry->src_qp = wc->src_qp;
+		__entry->sl = wc->sl;
+		__entry->pkey = pkey;
+		__entry->wc_status = wc->status;
+	),
+
+	TP_printk("%s:%d QP%d : RECV WC Status %d : length %d " \
+		  "base_ver 0x%02x class 0x%02x class_ver 0x%02x method 0x%02x " \
+		  "status 0x%04x class_specific 0x%04x tid 0x%016llx " \
+		  "attr_id 0x%04x attr_mod 0x%08x slid 0x%04x src QP%d, sl %d " \
+		  "pkey 0x%04x",
+		__entry->dev_name, __entry->port_num, __entry->qp_num,
+		__entry->wc_status,
+		__entry->length,
+		__entry->base_version, __entry->mgmt_class, __entry->class_version,
+		__entry->method, __entry->status, __entry->class_specific,
+		__entry->tid, __entry->attr_id, __entry->attr_mod,
+		__entry->slid, __entry->src_qp, __entry->sl, __entry->pkey
+	)
+);
+
+DECLARE_EVENT_CLASS(ib_mad_agent_template,
+	TP_PROTO(struct ib_mad_agent_private *agent),
+	TP_ARGS(agent),
+
+	TP_STRUCT__entry(
+		__field(void *,         agent_priv                   )
+		__array(char,           dev_name, IB_DEVICE_NAME_MAX )
+		__field(u32,            qp_num                       )
+		__field(u8,             port_num                     )
+		__field(u32,            hi_tid                       )
+		__field(u8,             mgmt_class                   )
+		__field(u8,             mgmt_class_version           )
+	),
+
+	TP_fast_assign(
+		__entry->agent_priv = agent;
+		memcpy(__entry->dev_name, agent->agent.device->name, IB_DEVICE_NAME_MAX);
+		__entry->qp_num = agent->qp_info->qp->qp_num;
+		__entry->port_num = agent->agent.port_num;
+		__entry->hi_tid = agent->agent.hi_tid;
+
+		__entry->mgmt_class = agent->reg_req->mgmt_class;
+		__entry->mgmt_class_version = agent->reg_req->mgmt_class_version;
+	),
+
+	TP_printk("%s:%d QP%d agent %p: " \
+		  "hi_tid 0x%08x class 0x%02x class_ver 0x%02x",
+		__entry->dev_name, __entry->port_num, __entry->qp_num, __entry->agent_priv,
+		__entry->hi_tid,
+		__entry->mgmt_class, __entry->mgmt_class_version
+	)
+);
+DEFINE_EVENT(ib_mad_agent_template, ib_mad_recv_done_agent,
+	TP_PROTO(struct ib_mad_agent_private *agent),
+	TP_ARGS(agent));
+DEFINE_EVENT(ib_mad_agent_template, ib_mad_create_agent,
+	TP_PROTO(struct ib_mad_agent_private *agent),
+	TP_ARGS(agent));
+DEFINE_EVENT(ib_mad_agent_template, ib_mad_unregister_agent,
+	TP_PROTO(struct ib_mad_agent_private *agent),
+	TP_ARGS(agent));
+
+#endif /* 0 */
+
+#endif /* _TRACE_IB_UMAD_H */
+
+#include <trace/define_trace.h>
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
