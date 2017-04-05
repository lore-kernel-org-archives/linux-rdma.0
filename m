From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/5] IB/qib: Use kmalloc_array() in qib_init_7322_variables()
Date: Wed, 5 Apr 2017 15:52:48 +0200
Message-ID: <894a5d6c-882c-0bd9-f3ec-80fc8b7c355c@users.sourceforge.net>
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
Date: Wed, 5 Apr 2017 09:51:33 +0200

Multiplications for the size determination of memory allocations
indicated that array data structures should be processed.
Thus use the corresponding function "kmalloc_array".

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/qib/qib_iba7322.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index e4e4e675c89c..490f432809b8 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -6442,12 +6442,15 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 	sbufcnt = dd->piobcnt2k + dd->piobcnt4k +
 		NUM_VL15_BUFS + BITS_PER_LONG - 1;
 	sbufcnt /= BITS_PER_LONG;
-	dd->cspec->sendchkenable = kmalloc(sbufcnt *
-		sizeof(*dd->cspec->sendchkenable), GFP_KERNEL);
-	dd->cspec->sendgrhchk = kmalloc(sbufcnt *
-		sizeof(*dd->cspec->sendgrhchk), GFP_KERNEL);
-	dd->cspec->sendibchk = kmalloc(sbufcnt *
-		sizeof(*dd->cspec->sendibchk), GFP_KERNEL);
+	dd->cspec->sendchkenable = kmalloc_array(sbufcnt,
+						 sizeof(*dd->cspec->sendchkenable),
+						 GFP_KERNEL);
+	dd->cspec->sendgrhchk = kmalloc_array(sbufcnt,
+					      sizeof(*dd->cspec->sendgrhchk),
+					      GFP_KERNEL);
+	dd->cspec->sendibchk = kmalloc_array(sbufcnt,
+					     sizeof(*dd->cspec->sendibchk),
+					     GFP_KERNEL);
 	if (!dd->cspec->sendchkenable || !dd->cspec->sendgrhchk ||
 		!dd->cspec->sendibchk) {
 		ret = -ENOMEM;
-- 
2.12.2
