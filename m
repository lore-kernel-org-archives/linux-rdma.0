From: Michal Kalderon <Michal.Kalderon@cavium.com>
Subject: [PATCH net 2/2] qede: Fix gfp flags sent to rdma event node allocation
Date: Tue, 8 May 2018 21:29:19 +0300
Message-ID: <20180508182919.23590-3-Michal.Kalderon@cavium.com>
References: <20180508182919.23590-1-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180508182919.23590-1-Michal.Kalderon@cavium.com>
Sender: netdev-owner@vger.kernel.org
To: michal.kalderon@cavium.com, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, chad.dupuis@cavium.com, Michal Kalderon <Michal.Kalderon@cavium.com>, Sudarsana Kalluru <Sudarsana.Kalluru@cavium.com>
List-Id: linux-rdma@vger.kernel.org

A previous commit 4609adc27175 ("qede: Fix qedr link update")
added a flow that could allocate rdma event objects from an
interrupt path (link notification). Therefore the kzalloc call
should be done with GFP_ATOMIC.

fixes: 4609adc27175 ("qede: Fix qedr link update")
Signed-off-by: Michal Kalderon <Michal.Kalderon@cavium.com>
Signed-off-by: Sudarsana Kalluru <Sudarsana.Kalluru@cavium.com>
---
 drivers/net/ethernet/qlogic/qede/qede_rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_rdma.c b/drivers/net/ethernet/qlogic/qede/qede_rdma.c
index 50b142f..1900bf7 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_rdma.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_rdma.c
@@ -238,7 +238,7 @@ qede_rdma_get_free_event_node(struct qede_dev *edev)
 	}
 
 	if (!found) {
-		event_node = kzalloc(sizeof(*event_node), GFP_KERNEL);
+		event_node = kzalloc(sizeof(*event_node), GFP_ATOMIC);
 		if (!event_node) {
 			DP_NOTICE(edev,
 				  "qedr: Could not allocate memory for rdma work\n");
-- 
2.9.5
