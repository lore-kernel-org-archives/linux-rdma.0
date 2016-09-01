From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs 0/3] SIF related libibverbs patches
Date: Thu,  1 Sep 2016 08:59:50 +0200
Message-ID: <1472713193-22397-1-git-send-email-knut.omang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is the initial patch series for the work of upstreaming the driver and
user level library for SIF, the new Oracle HCA. My philosophy here has been to
make the initial patches as little intrusive as possible, and rather consolidate
later. For instance patch 1 could have just changed the signature of ibv_cmd_create_ah but that
would have required a simultaneous change of all vendor libraries, which is
much easier to accomplish if they all end up in the same repository...

These patches are needed to support SIF - Oracle's new Infiniband HCA stack
from user mode. A corresponding patch set for the kernel will follow shortly.

I have been back and forth with whether or not an ABI version update is required/desired
for the (bugfix) patch 2 in this series, which will be followed by a corresponding patch
at the kernel level. This should ideally have been a backward compatible change since it does not
really logically change the APIs, but because the kernel checks for exact match of
sizes of the cmd structures instead of just accepting the expected size even if the
provided size is larger, both sides need to change simultaneously in this case to avoid
breaking (ibv_reg_mr). In fact, looking at the last ABI change it seems running with version
5 of the ABI on the kernel side is supported, but it will still fail due to the same reason.

No changes are needed for the vendor libraries, except that they need to be rebuilt against the
changed kern-abi.h file due to the same size check in the kernel.

We need this patch because we have a vendor specific extension to the ibv_reg_mr response,
which breaks if alignment criterias are violated.

This patch 2 and the corresponding kernel patch does not update the ABI version,
let me know what you think, if an update is desired, and what MIN and MAX versions
we would want to set.

Patch set:

Knut Omang (3):
  Add new call ibv_cmd_create_ah_ex which supports extra parameters
  Add padding to get proper end alignment of ibv_reg_mr_resp
  Provide remote XRC SRQ number in kernel post_send.

 include/infiniband/driver.h   |  4 ++++
 include/infiniband/kern-abi.h |  2 ++
 src/cmd.c                     | 55 ++++++++++++++++++++++++++-----------------
 src/libibverbs.map            |  1 +
 4 files changed, 40 insertions(+), 22 deletions(-)

--
2.5.5
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
