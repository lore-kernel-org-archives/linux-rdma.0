From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 8/8] rdma-ndd: Tidy getopt_long call
Date: Wed, 26 Jul 2017 13:59:12 -0600
Message-ID: <1501099152-6344-9-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1501099152-6344-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501099152-6344-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

struct option should be const and opt_idx can just be NULL.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 rdma-ndd/rdma-ndd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/rdma-ndd/rdma-ndd.c b/rdma-ndd/rdma-ndd.c
index 3e99d2dc5332dc..180cbb34a8e29b 100644
--- a/rdma-ndd/rdma-ndd.c
+++ b/rdma-ndd/rdma-ndd.c
@@ -289,15 +289,14 @@ int main(int argc, char *argv[])
 	openlog(NULL, LOG_NDELAY | LOG_CONS | LOG_PID, LOG_DAEMON);
 
 	while (1) {
-		int opt_idx = 0;
-		static struct option long_opts[] = {
+		static const struct option long_opts[] = {
 			{ "foreground",   0, NULL, 'f' },
 			{ "help",         0, NULL, 'h' },
 			{ "debug",        0, NULL, 'd' },
 			{ }
 		};
 
-		int c = getopt_long(argc, argv, "fh", long_opts, &opt_idx);
+		int c = getopt_long(argc, argv, "fh", long_opts, NULL);
 		if (c == -1)
 			break;
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
