From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/5 RFC] IB/MAD: add recv path trace point
Date: Thu,  1 Oct 2015 00:51:26 -0400
Message-ID: <1443675089-11786-3-git-send-email-ira.weiny@intel.com>
References: <1443675089-11786-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443675089-11786-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org, xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c | 10 +++++++
 include/trace/events/ib_mad.h | 63 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 0631bff54755..0dc0ae78d313 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2051,6 +2051,16 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 	if (!validate_mad((const struct ib_mad_hdr *)recv->mad, qp_info, opa))
 		goto out;
 
+	if (trace_ib_mad_recv_done_handler_enabled()) {
+		u16 pkey;
+
+		ib_query_pkey(qp_info->port_priv->device, qp_info->port_priv->port_num,
+			      wc->pkey_index, &pkey);
+
+		trace_ib_mad_recv_done_handler(qp_info, wc, (struct ib_mad_hdr *)recv->mad,
+					       pkey);
+	}
+
 	mad_size = recv->mad_size;
 	response = alloc_mad_private(mad_size, GFP_KERNEL);
 	if (!response) {
diff --git a/include/trace/events/ib_mad.h b/include/trace/events/ib_mad.h
index 7e42ac35324a..8704bbc476bd 100644
--- a/include/trace/events/ib_mad.h
+++ b/include/trace/events/ib_mad.h
@@ -185,6 +185,69 @@ TRACE_EVENT(ib_mad_send_done_handler,
 	)
 );
 
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
+		__entry->status = mad_hdr->status;
+		__entry->class_specific = mad_hdr->class_specific;
+		__entry->tid = mad_hdr->tid;
+		__entry->attr_id = mad_hdr->attr_id;
+		__entry->attr_mod = mad_hdr->attr_mod;
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
+		__entry->method, be16_to_cpu(__entry->status),
+		be16_to_cpu(__entry->class_specific),
+		be64_to_cpu(__entry->tid), be16_to_cpu(__entry->attr_id),
+		be32_to_cpu(__entry->attr_mod),
+		__entry->slid, __entry->src_qp, __entry->sl, __entry->pkey
+	)
+);
+
 
 #endif /* _TRACE_IB_MAD_H */
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
