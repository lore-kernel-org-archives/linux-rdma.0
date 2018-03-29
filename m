From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH v4 iproute2-next 0/7] cm_id, cq, mr, and pd resource tracking
Date: Thu, 29 Mar 2018 14:38:57 -0700
Message-ID: <cover.1522359537.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com
Cc: leon@kernel.org, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This series enhances the iproute2 rdma tool to include dumping of
connection manager id (cm_id), completion queue (cq), memory region (mr),
and protection domain (pd) rdma resources.  It is the user-space part of
the kernel resource tracking series merged into rdma-next for 4.17 [1]
and [2].

Changes since v3:
- replaced rdma_cma.h inclusion with UAPI rdma_user_cm.h
- display only device names instead of device/port for cq, mr, and pd
since they are not associated with a specific port.

Changes since v2:
- pull in rdma-core:include/rdma/rdma_cma.h
- 80 column reformat
- add reviewed-by tags

Changes since v1/RFC:
- removed RFC tag
- initialize rd properly to avoid passing a garbage port number
- revert accidental change to qp_valid_filters 
- removed cm_id dev/network/transport types
- cm_id ip addrs now passed up as __kernel_sockaddr_storage
- cm_id ip address ports printed as "address:port" strings
- only parse/display memory keys and iova if available
- filter on "users" for cqs and pds
- fixed memory leaks 
- removed PD_FLAGS attribute
- filter on "mrlen" for mrs
- filter on "poll-ctx" for cqs
- don't require addrs or qp_type for parsing cm_ids
- only filter optional attrs if they are present
- remove PGSIZE MR attr to match kernel 

[1] https://www.spinics.net/lists/linux-rdma/msg61720.html
[2] https://www.spinics.net/lists/linux-rdma/msg62979.html
    https://www.spinics.net/lists/linux-rdma/msg62980.html

---

Steve Wise (7):
  rdma: update rdma_netlink.h
  rdma: add UAPI rdma_user_cm.h
  rdma: initialize the rd struct
  rdma: Add CM_ID resource tracking information
  rdma: Add CQ resource tracking information
  rdma: Add MR resource tracking information
  rdma: Add PD resource tracking information

 include/json_writer.h                 |   2 +
 lib/json_writer.c                     |  11 +
 rdma/include/uapi/rdma/rdma_netlink.h |  38 ++
 rdma/include/uapi/rdma/rdma_user_cm.h | 324 +++++++++++++++++
 rdma/rdma.c                           |   2 +-
 rdma/rdma.h                           |   2 +
 rdma/res.c                            | 633 +++++++++++++++++++++++++++++++++-
 rdma/utils.c                          |  16 +
 8 files changed, 1026 insertions(+), 2 deletions(-)
 create mode 100644 rdma/include/uapi/rdma/rdma_user_cm.h

-- 
1.8.3.1
