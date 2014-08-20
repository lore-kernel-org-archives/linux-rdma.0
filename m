From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs V5 0/2] Use neighbour lookup for RoCE UD QPs Eth L2 resolution
Date: Wed, 20 Aug 2014 09:49:39 +0300
Message-ID: <1408517381-17523-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

This series adds support for Ethernet L2 address resolution for RoCE UD QPs,
whose L2 address-handles, unlike RC/UC/XRC/etc QPs are set from user space
without going through uverbs and the kernel IB core. The code is also
compatible both with old kernels that don't run IP based addressing.

Matan and Or.

changes from V4 -- addressed feedback from Jason
  - Instead of an extended create_ah_ex provider call, use a utlity
    function in libibverbs.
  - Remove the extended query port that was mainly used for caching.

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

Matan Barak (2):
  Add ibv_port_cap_flags
  Use neighbour lookup for RoCE UD QPs Eth L2 resolution

 Makefile.am                |   24 +-
 configure.ac               |   31 ++
 include/infiniband/verbs.h |   29 ++
 src/libibverbs.map         |    2 +
 src/neigh.c                | 1003 ++++++++++++++++++++++++++++++++++++++++++++
 src/neigh.h                |   53 +++
 src/verbs.c                |  143 +++++++
 7 files changed, 1275 insertions(+), 10 deletions(-)
 create mode 100644 src/neigh.c
 create mode 100644 src/neigh.h

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
