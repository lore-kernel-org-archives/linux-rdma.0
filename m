From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] infiniband: hw: qedr: add null check before pointer
 dereference
Date: Mon, 22 May 2017 13:30:15 -0500
Message-ID: <20170522183015.GA22310@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: linux-rdma@vger.kernel.org

Add null check before dereferencing pointer sgid_attr.ndev
inside function rdma_vlan_dev_vlan_id().

Addresses-Coverity-ID: 1373979
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/infiniband/hw/qedr/qedr_cm.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/qedr_cm.c b/drivers/infiniband/hw/qedr/qedr_cm.c
index 3d7705c..d86dbe8 100644
--- a/drivers/infiniband/hw/qedr/qedr_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_cm.c
@@ -270,11 +270,13 @@ static inline int qedr_gsi_build_header(struct qedr_dev *dev,
 		return rc;
 	}
 
-	vlan_id = rdma_vlan_dev_vlan_id(sgid_attr.ndev);
-	if (vlan_id < VLAN_CFI_MASK)
-		has_vlan = true;
-	if (sgid_attr.ndev)
+	if (sgid_attr.ndev) {
+		vlan_id = rdma_vlan_dev_vlan_id(sgid_attr.ndev);
+		if (vlan_id < VLAN_CFI_MASK)
+			has_vlan = true;
+
 		dev_put(sgid_attr.ndev);
+	}
 
 	if (!memcmp(&sgid, &zgid, sizeof(sgid))) {
 		DP_ERR(dev, "gsi post send: GID not found GID index %d\n",
-- 
2.5.0
