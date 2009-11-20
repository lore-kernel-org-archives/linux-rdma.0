From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 11/11] opensm: Update documentation to describe
 torus-2QoS.
Date: Fri, 20 Nov 2009 12:15:09 -0700
Message-ID: <1258744509-11148-11-git-send-email-jaschut@sandia.gov>
References: <1258744509-11148-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1258744509-11148-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/doc/current-routing.txt |  154 +++++++++++++++++++++++++++++++++++++++-
 opensm/man/opensm.8.in         |    9 ++-
 2 files changed, 160 insertions(+), 3 deletions(-)

diff --git a/opensm/doc/current-routing.txt b/opensm/doc/current-routing.txt
index 1302860..141d793 100644
--- a/opensm/doc/current-routing.txt
+++ b/opensm/doc/current-routing.txt
@@ -1,7 +1,7 @@
 Current OpenSM Routing
-7/9/07
+10/9/09
 
-OpenSM offers five routing engines:
+OpenSM offers six routing engines:
 
 1.  Min Hop Algorithm - based on the minimum hops to each node where the
 path length is optimized.
@@ -28,6 +28,13 @@ two switches.  This provides deadlock free routes for hypercubes when
 the fabric is cabled as a hypercube and for meshes when cabled as a
 mesh (see details below).
 
+6. Torus-2QoS unicast routing algorithm - a DOR-based routing algorithm
+specialized for 2D/3D torus topologies.  Torus-2QoS provides deadlock-free
+routing while supporting two quality of service (QoS) levels.  In addition
+it is able to route around multiple failed fabric links or a single failed
+fabric switch without introducing deadlocks, and without changing path SL
+values granted before the failure.
+
 OpenSM provides an optional unicast routing cache (enabled by -A or
 --ucast_cache options). When enabled, unicast routing cache prevents
 routing recalculation (which is a heavy task in a large cluster) when
@@ -388,3 +395,146 @@ ports, one port on one end of the cable, and the other port on the
 other end, continuing along the mesh dimension.
 
 Use '-R dor' option to activate the DOR algorithm.
+
+Torus-2QoS Routing Algorithm
+----------------------------
+
+Torus-2QoS is routing algorithm designed for large-scale 2D/3D torus fabrics.
+
+It is a DOR-based algorithm that avoids deadlocks that would otherwise
+occur in a torus using the concept of a dateline for each torus dimension.
+It encodes into a path SL which datelines the path crosses as follows:
+
+  sl = 0;
+  for (d = 0; d < torus_dimensions; d++)
+    /* path_crosses_dateline(d) returns 0 or 1 */
+    sl |= path_crosses_dateline(d) << d;
+
+For a 3D torus, that leaves one SL bit free, which torus-2QoS uses to
+implement two QoS levels.
+
+This is possible because torus-2QoS also makes use of the output port
+dependence of the switch SL2VL maps.  It computes in which torus coordinate
+direction each interswitch link "points", and writes SL2VL maps for such
+ports as follows:
+
+  for (sl = 0; sl < 16; sl ++)
+    /* cdir(port) reports which torus coordinate direction a switch port
+     * "points" in, and returns 0, 1, or 2 */
+    sl2vl(iport,oport,sl) = 0x1 & (sl >> cdir(oport));
+
+Thus torus-2QoS consumes 8 SL values (SL bits 0-2) and 2 VL values (VL bit 0)
+ per QoS level to provide deadlock-free routing on a 3D torus.
+
+Torus-2QoS routes around link failure by "taking the long way around" any
+1D ring interrupted by a link failure.  For example, consider the 2D 6x5
+torus below, where switches are denoted by [+a-zA-Z]:
+
+        |    |    |    |    |    |
+   4  --+----+----+----+----+----+--
+        |    |    |    |    |    |
+   3  --+----+----+----D----+----+--
+        |    |    |    |    |    |
+   2  --+----+----I----r----+----+--
+        |    |    |    |    |    |
+   1  --m----S----n----T----o----p--
+        |    |    |    |    |    |
+ y=0  --+----+----+----+----+----+--
+        |    |    |    |    |    |
+
+      x=0    1    2    3    4    5
+
+For a pristine fabric the path from S to D would be S-n-T-r-d.  In the
+event that either link S-n or n-T has failed, torus-2QoS would use the path
+S-m-p-o-T-r-D.  Note that it can do this without changing the path SL
+value; once the 1D ring m-S-n-T-o-p-m has been broken by failure, path
+segments using it cannot contribute to deadlock, and the x-direction
+dateline (between, say, x=5 and x=0) can be ignored for path segments on
+that ring.
+
+One result of this is that torus-2QoS can route around many simultaneous
+link failures, as long as no 1D ring is broken into disjoint regions.  For
+example, if links n-T and T-o have both failed, that ring has been broken
+into two disjoint regions, T and o-p-m-S-n.  Torus-2QoS checks for such
+issues, reports if they are found, and refuses to route such fabrics.
+
+Handling a failed switch under DOR requires introducing into a path at
+least one turn that would be otherwise "illegal", i.e. not allowed by DOR
+rules.  Torus-2QoS will introduce such a turn as close as possible to the
+failed switch in order to route around it.
+
+In the above example, suppose switch T has failed, and consider the path
+from S to D.  Torus-2QoS will produce the path S-n-I-r-D, rather than the
+S-n-T-r-D path for a pristine torus, by introducing an early turn at n.
+For traffic arriving at switch I from n, normal DOR rules will generate an
+illegal turn in the path from S to D at I, and a legal turn at r.
+
+Torus-2QoS will also use the input port dependence of SL2VL maps to set VL
+bit 1 (which would be otherwise unused) for y-x, z-x, and z-y turns, i.e.,
+those turns that are illegal under DOR.  This causes the first hop after
+any such turn to use a separate set of VL values, and prevents deadlock in
+the presence of a single failed switch.
+
+For any given path, only the hops after a turn that is illegal under DOR
+can contribute to a credit loop that leads to deadlock.  So in the example
+above with failed switch T, the location of the illegal turn at I in the
+path from S to D requires that any credit loop caused by that turn must
+encircle the failed switch at T.  Thus the second and later hops after the
+illegal turn at I (i.e., hop r-D) cannot contribute to a credit loop
+because they cannot be used to construct a loop encircling T.  The hop I-r
+uses a separate VL, so it cannot contribute to a credit loop encircling T.
+
+Extending this argument shows that in addition to being capable of routing
+around a single switch failure without introducing deadlock, torus-2QoS can
+also route around multiple failed switches on the condition they are
+adjacent in the last dimension routed by DOR.  For example, consider the
+following case on a 6x6 2D torus:
+
+
+        |    |    |    |    |    |
+   5  --+----+----+----+----+----+--
+        |    |    |    |    |    |
+   4  --+----+----+----D----+----+--
+        |    |    |    |    |    |
+   3  --+----+----I----u----+----+--
+        |    |    |    |    |    |
+   2  --+----+----q----R----+----+--
+        |    |    |    |    |    |
+   1  --m----S----n----T----o----p--
+        |    |    |    |    |    |
+ y=0  --+----+----+----+----+----+--
+        |    |    |    |    |    |
+
+      x=0    1    2    3    4    5
+
+
+Suppose switches T and R have failed, and consider the path from S to D.
+Torus-2QoS will generate the path S-n-q-I-u-D, with an illegal turn at
+switch I, and with hop I-u using a VL with bit 1 set.
+
+As a further example, consider a case that torus-2QoS cannot route without
+deadlock: two failed switches adjacent in a dimension that is not the last
+dimension routed by DOR; here the failed switches are O and T:
+
+        |    |    |    |    |    |
+   5  --+----+----+----+----+----+--
+        |    |    |    |    |    |
+   4  --+----+----+----+----+----+--
+        |    |    |    |    |    |
+   3  --+----+----+----+----D----+--
+        |    |    |    |    |    |
+   2  --+----+----I----q----r----+--
+        |    |    |    |    |    |
+   1  --m----S----n----O----T----p--
+        |    |    |    |    |    |
+ y=0  --+----+----+----+----+----+--
+        |    |    |    |    |    |
+
+      x=0    1    2    3    4    5
+
+In a pristine fabric, torus-2QoS would generate the path from S to D as
+S-n-O-T-r-D.  With failed switches O and T, torus-2QoS will generate the
+path S-n-I-q-r-D, with illegal turn at switch I, and with hop I-q using a
+VL with bit 1 set.  In contrast to the earlier examples, the second hop
+after the illegal turn, q-r, can be used to construct a credit loop
+encircling the failed switches.
diff --git a/opensm/man/opensm.8.in b/opensm/man/opensm.8.in
index bd8ab4e..da016f1 100644
--- a/opensm/man/opensm.8.in
+++ b/opensm/man/opensm.8.in
@@ -630,7 +630,7 @@ compiling opensm with -DROUTER_EXP which has been obsoleted.
 
 .SH ROUTING
 .PP
-OpenSM now offers five routing engines:
+OpenSM now offers six routing engines:
 
 1.  Min Hop Algorithm - based on the minimum hops to each node where the
 path length is optimized.
@@ -659,6 +659,13 @@ two switches.  This provides deadlock free routes for hypercubes when
 the fabric is cabled as a hypercube and for meshes when cabled as a
 mesh (see details below).
 
+6. Torus-2QoS unicast routing algorithm - a DOR-based routing algorithm
+specialized for 2D/3D torus topologies.  Torus-2QoS provides deadlock-free
+routing while supporting two quality of service (QoS) levels.  In addition
+it is able to route around multiple failed fabric links or a single failed
+fabric switch without introducing deadlocks, and without changing path SL
+values granted before the failure.
+
 OpenSM also supports a file method which
 can load routes from a table. See \'Modular Routing Engine\' for more
 information on this.
-- 
1.5.6.GIT


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
