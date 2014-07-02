From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/8] librdmacm: Remove NULL checks after calling alloca
Date: Tue,  1 Jul 2014 23:11:12 -0700
Message-ID: <1404281479-6755-2-git-send-email-sean.hefty@intel.com>
References: <1404281479-6755-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404281479-6755-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

alloca doesn't return a NULL pointer on failure.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/cma.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index 9a49a5b..1a88e5c 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -720,9 +720,6 @@ static int ucma_query_path(struct rdma_cm_id *id)
 
 	size = sizeof(*resp) + sizeof(struct ibv_path_data) * 6;
 	resp = alloca(size);
-	if (!resp)
-		return ERR(ENOMEM);
-
 	CMA_INIT_CMD_RESP(&cmd, sizeof cmd, QUERY, resp, size);
 	id_priv = container_of(id, struct cma_id_private, id);
 	cmd.id = id_priv->handle;
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
