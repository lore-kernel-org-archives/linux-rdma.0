From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 00/10] Support RAW Ethernet when RoCE is disabled
Date: Sun, 27 Nov 2016 16:51:26 +0200
Message-ID: <1480258296-27032-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Please find below the patch set from Or. I didn't add version notation to this
patch set, because it was enriched extensively over initial version [1], from
one mlx5-only patch to native IB core support.

It is tested against v4.9-rc6.

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

On some environments, such as certain SRIOV VF configurations, RoCE is
not supported for mlx5 Ethernet ports. Currently, the driver will not
open IB device on that port.

This is problematic, since we do want user-space RAW Ethernet (RAW_PACKET QPs)
functionality to remain in place. For that end, we change the relevant driver
flows such that an IB device instance is created in that case as well.

Following the previous post [1], Doug wanted us to enable a way for
applications to query what QP types are actually supported on a device.
This series adds that functionality on device/port granularity, since
some drivers (mlx4) could support different protocols per port and
hence different QP types per port.

QP types are basically derived from the protocol/s supported on the port. We
added two protocols (raw packet and usnic) to have a protocol set which is
consistent with what is currently upstream.

Patches 1-7 deal with the new query and patches 8-10 with the mlx5 specific
changes.

To make it clear, the upstream kernel IB core is fully functional without the
new port attribute, in the sense that no errors are seen from components that
e.g use SMI and GSI services. The query is mostly targeted to user-space.

Thanks, Or.

[1] https://patchwork.kernel.org/patch/9096351/

---------------------------------------------------------------------------------------
Available in the "topic/raw-ibdev" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/raw-ibdev
---------------------------------------------------------------------------------------

CC: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
CC: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
CC: "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
CC: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
CC: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
CC: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
CC: Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
CC: Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
CC: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
CC: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Or Gerlitz (10):
  IB/core: Add raw packet protocol
  IB/mlx5: Support raw packet protocol
  IB/mlx4: Support raw packet protocol
  IB: Add protocol for USNIC
  IB: Query port through the core instead of directly calling the driver
    handler
  IB/core: Enable to query QP types supported by IB device on a port
  IB/uverbs: Propagate supported QP types to user-space
  IB/mlx5: Refactor registration to netdev notifier
  IB/mlx5: Rename RoCE related helpers to reflect being Eth ones
  IB/mlx5: Support RAW Ethernet when RoCE is disabled

 drivers/infiniband/core/device.c             | 28 +++++++++
 drivers/infiniband/core/uverbs_cmd.c         |  2 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |  7 ++-
 drivers/infiniband/hw/cxgb4/provider.c       |  8 +--
 drivers/infiniband/hw/hfi1/verbs.c           |  1 +
 drivers/infiniband/hw/hns/hns_roce_main.c    | 10 ++-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c    |  8 +--
 drivers/infiniband/hw/mlx4/alias_GUID.c      |  1 +
 drivers/infiniband/hw/mlx4/main.c            | 23 ++++---
 drivers/infiniband/hw/mlx4/sysfs.c           |  1 +
 drivers/infiniband/hw/mlx5/mad.c             |  2 +-
 drivers/infiniband/hw/mlx5/main.c            | 91 +++++++++++++++++-----------
 drivers/infiniband/hw/mthca/mthca_provider.c |  9 +--
 drivers/infiniband/hw/nes/nes_verbs.c        |  5 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   |  9 +--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |  1 +
 drivers/infiniband/hw/qedr/verbs.c           | 11 ++--
 drivers/infiniband/hw/qib/qib_verbs.c        |  1 +
 drivers/infiniband/hw/usnic/usnic_ib_main.c  |  4 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |  2 +-
 drivers/infiniband/sw/rdmavt/vt.c            |  7 ++-
 drivers/infiniband/sw/rxe/rxe_verbs.c        |  6 +-
 include/rdma/ib_verbs.h                      | 17 ++++++
 include/uapi/rdma/ib_user_verbs.h            |  2 +-
 24 files changed, 173 insertions(+), 83 deletions(-)

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
