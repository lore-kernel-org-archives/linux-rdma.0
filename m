From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] libibumad: add ClassPortInfo struct
Date: Sat, 22 Jun 2013 14:47:13 -0700
Message-ID: <20130622144713.806a3988582a9d1156fbad43@intel.com>
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
 include/infiniband/umad_types.h |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/include/infiniband/umad_types.h b/include/infiniband/umad_types.h
index 32c747a..2d7c8cd 100644
--- a/include/infiniband/umad_types.h
+++ b/include/infiniband/umad_types.h
@@ -167,5 +167,38 @@ enum {
 	UMAD_OPENIB_OUI		= 0x001405
 };
 
+enum {
+	UMAD_CLASS_RESP_TIME_MASK = 0x1F
+};
+struct umad_class_port_info {
+	uint8_t base_ver;
+	uint8_t class_ver;
+	be16_t  cap_mask;
+	be32_t  cap_mask2_resp_time;
+	uint8_t redir_gid[16]; /* network byte order */
+	be32_t  redir_tc_sl_fl;
+	be16_t  redir_lid;
+	be16_t  redir_pkey;
+	be32_t  redir_qp;
+	be32_t  redir_qkey;
+	uint8_t trap_gid[16]; /* network byte order */
+	be32_t  trap_tc_sl_fl;
+	be16_t  trap_lid;
+	be16_t  trap_pkey;
+	be32_t  trap_hop_qp;
+	be32_t  trap_qkey;
+};
+static inline uint32_t
+umad_class_cap_mask2(struct umad_class_port_info *cpi)
+{
+	return (ntohl(cpi->cap_mask2_resp_time) >> 5);
+}
+static inline uint8_t
+umad_class_resp_time(struct umad_class_port_info *cpi)
+{
+	return (uint8_t)(ntohl(cpi->cap_mask2_resp_time)
+			 & UMAD_CLASS_RESP_TIME_MASK);
+}
+
 END_C_DECLS
 #endif				/* _UMAD_TYPES_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
