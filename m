From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 00/10] mlx4: Add Memory Windows support
Date: Wed,  6 Feb 2013 18:19:06 +0200
Message-ID: <1360167556-20756-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shanim-xlywION9k29BDgjK7y7TUQ@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Here's a series from Shani Michaeli and Haggai Eran adds mlx4 driver 
support for Memory Windows.

The first entries in this set are "pre patches" preparing the grounds for the 
actual implementation of MWs. Later there're two core patches, one to 
ib_verbs.h adding support for type 2 MWs and another one to uverbs that 
exposes MW commands to user space. And finally the actual mlx4 driver 
MWs patches.

Or.


Shani Michaeli (10):
  IB/mlx4_ib: Remove local invalidate segment unused fields
  net/mlx4_core: Rename MPT related service routines to have mpt_ prefix
  net/mlx4_core: Propogate MR deregistration failure
  net/mlx4_core: Disable memory windows for VFs
  net/mlx4_core: Enable memory windows in {INIT,QUERY}_HCA
  IB/core: Enhance memory windows support
  IB/uverbs: Implement memory windows support in uverbs
  mlx4: Implement memory windows allocation and deallocation
  IB/mlx4_ib: Support memory window binding
  IB/mlx4_ib: Advertize MW support

 drivers/infiniband/core/uverbs.h                   |    2 +
 drivers/infiniband/core/uverbs_cmd.c               |  121 +++++++++++++
 drivers/infiniband/core/uverbs_main.c              |   13 ++-
 drivers/infiniband/core/verbs.c                    |    5 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |    5 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c              |   15 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |    2 +-
 drivers/infiniband/hw/cxgb4/mem.c                  |    5 +-
 drivers/infiniband/hw/ehca/ehca_iverbs.h           |    2 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c             |    5 +-
 drivers/infiniband/hw/mlx4/main.c                  |   19 ++
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |   14 ++
 drivers/infiniband/hw/mlx4/mr.c                    |   87 +++++++++-
 drivers/infiniband/hw/mlx4/qp.c                    |   41 ++++-
 drivers/infiniband/hw/nes/nes_verbs.c              |   19 ++-
 drivers/net/ethernet/mellanox/mlx4/en_main.c       |    4 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |   14 ++-
 drivers/net/ethernet/mellanox/mlx4/fw.h            |    1 +
 drivers/net/ethernet/mellanox/mlx4/main.c          |    4 +
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |   34 +++-
 drivers/net/ethernet/mellanox/mlx4/mr.c            |  186 +++++++++++++++-----
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |   63 ++++++-
 include/linux/mlx4/device.h                        |   22 ++-
 include/linux/mlx4/qp.h                            |   19 ++-
 include/rdma/ib_verbs.h                            |   73 +++++++-
 include/uapi/rdma/ib_user_verbs.h                  |   16 ++
 net/sunrpc/xprtrdma/verbs.c                        |   20 +-
 27 files changed, 683 insertions(+), 128 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
