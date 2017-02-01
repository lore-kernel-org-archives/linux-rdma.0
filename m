From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/1] IB/iser: Protect completion context active_qps update
Date: Thu,  2 Feb 2017 01:55:18 +0200
Message-ID: <1485993318-21372-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

As iser connections can share completion contexts, we need
to protect the active_qps update each time we set it.

Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Sagi,
this one was your commit that somehow slip out submission.

---
 drivers/infiniband/ulp/iser/iser_verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index a4b791d..37fa0e7 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -597,7 +597,9 @@ static void iser_free_ib_conn_res(struct iser_conn *iser_conn,
 		  iser_conn, ib_conn->cma_id, ib_conn->qp);
 
 	if (ib_conn->qp != NULL) {
+		mutex_lock(&ig.connlist_mutex);
 		ib_conn->comp->active_qps--;
+		mutex_unlock(&ig.connlist_mutex);
 		rdma_destroy_qp(ib_conn->cma_id);
 		ib_conn->qp = NULL;
 	}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
