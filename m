From: Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v3 rdma-next 1/3] qed*: Change dpi_addr to be denoted with __iomem
Date: Thu, 13 Jun 2019 11:38:17 +0300
Message-ID: <20190613083819.6998-2-michal.kalderon@marvell.com>
References: <20190613083819.6998-1-michal.kalderon@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190613083819.6998-1-michal.kalderon@marvell.com>
Sender: netdev-owner@vger.kernel.org
To: michal.kalderon@marvell.com, ariel.elior@marvell.com, jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Several casts were required around dpi_addr parameter in qed_rdma_if.h
This is an address on the doorbell bar and should therefore be marked
with __iomem.

Reported-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/hw/qedr/main.c          | 2 +-
 drivers/infiniband/hw/qedr/qedr.h          | 2 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 6 +++---
 include/linux/qed/qed_rdma_if.h            | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index 083c2c00a8e9..3d1f32d56b37 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -813,7 +813,7 @@ static int qedr_init_hw(struct qedr_dev *dev)
 	if (rc)
 		goto out;
 
-	dev->db_addr = (void __iomem *)(uintptr_t)out_params.dpi_addr;
+	dev->db_addr = out_params.dpi_addr;
 	dev->db_phys_addr = out_params.dpi_phys_addr;
 	dev->db_size = out_params.dpi_size;
 	dev->dpi = out_params.dpi;
diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index 6175d1e98717..8df56aba9d2c 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -227,7 +227,7 @@ struct qedr_ucontext {
 	struct ib_ucontext ibucontext;
 	struct qedr_dev *dev;
 	struct qedr_pd *pd;
-	u64 dpi_addr;
+	void __iomem *dpi_addr;
 	u64 dpi_phys_addr;
 	u32 dpi_size;
 	u16 dpi;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 7873d6dfd91f..fef3e6979a26 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -799,9 +799,9 @@ static int qed_rdma_add_user(void *rdma_cxt,
 	/* Calculate the corresponding DPI address */
 	dpi_start_offset = p_hwfn->dpi_start_offset;
 
-	out_params->dpi_addr = (u64)((u8 __iomem *)p_hwfn->doorbells +
-				     dpi_start_offset +
-				     ((out_params->dpi) * p_hwfn->dpi_size));
+	out_params->dpi_addr = ((u8 __iomem *)p_hwfn->doorbells +
+				dpi_start_offset +
+				((out_params->dpi) * p_hwfn->dpi_size));
 
 	out_params->dpi_phys_addr = p_hwfn->cdev->db_phys_addr +
 				    dpi_start_offset +
diff --git a/include/linux/qed/qed_rdma_if.h b/include/linux/qed/qed_rdma_if.h
index d15f8e4815e3..834166809a6c 100644
--- a/include/linux/qed/qed_rdma_if.h
+++ b/include/linux/qed/qed_rdma_if.h
@@ -225,7 +225,7 @@ struct qed_rdma_start_in_params {
 
 struct qed_rdma_add_user_out_params {
 	u16 dpi;
-	u64 dpi_addr;
+	void __iomem *dpi_addr;
 	u64 dpi_phys_addr;
 	u32 dpi_size;
 	u16 wid_count;
-- 
2.14.5
