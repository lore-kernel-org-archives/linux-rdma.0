From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] librdmacm: Set errno correctly if status is positive
Date: Wed, 10 Jan 2018 18:07:21 +0200
Message-ID: <20180110160721.14469-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

No need to convert to positive if status is already positive.

Fixes: 1ef5c3a84 ("librdmacm: Set errno correctly in ucma_complete")

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 librdmacm/cma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/librdmacm/cma.c b/librdmacm/cma.c
index 25ebaaee..fb2dc5e4 100644
--- a/librdmacm/cma.c
+++ b/librdmacm/cma.c
@@ -866,7 +866,7 @@ int ucma_complete(struct rdma_cm_id *id)
 		else if (id_priv->id.event->status < 0)
 			ret = ERR(-id_priv->id.event->status);
 		else
-			ret = ERR(-id_priv->id.event->status);
+			ret = ERR(id_priv->id.event->status);
 	}
 	return ret;
 }
-- 
2.14.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
