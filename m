From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: remove ib_resolve_smlid_via requirement
 for sa queries
Date: Fri, 24 Feb 2012 09:47:19 -0800
Message-ID: <20120224094719.6a23dcb3.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


ib_resolve_smlid_via, in the MAD library, issues a SubnGet(PortInfo) on the
local port to resolve the SM LID and SL.  saqueries do not require the use of
SMP's.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/ibdiag_common.c |   44 ++++++++++++++++++++++++++++++--------------
 1 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index 58d3d95..b22ed60 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -483,29 +483,46 @@ int is_mlnx_ext_port_info_supported(uint32_t devid)
 	return 0;
 }
 
+/** =========================================================================
+ * Resolve the SM portid using the umad layer rather than using
+ * ib_resolve_smlid_via which requires a PortInfo query on the local port.
+ */
+int resolve_sm_portid(char *ca_name, uint8_t portnum, ib_portid_t *sm_id)
+{
+	umad_port_t port;
+	int rc;
+
+	if (!sm_id)
+		return (-1);
+
+	if ((rc = umad_get_port(ca_name, portnum, &port)) < 0)
+		return rc;
+
+	memset(sm_id, 0, sizeof(*sm_id));
+	sm_id->lid = port.sm_lid;
+	sm_id->sl = port.sm_sl;
+
+	umad_release_port(&port);
+
+	return 0;
+}
+
 /* define a common SA query structure
  * This is by no means optimal but it moves the saquery functionality out of
  * the saquery tool and provides it to other utilities.
  */
 bind_handle_t sa_get_bind_handle(void)
 {
-	struct ibmad_port * srcport;
 	bind_handle_t handle;
-	int mgmt_classes[2] = { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS };
-
-	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 2);
-	if (!srcport) {
-		IBWARN("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
-		return (NULL);
-	}
-
 	handle = calloc(1, sizeof(*handle));
 	if (!handle)
 		IBPANIC("calloc failed");
 
-	ib_resolve_smlid_via(&handle->dport, ibd_timeout, srcport);
+	resolve_sm_portid(ibd_ca, ibd_ca_port, &handle->dport);
 	if (!handle->dport.lid) {
-		IBWARN("No SM found.");
+		IBWARN("No SM/SA found on port %s:%d",
+			ibd_ca ? "" : ibd_ca,
+			ibd_ca_port);
 		free(handle);
 		return (NULL);
 	}
@@ -514,8 +531,7 @@ bind_handle_t sa_get_bind_handle(void)
 	if (!handle->dport.qkey)
 		handle->dport.qkey = IB_DEFAULT_QP1_QKEY;
 
-	handle->srcport = srcport;
-	handle->fd = mad_rpc_portid(srcport);
+	handle->fd = umad_open_port(ibd_ca, ibd_ca_port);
 	handle->agent = umad_register(handle->fd, IB_SA_CLASS, 2, 1, NULL);
 
 	return handle;
@@ -524,7 +540,7 @@ bind_handle_t sa_get_bind_handle(void)
 void sa_free_bind_handle(bind_handle_t h)
 {
 	umad_unregister(h->fd, h->agent);
-	mad_rpc_close_port(h->srcport);
+	umad_close_port(h->fd);
 	free(h);
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
