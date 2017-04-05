From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 5/5] IB/qib: Adjust two size determinations in
 qib_init_pportdata()
Date: Wed, 5 Apr 2017 15:55:39 +0200
Message-ID: <b5bc4160-aace-b919-7fe2-a4742d03c4ba@users.sourceforge.net>
References: <c16b18ac-287f-5faf-b79a-c86e2adfa22c@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c16b18ac-287f-5faf-b79a-c86e2adfa22c@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mike Marciniszyn <infinipath@intel.com>, Sean Hefty <sean.hefty@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 5 Apr 2017 15:00:44 +0200

* Replace the specification of two data structures by pointer dereferences
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

* Delete the local variable "size" which became unnecessary with
  this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/qib/qib_init.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 101580f0460a..e223226ed94d 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -222,8 +222,6 @@ struct qib_ctxtdata *qib_create_ctxtdata(struct qib_pportdata *ppd, u32 ctxt,
 int qib_init_pportdata(struct qib_pportdata *ppd, struct qib_devdata *dd,
 			u8 hw_pidx, u8 port)
 {
-	int size;
-
 	ppd->dd = dd;
 	ppd->hw_pidx = hw_pidx;
 	ppd->port = port; /* IB port number, not index */
@@ -270,13 +268,14 @@ int qib_init_pportdata(struct qib_pportdata *ppd, struct qib_devdata *dd,
 	if (!ppd->congestion_entries)
 		goto bail_1;
 
-	size = sizeof(struct cc_table_shadow);
-	ppd->ccti_entries_shadow = kzalloc(size, GFP_KERNEL);
+	ppd->ccti_entries_shadow = kzalloc(sizeof(*ppd->ccti_entries_shadow),
+					   GFP_KERNEL);
 	if (!ppd->ccti_entries_shadow)
 		goto bail_2;
 
-	size = sizeof(struct ib_cc_congestion_setting_attr);
-	ppd->congestion_entries_shadow = kzalloc(size, GFP_KERNEL);
+	ppd->congestion_entries_shadow = kzalloc(sizeof(*ppd
+							->congestion_entries_shadow),
+						 GFP_KERNEL);
 	if (!ppd->congestion_entries_shadow)
 		goto bail_3;
 
-- 
2.12.2
