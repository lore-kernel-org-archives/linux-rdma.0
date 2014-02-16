From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs V2 0/3] Add support for UD QPs under RoCE IP addressing
Date: Sun, 16 Feb 2014 16:06:05 +0200
Message-ID: <1392559568-13309-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

This series adds support for Ethernet L2 address resolution for RoCE UD QPs, 
whose L2 address-handles, unlike RC/UC/XRC/etc QPs are set from user space 
without going through uverbs and the kernel IB core. The code is also 
compatible both with old kernels that don't run IP based addressing.

Matan and Or.

changes from V1, addressed feedback from Yann Droneaud
  - ported the code to libnl3 with automatic fallback option to libnl1
  - better error handling (more checks to erroneous flows)
  - fixed typos and removed blank lines
  - set close-on-exec open flag for the relevant fds
  - remove wrong comment from the change-log of patch #1

changes from V0:
 - don't change struct ibv_port_attr flags field from uint32_t
   to enum (size could change)
 - ibv_ah_attr_ex is extendable and contains ibv_ah_attr


Matan Barak (3):
  Add ibv_port_cap_flags
  Use neighbour lookup for RoCE UD QPs Eth L2 resolution
  Add ibv_query_port_ex support

 Makefile.am                |   24 +-
 configure.ac               |   31 ++
 include/infiniband/verbs.h |  159 +++++++-
 src/device.c               |    2 +
 src/neigh.c                | 1003 ++++++++++++++++++++++++++++++++++++++++++++
 src/neigh.h                |   53 +++
 src/verbs.c                |  164 +++++++-
 7 files changed, 1423 insertions(+), 13 deletions(-)
 create mode 100644 src/neigh.c
 create mode 100644 src/neigh.h

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
