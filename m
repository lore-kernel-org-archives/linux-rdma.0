From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 08/12] IB/ocrdma: Delete an error message for a failed
 memory allocation in ocrdma_add()
Date: Sat, 22 Apr 2017 16:48:47 +0200
Message-ID: <9d2f449c-bbb9-6ec5-b4db-279f125abf7d@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <1492720999.3041.18.camel@redhat.com>
 <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 22 Apr 2017 14:36:30 +0200

Omit an extra message for a memory allocation failure in this function.

Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Devesh Sharma <devesh.sharma@broadcom.com>
Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index b82f6c6942e0..d3942558b083 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -304,10 +304,9 @@ static struct ocrdma_dev *ocrdma_add(struct be_dev_info *dev_info)
 	struct ocrdma_dev *dev;
 
 	dev = (struct ocrdma_dev *)ib_alloc_device(sizeof(*dev));
-	if (!dev) {
-		pr_err("Unable to allocate ib device\n");
+	if (!dev)
 		return NULL;
-	}
+
 	dev->mbx_cmd = kzalloc(sizeof(struct ocrdma_mqe_emb_cmd), GFP_KERNEL);
 	if (!dev->mbx_cmd)
 		goto idr_err;
-- 
2.12.2
