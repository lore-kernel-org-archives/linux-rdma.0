From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] IB/core - delete redundant check for DR SMP
Date: Wed, 10 Aug 2011 09:27:45 +0300
Message-ID: <201108100927.45568.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The function handle_outgoing_dr_smp() is only called if the
MAD to be sent is a directed route SMP.  Thus, the check for
IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE is redundant.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Acked-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---
 drivers/infiniband/core/mad.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: ofed_kernel/drivers/infiniband/core/mad.c
===================================================================
--- ofed_kernel.orig/drivers/infiniband/core/mad.c
+++ ofed_kernel/drivers/infiniband/core/mad.c
@@ -679,8 +679,7 @@ static int handle_outgoing_dr_smp(struct
 	struct ib_wc mad_wc;
 	struct ib_send_wr *send_wr = &mad_send_wr->send_wr;
 
-	if (device->node_type == RDMA_NODE_IB_SWITCH &&
-	    smp->mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
+	if (device->node_type == RDMA_NODE_IB_SWITCH)
 		port_num = send_wr->wr.ud.port_num;
 	else
 		port_num = mad_agent_priv->agent.port_num;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
