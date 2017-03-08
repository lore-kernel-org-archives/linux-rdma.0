From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 07/26] IB/ocrdma: Improve another size determination in
 ocrdma_mbx_get_ctrl_attribs()
Date: Wed, 8 Mar 2017 13:55:59 +0100
Message-ID: <b00fd477-8e8c-e9d9-4136-5a3f43b84277@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 7 Mar 2017 20:07:25 +0100

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 56f29e06dfe4..1f7d88d7569e 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1331,7 +1331,7 @@ static int ocrdma_mbx_get_ctrl_attribs(struct ocrdma_dev *dev)
 	struct ocrdma_get_ctrl_attribs_rsp *ctrl_attr_rsp;
 	struct mgmt_hba_attribs *hba_attribs;
 
-	mqe = kzalloc(sizeof(struct ocrdma_mqe), GFP_KERNEL);
+	mqe = kzalloc(sizeof(*mqe), GFP_KERNEL);
 	if (!mqe)
 		return status;
 
-- 
2.12.0
