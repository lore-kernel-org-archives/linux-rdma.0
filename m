From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/6] IB/core: Small fixes and refactors for IDR locking series
Date: Tue, 18 Apr 2017 12:03:36 +0300
Message-ID: <1492506222-28999-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This series comes after the comments Sean and Jason sent in the linux-rdma
mailing list for the "Change IDR usage and locking in uverbs" series.
It's focused on small refactors, beautification and fixes
for that series. It doesn't aim to change anything logically.

Thanks,
Matan

Matan Barak (6):
  IB/core: Rename write flag to exclusive in rdma_core
  IB/core: Don't pass the lock state to _rdma_remove_commit_uobject
  IB/core: Nullify ib_uobject during allocation
  IB/core: A small refactor in destroy WQ handler
  IB/core: Don't use is_async in event files to infer events size
  IB/core: Rename uverbs event file structure

 drivers/infiniband/core/rdma_core.c        |  86 ++++++++---------
 drivers/infiniband/core/uverbs.h           |  21 +++--
 drivers/infiniband/core/uverbs_cmd.c       |  16 +---
 drivers/infiniband/core/uverbs_main.c      | 146 ++++++++++++++---------------
 drivers/infiniband/core/uverbs_std_types.c |  20 ++--
 include/rdma/uverbs_types.h                |  33 +++----
 6 files changed, 158 insertions(+), 164 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
