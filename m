From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 01/14] IB/mad cleanup: Clean up function params -- find_mad_agent
Date: Sat,  6 Jun 2015 14:38:22 -0400
Message-ID: <1433615915-24591-2-git-send-email-ira.weiny@intel.com>
References: <1433615915-24591-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433615915-24591-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

find_mad_agent only needs read only access to the MAD header.  Update the
ib_mad pointer to be const ib_mad_hdr.  Adjust call tree.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 600af266838c..71cf3d51dad0 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -73,7 +73,7 @@ static int method_in_use(struct ib_mad_mgmt_method_table **method,
 static void remove_mad_reg_req(struct ib_mad_agent_private *priv);
 static struct ib_mad_agent_private *find_mad_agent(
 					struct ib_mad_port_private *port_priv,
-					struct ib_mad *mad);
+					const struct ib_mad_hdr *mad);
 static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 				    struct ib_mad_private *mad);
 static void cancel_mads(struct ib_mad_agent_private *mad_agent_priv);
@@ -813,7 +813,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 		if (port_priv) {
 			memcpy(&mad_priv->mad.mad, smp, sizeof(struct ib_mad));
 			recv_mad_agent = find_mad_agent(port_priv,
-						        &mad_priv->mad.mad);
+						        &mad_priv->mad.mad.mad_hdr);
 		}
 		if (!port_priv || !recv_mad_agent) {
 			/*
@@ -1324,7 +1324,7 @@ static int check_vendor_class(struct ib_mad_mgmt_vendor_class *vendor_class)
 }
 
 static int find_vendor_oui(struct ib_mad_mgmt_vendor_class *vendor_class,
-			   char *oui)
+			   const char *oui)
 {
 	int i;
 
@@ -1622,13 +1622,13 @@ out:
 
 static struct ib_mad_agent_private *
 find_mad_agent(struct ib_mad_port_private *port_priv,
-	       struct ib_mad *mad)
+	       const struct ib_mad_hdr *mad_hdr)
 {
 	struct ib_mad_agent_private *mad_agent = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(&port_priv->reg_lock, flags);
-	if (ib_response_mad(&mad->mad_hdr)) {
+	if (ib_response_mad(mad_hdr)) {
 		u32 hi_tid;
 		struct ib_mad_agent_private *entry;
 
@@ -1636,7 +1636,7 @@ find_mad_agent(struct ib_mad_port_private *port_priv,
 		 * Routing is based on high 32 bits of transaction ID
 		 * of MAD.
 		 */
-		hi_tid = be64_to_cpu(mad->mad_hdr.tid) >> 32;
+		hi_tid = be64_to_cpu(mad_hdr->tid) >> 32;
 		list_for_each_entry(entry, &port_priv->agent_list, agent_list) {
 			if (entry->agent.hi_tid == hi_tid) {
 				mad_agent = entry;
@@ -1648,45 +1648,45 @@ find_mad_agent(struct ib_mad_port_private *port_priv,
 		struct ib_mad_mgmt_method_table *method;
 		struct ib_mad_mgmt_vendor_class_table *vendor;
 		struct ib_mad_mgmt_vendor_class *vendor_class;
-		struct ib_vendor_mad *vendor_mad;
+		const struct ib_vendor_mad *vendor_mad;
 		int index;
 
 		/*
 		 * Routing is based on version, class, and method
 		 * For "newer" vendor MADs, also based on OUI
 		 */
-		if (mad->mad_hdr.class_version >= MAX_MGMT_VERSION)
+		if (mad_hdr->class_version >= MAX_MGMT_VERSION)
 			goto out;
-		if (!is_vendor_class(mad->mad_hdr.mgmt_class)) {
+		if (!is_vendor_class(mad_hdr->mgmt_class)) {
 			class = port_priv->version[
-					mad->mad_hdr.class_version].class;
+					mad_hdr->class_version].class;
 			if (!class)
 				goto out;
-			if (convert_mgmt_class(mad->mad_hdr.mgmt_class) >=
+			if (convert_mgmt_class(mad_hdr->mgmt_class) >=
 			    IB_MGMT_MAX_METHODS)
 				goto out;
 			method = class->method_table[convert_mgmt_class(
-							mad->mad_hdr.mgmt_class)];
+							mad_hdr->mgmt_class)];
 			if (method)
-				mad_agent = method->agent[mad->mad_hdr.method &
+				mad_agent = method->agent[mad_hdr->method &
 							  ~IB_MGMT_METHOD_RESP];
 		} else {
 			vendor = port_priv->version[
-					mad->mad_hdr.class_version].vendor;
+					mad_hdr->class_version].vendor;
 			if (!vendor)
 				goto out;
 			vendor_class = vendor->vendor_class[vendor_class_index(
-						mad->mad_hdr.mgmt_class)];
+						mad_hdr->mgmt_class)];
 			if (!vendor_class)
 				goto out;
 			/* Find matching OUI */
-			vendor_mad = (struct ib_vendor_mad *)mad;
+			vendor_mad = (const struct ib_vendor_mad *)mad_hdr;
 			index = find_vendor_oui(vendor_class, vendor_mad->oui);
 			if (index == -1)
 				goto out;
 			method = vendor_class->method_table[index];
 			if (method) {
-				mad_agent = method->agent[mad->mad_hdr.method &
+				mad_agent = method->agent[mad_hdr->method &
 							  ~IB_MGMT_METHOD_RESP];
 			}
 		}
@@ -2056,7 +2056,7 @@ local:
 		}
 	}
 
-	mad_agent = find_mad_agent(port_priv, &recv->mad.mad);
+	mad_agent = find_mad_agent(port_priv, &recv->mad.mad.mad_hdr);
 	if (mad_agent) {
 		ib_mad_complete_recv(mad_agent, &recv->header.recv_wc);
 		/*
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
