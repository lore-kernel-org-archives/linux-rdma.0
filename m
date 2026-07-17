Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE55730B50C
	for <linux-rdma@vger.kernel.org>; Fri, 17 Jul 2026 04:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784263851; cv=none; b=S347sNFAOk6EX2ly4QFZRcd2A2fq+iHAnB/Y8JonaIQ0mp/Z0Av9sCEB8DtXFaCmJVQFqpv0Bm9/v7mKPe66q3TTn+VddAKniU7kZgxU8q3YFnsN0WVTbXUNbc8gYXSHdKS3UVhDCGnEM/CB28L6b2xqyNefxmB/CnHoPMhfkqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784263851; c=relaxed/simple;
	bh=hO4kuTKP9y/WI8ztVdjJQ2BgFNWS+j4STo7gzND4p7E=;
	h=Date:From:To:Cc:Subject:Message-ID; b=nU/RU5BQuWTgyX3D3mkq2VzakQMq/nAuz8gJiNcudl4zD9o+XRoTTLorB7RCDjZw5+yK7DwpuM2WN3V/mIU1rsyptfA3+aTPv57fX6DfforWs5PrNo8+xQEmcfxWE3jCFy7dO29vW3H5MuirLGJ2xoTrRt7zo/xQekL7TM2ve3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ad7zQZId; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ad7zQZId"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784263849; x=1815799849;
  h=date:from:to:cc:subject:message-id;
  bh=hO4kuTKP9y/WI8ztVdjJQ2BgFNWS+j4STo7gzND4p7E=;
  b=ad7zQZIdNSk4ABTKqbKdkW6IYBcQTPuQY7Ljb7ayEiRQU/pzasOuNrBN
   KxBTK7iNCk0RnY9h20LqrXXDG2vIvPzzjZ+xqDNUMiqzsjNgziXjHIrOG
   ojGGRhLTvup3ClOISXq/TSgeJOFgHy6VY0BAFu15Xxx/OxdYkSMnZ7Kkn
   t7TCNw/3DwOlLDJ0K29oQtpOOjjqFhd8oTKCpYVDhhK6zo6uDCX4KI1WL
   LkzPdh5esmoOt/oDcoc+LVlgnadOz40YDXOBi5+AgVEAFgElgppREmFTx
   wvqMO84+TkTCtQB1v3GfTyoaP0NkDpdUu7LMEEy6Dj30tTN5EPZCNqIyR
   A==;
X-CSE-ConnectionGUID: eaCW97LbQzWH0PXFr9mFJg==
X-CSE-MsgGUID: m3qNzlmsQFuxSbxzmY1NSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="95533449"
X-IronPort-AV: E=Sophos;i="6.25,168,1779174000"; 
   d="scan'208";a="95533449"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2026 21:50:48 -0700
X-CSE-ConnectionGUID: svChW70FRg+p7gUSjMZ52A==
X-CSE-MsgGUID: zy/FbZOCSNqQ4yJ6VKn3NA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,168,1779174000"; 
   d="scan'208";a="255543394"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 16 Jul 2026 21:50:45 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wkaX5-00000000SQs-0dw0;
	Fri, 17 Jul 2026 04:50:43 +0000
Date: Fri, 17 Jul 2026 12:50:03 +0800
From: kernel test robot <lkp@intel.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [rdma:for-next] BUILD SUCCESS
 e952e079d226209a132110acc1de96a099701292
Message-ID: <202607171248.4lp3uiEu-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git for-next
branch HEAD: e952e079d226209a132110acc1de96a099701292  RDMA/umem: Constify struct dma_buf_attach_ops

elapsed time: 2268m

configs tested: 126
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    gcc-16.1.0
arc                   randconfig-001-20260717    gcc-11.5.0
arc                   randconfig-002-20260717    gcc-11.5.0
arm                               allnoconfig    clang-17
arm                              allyesconfig    gcc-16.1.0
arm                   randconfig-001-20260717    gcc-11.5.0
arm                   randconfig-002-20260717    gcc-11.5.0
arm                   randconfig-003-20260717    gcc-11.5.0
arm                   randconfig-004-20260717    gcc-11.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                 randconfig-001-20260717    gcc-13.4.0
arm64                 randconfig-002-20260717    gcc-13.4.0
arm64                 randconfig-003-20260717    gcc-13.4.0
arm64                 randconfig-004-20260717    gcc-13.4.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                  randconfig-001-20260717    gcc-13.4.0
csky                  randconfig-002-20260717    gcc-13.4.0
hexagon                           allnoconfig    clang-23
hexagon               randconfig-001-20260717    gcc-16.1.0
hexagon               randconfig-002-20260717    gcc-16.1.0
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260717    gcc-14
i386        buildonly-randconfig-002-20260717    gcc-14
i386        buildonly-randconfig-003-20260717    gcc-14
i386        buildonly-randconfig-004-20260717    gcc-14
i386        buildonly-randconfig-005-20260717    gcc-14
i386        buildonly-randconfig-006-20260717    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-20
loongarch                           defconfig    clang-24
loongarch             randconfig-001-20260717    gcc-16.1.0
loongarch             randconfig-002-20260717    gcc-16.1.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    gcc-16.1.0
m68k                        mvme147_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                 randconfig-001-20260717    gcc-16.1.0
nios2                 randconfig-002-20260717    gcc-16.1.0
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260717    gcc-11.5.0
parisc                randconfig-002-20260717    gcc-11.5.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    gcc-16.1.0
powerpc               randconfig-001-20260717    gcc-11.5.0
powerpc               randconfig-002-20260717    gcc-11.5.0
powerpc64             randconfig-001-20260717    gcc-11.5.0
powerpc64             randconfig-002-20260717    gcc-11.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-24
riscv                 randconfig-001-20260717    clang-24
riscv                 randconfig-002-20260717    clang-24
s390                             allmodconfig    clang-24
s390                              allnoconfig    clang-23
s390                              allnoconfig    clang-24
s390                             allyesconfig    gcc-16.1.0
s390                  randconfig-001-20260717    clang-24
s390                  randconfig-002-20260717    clang-24
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260717    clang-24
sh                    randconfig-002-20260717    clang-24
sparc                             allnoconfig    gcc-16.1.0
sparc                 randconfig-001-20260717    gcc-8.5.0
sparc                 randconfig-002-20260717    gcc-8.5.0
sparc64                          allmodconfig    clang-20
sparc64               randconfig-001-20260717    gcc-8.5.0
sparc64               randconfig-002-20260717    gcc-8.5.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                               allyesconfig    gcc-14
um                    randconfig-001-20260717    gcc-8.5.0
um                    randconfig-002-20260717    gcc-8.5.0
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260717    gcc-14
x86_64      buildonly-randconfig-002-20260717    gcc-14
x86_64      buildonly-randconfig-003-20260717    gcc-14
x86_64      buildonly-randconfig-004-20260717    gcc-14
x86_64                randconfig-001-20260717    gcc-14
x86_64                randconfig-002-20260717    gcc-14
x86_64                randconfig-003-20260717    gcc-14
x86_64                randconfig-004-20260717    gcc-14
x86_64                randconfig-005-20260717    gcc-14
x86_64                randconfig-006-20260717    gcc-14
x86_64                randconfig-011-20260717    gcc-12
x86_64                randconfig-012-20260717    gcc-12
x86_64                randconfig-013-20260717    gcc-12
x86_64                randconfig-014-20260717    gcc-12
x86_64                randconfig-015-20260717    gcc-12
x86_64                randconfig-016-20260717    gcc-12
x86_64                randconfig-071-20260717    clang-22
x86_64                randconfig-072-20260717    clang-22
x86_64                randconfig-073-20260717    clang-22
x86_64                randconfig-074-20260717    clang-22
x86_64                randconfig-075-20260717    clang-22
x86_64                randconfig-076-20260717    clang-22
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    gcc-16.1.0
xtensa                randconfig-001-20260717    gcc-8.5.0
xtensa                randconfig-002-20260717    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
