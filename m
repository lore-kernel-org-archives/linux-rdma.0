Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539243EBF06
	for <linux-rdma@vger.kernel.org>; Mon,  2 Feb 2026 02:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769998654; cv=none; b=Lqx14hufb5MAsKAZTPxi7kd7AhnqMbd5DwC6Lpt/IgIP6LcE9nVm3KDw2ZiXF5D9g3j8x7LKV+X1s7CWOLAhMl09hylRpJSPTOawH+EMB6AbXM5DsV1Lo63S8fQi84nNeM9P7XAC28rgmUfdAEniml9baNrmM6hNiHEiEEoudf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769998654; c=relaxed/simple;
	bh=7yHyIPajCcbV/9KEm0o7fqoG1mLiTzWzSUIdeJmintM=;
	h=Date:From:To:Cc:Subject:Message-ID; b=cBzuKzEdygxkdfB+N1vWVVsAiHacmJgvCCnEitnJYfywt1g99zXPTF2afz5NPP0ZyYHPJIr+CC0cqbh3BWLEXbYINBSt7dJOA9+WzGeUgfpBo3NojaL0K0oOjNe8/v+HaK7EjLRH0m1cO340Rrgh3uPXWQsyFm/LNzCl+rwWmZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MDIZcxa6; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MDIZcxa6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769998652; x=1801534652;
  h=date:from:to:cc:subject:message-id;
  bh=7yHyIPajCcbV/9KEm0o7fqoG1mLiTzWzSUIdeJmintM=;
  b=MDIZcxa6gQYorR4VLhRApzee3rYSeXci47Lb88yAKv7HYB0UV4ktbw8W
   EbqQvblJ+8DxiV8BuOlZVrcuvQiisz+QNx0/qgCyuknOefRap/qtsYij7
   mXBJk5DpQOzG4hi2KX1g1KpDWHkeuyBYQvUaPX9O+O5u3hjvAi8pW2ozC
   0GTIw9nhSFBCr6Il+lLHqemf0n225fk0kVtpZwdS9hF65PoBhEaUBV+2f
   c3F6eIBXgMtRqBHiLxtXygEcI3KdQQ8aEuddwMKGP9YR5+ks6zWFVyNAH
   quuEJQ+p0fiJc9mPKfLTviJHRR3gkIpejIjCcq14pImERm/nErcXhkMBv
   w==;
X-CSE-ConnectionGUID: hqd+Lqm8TPq2Svjywms9Ww==
X-CSE-MsgGUID: qahV2M6wSGO+0WfA6Z9Oxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11689"; a="71321090"
X-IronPort-AV: E=Sophos;i="6.21,267,1763452800"; 
   d="scan'208";a="71321090"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2026 18:17:32 -0800
X-CSE-ConnectionGUID: odfxxC56RpyjvTFAqEBi/g==
X-CSE-MsgGUID: DqqcvW/7REuuptOd/UuloQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,267,1763452800"; 
   d="scan'208";a="208925681"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 01 Feb 2026 18:17:20 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vmjV8-00000000fBQ-2cZC;
	Mon, 02 Feb 2026 02:17:18 +0000
Date: Mon, 02 Feb 2026 10:17:17 +0800
From: kernel test robot <lkp@intel.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [rdma:wip/leon-for-next] BUILD SUCCESS
 e5b0cfa32b1c3e7f153373bfdc20ccdd3c342de2
Message-ID: <202602021008.ebpVZCPV-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git wip/leon-for-next
branch HEAD: e5b0cfa32b1c3e7f153373bfdc20ccdd3c342de2  MAINTAINERS: Drop RDMA files from Hyper-V section

elapsed time: 722m

configs tested: 187
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260202    gcc-10.5.0
arc                   randconfig-002-20260202    gcc-14.3.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-22
arm                        mvebu_v5_defconfig    gcc-15.2.0
arm                   randconfig-001-20260202    gcc-13.4.0
arm                   randconfig-002-20260202    gcc-12.5.0
arm                   randconfig-003-20260202    clang-22
arm                   randconfig-004-20260202    gcc-11.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260202    gcc-10.5.0
arm64                 randconfig-002-20260202    gcc-12.5.0
arm64                 randconfig-003-20260202    clang-22
arm64                 randconfig-004-20260202    gcc-12.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260202    gcc-15.2.0
csky                  randconfig-002-20260202    gcc-9.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20260201    clang-22
hexagon               randconfig-001-20260202    clang-22
hexagon               randconfig-002-20260201    clang-22
hexagon               randconfig-002-20260202    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260201    gcc-14
i386        buildonly-randconfig-002-20260201    clang-20
i386        buildonly-randconfig-002-20260202    gcc-14
i386        buildonly-randconfig-003-20260201    gcc-14
i386        buildonly-randconfig-004-20260201    clang-20
i386        buildonly-randconfig-004-20260202    clang-20
i386        buildonly-randconfig-005-20260201    gcc-13
i386        buildonly-randconfig-005-20260202    gcc-12
i386        buildonly-randconfig-006-20260201    clang-20
i386        buildonly-randconfig-006-20260202    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20260201    clang-20
i386                  randconfig-002-20260201    clang-20
i386                  randconfig-003-20260201    clang-20
i386                  randconfig-004-20260201    clang-20
i386                  randconfig-005-20260201    clang-20
i386                  randconfig-006-20260201    clang-20
i386                  randconfig-007-20260201    clang-20
i386                  randconfig-011-20260201    gcc-14
i386                  randconfig-012-20260201    clang-20
i386                  randconfig-013-20260201    clang-20
i386                  randconfig-014-20260201    clang-20
i386                  randconfig-015-20260201    gcc-14
i386                  randconfig-016-20260201    gcc-14
i386                  randconfig-017-20260201    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260201    clang-22
loongarch             randconfig-001-20260202    gcc-12.5.0
loongarch             randconfig-002-20260201    gcc-15.2.0
loongarch             randconfig-002-20260202    clang-19
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
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
nios2                 randconfig-001-20260201    gcc-10.5.0
nios2                 randconfig-001-20260202    gcc-9.5.0
nios2                 randconfig-002-20260201    gcc-9.5.0
nios2                 randconfig-002-20260202    gcc-8.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
openrisc                       virt_defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260201    gcc-14.3.0
parisc                randconfig-001-20260202    gcc-8.5.0
parisc                randconfig-002-20260201    gcc-14.3.0
parisc                randconfig-002-20260202    gcc-8.5.0
parisc64                            defconfig    gcc-15.2.0
powerpc                     akebono_defconfig    clang-22
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260201    gcc-12.5.0
powerpc               randconfig-001-20260202    gcc-14.3.0
powerpc               randconfig-002-20260201    gcc-11.5.0
powerpc               randconfig-002-20260202    clang-22
powerpc64             randconfig-001-20260201    gcc-10.5.0
powerpc64             randconfig-001-20260202    gcc-12.5.0
powerpc64             randconfig-002-20260201    gcc-8.5.0
powerpc64             randconfig-002-20260202    gcc-11.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                    nommu_k210_defconfig    clang-22
riscv                 randconfig-001-20260202    gcc-14.3.0
riscv                 randconfig-002-20260202    gcc-13.4.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-22
s390                  randconfig-001-20260202    clang-22
s390                  randconfig-002-20260202    clang-22
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260202    gcc-15.2.0
sh                    randconfig-002-20260202    gcc-15.2.0
sh                   rts7751r2dplus_defconfig    gcc-15.2.0
sh                           se7751_defconfig    gcc-15.2.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260201    gcc-12.5.0
sparc                 randconfig-002-20260201    gcc-8.5.0
sparc64                          alldefconfig    gcc-15.2.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20260201    clang-22
sparc64               randconfig-002-20260201    clang-20
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260201    clang-22
um                    randconfig-002-20260201    clang-22
um                           x86_64_defconfig    clang-22
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260202    gcc-14
x86_64      buildonly-randconfig-002-20260201    clang-20
x86_64      buildonly-randconfig-002-20260202    clang-20
x86_64      buildonly-randconfig-003-20260201    clang-20
x86_64      buildonly-randconfig-003-20260202    gcc-14
x86_64      buildonly-randconfig-004-20260201    gcc-14
x86_64      buildonly-randconfig-004-20260202    gcc-14
x86_64      buildonly-randconfig-005-20260202    clang-20
x86_64      buildonly-randconfig-006-20260202    clang-20
x86_64                              defconfig    gcc-14
x86_64                randconfig-001-20260201    clang-20
x86_64                randconfig-002-20260201    gcc-14
x86_64                randconfig-003-20260201    gcc-14
x86_64                randconfig-004-20260201    gcc-14
x86_64                randconfig-005-20260201    gcc-14
x86_64                randconfig-006-20260201    clang-20
x86_64                randconfig-011-20260202    gcc-14
x86_64                randconfig-012-20260202    clang-20
x86_64                randconfig-013-20260202    clang-20
x86_64                randconfig-014-20260202    gcc-12
x86_64                randconfig-015-20260202    gcc-14
x86_64                randconfig-016-20260202    gcc-14
x86_64                randconfig-071-20260202    gcc-14
x86_64                randconfig-072-20260202    gcc-14
x86_64                randconfig-073-20260202    clang-20
x86_64                randconfig-074-20260202    clang-20
x86_64                randconfig-075-20260202    gcc-12
x86_64                randconfig-076-20260202    clang-20
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                  nommu_kc705_defconfig    gcc-15.2.0
xtensa                randconfig-001-20260201    gcc-15.2.0
xtensa                randconfig-002-20260201    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
