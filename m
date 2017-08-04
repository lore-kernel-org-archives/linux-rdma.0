From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-next 01/27] IB/hfi1: Revert egress pkey check enforcement
Date: Fri, 04 Aug 2017 13:52:13 -0700
Message-ID: <20170804205212.17853.906.stgit@scvm10.sc.intel.com>
References: <20170804204842.17853.14858.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170804204842.17853.14858.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Alex Estrin <alex.estrin@intel.com>

Current code has some serious flaws. Disarm the flag
pending an appropriate patch.

Fixes: 53526500f301 ("IB/hfi1: Permanently enable P_Key checking in HFI")
Cc: stable@vger.kernel.org
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Alex Estrin <alex.estrin@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/init.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index be027c9..da7cd5b 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -519,7 +519,6 @@ void hfi1_init_pportdata(struct pci_dev *pdev, struct hfi1_pportdata *ppd,
 
 	ppd->pkeys[default_pkey_idx] = DEFAULT_P_KEY;
 	ppd->part_enforce |= HFI1_PART_ENFORCE_IN;
-	ppd->part_enforce |= HFI1_PART_ENFORCE_OUT;
 
 	if (loopback) {
 		hfi1_early_err(&pdev->dev,
