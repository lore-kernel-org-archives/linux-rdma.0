From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 0/8] uverbs extensions fixes
Date: Wed, 30 Oct 2013 11:52:43 +0200
Message-ID: <1383126771-7658-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series is a continuous improvement for the uverbs extension mechanism
that was introduced as an experimental feature for v3.12.

Yann Droneaud suggested and implemented the following improvements:
- structure renaming to match others uverbs public structs;
- changes usage of the flow_attr.size to not count the
  "extended command header" but to describe only the size
  of the flow specs following flow_attr;
- removed unneeded flow_spec structure that don't need to be
  exposed to userspace.
- ensure 64bits alignment

This series is actually Yann's series with a bug fix.

Changes from Yann's series
(V0 http://marc.info/?l=linux-rdma&m=138151196022025):
1. Re-enable flow steering verbs and the extension verbs mechanism.
2. Squashed patches 1 and 2 from the original series
3. ib_uverbs_write should return the number of bytes including the
   header's size (Patch 7).


Matan Barak (2):
  IB/core: re-enable create_flow/destroy_flow uverbs
  IB/core: clarify overflow/underflow checks on ib_create/destroy_flow

Yann Droneaud (6):
  IB/core: Rename 'flow' structs to match other uverbs structs
  IB/core: Makes uverbs flow structure using names more similar to verbs
    ones
  IB/core: Uses a common header for uverbs flow_specs
  IB/core: Remove ib_uverbs_flow_spec structure from userspace
  IB/core: extended command: an improved infrastructure for uverbs
    commands
  IB/core: extended command: move comp_mask to the extended header

 drivers/infiniband/Kconfig            |  11 ---
 drivers/infiniband/core/uverbs.h      |  37 ++++++++--
 drivers/infiniband/core/uverbs_cmd.c  |  97 +++++++++++++------------
 drivers/infiniband/core/uverbs_main.c | 130 +++++++++++++++++++++++++---------
 drivers/infiniband/hw/mlx4/main.c     |   8 +--
 include/rdma/ib_verbs.h               |   1 +
 include/uapi/rdma/ib_user_verbs.h     | 101 ++++++++++++++------------
 7 files changed, 241 insertions(+), 144 deletions(-)

-- 
1.8.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
