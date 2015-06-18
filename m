From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv2 RFC] IB: Add rdma_cap_ib_switch helper and use where appropriate
Date: Thu, 18 Jun 2015 19:25:32 -0400
Message-ID: <5583536C.3010504@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Persuant to Liran's comments on node_type on linux-rdma
mailing list:

In an effort to reform the RDMA core and ULPs to minimize use of
node_type in struct ib_device, an additional bit is added to
struct ib_device for is_switch (IB switch). This is needed 
to be initialized by any IB switch device driver. This is a 
NEW requirement on such device drivers which are all
"out of tree".

In addition, an ib_switch helper was added to ib_verbs.h
based on the is_switch device bit rather than node_type
(although those should be consistent).

The RDMA core (MAD, SMI, agent, sa_query, multicast, sysfs)
as well as (IPoIB and SRP) ULPs are updated where
appropriate to use this new helper. In some cases,
the helper is now used under the covers of using
rdma_[start end]_port rather than the open coding
previously used.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changes since v1:
Per Jason and Sean's comments, used Ira's rdma_[start end]_port
routines where needed and made those routines in ib_verbs.h 
use the new is_switch helper.

diff --git a/drivers/infiniband/core/agent.c b/drivers/infiniband/core/agent.c
index c7dcfe4..0429040 100644
--- a/drivers/infiniband/core/agent.c
+++ b/drivers/infiniband/core/agent.c
@@ -88,7 +88,7 @@ void agent_send_response(const struct ib_mad_hdr *mad_hdr, const struct ib_grh *
 	struct ib_ah *ah;
 	struct ib_mad_send_wr_private *mad_send_wr;
 
-	if (device->node_type == RDMA_NODE_IB_SWITCH)
+	if (rdma_cap_ib_switch(device))
 		port_priv = ib_get_agent_port(device, 0);
 	else
 		port_priv = ib_get_agent_port(device, port_num);
@@ -122,7 +122,7 @@ void agent_send_response(const struct ib_mad_hdr *mad_hdr, const struct ib_grh *
 	memcpy(send_buf->mad, mad_hdr, resp_mad_len);
 	send_buf->ah = ah;
 
-	if (device->node_type == RDMA_NODE_IB_SWITCH) {
+	if (rdma_cap_ib_switch(device)) {
 		mad_send_wr = container_of(send_buf,
 					   struct ib_mad_send_wr_private,
 					   send_buf);
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index a4b1466..c82d751 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -769,7 +769,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	bool opa = rdma_cap_opa_mad(mad_agent_priv->qp_info->port_priv->device,
 				    mad_agent_priv->qp_info->port_priv->port_num);
 
-	if (device->node_type == RDMA_NODE_IB_SWITCH &&
+	if (rdma_cap_ib_switch(device) &&
 	    smp->mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
 		port_num = send_wr->wr.ud.port_num;
 	else
@@ -787,7 +787,8 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 		if ((opa_get_smp_direction(opa_smp)
 		     ? opa_smp->route.dr.dr_dlid : opa_smp->route.dr.dr_slid) ==
 		     OPA_LID_PERMISSIVE &&
-		     opa_smi_handle_dr_smp_send(opa_smp, device->node_type,
+		     opa_smi_handle_dr_smp_send(opa_smp,
+						rdma_cap_ib_switch(device),
 						port_num) == IB_SMI_DISCARD) {
 			ret = -EINVAL;
 			dev_err(&device->dev, "OPA Invalid directed route\n");
@@ -810,7 +811,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	} else {
 		if ((ib_get_smp_direction(smp) ? smp->dr_dlid : smp->dr_slid) ==
 		     IB_LID_PERMISSIVE &&
-		     smi_handle_dr_smp_send(smp, device->node_type, port_num) ==
+		     smi_handle_dr_smp_send(smp, rdma_cap_ib_switch(device), port_num) ==
 		     IB_SMI_DISCARD) {
 			ret = -EINVAL;
 			dev_err(&device->dev, "Invalid directed route\n");
@@ -2030,7 +2031,7 @@ static enum smi_action handle_ib_smi(const struct ib_mad_port_private *port_priv
 	struct ib_smp *smp = (struct ib_smp *)recv->mad;
 
 	if (smi_handle_dr_smp_recv(smp,
-				   port_priv->device->node_type,
+				   rdma_cap_ib_switch(port_priv->device),
 				   port_num,
 				   port_priv->device->phys_port_cnt) ==
 				   IB_SMI_DISCARD)
@@ -2042,13 +2043,13 @@ static enum smi_action handle_ib_smi(const struct ib_mad_port_private *port_priv
 
 	if (retsmi == IB_SMI_SEND) { /* don't forward */
 		if (smi_handle_dr_smp_send(smp,
-					   port_priv->device->node_type,
+					   rdma_cap_ib_switch(port_priv->device),
 					   port_num) == IB_SMI_DISCARD)
 			return IB_SMI_DISCARD;
 
 		if (smi_check_local_smp(smp, port_priv->device) == IB_SMI_DISCARD)
 			return IB_SMI_DISCARD;
-	} else if (port_priv->device->node_type == RDMA_NODE_IB_SWITCH) {
+	} else if (rdma_cap_ib_switch(port_priv->device)) {
 		/* forward case for switches */
 		memcpy(response, recv, mad_priv_size(response));
 		response->header.recv_wc.wc = &response->header.wc;
@@ -2115,7 +2116,7 @@ handle_opa_smi(struct ib_mad_port_private *port_priv,
 	struct opa_smp *smp = (struct opa_smp *)recv->mad;
 
 	if (opa_smi_handle_dr_smp_recv(smp,
-				   port_priv->device->node_type,
+				   rdma_cap_ib_switch(port_priv->device),
 				   port_num,
 				   port_priv->device->phys_port_cnt) ==
 				   IB_SMI_DISCARD)
@@ -2127,7 +2128,7 @@ handle_opa_smi(struct ib_mad_port_private *port_priv,
 
 	if (retsmi == IB_SMI_SEND) { /* don't forward */
 		if (opa_smi_handle_dr_smp_send(smp,
-					   port_priv->device->node_type,
+					   rdma_cap_ib_switch(port_priv->device),
 					   port_num) == IB_SMI_DISCARD)
 			return IB_SMI_DISCARD;
 
@@ -2135,7 +2136,7 @@ handle_opa_smi(struct ib_mad_port_private *port_priv,
 		    IB_SMI_DISCARD)
 			return IB_SMI_DISCARD;
 
-	} else if (port_priv->device->node_type == RDMA_NODE_IB_SWITCH) {
+	} else if (rdma_cap_ib_switch(port_priv->device)) {
 		/* forward case for switches */
 		memcpy(response, recv, mad_priv_size(response));
 		response->header.recv_wc.wc = &response->header.wc;
@@ -2235,7 +2236,7 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 		goto out;
 	}
 
-	if (port_priv->device->node_type == RDMA_NODE_IB_SWITCH)
+	if (rdma_cap_ib_switch(port_priv->device))
 		port_num = wc->port_num;
 	else
 		port_num = port_priv->port_num;
@@ -3297,17 +3298,11 @@ static int ib_mad_port_close(struct ib_device *device, int port_num)
 
 static void ib_mad_init_device(struct ib_device *device)
 {
-	int start, end, i;
+	int start, i;
 
-	if (device->node_type == RDMA_NODE_IB_SWITCH) {
-		start = 0;
-		end   = 0;
-	} else {
-		start = 1;
-		end   = device->phys_port_cnt;
-	}
+	start = rdma_start_port(device);
 
-	for (i = start; i <= end; i++) {
+	for (i = start; i <= rdma_end_port(device); i++) {
 		if (!rdma_cap_ib_mad(device, i))
 			continue;
 
@@ -3342,17 +3337,9 @@ error:
 
 static void ib_mad_remove_device(struct ib_device *device)
 {
-	int start, end, i;
-
-	if (device->node_type == RDMA_NODE_IB_SWITCH) {
-		start = 0;
-		end   = 0;
-	} else {
-		start = 1;
-		end   = device->phys_port_cnt;
-	}
+	int i;
 
-	for (i = start; i <= end; i++) {
+	for (i = rdma_start_port(device); i <= rdma_end_port(device); i++) {
 		if (!rdma_cap_ib_mad(device, i))
 			continue;
 
diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index 1244f02..2cb865c 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -812,12 +812,8 @@ static void mcast_add_one(struct ib_device *device)
 	if (!dev)
 		return;
 
-	if (device->node_type == RDMA_NODE_IB_SWITCH)
-		dev->start_port = dev->end_port = 0;
-	else {
-		dev->start_port = 1;
-		dev->end_port = device->phys_port_cnt;
-	}
+	dev->start_port = rdma_start_port(device);
+	dev->end_port = rdma_end_port(device);
 
 	for (i = 0; i <= dev->end_port - dev->start_port; i++) {
 		if (!rdma_cap_ib_mcast(device, dev->start_port + i))
diff --git a/drivers/infiniband/core/opa_smi.h b/drivers/infiniband/core/opa_smi.h
index 62d91bf..3bfab35 100644
--- a/drivers/infiniband/core/opa_smi.h
+++ b/drivers/infiniband/core/opa_smi.h
@@ -39,12 +39,12 @@
 
 #include "smi.h"
 
-enum smi_action opa_smi_handle_dr_smp_recv(struct opa_smp *smp, u8 node_type,
+enum smi_action opa_smi_handle_dr_smp_recv(struct opa_smp *smp, bool is_switch,
 				       int port_num, int phys_port_cnt);
 int opa_smi_get_fwd_port(struct opa_smp *smp);
 extern enum smi_forward_action opa_smi_check_forward_dr_smp(struct opa_smp *smp);
 extern enum smi_action opa_smi_handle_dr_smp_send(struct opa_smp *smp,
-					      u8 node_type, int port_num);
+					      bool is_switch, int port_num);
 
 /*
  * Return IB_SMI_HANDLE if the SMP should be handled by the local SMA/SM
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 0fae850..ca919f4 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1156,12 +1156,8 @@ static void ib_sa_add_one(struct ib_device *device)
 	int s, e, i;
 	int count = 0;
 
-	if (device->node_type == RDMA_NODE_IB_SWITCH)
-		s = e = 0;
-	else {
-		s = 1;
-		e = device->phys_port_cnt;
-	}
+	s = rdma_start_port(device);
+	e = rdma_end_port(device);
 
 	sa_dev = kzalloc(sizeof *sa_dev +
 			 (e - s + 1) * sizeof (struct ib_sa_port),
diff --git a/drivers/infiniband/core/smi.c b/drivers/infiniband/core/smi.c
index 368a561..f19b238 100644
--- a/drivers/infiniband/core/smi.c
+++ b/drivers/infiniband/core/smi.c
@@ -41,7 +41,7 @@
 #include "smi.h"
 #include "opa_smi.h"
 
-static enum smi_action __smi_handle_dr_smp_send(u8 node_type, int port_num,
+static enum smi_action __smi_handle_dr_smp_send(bool is_switch, int port_num,
 						u8 *hop_ptr, u8 hop_cnt,
 						const u8 *initial_path,
 						const u8 *return_path,
@@ -64,7 +64,7 @@ static enum smi_action __smi_handle_dr_smp_send(u8 node_type, int port_num,
 
 		/* C14-9:2 */
 		if (*hop_ptr && *hop_ptr < hop_cnt) {
-			if (node_type != RDMA_NODE_IB_SWITCH)
+			if (!is_switch)
 				return IB_SMI_DISCARD;
 
 			/* return_path set when received */
@@ -77,7 +77,7 @@ static enum smi_action __smi_handle_dr_smp_send(u8 node_type, int port_num,
 		if (*hop_ptr == hop_cnt) {
 			/* return_path set when received */
 			(*hop_ptr)++;
-			return (node_type == RDMA_NODE_IB_SWITCH ||
+			return (is_switch ||
 				dr_dlid_is_permissive ?
 				IB_SMI_HANDLE : IB_SMI_DISCARD);
 		}
@@ -96,7 +96,7 @@ static enum smi_action __smi_handle_dr_smp_send(u8 node_type, int port_num,
 
 		/* C14-13:2 */
 		if (2 <= *hop_ptr && *hop_ptr <= hop_cnt) {
-			if (node_type != RDMA_NODE_IB_SWITCH)
+			if (!is_switch)
 				return IB_SMI_DISCARD;
 
 			(*hop_ptr)--;
@@ -108,7 +108,7 @@ static enum smi_action __smi_handle_dr_smp_send(u8 node_type, int port_num,
 		if (*hop_ptr == 1) {
 			(*hop_ptr)--;
 			/* C14-13:3 -- SMPs destined for SM shouldn't be here */
-			return (node_type == RDMA_NODE_IB_SWITCH ||
+			return (is_switch ||
 				dr_slid_is_permissive ?
 				IB_SMI_HANDLE : IB_SMI_DISCARD);
 		}
@@ -127,9 +127,9 @@ static enum smi_action __smi_handle_dr_smp_send(u8 node_type, int port_num,
  * Return IB_SMI_DISCARD if the SMP should be discarded
  */
 enum smi_action smi_handle_dr_smp_send(struct ib_smp *smp,
-				       u8 node_type, int port_num)
+				       bool is_switch, int port_num)
 {
-	return __smi_handle_dr_smp_send(node_type, port_num,
+	return __smi_handle_dr_smp_send(is_switch, port_num,
 					&smp->hop_ptr, smp->hop_cnt,
 					smp->initial_path,
 					smp->return_path,
@@ -139,9 +139,9 @@ enum smi_action smi_handle_dr_smp_send(struct ib_smp *smp,
 }
 
 enum smi_action opa_smi_handle_dr_smp_send(struct opa_smp *smp,
-				       u8 node_type, int port_num)
+				       bool is_switch, int port_num)
 {
-	return __smi_handle_dr_smp_send(node_type, port_num,
+	return __smi_handle_dr_smp_send(is_switch, port_num,
 					&smp->hop_ptr, smp->hop_cnt,
 					smp->route.dr.initial_path,
 					smp->route.dr.return_path,
@@ -152,7 +152,7 @@ enum smi_action opa_smi_handle_dr_smp_send(struct opa_smp *smp,
 					OPA_LID_PERMISSIVE);
 }
 
-static enum smi_action __smi_handle_dr_smp_recv(u8 node_type, int port_num,
+static enum smi_action __smi_handle_dr_smp_recv(bool is_switch, int port_num,
 						int phys_port_cnt,
 						u8 *hop_ptr, u8 hop_cnt,
 						const u8 *initial_path,
@@ -173,7 +173,7 @@ static enum smi_action __smi_handle_dr_smp_recv(u8 node_type, int port_num,
 
 		/* C14-9:2 -- intermediate hop */
 		if (*hop_ptr && *hop_ptr < hop_cnt) {
-			if (node_type != RDMA_NODE_IB_SWITCH)
+			if (!is_switch)
 				return IB_SMI_DISCARD;
 
 			return_path[*hop_ptr] = port_num;
@@ -188,7 +188,7 @@ static enum smi_action __smi_handle_dr_smp_recv(u8 node_type, int port_num,
 				return_path[*hop_ptr] = port_num;
 			/* hop_ptr updated when sending */
 
-			return (node_type == RDMA_NODE_IB_SWITCH ||
+			return (is_switch ||
 				dr_dlid_is_permissive ?
 				IB_SMI_HANDLE : IB_SMI_DISCARD);
 		}
@@ -208,7 +208,7 @@ static enum smi_action __smi_handle_dr_smp_recv(u8 node_type, int port_num,
 
 		/* C14-13:2 */
 		if (2 <= *hop_ptr && *hop_ptr <= hop_cnt) {
-			if (node_type != RDMA_NODE_IB_SWITCH)
+			if (!is_switch)
 				return IB_SMI_DISCARD;
 
 			/* hop_ptr updated when sending */
@@ -224,8 +224,7 @@ static enum smi_action __smi_handle_dr_smp_recv(u8 node_type, int port_num,
 				return IB_SMI_HANDLE;
 			}
 			/* hop_ptr updated when sending */
-			return (node_type == RDMA_NODE_IB_SWITCH ?
-				IB_SMI_HANDLE : IB_SMI_DISCARD);
+			return (is_switch ? IB_SMI_HANDLE : IB_SMI_DISCARD);
 		}
 
 		/* C14-13:4 -- hop_ptr = 0 -> give to SM */
@@ -238,10 +237,10 @@ static enum smi_action __smi_handle_dr_smp_recv(u8 node_type, int port_num,
  * Adjust information for a received SMP
  * Return IB_SMI_DISCARD if the SMP should be dropped
  */
-enum smi_action smi_handle_dr_smp_recv(struct ib_smp *smp, u8 node_type,
+enum smi_action smi_handle_dr_smp_recv(struct ib_smp *smp, bool is_switch,
 				       int port_num, int phys_port_cnt)
 {
-	return __smi_handle_dr_smp_recv(node_type, port_num, phys_port_cnt,
+	return __smi_handle_dr_smp_recv(is_switch, port_num, phys_port_cnt,
 					&smp->hop_ptr, smp->hop_cnt,
 					smp->initial_path,
 					smp->return_path,
@@ -254,10 +253,10 @@ enum smi_action smi_handle_dr_smp_recv(struct ib_smp *smp, u8 node_type,
  * Adjust information for a received SMP
  * Return IB_SMI_DISCARD if the SMP should be dropped
  */
-enum smi_action opa_smi_handle_dr_smp_recv(struct opa_smp *smp, u8 node_type,
+enum smi_action opa_smi_handle_dr_smp_recv(struct opa_smp *smp, bool is_switch,
 					   int port_num, int phys_port_cnt)
 {
-	return __smi_handle_dr_smp_recv(node_type, port_num, phys_port_cnt,
+	return __smi_handle_dr_smp_recv(is_switch, port_num, phys_port_cnt,
 					&smp->hop_ptr, smp->hop_cnt,
 					smp->route.dr.initial_path,
 					smp->route.dr.return_path,
diff --git a/drivers/infiniband/core/smi.h b/drivers/infiniband/core/smi.h
index aff96ba..33c91c8 100644
--- a/drivers/infiniband/core/smi.h
+++ b/drivers/infiniband/core/smi.h
@@ -51,12 +51,12 @@ enum smi_forward_action {
 	IB_SMI_FORWARD	/* SMP should be forwarded (for switches only) */
 };
 
-enum smi_action smi_handle_dr_smp_recv(struct ib_smp *smp, u8 node_type,
+enum smi_action smi_handle_dr_smp_recv(struct ib_smp *smp, bool is_switch,
 				       int port_num, int phys_port_cnt);
 int smi_get_fwd_port(struct ib_smp *smp);
 extern enum smi_forward_action smi_check_forward_dr_smp(struct ib_smp *smp);
 extern enum smi_action smi_handle_dr_smp_send(struct ib_smp *smp,
-					      u8 node_type, int port_num);
+					      bool is_switch, int port_num);
 
 /*
  * Return IB_SMI_HANDLE if the SMP should be handled by the local SMA/SM
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index ed6b6c8..0b84a9c 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -870,7 +870,7 @@ int ib_device_register_sysfs(struct ib_device *device,
 		goto err_put;
 	}
 
-	if (device->node_type == RDMA_NODE_IB_SWITCH) {
+	if (rdma_cap_ib_switch(device)) {
 		ret = add_port(device, 0, port_callback);
 		if (ret)
 			goto err_put;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index da149c2..0d8336e 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1684,7 +1684,7 @@ static void ipoib_add_one(struct ib_device *device)
 	struct list_head *dev_list;
 	struct net_device *dev;
 	struct ipoib_dev_priv *priv;
-	int s, e, p;
+	int p;
 	int count = 0;
 
 	dev_list = kmalloc(sizeof *dev_list, GFP_KERNEL);
@@ -1693,15 +1693,7 @@ static void ipoib_add_one(struct ib_device *device)
 
 	INIT_LIST_HEAD(dev_list);
 
-	if (device->node_type == RDMA_NODE_IB_SWITCH) {
-		s = 0;
-		e = 0;
-	} else {
-		s = 1;
-		e = device->phys_port_cnt;
-	}
-
-	for (p = s; p <= e; ++p) {
+	for (p = rdma_start_port(device); p <= rdma_end_port(device); ++p) {
 		if (!rdma_protocol_ib(device, p))
 			continue;
 		dev = ipoib_add_port("ib%d", device, p);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index eada8f7..ef10f6c 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3379,7 +3379,7 @@ static void srp_add_one(struct ib_device *device)
 	struct srp_device *srp_dev;
 	struct ib_device_attr *dev_attr;
 	struct srp_host *host;
-	int mr_page_shift, s, e, p;
+	int mr_page_shift, p;
 	u64 max_pages_per_mr;
 
 	dev_attr = kmalloc(sizeof *dev_attr, GFP_KERNEL);
@@ -3443,15 +3443,7 @@ static void srp_add_one(struct ib_device *device)
 	if (IS_ERR(srp_dev->mr))
 		goto err_pd;
 
-	if (device->node_type == RDMA_NODE_IB_SWITCH) {
-		s = 0;
-		e = 0;
-	} else {
-		s = 1;
-		e = device->phys_port_cnt;
-	}
-
-	for (p = s; p <= e; ++p) {
+	for (p = rdma_start_port(device); p <= rdma_end_port(device); ++p) {
 		host = srp_add_port(srp_dev, p);
 		if (host)
 			list_add_tail(&host->list, &srp_dev->dev_list);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 986fddb..b0f898e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1745,6 +1745,7 @@ struct ib_device {
 	char			     node_desc[64];
 	__be64			     node_guid;
 	u32			     local_dma_lkey;
+	u16                          is_switch:1;
 	u8                           node_type;
 	u8                           phys_port_cnt;
 
@@ -1824,6 +1825,20 @@ enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *device,
 					       u8 port_num);
 
 /**
+ * rdma_cap_ib_switch - Check if the device is IB switch
+ * @device: Device to check
+ *
+ * Device driver is responsible for setting is_switch bit on
+ * in ib_device structure at init time.
+ *
+ * Return: true if the device is IB switch.
+ */
+static inline bool rdma_cap_ib_switch(const struct ib_device *device)
+{
+	return device->is_switch;
+}
+
+/**
  * rdma_start_port - Return the first valid port number for the device
  * specified
  *
@@ -1833,7 +1848,7 @@ enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *device,
  */
 static inline u8 rdma_start_port(const struct ib_device *device)
 {
-	return (device->node_type == RDMA_NODE_IB_SWITCH) ? 0 : 1;
+	return rdma_cap_ib_switch(device) ? 0 : 1;
 }
 
 /**
@@ -1846,8 +1861,7 @@ static inline u8 rdma_start_port(const struct ib_device *device)
  */
 static inline u8 rdma_end_port(const struct ib_device *device)
 {
-	return (device->node_type == RDMA_NODE_IB_SWITCH) ?
-		0 : device->phys_port_cnt;
+	return rdma_cap_ib_switch(device) ? 0 : device->phys_port_cnt;
 }
 
 static inline bool rdma_protocol_ib(const struct ib_device *device, u8 port_num)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
