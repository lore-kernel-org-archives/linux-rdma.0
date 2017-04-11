From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 02/18] IB/IPoIB: Remove 'else' when the 'if' has a return.
Date: Tue, 11 Apr 2017 13:42:09 -0400
Message-ID: <1491932545-60894-3-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1491932545-60894-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491932545-60894-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch fixes a checkpatch issue related to not having
to use an 'else' if the 'if' path returns from the function.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 3e3a84f..be2e84d4 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -293,17 +293,16 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
 				-PTR_ERR(ah));
 			/* use original error */
 			return PTR_ERR(ah);
-		} else {
-			spin_lock_irq(&priv->lock);
-			mcast->ah = ah;
-			spin_unlock_irq(&priv->lock);
-
-			ipoib_dbg_mcast(priv, "MGID %pI6 AV %p, LID 0x%04x, SL %d\n",
-					mcast->mcmember.mgid.raw,
-					mcast->ah->ah,
-					be16_to_cpu(mcast->mcmember.mlid),
-					mcast->mcmember.sl);
 		}
+		spin_lock_irq(&priv->lock);
+		mcast->ah = ah;
+		spin_unlock_irq(&priv->lock);
+
+		ipoib_dbg_mcast(priv, "MGID %pI6 AV %p, LID 0x%04x, SL %d\n",
+				mcast->mcmember.mgid.raw,
+				mcast->ah->ah,
+				be16_to_cpu(mcast->mcmember.mlid),
+				mcast->mcmember.sl);
 	}
 
 	/* actually send any queued packets */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
