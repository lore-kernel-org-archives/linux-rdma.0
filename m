From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 11/13] opensm/man/opensm.8.in: Add references to
 torus-2QoS.
Date: Fri, 12 Nov 2010 15:11:20 -0700
Message-ID: <1289599882-15165-12-git-send-email-jaschut@sandia.gov>
References: <1289599882-15165-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289599882-15165-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/man/opensm.8.in |   29 ++++++++++++++++++++++++++---
 1 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/opensm/man/opensm.8.in b/opensm/man/opensm.8.in
index 47dff99..c021026 100644
--- a/opensm/man/opensm.8.in
+++ b/opensm/man/opensm.8.in
@@ -1,4 +1,4 @@
-.TH OPENSM 8 "October 22, 2009" "OpenIB" "OpenIB Management"
+.TH OPENSM 8 "November 3, 2010" "OpenIB" "OpenIB Management"
 
 .SH NAME
 opensm \- InfiniBand subnet manager and administration (SM/SA)
@@ -51,6 +51,7 @@ opensm \- InfiniBand subnet manager and administration (SM/SA)
 [\-\-prefix_routes_file <path>]
 [\-\-consolidate_ipv6_snm_req]
 [\-\-log_prefix <prefix text>]
+[\-\-torus_config <path to file>]
 [\-v(erbose)] [\-V] [\-D <flags>] [\-d(ebug) <number>]
 [\-h(elp)] [\-?]
 
@@ -148,8 +149,10 @@ LID assignments resolving multiple use of same LID.
 This option chooses routing engine(s) to use instead of Min Hop
 algorithm (default).  Multiple routing engines can be specified
 separated by commas so that specific ordering of routing algorithms
-will be tried if earlier routing engines fail.
-Supported engines: minhop, updn, file, ftree, lash, dor
+will be tried if earlier routing engines fail.  If all configured
+routing engines fail, OpenSM will always attempt to route with Min Hop
+unless 'no_fallback' is included in the list of routing engines.
+Supported engines: minhop, updn, file, ftree, lash, dor, torus-2QoS.
 .TP
 \fB\-\-do_mesh_analysis\fR
 This option enables additional analysis for the lash routing engine to
@@ -364,6 +367,11 @@ when two or more instances of OpenSM run in a single node to manage multiple
 fabrics. For example, in a dual-fabric (or dual-rail) IB cluster, the prefix
 for the first fabric could be "mpi" and the other fabric could be "storage".
 .TP
+\fB\-\-torus_config\fR <path to torus\-2QoS config file>
+This option defines the file name for the extra configuration
+information needed for the torus-2QoS routing engine.   The default
+name is \fB\%@OPENSM_CONFIG_DIR@/@TORUS2QOS_CONF_FILE@\fP
+.TP
 \fB\-v\fR, \fB\-\-verbose\fR
 This option increases the log verbosity level.
 The -v option may be specified multiple times
@@ -1004,6 +1012,14 @@ along the mesh dimension, or the -O option used as an override.
 
 Use '-R dor' option to activate the DOR algorithm.
 
+Torus-2QoS Routing Algorithm
+
+Torus-2QoS is routing algorithm designed for large-scale 2D/3D torus fabrics;
+see torus-2QoS(8) for full documentation.
+
+Use '-R torus-2QoS -Q' or '-R torus-2QoS,no_fallback -Q'
+to activate the torus-2QoS algorithm.
+
 
 Routing References
 
@@ -1113,6 +1129,10 @@ default QOS policy config file
 .B @OPENSM_CONFIG_DIR@/@PREFIX_ROUTES_FILE@
 default prefix routes file.
 
+.TP
+.B @OPENSM_CONFIG_DIR@/@TORUS2QOS_CONF_FILE@
+default torus-2QoS config file.
+
 .SH AUTHORS
 .TP
 Hal Rosenstock
@@ -1135,3 +1155,6 @@ Ira Weiny
 .TP
 Dale Purdy
 .RI < purdy-sJ/iWh9BUns@public.gmane.org >
+
+.SH SEE ALSO
+torus-2QoS(8), torus-2QoS.conf(5).
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
