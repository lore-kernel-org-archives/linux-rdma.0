From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 0/5] Enable mlx5 vendor functionality
Date: Tue, 21 Mar 2017 19:42:05 +0200
Message-ID: <1490118130-1039-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sending V1 as a follow-up version based on the discussion that was in the list
re the verbs patch that enabled CQ creation with vendor data, details below.

This patch set is the supplementary part of the kernel series that
was accepted few months ago into 4.10.

The below functionality was accepted in mlx5 kernel driver in the vendor
channel path as some driver specific capabilities and functionality, as such it
is exposed to user applications in the same manner by using the direct access
mechanism.

The vendor specific capabilities are reported via the direct mlx5 query
capabilities API.

In addition, an explicit API was added in mlx5 to enable creating a CQ with
some private data. This private data is passed to mlx5 kernel driver in the
vendor channel path.

This follows the requirement to have a more rigid, typed interface than
previous solution that was used on top of ibv_create_cq_ex().

To be able to share the libibverbs code of ibv_create_cq_ex() as of locking,
reference counting a verbs patch was added to enable any provider to register a
vendor create_cq API with libibverbs to be used as part of a direct CQ
creation. Please see patch #4 for further details.

Specifically this series:
Report whether mlx5 hardware supports multi packet send WQE offload for RAW QP.
- Multi packet WQE enables sending multiple fix sized packets using a single
  WQE. When the WQE is completed a single CQE will be generated.

Report CQE compressing capabilities and enable creating a CQ with such
capabilities.
- CQE compressing reduces PCI overhead by coalescing and compressing multiple
  CQEs into a single merged CQE. Successful compressing improves message rate
  especially for small packet traffic. 

The series is exposed from 5 patches:
#1:   Pre-patch which aligns mlx5 query device response to 64 bit.
#2-3: Report mlx5 specific hardware capabilities through direct verbs.
#4:   Enable private create_cq for providers.
#5:   Add support in mlx5 provider to create a CQ with compressed CQEs using
      private vendor data.

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/103
Bodong Wang (3):
  mlx5: Explicitly align mlx5 query device response to 64 bit
  mlx5: Report multi packet send WQE capability for mlx5 based hardware
  mlx5: Report CQE compression capabilities through mlx5 direct verbs

Yishai Hadas (2):
  verbs: Enable private create_cq for providers
  mlx5: Expose direct create_cq with private data

 libibverbs/device.c                      | 22 +++++++++++++---
 libibverbs/driver.h                      | 11 ++++++++
 libibverbs/ibverbs.h                     |  7 +----
 libibverbs/libibverbs.map                |  5 ++++
 libibverbs/verbs.h                       |  4 +++
 providers/mlx5/libmlx5.map               |  5 ++++
 providers/mlx5/man/mlx5dv_query_device.3 |  1 +
 providers/mlx5/mlx5-abi.h                | 15 +++++++++--
 providers/mlx5/mlx5.c                    | 26 +++++++++++++++++--
 providers/mlx5/mlx5.h                    |  9 +++++++
 providers/mlx5/mlx5dv.h                  | 33 +++++++++++++++++++++++-
 providers/mlx5/verbs.c                   | 44 +++++++++++++++++++++++++++++---
 12 files changed, 164 insertions(+), 18 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
