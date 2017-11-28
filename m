From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags 3/6] libibmad: Add support for HDRFECMode
 fields in PortInfoExtended attribute
Date: Tue, 28 Nov 2017 17:11:56 -0500
Message-ID: <fc3566ee-d24d-73ec-054d-8eb18fcf5214@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Per MgtWG comment #9367

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibmad/include/infiniband/mad.h |  7 +++++++
 libibmad/src/dump.c               | 12 ++++++++++--
 libibmad/src/fields.c             |  7 +++++++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/libibmad/include/infiniband/mad.h b/libibmad/include/infiniband/mad.h
index 7f6b886..da82636 100644
--- a/libibmad/include/infiniband/mad.h
+++ b/libibmad/include/infiniband/mad.h
@@ -1315,6 +1315,13 @@ enum MAD_FIELDS {
 	 */
 	IB_PC_QP1_DROP_F,
 
+	/*
+	 * More PortInfoExtended fields
+	 */
+	IB_PORT_EXT_HDR_FEC_MODE_SUPPORTED_F,
+	IB_PORT_EXT_HDR_FEC_MODE_ENABLED_F,
+	IB_PORT_EXT_HDR_FEC_MODE_LAST_F,
+
 	IB_FIELD_LAST_		/* must be last */
 };
 
diff --git a/libibmad/src/dump.c b/libibmad/src/dump.c
index 98d5a34..d71c529 100644
--- a/libibmad/src/dump.c
+++ b/libibmad/src/dump.c
@@ -1183,8 +1183,16 @@ void mad_dump_classportinfo(char *buf, int bufsz, void *val, int valsz)
 
 void mad_dump_portinfo_ext(char *buf, int bufsz, void *val, int valsz)
 {
-	_dump_fields(buf, bufsz, val, IB_PORT_EXT_FIRST_F,
-		     IB_PORT_EXT_LAST_F);
+	int cnt;
+
+	cnt = _dump_fields(buf, bufsz, val, IB_PORT_EXT_FIRST_F,
+			   IB_PORT_EXT_LAST_F);
+	if (cnt < 0)
+		return;
+
+	_dump_fields(buf + cnt, bufsz - cnt, val,
+		     IB_PORT_EXT_HDR_FEC_MODE_SUPPORTED_F,
+		     IB_PORT_EXT_HDR_FEC_MODE_LAST_F);
 }
 
 void xdump(FILE * file, char *msg, void *p, int size)
diff --git a/libibmad/src/fields.c b/libibmad/src/fields.c
index bf48689..61fd540 100644
--- a/libibmad/src/fields.c
+++ b/libibmad/src/fields.c
@@ -1009,6 +1009,13 @@ static const ib_field_t ib_mad_f[] = {
 	 */
 	{160, 16, "QP1Dropped", mad_dump_uint},
 
+	/*
+	 * More PortInfoExtended fields
+	 */
+	{112, 16, "HDRFECModeSupported", mad_dump_hex},
+	{128, 16, "HDRFECModeEnabled", mad_dump_hex},
+	{0, 0},			/* IB_PORT_EXT_HDR_FEC_MODE_LAST_F */
+
 	{0, 0}			/* IB_FIELD_LAST_ */
 };
 
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
