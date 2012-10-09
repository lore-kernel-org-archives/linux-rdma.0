From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/5] [librdmacm] rsocket: add missing va_end() after calling va_end()
Date: Tue,  9 Oct 2012 14:27:48 +0200
Message-ID: <1349785672-1921-2-git-send-email-dotanb@dev.mellanox.co.il>
References: <1349785672-1921-1-git-send-email-dotanb@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1349785672-1921-1-git-send-email-dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Not doing so, may lead to resource leak.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/rsocket.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/src/rsocket.c b/src/rsocket.c
index 4c4821b..278c8ec 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -2002,6 +2002,7 @@ int rfcntl(int socket, int cmd, ... /* arg */ )
 	va_start(args, cmd);
 	switch (cmd) {
 	case F_GETFL:
+		va_end(args);
 		return (int) rs->fd_flags;
 	case F_SETFL:
 		param = va_arg(args, long);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
