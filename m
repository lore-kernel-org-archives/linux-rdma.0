From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH for-next 0/2] Support for Send Only Full Member Multicast Join
Date: Sun,  3 Jul 2016 15:47:52 +0300
Message-ID: <1467550074-24061-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Added UCMA and CMA support for multicast join flags. Flags are
passed using UCMA CM join command previously reserved fields.
Currently supporting two join flags indicating two different
multicast JoinStates:

1. Full Member:
  The initiator creates the Multicast group(MCG) if it wasn't
  previously created, can send Multicast messages to the group
  and receive messages from the MCG.

2. Send Only Full Member:
  The initiator creates the Multicast group(MCG) if it wasn't
  previously created, can send Multicast messages to the group
  but doesn't receive any messages from the MCG.

Since Send Only Full Member requires SM support a new cached
SA port attribute containing SM ClassPortInfo fields was added
(ClassPortInfo fields: Table 126 IB Spec 1.3.). The attribute
is cached to avoid resending queries, caching is done when a
successful ClassPortInfo reply is received on the port.
Invalidation of the attribute is done on SM change events,
SM re-registration events, and SM LID change events. The fields
in ClassPortInfo should not change during SM runtime without an
event.

These patches are available in the "topic/mc_join_only" branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/mc_join_only

Thanks

Alex Vesker (2):
  IB/sa: Add cached attribute containing SM information to SA port
  IB/core: Support for CMA multicast join flags

 drivers/infiniband/core/cma.c      | 98 +++++++++++++++++++++++++++++++++++---
 drivers/infiniband/core/sa_query.c | 51 ++++++++++++++++++--
 drivers/infiniband/core/ucma.c     | 18 +++++--
 include/rdma/ib_sa.h               |  5 ++
 include/rdma/rdma_cm.h             |  4 +-
 include/uapi/rdma/rdma_user_cm.h   |  9 +++-
 6 files changed, 168 insertions(+), 17 deletions(-)

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
