From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: [PATCH 1/2] ipoib: Add ratelimited version of ipoib_warn
Date: Tue, 26 Jul 2016 17:38:48 +0300
Message-ID: <1469543929-17659-1-git-send-email-kernel@kyup.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In certain cases it's possible to be flooded by warning messages. To
cope with such situation add ratelimited version of ipoib_warn -
ipoib_warn_rl. Current implementation is done in such a way so that
various messages do not skew the flood detection of one another e.g.
each is being governed by a separate ratelimit structure.

Signed-off-by: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 3ede10309754..dc1bcb32b7a1 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -763,8 +763,19 @@ static inline void ipoib_unregister_debugfs(void) { }
 
 #define ipoib_printk(level, priv, format, arg...)	\
 	printk(level "%s: " format, ((struct ipoib_dev_priv *) priv)->dev->name , ## arg)
+#define ipoib_printk_warn_ratelimit(priv, fmt, args...)		\
+do {								\
+	static DEFINE_RATELIMIT_STATE(_rs,			\
+		DEFAULT_RATELIMIT_INTERVAL,			\
+		DEFAULT_RATELIMIT_BURST);			\
+	if (__ratelimit(&_rs))					\
+		ipoib_printk(KERN_WARNING, priv, fmt, ##args);	\
+} while (0)
+
 #define ipoib_warn(priv, format, arg...)		\
 	ipoib_printk(KERN_WARNING, priv, format , ## arg)
+#define ipoib_warn_rl(priv, fmt, args...)		\
+	ipoib_printk_warn_ratelimit(priv, fmt , args...)
 
 extern int ipoib_sendq_size;
 extern int ipoib_recvq_size;
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
