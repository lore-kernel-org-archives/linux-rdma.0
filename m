From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 05/22] IB/iser: Get rid of un-maintained counters
Date: Thu,  6 Aug 2015 18:32:49 +0300
Message-ID: <1438875186-4310-6-git-send-email-sagig@mellanox.com>
References: <1438875186-4310-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438875186-4310-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We don't update those anywhere in the code and they
seem pretty useless (no one seem to care about those).

qp_tx_queue_full: We never should get this
fmr_map_not_avail: We can never get to this
eh_abort_cnt: We don't monitor aborts

Go ahead and remove them.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 859d9d9..92b1020 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -750,15 +750,9 @@ iscsi_iser_conn_get_stats(struct iscsi_cls_conn *cls_conn, struct iscsi_stats *s
 	stats->r2t_pdus = conn->r2t_pdus_cnt; /* always 0 */
 	stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
 	stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
-	stats->custom_length = 4;
-	strcpy(stats->custom[0].desc, "qp_tx_queue_full");
-	stats->custom[0].value = 0; /* TB iser_conn->qp_tx_queue_full; */
-	strcpy(stats->custom[1].desc, "fmr_map_not_avail");
-	stats->custom[1].value = 0; /* TB iser_conn->fmr_map_not_avail */;
-	strcpy(stats->custom[2].desc, "eh_abort_cnt");
-	stats->custom[2].value = conn->eh_abort_cnt;
-	strcpy(stats->custom[3].desc, "fmr_unalign_cnt");
-	stats->custom[3].value = conn->fmr_unalign_cnt;
+	stats->custom_length = 1;
+	strcpy(stats->custom[0].desc, "fmr_unalign_cnt");
+	stats->custom[0].value = conn->fmr_unalign_cnt;
 }
 
 static int iscsi_iser_get_ep_param(struct iscsi_endpoint *ep,
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
