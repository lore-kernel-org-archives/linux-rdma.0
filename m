From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] [PATCH 8/22] [for 2.6.36] rdma/cm: restrict AF_IB loopback to binding to IB devices only
Date: Tue, 23 Mar 2010 11:04:27 -0700
Message-ID: <C1F276CECBC24B9094E38F89D798B781@amr.corp.intel.com>
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

If a user specifies AF_IB as the source address for a loopback
connection, limit the resolution to IB devices only.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/cma.c |   30 ++++++++++++++++++++++--------
 1 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 7981a85..0bc33cc 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1795,26 +1795,40 @@ static void cma_set_loopback(struct sockaddr *addr)
 
 static int cma_bind_loopback(struct rdma_id_private *id_priv)
 {
-	struct cma_device *cma_dev;
+	struct cma_device *cma_dev, *cur_dev;
+	struct sockaddr *addr;
 	struct ib_port_attr port_attr;
 	union ib_gid gid;
 	u16 pkey;
 	int ret;
 	u8 p;
 
+	cma_dev = NULL;
+	addr = (struct sockaddr *) &id_priv->id.route.addr.src_addr;
 	mutex_lock(&lock);
-	if (list_empty(&dev_list)) {
+	list_for_each_entry(cur_dev, &dev_list, list) {
+		if (addr->sa_family == AF_IB &&
+		    rdma_node_get_transport(cur_dev->device->node_type) != RDMA_TRANSPORT_IB)
+			continue;
+
+		if (!cma_dev)
+			cma_dev = cur_dev;
+
+		for (p = 1; p <= cur_dev->device->phys_port_cnt; ++p) {
+			if (!ib_query_port(cur_dev->device, p, &port_attr) &&
+			    port_attr.state == IB_PORT_ACTIVE) {
+				cma_dev = cur_dev;
+				goto port_found;
+			}
+		}
+	}
+
+	if (!cma_dev) {
 		ret = -ENODEV;
 		goto out;
 	}
-	list_for_each_entry(cma_dev, &dev_list, list)
-		for (p = 1; p <= cma_dev->device->phys_port_cnt; ++p)
-			if (!ib_query_port(cma_dev->device, p, &port_attr) &&
-			    port_attr.state == IB_PORT_ACTIVE)
-				goto port_found;
 
 	p = 1;
-	cma_dev = list_entry(dev_list.next, struct cma_device, list);
 
 port_found:
 	ret = ib_get_cached_gid(cma_dev->device, p, 0, &gid);



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
