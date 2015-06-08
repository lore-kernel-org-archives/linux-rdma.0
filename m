From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/5] Indirect memory registration feature
Date: Mon,  8 Jun 2015 16:15:34 +0300
Message-ID: <1433769339-949-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey All,

This patchset introduce a feature called indirect memory registration.

The RDMA stack has always imposed constraints on the nature of a given list
of buffers for memory registration. The scatter list of buffers must meet
the condition where all the SG elements must have a minimum block alignment
(page_shift) and the first SG element is allowed to have a first byte offset.

This can make life hard for ULPs that want to support any arbitrary scattered
lists that don't meet the above constraint. Two immediate examples are iser
and srp which can be handed with SG lists which are not "nicely" aligned while
several components in the IO stack (e.g. block, scsi) support arbitrary SG
lists. Some work loads can yield such SG lists quite commonly.
This introduces a challenge for RDMA storage protocols.

There are couple of possible (sub-optimal) solutions to handle this limitation:
- srp can use multiple memory regions to register a single SG list and send an
  indirect data buffer descriptor. The down-side in this approach is that in certain
  work loads, srp may not have sufficient available resources (i.e. memory regions)
  to register a scsi SG list which will cause the dynamic queue size to shrink and
  cause unpredictable latencies. Another (minor) down-side is that an indirect
  descriptor will cause the target to initiate multiple rdma reads/writes (one for
  each rkey).

- This is not possible for iser. The iser protocol mandates that only a single stag can
  be sent for a unidirectional IO. Two possible solutions are:
  * Allocate a well aligned buffer list and copy the data to/from this SG list
    of buffers (has the obvious down-side of not being zero-copy, and introduces atomic
    allocations in the IO path).
  * Hold another pool of MRs with the minimal block alignment guaranteed from scsi (512B)
    and resort to this pool for an unaligned SG list. The down-sides here are:
    - This does not cover SG-IO where there is no minimal alignment
    - involves a heuristic approach for this pool size
    - Impact of cache misses imposed by longer page lists registered in the
      device translation tables

Indirect memory registration solves this problem by allowing the application/ULP to pass
a list of ib_sge elements which can be byte aligned. The proposed API attempts to follow
the well-known fast registration scheme and can be easily adopted in any application.

Note: We ran out of capability bits in the device_cap_flags, so I modified the field to
      be a (u64). I can alternatively introduce a second device_cap_flags2 if this has
      negative effects with user-space. 

See a former discussion on the RFC version of this in
http://marc.info/?l=linux-rdma&w=2&r=1&s=indirect+fast+memory+registration&q=b

I'll appreciate the community's code review.

Adir Lev (1):
  IB/iser: Add indirect registration support

Sagi Grimberg (4):
  IB/core: Introduce Fast Indirect Memory Registration verbs API
  IB/mlx5: Implement Fast Indirect Memory Registration Feature
  IB/iser: Pass iser device to registration routines
  IB/iser: Add debug prints to the various memory registration methods

 drivers/infiniband/core/verbs.c           |   28 +++++++
 drivers/infiniband/hw/mlx5/cq.c           |    2 +
 drivers/infiniband/hw/mlx5/main.c         |    4 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h      |   19 +++++
 drivers/infiniband/hw/mlx5/mr.c           |   66 +++++++++++++++++
 drivers/infiniband/hw/mlx5/qp.c           |  106 +++++++++++++++++++++++++++
 drivers/infiniband/ulp/iser/iscsi_iser.h  |    8 ++
 drivers/infiniband/ulp/iser/iser_memory.c |  112 +++++++++++++++++++++++++++--
 drivers/infiniband/ulp/iser/iser_verbs.c  |   53 ++++++++++++--
 include/rdma/ib_verbs.h                   |   52 +++++++++++++-
 10 files changed, 434 insertions(+), 16 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
