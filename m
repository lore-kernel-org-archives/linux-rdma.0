From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 for-next 0/4] Add receive Flow Steering support
Date: Wed, 26 Jun 2013 15:57:40 +0300
Message-ID: <1372251464-13394-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland, all

These patches add Flow Steering support to the kernel IB core, to uverbs and 
to the mlx4 IB (verbs) driver along with one patch to uverbs which adds 
some code to support extensions.

  IB/core: Add receive Flow Steering support
  IB/core: Infra-structure to support verbs extensions through uverbs
  IB/core: Export ib_create/destroy_flow through uverbs
  IB/mlx4: Add receive Flow Steering support

The main patch which introduces the Flow-Steering API is "IB/core: Add receive Flow 
Steering support", see its change log. Looking on the "Network Adapter Flow Steering" 
slides from Tzahi Oved which he presented on the annual OFA 2012 meeting could be helpful
https://www.openfabrics.org/resources/document-downloads/presentations/doc_download/518-network-adapter-flow-steering.html

At high level, V2 fixed an issue which was found by Roland during the review. There are some
open questions posed by Roland on verbs extensions, will take it over the list as response
to another thread where it was raised.

V2 changes:
  - dropped struct ib_kern_flow from patch #3, this structure wasn't 
    used and was left there by mistake (bug, thanks Roland)

  - removed the void *flow_context field from struct ib_flow, this was 
    pointing to driver private data for that flow, but doesn't belong here, 
    i.e need not be seen by the verbs consumer but rather hidden.

  - renamed struct mlx4_flow_handle to mlx4_ib_flow, a structure that contains 
    the verbs level struct ib_flow and the mlx4 registeration ID for that flow

V1 changes:

 - dropped the five pre-patches which were accepted into 3.10
 - rebased the patches against Roland's for-next / 3.10-rc4
 - in patch #3, ib_uverbs_destroy_flow was returning too quickly when the driver
   returned failure for ib_destroy_flow, need to free some uverbs resources 1st.
 - in patch #4, check index before accessing the array at mlx4_ib_create/destroy_flow

V0 has been acknowledged by Steve and Christoph, and was also got positive feedback from 
Sean and Jason over f2f talks we had during the Linux Foundation EU summit on last month.

Or.


Hadar Hen Zion (3):
  IB/core: Add receive Flow Steering support
  IB/core: Export ib_create/destroy_flow through uverbs
  IB/mlx4: Add receive Flow Steering support

Igor Ivanov (1):
  IB/core: Infra-structure to support verbs extensions through uverbs

 drivers/infiniband/core/uverbs.h      |    3 +
 drivers/infiniband/core/uverbs_cmd.c  |  206 +++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c |   42 +++++-
 drivers/infiniband/core/verbs.c       |   30 ++++
 drivers/infiniband/hw/mlx4/main.c     |  244 +++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h  |   12 ++
 include/linux/mlx4/device.h           |    5 -
 include/rdma/ib_verbs.h               |  136 ++++++++++++++++++-
 include/uapi/rdma/ib_user_verbs.h     |  112 +++++++++++++++-
 9 files changed, 776 insertions(+), 14 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
