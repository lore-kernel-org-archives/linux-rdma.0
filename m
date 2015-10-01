From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 5/5 RFC] IB/mad: Add SMP tracing
Date: Thu,  1 Oct 2015 00:51:29 -0400
Message-ID: <1443675089-11786-6-git-send-email-ira.weiny@intel.com>
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
 drivers/infiniband/core/mad.c |  8 ++++
 include/trace/events/ib_mad.h | 90 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 189404194470..6ff87fcc6aea 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -604,6 +604,8 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	if (opa && smp->class_version == OPA_SMP_CLASS_VERSION) {
 		u32 opa_drslid;
 
+		trace_ib_mad_handle_out_opa_smi(opa_smp);
+
 		if ((opa_get_smp_direction(opa_smp)
 		     ? opa_smp->route.dr.dr_dlid : opa_smp->route.dr.dr_slid) ==
 		     OPA_LID_PERMISSIVE &&
@@ -629,6 +631,8 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 		    opa_smi_check_local_returning_smp(opa_smp, device) == IB_SMI_DISCARD)
 			goto out;
 	} else {
+		trace_ib_mad_handle_out_ib_smi(smp);
+
 		if ((ib_get_smp_direction(smp) ? smp->dr_dlid : smp->dr_slid) ==
 		     IB_LID_PERMISSIVE &&
 		     smi_handle_dr_smp_send(smp, rdma_cap_ib_switch(device), port_num) ==
@@ -1858,6 +1862,8 @@ static enum smi_action handle_ib_smi(const struct ib_mad_port_private *port_priv
 	enum smi_forward_action retsmi;
 	struct ib_smp *smp = (struct ib_smp *)recv->mad;
 
+	trace_ib_mad_handle_ib_smi(smp);
+
 	if (smi_handle_dr_smp_recv(smp,
 				   rdma_cap_ib_switch(port_priv->device),
 				   port_num,
@@ -1943,6 +1949,8 @@ handle_opa_smi(struct ib_mad_port_private *port_priv,
 	enum smi_forward_action retsmi;
 	struct opa_smp *smp = (struct opa_smp *)recv->mad;
 
+	trace_ib_mad_handle_opa_smi(smp);
+
 	if (opa_smi_handle_dr_smp_recv(smp,
 				   rdma_cap_ib_switch(port_priv->device),
 				   port_num,
diff --git a/include/trace/events/ib_mad.h b/include/trace/events/ib_mad.h
index 3ac94636784b..8312eb1e7daf 100644
--- a/include/trace/events/ib_mad.h
+++ b/include/trace/events/ib_mad.h
@@ -290,6 +290,96 @@ DEFINE_EVENT(ib_mad_agent_template, ib_mad_unregister_agent,
 	TP_ARGS(agent));
 
 
+
+DECLARE_EVENT_CLASS(ib_mad_opa_smi_template,
+	TP_PROTO(struct opa_smp *smp),
+	TP_ARGS(smp),
+
+	TP_STRUCT__entry(
+		__field(u8,             hop_ptr                             )
+		__field(u8,             hop_cnt                             )
+		__field(u64,            mkey                                )
+		__field(u32,            dr_slid                             )
+		__field(u32,            dr_dlid                             )
+		__array(u8,             initial_path, OPA_SMP_MAX_PATH_HOPS )
+		__array(u8,             return_path, OPA_SMP_MAX_PATH_HOPS  )
+	),
+
+	TP_fast_assign(
+		__entry->hop_ptr = smp->hop_ptr;
+		__entry->hop_cnt = smp->hop_cnt;
+		__entry->mkey = smp->mkey;
+		__entry->dr_slid = smp->route.dr.dr_slid;
+		__entry->dr_dlid = smp->route.dr.dr_dlid;
+		memcpy(__entry->initial_path, smp->route.dr.initial_path,
+			OPA_SMP_MAX_PATH_HOPS);
+		memcpy(__entry->return_path, smp->route.dr.return_path,
+			OPA_SMP_MAX_PATH_HOPS);
+	),
+
+	TP_printk("OPA SMP: hop_ptr %d hop_cnt %d " \
+		  "mkey 0x%016llx dr_slid 0x%08x dr_dlid 0x%08x " \
+		  "initial_path %*ph return_path %*ph ",
+		__entry->hop_ptr, __entry->hop_cnt,
+		be64_to_cpu(__entry->mkey), be32_to_cpu(__entry->dr_slid),
+		be32_to_cpu(__entry->dr_dlid),
+		OPA_SMP_MAX_PATH_HOPS, __entry->initial_path,
+		OPA_SMP_MAX_PATH_HOPS, __entry->return_path
+	)
+);
+
+DEFINE_EVENT(ib_mad_opa_smi_template, ib_mad_handle_opa_smi,
+	TP_PROTO(struct opa_smp *smp),
+	TP_ARGS(smp));
+DEFINE_EVENT(ib_mad_opa_smi_template, ib_mad_handle_out_opa_smi,
+	TP_PROTO(struct opa_smp *smp),
+	TP_ARGS(smp));
+
+
+DECLARE_EVENT_CLASS(ib_mad_opa_ib_template,
+	TP_PROTO(struct ib_smp *smp),
+	TP_ARGS(smp),
+
+	TP_STRUCT__entry(
+		__field(u8,             hop_ptr                             )
+		__field(u8,             hop_cnt                             )
+		__field(u64,            mkey                                )
+		__field(u32,            dr_slid                             )
+		__field(u32,            dr_dlid                             )
+		__array(u8,             initial_path, IB_SMP_MAX_PATH_HOPS  )
+		__array(u8,             return_path, IB_SMP_MAX_PATH_HOPS   )
+	),
+
+	TP_fast_assign(
+		__entry->hop_ptr = smp->hop_ptr;
+		__entry->hop_cnt = smp->hop_cnt;
+		__entry->mkey = smp->mkey;
+		__entry->dr_slid = smp->dr_slid;
+		__entry->dr_dlid = smp->dr_dlid;
+		memcpy(__entry->initial_path, smp->initial_path,
+			IB_SMP_MAX_PATH_HOPS);
+		memcpy(__entry->return_path, smp->return_path,
+			IB_SMP_MAX_PATH_HOPS);
+	),
+
+	TP_printk("OPA SMP: hop_ptr %d hop_cnt %d " \
+		  "mkey 0x%016llx dr_slid 0x%04x dr_dlid 0x%04x " \
+		  "initial_path %*ph return_path %*ph ",
+		__entry->hop_ptr, __entry->hop_cnt,
+		be64_to_cpu(__entry->mkey), be16_to_cpu(__entry->dr_slid),
+		be16_to_cpu(__entry->dr_dlid),
+		IB_SMP_MAX_PATH_HOPS, __entry->initial_path,
+		IB_SMP_MAX_PATH_HOPS, __entry->return_path
+	)
+);
+
+DEFINE_EVENT(ib_mad_opa_ib_template, ib_mad_handle_ib_smi,
+	TP_PROTO(struct ib_smp *smp),
+	TP_ARGS(smp));
+DEFINE_EVENT(ib_mad_opa_ib_template, ib_mad_handle_out_ib_smi,
+	TP_PROTO(struct ib_smp *smp),
+	TP_ARGS(smp));
+
 #endif /* _TRACE_IB_MAD_H */
 
 #include <trace/define_trace.h>
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
