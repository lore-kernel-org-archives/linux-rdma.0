From: David Dai <zdai-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH 1/2] rds-tools user space part of change for rds-stress -D option failure
Date: Mon, 29 Feb 2016 19:47:25 -0600
Message-ID: <1456796846-8596-2-git-send-email-zdai@linux.vnet.ibm.com>
References: <1456796846-8596-1-git-send-email-zdai@linux.vnet.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456796846-8596-1-git-send-email-zdai-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, zdai-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

---
 rds-stress.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/rds-stress.c b/rds-stress.c
index 9f0623c..6632d58 100755
--- a/rds-stress.c
+++ b/rds-stress.c
@@ -1400,7 +1400,7 @@ static int recv_message(int fd,
 		return ret;
 	if (ret && ret < sizeof(struct header))
 		die("recvmsg() returned short data: %zd", ret);
-	if (msg.msg_namelen < sizeof(struct sockaddr_in))
+	if (ret && msg.msg_namelen < sizeof(struct sockaddr_in))
 		die("socklen = %d < sizeof(sin) (%zu)\n",
 		    msg.msg_namelen, sizeof(struct sockaddr_in));
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
