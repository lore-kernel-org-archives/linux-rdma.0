From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Fri,  7 Jun 2013 15:28:39 -0700
Message-ID: <1370644119-15200-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

InfiniBand fixes for 3.10-rc:
 - qib RCU/lockdep fix
 - iser device removal fix, plus doc fixes

----------------------------------------------------------------
Mike Marciniszyn (1):
      IB/qib: Fix lockdep splat in qib_alloc_lkey()

Or Gerlitz (2):
      IB/iser: Add Mellanox copyright
      MAINTAINERS: Add entry for iSCSI Extensions for RDMA (iSER) initiator

Roi Dayan (1):
      IB/iser: Fix device removal flow

Roland Dreier (1):
      Merge branches 'iser' and 'qib' into for-next

 MAINTAINERS                                  | 10 ++++++++++
 drivers/infiniband/hw/qib/qib_keys.c         |  2 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c     |  1 +
 drivers/infiniband/ulp/iser/iscsi_iser.h     |  1 +
 drivers/infiniband/ulp/iser/iser_initiator.c |  1 +
 drivers/infiniband/ulp/iser/iser_memory.c    |  1 +
 drivers/infiniband/ulp/iser/iser_verbs.c     | 16 +++++++++-------
 7 files changed, 24 insertions(+), 8 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
