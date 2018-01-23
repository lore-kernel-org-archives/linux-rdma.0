From: Michal Kalderon <Michal.Kalderon@cavium.com>
Subject: [PATCH net 1/2] qed: Remove reserveration of dpi for kernel
Date: Tue, 23 Jan 2018 11:33:46 +0200
Message-ID: <1516700027-3361-2-git-send-email-Michal.Kalderon@cavium.com>
References: <1516700027-3361-1-git-send-email-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1516700027-3361-1-git-send-email-Michal.Kalderon@cavium.com>
Sender: netdev-owner@vger.kernel.org
To: michal.kalderon@cavium.com, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, dledford@redhat.com, jgg@mellanox.com, Michal Kalderon <Michal.Kalderon@cavium.com>, Ariel Elior <Ariel.Elior@cavium.com>
List-Id: linux-rdma@vger.kernel.org

Double reservation for kernel dedicated dpi was performed.
Once in the core module and once in qedr.
Remove the reservation from core.

Signed-off-by: Michal Kalderon <Michal.Kalderon@cavium.com>
Signed-off-by: Ariel Elior <Ariel.Elior@cavium.com>
---
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index c8c4b39..9d6e2d4 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -615,9 +615,6 @@ static int qed_rdma_reserve_lkey(struct qed_hwfn *p_hwfn)
 {
 	struct qed_rdma_device *dev = p_hwfn->p_rdma_info->dev;
 
-	/* The first DPI is reserved for the Kernel */
-	__set_bit(0, p_hwfn->p_rdma_info->dpi_map.bitmap);
-
 	/* Tid 0 will be used as the key for "reserved MR".
 	 * The driver should allocate memory for it so it can be loaded but no
 	 * ramrod should be passed on it.
-- 
1.8.3.1
