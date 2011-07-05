From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/current-routing.txt: Add DnUp description
Date: Tue, 05 Jul 2011 07:33:20 -0400
Message-ID: <4E12F680.5040404@dev.mellanox.co.il>
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
diff --git a/doc/current-routing.txt b/doc/current-routing.txt
index 5048c55..ac00d13 100644
--- a/doc/current-routing.txt
+++ b/doc/current-routing.txt
@@ -1,7 +1,7 @@
 Current OpenSM Routing
-10/9/09
+7/4/11
 
-OpenSM offers six routing engines:
+OpenSM offers seven routing engines:
 
 1.  Min Hop Algorithm - based on the minimum hops to each node where the
 path length is optimized.
@@ -11,24 +11,28 @@ node, but it is constrained to ranking rules. This algorithm should be chosen
 if the subnet is not a pure Fat Tree, and deadlock may occur due to a
 loop in the subnet.
 
-3.  Fat-tree Unicast routing algorithm - this algorithm optimizes routing
+3. DNUP Unicast routing algorithm - similar to UPDN but allows routing in
+fabrics which have some CA nodes attached closer to the roots than some switch
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
@@ -192,6 +196,20 @@ To learn more about deadlock-free routing, see the article
 by William J Dally and Charles L Seitz (1985).
 
 
+Purpose of DNUP Algorithm
+
+The DNUP algorithm is designed to serve a similar purpose to UPDN. However
+it is intended to work in network topologies which are unsuited to
+UPDN due to nodes being connected closer to the roots than some of
+the switches.  An example would be a fabric which contains nodes and
+uplinks connected to the same switch. The operation of DNUP is the
+same as UPDN with the exception of the ranking process.  In DNUP all
+switch nodes are ranked based solely on their distance from CA Nodes,
+all switch nodes directly connected to at least one CA are assigned a
+value of 1 all other switch nodes are assigned a value of one more than
+the minimum rank of all neighbor switch nodes.
+
+
 Fat-tree Routing Algorithm
 --------------------------
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
