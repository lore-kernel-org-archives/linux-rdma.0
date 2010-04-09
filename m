From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Fri, 09 Apr 2010 09:13:40 -0700
Message-ID: <adaiq80txhn.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Linus, please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few small fixes that have trickled in:

Chien Tung (1):
      RDMA/nes: Correct cap.max_inline_data assignment in nes_query_qp()

Dan Carpenter (1):
      IB/mlx4: Check correct variable for allocation failure

Jani Nikula (1):
      IB/cm: Fix device_create() return value check

Roland Dreier (1):
      Merge branches 'cma', 'misc', 'mlx4' and 'nes' into for-linus

shefty (1):
      RDMA/cm: Set num_paths when manually assigning path records

 drivers/infiniband/core/cm.c          |    2 +-
 drivers/infiniband/core/cma.c         |    1 +
 drivers/infiniband/hw/mlx4/mr.c       |    2 +-
 drivers/infiniband/hw/nes/nes_verbs.c |    9 ++++-----
 4 files changed, 7 insertions(+), 7 deletions(-)

-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
