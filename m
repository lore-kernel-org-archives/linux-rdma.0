From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: libibumad: added link_layer for RoCEE support and updated umad version
Date: Tue, 09 Mar 2010 12:39:40 +0200
Message-ID: <4B96256C.7000406@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Added link_layer field to umad_port_t.
The field is implemented as char[].
If the relevant file doesn't exist in sysfs, the link layer
is "IB". Otherwise, the content of link_layer file is used.

The libibumad version is promoted.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 libibumad/include/infiniband/umad.h |    2 ++
 libibumad/libibumad.ver             |    2 +-
 libibumad/src/umad.c                |    5 +++++
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/libibumad/include/infiniband/umad.h b/libibumad/include/infiniband/umad.h
index 1f82183..f9da204 100644
--- a/libibumad/include/infiniband/umad.h
+++ b/libibumad/include/infiniband/umad.h
@@ -116,6 +116,7 @@ typedef struct ib_user_mad {
 #define SYS_PORT_RATE		"rate"
 #define SYS_PORT_GUID		"port_guid"
 #define SYS_PORT_GID		"gids/0"
+#define SYS_PORT_LINK_LAYER	"link_layer"

 typedef struct umad_port {
 	char ca_name[UMAD_CA_NAME_LEN];
@@ -132,6 +133,7 @@ typedef struct umad_port {
 	uint64_t port_guid;
 	unsigned pkeys_size;
 	uint16_t *pkeys;
+	char link_layer[UMAD_CA_NAME_LEN];
 } umad_port_t;

 typedef struct umad_ca {
diff --git a/libibumad/libibumad.ver b/libibumad/libibumad.ver
index 57cddbd..225738c 100644
--- a/libibumad/libibumad.ver
+++ b/libibumad/libibumad.ver
@@ -6,4 +6,4 @@
 # API_REV - advance on any added API
 # RUNNING_REV - advance any change to the vendor files
 # AGE - number of backward versions the API still supports
-LIBVERSION=2:1:0
+LIBVERSION=2:2:0
diff --git a/libibumad/src/umad.c b/libibumad/src/umad.c
index 277ae6b..d16e750 100644
--- a/libibumad/src/umad.c
+++ b/libibumad/src/umad.c
@@ -159,6 +159,11 @@ static int get_port(char *ca_name, char *dir, int portnum, umad_port_t * port)
 	if (sys_read_uint(port_dir, SYS_PORT_CAPMASK, &port->capmask) < 0)
 		goto clean;

+	if (sys_read_string(port_dir, SYS_PORT_LINK_LAYER,
+	    port->link_layer, UMAD_CA_NAME_LEN) < 0)
+		/* assume IB by default */
+		sprintf(port->link_layer, "IB");
+
 	port->capmask = htonl(port->capmask);

 	if (sys_read_gid(port_dir, SYS_PORT_GID, gid) < 0)
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
