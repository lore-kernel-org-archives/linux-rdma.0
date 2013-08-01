From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/3] XRC fixes
Date: Thu,  1 Aug 2013 18:49:51 +0300
Message-ID: <1375372194-23339-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Here are some XRC fixes from Yishai and Jack. 

Basically they all are fixes and have good match for 3.11, but if 
this works better for you, we can merge them for 3.12 too and 
later get them back in to 3.10 and 3.11 through -stable, please 
let me know what's your preference.

Sean, would love to get your review/ack for patches 2/3.

Or.


Yishai Hadas (3):
  net/mlx4_core: Fix XRC QPs detection in the resource tracker
  IB/core: Add locking around event dispatching on XRC target QPs
  IB/core: Fixes to XRC reference counting in uverbs

 drivers/infiniband/core/uverbs.h                   |    1 +
 drivers/infiniband/core/uverbs_cmd.c               |   22 ++++++++++++++++++-
 drivers/infiniband/core/verbs.c                    |    3 ++
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |    3 +-
 include/rdma/ib_verbs.h                            |    6 +++++
 5 files changed, 32 insertions(+), 3 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
