From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 00/15] RDMA fixes for v4.16
Date: Tue, 13 Feb 2018 12:18:26 +0200
Message-ID: <20180213101841.20101-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

This is mostly fixes for uverbs layers with two extra patches: one from
Alaa, who removed annoying warning prints in IPoIB and another from Leon
who removed unimplented part of restrack code.

Thanks

Alaa Hleihel (1):
  IB/ipoib: Do not warn if IPoIB debugfs doesn't exist

Jason Gunthorpe (7):
  IB/uverbs: Use inline data transfer for UHW_IN
  IB/uverbs: Use u64_to_user_ptr() not a union
  IB/uverbs: Use __aligned_u64 for uapi headers
  IB/uverbs: Hold the uobj write lock after allocate
  IB/uverbs: Tidy lockdep_check
  IB/uverbs: Tidy uverbs_uobject_add
  IB/uverbs: Fix unbalanced unlock on error path for
    rdma_explicit_destroy

Leon Romanovsky (3):
  RDMA/restrack: Remove unimplemented XRCD object
  RDMA/uverbs: Protect from races between lookup and destroy of uobjects
  RDMA/uverbs: Protect from command mask overflow

Matan Barak (4):
  IB/uverbs: Always the attribute size provided by the user
  IB/uverbs: Fix method merging in uverbs_ioctl_merge
  IB/uverbs: Add ioctl support for 32bit processes
  IB/uverbs: Fix possible oops with duplicate ioctl attributes

 drivers/infiniband/core/rdma_core.c          | 51 +++++++++++++++++-----------
 drivers/infiniband/core/restrack.c           |  5 ---
 drivers/infiniband/core/uverbs_ioctl.c       |  3 ++
 drivers/infiniband/core/uverbs_ioctl_merge.c | 18 +++++-----
 drivers/infiniband/core/uverbs_main.c        | 29 ++++++++++++----
 drivers/infiniband/core/uverbs_std_types.c   | 12 ++++---
 drivers/infiniband/ulp/ipoib/ipoib_fs.c      |  2 --
 include/rdma/restrack.h                      |  4 ---
 include/rdma/uverbs_ioctl.h                  | 43 ++++++++++++++++-------
 include/uapi/rdma/rdma_user_ioctl.h          |  4 +--
 10 files changed, 107 insertions(+), 64 deletions(-)

--
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
