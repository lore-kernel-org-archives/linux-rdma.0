From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 13/13] opensm/doc/current-routing.txt: Sync torus-2QoS
 information with new man pages.
Date: Fri, 12 Nov 2010 15:11:22 -0700
Message-ID: <1289599882-15165-14-git-send-email-jaschut@sandia.gov>
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
 opensm/doc/current-routing.txt |  141 +++++++++++++++++++++++++++++++++++----
 1 files changed, 126 insertions(+), 15 deletions(-)

diff --git a/opensm/doc/current-routing.txt b/opensm/doc/current-routing.txt
index 4eaf861..5048c55 100644
--- a/opensm/doc/current-routing.txt
+++ b/opensm/doc/current-routing.txt
@@ -399,7 +399,7 @@ Use '-R dor' option to activate the DOR algorithm.
 Torus-2QoS Routing Algorithm
 ----------------------------
 
-Torus-2QoS is routing algorithm designed for large-scale 2D/3D torus fabrics.
+Torus-2QoS is a routing algorithm designed for large-scale 2D/3D torus fabrics.
 The torus-2QoS routing engine can provide the following functionality on
 a 2D/3D torus:
 - routing that is free of credit loops
@@ -411,6 +411,8 @@ a 2D/3D torus:
 - very short run times, with good scaling properties as fabric size
     increases
 
+Unicast Routing:
+
 Torus-2QoS is a DOR-based algorithm that avoids deadlocks that would otherwise
 occur in a torus using the concept of a dateline for each torus dimension.
 It encodes into a path SL which datelines the path crosses as follows:
@@ -423,17 +425,18 @@ It encodes into a path SL which datelines the path crosses as follows:
 For a 3D torus, that leaves one SL bit free, which torus-2QoS uses to
 implement two QoS levels.
 
-This is possible because torus-2QoS also makes use of the output port
-dependence of the switch SL2VL maps.  It computes in which torus coordinate
-direction each interswitch link "points", and writes SL2VL maps for such
-ports as follows:
+Torus-2QoS also makes use of the output port dependence of switch SL2VL
+maps to encode into one VL bit the information encoded in three SL bits.
+It computes in which torus coordinate direction each inter-switch link
+"points", and writes SL2VL maps for such ports as follows:
 
   for (sl = 0; sl < 16; sl ++)
     /* cdir(port) reports which torus coordinate direction a switch port
      * "points" in, and returns 0, 1, or 2 */
     sl2vl(iport,oport,sl) = 0x1 & (sl >> cdir(oport));
 
-Thus torus-2QoS consumes 8 SL values (SL bits 0-2) and 2 VL values (VL bit 0)
+Thus, on a pristine 3D torus, i.e., in the absence of failed fabric switches,
+torus-2QoS consumes 8 SL values (SL bits 0-2) and 2 VL values (VL bit 0)
 per QoS level to provide deadlock-free routing on a 3D torus.
 
 Torus-2QoS routes around link failure by "taking the long way around" any
@@ -454,7 +457,7 @@ torus below, where switches are denoted by [+a-zA-Z]:
 
       x=0    1    2    3    4    5
 
-For a pristine fabric the path from S to D would be S-n-T-r-d.  In the
+For a pristine fabric the path from S to D would be S-n-T-r-D.  In the
 event that either link S-n or n-T has failed, torus-2QoS would use the path
 S-m-p-o-T-r-D.  Note that it can do this without changing the path SL
 value; once the 1D ring m-S-n-T-o-p-m has been broken by failure, path
@@ -463,11 +466,19 @@ dateline (between, say, x=5 and x=0) can be ignored for path segments on
 that ring.
 
 One result of this is that torus-2QoS can route around many simultaneous
-link failures, as long as no 1D ring is broken into disjoint regions.  For
+link failures, as long as no 1D ring is broken into disjoint segments.  For
 example, if links n-T and T-o have both failed, that ring has been broken
-into two disjoint regions, T and o-p-m-S-n.  Torus-2QoS checks for such
+into two disjoint segments, T and o-p-m-S-n.  Torus-2QoS checks for such
 issues, reports if they are found, and refuses to route such fabrics.
 
+Note that in the case where there are multiple parallel links between a pair
+of switches, torus-2QoS will allocate routes across such links in a round-
+robin fashion, based on ports at the path destination switch that are active
+and not used for inter-switch links.  Should a link that is one of several
+such parallel links fail, routes are redistributed across the remaining
+links.   When the last of such a set of parallel links fails, traffic is
+rerouted as described above.
+
 Handling a failed switch under DOR requires introducing into a path at
 least one turn that would be otherwise "illegal", i.e. not allowed by DOR
 rules.  Torus-2QoS will introduce such a turn as close as possible to the
@@ -476,8 +487,9 @@ failed switch in order to route around it.
 In the above example, suppose switch T has failed, and consider the path
 from S to D.  Torus-2QoS will produce the path S-n-I-r-D, rather than the
 S-n-T-r-D path for a pristine torus, by introducing an early turn at n.
-For traffic arriving at switch I from n, normal DOR rules will generate an
-illegal turn in the path from S to D at I, and a legal turn at r.
+Normal DOR rules will cause traffic arriving at switch I to be forwarded
+to switch r; for traffic arriving from I due to the "early" turn at n,
+this will generate an "illegal" turn at I.
 
 Torus-2QoS will also use the input port dependence of SL2VL maps to set VL
 bit 1 (which would be otherwise unused) for y-x, z-x, and z-y turns, i.e.,
@@ -549,6 +561,8 @@ VL with bit 1 set.  In contrast to the earlier examples, the second hop
 after the illegal turn, q-r, can be used to construct a credit loop
 encircling the failed switches.
 
+Multicast Routing:
+
 Since torus-2QoS uses all four available SL bits, and the three data VL
 bits that are typically available in current switches, there is no way
 to use SL/VL values to separate multicast traffic from unicast traffic.
@@ -649,7 +663,104 @@ a branch that crosses a dateline.  However, again this cannot contribute
 to credit loops as it occurs on a 1D ring (the ring for x=3) that is
 broken by a failure, as in the above example.
 
-Due to the use made by torus-2QoS of SLs and VLs, QoS configuration should
-only employ SL values 0 and 8, for both multicast and unicast.  Also,
-SL to VL map configuration must be under the complete control of torus-2QoS,
-so any user-supplied configuration must and will be ignored.
+Torus Topolgy Discovery:
+
+The algorithm used by torus-2QoS to contruct the torus topology from the
+undirected graph representing the fabric requires that the radix of each
+dimension be configured via torus-2QoS.conf. It also requires that the
+torus topology be "seeded"; for a 3D torus this requires configuring four
+switches that define the three coordinate directions of the torus.
+
+Given this starting information, the algorithm is to examine the cube
+formed by the eight switch locations bounded by the corners (x,y,z) and
+(x+1,y+1,z+1).  Based on switches already placed into the torus topology at
+some of these locations, the algorithm examines 4-loops of interswitch
+links to find the one that is consistent with a face of the cube of switch
+locations, and adds its swiches to the discovered topology in the correct
+locations.
+
+Because the algorithm is based on examing the topology of 4-loops of links,
+a torus with one or more radix-4 dimensions requires extra initial seed
+configuration.  See torus-2QoS.conf(5) for details. Torus-2QoS will detect
+and report when it has insufficient configuration for a torus with radix-4
+dimensions.
+
+In the event the torus is significantly degraded, i.e., there are many
+missing switches or links, it may happen that torus-2QoS is unable to place
+into the torus some switches and/or links that were discoverd in the
+fabric, and will generate a warning in that case.  A similar condition
+occurs if torus-2QoS is misconfigured, i.e., the radix of a torus dimension
+as configured does not match the radix of that torus dimension as wired,
+and many switches/links in the fabric will not be placed into the torus.
+
+Quality Of Service Configuration:
+
+OpenSM will not program switchs and channel adapters with SL2VL maps or VL
+arbitration configuration unless it is invoked with -Q.  Since torus-2QoS
+depends on such functionality for correct operation, always invoke OpenSM
+with -Q when torus-2QoS is in the list of routing engines.
+
+Any quality of service configuration method supported by OpenSM will work
+with torus-2QoS, subject to the following limitations and considerations.
+
+For all routing engines supported by OpenSM except torus-2QoS, there is a
+one-to-one correspondence between QoS level and SL. Torus-2QoS can only
+support two quality of service levels, so only the high-order bit of any SL
+value used for unicast QoS configuration will be honored by torus-2QoS.
+
+For multicast QoS configuration, only SL values 0 and 8 should be used with
+torus-2QoS.
+
+Since SL to VL map configuration must be under the complete control of
+torus-2QoS, any configuration via qos_sl2vl, qos_swe_sl2vl, etc., must and
+will be ignored, and a warning will be generated.
+
+Torus-2QoS uses VL values 0-3 to implement one of its supported QoS levels,
+and VL values 4-7 to implement the other.  Hard-to-diagnose application
+issues may arise if traffic is not delivered fairly across each of these
+two VL ranges. Torus-2QoS will detect and warn if VL arbitration is
+configured unfairly across VLs in the range 0-3, and also in the range
+4-7. Note that the default OpenSM VL arbitration configuration does not
+meet this constraint, so all torus-2QoS users should configure VL
+arbitration via qos_vlarb_high, qos_vlarb_low, etc.
+
+Operational Considerations:
+
+Any routing algorithm for a torus IB fabric must employ path SL values to
+avoid credit loops. As a result, all applications run over such fabrics
+must perform a path record query to obtain the correct path SL for
+connection setup. Applications that use rdma_cm for connection setup will
+automatically meet this requirement.
+
+If a change in fabric topology causes changes in path SL values required to
+route without credit loops, in general all applications would need to
+repath to avoid message deadlock. Since torus-2QoS has the ability to
+reroute after a single switch failure without changing path SL values,
+repathing by running applications is not required when the fabric is routed
+with torus-2QoS.
+
+Torus-2QoS can provide unchanging path SL values in the presence of subnet
+manager failover provided that all OpenSM instances have the same idea of
+dateline location. See torus-2QoS.conf(5) for details.
+
+Torus-2QoS will detect configurations of failed switches and links that
+prevent routing that is free of credit loops, and will log warnings and
+refuse to route. If "no_fallback" was configured in the list of OpenSM
+routing engines, then no other routing engine will attempt to route the
+fabric. In that case all paths that do not transit the failed components
+will continue to work, and the subset of paths that are still operational
+will continue to remain free of credit loops. OpenSM will continue to
+attempt to route the fabric after every sweep interval, and after any
+change (such as a link up) in the fabric topology. When the fabric
+components are repaired, full functionality will be restored.
+
+In the event OpenSM was configured to allow some other engine to route the
+fabric if torus-2QoS fails, then credit loops and message deadlock are
+likely if torus-2QoS had previously routed the fabric successfully. Even if
+the other engine is capable of routing a torus without credit loops,
+applications that built connections with path SL values granted under
+torus-2QoS will likely experience message deadlock under routing generated
+by a different engine, unless they repath.
+
+To verify that a torus fabric is routed free of credit loops, use ibdmchk
+to analyze data collected via ibdiagnet -vlr.
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
