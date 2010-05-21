From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl-2.0: update dat.conf manpage for static configuration
 options
Date: Fri, 21 May 2010 14:31:13 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C713A292@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Update dat.conf manpage to explain options for different providers and devices

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

diff --git a/man/dat.conf.5 b/man/dat.conf.5
index 6dee668..8360e92 100644
--- a/man/dat.conf.5
+++ b/man/dat.conf.5
@@ -45,18 +45,63 @@ entry is termed Static Registration.
         - ia params, IA specific parameters - device name and port
         - platform params, (not used) 
 .PP
-.SH Example netdev entries for OpenFabrics rdma_cm providers, both v1.2 and v2.0 
+.SH OpenFabrics RDMA providers: 
 \br 
+    Provider options for both 1.2 and 2.0, each using different CM services
+
+        1. cma - OpenFabrics rdma_cm    - uses rdma_cm services for connections
+                                        - requires IPoIB and SA/SM services for IB
+                                        - netdev used for device name, without port designation (ia_params) 
+                                        - Supports any transport rdma_cm supports including IB, iWARP, RoCEE
+                                        - libdaplcma.so (1.2), libdaplofa (2.0)
+
+        2. scm - uDAPL socket based CM  - exchanges CM information over sockets 
+                                        - eliminates the need for rdma_cm, IPoIB, and SA for IB
+                                        - verbs device used for device name with port designation (ia_param)
+                                        - Supports IB, RoCEE. Doesn't support iWARP
+                                        - libdaplscm.so (1.2), libdaploscm (2.0)
+
+        3. ucm - uDAPL unreliable IB CM - exchanges CM information via IB UD QP's
+                                        - eliminates the need for sockets or rdma_cm
+                                        - verbs device used for device name with port designation (ia_param)
+                                        - Supports IB only, no name service. 
+                                        - libdaplucm.so (1.2), libdaploucm (2.0)
+.PP
+.SH Example entries for each OpenFabrics provider 
+\br 
+
+        1. cma - OpenFarbrics rdma_cm (v1.2 and v2.0 examples)
+
         OpenIB-cma u1.2 nonthreadsafe default libdaplcma.so.1 dapl.1.2 "ib0 0" ""
         ofa-v2-ib0 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 "ib0 0" ""
+        ofa-v2-iwarp u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 "eth2 0" ""
+        ofa-v2-cma-roe-eth2 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 "eth2 0" ""
+        ofa-v2-cma-roe-eth3 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 "eth3 0" ""
 
-        NOTE: The OpenFabrics providers use <ia_params> to specify the device with one of the following:
+        NOTE: The OpenFabrics CMA providers use <ia_params> to specify the device with one of the following:
               network address, network hostname, or netdev name; along with port number.
 
-              The OpenIB- and ofa-v2- IA names are unique mappings. Reserved for OpenFabrics providers. 
+        2. scm - uDAPL socket based CM (v1.2 and v2.0 examples)
+
+        OpenIB-mlx4_0-1 u1.2 nonthreadsafe default libdaplscm.so.1 dapl.1.2 "mlx4_0 1" ""
+        OpenIB-ipath0-1 u1.2 nonthreadsafe default libdaplscm.so.1 dapl.1.2 "ipath0 1" ""
+        ofa-v2-mlx4_0-1 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 "mlx4_0 1" ""
+        ofa-v2-mlx4_0-2 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 "mlx4_0 2" ""
+        ofa-v2-mlx4_1-1 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 "mlx4_1 1" ""
+        ofa-v2-ehca0-1 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 "ehca0 1" ""
+
+        3. ucm - uDAPL unreliable IB CM  (not supported in 1.2, v2.0 examples)
+
+        ofa-v2-mlx4_0-1u u2.0 nonthreadsafe default libdaploucm.so.2 dapl.2.0 "mlx4_0 1" ""
+        ofa-v2-mlx4_0-2u u2.0 nonthreadsafe default libdaploucm.so.2 dapl.2.0 "mlx4_0 2" ""
+        ofa-v2-ipath0-1u u2.0 nonthreadsafe default libdaploucm.so.2 dapl.2.0 "ipath0 1" ""
+        ofa-v2-ehca0-1u u2.0 nonthreadsafe default libdaploucm.so.2 dapl.2.0 "ehca0 1" ""
+
+        Note: OpenIB- and ofa-v2- IA names are unique mappings, reserved for OpenFabrics providers.
+.PP
+The default location for this configuration file is /etc/dat.conf.
 .PP
-The default location for this configuration file is /etc/dat.conf. 
 The file location may be overridden with the environment variable DAT_OVERRIDE=/your_own_directory/your_dat.conf. 
 .PP
-.SH "SEE ALSO"
+.SH "SEE ALSO" rdma_cm verbs socket
 .PP
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
