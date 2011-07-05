From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/man/opensm.8.in: Fix some typos
Date: Tue, 05 Jul 2011 07:33:01 -0400
Message-ID: <4E12F66D.80102@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/man/opensm.8.in b/man/opensm.8.in
index 484cbad..9a1a9fe 100644
--- a/man/opensm.8.in
+++ b/man/opensm.8.in
@@ -669,7 +669,7 @@ compiling opensm with -DROUTER_EXP which has been obsoleted.
 
 .SH ROUTING
 .PP
-OpenSM now offers six routing engines:
+OpenSM now offers seven routing engines:
 
 1.  Min Hop Algorithm - based on the minimum hops to each node where the
 path length is optimized.
@@ -680,29 +680,29 @@ if the subnet is not a pure Fat Tree, and deadlock may occur due to a
 loop in the subnet.
 
 3. DNUP Unicast routing algorithm - similar to UPDN but allows routing in
-fabrics which have some Ca nodes attached closer to the roots than some switch
+fabrics which have some CA nodes attached closer to the roots than some switch
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
@@ -860,8 +860,8 @@ UPDN due to nodes being connected closer to the roots than some of
 the switches.  An example would be a fabric which contains nodes and
 uplinks connected to the same switch. The operation of DNUP is the
 same as UPDN with the exception of the ranking process.  In DNUP all
-switch nodes are ranked based solely on their distance from Ca Nodes,
-all switch nodes directly connected to at least one Ca are assigned a
+switch nodes are ranked based solely on their distance from CA Nodes,
+all switch nodes directly connected to at least one CA are assigned a
 value of 1 all other switch nodes are assigned a value of one more than
 the minimum rank of all neighbor switch nodes.
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
