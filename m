From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/2] opensm/ib_types.h: Add CapabilityMask2 to notice for
 trap 144
Date: Wed, 25 Jul 2012 06:40:53 -0400
Message-ID: <500FCD35.3000900@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Per MgtWG RefID #4855

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/iba/ib_types.h b/include/iba/ib_types.h
index d28de17..7b4d1ee 100644
--- a/include/iba/ib_types.h
+++ b/include/iba/ib_types.h
@@ -7656,6 +7656,7 @@ typedef struct _ib_mad_notice_attr	// Total Size calc  Accumulated
 			uint8_t    local_changes;   // 7b reserved 1b local changes
 			ib_net32_t new_cap_mask;    // new capability mask
 			ib_net16_t change_flgs;     // 10b reserved 6b change flags
+			ib_net16_t cap_mask2;
 		} PACK_SUFFIX ntc_144;
 		struct _ntc_145 {
 			ib_net16_t pad1;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
