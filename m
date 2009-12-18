From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 00/12] Add specialized multicast support to new torus
 routing engine: torus-2QoS
Date: Fri, 18 Dec 2009 13:50:50 -0700
Message-ID: <1261169461-2516-1-git-send-email-jaschut@sandia.gov>
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

This patch series adds specialized multicast support to torus-2QoS,
a new routing engine designed to handle large fabrics connected with a
2D/3D torus topology.  The original patch series adding torus-2QoS
can be found here: http://www.spinics.net/lists/linux-rdma/msg01438.html

This patch series is intended to be applied on top of the previous series.
Patches 1-7 are cleanup patches that fix issues in the previous series
that were discoverd during development of this series.  Patches 8-9 are
preparation patches that make it possible for a routing engine to 
generate spanning trees for multicast groups.  Patches 10-12 implement
the specialized multicast spanning tree support required by torus-2QoS.

As described for the previous patch series, the torus-2QoS engine can
provide the following functionality on a 2D/3D torus:
- routing that is free of credit loops
- two levels of QoS, assuming switches support 8 data VLs
- ability to route around a single failed switch, and/or multiple failed
    links, without
    - introducing credit loops
    - changing path SL values
- very short run times, with good scaling properties as fabric size
    increases

However, in order to provide this funcionality, torus-2QoS must employ
all 4 available SL bits, and 3 data VL bits.  Thus, there are no available
resources on which to confine multicast routing, and multicast spanning
trees must be constructed to overlay unicast routes in such a way that
no credit loops are possible.  This patch set implements that, and provides
the above functionality for all fabrics for which torus-2QoS can generate
unicast routes which are free of credit loops.

The last patch in the series updates opensm/doc/current-routing.txt with
a description of how torus-2QoS generates spanning trees with the 
desired properties.


Jim Schutt (12):
  opensm: Make error message for torus-2QoS dateline specification
    match code check.
  opensm: torus-2QoS should fail to route if message deadlock is
    possible.
  opensm: Remove unused port specification from torus-2QoS config file
    parsing.
  opensm: Fix up some torus-2QoS comments to match code.
  opensm: Enforce torus-2QoS link ordering convention.
  opensm: Remove redundant function names in torus-2QoS logging.
  opensm: Make torus-2QoS always use OSM_LOG_INFO, never LOG_INFO.
  opensm: Add struct osm_routing_engine callback to build spanning
    trees for multicast.
  opensm: Make mcast_mgr_purge_tree() available outside
    osm_mcast_mgr.c.
  opensm: Implement master spanning tree for torus-2QoS multicast
    support.
  opensm: Implement multicast support for torus-2QoS.
  opensm: Update documentation to describe torus-2QoS multicast
    support.

 opensm/doc/current-routing.txt        |  121 ++++-
 opensm/include/opensm/osm_multicast.h |   33 ++
 opensm/include/opensm/osm_opensm.h    |    6 +
 opensm/opensm/osm_mcast_mgr.c         |   11 +-
 opensm/opensm/osm_ucast_torus.c       | 1001 +++++++++++++++++++++++++--------
 5 files changed, 931 insertions(+), 241 deletions(-)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
