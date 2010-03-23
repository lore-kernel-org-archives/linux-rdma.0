From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] [PATCH 9/22] [for 2.6.36] rdma/cm: add support for AF_IB to rdma_resolve_addr
Date: Tue, 23 Mar 2010 11:06:05 -0700
Message-ID: <9E248C187E8E4CFBB3C5E20CB92F13E9@amr.corp.intel.com>
References: <2F3826558E79459EAD2A457A604221C1@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2F3826558E79459EAD2A457A604221C1-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow the user to specify the remote address using AF_IB format.
When AF_IB is used, the remote address simply needs to be recorded,
and no resolution using ARP is done.  The local address may still
need to be resolved however.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/cma.c |  108 +++++++++++++++++++++++++++++++++++++++--
 1 files changed, 102 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 0bc33cc..c7b6912 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -350,6 +350,62 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv)
 	return ret;
 }
 
+/*
+ * Select the source IB device and address to reach the destination IB address.
+ */
+static int cma_resolve_ib_dev(struct rdma_id_private *id_priv)
+{
+	struct cma_device *cma_dev, *cur_dev;
+	struct sockaddr_ib *addr;
+	union ib_gid gid, sgid, *dgid;
+	u16 pkey, index;
+	u8 port, p;
+	int i;
+
+	cma_dev = NULL;
+	addr = (struct sockaddr_ib *) &id_priv->id.route.addr.dst_addr;
+	dgid = (union ib_gid *) &addr->sib_addr;
+	pkey = ntohs(addr->sib_pkey);
+
+	list_for_each_entry(cur_dev, &dev_list, list) {
+		if (rdma_node_get_transport(cur_dev->device->node_type) != RDMA_TRANSPORT_IB)
+			continue;
+
+		for (p = 1; p <= cur_dev->device->phys_port_cnt; ++p) {
+			if (ib_find_cached_pkey(cur_dev->device, p, pkey, &index))
+				continue;
+
+			for (i = 0; !ib_get_cached_gid(cur_dev->device, p, i, &gid); i++) {
+				if (!memcmp(&gid, dgid, sizeof(gid))) {
+					cma_dev = cur_dev;
+					sgid = gid;
+					port = p;
+					goto found;
+				}
+
+				if (!cma_dev && (gid.global.subnet_prefix ==
+						 dgid->global.subnet_prefix)) {
+					cma_dev = cur_dev;
+					sgid = gid;
+					port = p;
+				}
+			}
+		}
+	}
+
+	if (!cma_dev) {
+		return -ENODEV;
+	}
+
+found:
+	cma_attach_to_dev(id_priv, cma_dev);
+	id_priv->id.port_num = port;
+	addr = (struct sockaddr_ib *) &id_priv->id.route.addr.src_addr;
+	memcpy(&addr->sib_addr, &sgid, sizeof sgid);
+	cma_translate_ib(addr, &id_priv->id.route.addr.dev_addr);
+	return 0;
+}
+
 static void cma_deref_id(struct rdma_id_private *id_priv)
 {
 	if (atomic_dec_and_test(&id_priv->refcount))
@@ -1930,14 +1986,48 @@ err:
 	return ret;
 }
 
+static int cma_resolve_ib_addr(struct rdma_id_private *id_priv)
+{
+	struct cma_work *work;
+	int ret;
+
+	work = kzalloc(sizeof *work, GFP_KERNEL);
+	if (!work)
+		return -ENOMEM;
+
+	if (!id_priv->cma_dev) {
+		ret = cma_resolve_ib_dev(id_priv);
+		if (ret)
+			goto err;
+	}
+
+	rdma_addr_set_dgid(&id_priv->id.route.addr.dev_addr, (union ib_gid *)
+		&(((struct sockaddr_ib *) &id_priv->id.route.addr.dst_addr)->sib_addr));
+
+	work->id = id_priv;
+	INIT_WORK(&work->work, cma_work_handler);
+	work->old_state = CMA_ADDR_QUERY;
+	work->new_state = CMA_ADDR_RESOLVED;
+	work->event.event = RDMA_CM_EVENT_ADDR_RESOLVED;
+	queue_work(cma_wq, &work->work);
+	return 0;
+err:
+	kfree(work);
+	return ret;
+}
+
 static int cma_bind_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 			 struct sockaddr *dst_addr)
 {
 	if (!src_addr || !src_addr->sa_family) {
 		src_addr = (struct sockaddr *) &id->route.addr.src_addr;
-		if ((src_addr->sa_family = dst_addr->sa_family) == AF_INET6) {
+		src_addr->sa_family = dst_addr->sa_family;
+		if (dst_addr->sa_family == AF_INET6) {
 			((struct sockaddr_in6 *) src_addr)->sin6_scope_id =
 				((struct sockaddr_in6 *) dst_addr)->sin6_scope_id;
+		} else if (dst_addr->sa_family == AF_IB) {
+			((struct sockaddr_ib *) src_addr)->sib_pkey =
+				((struct sockaddr_ib *) dst_addr)->sib_pkey;
 		}
 	}
 	return rdma_bind_addr(id, src_addr);
@@ -1961,12 +2051,18 @@ int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 
 	atomic_inc(&id_priv->refcount);
 	memcpy(&id->route.addr.dst_addr, dst_addr, rdma_addr_size(dst_addr));
-	if (cma_any_addr(dst_addr))
+	if (cma_any_addr(dst_addr)) {
 		ret = cma_resolve_loopback(id_priv);
-	else
-		ret = rdma_resolve_ip(&addr_client, (struct sockaddr *) &id->route.addr.src_addr,
-				      dst_addr, &id->route.addr.dev_addr,
-				      timeout_ms, addr_handler, id_priv);
+	} else {
+		if (dst_addr->sa_family == AF_IB) {
+			ret = cma_resolve_ib_addr(id_priv);
+		} else {
+			ret = rdma_resolve_ip(&addr_client,
+					      (struct sockaddr *) &id->route.addr.src_addr,
+					      dst_addr, &id->route.addr.dev_addr,
+					      timeout_ms, addr_handler, id_priv);
+		}
+	}
 	if (ret)
 		goto err;
 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
