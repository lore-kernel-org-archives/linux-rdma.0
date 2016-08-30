From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 0/7] Extend flow steering IPv4 and IPv6 specification.
Date: Tue, 30 Aug 2016 16:58:29 +0300
Message-ID: <1472565516-11591-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set extends the IPv4 and IPv6 flow specification.

New fields in IPv4:
 1. Type of Service
 2. Time to Live
 3. Flags
 4. Protocol

New fields in IPv6:
 1. Traffic Class
 2. Flow Label
 3. Next Header
 4. Hop Limit

The first patch in this series adds support to extend the flow
steering specification. Previously, user flow specification
and kernel flow specification were must to be equal in their size.

To support extensions, we change the flow specifications conditions
test to be as following:
 1. Every mask field that is given by the user and doesn't exist in
    kernel is validated to be zero. Thus, new user-space would only fail
    if it's using (i.e field_mask != 0) a field which doesn't exist in
    the current kernel version.
 2. All types are known by the kernel.
 3. If the kernel is newer than the user-space, all fields (and by
    that, their masks) weren't given by the user are assumed as zeros
    and ignored.
 4. The ABI declares filters as 32bit aligned. This is necessary to
    avoid unaligned access when reading the header.

Changes from v0 to v1:
 * Add Reviewed-by from Sagi G.
 * Split mlx4, mlx5 and uverbs to separate patches
 * Rename IB/core to be IB/uverbs

Available in the "topic/ext-flow" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/ext-flow

Thanks,
  Maor & Leon

Maor Gottlieb (7):
  IB/mlx4: Add validation to flow specifications parsing
  IB/mlx5: Add validation to flow specifications parsing
  IB/uverbs: Add support to extend flow steering specifications
  IB/uverbs: Add more fields to IPv4 flow specification
  IB/uverbs: Add more fields to IPv6 flow specification
  IB/mlx5: Add support in TOS and protocol to flow steering
  IB/mlx5: Add support of more IPv6 fields to flow steering

 drivers/infiniband/core/uverbs_cmd.c | 102 ++++++++++++++++++++++++--------
 drivers/infiniband/hw/mlx4/main.c    |  25 ++++++++
 drivers/infiniband/hw/mlx5/main.c    | 110 ++++++++++++++++++++++++++++-------
 include/rdma/ib_verbs.h              |  25 ++++++++
 include/uapi/rdma/ib_user_verbs.h    |  13 ++++-
 5 files changed, 228 insertions(+), 47 deletions(-)

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
