From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 00/14] Refactor ib_uverbs_write path
Date: Wed, 14 Feb 2018 14:38:30 +0200
Message-ID: <20180214123844.30321-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

This series comes as an outcome of [1] which was sent to rdma-rc
and it should be applied on top of that patch.

During review process of that patch, we realized that the
ib_uverbs_write() has number of flaws and this series
tries to fix them:
1. Localize all processing and verification code in specific functions.
2. Fix the command mask insufficient checks.
3. Simplify code to allow drop uverbs_ex_mask and in the future we
   will drop uverbs_mask too.
4. Fix differences in error codes.

Thanks

[1] https://marc.info/?l=linux-rdma&m=151851719021404&w=2

Leon Romanovsky (14):
  RDMA/uverbs: Convert command mask validity check function to be bool
  RDMA/uverbs: Update sizeof users
  RDMA/uverbs: Refactor flags checks and update return value
  RDMA/uverbs: Fail as early as possible if not enough header data was
    provided
  RDMA/uverbs: Return not supported error code for unsupported commands
  RDMA/uverbs: Unify return values of not supported command
  RDMA/uverbs: Refactor command header processing
  RDMA/uverbs: Properly check command supported mask
  RDMA/uverbs: Move uncontext check before SRCU read lock
  RDMa/uverbs: Copy ex_hdr outside of SRCU read lock
  RDMA/uverbs: Refactor the header validation logic
  RDMA/verbs: Return proper error code for not supported system call
  RDMA/verbs: Check existence of function prior to accessing it
  RDMA/verbs: Drop uverbs_ex_mask

 drivers/infiniband/core/core_priv.h   |   3 +
 drivers/infiniband/core/uverbs_cmd.c  |  21 ++++
 drivers/infiniband/core/uverbs_main.c | 219 ++++++++++++++++------------------
 drivers/infiniband/core/verbs.c       |  46 +++----
 drivers/infiniband/hw/mlx4/main.c     |  18 ---
 drivers/infiniband/hw/mlx5/main.c     |  15 ---
 include/rdma/ib_verbs.h               |   1 -
 7 files changed, 150 insertions(+), 173 deletions(-)

--
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
