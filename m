From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/3] libibmad: Add support for SA GUIDInfoRecord fields
Date: Fri, 25 Mar 2011 21:23:22 +0200
Message-ID: <4D8CEBAA.2020609@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
  libibmad/include/infiniband/mad.h |   15 +++++++++++++++
  libibmad/src/fields.c             |   12 ++++++++++++
  2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/libibmad/include/infiniband/mad.h 
b/libibmad/include/infiniband/mad.h
index 02f0dc8..a0b368a 100644
--- a/libibmad/include/infiniband/mad.h
+++ b/libibmad/include/infiniband/mad.h
@@ -62,6 +62,7 @@ BEGIN_C_DECLS
  #define IB_PC_DATA_SZ        (IB_MAD_SIZE - IB_PC_DATA_OFFS)
  #define IB_SA_MCM_RECSZ        53
  #define IB_SA_PR_RECSZ        64
+#define IB_SA_GIR_RECSZ        72
  #define IB_BM_DATA_OFFS        64
  #define IB_BM_DATA_SZ        (IB_MAD_SIZE - IB_BM_DATA_OFFS)
  #define IB_BM_BKEY_OFFS        24
@@ -713,6 +714,20 @@ enum MAD_FIELDS {
      IB_PSC_SAMPLES_ONLY_OPT_MASK_F,
      IB_PSC_LAST_F,

+    /*
+     * GUID Info Record
+     */
+    IB_SA_GIR_LID_F,
+    IB_SA_GIR_BLOCKNUM_F,
+    IB_SA_GIR_GUID0,
+    IB_SA_GIR_GUID1,
+    IB_SA_GIR_GUID2,
+    IB_SA_GIR_GUID3,
+    IB_SA_GIR_GUID4,
+    IB_SA_GIR_GUID5,
+    IB_SA_GIR_GUID6,
+    IB_SA_GIR_GUID7,
+
      IB_FIELD_LAST_        /* must be last */
  };

diff --git a/libibmad/src/fields.c b/libibmad/src/fields.c
index c9897e7..1dc1fb8 100644
--- a/libibmad/src/fields.c
+++ b/libibmad/src/fields.c
@@ -511,6 +511,18 @@ static const ib_field_t ib_mad_f[] = {
      {576, 64, "SamplesOnlyOptionMask", mad_dump_hex},
      {0, 0},            /* IB_PSC_LAST_F */

+    /* GUID Info Record */
+    {BITSOFFS(0, 16), "Lid", mad_dump_uint},
+    {BITSOFFS(16, 8), "BlockNum", mad_dump_uint},
+    {64, 64, "Guid0", mad_dump_hex},
+    {128, 64, "Guid1", mad_dump_hex},
+    {192, 64, "Guid2", mad_dump_hex},
+    {256, 64, "Guid3", mad_dump_hex},
+    {320, 64, "Guid4", mad_dump_hex},
+    {384, 64, "Guid5", mad_dump_hex},
+    {448, 64, "Guid6", mad_dump_hex},
+    {512, 64, "Guid7", mad_dump_hex},
+
      {0, 0}            /* IB_FIELD_LAST_ */

  };
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
