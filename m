From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-rc 6/6] RDMA/bnxt_re: Avoid system hang during device un-reg
Date: Thu, 15 Feb 2018 21:20:13 -0800
Message-ID: <1518758413-20850-7-git-send-email-selvin.xavier@broadcom.com>
References: <1518758413-20850-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1518758413-20850-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

BNXT_RE_FLAG_TASK_IN_PROG doesn't handle multiple work
requests posted together. Track schedule of multiple
workqueue items by maintaining a per device counter
and proceed with IB dereg only if this counter is zero.
flush_workqueue is no longer required from
NETDEV_UNREGISTER path.

Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h | 2 +-
 drivers/infiniband/hw/bnxt_re/main.c    | 7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index 5692335..7463067 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -121,7 +121,6 @@ struct bnxt_re_dev {
 #define BNXT_RE_FLAG_HAVE_L2_REF		3
 #define BNXT_RE_FLAG_RCFW_CHANNEL_EN		4
 #define BNXT_RE_FLAG_QOS_WORK_REG		5
-#define BNXT_RE_FLAG_TASK_IN_PROG		6
 #define BNXT_RE_FLAG_ISSUE_ROCE_STATS          29
 	struct net_device		*netdev;
 	unsigned int			version, major, minor;
@@ -159,6 +158,7 @@ struct bnxt_re_dev {
 	atomic_t			srq_count;
 	atomic_t			mr_count;
 	atomic_t			mw_count;
+	atomic_t			sched_count;
 	/* Max of 2 lossless traffic class supported per port */
 	u16				cosq[2];
 
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 560520c..b1aa5a7 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -656,7 +656,6 @@ static void bnxt_re_dev_remove(struct bnxt_re_dev *rdev)
 	mutex_unlock(&bnxt_re_dev_lock);
 
 	synchronize_rcu();
-	flush_workqueue(bnxt_re_wq);
 
 	kfree(rdev->gid_map);
 	ib_dealloc_device(&rdev->ibdev);
@@ -1454,7 +1453,7 @@ static void bnxt_re_task(struct work_struct *work)
 		break;
 	}
 	smp_mb__before_atomic();
-	clear_bit(BNXT_RE_FLAG_TASK_IN_PROG, &rdev->flags);
+	atomic_dec(&rdev->sched_count);
 	kfree(re_work);
 }
 
@@ -1516,7 +1515,7 @@ static int bnxt_re_netdev_event(struct notifier_block *notifier,
 		/* netdev notifier will call NETDEV_UNREGISTER again later since
 		 * we are still holding the reference to the netdev
 		 */
-		if (test_bit(BNXT_RE_FLAG_TASK_IN_PROG, &rdev->flags))
+		if (atomic_read(&rdev->sched_count) > 0)
 			goto exit;
 		bnxt_re_ib_unreg(rdev, false);
 		bnxt_re_remove_one(rdev);
@@ -1536,7 +1535,7 @@ static int bnxt_re_netdev_event(struct notifier_block *notifier,
 			re_work->vlan_dev = (real_dev == netdev ?
 					     NULL : netdev);
 			INIT_WORK(&re_work->work, bnxt_re_task);
-			set_bit(BNXT_RE_FLAG_TASK_IN_PROG, &rdev->flags);
+			atomic_inc(&rdev->sched_count);
 			queue_work(bnxt_re_wq, &re_work->work);
 		}
 	}
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
