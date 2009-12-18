From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 12/12] opensm: Update documentation to describe
 torus-2QoS multicast support.
Date: Fri, 18 Dec 2009 13:51:01 -0700
Message-ID: <1261169461-2516-12-git-send-email-jaschut@sandia.gov>
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
 opensm/doc/current-routing.txt |  121 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 118 insertions(+), 3 deletions(-)

diff --git a/opensm/doc/current-routing.txt b/opensm/doc/current-routing.txt
index 141d793..78a2e01 100644
--- a/opensm/doc/current-routing.txt
+++ b/opensm/doc/current-routing.txt
@@ -400,8 +400,18 @@ Torus-2QoS Routing Algorithm
 ----------------------------
 
 Torus-2QoS is routing algorithm designed for large-scale 2D/3D torus fabrics.
-
-It is a DOR-based algorithm that avoids deadlocks that would otherwise
+The torus-2QoS routing engine can provide the following functionality on
+a 2D/3D torus:
+- routing that is free of credit loops
+- two levels of QoS, assuming switches support 8 data VLs
+- ability to route around a single failed switch, and/or multiple failed
+    links, without
+    - introducing credit loops
+    - changing path SL values
+- very short run times, with good scaling properties as fabric size
+    increases
+
+Torus-2QoS is a DOR-based algorithm that avoids deadlocks that would otherwise
 occur in a torus using the concept of a dateline for each torus dimension.
 It encodes into a path SL which datelines the path crosses as follows:
 
@@ -424,7 +434,7 @@ ports as follows:
     sl2vl(iport,oport,sl) = 0x1 & (sl >> cdir(oport));
 
 Thus torus-2QoS consumes 8 SL values (SL bits 0-2) and 2 VL values (VL bit 0)
- per QoS level to provide deadlock-free routing on a 3D torus.
+per QoS level to provide deadlock-free routing on a 3D torus.
 
 Torus-2QoS routes around link failure by "taking the long way around" any
 1D ring interrupted by a link failure.  For example, consider the 2D 6x5
@@ -538,3 +548,108 @@ path S-n-I-q-r-D, with illegal turn at switch I, and with hop I-q using a
 VL with bit 1 set.  In contrast to the earlier examples, the second hop
 after the illegal turn, q-r, can be used to construct a credit loop
 encircling the failed switches.
+
+Since torus-2QoS uses all four available SL bits, and the three data VL
+bits that are typically available in current switches, there is no way
+to use SL/VL values to separate multicast traffic from unicast traffic.
+Thus, torus-2QoS must generate multicast routing such that credit loops
+cannot arise from a combination of multicast and unicast path segments.
+
+It turns out that it is possible to construct spanning trees for multicast
+routing that have that property.  For the 2D 6x5 torus example above, here
+is the full-fabric spanning tree that torus-2QoS will construct, where "x"
+is the root switch and each "+" is a non-root switch:
+
+   4    +    +    +    +    +    +
+        |    |    |    |    |    |
+   3    +    +    +    +    +    +
+        |    |    |    |    |    |
+   2    +----+----+----x----+----+
+        |    |    |    |    |    |
+   1    +    +    +    +    +    +
+        |    |    |    |    |    |
+ y=0    +    +    +    +    +    +
+
+      x=0    1    2    3    4    5
+
+For multicast traffic routed from root to tip, every turn in the above
+spanning tree is a legal DOR turn.
+
+For traffic routed from tip to root, and some traffic routed through the
+root, turns are not legal DOR turns.  However, to construct a credit loop,
+the union of multicast routing on this spanning tree with DOR unicast
+routing can only provide 3 of the 4 turns needed for the loop.
+
+In addition, if none of the above spanning tree branches crosses a dateline
+used for unicast credit loop avoidance on a torus, and if multicast traffic
+is confined to SL 0 or SL 8 (recall that torus-2QoS uses SL bit 3 to
+differentiate QoS level), then multicast traffic also cannot contribute to
+the "ring" credit loops that are otherwise possible in a torus.
+
+Torus-2QoS uses these ideas to create a master spanning tree.  Every
+multicast group spanning tree will be constructed as a subset of the master
+tree, with the same root as the master tree.
+
+Such multicast group spanning trees will in general not be optimal for
+groups which are a subset of the full fabric. However, this compromise must
+be made to enable support for two QoS levels on a torus while preventing
+credit loops.
+
+In the presence of link or switch failures that result in a fabric for
+which torus-2QoS can generate credit-loop-free unicast routes, it is also
+possible to generate a master spanning tree for multicast that retains the
+required properties.  For example, consider that same 2D 6x5 torus, with
+the link from (2,2) to (3,2) failed.  Torus-2QoS will generate the following
+master spanning tree:
+
+   4    +    +    +    +    +    +
+        |    |    |    |    |    |
+   3    +    +    +    +    +    +
+        |    |    |    |    |    |
+   2  --+----+----+    x----+----+--
+        |    |    |    |    |    |
+   1    +    +    +    +    +    +
+        |    |    |    |    |    |
+ y=0    +    +    +    +    +    +
+
+      x=0    1    2    3    4    5
+
+Two things are notable about this master spanning tree.  First, assuming
+the x dateline was between x=5 and x=0, this spanning tree has a branch
+that crosses the dateline.  However, just as for unicast, crossing a
+dateline on a 1D ring (here, the ring for y=2) that is broken by a failure
+cannot contribute to a torus credit loop.
+
+Second, this spanning tree is no longer optimal even for multicast groups
+that encompass the entire fabric.  That, unfortunately, is a compromise that
+must be made to retain the other desirable properties of torus-2QoS routing.
+
+In the event that a single switch fails, torus-2QoS will generate a master
+spanning tree that has no "extra" turns by appropriately selecting a root
+switch.  In the 2D 6x5 torus example, assume now that the switch at (3,2),
+i.e. the root for a pristine fabric, fails.  Torus-2QoS will generate the
+following master spanning tree for that case:
+
+                       |
+   4    +    +    +    +    +    +
+        |    |    |    |    |    |
+   3    +    +    +    +    +    +
+        |    |    |         |    |
+   2    +    +    +         +    +
+        |    |    |         |    |
+   1    +----+----x----+----+----+
+        |    |    |    |    |    |
+ y=0    +    +    +    +    +    +
+                       |
+
+      x=0    1    2    3    4    5
+
+Assuming the y dateline was between y=4 and y=0, this spanning tree has
+a branch that crosses a dateline.  However, again this cannot contribute
+to credit loops as it occurs on a 1D ring (the ring for x=3) that is
+broken by a failure, as in the above example.
+
+Due to the use made by torus-2QoS of SLs and VLs, QoS configuration should
+only employ SL values 0 and 8, for both multicast and unicast.  Also,
+SL to VL map configuration must be under the complete control of torus-2QoS,
+so any user-supplied configuration must and will be ignored.
-- 
1.5.6.GIT


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
