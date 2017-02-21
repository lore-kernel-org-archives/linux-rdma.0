From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [RESEND PATCH 1/1] rdma_cm: fail iwarp accepts w/o connection params
Date: Tue, 21 Feb 2017 11:21:57 -0800
Message-ID: <20170221194805.03181E0BEF@smtp.ogc.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shaobo-sDh8Nw2yj/+Vc3sceRu5cw@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

cma_accept_iw() needs to return an error if conn_params is NULL.
Since this is coming from user space, we can crash.

Reported-by: Shaobo He <shaobo-sDh8Nw2yj/+Vc3sceRu5cw@public.gmane.org>
Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---

(resent because I screwed up linux-rdma mailing address)

---

 drivers/infiniband/core/cma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 3e70a9c..c377afc 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3583,6 +3583,9 @@ static int cma_accept_iw(struct rdma_id_private *id_priv,
 	struct iw_cm_conn_param iw_param;
 	int ret;
 
+	if (!conn_param)
+		return -EINVAL;
+
 	ret = cma_modify_qp_rtr(id_priv, conn_param);
 	if (ret)
 		return ret;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
