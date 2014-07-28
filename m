From: Ilya Nelkenbaum <ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH librdmacm] rsocket: Segmentation fault fix in case of multiple connections
Date: Mon, 28 Jul 2014 15:48:09 +0300
Message-ID: <1406551689-8142-1-git-send-email-ilyan@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In case of more than 16 rsocket connections
are established, "svc->rss" buffer is reallocated
with more memory. Index 0 is reserved for the service's
communication socket, and this is not taken in count
when data is copied from old buffer location to
new one.

Signed-off-by: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/rsocket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/rsocket.c b/src/rsocket.c
index c7a0cb2..7007897 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -3915,8 +3915,8 @@ static int rs_svc_grow_sets(struct rs_svc *svc, int grow_size)
 	rss = set;
 	contexts = set + sizeof(*rss) * svc->size;
 	if (svc->cnt) {
-		memcpy(rss, svc->rss, sizeof(*rss) * svc->cnt);
-		memcpy(contexts, svc->contexts, svc->context_size * svc->cnt);
+		memcpy(rss, svc->rss, sizeof(*rss) * (svc->cnt + 1));
+		memcpy(contexts, svc->contexts, svc->context_size * (svc->cnt + 1));
 	}
 
 	free(svc->rss);
-- 
1.8.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
