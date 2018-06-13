From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 1/2] IDR: Expose the XArray lock
Date: Wed, 13 Jun 2018 11:45:55 -0700
Message-ID: <20180613184555.4503-1-willy@infradead.org>
References: <20180613123403.25233-2-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180613123403.25233-2-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hans.westgaard.ry@oracle.com, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-rdma@vger.kernel.org, =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Allow users of the IDR to use the XArray lock for their own
synchronisation purposes.  The IDR continues to rely on the caller to
handle locking, but this lets the caller use the lock embedded in the
IDR data structure instead of allocating their own lock.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 include/linux/idr.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index e856f4e0ab35..3e8215b2c371 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -98,6 +98,17 @@ static inline void idr_set_cursor(struct idr *idr, unsigned int val)
  * period).
  */
 
+#define idr_lock(idr)		xa_lock(&(idr)->idr_rt)
+#define idr_unlock(idr)		xa_unlock(&(idr)->idr_rt)
+#define idr_lock_bh(idr)	xa_lock_bh(&(idr)->idr_rt)
+#define idr_unlock_bh(idr)	xa_unlock_bh(&(idr)->idr_rt)
+#define idr_lock_irq(idr)	xa_lock_irq(&(idr)->idr_rt)
+#define idr_unlock_irq(idr)	xa_unlock_irq(&(idr)->idr_rt)
+#define idr_lock_irqsave(idr, flags) \
+				xa_lock_irqsave(&(idr)->idr_rt, flags)
+#define idr_unlock_irqrestore(idr, flags) \
+				xa_unlock_irqrestore(&(idr)->idr_rt, flags)
+
 void idr_preload(gfp_t gfp_mask);
 
 int idr_alloc(struct idr *, void *ptr, int start, int end, gfp_t);
-- 
2.17.1
