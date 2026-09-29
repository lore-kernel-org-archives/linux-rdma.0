Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE88544897
	for <linux-rdma@vger.kernel.org>; Tue, 29 Sep 2026 17:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790703902; cv=none; b=BbLIA+KArrB0jCzlkWRxpAvkNICRBkIZboSesOwZixQR52iytxPaxr4qnGdUS3JpucIisebnT8VKaGjVaBbHZYL4+KpVyaIwh/GXG/5vrDesibdMvFag2wpI8RFd7f3KK/vp36J5y+bNR1oT3ngkipEuIPwY7dZvs+VqB72RDvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790703902; c=relaxed/simple;
	bh=XI1SxwEVoMbdZ00yuMB2l5Kg9jEMqUySRc8tfCvX0fY=;
	h=Date:From:To:Cc:Subject:Message-ID; b=UwJIyWY0zr3aA/cCq0hWqd/EnZjwL7flU/7V4fp1aI7fvNBmg07mcN/kd7dtCXAlNfqXE9IvOLqCP3zjgV++rJzTnZvzy1/ejuhxCX5pqavxM3kXIQO+BNWifU9dyweNSxhHB0NEW8v5zZ6KPKXIkI9Veg6ShXJ+DI9PHHtVrtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UVmh1Hke; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UVmh1Hke"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790703900; x=1822239900;
  h=date:from:to:cc:subject:message-id;
  bh=XI1SxwEVoMbdZ00yuMB2l5Kg9jEMqUySRc8tfCvX0fY=;
  b=UVmh1HkeciP+O1s49+zP3iBaXGd9KhCTbr9v5ecB5Lw7fm1C32f3hnvi
   uJyuaxPxpkCmZBgdKDj1aAMRxyX01GDU9yJBN95Wss7v0UcCp6+BE+azS
   FEzr55vroRTNxKfkc+R9V/4IdEd7rhgiRJB+r+EVqIh0dsVmkjEkdI36o
   qx1uZTTu6ybeuoDmU3xUZNsWstAEYN+nqv9/znEAjVm4VGujsiRUcvNWi
   GfMgpv8Gw+ZzpeMYTidjUELT50G2t0DU4Nb/aM6SbXOB/JSvc4fx88yR5
   rzEk4F0MBfX3ojCT9kTOCtoTh+nRhcegem0Rt8GZpUhcK+AcIEVfbFDQm
   A==;
X-CSE-ConnectionGUID: sQpDYwsETuCLtKDhV6SItQ==
X-CSE-MsgGUID: v00DppbwR6mU1knzwM3eQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="116960660"
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="116960660"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2026 10:44:57 -0700
X-CSE-ConnectionGUID: X5W0EQ6VThe8KQvr3AneDg==
X-CSE-MsgGUID: HRbaa/heRYq0XrHsgOzUWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="274981620"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 29 Sep 2026 10:44:55 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xBbsq-00000000PZI-01QV;
	Tue, 29 Sep 2026 17:44:52 +0000
Date: Wed, 30 Sep 2026 01:44:49 +0800
From: kernel test robot <lkp@intel.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [rdma:for-next] BUILD SUCCESS
 952f18e04fa9790e347e09263c25318afe723d86
Message-ID: <202609300145.Rk5M9qV8-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git for-next
branch HEAD: 952f18e04fa9790e347e09263c25318afe723d86  RDMA/irdma: Free IRQ when CEQ vector mapping fails

elapsed time: 945m

configs tested: 290
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2107-20260929    gcc-15.2.0 cocci
alpha                randconfig-r2200-20260929    gcc-11.5.0 smatch
alpha                randconfig-r2307-20260928    gcc-15.2.0 sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20260929    clang-17
arc                   randconfig-1001-20260929    clang-17
arc                  randconfig-r2107-20260928    gcc-9.5.0  cocci
arc                  randconfig-r2303-20260929    gcc-8.5.0  sparse
arc                            tb10x_defconfig    gcc-16.1.0
arc                     vdk_hs38_smp_defconfig    gcc-16.1.0
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                          assabet_defconfig    gcc-16.1.0
arm                          at91_dt_defconfig    gcc-16.1.0
arm                         clps711x_defconfig    gcc-16.1.0
arm                                  defconfig    gcc-16.1.0
arm                       footbridge_defconfig    gcc-16.1.0
arm                              mxs_defconfig    gcc-16.1.0
arm                          orion5x_defconfig    gcc-16.1.0
arm                   randconfig-1000-20260929    clang-17
arm                   randconfig-1001-20260929    clang-17
arm                   randconfig-1002-20260929    clang-17
arm                   randconfig-1003-20260929    clang-17
arm                  randconfig-r2103-20260928    clang-24   cocci
arm                  randconfig-r2202-20260928    gcc-8.5.0  smatch
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260929    clang-24
arm64                 randconfig-1001-20260929    clang-24
arm64                 randconfig-1002-20260929    clang-24
arm64                 randconfig-1003-20260929    clang-24
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260929    clang-24
csky                  randconfig-1001-20260929    clang-24
csky                 randconfig-r2200-20260928    gcc-16.1.0 smatch
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20260929    gcc-8.5.0
hexagon               randconfig-1001-20260929    gcc-8.5.0
hexagon              randconfig-r2102-20260928    clang-24   cocci
hexagon              randconfig-r2104-20260928    gcc-9.5.0  cocci
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20260929    clang-22
i386        buildonly-randconfig-1001-20260929    clang-22
i386        buildonly-randconfig-1002-20260929    clang-22
i386        buildonly-randconfig-1003-20260929    clang-22
i386        buildonly-randconfig-1004-20260929    clang-22
i386        buildonly-randconfig-1005-20260929    clang-22
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20260929    gcc-13
i386                  randconfig-1001-20260929    gcc-13
i386                  randconfig-1002-20260929    gcc-13
i386                  randconfig-1003-20260929    gcc-13
i386                  randconfig-1004-20260929    gcc-13
i386                  randconfig-1005-20260929    gcc-13
i386                  randconfig-1006-20260929    gcc-13
i386                  randconfig-1007-20260929    gcc-14
i386                  randconfig-1008-20260929    gcc-14
i386                  randconfig-1009-20260929    gcc-14
i386                  randconfig-1010-20260929    gcc-14
i386                  randconfig-1011-20260929    gcc-14
i386                  randconfig-1012-20260929    gcc-14
i386                  randconfig-1013-20260929    gcc-14
i386                  randconfig-2100-20260928    gcc-14     cocci
i386                  randconfig-2100-20260929    clang-22   cocci
i386                  randconfig-2101-20260928    gcc-14     cocci
i386                  randconfig-2101-20260929    clang-22   cocci
i386                  randconfig-2102-20260928    gcc-14     cocci
i386                  randconfig-2102-20260929    clang-22   cocci
i386                  randconfig-2103-20260928    gcc-14     cocci
i386                  randconfig-2103-20260929    clang-22   cocci
i386                  randconfig-2200-20260928    clang-22   smatch
i386                  randconfig-2200-20260929    gcc-14     smatch
i386                  randconfig-2300-20260928    clang-22   sparse
i386                  randconfig-2301-20260928    clang-22   sparse
i386                  randconfig-2302-20260928    clang-22   sparse
i386                 randconfig-r2300-20260928    gcc-12.5.0 sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260929    gcc-8.5.0
loongarch             randconfig-1001-20260929    gcc-8.5.0
loongarch            randconfig-r2304-20260928    gcc-12.5.0 sparse
loongarch            randconfig-r2306-20260928    gcc-15.2.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                          amcore_defconfig    gcc-16.1.0
m68k                        bvme6000_defconfig    gcc-16.1.0
m68k                                 defconfig    clang-24
m68k                 randconfig-r2105-20260928    gcc-9.5.0  cocci
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r2302-20260928    gcc-12.5.0 sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                             gpr_defconfig    gcc-16.1.0
mips                            ip30_defconfig    gcc-16.1.0
mips                       loongson3_defconfig    gcc-16.1.0
mips                       malta_kvm_defconfig    gcc-16.1.0
mips                 randconfig-r2300-20260929    gcc-8.5.0  sparse
mips                 randconfig-r2308-20260929    gcc-11.5.0 sparse
nios2                          10m50_defconfig    gcc-16.1.0
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20260929    gcc-8.5.0
nios2                 randconfig-1001-20260929    gcc-8.5.0
nios2                randconfig-r2308-20260928    gcc-15.2.0 sparse
openrisc                          alldefconfig    gcc-16.1.0
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260929    gcc-8.5.0
parisc                randconfig-1001-20260929    gcc-8.5.0
parisc               randconfig-r2309-20260929    gcc-11.5.0 sparse
parisc64                             defconfig    clang-24
powerpc                      akebono_defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                     gamecube_defconfig    gcc-16.1.0
powerpc                         icon_defconfig    gcc-16.1.0
powerpc                      ksi8560_defconfig    gcc-16.1.0
powerpc                    motionpro_defconfig    gcc-16.1.0
powerpc                  mpc837x_rdb_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20260929    gcc-8.5.0
powerpc               randconfig-1001-20260929    gcc-8.5.0
powerpc              randconfig-r2201-20260928    gcc-8.5.0  smatch
powerpc              randconfig-r2202-20260929    clang-24   smatch
powerpc64             randconfig-1000-20260929    gcc-8.5.0
powerpc64             randconfig-1001-20260929    gcc-8.5.0
powerpc64            randconfig-r2101-20260928    clang-24   cocci
powerpc64            randconfig-r2104-20260929    gcc-15.2.0 cocci
powerpc64            randconfig-r2106-20260929    gcc-15.2.0 cocci
powerpc64            randconfig-r2307-20260929    gcc-11.5.0 sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20260929    clang-24
riscv                 randconfig-1001-20260929    clang-24
riscv                 randconfig-2000-20260928    gcc-8.5.0
riscv                 randconfig-2000-20260929    gcc-11.5.0
riscv                 randconfig-2001-20260928    gcc-8.5.0
riscv                 randconfig-2001-20260929    gcc-11.5.0
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20260929    clang-24
s390                  randconfig-1001-20260929    clang-24
s390                  randconfig-2000-20260928    gcc-8.5.0
s390                  randconfig-2000-20260929    gcc-11.5.0
s390                  randconfig-2001-20260928    gcc-8.5.0
s390                  randconfig-2001-20260929    gcc-11.5.0
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                           kfr2r09_defconfig    gcc-16.1.0
sh                    randconfig-1000-20260929    clang-24
sh                    randconfig-1001-20260929    clang-24
sh                    randconfig-2000-20260928    gcc-8.5.0
sh                    randconfig-2000-20260929    gcc-11.5.0
sh                    randconfig-2001-20260928    gcc-8.5.0
sh                    randconfig-2001-20260929    gcc-11.5.0
sh                   randconfig-r2100-20260928    clang-24   cocci
sh                   randconfig-r2106-20260928    gcc-9.5.0  cocci
sh                   randconfig-r2201-20260929    gcc-16.1.0 smatch
sh                   randconfig-r2303-20260928    gcc-12.5.0 sparse
sh                   randconfig-r2305-20260929    gcc-8.5.0  sparse
sh                            se7343_defconfig    gcc-16.1.0
sh                            se7705_defconfig    gcc-16.1.0
sh                            se7721_defconfig    gcc-16.1.0
sh                            se7722_defconfig    gcc-16.1.0
sh                    secureedge5410_defconfig    gcc-16.1.0
sh                         sh7785lcr_defconfig    gcc-16.1.0
sh                              shx3_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260929    gcc-14
sparc                 randconfig-1001-20260929    gcc-14
sparc                 randconfig-2000-20260928    gcc-13.4.0
sparc                 randconfig-2000-20260929    gcc-12.5.0
sparc                 randconfig-2001-20260928    gcc-13.4.0
sparc                 randconfig-2001-20260929    gcc-12.5.0
sparc                randconfig-r2309-20260928    gcc-15.2.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20260929    gcc-14
sparc64               randconfig-1001-20260929    gcc-14
sparc64               randconfig-2000-20260928    gcc-13.4.0
sparc64               randconfig-2000-20260929    gcc-12.5.0
sparc64               randconfig-2001-20260928    gcc-13.4.0
sparc64               randconfig-2001-20260929    gcc-12.5.0
sparc64              randconfig-r2305-20260928    gcc-12.5.0 sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260929    gcc-14
um                    randconfig-1001-20260929    gcc-14
um                    randconfig-2000-20260928    gcc-13.4.0
um                    randconfig-2000-20260929    gcc-12.5.0
um                    randconfig-2001-20260928    gcc-13.4.0
um                    randconfig-2001-20260929    gcc-12.5.0
um                   randconfig-r2306-20260929    gcc-11.5.0 sparse
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20260929    clang-22
x86_64      buildonly-randconfig-1001-20260929    clang-22
x86_64      buildonly-randconfig-1002-20260929    clang-22
x86_64      buildonly-randconfig-1003-20260929    clang-22
x86_64      buildonly-randconfig-1004-20260929    clang-22
x86_64      buildonly-randconfig-1005-20260929    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20260929    clang-22
x86_64                randconfig-1001-20260929    clang-22
x86_64                randconfig-1002-20260929    clang-22
x86_64                randconfig-1003-20260929    clang-22
x86_64                randconfig-1004-20260929    clang-22
x86_64                randconfig-1005-20260929    clang-22
x86_64                randconfig-1006-20260929    gcc-13
x86_64                randconfig-1007-20260929    gcc-13
x86_64                randconfig-1008-20260929    gcc-13
x86_64                randconfig-1009-20260929    gcc-13
x86_64                randconfig-1010-20260929    gcc-13
x86_64                randconfig-1011-20260929    gcc-13
x86_64                randconfig-1012-20260929    clang-22
x86_64                randconfig-1013-20260929    clang-22
x86_64                randconfig-1014-20260929    clang-22
x86_64                randconfig-1015-20260929    clang-22
x86_64                randconfig-1016-20260929    clang-22
x86_64                randconfig-1017-20260929    clang-22
x86_64                randconfig-2100-20260928    gcc-12     cocci
x86_64                randconfig-2101-20260928    gcc-12     cocci
x86_64                randconfig-2102-20260928    gcc-12     cocci
x86_64                randconfig-2103-20260928    gcc-12     cocci
x86_64                randconfig-2200-20260928    gcc-14     smatch
x86_64                randconfig-2200-20260929    clang-22   smatch
x86_64                randconfig-2300-20260928    clang-22   sparse
x86_64                randconfig-2301-20260928    clang-22   sparse
x86_64                randconfig-2302-20260928    clang-22   sparse
x86_64               randconfig-r2302-20260929    gcc-8.5.0  sparse
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    clang-22
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                randconfig-1000-20260929    gcc-14
xtensa                randconfig-1001-20260929    gcc-14
xtensa                randconfig-2000-20260928    gcc-13.4.0
xtensa                randconfig-2000-20260929    gcc-12.5.0
xtensa                randconfig-2001-20260928    gcc-13.4.0
xtensa                randconfig-2001-20260929    gcc-12.5.0
xtensa               randconfig-r2105-20260929    gcc-15.2.0 cocci
xtensa               randconfig-r2301-20260928    gcc-12.5.0 sparse
xtensa               randconfig-r2301-20260929    gcc-8.5.0  sparse
xtensa               randconfig-r2304-20260929    gcc-8.5.0  sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
