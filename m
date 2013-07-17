From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH FIXES for-3.11 4/4] IB/ipoib: Fix pkey-change flow for Virtualization environments
Date: Wed, 17 Jul 2013 16:52:37 +0300
Message-ID: <1374069157-16996-5-git-send-email-ogerlitz@mellanox.com>
References: <1374069157-16996-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1374069157-16996-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

IPoIB's required behaviour w.r.t to the pkey used by the device is the following:

- For "parent" interfaces (e.g ib0, ib1, etc) who are created automatically as a
  result of hot-plug events from the IB core, the driver needs to take whatever
  pkey vlaue it finds in index 0, and stick to that index.

- For child interfaces (e.g ib0.8001, etc) created by admin directive, the driver
  needs to use and stick to the value provided during its creation.

In SR-IOV environment its possible for the VF probe to take place before the
cloud management software provisions the suitable pkey for the VF in the
paravirtualed PKEY table index 0. When this is the case, the VF IB stack will
find in index 0 an invalide pkey, which is all zeros.

Moreover, the cloud managment can assign the pkey value at index 0 at any
time of the guest life cycle.

The correct behavior for IPoIB to address these requirements for parent
interfaces is to use PKEY_CHANGE event as trigger to optionally re-init the
device pkey value and re-create all the relevant resources accordingly, if
the value of the pkey in index 0 has changed (from invalid to valid or from
valid value X to invalid value Y).

This patch enhances the heavy flushing code which is triggered by pkey change
event, to behave correctly for parent devices. For child devices, the code
remains the same, namely chases pkey value and not index.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |   68 +++++++++++++++++++-----
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   12 ++++-
 2 files changed, 66 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 2cfa76f..a2db524 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -932,12 +932,39 @@ int ipoib_ib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 	return 0;
 }
 
+/*
+ * Takes whatever value which is in pkey index 0 and updates priv->pkey
+ * returns 0 if the pkey value was changed.
+ */
+static inline int update_parent_pkey_index(struct ipoib_dev_priv *priv)
+{
+	int result;
+	u16 prev_pkey;
+
+	prev_pkey = priv->pkey;
+	result = ib_query_pkey(priv->ca, priv->port, 0, &priv->pkey);
+	if (result) {
+		ipoib_warn(priv, "ib_query_pkey port %d failed (ret = %d)\n",
+			   priv->port, result);
+		return result;
+	}
+
+	if (prev_pkey != priv->pkey) {
+		ipoib_dbg(priv, "pkey changed from 0x%x to 0x%x\n",
+			  prev_pkey, priv->pkey);
+		return 0;
+	}
+
+	return 1;
+}
+
 static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
 				enum ipoib_flush_level level)
 {
 	struct ipoib_dev_priv *cpriv;
 	struct net_device *dev = priv->dev;
 	u16 new_index;
+	int result;
 
 	mutex_lock(&priv->vlan_mutex);
 
@@ -951,6 +978,10 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
 	mutex_unlock(&priv->vlan_mutex);
 
 	if (!test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags)) {
+		/* for non-child devices must check/update the pkey value here */
+		if (level == IPOIB_FLUSH_HEAVY &&
+		    !test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags))
+			update_parent_pkey_index(priv);
 		ipoib_dbg(priv, "Not flushing - IPOIB_FLAG_INITIALIZED not set.\n");
 		return;
 	}
@@ -961,21 +992,32 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
 	}
 
 	if (level == IPOIB_FLUSH_HEAVY) {
-		if (ib_find_pkey(priv->ca, priv->port, priv->pkey, &new_index)) {
-			clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
-			ipoib_ib_dev_down(dev, 0);
-			ipoib_ib_dev_stop(dev, 0);
-			if (ipoib_pkey_dev_delay_open(dev))
+		/* child devices chase their origin pkey value, while non-child
+		 * (parent) devices should always takes what present in pkey index 0
+		 */
+		if (test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags)) {
+			if (ib_find_pkey(priv->ca, priv->port, priv->pkey, &new_index)) {
+				clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
+				ipoib_ib_dev_down(dev, 0);
+				ipoib_ib_dev_stop(dev, 0);
+				if (ipoib_pkey_dev_delay_open(dev))
+					return;
+			}
+			/* restart QP only if P_Key index is changed */
+			if (test_and_set_bit(IPOIB_PKEY_ASSIGNED, &priv->flags) &&
+			    new_index == priv->pkey_index) {
+				ipoib_dbg(priv, "Not flushing - P_Key index not changed.\n");
 				return;
+			}
+			priv->pkey_index = new_index;
+		} else {
+			result = update_parent_pkey_index(priv);
+			/* restart QP only if P_Key value changed */
+			if (result) {
+				ipoib_dbg(priv, "Not flushing - P_Key index not changed.\n");
+				return;
+			}
 		}
-
-		/* restart QP only if P_Key index is changed */
-		if (test_and_set_bit(IPOIB_PKEY_ASSIGNED, &priv->flags) &&
-		    new_index == priv->pkey_index) {
-			ipoib_dbg(priv, "Not flushing - P_Key index not changed.\n");
-			return;
-		}
-		priv->pkey_index = new_index;
 	}
 
 	if (level == IPOIB_FLUSH_LIGHT) {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index cecb98a..9a7e53d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -516,8 +516,18 @@ void ipoib_mcast_join_task(struct work_struct *work)
 
 	if (ib_query_gid(priv->ca, priv->port, 0, &priv->local_gid))
 		ipoib_warn(priv, "ib_query_gid() failed\n");
-	else
+	else {
 		memcpy(priv->dev->dev_addr + 4, priv->local_gid.raw, sizeof (union ib_gid));
+		/*
+		 * Update the pkey in the broadcast address, as for parent
+		 * devices it can change according to pkey change event. When
+		 * doing so, make sure to update the full membership bit, so
+		 * that we join the right broadcast group, etc.
+		 */
+		priv->pkey |= 0x8000;
+		priv->dev->broadcast[8] = priv->pkey >> 8;
+		priv->dev->broadcast[9] = priv->pkey & 0xff;
+	}
 
 	{
 		struct ib_port_attr attr;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
