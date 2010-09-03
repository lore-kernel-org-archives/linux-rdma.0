From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH v4 00/18] opensm: Add new torus routing engine:
 torus-2QoS
Date: Fri,  3 Sep 2010 10:42:56 -0600
Message-ID: <1283532194-27112-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is v4 of a patchset to add to opensm a new routing engine designed
to handle large fabrics connected with a 2D/3D torus topology.

Changes since v3:

- Rebased to e5615a7039.
- Simplify changes to setup_routing_engines() based on Sasha's feedback.
- Bug fix: Don't install torus fabric links based on torus config, as
   locate_sw() does the right thing always anyway.
- Bug fix: Correctly check for existence in fabric of configured seed switches.
- Divide "Add torus-2QoS routing engine" patch into four parts
   to avoid rejection by mailing list.

Changes since v2:

- Rebased to a3dec3a87a.
- Divide "Add torus-2QoS routing engine" patch into three parts
   to avoid rejection by mailing list.
- Bug fix: reduce number of required seed links for a torus
   with one or more dimensions of radix four.
- Bug fix: don't let torus-2QoS be fooled into thinking it can route
   a torus with two or more blocks of switches adjacent in z missing.
- Bug fix: if osm_ucast_mgr_process() fails, no configured routing engine
   could route the fabric, so wait for a trap or sweep interval before
   next heavy sweep.
- Bug fix: cut-n-paste error in handle_case_0x731().

Changes since initial version:

- Merged my patchsets from 11/20/2009, 12/18/2009, 2/16/2010.
- Moved infomation contained in the earlier patch series introduction
    emails into the appropriate commit messages.
- Rebased to c183eb8c4c.
- Addressed issues found by Yevgeny Kliteynik in original patchsets.
    Yevgeny's --no_default_routing option patch is not included
    in the merging, but would be a good addition.
- Renamed osm_ucast_torus.c to osm_torus.c.
    Since osm_torus.c contains code to implement both unicast and
    multicast routing, the new name seems more appropriate.  The
    multicast support depends heavily on the unicast routing code,
    so it is more convenient to keep everything in one file.
- Removed redundant check for changed sl2vl map.
    This functionality already exists in sl2vl_update_table().
- Set sl2vl maps on CA ports for torus-2QoS.
    This was missing in the original patches.
- Do not force torus-2QoS to use SLs 8-15 when not using "opensm -Q".
    This was an interim measure introduced before multicast support was
    working, that allowed multicast to use SL/VL 0 and thus not deadlock
    against unicast.  I forget to take it out in the multicast patchset,
    so I took it out when I merged.
- Renamed torus variables referencing "origin" to "seed".
    These things refer to switches used to seed the torus topology
    appropriately, so the new name should reduce confusion going forward.
    This also contains a keyword change in the torus configuration file,
    so I'll repost an updated example.


Jim Schutt (18):
  opensm: Prepare for routing engine input to path record SL lookup and
    SL2VL map setup.
  opensm: Allow the routing engine to influence SL2VL calculations.
  opensm: Allow the routing engine to participate in path SL
    calculations.
  opensm: Track the minimum value in the fabric of data VLs supported.
  opensm: Add struct osm_routing_engine callback to build spanning
    trees for multicast.
  opensm: Make mcast_mgr_purge_tree() available outside
    osm_mcast_mgr.c.
  opensm: Add torus-2QoS routing engine, part 1.
  opensm: Add torus-2QoS routing engine, part 2.
  opensm: Add torus-2QoS routing engine, part 3.
  opensm: Add torus-2QoS routing engine, part 4.
  opensm: Update documentation to describe torus-2QoS.
  opensm: Enable torus-2QoS routing engine.
  opensm: Add opensm option to specify file name for extra torus-2QoS
    configuration information.
  opensm: Do not require -Q option for torus-2QoS routing engine.
  opensm: Make it possible to configure no fallback routing engine.
  opensm: Avoid havoc in minhop caused by torus-2QoS persistent use of
    osm_port_t:priv.
  opensm: Avoid havoc in dump_ucast_routes() caused by torus-2QoS
    persistent use of osm_port_t:priv.
  opensm: Cause status of unicast routing attempt to propogate to
    callers of osm_ucast_mgr_process().

 opensm/doc/current-routing.txt         |  269 +-
 opensm/include/opensm/osm_base.h       |   18 +
 opensm/include/opensm/osm_multicast.h  |   33 +
 opensm/include/opensm/osm_opensm.h     |   29 +-
 opensm/include/opensm/osm_subnet.h     |    7 +
 opensm/include/opensm/osm_switch.h     |   12 +
 opensm/include/opensm/osm_ucast_lash.h |    3 -
 opensm/man/opensm.8.in                 |    9 +-
 opensm/opensm/Makefile.am              |    2 +-
 opensm/opensm/main.c                   |   11 +-
 opensm/opensm/osm_console.c            |   10 +-
 opensm/opensm/osm_dump.c               |    5 +-
 opensm/opensm/osm_link_mgr.c           |   16 +-
 opensm/opensm/osm_mcast_mgr.c          |   11 +-
 opensm/opensm/osm_opensm.c             |   51 +-
 opensm/opensm/osm_port_info_rcv.c      |   13 +-
 opensm/opensm/osm_qos.c                |   40 +-
 opensm/opensm/osm_sa_path_record.c     |   33 +-
 opensm/opensm/osm_state_mgr.c          |   23 +-
 opensm/opensm/osm_subnet.c             |   20 +-
 opensm/opensm/osm_switch.c             |    7 +-
 opensm/opensm/osm_torus.c              | 9108 ++++++++++++++++++++++++++++++++
 opensm/opensm/osm_ucast_lash.c         |   11 +-
 opensm/opensm/osm_ucast_mgr.c          |   55 +-
 24 files changed, 9687 insertions(+), 109 deletions(-)
 create mode 100644 opensm/opensm/osm_torus.c


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
