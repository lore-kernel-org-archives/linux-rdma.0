From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs V4 0/5] Add support for UD QPs under RoCE IP addressing
Date: Sun, 18 May 2014 12:38:44 +0300
Message-ID: <1400405929-14313-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Roland,

This series adds support for Ethernet L2 address resolution for RoCE UD QPs,
whose L2 address-handles, unlike RC/UC/XRC/etc QPs are set from user space
without going through uverbs and the kernel IB core. The code is also
compatible both with old kernels that don't run IP based addressing.

Matan and Or.

changes from V3 -- addressed feedback from Jason:
  - replaced the char* that used to hold the MAC address provided to
    the provider library (e.g libmlx4) with sockaddr_storage and use ARPHRD
    for the af_family (similar to the practice used in the kernel)

  - Dropped mask1 from ibv_query_port_ex and put all fields in comp_mask
  - Added a man page for ibv_query_port_ex
  - Made the code c99 friendly by dropping the anonymous union and struct
  - Splitted the patches to patch that adds the interface and patch that uses it
  - Removed the usage of drv_ and lib_ schemas
  - Removed the VERBS_CONTEXT_XXXXXXX
 
changes from V2:
  - when using libnl3, link libibverbs itself with libnl3 and not the utilities
  - fix memory leak which took place when nl_addr_cmp_prefix_msb returns non zero.
  - rebased against libibverbs-1.1.8

changes from V1, addressed feedback from Yann Droneaud:
  - ported the code to libnl3 with automatic fallback option to libnl1
  - better error handling (more checks to erroneous flows)
  - fixed typos and removed blank lines
  - set close-on-exec open flag for the relevant fds
  - remove wrong comment from the change-log of patch #1

changes from V0:
 - don't change struct ibv_port_attr flags field from uint32_t
   to enum (size could change)
 - ibv_ah_attr_ex is extendable and contains ibv_ah_attr

Matan Barak (5):
  Add ibv_port_cap_flags
  Extend create_ah in order to pass L2 parameters to the provider
  Use neighbour lookup for RoCE UD QPs Eth L2 resolution
  Add ibv_query_port_ex support
  Optimize ibv_create_ah link query

 Makefile.am                |   27 +-
 configure.ac               |   31 ++
 include/infiniband/verbs.h |  140 ++++++
 man/ibv_query_port_ex.3    |   97 +++++
 src/neigh.c                | 1003 ++++++++++++++++++++++++++++++++++++++++++++
 src/neigh.h                |   53 +++
 src/verbs.c                |  164 +++++++-
 7 files changed, 1502 insertions(+), 13 deletions(-)
 create mode 100644 man/ibv_query_port_ex.3
 create mode 100644 src/neigh.c
 create mode 100644 src/neigh.h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
