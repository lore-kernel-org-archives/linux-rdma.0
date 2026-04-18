Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A23C3A0E97
	for <linux-rdma@vger.kernel.org>; Sat, 18 Apr 2026 23:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776554818; cv=none; b=hfxZtRaCr4lFZNxHM921WXbysRopwrVT2ST4OxhmIPcDb586KDUpLYHa0OKgIhiZvw15Y0UPcOQp+WK699+LngnEFR4xKbUyJKIQ5/Ah81eUCk3jMHiQXr9H91uik/eUsEtYnGyJoKSWlMMF33my5mgcYgOmZQNqZS+pVg+fSSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776554818; c=relaxed/simple;
	bh=WkC0BPW/MnY+ZX/cRtCbSz1uXlb1HtzhdTlPLbjfHcQ=;
	h=Date:From:To:Cc:Subject:Message-ID; b=HEvEUQT4Ndzk46W47hCDHsW2s5GinTHcFFVmBCcdgFJmzFWsBrctm244SpPmDrc2RYQqqqWMuAqGlsZkNovwsBiZAHu54uK3581v6gr4KHKpchYg3v4pYL9LOJmQ1GWO7yXVm+m1m9ffvTKbgbg1BMjYt7QZRQYawhbFDFfgIYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y4qKtVHV; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y4qKtVHV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776554813; x=1808090813;
  h=date:from:to:cc:subject:message-id;
  bh=WkC0BPW/MnY+ZX/cRtCbSz1uXlb1HtzhdTlPLbjfHcQ=;
  b=Y4qKtVHVAAJJ+gkt7fqlvhNmWUtm3zHRydYkNnjVToGYcUA/7PoJPOr+
   1NT6xwPEn7CquWEMataunVvQ48mCPNYq9Pz7qKLGbi3aBwFQkQhnoLEyc
   EwGiA2zz2M2RTCZIi3ua48MG7uL4ZaZ6IWq0D4ZY0iL9hHMgelp2EsQbW
   NkH73IbEfv/n74RPHnVrSpyJSfKg/FbS1kw9BGA9Hd7GmqUCtLgHVz43U
   GTLBZAjEIHnYnD0SG8hAJD6GNgVZMmV/2i6DXOGf7yOir1zo4wkZWeQR1
   OkaEfdxE+kSQk3dCYvTjIAyxDYUwNEB+RENxN6BHREdJ2YMHP4sHPMpit
   w==;
X-CSE-ConnectionGUID: WWof6GM6RLqOgH0dzqmwaA==
X-CSE-MsgGUID: TZWznjjuR+ulHbAizST8UQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11762"; a="87821394"
X-IronPort-AV: E=Sophos;i="6.23,187,1770624000"; 
   d="scan'208";a="87821394"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2026 16:26:50 -0700
X-CSE-ConnectionGUID: 1GmSzXiKRmOe5UQgQPbPMw==
X-CSE-MsgGUID: jUz4+n+6TTaXLe/KYq21ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,187,1770624000"; 
   d="scan'208";a="224862199"
Received: from lkp-server01.sh.intel.com (HELO 7e48d0ff8e22) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 18 Apr 2026 16:26:48 -0700
Received: from kbuild by 7e48d0ff8e22 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wEF3l-000000001Y8-1B1q;
	Sat, 18 Apr 2026 23:26:45 +0000
Date: Sun, 19 Apr 2026 07:25:52 +0800
From: kernel test robot <lkp@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Subject: [rdma:for-next] BUILD SUCCESS
 9091e3b59f2bef11c0a841096327565ae0ca220b
Message-ID: <202604190742.v4zyM1lU-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git for-next
branch HEAD: 9091e3b59f2bef11c0a841096327565ae0ca220b  RDMA/core: Fix user CQ creation for drivers without create_cq

elapsed time: 1442m

configs tested: 150
configs skipped: 13

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260418    gcc-9.5.0
arc                   randconfig-002-20260418    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                                 defconfig    clang-23
arm                   randconfig-001-20260418    gcc-8.5.0
arm                   randconfig-002-20260418    gcc-11.5.0
arm                   randconfig-004-20260418    clang-20
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260418    clang-23
arm64                 randconfig-002-20260418    gcc-8.5.0
arm64                 randconfig-003-20260418    clang-23
arm64                 randconfig-004-20260418    clang-23
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260418    gcc-15.2.0
csky                  randconfig-002-20260418    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260418    clang-23
hexagon               randconfig-002-20260418    clang-23
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260418    clang-20
i386        buildonly-randconfig-002-20260418    gcc-14
i386        buildonly-randconfig-003-20260418    clang-20
i386        buildonly-randconfig-004-20260418    clang-20
i386        buildonly-randconfig-005-20260418    gcc-14
i386        buildonly-randconfig-006-20260418    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20260418    gcc-14
i386                  randconfig-002-20260418    gcc-12
i386                  randconfig-003-20260418    gcc-14
i386                  randconfig-004-20260418    gcc-12
i386                  randconfig-005-20260418    gcc-12
i386                  randconfig-006-20260418    gcc-14
i386                  randconfig-007-20260418    clang-20
i386                  randconfig-011-20260418    clang-20
i386                  randconfig-012-20260418    clang-20
i386                  randconfig-013-20260418    gcc-13
i386                  randconfig-014-20260418    clang-20
i386                  randconfig-015-20260418    gcc-14
i386                  randconfig-016-20260418    clang-20
i386                  randconfig-017-20260418    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260418    gcc-15.2.0
loongarch             randconfig-002-20260418    gcc-15.2.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260418    gcc-11.5.0
nios2                 randconfig-002-20260418    gcc-11.5.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260418    gcc-15.2.0
parisc                randconfig-002-20260418    gcc-9.5.0
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260418    clang-23
powerpc               randconfig-002-20260418    gcc-12.5.0
powerpc                         wii_defconfig    gcc-15.2.0
powerpc64             randconfig-001-20260418    gcc-10.5.0
powerpc64             randconfig-002-20260418    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                               defconfig    clang-23
riscv                 randconfig-001-20260418    clang-23
riscv                 randconfig-002-20260418    clang-23
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                  randconfig-001-20260418    clang-19
s390                  randconfig-002-20260418    gcc-8.5.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260418    gcc-11.5.0
sh                    randconfig-002-20260418    gcc-11.5.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260418    gcc-15.2.0
sparc                 randconfig-002-20260418    gcc-12.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20260418    clang-23
sparc64               randconfig-002-20260418    gcc-10.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                                  defconfig    clang-23
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260418    gcc-12
um                    randconfig-002-20260418    gcc-12
um                           x86_64_defconfig    clang-23
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260418    gcc-14
x86_64      buildonly-randconfig-002-20260418    gcc-14
x86_64      buildonly-randconfig-003-20260418    gcc-14
x86_64      buildonly-randconfig-004-20260418    gcc-14
x86_64      buildonly-randconfig-005-20260418    clang-20
x86_64      buildonly-randconfig-006-20260418    gcc-14
x86_64                              defconfig    gcc-14
x86_64                randconfig-001-20260418    clang-20
x86_64                randconfig-002-20260418    clang-20
x86_64                randconfig-003-20260418    clang-20
x86_64                randconfig-004-20260418    gcc-14
x86_64                randconfig-005-20260418    clang-20
x86_64                randconfig-006-20260418    clang-20
x86_64                randconfig-011-20260418    gcc-14
x86_64                randconfig-012-20260418    clang-20
x86_64                randconfig-013-20260418    clang-20
x86_64                randconfig-014-20260418    clang-20
x86_64                randconfig-015-20260418    gcc-14
x86_64                randconfig-016-20260418    clang-20
x86_64                randconfig-071-20260418    clang-20
x86_64                randconfig-072-20260418    gcc-14
x86_64                randconfig-073-20260418    clang-20
x86_64                randconfig-074-20260418    clang-20
x86_64                randconfig-075-20260418    clang-20
x86_64                randconfig-076-20260418    clang-20
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.2.0
xtensa                randconfig-001-20260418    gcc-12.5.0
xtensa                randconfig-002-20260418    gcc-13.4.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
