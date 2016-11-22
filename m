From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 07/11] IB/mad: Change slid in RMPP recv from 16 to 32 bits
Date: Tue, 22 Nov 2016 14:38:48 -0500
Message-ID: <1479843532-47496-8-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

OPA devices will contain larger lids in the wc.slid
which is now 32 bits. This change ensures RMPP handler
is able to retrieve the correct lid.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad_rmpp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index 8a076e1..057c1ec 100644
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -64,7 +64,7 @@ struct mad_rmpp_recv {
 
 	__be64 tid;
 	u32 src_qp;
-	u16 slid;
+	u32 slid;
 	u8 mgmt_class;
 	u8 class_version;
 	u8 method;
@@ -316,7 +316,7 @@ static void recv_cleanup_handler(struct work_struct *work)
 	mad_hdr = &mad_recv_wc->recv_buf.mad->mad_hdr;
 	rmpp_recv->tid = mad_hdr->tid;
 	rmpp_recv->src_qp = mad_recv_wc->wc->src_qp;
-	rmpp_recv->slid = (u16)mad_recv_wc->wc->slid;
+	rmpp_recv->slid = mad_recv_wc->wc->slid;
 	rmpp_recv->mgmt_class = mad_hdr->mgmt_class;
 	rmpp_recv->class_version = mad_hdr->class_version;
 	rmpp_recv->method  = mad_hdr->method;
@@ -337,7 +337,7 @@ static void recv_cleanup_handler(struct work_struct *work)
 	list_for_each_entry(rmpp_recv, &agent->rmpp_list, list) {
 		if (rmpp_recv->tid == mad_hdr->tid &&
 		    rmpp_recv->src_qp == mad_recv_wc->wc->src_qp &&
-		    rmpp_recv->slid == (u16)mad_recv_wc->wc->slid &&
+		    rmpp_recv->slid == mad_recv_wc->wc->slid &&
 		    rmpp_recv->mgmt_class == mad_hdr->mgmt_class &&
 		    rmpp_recv->class_version == mad_hdr->class_version &&
 		    rmpp_recv->method == mad_hdr->method)
@@ -870,7 +870,7 @@ static int init_newwin(struct ib_mad_send_wr_private *mad_send_wr)
 		if (ib_query_ah(mad_send_wr->send_buf.ah, &ah_attr))
 			continue;
 
-		if (rmpp_recv->slid == (u16)ah_attr.dlid) {
+		if (rmpp_recv->slid == ah_attr.dlid) {
 			newwin = rmpp_recv->repwin;
 			break;
 		}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
