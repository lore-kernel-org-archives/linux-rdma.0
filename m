From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Wed, 08 Sep 2010 14:45:38 -0700
Message-ID: <adak4mvj4e5.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few small driver fixes.

Chien Tung (1):
      RDMA/nes: Write correct register write to set TX pause param

Faisal Latif (3):
      RDMA/nes: Fix double CLOSE event indication crash
      RDMA/nes: Change state to closing after FIN
      RDMA/nes: Fix hang with modified FIN handling on A0 cards

Roland Dreier (1):
      Merge branches 'cxgb3' and 'nes' into for-linus

Steve Wise (1):
      RDMA/cxgb3: Don't exceed the max HW CQ depth

 drivers/infiniband/hw/cxgb3/cxio_hal.h |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c     |   18 ++++++++++--------
 drivers/infiniband/hw/nes/nes_hw.c     |   14 +++++++++++++-
 drivers/infiniband/hw/nes/nes_hw.h     |    1 +
 drivers/infiniband/hw/nes/nes_nic.c    |    4 ++--
 5 files changed, 27 insertions(+), 12 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
