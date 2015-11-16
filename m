From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH for-next 00/10] iSER support for remote invalidate
Date: Mon, 16 Nov 2015 18:37:31 +0200
Message-ID: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

This patchset adds remote invalidation support to iser initiator and
target. The support negotiation for this feature is based on IBTA
annex 12 "Support for iSCSI Extensions for RDMA" carried in rdma_cm
private data.

Remote invalidation allows a peer host to invalidate a remote key
as part of a SEND operation. This feature allows a host to avoid
invalidating an rkey locally. By supporting this feature iser initiator
can save extra latency and processing time yielded by invalidating 
the memory key locally.

The initiator feature support is dependent on:
- fastreg is used (not FMR)
- always_register=Y

In this case the initiator will expose support for remote invalidation,
however it will not blindly rely on the target to do so and will verify
that in the work completion information. The iser target now looks into
the iser header in the CM request and in case the initiator supports
remote invalidation it will respond it will use remote invalidation for
provided remote keys.

Initial Benchmarks (CIB/CX4) shows a moderate IOPs improvements under
high workloads (7%-10%). CX3 devices should show dramatic increase in
performance as it has strict fencing policies for rkey invalidation.
Would be nice to benchmark this in iWARP too (Steve ;)).

- Patch 1 is just a small fixup piggybacked to this set.
- Patches 2-4 are preping the ground for remote invalidate support.
- Patches 5-6 centralize protocol related stuff to a central header.
- Patches 7-8 adds iser target remote invalidation support.
- Patches 9-10 adds iser initiator remote invalidate support.

Jenny Derzhavetz (5):
  IB/iser: Don't register memory for all immediatedata writes
  IB/iser: set intuitive values for mr_valid
  iser-target: Declare correct flags when accepting a connection
  iser-target: Support the remote invalidation exception
  IB/iser: Support the remote invalidation exception

Roi Dayan (1):
  IB/iser: fix module init not cleaning up on error flow

Sagi Grimberg (4):
  IB/iser: Default to fastreg instead of fmr
  iser: Have initiator and target to share protocol structures and
    definitions
  iser-target: Remove unused file iser_proto.h
  IB/iser: Increment the rkey when registering and not when invalidating

 drivers/infiniband/ulp/iser/iscsi_iser.c     |   9 ++-
 drivers/infiniband/ulp/iser/iscsi_iser.h     |  47 +++---------
 drivers/infiniband/ulp/iser/iser_initiator.c |  66 ++++++++++++++--
 drivers/infiniband/ulp/iser/iser_memory.c    |  46 +++++------
 drivers/infiniband/ulp/iser/iser_verbs.c     |  28 ++++---
 drivers/infiniband/ulp/isert/ib_isert.c      |  66 +++++++++++-----
 drivers/infiniband/ulp/isert/ib_isert.h      |  39 +++++++++-
 drivers/infiniband/ulp/isert/isert_proto.h   |  47 ------------
 include/scsi/iser.h                          | 109 +++++++++++++++++++++++++++
 9 files changed, 310 insertions(+), 147 deletions(-)
 delete mode 100644 drivers/infiniband/ulp/isert/isert_proto.h
 create mode 100644 include/scsi/iser.h

-- 
1.8.4.3
