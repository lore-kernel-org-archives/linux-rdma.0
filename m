From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 3/5] [librdmacm] rstream: initialize return value in server_connect()
Date: Tue,  9 Oct 2012 14:27:50 +0200
Message-ID: <1349785672-1921-4-git-send-email-dotanb@dev.mellanox.co.il>
References: <1349785672-1921-1-git-send-email-dotanb@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1349785672-1921-1-git-send-email-dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If use_async == 0 and rs_accept() passes (i.e. non negative value), then
the return value from the function was uninitialized.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 examples/rstream.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/examples/rstream.c b/examples/rstream.c
index 1d221d0..6ef60a1 100644
--- a/examples/rstream.c
+++ b/examples/rstream.c
@@ -444,7 +444,7 @@ free:
 static int server_connect(void)
 {
 	struct pollfd fds;
-	int ret;
+	int ret = 0;
 
 	set_options(lrs);
 	do {
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
