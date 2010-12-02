From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Thu, 02 Dec 2010 10:57:40 -0800
Message-ID: <aday688knob.fsf@cisco.com>
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

Just a few small things here:

 - Fix a minor leak of a few bytes of kernel stack
 - MAINTAINERS update
 - Fix a few small issues introduced with the merge of IBoE support in 2.6.37-rc1

Chien Tung (1):
      MAINTAINERS: Update NetEffect entry

Eli Cohen (4):
      IB/mlx4: Fix memory ordering of VLAN insertion control bits
      mlx4_core: Workaround firmware bug in query dev cap
      IB/mlx4: Fix IBoE reported link rate
      IB/mlx4: Fix IBoE link state

Or Gerlitz (1):
      IB/pack: Remove some unused code added by the IBoE patches

Roland Dreier (1):
      Merge branches 'misc', 'mlx4' and 'nes' into for-next

Vasiliy Kulikov (1):
      IB: Fix information leak in marshalling code

 MAINTAINERS                               |    3 +-
 drivers/infiniband/core/ud_header.c       |   30 -----------------------------
 drivers/infiniband/core/uverbs_marshall.c |    4 +++
 drivers/infiniband/hw/mlx4/main.c         |    4 +-
 drivers/infiniband/hw/mlx4/qp.c           |   10 ++++----
 drivers/net/mlx4/fw.c                     |    4 +++
 6 files changed, 16 insertions(+), 39 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
