From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [pull request][rdma-next 0/8] Export device and port properties
Date: Tue, 15 Aug 2017 12:14:23 +0300
Message-ID: <20170815091431.12822-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

This is the third part of RDMAtool infrastructure changes. In this series,
I'm exporting various device and port properties which are parsed in
RDMAtool.

Due to the fact, that the "IB/hfi1: Document phys port state bits not
used in IB", I embed its content into the actual patches.

As part of this series, I performed small code cleanup to improve our
static checker situation.

Thanks

Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
----------------------------------------------------------------
The following changes since commit 30307f91febf1b99947307a479c0a82c3af72f93:

  Documentation: Hardware tag matching (2017-08-15 11:46:45 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-08-15-2

for you to fetch changes up to 9335303fee9bac70b5d5c143126b846d20df56d6:

  RDMA: Use defines instead of hard coded value for phys_state (2017-08-15 11:46:53 +0300)

----------------------------------------------------------------
Export port properties, physical state and node types to the UAPI

----------------------------------------------------------------
Leon Romanovsky (8):
      RDMA/mlx4: Properly annotate link layer variable
      RDMA/core: Export device capabilities flags
      RDMA/core: Provide node type flags
      RDMA/core: Move port capabilities to UAPI
      RDMA/core: Move port state to UAPI and rename it to be link
      RDMA/core: Add physical link state information to the UAPI
      RDMA/nes: Remove zeroed parameter from port query callback
      RDMA: Use defines instead of hard coded value for phys_state

 drivers/infiniband/core/sysfs.c              |  24 ++--
 drivers/infiniband/hw/bnxt_re/ib_verbs.c     |   4 +-
 drivers/infiniband/hw/hfi1/opa_compat.h      |  30 ++--
 drivers/infiniband/hw/hns/hns_roce_main.c    |   4 +-
 drivers/infiniband/hw/mlx4/main.c            |   4 +-
 drivers/infiniband/hw/mlx4/qp.c              |   6 +-
 drivers/infiniband/hw/mlx5/main.c            |   4 +-
 drivers/infiniband/hw/nes/nes_verbs.c        |   5 -
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |   4 +-
 drivers/infiniband/hw/qedr/verbs.c           |   4 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |   6 +-
 drivers/infiniband/sw/rxe/rxe_param.h        |   2 +-
 include/rdma/ib_verbs.h                      | 135 +++++++++---------
 include/uapi/rdma/ib_user_verbs.h            |   1 +
 include/uapi/rdma/rdma.h                     | 196 +++++++++++++++++++++++++++
 15 files changed, 314 insertions(+), 115 deletions(-)
 create mode 100644 include/uapi/rdma/rdma.h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
