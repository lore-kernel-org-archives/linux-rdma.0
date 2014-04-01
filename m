From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH REPOST for-next 3/5] IB/iser: Print QP information once connection is established
Date: Tue,  1 Apr 2014 16:28:40 +0300
Message-ID: <1396358922-20599-4-git-send-email-ogerlitz@mellanox.com>
References: <1396358922-20599-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1396358922-20599-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add an iser info print with the local/remote QP information
carried out when the connection is established. While on that,
fix little leftover from the T10 work, and set a debug print
to be carried in debug and not info level.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 2c9276a..2f5c45b 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -340,8 +340,8 @@ iser_create_fastreg_desc(struct ib_device *ib_device, struct ib_pd *pd,
 	}
 	desc->reg_indicators &= ~ISER_FASTREG_PROTECTED;
 
-	iser_info("Create fr_desc %p page_list %p\n",
-		  desc, desc->data_frpl->page_list);
+	iser_dbg("Create fr_desc %p page_list %p\n",
+		 desc, desc->data_frpl->page_list);
 
 	return 0;
 sig_mr_failure:
@@ -728,6 +728,11 @@ failure:
 static void iser_connected_handler(struct rdma_cm_id *cma_id)
 {
 	struct iser_conn *ib_conn;
+	struct ib_qp_attr attr;
+	struct ib_qp_init_attr init_attr;
+
+	(void)ib_query_qp(cma_id->qp, &attr, ~0, &init_attr);
+	iser_info("remote qpn:%x my qpn:%x\n", attr.dest_qp_num, cma_id->qp->qp_num);
 
 	ib_conn = (struct iser_conn *)cma_id->context;
 	ib_conn->state = ISER_CONN_UP;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
