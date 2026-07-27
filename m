Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FBD3546C3
	for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 16:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785169858; cv=none; b=gxQFjqLEF/OgWuRvNTkxGGofN76GSFTgRwmUz2MptjIfe7tFhlJf6FyerbASzYuu5Fd8jVws+VguZvkrcUhVeDgIcEBievHUVVUI7EM4ZuwHBKiiXvmfchmQWV9bDyWGp1Q8oN5OU+1gacMO4CXQpI104ocoyU8nlf1U7gmjUAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785169858; c=relaxed/simple;
	bh=licB4syIGqDjwHw6jywufkNg9oa4LowRaVvMvywkYKA=;
	h=Date:From:To:Cc:Subject:Message-ID; b=blCeLXSxASLjhAJG47O6MdyiIpC3cjxx3jACrtt8im1WqlHPEunz1pc9TGhoq9F5CmoXR2Jay66Ab5coKPFuUFdwrynMZBOEkK/eD2KgazRmkWm3F9Yh94bqhTOgfeeuGTqrmgpjT6edvsnvfshrRJ0ke7YHQuOEkW3oYI2f99o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NNNnX5FM; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NNNnX5FM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785169856; x=1816705856;
  h=date:from:to:cc:subject:message-id;
  bh=licB4syIGqDjwHw6jywufkNg9oa4LowRaVvMvywkYKA=;
  b=NNNnX5FM4LY98zvu5czC5ujS5juA2N6jNs5i5W6iUYqtd6TGyoDoM5/1
   uWYJVztv+AdiSVl9KL5x7mQ2Z2HGddCnhsnOD2QdJwyxP38lfy4T2L3rG
   TmuUKR+WS4+6g7Brg3cL98JDpIpHVPviwx7GQM5tXsgbk4qgHSZHG0JxG
   ahOl/W+mwxtH1AhiSPQwbWV2Qu9YZftVz92rmOMt88IQl9qKGir1bA23J
   j5lkXCVUTWNemx7k5DyJ+Z3pyHtxsk+cT3gvgfql/qB15y5E7nwXyEW21
   k0m0EwwyOysLba+bcWwzPY0W/SKUCTahnIWpfNGs79MxEYWI0HSqTMNEc
   g==;
X-CSE-ConnectionGUID: 48ZZ75OESGWa9ocHQj7lsA==
X-CSE-MsgGUID: jRGUlfhkQ6qVsQ0HeexBiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11858"; a="73280159"
X-IronPort-AV: E=Sophos;i="6.25,188,1779174000"; 
   d="scan'208";a="73280159"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2026 09:30:55 -0700
X-CSE-ConnectionGUID: rV1xtYtzTKCqPCX7rAMuqg==
X-CSE-MsgGUID: pqyUr8q9SKCRiJJ6LcEJVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,188,1779174000"; 
   d="scan'208";a="261425222"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 27 Jul 2026 09:30:53 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1woOE6-00000000dJo-1sYo;
	Mon, 27 Jul 2026 16:30:50 +0000
Date: Tue, 28 Jul 2026 00:30:20 +0800
From: kernel test robot <lkp@intel.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [rdma:wip/leon-for-next] BUILD REGRESSION
 a273210687f255b12c2f6baf8f25ff80cdbb29ed
Message-ID: <202607280004.TAQWia5O-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git wip/leon-for-next
branch HEAD: a273210687f255b12c2f6baf8f25ff80cdbb29ed  RDMA/cxgb4: remove dead NULL checks after GFP_NOFAIL allocations

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/infiniband/hw/mthca/mthca_provider.c:946:1: internal compiler error: in final_scan_insn_1, at final.cc:2823

Error/Warning ids grouped by kconfigs:

recent_errors
`-- csky-allmodconfig
    `-- drivers-infiniband-hw-mthca-mthca_provider.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc

elapsed time: 884m

configs tested: 94
configs skipped: 2

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                           randconfig-001    gcc-8.5.0
arc                  randconfig-001-20260727    gcc-8.5.0
arc                  randconfig-002-20260727    gcc-8.5.0
arm                      imx_v4_v5_defconfig    clang-24
arm                  randconfig-001-20260727    gcc-8.5.0
arm                  randconfig-002-20260727    gcc-8.5.0
arm                  randconfig-003-20260727    gcc-8.5.0
arm                  randconfig-004-20260727    clang-20
arm64                         randconfig-001    gcc-14.3.0
arm64                randconfig-001-20260727    gcc-9.5.0
arm64                randconfig-002-20260727    gcc-8.5.0
arm64                randconfig-003-20260727    gcc-8.5.0
arm64                randconfig-004-20260727    gcc-15.2.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260727    gcc-11.5.0
csky                 randconfig-002-20260727    gcc-9.5.0
hexagon              randconfig-001-20260727    clang-22
hexagon              randconfig-002-20260727    clang-24
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260727    gcc-14
i386       buildonly-randconfig-002-20260727    gcc-14
i386       buildonly-randconfig-003-20260727    gcc-14
i386       buildonly-randconfig-004-20260727    clang-22
i386       buildonly-randconfig-005-20260727    clang-22
i386       buildonly-randconfig-006-20260727    gcc-14
i386                 randconfig-001-20260727    clang-22
i386                 randconfig-002-20260727    gcc-14
i386                 randconfig-003-20260727    clang-22
i386                 randconfig-004-20260727    gcc-14
i386                 randconfig-005-20260727    gcc-12
i386                 randconfig-006-20260727    clang-22
i386                 randconfig-007-20260727    clang-22
i386                 randconfig-011-20260727    clang-22
i386                 randconfig-012-20260727    clang-22
i386                 randconfig-013-20260727    clang-22
i386                 randconfig-014-20260727    clang-22
i386                 randconfig-015-20260727    clang-22
i386                 randconfig-016-20260727    gcc-14
i386                 randconfig-017-20260727    gcc-13
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260727    gcc-16.1.0
loongarch            randconfig-002-20260727    gcc-15.2.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260727    gcc-8.5.0
nios2                randconfig-002-20260727    gcc-11.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260727    gcc-12.5.0
parisc               randconfig-002-20260727    gcc-8.5.0
powerpc              randconfig-001-20260727    gcc-11.5.0
powerpc              randconfig-002-20260727    gcc-8.5.0
powerpc64            randconfig-001-20260727    gcc-8.5.0
powerpc64            randconfig-002-20260727    clang-18
riscv                randconfig-001-20260727    gcc-9.5.0
riscv                randconfig-002-20260727    gcc-11.5.0
s390                 randconfig-001-20260727    clang-24
s390                 randconfig-002-20260727    gcc-8.5.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260727    gcc-15.2.0
sh                   randconfig-002-20260727    gcc-16.1.0
sparc                         randconfig-001    gcc-16.1.0
sparc                randconfig-001-20260727    gcc-16.1.0
sparc                randconfig-002-20260727    gcc-8.5.0
sparc64              randconfig-001-20260727    gcc-10.5.0
sparc64              randconfig-002-20260727    gcc-12.5.0
um                   randconfig-001-20260727    gcc-14
um                   randconfig-002-20260727    clang-21
x86_64     buildonly-randconfig-001-20260727    gcc-14
x86_64     buildonly-randconfig-002-20260727    gcc-14
x86_64     buildonly-randconfig-003-20260727    clang-22
x86_64     buildonly-randconfig-004-20260727    clang-22
x86_64     buildonly-randconfig-005-20260727    gcc-14
x86_64     buildonly-randconfig-006-20260727    gcc-14
x86_64                        randconfig-001    gcc-14
x86_64               randconfig-001-20260727    gcc-13
x86_64               randconfig-002-20260727    clang-22
x86_64               randconfig-003-20260727    gcc-14
x86_64               randconfig-004-20260727    clang-22
x86_64               randconfig-005-20260727    clang-22
x86_64               randconfig-006-20260727    clang-22
x86_64               randconfig-071-20260727    gcc-12
x86_64               randconfig-072-20260727    gcc-14
x86_64               randconfig-073-20260727    gcc-14
x86_64               randconfig-074-20260727    clang-22
x86_64               randconfig-075-20260727    gcc-12
x86_64               randconfig-076-20260727    gcc-14
xtensa               randconfig-001-20260727    gcc-14.3.0
xtensa               randconfig-002-20260727    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
