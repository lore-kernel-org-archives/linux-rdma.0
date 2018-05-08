From: Michal Kalderon <Michal.Kalderon@cavium.com>
Subject: [PATCH net 1/2] qed: Fix l2 initializations over iWARP personality
Date: Tue, 8 May 2018 21:29:18 +0300
Message-ID: <20180508182919.23590-2-Michal.Kalderon@cavium.com>
References: <20180508182919.23590-1-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180508182919.23590-1-Michal.Kalderon@cavium.com>
Sender: netdev-owner@vger.kernel.org
To: michal.kalderon@cavium.com, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, chad.dupuis@cavium.com, Michal Kalderon <Michal.Kalderon@cavium.com>, Sudarsana Kalluru <Sudarsana.Kalluru@cavium.com>
List-Id: linux-rdma@vger.kernel.org

If qede driver was loaded on a device configured for iWARP
the l2 mutex wouldn't be allocated, and some l2 related
resources wouldn't be freed.

fixes: c851a9dc4359 ("qed: Introduce iWARP personality")
Signed-off-by: Michal Kalderon <Michal.Kalderon@cavium.com>
Signed-off-by: Sudarsana Kalluru <Sudarsana.Kalluru@cavium.com>
---
 drivers/net/ethernet/qlogic/qed/qed_l2.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.c b/drivers/net/ethernet/qlogic/qed/qed_l2.c
index e874504..8667799 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_l2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_l2.c
@@ -115,8 +115,7 @@ int qed_l2_alloc(struct qed_hwfn *p_hwfn)
 
 void qed_l2_setup(struct qed_hwfn *p_hwfn)
 {
-	if (p_hwfn->hw_info.personality != QED_PCI_ETH &&
-	    p_hwfn->hw_info.personality != QED_PCI_ETH_ROCE)
+	if (!QED_IS_L2_PERSONALITY(p_hwfn))
 		return;
 
 	mutex_init(&p_hwfn->p_l2_info->lock);
@@ -126,8 +125,7 @@ void qed_l2_free(struct qed_hwfn *p_hwfn)
 {
 	u32 i;
 
-	if (p_hwfn->hw_info.personality != QED_PCI_ETH &&
-	    p_hwfn->hw_info.personality != QED_PCI_ETH_ROCE)
+	if (!QED_IS_L2_PERSONALITY(p_hwfn))
 		return;
 
 	if (!p_hwfn->p_l2_info)
-- 
2.9.5
