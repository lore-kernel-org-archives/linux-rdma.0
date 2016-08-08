From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: [PATCH] ipoib: Make ipoib_warn ratelimited
Date: Mon,  8 Aug 2016 17:14:22 +0300
Message-ID: <1470665662-24028-1-git-send-email-kernel@kyup.com>
References: <1470234370.18081.63.camel@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470234370.18081.63.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In certain cases it's possible to be flooded by warning messages. To
cope with such situations make the ipoib_warn macro be ratelimited.
To prevent accidental limiting of legitimate, bursty messages make
the limit fairly liberal by allowing up to 100 messages in 10 seconds.

Signed-off-by: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 3ede10309754..1f02ccbdccd0 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -764,7 +764,13 @@ static inline void ipoib_unregister_debugfs(void) { }
 #define ipoib_printk(level, priv, format, arg...)	\
 	printk(level "%s: " format, ((struct ipoib_dev_priv *) priv)->dev->name , ## arg)
 #define ipoib_warn(priv, format, arg...)		\
-	ipoib_printk(KERN_WARNING, priv, format , ## arg)
+do {							\
+	static DEFINE_RATELIMIT_STATE(_rs,		\
+		10 * HZ /*10 seconds */,		\
+		100);		\
+	if (__ratelimit(&_rs))				\
+		ipoib_printk(KERN_WARNING, priv, format , ## arg);\
+} while (0)
 
 extern int ipoib_sendq_size;
 extern int ipoib_recvq_size;
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
