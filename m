From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/5] IB/qib: Use kcalloc() in qib_init_iba7322_funcs()
Date: Wed, 5 Apr 2017 15:51:52 +0200
Message-ID: <5e5e00d3-b6a4-7371-65be-c5fe387d26b3@users.sourceforge.net>
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
Date: Wed, 5 Apr 2017 09:43:54 +0200

* A multiplication for the size determination of a memory allocation
  indicated that an array data structure should be processed.
  Thus use the corresponding function "kcalloc".

  This issue was detected by using the Coccinelle software.

* Replace the specification of a data structure by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/qib/qib_iba7322.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index af9f596bb68b..e4e4e675c89c 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -7324,8 +7324,9 @@ struct qib_devdata *qib_init_iba7322_funcs(struct pci_dev *pdev,
 		actual_cnt -= dd->num_pports;
 
 	tabsize = actual_cnt;
-	dd->cspec->msix_entries = kzalloc(tabsize *
-			sizeof(struct qib_msix_entry), GFP_KERNEL);
+	dd->cspec->msix_entries = kcalloc(tabsize,
+					  sizeof(*dd->cspec->msix_entries),
+					  GFP_KERNEL);
 	if (!dd->cspec->msix_entries)
 		tabsize = 0;
 
-- 
2.12.2
