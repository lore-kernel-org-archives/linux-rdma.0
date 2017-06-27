From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V3 0/5] Refactor RDMA netlink infrastructure
Date: Tue, 27 Jun 2017 08:00:23 +0300
Message-ID: <20170627050028.17902-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following patch set is a preparation to addition of
netlink handlers to support RDMA tool. It simplifies the code,
removes useless client infrastructure, concentrates netlink validity
checks and allows future patches to remove a lot of dead code
from iwcm* code base (all operations related to nl_clients).

It is based on already sent to the mailing list patch [1]
"Revert "IB/core: Add flow control to the portmapper netlink calls""

[1] https://patchwork.kernel.org/patch/9752865/

Changelog
v2->v3:
 * Rebase on top -rc4.
v1->v2:
 * Added Chien's ROB tags
 Patch #1:
  * Annotate max_num_ops with "static const" to calculate the value once only.

v0->v1:
 * Moved to separate topic from rdmatool.
 Patch #1:
  * Add check to catch already initialized callback table to avoid
    double registration of the same protocol.
  * Rewrite the validity check to use array instead of switch().

CC: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
CC: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Available in the "topic/betlink-refactor-v3" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/netlink-refactor-v3

Leon Romanovsky (5):
  RDMA/netlink: Remove netlink clients infrastructure
  RDMA/netlink: Remove redundant owner option for netlink callbacks
  RDMA/netlink: Avoid double pass for RDMA netlink messages
  RDMA/iwcm: Remove useless check of nelink client validity
  RDMA/iwcm: Remove extra EXPORT_SYMBOLS

 drivers/infiniband/core/cma.c       |   9 +-
 drivers/infiniband/core/core_priv.h |   4 +-
 drivers/infiniband/core/device.c    |  41 ++----
 drivers/infiniband/core/iwcm.c      |  10 +-
 drivers/infiniband/core/iwpm_msg.c  |  12 --
 drivers/infiniband/core/iwpm_util.c |  11 --
 drivers/infiniband/core/netlink.c   | 249 +++++++++++++++++++-----------------
 include/rdma/rdma_netlink.h         |  14 +-
 8 files changed, 155 insertions(+), 195 deletions(-)

--
2.13.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
