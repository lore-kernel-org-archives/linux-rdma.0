From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 00/13] opensm: Cleanups and more documentation for
 torus-2QoS patchset
Date: Fri, 12 Nov 2010 15:11:09 -0700
Message-ID: <1289599882-15165-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

These patches clean up and add documentation to the
torus-2QoS routing module for OpenSM.  They apply on
top of my previous bug-fix patchset from September
(http://www.spinics.net/lists/linux-rdma/msg05809.html),
which applies to your torus-2qos branch.

Thanks -- Jim


Jim Schutt (13):
  Revert "opensm: Do not require -Q option for torus-2QoS routing
    engine."
  opensm: torus-2QoS requires that QoS be enabled.
  opensm/osm_ucast_mgr.c: ensure osm_ucast_mgr_process() returns
    failure when no routing engine runs.
  opensm: Fill in default QoS values at last possible moment.
  opensm: Cause torus-2QoS to warn if QoS configuration will cause
    issues.
  opensm/osm_torus.c: Also parse DOS line endings in torus-2QoS.conf.
  opensm/osm_torus.c: Use PRIx64 for GUID printing.
  opensm/osm_torus.c: Ignore multiple configurations of torus size.
  opensm/osm_subnet.c: Add torus-2QoS config file option to those
    configurable via opensm config file.
  opensm/main.c:  Add description of "no_fallback" to
    "--routing_engine" option documentation.
  opensm/man/opensm.8.in:  Add references to torus-2QoS.
  opensm: Add torus-2QoS man pages.
  opensm/doc/current-routing.txt: Sync torus-2QoS information with new
    man pages.

 opensm/Makefile.am              |    2 +-
 opensm/configure.in             |    6 +-
 opensm/doc/current-routing.txt  |  141 +++++++++++--
 opensm/man/opensm.8.in          |   29 +++-
 opensm/man/torus-2QoS.8.in      |  476 +++++++++++++++++++++++++++++++++++++++
 opensm/man/torus-2QoS.conf.5.in |  184 +++++++++++++++
 opensm/opensm/main.c            |    3 +
 opensm/opensm/osm_qos.c         |   62 ++++--
 opensm/opensm/osm_subnet.c      |   75 +++----
 opensm/opensm/osm_torus.c       |  319 +++++++++++++++++---------
 opensm/opensm/osm_ucast_mgr.c   |    1 +
 11 files changed, 1105 insertions(+), 193 deletions(-)
 create mode 100644 opensm/man/torus-2QoS.8.in
 create mode 100644 opensm/man/torus-2QoS.conf.5.in


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
