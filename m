From: Max Gurtovoy <maxg@mellanox.com>
Subject: [PATCH v3 1/2] IB/core: Fix bit curruption in ib_device_cap_flags structure
Date: Mon,  6 Jun 2016 19:34:39 +0300
Message-ID: <1465230880-25953-2-git-send-email-maxg@mellanox.com>
References: <1465230880-25953-1-git-send-email-maxg@mellanox.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1465230880-25953-1-git-send-email-maxg@mellanox.com>
Sender: stable-owner@vger.kernel.org
To: robert@leblancnet.us, matanb@mellanox.com, leon@leon.nu, sagi@grimberg.me, linux-rdma@vger.kernel.org
Cc: stable@vger.kernel.org, Max Gurtovoy <maxg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

ib_device_cap_flags 64-bit expansion caused caps overlapping
and made consumers read wrong device capabilities. For example
IB_DEVICE_SG_GAPS_REG was falsely read by the iser driver causing
it to use a non-existing capability. This happened because signed
int becomes sign extended when converted it to u64. Fix this by
casting IB_DEVICE_ON_DEMAND_PAGING enumeration to ULL.

Fixes: f5aa9159a418 ('IB/core: Add arbitrary sg_list support')
Reported-by: Robert LeBlanc <robert@leblancnet.us>
Cc: Stable <stable@vger.kernel.org> #[v4.6+]
Acked-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Signed-off-by: Matan Barak <matanb@mellanox.com>
---
 include/rdma/ib_verbs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 432bed5..c97357b 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -217,7 +217,7 @@ enum ib_device_cap_flags {
 	IB_DEVICE_CROSS_CHANNEL		= (1 << 27),
 	IB_DEVICE_MANAGED_FLOW_STEERING		= (1 << 29),
 	IB_DEVICE_SIGNATURE_HANDOVER		= (1 << 30),
-	IB_DEVICE_ON_DEMAND_PAGING		= (1 << 31),
+	IB_DEVICE_ON_DEMAND_PAGING		= (1ULL << 31),
 	IB_DEVICE_SG_GAPS_REG			= (1ULL << 32),
 	IB_DEVICE_VIRTUAL_FUNCTION		= ((u64)1 << 33),
 	IB_DEVICE_RAW_SCATTER_FCS		= ((u64)1 << 34),
-- 
1.7.1
