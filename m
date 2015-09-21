From: Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 04/38] IB/ehca: fix handling idr_alloc result
Date: Mon, 21 Sep 2015 15:33:36 +0200
Message-ID: <1442842450-29769-5-git-send-email-a.hajda@samsung.com>
References: <1442842450-29769-1-git-send-email-a.hajda@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-reply-to: <1442842450-29769-1-git-send-email-a.hajda@samsung.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrzej Hajda <a.hajda@samsung.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Marek Szyprowski <m.szyprowski@samsung.com>
List-Id: linux-rdma@vger.kernel.org

The function can return negative value.

The problem has been detected using proposed semantic patch
scripts/coccinelle/tests/unsigned_lesser_than_zero.cocci [1].

[1]: http://permalink.gmane.org/gmane.linux.kernel/2038576

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/staging/rdma/ehca/ehca_cq.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rdma/ehca/ehca_cq.c b/drivers/staging/rdma/ehca/ehca_cq.c
index 9b68b17..ea1b5c1 100644
--- a/drivers/staging/rdma/ehca/ehca_cq.c
+++ b/drivers/staging/rdma/ehca/ehca_cq.c
@@ -130,7 +130,7 @@ struct ib_cq *ehca_create_cq(struct ib_device *device,
 	void *vpage;
 	u32 counter;
 	u64 rpage, cqx_fec, h_ret;
-	int ipz_rc, i;
+	int rc, i;
 	unsigned long flags;
 
 	if (attr->flags)
@@ -170,16 +170,17 @@ struct ib_cq *ehca_create_cq(struct ib_device *device,
 
 	idr_preload(GFP_KERNEL);
 	write_lock_irqsave(&ehca_cq_idr_lock, flags);
-	my_cq->token = idr_alloc(&ehca_cq_idr, my_cq, 0, 0x2000000, GFP_NOWAIT);
+	rc = idr_alloc(&ehca_cq_idr, my_cq, 0, 0x2000000, GFP_NOWAIT);
 	write_unlock_irqrestore(&ehca_cq_idr_lock, flags);
 	idr_preload_end();
 
-	if (my_cq->token < 0) {
+	if (rc < 0) {
 		cq = ERR_PTR(-ENOMEM);
 		ehca_err(device, "Can't allocate new idr entry. device=%p",
 			 device);
 		goto create_cq_exit1;
 	}
+	my_cq->token = rc;
 
 	/*
 	 * CQs maximum depth is 4GB-64, but we need additional 20 as buffer
@@ -195,11 +196,11 @@ struct ib_cq *ehca_create_cq(struct ib_device *device,
 		goto create_cq_exit2;
 	}
 
-	ipz_rc = ipz_queue_ctor(NULL, &my_cq->ipz_queue, param.act_pages,
+	rc = ipz_queue_ctor(NULL, &my_cq->ipz_queue, param.act_pages,
 				EHCA_PAGESIZE, sizeof(struct ehca_cqe), 0, 0);
-	if (!ipz_rc) {
+	if (!rc) {
 		ehca_err(device, "ipz_queue_ctor() failed ipz_rc=%i device=%p",
-			 ipz_rc, device);
+			 rc, device);
 		cq = ERR_PTR(-EINVAL);
 		goto create_cq_exit3;
 	}
-- 
1.9.1
