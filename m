From: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/1] IB/ipoib: Remove redudant label
Date: Tue, 14 Feb 2017 03:43:12 -0500
Message-ID: <1487061792-6279-1-git-send-email-yanjun.zhu@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There are 2 labels to mark the same statements. Replace the 2 labels
with one versatile labe.

Cc: Joe Jin <joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index fd6f97e..c43f40e 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1153,13 +1153,13 @@ static int ipoib_cm_tx_init(struct ipoib_cm_tx *p, u32 qpn,
 	ret = ipoib_cm_modify_tx_init(p->dev, p->id,  p->qp);
 	if (ret) {
 		ipoib_warn(priv, "failed to modify tx qp to rtr: %d\n", ret);
-		goto err_modify;
+		goto err_modify_send;
 	}
 
 	ret = ipoib_cm_send_req(p->dev, p->id, p->qp, qpn, pathrec);
 	if (ret) {
 		ipoib_warn(priv, "failed to send cm req: %d\n", ret);
-		goto err_send_cm;
+		goto err_modify_send;
 	}
 
 	ipoib_dbg(priv, "Request connection 0x%x for gid %pI6 qpn 0x%x\n",
@@ -1167,8 +1167,7 @@ static int ipoib_cm_tx_init(struct ipoib_cm_tx *p, u32 qpn,
 
 	return 0;
 
-err_send_cm:
-err_modify:
+err_modify_send:
 	ib_destroy_cm_id(p->id);
 err_id:
 	p->id = NULL;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
