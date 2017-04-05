From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 3/5] IB/qib: Use kcalloc() in qib_alloc_devdata()
Date: Wed, 5 Apr 2017 15:53:47 +0200
Message-ID: <9bcddc18-197c-0784-bb25-8ac6446d8fb6@users.sourceforge.net>
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
Date: Wed, 5 Apr 2017 14:15:45 +0200

A multiplication for the size determination of a memory allocation
indicated that an array data structure should be processed.
Thus use the corresponding function "kcalloc".

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/qib/qib_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index b50240b1d5a4..9e680ca971e3 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1140,8 +1140,8 @@ struct qib_devdata *qib_alloc_devdata(struct pci_dev *pdev, size_t extra)
 	if (!qib_cpulist_count) {
 		u32 count = num_online_cpus();
 
-		qib_cpulist = kzalloc(BITS_TO_LONGS(count) *
-				      sizeof(long), GFP_KERNEL);
+		qib_cpulist = kcalloc(BITS_TO_LONGS(count), sizeof(long),
+				      GFP_KERNEL);
 		if (qib_cpulist)
 			qib_cpulist_count = count;
 	}
-- 
2.12.2
