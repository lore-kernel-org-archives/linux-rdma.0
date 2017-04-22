From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 06/12] IB/ocrdma: Use kmalloc_array() in
 ocrdma_create_srq()
Date: Sat, 22 Apr 2017 16:45:07 +0200
Message-ID: <899edbe6-3248-d2de-0d09-f9ffef952ec8@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <1492720999.3041.18.camel@redhat.com>
 <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
Content-Language: en-GB
Sender: kernel-janitors-owner@vger.kernel.org
To: Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 22 Apr 2017 14:17:46 +0200

* A multiplication for the size determination of a memory allocation
  indicated that an array data structure should be processed.
  Thus use the corresponding function "kmalloc_array".

  This issue was detected by using the Coccinelle software.

* Replace the specification of a data type by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 16f14d4c3e85..5eaf946aeac6 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1908,8 +1908,9 @@ struct ib_srq *ocrdma_create_srq(struct ib_pd *ibpd,
 
 		srq->bit_fields_len = (srq->rq.max_cnt / 32) +
 		    (srq->rq.max_cnt % 32 ? 1 : 0);
-		srq->idx_bit_fields =
-		    kmalloc(srq->bit_fields_len * sizeof(u32), GFP_KERNEL);
+		srq->idx_bit_fields = kmalloc_array(srq->bit_fields_len,
+						    sizeof(*srq->idx_bit_fields),
+						    GFP_KERNEL);
 		if (srq->idx_bit_fields == NULL)
 			goto arm_err;
 		memset(srq->idx_bit_fields, 0xff,
-- 
2.12.2

