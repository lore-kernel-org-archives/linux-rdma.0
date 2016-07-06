From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH V1 for-next 0/2] Support for Send Only Full Member multicast join
Date: Wed,  6 Jul 2016 16:36:33 +0300
Message-ID: <1467812195-22221-1-git-send-email-leon@kernel.org>
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

The changes compared to v0 of this patch series are:
 * Use multicast.c join state enum instead of the new added bits
   defined by IB_SA_MCMEMBER_REC_JOIN_STATE in ib_sa.h
 * Remove ib_sa_port struct alignment spaces

Alex Vesker (2):
  IB/sa: Add cached attribute containing SM information to SA port
  IB/core: Support for CMA multicast join flags

 drivers/infiniband/core/cma.c       | 98 ++++++++++++++++++++++++++++++++++---
 drivers/infiniband/core/multicast.c | 12 -----
 drivers/infiniband/core/sa_query.c  | 41 ++++++++++++++++
 drivers/infiniband/core/ucma.c      | 18 +++++--
 include/rdma/ib_sa.h                | 13 +++++
 include/rdma/rdma_cm.h              |  4 +-
 include/uapi/rdma/rdma_user_cm.h    |  9 +++-
 7 files changed, 171 insertions(+), 24 deletions(-)

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
