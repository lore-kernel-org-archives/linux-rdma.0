From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 6/6] IB/ipoib: add support for clones / multiple childs on
 the same partition
Date: Wed, 11 Jan 2012 19:06:15 +0200
Message-ID: <alpine.LRH.2.00.1201111905150.10264@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1201111850330.10264@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1201111850330.10264-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ali Ayoub <ali-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow creating "clone" child interfaces which further partition an IPoIB
interface to sub interfaces which either use the same pkey as their parent
or use the same pkey as an already created child interface.

Each child now has a child index, which together with the pkey is
used as the identifier of the created network device.

Child interfaces can still be created/deleted using only the pkey,
and they are referred to as legacy childs.

Non-legacy, clone childs of IPoIB device named ibN are named ibN.pkey.index
and those using the same pkey as the parent ibN device are named ibN.index,
where (0x8001 <= pkey <= 0xffff) as before this change, and (0 < index <= 255),
example device names are:

legacy - ib0, ib1, ib0.8001, ib0.8002

non-legacy (clones) - ib0.1, ib0.2, ib0.8001.1, ib0.8001.2

All sorts of childs are still created/deleted through sysfs, in a similar
manner to the way legacy child interfaces are.

A major use case for clone childs is for virtualization purposes, e.g under
schemes where a per VM NIC / HW queue is desired at the hypervisor level.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

for the case of non-legacy and same pkey childs I wanted to use
a notation of ibN.pkey:index and ibN:index but this is problematic with
tools (e.g ifconfig) who treat devices with colon in their names as aliases
which are restriced, e.g w.r.t counters, etc, any ideas?

 Documentation/infiniband/ipoib.txt        |   24 ++++++++++++++
 drivers/infiniband/ulp/ipoib/ipoib.h      |    9 ++++-
 drivers/infiniband/ulp/ipoib/ipoib_main.c |   48 +++++++++++++++++++++-------
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c |   40 +++++++++++++++--------
 4 files changed, 93 insertions(+), 28 deletions(-)

diff --git a/Documentation/infiniband/ipoib.txt b/Documentation/infiniband/ipoib.txt
index 64eeb55..2c958f8 100644
--- a/Documentation/infiniband/ipoib.txt
+++ b/Documentation/infiniband/ipoib.txt
@@ -24,6 +24,30 @@ Partitions and P_Keys
   The P_Key for any interface is given by the "pkey" file, and the
   main interface for a subinterface is in "parent."

+Clones
+
+  It is possible to further partition an IPoIB interfaces, and create
+  "clone" child interfaces which either use the same pkey as their
+  parent, or as an already created child interface. Each child now has
+  a child index, which together with the pkey is used as the identifier
+  of the created network device.
+
+ All sorts of childs are still created/deleted through sysfs, in a
+ similar manner to the way conventional child interfaces are, for example:
+
+    echo 0x8001.1 > /sys/class/net/ib0/create_child
+
+  will create an interface named ib0.8001.1 with P_Key 0x8001 and index 1
+
+    echo .1 > /sys/class/net/ib0/create_child
+
+  will create an interface named ib0.1 with same P_Key as ib0 and index 1
+
+  To remove a such subinterface, use the "delete_child" file:
+
+    echo 0x8001.1 > /sys/class/net/ib0/create_child
+    echo .1  > /sys/class/net/ib0/create_child
+
 Datagram vs Connected modes

   The IPoIB driver supports two modes of operation: datagram and
diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index b3cc1e0..53e021d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -101,6 +101,8 @@ enum {

 	MAX_SEND_CQE		  = 16,
 	IPOIB_CM_COPYBREAK	  = 256,
+
+	MAX_CHILDS_PER_PKEY	  = 255,
 };

 #define	IPOIB_OP_RECV   (1ul << 31)
@@ -330,6 +332,7 @@ struct ipoib_dev_priv {
 	struct net_device *parent;
 	struct list_head child_intfs;
 	struct list_head list;
+	int child_index;

 #ifdef CONFIG_INFINIBAND_IPOIB_CM
 	struct ipoib_cm_dev_priv cm;
@@ -488,8 +491,10 @@ void ipoib_transport_dev_cleanup(struct net_device *dev);
 void ipoib_event(struct ib_event_handler *handler,
 		 struct ib_event *record);

-int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey);
-int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey);
+int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey,
+						unsigned char clone_index);
+int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey,
+						unsigned char clone_index);

 void ipoib_pkey_poll(struct work_struct *work);
 int ipoib_pkey_dev_delay_open(struct net_device *dev);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 3514ca0..3a6848d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1110,17 +1110,44 @@ int ipoib_add_umcast_attr(struct net_device *dev)
 	return device_create_file(&dev->dev, &dev_attr_umcast);
 }

+static int parse_child(struct device *dev, const char *buf, int *pkey,
+		int *child_index)
+{
+	int ret;
+	struct ipoib_dev_priv *priv = netdev_priv(to_net_dev(dev));
+
+	*pkey = *child_index = -1;
+
+	/* 'pkey' or 'pkey.child_index' or '.child_index' are allowed */
+	ret = sscanf(buf, "%i.%i", pkey, child_index);
+	if (ret == 1)  /* just pkey, implicit child index is 0 */
+		*child_index = 0;
+	else  if (ret != 2) { /* pkey same as parent, specified child index */
+		*pkey = priv->pkey;
+		ret  = sscanf(buf, ".%i", child_index);
+		if (ret != 1 || *child_index == 0)
+			return -EINVAL;
+	}
+
+	if (*child_index < 0 || *child_index > MAX_CHILDS_PER_PKEY)
+		return -EINVAL;
+
+	if (*pkey < 0 || *pkey > 0xffff)
+		return -EINVAL;
+
+	ipoib_dbg(priv, "parse_child inp %s out pkey %04x index %d\n",
+		buf, *pkey, *child_index);
+	return 0;
+}
+
 static ssize_t create_child(struct device *dev,
 			    struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
-	int pkey;
+	int pkey, child_index;
 	int ret;

-	if (sscanf(buf, "%i", &pkey) != 1)
-		return -EINVAL;
-
-	if (pkey < 0 || pkey > 0xffff)
+	if (parse_child(dev, buf, &pkey, &child_index))
 		return -EINVAL;

 	/*
@@ -1129,7 +1156,7 @@ static ssize_t create_child(struct device *dev,
 	 */
 	pkey |= 0x8000;

-	ret = ipoib_vlan_add(to_net_dev(dev), pkey);
+	ret = ipoib_vlan_add(to_net_dev(dev), pkey, child_index);

 	return ret ? ret : count;
 }
@@ -1139,16 +1166,13 @@ static ssize_t delete_child(struct device *dev,
 			    struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
-	int pkey;
+	int pkey, child_index;
 	int ret;

-	if (sscanf(buf, "%i", &pkey) != 1)
-		return -EINVAL;
-
-	if (pkey < 0 || pkey > 0xffff)
+	if (parse_child(dev, buf, &pkey, &child_index))
 		return -EINVAL;

-	ret = ipoib_vlan_delete(to_net_dev(dev), pkey);
+	ret = ipoib_vlan_delete(to_net_dev(dev), pkey, child_index);

 	return ret ? ret : count;

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index d7e9740..3ea888d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -49,7 +49,8 @@ static ssize_t show_parent(struct device *d, struct device_attribute *attr,
 }
 static DEVICE_ATTR(parent, S_IRUGO, show_parent, NULL);

-int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
+int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey,
+		unsigned char child_index)
 {
 	struct ipoib_dev_priv *ppriv, *priv;
 	char intf_name[IFNAMSIZ];
@@ -65,25 +66,34 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 	mutex_lock(&ppriv->vlan_mutex);

 	/*
-	 * First ensure this isn't a duplicate. We check the parent device and
-	 * then all of the child interfaces to make sure the Pkey doesn't match.
+	 * First ensure this isn't a duplicate. We check all of the child
+	 * interfaces to make sure the Pkey AND the child index
+	 * don't match.
 	 */
-	if (ppriv->pkey == pkey) {
-		result = -ENOTUNIQ;
-		priv = NULL;
-		goto err;
-	}
-
 	list_for_each_entry(priv, &ppriv->child_intfs, list) {
-		if (priv->pkey == pkey) {
+		if (priv->pkey == pkey && priv->child_index == child_index) {
 			result = -ENOTUNIQ;
 			priv = NULL;
 			goto err;
 		}
 	}

-	snprintf(intf_name, sizeof intf_name, "%s.%04x",
-		 ppriv->dev->name, pkey);
+	if (ppriv->pkey != pkey && child_index == 0) /* legacy child */
+		snprintf(intf_name, sizeof intf_name, "%s.%04x",
+			 ppriv->dev->name, pkey);
+	else if (ppriv->pkey != pkey && child_index != 0) /* non-legacy child */
+		snprintf(intf_name, sizeof intf_name, "%s.%04x.%d",
+			 ppriv->dev->name, pkey, child_index);
+	else if (ppriv->pkey == pkey && child_index != 0) /* same pkey child */
+		snprintf(intf_name, sizeof intf_name, "%s.%d",
+			 ppriv->dev->name, child_index);
+	else  {
+		printk(KERN_ERR "wrong pkey/child_index pairing %04x %d\n",
+				pkey, child_index);
+		result = -EINVAL;
+		goto err;
+	}
+
 	priv = ipoib_intf_alloc(intf_name);
 	if (!priv) {
 		result = -ENOMEM;
@@ -101,6 +111,7 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 		goto err;

 	priv->pkey = pkey;
+	priv->child_index = child_index;

 	memcpy(priv->dev->dev_addr, ppriv->dev->dev_addr, INFINIBAND_ALEN);
 	priv->dev->broadcast[8] = pkey >> 8;
@@ -157,7 +168,8 @@ err:
 	return result;
 }

-int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey)
+int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey,
+		unsigned char child_index)
 {
 	struct ipoib_dev_priv *ppriv, *priv, *tpriv;
 	struct net_device *dev = NULL;
@@ -171,7 +183,7 @@ int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey)
 		return restart_syscall();
 	mutex_lock(&ppriv->vlan_mutex);
 	list_for_each_entry_safe(priv, tpriv, &ppriv->child_intfs, list) {
-		if (priv->pkey == pkey) {
+		if (priv->pkey == pkey && priv->child_index == child_index) {
 			unregister_netdevice(priv->dev);
 			ipoib_dev_cleanup(priv->dev);
 			list_del(&priv->list);
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
