From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] vmw_pvrdma: Avoid rounding up of sge count to power of 2
Date: Thu, 15 Feb 2018 16:39:52 -0800
Message-ID: <1518741592-12723-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Creation of resources can fail if the rounding up exceeds
provider supported values.

Fixes: 4c8ed14eb6b7 ("vmw_pvrdma: Add SRQ support")
Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Nitish Bhat <bnitish-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
---
 providers/vmw_pvrdma/qp.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/providers/vmw_pvrdma/qp.c b/providers/vmw_pvrdma/qp.c
index efcc99b..4b9f897 100644
--- a/providers/vmw_pvrdma/qp.c
+++ b/providers/vmw_pvrdma/qp.c
@@ -113,7 +113,7 @@ struct ibv_srq *pvrdma_create_srq(struct ibv_pd *pd,
 	int ret;
 
 	attr->attr.max_wr = align_next_power2(max_t(uint32_t, 1U, attr->attr.max_wr));
-	attr->attr.max_sge = align_next_power2(max_t(uint32_t, 1U, attr->attr.max_sge));
+	attr->attr.max_sge = max_t(uint32_t, 1U, attr->attr.max_sge);
 
 	srq = malloc(sizeof(*srq));
 	if (!srq)
@@ -216,14 +216,12 @@ struct ibv_qp *pvrdma_create_qp(struct ibv_pd *pd,
 	int ret;
 	int is_srq = !!(attr->srq);
 
-	attr->cap.max_send_sge =
-		align_next_power2(max_t(uint32_t, 1U, attr->cap.max_send_sge));
+	attr->cap.max_send_sge = max_t(uint32_t, 1U, attr->cap.max_send_sge);
 	attr->cap.max_send_wr =
 		align_next_power2(max_t(uint32_t, 1U, attr->cap.max_send_wr));
 
 	if (!is_srq) {
-		attr->cap.max_recv_sge =
-			align_next_power2(max_t(uint32_t, 1U, attr->cap.max_recv_sge));
+		attr->cap.max_recv_sge = max_t(uint32_t, 1U, attr->cap.max_recv_sge);
 		attr->cap.max_recv_wr =
 			align_next_power2(max_t(uint32_t, 1U, attr->cap.max_recv_wr));
 	} else {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
