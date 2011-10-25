From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] rdma/cma: fixed resource leak in case of an error in udaddy
Date: Tue, 25 Oct 2011 10:25:04 +0200
Message-ID: <201110251025.04409.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fixed a resource leak in case of an error level in the udaddy example.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 examples/udaddy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/examples/udaddy.c b/examples/udaddy.c
index 637306a..1534df5 100644
--- a/examples/udaddy.c
+++ b/examples/udaddy.c
@@ -547,7 +547,7 @@ static int run_server(void)
 	ret = rdma_bind_addr(listen_id, test.src_addr);
 	if (ret) {
 		perror("udaddy: bind address failed");
-		return ret;
+		goto out;
 	}
 
 	ret = rdma_listen(listen_id, 0);
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
