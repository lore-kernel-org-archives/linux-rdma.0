From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/3] RDMA/core: iWARP Port Mapper Overview
Date: Wed, 26 Mar 2014 17:07:18 -0500
Message-ID: <20140326220718.GA8784@TENIKOLO-MOBL1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Hello All,

This patch series adds iWARP Port Mapper (IWPM) Version 2 support
in RDMA/core, RDMA/nes driver and RDMA/cxgb4 driver.
The iWARP Port Mapper implementation is based on the port mapper specification
section in the Sockets Direct Protocol paper -
http://www.rdmaconsortium.org/home/draft-pinkerton-iwarp-sdp-v1.0.pdf 

Existing iWARP RDMA providers use the same IP address as the native TCP/IP
stack when creating RDMA connections. They need to ensure a mechanism to claim 
the TCP ports used for RDMA connections, thereby preventing TCP port collisions
when other host applications are consuming TCP ports. The iWARP Port Mapper
provides a standard mechanism to accomplish this. Without this service it is
possible for RDMA application to bind/listen on the same port which is already
being used by native TCP host application. If that happens the incoming TCP
connection data can be passed to the RDMA stack with error.

The iWARP Port Mapper solution doesn't contain any changes to the existing
network stack in the kernel space. All the changes are contained with the
infiniband tree and also in user space.

The iWARP Port Mapper service is implemented as a user space daemon process.
Interested readers could look at the source code of the IWPM service located at
http://git.openfabrics.org/git?p=~tnikolova/libiwpm-1.0.0/.git;a=summary

The iWARP driver (port mapper client) sends to the IWPM service the local IP
address and TCP port it has received from the RDMA application, when starting a
connection. The IWPM service performs a socket bind from user space to get
an available TCP port, called a mapped port, and communicates it back to the
client. In that sense, the IWPM service is used to map the TCP port, which the
RDMA application uses to any port available from the host TCP port space. The
mapped ports are used in iWARP RDMA connections to avoid collisions with native
TCP stack which is aware that these ports are taken. When an RDMA connection
using a mapped port is terminated, the client notifies the IWPM service, which
then releases the TCP port.

The message exchange between the IWPM service and the iWARP drivers
(between user space and kernel space) is implemented using netlink sockets.

This patch series adds iWarp driver support for sending/receiving/parsing
netlink messages, to make the communication with the IWPM service possible.

This is the second submission for the iWarp Port Mapper and
we have considered and incorporated feedback after the first submission
to improve the IWPM Version 2 patch series.

The following items are improvements and fixes to IWPM V2:

1) The IWPM functionality, common for both iWarp drivers (nes and cxgb4)
   is refactored from the drivers source files and is moved to new shared
   files in infiniband/core which are compiled as part of the iw_cm module.

2) Hash table data structure is implemented to store the drivers mapping
   information and enable efficient searching. (Hash table implementation
   is based on original work by Vipul Pandya)

3) Fix for a timer bug is provided as the unnecessary timer scheduling is
   removed.

The patches are built against Roland's infiniband tree for-next branch.

Thank you,

Tatyana Nikolova (2):
  RDMA/core: Add support for iWarp Port Mapper V2 user space service
  RDMA/nes: Add support for iWarp Port Mapper V2 user space service
Steve Wise (1):
  RDMA/cxgb4: Add support for iWarp Port Mapper V2 user space service

 drivers/infiniband/core/Makefile       |    2 +-
 drivers/infiniband/core/cma.c          |    3 +-
 drivers/infiniband/core/iwpm_msg.c     |  691 ++++++++++++++++++++++++++++++++
 drivers/infiniband/core/iwpm_util.c    |  609 ++++++++++++++++++++++++++++
 drivers/infiniband/core/iwpm_util.h    |  238 +++++++++++
 drivers/infiniband/core/netlink.c      |   18 +-
 drivers/infiniband/hw/cxgb4/cm.c       |  180 +++++++--
 drivers/infiniband/hw/cxgb4/device.c   |   81 ++++-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |   44 ++
 drivers/infiniband/hw/nes/nes.c        |   25 ++-
 drivers/infiniband/hw/nes/nes.h        |    3 +
 drivers/infiniband/hw/nes/nes_cm.c     |  320 ++++++++++++---
 drivers/infiniband/hw/nes/nes_cm.h     |   12 +-
 include/rdma/iw_portmap.h              |  199 +++++++++
 include/rdma/rdma_netlink.h            |   23 +-
 include/uapi/rdma/rdma_netlink.h       |   96 +++++-
 16 files changed, 2431 insertions(+), 113 deletions(-)
 create mode 100644 drivers/infiniband/core/iwpm_msg.c
 create mode 100644 drivers/infiniband/core/iwpm_util.c
 create mode 100644 drivers/infiniband/core/iwpm_util.h
 create mode 100644 include/rdma/iw_portmap.h

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
