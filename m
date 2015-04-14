From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: iser patches for kernel 4.1 [v3]
Date: Tue, 14 Apr 2015 18:08:10 +0300
Message-ID: <1429024108-7221-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

This set contains bug fixes as well as code refactoring patches

- Patches 1-3:	   Bug fixes (stable material)
- Patches 4-6:     Bounce buffer related code cleanups
- Patches 7-12,16: Refactoring
- Patches 13-15:   Minor optimizations
- Patch 17:        Version bump
- Patch 18:        Bounce buffer rewrite to handle situations where
                   large transfers are unaligned causing iser to
		   use high order allocations

Changes from v2:
- Fix regression in DIX mode (introduced in patch 15) by incorrectly
  setting the protection information scatter-entry.

Changes from v1:
- Addressed review comments (patch 18) from Alex Lyakas on bounce buffer
  re-write code (kmap/kunmap mismatch, possible use-after-free,
  and double free).

Sagi Grimberg (18):
  IB/iser: Fix unload during ep_poll wrong dereference
  IB/iser: Handle fastreg/local_inv completion errors
  IB/iser: Fix wrong calculation of protection buffer length
  IB/iser: Remove redundant cmd_data_len calculation
  IB/iser: Remove a redundant struct iser_data_buf
  IB/iser: Don't pass ib_device to fall_to_bounce_buff routine
  IB/iser: Move memory reg/dereg routines to iser_memory.c
  IB/iser: Remove redundant assignments in iser_reg_page_vec
  IB/iser: Get rid of struct iser_rdma_regd
  IB/iser: Merge build page-vec into register page-vec
  IB/iser: Move fastreg descriptor pool get/put to helper functions
  IB/iser: Move PI context alloc/free to routines
  IB/iser: Make fastreg pool cache friendly
  IB/iser: Modify struct iser_mem_reg members
  IB/iser: Pass struct iser_mem_reg to iser_fast_reg_mr and
    iser_reg_sig_mr
  IB/iser: Remove code duplication for a single DMA entry
  IB/iser: Bump version to 1.6
  IB/iser: Rewrite bounce buffer code path

 drivers/infiniband/ulp/iser/iscsi_iser.h     |   66 +---
 drivers/infiniband/ulp/iser/iser_initiator.c |   66 ++--
 drivers/infiniband/ulp/iser/iser_memory.c    |  523 +++++++++++++++-----------
 drivers/infiniband/ulp/iser/iser_verbs.c     |  220 ++++--------
 4 files changed, 431 insertions(+), 444 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
