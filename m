From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/ib_types.h: Update SA PortInfoRecord component masks
Date: Thu, 28 Jul 2011 09:58:58 -0400
Message-ID: <4E316B22.1070904@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/iba/ib_types.h b/include/iba/ib_types.h
index ea08f51..3dc8a7c 100644
--- a/include/iba/ib_types.h
+++ b/include/iba/ib_types.h
@@ -2710,12 +2710,16 @@ typedef struct _ib_path_rec {
 #define IB_PIR_COMPMASK_PKEYVIO          (CL_HTON64(((uint64_t)1)<<40))
 #define IB_PIR_COMPMASK_QKEYVIO          (CL_HTON64(((uint64_t)1)<<41))
 #define IB_PIR_COMPMASK_GUIDCAP          (CL_HTON64(((uint64_t)1)<<42))
-#define IB_PIR_COMPMASK_RESV3            (CL_HTON64(((uint64_t)1)<<43))
-#define IB_PIR_COMPMASK_SUBNTO           (CL_HTON64(((uint64_t)1)<<44))
-#define IB_PIR_COMPMASK_RESV4            (CL_HTON64(((uint64_t)1)<<45))
-#define IB_PIR_COMPMASK_RESPTIME         (CL_HTON64(((uint64_t)1)<<46))
-#define IB_PIR_COMPMASK_LOCALPHYERR      (CL_HTON64(((uint64_t)1)<<47))
-#define IB_PIR_COMPMASK_OVERRUNERR       (CL_HTON64(((uint64_t)1)<<48))
+#define IB_PIR_COMPMASK_CLIENTREREG	 (CL_HTON64(((uint64_t)1)<<43))
+#define IB_PIR_COMPMASK_RESV3            (CL_HTON64(((uint64_t)1)<<44))
+#define IB_PIR_COMPMASK_SUBNTO           (CL_HTON64(((uint64_t)1)<<45))
+#define IB_PIR_COMPMASK_RESV4            (CL_HTON64(((uint64_t)1)<<46))
+#define IB_PIR_COMPMASK_RESPTIME         (CL_HTON64(((uint64_t)1)<<47))
+#define IB_PIR_COMPMASK_LOCALPHYERR      (CL_HTON64(((uint64_t)1)<<48))
+#define IB_PIR_COMPMASK_OVERRUNERR       (CL_HTON64(((uint64_t)1)<<49))
+#define IB_PIR_COMPMASK_MAXCREDHINT	 (CL_HTON64(((uint64_t)1)<<50))
+#define IB_PIR_COMPMASK_RESV5		 (CL_HTON64(((uint64_t)1)<<51))
+#define IB_PIR_COMPMASK_LINKRTLAT	 (CL_HTON64(((uint64_t)1)<<52))
 
 /* Multicast Member Record Component Masks */
 #define IB_MCR_COMPMASK_GID         (CL_HTON64(((uint64_t)1)<<0))
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
