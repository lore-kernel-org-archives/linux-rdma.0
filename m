From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] libibumad: add SA CAP MASK[2] definitions
Date: Sat, 22 Jun 2013 14:47:11 -0700
Message-ID: <20130622144711.11814c38b9b4fd65f9598038@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/infiniband/umad_sa.h |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/infiniband/umad_sa.h b/include/infiniband/umad_sa.h
index eb7812d..a236806 100644
--- a/include/infiniband/umad_sa.h
+++ b/include/infiniband/umad_sa.h
@@ -102,6 +102,30 @@ enum {
 	UMAD_LEN_SA_DATA		= 200
 };
 
+/* CM bits */
+enum {
+	UMAD_SA_CAP_MASK_IS_SUBNET_OPT_REC_SUP              = (1 << 8),
+	UMAD_SA_CAP_MASK_IS_UD_MCAST_SUP                    = (1 << 9),
+	UMAD_SA_CAP_MASK_IS_MULTIPATH_SUP                   = (1 << 10),
+	UMAD_SA_CAP_MASK_IS_REINIT_SUP                      = (1 << 11),
+	UMAD_SA_CAP_MASK_IS_GID_SCOPED_MULTIPATH_SUP        = (1 << 12),
+	UMAD_SA_CAP_MASK_IS_PORTINFO_CAP_MASK_MATCH_SUP     = (1 << 13),
+	UMAD_SA_CAP_MASK_IS_LINK_SPEED_WIDTH_PAIRS_REC_SUP  = (1 << 14),
+	UMAD_SA_CAP_MASK_IS_PA_SERVICES_SUP                 = (1 << 15)
+};
+/* CM2 bits */
+enum {
+	UMAD_SA_CAP_MASK2_IS_UNPATH_REPATH_SUP              = (1 << 0),
+	UMAD_SA_CAP_MASK2_IS_QOS_SUP                        = (1 << 1),
+	UMAD_SA_CAP_MASK2_IS_REV_PATH_PKEY_MEM_BIT_SUP      = (1 << 2),
+	UMAD_SA_CAP_MASK2_IS_MCAST_TOP_SUP                  = (1 << 3),
+	UMAD_SA_CAP_MASK2_IS_HIERARCHY_INFO_SUP             = (1 << 4),
+	UMAD_SA_CAP_MASK2_IS_ADDITIONAL_GUID_SUP            = (1 << 5),
+	UMAD_SA_CAP_MASK2_IS_FULL_PORTINFO_REC_SUP          = (1 << 6),
+	UMAD_SA_CAP_MASK2_IS_EXT_SPEEDS_SUP                 = (1 << 7),
+	UMAD_SA_CAP_MASK2_IS_MCAST_SERVICE_REC_SUP          = (1 << 8)
+};
+
 /*
  *  sm_key is not aligned on an 8-byte boundary, so is defined as a byte array
  */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
