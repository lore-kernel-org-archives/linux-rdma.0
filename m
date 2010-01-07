From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Thu, 07 Jan 2010 11:30:25 -0800
Message-ID: <adafx6hr9v2.fsf@roland-alpha.cisco.com>
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

This will get a few very small fixes that have trickled in over the
holidays.

Eli Cohen (1):
      mlx4_core: Fix cleanup in __mlx4_init_one() error path

Jack Morgenstein (1):
      IB/mlx4: Initialize SRQ scatter entries when creating an SRQ

Or Gerlitz (1):
      IB/mlx4: Fix queue overflow check in post_recv

Robert P. J. Day (1):
      IB/addr: Correct CONFIG_IPv6 to CONFIG_IPV6

Roland Dreier (1):
      Merge branches 'misc' and 'mlx4' into for-next

 drivers/infiniband/core/cma.c    |    2 +-
 drivers/infiniband/hw/mlx4/qp.c  |    2 +-
 drivers/infiniband/hw/mlx4/srq.c |    6 ++++++
 drivers/net/mlx4/main.c          |    2 +-
 4 files changed, 9 insertions(+), 3 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
