From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: bug in ucma_accept()?
Date: Mon, 07 Jan 2013 13:13:13 -0600
Message-ID: <50EB1E49.7020807@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Sean,

Is this a bug?  I think it is...

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 2709ff5..fb24f05 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -806,8 +806,13 @@ static ssize_t ucma_accept(struct ucma_file *file, 
const ch
                 if (!ret)
                         ctx->uid = cmd.uid;
                 mutex_unlock(&file->mut);
-       } else
+       } else {
+               mutex_lock(&file->mut);
                 ret = rdma_accept(ctx->cm_id, NULL);
+               if (!ret)
+                       ctx->uid = cmd.uid;
+               mutex_unlock(&file->mut);
+       }

         ucma_put_ctx(ctx);
         return ret;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
