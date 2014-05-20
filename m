From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v4 0/9] SRP initiator patches for kernel 3.16
Date: Tue, 20 May 2014 15:03:02 +0200
Message-ID: <537B5286.1060504@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Changes compared to v3:
- Fixed test robot complaints ("undefined reference to `__udivdi3'" and
  "warning: format '%d' expects a matching 'int' argument").
- Restored support for HCA's that neither support FMR nor FR.
- Simplified memory registration pool reallocation code in
  srp_create_target_ib(). If FMR or FR is supported, an memory
  registration pool is allocated. If this fails, an error code is
  returned. If neither FMR nor FR is supported no attempt is made to
  allocate a memory registration pool.
- Minimized the changes in srp_add_one(). The decision to limit
  sg_tablesize is now based on whether or not the HCA supports memory
  registration instead of whether allocation of a memory registration
  pool succeeded. This change allows to keep the resource allocation
  order unmodified.
- Fixed a (theoretical ?) memory registration failure that was
  introduced in Linux kernel v2.6.39 (state->npages being compared
  against SRP_FMR_SIZE instead of max_pages_per_fmr).

Changes compared to v2:
- Reconnect to the SRP target if a local invalidation work request
  fails.
- Swapped the state->next_fmr / next_fr assignments to improve code
  readability.
- Clarified a comment in patch 1/9.
- Fixed error handling in srp_create_target() (was broken in v2).
- Added a missing "PFX" in two shost_printk() statements in patch 9/9.

Changes compared to v1:
- Modified the FMR code such that one FMR pool is allocated per
  connection instead of one pool per HCA.
- Dropped the patch "Make srp_alloc_req_data() reallocate request data".
- Moved introduction of the register_always kernel module parameter
  into a separate patch.
- Removed the loop from around ib_create_fmr_pool() and
  srp_create_fr_pool(). max_pages_per_mr is now computed from
  max_mr_size and max_fast_reg_page_list_len.
- Reduced fast registration pool size from 1024 to scsi_host->can_queue.
- Added a patch that should fix a crash that had been reported by Sagi
  but that I have not yet been able to reproduce myself.

This patch series consists of the following nine patches:

0001-IB-srp-Fix-a-sporadic-crash-triggered-by-cable-pulli.patch
0002-IB-srp-Fix-kernel-doc-warnings.patch
0003-IB-srp-Introduce-an-additional-local-variable.patch
0004-IB-srp-Introduce-srp_map_fmr.patch
0005-IB-srp-Introduce-srp_finish_mapping.patch
0006-IB-srp-Introduce-the-register_always-kernel-module-p.patch
0007-IB-srp-One-FMR-pool-per-SRP-connection.patch
0008-IB-srp-Rename-FMR-related-variables.patch
0009-IB-srp-Add-fast-registration-support.patch

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
