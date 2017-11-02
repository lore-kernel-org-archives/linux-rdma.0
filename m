From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] librdmacm: Remove unneeded condition
Date: Thu,  2 Nov 2017 15:51:34 +0200
Message-ID: <20171102135134.5728-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The check makes no difference - remove it.

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 librdmacm/cma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/librdmacm/cma.c b/librdmacm/cma.c
index 7aaf45f2..6eebe71b 100644
--- a/librdmacm/cma.c
+++ b/librdmacm/cma.c
@@ -880,8 +880,8 @@ static int rdma_resolve_addr2(struct rdma_cm_id *id, struct sockaddr *src_addr,
 	CMA_INIT_CMD(&cmd, sizeof cmd, RESOLVE_ADDR);
 	id_priv = container_of(id, struct cma_id_private, id);
 	cmd.id = id_priv->handle;
-	if ((cmd.src_size = src_len))
-		memcpy(&cmd.src_addr, src_addr, src_len);
+	cmd.src_size = src_len;
+	memcpy(&cmd.src_addr, src_addr, src_len);
 	memcpy(&cmd.dst_addr, dst_addr, dst_len);
 	cmd.dst_size = dst_len;
 	cmd.timeout_ms = timeout_ms;
-- 
2.13.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
