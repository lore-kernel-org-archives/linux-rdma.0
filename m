From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] libibumad: Fix issues causing const warnings for strings
Date: Fri, 08 Mar 2013 06:53:11 -0500
Message-ID: <5139D127.6000109@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/Makefile.am b/Makefile.am
index 2868c8d..24b5dd8 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -23,10 +23,9 @@ man_MANS = man/umad_debug.3 man/umad_get_ca.3 \
 	   man/umad_mad_status_str.3 \
 	   man/umad_method_str.3
 
-
 lib_LTLIBRARIES = libibumad.la
 
-libibumad_la_CFLAGS = -Wall
+libibumad_la_CFLAGS = -Wall -Wwrite-strings
 
 if HAVE_LD_VERSION_SCRIPT
 libibumad_version_script = -Wl,--version-script=$(srcdir)/src/libibumad.map
diff --git a/include/infiniband/umad.h b/include/infiniband/umad.h
index b3f00e7..6af30c0 100644
--- a/include/infiniband/umad.h
+++ b/include/infiniband/umad.h
@@ -160,16 +160,16 @@ int umad_init(void);
 int umad_done(void);
 
 int umad_get_cas_names(char cas[][UMAD_CA_NAME_LEN], int max);
-int umad_get_ca_portguids(char *ca_name, uint64_t * portguids, int max);
+int umad_get_ca_portguids(const char *ca_name, uint64_t * portguids, int max);
 
-int umad_get_ca(char *ca_name, umad_ca_t * ca);
+int umad_get_ca(const char *ca_name, umad_ca_t * ca);
 int umad_release_ca(umad_ca_t * ca);
-int umad_get_port(char *ca_name, int portnum, umad_port_t * port);
+int umad_get_port(const char *ca_name, int portnum, umad_port_t * port);
 int umad_release_port(umad_port_t * port);
 
-int umad_get_issm_path(char *ca_name, int portnum, char path[], int max);
+int umad_get_issm_path(const char *ca_name, int portnum, char path[], int max);
 
-int umad_open_port(char *ca_name, int portnum);
+int umad_open_port(const char *ca_name, int portnum);
 int umad_close_port(int portid);
 
 void *umad_get_mad(void *umad);
diff --git a/src/sysfs.c b/src/sysfs.c
index 02aec7f..20448d6 100644
--- a/src/sysfs.c
+++ b/src/sysfs.c
@@ -65,7 +65,7 @@ static int ret_code(void)
 	return e;
 }
 
-int sys_read_string(char *dir_name, char *file_name, char *str, int max_len)
+int sys_read_string(const char *dir_name, const char *file_name, char *str, int max_len)
 {
 	char path[256], *s;
 	int fd, r;
@@ -75,7 +75,7 @@ int sys_read_string(char *dir_name, char *file_name, char *str, int max_len)
 	if ((fd = open(path, O_RDONLY)) < 0)
 		return ret_code();
 
-	if ((r = read(fd, str, max_len)) < 0) {
+	if ((r = read(fd, (void *)str, max_len)) < 0) {
 		int e = errno;
 		close(fd);
 		errno = e;
@@ -91,7 +91,7 @@ int sys_read_string(char *dir_name, char *file_name, char *str, int max_len)
 	return 0;
 }
 
-int sys_read_guid(char *dir_name, char *file_name, uint64_t * net_guid)
+int sys_read_guid(const char *dir_name, const char *file_name, uint64_t * net_guid)
 {
 	char buf[32], *str, *s;
 	uint64_t guid;
@@ -113,7 +113,7 @@ int sys_read_guid(char *dir_name, char *file_name, uint64_t * net_guid)
 	return 0;
 }
 
-int sys_read_gid(char *dir_name, char *file_name, uint8_t * gid)
+int sys_read_gid(const char *dir_name, const char *file_name, uint8_t * gid)
 {
 	char buf[64], *str, *s;
 	uint16_t *ugid = (uint16_t *) gid;
@@ -131,7 +131,7 @@ int sys_read_gid(char *dir_name, char *file_name, uint8_t * gid)
 	return 0;
 }
 
-int sys_read_uint64(char *dir_name, char *file_name, uint64_t * u)
+int sys_read_uint64(const char *dir_name, const char *file_name, uint64_t * u)
 {
 	char buf[32];
 	int r;
@@ -144,7 +144,7 @@ int sys_read_uint64(char *dir_name, char *file_name, uint64_t * u)
 	return 0;
 }
 
-int sys_read_uint(char *dir_name, char *file_name, unsigned *u)
+int sys_read_uint(const char *dir_name, const char *file_name, unsigned *u)
 {
 	char buf[32];
 	int r;
diff --git a/src/umad.c b/src/umad.c
index 8ab5e80..5dd7f09 100644
--- a/src/umad.c
+++ b/src/umad.c
@@ -76,11 +76,11 @@ typedef struct ib_user_mad_reg_req {
 	uint8_t rmpp_version;
 } ib_user_mad_reg_req_t;
 
-extern int sys_read_string(char *dir_name, char *file_name, char *str, int len);
-extern int sys_read_guid(char *dir_name, char *file_name, uint64_t * net_guid);
-extern int sys_read_gid(char *dir_name, char *file_name, uint8_t * gid);
-extern int sys_read_uint64(char *dir_name, char *file_name, uint64_t * u);
-extern int sys_read_uint(char *dir_name, char *file_name, unsigned *u);
+extern int sys_read_string(const char *dir_name, const char *file_name, char *str, int len);
+extern int sys_read_guid(const char *dir_name, const char *file_name, uint64_t * net_guid);
+extern int sys_read_gid(const char *dir_name, const char *file_name, uint8_t * gid);
+extern int sys_read_uint64(const char *dir_name, const char *file_name, uint64_t * u);
+extern int sys_read_uint(const char *dir_name, const char *file_name, unsigned *u);
 
 #define IBWARN(fmt, args...) fprintf(stderr, "ibwarn: [%d] %s: " fmt "\n", getpid(), __func__, ## args)
 
@@ -91,7 +91,7 @@ int umaddebug = 0;
 
 #define UMAD_DEV_FILE_SZ	256
 
-static char *def_ca_name = "mthca0";
+static const char *def_ca_name = "mthca0";
 static int def_ca_port = 1;
 
 static unsigned abi_version;
@@ -100,7 +100,7 @@ static unsigned new_user_mad_api;
 /*************************************
  * Port
  */
-static int find_cached_ca(char *ca_name, umad_ca_t * ca)
+static int find_cached_ca(const char *ca_name, umad_ca_t * ca)
 {
 	return 0;		/* caching not implemented yet */
 }
@@ -126,7 +126,7 @@ static int check_for_digit_name(const struct dirent *dent)
 	return *p ? 0 : 1;
 }
 
-static int get_port(char *ca_name, char *dir, int portnum, umad_port_t * port)
+static int get_port(const char *ca_name, const char *dir, int portnum, umad_port_t * port)
 {
 	char port_dir[256];
 	uint8_t gid[16];
@@ -230,7 +230,7 @@ static int release_ca(umad_ca_t * ca)
  * the first port that is link up and if none are linkup, then
  * the first port that is not disabled.  Otherwise return -1.
  */
-static int resolve_ca_port(char *ca_name, int *port)
+static int resolve_ca_port(const char *ca_name, int *port)
 {
 	umad_ca_t ca;
 	int active = -1, up = -1;
@@ -313,7 +313,7 @@ Exit:
 	return ret;
 }
 
-static char *resolve_ca_name(char *ca_name, int *best_port)
+static const char *resolve_ca_name(const char *ca_name, int *best_port)
 {
 	static char names[UMAD_MAX_DEVICES][UMAD_CA_NAME_LEN];
 	int phys_found = -1, port_found = 0, port, port_type;
@@ -370,7 +370,7 @@ static char *resolve_ca_name(char *ca_name, int *best_port)
 	return def_ca_name;
 }
 
-static int get_ca(char *ca_name, umad_ca_t * ca)
+static int get_ca(const char *ca_name, umad_ca_t * ca)
 {
 	DIR *dir;
 	char dir_name[256];
@@ -477,7 +477,7 @@ static int umad_id_to_dev(int umad_id, char *dev, unsigned *port)
 	return 0;
 }
 
-static int dev_to_umad_id(char *dev, unsigned port)
+static int dev_to_umad_id(const char *dev, unsigned port)
 {
 	char umad_dev[UMAD_CA_NAME_LEN];
 	unsigned umad_port;
@@ -528,7 +528,7 @@ int umad_done(void)
 	return 0;
 }
 
-static unsigned is_ib_type(char *ca_name)
+static unsigned is_ib_type(const char *ca_name)
 {
 	char dir_name[256];
 	unsigned type;
@@ -571,7 +571,7 @@ int umad_get_cas_names(char cas[][UMAD_CA_NAME_LEN], int max)
 	return j;
 }
 
-int umad_get_ca_portguids(char *ca_name, uint64_t * portguids, int max)
+int umad_get_ca_portguids(const char *ca_name, uint64_t * portguids, int max)
 {
 	umad_ca_t ca;
 	int ports = 0, i;
@@ -600,7 +600,7 @@ int umad_get_ca_portguids(char *ca_name, uint64_t * portguids, int max)
 	return ports;
 }
 
-int umad_get_issm_path(char *ca_name, int portnum, char path[], int max)
+int umad_get_issm_path(const char *ca_name, int portnum, char path[], int max)
 {
 	int umad_id;
 
@@ -617,7 +617,7 @@ int umad_get_issm_path(char *ca_name, int portnum, char path[], int max)
 	return 0;
 }
 
-int umad_open_port(char *ca_name, int portnum)
+int umad_open_port(const char *ca_name, int portnum)
 {
 	char dev_file[UMAD_DEV_FILE_SZ];
 	int umad_id, fd;
@@ -649,7 +649,7 @@ int umad_open_port(char *ca_name, int portnum)
 	return fd;
 }
 
-int umad_get_ca(char *ca_name, umad_ca_t * ca)
+int umad_get_ca(const char *ca_name, umad_ca_t * ca)
 {
 	int r;
 
@@ -682,7 +682,7 @@ int umad_release_ca(umad_ca_t * ca)
 	return 0;
 }
 
-int umad_get_port(char *ca_name, int portnum, umad_port_t * port)
+int umad_get_port(const char *ca_name, int portnum, umad_port_t * port)
 {
 	char dir_name[256];
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
