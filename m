From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC 12/12] ib-mgmt/diags: add utility to display snooped mads
Date: Sat, 23 Oct 2010 00:17:16 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B7FC@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B7EE@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B7EE-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Port the kernel madeye utility to user space.  Use the
new MAD snooping ability exported from the kernel to
view captured MADs and display them.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 infiniband-diags/Makefile.am              |    6
 infiniband-diags/configure.in             |    3
 infiniband-diags/infiniband-diags.spec.in |    1
 infiniband-diags/man/madeye.8             |   23 +
 infiniband-diags/src/madeye.c             |  582 +++++++++++++++++++++++++++++
 5 files changed, 613 insertions(+), 2 deletions(-)
 create mode 100644 infiniband-diags/man/madeye.8
 create mode 100755 infiniband-diags/src/madeye.c

diff --git a/infiniband-diags/Makefile.am b/infiniband-diags/Makefile.am
index af90b05..e0a55ef 100644
--- a/infiniband-diags/Makefile.am
+++ b/infiniband-diags/Makefile.am
@@ -13,7 +13,7 @@ sbin_PROGRAMS = src/ibaddr src/ibnetdiscover src/ibping src/ibportstate \
                src/ibroute src/ibstat src/ibsysstat src/ibtracert \
                src/perfquery src/sminfo src/smpdump src/smpquery \
                src/saquery src/vendstat src/iblinkinfo \
-               src/ibqueryerrors src/ibcacheedit
+               src/ibqueryerrors src/ibcacheedit src/madeye

 if ENABLE_TEST_UTILS
 sbin_PROGRAMS += src/ibsendtrap src/mcm_rereg_test
@@ -55,6 +55,8 @@ src_sminfo_SOURCES = src/sminfo.c
 src_smpdump_SOURCES = src/smpdump.c
 src_smpquery_SOURCES = src/smpquery.c
 src_saquery_SOURCES = src/saquery.c
+src_madeye_SOURCES = src/madeye.c
+src_madeye_LDFLAGS = -libumad
 src_ibsendtrap_SOURCES = src/ibsendtrap.c
 src_vendstat_SOURCES = src/vendstat.c
 src_mcm_rereg_test_SOURCES = src/mcm_rereg_test.c
@@ -78,7 +80,7 @@ man_MANS = man/ibaddr.8 man/ibcheckerrors.8 man/ibcheckerrs.8 \
        man/ibprintswitch.8 man/ibprintca.8 man/ibfindnodesusing.8 \
        man/ibdatacounts.8 man/ibdatacounters.8 \
        man/ibrouters.8 man/ibprintrt.8 man/ibidsverify.8 \
-       man/check_lft_balance.8 man/ibcacheedit.8
+       man/check_lft_balance.8 man/ibcacheedit.8 man/madeye.8

 BUILT_SOURCES = ibdiag_version
 ibdiag_version:
diff --git a/infiniband-diags/configure.in b/infiniband-diags/configure.in
index b9326c0..e01b5a8 100644
--- a/infiniband-diags/configure.in
+++ b/infiniband-diags/configure.in
@@ -50,6 +50,9 @@ then
 AC_CHECK_HEADER(infiniband/umad.h, [],
        AC_MSG_ERROR([<infiniband/umad.h> not found. diags require libibumad.])
 )
+AC_CHECK_HEADER(infiniband/umad_types.h, [],
+       AC_MSG_ERROR([<infiniband/umad_types.h> not found. diags require more recent libibumad.])
+)
 AC_CHECK_HEADER(infiniband/mad.h, [],
        AC_MSG_ERROR([<infiniband/mad.h> not found. diags require libibmad.])
 )
diff --git a/infiniband-diags/infiniband-diags.spec.in b/infiniband-diags/infiniband-diags.spec.in
index c50ce09..64cc645 100644
--- a/infiniband-diags/infiniband-diags.spec.in
+++ b/infiniband-diags/infiniband-diags.spec.in
@@ -47,6 +47,7 @@ rm -rf $RPM_BUILD_ROOT
 %{_sbindir}/check_lft_balance.pl
 %{_sbindir}/set_nodedesc.sh
 %{_sbindir}/sm*
+%{_sbindir}/madeye
 %{_libdir}/*.a
 %{_libdir}/*.so*
 %{_includedir}/infiniband/*.h
diff --git a/infiniband-diags/man/madeye.8 b/infiniband-diags/man/madeye.8
new file mode 100644
index 0000000..ec26da2
--- /dev/null
+++ b/infiniband-diags/man/madeye.8
@@ -0,0 +1,23 @@
+.TH MADEYE 8 "October 22, 2010" "OpenIB" "OpenIB Diagnostics"
+
+.SH NAME
+madeye \- capture and display captured IB MAD traffic
+
+.SH SYNOPSIS
+.B madeye
+[\-C, \-\-Ca=<ca_name>] [\-P, \-\-Port=<port_number>]
+[\-c, \-\-class=<management_class>] [\-n, \-\-class_version=<class_version>]
+[\-a, \-\-attr=<attribute_id>]
+[\-e, \-\-errors] [\-o, \-\-oui=<oui>] [\-h, \-\-help]
+[\-v, \-\-verbose]
+
+.SH DESCRIPTION
+.PP
+Madeye registers with the kernel to capture specified sent and
+received MADs.  Captured MADs are displayed in a human readable
+format.
+
+.SH AUTHOR
+.TP
+Sean Hefty
+.RI < sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org >
diff --git a/infiniband-diags/src/madeye.c b/infiniband-diags/src/madeye.c
new file mode 100755
index 0000000..684ede4
--- /dev/null
+++ b/infiniband-diags/src/madeye.c
@@ -0,0 +1,582 @@
+/*
+ * Copyright (c) 2004, 2005, 2010 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2005 Voltaire Inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directorY of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#if HAVE_CONFIG_H
+#  include <config.h>
+#endif /* HAVE_CONFIG_H */
+
+#include <stdio.h>
+#include <getopt.h>
+#include <string.h>
+
+#include <infiniband/umad.h>
+#include <infiniband/umad_sa.h>
+#include <infiniband/umad_sm.h>
+#include <infiniband/umad_cm.h>
+
+struct mad_info {
+       ib_user_mad_t   user_mad;
+       char            data[256];
+};
+
+static char *ca;
+static uint8_t port;
+static umad_filter_t filter;
+static int verbose;
+
+static char * get_class_name(uint8_t mgmt_class)
+{
+       switch(mgmt_class) {
+       case UMAD_CLASS_SUBN_LID_ROUTED:
+               return "LID routed SMP";
+       case UMAD_CLASS_SUBN_DIRECTED_ROUTE:
+               return "Directed route SMP";
+       case UMAD_CLASS_SUBN_ADM:
+               return "Subnet admin.";
+       case UMAD_CLASS_PERF_MGMT:
+               return "Perf. mgmt.";
+       case UMAD_CLASS_BM:
+               return "Baseboard mgmt.";
+       case UMAD_CLASS_DEVICE_MGMT:
+               return "Device mgmt.";
+       case UMAD_CLASS_CM:
+               return "Comm. mgmt.";
+       case UMAD_CLASS_SNMP:
+               return "SNMP";
+       default:
+               return "Unknown vendor/application";
+       }
+}
+
+static char * get_method_name(uint8_t mgmt_class, uint8_t method)
+{
+       switch(method) {
+       case UMAD_METHOD_GET:
+               return "Get";
+       case UMAD_METHOD_SET:
+               return "Set";
+       case UMAD_METHOD_GET_RESP:
+               return "Get response";
+       case UMAD_METHOD_SEND:
+               return "Send";
+       case UMAD_METHOD_TRAP:
+               return "Trap";
+       case UMAD_METHOD_REPORT:
+               return "Report";
+       case UMAD_METHOD_REPORT_RESP:
+               return "Report response";
+       case UMAD_METHOD_TRAP_REPRESS:
+               return "Trap repress";
+       default:
+               break;
+       }
+
+       switch (mgmt_class) {
+       case UMAD_CLASS_SUBN_ADM:
+               switch (method) {
+               case UMAD_SA_METHOD_GET_TABLE:
+                       return "Get table";
+               case UMAD_SA_METHOD_GET_TABLE_RESP:
+                       return "Get table response";
+               case UMAD_SA_METHOD_DELETE:
+                       return "Delete";
+               case UMAD_SA_METHOD_DELETE_RESP:
+                       return "Delete response";
+               case UMAD_SA_METHOD_GET_MULTI:
+                       return "Get Multi";
+               case UMAD_SA_METHOD_GET_MULTI_RESP:
+                       return "Get Multi response";
+               case UMAD_SA_METHOD_GET_TRACE_TABLE:
+                       return "Get Trace Table response";
+               default:
+                       break;
+               }
+       default:
+               break;
+       }
+
+       return "Unknown";
+}
+
+static void print_status_details(uint16_t status)
+{
+       if (status & 0x0001)
+               printf("               busy\n");
+       if (status & 0x0002)
+               printf("               redirection required\n");
+       switch((status & 0x001C) >> 2) {
+       case 1:
+               printf("               bad version\n");
+               break;
+       case 2:
+               printf("               method not supported\n");
+               break;
+       case 3:
+               printf("               method/attribute combo not supported\n");
+               break;
+       case 7:
+               printf("               invalid attribute/modifier value\n");
+               break;
+       }
+}
+
+static char * get_sa_attr(uint16_t attr)
+{
+       switch(attr) {
+       case UMAD_ATTR_CLASS_PORT_INFO:
+               return "Class Port Info";
+       case UMAD_ATTR_NOTICE:
+               return "Notice";
+       case UMAD_ATTR_INFORM_INFO:
+               return "Inform Info";
+       case UMAD_SA_ATTR_NODE_REC:
+               return "Node Record";
+       case UMAD_SA_ATTR_PORT_INFO_REC:
+               return "PortInfo Record";
+       case UMAD_SA_ATTR_SLVL_REC:
+               return "SL to VL Record";
+       case UMAD_SA_ATTR_SWITCH_INFO_REC:
+               return "Switch Record";
+       case UMAD_SA_ATTR_LINEAR_FT_REC:
+               return "Linear FDB Record";
+       case UMAD_SA_ATTR_RANDOM_FT_REC:
+               return "Random FDB Record";
+       case UMAD_SA_ATTR_MCAST_FT_REC:
+               return "Multicast FDB Record";
+       case UMAD_SA_ATTR_SM_INFO_REC:
+               return "SM Info Record";
+       case UMAD_SA_ATTR_INFORM_INFO_REC:
+               return "Inform Info Record";
+       case UMAD_SA_ATTR_LINK_REC:
+               return "Link Record";
+       case UMAD_SA_ATTR_GUID_INFO_REC:
+               return "Guid Info Record";
+       case UMAD_SA_ATTR_SERVICE_REC:
+               return "Service Record";
+       case UMAD_SA_ATTR_PKEY_TABLE_REC:
+               return "Partition Record";
+       case UMAD_SA_ATTR_PATH_REC:
+               return "Path Record";
+       case UMAD_SA_ATTR_VL_ARB_REC:
+               return "VL Arb Record";
+       case UMAD_SA_ATTR_MCMEMBER_REC:
+               return "MC Member Record";
+       case UMAD_SA_ATTR_TRACE_REC:
+               return "Trace Record";
+       case UMAD_SA_ATTR_MULTI_PATH_REC:
+               return "Multi Path Record";
+       case UMAD_SA_ATTR_SERVICE_ASSOC_REC:
+               return "Service Assoc Record";
+       default:
+               return "";
+       }
+}
+
+static char * get_cm_attr(uint16_t attr)
+{
+       switch(attr) {
+       case UMAD_CM_ATTR_REQ:
+               return "REQ";
+       case UMAD_CM_ATTR_MRA:
+               return "MRA";
+       case UMAD_CM_ATTR_REJ:
+               return "REJ";
+       case UMAD_CM_ATTR_REP:
+               return "REP";
+       case UMAD_CM_ATTR_RTU:
+               return "RTU";
+       case UMAD_CM_ATTR_DREQ:
+               return "DREQ";
+       case UMAD_CM_ATTR_DREP:
+               return "DREP";
+       case UMAD_CM_ATTR_SIDR_REQ:
+               return "SIDR REQ";
+       case UMAD_CM_ATTR_SIDR_REP:
+               return "SIDR REP";
+       case UMAD_CM_ATTR_LAP:
+               return "LAP";
+       case UMAD_CM_ATTR_APR:
+               return "APR";
+       default:
+               return "unknown";
+       }
+}
+
+static void print_mad_hdr(struct umad_hdr *hdr)
+{
+       printf("MAD version....0x%01x\n", hdr->base_version);
+       printf("Class..........0x%01x (%s)\n", hdr->mgmt_class,
+              get_class_name(hdr->mgmt_class));
+       printf("Class version..0x%01x\n", hdr->class_version);
+       printf("Method.........0x%01x (%s)\n", hdr->method,
+              get_method_name(hdr->mgmt_class, hdr->method));
+       printf("Status.........0x%02x\n", ntohs(hdr->status));
+       if (hdr->status)
+               print_status_details(ntohs(hdr->status));
+       printf("Class specific.0x%02x\n", ntohs(hdr->class_specific));
+       printf("Trans ID.......0x%llx\n", (unsigned long long) ntohll(hdr->tid));
+       printf("Attr ID........0x%02x", ntohs(hdr->attr_id));
+       switch (hdr->mgmt_class) {
+       case UMAD_CLASS_SUBN_ADM:
+               printf(" (%s)", get_sa_attr(ntohs(hdr->attr_id)));
+               break;
+       case UMAD_CLASS_CM:
+               printf(" (%s)", get_cm_attr(ntohs(hdr->attr_id)));
+               break;
+       default:
+               break;
+       }
+       printf("\n");
+       printf("Attr modifier..0x%04x\n", ntohl(hdr->attr_mod));
+}
+
+static char * get_rmpp_type(uint8_t rmpp_type)
+{
+       switch (rmpp_type) {
+       case UMAD_RMPP_TYPE_DATA:
+               return "Data";
+       case UMAD_RMPP_TYPE_ACK:
+               return "Ack";
+       case UMAD_RMPP_TYPE_STOP:
+               return "Stop";
+       case UMAD_RMPP_TYPE_ABORT:
+               return "Abort";
+       default:
+               return "Unknown";
+       }
+}
+
+static char * get_rmpp_flags(uint8_t rmpp_flags)
+{
+       if (rmpp_flags & UMAD_RMPP_FLAG_ACTIVE)
+               if (rmpp_flags & UMAD_RMPP_FLAG_FIRST)
+                       if (rmpp_flags & UMAD_RMPP_FLAG_LAST)
+                               return "Active - First & Last";
+                       else
+                               return "Active - First";
+               else
+                       if (rmpp_flags & UMAD_RMPP_FLAG_LAST)
+                               return "Active - Last";
+                       else
+                               return "Active";
+       else
+               return "Inactive";
+}
+
+static void print_rmpp_hdr(struct umad_rmpp_hdr *rmpp_hdr)
+{
+       printf("RMPP version...0x%01x\n", rmpp_hdr->rmpp_version);
+       printf("RMPP type......0x%01x (%s)\n", rmpp_hdr->rmpp_type,
+              get_rmpp_type(rmpp_hdr->rmpp_type));
+       printf("RMPP RRespTime.0x%01x\n",
+              rmpp_hdr->rmpp_rtime_flags >> UMAD_RMPP_RESP_TIME_SHIFT);
+       printf("RMPP flags.....0x%01x (%s)\n",
+              rmpp_hdr->rmpp_rtime_flags & UMAD_RMPP_FLAG_MASK,
+              get_rmpp_flags(rmpp_hdr->rmpp_rtime_flags & UMAD_RMPP_FLAG_MASK));
+       printf("RMPP status....0x%01x\n", rmpp_hdr->rmpp_status);
+       printf("Seg number.....0x%04x\n", ntohl(rmpp_hdr->seg_num));
+       switch (rmpp_hdr->rmpp_type) {
+       case UMAD_RMPP_TYPE_DATA:
+               printf("Payload len....0x%04x\n",
+                      ntohl(rmpp_hdr->paylen_newwin));
+               break;
+       case UMAD_RMPP_TYPE_ACK:
+               printf("New window.....0x%04x\n",
+                      ntohl(rmpp_hdr->paylen_newwin));
+               break;
+       default:
+               printf("Data 2.........0x%04x\n",
+                      ntohl(rmpp_hdr->paylen_newwin));
+               break;
+       }
+}
+
+static char * get_smp_attr(uint16_t attr)
+{
+       switch (attr) {
+       case UMAD_ATTR_NOTICE:
+               return "notice";
+       case UMAD_SMP_ATTR_NODE_DESC:
+               return "node description";
+       case UMAD_SMP_ATTR_NODE_INFO:
+               return "node info";
+       case UMAD_SMP_ATTR_SWITCH_INFO:
+               return "switch info";
+       case UMAD_SMP_ATTR_GUID_INFO:
+               return "GUID info";
+       case UMAD_SMP_ATTR_PORT_INFO:
+               return "port info";
+       case UMAD_SMP_ATTR_PKEY_TABLE:
+               return "pkey table";
+       case UMAD_SMP_ATTR_SLVL_TABLE:
+               return "SL to VL table";
+       case UMAD_SMP_ATTR_VL_ARB_TABLE:
+               return "VL arbitration table";
+       case UMAD_SMP_ATTR_LINEAR_FT:
+               return "linear forwarding table";
+       case UMAD_SMP_ATTR_RANDOM_FT:
+               return "random forward table";
+       case UMAD_SMP_ATTR_MCAST_FT:
+               return "multicast forward table";
+       case UMAD_SMP_ATTR_SM_INFO:
+               return "SM info";
+       case UMAD_SMP_ATTR_VENDOR_DIAG:
+               return "vendor diags";
+       case UMAD_SMP_ATTR_LED_INFO:
+               return "LED info";
+       default:
+               return "Unknown";
+       }
+}
+
+static void print_data(char *msg, uint8_t *data, int size)
+{
+       int i;
+
+       for (i = 0; i < size; i++) {
+               if (i % 16 == 0)
+                       printf("%s", msg);
+               printf("%.2x ", data[i]);
+               if ((i < size - 1) && (i % 16 == 15))
+                       printf("\n");
+       }
+       printf("\n");
+}
+
+static void print_smp(struct umad_smp *smp)
+{
+       printf("MAD version....0x%01x\n", smp->base_version);
+       printf("Class..........0x%01x (%s)\n", smp->mgmt_class,
+              get_class_name(smp->mgmt_class));
+       printf("Class version..0x%01x\n", smp->class_version);
+       printf("Method.........0x%01x (%s)\n", smp->method,
+              get_method_name(smp->mgmt_class, smp->method));
+       printf("Status.........0x%02x\n", ntohs(smp->status));
+       if (smp->status)
+               print_status_details(ntohs(smp->status));
+       printf("Hop pointer...0x%01x\n", smp->hop_ptr);
+       printf("Hop counter...0x%01x\n", smp->hop_cnt);
+       printf("Trans ID.......0x%llx\n", (unsigned long long) ntohll(smp->tid));
+       printf("Attr ID........0x%02x (%s)\n", ntohs(smp->attr_id),
+               get_smp_attr(ntohs(smp->attr_id)));
+       printf("Attr modifier..0x%04x\n", ntohl(smp->attr_mod));
+
+       printf("Mkey...........0x%llx\n",
+              (unsigned long long) ntohll(*(uint64_t *) smp->mkey));
+       printf("DR SLID........0x%02x\n", ntohs(smp->dr_slid));
+       printf("DR DLID........0x%02x\n", ntohs(smp->dr_dlid));
+
+       if (verbose) {
+               print_data("SMP data.......", smp->data, UMAD_LEN_SMP_DATA);
+               print_data("Initial path...", smp->initial_path,
+                          UMAD_SMP_MAX_HOPS);
+               print_data("Return path....", smp->return_path,
+                          UMAD_SMP_MAX_HOPS);
+       }
+}
+
+static void print_sa_hdr(struct umad_sa_packet *mad)
+{
+       printf("SM key.........0x%llx\n",
+              (unsigned long long) ntohll(*(uint64_t *) mad->sm_key));
+       printf("Attr offset....0x%02x\n", ntohs(mad->attr_offset));
+       printf("Comp mask......0x%llx\n",
+              (unsigned long long) ntohll(mad->comp_mask));
+}
+
+static int is_rmpp_mad(uint8_t mgmt_class)
+{
+       return ((mgmt_class == UMAD_CLASS_SUBN_ADM) ||
+               ((mgmt_class >= UMAD_CLASS_VENDOR_RANGE2_START) &&
+                (mgmt_class <= UMAD_CLASS_VENDOR_RANGE2_END)) ||
+               (mgmt_class == UMAD_CLASS_DEVICE_MGMT) ||
+               (mgmt_class == UMAD_CLASS_DEVICE_ADM) ||
+               (mgmt_class == UMAD_CLASS_BIS));
+}
+
+static void print_gmp(struct umad_hdr *hdr)
+{
+       print_mad_hdr(hdr);
+
+       if (is_rmpp_mad(hdr->mgmt_class))
+               print_rmpp_hdr(&((struct umad_rmpp_packet *) hdr)->rmpp_hdr);
+
+       if (!verbose)
+               return;
+
+       if (hdr->mgmt_class == UMAD_CLASS_SUBN_ADM) {
+               struct umad_sa_packet *sa_mad = (struct umad_sa_packet *) hdr;
+               print_sa_hdr(sa_mad);
+               print_data("SA data........", sa_mad->data,
+                          UMAD_LEN_SA_DATA);
+       } else if ((hdr->mgmt_class >= UMAD_CLASS_VENDOR_RANGE2_START) &&
+                  (hdr->mgmt_class <= UMAD_CLASS_VENDOR_RANGE2_END)) {
+               struct umad_vendor_packet *vendor_mad = (struct umad_vendor_packet *) hdr;
+               printf("Vendor OUI......%01x %01x %01x\n",
+                       vendor_mad->oui[0],
+                       vendor_mad->oui[1],
+                       vendor_mad->oui[2]);
+               print_data("Vendor data....", vendor_mad->data,
+                          UMAD_LEN_VENDOR_DATA);
+       } else if (is_rmpp_mad(hdr->mgmt_class)) {
+               print_data("RMPP data....", ((struct umad_rmpp_packet *) hdr)->data,
+                          UMAD_LEN_RMPP_DATA);
+       } else {
+               print_data("MAD data.......", ((struct umad_packet *) hdr)->data, UMAD_LEN_DATA);
+       }
+}
+
+static void print_mad(struct mad_info *umad)
+{
+       struct umad_hdr *hdr;
+
+       umad_addr_dump(&umad->user_mad.addr);
+       hdr = (struct umad_hdr *) umad->data;
+
+       if (hdr->mgmt_class == UMAD_CLASS_SUBN_LID_ROUTED ||
+           hdr->mgmt_class == UMAD_CLASS_SUBN_DIRECTED_ROUTE)
+               print_smp((struct umad_smp *) hdr);
+       else
+               print_gmp(hdr);
+}
+
+static int run(void)
+{
+       int port_id, agent;
+       struct mad_info umad;
+       int ret, len;
+
+       port_id = umad_open_port(ca, port);
+       if (port_id < 0) {
+               printf("umad_open_port %s\n", strerror(-port_id));
+               return 1;
+       }
+
+       agent = umad_register_snoop(port_id, &filter, sizeof filter);
+       if (agent < 0) {
+               printf("umad_register_snoop %s\n", strerror(-agent));
+               ret = -agent;
+               goto close;
+       }
+
+       while (1) {
+               len = sizeof umad;
+               ret = umad_recv(port_id, &umad, &len, -1);
+               if (ret < 0) {
+                       printf("umad_recv %s\n", strerror(-ret));
+                       break;
+               }
+
+               print_mad(&umad);
+       }
+
+       umad_unregister(port_id, agent);
+close:
+       umad_close_port(port_id);
+       return ret;
+}
+
+static void show_usage(char *name)
+{
+       printf("Usage: %s        capture and display IB MAD traffic\n\n", name);
+       printf("Options:\n");
+       printf("  -C, --Ca=<ca_name>\n");
+       printf("  -P, --Port=<port_number>\n");
+       printf("  -c, --class=<management_class>\n");
+       printf("  -n, --class_version=<class_version>\n");
+       printf("  -a, --attr=<attribute_id>\n");
+       printf("  -e, --errors        (capture only MADs which complete in error)\n");
+       printf("  -o, --oui=<oui>\n");
+       printf("  -h, --help\n");
+       printf("  -v, --verbose       (display MAD data)\n");
+}
+
+int main(int argc, char *argv[])
+{
+       int val;
+
+       while (1) {
+               int c;
+               static struct option long_options[] = {
+                       {.name = "Ca",      .has_arg = 1, .val = 'C'},
+                       {.name = "Port",    .has_arg = 1, .val = 'P'},
+                       {.name = "class",   .has_arg = 1, .val = 'c'},
+                       {.name = "class_version", .has_arg = 1, .val = 'n'},
+                       {.name = "attr",    .has_arg = 1, .val = 'a'},
+                       {.name = "errors",  .has_arg = 0, .val = 'e'},
+                       {.name = "oui",     .has_arg = 1, .val = 'o'},
+                       {.name = "help",    .has_arg = 0, .val = 'h'},
+                       {.name = "verbose", .has_arg = 0, .val = 'v'},
+                       {0, 0, 0, 0}
+               };
+
+               c = getopt_long(argc, argv, "C:P:c:n:a:eo:hv", long_options, NULL);
+               if (c == -1)
+                       break;
+
+               switch (c) {
+               case 'C':
+                       ca = optarg;
+                       break;
+               case 'P':
+                       port = (uint8_t) strtoul(optarg, 0, 0);
+                       break;
+               case 'c':
+                       filter.mgmt_class = (uint8_t) strtoul(optarg, 0, 0);
+                       break;
+               case 'n':
+                       filter.mgmt_version = (uint8_t) strtoul(optarg, 0, 0);
+                       break;
+               case 'a':
+                       filter.attr_id = (uint16_t) strtoul(optarg, 0, 0);
+                       break;
+               case 'e':
+                       filter.errors = 1;
+               case 'o':
+                       val = strtoul(optarg, 0, 0);
+                       filter.oui[0] = (uint8_t) (val >> 16);
+                       filter.oui[1] = (uint8_t) (val >> 8);
+                       filter.oui[2] = (uint8_t) val;
+                       break;
+               case 'v':
+                       verbose = 1;
+                       break;
+               default:
+                       show_usage(argv[0]);
+                       exit(1);
+               }
+       }
+
+       val = run();
+       return val;
+}


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
