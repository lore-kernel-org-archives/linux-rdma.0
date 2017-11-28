From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags 5/6] [perfquery.c ibdiag_common.h]: Add
 support for HDR RS-FEC
Date: Tue, 28 Nov 2017 17:12:07 -0500
Message-ID: <ecd315f7-9e91-b957-54a0-4be10d5a766a@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


HDR uses different RS-FEC. Original RS-FEC is RS(528,514) and is
bit 2 in FECMode fields and value 2 in FECModeActive field.
HDR uses RS(544,514) which is bit 4 in HDRFECMode fields and
value 4 in FECModeActive field.

Per MgtWG comments #9367 and #9368

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/ibdiag_common.h | 4 ++++
 src/perfquery.c         | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index b8c5987..ae93ba3 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -114,6 +114,10 @@ extern char *ibd_nd_format;
 #define IB_PORT_EXT_LOW_LATENCY_RS_FEC_MODE_ACTIVE (CL_HTON16(0x0003))
 #endif
 
+#ifndef IB_PORT_EXT_RS_FEC2_MODE_ACTIVE
+#define IB_PORT_EXT_RS_FEC2_MODE_ACTIVE (CL_HTON16(0x0004))
+#endif
+
 /* SM PortInfoExtended CapabilityMask Bits */
 #ifndef IB_PORT_EXT_CAP_IS_FEC_MODE_SUPPORTED
 #define IB_PORT_EXT_CAP_IS_FEC_MODE_SUPPORTED (CL_HTON32(0x00000001))
diff --git a/src/perfquery.c b/src/perfquery.c
index 6bc4d9c..19d4273 100644
--- a/src/perfquery.c
+++ b/src/perfquery.c
@@ -571,7 +571,8 @@ static uint8_t is_rsfec_mode_active(ib_portid_t * portid, int port,
 				 &fec_mode_active);
 		if((pie_capmask &
 		    CL_NTOH32(IB_PORT_EXT_CAP_IS_FEC_MODE_SUPPORTED)) &&
-		   (CL_NTOH16(IB_PORT_EXT_RS_FEC_MODE_ACTIVE) == (fec_mode_active & 0xffff)))
+		   ((CL_NTOH16(IB_PORT_EXT_RS_FEC_MODE_ACTIVE) == (fec_mode_active & 0xffff)) ||
+                    (CL_NTOH16(IB_PORT_EXT_RS_FEC2_MODE_ACTIVE) == (fec_mode_active & 0xffff))))
 			return 1;
 	}
 
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
