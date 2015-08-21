From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 2/2] IB/ipoib: Suppress warning for send only join failures
Date: Fri, 21 Aug 2015 17:34:13 -0600
Message-ID: <1440200053-18890-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1440200053-18890-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440200053-18890-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We expect send only joins to fail, it just means there are no listeners
for the group. The correct thing to do is silently drop the packet
at source.

Eg avahi will full join 224.0.0.251 which causes a send only IGMP packet
to 224.0.0.22, and then a warning level kmessage like this:

 ib0: sendonly multicast join failed for ff12:401b:ffff:0000:0000:0000:0000:0016, status -22

If there is no IP router listening to IGMP.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index c0e702c577d5..2d43ec542b63 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -393,8 +393,13 @@ static int ipoib_mcast_join_complete(int status,
 			goto out_locked;
 		}
 	} else {
-		if (mcast->logcount++ < 20) {
-			if (status == -ETIMEDOUT || status == -EAGAIN) {
+		bool silent_fail =
+		    test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) &&
+		    status == -EINVAL;
+
+		if (mcast->logcount < 20) {
+			if (status == -ETIMEDOUT || status == -EAGAIN ||
+			    silent_fail) {
 				ipoib_dbg_mcast(priv, "%smulticast join failed for %pI6, status %d\n",
 						test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) ? "sendonly " : "",
 						mcast->mcmember.mgid.raw, status);
@@ -403,6 +408,9 @@ static int ipoib_mcast_join_complete(int status,
 						test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) ? "sendonly " : "",
 					   mcast->mcmember.mgid.raw, status);
 			}
+
+			if (!silent_fail)
+				mcast->logcount++;
 		}
 
 		if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) &&
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
