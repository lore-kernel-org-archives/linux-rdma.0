Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6B432AAD1
	for <linux-rdma@vger.kernel.org>; Fri, 27 Feb 2026 07:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772178736; cv=none; b=N6+giuFqBMWfPOWS7TZJYjkqKQpt2ZFXD/4qr4IYdeSA5OsUBqCIGGzac97RdmgHNZlTMq2EYrTDymXEHClYAopVVBVCz24fxzYUIMWpHNn/4mELiu9TMVDegTRwD39jgSNWD67IN0p+pmiBRTJPHMbqdCAdVunEruLeoN14MCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772178736; c=relaxed/simple;
	bh=jl4HwSQMMfkphJJTB0pYW8VoNTdR65XwjV+D9dbqKfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XCvWvlPLmuvqOL1gMGsix3foJTqbknGjtXVGa1GVgXwem+1vhPvlNoijpirDqjzS798Uv0iA8ZJzPyzvUYv31mErSeqD9eqrEMGE3LwQRJifyBQmZHfoAewJ/4NOQX3Ygwc92KRysbRnquENyIDLnioqiVESY/lG+7UmbGsiKAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qzth/Xxw; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qzth/Xxw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772178734; x=1803714734;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jl4HwSQMMfkphJJTB0pYW8VoNTdR65XwjV+D9dbqKfo=;
  b=Qzth/Xxw+jREpr/GdOJSiwuXzDhumQ5dnmJyHhWoVrbj13weREduG2Sa
   K1vApNZ7DGpPbP0Fjxoeq6gj6vyAoWG7zXkygrShC4KJRGhqp1frOt0Td
   pWO0uDv+WCzigGfehOG/HOU0+5+xr+M1N4FQmdxOmEcNyredDE/qKWsPw
   /KvQg8O8MZuke5doyOiNJ3QkI7Zw1xPJVALCg5wbI/ZUq3fj0UmHySlNc
   ViwXJixKAqNfsTZvdNxsmiTt3bqJzw0KqqaYLXQwrX53dLzwFG5nVMhfi
   +V+LzoMdHuZdDQUoSgJXV9oeiqpOtnm07CYNzAW0RxyHHCYVT/ISgw24p
   w==;
X-CSE-ConnectionGUID: ZwiXh3anS5C3Ci5nN2mzgQ==
X-CSE-MsgGUID: pPRTr9EORkuSxgPmBF6Qfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11713"; a="73301970"
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="73301970"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 23:52:06 -0800
X-CSE-ConnectionGUID: UwQjJSS1SjCucjyUoHa4hw==
X-CSE-MsgGUID: 2tSJNPdTSOWT+hvepgKmdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="221451825"
Received: from lkp-server02.sh.intel.com (HELO a3936d6a266d) ([10.239.97.151])
  by fmviesa005.fm.intel.com with ESMTP; 26 Feb 2026 23:52:02 -0800
Received: from kbuild by a3936d6a266d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vvsd1-00000000ALB-31GO;
	Fri, 27 Feb 2026 07:51:25 +0000
Date: Fri, 27 Feb 2026 15:50:02 +0800
From: kernel test robot <lkp@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 03/13] RDMA: Add ib_copy_validate_udata_in()
Message-ID: <202602271548.rksoOQrN-lkp@intel.com>
References: <3-v2-13af4a900857+4f13-bnxt_re_uapi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v2-13af4a900857+4f13-bnxt_re_uapi_jgg@nvidia.com>

Hi Jason,

kernel test robot noticed the following build errors:

[auto build test ERROR on 3f4a08e64442340f4807de63e30aef22cc308830]

url:    https://github.com/intel-lab-lkp/linux/commits/Jason-Gunthorpe/RDMA-Use-copy_struct_from_user-instead-of-open-coding/20260227-093947
base:   3f4a08e64442340f4807de63e30aef22cc308830
patch link:    https://lore.kernel.org/r/3-v2-13af4a900857%2B4f13-bnxt_re_uapi_jgg%40nvidia.com
patch subject: [PATCH v2 03/13] RDMA: Add ib_copy_validate_udata_in()
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20260227/202602271548.rksoOQrN-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260227/202602271548.rksoOQrN-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602271548.rksoOQrN-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/infiniband/core/nldev.c:44:
   In file included from drivers/infiniband/core/uverbs.h:49:
   In file included from include/rdma/uverbs_std_types.h:10:
>> include/rdma/uverbs_ioctl.h:964:10: error: use of undeclared identifier 'EVINAL'
     964 |         return -EVINAL;
         |                 ^
   1 error generated.


vim +/EVINAL +964 include/rdma/uverbs_ioctl.h

   959	
   960	static inline int _ib_copy_validate_udata_in(struct ib_udata *udata, void *req,
   961						     size_t kernel_size,
   962						     size_t minimum_size)
   963	{
 > 964		return -EVINAL;
   965	}
   966	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
