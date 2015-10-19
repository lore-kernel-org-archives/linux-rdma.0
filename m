From: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] usnic: correctly handle kzalloc return value
Date: Mon, 19 Oct 2015 16:57:10 +0000
Message-ID: <1445273830-25909-1-git-send-email-wuninsu@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, yeongjin.jang-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, insu-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, changwoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since kzalloc returns memory address, not error code,
it should be checked whether it is null or not. 

Signed-off-by: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
index db3588d..a678a66 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
@@ -221,8 +221,8 @@ create_roce_custom_flow(struct usnic_ib_qp_grp *qp_grp,
 
 	/* Create Flow Handle */
 	qp_flow = kzalloc(sizeof(*qp_flow), GFP_ATOMIC);
-	if (IS_ERR_OR_NULL(qp_flow)) {
-		err = qp_flow ? PTR_ERR(qp_flow) : -ENOMEM;
+	if (!qp_flow) {
+		err = -ENOMEM;
 		goto out_dealloc_flow;
 	}
 	qp_flow->flow = flow;
@@ -296,8 +296,8 @@ create_udp_flow(struct usnic_ib_qp_grp *qp_grp,
 
 	/* Create qp_flow */
 	qp_flow = kzalloc(sizeof(*qp_flow), GFP_ATOMIC);
-	if (IS_ERR_OR_NULL(qp_flow)) {
-		err = qp_flow ? PTR_ERR(qp_flow) : -ENOMEM;
+	if (!qp_flow) {
+		err = -ENOMEM;
 		goto out_dealloc_flow;
 	}
 	qp_flow->flow = flow;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
