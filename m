From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/5] Enable mlx5 vendor functionality
Date: Mon,  6 Mar 2017 16:06:39 +0200
Message-ID: <1488809204-30428-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set from Bodong is the supplementary part of the kernel series that
was accepted few months ago into 4.10.

The below functionality was accepted in mlx5 kernel driver in the vendor
channel path as some driver specific capabilities and functionality, as such it
is exposed to user applications in the same manner by using the direct access
mechanism.

The vendor specific capabilities are reported via the direct mlx5 query
capabilities API.

In addition, an option is added to provide vendor private data when creating a
CQ.  This option drops the need to extend the verbs layer each time with some
non-generic fields when creating a CQ. It adds an option to set some opaque
vendor data in some generic way which can fit any vendor, further details are
available in the commit log itself.

Specifically:
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
#4:   Extend ibv_create_cq_ex to get some vendor opaque data.
#5:   Add support in mlx5 provider to create a CQ with compressed CQEs using
      the vendor data.

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/90

Bodong Wang (5):
  mlx5: Explicitly align mlx5 query device response to 64 bit
  mlx5: Report multi packet send WQE capability for mlx5 based hardware
  mlx5: Report CQE compression capabilities through mlx5 direct verbs
  verbs: Add an option to provide vendor private data when creating a CQ
  mlx5: Add support to create a CQ with compressed CQEs

 libibverbs/man/ibv_create_cq_ex.3        |  2 ++
 libibverbs/verbs.h                       |  5 +++-
 providers/mlx5/man/mlx5dv_query_device.3 |  1 +
 providers/mlx5/mlx5-abi.h                | 15 ++++++++++--
 providers/mlx5/mlx5.c                    | 17 +++++++++++--
 providers/mlx5/mlx5.h                    |  6 +++++
 providers/mlx5/mlx5dv.h                  | 30 ++++++++++++++++++++++-
 providers/mlx5/verbs.c                   | 42 ++++++++++++++++++++++++++++++--
 8 files changed, 110 insertions(+), 8 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
