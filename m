From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 6/8] bnxt_re: Remove RTNL lock dependency in bnxt_re_query_port
Date: Thu, 31 Aug 2017 09:27:33 +0530
Message-ID: <20170831035735.19595-7-somnath.kotur@broadcom.com>
References: <20170831035735.19595-1-somnath.kotur@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170831035735.19595-1-somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When there is a NETDEV_UNREGISTER event, bnxt_re driver calls
ib_unregister_device() (RTNL lock held).
ib_unregister_device attempts to flush a worker queue scheduled by
ib_core and that queue might have a pending ib_query_port().
ib_query_port in turn calls bnxt_re_query_port(), which while querying the
link speed using ib_get_eth_speed(), tries to acquire the rtnl_lock() which
was already held by NETDEV_UNREGISTER.
Fixing the issue by removing the link speed query from bnxt_re_query_port()
Now the speed is queried post a successful ib_register_device or whenever
there is a NETDEV_CHANGE event.

Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h  |  2 ++
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 11 +++--------
 drivers/infiniband/hw/bnxt_re/main.c     |  4 ++++
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index a25f9d2..ecbac91 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -110,6 +110,8 @@ struct bnxt_re_dev {
 
 	struct delayed_work		worker;
 	u8				cur_prio_map;
+	u8				active_speed;
+	u8				active_width;
 
 	/* FP Notification Queue (CQ & SRQ) */
 	struct tasklet_struct		nq_task;
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 712a62b..cf0440c 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -259,14 +259,9 @@ int bnxt_re_query_port(struct ib_device *ibdev, u8 port_num,
 	port_attr->sm_sl = 0;
 	port_attr->subnet_timeout = 0;
 	port_attr->init_type_reply = 0;
-	/* call the underlying netdev's ethtool hooks to query speed settings
-	 * for which we acquire rtnl_lock _only_ if it's registered with
-	 * IB stack to avoid race in the NETDEV_UNREG path
-	 */
-	if (test_bit(BNXT_RE_FLAG_IBDEV_REGISTERED, &rdev->flags))
-		if (ib_get_eth_speed(ibdev, port_num, &port_attr->active_speed,
-				     &port_attr->active_width))
-			return -EINVAL;
+	port_attr->active_speed = rdev->active_speed;
+	port_attr->active_width = rdev->active_width;
+
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 29c3d7e..e7450ea 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -1161,6 +1161,8 @@ static int bnxt_re_ib_reg(struct bnxt_re_dev *rdev)
 		}
 	}
 	set_bit(BNXT_RE_FLAG_IBDEV_REGISTERED, &rdev->flags);
+	ib_get_eth_speed(&rdev->ibdev, 1, &rdev->active_speed,
+			 &rdev->active_width);
 	bnxt_re_dispatch_event(&rdev->ibdev, NULL, 1, IB_EVENT_PORT_ACTIVE);
 	bnxt_re_dispatch_event(&rdev->ibdev, NULL, 1, IB_EVENT_GID_CHANGE);
 
@@ -1255,6 +1257,8 @@ static void bnxt_re_task(struct work_struct *work)
 		else if (netif_carrier_ok(rdev->netdev))
 			bnxt_re_dispatch_event(&rdev->ibdev, NULL, 1,
 					       IB_EVENT_PORT_ACTIVE);
+		ib_get_eth_speed(&rdev->ibdev, 1, &rdev->active_speed,
+				 &rdev->active_width);
 		break;
 	default:
 		break;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
