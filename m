From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 17/21] srp_deamon: Using v formatters directly for pr_err
Date: Mon, 24 Jul 2017 14:00:25 -0600
Message-ID: <1500926429-31822-18-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

No reason to format to a string buffer and then just print that string,
use vsyslog and vfprintf directly instead.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 srp_daemon/srp_daemon.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index f0dfe260945574..a75f3af085cbde 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -295,22 +295,17 @@ void pr_debug(const char *fmt, ...)
 void pr_err(const char *fmt, ...)
 {
 	va_list args;
-	int pos;
-	char str[1000];
 
 	va_start(args, fmt);
-	pos = vsnprintf(str, sizeof(str), fmt, args);
-	va_end(args);
-	if (pos >= sizeof(str))
-		str[sizeof(str) - 1] = '\0';
 	switch (s_log_dest) {
 	case log_to_syslog:
-		syslog(LOG_DAEMON | LOG_ERR, "%s", str);
+		vsyslog(LOG_DAEMON | LOG_ERR, fmt, args);
 		break;
 	case log_to_stderr:
-		fprintf(stderr, "%s", str);
+		vfprintf(stderr, fmt, args);
 		break;
 	}
+	va_end(args);
 }
 
 static int check_not_equal_str(const char *dir_name, const char *attr,
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
