From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 04/12] IB/ocrdma: Delete unnecessary variable
 initialisations in ocrdma_mbx_get_dcbx_config()
Date: Sat, 22 Apr 2017 16:40:19 +0200
Message-ID: <518c3609-4539-9a9a-b441-d3f3538984c0@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <1492720999.3041.18.camel@redhat.com>
 <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
Content-Language: en-GB
Sender: kernel-janitors-owner@vger.kernel.org
To: Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 22 Apr 2017 13:38:33 +0200

The local variables "req" and "rsp" will be set to appropriate pointers
a bit later. Thus omit the explicit initialisations at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 7e58a74102f6..aa32bc9f323d 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2894,9 +2894,8 @@ static int ocrdma_mbx_get_dcbx_config(struct ocrdma_dev *dev, u32 ptype,
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
2.12.2

