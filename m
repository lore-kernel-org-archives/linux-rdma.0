From: Grant Grundler <grundler-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH] rdma: fix odd use of WARN_ON() in ib_srpt.c
Date: Tue, 26 Mar 2013 14:48:28 -0700
Message-ID: <1364334508-7397-1-git-send-email-grundler@chromium.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Grant Grundler <grundler-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

While WARN_ON("const string") will work, it's intent is not obvious.
The warning is more useful by showing the "state" value.

Signed-off-by: Grant Grundler <grundler-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
UNTESTED.

 drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index c09d41b..b08ca7a 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1374,7 +1374,7 @@ static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
 		target_put_sess_cmd(ioctx->ch->sess, &ioctx->cmd);
 		break;
 	default:
-		WARN_ON("ERROR: unexpected command state");
+		WARN(1, "Unexpected command state (%d)", state);
 		break;
 	}
 
-- 
1.8.1.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
