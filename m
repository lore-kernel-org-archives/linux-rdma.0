From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [for-2.6.33] rdma/cm: disallow loopback address for
	iwarp devices
Date: Sun, 7 Feb 2010 22:02:11 -0800
Message-ID: <79BAA34231304F1E84C5A5A53C50A207@amr.corp.intel.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com>
	<0D5487526204477AA2ABED06E46768E2@amr.corp.intel.com>
	<4B6C498F.3060708@opengridcomputing.com>
	<38B735478FE94F40BBA3E8BFD794B10F@amr.corp.intel.com>
	<4B6D9948.6040007@opengridcomputing.com>
	<B41CA82E76BB439B892B4874D38EA652@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <B41CA82E76BB439B892B4874D38EA652-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Steve Wise' <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since iWarp devices are not guaranteed to support loopback connections,
prevent rdma_bind_addr from associating the loopback address with
an iWarp device.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
This includes feedback from Steve Wise based on the initial rfc patch.

Although this patch is needed to prevent binding to RDMA devices that
may not support loopback addressing, is also works around a bug in
openmpi using the loopback address to bind to an iwarp device.

This is not a perfect solution either, since it disable all iwarp devices.
The NES driver should be able to support loopback connections, though that
feature has never been tested.  We may need a per device attribute.
I will look at creating such a patch, but wanted to post this in case I
can't get that one done in the next couple of days. 

 drivers/infiniband/core/cma.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index cc9b594..fe8b0c0 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1739,6 +1739,9 @@ err:
 }
 EXPORT_SYMBOL(rdma_resolve_route);
 
+/*
+ * Only IB devices are guaranteed to support loopback connections.
+ */
 static int cma_bind_loopback(struct rdma_id_private *id_priv)
 {
 	struct cma_device *cma_dev;
@@ -1753,14 +1756,19 @@ static int cma_bind_loopback(struct rdma_id_private *id_priv)
 		ret = -ENODEV;
 		goto out;
 	}
-	list_for_each_entry(cma_dev, &dev_list, list)
+	list_for_each_entry(cma_dev, &dev_list, list) {
+		if (rdma_node_get_transport(cma_dev->device->node_type) !=
+		    RDMA_TRANSPORT_IB)
+			continue;
+
 		for (p = 1; p <= cma_dev->device->phys_port_cnt; ++p)
 			if (!ib_query_port(cma_dev->device, p, &port_attr) &&
 			    port_attr.state == IB_PORT_ACTIVE)
 				goto port_found;
+	}
 
-	p = 1;
-	cma_dev = list_entry(dev_list.next, struct cma_device, list);
+	ret = -ENODEV;
+	goto out;
 
 port_found:
 	ret = ib_get_cached_gid(cma_dev->device, p, 0, &gid);
@@ -1771,9 +1779,7 @@ port_found:
 	if (ret)
 		goto out;
 
-	id_priv->id.route.addr.dev_addr.dev_type =
-		(rdma_node_get_transport(cma_dev->device->node_type) == RDMA_TRANSPORT_IB) ?
-		ARPHRD_INFINIBAND : ARPHRD_ETHER;
+	id_priv->id.route.addr.dev_addr.dev_type = ARPHRD_INFINIBAND;
 
 	rdma_addr_set_sgid(&id_priv->id.route.addr.dev_addr, &gid);
 	ib_addr_set_pkey(&id_priv->id.route.addr.dev_addr, pkey);
