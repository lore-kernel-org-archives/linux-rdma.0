From: Aditya Pakki <pakki001@umn.edu>
Subject: [PATCH] infiniband: bnxt_re: qplib: Check the return value of send_message
Date: Wed, 26 Dec 2018 12:56:22 -0600
Message-ID: <20181226185623.9324-1-pakki001@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: pakki001@umn.edu
Cc: kjlu@umn.edu, Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

In bnxt_qplib_map_tc2cos(), bnxt_qplib_rcfw_send_message() can return
an error value. The fix returns the error from the latter function
upstream.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index 5216b5f844cc..adb8eae5193c 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -778,9 +778,8 @@ int bnxt_qplib_map_tc2cos(struct bnxt_qplib_res *res, u16 *cids)
 	req.cos0 = cpu_to_le16(cids[0]);
 	req.cos1 = cpu_to_le16(cids[1]);
 
-	bnxt_qplib_rcfw_send_message(rcfw, (void *)&req, (void *)&resp, NULL,
-				     0);
-	return 0;
+	return bnxt_qplib_rcfw_send_message(rcfw, (void *)&req, (void *)&resp,
+						NULL, 0);
 }
 
 int bnxt_qplib_get_roce_stats(struct bnxt_qplib_rcfw *rcfw,
-- 
2.17.1
