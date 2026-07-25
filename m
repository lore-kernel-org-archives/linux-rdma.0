Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A0D367F3A
	for <linux-rdma@vger.kernel.org>; Sat, 25 Jul 2026 23:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785023646; cv=none; b=HgD8cM0v2NKF/51TtNlooLtq7FRaIeA1k0d/ErJAPcfCoBPKdlahZDjD8vnXHNGKP6KfINeHxeo02adel2mSXDEcn5aRkSoebfR+qLSNKNCqijwL2Y/ygXaSLpEc10cz7n3ozBdkSW5vSBYxXk6ff2DoUwLn2PHnu/du+6M7xjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785023646; c=relaxed/simple;
	bh=5uoDhMzynw9RWfbvNIdit1xbCkHAwFJ5PnI88QYAW0E=;
	h=Date:From:To:Cc:Subject:Message-ID; b=EOoaY9slJY3+vRlH0B/grRs4QQgrSCN8HaO3PvhdREmcQvXoEa4CU3lZJdHSkXfALE8LXXcMeM3/vEW1tgD9vEjpOL7zF25+hmwsSonjL1AFk1o63/fRlsSC5IZ3lOrl55a+qU9MOQ/VI5fK7ULhNgki+ziGXyURutLPqPktk5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZpWiYmOO; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZpWiYmOO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785023644; x=1816559644;
  h=date:from:to:cc:subject:message-id;
  bh=5uoDhMzynw9RWfbvNIdit1xbCkHAwFJ5PnI88QYAW0E=;
  b=ZpWiYmOOBbhOo0hErwwNSMD5MRFchjfU659fCQkK0EJJrI15VMg+MUPU
   nxWesXZWtS18MSsVt8xF/i7wddVk94YCZtmqdZlEB/IyP8giGUJwphkNs
   e9bfuYSdpqf2sDRIc0e34H4dwXrnLL9+NN5WgKCkrjFEa1wUvk9DJzgoh
   CD0iyY0QrtAQHzxqA2+QSv+9QTS34VBsLIWzgreOpl+Vi5p8dBwPswTWC
   DZtpLdU7S3rMshqBhqVE3gX1u7e0mdu7xUqRbkl2oEZTmlUGlbKOwlQfO
   /nCHC5DbrurA3bjqWho0hI4R7rdxvyuaUqITZ94kk6OTbq0kEXuRqJBM4
   g==;
X-CSE-ConnectionGUID: 20ywWOkvQDOEpv6VbkuoyA==
X-CSE-MsgGUID: FV8lo3Q5QtGVrCgcwXf6YQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11856"; a="108436643"
X-IronPort-AV: E=Sophos;i="6.25,185,1779174000"; 
   d="scan'208";a="108436643"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2026 16:54:03 -0700
X-CSE-ConnectionGUID: Ypn/N6HbRK2MJPBhIcVdAg==
X-CSE-MsgGUID: heL90T8xTzGP/y10M0wAUQ==
X-ExtLoop1: 1
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa003.fm.intel.com with ESMTP; 25 Jul 2026 16:54:01 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wnmBq-00000000c8p-1mOW;
	Sat, 25 Jul 2026 23:53:58 +0000
Date: Sun, 26 Jul 2026 07:53:35 +0800
From: kernel test robot <lkp@intel.com>
To: Leon Romanovsky <leonro@nvidia.com>
Cc: Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [rdma:for-next] BUILD SUCCESS
 9b66c9af7172ffcf727214fa0ebe9a5e1ed6eb16
Message-ID: <202607260722.joeFcXgz-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git for-next
branch HEAD: 9b66c9af7172ffcf727214fa0ebe9a5e1ed6eb16  RDMA/bnxt_re: Clear VM_MAYWRITE on DBR/toggle page mmap

elapsed time: 3916m

configs tested: 104
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                           randconfig-001    clang-21
arc                  randconfig-001-20260725    clang-21
arc                  randconfig-002-20260725    clang-21
arm                  randconfig-001-20260725    clang-21
arm                  randconfig-002-20260725    clang-21
arm                  randconfig-003-20260725    clang-21
arm                  randconfig-004-20260725    clang-21
arm64                randconfig-001-20260725    clang-24
arm64                randconfig-002-20260725    clang-24
arm64                randconfig-003-20260725    clang-24
arm64                randconfig-004-20260725    clang-24
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260725    clang-24
csky                 randconfig-002-20260725    clang-24
hexagon                       randconfig-001    gcc-9.5.0
hexagon              randconfig-001-20260725    gcc-9.5.0
hexagon              randconfig-002-20260725    gcc-9.5.0
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260725    clang-22
i386       buildonly-randconfig-002-20260725    clang-22
i386       buildonly-randconfig-003-20260725    clang-22
i386       buildonly-randconfig-004-20260725    clang-22
i386       buildonly-randconfig-005-20260725    clang-22
i386       buildonly-randconfig-006-20260725    clang-22
i386                          randconfig-001    clang-22
i386                 randconfig-001-20260725    clang-22
i386                 randconfig-002-20260725    clang-22
i386                 randconfig-003-20260725    clang-22
i386                 randconfig-004-20260725    clang-22
i386                 randconfig-005-20260725    clang-22
i386                 randconfig-006-20260725    clang-22
i386                 randconfig-007-20260725    clang-22
i386                 randconfig-011-20260725    clang-22
i386                 randconfig-012-20260725    clang-22
i386                 randconfig-013-20260725    clang-22
i386                 randconfig-014-20260725    clang-22
i386                 randconfig-015-20260725    clang-22
i386                 randconfig-016-20260725    clang-22
i386                 randconfig-017-20260725    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260725    gcc-9.5.0
loongarch            randconfig-002-20260725    gcc-9.5.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260725    gcc-9.5.0
nios2                randconfig-002-20260725    gcc-9.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260725    clang-17
parisc               randconfig-002-20260725    clang-17
powerpc              randconfig-001-20260725    clang-17
powerpc              randconfig-002-20260725    clang-17
powerpc64            randconfig-001-20260725    clang-17
powerpc64            randconfig-002-20260725    clang-17
riscv                randconfig-001-20260725    gcc-10.5.0
riscv                randconfig-002-20260725    gcc-10.5.0
s390                 randconfig-001-20260725    gcc-10.5.0
s390                 randconfig-002-20260725    gcc-10.5.0
sh                                 defconfig    gcc-16.1.0
sh                       edosk7760_defconfig    gcc-16.1.0
sh                   randconfig-001-20260725    gcc-10.5.0
sh                   randconfig-002-20260725    gcc-10.5.0
sparc                randconfig-001-20260725    gcc-8.5.0
sparc                randconfig-002-20260725    gcc-8.5.0
sparc64              randconfig-001-20260725    gcc-8.5.0
sparc64              randconfig-002-20260725    gcc-8.5.0
um                   randconfig-001-20260725    gcc-8.5.0
um                   randconfig-002-20260725    gcc-8.5.0
x86_64     buildonly-randconfig-001-20260725    gcc-12
x86_64     buildonly-randconfig-002-20260725    gcc-12
x86_64     buildonly-randconfig-003-20260725    gcc-12
x86_64     buildonly-randconfig-004-20260725    gcc-12
x86_64     buildonly-randconfig-005-20260725    gcc-12
x86_64     buildonly-randconfig-006-20260725    gcc-12
x86_64                                 kexec    clang-22
x86_64                        randconfig-001    gcc-14
x86_64               randconfig-001-20260725    gcc-14
x86_64               randconfig-002-20260725    gcc-14
x86_64               randconfig-003-20260725    gcc-14
x86_64               randconfig-004-20260725    gcc-14
x86_64               randconfig-005-20260725    gcc-14
x86_64               randconfig-006-20260725    gcc-14
x86_64                        randconfig-011    gcc-14
x86_64               randconfig-011-20260725    gcc-14
x86_64               randconfig-012-20260725    gcc-14
x86_64               randconfig-013-20260725    gcc-14
x86_64               randconfig-014-20260725    gcc-14
x86_64               randconfig-015-20260725    gcc-14
x86_64               randconfig-016-20260725    gcc-14
x86_64               randconfig-071-20260725    gcc-14
x86_64               randconfig-072-20260725    gcc-14
x86_64               randconfig-073-20260725    gcc-14
x86_64               randconfig-074-20260725    gcc-14
x86_64               randconfig-075-20260725    gcc-14
x86_64               randconfig-076-20260725    gcc-14
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260725    gcc-8.5.0
xtensa               randconfig-002-20260725    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
