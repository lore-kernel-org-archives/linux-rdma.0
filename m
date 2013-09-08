From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/cma: use cached gids
Date: Sun,  8 Sep 2013 17:44:25 -0400
Message-ID: <681df2ae830b20b81fef0c57c41f3bbce5c8c1cc.1378676509.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The cma_acquire_dev function was changed by commit 3c86aa70bf67
to use find_gid_port because multiport devices might have
either IB or IBoE formatted gids.  The old function assumed that
all ports on the same device used the same GID format.  However,
when it was changed to use find_gid_port, we inadvertently lost
usage of the GID cache.  This turned out to be a very costly
change.  In our testing, each iteration through each index of
the GID table takes roughly 35us.  When you have multiple
devices in a system, and the GID you are looking for is on one
of the later devices, the code loops through all of the GID
indexes on all of the early devices before it finally succeeds
on the target device.  This pathological search behavior combined
with 35us per GID table index retrieval results in results such
as the following from the cmtime application that's part of the
latest librdmacm git repo:

cmtime -b <card1, port1, mthca> -c 10000

step              total ms     max ms     min us  us / conn
create id    :       33.88       0.06       1.00       3.39
bind addr    :     1029.22       0.42      85.00     102.92
resolve addr :       50.40      25.93   23244.00       5.04
resolve route:      578.06     551.67   26457.00      57.81
create qp    :      603.69       0.33      51.00      60.37
connect      :     6461.23    6417.50   43963.00     646.12
disconnect   :      877.99     659.96  162985.00      87.80
destroy      :       38.67       0.03       2.00       3.87

cmtime -b <card1, port2, mthca> -c 10000

step              total ms     max ms     min us  us / conn
create id    :       34.74       0.07       1.00       3.47
bind addr    :    21759.39       2.75    1874.00    2175.94
resolve addr :       50.67      26.30   23962.00       5.07
resolve route:      622.68     594.80   27952.00      62.27
create qp    :      599.82       0.23      49.00      59.98
connect      :    24761.36   24709.28   49183.00    2476.14
disconnect   :      904.57     652.34  187201.00      90.46
destroy      :       38.94       0.04       2.00       3.89

cmtime -b <card2, port1, mlx4, IB> -c 10000

step              total ms     max ms     min us  us / conn
create id    :       35.13       0.05       1.00       3.51
bind addr    :    47421.04       6.38    3896.00    4742.10
resolve addr :       50.60      25.54   24248.00       5.06
resolve route:      524.76     498.97   25861.00      52.48
create qp    :     3137.70       5.68     251.00     313.77
connect      :    48959.76   48894.49   31841.00    4895.98
disconnect   :   101926.72   98431.12  538689.00   10192.67
destroy      :       37.63       0.04       2.00       3.76

cmtime -b <card2, port2, mlx4, IBoE> -c 5000

step              total ms     max ms     min us  us / conn
create id    :       28.04       0.05       1.00       5.61
bind addr    :      235.03       0.17      41.00      47.01
resolve addr :       27.45      14.97   12308.00       5.49
resolve route:      556.26     540.88   15514.00     111.25
create qp    :     1323.23       5.73     210.00     264.65
connect      :    84025.30   83960.46   61319.00   16805.06
disconnect   :     2273.15    1734.22  417534.00     454.63
destroy      :       21.28       0.06       2.00       4.26

Clearly, both the bind address and connect operations suffer
a huge penalty for being anything other than the default
GID on the first port in the system.  Note: I had to reduce
the number of connections to 5000 to get the IBoE test to
complete, so it's numbers aren't fully comparable to the
rest of the tests.

After applying this patch, the numbers now look like this:

cmtime -b <card1, port1, mthca> -c 10000

step              total ms     max ms     min us  us / conn
create id    :       30.30       0.04       1.00       3.03
bind addr    :       26.15       0.03       1.00       2.62
resolve addr :       47.18      24.62   22336.00       4.72
resolve route:      642.78     617.61   25242.00      64.28
create qp    :      610.06       0.61      52.00      61.01
connect      :    43362.32   43303.70   59353.00    4336.23
disconnect   :      877.59     658.70  165291.00      87.76
destroy      :       40.03       0.05       2.00       4.00

cmtime -b <card1, port2, mthca> -c 10000

step              total ms     max ms     min us  us / conn
create id    :       31.34       0.07       1.00       3.13
bind addr    :       42.37       0.03       3.00       4.24
resolve addr :       47.19      24.92   22003.00       4.72
resolve route:      580.25     553.65   26680.00      58.03
create qp    :      687.45       0.30      52.00      68.74
connect      :    37457.12   37384.62   73015.00    3745.71
disconnect   :      900.72     648.67  183825.00      90.07
destroy      :       39.05       0.05       2.00       3.90

cmtime -b <card2, port1, mlx4, IB> -c 10000

step              total ms     max ms     min us  us / conn
create id    :       36.26       0.05       1.00       3.63
bind addr    :       75.29       0.10       4.00       7.53
resolve addr :       52.59      28.60   24753.00       5.26
resolve route:      628.05     602.16   25969.00      62.80
create qp    :     3125.12       5.48     272.00     312.51
connect      :    55779.52   55704.92   75617.00    5577.95
disconnect   :   100925.06   98429.45  476384.00   10092.51
destroy      :       51.92       0.07       2.00       5.19

cmtime -b <card2, port2, mlx4, IBoE> -c 5000

step              total ms     max ms     min us  us / conn
create id    :       26.89       0.05       1.00       5.38
bind addr    :       27.51       0.03       4.00       5.50
resolve addr :       22.77      11.78   11004.00       4.55
resolve route:      505.13     489.99   15252.00     101.03
create qp    :     1331.86       5.71     209.00     266.37
connect      :    82606.75   82537.34   70746.00   16521.35
disconnect   :     2261.20    1734.62  406724.00     452.24
destroy      :       22.19       0.04       2.00       4.44

Many thanks to Neil Horman for helping to track the source of
slow function that allowed us to track down the fact that
the original patch I mentioned above backed out cache usage
and identify just how much that impacted the system.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 35 ++++++-----------------------------
 1 file changed, 6 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index dab4b41..c62ff9e 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -328,28 +328,6 @@ static int cma_set_qkey(struct rdma_id_private *id_priv, u32 qkey)
 	return ret;
 }
 
-static int find_gid_port(struct ib_device *device, union ib_gid *gid, u8 port_num)
-{
-	int i;
-	int err;
-	struct ib_port_attr props;
-	union ib_gid tmp;
-
-	err = ib_query_port(device, port_num, &props);
-	if (err)
-		return err;
-
-	for (i = 0; i < props.gid_tbl_len; ++i) {
-		err = ib_query_gid(device, port_num, i, &tmp);
-		if (err)
-			return err;
-		if (!memcmp(&tmp, gid, sizeof tmp))
-			return 0;
-	}
-
-	return -EADDRNOTAVAIL;
-}
-
 static void cma_translate_ib(struct sockaddr_ib *sib, struct rdma_dev_addr *dev_addr)
 {
 	dev_addr->dev_type = ARPHRD_INFINIBAND;
@@ -377,7 +355,7 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv)
 	struct cma_device *cma_dev;
 	union ib_gid gid, iboe_gid;
 	int ret = -ENODEV;
-	u8 port;
+	u8 port, found_port;
 	enum rdma_link_layer dev_ll = dev_addr->dev_type == ARPHRD_INFINIBAND ?
 		IB_LINK_LAYER_INFINIBAND : IB_LINK_LAYER_ETHERNET;
 
@@ -390,20 +368,19 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv)
 	memcpy(&gid, dev_addr->src_dev_addr +
 	       rdma_addr_gid_offset(dev_addr), sizeof gid);
 	list_for_each_entry(cma_dev, &dev_list, list) {
-		for (port = 1; port <= cma_dev->device->phys_port_cnt; ++port) {
+		for (port = 1; port <= cma_dev->device->phys_port_cnt; ++port)
 			if (rdma_port_get_link_layer(cma_dev->device, port) == dev_ll) {
 				if (rdma_node_get_transport(cma_dev->device->node_type) == RDMA_TRANSPORT_IB &&
 				    rdma_port_get_link_layer(cma_dev->device, port) == IB_LINK_LAYER_ETHERNET)
-					ret = find_gid_port(cma_dev->device, &iboe_gid, port);
+					ret = ib_find_cached_gid(cma_dev->device, &iboe_gid, &found_port, NULL);
 				else
-					ret = find_gid_port(cma_dev->device, &gid, port);
+					ret = ib_find_cached_gid(cma_dev->device, &gid, &found_port, NULL);
 
-				if (!ret) {
-					id_priv->id.port_num = port;
+				if (!ret && (port == found_port)) {
+					id_priv->id.port_num = found_port;
 					goto out;
 				}
 			}
-		}
 	}
 
 out:
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
