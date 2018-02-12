From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] vmw_pvrdma: Fix SRQN returned to library
Date: Mon, 12 Feb 2018 10:42:36 -0800
Message-ID: <1518460956-4629-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>

Here's a fix for the vmw_pvrdma library. It needs to go into the
stable branch for 16.0 as well since we can then add it to OFED-4.8-2.

The PR is here:
https://github.com/linux-rdma/rdma-core/pull/291

Thanks,
Adit
---

Use the correct SQN reported by the driver.

Fixes: 4c8ed14eb6b7 ("vmw_pvrdma: Add SRQ support")
Reviewed-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
---
 providers/vmw_pvrdma/qp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/providers/vmw_pvrdma/qp.c b/providers/vmw_pvrdma/qp.c
index 34c8020..efcc99b 100644
--- a/providers/vmw_pvrdma/qp.c
+++ b/providers/vmw_pvrdma/qp.c
@@ -108,7 +108,7 @@ struct ibv_srq *pvrdma_create_srq(struct ibv_pd *pd,
 {
 	struct pvrdma_device *dev = to_vdev(pd->context->device);
 	struct user_pvrdma_create_srq cmd;
-	struct ib_uverbs_create_srq_resp resp;
+	struct user_pvrdma_create_srq_resp resp;
 	struct pvrdma_srq *srq;
 	int ret;
 
@@ -142,12 +142,12 @@ struct ibv_srq *pvrdma_create_srq(struct ibv_pd *pd,
 
 	ret = ibv_cmd_create_srq(pd, &srq->ibv_srq, attr,
 				 &cmd.ibv_cmd, sizeof(cmd),
-				 &resp, sizeof(resp));
+				 &resp.ibv_resp, sizeof(resp));
 
 	if (ret)
 		goto err_free;
 
-	srq->srqn = resp.srqn;
+	srq->srqn = resp.udata.srqn;
 
 	return &srq->ibv_srq;
 
-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
