From: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-3.17 v7 1/1] IB/ipoib: Avoid multicast join attempts
 when having invalid p_key
Date: Wed, 06 Aug 2014 14:40:32 -0400
Message-ID: <20140806184032.7627.26167.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Currently, the parent interface keeps sending broadcast group join
requests even if p_key index 0 is invalid, which for itself is
possible/common in virtualized environmentswhere a VF has been probed to
VM but the actual p_key configuration has not yet been assigned by the
management software. This creates unnecessary noise on the fabric and in
the kernel logs:

ib0: multicast join failed for ff12:401b:8000:0000:0000:0000:ffff:ffff,
status -22

The original code run the multicast task regardless of the actual
p_key value, which can be avoided. The fix is to re-init resources  and
bring interface up only if p_key index 0 is valid either when starting
up or on PKEY_CHANGE event.

Fixes: c290414169 ('IPoIB: Fix pkey change flow for virtualization environments')

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes from v6
-patch is refactored and rebased for 3.17
Changes from v5:
-reinit child interface pkey_index before pkey lookup & compare.
Changes from v4:
- streamline child interface pkey event handling,
- shutdown of pkey polling thread depends on PKEY_STOP flag state only.
Original ipoib_ib_dev_down() could leave polling thread active
if PKEY_ASSIGNED flag was set. That could create a racing condition on followed
re-initialization of QP resources.
Changes from v3:
Updated chagelog and fixed alignemnt
as suggested by Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Changes from v2:
Handle pkey change event for a case when interface is down
(pointed out by Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>).
Changes from v1:
p_key check for 'Invalid' value was moved to
ipoib_pkey_dev_check_presence() that is used now in ipoib_ib_dev_open()
for p_key validation.
---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c   |   80 +++++++++++++++--------------
 drivers/infiniband/ulp/ipoib/ipoib_main.c |   11 +---
 2 files changed, 46 insertions(+), 45 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 9dcb2c9..72626c3 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -669,12 +669,13 @@ int ipoib_ib_dev_open(struct net_device *dev, int flush)
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	int ret;
 
-	if (ib_find_pkey(priv->ca, priv->port, priv->pkey, &priv->pkey_index)) {
-		ipoib_warn(priv, "P_Key 0x%04x not found\n", priv->pkey);
-		clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
+	ipoib_pkey_dev_check_presence(dev);
+
+	if (!test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags)) {
+		ipoib_warn(priv, "P_Key 0x%04x is %s\n", priv->pkey,
+			   (!(priv->pkey & 0x7fff) ? "Invalid" : "not found"));
 		return -1;
 	}
-	set_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
 
 	ret = ipoib_init_qp(dev);
 	if (ret) {
@@ -712,9 +713,10 @@ dev_stop:
 void ipoib_pkey_dev_check_presence(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
-	u16 pkey_index = 0;
 
-	if (ib_find_pkey(priv->ca, priv->port, priv->pkey, &pkey_index))
+	if (!(priv->pkey & 0x7fff) ||
+	    ib_find_pkey(priv->ca, priv->port, priv->pkey,
+			 &priv->pkey_index))
 		clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
 	else
 		set_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
@@ -958,13 +960,27 @@ static inline int update_parent_pkey(struct ipoib_dev_priv *priv)
 
 	return 1;
 }
+/*
+ * returns 0 if pkey value was found in a different slot.
+ */
+static inline int update_child_pkey(struct ipoib_dev_priv *priv)
+{
+	u16 old_index = priv->pkey_index;
+
+	priv->pkey_index = 0;
+	ipoib_pkey_dev_check_presence(priv->dev);
+
+	if (test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags) &&
+	    (old_index == priv->pkey_index))
+		return 1;
+	return 0;
+}
 
 static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
 				enum ipoib_flush_level level)
 {
 	struct ipoib_dev_priv *cpriv;
 	struct net_device *dev = priv->dev;
-	u16 new_index;
 	int result;
 
 	down_read(&priv->vlan_rwsem);
@@ -978,19 +994,20 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
 
 	up_read(&priv->vlan_rwsem);
 
-	if (!test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags)) {
-		/* for non-child devices must check/update the pkey value here */
-		if (level == IPOIB_FLUSH_HEAVY) {
-			if (test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags))
-				ipoib_pkey_open(priv);
-			else
-				update_parent_pkey(priv);
-		}
+	if (!test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags) &&
+	    level != IPOIB_FLUSH_HEAVY) {
 		ipoib_dbg(priv, "Not flushing - IPOIB_FLAG_INITIALIZED not set.\n");
 		return;
 	}
 
 	if (!test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags)) {
+		/* interface is down. update pkey and leave. */
+		if (level == IPOIB_FLUSH_HEAVY) {
+			if (!test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags))
+				update_parent_pkey(priv);
+			else
+				update_child_pkey(priv);
+		}
 		ipoib_dbg(priv, "Not flushing - IPOIB_FLAG_ADMIN_UP not set.\n");
 		return;
 	}
@@ -1000,19 +1017,13 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
 		 * (parent) devices should always takes what present in pkey index 0
 		 */
 		if (test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags)) {
-			if (ib_find_pkey(priv->ca, priv->port, priv->pkey, &new_index)) {
-				clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
-				ipoib_ib_dev_down(dev, 0);
-				ipoib_ib_dev_stop(dev, 0);
-				return;
-			}
-			/* restart QP only if P_Key index is changed */
-			if (test_and_set_bit(IPOIB_PKEY_ASSIGNED, &priv->flags) &&
-			    new_index == priv->pkey_index) {
+			result = update_child_pkey(priv);
+			if (result) {
+				/* restart QP only if P_Key index is changed */
 				ipoib_dbg(priv, "Not flushing - P_Key index not changed.\n");
 				return;
 			}
-			priv->pkey_index = new_index;
+
 		} else {
 			result = update_parent_pkey(priv);
 			/* restart QP only if P_Key value changed */
@@ -1032,8 +1043,12 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
 		ipoib_ib_dev_down(dev, 0);
 
 	if (level == IPOIB_FLUSH_HEAVY) {
-		ipoib_ib_dev_stop(dev, 0);
-		ipoib_ib_dev_open(dev, 0);
+		if (test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
+			ipoib_ib_dev_stop(dev, 0);
+		if (ipoib_ib_dev_open(dev, 0) != 0)
+			return;
+		if (netif_queue_stopped(dev))
+			netif_start_queue(dev);
 	}
 
 	/*
@@ -1088,15 +1103,4 @@ void ipoib_ib_dev_cleanup(struct net_device *dev)
 	ipoib_transport_dev_cleanup(dev);
 }
 
-void ipoib_pkey_open(struct ipoib_dev_priv *priv)
-{
-
-	if (test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
-		return;
-
-	ipoib_pkey_dev_check_presence(priv->dev);
-
-	if (test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags))
-		ipoib_open(priv->dev);
-}
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 1bf994a..217cb77 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -108,14 +108,11 @@ int ipoib_open(struct net_device *dev)
 
 	set_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags);
 
-
-	ipoib_pkey_dev_check_presence(dev);
-
-	if (!test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags))
-		return 0;
-
-	if (ipoib_ib_dev_open(dev, 1))
+	if (ipoib_ib_dev_open(dev, 1)) {
+		if (!test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags))
+			return 0;
 		goto err_disable;
+	}
 
 	if (ipoib_ib_dev_up(dev))
 		goto err_stop;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
