From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 3/5 RFC] IB/MAD Add agent trace points
Date: Thu,  1 Oct 2015 00:51:27 -0400
Message-ID: <1443675089-11786-4-git-send-email-ira.weiny@intel.com>
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
 drivers/infiniband/core/mad.c |  3 +++
 include/trace/events/ib_mad.h | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 0dc0ae78d313..189404194470 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -441,6 +441,7 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 	list_add_tail(&mad_agent_priv->agent_list, &port_priv->agent_list);
 	spin_unlock_irqrestore(&port_priv->reg_lock, flags);
 
+	trace_ib_mad_create_agent(mad_agent_priv);
 	return &mad_agent_priv->agent;
 
 error4:
@@ -465,6 +466,7 @@ static void unregister_mad_agent(struct ib_mad_agent_private *mad_agent_priv)
 	unsigned long flags;
 
 	/* Note that we could still be handling received MADs */
+	trace_ib_mad_unregister_agent(mad_agent_priv);
 
 	/*
 	 * Canceling all sends results in dropping received response
@@ -2112,6 +2114,7 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 
 	mad_agent = find_mad_agent(port_priv, (const struct ib_mad_hdr *)recv->mad);
 	if (mad_agent) {
+		trace_ib_mad_recv_done_agent(mad_agent);
 		ib_mad_complete_recv(mad_agent, &recv->header.recv_wc);
 		/*
 		 * recv is freed up in error cases in ib_mad_complete_recv
diff --git a/include/trace/events/ib_mad.h b/include/trace/events/ib_mad.h
index 8704bbc476bd..3ac94636784b 100644
--- a/include/trace/events/ib_mad.h
+++ b/include/trace/events/ib_mad.h
@@ -248,6 +248,47 @@ TRACE_EVENT(ib_mad_recv_done_handler,
 	)
 );
 
+DECLARE_EVENT_CLASS(ib_mad_agent_template,
+	TP_PROTO(struct ib_mad_agent_private *agent),
+	TP_ARGS(agent),
+
+	TP_STRUCT__entry(
+		__array(char,           dev_name, IB_DEVICE_NAME_MAX )
+		__field(u8,             port_num                     )
+		__field(u32,            hi_tid                       )
+		__field(u8,             mgmt_class                   )
+		__field(u8,             mgmt_class_version           )
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->dev_name, agent->agent.device->name, IB_DEVICE_NAME_MAX);
+		__entry->port_num = agent->agent.port_num;
+		__entry->hi_tid = agent->agent.hi_tid;
+
+		if (agent->reg_req) {
+			__entry->mgmt_class = agent->reg_req->mgmt_class;
+			__entry->mgmt_class_version = agent->reg_req->mgmt_class_version;
+		} else {
+			__entry->mgmt_class = 0;
+			__entry->mgmt_class_version = 0;
+		}
+	),
+
+	TP_printk("%s:%d hi_tid 0x%08x class 0x%02x class_ver 0x%02x",
+		__entry->dev_name, __entry->port_num,
+		__entry->hi_tid, __entry->mgmt_class, __entry->mgmt_class_version
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
 
 #endif /* _TRACE_IB_MAD_H */
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
