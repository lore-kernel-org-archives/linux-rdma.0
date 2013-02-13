From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/ib_types.h: Add missing IB_PR_COMPMASK_SERVICEID define
Date: Wed, 13 Feb 2013 08:31:49 -0500
Message-ID: <511B95C5.6040404@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/iba/ib_types.h b/include/iba/ib_types.h
index 698418d..2bb87d3 100644
--- a/include/iba/ib_types.h
+++ b/include/iba/ib_types.h
@@ -2586,6 +2586,9 @@ typedef struct _ib_path_rec {
 #define  IB_PR_COMPMASK_PKTLIFETIMESELEC  (CL_HTON64(((uint64_t)1)<<20))
 #define  IB_PR_COMPMASK_PKTLIFETIME       (CL_HTON64(((uint64_t)1)<<21))
 
+#define  IB_PR_COMPMASK_SERVICEID (IB_PR_COMPMASK_SERVICEID_MSB | \
+				   IB_PR_COMPMASK_SERVICEID_LSB)
+
 /* Link Record Component Masks */
 #define IB_LR_COMPMASK_FROM_LID           (CL_HTON64(((uint64_t)1)<<0))
 #define IB_LR_COMPMASK_FROM_PORT          (CL_HTON64(((uint64_t)1)<<1))
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
