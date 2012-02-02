From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] IB/srpt: Use DEFINE_SPINLOCK()/LIST_HEAD()
Date: Thu,  2 Feb 2012 12:52:06 -0800
Message-ID: <1328215927-14474-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index cd5d05e..284cb50 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -69,8 +69,8 @@ MODULE_LICENSE("Dual BSD/GPL");
  */
 
 static u64 srpt_service_guid;
-static spinlock_t srpt_dev_lock;       /* Protects srpt_dev_list. */
-static struct list_head srpt_dev_list; /* List of srpt_device structures. */
+static DEFINE_SPINLOCK(srpt_dev_lock);	/* Protects srpt_dev_list. */
+static LIST_HEAD(srpt_dev_list);	/* List of srpt_device structures. */
 
 static unsigned srp_max_req_size = DEFAULT_MAX_REQ_SIZE;
 module_param(srp_max_req_size, int, 0444);
@@ -4010,9 +4010,6 @@ static int __init srpt_init_module(void)
 		goto out;
 	}
 
-	spin_lock_init(&srpt_dev_lock);
-	INIT_LIST_HEAD(&srpt_dev_list);
-
 	ret = -ENODEV;
 	srpt_target = target_fabric_configfs_init(THIS_MODULE, "srpt");
 	if (!srpt_target) {
-- 
1.7.9

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
