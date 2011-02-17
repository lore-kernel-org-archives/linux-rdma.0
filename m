From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Thu, 17 Feb 2011 14:26:15 -0800
Message-ID: <1297981575-17431-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few small things:
 - Don't send events for nonexistent nes devices
 - Fix a couple of double events in qib

Maciej Sosnowski (1):
      RDMA/nes: Don't generate async events for unregistered devices

Mike Marciniszyn (2):
      IB/qib: Fix double add_timer()
      IB/qib: Prevent double completions after a timeout or RNR error

Roland Dreier (1):
      Merge branches 'nes' and 'qib' into for-next

 drivers/infiniband/hw/nes/nes_hw.c |   32 ++++++++++++++++++++------------
 drivers/infiniband/hw/qib/qib_rc.c |    5 ++++-
 2 files changed, 24 insertions(+), 13 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
