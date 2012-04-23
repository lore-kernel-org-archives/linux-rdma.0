From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/15] uDAPL v2.0 commom: add cm, link, and diag event
 counters in IB extended builds
Date: Mon, 23 Apr 2012 20:01:05 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F948120284@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add additional event monitoring capabilities during runtime to help
isolate issues during scaling in lieu of logging/printing warning
messages. Counters have been added to provider CM services and counters
have been added and mapped to sysfs ib_cm, device port and device
diag counters. ibdev_path is used for device sysfs counters.

uDAPL CM events are tracked on a per IA instance via internal
provider counters. The ib_cm, link, and diag events are tracked on a
per platform basis via sysfs. For these running counters a start
and stop function is provided for sampling and mapping to DAPL
64 bit counters. All counters, along with new start and stop functions,
are provided via dat_ib_extensions.h. New IB extension version is 2.0.7

New DCNT_IA_xx counters include 40 cm, 9 link, and 9 diag types.

To enable new counters (default build is disabled):
	./configure --enable-counters

New bitmappings have been added to DAPL_DBG_TYPE environment
variable to automatically start/stop counters and log
errors if counters are enabled. The following will control
CM, LINK, and DIAG respectively:

   DAPL_DBG_TYPE_CM_ERRS	= 0x080000,
   DAPL_DBG_TYPE_LINK_ERRS	= 0x100000,
   DAPL_DBG_TYPE_DIAG_ERRS	= 0x400000,

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am                          |    3 +
 configure.in                         |   11 +
 dapl/common/dapl_debug.c             |  431 +++++++++++++++++++++++++++++++++-
 dapl/common/dapl_ia_open.c           |    4 +
 dapl/common/dapl_ia_util.c           |   12 +-
 dapl/include/dapl_debug.h            |   13 +-
 dapl/openib_common/dapl_ib_common.h  |    2 +-
 dapl/openib_common/ib_extensions.c   |   26 ++
 dapl/udapl/linux/dapl_osd.h          |   16 ++
 dat/include/dat2/dat_ib_extensions.h |   95 ++++++++-
 10 files changed, 601 insertions(+), 12 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index a9bdeda..edff7f8 100755
--- a/Makefile.am
+++ b/Makefile.am
@@ -20,6 +20,9 @@ XFLAGS = -DDAT_EXTENSIONS
 XPROGRAMS = dapl/openib_common/ib_extensions.c
 XHEADERS =
 XLIBS =
+if DEFINE_COUNTERS
+XFLAGS += -DDAPL_COUNTERS
+endif
 if COLL_TYPE_FCA
 XFLAGS += -DDAT_IB_COLLECTIVES -DDAT_FCA_PROVIDER
 XPROGRAMS += dapl/openib_common/collectives/fca_provider.c
diff --git a/configure.in b/configure.in
index 71da96c..d577525 100644
--- a/configure.in
+++ b/configure.in
@@ -104,6 +104,17 @@ AC_ARG_ENABLE([ucm],
   [ucm=true])
 AM_CONDITIONAL(DEFINE_UCM, test x$ucm = xtrue)
 
+dnl Support to enable/disable IB extended counters (CM,LINK,DIAG)
+AC_ARG_ENABLE([counters], 
+  AS_HELP_STRING([--enable-counters],[enable counters provider build, default=disabled]),
+  [case "${enableval}" in
+    yes) counters=true ;;
+    no)  counters=false ;;
+    *) AC_MSG_ERROR(bad value ${enableval} for --enable-counters) ;; 
+  esac],
+  [counters=false])
+AM_CONDITIONAL(DEFINE_COUNTERS, test x$counters = xtrue)
+
 dnl Support ib_extension build - if enable-ext-type == ib 
 AC_ARG_ENABLE(ext-type,
 [  --enable-ext-type Enable extensions support for library: ib, none, default=ib],
diff --git a/dapl/common/dapl_debug.c b/dapl/common/dapl_debug.c
index 7a0a199..cb45496 100644
--- a/dapl/common/dapl_debug.c
+++ b/dapl/common/dapl_debug.c
@@ -74,6 +74,328 @@ void dapl_internal_dbg_log(DAPL_DBG_TYPE type, const char *fmt, ...)
 
 #ifdef DAPL_COUNTERS
 
+static int rd_ctr(const char *dev,
+		  const char *file,
+		  int port,
+		  DAT_IA_COUNTER_TYPE type,
+		  DAT_UINT64 *value)
+{
+	char *f_path;
+	int len, fd;
+	char vstr[21];
+	char pstr[2];
+
+	sprintf(pstr, "%d", port);
+	*value = 0;
+
+	switch (type) {
+	case DCNT_IA_CM:
+		if (asprintf(&f_path, "/sys/class/infiniband_cm/%s/%s/%s", dev, pstr, file) < 0)
+			return -1;
+		break;
+	case DCNT_IA_LNK:
+		if (asprintf(&f_path, "%s/ports/%s/counters/%s", dev, pstr, file) < 0)
+			return -1;
+		break;
+	case DCNT_IA_DIAG:
+		if (asprintf(&f_path, "%s/diag_counters/%s", dev, file) < 0)
+			return -1;
+		break;
+	default:
+		return -1;
+	}
+
+	fd = open(f_path, O_RDONLY);
+	if (fd < 0) {
+		free(f_path);
+		return -1;
+	}
+
+	len = read(fd, vstr, 21);
+
+	if (len > 0 && vstr[--len] == '\n')
+		vstr[len] = '\0';
+
+	*value = (DAT_UINT64)atoi(vstr);
+
+	close(fd);
+	free(f_path);
+	return 0;
+}
+
+#ifdef _OPENIB_CMA_
+static void dapl_start_cm_cntrs(DAT_HANDLE dh)
+{
+	DAPL_IA *ia = (DAPL_IA *)dh;
+	const char *dev = ibv_get_device_name(ia->hca_ptr->ib_trans.ib_dev);
+	int port = ia->hca_ptr->port_num;
+	DAT_UINT64 *cntrs = (DAT_UINT64 *)ia->cntrs;
+
+	rd_ctr(dev,"cm_tx_msgs/req", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_REQ_TX]);
+	rd_ctr(dev,"cm_tx_msgs/rep", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_REP_TX]);
+	rd_ctr(dev,"cm_tx_msgs/rtu", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_RTU_TX]);
+	rd_ctr(dev,"cm_tx_msgs/rej", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_USER_REJ_TX]);
+	rd_ctr(dev,"cm_tx_msgs/mra", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_MRA_TX]);
+	rd_ctr(dev,"cm_tx_msgs/dreq", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_DREQ_TX]);
+	rd_ctr(dev,"cm_tx_msgs/drep", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_DREP_TX]);
+
+	rd_ctr(dev,"cm_rx_msgs/req", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_REQ_RX]);
+	rd_ctr(dev,"cm_rx_msgs/rep", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_REP_RX]);
+	rd_ctr(dev,"cm_rx_msgs/rtu", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_RTU_RX]);
+	rd_ctr(dev,"cm_rx_msgs/rej", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_USER_REJ_RX]);
+	rd_ctr(dev,"cm_rx_msgs/mra", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_MRA_RX]);
+	rd_ctr(dev,"cm_rx_msgs/dreq", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_DREQ_RX]);
+	rd_ctr(dev,"cm_rx_msgs/drep", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_DREP_RX]);
+
+	rd_ctr(dev,"cm_tx_retries/req", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_ERR_REQ_RETRY]);
+	rd_ctr(dev,"cm_tx_retries/rep", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_ERR_REP_RETRY]);
+	rd_ctr(dev,"cm_tx_retries/rtu", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_ERR_RTU_RETRY]);
+	rd_ctr(dev,"cm_tx_retries/mra", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_ERR_MRA_RETRY]);
+	rd_ctr(dev,"cm_tx_retries/dreq", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_ERR_DREQ_RETRY]);
+	rd_ctr(dev,"cm_tx_retries/drep", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_ERR_DREP_RETRY]);
+
+	rd_ctr(dev,"cm_tx_duplicates/req", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_ERR_REQ_DUP]);
+	rd_ctr(dev,"cm_tx_duplicates/rep", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_ERR_REP_DUP]);
+	rd_ctr(dev,"cm_tx_duplicates/rtu", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_ERR_RTU_DUP]);
+	rd_ctr(dev,"cm_tx_duplicates/mra", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_ERR_MRA_DUP]);
+	rd_ctr(dev,"cm_tx_duplicates/dreq", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_ERR_DREQ_DUP]);
+	rd_ctr(dev,"cm_tx_duplicates/drep", port, DCNT_IA_CM, &cntrs[DCNT_IA_CM_ERR_DREP_DUP]);
+}
+
+static void dapl_stop_cm_cntrs(DAT_HANDLE dh)
+{
+	DAPL_IA *ia = (DAPL_IA *)dh;
+	const char *dev = ibv_get_device_name(ia->hca_ptr->ib_trans.ib_dev);
+	int port = ia->hca_ptr->port_num;
+	DAT_UINT64 *cntrs = (DAT_UINT64 *)ia->cntrs;
+	DAT_UINT64 val = 0;
+
+	rd_ctr(dev,"cm_tx_msgs/req", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_REQ_TX] = val - cntrs[DCNT_IA_CM_REQ_TX];
+	rd_ctr(dev,"cm_tx_msgs/rep", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_REP_TX] = val - cntrs[DCNT_IA_CM_REP_TX];
+	rd_ctr(dev,"cm_tx_msgs/rtu", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_RTU_TX] = val - cntrs[DCNT_IA_CM_RTU_TX];
+	rd_ctr(dev,"cm_tx_msgs/rej", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_USER_REJ_TX] = val - cntrs[DCNT_IA_CM_USER_REJ_TX];
+	rd_ctr(dev,"cm_tx_msgs/mra", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_MRA_TX] = val - cntrs[DCNT_IA_CM_MRA_TX];
+	rd_ctr(dev,"cm_tx_msgs/dreq", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_DREQ_TX] = val - cntrs[DCNT_IA_CM_DREQ_TX];
+	rd_ctr(dev,"cm_tx_msgs/drep", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_DREP_TX] = val - cntrs[DCNT_IA_CM_DREP_TX];
+
+	rd_ctr(dev,"cm_rx_msgs/req", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_REQ_RX] = val - cntrs[DCNT_IA_CM_REQ_RX];
+	rd_ctr(dev,"cm_rx_msgs/rep", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_REP_RX] = val - cntrs[DCNT_IA_CM_REP_RX];
+	rd_ctr(dev,"cm_rx_msgs/rtu", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_RTU_RX] = val - cntrs[DCNT_IA_CM_RTU_RX];
+	rd_ctr(dev,"cm_rx_msgs/rej", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_USER_REJ_RX] = val - cntrs[DCNT_IA_CM_USER_REJ_RX];
+	rd_ctr(dev,"cm_rx_msgs/mra", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_MRA_RX] = val - cntrs[DCNT_IA_CM_MRA_RX];
+	rd_ctr(dev,"cm_rx_msgs/dreq", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_DREQ_RX] = val - cntrs[DCNT_IA_CM_DREQ_RX];
+	rd_ctr(dev,"cm_rx_msgs/drep", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_DREP_RX] = val - cntrs[DCNT_IA_CM_DREP_RX];
+
+	rd_ctr(dev,"cm_tx_retries/req", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_ERR_REQ_RETRY] = val - cntrs[DCNT_IA_CM_ERR_REQ_RETRY];
+	rd_ctr(dev,"cm_tx_retries/rep", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_ERR_REP_RETRY] = val - cntrs[DCNT_IA_CM_ERR_REP_RETRY];
+	rd_ctr(dev,"cm_tx_retries/rtu", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_ERR_RTU_RETRY] = val - cntrs[DCNT_IA_CM_ERR_RTU_RETRY];
+	rd_ctr(dev,"cm_tx_retries/mra", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_ERR_MRA_RETRY] = val - cntrs[DCNT_IA_CM_ERR_MRA_RETRY];
+	rd_ctr(dev,"cm_tx_retries/dreq", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_ERR_DREQ_RETRY] = val - cntrs[DCNT_IA_CM_ERR_DREQ_RETRY];
+	rd_ctr(dev,"cm_tx_retries/drep", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_ERR_DREP_RETRY] = val - cntrs[DCNT_IA_CM_ERR_DREP_RETRY];
+
+	rd_ctr(dev,"cm_tx_duplicates/req", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_ERR_REQ_DUP] = val - cntrs[DCNT_IA_CM_ERR_REQ_DUP];
+	rd_ctr(dev,"cm_tx_duplicates/rep", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_ERR_REP_DUP] = val - cntrs[DCNT_IA_CM_ERR_REP_DUP];
+	rd_ctr(dev,"cm_tx_duplicates/rtu", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_ERR_RTU_DUP] = val - cntrs[DCNT_IA_CM_ERR_RTU_DUP];
+	rd_ctr(dev,"cm_tx_duplicates/mra", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_ERR_MRA_DUP] = val - cntrs[DCNT_IA_CM_ERR_MRA_DUP];
+	rd_ctr(dev,"cm_tx_duplicates/dreq", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_ERR_DREQ_DUP] = val - cntrs[DCNT_IA_CM_ERR_DREQ_DUP];
+	rd_ctr(dev,"cm_tx_duplicates/drep", port, DCNT_IA_CM, &val);
+	cntrs[DCNT_IA_CM_ERR_DREP_DUP] = val - cntrs[DCNT_IA_CM_ERR_DREP_DUP];
+}
+#endif
+
+/* map selective IB port counters to dapl counters */
+static void dapl_start_lnk_cntrs(DAT_HANDLE dh)
+{
+	DAPL_IA *ia = (DAPL_IA *)dh;
+	char *dev = ia->hca_ptr->ib_hca_handle->device->ibdev_path;
+	int port = ia->hca_ptr->port_num;
+	DAT_UINT64 *cntrs = (DAT_UINT64 *)ia->cntrs;
+
+	rd_ctr(dev,"port_rcv_errors", port, DCNT_IA_LNK, &cntrs[DCNT_IA_LNK_ERR_RCV]);
+	rd_ctr(dev,"port_rcv_remote_physical_errors", port, DCNT_IA_LNK, &cntrs[DCNT_IA_LNK_ERR_RCV_REM_PHYS]);
+	rd_ctr(dev,"port_rcv_contraint_errors", port, DCNT_IA_LNK, &cntrs[DCNT_IA_LNK_ERR_RCV_CONSTRAINT]);
+	rd_ctr(dev,"port_xmit_discards", port, DCNT_IA_LNK, &cntrs[DCNT_IA_LNK_ERR_XMT_DISCARDS]);
+	rd_ctr(dev,"port_xmit_contraint", port, DCNT_IA_LNK, &cntrs[DCNT_IA_LNK_ERR_XMT_CONTRAINT]);
+	rd_ctr(dev,"local_link_integrity_errors", port, DCNT_IA_LNK, &cntrs[DCNT_IA_LNK_ERR_INTEGRITY]);
+	rd_ctr(dev,"excessive_buffer_overrun_errors", port, DCNT_IA_LNK, &cntrs[DCNT_IA_LNK_ERR_EXC_BUF_OVERRUN]);
+	rd_ctr(dev,"port_xmit_wait", port, DCNT_IA_LNK, &cntrs[DCNT_IA_LNK_WARN_XMT_WAIT]);
+	rd_ctr(dev,"port_rcv_switch_relay_errors", port, DCNT_IA_LNK, &cntrs[DCNT_IA_LNK_WARN_RCV_SW_RELAY]);
+}
+
+static void dapl_stop_lnk_cntrs(DAT_HANDLE dh)
+{
+	DAPL_IA *ia = (DAPL_IA *)dh;
+	char *dev = ia->hca_ptr->ib_hca_handle->device->ibdev_path;
+	int port = ia->hca_ptr->port_num;
+	DAT_UINT64 *cntrs = (DAT_UINT64 *)ia->cntrs;
+	DAT_UINT64 val = 0;
+
+	rd_ctr(dev,"port_rcv_errors", port, DCNT_IA_LNK, &val);
+	cntrs[DCNT_IA_LNK_ERR_RCV] = val - cntrs[DCNT_IA_LNK_ERR_RCV];
+	rd_ctr(dev,"port_rcv_remote_physical_errors", port, DCNT_IA_LNK, &val);
+	cntrs[DCNT_IA_LNK_ERR_RCV_REM_PHYS] = val - cntrs[DCNT_IA_LNK_ERR_RCV_REM_PHYS];
+	rd_ctr(dev,"port_rcv_contraint_errors", port, DCNT_IA_LNK, &val);
+	cntrs[DCNT_IA_LNK_ERR_RCV_CONSTRAINT] =	val - cntrs[DCNT_IA_LNK_ERR_RCV_CONSTRAINT];
+	rd_ctr(dev,"port_xmit_discards", port, DCNT_IA_LNK, &val);
+	cntrs[DCNT_IA_LNK_ERR_XMT_DISCARDS] = val - cntrs[DCNT_IA_LNK_ERR_XMT_DISCARDS];
+	rd_ctr(dev,"port_xmit_contraint", port, DCNT_IA_LNK, &val);
+	cntrs[DCNT_IA_LNK_ERR_XMT_CONTRAINT] = val - cntrs[DCNT_IA_LNK_ERR_XMT_CONTRAINT];
+	rd_ctr(dev,"local_link_integrity_errors", port, DCNT_IA_LNK, &val);
+	cntrs[DCNT_IA_LNK_ERR_INTEGRITY]  = val - cntrs[DCNT_IA_LNK_ERR_INTEGRITY] ;
+	rd_ctr(dev,"excessive_buffer_overrun_errors", port, DCNT_IA_LNK, &val);
+	cntrs[DCNT_IA_LNK_ERR_EXC_BUF_OVERRUN] = val - cntrs[DCNT_IA_LNK_ERR_EXC_BUF_OVERRUN];
+	rd_ctr(dev,"port_rcv_switch_relay_errors", port, DCNT_IA_LNK, &val);
+	cntrs[DCNT_IA_LNK_WARN_RCV_SW_RELAY] = val - cntrs[DCNT_IA_LNK_WARN_RCV_SW_RELAY];
+	rd_ctr(dev,"port_xmit_wait", port, DCNT_IA_LNK, &val);
+	cntrs[DCNT_IA_LNK_WARN_XMT_WAIT] = val - cntrs[DCNT_IA_LNK_WARN_XMT_WAIT];
+}
+
+/* map selective IB diag_counters to dapl counters */
+static void dapl_start_diag_cntrs(DAT_HANDLE dh)
+{
+	DAPL_IA *ia = (DAPL_IA *)dh;
+	char *dev = ia->hca_ptr->ib_hca_handle->device->ibdev_path;
+	int port = ia->hca_ptr->port_num;
+	DAT_UINT64 *cntrs = (DAT_UINT64 *)ia->cntrs;
+
+	rd_ctr(dev,"rq_num_rae", port, DCNT_IA_DIAG, &cntrs[DCNT_IA_DIAG_ERR_RQ_RAE]);
+	rd_ctr(dev,"rq_num_oos", port, DCNT_IA_DIAG, &cntrs[DCNT_IA_DIAG_ERR_RQ_OOS]);
+	rd_ctr(dev,"rq_num_rire", port, DCNT_IA_DIAG, &cntrs[DCNT_IA_DIAG_ERR_RQ_RIRE]);
+	rd_ctr(dev,"rq_num_udsdprd", port, DCNT_IA_DIAG, &cntrs[DCNT_IA_DIAG_ERR_RQ_UDSDPRD]);
+	rd_ctr(dev,"sq_num_rae", port, DCNT_IA_DIAG, &cntrs[DCNT_IA_DIAG_ERR_SQ_RAE]);
+	rd_ctr(dev,"sq_num_oos", port, DCNT_IA_DIAG, &cntrs[DCNT_IA_DIAG_ERR_SQ_OOS]);
+	rd_ctr(dev,"sq_num_rire", port, DCNT_IA_DIAG, &cntrs[DCNT_IA_DIAG_ERR_SQ_RIRE]);
+	rd_ctr(dev,"sq_num_rree", port, DCNT_IA_DIAG, &cntrs[DCNT_IA_DIAG_ERR_SQ_RREE]);
+	rd_ctr(dev,"sq_num_tree", port, DCNT_IA_DIAG, &cntrs[DCNT_IA_DIAG_ERR_SQ_TREE]);
+}
+
+static void dapl_stop_diag_cntrs(DAT_HANDLE dh)
+{
+	DAPL_IA *ia = (DAPL_IA *)dh;
+	char *dev = ia->hca_ptr->ib_hca_handle->device->ibdev_path;
+	int port = ia->hca_ptr->port_num;
+	DAT_UINT64 *cntrs = (DAT_UINT64 *)ia->cntrs;
+	DAT_UINT64 val = 0;
+
+	rd_ctr(dev,"rq_num_rae", port, DCNT_IA_DIAG, &val);
+	cntrs[DCNT_IA_DIAG_ERR_RQ_RAE] = val - cntrs[DCNT_IA_DIAG_ERR_RQ_RAE];
+	rd_ctr(dev,"rq_num_oos", port, DCNT_IA_DIAG, &val);
+	cntrs[DCNT_IA_DIAG_ERR_RQ_OOS] = val - cntrs[DCNT_IA_DIAG_ERR_RQ_OOS];
+	rd_ctr(dev,"rq_num_rire", port, DCNT_IA_DIAG, &val);
+	cntrs[DCNT_IA_DIAG_ERR_RQ_RIRE] = val - cntrs[DCNT_IA_DIAG_ERR_RQ_RIRE];
+	rd_ctr(dev,"rq_num_udsdprd", port, DCNT_IA_DIAG, &val);
+	cntrs[DCNT_IA_DIAG_ERR_RQ_UDSDPRD] = val - cntrs[DCNT_IA_DIAG_ERR_RQ_UDSDPRD];
+	rd_ctr(dev,"sq_num_rae", port, DCNT_IA_DIAG, &val);
+	cntrs[DCNT_IA_DIAG_ERR_SQ_RAE] = val - cntrs[DCNT_IA_DIAG_ERR_SQ_RAE];
+	rd_ctr(dev,"sq_num_oos", port, DCNT_IA_DIAG, &val);
+	cntrs[DCNT_IA_DIAG_ERR_SQ_OOS] = val - cntrs[DCNT_IA_DIAG_ERR_SQ_OOS];
+	rd_ctr(dev,"sq_num_rire", port, DCNT_IA_DIAG, &val);
+	cntrs[DCNT_IA_DIAG_ERR_SQ_RIRE] = val - cntrs[DCNT_IA_DIAG_ERR_SQ_RIRE];
+	rd_ctr(dev,"sq_num_rree", port, DCNT_IA_DIAG, &val);
+	cntrs[DCNT_IA_DIAG_ERR_SQ_RREE] = val - cntrs[DCNT_IA_DIAG_ERR_SQ_RREE];
+	rd_ctr(dev,"sq_num_tree", port, DCNT_IA_DIAG, &val);
+	cntrs[DCNT_IA_DIAG_ERR_SQ_TREE] = val - cntrs[DCNT_IA_DIAG_ERR_SQ_TREE];
+}
+
+void dapl_start_counters(DAT_HANDLE dh, DAT_IA_COUNTER_TYPE type)
+{
+	switch (type) {
+	case DCNT_IA_CM:
+#ifdef _OPENIB_CMA_
+		dapl_start_cm_cntrs(dh); /* ib cm timers, cma only */
+#endif
+		break;
+	case DCNT_IA_LNK:
+		dapl_start_lnk_cntrs(dh);
+		break;
+	case DCNT_IA_DIAG:
+		dapl_start_diag_cntrs(dh);
+		break;
+	default:
+		break;
+	}
+}
+
+void dapl_stop_counters(DAT_HANDLE dh, DAT_IA_COUNTER_TYPE type)
+{
+	switch (type) {
+	case DCNT_IA_CM:
+#ifdef _OPENIB_CMA_
+		dapl_stop_cm_cntrs(dh);
+#endif
+		break;
+	case DCNT_IA_LNK:
+		dapl_stop_lnk_cntrs(dh);
+		break;
+	case DCNT_IA_DIAG:
+		dapl_stop_diag_cntrs(dh);
+		break;
+	default:
+		break;
+
+	}
+}
+
+void dapli_start_counters(DAT_HANDLE dh)
+{
+#ifdef _OPENIB_CMA_
+	if (g_dapl_dbg_type & (DAPL_DBG_TYPE_CM_ERRS | DAPL_DBG_TYPE_CM_STATS))
+		dapl_start_cm_cntrs(dh);
+#endif
+	if (g_dapl_dbg_type & DAPL_DBG_TYPE_LINK_ERRS)
+		dapl_start_lnk_cntrs(dh);
+	if (g_dapl_dbg_type & DAPL_DBG_TYPE_DIAG_ERRS)
+		dapl_start_diag_cntrs(dh);
+}
+
+void dapli_stop_counters(DAT_HANDLE dh)
+{
+#ifdef _OPENIB_CMA_
+	if (g_dapl_dbg_type & (DAPL_DBG_TYPE_CM_ERRS | DAPL_DBG_TYPE_CM_STATS))
+		dapl_stop_cm_cntrs(dh);
+#endif
+	if (g_dapl_dbg_type & DAPL_DBG_TYPE_LINK_ERRS)
+		dapl_stop_lnk_cntrs(dh);
+	if (g_dapl_dbg_type & DAPL_DBG_TYPE_DIAG_ERRS)
+		dapl_stop_diag_cntrs(dh);
+
+	if (g_dapl_dbg_type & DAPL_DBG_TYPE_CM_STATS)
+		dapl_print_counter_str(dh, DCNT_IA_ALL_COUNTERS, 1, "_CM");
+	else if (g_dapl_dbg_type & DAPL_DBG_TYPE_CM_ERRS)
+		dapl_print_counter_str(dh, DCNT_IA_ALL_COUNTERS, 1, "_CM_ERR");
+	if (g_dapl_dbg_type & DAPL_DBG_TYPE_LINK_ERRS)
+		dapl_print_counter_str(dh, DCNT_IA_ALL_COUNTERS, 1, "_LNK_ERR");
+	if (g_dapl_dbg_type & DAPL_DBG_TYPE_LINK_WARN)
+		dapl_print_counter_str(dh, DCNT_IA_ALL_COUNTERS, 1, "_LNK_WARN");
+	if (g_dapl_dbg_type & DAPL_DBG_TYPE_DIAG_ERRS)
+		dapl_print_counter_str(dh, DCNT_IA_ALL_COUNTERS, 1, "_DIAG_ERR");
+}
+
 /*
  * The order of this list must match the DAT counter definitions 
  */
@@ -103,9 +425,69 @@ static char *ia_cntr_names[] = {
 	"DCNT_IA_MEM_FREE",
 	"DCNT_IA_ASYNC_ERROR",
 	"DCNT_IA_ASYNC_QP_ERROR",
-	"DCNT_IA_ASYNC_CQ_ERROR"
+	"DCNT_IA_ASYNC_CQ_ERROR",
+	"DCNT_IA_CM_LISTEN",
+	"DCNT_IA_CM_REQ_TX",
+	"DCNT_IA_CM_REQ_RX",
+	"DCNT_IA_CM_REP_TX",
+	"DCNT_IA_CM_REP_RX",
+	"DCNT_IA_CM_RTU_TX",
+	"DCNT_IA_CM_RTU_RX",
+	"DCNT_IA_CM_USER_REJ_TX",
+	"DCNT_IA_CM_USER_REJ_RX",
+	"DCNT_IA_CM_ACTIVE_EST",
+	"DCNT_IA_CM_PASSIVE_EST",
+	"DCNT_IA_CM_AH_REQ_TX",
+	"DCNT_IA_CM_AH_REQ_RX",
+	"DCNT_IA_CM_AH_RESOLVED",
+	"DCNT_IA_CM_DREQ_TX",
+	"DCNT_IA_CM_DREQ_RX",
+	"DCNT_IA_CM_DREP_TX",
+	"DCNT_IA_CM_DREP_RX",
+	"DCNT_IA_CM_MRA_TX",
+	"DCNT_IA_CM_MRA_RX",
+	"DCNT_IA_CM_REQ_FULLQ_POLL",
+	"DCNT_IA_CM_ERR",
+	"DCNT_IA_CM_ERR_REQ_FULLQ",
+	"DCNT_IA_CM_ERR_REQ_DUP",
+	"DCNT_IA_CM_ERR_REQ_RETRY",
+	"DCNT_IA_CM_ERR_REP_DUP",
+	"DCNT_IA_CM_ERR_REP_RETRY",
+	"DCNT_IA_CM_ERR_RTU_DUP",
+	"DCNT_IA_CM_ERR_RTU_RETRY",
+	"DCNT_IA_CM_ERR_REFUSED",
+	"DCNT_IA_CM_ERR_RESET",
+	"DCNT_IA_CM_ERR_TIMEOUT",
+	"DCNT_IA_CM_ERR_REJ_TX",
+	"DCNT_IA_CM_ERR_REJ_RX",
+	"DCNT_IA_CM_ERR_DREQ_DUP",
+	"DCNT_IA_CM_ERR_DREQ_RETRY",
+	"DCNT_IA_CM_ERR_DREP_DUP",
+	"DCNT_IA_CM_ERR_DREP_RETRY",
+	"DCNT_IA_CM_ERR_MRA_DUP",
+	"DCNT_IA_CM_ERR_MRA_RETRY",
+	"DCNT_IA_CM_ERR_UNEXPECTED",
+	"DCNT_IA_LNK_ERR_RCV",
+	"DCNT_IA_LNK_ERR_RCV_REM_PHYS",
+	"DCNT_IA_LNK_ERR_RCV_CONSTRAINT",
+	"DCNT_IA_LNK_ERR_XMT_DISCARDS",
+	"DCNT_IA_LNK_ERR_XMT_CONTRAINT",
+	"DCNT_IA_LNK_ERR_INTEGRITY",
+	"DCNT_IA_LNK_ERR_EXC_BUF_OVERRUN",
+	"DCNT_IA_LNK_WARN_RCV_SW_RELAY",
+	"DCNT_IA_LNK_WARN_XMT_WAIT",
+	"DCNT_IA_DIAG_ERR_RQ_RAE",
+	"DCNT_IA_DIAG_ERR_RQ_OOS",
+	"DCNT_IA_DIAG_ERR_RQ_RIRE",
+	"DCNT_IA_DIAG_ERR_RQ_UDSDPRD",
+	"DCNT_IA_DIAG_ERR_SQ_RAE",
+	"DCNT_IA_DIAG_ERR_SQ_OOS",
+	"DCNT_IA_DIAG_ERR_SQ_RIRE",
+	"DCNT_IA_DIAG_ERR_SQ_RREE",
+	"DCNT_IA_DIAG_ERR_SQ_TREE",
 };
 
+
 static char *ep_cntr_names[] = {
 	"DCNT_EP_CONNECT",
 	"DCNT_EP_DISCONNECT",
@@ -234,8 +616,9 @@ void dapl_print_counter(DAT_HANDLE dh, int counter, int reset)
 
 	for (i = 0; i < max; i++) {
 		if ((counter == i) || (counter == max)) {
-			printf(" %s = " F64u " \n",
-			       dapl_query_counter_name(dh, i), p_cntrs[i]);
+			printf(" %s:0x%x: %s = " F64u " \n",
+				_hostname_, dapl_os_getpid(),
+			       	dapl_query_counter_name(dh, i), p_cntrs[i]);
 			if (reset)
 				p_cntrs[i] = 0;
 		}
@@ -246,7 +629,47 @@ void dapl_print_counter(DAT_HANDLE dh, int counter, int reset)
 	    (g_dapl_dbg_type & DAPL_DBG_TYPE_CM_LIST)) {
 		dapls_print_cm_list((DAPL_IA*)dh);
 	}
-	return;
+}
+
+void dapl_print_counter_str(DAT_HANDLE dh, int counter, int reset, const char *pattern)
+{
+	int i, max;
+	DAT_UINT64 *p_cntrs;
+	DAT_HANDLE_TYPE type = 0;
+	DAPL_IA *ia = NULL;
+
+	dat_get_handle_type(dh, &type);
+
+	switch (type) {
+	case DAT_HANDLE_TYPE_IA:
+		max = DCNT_IA_ALL_COUNTERS;
+		ia = (DAPL_IA *)dh;
+		p_cntrs = ((DAPL_IA *) dh)->cntrs;
+		break;
+	case DAT_HANDLE_TYPE_EP:
+		max = DCNT_EP_ALL_COUNTERS;
+		p_cntrs = ((DAPL_EP *) dh)->cntrs;
+		break;
+	case DAT_HANDLE_TYPE_EVD:
+		max = DCNT_EVD_ALL_COUNTERS;
+		p_cntrs = ((DAPL_EVD *) dh)->cntrs;
+		break;
+	default:
+		return;
+	}
+
+	/* print only counters with pattern string match and non-zero values */
+	for (i = 0; i < max; i++) {
+		if ((counter == i) || (counter == max)) {
+			if (p_cntrs[i] && !dapl_os_pstrcmp(pattern, dapl_query_counter_name(dh, i))) {
+				printf(" %s:0x%x: %s = " F64u " \n",
+					_hostname_, dapl_os_getpid(),
+			        	dapl_query_counter_name(dh, i), p_cntrs[i]);
+				if (reset)
+					p_cntrs[i] = 0;
+			}
+		}
+	}
 }
 
 #endif				/* DAPL_COUNTERS */
diff --git a/dapl/common/dapl_ia_open.c b/dapl/common/dapl_ia_open.c
index edead04..e43d78d 100644
--- a/dapl/common/dapl_ia_open.c
+++ b/dapl/common/dapl_ia_open.c
@@ -266,6 +266,10 @@ dapl_ia_open(IN const DAT_NAME_PTR name,
 	*ia_handle_ptr = ia_ptr;
 	*async_evd_handle_ptr = evd_ptr;
 
+#if DAPL_COUNTERS
+	dapli_start_counters((DAT_HANDLE)ia_ptr);
+#endif
+
       bail:
 	if (dat_status != DAT_SUCCESS) {
 		if (ia_ptr) {
diff --git a/dapl/common/dapl_ia_util.c b/dapl/common/dapl_ia_util.c
index 2208c23..6d1b5a8 100755
--- a/dapl/common/dapl_ia_util.c
+++ b/dapl/common/dapl_ia_util.c
@@ -525,6 +525,13 @@ void dapli_ia_release_hca(DAPL_HCA * hca_ptr)
 	dapl_os_lock(&hca_ptr->lock);
 	dapl_os_atomic_dec(&hca_ptr->handle_ref_count);
 	if (dapl_os_atomic_read(&hca_ptr->handle_ref_count) == 0) {
+#ifdef DAPL_COUNTERS
+{
+		DAPL_IA *ia = (DAPL_IA *)dapl_llist_peek_head(&hca_ptr->ia_list_head);
+		dapli_stop_counters(ia);
+		dapl_os_free(ia->cntrs, sizeof(DAT_UINT64) * DCNT_IA_ALL_COUNTERS);
+}
+#endif
 		dapls_ib_close_hca(hca_ptr);
 		hca_ptr->ib_hca_handle = IB_INVALID_HANDLE;
 		hca_ptr->async_evd = NULL;
@@ -566,11 +573,6 @@ void dapls_ia_free(DAPL_IA * ia_ptr)
 	dapl_hca_unlink_ia(ia_ptr->hca_ptr, ia_ptr);
 	ia_ptr->header.magic = DAPL_MAGIC_INVALID;	/* reset magic to prevent reuse */
 	dapl_os_lock_destroy(&ia_ptr->header.lock);
-
-#ifdef DAPL_COUNTERS
-	dapl_os_free(ia_ptr->cntrs, sizeof(DAT_UINT64) * DCNT_IA_ALL_COUNTERS);
-#endif				/* DAPL_COUNTERS */
-
 	dapl_os_free(ia_ptr, sizeof(DAPL_IA));
 }
 
diff --git a/dapl/include/dapl_debug.h b/dapl/include/dapl_debug.h
index bb11c3d..6cbe028 100644
--- a/dapl/include/dapl_debug.h
+++ b/dapl/include/dapl_debug.h
@@ -71,7 +71,11 @@ typedef enum
     DAPL_DBG_TYPE_CM_EST  	= 0x8000,
     DAPL_DBG_TYPE_CM_WARN  	= 0x10000,
     DAPL_DBG_TYPE_EXTENSION	= 0x20000,
-    DAPL_DBG_TYPE_CM_STATS	= 0x40000
+    DAPL_DBG_TYPE_CM_STATS	= 0x40000,
+    DAPL_DBG_TYPE_CM_ERRS	= 0x80000,
+    DAPL_DBG_TYPE_LINK_ERRS	= 0x100000,
+    DAPL_DBG_TYPE_LINK_WARN	= 0x200000,
+    DAPL_DBG_TYPE_DIAG_ERRS	= 0x400000,
 
 } DAPL_DBG_TYPE;
 
@@ -100,6 +104,7 @@ extern void dapl_internal_dbg_log(DAPL_DBG_TYPE type,  const char *fmt,  ...);
 
 #define DAPL_CNTR(h_ptr, cntr) ((DAT_UINT64*)h_ptr->cntrs)[cntr]++
 #define DAPL_CNTR_DATA(h_ptr, cntr, data) ((DAT_UINT64*)h_ptr->cntrs)[cntr]+= data
+#define DAPL_CNTR_RESET(h_ptr, cntr) ((DAT_UINT64*)h_ptr->cntrs)[cntr] = 0
 
 DAT_RETURN dapl_query_counter(DAT_HANDLE dh, 
 			      int counter, 
@@ -107,11 +112,17 @@ DAT_RETURN dapl_query_counter(DAT_HANDLE dh,
 			      int reset);
 char *dapl_query_counter_name(DAT_HANDLE dh, int counter);
 void dapl_print_counter(DAT_HANDLE dh, int counter, int reset);
+void dapl_print_counter_str(DAT_HANDLE dh, int counter, int reset, const char *pattern);
+void dapl_start_counters(DAT_HANDLE ia, DAT_IA_COUNTER_TYPE type);
+void dapl_stop_counters(DAT_HANDLE ia, DAT_IA_COUNTER_TYPE type);
+void dapli_start_counters(DAT_HANDLE ia);
+void dapli_stop_counters(DAT_HANDLE ia);
 
 #else
 
 #define DAPL_CNTR(handle, cntr)
 #define DAPL_CNTR_DATA(handle, cntr, data)
+#define DAPL_CNTR_RESET(handle, cntr)
 
 #endif /* DAPL_COUNTERS */
 
diff --git a/dapl/openib_common/dapl_ib_common.h b/dapl/openib_common/dapl_ib_common.h
index e757b65..ba805d0 100644
--- a/dapl/openib_common/dapl_ib_common.h
+++ b/dapl/openib_common/dapl_ib_common.h
@@ -342,7 +342,7 @@ dapl_convert_errno( IN int err, IN const char *str )
     if (!err)  return DAT_SUCCESS;
     	
     if ((err != EAGAIN) && (err != ETIMEDOUT))
-	dapl_log (DAPL_DBG_TYPE_ERR," %s %s\n", str, strerror(err));
+	dapl_log (DAPL_DBG_TYPE_ERR," DAPL ERR %s %s\n", str, strerror(err));
 
     switch( err )
     {
diff --git a/dapl/openib_common/ib_extensions.c b/dapl/openib_common/ib_extensions.c
index c85323c..0952bd5 100644
--- a/dapl/openib_common/ib_extensions.c
+++ b/dapl/openib_common/ib_extensions.c
@@ -184,6 +184,32 @@ dapl_extensions(IN DAT_HANDLE dat_handle,
 			status = DAT_SUCCESS;
 			break;
 		}
+	case DAT_IB_START_COUNTERS_OP:
+		{
+			DAT_IA_COUNTER_TYPE type;
+
+			dapl_dbg_log(DAPL_DBG_TYPE_RTN,
+				     " Start counter extension call\n");
+
+			type = va_arg(args, int);
+
+			dapl_start_counters(dat_handle, type);
+			status = DAT_SUCCESS;
+			break;
+		}
+	case DAT_IB_STOP_COUNTERS_OP:
+		{
+			DAT_IA_COUNTER_TYPE type;
+
+			dapl_dbg_log(DAPL_DBG_TYPE_RTN,
+				     " Start counter extension call\n");
+
+			type = va_arg(args, int);
+
+			dapl_stop_counters(dat_handle, type);
+			status = DAT_SUCCESS;
+			break;
+		}
 #endif				/* DAPL_COUNTERS */
 #ifdef DAT_IB_COLLECTIVES
 	case DAT_IB_COLLECTIVE_CREATE_MEMBER_OP:
diff --git a/dapl/udapl/linux/dapl_osd.h b/dapl/udapl/linux/dapl_osd.h
index cb61cae..7198439 100644
--- a/dapl/udapl/linux/dapl_osd.h
+++ b/dapl/udapl/linux/dapl_osd.h
@@ -515,6 +515,22 @@ STATIC _INLINE_ char * dapl_os_strdup(const char *str)
     return strdup(str);
 }
 
+STATIC _INLINE_ int dapl_os_pstrcmp(const char *pstr, const char *str)
+{
+	int i, ii;
+	int plen = strlen(pstr);
+	int slen = strlen(str);
+
+	for (i=0; i < slen; i++) {
+		for (ii=0; ii < plen && i < slen; ii++, i++) {
+			if ((pstr[ii] == str[i]) && (ii == plen-1))
+				return 0;
+			else if (pstr[ii] != str[i])
+				break;
+		}
+	}
+	return 1;
+}
 
 /*
  * Timer Functions
diff --git a/dat/include/dat2/dat_ib_extensions.h b/dat/include/dat2/dat_ib_extensions.h
index ac69fed..6e3cb9e 100755
--- a/dat/include/dat2/dat_ib_extensions.h
+++ b/dat/include/dat2/dat_ib_extensions.h
@@ -73,9 +73,10 @@
  * 2.0.4 - Add DAT_IB_UD_CONNECTION_REJECT_EVENT extended UD event
  * 2.0.5 - Add DAT_IB_UD extended UD connection error events
  * 2.0.6 - Add MPI over IB collective extensions
+ * 2.0.7 - Add new IA counters for dapl CM, device LINK, device DIAG
  *
  */
-#define DAT_IB_EXTENSION_VERSION	206	/* 2.0.6 */
+#define DAT_IB_EXTENSION_VERSION	207	/* 2.0.7 */
 #define DAT_IB_ATTR_COUNTERS		"DAT_COUNTERS"
 #define DAT_IB_ATTR_FETCH_AND_ADD	"DAT_IB_FETCH_AND_ADD"
 #define DAT_IB_ATTR_CMP_AND_SWAP	"DAT_IB_CMP_AND_SWAP"
@@ -151,6 +152,8 @@ typedef enum dat_ib_op
 	DAT_IB_COLLECTIVE_SCAN_OP,
 	DAT_IB_COLLECTIVE_BROADCAST_OP,
 	DAT_IB_COLLECTIVE_BARRIER_OP,
+	DAT_IB_START_COUNTERS_OP,
+	DAT_IB_STOP_COUNTERS_OP,
 	
 } DAT_IB_OP;
 
@@ -369,6 +372,65 @@ typedef enum dat_ia_counters
 	DCNT_IA_ASYNC_ERROR,
 	DCNT_IA_ASYNC_QP_ERROR,
 	DCNT_IA_ASYNC_CQ_ERROR,
+	DCNT_IA_CM_LISTEN,
+	DCNT_IA_CM_REQ_TX,
+	DCNT_IA_CM_REQ_RX,
+	DCNT_IA_CM_REP_TX,
+	DCNT_IA_CM_REP_RX,
+	DCNT_IA_CM_RTU_TX,
+	DCNT_IA_CM_RTU_RX,
+	DCNT_IA_CM_USER_REJ_TX,
+	DCNT_IA_CM_USER_REJ_RX,
+	DCNT_IA_CM_ACTIVE_EST,
+	DCNT_IA_CM_PASSIVE_EST,
+	DCNT_IA_CM_AH_REQ_TX,
+	DCNT_IA_CM_AH_REQ_RX,
+	DCNT_IA_CM_AH_RESOLVED,
+	DCNT_IA_CM_DREQ_TX,
+	DCNT_IA_CM_DREQ_RX,
+	DCNT_IA_CM_DREP_TX,
+	DCNT_IA_CM_DREP_RX,
+	DCNT_IA_CM_MRA_TX,
+	DCNT_IA_CM_MRA_RX,
+	DCNT_IA_CM_REQ_FULLQ_POLL,
+	DCNT_IA_CM_ERR,
+	DCNT_IA_CM_ERR_REQ_FULLQ,
+	DCNT_IA_CM_ERR_REQ_DUP,
+	DCNT_IA_CM_ERR_REQ_RETRY,
+	DCNT_IA_CM_ERR_REP_DUP,
+	DCNT_IA_CM_ERR_REP_RETRY,
+	DCNT_IA_CM_ERR_RTU_DUP,
+	DCNT_IA_CM_ERR_RTU_RETRY,
+	DCNT_IA_CM_ERR_REFUSED,
+	DCNT_IA_CM_ERR_RESET,
+	DCNT_IA_CM_ERR_TIMEOUT,
+	DCNT_IA_CM_ERR_REJ_TX,
+	DCNT_IA_CM_ERR_REJ_RX,
+	DCNT_IA_CM_ERR_DREQ_DUP,
+	DCNT_IA_CM_ERR_DREQ_RETRY,
+	DCNT_IA_CM_ERR_DREP_DUP,
+	DCNT_IA_CM_ERR_DREP_RETRY,
+	DCNT_IA_CM_ERR_MRA_DUP,
+	DCNT_IA_CM_ERR_MRA_RETRY,
+	DCNT_IA_CM_ERR_UNEXPECTED,
+	DCNT_IA_LNK_ERR_RCV,
+	DCNT_IA_LNK_ERR_RCV_REM_PHYS,
+	DCNT_IA_LNK_ERR_RCV_CONSTRAINT,
+	DCNT_IA_LNK_ERR_XMT_DISCARDS,
+	DCNT_IA_LNK_ERR_XMT_CONTRAINT,
+	DCNT_IA_LNK_ERR_INTEGRITY,
+	DCNT_IA_LNK_ERR_EXC_BUF_OVERRUN,
+	DCNT_IA_LNK_WARN_RCV_SW_RELAY,
+	DCNT_IA_LNK_WARN_XMT_WAIT,
+	DCNT_IA_DIAG_ERR_RQ_RAE,
+	DCNT_IA_DIAG_ERR_RQ_OOS,
+	DCNT_IA_DIAG_ERR_RQ_RIRE,
+	DCNT_IA_DIAG_ERR_RQ_UDSDPRD,
+	DCNT_IA_DIAG_ERR_SQ_RAE,
+	DCNT_IA_DIAG_ERR_SQ_OOS,
+	DCNT_IA_DIAG_ERR_SQ_RIRE,
+	DCNT_IA_DIAG_ERR_SQ_RREE,
+	DCNT_IA_DIAG_ERR_SQ_TREE,
 	DCNT_IA_ALL_COUNTERS,  /* MUST be last */
 
 } DAT_IA_COUNTERS;
@@ -426,6 +488,19 @@ typedef enum dat_evd_counters
 } DAT_EVD_COUNTERS;
 
 /*
+ * Definitions IA Counter Types
+ * 	for sampling running counters
+ *
+ */
+typedef enum dat_ia_counter_type
+{
+	DCNT_IA_CM,
+	DCNT_IA_LNK,
+	DCNT_IA_DIAG,
+
+} DAT_IA_COUNTER_TYPE;
+
+/*
  * Data type for reduce operations
  */
 typedef enum dat_ib_collective_data_type
@@ -655,6 +730,24 @@ dat_strerror_ext_status (
 		IN (int) (reset))
 
 /*
+ * Start and stop counter(s):
+ * Provide IA, call will start sampling running IB counters
+ * 	DAT_HANDLE dat_handle, counter type (link, diag)
+ *
+ */
+#define dat_ib_start_counter(dat_handle, type) \
+	dat_extension_op(\
+		IN (DAT_HANDLE) dat_handle, \
+		IN (DAT_IB_OP) DAT_IB_START_COUNTERS_OP, \
+		IN (DAT_COUNTER_TYPE) (type))
+
+#define dat_ib_stop_counter(dat_handle, type) \
+	dat_extension_op(\
+		IN (DAT_HANDLE) dat_handle, \
+		IN (DAT_IB_OP) DAT_IB_STOP_COUNTERS_OP, \
+		IN (DAT_COUNTER_TYPE) (type))
+
+/*
  ************************ MPI IB Collective Functions ***********************
  */
 
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
