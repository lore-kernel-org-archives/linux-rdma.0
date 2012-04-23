From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH fixes] IB/core: fix generation of unmatched responses for unhandled MADs
Date: Mon, 23 Apr 2012 18:20:13 +0300
Message-ID: <1335194413-27436-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Swapna Thete <swapna.thete-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Commit 0b307043049f34211affdde46f82e7abbe8c4590 "IB/mad: Return 
error response for unsupported MADs" introduced two problems:

1. If the "unsupported" MAD is a Directed-route get/set, it fails
   to set the "D" bit in the response MAD status field. This is
   a problem for SM_INFO MADs when the receiver does not have
   an SM running.

2. It sends out automatic error responses for failed get/set MADs
   (e.g., for MADs which return IB_MAD_RETURN_FAILURE).
   These MADs should be silently discarded. (We should not force
   the lower-layer drivers to return SUCCESS | CONSUMED in this
   case, since the MAD is NOT successful).
   Note that unsupported MADs are not failures -- they return
   SUCCESS, but with an "unsupported error" status value inside
   the response MAD.

This patch fixes these two problems.

CC: Swapna Thete <swapna.thete-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Found-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/core/mad.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 426bb76..d4b1ba7 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1854,6 +1854,8 @@ static bool generate_unmatched_resp(struct ib_mad_private *recv,
 		response->mad.mad.mad_hdr.method = IB_MGMT_METHOD_GET_RESP;
 		response->mad.mad.mad_hdr.status =
 			cpu_to_be16(IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD_ATTRIB);
+		if (recv->mad.mad.mad_hdr.mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
+			response->mad.mad.mad_hdr.status |= IB_SMP_DIRECTION;
 
 		return true;
 	} else {
@@ -1869,6 +1871,7 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 	struct ib_mad_list_head *mad_list;
 	struct ib_mad_agent_private *mad_agent;
 	int port_num;
+	int ret = IB_MAD_RESULT_SUCCESS;
 
 	mad_list = (struct ib_mad_list_head *)(unsigned long)wc->wr_id;
 	qp_info = mad_list->mad_queue->qp_info;
@@ -1952,7 +1955,6 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 local:
 	/* Give driver "right of first refusal" on incoming MAD */
 	if (port_priv->device->process_mad) {
-		int ret;
 
 		ret = port_priv->device->process_mad(port_priv->device, 0,
 						     port_priv->port_num,
@@ -1981,7 +1983,8 @@ local:
 		 * or via recv_handler in ib_mad_complete_recv()
 		 */
 		recv = NULL;
-	} else if (generate_unmatched_resp(recv, response)) {
+	} else if ((ret & IB_MAD_RESULT_SUCCESS) &&
+		   generate_unmatched_resp(recv, response)) {
 		agent_send_response(&response->mad.mad, &recv->grh, wc,
 				    port_priv->device, port_num, qp_info->qp->qp_num);
 	}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
