From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH v3 iproute2-next 0/3] RDMA tool driver-specific resource tracking
Date: Wed, 16 May 2018 08:05:57 -0700
Message-ID: <cover.1526483157.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This series enhances the iproute2 rdma tool to include displaying
driver-specific resource attributes.  It is the user-space part of the
kernel driver resource tracking series that has been accepted for merging
into linux-4.18 [1]

If there are no additional review comments, it can now be merged, I think.

Changes since v2:
- resync rdma_netlink.h to fix uapi break

Changes since v1:
- commit log editorial fixes
- cite kernel commits that updated rdma_netlink.h in the 
  iproute2 commit syncing this header
- reorder stack definitions ala "reverse christmas tree"
- correctly handle unknown driver attributes when printing

Changes since v0/rfc:
- changed "provider" to "driver" based on kernel side changes
- updated man pages
- removed "RFC" tag

Thanks,

Steve.

[1] https://www.spinics.net/lists/linux-rdma/msg64199.html

Steve Wise (3):
  rdma: update rdma_netlink.h to get new driver attributes
  rdma: print driver resource attributes
  rdma: update man pages

 man/man8/rdma-resource.8              |  29 ++++-
 man/man8/rdma.8                       |   2 +-
 rdma/include/uapi/rdma/rdma_netlink.h |  30 +++++-
 rdma/rdma.c                           |   9 +-
 rdma/rdma.h                           |  11 ++
 rdma/res.c                            |  30 ++----
 rdma/utils.c                          | 196 ++++++++++++++++++++++++++++++++++
 7 files changed, 280 insertions(+), 27 deletions(-)

-- 
1.8.3.1
