From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v2 00/10] iSER support for remote invalidate
Date: Wed,  9 Dec 2015 14:11:58 +0200
Message-ID: <1449663128-368-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: Or Gerlitz <ogerlitz@mellanox.com>, Jenny Derzhavetz <jennyf@mellanox.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org

Changes from v1:
- Fixed change-log typos

Changes from v0:
- Rebased on top of 4.4-rc2
- Removed iser_hello messages from the protocol header
- Avoided from further breaking the non-existent bidi support
- Fixed initiator remote invalidate support exposure only
  for fastreg && iser_always_register
- Removed patch 2/10 as it's still under testing.
- Minor line-spacing nitpicks CR comments fixes.
- Added a FIXME comment to declare our debt to Or and Jason
  on the awkward device->mr->rkey deref.
- Piggybacked another patch that reduces some iser code that
  is now available by the ib_core (ib_sg_to_pages).

Thanks a lot to all the reviewers!

Code is available at:
git@github.com:sagigrimberg/linux.git iser-remote-inv.2

Jenny Derzhavetz (5):
  IB/iser: Don't register memory for all immediate data writes
  IB/iser: set intuitive values for mr_valid
  iser-target: Declare correct flags when accepting a connection
  iser-target: Support the remote invalidation exception
  IB/iser: Support the remote invalidation exception

Roi Dayan (1):
  IB/iser: Fix module init not cleaning up on error flow

Sagi Grimberg (4):
  IB/iser: Reuse ib_sg_to_pages
  iser: Have initiator and target to share protocol structures and
    definitions
  iser-target: Remove unused file iser_proto.h
  IB/iser: Increment the rkey when registering and not when invalidating

 drivers/infiniband/ulp/iser/iscsi_iser.c     |   9 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h     |  54 +++-------
 drivers/infiniband/ulp/iser/iser_initiator.c |  70 +++++++++++--
 drivers/infiniband/ulp/iser/iser_memory.c    | 150 +++++++++------------------
 drivers/infiniband/ulp/iser/iser_verbs.c     |  30 ++++--
 drivers/infiniband/ulp/isert/ib_isert.c      |  73 +++++++++----
 drivers/infiniband/ulp/isert/ib_isert.h      |  40 ++++++-
 drivers/infiniband/ulp/isert/isert_proto.h   |  47 ---------
 include/scsi/iser.h                          |  78 ++++++++++++++
 9 files changed, 322 insertions(+), 229 deletions(-)
 delete mode 100644 drivers/infiniband/ulp/isert/isert_proto.h
 create mode 100644 include/scsi/iser.h

-- 
1.8.4.3
