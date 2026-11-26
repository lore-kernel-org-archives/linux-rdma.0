Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795734939;
	b=QSL8ESGc1WaNf7npe5PHt4CUpV6qUMSWnMCM+hopRBqkkPbR2V2YbDksH5wKAnU1StD3
	 Cw5zL6paBPtOuVUbhuPAq0hF1iAAFsvkPqsg2VR5+oNBg4QyKgmiTz55My/+ZzNuIpaa1
	 ZW/DuvySHMn6Fy0fEnHIBQI2DylleXrHxUW415sfPfAfYQAEXSKvNEakX0CQxsJbqoryH
	 saeTB6vNiCwJ0IucdSVKA8EfjKHpBb3ezHbZuMI73D9p4na1b8YXc4A622w9ZbMpJGFrT
	 A22tpAcNN7bkwPC88QnhdwO9UoTYSUCBCdkU+ENKZvEGTmjkGSPSL0imPrrO2LcojfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795734939;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=60vvLuN6cDazj57LrWATrAO7V/mmYw10iEcyu6so+68=;
	b=krtxJV+KQeSo4yf1lu/YZjf+MrXYjJ3KyzFqSkGvhvOzyNRGGIvudx46O7u7vw59lE3l
	 sMKImGr0ok1RfQ7U0+fjLVb/DGlsUwzTN/G6xRBppMkFmbkeyAiS08/J31q8yzk7r5YmL
	 aPjjonIjRUWxbP84fMluZVEXhhWzd0WE9ip/PCxFixB871FUstc5cipYTNPycpMhOhiPK
	 +tTUzaJBAI7+twTTNPUU7TFXSLHJ3QyB/Gy4khhcqLvanVurMa0E4ruMzhBU7hjwr4LQ4
	 YoSLMcyxibyasyvWiGdCgfu56vpGYHMhaaE3wAnlhu2dKYjxmPxSfYZH55O8xJa6KNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=DQwwbjRm;
	arc=none smtp.remote-ip=198.175.65.21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB02606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 23:15:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FB02606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=DQwwbjRm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795734938; x=1827270938;
  h=date:from:to:cc:subject:message-id;
  bh=9melxTcORrNdY4iA4zzSPybrme3jEN29eRCU75dOS6A=;
  b=DQwwbjRmivtmyK3HtzD7Nak09s5/1D/TpYh3BhottsxebmkEaPQoi2YZ
   vBIS8Cc0to6n7ryDg6+FEhdWdFSx2paRuM41h/K9CLCNpE1/aIL0PjtOh
   qeBJKKqEiR+c5nmZKQdBfIqhALooJcqvwMt5C/b2Bi0V8FbLm7IY0U09o
   HY95cHnE+yi4kNLstqzntTu9kMu9Z0E7Ip3mic80/YlkcsgZSP7fqaslD
   gX0KjQqDz3hduQ4olkAY++STUUSe7HZyhP89bN13jwEn38inlzXia/Ge3
   GwvFMP++zuxa1wBliFiJatARk83QzsiqUx4zTjiszHc4emB1JBEgMAb5k
   A==;
X-CSE-ConnectionGUID: D1jE/ro1Tjqd2yRFwaSvbQ==
X-CSE-MsgGUID: 5ShIe1KyTyqD0C2hOja9CQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11978"; a="4734910"
X-IronPort-AV: E=Sophos;i="6.27,235,1787036400"; 
   d="scan'208";a="4734910"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2026 15:15:37 -0800
X-CSE-ConnectionGUID: 6aPoUMezTdKZCauhxk/MEw==
X-CSE-MsgGUID: Y77fmrqcQbiTffKfLcKunQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,235,1787036400"; 
   d="scan'208";a="12300771"
Received: from igk-lkp-server01.igk.intel.com (HELO 800201f3098f) ([10.211.93.152])
  by orviesa006.jf.intel.com with ESMTP; 26 Nov 2026 15:15:32 -0800
Received: from kbuild by 800201f3098f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xWigb-000000000EK-1iEj;
	Thu, 26 Nov 2026 23:15:29 +0000
Date: Fri, 27 Nov 2026 00:14:45 +0100
From: kernel test robot <lkp@intel.com>
To: Yuho Choi <oss.patchbox@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org,
 Leon Romanovsky <leon@kernel.org>
Subject: [rdma:wip/leon-for-next 63/69]
 drivers/infiniband/hw/bnxt_re/ib_verbs.c:953:6: warning: unused variable 'rc'
Message-ID: <20261127001029.bEUPKsfa-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git wip/leon-for-next
head:   d24184a64765d7797ff0f46f6872aa91a6a1a5da
commit: a95c6b735017c61d92e7465d153fb06d540f2132 [63/69] RDMA/bnxt_re: Don't republish a QP whose destroy failed
config: x86_64-allmodconfig (https://download.01.org/0day-ci/archive/20261127/20261127001029.bEUPKsfa-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
rustc: rustc 1.96.0 (ac68faa20 2026-05-25)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261127/20261127001029.bEUPKsfa-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261127001029.bEUPKsfa-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:953:6: warning: unused variable 'rc' [-Wunused-variable]
     953 |         int rc;
         |             ^~
   1 warning generated.


vim +/rc +953 drivers/infiniband/hw/bnxt_re/ib_verbs.c

3b921e3bc4c20a Selvin Xavier      2018-02-15  947  
88de89f184661e YanLong Dai        2025-09-24  948  static void bnxt_re_destroy_gsi_sqp(struct bnxt_re_qp *qp)
8dae419f9ec730 Devesh Sharma      2020-02-15  949  {
8dae419f9ec730 Devesh Sharma      2020-02-15  950  	struct bnxt_re_qp *gsi_sqp;
8dae419f9ec730 Devesh Sharma      2020-02-15  951  	struct bnxt_re_ah *gsi_sah;
8dae419f9ec730 Devesh Sharma      2020-02-15  952  	struct bnxt_re_dev *rdev;
14611b9b984125 Kalesh AP          2023-08-03 @953  	int rc;
8dae419f9ec730 Devesh Sharma      2020-02-15  954  
8dae419f9ec730 Devesh Sharma      2020-02-15  955  	rdev = qp->rdev;
8dae419f9ec730 Devesh Sharma      2020-02-15  956  	gsi_sqp = rdev->gsi_ctx.gsi_sqp;
8dae419f9ec730 Devesh Sharma      2020-02-15  957  	gsi_sah = rdev->gsi_ctx.gsi_sah;
8dae419f9ec730 Devesh Sharma      2020-02-15  958  
6ccad8483b2866 Devesh Sharma      2020-02-15  959  	ibdev_dbg(&rdev->ibdev, "Destroy the shadow AH\n");
8dae419f9ec730 Devesh Sharma      2020-02-15  960  	bnxt_qplib_destroy_ah(&rdev->qplib_res,
8dae419f9ec730 Devesh Sharma      2020-02-15  961  			      &gsi_sah->qplib_ah,
8dae419f9ec730 Devesh Sharma      2020-02-15  962  			      true);
063975feedb143 Chandramohan Akula 2023-07-26  963  	atomic_dec(&rdev->stats.res.ah_count);
8dae419f9ec730 Devesh Sharma      2020-02-15  964  	bnxt_qplib_clean_qp(&qp->qplib_qp);
8dae419f9ec730 Devesh Sharma      2020-02-15  965  
6ccad8483b2866 Devesh Sharma      2020-02-15  966  	ibdev_dbg(&rdev->ibdev, "Destroy the shadow QP\n");
a95c6b735017c6 Yuho Choi          2026-11-24  967  	bnxt_qplib_destroy_qp(&rdev->qplib_res, &gsi_sqp->qplib_qp);
88de89f184661e YanLong Dai        2025-09-24  968  
8dae419f9ec730 Devesh Sharma      2020-02-15  969  	bnxt_qplib_free_qp_res(&rdev->qplib_res, &gsi_sqp->qplib_qp);
8dae419f9ec730 Devesh Sharma      2020-02-15  970  
097a9d23b72503 Selvin Xavier      2020-08-24  971  	/* remove from active qp list */
097a9d23b72503 Selvin Xavier      2020-08-24  972  	mutex_lock(&rdev->qp_lock);
097a9d23b72503 Selvin Xavier      2020-08-24  973  	list_del(&gsi_sqp->list);
097a9d23b72503 Selvin Xavier      2020-08-24  974  	mutex_unlock(&rdev->qp_lock);
063975feedb143 Chandramohan Akula 2023-07-26  975  	atomic_dec(&rdev->stats.res.qp_count);
097a9d23b72503 Selvin Xavier      2020-08-24  976  
8dae419f9ec730 Devesh Sharma      2020-02-15  977  	kfree(rdev->gsi_ctx.sqp_tbl);
8dae419f9ec730 Devesh Sharma      2020-02-15  978  	kfree(gsi_sah);
8dae419f9ec730 Devesh Sharma      2020-02-15  979  	kfree(gsi_sqp);
8dae419f9ec730 Devesh Sharma      2020-02-15  980  	rdev->gsi_ctx.gsi_sqp = NULL;
8dae419f9ec730 Devesh Sharma      2020-02-15  981  	rdev->gsi_ctx.gsi_sah = NULL;
8dae419f9ec730 Devesh Sharma      2020-02-15  982  	rdev->gsi_ctx.sqp_tbl = NULL;
8dae419f9ec730 Devesh Sharma      2020-02-15  983  }
8dae419f9ec730 Devesh Sharma      2020-02-15  984  

:::::: The code at line 953 was first introduced by commit
:::::: 14611b9b984125b2da5966d0725fdd89f6564c45 RDMA/bnxt_re: Remove unnecessary variable initializations

:::::: TO: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
:::::: CC: Leon Romanovsky <leon@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
