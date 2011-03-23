From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Wed, 23 Mar 2011 10:47:57 -0700
Message-ID: <1300902477-6608-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the second batch of 2.6.39 changes:
 - Dave Dillow's SRP initiator changes
 - Fix to uninitialized return value introduced by net tree merge
 - A couple of other minor cleanups

David Dillow (7):
      IB/srp: always avoid non-zero offsets into an FMR
      IB/srp: move IB CM setup completion into its own function
      IB/srp: allow sg_tablesize to be set for each target
      IB/srp: rework mapping engine to use multiple FMR entries
      IB/srp: add support for indirect tables that don't fit in SRP_CMD
      IB/srp: try to use larger FMR sizes to cover our mappings
      IB: Increase DMA max_segment_size on Mellanox hardware

Michael Heinz (1):
      IB/mad: Improve an error message so error code is included

Roland Dreier (3):
      RDMA/nes: Don't print success message at level KERN_ERR
      Merge branch 'external-indirect' of git://git.kernel.org/.../dad/srp-initiator into srp
      Merge branches 'misc', 'nes' and 'srp' into for-next

Sean Hefty (1):
      RDMA/addr: Fix return of uninitialized ret value

 drivers/infiniband/core/addr.c           |    2 +-
 drivers/infiniband/core/agent.c          |    3 +-
 drivers/infiniband/hw/mthca/mthca_main.c |    3 +
 drivers/infiniband/hw/nes/nes.c          |    2 +-
 drivers/infiniband/ulp/srp/ib_srp.c      |  725 ++++++++++++++++++++----------
 drivers/infiniband/ulp/srp/ib_srp.h      |   38 ++-
 6 files changed, 521 insertions(+), 252 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
