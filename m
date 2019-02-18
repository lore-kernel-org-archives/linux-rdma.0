From: Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH net 2/2] qed: Fix iWARP syn packet mac address validation.
Date: Mon, 18 Feb 2019 15:24:03 +0200
Message-ID: <20190218132403.12487-3-michal.kalderon@marvell.com>
References: <20190218132403.12487-1-michal.kalderon@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190218132403.12487-1-michal.kalderon@marvell.com>
Sender: netdev-owner@vger.kernel.org
To: michal.kalderon@marvell.com, ariel.elior@marvell.com, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The ll2 forwards all syn packets to the driver without validating the mac
address. Add validation check in the driver's iWARP listener flow and drop
the packet if it isn't intended for the device.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index e84fb01..ded556b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -1688,6 +1688,15 @@ qed_iwarp_parse_rx_pkt(struct qed_hwfn *p_hwfn,
 
 	eth_hlen = ETH_HLEN + (vlan_valid ? sizeof(u32) : 0);
 
+	if (!ether_addr_equal(ethh->h_dest,
+			      p_hwfn->p_rdma_info->iwarp.mac_addr)) {
+		DP_VERBOSE(p_hwfn,
+			   QED_MSG_RDMA,
+			   "Got unexpected mac %pM instead of %pM\n",
+			   ethh->h_dest, p_hwfn->p_rdma_info->iwarp.mac_addr);
+		return -EINVAL;
+	}
+
 	ether_addr_copy(remote_mac_addr, ethh->h_source);
 	ether_addr_copy(local_mac_addr, ethh->h_dest);
 
-- 
2.9.5
