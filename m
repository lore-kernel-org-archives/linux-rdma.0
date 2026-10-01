Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8351363097
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 00:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790814701; cv=none; b=PWUzlUFYG6iZU9ZLuSSHOAfyySagf80g1+WWfYZ+YRHJVapmMAwLyFwSctWlo4sUExYOhp/KpOwtiRc/9rrM81lLv8CqGMeVywB5xIw8w5tYbyh6vaXP7wUWFLTBs2Yw5XgMiJ10LxPqlqeX/iZzP6q//vUqVXo9x15WxsWCe8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790814701; c=relaxed/simple;
	bh=l5dEw++oNjkZa5gLyHy+lbytB25puGgn9VHW63tnRqA=;
	h=Date:From:To:Cc:Subject:Message-ID; b=sRts0JdayDiGRibVaBxhTsybZ3FqpOrLV0mgRWdJ7PkFSshIPUpmlhfzJmMoR99rSgn+VU/m0pX8S8l1YiZ589eOHkZytOlI0hHDl9qqK0d8aIs7eobIDDm3TUCeZR3hhG8pYcXG/QXs3b0FNszl0a9CbbhhwrvV3pN/wMkttpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wb2ksS2i; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wb2ksS2i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790814693; x=1822350693;
  h=date:from:to:cc:subject:message-id;
  bh=l5dEw++oNjkZa5gLyHy+lbytB25puGgn9VHW63tnRqA=;
  b=Wb2ksS2iVF4PIimovLpQntQGPcYtjOYMnjjsDtbvCEhD9RRxf0bNcL8I
   yEd05I3OS/6OfjKs75CbMJmI5K0bpTRquq5DpbUPt4GoQ9kBdqIHO+doM
   9+wXjbyevY3OYaCqvuv7Dv3qyNBGL5IJc+6SCM6o9251JskFlLrTzldLR
   wUc9qs1wnSNwXzBrdaHA3Lqy3nXYy792RpZUBg9cVYV6MpHAiDa5atO9u
   tbQWNaVOJWDpyCtnVtBSOwAjfj0UV11U8gyP2pSOmVshUBWpcuS1GNjIL
   q6CYN4Ln/jorLyPaYVe2eGuoelTb+zdDbkk28umiwkRP5sToiH4aBjJZ5
   Q==;
X-CSE-ConnectionGUID: Ftwe/fVoRPKOudGxHY0ejQ==
X-CSE-MsgGUID: Cx9o8BRHTh6hBORGihP1Yg==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="90621168"
X-IronPort-AV: E=Sophos;i="6.27,133,1787036400"; 
   d="scan'208";a="90621168"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 17:31:30 -0700
X-CSE-ConnectionGUID: kyiS3SL9RrWj7HZvFZuOhg==
X-CSE-MsgGUID: QkAIvGETTBCdtb8ELKtnHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,133,1787036400"; 
   d="scan'208";a="274951519"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 30 Sep 2026 17:31:28 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xC4hq-00000000RKv-1JXE;
	Thu, 01 Oct 2026 00:31:26 +0000
Date: Thu, 01 Oct 2026 08:30:54 +0800
From: kernel test robot <lkp@intel.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [rdma:wip:leon-for-next] BUILD SUCCESS
 1c5335a6902639596a795705349da7f76027e103
Message-ID: <202610010850.fBN9zmFk-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git wip/leon-for-next
branch HEAD: 1c5335a6902639596a795705349da7f76027e103  RDMA/cxgb4: Do not allow userspace to write the status page

elapsed time: 1608m

configs tested: 343
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2300-20260930    gcc-8.5.0  sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20260930    gcc-11.5.0
arc                   randconfig-1000-20261001    gcc-13.4.0
arc                   randconfig-1001-20260930    gcc-11.5.0
arc                   randconfig-1001-20261001    gcc-13.4.0
arc                  randconfig-r2104-20260930    gcc-12     cocci
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                       integrator_defconfig    clang-24
arm                             qcom_defconfig    clang-24
arm                   randconfig-1000-20260930    gcc-11.5.0
arm                   randconfig-1000-20261001    gcc-13.4.0
arm                   randconfig-1001-20260930    gcc-11.5.0
arm                   randconfig-1001-20261001    gcc-13.4.0
arm                   randconfig-1002-20260930    gcc-11.5.0
arm                   randconfig-1002-20261001    gcc-13.4.0
arm                   randconfig-1003-20260930    gcc-11.5.0
arm                   randconfig-1003-20261001    gcc-13.4.0
arm                  randconfig-r2104-20260930    gcc-10.5.0 cocci
arm                              rpc_defconfig    gcc-16.1.0
arm                        spear13xx_defconfig    gcc-16.1.0
arm                            spitz_defconfig    gcc-16.1.0
arm                        versatile_defconfig    gcc-16.1.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260930    gcc-16.1.0
arm64                 randconfig-1000-20261001    gcc-15.2.0
arm64                 randconfig-1001-20260930    gcc-16.1.0
arm64                 randconfig-1001-20261001    gcc-15.2.0
arm64                 randconfig-1002-20260930    gcc-16.1.0
arm64                 randconfig-1002-20261001    gcc-15.2.0
arm64                 randconfig-1003-20260930    gcc-16.1.0
arm64                 randconfig-1003-20261001    gcc-15.2.0
arm64                randconfig-r2201-20260930    gcc-8.5.0  smatch
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260930    gcc-16.1.0
csky                  randconfig-1000-20261001    gcc-15.2.0
csky                  randconfig-1001-20260930    gcc-16.1.0
csky                  randconfig-1001-20261001    gcc-15.2.0
csky                 randconfig-r2308-20260930    gcc-13.4.0 sparse
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20260930    clang-24
hexagon               randconfig-1000-20261001    clang-24
hexagon               randconfig-1001-20260930    clang-24
hexagon               randconfig-1001-20261001    clang-24
hexagon              randconfig-r2105-20260930    clang-17   cocci
hexagon              randconfig-r2304-20260930    gcc-8.5.0  sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20260930    gcc-14
i386        buildonly-randconfig-1000-20261001    gcc-13
i386        buildonly-randconfig-1001-20260930    gcc-14
i386        buildonly-randconfig-1001-20261001    gcc-13
i386        buildonly-randconfig-1002-20260930    gcc-14
i386        buildonly-randconfig-1002-20261001    gcc-13
i386        buildonly-randconfig-1003-20260930    gcc-14
i386        buildonly-randconfig-1003-20261001    gcc-13
i386        buildonly-randconfig-1004-20260930    gcc-14
i386        buildonly-randconfig-1004-20261001    gcc-13
i386        buildonly-randconfig-1005-20260930    gcc-14
i386        buildonly-randconfig-1005-20261001    gcc-13
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20260930    gcc-14
i386                  randconfig-1001-20260930    gcc-14
i386                  randconfig-1002-20260930    gcc-14
i386                  randconfig-1003-20260930    gcc-14
i386                  randconfig-1004-20260930    gcc-14
i386                  randconfig-1005-20260930    gcc-14
i386                  randconfig-1006-20260930    gcc-14
i386                  randconfig-1007-20260930    clang-22
i386                  randconfig-1007-20261001    clang-22
i386                  randconfig-1008-20260930    clang-22
i386                  randconfig-1008-20261001    clang-22
i386                  randconfig-1009-20260930    clang-22
i386                  randconfig-1009-20261001    clang-22
i386                  randconfig-1010-20260930    clang-22
i386                  randconfig-1010-20261001    clang-22
i386                  randconfig-1011-20260930    clang-22
i386                  randconfig-1011-20261001    clang-22
i386                  randconfig-1012-20260930    clang-22
i386                  randconfig-1012-20261001    clang-22
i386                  randconfig-1013-20260930    clang-22
i386                  randconfig-1013-20261001    clang-22
i386                  randconfig-2100-20260930    clang-22   cocci
i386                  randconfig-2101-20260930    clang-22   cocci
i386                  randconfig-2102-20260930    clang-22   cocci
i386                  randconfig-2103-20260930    clang-22   cocci
i386                  randconfig-2200-20260930    gcc-14     smatch
i386                  randconfig-2300-20260930    gcc-13     sparse
i386                  randconfig-2300-20260930    gcc-14     sparse
i386                  randconfig-2301-20260930    clang-22   sparse
i386                  randconfig-2301-20260930    gcc-13     sparse
i386                  randconfig-2302-20260930    gcc-13     sparse
i386                  randconfig-2302-20260930    gcc-14     sparse
i386                 randconfig-r2105-20260930    gcc-12     cocci
i386                 randconfig-r2304-20260930    gcc-14     sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260930    clang-24
loongarch             randconfig-1000-20261001    clang-24
loongarch             randconfig-1001-20260930    clang-24
loongarch             randconfig-1001-20261001    clang-24
loongarch            randconfig-r2102-20260930    gcc-9.5.0  cocci
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                           atari_defconfig    clang-24
m68k                                 defconfig    clang-24
m68k                             mac_defconfig    gcc-16.1.0
m68k                 randconfig-r2102-20260930    gcc-8.5.0  cocci
m68k                 randconfig-r2202-20260930    gcc-15.2.0 smatch
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r2103-20260930    gcc-9.5.0  cocci
microblaze           randconfig-r2305-20260930    gcc-14.3.0 sparse
microblaze           randconfig-r2305-20260930    gcc-8.5.0  sparse
microblaze           randconfig-r2307-20260930    gcc-10.5.0 sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                           ath79_defconfig    gcc-16.1.0
mips                         bcm63xx_defconfig    clang-24
mips                          cobalt_defconfig    gcc-16.1.0
mips                  decstation_r4k_defconfig    gcc-16.1.0
mips                           malta_defconfig    clang-24
mips                         qi_lb60_defconfig    clang-24
nios2                          10m50_defconfig    gcc-16.1.0
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20260930    clang-24
nios2                 randconfig-1000-20261001    clang-24
nios2                 randconfig-1001-20260930    clang-24
nios2                 randconfig-1001-20261001    clang-24
nios2                randconfig-r2106-20260930    gcc-12     cocci
nios2                randconfig-r2201-20260930    gcc-11.5.0 smatch
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2302-20260930    gcc-8.5.0  sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260930    gcc-8.5.0
parisc                randconfig-1000-20261001    gcc-13.4.0
parisc                randconfig-1001-20260930    gcc-8.5.0
parisc                randconfig-1001-20261001    gcc-13.4.0
parisc               randconfig-r2107-20260930    gcc-12     cocci
parisc               randconfig-r2309-20260930    gcc-15.2.0 sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                        eiger_defconfig    gcc-16.1.0
powerpc                      mpc83xx_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20260930    gcc-8.5.0
powerpc               randconfig-1000-20261001    gcc-13.4.0
powerpc               randconfig-1001-20260930    gcc-8.5.0
powerpc               randconfig-1001-20261001    gcc-13.4.0
powerpc              randconfig-r2101-20260930    gcc-15.2.0 cocci
powerpc              randconfig-r2300-20260930    gcc-8.5.0  sparse
powerpc              randconfig-r2306-20260930    gcc-8.5.0  sparse
powerpc                       tqm8xx_defconfig    gcc-16.1.0
powerpc64             randconfig-1000-20260930    gcc-8.5.0
powerpc64             randconfig-1000-20261001    gcc-13.4.0
powerpc64             randconfig-1001-20260930    gcc-8.5.0
powerpc64             randconfig-1001-20261001    gcc-13.4.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                     nommu_k210_defconfig    clang-24
riscv                 randconfig-1000-20260930    gcc-16.1.0
riscv                 randconfig-1000-20261001    gcc-10.5.0
riscv                 randconfig-1001-20260930    gcc-16.1.0
riscv                 randconfig-1001-20261001    gcc-10.5.0
riscv                 randconfig-2000-20260930    gcc-14.3.0
riscv                 randconfig-2000-20260930    gcc-15.2.0
riscv                 randconfig-2001-20260930    gcc-14.3.0
riscv                 randconfig-2001-20260930    gcc-8.5.0
riscv                randconfig-r2302-20260930    gcc-15.2.0 sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20260930    gcc-16.1.0
s390                  randconfig-1000-20261001    gcc-10.5.0
s390                  randconfig-1001-20260930    gcc-16.1.0
s390                  randconfig-1001-20261001    gcc-10.5.0
s390                  randconfig-2000-20260930    clang-24
s390                  randconfig-2000-20260930    gcc-14.3.0
s390                  randconfig-2001-20260930    gcc-14.3.0
s390                  randconfig-2001-20260930    gcc-8.5.0
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                          ecovec24_defconfig    gcc-16.1.0
sh                         edosk7760_defconfig    clang-24
sh                    randconfig-1000-20260930    gcc-16.1.0
sh                    randconfig-1000-20261001    gcc-10.5.0
sh                    randconfig-1001-20260930    gcc-16.1.0
sh                    randconfig-1001-20261001    gcc-10.5.0
sh                    randconfig-2000-20260930    gcc-14.3.0
sh                    randconfig-2001-20260930    gcc-12.5.0
sh                    randconfig-2001-20260930    gcc-14.3.0
sh                               ul2_defconfig    gcc-16.1.0
sparc                             alldefconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260930    clang-22
sparc                 randconfig-1000-20261001    clang-17
sparc                 randconfig-1001-20260930    clang-22
sparc                 randconfig-1001-20261001    clang-17
sparc                 randconfig-2000-20260930    gcc-10.5.0
sparc                 randconfig-2000-20260930    gcc-14.3.0
sparc                 randconfig-2001-20260930    gcc-10.5.0
sparc                 randconfig-2001-20260930    gcc-8.5.0
sparc                randconfig-r2202-20260930    gcc-15.2.0 smatch
sparc                randconfig-r2301-20260930    gcc-8.5.0  sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20260930    clang-22
sparc64               randconfig-1000-20261001    clang-17
sparc64               randconfig-1001-20260930    clang-22
sparc64               randconfig-1001-20261001    clang-17
sparc64               randconfig-2000-20260930    gcc-10.5.0
sparc64               randconfig-2000-20260930    gcc-8.5.0
sparc64               randconfig-2001-20260930    gcc-10.5.0
sparc64               randconfig-2001-20260930    gcc-9.5.0
sparc64              randconfig-r2303-20260930    gcc-15.2.0 sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260930    clang-22
um                    randconfig-1000-20261001    clang-17
um                    randconfig-1001-20260930    clang-22
um                    randconfig-1001-20261001    clang-17
um                    randconfig-2000-20260930    clang-24
um                    randconfig-2000-20260930    gcc-10.5.0
um                    randconfig-2001-20260930    clang-24
um                    randconfig-2001-20260930    gcc-10.5.0
um                   randconfig-r2100-20260930    gcc-14     cocci
um                   randconfig-r2106-20260930    gcc-14     cocci
um                   randconfig-r2200-20260930    clang-24   smatch
um                   randconfig-r2303-20260930    gcc-8.5.0  sparse
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22   checkkconfigsymbols
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20260930    clang-22
x86_64      buildonly-randconfig-1000-20261001    clang-22
x86_64      buildonly-randconfig-1001-20260930    clang-22
x86_64      buildonly-randconfig-1001-20261001    clang-22
x86_64      buildonly-randconfig-1002-20260930    clang-22
x86_64      buildonly-randconfig-1002-20261001    clang-22
x86_64      buildonly-randconfig-1003-20260930    clang-22
x86_64      buildonly-randconfig-1003-20261001    clang-22
x86_64      buildonly-randconfig-1004-20260930    clang-22
x86_64      buildonly-randconfig-1004-20261001    clang-22
x86_64      buildonly-randconfig-1005-20260930    clang-22
x86_64      buildonly-randconfig-1005-20261001    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20260930    gcc-14
x86_64                randconfig-1001-20260930    gcc-14
x86_64                randconfig-1002-20260930    gcc-14
x86_64                randconfig-1003-20260930    gcc-14
x86_64                randconfig-1004-20260930    gcc-14
x86_64                randconfig-1005-20260930    gcc-14
x86_64                randconfig-1006-20260930    gcc-14
x86_64                randconfig-1006-20261001    clang-22
x86_64                randconfig-1007-20260930    gcc-14
x86_64                randconfig-1007-20261001    clang-22
x86_64                randconfig-1008-20260930    gcc-14
x86_64                randconfig-1008-20261001    clang-22
x86_64                randconfig-1009-20260930    gcc-14
x86_64                randconfig-1009-20261001    clang-22
x86_64                randconfig-1010-20260930    gcc-14
x86_64                randconfig-1010-20261001    clang-22
x86_64                randconfig-1011-20260930    gcc-14
x86_64                randconfig-1011-20261001    clang-22
x86_64                randconfig-1012-20260930    clang-22
x86_64                randconfig-1013-20260930    clang-22
x86_64                randconfig-1014-20260930    clang-22
x86_64                randconfig-1015-20260930    clang-22
x86_64                randconfig-1016-20260930    clang-22
x86_64                randconfig-1017-20260930    clang-22
x86_64                randconfig-2100-20260930    clang-22   cocci
x86_64                randconfig-2101-20260930    clang-22   cocci
x86_64                randconfig-2102-20260930    clang-22   cocci
x86_64                randconfig-2102-20260930    gcc-14     cocci
x86_64                randconfig-2103-20260930    clang-22   cocci
x86_64                randconfig-2200-20260930    gcc-14     smatch
x86_64                randconfig-2300-20260930    clang-22   sparse
x86_64                randconfig-2300-20260930    gcc-13     sparse
x86_64                randconfig-2301-20260930    gcc-13     sparse
x86_64                randconfig-2301-20260930    gcc-14     sparse
x86_64                randconfig-2302-20260930    gcc-13     sparse
x86_64               randconfig-r2103-20260930    gcc-14     cocci
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
xtensa                randconfig-1000-20260930    clang-22
xtensa                randconfig-1000-20261001    clang-17
xtensa                randconfig-1001-20260930    clang-22
xtensa                randconfig-1001-20261001    clang-17
xtensa                randconfig-2000-20260930    gcc-10.5.0
xtensa                randconfig-2000-20260930    gcc-12.5.0
xtensa                randconfig-2001-20260930    gcc-10.5.0
xtensa               randconfig-r2100-20260930    gcc-9.5.0  cocci
xtensa               randconfig-r2101-20260930    gcc-9.5.0  cocci
xtensa               randconfig-r2107-20260930    gcc-11.5.0 cocci

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
