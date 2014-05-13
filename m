From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 0/9] SRP initiator patches for kernel 3.16
Date: Tue, 13 May 2014 16:38:07 +0200
Message-ID: <53722E4F.7070709@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

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
