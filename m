From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 0/5] USNIC and RAW enhancements series
Date: Tue, 24 Jan 2017 13:02:34 +0200
Message-ID: <20170124110239.31555-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Please find below second version og USNIC and RAW protocols enhancements from Or.

from: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This series adds the USNIC and RAW protocols to the core and relevant devices
(usnic, and mlx5/mlx4 over Eth ports) such that now the protocol part of the
caps covers all in-tree HW/SW devices.

It also contains a cleanup patch to the HW/SW drivers such that they use
ib_query_port when needed to query their own ports and not apply their
internal callback. The patch doesn't add new functionality but makes
the different drivers to be behave the same in that respect and makes
the IB stack code a little bit more robust and clear.

Thanks
---
Changelog v0->v1:
 * Change memset calls to use actual size of filled variable and not structure.
---
CC: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
CC: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
CC: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
CC: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
CC: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
CC: Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
CC: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
CC: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
CC: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
CC: Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
This patchset was generated against commit
f502d834950a ("net/mlx5: Activate support for 4K UARs") and it applies
cleanly on k.o/for-4.11 branch.

Available in the "topic/raw-qp-query-enhance" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/raw-qp-query-enhance

Or Gerlitz (5):
  IB/core: Add raw packet protocol
  IB/mlx5: Support raw packet protocol
  IB/mlx4: Support raw packet protocol
  IB: Add protocol for USNIC
  IB: Query port through the core instead of directly calling the driver
    handler

 drivers/infiniband/hw/cxgb3/iwch_provider.c     |  7 ++++---
 drivers/infiniband/hw/cxgb4/provider.c          |  8 ++++----
 drivers/infiniband/hw/hfi1/verbs.c              |  1 +
 drivers/infiniband/hw/hns/hns_roce_main.c       |  7 ++++---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c       |  8 ++++----
 drivers/infiniband/hw/mlx4/alias_GUID.c         |  1 +
 drivers/infiniband/hw/mlx4/main.c               | 23 +++++++++++++----------
 drivers/infiniband/hw/mlx4/sysfs.c              |  1 +
 drivers/infiniband/hw/mlx5/mad.c                |  2 +-
 drivers/infiniband/hw/mlx5/main.c               | 17 +++++++++++------
 drivers/infiniband/hw/mthca/mthca_provider.c    |  9 +++++----
 drivers/infiniband/hw/nes/nes_verbs.c           |  5 +++--
 drivers/infiniband/hw/ocrdma/ocrdma_main.c      |  9 +++++----
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c     |  1 +
 drivers/infiniband/hw/qedr/verbs.c              |  9 +++++----
 drivers/infiniband/hw/qib/qib_verbs.c           |  1 +
 drivers/infiniband/hw/usnic/usnic_ib_main.c     |  4 +++-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c    |  2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c  |  5 +++--
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c |  4 ++--
 drivers/infiniband/sw/rdmavt/vt.c               |  7 ++++---
 drivers/infiniband/sw/rxe/rxe_verbs.c           |  6 ++++--
 include/rdma/ib_verbs.h                         | 16 ++++++++++++++++
 23 files changed, 97 insertions(+), 56 deletions(-)

--
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
