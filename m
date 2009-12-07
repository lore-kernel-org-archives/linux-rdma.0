From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] IPoIB: synchronize timer deletion with completion
	handler
Date: Mon, 7 Dec 2009 19:22:10 +0200
Message-ID: <20091207172210.GA8441@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When calling del_timer_sync on priv->poll_timer, it is necessary to prevent
farther arming of the timer which can be done by a completion handler. Though
it is harmless since the timer will eventually stop being rearmed, it is better
practice to avoid calling the timer function after it is deleted. This patch
handles this by using a new flag that is checked before arming the timer.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h    |    1 +
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 753a983..3c6f931 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -92,6 +92,7 @@ enum {
 	IPOIB_FLAG_ADMIN_CM	  = 9,
 	IPOIB_FLAG_UMCAST	  = 10,
 	IPOIB_FLAG_CSUM		  = 11,
+	IPOIB_FLAG_POLL_TIMER	  = 12,
 
 	IPOIB_MAX_BACKOFF_SECONDS = 16,
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 8c91d9f..b946a01 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -481,7 +481,8 @@ void ipoib_send_comp_handler(struct ib_cq *cq, void *dev_ptr)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev_ptr);
 
-	mod_timer(&priv->poll_timer, jiffies);
+	if (test_bit(IPOIB_FLAG_POLL_TIMER, &priv->flags))
+		mod_timer(&priv->poll_timer, jiffies);
 }
 
 static inline int post_send(struct ipoib_dev_priv *priv,
@@ -860,6 +861,7 @@ int ipoib_ib_dev_stop(struct net_device *dev, int flush)
 	ipoib_dbg(priv, "All sends and receives done.\n");
 
 timeout:
+	clear_bit(IPOIB_FLAG_POLL_TIMER, &priv->flags);
 	del_timer_sync(&priv->poll_timer);
 	qp_attr.qp_state = IB_QPS_RESET;
 	if (ib_modify_qp(priv->qp, &qp_attr, IB_QP_STATE))
@@ -904,6 +906,7 @@ int ipoib_ib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 
 	setup_timer(&priv->poll_timer, ipoib_ib_tx_timer_func,
 		    (unsigned long) dev);
+	set_bit(IPOIB_FLAG_POLL_TIMER, &priv->flags);
 
 	if (dev->flags & IFF_UP) {
 		if (ipoib_ib_dev_open(dev)) {
-- 
1.6.5.5
