From: Joe Perches <joe@perches.com>
Subject: [PATCH 3/9] drivers/infiniband: Fix continuation lines
Date: Fri, 26 Mar 2010 19:27:52 -0700
Message-ID: <f0b8a02c42d9923131076626f562af0e5074b761.1269655208.git.joe@perches.com>
References: <cover.1269655208.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1269655208.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Faisal Latif <faisal.latif@intel.com>, Chien Tung <chien.tin.tung@intel.com>, Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/hw/nes/nes_nic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 91fdde3..9963676 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -902,9 +902,8 @@ static void nes_netdev_set_multicast_list(struct net_device *netdev)
 					nesvnic->nic_index &&
 					mc_index < max_pft_entries_avaiable) {
 						nes_debug(NES_DBG_NIC_RX,
-					"mc_index=%d skipping nic_index=%d,\
-					used for=%d \n", mc_index,
+					"mc_index=%d skipping nic_index=%d, "
+					"used for=%d\n", mc_index,
 					nesvnic->nic_index,
 					nesadapter->pft_mcast_map[mc_index]);
 				mc_index++;
-- 
1.7.0.14.g7e948
