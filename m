From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 5/5] infiniband-diags: migrate resolve_portid_str in from libibmad
Date: Thu, 12 Apr 2012 18:09:45 -0700
Message-ID: <1334279385-10792-5-git-send-email-foraker1@llnl.gov>
References: <1334279385-10792-1-git-send-email-foraker1@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334279385-10792-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ib_resolve_portid_str_via() is replaced with resolve_portid_str(),
which operates identically but does not issue any SMPs.  Data is
pulled from the umad layer, which necessitates it taking 2 new
arguments.

Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 include/ibdiag_common.h |    3 ++
 src/ibaddr.c            |    4 +-
 src/ibccconfig.c        |    4 +-
 src/ibccquery.c         |    4 +-
 src/ibdiag_common.c     |  118 ++++++++++++++++++++++++++++++++++++++++++++++-
 src/iblinkinfo.c        |   10 ++--
 src/ibping.c            |    4 +-
 src/ibportstate.c       |    4 +-
 src/ibqueryerrors.c     |    8 ++--
 src/ibroute.c           |    4 +-
 src/ibsysstat.c         |    4 +-
 src/ibtracert.c         |    8 ++--
 src/perfquery.c         |    4 +-
 src/sminfo.c            |    4 +-
 src/smpquery.c          |    8 ++--
 src/vendstat.c          |    4 +-
 16 files changed, 156 insertions(+), 39 deletions(-)

diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index 4388834..09dc319 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -147,4 +147,7 @@ void get_max_msg(char *width_msg, char *speed_msg, int msg_size,
 int resolve_sm_portid(char *ca_name, uint8_t portnum, ib_portid_t *sm_id);
 int resolve_self(char *ca_name, uint8_t ca_port, ib_portid_t *portid,
                  int *port, ibmad_gid_t *gid);
+int resolve_portid_str(char *ca_name, uint8_t ca_port, ib_portid_t * portid,
+		       char *addr_str, enum MAD_DEST dest_type,
+		       ib_portid_t *sm_id, const struct ibmad_port *srcport);
 #endif				/* _IBDIAG_COMMON_H_ */
diff --git a/src/ibaddr.c b/src/ibaddr.c
index 10dfae8..455d941 100644
--- a/src/ibaddr.c
+++ b/src/ibaddr.c
@@ -150,8 +150,8 @@ int main(int argc, char **argv)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
 	if (argc) {
-		if (ib_resolve_portid_str_via(&portid, argv[0], ibd_dest_type,
-					      ibd_sm_id, srcport) < 0)
+		if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
+				       ibd_dest_type, ibd_sm_id, srcport) < 0)
 			IBERROR("can't resolve destination port %s", argv[0]);
 	} else {
 		if (resolve_self(ibd_ca, ibd_ca_port, &portid, &port, NULL) < 0)
diff --git a/src/ibccconfig.c b/src/ibccconfig.c
index c81b7fa..71d408a 100644
--- a/src/ibccconfig.c
+++ b/src/ibccconfig.c
@@ -636,8 +636,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
-	if (ib_resolve_portid_str_via(&portid, argv[1], ibd_dest_type,
-				      ibd_sm_id, srcport) < 0)
+	if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[1],
+			       ibd_dest_type, ibd_sm_id, srcport) < 0)
 		IBERROR("can't resolve destination %s", argv[1]);
 	if ((err = fn(&portid, argv + 2, argc - 2)))
 		IBERROR("operation %s: %s", argv[0], err);
diff --git a/src/ibccquery.c b/src/ibccquery.c
index cf8b35a..2bf62fa 100644
--- a/src/ibccquery.c
+++ b/src/ibccquery.c
@@ -416,8 +416,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
-	if (ib_resolve_portid_str_via(&portid, argv[1], ibd_dest_type,
-				      ibd_sm_id, srcport) < 0)
+	if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[1],
+			       ibd_dest_type, ibd_sm_id, srcport) < 0)
 		IBERROR("can't resolve destination %s", argv[1]);
 	if ((err = fn(&portid, argv + 2, argc - 2)))
 		IBERROR("operation %s: %s", argv[0], err);
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index 6605362..5752f95 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -255,8 +255,8 @@ static int process_opt(int ch, char *optarg)
 		break;
 	case 's':
 		/* srcport is not required when resolving via IB_DEST_LID */
-		if (ib_resolve_portid_str_via(&sm_portid, optarg, IB_DEST_LID,
-					      0, NULL) < 0)
+		if (resolve_portid_str(ibd_ca, ibd_ca_port, &sm_portid, optarg,
+				IB_DEST_LID, 0, NULL) < 0)
 			IBERROR("cannot resolve SM destination port %s",
 				optarg);
 		ibd_sm_id = &sm_portid;
@@ -544,6 +544,120 @@ int resolve_self(char *ca_name, uint8_t ca_port, ib_portid_t *portid,
 	return 0;
 }
 
+int resolve_gid(char *ca_name, uint8_t ca_port, ib_portid_t * portid,
+		ibmad_gid_t gid, ib_portid_t * sm_id,
+		const struct ibmad_port *srcport)
+{
+	ib_portid_t sm_portid;
+	char buf[IB_SA_DATA_SIZE] = { 0 };
+
+	if (!sm_id) {
+		sm_id = &sm_portid;
+		if (resolve_sm_portid(ca_name, ca_port, sm_id) < 0)
+			return -1;
+	}
+
+	if ((portid->lid =
+	     ib_path_query_via(srcport, gid, gid, sm_id, buf)) < 0)
+		return -1;
+
+	return 0;
+}
+
+int resolve_guid(char *ca_name, uint8_t ca_port, ib_portid_t *portid,
+		 uint64_t *guid, ib_portid_t *sm_id,
+		 const struct ibmad_port *srcport)
+{
+	ib_portid_t sm_portid;
+	uint8_t buf[IB_SA_DATA_SIZE] = { 0 };
+	uint64_t prefix;
+	ibmad_gid_t selfgid;
+
+	if (!sm_id) {
+		sm_id = &sm_portid;
+		if (resolve_sm_portid(ca_name, ca_port, sm_id) < 0)
+			return -1;
+	}
+
+	if (resolve_self(ca_name, ca_port, NULL, NULL, &selfgid) < 0)
+		return -1;
+
+	memcpy(&prefix, portid->gid, sizeof(prefix));
+	if (!prefix)
+		mad_set_field64(portid->gid, 0, IB_GID_PREFIX_F,
+				IB_DEFAULT_SUBN_PREFIX);
+	if (guid)
+		mad_set_field64(portid->gid, 0, IB_GID_GUID_F, *guid);
+
+	if ((portid->lid =
+	     ib_path_query_via(srcport, selfgid, portid->gid, sm_id, buf)) < 0)
+		return -1;
+
+	mad_decode_field(buf, IB_SA_PR_SL_F, &portid->sl);
+	return 0;
+}
+
+int resolve_portid_str(char *ca_name, uint8_t ca_port, ib_portid_t * portid,
+		       char *addr_str, enum MAD_DEST dest_type,
+		       ib_portid_t *sm_id, const struct ibmad_port *srcport)
+{
+	ibmad_gid_t gid;
+	uint64_t guid;
+	int lid;
+	char *routepath;
+	ib_portid_t selfportid = { 0 };
+	int selfport = 0;
+
+	memset(portid, 0, sizeof *portid);
+
+	switch (dest_type) {
+	case IB_DEST_LID:
+		lid = strtol(addr_str, 0, 0);
+		if (!IB_LID_VALID(lid))
+			return -1;
+		return ib_portid_set(portid, lid, 0, 0);
+
+	case IB_DEST_DRPATH:
+		if (str2drpath(&portid->drpath, addr_str, 0, 0) < 0)
+			return -1;
+		return 0;
+
+	case IB_DEST_GUID:
+		if (!(guid = strtoull(addr_str, 0, 0)))
+			return -1;
+
+		/* keep guid in portid? */
+		return resolve_guid(ca_name, ca_port, portid, &guid, sm_id,
+				    srcport);
+
+	case IB_DEST_DRSLID:
+		lid = strtol(addr_str, &routepath, 0);
+		routepath++;
+		if (!IB_LID_VALID(lid))
+			return -1;
+		ib_portid_set(portid, lid, 0, 0);
+
+		/* handle DR parsing and set DrSLID to local lid */
+		if (resolve_self(ca_name, ca_port, &selfportid, &selfport,
+				 NULL) < 0)
+			return -1;
+		if (str2drpath(&portid->drpath, routepath, selfportid.lid, 0) <
+		    0)
+			return -1;
+		return 0;
+
+	case IB_DEST_GID:
+		if (inet_pton(AF_INET6, addr_str, &gid) <= 0)
+			return -1;
+		return resolve_gid(ca_name, ca_port, portid, gid, sm_id,
+				   srcport);
+	default:
+		IBWARN("bad dest_type %d", dest_type);
+	}
+
+	return -1;
+}
+
 /* define a common SA query structure
  * This is by no means optimal but it moves the saquery functionality out of
  * the saquery tool and provides it to other utilities.
diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
index 575be0a..36aa6d1 100644
--- a/src/iblinkinfo.c
+++ b/src/iblinkinfo.c
@@ -649,15 +649,15 @@ int main(int argc, char **argv)
 	if (dr_path) {
 		/* only scan part of the fabric */
 		if ((resolved =
-		     ib_resolve_portid_str_via(&port_id, dr_path,
-					       IB_DEST_DRPATH, NULL,
-					       ibmad_port)) < 0)
+		     resolve_portid_str(ibd_ca, ibd_ca_port, &port_id, dr_path,
+					IB_DEST_DRPATH, NULL, ibmad_port)) < 0)
 			IBWARN("Failed to resolve %s; attempting full scan",
 			       dr_path);
 	} else if (guid_str) {
 		if ((resolved =
-		     ib_resolve_portid_str_via(&port_id, guid_str, IB_DEST_GUID,
-					       NULL, ibmad_port)) < 0)
+		     resolve_portid_str(ibd_ca, ibd_ca_port, &port_id,
+				        guid_str, IB_DEST_GUID, NULL,
+					ibmad_port)) < 0)
 			IBWARN("Failed to resolve %s; attempting full scan\n",
 			       guid_str);
 	}
diff --git a/src/ibping.c b/src/ibping.c
index 16ffb34..9d5c54b 100644
--- a/src/ibping.c
+++ b/src/ibping.c
@@ -232,8 +232,8 @@ int main(int argc, char **argv)
 		IBERROR("can't register ping class %d on this port",
 			ping_class);
 
-	if (ib_resolve_portid_str_via(&portid, argv[0], ibd_dest_type,
-				      ibd_sm_id, srcport) < 0)
+	if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
+			       ibd_dest_type, ibd_sm_id, srcport) < 0)
 		IBERROR("can't resolve destination port %s", argv[0]);
 
 	signal(SIGINT, report);
diff --git a/src/ibportstate.c b/src/ibportstate.c
index ac74dfd..5559d18 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -376,8 +376,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
-	if (ib_resolve_portid_str_via(&portid, argv[0], ibd_dest_type,
-				      ibd_sm_id, srcport) < 0)
+	if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
+			       ibd_dest_type, ibd_sm_id, srcport) < 0)
 		IBERROR("can't resolve destination port %s", argv[0]);
 
 	if (argc > 1)
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index f877527..4fec240 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -931,14 +931,14 @@ int main(int argc, char **argv)
 	/* limit the scan the fabric around the target */
 	if (dr_path) {
 		if ((resolved =
-		     ib_resolve_portid_str_via(&portid, dr_path, IB_DEST_DRPATH,
-					       NULL, ibmad_port)) < 0)
+		     resolve_portid_str(ibd_ca, ibd_ca_port, &portid, dr_path,
+					IB_DEST_DRPATH, NULL, ibmad_port)) < 0)
 			IBWARN("Failed to resolve %s; attempting full scan",
 			       dr_path);
 	} else if (port_guid_str) {
 		if ((resolved =
-		     ib_resolve_portid_str_via(&portid, port_guid_str,
-					       IB_DEST_GUID, ibd_sm_id,
+		     resolve_portid_str(ibd_ca, ibd_ca_port, &portid,
+					port_guid_str, IB_DEST_GUID, ibd_sm_id,
 					       ibmad_port)) < 0)
 			IBWARN("Failed to resolve %s; attempting full scan",
 			       port_guid_str);
diff --git a/src/ibroute.c b/src/ibroute.c
index 1bf1fb0..faff34d 100644
--- a/src/ibroute.c
+++ b/src/ibroute.c
@@ -432,8 +432,8 @@ int main(int argc, char **argv)
 	if (!srcport)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
-	if (ib_resolve_portid_str_via(&portid, argv[0], ibd_dest_type,
-					     ibd_sm_id, srcport) < 0)
+	if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
+			       ibd_dest_type, ibd_sm_id, srcport) < 0)
 		IBERROR("can't resolve destination port %s", argv[1]);
 
 	if (multicast)
diff --git a/src/ibsysstat.c b/src/ibsysstat.c
index f007aa3..2b11a06 100644
--- a/src/ibsysstat.c
+++ b/src/ibsysstat.c
@@ -358,8 +358,8 @@ int main(int argc, char **argv)
 	if (mad_register_client_via(sysstat_class, 1, srcport) < 0)
 		IBERROR("can't register to sysstat class %d", sysstat_class);
 
-	if (ib_resolve_portid_str_via(&portid, argv[0], ibd_dest_type,
-				      ibd_sm_id, srcport) < 0)
+	if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
+			       ibd_dest_type, ibd_sm_id, srcport) < 0)
 		IBERROR("can't resolve destination port %s", argv[0]);
 
 	if ((err = ibsystat(&portid, attr)))
diff --git a/src/ibtracert.c b/src/ibtracert.c
index c9f511b..e8fedf3 100644
--- a/src/ibtracert.c
+++ b/src/ibtracert.c
@@ -776,12 +776,12 @@ int main(int argc, char **argv)
 
 	node_name_map = open_node_name_map(node_name_map_file);
 
-	if (ib_resolve_portid_str_via(&src_portid, argv[0], ibd_dest_type,
-				      ibd_sm_id, srcport) < 0)
+	if (resolve_portid_str(ibd_ca, ibd_ca_port, &src_portid, argv[0],
+			       ibd_dest_type, ibd_sm_id, srcport) < 0)
 		IBERROR("can't resolve source port %s", argv[0]);
 
-	if (ib_resolve_portid_str_via(&dest_portid, argv[1], ibd_dest_type,
-				      ibd_sm_id, srcport) < 0)
+	if (resolve_portid_str(ibd_ca, ibd_ca_port, &dest_portid, argv[1],
+			       ibd_dest_type, ibd_sm_id, srcport) < 0)
 		IBERROR("can't resolve destination port %s", argv[1]);
 
 	if (ibd_dest_type == IB_DEST_DRPATH) {
diff --git a/src/perfquery.c b/src/perfquery.c
index 7361c06..8835d3d 100644
--- a/src/perfquery.c
+++ b/src/perfquery.c
@@ -730,8 +730,8 @@ int main(int argc, char **argv)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
 	if (argc) {
-		if (ib_resolve_portid_str_via(&portid, argv[0], ibd_dest_type,
-					      ibd_sm_id, srcport) < 0)
+		if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
+				       ibd_dest_type, ibd_sm_id, srcport) < 0)
 			IBERROR("can't resolve destination port %s", argv[0]);
 	} else {
 		if (resolve_self(ibd_ca, ibd_ca_port, &portid, &port, 0) < 0)
diff --git a/src/sminfo.c b/src/sminfo.c
index dfe0681..f1abc6a 100644
--- a/src/sminfo.c
+++ b/src/sminfo.c
@@ -123,8 +123,8 @@ int main(int argc, char **argv)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
 	if (argc) {
-		if (ib_resolve_portid_str_via(&portid, argv[0], ibd_dest_type,
-					      0, srcport) < 0)
+		if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
+				       ibd_dest_type, 0, srcport) < 0)
 			IBERROR("can't resolve destination port %s", argv[0]);
 	} else {
 		if (resolve_sm_portid(ibd_ca, ibd_ca_port, &portid) < 0)
diff --git a/src/smpquery.c b/src/smpquery.c
index cecfa68..533b2c3 100644
--- a/src/smpquery.c
+++ b/src/smpquery.c
@@ -483,8 +483,8 @@ int main(int argc, char **argv)
 	node_name_map = open_node_name_map(node_name_map_file);
 
 	if (ibd_dest_type != IB_DEST_DRSLID) {
-		if (ib_resolve_portid_str_via(&portid, argv[1], ibd_dest_type,
-					      ibd_sm_id, srcport) < 0)
+		if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[1],
+				       ibd_dest_type, ibd_sm_id, srcport) < 0)
 			IBERROR("can't resolve destination port %s", argv[1]);
 		if ((err = fn(&portid, argv + 2, argc - 2)))
 			IBERROR("operation %s: %s", argv[0], err);
@@ -493,8 +493,8 @@ int main(int argc, char **argv)
 
 		memset(concat, 0, 64);
 		snprintf(concat, sizeof(concat), "%s %s", argv[1], argv[2]);
-		if (ib_resolve_portid_str_via(&portid, concat, ibd_dest_type,
-					      ibd_sm_id, srcport) < 0)
+		if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, concat,
+				       ibd_dest_type, ibd_sm_id, srcport) < 0)
 			IBERROR("can't resolve destination port %s", concat);
 		if ((err = fn(&portid, argv + 3, argc - 3)))
 			IBERROR("operation %s: %s", argv[0], err);
diff --git a/src/vendstat.c b/src/vendstat.c
index 059ceab..1d3d78c 100644
--- a/src/vendstat.c
+++ b/src/vendstat.c
@@ -327,8 +327,8 @@ int main(int argc, char **argv)
 		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
 
 	if (argc) {
-		if (ib_resolve_portid_str_via(&portid, argv[0], ibd_dest_type,
-					      ibd_sm_id, srcport) < 0)
+		if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
+				       ibd_dest_type, ibd_sm_id, srcport) < 0)
 			IBERROR("can't resolve destination port %s", argv[0]);
 	} else {
 		if (resolve_self(ibd_ca, ibd_ca_port, &portid, &port, 0) < 0)
-- 
1.7.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
