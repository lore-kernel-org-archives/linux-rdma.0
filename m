From: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
Subject: [PATCH] Infiniband: Remove unneeded version.h include from
 drivers/infiniband/ulp/srpt/ib_srpt.h
Date: Thu, 2 Feb 2012 21:18:16 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1202022116280.16704@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Nicholas A. Bellinger" <nab-4mckEHfoRW3KI0RCH6AXYZqQE7yCjDx5@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index b4b4bbc..61e52b8 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -35,7 +35,6 @@
 #ifndef IB_SRPT_H
 #define IB_SRPT_H
 
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/wait.h>
-- 
1.7.9


-- 
Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
