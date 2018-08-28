From: Arseny Maslennikov <ar@cs.msu.ru>
Subject: [PATCH 1/3] IB/ipoib: Use dev_port to expose network interface port numbers
Date: Wed, 29 Aug 2018 00:01:15 +0300
Message-ID: <20180828210117.6437-2-ar@cs.msu.ru>
References: <20180828210117.6437-1-ar@cs.msu.ru>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180828210117.6437-1-ar@cs.msu.ru>
Sender: netdev-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: Arseny Maslennikov <ar@cs.msu.ru>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Some InfiniBand network devices have multiple ports on the same PCI
function. This initializes the `dev_port' sysfs field of those
network interfaces with their port number.

The use of `dev_id' was considered correct until Linux 3.15,
when another field, `dev_port', was defined for this particular
purpose and `dev_id' was reserved for distinguishing stacked ifaces
(e.g: VLANs) with the same hardware address as their parent device.

Similar fixes to net/mlx4_en and many other drivers, which started
exporting this information through `dev_id' before 3.15, were accepted
into the kernel 4 years ago.
See 76a066f2a2a0268b565459c417b59724b5a3197b, commit message:
`net/mlx4_en: Expose port number through sysfs'.

Signed-off-by: Arseny Maslennikov <ar@cs.msu.ru>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index e3d28f9ad9c0..fcd69273de91 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1881,6 +1881,7 @@ static int ipoib_parent_init(struct net_device *ndev)
 
 	SET_NETDEV_DEV(priv->dev, priv->ca->dev.parent);
 	priv->dev->dev_id = priv->port - 1;
+	priv->dev->dev_port = priv->port - 1;
 
 	return 0;
 }
-- 
2.18.0
