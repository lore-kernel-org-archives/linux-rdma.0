From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-next 1/4] IB/hfi1: Fix SL array bounds check
Date: Thu, 20 Sep 2018 12:44:15 -0700
Message-ID: <20180920194408.7072.55727.stgit@scvm10.sc.intel.com>
References: <20180920193538.7072.71796.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180920193538.7072.71796.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

The SL specified by a user needs to be a valid SL.

Add a range check to the user specified SL value which protects from
running off the end of the SL to SC table.

CC: stable@vger.kernel.org
Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/verbs.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 13374c7..a7c586a 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1582,6 +1582,7 @@ static int hfi1_check_ah(struct ib_device *ibdev, struct rdma_ah_attr *ah_attr)
 	struct hfi1_pportdata *ppd;
 	struct hfi1_devdata *dd;
 	u8 sc5;
+	u8 sl;
 
 	if (hfi1_check_mcast(rdma_ah_get_dlid(ah_attr)) &&
 	    !(rdma_ah_get_ah_flags(ah_attr) & IB_AH_GRH))
@@ -1590,8 +1591,13 @@ static int hfi1_check_ah(struct ib_device *ibdev, struct rdma_ah_attr *ah_attr)
 	/* test the mapping for validity */
 	ibp = to_iport(ibdev, rdma_ah_get_port_num(ah_attr));
 	ppd = ppd_from_ibp(ibp);
-	sc5 = ibp->sl_to_sc[rdma_ah_get_sl(ah_attr)];
 	dd = dd_from_ppd(ppd);
+
+	sl = rdma_ah_get_sl(ah_attr);
+	if (sl >= ARRAY_SIZE(ibp->sl_to_sc))
+		return -EINVAL;
+
+	sc5 = ibp->sl_to_sc[sl];
 	if (sc_to_vlt(dd, sc5) > num_vls && sc_to_vlt(dd, sc5) != 0xf)
 		return -EINVAL;
 	return 0;
