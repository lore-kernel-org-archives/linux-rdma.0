From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V3 1/8] infiniband-diags: Obfuscate sensitive output by default
Date: Wed, 30 May 2012 10:21:30 -0700
Message-ID: <1338398497-12444-1-git-send-email-foraker1@llnl.gov>
References: <1338398414.11948.29.camel@auk75.llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338398414.11948.29.camel-mxTxeWJot8FliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: weiny2-i2BcT+NCU+M@public.gmane.org, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Cause security credentials to not be displayed by default. Instead,
the "-K" flag is supported, which must be passed to the command
to display valid results.

Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 doc/rst/common/opt_K.rst  |    4 +++
 doc/rst/saquery.8.in.rst  |    2 ++
 doc/rst/smpquery.8.in.rst |    2 ++
 include/ibdiag_common.h   |    9 ++++++
 src/ibaddr.c              |    2 +-
 src/ibcacheedit.c         |    2 +-
 src/ibccconfig.c          |    2 +-
 src/ibccquery.c           |    2 +-
 src/ibdiag_common.c       |   71 +++++++++++++++++++++++++++++++++++++++++++++
 src/iblinkinfo.c          |    2 +-
 src/ibnetdiscover.c       |    2 +-
 src/ibping.c              |    2 +-
 src/ibqueryerrors.c       |    2 +-
 src/ibroute.c             |    2 +-
 src/ibsendtrap.c          |    2 +-
 src/ibstat.c              |    2 +-
 src/ibsysstat.c           |    2 +-
 src/ibtracert.c           |    2 +-
 src/perfquery.c           |    2 +-
 src/saquery.c             |   66 ++++++++++++++++++++---------------------
 src/sminfo.c              |    2 +-
 src/smpdump.c             |    2 +-
 src/smpquery.c            |    6 ++--
 src/vendstat.c            |    2 +-
 24 files changed, 139 insertions(+), 55 deletions(-)
 create mode 100644 doc/rst/common/opt_K.rst

diff --git a/doc/rst/common/opt_K.rst b/doc/rst/common/opt_K.rst
new file mode 100644
index 0000000..2b96bf2
--- /dev/null
+++ b/doc/rst/common/opt_K.rst
@@ -0,0 +1,4 @@
+.. Define the common option -K
+
+**-K, --show_keys**
+  show security keys (mkey, smkey, etc.) associated with the request.
diff --git a/doc/rst/saquery.8.in.rst b/doc/rst/saquery.8.in.rst
index 36696c7..79c8bd3 100644
--- a/doc/rst/saquery.8.in.rst
+++ b/doc/rst/saquery.8.in.rst
@@ -84,6 +84,8 @@ OPTIONS
         queries.  If non-numeric value (like 'x') is specified then saquery
         will prompt for a value.
 
+.. include:: common/opt_K.rst
+
 **--slid <lid>** Source LID (PathRecord)
 
 **--dlid <lid>** Destination LID (PathRecord)
diff --git a/doc/rst/smpquery.8.in.rst b/doc/rst/smpquery.8.in.rst
index 3b249df..b422731 100644
--- a/doc/rst/smpquery.8.in.rst
+++ b/doc/rst/smpquery.8.in.rst
@@ -46,6 +46,8 @@ Current supported operations and their parameters:
         Set SMSupportsExtendedSpeeds bit 31 in AttributeModifier
         (only impacts PortInfo queries).
 
+.. include:: common/opt_K.rst
+
 
 Addressing Flags
 ----------------
diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index 6645322..e989088 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -39,6 +39,7 @@
 #ifndef _IBDIAG_COMMON_H_
 #define _IBDIAG_COMMON_H_
 
+#include <stdarg.h>
 #include <infiniband/mad.h>
 #include <infiniband/iba/ib_types.h>
 #include <infiniband/ibnetdisc.h>
@@ -50,6 +51,7 @@ extern enum MAD_DEST ibd_dest_type;
 extern ib_portid_t *ibd_sm_id;
 extern int ibd_timeout;
 extern uint32_t ibd_ibnetdisc_flags;
+extern int show_keys;
 
 /*========================================================*/
 /*                External interface                      */
@@ -64,6 +66,8 @@ extern uint32_t ibd_ibnetdisc_flags;
 } while (0)
 #define IBERROR(fmt, ...) iberror(__FUNCTION__, fmt, ## __VA_ARGS__)
 
+#define NOT_DISPLAYED_STR "<not displayed>"
+
 /* not all versions of ib_types.h will have this define */
 #ifndef IB_PM_PC_XMIT_WAIT_SUP
 #define IB_PM_PC_XMIT_WAIT_SUP (CL_HTON16(((uint16_t)1)<<12))
@@ -150,4 +154,9 @@ int resolve_self(char *ca_name, uint8_t ca_port, ib_portid_t *portid,
 int resolve_portid_str(char *ca_name, uint8_t ca_port, ib_portid_t * portid,
 		       char *addr_str, enum MAD_DEST dest_type,
 		       ib_portid_t *sm_id, const struct ibmad_port *srcport);
+int vsnprint_field(char *buf, size_t n, enum MAD_FIELDS f, int spacing,
+		   const char *format, va_list va_args);
+int snprint_field(char *buf, size_t n, enum MAD_FIELDS f, int spacing,
+		  const char *format, ...);
+void dump_portinfo(void *pi, int pisize, int tabs);
 #endif				/* _IBDIAG_COMMON_H_ */
diff --git a/src/ibaddr.c b/src/ibaddr.c
index 455d941..0735837 100644
--- a/src/ibaddr.c
+++ b/src/ibaddr.c
@@ -133,7 +133,7 @@ int main(int argc, char **argv)
 		NULL
 	};
 
-	ibdiag_process_opts(argc, argv, NULL, "L", opts, process_opt,
+	ibdiag_process_opts(argc, argv, NULL, "KL", opts, process_opt,
 			    usage_args, usage_examples);
 
 	argc -= optind;
diff --git a/src/ibcacheedit.c b/src/ibcacheedit.c
index f9e7dc9..2f9a634 100644
--- a/src/ibcacheedit.c
+++ b/src/ibcacheedit.c
@@ -269,7 +269,7 @@ int main(int argc, char **argv)
 	};
 	char *usage_args = "<orig.cache> <new.cache>";
 
-	ibdiag_process_opts(argc, argv, NULL, "CDdeGLPstv",
+	ibdiag_process_opts(argc, argv, NULL, "CDdeGKLPstv",
 			    opts, process_opt, usage_args,
 			    NULL);
 
diff --git a/src/ibccconfig.c b/src/ibccconfig.c
index f84c63c..d796ed8 100644
--- a/src/ibccconfig.c
+++ b/src/ibccconfig.c
@@ -615,7 +615,7 @@ int main(int argc, char **argv)
 			exit(-1);
 	}
 
-	ibdiag_process_opts(argc, argv, NULL, "D", opts, process_opt,
+	ibdiag_process_opts(argc, argv, NULL, "DK", opts, process_opt,
 			    usage_args, usage_examples);
 
 	argc -= optind;
diff --git a/src/ibccquery.c b/src/ibccquery.c
index acdfe46..34a9afd 100644
--- a/src/ibccquery.c
+++ b/src/ibccquery.c
@@ -399,7 +399,7 @@ int main(int argc, char **argv)
 			exit(-1);
 	}
 
-	ibdiag_process_opts(argc, argv, NULL, "D", opts, process_opt,
+	ibdiag_process_opts(argc, argv, NULL, "DK", opts, process_opt,
 			    usage_args, usage_examples);
 
 	argc -= optind;
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index 2f12c46..2662b9b 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -53,6 +53,7 @@
 #include <getopt.h>
 #include <limits.h>
 #include <sys/stat.h>
+#include <stdarg.h>
 
 #include <infiniband/umad.h>
 #include <infiniband/mad.h>
@@ -70,6 +71,7 @@ char *ibd_ca = NULL;
 int ibd_ca_port = 0;
 int ibd_timeout = 0;
 uint32_t ibd_ibnetdisc_flags = IBND_CONFIG_MLX_EPI;
+int show_keys = 0;
 
 static const char *prog_name;
 static const char *prog_args;
@@ -260,6 +262,9 @@ static int process_opt(int ch, char *optarg)
 				optarg);
 		ibd_sm_id = &sm_portid;
 		break;
+	case 'K':
+		show_keys = 1;
+		break;
 	default:
 		return -1;
 	}
@@ -276,6 +281,7 @@ static const struct ibdiag_opt common_opts[] = {
 	{"Guid", 'G', 0, NULL, "use GUID address argument"},
 	{"timeout", 't', 1, "<ms>", "timeout in ms"},
 	{"sm_port", 's', 1, "<lid>", "SM port lid"},
+	{"show_keys", 'K', 0, NULL, "display security keys in output"},
 	{"errors", 'e', 0, NULL, "show send and receive errors"},
 	{"verbose", 'v', 0, NULL, "increase verbosity level"},
 	{"debug", 'd', 0, NULL, "raise debug level"},
@@ -913,3 +919,68 @@ check_fdr10_active:
 			   IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F) & FDR10) == 0)
 		snprintf(speed_msg, msg_size, "Could be FDR10");
 }
+
+int vsnprint_field(char *buf, size_t n, enum MAD_FIELDS f, int spacing,
+		   const char *format, va_list va_args)
+{
+	int len, i, ret;
+
+	len = strlen(mad_field_name(f));
+        if (len + 2 > n || spacing + 1 > n)
+		return 0;
+
+	strncpy(buf, mad_field_name(f), n);
+	buf[len] = ':';
+	for (i = len+1; i < spacing+1; i++) {
+		buf[i] = '.';
+	}
+
+	ret = vsnprintf(&buf[spacing+1], n - spacing, format, va_args);
+	if (ret >= n - spacing)
+		buf[n] = '\0';
+
+	return ret + spacing;
+}
+
+int snprint_field(char *buf, size_t n, enum MAD_FIELDS f, int spacing,
+		  const char *format, ...)
+{
+	va_list val;
+	int ret;
+
+	va_start(val, format);
+	ret = vsnprint_field(buf, n, f, spacing, format, val);
+	va_end(val);
+
+	return ret;
+}
+
+void dump_portinfo(void *pi, int pisize, int tabs)
+{
+	int field, i;
+	char val[64];
+	char buf[1024];
+
+	for (field = IB_PORT_FIRST_F; field < IB_PORT_LAST_F; field++) {
+		for (i=0;i<tabs;i++)
+			printf("\t");
+		if (field == IB_PORT_MKEY_F && show_keys == 0) {
+			snprint_field(buf, 1024, field, 32, NOT_DISPLAYED_STR);
+		} else {
+			mad_decode_field(pi, field, val);
+			if (!mad_dump_field(field, buf, 1024, val))
+				return;
+		}
+		printf("%s\n", buf);
+	}
+
+	for (field = IB_PORT_CAPMASK2_F;
+	     field < IB_PORT_LINK_SPEED_EXT_LAST_F; field++) {
+		for (i=0;i<tabs;i++)
+			printf("\t");
+		mad_decode_field(pi, field, val);
+		if (!mad_dump_field(field, buf, 1024, val))
+			return;
+		printf("%s\n", buf);
+	}
+}
diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
index a817920..e4a8d65 100644
--- a/src/iblinkinfo.c
+++ b/src/iblinkinfo.c
@@ -619,7 +619,7 @@ int main(int argc, char **argv)
 	};
 	char usage_args[] = "";
 
-	ibdiag_process_opts(argc, argv, &config, "aDdGgLlnpRS", opts,
+	ibdiag_process_opts(argc, argv, &config, "aDdGgKLlnpRS", opts,
 			    process_opt, usage_args, NULL);
 
 	argc -= optind;
diff --git a/src/ibnetdiscover.c b/src/ibnetdiscover.c
index 4748be9..6ed0801 100644
--- a/src/ibnetdiscover.c
+++ b/src/ibnetdiscover.c
@@ -1074,7 +1074,7 @@ int main(int argc, char **argv)
 	};
 	char usage_args[] = "[topology-file]";
 
-	ibdiag_process_opts(argc, argv, &config, "DGLs", opts, process_opt,
+	ibdiag_process_opts(argc, argv, &config, "DGKLs", opts, process_opt,
 			    usage_args, NULL);
 
 	f = stdout;
diff --git a/src/ibping.c b/src/ibping.c
index 205aa82..6d3246c 100644
--- a/src/ibping.c
+++ b/src/ibping.c
@@ -202,7 +202,7 @@ int main(int argc, char **argv)
 	};
 	char usage_args[] = "<dest lid|guid>";
 
-	ibdiag_process_opts(argc, argv, NULL, "D", opts, process_opt,
+	ibdiag_process_opts(argc, argv, NULL, "DK", opts, process_opt,
 			    usage_args, NULL);
 
 	argc -= optind;
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index eb57418..c4ffcf1 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -901,7 +901,7 @@ int main(int argc, char **argv)
 	char usage_args[] = "";
 
 	memset(suppressed_fields, 0, sizeof suppressed_fields);
-	ibdiag_process_opts(argc, argv, &config, "cDGLnRrSs", opts, process_opt,
+	ibdiag_process_opts(argc, argv, &config, "cDGKLnRrSs", opts, process_opt,
 			    usage_args, NULL);
 
 	argc -= optind;
diff --git a/src/ibroute.c b/src/ibroute.c
index faff34d..63baf04 100644
--- a/src/ibroute.c
+++ b/src/ibroute.c
@@ -414,7 +414,7 @@ int main(int argc, char **argv)
 		NULL,
 	};
 
-	ibdiag_process_opts(argc, argv, NULL, NULL, opts, process_opt,
+	ibdiag_process_opts(argc, argv, NULL, "K", opts, process_opt,
 			    usage_args, usage_examples);
 
 	argc -= optind;
diff --git a/src/ibsendtrap.c b/src/ibsendtrap.c
index f98d9cf..98bacf1 100644
--- a/src/ibsendtrap.c
+++ b/src/ibsendtrap.c
@@ -192,7 +192,7 @@ int main(int argc, char **argv)
 	snprintf(usage_args + n, sizeof(usage_args) - n,
 		 "\n  default behavior is to send \"%s\"", traps[0].trap_name);
 
-	ibdiag_process_opts(argc, argv, NULL, "DGL", NULL, NULL,
+	ibdiag_process_opts(argc, argv, NULL, "DGKL", NULL, NULL,
 			    usage_args, NULL);
 
 	argc -= optind;
diff --git a/src/ibstat.c b/src/ibstat.c
index 3d971ed..12d3c20 100644
--- a/src/ibstat.c
+++ b/src/ibstat.c
@@ -292,7 +292,7 @@ int main(int argc, char *argv[])
 		NULL
 	};
 
-	ibdiag_process_opts(argc, argv, NULL, "CDeGLPst", opts, process_opt,
+	ibdiag_process_opts(argc, argv, NULL, "CDeGKLPst", opts, process_opt,
 			    usage_args, usage_examples);
 
 	argc -= optind;
diff --git a/src/ibsysstat.c b/src/ibsysstat.c
index 2b11a06..bac4bb1 100644
--- a/src/ibsysstat.c
+++ b/src/ibsysstat.c
@@ -326,7 +326,7 @@ int main(int argc, char **argv)
 	};
 	char usage_args[] = "<dest lid|guid> [<op>]";
 
-	ibdiag_process_opts(argc, argv, NULL, "D", opts, process_opt,
+	ibdiag_process_opts(argc, argv, NULL, "DK", opts, process_opt,
 			    usage_args, NULL);
 
 	argc -= optind;
diff --git a/src/ibtracert.c b/src/ibtracert.c
index e8fedf3..575d9d0 100644
--- a/src/ibtracert.c
+++ b/src/ibtracert.c
@@ -757,7 +757,7 @@ int main(int argc, char **argv)
 		NULL,
 	};
 
-	ibdiag_process_opts(argc, argv, NULL, "D", opts, process_opt,
+	ibdiag_process_opts(argc, argv, NULL, "DK", opts, process_opt,
 			    usage_args, usage_examples);
 
 	f = stdout;
diff --git a/src/perfquery.c b/src/perfquery.c
index b58ad70..9ca2e15 100644
--- a/src/perfquery.c
+++ b/src/perfquery.c
@@ -710,7 +710,7 @@ int main(int argc, char **argv)
 		NULL,
 	};
 
-	ibdiag_process_opts(argc, argv, NULL, "D", opts, process_opt,
+	ibdiag_process_opts(argc, argv, NULL, "DK", opts, process_opt,
 			    usage_args, usage_examples);
 
 	argc -= optind;
diff --git a/src/saquery.c b/src/saquery.c
index 1e730a4..90feb2d 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -116,20 +116,6 @@ static unsigned valid_gid(ib_gid_t * gid)
 	return memcmp(&zero_gid, gid, sizeof(*gid));
 }
 
-static void format_buf(char *in, char *out, unsigned size)
-{
-	unsigned i;
-
-	for (i = 0; i < size - 3 && *in; i++) {
-		*out++ = *in;
-		if (*in++ == '\n' && *in) {
-			*out++ = '\t';
-			*out++ = '\t';
-		}
-	}
-	*out = '\0';
-}
-
 static void print_node_desc(ib_node_record_t * node_record)
 {
 	ib_node_info_t *p_ni = &(node_record->node_info);
@@ -300,19 +286,17 @@ static void dump_portinfo_record(void *data)
 
 static void dump_one_portinfo_record(void *data)
 {
-	char buf[2300], buf2[4096];
 	ib_portinfo_record_t *pir = data;
 	ib_port_info_t *pi = &pir->port_info;
 
-	mad_dump_portinfo(buf, sizeof(buf), pi, sizeof(*pi));
-	format_buf(buf, buf2, sizeof(buf2));
 	printf("PortInfoRecord dump:\n"
 	       "\tRID:\n"
 	       "\t\tEndPortLid..............%u\n"
 	       "\t\tPortNum.................%u\n"
 	       "\t\tOptions.................0x%x\n"
-	       "\tPortInfo dump:\n\t\t%s",
-	       cl_ntoh16(pir->lid), pir->port_num, pir->options, buf2);
+	       "\tPortInfo dump:\n",
+	       cl_ntoh16(pir->lid), pir->port_num, pir->options);
+	dump_portinfo(pi, sizeof(*pi), 2);
 }
 
 static void dump_one_mcmember_record(void *data)
@@ -471,7 +455,8 @@ static void dump_service_record(void *data)
 	       cl_ntoh64(p_sr->service_id),
 	       inet_ntop(AF_INET6, p_sr->service_gid.raw, gid, sizeof gid),
 	       cl_ntoh16(p_sr->service_pkey), cl_ntoh32(p_sr->service_lease),
-	       buf_service_key, buf_service_name,
+	       (show_keys ? buf_service_key : NOT_DISPLAYED_STR),
+               buf_service_name,
 	       p_sr->service_data8[0], p_sr->service_data8[1],
 	       p_sr->service_data8[2], p_sr->service_data8[3],
 	       p_sr->service_data8[4], p_sr->service_data8[5],
@@ -507,7 +492,7 @@ static void dump_inform_info_record(void *data)
 	ib_inform_info_get_qpn_resp_time(p_iir->inform_info.g_or_v.
 					 generic.qpn_resp_time_val, &qpn,
 					 &resp_time_val);
-	if (p_iir->inform_info.is_generic)
+	if (p_iir->inform_info.is_generic) {
 		printf("InformInfoRecord dump:\n"
 		       "\t\tRID\n"
 		       "\t\tSubscriberGID...........%s\n"
@@ -519,10 +504,7 @@ static void dump_inform_info_record(void *data)
 		       "\t\tis_generic..............0x%X\n"
 		       "\t\tsubscribe...............0x%X\n"
 		       "\t\ttrap_type...............0x%X\n"
-		       "\t\ttrap_num................%u\n"
-		       "\t\tqpn.....................0x%06X\n"
-		       "\t\tresp_time_val...........0x%X\n"
-		       "\t\tnode_type...............0x%06X\n",
+		       "\t\ttrap_num................%u\n",
 		       inet_ntop(AF_INET6, p_iir->subscriber_gid.raw, gid_str,
 				 sizeof gid_str),
 		       cl_ntoh16(p_iir->subscriber_enum),
@@ -533,11 +515,20 @@ static void dump_inform_info_record(void *data)
 		       p_iir->inform_info.is_generic,
 		       p_iir->inform_info.subscribe,
 		       cl_ntoh16(p_iir->inform_info.trap_type),
-		       cl_ntoh16(p_iir->inform_info.g_or_v.generic.trap_num),
-		       cl_ntoh32(qpn), resp_time_val,
+		       cl_ntoh16(p_iir->inform_info.g_or_v.generic.trap_num));
+		if (show_keys) {
+			printf("\t\tqpn.....................0x%06X\n",
+			       cl_ntoh32(qpn));
+		} else {
+			printf("\t\tqpn....................."
+			       NOT_DISPLAYED_STR "\n");
+		}
+		printf("\t\tresp_time_val...........0x%X\n"
+		       "\t\tnode_type...............0x%06X\n",
+		       resp_time_val,
 		       cl_ntoh32(ib_inform_info_get_prod_type
 				 (&p_iir->inform_info)));
-	else
+	} else {
 		printf("InformInfoRecord dump:\n"
 		       "\t\tRID\n"
 		       "\t\tSubscriberGID...........%s\n"
@@ -549,10 +540,7 @@ static void dump_inform_info_record(void *data)
 		       "\t\tis_generic..............0x%X\n"
 		       "\t\tsubscribe...............0x%X\n"
 		       "\t\ttrap_type...............0x%X\n"
-		       "\t\tdev_id..................0x%X\n"
-		       "\t\tqpn.....................0x%06X\n"
-		       "\t\tresp_time_val...........0x%X\n"
-		       "\t\tvendor_id...............0x%06X\n",
+		       "\t\tdev_id..................0x%X\n",
 		       inet_ntop(AF_INET6, p_iir->subscriber_gid.raw, gid_str,
 				 sizeof gid_str),
 		       cl_ntoh16(p_iir->subscriber_enum),
@@ -563,10 +551,20 @@ static void dump_inform_info_record(void *data)
 		       p_iir->inform_info.is_generic,
 		       p_iir->inform_info.subscribe,
 		       cl_ntoh16(p_iir->inform_info.trap_type),
-		       cl_ntoh16(p_iir->inform_info.g_or_v.vend.dev_id),
-		       cl_ntoh32(qpn), resp_time_val,
+		       cl_ntoh16(p_iir->inform_info.g_or_v.vend.dev_id));
+		if (show_keys) {
+			printf("\t\tqpn.....................0x%06X\n",
+			       cl_ntoh32(qpn));
+		} else {
+			printf("\t\tqpn....................."
+			       NOT_DISPLAYED_STR "\n");
+		}
+		printf("\t\tresp_time_val...........0x%X\n"
+		       "\t\tvendor_id...............0x%06X\n",
+		       resp_time_val,
 		       cl_ntoh32(ib_inform_info_get_prod_type
 				 (&p_iir->inform_info)));
+	}
 }
 
 static void dump_one_link_record(void *data)
diff --git a/src/sminfo.c b/src/sminfo.c
index f1abc6a..1c12204 100644
--- a/src/sminfo.c
+++ b/src/sminfo.c
@@ -109,7 +109,7 @@ int main(int argc, char **argv)
 	};
 	char usage_args[] = "<sm_lid|sm_dr_path> [modifier]";
 
-	ibdiag_process_opts(argc, argv, NULL, "s", opts, process_opt,
+	ibdiag_process_opts(argc, argv, NULL, "sK", opts, process_opt,
 			    usage_args, NULL);
 
 	argc -= optind;
diff --git a/src/smpdump.c b/src/smpdump.c
index 1e79c52..4d67be7 100644
--- a/src/smpdump.c
+++ b/src/smpdump.c
@@ -231,7 +231,7 @@ int main(int argc, char *argv[])
 
 	ibd_timeout = 1000;
 
-	ibdiag_process_opts(argc, argv, NULL, "Gs", opts, process_opt,
+	ibdiag_process_opts(argc, argv, NULL, "GKs", opts, process_opt,
 			    usage_args, usage_examples);
 
 	argc -= optind;
diff --git a/src/smpquery.c b/src/smpquery.c
index 533b2c3..2909dc5 100644
--- a/src/smpquery.c
+++ b/src/smpquery.c
@@ -133,7 +133,6 @@ static char *node_info(ib_portid_t * dest, char **argv, int argc)
 
 static char *port_info(ib_portid_t * dest, char **argv, int argc)
 {
-	char buf[2300];
 	char data[IB_SMP_DATA_SIZE] = { 0 };
 	int portnum = 0, orig_portnum;
 
@@ -146,9 +145,8 @@ static char *port_info(ib_portid_t * dest, char **argv, int argc)
 	if (!smp_query_via(data, dest, IB_ATTR_PORT_INFO, portnum, 0, srcport))
 		return "port info query failed";
 
-	mad_dump_portinfo(buf, sizeof buf, data, sizeof data);
-
-	printf("# Port info: %s port %d\n%s", portid2str(dest), orig_portnum, buf);
+	printf("# Port info: %s port %d\n", portid2str(dest), orig_portnum);
+	dump_portinfo(data, sizeof data, 0);
 	return 0;
 }
 
diff --git a/src/vendstat.c b/src/vendstat.c
index 78f6d7d..dd89da7 100644
--- a/src/vendstat.c
+++ b/src/vendstat.c
@@ -332,7 +332,7 @@ int main(int argc, char **argv)
 		NULL
 	};
 
-	ibdiag_process_opts(argc, argv, NULL, "D", opts, process_opt,
+	ibdiag_process_opts(argc, argv, NULL, "DK", opts, process_opt,
 			    usage_args, usage_examples);
 
 	argc -= optind;
-- 
1.7.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
