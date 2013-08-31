From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/4] RDMA/nes and RDMA/cxgb4: iWARP Port Mapper Overview
Date: Sat, 31 Aug 2013 14:41:28 -0500
Message-ID: <20130831194127.GA22152@TENIKOLO-MOBL1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello All,

This patch series adds iWARP Port Mapper (IWPM) service support in RDMA/core,
RDMA/nes driver and RDMA/cxgb4 driver. The iWARP Port Mapper implementation is
based on the port mapper specification section in the Sockets Direct Protocol
paper - http://www.rdmaconsortium.org/home/draft-pinkerton-iwarp-sdp-v1.0.pdf 

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
This patch series adds driver support for sending/receiving/parsing netlink
messages, to make the communication with the IWPM service possible.

The patches are built against Roland's infiniband tree for-next branch.
We would like this series to get in the linux-3.12 merge window.

Kindly review it and provide feedback.
Thanks,

Tatyana Nikolova (3):
  RDMA/core: Add support for iWARP Port Mapper user space service
  RDMA/nes: Add support for iWARP Port Mapper user space service
  RDMA/nes: Change the nes driver version to reflect added IWPM functionality

Vipul Pandya (1):
  RDMA/cxgb4: Add support for iWARP Port Mapper user space service

 drivers/infiniband/core/cma.c              |    2 +-
 drivers/infiniband/core/netlink.c          |   18 +-
 drivers/infiniband/hw/cxgb4/Makefile       |    2 +-
 drivers/infiniband/hw/cxgb4/c4iw_netlink.c | 1021 +++++++++++++++++++++++
 drivers/infiniband/hw/cxgb4/c4iw_netlink.h |  273 +++++++
 drivers/infiniband/hw/cxgb4/cm.c           |  138 +++-
 drivers/infiniband/hw/cxgb4/device.c       |   24 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h     |   16 +
 drivers/infiniband/hw/nes/Makefile         |    2 +-
 drivers/infiniband/hw/nes/nes.c            |   16 +-
 drivers/infiniband/hw/nes/nes.h            |    4 +-
 drivers/infiniband/hw/nes/nes_cm.c         |  189 ++++--
 drivers/infiniband/hw/nes/nes_cm.h         |   12 +-
 drivers/infiniband/hw/nes/nes_netlink.c    | 1223 ++++++++++++++++++++++++++++
 drivers/infiniband/hw/nes/nes_netlink.h    |  108 +++
 drivers/infiniband/hw/nes/nes_nic.c        |    5 +
 include/rdma/rdma_netlink.h                |   23 +-
 include/uapi/rdma/rdma_netlink.h           |   94 +++-
 18 files changed, 3083 insertions(+), 87 deletions(-)
 create mode 100644 drivers/infiniband/hw/cxgb4/c4iw_netlink.c
 create mode 100644 drivers/infiniband/hw/cxgb4/c4iw_netlink.h
 create mode 100644 drivers/infiniband/hw/nes/nes_netlink.c
 create mode 100644 drivers/infiniband/hw/nes/nes_netlink.h

-- 
1.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
