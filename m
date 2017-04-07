From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 4/9] IB/IPoIB: Delete unwanted spaces behind usages of the
 sizeof operator
Date: Fri, 7 Apr 2017 23:03:35 +0200
Message-ID: <3e97b74c-26fa-2965-fa3c-e0f96c62e46e@users.sourceforge.net>
References: <ce4249f2-c7e7-0282-2cff-3f9c3991efa3@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ce4249f2-c7e7-0282-2cff-3f9c3991efa3-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-GB
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Ahern <dsa-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Fri, 7 Apr 2017 20:10:45 +0200

* Replace the source code "sizeof (" by "sizeof("
  according to the Linux coding style convention.

* Adjust indentation at a few places.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 446af4ec3d86..55581417eb43 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -514,8 +514,7 @@ struct ipoib_path *__path_find(struct net_device *dev, void *gid)
 		path = rb_entry(n, struct ipoib_path, rb_node);
 
 		ret = memcmp(gid, path->pathrec.dgid.raw,
-			     sizeof (union ib_gid));
-
+			     sizeof(union ib_gid));
 		if (ret < 0)
 			n = n->rb_left;
 		else if (ret > 0)
@@ -540,7 +539,7 @@ static int __path_add(struct net_device *dev, struct ipoib_path *path)
 		tpath = rb_entry(pn, struct ipoib_path, rb_node);
 
 		ret = memcmp(path->pathrec.dgid.raw, tpath->pathrec.dgid.raw,
-			     sizeof (union ib_gid));
+			     sizeof(union ib_gid));
 		if (ret < 0)
 			n = &pn->rb_left;
 		else if (ret > 0)
@@ -611,7 +610,7 @@ int ipoib_path_iter_next(struct ipoib_path_iter *iter)
 		path = rb_entry(n, struct ipoib_path, rb_node);
 
 		if (memcmp(iter->path.pathrec.dgid.raw, path->pathrec.dgid.raw,
-			   sizeof (union ib_gid)) < 0) {
+			   sizeof(union ib_gid)) < 0) {
 			iter->path = *path;
 			ret = 0;
 			break;
@@ -874,7 +873,7 @@ static struct ipoib_path *path_rec_create(struct net_device *dev, void *gid)
 
 	INIT_LIST_HEAD(&path->neigh_list);
 
-	memcpy(path->pathrec.dgid.raw, gid, sizeof (union ib_gid));
+	memcpy(path->pathrec.dgid.raw, gid, sizeof(union ib_gid));
 	path->pathrec.sgid	    = priv->local_gid;
 	path->pathrec.pkey	    = cpu_to_be16(priv->pkey);
 	path->pathrec.numb_path     = 1;
@@ -1541,7 +1540,8 @@ void ipoib_del_neighs_by_gid(struct net_device *dev, u8 *gid)
 		while ((neigh = rcu_dereference_protected(*np,
 							  lockdep_is_held(&priv->lock))) != NULL) {
 			/* delete neighs belong to this parent */
-			if (!memcmp(gid, neigh->daddr + 4, sizeof (union ib_gid))) {
+			if (!memcmp(gid, neigh->daddr + 4,
+				    sizeof(union ib_gid))) {
 				rcu_assign_pointer(*np,
 						   rcu_dereference_protected(neigh->hnext,
 									     lockdep_is_held(&priv->lock)));
@@ -2060,7 +2060,8 @@ static struct net_device *ipoib_add_port(const char *format,
 		       hca->name, port, result);
 		goto device_init_failed;
 	} else
-		memcpy(priv->dev->dev_addr + 4, priv->local_gid.raw, sizeof (union ib_gid));
+		memcpy(priv->dev->dev_addr + 4, priv->local_gid.raw,
+		       sizeof(union ib_gid));
 	set_bit(IPOIB_FLAG_DEV_ADDR_SET, &priv->flags);
 
 	result = ipoib_dev_init(priv->dev, hca, port);
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
