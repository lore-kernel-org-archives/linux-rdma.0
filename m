From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 2/3] Fix exchange message size in ibv_xsrq_pinpong example
Date: Wed, 30 Mar 2016 18:39:19 +0300
Message-ID: <1459352360-32663-3-git-send-email-yishaih@mellanox.com>
References: <1459352360-32663-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459352360-32663-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

SRQ number is 24 bits and not 16, fix to have sufficient
size for it.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 examples/xsrq_pingpong.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/examples/xsrq_pingpong.c b/examples/xsrq_pingpong.c
index 74205ec..aadf201 100644
--- a/examples/xsrq_pingpong.c
+++ b/examples/xsrq_pingpong.c
@@ -52,11 +52,11 @@
 
 #include "pingpong.h"
 
-#define MSG_FORMAT "%04x:%06x:%06x:%06x:%04x"
-#define MSG_SIZE   31
+#define MSG_FORMAT "%04x:%06x:%06x:%06x:%06x"
+#define MSG_SIZE   33
 #define MSG_SSCAN  "%x:%x:%x:%x:%x"
 #define ADDR_FORMAT \
-	"%8s: LID %04x, QPN RECV %06x SEND %06x, PSN %06x, SRQN %04x\n"
+	"%8s: LID %04x, QPN RECV %06x SEND %06x, PSN %06x, SRQN %06x\n"
 #define TERMINATION_FORMAT "%s"
 #define TERMINATION_MSG_SIZE 4
 #define TERMINATION_MSG "END"
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
