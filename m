Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CC122FDE6
	for <linux-rdma@vger.kernel.org>; Tue, 28 Jul 2026 01:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785203437; cv=none; b=Mwd5ftvvf5Exd2lTrYRF5BJ1PkAH/YB3kSaYC0773/4cYUB8+9AbwEmLs4auWso9BLapTWGUijo7ftqJ2fXY+xPCL7I7/S5wMzDaatHr4rjrRnYmoVzvDqvta17/9g4Nb3DZMvQIElJxpCXAisOUQIxgSl/lil981YNYT/MRx5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785203437; c=relaxed/simple;
	bh=FYIdbQ/eoxpuiFHYJ5FwE/lNwlKpqySS70k6k6RM7Hw=;
	h=Date:From:To:Cc:Subject:Message-ID; b=Qhi/npgwDnqdOhSC7JR2JF2PJQpZqMAtmjMz3OYvjcqoEnzIAmC5hCaLKbf6GiYMM9zu7ShcUyLwphFUHQAoIRoxMjUbH7gifMPpGAttqpVREsp+rXAWJDNXgkfyFGpA8GR10s+0uVAieeoJuafGW3QaNpWSR4gCnK93BZP58ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nFaMU28W; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nFaMU28W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785203435; x=1816739435;
  h=date:from:to:cc:subject:message-id;
  bh=FYIdbQ/eoxpuiFHYJ5FwE/lNwlKpqySS70k6k6RM7Hw=;
  b=nFaMU28WDv9lpsDkAWkuoJg5kRs4AScZyktZAfb7BXQ33K2tEXxbKLfI
   9xzoOFucGbZgTqsZoXtjs7qvLcytOqLxy1YBCBx44SCSxtiM+xOyQ9aE8
   ypnQNlc1ukbLs551MoStLdA+JjZv1tAr6grSXLLvw2GGf874AZR95fUIc
   h2lSoDq0OZ3sC9WznHoWMV9V+rUOhkNSncfeI4ExPHhfq2YCt3cFGDAvV
   Hz3o3xoo+Y31G6Lnq/ypsPFKtf5BONAPVGRC2EAUqUmkpG097o2bXVcTB
   Tyj6KZaZggrultzx6XZZA8gBcYCMrZkOKrRbJYX/yK2ET4KOeZ9b9NUMT
   w==;
X-CSE-ConnectionGUID: 1cqXkcHPTvOAAiUasdLBmw==
X-CSE-MsgGUID: j4kWk/AzQYqoodikSzmJ4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11858"; a="89602816"
X-IronPort-AV: E=Sophos;i="6.25,189,1779174000"; 
   d="scan'208";a="89602816"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2026 18:50:33 -0700
X-CSE-ConnectionGUID: BJcjPZLtQiS36nRoxILulg==
X-CSE-MsgGUID: s91taHgYS6CtsBvxpD18pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,189,1779174000"; 
   d="scan'208";a="259009591"
Received: from igk-lkp-server01.igk.intel.com (HELO 3cba2a188a06) ([10.211.93.152])
  by orviesa008.jf.intel.com with ESMTP; 27 Jul 2026 18:50:30 -0700
Received: from kbuild by 3cba2a188a06 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1woWxf-000000001p4-2bnX;
	Tue, 28 Jul 2026 01:50:27 +0000
Date: Tue, 28 Jul 2026 03:49:54 +0200
From: kernel test robot <lkp@intel.com>
To: Selvin Xavier <selvin.xavier@broadcom.com>
Cc: oe-kbuild-all@lists.linux.dev, Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org,
 Leon Romanovsky <leon@kernel.org>
Subject: [rdma:wip/leon-for-next 80/84]
 drivers/infiniband/hw/bnxt_re/ib_verbs.c:2178:12: error: invalid storage
 class for function 'bnxt_re_init_user_srq'
Message-ID: <202607280336.rdhVIN8h-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git wip/leon-for-next
head:   983c450ae26317c58b62cac5afa58725ada7d256
commit: 2b248ac9c95bf0175fda9f3a869c7c4054893de0 [80/84] RDMA/bnxt_re: Replace per-device hash tables with per-context XArrays
config: x86_64-rhel-9.4-bpf (https://download.01.org/0day-ci/archive/20260728/202607280336.rdhVIN8h-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260728/202607280336.rdhVIN8h-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607280336.rdhVIN8h-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   drivers/infiniband/hw/bnxt_re/ib_verbs.c: In function 'bnxt_re_destroy_srq':
>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:2178:12: error: invalid storage class for function 'bnxt_re_init_user_srq'
    2178 | static int bnxt_re_init_user_srq(struct bnxt_re_dev *rdev,
         |            ^~~~~~~~~~~~~~~~~~~~~
>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:2396:12: error: invalid storage class for function 'bnxt_re_modify_shadow_qp'
    2396 | static int bnxt_re_modify_shadow_qp(struct bnxt_re_dev *rdev,
         |            ^~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:2428:13: error: invalid storage class for function 'bnxt_re_is_modify_ok'
    2428 | static bool bnxt_re_is_modify_ok(enum ib_qp_attr_mask ext_mask,
         |             ^~~~~~~~~~~~~~~~~~~~
>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:2774:12: error: invalid storage class for function 'bnxt_re_build_qp1_send_v2'
    2774 | static int bnxt_re_build_qp1_send_v2(struct bnxt_re_qp *qp,
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:2948:12: error: invalid storage class for function 'bnxt_re_build_qp1_shadow_qp_recv'
    2948 | static int bnxt_re_build_qp1_shadow_qp_recv(struct bnxt_re_qp *qp,
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:2991:12: error: invalid storage class for function 'is_ud_qp'
    2991 | static int is_ud_qp(struct bnxt_re_qp *qp)
         |            ^~~~~~~~
>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:2997:12: error: invalid storage class for function 'bnxt_re_build_send_wqe'
    2997 | static int bnxt_re_build_send_wqe(struct bnxt_re_qp *qp,
         |            ^~~~~~~~~~~~~~~~~~~~~~
>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:3036:12: error: invalid storage class for function 'bnxt_re_build_rdma_wqe'
    3036 | static int bnxt_re_build_rdma_wqe(const struct ib_send_wr *wr,
         |            ^~~~~~~~~~~~~~~~~~~~~~
>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:3068:12: error: invalid storage class for function 'bnxt_re_build_atomic_wqe'
    3068 | static int bnxt_re_build_atomic_wqe(const struct ib_send_wr *wr,
         |            ^~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:3095:12: error: invalid storage class for function 'bnxt_re_build_inv_wqe'
    3095 | static int bnxt_re_build_inv_wqe(const struct ib_send_wr *wr,
         |            ^~~~~~~~~~~~~~~~~~~~~
>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:3109:12: error: invalid storage class for function 'bnxt_re_build_reg_wqe'
    3109 | static int bnxt_re_build_reg_wqe(const struct ib_reg_wr *wr,
         |            ^~~~~~~~~~~~~~~~~~~~~
>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:3145:12: error: invalid storage class for function 'bnxt_re_copy_inline_data'
    3145 | static int bnxt_re_copy_inline_data(struct bnxt_re_dev *rdev,
         |            ^~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:3175:12: error: invalid storage class for function 'bnxt_re_copy_wr_payload'
    3175 | static int bnxt_re_copy_wr_payload(struct bnxt_re_dev *rdev,
         |            ^~~~~~~~~~~~~~~~~~~~~~~
>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:3190:13: error: invalid storage class for function 'bnxt_ud_qp_hw_stall_workaround'
    3190 | static void bnxt_ud_qp_hw_stall_workaround(struct bnxt_re_qp *qp)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:3206:12: error: invalid storage class for function 'bnxt_re_post_send_shadow_qp'
    3206 | static int bnxt_re_post_send_shadow_qp(struct bnxt_re_dev *rdev,
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:3254:13: error: invalid storage class for function 'bnxt_re_legacy_set_uc_fence'
    3254 | static void bnxt_re_legacy_set_uc_fence(struct bnxt_qplib_swqe *wqe)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:3363:12: error: invalid storage class for function 'bnxt_re_post_recv_shadow_qp'
    3363 | static int bnxt_re_post_recv_shadow_qp(struct bnxt_re_dev *rdev,
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:3454:30: error: invalid storage class for function 'bnxt_re_get_nq'
    3454 | static struct bnxt_qplib_nq *bnxt_re_get_nq(struct bnxt_re_dev *rdev)
         |                              ^~~~~~~~~~~~~~
>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:3469:13: error: invalid storage class for function 'bnxt_re_put_nq'
    3469 | static void bnxt_re_put_nq(struct bnxt_re_dev *rdev, struct bnxt_qplib_nq *nq)
         |             ^~~~~~~~~~~~~~
>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:3673:13: error: invalid storage class for function 'bnxt_re_resize_cq_complete'
    3673 | static void bnxt_re_resize_cq_complete(struct bnxt_re_cq *cq)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:3773:11: error: invalid storage class for function '__req_to_ib_wc_status'
    3773 | static u8 __req_to_ib_wc_status(u8 qstatus)
         |           ^~~~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:3806:11: error: invalid storage class for function '__rawqp1_to_ib_wc_status'
    3806 | static u8 __rawqp1_to_ib_wc_status(u8 qstatus)
         |           ^~~~~~~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:3830:11: error: invalid storage class for function '__rc_to_ib_wc_status'
    3830 | static u8 __rc_to_ib_wc_status(u8 qstatus)
         |           ^~~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:3856:13: error: invalid storage class for function 'bnxt_re_process_req_wc'
    3856 | static void bnxt_re_process_req_wc(struct ib_wc *wc, struct bnxt_qplib_cqe *cqe)
         |             ^~~~~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:3900:12: error: invalid storage class for function 'bnxt_re_check_packet_type'
    3900 | static int bnxt_re_check_packet_type(u16 raweth_qp1_flags,
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:3926:12: error: invalid storage class for function 'bnxt_re_to_ib_nw_type'
    3926 | static int bnxt_re_to_ib_nw_type(int nw_type)
         |            ^~~~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:3944:13: error: invalid storage class for function 'bnxt_re_is_loopback_packet'
    3944 | static bool bnxt_re_is_loopback_packet(struct bnxt_re_dev *rdev,
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:3989:12: error: invalid storage class for function 'bnxt_re_process_raw_qp_pkt_rx'
    3989 | static int bnxt_re_process_raw_qp_pkt_rx(struct bnxt_re_qp *gsi_qp,
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:4100:13: error: invalid storage class for function 'bnxt_re_process_res_rawqp1_wc'
    4100 | static void bnxt_re_process_res_rawqp1_wc(struct ib_wc *wc,
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:4108:13: error: invalid storage class for function 'bnxt_re_check_if_vlan_valid'
    4108 | static bool bnxt_re_check_if_vlan_valid(struct bnxt_re_dev *rdev,
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:4121:13: error: invalid storage class for function 'bnxt_re_is_vlan_pkt'
    4121 | static bool bnxt_re_is_vlan_pkt(struct bnxt_qplib_cqe *orig_cqe,
         |             ^~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:4147:13: error: invalid storage class for function 'bnxt_re_process_res_rc_wc'
    4147 | static void bnxt_re_process_res_rc_wc(struct ib_wc *wc,
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:4162:13: error: invalid storage class for function 'bnxt_re_process_res_shadow_qp_wc'
    4162 | static void bnxt_re_process_res_shadow_qp_wc(struct bnxt_re_qp *gsi_sqp,
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:4210:13: error: invalid storage class for function 'bnxt_re_process_res_ud_wc'
    4210 | static void bnxt_re_process_res_ud_wc(struct bnxt_re_qp *qp,
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:4245:12: error: invalid storage class for function 'send_phantom_wqe'
    4245 | static int send_phantom_wqe(struct bnxt_re_qp *qp)
         |            ^~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:4518:12: error: invalid storage class for function 'bnxt_re_set_page'
    4518 | static int bnxt_re_set_page(struct ib_mr *ib_mr, u64 addr)
         |            ^~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:4653:22: error: invalid storage class for function '__bnxt_re_user_reg_mr'
    4653 | static struct ib_mr *__bnxt_re_user_reg_mr(struct ib_pd *ib_pd, u64 length, u64 virt_addr,
         |                      ^~~~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:4904:12: error: invalid storage class for function 'bnxt_re_setup_vnic'
    4904 | static int bnxt_re_setup_vnic(struct bnxt_re_dev *rdev, struct bnxt_re_qp *qp)
         |            ^~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:5102:1: error: expected declaration or statement at end of input
    5102 | }
         | ^
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:5103: warning: control reaches end of non-void function [-Wreturn-type]
   drivers/infiniband/hw/bnxt_re/ib_verbs.c: At top level:
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:5069:5: warning: 'bnxt_re_process_mad' defined but not used [-Wunused-function]
    5069 | int bnxt_re_process_mad(struct ib_device *ibdev, int mad_flags,
         |     ^~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:5055:6: warning: 'bnxt_re_mmap_free' defined but not used [-Wunused-function]
    5055 | void bnxt_re_mmap_free(struct rdma_user_mmap_entry *rdma_entry)
         |      ^~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:4996:5: warning: 'bnxt_re_mmap' defined but not used [-Wunused-function]
    4996 | int bnxt_re_mmap(struct ib_ucontext *ib_uctx, struct vm_area_struct *vma)
         |     ^~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:4975:5: warning: 'bnxt_re_destroy_flow' defined but not used [-Wunused-function]
    4975 | int bnxt_re_destroy_flow(struct ib_flow *flow_id)
         |     ^~~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:4922:17: warning: 'bnxt_re_create_flow' defined but not used [-Wunused-function]
    4922 | struct ib_flow *bnxt_re_create_flow(struct ib_qp *ib_qp,
         |                 ^~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:4880:6: warning: 'bnxt_re_dealloc_ucontext' defined but not used [-Wunused-function]
    4880 | void bnxt_re_dealloc_ucontext(struct ib_ucontext *ib_uctx)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:4784:5: warning: 'bnxt_re_alloc_ucontext' defined but not used [-Wunused-function]
    4784 | int bnxt_re_alloc_ucontext(struct ib_ucontext *ctx, struct ib_udata *udata)
         |     ^~~~~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:4756:15: warning: 'bnxt_re_reg_user_mr_dmabuf' defined but not used [-Wunused-function]
    4756 | struct ib_mr *bnxt_re_reg_user_mr_dmabuf(struct ib_pd *ib_pd, u64 start,
         |               ^~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:4728:15: warning: 'bnxt_re_reg_user_mr' defined but not used [-Wunused-function]
    4728 | struct ib_mr *bnxt_re_reg_user_mr(struct ib_pd *ib_pd, u64 start, u64 length,
         |               ^~~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:4636:5: warning: 'bnxt_re_dealloc_mw' defined but not used [-Wunused-function]
    4636 | int bnxt_re_dealloc_mw(struct ib_mw *ib_mw)
         |     ^~~~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:4597:15: warning: 'bnxt_re_alloc_mw' defined but not used [-Wunused-function]
    4597 | struct ib_mw *bnxt_re_alloc_mw(struct ib_pd *ib_pd, enum ib_mw_type type,
         |               ^~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:4538:15: warning: 'bnxt_re_alloc_mr' defined but not used [-Wunused-function]
    4538 | struct ib_mr *bnxt_re_alloc_mr(struct ib_pd *ib_pd, enum ib_mr_type type,
         |               ^~~~~~~~~~~~~~~~
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:4529:5: warning: 'bnxt_re_map_mr_sg' defined but not used [-Wunused-function]
    4529 | int bnxt_re_map_mr_sg(struct ib_mr *ib_mr, struct scatterlist *sg, int sg_nents,
         |     ^~~~~~~~~~~~~~~~~


vim +/bnxt_re_init_user_srq +2178 drivers/infiniband/hw/bnxt_re/ib_verbs.c

37cb11acf1f72a Devesh Sharma      2018-01-11  2177  
37cb11acf1f72a Devesh Sharma      2018-01-11 @2178  static int bnxt_re_init_user_srq(struct bnxt_re_dev *rdev,
37cb11acf1f72a Devesh Sharma      2018-01-11  2179  				 struct bnxt_re_pd *pd,
37cb11acf1f72a Devesh Sharma      2018-01-11  2180  				 struct bnxt_re_srq *srq,
37cb11acf1f72a Devesh Sharma      2018-01-11  2181  				 struct ib_udata *udata)
37cb11acf1f72a Devesh Sharma      2018-01-11  2182  {
37cb11acf1f72a Devesh Sharma      2018-01-11  2183  	struct bnxt_re_srq_req ureq;
37cb11acf1f72a Devesh Sharma      2018-01-11  2184  	struct bnxt_qplib_srq *qplib_srq = &srq->qplib_srq;
37cb11acf1f72a Devesh Sharma      2018-01-11  2185  	struct ib_umem *umem;
37cb11acf1f72a Devesh Sharma      2018-01-11  2186  	int bytes = 0;
89944450547334 Shamir Rabinovitch 2019-02-07  2187  	struct bnxt_re_ucontext *cntx = rdma_udata_to_drv_context(
89944450547334 Shamir Rabinovitch 2019-02-07  2188  		udata, struct bnxt_re_ucontext, ib_uctx);
b33d860a13b4f7 Jason Gunthorpe    2026-03-03  2189  	int rc;
89944450547334 Shamir Rabinovitch 2019-02-07  2190  
b33d860a13b4f7 Jason Gunthorpe    2026-03-03  2191  	rc = ib_copy_validate_udata_in(udata, ureq, srq_handle);
b33d860a13b4f7 Jason Gunthorpe    2026-03-03  2192  	if (rc)
b33d860a13b4f7 Jason Gunthorpe    2026-03-03  2193  		return rc;
37cb11acf1f72a Devesh Sharma      2018-01-11  2194  
fddcbbb02af42a Devesh Sharma      2020-04-02  2195  	bytes = (qplib_srq->max_wqe * qplib_srq->wqe_size);
37cb11acf1f72a Devesh Sharma      2018-01-11  2196  	bytes = PAGE_ALIGN(bytes);
af841056860d2d Jiri Pirko         2026-05-29  2197  	umem = ib_umem_get_va(&rdev->ibdev, ureq.srqva, bytes,
c320e527e15483 Moni Shoua         2020-01-15  2198  			      IB_ACCESS_LOCAL_WRITE);
37cb11acf1f72a Devesh Sharma      2018-01-11  2199  	if (IS_ERR(umem))
37cb11acf1f72a Devesh Sharma      2018-01-11  2200  		return PTR_ERR(umem);
37cb11acf1f72a Devesh Sharma      2018-01-11  2201  
37cb11acf1f72a Devesh Sharma      2018-01-11  2202  	srq->umem = umem;
6ef999f5002132 Jason Gunthorpe    2020-09-29  2203  	qplib_srq->sg_info.umem = umem;
0c4dcd60281750 Devesh Sharma      2020-02-15  2204  	qplib_srq->sg_info.pgsize = PAGE_SIZE;
0c4dcd60281750 Devesh Sharma      2020-02-15  2205  	qplib_srq->sg_info.pgshft = PAGE_SHIFT;
37cb11acf1f72a Devesh Sharma      2018-01-11  2206  	qplib_srq->srq_handle = ureq.srq_handle;
37cb11acf1f72a Devesh Sharma      2018-01-11  2207  	qplib_srq->dpi = &cntx->dpi;
37cb11acf1f72a Devesh Sharma      2018-01-11  2208  
37cb11acf1f72a Devesh Sharma      2018-01-11  2209  	return 0;
37cb11acf1f72a Devesh Sharma      2018-01-11  2210  }
37cb11acf1f72a Devesh Sharma      2018-01-11  2211  
68e326dea1dba9 Leon Romanovsky    2019-04-03 @2212  int bnxt_re_create_srq(struct ib_srq *ib_srq,
37cb11acf1f72a Devesh Sharma      2018-01-11  2213  		       struct ib_srq_init_attr *srq_init_attr,
37cb11acf1f72a Devesh Sharma      2018-01-11  2214  		       struct ib_udata *udata)
37cb11acf1f72a Devesh Sharma      2018-01-11  2215  {
fddcbbb02af42a Devesh Sharma      2020-04-02  2216  	struct bnxt_qplib_dev_attr *dev_attr;
48f996d4adf15a Chandramohan Akula 2023-10-23  2217  	struct bnxt_re_ucontext *uctx;
fddcbbb02af42a Devesh Sharma      2020-04-02  2218  	struct bnxt_re_dev *rdev;
fddcbbb02af42a Devesh Sharma      2020-04-02  2219  	struct bnxt_re_srq *srq;
fddcbbb02af42a Devesh Sharma      2020-04-02  2220  	struct bnxt_re_pd *pd;
fddcbbb02af42a Devesh Sharma      2020-04-02  2221  	struct ib_pd *ib_pd;
cb95709e0dca7a Chandramohan Akula 2023-07-26  2222  	u32 active_srqs;
2b2f078236a445 Leon Romanovsky    2026-03-18  2223  	int rc;
37cb11acf1f72a Devesh Sharma      2018-01-11  2224  
fddcbbb02af42a Devesh Sharma      2020-04-02  2225  	ib_pd = ib_srq->pd;
fddcbbb02af42a Devesh Sharma      2020-04-02  2226  	pd = container_of(ib_pd, struct bnxt_re_pd, ib_pd);
fddcbbb02af42a Devesh Sharma      2020-04-02  2227  	rdev = pd->rdev;
9264cd6aa8f194 Kalesh AP          2025-01-09  2228  	dev_attr = rdev->dev_attr;
fddcbbb02af42a Devesh Sharma      2020-04-02  2229  	srq = container_of(ib_srq, struct bnxt_re_srq, ib_srq);
fddcbbb02af42a Devesh Sharma      2020-04-02  2230  
37cb11acf1f72a Devesh Sharma      2018-01-11  2231  	if (srq_init_attr->attr.max_wr >= dev_attr->max_srq_wqes) {
6ccad8483b2866 Devesh Sharma      2020-02-15  2232  		ibdev_err(&rdev->ibdev, "Create CQ failed - max exceeded");
37cb11acf1f72a Devesh Sharma      2018-01-11  2233  		rc = -EINVAL;
37cb11acf1f72a Devesh Sharma      2018-01-11  2234  		goto exit;
37cb11acf1f72a Devesh Sharma      2018-01-11  2235  	}
37cb11acf1f72a Devesh Sharma      2018-01-11  2236  
37cb11acf1f72a Devesh Sharma      2018-01-11  2237  	if (srq_init_attr->srq_type != IB_SRQT_BASIC) {
8380b74e7d606c Kamal Heib         2018-07-30  2238  		rc = -EOPNOTSUPP;
37cb11acf1f72a Devesh Sharma      2018-01-11  2239  		goto exit;
37cb11acf1f72a Devesh Sharma      2018-01-11  2240  	}
37cb11acf1f72a Devesh Sharma      2018-01-11  2241  
48f996d4adf15a Chandramohan Akula 2023-10-23  2242  	uctx = rdma_udata_to_drv_context(udata, struct bnxt_re_ucontext, ib_uctx);
37cb11acf1f72a Devesh Sharma      2018-01-11  2243  	srq->rdev = rdev;
37cb11acf1f72a Devesh Sharma      2018-01-11  2244  	srq->qplib_srq.pd = &pd->qplib_pd;
37cb11acf1f72a Devesh Sharma      2018-01-11  2245  	srq->qplib_srq.dpi = &rdev->dpi_privileged;
37cb11acf1f72a Devesh Sharma      2018-01-11  2246  	/* Allocate 1 more than what's provided so posting max doesn't
37cb11acf1f72a Devesh Sharma      2018-01-11  2247  	 * mean empty
37cb11acf1f72a Devesh Sharma      2018-01-11  2248  	 */
2b2f078236a445 Leon Romanovsky    2026-03-18  2249  	srq->qplib_srq.max_wqe =
2b2f078236a445 Leon Romanovsky    2026-03-18  2250  		bnxt_re_init_depth(srq_init_attr->attr.max_wr + 1,
2b2f078236a445 Leon Romanovsky    2026-03-18  2251  				   dev_attr->max_srq_wqes + 1, uctx);
fddcbbb02af42a Devesh Sharma      2020-04-02  2252  
37cb11acf1f72a Devesh Sharma      2018-01-11  2253  	srq->qplib_srq.max_sge = srq_init_attr->attr.max_sge;
b898d5c50cab1f Selvin Xavier      2020-10-12  2254  	 /* 128 byte wqe size for SRQ . So use max sges */
b898d5c50cab1f Selvin Xavier      2020-10-12  2255  	srq->qplib_srq.wqe_size = bnxt_re_get_rwqe_size(dev_attr->max_srq_sges);
37cb11acf1f72a Devesh Sharma      2018-01-11  2256  	srq->qplib_srq.threshold = srq_init_attr->attr.srq_limit;
37cb11acf1f72a Devesh Sharma      2018-01-11  2257  	srq->srq_limit = srq_init_attr->attr.srq_limit;
30b871338c3eba Kalesh AP          2024-11-14  2258  	srq->qplib_srq.eventq_hw_ring_id = rdev->nqr->nq[0].ring_id;
b66535356a4834 Kashyap Desai      2025-02-22  2259  	srq->qplib_srq.sg_info.pgsize = PAGE_SIZE;
b66535356a4834 Kashyap Desai      2025-02-22  2260  	srq->qplib_srq.sg_info.pgshft = PAGE_SHIFT;
37cb11acf1f72a Devesh Sharma      2018-01-11  2261  
37cb11acf1f72a Devesh Sharma      2018-01-11  2262  	if (udata) {
37cb11acf1f72a Devesh Sharma      2018-01-11  2263  		rc = bnxt_re_init_user_srq(rdev, pd, srq, udata);
37cb11acf1f72a Devesh Sharma      2018-01-11  2264  		if (rc)
37cb11acf1f72a Devesh Sharma      2018-01-11  2265  			goto fail;
37cb11acf1f72a Devesh Sharma      2018-01-11  2266  	}
37cb11acf1f72a Devesh Sharma      2018-01-11  2267  
37cb11acf1f72a Devesh Sharma      2018-01-11  2268  	rc = bnxt_qplib_create_srq(&rdev->qplib_res, &srq->qplib_srq);
37cb11acf1f72a Devesh Sharma      2018-01-11  2269  	if (rc) {
6ccad8483b2866 Devesh Sharma      2020-02-15  2270  		ibdev_err(&rdev->ibdev, "Create HW SRQ failed!");
37cb11acf1f72a Devesh Sharma      2018-01-11  2271  		goto fail;
37cb11acf1f72a Devesh Sharma      2018-01-11  2272  	}
37cb11acf1f72a Devesh Sharma      2018-01-11  2273  
37cb11acf1f72a Devesh Sharma      2018-01-11  2274  	if (udata) {
181028a0d84cdc Chandramohan Akula 2024-08-29  2275  		struct bnxt_re_srq_resp resp = {};
37cb11acf1f72a Devesh Sharma      2018-01-11  2276  
37cb11acf1f72a Devesh Sharma      2018-01-11  2277  		resp.srqid = srq->qplib_srq.id;
181028a0d84cdc Chandramohan Akula 2024-08-29  2278  		if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT) {
181028a0d84cdc Chandramohan Akula 2024-08-29  2279  			srq->uctx_srq_page = (void *)get_zeroed_page(GFP_KERNEL);
181028a0d84cdc Chandramohan Akula 2024-08-29  2280  			if (!srq->uctx_srq_page) {
181028a0d84cdc Chandramohan Akula 2024-08-29  2281  				rc = -ENOMEM;
2b248ac9c95bf0 Selvin Xavier      2026-07-21  2282  				goto fail_destroy_srq;
2b248ac9c95bf0 Selvin Xavier      2026-07-21  2283  			}
2b248ac9c95bf0 Selvin Xavier      2026-07-21  2284  			if (xa_is_err(xa_store(&uctx->srq_xa, srq->qplib_srq.id,
2b248ac9c95bf0 Selvin Xavier      2026-07-21  2285  					       ib_srq->uobject, GFP_KERNEL))) {
2b248ac9c95bf0 Selvin Xavier      2026-07-21  2286  				rc = -ENOMEM;
2b248ac9c95bf0 Selvin Xavier      2026-07-21  2287  				goto fail_free_srq_page;
181028a0d84cdc Chandramohan Akula 2024-08-29  2288  			}
181028a0d84cdc Chandramohan Akula 2024-08-29  2289  			resp.comp_mask |= BNXT_RE_SRQ_TOGGLE_PAGE_SUPPORT;
181028a0d84cdc Chandramohan Akula 2024-08-29  2290  		}
bc30311e492ecf Jason Gunthorpe    2026-03-03  2291  		rc = ib_respond_udata(udata, resp);
2b248ac9c95bf0 Selvin Xavier      2026-07-21  2292  		if (rc)
2b248ac9c95bf0 Selvin Xavier      2026-07-21  2293  			goto fail_respond;
37cb11acf1f72a Devesh Sharma      2018-01-11  2294  	}
cb95709e0dca7a Chandramohan Akula 2023-07-26  2295  	active_srqs = atomic_inc_return(&rdev->stats.res.srq_count);
cb95709e0dca7a Chandramohan Akula 2023-07-26  2296  	if (active_srqs > rdev->stats.res.srq_watermark)
cb95709e0dca7a Chandramohan Akula 2023-07-26  2297  		rdev->stats.res.srq_watermark = active_srqs;
17f2569dce1848 Naresh Kumar PBS   2021-08-18  2298  	spin_lock_init(&srq->lock);
37cb11acf1f72a Devesh Sharma      2018-01-11  2299  
68e326dea1dba9 Leon Romanovsky    2019-04-03  2300  	return 0;
37cb11acf1f72a Devesh Sharma      2018-01-11  2301  
2b248ac9c95bf0 Selvin Xavier      2026-07-21  2302  fail_respond:
2b248ac9c95bf0 Selvin Xavier      2026-07-21  2303  	if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT) {
2b248ac9c95bf0 Selvin Xavier      2026-07-21  2304  		xa_erase(&uctx->srq_xa, srq->qplib_srq.id);
2b248ac9c95bf0 Selvin Xavier      2026-07-21  2305  		free_page((unsigned long)srq->uctx_srq_page);
2b248ac9c95bf0 Selvin Xavier      2026-07-21  2306  	}
2b248ac9c95bf0 Selvin Xavier      2026-07-21  2307  	bnxt_qplib_destroy_srq(&rdev->qplib_res, &srq->qplib_srq);
2b248ac9c95bf0 Selvin Xavier      2026-07-21  2308  	goto fail;
2b248ac9c95bf0 Selvin Xavier      2026-07-21  2309  fail_free_srq_page:
2b248ac9c95bf0 Selvin Xavier      2026-07-21  2310  	free_page((unsigned long)srq->uctx_srq_page);
2b248ac9c95bf0 Selvin Xavier      2026-07-21  2311  fail_destroy_srq:
2b248ac9c95bf0 Selvin Xavier      2026-07-21  2312  	bnxt_qplib_destroy_srq(&rdev->qplib_res, &srq->qplib_srq);
37cb11acf1f72a Devesh Sharma      2018-01-11  2313  fail:
37cb11acf1f72a Devesh Sharma      2018-01-11  2314  	ib_umem_release(srq->umem);
37cb11acf1f72a Devesh Sharma      2018-01-11  2315  exit:
68e326dea1dba9 Leon Romanovsky    2019-04-03  2316  	return rc;
37cb11acf1f72a Devesh Sharma      2018-01-11  2317  }
37cb11acf1f72a Devesh Sharma      2018-01-11  2318  
37cb11acf1f72a Devesh Sharma      2018-01-11 @2319  int bnxt_re_modify_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr,
37cb11acf1f72a Devesh Sharma      2018-01-11  2320  		       enum ib_srq_attr_mask srq_attr_mask,
37cb11acf1f72a Devesh Sharma      2018-01-11  2321  		       struct ib_udata *udata)
37cb11acf1f72a Devesh Sharma      2018-01-11  2322  {
37cb11acf1f72a Devesh Sharma      2018-01-11  2323  	struct bnxt_re_srq *srq = container_of(ib_srq, struct bnxt_re_srq,
37cb11acf1f72a Devesh Sharma      2018-01-11  2324  					       ib_srq);
3f6b103c4bf25e Jason Gunthorpe    2026-03-03  2325  	int ret;
3f6b103c4bf25e Jason Gunthorpe    2026-03-03  2326  
d38c835925d4a3 Leon Romanovsky    2026-07-14  2327  	ret = ib_no_udata_io(udata);
3f6b103c4bf25e Jason Gunthorpe    2026-03-03  2328  	if (ret)
3f6b103c4bf25e Jason Gunthorpe    2026-03-03  2329  		return ret;
37cb11acf1f72a Devesh Sharma      2018-01-11  2330  
d38c835925d4a3 Leon Romanovsky    2026-07-14  2331  	if (srq_attr_mask != IB_SRQ_LIMIT)
3687b450c5f32e Kalesh AP          2024-01-22  2332  		return -EINVAL;
d38c835925d4a3 Leon Romanovsky    2026-07-14  2333  
37cb11acf1f72a Devesh Sharma      2018-01-11  2334  	if (srq_attr->srq_limit > srq->qplib_srq.max_wqe)
37cb11acf1f72a Devesh Sharma      2018-01-11  2335  		return -EINVAL;
37cb11acf1f72a Devesh Sharma      2018-01-11  2336  
37cb11acf1f72a Devesh Sharma      2018-01-11  2337  	srq->qplib_srq.threshold = srq_attr->srq_limit;
666bce0bd7e771 Kashyap Desai      2025-08-05  2338  	bnxt_qplib_srq_arm_db(&srq->qplib_srq.dbinfo, srq->qplib_srq.threshold);
666bce0bd7e771 Kashyap Desai      2025-08-05  2339  
37cb11acf1f72a Devesh Sharma      2018-01-11  2340  	/* On success, update the shadow */
37cb11acf1f72a Devesh Sharma      2018-01-11  2341  	srq->srq_limit = srq_attr->srq_limit;
37cb11acf1f72a Devesh Sharma      2018-01-11  2342  	/* No need to Build and send response back to udata */
d38c835925d4a3 Leon Romanovsky    2026-07-14  2343  	return 0;
37cb11acf1f72a Devesh Sharma      2018-01-11  2344  }
37cb11acf1f72a Devesh Sharma      2018-01-11  2345  
37cb11acf1f72a Devesh Sharma      2018-01-11 @2346  int bnxt_re_query_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr)
37cb11acf1f72a Devesh Sharma      2018-01-11  2347  {
37cb11acf1f72a Devesh Sharma      2018-01-11  2348  	struct bnxt_re_srq *srq = container_of(ib_srq, struct bnxt_re_srq,
37cb11acf1f72a Devesh Sharma      2018-01-11  2349  					       ib_srq);
37cb11acf1f72a Devesh Sharma      2018-01-11  2350  	struct bnxt_re_srq tsrq;
37cb11acf1f72a Devesh Sharma      2018-01-11  2351  	struct bnxt_re_dev *rdev = srq->rdev;
37cb11acf1f72a Devesh Sharma      2018-01-11  2352  	int rc;
37cb11acf1f72a Devesh Sharma      2018-01-11  2353  
37cb11acf1f72a Devesh Sharma      2018-01-11  2354  	/* Get live SRQ attr */
37cb11acf1f72a Devesh Sharma      2018-01-11  2355  	tsrq.qplib_srq.id = srq->qplib_srq.id;
37cb11acf1f72a Devesh Sharma      2018-01-11  2356  	rc = bnxt_qplib_query_srq(&rdev->qplib_res, &tsrq.qplib_srq);
37cb11acf1f72a Devesh Sharma      2018-01-11  2357  	if (rc) {
6ccad8483b2866 Devesh Sharma      2020-02-15  2358  		ibdev_err(&rdev->ibdev, "Query HW SRQ failed!");
37cb11acf1f72a Devesh Sharma      2018-01-11  2359  		return rc;
37cb11acf1f72a Devesh Sharma      2018-01-11  2360  	}
37cb11acf1f72a Devesh Sharma      2018-01-11  2361  	srq_attr->max_wr = srq->qplib_srq.max_wqe;
37cb11acf1f72a Devesh Sharma      2018-01-11  2362  	srq_attr->max_sge = srq->qplib_srq.max_sge;
37cb11acf1f72a Devesh Sharma      2018-01-11  2363  	srq_attr->srq_limit = tsrq.qplib_srq.threshold;
37cb11acf1f72a Devesh Sharma      2018-01-11  2364  
37cb11acf1f72a Devesh Sharma      2018-01-11  2365  	return 0;
37cb11acf1f72a Devesh Sharma      2018-01-11  2366  }
37cb11acf1f72a Devesh Sharma      2018-01-11  2367  
d34ac5cd3a73aa Bart Van Assche    2018-07-18 @2368  int bnxt_re_post_srq_recv(struct ib_srq *ib_srq, const struct ib_recv_wr *wr,
d34ac5cd3a73aa Bart Van Assche    2018-07-18  2369  			  const struct ib_recv_wr **bad_wr)
37cb11acf1f72a Devesh Sharma      2018-01-11  2370  {
37cb11acf1f72a Devesh Sharma      2018-01-11  2371  	struct bnxt_re_srq *srq = container_of(ib_srq, struct bnxt_re_srq,
37cb11acf1f72a Devesh Sharma      2018-01-11  2372  					       ib_srq);
37cb11acf1f72a Devesh Sharma      2018-01-11  2373  	struct bnxt_qplib_swqe wqe;
37cb11acf1f72a Devesh Sharma      2018-01-11  2374  	unsigned long flags;
036ef0a1a86751 Bart Van Assche    2018-03-07  2375  	int rc = 0;
37cb11acf1f72a Devesh Sharma      2018-01-11  2376  
37cb11acf1f72a Devesh Sharma      2018-01-11  2377  	spin_lock_irqsave(&srq->lock, flags);
37cb11acf1f72a Devesh Sharma      2018-01-11  2378  	while (wr) {
37cb11acf1f72a Devesh Sharma      2018-01-11  2379  		/* Transcribe each ib_recv_wr to qplib_swqe */
37cb11acf1f72a Devesh Sharma      2018-01-11  2380  		wqe.num_sge = wr->num_sge;
036ef0a1a86751 Bart Van Assche    2018-03-07  2381  		bnxt_re_build_sgl(wr->sg_list, wqe.sg_list, wr->num_sge);
37cb11acf1f72a Devesh Sharma      2018-01-11  2382  		wqe.wr_id = wr->wr_id;
37cb11acf1f72a Devesh Sharma      2018-01-11  2383  		wqe.type = BNXT_QPLIB_SWQE_TYPE_RECV;
37cb11acf1f72a Devesh Sharma      2018-01-11  2384  
37cb11acf1f72a Devesh Sharma      2018-01-11  2385  		rc = bnxt_qplib_post_srq_recv(&srq->qplib_srq, &wqe);
37cb11acf1f72a Devesh Sharma      2018-01-11  2386  		if (rc) {
37cb11acf1f72a Devesh Sharma      2018-01-11  2387  			*bad_wr = wr;
37cb11acf1f72a Devesh Sharma      2018-01-11  2388  			break;
37cb11acf1f72a Devesh Sharma      2018-01-11  2389  		}
37cb11acf1f72a Devesh Sharma      2018-01-11  2390  		wr = wr->next;
37cb11acf1f72a Devesh Sharma      2018-01-11  2391  	}
37cb11acf1f72a Devesh Sharma      2018-01-11  2392  	spin_unlock_irqrestore(&srq->lock, flags);
37cb11acf1f72a Devesh Sharma      2018-01-11  2393  
37cb11acf1f72a Devesh Sharma      2018-01-11  2394  	return rc;
37cb11acf1f72a Devesh Sharma      2018-01-11  2395  }
1ac5a404797523 Selvin Xavier      2017-02-10  2396  static int bnxt_re_modify_shadow_qp(struct bnxt_re_dev *rdev,
1ac5a404797523 Selvin Xavier      2017-02-10  2397  				    struct bnxt_re_qp *qp1_qp,
1ac5a404797523 Selvin Xavier      2017-02-10  2398  				    int qp_attr_mask)
1ac5a404797523 Selvin Xavier      2017-02-10  2399  {
8dae419f9ec730 Devesh Sharma      2020-02-15  2400  	struct bnxt_re_qp *qp = rdev->gsi_ctx.gsi_sqp;
14611b9b984125 Kalesh AP          2023-08-03  2401  	int rc;
1ac5a404797523 Selvin Xavier      2017-02-10  2402  
1ac5a404797523 Selvin Xavier      2017-02-10  2403  	if (qp_attr_mask & IB_QP_STATE) {
1ac5a404797523 Selvin Xavier      2017-02-10  2404  		qp->qplib_qp.modify_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_STATE;
1ac5a404797523 Selvin Xavier      2017-02-10  2405  		qp->qplib_qp.state = qp1_qp->qplib_qp.state;
1ac5a404797523 Selvin Xavier      2017-02-10  2406  	}
1ac5a404797523 Selvin Xavier      2017-02-10  2407  	if (qp_attr_mask & IB_QP_PKEY_INDEX) {
1ac5a404797523 Selvin Xavier      2017-02-10  2408  		qp->qplib_qp.modify_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_PKEY;
1ac5a404797523 Selvin Xavier      2017-02-10  2409  		qp->qplib_qp.pkey_index = qp1_qp->qplib_qp.pkey_index;
1ac5a404797523 Selvin Xavier      2017-02-10  2410  	}
1ac5a404797523 Selvin Xavier      2017-02-10  2411  
1ac5a404797523 Selvin Xavier      2017-02-10  2412  	if (qp_attr_mask & IB_QP_QKEY) {
1ac5a404797523 Selvin Xavier      2017-02-10  2413  		qp->qplib_qp.modify_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_QKEY;
1ac5a404797523 Selvin Xavier      2017-02-10  2414  		/* Using a Random  QKEY */
1ac5a404797523 Selvin Xavier      2017-02-10  2415  		qp->qplib_qp.qkey = 0x81818181;
1ac5a404797523 Selvin Xavier      2017-02-10  2416  	}
1ac5a404797523 Selvin Xavier      2017-02-10  2417  	if (qp_attr_mask & IB_QP_SQ_PSN) {
1ac5a404797523 Selvin Xavier      2017-02-10  2418  		qp->qplib_qp.modify_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_SQ_PSN;
1ac5a404797523 Selvin Xavier      2017-02-10  2419  		qp->qplib_qp.sq.psn = qp1_qp->qplib_qp.sq.psn;
1ac5a404797523 Selvin Xavier      2017-02-10  2420  	}
1ac5a404797523 Selvin Xavier      2017-02-10  2421  
1ac5a404797523 Selvin Xavier      2017-02-10  2422  	rc = bnxt_qplib_modify_qp(&rdev->qplib_res, &qp->qplib_qp);
1ac5a404797523 Selvin Xavier      2017-02-10  2423  	if (rc)
6ccad8483b2866 Devesh Sharma      2020-02-15  2424  		ibdev_err(&rdev->ibdev, "Failed to modify Shadow QP for QP1");
1ac5a404797523 Selvin Xavier      2017-02-10  2425  	return rc;
1ac5a404797523 Selvin Xavier      2017-02-10  2426  }
1ac5a404797523 Selvin Xavier      2017-02-10  2427  

:::::: The code at line 2178 was first introduced by commit
:::::: 37cb11acf1f72a007a85894a6dd2ec93932bde46 RDMA/bnxt_re: Add SRQ support for Broadcom adapters

:::::: TO: Devesh Sharma <devesh.sharma@broadcom.com>
:::::: CC: Doug Ledford <dledford@redhat.com>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
