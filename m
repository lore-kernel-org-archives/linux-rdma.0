From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 13/15] RDMA/ocrdma: Increase the size of STAG array
Date: Wed, 4 Jun 2014 14:22:44 +0530
Message-ID: <d990a2b0-df37-4eba-bbbd-dfec5290433d@CMEXHTCAS1.ad.emulex.com>
References: <1401871966-20408-1-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-2-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-3-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-4-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-5-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-6-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-7-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-8-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-9-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-10-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-11-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-12-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-13-git-send-email-selvin.xavier@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1401871966-20408-13-git-send-email-selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h      | 2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c | 6 ++++++
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h  | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index fc27378..5716513 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -236,7 +236,7 @@ struct ocrdma_dev {
 	struct list_head entry;
 	struct rcu_head rcu;
 	int id;
-	u64 stag_arr[OCRDMA_MAX_STAG];
+	u64 *stag_arr;
 	u8 sl; /* service level */
 	bool pfc_state;
 	atomic_t update_sl;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 3cb20c6..0d90c7f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -324,6 +324,11 @@ static int ocrdma_alloc_resources(struct ocrdma_dev *dev)
 		if (!dev->qp_tbl)
 			goto alloc_err;
 	}
+
+	dev->stag_arr = kzalloc(sizeof(u64) * OCRDMA_MAX_STAG, GFP_KERNEL);
+	if (dev->stag_arr == NULL)
+		goto alloc_err;
+
 	spin_lock_init(&dev->av_tbl.lock);
 	spin_lock_init(&dev->flush_q_lock);
 	return 0;
@@ -334,6 +339,7 @@ alloc_err:
 
 static void ocrdma_free_resources(struct ocrdma_dev *dev)
 {
+	kfree(dev->stag_arr);
 	kfree(dev->qp_tbl);
 	kfree(dev->cq_tbl);
 	kfree(dev->sgid_tbl);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index a20d348..3d08e66 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -107,7 +107,7 @@ enum {
 
 #define OCRDMA_MAX_QP    2048
 #define OCRDMA_MAX_CQ    2048
-#define OCRDMA_MAX_STAG  8192
+#define OCRDMA_MAX_STAG 16384
 
 enum {
 	OCRDMA_DB_RQ_OFFSET		= 0xE0,
-- 
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
