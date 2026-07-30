Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9571A682A
	for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 03:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785380941; cv=none; b=MZFXv7uueWG1NZY2snD1rrAINKOz0vzrB7H6dB6/z8qEHQYTaYnI46EYXvlE9apae32J/K25/uDMEduYpDWmaMTHA7gVYjqMTbjLlO9T+Cdc0ttuajPsz1Sec8q4EiopRPT495RLb+EpADGzGQ+xHWdGxWoVrA4k2w4FVr4sh3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785380941; c=relaxed/simple;
	bh=Mju5Vc9XvI6U0ZFC5gsqOBehmXLwzhO747Rsg/rYqcQ=;
	h=Date:From:To:Cc:Subject:Message-ID; b=KGzpvjlelGHGgvnrMAmuTtfsImWiyp8AW3dM4Z/azGePKg1Nqi1oajh3D9VnvkDUhqLIWGU+ZLeynFxkjruE5dcM8LmDY2liRuNgA3g+GfuorPEyivNL6rfpxlXOIESyZ3FP/wZ94YX5v/HfIvJGP2Y1Ytd4i6xCD+tkWxU/FiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a7jzhjcG; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a7jzhjcG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785380938; x=1816916938;
  h=date:from:to:cc:subject:message-id;
  bh=Mju5Vc9XvI6U0ZFC5gsqOBehmXLwzhO747Rsg/rYqcQ=;
  b=a7jzhjcGwrJciEByOhq0RsO+brP+ctT1q6bX8y8iEwGZ3p4rGjFOtPwU
   /nILEmU7D1I6Tr6tTf0R7MI7kULcc81W839ca/nHW9d5azKglpdpjW6ht
   zALkByc5Wh3bnOdQhQfIUduFh8G9t4jBePMz9Veo4x4QUoDHSnGdemWnI
   VIZp3Ct15/lEU59Cp7N2ztM3krZt+9t5Qjpcebm5tvIX+xe6DBqwbdpZF
   CPld2Oy73AxSIzh46tqGVQjnq3z8YlzNwdqCLPRjY17rMCJst30aKI19F
   ydvDivBE+SUvMRwycdBXxAH3ZNdEcEFg3WfmdxKYVqAUefQl7PIUE9fKy
   A==;
X-CSE-ConnectionGUID: tEJr2wrjQ86YMd9G3qLRrQ==
X-CSE-MsgGUID: 6kG4/LZrQjmscQcHNzX/uA==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="86031195"
X-IronPort-AV: E=Sophos;i="6.25,193,1779174000"; 
   d="scan'208";a="86031195"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 20:08:56 -0700
X-CSE-ConnectionGUID: 61vERZECS8u4gebOMAmV/w==
X-CSE-MsgGUID: 3Capd22XTg+249/vAPMZ5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,193,1779174000"; 
   d="scan'208";a="263992026"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 29 Jul 2026 20:08:54 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wpH8P-00000000fxu-3o5U;
	Thu, 30 Jul 2026 03:08:43 +0000
Date: Thu, 30 Jul 2026 11:07:31 +0800
From: kernel test robot <lkp@intel.com>
To: Leon Romanovsky <leonro@nvidia.com>
Cc: Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [rdma:wip/leon-for-next] BUILD SUCCESS
 fdfb5cea4bf070cdb31d997efd87bb684df041fd
Message-ID: <202607301120.78BlPcvq-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git wip/leon-for-next
branch HEAD: fdfb5cea4bf070cdb31d997efd87bb684df041fd  RDMA/cxgb4: free STAG index when TPT entry write fails

elapsed time: 836m

configs tested: 127
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260730    gcc-11.5.0
arc                  randconfig-001-20260730    gcc-8.5.0
arc                  randconfig-002-20260730    gcc-8.5.0
arm                  randconfig-001-20260730    gcc-8.5.0
arm                  randconfig-002-20260730    gcc-15.2.0
arm                  randconfig-002-20260730    gcc-8.5.0
arm                  randconfig-003-20260730    gcc-13.4.0
arm                  randconfig-003-20260730    gcc-8.5.0
arm                  randconfig-004-20260730    clang-24
arm                  randconfig-004-20260730    gcc-8.5.0
arm                       realview_defconfig    clang-17
arm64                randconfig-001-20260730    gcc-15.2.0
arm64                randconfig-002-20260730    clang-21
arm64                randconfig-002-20260730    gcc-15.2.0
arm64                randconfig-003-20260730    gcc-15.2.0
arm64                randconfig-003-20260730    gcc-8.5.0
arm64                randconfig-004-20260730    gcc-13.4.0
arm64                randconfig-004-20260730    gcc-15.2.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260730    gcc-13.4.0
csky                 randconfig-001-20260730    gcc-15.2.0
csky                 randconfig-002-20260730    gcc-15.2.0
csky                 randconfig-002-20260730    gcc-16.1.0
hexagon              randconfig-001-20260730    clang-24
hexagon              randconfig-002-20260730    clang-24
i386                            allmodconfig    gcc-14
i386                buildonly-randconfig-001    gcc-14
i386       buildonly-randconfig-001-20260730    clang-22
i386       buildonly-randconfig-001-20260730    gcc-14
i386       buildonly-randconfig-002-20260730    clang-22
i386       buildonly-randconfig-002-20260730    gcc-14
i386       buildonly-randconfig-003-20260730    gcc-14
i386       buildonly-randconfig-004-20260730    clang-22
i386       buildonly-randconfig-004-20260730    gcc-14
i386       buildonly-randconfig-005-20260730    gcc-14
i386       buildonly-randconfig-006-20260730    gcc-14
i386                 randconfig-001-20260730    gcc-14
i386                 randconfig-003-20260730    gcc-14
i386                 randconfig-006-20260730    gcc-14
i386                 randconfig-011-20260730    clang-22
i386                 randconfig-012-20260730    clang-22
i386                 randconfig-013-20260730    clang-22
i386                 randconfig-014-20260730    gcc-14
i386                 randconfig-015-20260730    clang-22
i386                 randconfig-016-20260730    gcc-13
i386                 randconfig-017-20260730    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260730    clang-24
loongarch            randconfig-001-20260730    gcc-16.1.0
loongarch            randconfig-002-20260730    clang-24
loongarch            randconfig-002-20260730    gcc-13.4.0
m68k                       m5272c3_defconfig    gcc-16.1.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260730    clang-24
nios2                randconfig-001-20260730    gcc-11.5.0
nios2                randconfig-002-20260730    clang-24
nios2                randconfig-002-20260730    gcc-9.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc                        randconfig-001    gcc-14.3.0
parisc               randconfig-001-20260730    gcc-14.3.0
parisc               randconfig-002-20260730    gcc-14.3.0
parisc               randconfig-002-20260730    gcc-16.1.0
powerpc              randconfig-001-20260730    clang-24
powerpc              randconfig-001-20260730    gcc-14.3.0
powerpc              randconfig-002-20260730    gcc-11.5.0
powerpc              randconfig-002-20260730    gcc-14.3.0
powerpc64            randconfig-001-20260730    clang-24
powerpc64            randconfig-001-20260730    gcc-14.3.0
powerpc64            randconfig-002-20260730    gcc-14.3.0
powerpc64            randconfig-002-20260730    gcc-8.5.0
riscv                randconfig-001-20260730    gcc-15.2.0
riscv                randconfig-002-20260730    gcc-15.2.0
riscv                randconfig-002-20260730    gcc-9.5.0
s390                 randconfig-001-20260730    clang-17
s390                 randconfig-001-20260730    gcc-15.2.0
s390                 randconfig-002-20260730    gcc-15.2.0
s390                 randconfig-002-20260730    gcc-8.5.0
sh                        apsh4a3a_defconfig    gcc-16.1.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260730    gcc-13.4.0
sh                   randconfig-001-20260730    gcc-15.2.0
sh                   randconfig-002-20260730    gcc-15.2.0
sparc                randconfig-001-20260730    gcc-16.1.0
sparc                randconfig-002-20260730    gcc-16.1.0
sparc64              randconfig-001-20260730    clang-20
sparc64              randconfig-002-20260730    gcc-14.3.0
um                   randconfig-001-20260730    clang-17
um                   randconfig-002-20260730    clang-24
x86_64     buildonly-randconfig-001-20260730    clang-22
x86_64     buildonly-randconfig-001-20260730    gcc-14
x86_64     buildonly-randconfig-002-20260730    clang-22
x86_64     buildonly-randconfig-002-20260730    gcc-14
x86_64     buildonly-randconfig-003-20260730    clang-22
x86_64     buildonly-randconfig-003-20260730    gcc-14
x86_64     buildonly-randconfig-004-20260730    gcc-14
x86_64     buildonly-randconfig-005-20260730    gcc-14
x86_64     buildonly-randconfig-006-20260730    gcc-14
x86_64                                 kexec    clang-22
x86_64               randconfig-001-20260730    clang-22
x86_64               randconfig-002-20260730    clang-22
x86_64               randconfig-003-20260730    clang-22
x86_64               randconfig-004-20260730    clang-22
x86_64               randconfig-005-20260730    clang-22
x86_64               randconfig-006-20260730    clang-22
x86_64               randconfig-011-20260730    gcc-12
x86_64               randconfig-012-20260730    gcc-14
x86_64               randconfig-013-20260730    gcc-14
x86_64               randconfig-014-20260730    clang-22
x86_64               randconfig-015-20260730    clang-22
x86_64               randconfig-016-20260730    gcc-12
x86_64               randconfig-071-20260730    gcc-14
x86_64               randconfig-072-20260730    gcc-12
x86_64               randconfig-073-20260730    clang-22
x86_64               randconfig-074-20260730    gcc-12
x86_64               randconfig-075-20260730    clang-22
x86_64               randconfig-076-20260730    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260730    gcc-16.1.0
xtensa               randconfig-002-20260730    gcc-14.3.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
