From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 5/8] bnxt_re: Fix race between the netdev register and unregister events
Date: Thu, 31 Aug 2017 09:27:32 +0530
Message-ID: <20170831035735.19595-6-somnath.kotur@broadcom.com>
References: <20170831035735.19595-1-somnath.kotur@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170831035735.19595-1-somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Upon receipt of the NETDEV_REGISTER event from the netdev notifier chain,
the IB stack registration is spawned off to a workqueue since that also
requires an rtnl lock.
There could be 2 kinds of races between the NETDEV_REGISTER and the
NETDEV_UNREGISTER event handling.
a)The NETDEV_UNREGISTER event is received in rapid succession after
the NETDEV_REGISTER event even before the work queue got a chance to run.
b)The NETDEV_UNREGISTER event is received while the workqueue that handles
registration with the IB stack is still in progress.
Handle both the races with a bit flag that is set just before the work item
is queued and cleared in the workqueue after the event is handled just
before the workqueue item is freed.

Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h | 12 +++++++-----
 drivers/infiniband/hw/bnxt_re/main.c    |  8 ++++++++
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index b3ad37f..a25f9d2 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -93,11 +93,13 @@ struct bnxt_re_dev {
 	struct ib_device		ibdev;
 	struct list_head		list;
 	unsigned long			flags;
-#define BNXT_RE_FLAG_NETDEV_REGISTERED	0
-#define BNXT_RE_FLAG_IBDEV_REGISTERED	1
-#define BNXT_RE_FLAG_GOT_MSIX		2
-#define BNXT_RE_FLAG_RCFW_CHANNEL_EN	8
-#define BNXT_RE_FLAG_QOS_WORK_REG	16
+#define BNXT_RE_FLAG_NETDEV_REGISTERED		0
+#define BNXT_RE_FLAG_IBDEV_REGISTERED		1
+#define BNXT_RE_FLAG_GOT_MSIX			2
+#define BNXT_RE_FLAG_HAVE_L2_REF		3
+#define BNXT_RE_FLAG_RCFW_CHANNEL_EN		4
+#define BNXT_RE_FLAG_QOS_WORK_REG		5
+#define BNXT_RE_FLAG_TASK_IN_PROG		6
 	struct net_device		*netdev;
 	unsigned int			version, major, minor;
 	struct bnxt_en_dev		*en_dev;
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 00a3b74..29c3d7e 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -1259,6 +1259,8 @@ static void bnxt_re_task(struct work_struct *work)
 	default:
 		break;
 	}
+	smp_mb__before_atomic();
+	clear_bit(BNXT_RE_FLAG_TASK_IN_PROG, &rdev->flags);
 	kfree(re_work);
 }
 
@@ -1317,6 +1319,11 @@ static int bnxt_re_netdev_event(struct notifier_block *notifier,
 		break;
 
 	case NETDEV_UNREGISTER:
+		/* netdev notifier will call NETDEV_UNREGISTER again later since
+		 * we are still holding the reference to the netdev
+		 */
+		if (test_bit(BNXT_RE_FLAG_TASK_IN_PROG, &rdev->flags))
+			goto exit;
 		bnxt_re_ib_unreg(rdev, false);
 		bnxt_re_remove_one(rdev);
 		bnxt_re_dev_unreg(rdev);
@@ -1335,6 +1342,7 @@ static int bnxt_re_netdev_event(struct notifier_block *notifier,
 			re_work->vlan_dev = (real_dev == netdev ?
 					     NULL : netdev);
 			INIT_WORK(&re_work->work, bnxt_re_task);
+			set_bit(BNXT_RE_FLAG_TASK_IN_PROG, &rdev->flags);
 			queue_work(bnxt_re_wq, &re_work->work);
 		}
 	}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
