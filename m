From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 3/6] rstream: Use waitpid instead of wait
Date: Wed, 15 Mar 2017 16:12:04 -0600
Message-ID: <1489615927-12117-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1489615927-12117-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489615927-12117-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is motiviated by sparse not handling the transparent union in wait()
properly, but using waitpid is generally a better idea since we know what is
supposed to be waited for here.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 librdmacm/examples/rstream.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/librdmacm/examples/rstream.c b/librdmacm/examples/rstream.c
index 70b714613e91af..7523269cbd5cda 100644
--- a/librdmacm/examples/rstream.c
+++ b/librdmacm/examples/rstream.c
@@ -527,7 +527,7 @@ static int run(void)
 			run_test();
 		}
 		if (fork_pid)
-			wait(NULL);
+			waitpid(fork_pid, NULL, 0);
 		else
 			rs_shutdown(rs, SHUT_RDWR);
 		rs_close(rs);
@@ -555,7 +555,7 @@ static int run(void)
 	}
 
 	if (fork_pid)
-		wait(NULL);
+		waitpid(fork_pid, NULL, 0);
 	else
 		rs_shutdown(rs, SHUT_RDWR);
 	rs_close(rs);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
