From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH RFC iproute2-next 0/2] RDMA tool provider resource tracking
Date: Mon, 30 Apr 2018 08:01:13 -0700
Message-ID: <cover.1525100473.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hello,

This series enhances the iproute2 rdma tool to include displaying
provider-specific resource attributes.  It is the user-space part of
the kernel provider resource tracking series currently under
review [1].

This is an RFC and should not be merged yet.  Once [1] is in the
linux-rdma for-next branch (and all reviewing is complete), I'll post
a final version and request merging.

Thanks,

Steve.

[1] https://www.spinics.net/lists/linux-rdma/msg64013.html

Steve Wise (2):
  rdma: update rdma_netlink.h to get provider attrs
  rdma: print provider resource attributes

 rdma/include/uapi/rdma/rdma_netlink.h |  37 ++++++-
 rdma/rdma.c                           |   7 +-
 rdma/rdma.h                           |  11 ++
 rdma/res.c                            |  30 ++----
 rdma/utils.c                          | 194 ++++++++++++++++++++++++++++++++++
 5 files changed, 257 insertions(+), 22 deletions(-)

-- 
1.8.3.1
