From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v2 00/12] T10-DIF Initial support for iSER target
Date: Wed, 19 Feb 2014 17:50:13 +0200
Message-ID: <1392825025-29943-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: target-devel@vger.kernel.org, roland@kernel.org, linux-rdma@vger.kernel.org, oren@mellanox.com, martin.petersen@oracle.com
List-Id: linux-rdma@vger.kernel.org

Hey Nic,

I addressed your comments in the this set. I'll try to send the
initiator code for review in the next couple of days.

This patchset introduces target side T10-PI offload support over
RDMA. Currently the implementation is for iSER transport but can
be easily extended to SRP (or FCoE in the future).

Should mention that this patchset depends on RDMA signature
verbs making it for inclusion which will hopefully happen in
near future.

This code was tested against iSER legacy initiator, and also
initiator that uses T10-PI offload as well. I'll clean up the
initiator code in the following days and submit that as well.

This code works under medium loads using backstores:
- FileIO with DIF emulation.
- RD with DIF emulation.
- iBLOCK (scsi_debug with DIF support).

Chnages from v1:
- Rebased rdma_dif (3.14-rc2)
- Target core:
  - Pass zero_flag=true to alloc_sgl for protection buffers
  - Removed Unneeded inline function rwprotect
  - Pass is_write bool to sbc_set_prot_op_checks
  - Send failure response for absence of protection buffers
    when needed.
- iSER:
  - Removed unneeded assignments in isert_set_sig_attrs

Chnages from v0:
- Rebased from for-next
- Target core:
  - Don't minor fixes for check_prot - to support transports
    that doesn't use submit_map_sgls.
  - file  format - use escape values.
  - Removed redundant prot_handover.
  - Added protection checks and operation set.
- iSER:
  - Added preperation routines for mapping/unmapping buffers
    to ease the amount of code in isert_reg_rdma.
  - Fixed print of DIF error (sector instead of offset).
  - Fix RDMA length for protection on wire domain.
  - Refactored reg_sig_mr to use helper routines.

Sagi Grimberg (12):
  Target/transport: Allocate protection sg if needed
  Target/sbc: Set protection operation and relevant checks
  Target/file: place escape values for protection information format
  Target/sbc: don't return from sbc_check for non prot_sg
  Target/core: Remove prot_handover use for now
  Target/iscsi: Add T10-PI indication for iscsi_portal_group
  Target/configfs: Expose iSCSI network portal group T10-PI support
  Target/sbc: add debug print
  IB/isert: Introduce isert_map/unmap_data_buf
  IB/isert: Initialize T10-PI resources
  IB/isert: Accept RDMA_WRITE completions
  IB/isert: Support T10-PI protected transactions

 drivers/infiniband/ulp/isert/ib_isert.c      |  668 ++++++++++++++++++++------
 drivers/infiniband/ulp/isert/ib_isert.h      |   38 ++-
 drivers/target/iscsi/iscsi_target_configfs.c |    6 +
 drivers/target/iscsi/iscsi_target_core.h     |    5 +-
 drivers/target/iscsi/iscsi_target_tpg.c      |   21 +
 drivers/target/iscsi/iscsi_target_tpg.h      |    1 +
 drivers/target/target_core_file.c            |   40 +--
 drivers/target/target_core_sbc.c             |   91 +++-
 drivers/target/target_core_transport.c       |   33 ++-
 include/target/target_core_base.h            |   13 +-
 10 files changed, 683 insertions(+), 233 deletions(-)
