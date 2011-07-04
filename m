From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: dnup routing algorithm man page and documentation
 fixes
Date: Mon, 4 Jul 2011 11:35:04 +0300
Message-ID: <20110704083504.GD28114@calypso.voltaire.com>
References: <20110628210549.9131ABB2F74@cu0login3.emsl.pnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110628210549.9131ABB2F74-3GowgxBEfRkyPe/kX8gMlWWJnu75u/By@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ken Schmidt <kenneth.schmidt-Y2zl/4KMd60@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

1. Added DnUp routing engine description in doc/current-routing.txt
2. Tiny fixes to opensm man page and usage

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 doc/current-routing.txt |   48 +++++++++++++++++++++++++++++++++++++++++-----
 man/opensm.8.in         |   12 +++++-----
 opensm/main.c           |    2 +-
 3 files changed, 49 insertions(+), 13 deletions(-)

diff --git a/doc/current-routing.txt b/doc/current-routing.txt
index 5048c55..192b65f 100644
--- a/doc/current-routing.txt
+++ b/doc/current-routing.txt
@@ -1,7 +1,7 @@
 Current OpenSM Routing
-10/9/09
+28/6/11
 
-OpenSM offers six routing engines:
+OpenSM offers seven routing engines:
 
 1.  Min Hop Algorithm - based on the minimum hops to each node where the
 path length is optimized.
@@ -11,24 +11,28 @@ node, but it is constrained to ranking rules. This algorithm should be chosen
 if the subnet is not a pure Fat Tree, and deadlock may occur due to a
 loop in the subnet.
 
-3.  Fat-tree Unicast routing algorithm - this algorithm optimizes routing
+3.  DNUP Unicast routing algorithm - similar to UPDN but allows routing in
+fabrics which have some Ca nodes attached closer to the roots than some switch
+nodes.
+
+4.  Fat-tree Unicast routing algorithm - this algorithm optimizes routing
 of fat-trees for congestion-free "shift" communication pattern.
 It should be chosen if a subnet is a symmetrical fat-tree.
 Similar to UPDN routing, Fat-tree routing is credit-loop-free.
 
-4. LASH unicast routing algorithm - uses Infiniband virtual layers
+5. LASH unicast routing algorithm - uses Infiniband virtual layers
 (SL) to provide deadlock-free shortest-path routing while also
 distributing the paths between layers. LASH is an alternative
 deadlock-free topology-agnostic routing algorithm to the non-minimal
 UPDN algorithm avoiding the use of a potentially congested root node.
 
-5. DOR Unicast routing algorithm - based on the Min Hop algorithm, but
+6. DOR Unicast routing algorithm - based on the Min Hop algorithm, but
 avoids port equalization except for redundant links between the same
 two switches.  This provides deadlock free routes for hypercubes when
 the fabric is cabled as a hypercube and for meshes when cabled as a
 mesh (see details below).
 
-6. Torus-2QoS unicast routing algorithm - a DOR-based routing algorithm
+7. Torus-2QoS unicast routing algorithm - a DOR-based routing algorithm
 specialized for 2D/3D torus topologies.  Torus-2QoS provides deadlock-free
 routing while supporting two quality of service (QoS) levels.  In addition
 it is able to route around multiple failed fabric links or a single failed
@@ -192,6 +196,38 @@ To learn more about deadlock-free routing, see the article
 by William J Dally and Charles L Seitz (1985).
 
 
+DNUP Routing Algorithm
+----------------------
+
+Purpose:
+
+Down/Up routing algorithm operates in a very similar fashion to UPDN, but
+is modified to allow optimal routing on certain network structures in
+which uplinks and CA nodes are connected to the same switch nodes. (For
+example Chinook at EMSL and RoadRunner at LANL.) In these networks the
+optimal paths between nodes connected to a single chassis would remain
+within the chassis.  However due to the uplinks being connected at the
+same level of the network as the CA nodes UPDN will not allow these paths
+to be used for communication between the CA nodes.
+
+Down/Up follows the same procedure as UPDN with a few differences.  Ranking
+is based solely on the relative distance from CA nodes, any switch node
+with a CA node directly attached is assigned a rank of 0 any switch
+node without a CA node attached is assigned a rank of one greater than
+the minimum rank of their neighbors. Transitions are also reversed;
+The initial direction is down and only one transition to up
+is allowed.  There is also an option which relaxes this restriction to
+allow communication with switches nodes similar to the functionality of
+connect_roots in UPDN.
+
+DNUP Algorithm Usage
+
+Activation through OpenSM
+
+Use '-R dnup' option to activate the DNUP algorithm.
+Use '--connect_roots' option to connect nodes which violate the DNUP criteria.
+
+
 Fat-tree Routing Algorithm
 --------------------------
 
diff --git a/man/opensm.8.in b/man/opensm.8.in
index 74a4d33..e281157 100644
--- a/man/opensm.8.in
+++ b/man/opensm.8.in
@@ -692,7 +692,7 @@ compiling opensm with -DROUTER_EXP which has been obsoleted.
 
 .SH ROUTING
 .PP
-OpenSM now offers six routing engines:
+OpenSM now offers seven routing engines:
 
 1.  Min Hop Algorithm - based on the minimum hops to each node where the
 path length is optimized.
@@ -702,30 +702,30 @@ node, but it is constrained to ranking rules. This algorithm should be chosen
 if the subnet is not a pure Fat Tree, and deadlock may occur due to a
 loop in the subnet.
 
-3. DNUP Unicast routing algorithm - similar to UPDN but allows routing in
+3.  DNUP Unicast routing algorithm - similar to UPDN but allows routing in
 fabrics which have some Ca nodes attached closer to the roots than some switch
 nodes.
 
-3.  Fat Tree Unicast routing algorithm - this algorithm optimizes routing
+4.  Fat Tree Unicast routing algorithm - this algorithm optimizes routing
 for congestion-free "shift" communication pattern.
 It should be chosen if a subnet is a symmetrical or almost symmetrical
 fat-tree of various types, not just K-ary-N-Trees: non-constant K, not
 fully staffed, any Constant Bisectional Bandwidth (CBB) ratio.
 Similar to UPDN, Fat Tree routing is constrained to ranking rules.
 
-4. LASH unicast routing algorithm - uses Infiniband virtual layers
+5. LASH unicast routing algorithm - uses Infiniband virtual layers
 (SL) to provide deadlock-free shortest-path routing while also
 distributing the paths between layers. LASH is an alternative
 deadlock-free topology-agnostic routing algorithm to the non-minimal
 UPDN algorithm avoiding the use of a potentially congested root node.
 
-5. DOR Unicast routing algorithm - based on the Min Hop algorithm, but
+6. DOR Unicast routing algorithm - based on the Min Hop algorithm, but
 avoids port equalization except for redundant links between the same
 two switches.  This provides deadlock free routes for hypercubes when
 the fabric is cabled as a hypercube and for meshes when cabled as a
 mesh (see details below).
 
-6. Torus-2QoS unicast routing algorithm - a DOR-based routing algorithm
+7. Torus-2QoS unicast routing algorithm - a DOR-based routing algorithm
 specialized for 2D/3D torus topologies.  Torus-2QoS provides deadlock-free
 routing while supporting two quality of service (QoS) levels.  In addition
 it is able to route around multiple failed fabric links or a single failed
diff --git a/opensm/main.c b/opensm/main.c
index 6fa767c..6ece03a 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -189,7 +189,7 @@ static void show_usage(void)
 	printf("--sm_sl <sl number>\n"
 	       "          Sets the SL to use to communicate with the SM/SA. Defaults to 0.\n\n");
 	printf("--connect_roots, -z\n"
-	       "          This option enforces routing engines (up/down and \n"
+	       "          This option enforces routing engines (up/down, down/up and \n"
 	       "          fat-tree) to make connectivity between root switches\n"
 	       "          and in this way be IBA compliant. In many cases,\n"
 	       "          this can violate \"pure\" deadlock free algorithm, so\n"
-- 
1.7.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
