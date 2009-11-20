From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 00/11] Add new torus routing engine: torus-2QoS
Date: Fri, 20 Nov 2009 12:14:59 -0700
Message-ID: <1258744509-11148-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch series adds a new routing engine designed to handle large 
fabrics connected with a 2D/3D torus topology.

Patches 1-4 do some preparation to handle new SL-related features of
the routing engine, patches 5/6 add and enable the engine, and patches
7-11 have some fixups that only make sense in the presence of the new
engine.

So why a new torus routing engine?

Because I believe none of the existing routing engines can provide a
satisfactory operational experience on a large-scale torus, i.e. one
with hundreds of switches.

Generating routes for a torus that are free of credit loops requires
the use of multiple virtual lanes, and thus SLs on IB.  For IB fabrics
it also requires that _every_ application use path record queries - 
any application that uses an SL that was not obtained via a path record
query may cause credit loops.

In addition, if a fabric topology change (e.g. failed switch/link)
causes a change in the path SL values needed to prevent credit loops,
then _every_ application needs to repath for every path whose SL has
changed.  AFAIK there is no good way to do this as yet in general.

Also, the requirement for path SL queries on every connection places a
heavy load on subnet administration, and the possibility that path SL
values can change makes caching as a performance enhancement more 
difficult.

Since multiple VL/SL values are required to prevent credit loops on a 
torus,  supporting QoS means that QoS and routing need to share the small 
pool of available SL values, and the even smaller pool of available VL 
values.

This patch series, and the routing engine it introduces, addresses these
issues for a 2D/3D torus fabric.  The torus-2QoS engine can provide the
following functionality on a 2D/3D torus:
- routing that is free of credit loops
- two levels of QoS, assuming switches support 8 data VLs
- ability to route around a single failed switch, and/or multiple failed
    links, without
    - introducing credit loops
    - changing path SL values
- very short run times, with good scaling properties as fabric size
    increases

The routing engine currently in opensm that is most functional for a
torus-connected fabric is LASH.  In comparison with torus-2QoS, LASH
has the following issues:
- LASH does not support QoS.
- changing inter-switch topology (add/remove a switch, or
    removing all the links between a switch) can change many
    path SL values, potentially leading to credit loops if
    running applications do not repath.
- running time to calculate routes scales poorly with increasing 
    fabric size.

The basic algorithm used by torus-2QoS is DOR.  It also uses SL bits 0-2,
one SL bit per torus dimension, to encode whether a path crosses a dateline
(where the coordinate value wraps to zero) for each of the three dimensions,
in order to avoid the credit loops that otherwise result on a torus.  It
uses SL bit 3 to distinguish between two QoS levels.

It uses the SL2VL tables to map those eight SL values per QoS level into
two VL values per QoS level, based on which coordinate direction a link
points.  For two QoS levels, this consumes four data VLs, where VL bit
0 encodes whether the path crosses the dateline for the coordinate
direction in which the link points, and VL bit 2 encodes QoS level.

In the event of link failure, it routes the long way around the 1-D ring
containing the failed link.  I.e. no turns are introduced into a path in
order to route around a failed link.  Note that due to this implementation, 
torus-2QoS cannot route a torus with link failures that break a 1-D ring
into two disjoint segments.

Under DOR routing in a torus with a failed switch, paths that would
otherwise turn at the failed switch cannot be routed without introducing
an "illegal" turn into the path.  Such turns are "illegal" in the
sense that allowing them will allow credit loops, unless something can
be done.

The routes produced by torus-2QoS will introduce such "illegal" turns when
a switch fails.  It makes use of the input/output port dependence in the
SL2VL maps to set the otherwise unused VL bit 1 for the path hop following 
such an illegal turn.  This is enough to avoid credit loops in the 
presence of a single failed switch.

As an example, consider the following 2D torus, and consider routes
from S to D, both when the switch at F is operational, and when it
has failed.  torus-2QoS will generate routes such that the path
S-F-D is followed if F is operational, and the path S-E-I-L-D
if F has failed:

    |    |    |    |    |    |    |
  --+----+----+----+----+----+----+--
    |    |    |    |    |    |    |
  --+----+----+----+----+----D----+--
    |    |    |    |    |    |    |
  --+----+----+----+----I----L----+--
    |    |    |    |    |    |    |
  --+----+----S----+----E----F----+--
    |    |    |    |    |    |    |
  --+----+----+----+----+----+----+--

The turn in S-E-I-L-D at switch I is the illegal turn introduced
into the path.  The turns at E and L are extra turns introduced
into the path that are legal in the sense that no credit loops
can be constructed using them.

The path hop after the turn at switch I has VL bit 1 set, which marks
it as a hop after an illegal turn.

I've used the latest development version of ibdmchk, because it can use
path SL values and SL2VL tables, to check for credit loops in cases like 
the above routed with torus-2QoS, and it finds none.

I've also looked for credit loops in a torus with multiple failed switches
routed with torus-2QoS, and learned that if and only if the failed switches
are adjacent in the last DOR dimension, there will be no credit loops.

Since torus-2QoS makes use of all available SL values when supporting
2 QoS levels, there are none left over on which to confine multicast.
It turns out there is a way to construct a spanning tree which can 
overlay a DOR-routed mesh, so that multicast and unicast can coexist
on the same SL/VL without causing credit loops.  I'm working on that but
don't have it implemented yet.

In the meantime, if you do not request QoS using opensm -Q, then
torus-2QoS will only use SLs 8-15, and thus VLs 4-7, leaving SL0/VL0
free for multicast.


Jim Schutt (11):
  opensm: Prepare for routing engine input to path record SL lookup and
    SL2VL map setup.
  opensm: Allow the routing engine to influence SL2VL calculations.
  opensm: Allow the routing engine to participate in path SL
    calculations.
  opensm: Track the minimum value in the fabric of data VLs supported.
  opensm: Add torus-2QoS routing engine.
  opensm: Enable torus-2QoS routing engine.
  opensm: Add opensm option to specify file name for extra torus-2QoS
    configuration information.
  opensm: Do not require -Q option for torus-2QoS routing engine.
  opensm: Make it possible to configure no fallback routing engine.
  opensm:  Avoid havoc in minhop caused by torus-2QoS persistent use of
    osm_port_t:priv.
  opensm: Update documentation to describe torus-2QoS.

 opensm/doc/current-routing.txt         |  154 +-
 opensm/include/opensm/osm_base.h       |   18 +
 opensm/include/opensm/osm_opensm.h     |   24 +-
 opensm/include/opensm/osm_subnet.h     |    7 +
 opensm/include/opensm/osm_ucast_lash.h |    3 -
 opensm/man/opensm.8.in                 |    9 +-
 opensm/opensm/Makefile.am              |    2 +-
 opensm/opensm/main.c                   |    8 +
 opensm/opensm/osm_console.c            |   10 +-
 opensm/opensm/osm_dump.c               |    3 +-
 opensm/opensm/osm_link_mgr.c           |   16 +-
 opensm/opensm/osm_opensm.c             |   54 +-
 opensm/opensm/osm_port_info_rcv.c      |   13 +-
 opensm/opensm/osm_qos.c                |   26 +-
 opensm/opensm/osm_sa_path_record.c     |   33 +-
 opensm/opensm/osm_state_mgr.c          |   10 +-
 opensm/opensm/osm_subnet.c             |   20 +-
 opensm/opensm/osm_ucast_lash.c         |   11 +-
 opensm/opensm/osm_ucast_mgr.c          |   44 +-
 opensm/opensm/osm_ucast_torus.c        | 8665 ++++++++++++++++++++++++++++++++
 20 files changed, 9038 insertions(+), 92 deletions(-)
 create mode 100644 opensm/opensm/osm_ucast_torus.c


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
