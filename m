From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next v1 00/19] Export object IDs to users
Date: Wed, 20 Feb 2019 09:21:17 +0200
Message-ID: <20190220072136.3840-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog:
v0->v1:
 * Rebased to latest iproute2-next
 * Added latest rdma_netlink.h and updated commit message to point
   to kernel SHA commit.

This series adds ability to present and query all known to rdmatool
object by their respective, unique IDs (e.g. pdn. mrn, cqn e.t.c).
All objects which have "parent" object has this information too.

Thanks

Leon Romanovsky (19):
  rdma: update uapi headers
  rdma: Remove duplicated print code
  rdma: Provide unique indexes for all visible objects
  rdma: Provide parent context index for all objects except CM_ID
  rdma: Move resource PD logic to separate file
  rdma: Refactor out resource MR logic to separate file
  rdma: Move out resource CQ logic to separate file
  rdma: Move out resource CM-ID logic to separate file
  rdma: Move resource PD logic to separate file
  rdma: Properly mark RDMAtool license
  rdma: Simplify code to reuse existing functions
  rdma: Simplify CM_ID print code
  rdma: Refactor CQ prints
  rdma: Separate MR code
  rdma: Separate PD code
  rdma: Move QP code to separate function
  rdma: Unify netlink attribute checks prior to prints
  rdma: Perform single .doit call to query specific objects
  rdma: Provide and reuse filter functions

 rdma/Makefile                         |   5 +-
 rdma/dev.c                            |   7 +-
 rdma/include/uapi/rdma/rdma_netlink.h |  64 +-
 rdma/link.c                           |   7 +-
 rdma/rdma.c                           |   7 +-
 rdma/rdma.h                           |  24 +-
 rdma/res-cmid.c                       | 275 ++++++++
 rdma/res-cq.c                         | 160 +++++
 rdma/res-mr.c                         | 133 ++++
 rdma/res-pd.c                         | 136 ++++
 rdma/res-qp.c                         | 240 +++++++
 rdma/res.c                            | 932 ++------------------------
 rdma/res.h                            | 148 ++++
 rdma/utils.c                          |  53 +-
 14 files changed, 1257 insertions(+), 934 deletions(-)
 create mode 100644 rdma/res-cmid.c
 create mode 100644 rdma/res-cq.c
 create mode 100644 rdma/res-mr.c
 create mode 100644 rdma/res-pd.c
 create mode 100644 rdma/res-qp.c
 create mode 100644 rdma/res.h
