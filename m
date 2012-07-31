From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 01/27] opensm/torus-2QoS: Fix some typos in documentation
Date: Tue, 31 Jul 2012 19:04:29 +0300
Message-ID: <1343750695-28063-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 doc/current-routing.txt | 6 +++---
 man/torus-2QoS.8.in     | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/doc/current-routing.txt b/doc/current-routing.txt
index 8cc5154..495a0d2 100644
--- a/doc/current-routing.txt
+++ b/doc/current-routing.txt
@@ -696,7 +696,7 @@ broken by a failure, as in the above example.
 
 Torus Topolgy Discovery:
 
-The algorithm used by torus-2QoS to contruct the torus topology from the
+The algorithm used by torus-2QoS to construct the torus topology from the
 undirected graph representing the fabric requires that the radix of each
 dimension be configured via torus-2QoS.conf. It also requires that the
 torus topology be "seeded"; for a 3D torus this requires configuring four
@@ -710,7 +710,7 @@ links to find the one that is consistent with a face of the cube of switch
 locations, and adds its swiches to the discovered topology in the correct
 locations.
 
-Because the algorithm is based on examing the topology of 4-loops of links,
+Because the algorithm is based on examining the topology of 4-loops of links,
 a torus with one or more radix-4 dimensions requires extra initial seed
 configuration.  See torus-2QoS.conf(5) for details. Torus-2QoS will detect
 and report when it has insufficient configuration for a torus with radix-4
@@ -718,7 +718,7 @@ dimensions.
 
 In the event the torus is significantly degraded, i.e., there are many
 missing switches or links, it may happen that torus-2QoS is unable to place
-into the torus some switches and/or links that were discoverd in the
+into the torus some switches and/or links that were discovered in the
 fabric, and will generate a warning in that case.  A similar condition
 occurs if torus-2QoS is misconfigured, i.e., the radix of a torus dimension
 as configured does not match the radix of that torus dimension as wired,
diff --git a/man/torus-2QoS.8.in b/man/torus-2QoS.8.in
index c14278a..be74f26 100644
--- a/man/torus-2QoS.8.in
+++ b/man/torus-2QoS.8.in
@@ -348,7 +348,7 @@ broken by a failure, as in the above example.
 .
 .SH TORUS TOPOLOGY DISCOVERY
 .
-The algorithm used by torus-2QoS to contruct the torus topology from
+The algorithm used by torus-2QoS to construct the torus topology from
 the undirected graph representing the fabric requires that the radix of
 each dimension be configured via torus-2QoS.conf.
 It also requires that the torus topology be "seeded"; for a 3D torus this
@@ -363,7 +363,7 @@ locations, the algorithm examines 4-loops of inter-switch links to find the
 one that is consistent with a face of the cube of switch locations,
 and adds its swiches to the discovered topology in the correct locations.
 .P
-Because the algorithm is based on examing the topology of 4-loops of links,
+Because the algorithm is based on examining the topology of 4-loops of links,
 a torus with one or more radix-4 dimensions requires extra initial
 seed configuration.
 See torus-2QoS.conf(5) for details.
@@ -372,7 +372,7 @@ for a torus with radix-4 dimensions.
 .P
 In the event the torus is significantly degraded, \fIi.e.\fR, there are
 many missing switches or links, it may happen that torus-2QoS is unable
-to place into the torus some switches and/or links that were discoverd
+to place into the torus some switches and/or links that were discovered
 in the fabric, and will generate a warning in that case.
 A similar condition occurs if torus-2QoS is misconfigured, \fIi.e.\fR,
 the radix of a torus dimension as configured does not match the radix
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
