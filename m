Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9A63DFC7F
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 09:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790155254; cv=none; b=up/MkNzHsgVLHS9DvVLUw/SYM7MyKREt9Hbm0G/m4ZaVbedid7EFORpQeGrLZlbYNZRY79yPJNHPbDAH5IDJaBKajEHBW8lowAlNV31DeNUy7xvbECgWtpu2oxhMQLdJ8tvU2PUkN6NKHuriL5vBFrCmXQ6dF32ZAeiN40Dhgfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790155254; c=relaxed/simple;
	bh=bEJM4jtH7bX4M5zg4KtOCdw8v+EtpwgD+UiOXUoY5ro=;
	h=Date:From:To:Cc:Subject:Message-ID; b=Rgz2Ozfr/scpAvHEMYcvjKmTUjXUi77H7q4CwiRdS8Y/KsCwbE/gu4wKdmCPO7+tHzm7LCxnyu9W+R+8pal2Ra1r9fE9B5hlc8fwAqZAvExAcZ7ZAcO+sDobEa8YxmYdXoXwDaLfLlunnLXwwaQnifIYeXUk8Xd2eyXnFXFrOVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jTfRToHc; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jTfRToHc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790155253; x=1821691253;
  h=date:from:to:cc:subject:message-id;
  bh=bEJM4jtH7bX4M5zg4KtOCdw8v+EtpwgD+UiOXUoY5ro=;
  b=jTfRToHcph2WMtAT1YgDekSTCe7kOzTuekwum3sZsE9EEMS9BUcHNYhq
   TpjXaQykuMC2CvEa71RQKpM1QWpbCSlyaQsjqKn58P9OSV4LMHa8XNA84
   sJFerjX6c9kspX/+ZpbBW0mXSsyJeIHPIG2ct9tgLeYjA78Vwe1qO0QBT
   w3yDbCU7975e2sGUUBdca4E8mbW6iefmPO5Ewae9l4nign9IvMe1SycPl
   pOcriurjRvdDEXZQ9dmtQlJPFeLGxboQgK23KOkGvP+lWeXW0bhxKVWAy
   XrG34Dnauvtcis4K/o6d8zFn3WRn6ordY6jCamV1UX2gq+2TsNKtF4pK9
   w==;
X-CSE-ConnectionGUID: R5ot96oTR5q6nK5F0aeazg==
X-CSE-MsgGUID: 42nOvv91SEGwP2phftKSvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="89748599"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="89748599"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 02:20:52 -0700
X-CSE-ConnectionGUID: tdlIIv5XS9CtN6nDfOw2Zw==
X-CSE-MsgGUID: gVssKOgfQHmCco3o3uDVTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="4804504"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa013.fm.intel.com with ESMTP; 23 Sep 2026 02:20:51 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x9J9j-00000000Gr4-3c7p;
	Wed, 23 Sep 2026 09:20:47 +0000
Date: Wed, 23 Sep 2026 17:20:24 +0800
From: kernel test robot <lkp@intel.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [rdma:for-next] BUILD SUCCESS
 9dcacdc41083cccff74292851bf9fde999e0731a
Message-ID: <202609231721.Ti4lJqWw-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git for-next
branch HEAD: 9dcacdc41083cccff74292851bf9fde999e0731a  RDMA/uverbs: Drop restrack ref on ib_init_ucontext() failure in GET_CONTEXT

elapsed time: 5405m

configs tested: 207
configs skipped: 11

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.1.0
arc                          haps_hs_defconfig    gcc-16.1.0
arc                             hsdk_defconfig    gcc-16.1.0
arc                   randconfig-1000-20260923    clang-24
arc                   randconfig-1001-20260923    clang-24
arc                  randconfig-r1306-20260923    gcc-8.5.0  sparse
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                         multi_v7_defconfig    clang-20
arm                          nhk8815_defconfig    clang-24
arm                   randconfig-1000-20260923    clang-24
arm                   randconfig-1001-20260923    clang-24
arm                   randconfig-1002-20260923    clang-24
arm                   randconfig-1003-20260923    clang-24
arm                          s5pv210_defconfig    gcc-16.1.0
arm                         spear3xx_defconfig    clang-20
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260923    clang-24
arm64                 randconfig-1001-20260923    clang-24
arm64                 randconfig-1002-20260923    clang-24
arm64                 randconfig-1003-20260923    clang-24
arm64                randconfig-r1302-20260923    clang-20   sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260923    clang-24
csky                  randconfig-1001-20260923    clang-24
csky                 randconfig-r1306-20260923    gcc-16.1.0 sparse
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20260923    gcc-8.5.0
hexagon               randconfig-1001-20260923    gcc-8.5.0
hexagon              randconfig-r1303-20260923    clang-20   sparse
i386                               allnoconfig    gcc-16.1.0
i386        buildonly-randconfig-1000-20260923    gcc-14
i386        buildonly-randconfig-1001-20260923    gcc-14
i386        buildonly-randconfig-1002-20260923    gcc-14
i386        buildonly-randconfig-1003-20260923    gcc-14
i386        buildonly-randconfig-1004-20260923    gcc-14
i386        buildonly-randconfig-1005-20260923    gcc-14
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20260923    clang-22
i386                  randconfig-1001-20260923    clang-22
i386                  randconfig-1002-20260923    clang-22
i386                  randconfig-1003-20260923    clang-22
i386                  randconfig-1004-20260923    clang-22
i386                  randconfig-1005-20260923    clang-22
i386                  randconfig-1006-20260923    clang-22
i386                  randconfig-1007-20260923    gcc-14
i386                  randconfig-1008-20260923    gcc-14
i386                  randconfig-1009-20260923    gcc-14
i386                  randconfig-1010-20260923    gcc-14
i386                  randconfig-1011-20260923    gcc-14
i386                  randconfig-1012-20260923    gcc-14
i386                  randconfig-1013-20260923    gcc-14
i386                  randconfig-1300-20260923    gcc-12     sparse
i386                  randconfig-1301-20260923    gcc-12     sparse
i386                  randconfig-1302-20260923    gcc-12     sparse
i386                 randconfig-r1304-20260923    clang-20   sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260923    gcc-8.5.0
loongarch             randconfig-1001-20260923    gcc-8.5.0
loongarch            randconfig-r1308-20260923    gcc-8.5.0  sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
m68k                        m5475evb_defconfig    clang-20
m68k                 randconfig-r1307-20260923    gcc-8.5.0  sparse
microblaze                        alldefconfig    clang-24
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r1309-20260923    gcc-8.5.0  sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                         bcm47xx_defconfig    clang-24
mips                        bmips_be_defconfig    gcc-16.1.0
mips                         qi_lb60_defconfig    clang-24
mips                    sb1250_swarm_defconfig    clang-24
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20260923    gcc-8.5.0
nios2                 randconfig-1001-20260923    gcc-8.5.0
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r1305-20260923    clang-20   sparse
openrisc             randconfig-r1307-20260923    gcc-16.1.0 sparse
parisc                            alldefconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260923    clang-22
parisc                randconfig-1001-20260923    clang-22
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                      mpc83xx_defconfig    clang-24
powerpc                      rainier_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20260923    clang-22
powerpc               randconfig-1001-20260923    clang-22
powerpc                     socrates_defconfig    clang-24
powerpc                   storcenter_defconfig    clang-20
powerpc                      tqm8540_defconfig    gcc-16.1.0
powerpc                       tqm8xx_defconfig    clang-20
powerpc64             randconfig-1000-20260923    clang-22
powerpc64             randconfig-1001-20260923    clang-22
powerpc64            randconfig-r1308-20260923    gcc-16.1.0 sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20260923    gcc-16.1.0
riscv                 randconfig-1001-20260923    gcc-16.1.0
riscv                randconfig-r1309-20260923    gcc-16.1.0 sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20260923    gcc-16.1.0
s390                  randconfig-1001-20260923    gcc-16.1.0
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                          ecovec24_defconfig    clang-24
sh                           r7785rp_defconfig    clang-20
sh                    randconfig-1000-20260923    gcc-16.1.0
sh                    randconfig-1001-20260923    gcc-16.1.0
sh                            se7343_defconfig    clang-20
sparc                             alldefconfig    clang-20
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260923    clang-24
sparc                 randconfig-1001-20260923    clang-24
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20260923    clang-24
sparc64               randconfig-1001-20260923    clang-24
sparc64              randconfig-r1301-20260923    clang-20   sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260923    clang-24
um                    randconfig-1001-20260923    clang-24
um                            x86_64_defconfig    gcc-14
x86_64                             allnoconfig    clang-24
x86_64      buildonly-randconfig-1000-20260923    gcc-14
x86_64      buildonly-randconfig-1001-20260923    gcc-14
x86_64      buildonly-randconfig-1002-20260923    gcc-14
x86_64      buildonly-randconfig-1003-20260923    gcc-14
x86_64      buildonly-randconfig-1004-20260923    gcc-14
x86_64      buildonly-randconfig-1005-20260923    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20260923    gcc-14
x86_64                randconfig-1001-20260923    gcc-14
x86_64                randconfig-1002-20260923    gcc-14
x86_64                randconfig-1003-20260923    gcc-14
x86_64                randconfig-1004-20260923    gcc-14
x86_64                randconfig-1005-20260923    gcc-14
x86_64                randconfig-1006-20260923    gcc-13
x86_64                randconfig-1007-20260923    gcc-13
x86_64                randconfig-1008-20260923    gcc-13
x86_64                randconfig-1009-20260923    gcc-13
x86_64                randconfig-1010-20260923    gcc-13
x86_64                randconfig-1011-20260923    gcc-13
x86_64                randconfig-1012-20260923    gcc-14
x86_64                randconfig-1013-20260923    gcc-14
x86_64                randconfig-1014-20260923    gcc-14
x86_64                randconfig-1015-20260923    gcc-14
x86_64                randconfig-1016-20260923    gcc-14
x86_64                randconfig-1017-20260923    gcc-14
x86_64                randconfig-1300-20260923    gcc-12     sparse
x86_64                randconfig-1301-20260923    gcc-12     sparse
x86_64                randconfig-1302-20260923    gcc-12     sparse
x86_64               randconfig-r1300-20260923    clang-20   sparse
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                randconfig-1000-20260923    clang-24
xtensa                randconfig-1001-20260923    clang-24
xtensa                     xip_kc705_defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
