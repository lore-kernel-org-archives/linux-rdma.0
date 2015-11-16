From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 07/10] iser-target: Declare correct flags when accepting a connection
Date: Mon, 16 Nov 2015 18:37:38 +0200
Message-ID: <1447691861-3796-8-git-send-email-sagig@mellanox.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447691861-3796-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

iser target does not support zero based virtual addresses and
send with invalidate, so it should declare that it doesn't.

Signed-off-by: Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index bdda42638629..667238f6253f 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -3099,12 +3099,18 @@ isert_rdma_accept(struct isert_conn *isert_conn)
 	struct rdma_cm_id *cm_id = isert_conn->cm_id;
 	struct rdma_conn_param cp;
 	int ret;
+	struct iser_cm_hdr rsp_hdr;
 
 	memset(&cp, 0, sizeof(struct rdma_conn_param));
 	cp.initiator_depth = isert_conn->initiator_depth;
 	cp.retry_count = 7;
 	cp.rnr_retry_count = 7;
 
+	memset(&rsp_hdr, 0, sizeof(rsp_hdr));
+	rsp_hdr.flags = (ISERT_ZBVA_NOT_USED | ISERT_SEND_W_INV_NOT_USED);
+	cp.private_data = (void *)&rsp_hdr;
+	cp.private_data_len = sizeof(rsp_hdr);
+
 	ret = rdma_accept(cm_id, &cp);
 	if (ret) {
 		isert_err("rdma_accept() failed with: %d\n", ret);
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
