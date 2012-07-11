From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH librdmacm] rdma_resolve_addr: source address protocol family must be valid
Date: Wed, 11 Jul 2012 17:18:53 +0200
Message-ID: <1342019933-15056-1-git-send-email-ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If a source address is provided but its protocol family is not recognized,
returns an error.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/cma.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index f688c4c..364b587 100755
--- a/src/cma.c
+++ b/src/cma.c
@@ -811,6 +811,9 @@ int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 		return ERR(EINVAL);
 
 	src_len = ucma_addrlen(src_addr);
+	if (src_addr && !src_len)
+		return ERR(EINVAL);
+
 	if (af_ib_support)
 		return rdma_resolve_addr2(id, src_addr, src_len, dst_addr,
 					  dst_len, timeout_ms);
@@ -818,7 +821,7 @@ int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 	CMA_INIT_CMD(&cmd, sizeof cmd, RESOLVE_IP);
 	id_priv = container_of(id, struct cma_id_private, id);
 	cmd.id = id_priv->handle;
-	if (src_addr)
+	if (src_len)
 		memcpy(&cmd.src_addr, src_addr, src_len);
 	memcpy(&cmd.dst_addr, dst_addr, dst_len);
 	cmd.timeout_ms = timeout_ms;
-- 
1.7.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
