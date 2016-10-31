From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] target: Fix queue-full callback error signaling
Date: Mon, 31 Oct 2016 05:25:51 +0000
Message-ID: <1477891554-26222-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Potnuri Bharat Teja <bharat@chelsio.com>, Steve Wise <swise@opengridcomputing.com>, Sagi Grimberg <sagi@grimberg.me>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

This series contains target-core queue-full + iscsi-target
callback fixes for a bug reported by Steve and Potnuri
during recent v4.8.y iWARP/iser-target testing.

The first patch fixes target-core queue-full handling response
leaks with non -EAGAIN / -ENOMEM errors.  It uses a new state
TRANSPORT_COMPLETE_QF_ERR to internally generate CHECK_CONDITION
for unknown fabric callback errors, to avoid attempting retry
of fabric data-transfer callbacks for this special case.

This means all non -EAGAIN / -ENOMEM fabric callback errors
during target_core_fabric_ops for:

  *) ->write_pending()
  *) ->queue_data_in()
  *) ->queue_status()

will result in CHECK_CONDITION + LOGICAL_UNIT_COMMUNICATION_FAILURE,
if no non-zero se_cmd->scsi_status was previously set.
It also means target-core ->queue_status() errors retry indefinately,
or until session shutdown explicitly stops outstanding I/O.

The remaining changes are for propagating iscsit_transport
response failure back to target-core queue-full, and updating
iser-target to propagate isert_rdma_rw_ctx_post() errors from
RDMA R/W API back to target-core as well.

Please review.

--nab

Nicholas Bellinger (3):
  target: Fix unknown fabric callback queue-full errors
  iscsi-target: Propigate queue_data_in + queue_status errors
  iser-target: Fix queue-full response handling

 drivers/infiniband/ulp/isert/ib_isert.c      |  53 +++++++++-----
 drivers/target/iscsi/iscsi_target.c          |   3 +-
 drivers/target/iscsi/iscsi_target_configfs.c |  13 ++--
 drivers/target/iscsi/iscsi_target_util.c     |   5 +-
 drivers/target/iscsi/iscsi_target_util.h     |   2 +-
 drivers/target/target_core_transport.c       | 102 ++++++++++++++++++---------
 include/target/target_core_base.h            |   1 +
 7 files changed, 114 insertions(+), 65 deletions(-)

-- 
1.9.1
