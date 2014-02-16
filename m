From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 00/12] T10-DIF Initial support for iSER target
Date: Sun, 16 Feb 2014 19:38:05 +0200
Message-ID: <1392572297-5333-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org
Cc: target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Nic and folks,

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

Nic, Can you take this code to rdma_dif branch until RDMA
Signature verbs set will pass submission? (after review of
course...).

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

 drivers/infiniband/ulp/isert/ib_isert.c      |  675 ++++++++++++++++++++------
 drivers/infiniband/ulp/isert/ib_isert.h      |   38 ++-
 drivers/target/iscsi/iscsi_target_configfs.c |    6 +
 drivers/target/iscsi/iscsi_target_core.h     |    5 +-
 drivers/target/iscsi/iscsi_target_tpg.c      |   21 +
 drivers/target/iscsi/iscsi_target_tpg.h      |    1 +
 drivers/target/target_core_file.c            |   40 +--
 drivers/target/target_core_sbc.c             |   93 ++++-
 drivers/target/target_core_transport.c       |   33 ++-
 include/target/target_core_base.h            |   13 +-
 10 files changed, 698 insertions(+), 227 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
