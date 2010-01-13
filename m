From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: [PATCH 3/3] Add new port_space parameter to ko2iblnd module
Date: Wed, 13 Jan 2010 15:56:46 +0100
Message-ID: <20100113155646.2f786945@frecb007965>
References: <20100113154952.0f01aa1d@frecb007965>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100113154952.0f01aa1d@frecb007965>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


  This patch is only given as a reference.


Index: b/lnet/klnds/o2iblnd/o2iblnd.c
===================================================================
--- a/lnet/klnds/o2iblnd/o2iblnd.c
+++ b/lnet/klnds/o2iblnd/o2iblnd.c
@@ -2503,7 +2503,7 @@ kiblnd_startup (lnet_ni_t *ni)
                 ibdev->ibd_ifip = ip;
                 strcpy(&ibdev->ibd_ifname[0], ifname);
 
-                id = rdma_create_id(kiblnd_cm_callback, ibdev, RDMA_PS_TCP);
+                id = rdma_create_id(kiblnd_cm_callback, ibdev, *kiblnd_tunables.kib_port_space);
                 if (IS_ERR(id)) {
                         CERROR("Can't create listen ID: %ld\n", PTR_ERR(id));
                         goto failed;
Index: b/lnet/klnds/o2iblnd/o2iblnd.h
===================================================================
--- a/lnet/klnds/o2iblnd/o2iblnd.h
+++ b/lnet/klnds/o2iblnd/o2iblnd.h
@@ -125,6 +125,7 @@ typedef struct
 #if defined(CONFIG_SYSCTL) && !CFS_SYSFS_MODULE_PARM
         cfs_sysctl_table_header_t *kib_sysctl;  /* sysctl interface */
 #endif
+        int              *kib_port_space;       /* port space */
 } kib_tunables_t;
 
 extern kib_tunables_t  kiblnd_tunables;
Index: b/lnet/klnds/o2iblnd/o2iblnd_cb.c
===================================================================
--- a/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -1188,7 +1188,7 @@ kiblnd_connect_peer (kib_peer_t *peer)
         LASSERT (net != NULL);
         LASSERT (peer->ibp_connecting > 0);
 
-        cmid = rdma_create_id(kiblnd_cm_callback, peer, RDMA_PS_TCP);
+        cmid = rdma_create_id(kiblnd_cm_callback, peer, *kiblnd_tunables.kib_port_space);
         if (IS_ERR(cmid)) {
                 CERROR("Can't create CMID for %s: %ld\n",
                        libcfs_nid2str(peer->ibp_nid), PTR_ERR(cmid));
Index: b/lnet/klnds/o2iblnd/o2iblnd_modparams.c
===================================================================
--- a/lnet/klnds/o2iblnd/o2iblnd_modparams.c
+++ b/lnet/klnds/o2iblnd/o2iblnd_modparams.c
@@ -120,6 +120,10 @@ static int pmr_pool_size = 512;
 CFS_MODULE_PARM(pmr_pool_size, "i", int, 0444,
                 "size of the MR cache pmr pool");
 
+static int port_space = RDMA_PS_TCP;
+CFS_MODULE_PARM(port_space, "i", int, 0444,
+                "Port space");
+
 kib_tunables_t kiblnd_tunables = {
         .kib_service                = &service,
         .kib_cksum                  = &cksum,
@@ -141,6 +145,7 @@ kib_tunables_t kiblnd_tunables = {
         .kib_fmr_flush_trigger      = &fmr_flush_trigger,
         .kib_fmr_cache              = &fmr_cache,
         .kib_pmr_pool_size          = &pmr_pool_size,
+        .kib_port_space             = &port_space,
 };
 
 #if defined(CONFIG_SYSCTL) && !CFS_SYSFS_MODULE_PARM
@@ -169,7 +174,8 @@ enum {
         O2IBLND_FMR_POOL_SIZE,
         O2IBLND_FMR_FLUSH_TRIGGER,
         O2IBLND_FMR_CACHE,
-        O2IBLND_PMR_POOL_SIZE
+        O2IBLND_PMR_POOL_SIZE,
+        O2IBLND_PORT_SPACE
 };
 #else
 
@@ -193,6 +199,7 @@ enum {
 #define O2IBLND_FMR_FLUSH_TRIGGER CTL_UNNUMBERED
 #define O2IBLND_FMR_CACHE        CTL_UNNUMBERED
 #define O2IBLND_PMR_POOL_SIZE    CTL_UNNUMBERED
+#define O2IBLND_PORT_SPACE       CTL_UNNUMBERED
 
 #endif
 
@@ -358,6 +365,14 @@ static cfs_sysctl_table_t kiblnd_ctl_tab
                 .mode     = 0444,
                 .proc_handler = &proc_dointvec
         },
+        {
+                .ctl_name = O2IBLND_PORT_SPACE,
+                .procname = "port_space",
+                .data     = &port_space,
+                .maxlen   = sizeof(int),
+                .mode     = 0444,
+                .proc_handler = &proc_dointvec
+        },
         {0}
 };
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
