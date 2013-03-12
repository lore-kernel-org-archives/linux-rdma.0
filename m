From: Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] libibmad: To fix big endian problem for both 32-bit & 64-bit
 SPARC
Date: Tue, 12 Mar 2013 12:36:29 -0700
Message-ID: <513F83BD.3050302@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 src/dump.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 57 insertions(+), 9 deletions(-)

diff --git a/src/dump.c b/src/dump.c
index 7f3ef7d..e83c363 100644
--- a/src/dump.c
+++ b/src/dump.c
@@ -46,12 +46,24 @@
 
 void mad_dump_int(char *buf, int bufsz, void *val, int valsz)
 {
+	/*
+	 * the val pointer passed to the dump routines are always 32 bit
+	 * integers for valsz <= 4 and 64 bit integer for the rest. It is never
+	 * uint8_t or uint16_t. This is because mad_decode_field always returns
+	 * the values as 32 bit integer even if they are 8 bit or 16 bit fields.
+	 */
 	switch (valsz) {
 	case 1:
-		snprintf(buf, bufsz, "%d", *(uint32_t *) val & 0xff);
+#if defined(_BIG_ENDIAN)
+		val = ((uint8_t *)val) + 3;
+#endif /* _BIG_ENDIAN */
+		snprintf(buf, bufsz, "%d", *(uint8_t *) val & 0xff);
 		break;
 	case 2:
-		snprintf(buf, bufsz, "%d", *(uint32_t *) val & 0xffff);
+#if defined(_BIG_ENDIAN)
+		val = ((uint16_t *)val) + 1;
+#endif /* _BIG_ENDIAN */
+		snprintf(buf, bufsz, "%d", *(uint16_t *) val & 0xffff);
 		break;
 	case 3:
 	case 4:
@@ -71,12 +83,24 @@ void mad_dump_int(char *buf, int bufsz, void *val, int valsz)
 
 void mad_dump_uint(char *buf, int bufsz, void *val, int valsz)
 {
+	/*
+	 * the val pointer passed to the dump routines are always 32 bit
+	 * integers for valsz <= 4 and 64 bit integer for the rest. It is never
+	 * uint8_t or uint16_t. This is because mad_decode_field always returns
+	 * the values as 32 bit integer even if they are 8 bit or 16 bit fields.
+	 */
 	switch (valsz) {
 	case 1:
-		snprintf(buf, bufsz, "%u", *(uint32_t *) val & 0xff);
+#if defined(_BIG_ENDIAN)
+		val = ((uint8_t *)val) + 3;
+#endif /* _BIG_ENDIAN */
+		snprintf(buf, bufsz, "%u", *(uint8_t *) val & 0xff);
 		break;
 	case 2:
-		snprintf(buf, bufsz, "%u", *(uint32_t *) val & 0xffff);
+#if defined(_BIG_ENDIAN)
+		val = ((uint16_t *)val) + 1;
+#endif /* _BIG_ENDIAN */
+		snprintf(buf, bufsz, "%u", *(uint16_t *) val & 0xffff);
 		break;
 	case 3:
 	case 4:
@@ -96,15 +120,27 @@ void mad_dump_uint(char *buf, int bufsz, void *val, int valsz)
 
 void mad_dump_hex(char *buf, int bufsz, void *val, int valsz)
 {
+	/*
+	 * the val pointer passed to the dump routines are always 32 bit
+	 * integers for valsz <= 4 and 64 bit integer for the rest. It is never
+	 * uint8_t or uint16_t. This is because mad_decode_field always returns
+	 * the values as 32 bit integer even if they are 8 bit or 16 bit fields.
+	 */
 	switch (valsz) {
 	case 1:
-		snprintf(buf, bufsz, "0x%02x", *(uint32_t *) val & 0xff);
+#if defined(_BIG_ENDIAN)
+		val = ((uint8_t *)val) + 3;
+#endif /* _BIG_ENDIAN */
+		snprintf(buf, bufsz, "0x%02x", *(uint8_t *) val & 0xff);
 		break;
 	case 2:
-		snprintf(buf, bufsz, "0x%04x", *(uint32_t *) val & 0xffff);
+#if defined(_BIG_ENDIAN)
+		val = ((uint16_t *)val) + 1;
+#endif /* _BIG_ENDIAN */
+		snprintf(buf, bufsz, "0x%04x", *(uint16_t *) val & 0xffff);
 		break;
 	case 3:
-		snprintf(buf, bufsz, "0x%06x", *(uint32_t *) val & 0xffffff);
+		snprintf(buf, bufsz, "0x%x", *(uint32_t *) val & 0xffffff);
 		break;
 	case 4:
 		snprintf(buf, bufsz, "0x%08x", *(uint32_t *) val);
@@ -132,12 +168,24 @@ void mad_dump_hex(char *buf, int bufsz, void *val, int valsz)
 
 void mad_dump_rhex(char *buf, int bufsz, void *val, int valsz)
 {
+	/*
+	 * the val pointer passed to the dump routines are always 32 bit
+	 * integers for valsz <= 4 and 64 bit integer for the rest. It is never
+	 * uint8_t or uint16_t. This is because mad_decode_field always returns
+	 * the values as 32 bit integer even if they are 8 bit or 16 bit fields.
+	 */
 	switch (valsz) {
 	case 1:
-		snprintf(buf, bufsz, "%02x", *(uint32_t *) val & 0xff);
+#if defined(_BIG_ENDIAN)
+		val = ((uint8_t *)val) + 3;
+#endif /* _BIG_ENDIAN */
+		snprintf(buf, bufsz, "%02x", *(uint8_t *) val & 0xff);
 		break;
 	case 2:
-		snprintf(buf, bufsz, "%04x", *(uint32_t *) val & 0xffff);
+#if defined(_BIG_ENDIAN)
+		val = ((uint16_t *)val) + 1;
+#endif /* _BIG_ENDIAN */
+		snprintf(buf, bufsz, "%04x", *(uint16_t *) val & 0xffff);
 		break;
 	case 3:
 		snprintf(buf, bufsz, "%06x", *(uint32_t *) val & 0xffffff);
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
