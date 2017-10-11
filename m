From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 33/45] RDMA/ocrdma: Remove set-but-not-used variables
Date: Wed, 11 Oct 2017 10:49:15 -0700
Message-ID: <20171011174927.25113-34-bart.vanassche@wdc.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 4 ++--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index eaacb71b0bff..f8c14c7baedb 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -3187,7 +3187,7 @@ void ocrdma_eqd_set_task(struct work_struct *work)
 	struct ocrdma_dev *dev =
 		container_of(work, struct ocrdma_dev, eqd_work.work);
 	struct ocrdma_eq *eq = NULL;
-	int i, num = 0, status = -EINVAL;
+	int i, num = 0;
 	u64 eq_intr;
 
 	for (i = 0; i < dev->eq_cnt; i++) {
@@ -3209,7 +3209,7 @@ void ocrdma_eqd_set_task(struct work_struct *work)
 	}
 
 	if (num)
-		status = ocrdma_modify_eqd(dev, &dev->eq_tbl[0], num);
+		ocrdma_modify_eqd(dev, &dev->eq_tbl[0], num);
 	schedule_delayed_work(&dev->eqd_work, msecs_to_jiffies(1000));
 }
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 3757f1b8cbfc..7866fd8051f6 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -66,9 +66,7 @@ int ocrdma_query_gid(struct ib_device *ibdev, u8 port,
 		     int index, union ib_gid *sgid)
 {
 	int ret;
-	struct ocrdma_dev *dev;
 
-	dev = get_ocrdma_dev(ibdev);
 	memset(sgid, 0, sizeof(*sgid));
 	if (index >= OCRDMA_MAX_SGID)
 		return -EINVAL;
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
