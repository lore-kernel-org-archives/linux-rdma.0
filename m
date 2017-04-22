From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/4] Sparse fixes for 4.12
Date: Sat, 22 Apr 2017 17:28:48 +0300
Message-ID: <20170422142852.18882-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Please find below 4 patches, which fix 45 sparse warnings.

Patches #1 and #2 are trivial changes. The first adds static keyword
to the functions declarations and second adds includes of the relevant
headers.

Patch #3 refactors code to get rid of one temporal variable. That variable
was needed to determine if QP is found. Once removed, it allowed to write
the code with lock and unlock placed together.

Patch #4 fixes wrong type casting. The opcode is in CPU format and wqe_word
is in le32 format.

This series is based on k.o/for-4.12-rdma-netdevice branch.

Thanks

Leon Romanovsky (4):
  Ib/core: Mark local uverbs_std_types functions to be static
  Ib/usnic: Explicitly include usnic headers
  IB/usnic: Simplify the code to balance loc/unlock calls
  IB/nes: Fix incorrect type in assignment

 drivers/infiniband/core/uverbs_std_types.c   | 48 ++++++++++++++--------------
 drivers/infiniband/hw/nes/nes_hw.c           |  2 +-
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c |  1 +
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 46 +++++++++++++-------------
 4 files changed, 50 insertions(+), 47 deletions(-)

--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
