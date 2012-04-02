From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 5/6] [ofa_kernel] Add nfsrdma_0000_sysctl-changes.patch
Date: Mon, 2 Apr 2012 00:06:01 -0500
Message-ID: <20120402050558.GA20012@shrek.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
---
 .../nfsrdma_0000_sysctl-changes.patch              |  242 ++++++++++++++++++++
 1 files changed, 242 insertions(+), 0 deletions(-)
 create mode 100644 kernel_patches/backport/3.0_sles11sp2/nfsrdma_0000_sysctl-changes.patch

diff --git a/kernel_patches/backport/3.0_sles11sp2/nfsrdma_0000_sysctl-changes.patch b/kernel_patches/backport/3.0_sles11sp2/nfsrdma_0000_sysctl-changes.patch
new file mode 100644
index 0000000..f243b63
--- /dev/null
+++ b/kernel_patches/backport/3.0_sles11sp2/nfsrdma_0000_sysctl-changes.patch
@@ -0,0 +1,242 @@
+From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
+Subject: nfsrdma - sysctl usage changes
+
+Index: ofa_kernel-1.5.4.1/net/sunrpc/xprtrdma/svc_rdma.c
+===================================================================
+--- ofa_kernel-1.5.4.1.orig/net/sunrpc/xprtrdma/svc_rdma.c
++++ ofa_kernel-1.5.4.1/net/sunrpc/xprtrdma/svc_rdma.c
+@@ -80,8 +80,7 @@ struct kmem_cache *svc_rdma_ctxt_cachep;
+  * current value.
+  */
+ static int read_reset_stat(ctl_table *table, int write,
+-			   struct file *filp, void __user *buffer, size_t *lenp,
+-			   loff_t *ppos)
++			   void __user *buffer, size_t *lenp, loff_t *ppos)
+ {
+ 	atomic_t *stat = (atomic_t *)table->data;
+ 
+@@ -121,7 +120,6 @@ static ctl_table svcrdma_parm_table[] =
+ 		.maxlen		= sizeof(unsigned int),
+ 		.mode		= 0644,
+ 		.proc_handler	= &proc_dointvec_minmax,
+-		.strategy	= &sysctl_intvec,
+ 		.extra1		= &min_max_requests,
+ 		.extra2		= &max_max_requests
+ 	},
+@@ -131,7 +129,6 @@ static ctl_table svcrdma_parm_table[] =
+ 		.maxlen		= sizeof(unsigned int),
+ 		.mode		= 0644,
+ 		.proc_handler	= &proc_dointvec_minmax,
+-		.strategy	= &sysctl_intvec,
+ 		.extra1		= &min_max_inline,
+ 		.extra2		= &max_max_inline
+ 	},
+@@ -141,7 +138,6 @@ static ctl_table svcrdma_parm_table[] =
+ 		.maxlen		= sizeof(unsigned int),
+ 		.mode		= 0644,
+ 		.proc_handler	= &proc_dointvec_minmax,
+-		.strategy	= &sysctl_intvec,
+ 		.extra1		= &min_ord,
+ 		.extra2		= &max_ord,
+ 	},
+@@ -209,9 +205,7 @@ static ctl_table svcrdma_parm_table[] =
+ 		.mode		= 0644,
+ 		.proc_handler	= &read_reset_stat,
+ 	},
+-	{
+-		.ctl_name = 0,
+-	},
++	{ },
+ };
+ 
+ static ctl_table svcrdma_table[] = {
+@@ -220,21 +214,16 @@ static ctl_table svcrdma_table[] = {
+ 		.mode		= 0555,
+ 		.child		= svcrdma_parm_table
+ 	},
+-	{
+-		.ctl_name = 0,
+-	},
++	{ },
+ };
+ 
+ static ctl_table svcrdma_root_table[] = {
+ 	{
+-		.ctl_name	= CTL_SUNRPC,
+ 		.procname	= "sunrpc",
+ 		.mode		= 0555,
+ 		.child		= svcrdma_table
+ 	},
+-	{
+-		.ctl_name = 0,
+-	},
++	{ },
+ };
+ 
+ void svc_rdma_cleanup(void)
+Index: ofa_kernel-1.5.4.1/net/sunrpc/xprtrdma/transport.c
+===================================================================
+--- ofa_kernel-1.5.4.1.orig/net/sunrpc/xprtrdma/transport.c
++++ ofa_kernel-1.5.4.1/net/sunrpc/xprtrdma/transport.c
+@@ -86,79 +86,63 @@ static struct ctl_table_header *sunrpc_t
+ 
+ static ctl_table xr_tunables_table[] = {
+ 	{
+-		.ctl_name       = CTL_UNNUMBERED,
+ 		.procname	= "rdma_slot_table_entries",
+ 		.data		= &xprt_rdma_slot_table_entries,
+ 		.maxlen		= sizeof(unsigned int),
+ 		.mode		= 0644,
+ 		.proc_handler	= &proc_dointvec_minmax,
+-		.strategy	= &sysctl_intvec,
+ 		.extra1		= &min_slot_table_size,
+ 		.extra2		= &max_slot_table_size
+ 	},
+ 	{
+-		.ctl_name       = CTL_UNNUMBERED,
+ 		.procname	= "rdma_max_inline_read",
+ 		.data		= &xprt_rdma_max_inline_read,
+ 		.maxlen		= sizeof(unsigned int),
+ 		.mode		= 0644,
+ 		.proc_handler	= &proc_dointvec,
+-		.strategy	= &sysctl_intvec,
+ 	},
+ 	{
+-		.ctl_name       = CTL_UNNUMBERED,
+ 		.procname	= "rdma_max_inline_write",
+ 		.data		= &xprt_rdma_max_inline_write,
+ 		.maxlen		= sizeof(unsigned int),
+ 		.mode		= 0644,
+ 		.proc_handler	= &proc_dointvec,
+-		.strategy	= &sysctl_intvec,
+ 	},
+ 	{
+-		.ctl_name       = CTL_UNNUMBERED,
+ 		.procname	= "rdma_inline_write_padding",
+ 		.data		= &xprt_rdma_inline_write_padding,
+ 		.maxlen		= sizeof(unsigned int),
+ 		.mode		= 0644,
+ 		.proc_handler	= &proc_dointvec_minmax,
+-		.strategy	= &sysctl_intvec,
+ 		.extra1		= &zero,
+ 		.extra2		= &max_padding,
+ 	},
+ 	{
+-		.ctl_name       = CTL_UNNUMBERED,
+ 		.procname	= "rdma_memreg_strategy",
+ 		.data		= &xprt_rdma_memreg_strategy,
+ 		.maxlen		= sizeof(unsigned int),
+ 		.mode		= 0644,
+ 		.proc_handler	= &proc_dointvec_minmax,
+-		.strategy	= &sysctl_intvec,
+ 		.extra1		= &min_memreg,
+ 		.extra2		= &max_memreg,
+ 	},
+ 	{
+-		.ctl_name       = CTL_UNNUMBERED,
+ 		.procname	= "rdma_pad_optimize",
+ 		.data		= &xprt_rdma_pad_optimize,
+ 		.maxlen		= sizeof(unsigned int),
+ 		.mode		= 0644,
+ 		.proc_handler	= &proc_dointvec,
+ 	},
+-	{
+-		.ctl_name = 0,
+-	},
++	{ },
+ };
+ 
+ static ctl_table sunrpc_table[] = {
+ 	{
+-		.ctl_name	= CTL_SUNRPC,
+ 		.procname	= "sunrpc",
+ 		.mode		= 0555,
+ 		.child		= xr_tunables_table
+ 	},
+-	{
+-		.ctl_name = 0,
+-	},
++	{ },
+ };
+ 
+ #endif
+@@ -168,47 +152,24 @@ static struct rpc_xprt_ops xprt_rdma_pro
+ static void
+ xprt_rdma_format_addresses(struct rpc_xprt *xprt)
+ {
+-	struct sockaddr_in *addr = (struct sockaddr_in *)
+-					&rpcx_to_rdmad(xprt).addr;
+-	char *buf;
+-
+-	buf = kzalloc(20, GFP_KERNEL);
+-	if (buf)
+-		snprintf(buf, 20, "%pI4", &addr->sin_addr.s_addr);
+-	xprt->address_strings[RPC_DISPLAY_ADDR] = buf;
+-
+-	buf = kzalloc(8, GFP_KERNEL);
+-	if (buf)
+-		snprintf(buf, 8, "%u", ntohs(addr->sin_port));
+-	xprt->address_strings[RPC_DISPLAY_PORT] = buf;
++	struct sockaddr *sap = (struct sockaddr *)
++		&rpcx_to_rdmad(xprt).addr;
++	struct sockaddr_in *sin = (struct sockaddr_in *)sap;
++	char buf[64];
++
++	(void)rpc_ntop(sap, buf, sizeof(buf));
++	xprt->address_strings[RPC_DISPLAY_ADDR] = kstrdup(buf, GFP_KERNEL);
++
++	snprintf(buf, sizeof(buf), "%u", rpc_get_port(sap));
++	xprt->address_strings[RPC_DISPLAY_PORT] = kstrdup(buf, GFP_KERNEL);
+ 
+ 	xprt->address_strings[RPC_DISPLAY_PROTO] = "rdma";
+ 
+-	buf = kzalloc(48, GFP_KERNEL);
+-	if (buf)
+-		snprintf(buf, 48, "addr=%pI4 port=%u proto=%s",
+-			&addr->sin_addr.s_addr,
+-			ntohs(addr->sin_port), "rdma");
+-	xprt->address_strings[RPC_DISPLAY_ALL] = buf;
+-
+-	buf = kzalloc(10, GFP_KERNEL);
+-	if (buf)
+-		snprintf(buf, 10, "%02x%02x%02x%02x",
+-			NIPQUAD(addr->sin_addr.s_addr));
+-	xprt->address_strings[RPC_DISPLAY_HEX_ADDR] = buf;
+-
+-	buf = kzalloc(8, GFP_KERNEL);
+-	if (buf)
+-		snprintf(buf, 8, "%4hx", ntohs(addr->sin_port));
+-	xprt->address_strings[RPC_DISPLAY_HEX_PORT] = buf;
+-
+-	buf = kzalloc(30, GFP_KERNEL);
+-	if (buf)
+-		snprintf(buf, 30, "%pI4.%u.%u",
+-			&addr->sin_addr.s_addr,
+-			ntohs(addr->sin_port) >> 8,
+-			ntohs(addr->sin_port) & 0xff);
+-	xprt->address_strings[RPC_DISPLAY_UNIVERSAL_ADDR] = buf;
++	snprintf(buf, sizeof(buf), "%08x", ntohl(sin->sin_addr.s_addr));
++	xprt->address_strings[RPC_DISPLAY_HEX_ADDR] = kstrdup(buf, GFP_KERNEL);
++
++	snprintf(buf, sizeof(buf), "%4hx", rpc_get_port(sap));
++	xprt->address_strings[RPC_DISPLAY_HEX_PORT] = kstrdup(buf, GFP_KERNEL);
+ 
+ 	/* netid */
+ 	xprt->address_strings[RPC_DISPLAY_NETID] = "rdma";
+@@ -343,7 +304,6 @@ xprt_setup_rdma(struct xprt_create *args
+ 	/* 60 second timeout, no retries */
+ 	xprt->timeout = &xprt_rdma_default_timeout;
+ 	xprt->bind_timeout = (60U * HZ);
+-	xprt->connect_timeout = (60U * HZ);
+ 	xprt->reestablish_timeout = (5U * HZ);
+ 	xprt->idle_timeout = (5U * 60 * HZ);
+ 
+@@ -715,7 +675,7 @@ xprt_rdma_send_request(struct rpc_task *
+ 	if (rpcrdma_ep_post(&r_xprt->rx_ia, &r_xprt->rx_ep, req))
+ 		goto drop_connection;
+ 
+-	task->tk_bytes_sent += rqst->rq_snd_buf.len;
++	rqst->rq_xmit_bytes_sent += rqst->rq_snd_buf.len;
+ 	rqst->rq_bytes_sent = 0;
+ 	return 0;
+ 
-- 
1.7.7


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
