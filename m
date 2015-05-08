From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/4] IB/mad: Change validate_mad signature to take const ib_mad_hdr rather than ib_mad
Date: Fri,  8 May 2015 14:27:21 -0400
Message-ID: <1431109644-27226-2-git-send-email-ira.weiny@intel.com>
References: <1431109644-27226-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431109644-27226-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

validate_mad only needs read access to the MAD header

Reviewed-By: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes since V1:
	Add const specifier

 drivers/infiniband/core/mad.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 5666a8b..66ce764 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1708,20 +1708,20 @@ out:
 	return mad_agent;
 }
 
-static int validate_mad(struct ib_mad *mad, u32 qp_num)
+static int validate_mad(const struct ib_mad_hdr *mad_hdr, u32 qp_num)
 {
 	int valid = 0;
 
 	/* Make sure MAD base version is understood */
-	if (mad->mad_hdr.base_version != IB_MGMT_BASE_VERSION) {
+	if (mad_hdr->base_version != IB_MGMT_BASE_VERSION) {
 		pr_err("MAD received with unsupported base version %d\n",
-			mad->mad_hdr.base_version);
+			mad_hdr->base_version);
 		goto out;
 	}
 
 	/* Filter SMI packets sent to other than QP0 */
-	if ((mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_SUBN_LID_ROUTED) ||
-	    (mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)) {
+	if ((mad_hdr->mgmt_class == IB_MGMT_CLASS_SUBN_LID_ROUTED) ||
+	    (mad_hdr->mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)) {
 		if (qp_num == 0)
 			valid = 1;
 	} else {
@@ -1979,7 +1979,7 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 		snoop_recv(qp_info, &recv->header.recv_wc, IB_MAD_SNOOP_RECVS);
 
 	/* Validate MAD */
-	if (!validate_mad(&recv->mad.mad, qp_info->qp->qp_num))
+	if (!validate_mad(&recv->mad.mad.mad_hdr, qp_info->qp->qp_num))
 		goto out;
 
 	response = kmem_cache_alloc(ib_mad_cache, GFP_KERNEL);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
