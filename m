From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] perfquery: Fix timeout on nodes supporting
 RS_FEC capability
Date: Tue, 01 Sep 2015 08:28:38 -0400
Message-ID: <55E599F6.2000503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 0e8341980ca7133fe0a472fddc1c622f766b8f8e Mon Sep 17 00:00:00 2001
From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Mon, 31 Aug 2015 10:49:04 +0300

perfquery -T (print Extended Speed Counters) times out on nodes
supporting RS_FEC capability.

Before sending ExtendedSpeedCounters PerfMgt GMP, perfquery sends
PortInfoExtended SMP to get CapMask and FECModeActive fields.
Upon reception of PortInfoExtended SMP, fec_mode_active field is
erroneously decoded to 16 bit buffer instead of 32 bit buffer.
As a result, memory corruption occurs and portid.dlid field is set to 0,
so that ExtendedSpeedCounters GMP is sent to wrong destination.

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/perfquery.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/perfquery.c b/src/perfquery.c
index 46451ef..9e3a307 100644
--- a/src/perfquery.c
+++ b/src/perfquery.c
@@ -469,7 +469,7 @@ static uint8_t is_rsfec_mode_active(ib_portid_t * portid, int port,
 				  uint16_t cap_mask)
 {
 	uint8_t data[IB_SMP_DATA_SIZE] = { 0 };
-	uint16_t fec_mode_active = 0;
+	uint32_t fec_mode_active = 0;
 	uint32_t pie_capmask = 0;
 	if (cap_mask & IS_PM_RSFEC_COUNTERS_SUP) {
 		if (!is_port_info_extended_supported(portid, port, srcport)) {
@@ -486,7 +486,7 @@ static uint8_t is_rsfec_mode_active(ib_portid_t * portid, int port,
 				 &fec_mode_active);
 		if((pie_capmask &
 		    CL_NTOH32(IB_PORT_EXT_CAP_IS_FEC_MODE_SUPPORTED)) &&
-		   (CL_NTOH16(IB_PORT_EXT_RS_FEC_MODE_ACTIVE) == fec_mode_active))
+		   (CL_NTOH16(IB_PORT_EXT_RS_FEC_MODE_ACTIVE) == (fec_mode_active & 0xffff)))
 			return 1;
 	}
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
