From: Arseny Maslennikov <ar@cs.msu.ru>
Subject: [PATCH 2/3] IB/ipoib: Stop using dev_id to expose port numbers
Date: Mon, 13 Aug 2018 14:42:23 +0300
Message-ID: <20180813114224.7065-3-ar@cs.msu.ru>
References: <20180813114224.7065-1-ar@cs.msu.ru>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180813114224.7065-1-ar@cs.msu.ru>
Sender: netdev-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: Arseny Maslennikov <ar@cs.msu.ru>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Some InfiniBand network devices have multiple ports on the same PCI
function. Prior to this the kernel erroneously used the `dev_id' sysfs
field of those network interfaces to convey the port number to userspace.

`dev_id' is currently reserved for distinguishing stacked ifaces
(e.g: VLANs) with the same hardware address as their parent device.

Similar fixes to net/mlx4_en and many other drivers, which started
exporting this information through `dev_id' before 3.15, were accepted
into the kernel 4 years ago.
See 76a066f2a2a0268b565459c417b59724b5a3197b, commit message:
`net/mlx4_en: Expose port number through sysfs'.

I would be OK with this commit not being backported to stable, since
it might break admin-supplied udev rules and the likes.

Signed-off-by: Arseny Maslennikov <ar@cs.msu.ru>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 6eb0594fffec..f64535038147 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2252,7 +2252,6 @@ static struct net_device *ipoib_add_port(const char *format,
 	}
 
 	SET_NETDEV_DEV(priv->dev, hca->dev.parent);
-	priv->dev->dev_id = port - 1;
 	priv->dev->dev_port = port - 1;
 
 	result = ib_query_port(hca, port, &attr);
-- 
2.18.0
