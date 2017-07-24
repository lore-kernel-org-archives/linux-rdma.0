From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 16/21] srp_daemon: Do not use LOG_PERROR
Date: Mon, 24 Jul 2017 14:00:24 -0600
Message-ID: <1500926429-31822-17-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When running from systemd syslog will send messages to the log, but
so will stderr. Thus using LOG_PERROR doubles every log message.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 srp_daemon/srp_daemon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index c0e8d23d58faf5..f0dfe260945574 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -2090,7 +2090,7 @@ int main(int argc, char *argv[])
 		goto restore_sig;
 	}
 
-	openlog("srp_daemon", LOG_PID | LOG_PERROR, LOG_DAEMON);
+	openlog("srp_daemon", LOG_PID, LOG_DAEMON);
 
 	config = calloc(1, sizeof(*config));
 	if (!config) {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
