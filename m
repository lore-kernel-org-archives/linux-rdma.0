From: Sinan Kaya <okaya@codeaurora.org>
Subject: [PATCH v5 2/3] RDMA/i40iw: Eliminate duplicate barriers on weakly-ordered archs
Date: Thu, 22 Mar 2018 12:26:48 -0400
Message-ID: <1521736009-23387-3-git-send-email-okaya@codeaurora.org>
References: <1521736009-23387-1-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521736009-23387-1-git-send-email-okaya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Sinan Kaya <okaya@codeaurora.org>, Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Code includes wmb() followed by writel(). writel() already has a barrier on
some architectures like arm64.

This ends up CPU observing two barriers back to back before executing the
register write.

Create a new wrapper function with relaxed write operator. Use the new
wrapper when a write is following a wmb().

Since code already has an explicit barrier call, changing writel() to
writel_relaxed().

Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c  |  6 ++++--
 drivers/infiniband/hw/i40iw/i40iw_osdep.h |  1 +
 drivers/infiniband/hw/i40iw/i40iw_uk.c    |  3 ++-
 drivers/infiniband/hw/i40iw/i40iw_utils.c | 11 +++++++++++
 4 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index c74fd33..47f473e 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -706,9 +706,11 @@ static void i40iw_sc_ccq_arm(struct i40iw_sc_cq *ccq)
 	wmb();       /* make sure shadow area is updated before arming */
 
 	if (ccq->dev->is_pf)
-		i40iw_wr32(ccq->dev->hw, I40E_PFPE_CQARM, ccq->cq_uk.cq_id);
+		i40iw_wr32_relaxed(ccq->dev->hw, I40E_PFPE_CQARM,
+				   ccq->cq_uk.cq_id);
 	else
-		i40iw_wr32(ccq->dev->hw, I40E_VFPE_CQARM1, ccq->cq_uk.cq_id);
+		i40iw_wr32_relaxed(ccq->dev->hw, I40E_VFPE_CQARM1,
+				   ccq->cq_uk.cq_id);
 }
 
 /**
diff --git a/drivers/infiniband/hw/i40iw/i40iw_osdep.h b/drivers/infiniband/hw/i40iw/i40iw_osdep.h
index f27be3e..e06f4b9 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_osdep.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_osdep.h
@@ -213,5 +213,6 @@ void i40iw_hw_stats_start_timer(struct i40iw_sc_vsi *vsi);
 void i40iw_hw_stats_stop_timer(struct i40iw_sc_vsi *vsi);
 #define i40iw_mmiowb() mmiowb()
 void i40iw_wr32(struct i40iw_hw *hw, u32 reg, u32 value);
+void i40iw_wr32_relaxed(struct i40iw_hw *hw, u32 reg, u32 value);
 u32  i40iw_rd32(struct i40iw_hw *hw, u32 reg);
 #endif				/* _I40IW_OSDEP_H_ */
diff --git a/drivers/infiniband/hw/i40iw/i40iw_uk.c b/drivers/infiniband/hw/i40iw/i40iw_uk.c
index 8afa5a6..f936fc2 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_uk.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_uk.c
@@ -723,7 +723,8 @@ static void i40iw_cq_request_notification(struct i40iw_cq_uk *cq,
 
 	wmb(); /* make sure WQE is populated before valid bit is set */
 
-	writel(cq->cq_id, cq->cqe_alloc_reg);
+	writel_relaxed(cq->cq_id, cq->cqe_alloc_reg);
+	mmiowb();
 }
 
 /**
diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniband/hw/i40iw/i40iw_utils.c
index ddc1056..99aa6f8 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
@@ -125,6 +125,17 @@ inline void i40iw_wr32(struct i40iw_hw *hw, u32 reg, u32 value)
 }
 
 /**
+ * i40iw_wr32_relaxed - write 32 bits to hw register without ordering
+ * @hw: hardware information including registers
+ * @reg: register offset
+ * @value: vvalue to write to register
+ */
+inline void i40iw_wr32_relaxed(struct i40iw_hw *hw, u32 reg, u32 value)
+{
+	writel_relaxed(value, hw->hw_addr + reg);
+}
+
+/**
  * i40iw_rd32 - read a 32 bit hw register
  * @hw: hardware information including registers
  * @reg: register offset
-- 
2.7.4
