From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 3/8] IB/iser: Fix responder resources advertizement
Date: Thu, 31 Jul 2014 13:27:46 +0300
Message-ID: <1406802471-23359-4-git-send-email-ogerlitz@mellanox.com>
References: <1406802471-23359-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1406802471-23359-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The iser initiator is the RDMA responder so it should publish
to the target the max inflight rdma read requests its local HCA
can handle in responder_resources (max_qp_rd_atom).

The iser target should take the min of that and its local HCA max
inflight oustanding rdma read requests (max_qp_init_rd_atom).

We keep initiator_depth set to 1 in order to compat with old targets.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index da6f3dd..6c7d8ce 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -694,13 +694,15 @@ static void iser_route_handler(struct rdma_cm_id *cma_id)
 	struct rdma_conn_param conn_param;
 	int    ret;
 	struct iser_cm_hdr req_hdr;
+	struct iser_conn *ib_conn = (struct iser_conn *)cma_id->context;
+	struct iser_device *device = ib_conn->device;
 
 	ret = iser_create_ib_conn_res((struct iser_conn *)cma_id->context);
 	if (ret)
 		goto failure;
 
 	memset(&conn_param, 0, sizeof conn_param);
-	conn_param.responder_resources = 4;
+	conn_param.responder_resources = device->dev_attr.max_qp_rd_atom;
 	conn_param.initiator_depth     = 1;
 	conn_param.retry_count	       = 7;
 	conn_param.rnr_retry_count     = 6;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
