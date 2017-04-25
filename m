From: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [rdma-core/rdma-ndd] Use integer as getopt_long returns integer
Date: Tue, 25 Apr 2017 13:49:52 +0800
Message-ID: <1493099392-1883-1-git-send-email-honli@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

ARM chars are unsigned by default. getopt_long return 255 instead -1.
That will cause an endless loop for aarch64 platform.

Signed-off-by: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 rdma-ndd/rdma-ndd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rdma-ndd/rdma-ndd.c b/rdma-ndd/rdma-ndd.c
index 1579a02..e7be22b 100644
--- a/rdma-ndd/rdma-ndd.c
+++ b/rdma-ndd/rdma-ndd.c
@@ -297,7 +297,7 @@ int main(int argc, char *argv[])
 			{ }
 		};
 
-		char c = getopt_long(argc, argv, "fh", long_opts, &opt_idx);
+		int c = getopt_long(argc, argv, "fh", long_opts, &opt_idx);
 		if (c == -1)
 			break;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
