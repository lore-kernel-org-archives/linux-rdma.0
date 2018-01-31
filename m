From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 00/10] RDMA resource tracking
Date: Wed, 31 Jan 2018 10:11:46 +0200
Message-ID: <20180131081156.19607-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Steve Wise <swise@opengridcomputing.com>, Leon Romanovsky <leon@kernel.org>, netdev <netdev@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

Changelog:
 v2 -> v3:
   * Rebased to commit: 1e24e773f144 ("Merge branch 'iproute2-master' into iproute2-next")
   * Refreshed include/uapi/rdma/rdma_netlink.h file
   * Fixed bug, where cxgb4 was printed twice.
 v1 -> v2;
   * Added checks for all occurrences of strdup failures and added patch
     with fix of already merged code.
   * Sync with latest kernel code.
   * Rewrote table representation to be similar to "ip route" output.
   * Implemented string filters.
   * Removed curr/max representation from the summary output.
 v0 -> v1:
   * Fixed subject title in patch #1: rdam -> rdma.
   * Added newline between variable declaration and the code.
   * Add check to failure in strdup() call in rd_check_is_string_filtered().
   * Rewrote res_qp_parse_cb() to avoid long lines and extra indentation.

------------------------------------------------------------------------

David, Stephen,

The kernel code is accepted to the RDMA and will be sent to Linus in
this merge window, and this is refreshed version of user space part.

Because, I found bug in handling cxgb4 devices and we cleaned header
file a little bit more, it was more wise to resend the series instead
of applying v2.

https://patchwork.ozlabs.org/project/netdev/list/?series=RDMA+resource+tracking&submitter=68852&state=8&q=&archive=&delegate=

Thanks

Cc: RDMA mailing list <linux-rdma@vger.kernel.org>
Cc: Steve Wise <swise@opengridcomputing.com>

[1] https://www.spinics.net/lists/linux-rdma/msg59535.html

Leon Romanovsky (10):
  rdma: Add option to provide "-" sign for the port number
  rdma: Make visible the number of arguments
  rdma: Add filtering infrastructure
  rdma: Set pointer to device name position
  rdma: Allow external usage of compare string routine
  rdma: Update kernel header file
  rdma: Add resource tracking summary
  rdma: Add QP resource tracking information
  rdma: Document resource tracking
  rdma: Check return value of strdup call

 include/uapi/rdma/rdma_netlink.h |  67 +++++-
 man/man8/rdma-resource.8         |  86 +++++++
 rdma/Makefile                    |   2 +-
 rdma/link.c                      |   2 +-
 rdma/rdma.c                      |   4 +-
 rdma/rdma.h                      |  28 ++-
 rdma/res.c                       | 486 +++++++++++++++++++++++++++++++++++++++
 rdma/utils.c                     | 321 +++++++++++++++++++++++++-
 8 files changed, 971 insertions(+), 25 deletions(-)
 create mode 100644 man/man8/rdma-resource.8
 create mode 100644 rdma/res.c
