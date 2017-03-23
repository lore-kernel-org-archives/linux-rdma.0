From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 rdma-core 0/6] Enable mlx5 vendor functionality
Date: Thu, 23 Mar 2017 15:55:23 +0200
Message-ID: <1490277329-8738-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sending V2 to handle few notes from Jason, details below.

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
reference counting a verbs helper API was added, see patch #4 for further details.

Specifically this series:
Report whether mlx5 hardware supports multi packet send WQE offload for RAW QP.
- Multi packet WQE enables sending multiple fix sized packets using a single
  WQE. When the WQE is completed a single CQE will be generated.

Report CQE compressing capabilities and enable creating a CQ with such
capabilities.
- CQE compressing reduces PCI overhead by coalescing and compressing multiple
  CQEs into a single merged CQE. Successful compressing improves message rate
  especially for small packet traffic. 

The series is exposed from 6 patches:
#1:   Pre-patch which aligns mlx5 query device response to 64 bit.
#2-3: Report mlx5 specific hardware capabilities through direct verbs.
#4:   Enable an helper API for post CQ creation for providers.
#5:   Add support in mlx5 provider to create a CQ with compressed CQEs using
      private vendor data.
#6:   Bump package version and update debian relevant files.

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/103

Changes from V1:
Patch #4:
- Move to use an helper function from verbs instead of using some provider
  callback.
- Bump the whole IBVERBS_PRIVATE section to 14.
	  
Patch #5:
- Move to use the verbs helper API.
- Naming changes. (replaced 'vendor' and dropped 'ex')
- Update libmlx5.map to use coming version number.(i.e. 14).

An additional patch #6 was added:
- Bump package version and update debian relevant files.
- As a result the relevant libraries symlinks (verb, mlx5) has 1.14 in
  the name as expected. (Tested in both RH & debian).

Bodong Wang (3):
  mlx5: Explicitly align mlx5 query device response to 64 bit
  mlx5: Report multi packet send WQE capability for mlx5 based hardware
  mlx5: Report CQE compression capabilities through mlx5 direct verbs

Yishai Hadas (3):
  verbs: Expose verbs init CQ helper API
  mlx5: Expose direct create_cq with private data
  Bump version and update debian

 CMakeLists.txt                           |  2 +-
 debian/changelog                         |  5 ++-
 debian/ibverbs-providers.symbols         |  2 ++
 debian/libibverbs1.symbols               |  2 +-
 libibverbs/device.c                      | 38 ++++++++++++++---------
 libibverbs/driver.h                      |  3 ++
 libibverbs/ibverbs.h                     |  2 +-
 libibverbs/libibverbs.map                |  3 +-
 libibverbs/verbs.c                       | 26 ++++------------
 providers/mlx5/libmlx5.map               |  5 +++
 providers/mlx5/man/mlx5dv_query_device.3 |  1 +
 providers/mlx5/mlx5-abi.h                | 15 +++++++--
 providers/mlx5/mlx5.c                    | 17 +++++++++--
 providers/mlx5/mlx5.h                    |  6 ++++
 providers/mlx5/mlx5dv.h                  | 33 +++++++++++++++++++-
 providers/mlx5/verbs.c                   | 52 +++++++++++++++++++++++++++++---
 16 files changed, 163 insertions(+), 49 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
