From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv2 ibacm 10/15] Add the ability to preload the destination
 GID and LID caches
Date: Thu, 27 Jun 2013 09:57:21 -0400
Message-ID: <51CC44C1.5050803@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Preloading of these caches is supported via a file which is
produced by OpenSM by the dump_pr plugin which contains
sufficient SA PathRecord information. Details on this
file format and configuring OpenSM for this are found in
dump_pr_notes.txt in dump_pr.

File format is specified in ibacm_opts.cfg as follows:
path_rec_fmt full_opensm_v1

File format defaults to none which means no preload of ACM cache.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changes since v1:
Eliminated command line option in favor of option file parameters
Fixed address and route resolution cache timers

 ibacm_opts.cfg |   12 +++
 linux/osd.h    |    2 +
 man/ibacm.1    |   13 +++-
 src/acm.c      |  254 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 src/acme.c     |   12 +++
 5 files changed, 290 insertions(+), 3 deletions(-)

diff --git a/ibacm_opts.cfg b/ibacm_opts.cfg
index 87f31d9..968a99d 100644
--- a/ibacm_opts.cfg
+++ b/ibacm_opts.cfg
@@ -143,3 +143,15 @@ min_mtu 2048
 
 min_rate 10
 
+# path_rec_fmt:
+# Indicates format of optional path records file for preloading ACM cache.
+# Supported formats are:
+# none - No path record file preloading (default)
+# full_opensm_v1 - OpenSM "full" path records dump file format (version 1)
+
+path_rec_fmt none
+
+# path_rec_file:
+# If path_rec_fmt is other than "none", full pathname of path records file
+# to use for preloading the ACM cache.  Default is ACM_CONF_DIR/ibacm_path_records.dump
+
diff --git a/linux/osd.h b/linux/osd.h
index c8278aa..0b6884f 100644
--- a/linux/osd.h
+++ b/linux/osd.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2009 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2013 Mellanox Technologies LTD. All rights reserved.
  *
  * This software is available to you under the OpenFabrics.org BSD license
  * below:
@@ -57,6 +58,7 @@
 #define ACM_CONF_DIR  SYSCONFDIR "/" RDMADIR
 #define ACM_ADDR_FILE "ibacm_addr.cfg"
 #define ACM_OPTS_FILE "ibacm_opts.cfg"
+#define ACM_PATH_REC_FILE "ibacm_path_records.dump"
 
 #define LIB_DESTRUCTOR __attribute__((destructor))
 #define CDECL_FUNC
diff --git a/man/ibacm.1 b/man/ibacm.1
index 35b79c6..3a1e212 100644
--- a/man/ibacm.1
+++ b/man/ibacm.1
@@ -1,4 +1,4 @@
-.TH "ibacm" 1 "2013-06-15" "ibacm" "ibacm" ibacm
+.TH "ibacm" 1 "2013-06-18" "ibacm" "ibacm" ibacm
 .SH NAME
 ibacm \- address and route resolution services for InfiniBand.
 .SH SYNOPSIS
@@ -145,5 +145,16 @@ request is received from a different QPN than a cached request.
 limited to 4.
 .P
 - The number of multicast groups that an endpoint can support is limited to 2.
+.P
+The ibacm contains several internal caches.  These include caches for GID
+and LID destination addresses.  These caches can be optionally
+preloaded. ibacm supports the OpenSM dump_pr plugin "full" PathRecord 
+format which is used to preload these caches.
+The file format is specified in the ibacm_opts.cfg file via the
+path_rec_fmt parameter which should be set to full_opensm_v1 for this file
+format.  Default is none which does not preload these caches.
+See dump_pr.notes.txt in dump_pr for more information on the
+full_opensm_v1 file format and how to configure OpenSM to
+generate this file.
 .SH "SEE ALSO"
 ibacm(7), ib_acme(1), rdma_cm(7)
diff --git a/src/acm.c b/src/acm.c
index a124e93..aac7883 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2009-2012 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Mellanox Technologies LTD. All rights reserved.
  *
  * This software is available to you under the OpenIB.org BSD license
  * below:
@@ -49,6 +50,8 @@
 
 #define src_out     data[0]
 
+#define IB_LID_MCAST_START 0xc000
+
 #define MAX_EP_ADDR 4
 #define MAX_EP_MC   2
 
@@ -74,6 +77,11 @@ enum acm_loopback_prot {
 	ACM_LOOPBACK_PROT_LOCAL
 };
 
+enum acm_path_rec_fmt {
+	ACM_PATH_REV_FMT_NONE,
+	ACM_PATH_REV_FMT_OSM_FULL_V1
+};
+
 /*
  * Nested locking order: dest -> ep, dest -> port
  */
@@ -210,6 +218,7 @@ static atomic_t counter[ACM_MAX_COUNTER];
 static char *acme = BINDIR "/ib_acme -A";
 static char *opts_file = ACM_CONF_DIR "/" ACM_OPTS_FILE;
 static char *addr_file = ACM_CONF_DIR "/" ACM_ADDR_FILE;
+static char path_rec_file[128] = ACM_CONF_DIR "/" ACM_PATH_REC_FILE;
 static char log_file[128] = "/var/log/ibacm.log";
 static int log_level = 0;
 static char lock_file[128] = "/var/run/ibacm.pid";
@@ -227,6 +236,7 @@ static int send_depth = 1;
 static int recv_depth = 1024;
 static uint8_t min_mtu = IBV_MTU_2048;
 static uint8_t min_rate = IBV_RATE_10_GBPS;
+static enum acm_path_rec_fmt path_rec_fmt = ACM_PATH_REV_FMT_NONE;
 
 #define acm_log(level, format, ...) \
 	acm_write(level, "%s: "format, __func__, ## __VA_ARGS__)
@@ -2444,6 +2454,15 @@ static enum acm_loopback_prot acm_convert_loopback_prot(char *param)
 	return loopback_prot;
 }
 
+static enum acm_path_rec_fmt acm_convert_path_rec_fmt(char *param)
+{
+	if (!stricmp("none", param))
+		return ACM_PATH_REV_FMT_NONE;
+	else if (!stricmp("full_opensm_v1", param))
+		return ACM_PATH_REV_FMT_OSM_FULL_V1;
+	return path_rec_fmt;
+}
+
 static enum ibv_rate acm_get_rate(uint8_t width, uint8_t speed)
 {
 	switch (width) {
@@ -2553,6 +2572,224 @@ static FILE *acm_open_addr_file(void)
 	return fopen(addr_file, "r");
 }
 
+static void acm_parse_path_records_pass1(FILE *f, uint64_t *lid2guid)
+{
+	char s[128];
+	char *p, *ptr, *p_guid, *p_lid;
+	uint64_t guid;
+	uint16_t lid;
+
+	/* Pass 1 - LID to GUID table */
+	while (fgets(s, sizeof s, f)) {
+		if (s[0] == '#')
+			continue;
+		if (!(p = strtok_r(s, " \n", &ptr)))
+			continue;	/* ignore blank lines */
+
+		if (strncmp(p, "Switch", sizeof("Switch") - 1) &&
+		    strncmp(p, "Channel", sizeof("Channel") - 1) &&
+		    strncmp(p, "Router", sizeof("Router") - 1))
+			continue;
+
+		if (!strncmp(p, "Channel", sizeof("Channel") - 1)) {
+			p = strtok_r(NULL, " ", &ptr); /* skip 'Adapter' */
+			if (!p)
+				continue;
+		}
+
+		p_guid = strtok_r(NULL, ",", &ptr);
+		if (!p_guid)
+			continue;
+
+		guid = (uint64_t) strtoull(p_guid, NULL, 16);
+
+		ptr = strstr(ptr, "base LID");
+		if (!ptr)
+			continue;
+		ptr += sizeof("base LID");
+		p_lid = strtok_r(NULL, ",", &ptr);
+		if (!p_lid)
+			continue;
+
+		lid = (uint16_t) strtoul(p_lid, NULL, 0);
+		if (lid >= IB_LID_MCAST_START)
+			continue;
+		if (lid2guid[lid])
+			acm_log(0, "ERROR - duplicate lid %u\n", lid);
+		else
+			lid2guid[lid] = htonll(guid);
+	}
+}
+
+static int acm_parse_path_records_pass2(FILE *f, uint64_t *lid2guid,
+				 	struct acm_ep *ep)
+{
+	union ibv_gid sgid, dgid;
+	struct ibv_port_attr attr = { 0 };
+	struct acm_dest *dest;
+	char s[128];
+	char *p, *ptr, *p_guid, *p_lid;
+	uint64_t guid;
+	uint16_t lid, dlid;
+	int sl, mtu, rate;
+	int ret = 1, i;
+	uint8_t addr[ACM_MAX_ADDRESS];
+	uint8_t addr_type;
+
+	ibv_query_gid(ep->port->dev->verbs, ep->port->port_num, 0, &sgid);
+
+	/* Pass 2 - Path records for source to all destinations */
+
+	while (fgets(s, sizeof s, f)) {
+		if (s[0] == '#')
+			continue;
+		if (!(p = strtok_r(s, " \n", &ptr)))
+			continue;	/* ignore blank lines */
+
+		if (strncmp(p, "Switch", sizeof("Switch") - 1) &&
+		    strncmp(p, "Channel", sizeof("Channel") - 1) &&
+		    strncmp(p, "Router", sizeof("Router") - 1))
+			continue;
+
+		if (!strncmp(p, "Channel", sizeof("Channel") - 1)) {
+			p = strtok_r(NULL, " ", &ptr); /* skip 'Adapter' */
+			if (!p)
+				continue;
+		}
+
+		p_guid = strtok_r(NULL, ",", &ptr);
+		if (!p_guid)
+			continue;
+
+		guid = (uint64_t) strtoull(p_guid, NULL, 16);
+		if (guid != ntohll(sgid.global.interface_id))
+			continue;
+
+		ptr = strstr(ptr, "base LID");
+		if (!ptr)
+			continue;
+		ptr += sizeof("base LID");
+		p_lid = strtok_r(NULL, ",", &ptr);
+		if (!p_lid)
+			continue;
+
+		lid = (uint16_t) strtoul(p_lid, NULL, 0);
+		if (lid != ep->port->lid)
+			continue;
+		ibv_query_port(ep->port->dev->verbs, ep->port->port_num, &attr);
+		ret = 0;
+		break;
+	}
+
+	while (fgets(s, sizeof s, f)) {
+		if (s[0] == '#')
+			continue;
+		if (!(p = strtok_r(s, " \n", &ptr)))
+			continue;	/* ignore blank lines */
+
+		if (!strncmp(p, "Switch", sizeof("Switch") - 1) ||
+		    !strncmp(p, "Channel", sizeof("Channel") - 1) ||
+		    !strncmp(p, "Router", sizeof("Router") - 1))
+			break;
+
+		dlid = strtoul(p, NULL, 0);
+
+		p = strtok_r(NULL, ":", &ptr);
+		if (!p)
+			continue;
+		if (strcmp(p, "UNREACHABLE") == 0)
+			continue;
+		sl = atoi(p);
+
+		p = strtok_r(NULL, ":", &ptr);
+		if (!p)
+			continue;
+		mtu = atoi(p);
+
+		p = strtok_r(NULL, ":", &ptr);
+		if (!p)
+			continue;
+		rate = atoi(p);
+
+		if (!lid2guid[dlid]) {
+			acm_log(0, "ERROR - dlid %u not found in lid2guid table\n", dlid);
+			continue;
+		}
+
+		dgid.global.subnet_prefix = sgid.global.subnet_prefix;
+		dgid.global.interface_id = lid2guid[dlid];
+
+		for (i = 0; i < 2; i++) {
+			memset(addr, 0, ACM_MAX_ADDRESS);
+			if (i == 0) {
+				addr_type = ACM_ADDRESS_LID;
+				*((uint16_t *) addr) = htons(dlid);
+			} else {
+				addr_type = ACM_ADDRESS_GID;
+				memcpy(addr, &dgid, sizeof(dgid));
+			}
+			dest = acm_acquire_dest(ep, addr_type, addr);
+			if (!dest) {
+				acm_log(0, "ERROR - unable to create dest\n");
+				break;
+			}
+
+			dest->path.sgid = sgid;
+			dest->path.slid = htons(ep->port->lid);
+			dest->path.dgid = dgid;
+			dest->path.dlid = htons(dlid);
+			dest->path.reversible_numpath = IBV_PATH_RECORD_REVERSIBLE;
+			dest->path.pkey = htons(ep->pkey);
+			dest->path.mtu = (uint8_t) mtu;
+			dest->path.rate = (uint8_t) rate;
+			dest->path.qosclass_sl = htons((uint16_t) sl & 0xF);
+			if (dlid == ep->port->lid) {
+				dest->path.packetlifetime = 0;
+				dest->addr_timeout = (uint64_t)~0ULL;
+				dest->route_timeout = (uint64_t)~0ULL;
+			} else {
+				dest->path.packetlifetime = attr.subnet_timeout;
+				dest->addr_timeout = time_stamp_min() + (unsigned) addr_timeout;
+				dest->route_timeout = time_stamp_min() + (unsigned) route_timeout;
+			}
+			dest->remote_qpn = 1;
+			dest->state = ACM_READY;
+			acm_put_dest(dest);
+			acm_log(1, "added cached dest %s\n", dest->name);
+		}
+	}
+	return ret;
+}
+
+static int acm_parse_path_records(struct acm_ep *ep)
+{
+	FILE *f;
+	uint64_t *lid2guid;
+	int ret = 1;
+
+	if (!(f = fopen(path_rec_file, "r"))) {
+		acm_log(0, "ERROR - couldn't open %s\n", path_rec_file); 
+		return ret;
+	}
+
+	lid2guid = calloc(IB_LID_MCAST_START, sizeof(*lid2guid));
+	if (!lid2guid) {
+		acm_log(0, "ERROR - no memory for path record parsing\n");
+		goto err;
+	}
+
+	if (path_rec_fmt == ACM_PATH_REV_FMT_OSM_FULL_V1) {
+		acm_parse_path_records_pass1(f, lid2guid);
+		rewind(f);
+		ret = acm_parse_path_records_pass2(f, lid2guid, ep);
+	}
+
+	free(lid2guid);
+err:
+	fclose(f);
+	return ret;
+}
+
 static int acm_assign_ep_names(struct acm_ep *ep)
 {
 	FILE *faddr;
@@ -2802,6 +3039,13 @@ static void acm_ep_up(struct acm_port *port, uint16_t pkey_index)
 	lock_acquire(&port->lock);
 	DListInsertHead(&ep->entry, &port->ep_list);
 	lock_release(&port->lock);
+
+	if (path_rec_fmt == ACM_PATH_REV_FMT_OSM_FULL_V1) {
+		ret = acm_parse_path_records(ep);
+		if (ret)
+			acm_log(1, "unable to find ep in path records\n");
+	}
+
 	return;
 
 err2:
@@ -3114,6 +3358,10 @@ static void acm_set_options(void)
 			min_mtu = acm_convert_mtu(atoi(value));
 		else if (!stricmp("min_rate", opt))
 			min_rate = acm_convert_rate(atoi(value));
+		else if (!stricmp("path_rec_fmt", opt))
+			path_rec_fmt = acm_convert_path_rec_fmt(value);
+		else if (!stricmp("path_rec_file", opt))
+			strcpy(path_rec_file, value);
 	}
 
 	fclose(f);
@@ -3137,6 +3385,8 @@ static void acm_log_options(void)
 	acm_log(0, "receive depth %d\n", recv_depth);
 	acm_log(0, "minimum mtu %d\n", min_mtu);
 	acm_log(0, "minimum rate %d\n", min_rate);
+	acm_log(0, "path record format %d\n", path_rec_fmt);
+	acm_log(0, "path record file %s\n", path_rec_file);
 }
 
 static FILE *acm_open_log(void)
@@ -3200,9 +3450,9 @@ static void show_usage(char *program)
 	printf("   [-D]             - run as a daemon (default)\n");
 	printf("   [-P]             - run as a standard process\n");
 	printf("   [-A addr_file]   - address configuration file\n");
-	printf("                      (default %s/%s\n", ACM_CONF_DIR, ACM_ADDR_FILE);
+	printf("                      (default %s/%s)\n", ACM_CONF_DIR, ACM_ADDR_FILE);
 	printf("   [-O option_file] - option configuration file\n");
-	printf("                      (default %s/%s\n", ACM_CONF_DIR, ACM_OPTS_FILE);
+	printf("                      (default %s/%s)\n", ACM_CONF_DIR, ACM_OPTS_FILE);
 }
 
 int CDECL_FUNC main(int argc, char **argv)
diff --git a/src/acme.c b/src/acme.c
index d7ad25f..ec1d3d2 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -244,6 +244,18 @@ static void gen_opts_temp(FILE *f)
 	fprintf(f, "\n");
 	fprintf(f, "min_rate 10\n");
 	fprintf(f, "\n");
+	fprintf(f, "# path_rec_fmt:\n");
+	fprintf(f, "# Indicates format of optional path records file for preloading ACM cache.\n");
+	fprintf(f, "# Supported formats are:\n");
+	fprintf(f, "# none - No path record file preloading (default)\n");
+	fprintf(f, "# full_opensm_v1 - OpenSM \"full\" path records dump file format (version 1)\n");
+	fprintf(f, "\n");
+	fprintf(f, "path_rec_fmt none\n");
+	fprintf(f, "\n");
+	fprintf(f, "# path_rec_file:\n");
+	fprintf(f, "# If path_rec_fmt is other than \"none\", full pathname of path records file\n");
+	fprintf(f, "# to use for preloading the ACM cache.  Default is ACM_CONF_DIR/ibacm_path_records.dump\n");
+	fprintf(f, "\n");
 }
 
 static int open_dir(void)
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
