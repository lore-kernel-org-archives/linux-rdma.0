From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 00/16] iser initiator preps for indirect registration (for kernel 4.2)
Date: Mon,  8 Jun 2015 16:15:12 +0300
Message-ID: <1433769323-790-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey All,

This set consists of both minor fixes and preparations for
indirect memory registration support (sent in a separate set).

Patches summary:
- cleanups in fmr pool allocation
- Introduce iser_fr_pool and iser_reg_ops to handle
  per-device memory registration operations
- Unify memory registration code logic and separate
  fmrs/frwrs only for the registration operations itself (also
  includes some function signature changes).

Another patchset will introduce fast indirect memory registration
feature in the ib_core, mlx5 driver and iser support. This split
is designed to make the review easier and more focused as I anticipate
that the indirect registration set will probably involve a wider discussion.

Adir Lev (1):
  IB/iser: Maintain connection fmr_pool under a single registration
    descriptor

Sagi Grimberg (10):
  IB/iser: Remove an unneeded print for unaligned memory
  IB/iser: Introduce struct iser_reg_resources
  IB/iser: Rename struct fast_reg_descriptor -> iser_fr_desc
  IB/iser: Remove dead code in fmr_pool alloc/free
  IB/iser: Introduce iser_reg_ops
  IB/iser: Move fastreg descriptor allocation to
    iser_create_fastreg_desc
  IB/iser: Introduce iser registration pool struct
  IB/iser: Rename iser_reg_page_vec -> iser_fast_reg_fmr
  IB/iser: Make reg_desc_get a per device routine
  IB/iser: Unify fast memory registration flows

 drivers/infiniband/ulp/iser/iscsi_iser.h     |  151 +++++++-----
 drivers/infiniband/ulp/iser/iser_initiator.c |   19 +-
 drivers/infiniband/ulp/iser/iser_memory.c    |  344 ++++++++++++++------------
 drivers/infiniband/ulp/iser/iser_verbs.c     |  263 ++++++++++----------
 4 files changed, 425 insertions(+), 352 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
