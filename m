From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 3/3] ib_srpt: Simplify __srpt_lookup_port()
Date: Fri, 11 Nov 2011 12:18:43 +0100
Message-ID: <201111111218.43856.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The sdev->device pointer is initialized in srpt_add_one() and is
not modified until the sdev structure is freed in srpt_remove_one().
An sdev structure is only added to srpt_dev_list after the device
pointer has been initialized and is removed from that list before
srpt_remove_one() returns. Calls to __srpt_lookup_port() are
protected via the same spinlock that protects srpt_dev_list. Hence
the sdev->device pointer is never NULL nor invalid inside
__srpt_lookup_port(). That means that it is safe to remove the
sdev->device test in that function.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index b93e1a0..2b7d6fb 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3144,9 +3144,6 @@ static struct srpt_port *__srpt_lookup_port(const char *name)
 
 	list_for_each_entry(sdev, &srpt_dev_list, list) {
 		dev = sdev->device;
-		if (!dev)
-			continue;
-
 		for (i = 0; i < dev->phys_port_cnt; i++) {
 			sport = &sdev->port[i];
 
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
