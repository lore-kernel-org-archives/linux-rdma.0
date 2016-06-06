From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 2/2] IB/core: Align casting method of ib_device_cap_flags enumerations to ULL
Date: Mon,  6 Jun 2016 19:34:40 +0300
Message-ID: <1465230880-25953-3-git-send-email-maxg@mellanox.com>
References: <1465230880-25953-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465230880-25953-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-2ukJVAZIZ/Y@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Replace u64 casting to ULL.

Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/ib_verbs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index c97357b..7e440d4 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -219,8 +219,8 @@ enum ib_device_cap_flags {
 	IB_DEVICE_SIGNATURE_HANDOVER		= (1 << 30),
 	IB_DEVICE_ON_DEMAND_PAGING		= (1ULL << 31),
 	IB_DEVICE_SG_GAPS_REG			= (1ULL << 32),
-	IB_DEVICE_VIRTUAL_FUNCTION		= ((u64)1 << 33),
-	IB_DEVICE_RAW_SCATTER_FCS		= ((u64)1 << 34),
+	IB_DEVICE_VIRTUAL_FUNCTION		= (1ULL << 33),
+	IB_DEVICE_RAW_SCATTER_FCS		= (1ULL << 34),
 };
 
 enum ib_signature_prot_cap {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
