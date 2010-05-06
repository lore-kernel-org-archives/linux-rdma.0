From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] libibverbs: add path record definitions to sa.h
Date: Thu, 6 May 2010 15:22:58 -0700
Message-ID: <2420730B531C4665BD842A7F46007DA2@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add definitions for path record wire definition.  This
will be used by the librdmacm and ib_acm service, and is
exchanged with the kernel using the newer set and query
route functionality.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
I went with the simpler definition, rather than defining bitfields.
Once a definition is accepted into the libibverbs git tree, I will
request that the same definition be pulled into the OFED 1.5.2 codebase.

 include/infiniband/sa.h |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/include/infiniband/sa.h b/include/infiniband/sa.h
index ec90f14..f475c66 100644
--- a/include/infiniband/sa.h
+++ b/include/infiniband/sa.h
@@ -97,4 +97,41 @@ struct ibv_sa_service_rec {
 	uint64_t      data64[2];
 };
 
+#define IB_PATH_RECORD_REVERSIBLE 0x80
+
+struct ib_path_record
+{
+	uint64_t        service_id;
+	union ibv_gid   dgid;
+	union ibv_gid   sgid;
+	uint16_t        dlid;
+	uint16_t        slid;
+	uint32_t        flowlabel_hoplimit; /* resv-31:28 flow label-27:8 hop limit-7:0*/
+	uint8_t         tclass;
+	uint8_t         reversible_numpath; /* reversible-7:7 num path-6:0 */
+	uint16_t        pkey;
+	uint16_t        qosclass_sl;        /* qos class-15:4 sl-3:0 */
+	uint8_t         mtu;                /* mtu selector-7:6 mtu-5:0 */
+	uint8_t         rate;               /* rate selector-7:6 rate-5:0 */
+	uint8_t         packetlifetime;     /* lifetime selector-7:6 lifetime-5:0 */
+	uint8_t         preference;
+	uint8_t         reserved[6];
+};
+
+#define IB_PATH_FLAG_GMP             (1<<0)
+#define IB_PATH_FLAG_PRIMARY         (1<<1)
+#define IB_PATH_FLAG_ALTERNATE       (1<<2)
+#define IB_PATH_FLAG_OUTBOUND        (1<<3)
+#define IB_PATH_FLAG_INBOUND         (1<<4)
+#define IB_PATH_FLAG_INBOUND_REVERSE (1<<5)
+#define IB_PATH_FLAG_BIDIRECTIONAL   (IB_PATH_FLAG_OUTBOUND |     \
+                                      IB_PATH_FLAG_INBOUND_REVERSE)
+
+struct ib_path_data
+{
+	uint32_t              flags;
+	uint32_t              reserved;
+	struct ib_path_record path;
+};
+
 #endif /* INFINIBAND_SA_H */



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
