From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 2/8] srp_daemon: Fix missing free_config for ibsrpdm
Date: Wed, 26 Jul 2017 13:59:06 -0600
Message-ID: <1501099152-6344-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1501099152-6344-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501099152-6344-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Doesn't really matter since this just exits the process right after.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 srp_daemon/srp_daemon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index ec394b686d55ff..836e2e5d1487b5 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -2053,7 +2053,7 @@ static int ibsrpdm(int argc, char *argv[])
 	ret = set_conf_dev_and_port(umad_dev, config);
 	if (ret) {
 		pr_err("Failed to build config\n");
-		return 1;
+		goto out;
 	}
 
 	umad_init();
@@ -2076,7 +2076,7 @@ static int ibsrpdm(int argc, char *argv[])
 	free_res(res);
 umad_done:
 	umad_done();
-
+out:
 	free_config(config);
 
 	return ret;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
