From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/9] IBoE updates: GID change event and network flow
 counters
Date: Wed, 15 Jun 2011 17:38:06 +0300
Message-ID: <alpine.LRH.2.00.1106151733410.15844@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland,

The enclosed patch series enhances the IBoE kernel stack to
use GID change event and network flow counters.

This work is based on earlier patches done by Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
posted during Nov/2010 see http://marc.info/?l=linux-rdma&m=128939180605962

The first change is used to avoid using the irrelevant LID change
event for updating the IB core GID cache, and is made of two patches:

[PATCH 1/9] ib/core: Add GID change event
[PATCH 2/9] ib/mlx4: use GID change event on IBoE code

The second change is used such that eventually we're able to
implement port level packets/bytes performance counters for
IBoE and is made of seven patches:

[PATCH 3/9] mlx4: extend cap flags to 64 bit
[PATCH 4/9] mlx4: align current extended capabilities to use the flags field
[PATCH 5/9] mlx4: Fix layout of QP context for correct location of counter index
[PATCH 6/9] mlx4: add network flow counters
[PATCH 7/9] ib/pma: add include file for IBA performance counters definitions
[PATCH 8/9] ib/mlx4: use flow counters on IBoE ports
[PATCH 9/9] ib/mlx4: support PMA counters for IBoE

patches #3 and #4 change the mlx4 driver such that it now uses
a 64 bit capability flags. This extended cap flags field is used
to account for currently implemented extended capabilities (e.g
udp_rss, uc/mc vep steering, etc) and for the flow counters capability.
These two patches are light in the sense that they don't add/remove
any functionality from the driver.

patch #5 is a bug fix for driver view of the mlx4 QP context
layout w.r.t to the counter index location.

patch #6 adds mlx4 support for network flow counters, where such counter
can be pointed by a set containing one or more QPs and track receive and
transmit packets and bytes of these QPs.

patch #7 moves the various definitions and mad structures related to IBA
PM agent from the ipath and qib drivers into a single include file, so we
can later use them for IBoE and avoid the current code duplication...

patches #8 and #9 bring the actual IBoE use of the counters,
done through allocating flow counter per Ethernet/IBoE port,
such that this counter is later pointed by all mlx4_ib QPs created
on that port. Later this counter can be queried so get a port level
packets/bytes performance counters ala IB

Or.


 drivers/infiniband/core/cache.c         |    3
 drivers/infiniband/hw/ipath/ipath_mad.c |  134 ------------------------
 drivers/infiniband/hw/mlx4/mad.c        |   68 ++++++++++++
 drivers/infiniband/hw/mlx4/main.c       |   22 +++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h    |    1
 drivers/infiniband/hw/mlx4/qp.c         |   10 +
 drivers/infiniband/hw/qib/qib_mad.h     |  176 --------------------------------
 drivers/net/mlx4/en_ethtool.c           |    9 -
 drivers/net/mlx4/en_main.c              |    3
 drivers/net/mlx4/en_netdev.c            |    5
 drivers/net/mlx4/en_port.c              |    6 -
 drivers/net/mlx4/en_selftest.c          |    3
 drivers/net/mlx4/fw.c                   |   39 ++++---
 drivers/net/mlx4/fw.h                   |    8 -
 drivers/net/mlx4/main.c                 |   62 ++++++++++-
 drivers/net/mlx4/mcg.c                  |   17 +--
 drivers/net/mlx4/mlx4.h                 |    1
 drivers/net/mlx4/port.c                 |    8 -
 include/linux/mlx4/cmd.h                |    3
 include/linux/mlx4/device.h             |   60 ++++++----
 include/linux/mlx4/qp.h                 |    8 -
 include/rdma/ib_verbs.h                 |    3
 22 files changed, 262 insertions(+), 387 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
