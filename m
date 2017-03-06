From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 5/5] IB/nes: Improve size determinations in two functions
Date: Mon, 6 Mar 2017 18:44:56 +0100
Message-ID: <540c6942-94c8-4042-0bd0-62dc9140a0c6@users.sourceforge.net>
References: <502a5a6f-ee91-dd2f-cdc7-63f396059529@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <502a5a6f-ee91-dd2f-cdc7-63f396059529@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Faisal Latif <faisal.latif@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 6 Mar 2017 18:12:37 +0100

Replace the specification of two data structures by pointer dereferences
as the parameter for the operator "sizeof" to make the corresponding size
determinations a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/nes/nes_verbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 7764ba423c1c..5cbb62e44d84 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -678,7 +678,7 @@ static struct ib_pd *nes_alloc_pd(struct ib_device *ibdev,
 	if (err)
 		return ERR_PTR(err);
 
-	nespd = kzalloc(sizeof (struct nes_pd), GFP_KERNEL);
+	nespd = kzalloc(sizeof(*nespd), GFP_KERNEL);
 	if (!nespd) {
 		nes_free_resource(nesadapter, nesadapter->allocated_pds, pd_num);
 		return ERR_PTR(-ENOMEM);
@@ -1447,7 +1447,7 @@ static struct ib_cq *nes_create_cq(struct ib_device *ibdev,
 	if (err)
 		return ERR_PTR(err);
 
-	nescq = kzalloc(sizeof(struct nes_cq), GFP_KERNEL);
+	nescq = kzalloc(sizeof(*nescq), GFP_KERNEL);
 	if (!nescq) {
 		nes_free_resource(nesadapter, nesadapter->allocated_cqs, cq_num);
 		return ERR_PTR(-ENOMEM);
-- 
2.12.0

