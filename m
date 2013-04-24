From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/9] Add receive Flow Steering support
Date: Wed, 24 Apr 2013 16:58:43 +0300
Message-ID: <1366811932-28199-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland, all

The first five patches in the series are mlx4 DMFS (Device Managed Flow 
Steering) pre-patches needed for flow steering access from the mlx4 IB driver.

  net/mlx4_core: Move DMFS HW structs to common header file
  net/mlx4: Match DMFS promiscuous field names to firmware spec
  net/mlx4_core: Change few DMFS fields names to match firmare spec
  net/mlx4_core: Directly expose fields of DMFS HW rule control segment
  net/mlx4_core: Expose few helpers to fill DMFS HW strucutures

We're submitting them through the rdma tree as the next patch depend on them,
please apply them for 3.10 this way (accepting also the next patches) or 
another (even if they are not accepted now), so we will not have extra 
dependencies with further changes on that area.

The next four patches add Flow Steering support to the kernel IB core, 
to uverbs and to the mlx4 IB (verbs) driver along with one patch
to uverbs which adds some code to support extensions.

  IB/core: Add receive Flow Steering support
  IB/core: Infra-structure to support verbs extensions through uverbs
  IB/core: Export ib_create/destroy_flow through uverbs
  IB/mlx4: Add receive Flow Steering support

The main patch which introduces the Flow-Steering API is "IB/core: Add receive Flow 
Steering support", see its change log. Looking on the "Network Adapter Flow Steering" 
slides from Tzahi Oved which he presented on the annual OFA 2012 meeting could be helpful
https://www.openfabrics.org/resources/document-downloads/presentations/doc_download/518-network-adapter-flow-steering.html

Or.


Hadar Hen Zion (8):
  net/mlx4_core: Move DMFS HW structs to common header file
  net/mlx4: Match DMFS promiscuous field names to firmware spec
  net/mlx4_core: Change few DMFS fields names to match firmare spec
  net/mlx4_core: Directly expose fields of DMFS HW rule control segment
  net/mlx4_core: Expose few helpers to fill DMFS HW strucutures
  IB/core: Add receive Flow Steering support
  IB/core: Export ib_create/destroy_flow through uverbs
  IB/mlx4: Add receive Flow Steering support

Igor Ivanov (1):
  IB/core: Infra-structure to support verbs extensions through uverbs

 drivers/infiniband/core/uverbs.h                |    3 +
 drivers/infiniband/core/uverbs_cmd.c            |  209 +++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c           |   42 ++++-
 drivers/infiniband/core/verbs.c                 |   30 +++
 drivers/infiniband/hw/mlx4/main.c               |  247 +++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c  |   16 +-
 drivers/net/ethernet/mellanox/mlx4/mcg.c        |  120 +++++++----
 drivers/net/ethernet/mellanox/mlx4/mlx4.h       |   79 -------
 include/linux/mlx4/device.h                     |  104 +++++++++-
 include/rdma/ib_verbs.h                         |  137 ++++++++++++-
 include/uapi/rdma/ib_user_verbs.h               |  118 +++++++++++-
 12 files changed, 960 insertions(+), 147 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
