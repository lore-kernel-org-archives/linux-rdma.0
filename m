From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 10/11] IB/IPoIB: Modify ipoib_get_net_dev_by_params to lookup gid table
Date: Tue, 22 Nov 2016 14:38:51 -0500
Message-ID: <1479843532-47496-11-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ipoib_get_net_dev_by_params compares incoming gid with local_gid
which is gid at index 0 of the gid table. OPA devices using larger
LIDs may have a different GID format than whats setup in the local_gid
field. Do a search of the gid table in those cases.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 37 +++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 474c3bf..3e135df 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -328,6 +328,40 @@ static struct net_device *ipoib_get_net_dev_match_addr(
 	return result;
 }
 
+/* retuns true if the incoming gid is assigned to the IPoIB
+ * netdev interface
+ *
+ * OPA devices may have the incoming GID in the OPA GID
+ * format which might not necessarily be assigned to the
+ * netdev interface. This necessitates searching the GID
+ * table to match this OPA GID.
+ */
+static bool ipoib_check_gid(struct ipoib_dev_priv *priv,
+			    const union ib_gid *gid)
+{
+	bool is_local_gid;
+	struct ib_port_attr attr;
+	union ib_gid port_gid;
+	int i;
+
+	if (!gid)
+		return true;
+
+	is_local_gid = !memcmp(gid, &priv->local_gid, sizeof(*gid));
+
+	if (!rdma_cap_opa_ah(priv->ca, priv->port) || is_local_gid)
+		return is_local_gid;
+
+	if (ib_query_port(priv->ca, priv->port, &attr))
+		return false;
+	for (i = 1; i < attr.gid_tbl_len; i++) {
+		if (ib_query_gid(priv->ca, priv->port, i, &port_gid, NULL))
+			return false;
+		if (!memcmp(gid, &port_gid, sizeof(*gid)))
+			return true;
+	}
+	return false;
+}
 /* returns the number of IPoIB netdevs on top a given ipoib device matching a
  * pkey_index and address, if one exists.
  *
@@ -344,8 +378,7 @@ static int ipoib_match_gid_pkey_addr(struct ipoib_dev_priv *priv,
 	struct net_device *net_dev = NULL;
 	int matches = 0;
 
-	if (priv->pkey_index == pkey_index &&
-	    (!gid || !memcmp(gid, &priv->local_gid, sizeof(*gid)))) {
+	if (priv->pkey_index == pkey_index && ipoib_check_gid(priv, gid)) {
 		if (!addr) {
 			net_dev = ipoib_get_master_net_dev(priv->dev);
 		} else {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
