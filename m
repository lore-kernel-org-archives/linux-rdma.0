From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 04/26] IB/ocrdma: Delete unnecessary variable initialisations
 in ocrdma_mbx_get_dcbx_config()
Date: Wed, 8 Mar 2017 13:48:46 +0100
Message-ID: <5780384b-87ef-fb39-6804-35f7eaada0c7@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 7 Mar 2017 19:25:55 +0100

The local variables "req" and "rsp" will be set to appropriate pointers
a bit later. Thus omit the explicit initialisations at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 85bebb887c5c..517a18e9351a 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2895,9 +2895,8 @@ static int ocrdma_mbx_get_dcbx_config(struct ocrdma_dev *dev, u32 ptype,
 	int status;
 	dma_addr_t pa;
 	struct ocrdma_mqe cmd;
-
-	struct ocrdma_get_dcbx_cfg_req *req = NULL;
-	struct ocrdma_get_dcbx_cfg_rsp *rsp = NULL;
+	struct ocrdma_get_dcbx_cfg_req *req;
+	struct ocrdma_get_dcbx_cfg_rsp *rsp;
 	struct pci_dev *pdev = dev->nic_info.pdev;
 	struct ocrdma_mqe_sge *mqe_sge = cmd.u.nonemb_req.sge;
 
-- 
2.12.0

