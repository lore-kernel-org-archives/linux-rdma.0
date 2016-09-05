From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/5] ibacm: Check umad_init return value
Date: Mon,  5 Sep 2016 16:36:41 +0300
Message-ID: <1473082601-15887-1-git-send-email-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 src/acm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/acm.c b/src/acm.c
index f6191bd..ab1269f 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -3117,7 +3117,11 @@ int CDECL_FUNC main(int argc, char **argv)
 	for (i = 0; i < ACM_MAX_COUNTER; i++)
 		atomic_init(&counter[i]);
 
-	umad_init();
+	if (umad_init() != 0) {
+		acm_log(0, "ERROR - fail to initialize umad\n");
+		return -1;
+	}
+
 	if (acm_open_providers()) {
 		acm_log(0, "ERROR - unable to open any providers\n");
 		return -1;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
