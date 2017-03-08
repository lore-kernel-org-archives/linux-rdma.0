From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 11/26] IB/ocrdma: Delete unnecessary braces
Date: Wed, 8 Mar 2017 14:04:56 +0100
Message-ID: <c4c62b82-db2a-3db9-03c4-9f8d95a6a29b@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fc421509-4069-da8a-b308-60b49ea91ada-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Tue, 7 Mar 2017 21:12:56 +0100

Do not use curly brackets at some source code places
where a single statement should be sufficient.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index aa32bc9f323d..d5b988b011d1 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1092,14 +1092,14 @@ static int ocrdma_mbx_cmd(struct ocrdma_dev *dev, struct ocrdma_mqe *mqe)
 	if (cqe_status || ext_status) {
 		pr_err("%s() cqe_status=0x%x, ext_status=0x%x,",
 		       __func__, cqe_status, ext_status);
-		if (rsp) {
+		if (rsp)
 			/* This is for embedded cmds. */
 			pr_err("opcode=0x%x, subsystem=0x%x\n",
 			       (rsp->subsys_op & OCRDMA_MBX_RSP_OPCODE_MASK) >>
 				OCRDMA_MBX_RSP_OPCODE_SHIFT,
 				(rsp->subsys_op & OCRDMA_MBX_RSP_SUBSYS_MASK) >>
 				OCRDMA_MBX_RSP_SUBSYS_SHIFT);
-		}
+
 		status = ocrdma_get_mbx_cqe_errno(cqe_status);
 		goto mbx_err;
 	}
@@ -1600,10 +1600,9 @@ void ocrdma_alloc_pd_pool(struct ocrdma_dev *dev)
 		return;
 
 	status = ocrdma_mbx_alloc_pd_range(dev);
-	if (status) {
+	if (status)
 		pr_err("%s(%d) Unable to initialize PD pool, using default.\n",
 			 __func__, dev->id);
-	}
 }
 
 static void ocrdma_free_pd_pool(struct ocrdma_dev *dev)
@@ -2997,11 +2996,10 @@ static int ocrdma_parse_dcbxcfg_rsp(struct ocrdma_dev *dev, int ptype,
 					goto out;
 				}
 			}
-			if (slindx == OCRDMA_MAX_SERVICE_LEVEL_INDEX) {
+			if (slindx == OCRDMA_MAX_SERVICE_LEVEL_INDEX)
 				pr_info("%s ocrdma%d application priority not set for 0x%x protocol\n",
 					dev_name(&dev->nic_info.pdev->dev),
 					dev->id, proto);
-			}
 		}
 	}
 
@@ -3158,16 +3156,17 @@ static int ocrdma_modify_eqd(struct ocrdma_dev *dev, struct ocrdma_eq *eq,
 			     int num)
 {
 	int num_eqs, i = 0;
-	if (num > 8) {
+
+	if (num > 8)
 		while (num) {
 			num_eqs = min(num, 8);
 			ocrdma_mbx_modify_eqd(dev, &eq[i], num_eqs);
 			i += num_eqs;
 			num -= num_eqs;
 		}
-	} else {
+	else
 		ocrdma_mbx_modify_eqd(dev, eq, num);
-	}
+
 	return 0;
 }
 
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
