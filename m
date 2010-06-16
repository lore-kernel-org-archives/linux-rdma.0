From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] pkey fix for ipoib - resubmission
Date: Wed, 16 Jun 2010 08:59:03 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7A43@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I never got a response to this patch, so I'm sending it again.

-----------------

IPoIB is coded to use the 1st PKey in the PKey table as its ib0 interface. Additional ib0.pkey interfaces may be created using the /sys/class/... add_child interface.

However, there is a race.  During normal boot, IPoIB will be started before the port is Active.  Hence the pkey table has not yet been programmed and has a default pkey table (with 0xffff as only pkey).

Later when the SM moves the port to Active, the SM may program the pkey table differently.  However at this point IPoIB has already started using the incorrect pkey.

It appears that the initially formatted 'broadcast' mgid is never updated to supply actual pkey value if ipoib comes up before hca port. Proposed patch targets two issues:

1. Suppress activation of interface and join multicast group queries (it will fail anyway) until hca port is initialized. When port becomes active - update pkey value and move on.
2. Update broadcast mgid based on actual pkey, then issue join broadcast group request.

Signed-Off-By: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

-------
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index ec6b4fb..496d96c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -51,6 +51,7 @@ MODULE_PARM_DESC(data_debug_level,
 #endif
 
 static DEFINE_MUTEX(pkey_mutex);
+static void ipoib_pkey_dev_check_presence(struct net_device *dev);
 
 struct ipoib_ah *ipoib_create_ah(struct net_device *dev,
 				 struct ib_pd *pd, struct ib_ah_attr *attr) @@ -654,12 +655,13 @@ int ipoib_ib_dev_open(struct net_device *dev)
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	int ret;
 
-	if (ib_find_pkey(priv->ca, priv->port, priv->pkey, &priv->pkey_index)) {
+	ipoib_pkey_dev_check_presence(dev);
+
+	if (!test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags)) {
 		ipoib_warn(priv, "P_Key 0x%04x not found\n", priv->pkey);
 		clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
 		return -1;
 	}
-	set_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
 
 	ret = ipoib_init_qp(dev);
 	if (ret) {
@@ -694,9 +696,26 @@ int ipoib_ib_dev_open(struct net_device *dev)  static void ipoib_pkey_dev_check_presence(struct net_device *dev)  {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
-	u16 pkey_index = 0;
+	struct ib_port_attr    port_attr;
+
+	if (!test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags)) {
+		clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
+		if (ib_query_port(priv->ca, priv->port, &port_attr)) {
+			ipoib_warn(priv, "Query port attrs failed\n");
+			return;
+		}
+
+		if (port_attr.state != IB_PORT_ACTIVE)
+			return;
+
+		if (ib_query_pkey(priv->ca, priv->port, 0, &priv->pkey)) {
+			ipoib_warn(priv, "Query P_Key table entry 0 failed\n");
+			return;
+		}
+		set_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
+	}
 
-	if (ib_find_pkey(priv->ca, priv->port, priv->pkey, &pkey_index))
+	if (ib_find_pkey(priv->ca, priv->port, priv->pkey, &priv->pkey_index))
 		clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
 	else
 		set_bit(IPOIB_PKEY_ASSIGNED, &priv->flags); @@ -955,7 +974,8 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
 		}
 
 		/* restart QP only if P_Key index is changed */
-		if (test_and_set_bit(IPOIB_PKEY_ASSIGNED, &priv->flags) &&
+		if (test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags) &&
+		    test_and_set_bit(IPOIB_PKEY_ASSIGNED, &priv->flags) &&
 		    new_index == priv->pkey_index) {
 			ipoib_dbg(priv, "Not flushing - P_Key index not changed.\n");
 			return;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 3871ac6..6fe6527 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -552,6 +552,13 @@ void ipoib_mcast_join_task(struct work_struct *work)
 		}
 
 		spin_lock_irq(&priv->lock);
+
+		if (!test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags)) {
+			/* fix broadcast gid in case if pkey was changed */
+			priv->pkey |= 0x8000;
+			priv->dev->broadcast[8] = priv->pkey >> 8;
+			priv->dev->broadcast[9] = priv->pkey & 0xff;
+		}
 		memcpy(broadcast->mcmember.mgid.raw, priv->dev->broadcast + 4,
 		       sizeof (union ib_gid));
 		priv->broadcast = broadcast;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
