Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7810A4E0B6C
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 12:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792411440; cv=none; b=n0xAFypFKTYYJ3jxX70jcWgm9FGkrv3ii9rFel5Sc/GmcPAB4GHwi5/+ll1t7fk3QKxsdaudmd5pUW7OAJkB0rRjZYYF9Yd1PinsaIBpCJLZvZJ18WWeTz6Lc+siiBDoImZYBgsly9/4M/atQRUTKUG/2WzivMfuj4BVvvbxsRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792411440; c=relaxed/simple;
	bh=Zr9VkFDB8N8Vm3ItbAE95i8JgQnonz8Kuoe4Mh5wu7k=;
	h=Date:From:To:Cc:Subject:Message-ID; b=LyZjlvjPNXG0nSmZFpQ5lFPmwn9IAeIhgtCBqq9poM31O8Dj3b6Uc9kng+R5t0VhoJvTpk38IMAPXSAmVjYztb5iByl2X3t3kYVMeXcEkxRIP0WPNL4jf7JFupdGnlNt6U6xjVIpyX0WHKo82i03BYDhtMclDuaKLkpBDRP1d2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=krtqjpFX; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="krtqjpFX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792411438; x=1823947438;
  h=date:from:to:cc:subject:message-id;
  bh=Zr9VkFDB8N8Vm3ItbAE95i8JgQnonz8Kuoe4Mh5wu7k=;
  b=krtqjpFXuiDLan/DxRkibD/0nXo+A9QjNlhkhl9RDtkU/i+E5Pxdt9mf
   IcCHKdL2fJeV+jS9sWauFM5Qo3XftxrxTGSc9QKw3RMMIlZRMTFC0aMy5
   ZHmBb64PYtWHdH768lH0JswQlv8pm6dcR/cRQ3UgVSeIIOwAYY0tg9znG
   boL87HjCYvzedzzJqXspNw9b48dqdKphrB/vV0pzEmpjiuUIp5b70WgTX
   jC5xdyogSF24NYZbsewC7jK5gr+T+BZJIykAgoPUaMyTc8MWVkOPRbW6C
   IVgj9JvYLUoJj9aQDg99owRs7mEigyh8zYqddM9mJLHqOPI68rl7ayj7b
   w==;
X-CSE-ConnectionGUID: /l+jjBvcSfK4jxc+a59vqQ==
X-CSE-MsgGUID: E1nG8uMrTiW3/xsNCLOmJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11939"; a="1076752"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="1076752"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 05:03:57 -0700
X-CSE-ConnectionGUID: GT4+QdgZQhCv2Kp+XxSzGQ==
X-CSE-MsgGUID: kuOd0lVuRv+NKrKMP7J/XQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="4304935"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa013.fm.intel.com with ESMTP; 19 Oct 2026 05:03:55 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xIm5o-00000000LeO-0xom;
	Mon, 19 Oct 2026 12:03:52 +0000
Date: Mon, 19 Oct 2026 20:03:41 +0800
From: kernel test robot <lkp@intel.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [rdma:wip:leon-for-next] BUILD SUCCESS
 9dd8b9a337af844291edcd9139c927d0f7958dbe
Message-ID: <202610192038.uv9gDgUC-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git wip/leon-for-next
branch HEAD: 9dd8b9a337af844291edcd9139c927d0f7958dbe  RDMA/usnic: Bound buffer size to sizeof(buf) in flowinfo_read()

elapsed time: 1344m

configs tested: 255
configs skipped: 6

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                randconfig-r2111-20261018    gcc-8.5.0  cocci
alpha                randconfig-r2311-20261018    gcc-11.5.0 sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261019    clang-21
arc                   randconfig-1001-20261019    clang-21
arc                   randconfig-2000-20261018    gcc-8.5.0
arc                   randconfig-2001-20261018    gcc-10.5.0
arc                  randconfig-r2109-20261018    gcc-13.5.0 cocci
arc                  randconfig-r2201-20261018    gcc-16.2.0 smatch
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.2.0
arm                       jornada720_defconfig    clang-24
arm                           pxa3xx_defconfig    clang-24
arm                   randconfig-1000-20261019    clang-21
arm                   randconfig-1001-20261019    clang-21
arm                   randconfig-1002-20261019    clang-21
arm                   randconfig-1003-20261019    clang-21
arm                   randconfig-2000-20261018    clang-24
arm                   randconfig-2001-20261018    clang-17
arm                  randconfig-r2308-20261018    gcc-10.5.0 sparse
arm                          socfpga_defconfig    clang-24
arm                        spear13xx_defconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261019    clang-24
arm64                 randconfig-1001-20261019    clang-24
arm64                 randconfig-1002-20261019    clang-24
arm64                 randconfig-1003-20261019    clang-24
arm64                 randconfig-2000-20261018    gcc-11.5.0
arm64                 randconfig-2001-20261018    gcc-13.5.0
arm64                randconfig-r2303-20261019    clang-24   sparse
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261019    clang-24
csky                  randconfig-1001-20261019    clang-24
csky                  randconfig-2000-20261018    gcc-12.5.0
csky                  randconfig-2001-20261018    gcc-14.4.0
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261019    clang-24
hexagon               randconfig-1001-20261019    clang-24
hexagon               randconfig-2000-20261018    clang-24
hexagon               randconfig-2001-20261018    clang-24
hexagon              randconfig-r2307-20261018    clang-24   sparse
i386                              alldefconfig    clang-24
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261019    clang-22
i386        buildonly-randconfig-1001-20261019    clang-22
i386        buildonly-randconfig-1002-20261019    clang-22
i386        buildonly-randconfig-1003-20261019    clang-22
i386        buildonly-randconfig-1004-20261019    clang-22
i386        buildonly-randconfig-1005-20261019    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261019    clang-22
i386                  randconfig-1001-20261019    clang-22
i386                  randconfig-1002-20261019    clang-22
i386                  randconfig-1003-20261019    clang-22
i386                  randconfig-1004-20261019    clang-22
i386                  randconfig-1005-20261019    clang-22
i386                  randconfig-1006-20261019    clang-22
i386                  randconfig-1007-20261019    gcc-14
i386                  randconfig-1008-20261019    gcc-14
i386                  randconfig-1009-20261019    gcc-14
i386                  randconfig-1010-20261019    gcc-14
i386                  randconfig-1011-20261019    gcc-14
i386                  randconfig-1012-20261019    gcc-14
i386                  randconfig-1013-20261019    gcc-14
i386                  randconfig-2000-20261018    clang-22
i386                  randconfig-2001-20261018    gcc-14
i386                  randconfig-2100-20261018    clang-22   cocci
i386                  randconfig-2101-20261018    gcc-14     cocci
i386                  randconfig-2102-20261018    clang-22   cocci
i386                  randconfig-2103-20261018    gcc-14     cocci
i386                  randconfig-2104-20261018    gcc-14     cocci
i386                  randconfig-2105-20261018    gcc-14     cocci
i386                  randconfig-2200-20261019    gcc-14     smatch
i386                 randconfig-r2301-20261019    clang-22   sparse
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch                 loongson32_defconfig    clang-24
loongarch             randconfig-1000-20261019    clang-24
loongarch             randconfig-1001-20261019    clang-24
loongarch             randconfig-2000-20261018    clang-24
loongarch             randconfig-2001-20261018    clang-24
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r2302-20261019    gcc-11.5.0 sparse
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                            ip27_defconfig    clang-24
mips                      loongson2k_defconfig    clang-24
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261019    clang-24
nios2                 randconfig-1001-20261019    clang-24
nios2                 randconfig-2000-20261018    gcc-11.5.0
nios2                 randconfig-2001-20261018    gcc-10.5.0
nios2                randconfig-r2107-20261018    gcc-8.5.0  cocci
nios2                randconfig-r2108-20261018    gcc-11.5.0 cocci
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.2.0
openrisc             randconfig-r2101-20261018    gcc-9.5.0  cocci
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261019    gcc-8.5.0
parisc                randconfig-1001-20261019    gcc-8.5.0
parisc                randconfig-2000-20261018    gcc-14.4.0
parisc                randconfig-2001-20261018    gcc-12.5.0
parisc               randconfig-r2104-20261018    gcc-13.5.0 cocci
parisc               randconfig-r2310-20261018    gcc-8.5.0  sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                       cm5200_defconfig    clang-24
powerpc               randconfig-1000-20261019    gcc-8.5.0
powerpc               randconfig-1001-20261019    gcc-8.5.0
powerpc               randconfig-2000-20261018    gcc-9.5.0
powerpc               randconfig-2001-20261018    gcc-8.5.0
powerpc              randconfig-r2106-20261018    gcc-15.3.0 cocci
powerpc                      tqm8548_defconfig    clang-24
powerpc64             randconfig-1000-20261019    gcc-8.5.0
powerpc64             randconfig-1001-20261019    gcc-8.5.0
powerpc64             randconfig-2000-20261018    gcc-11.5.0
powerpc64             randconfig-2001-20261018    gcc-10.5.0
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261019    gcc-11.5.0
riscv                 randconfig-1001-20261019    gcc-11.5.0
riscv                 randconfig-2000-20261018    clang-17
riscv                 randconfig-2001-20261018    gcc-15.3.0
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261019    gcc-11.5.0
s390                  randconfig-1001-20261019    gcc-11.5.0
s390                  randconfig-2000-20261018    clang-24
s390                  randconfig-2001-20261018    clang-24
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                           landisk_defconfig    clang-24
sh                             migor_defconfig    clang-24
sh                           r7785rp_defconfig    clang-24
sh                    randconfig-1000-20261019    gcc-11.5.0
sh                    randconfig-1001-20261019    gcc-11.5.0
sh                    randconfig-2000-20261018    gcc-12.5.0
sh                    randconfig-2001-20261018    gcc-10.5.0
sh                   randconfig-r2305-20261019    gcc-13.5.0 sparse
sh                         sh7757lcr_defconfig    clang-24
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261019    clang-20
sparc                 randconfig-1001-20261019    clang-20
sparc                 randconfig-2000-20261018    gcc-12.5.0
sparc                 randconfig-2001-20261018    gcc-8.5.0
sparc                randconfig-r2102-20261018    gcc-16.2.0 cocci
sparc                randconfig-r2105-20261018    gcc-16.2.0 cocci
sparc                randconfig-r2202-20261019    gcc-12.5.0 smatch
sparc                randconfig-r2306-20261018    gcc-16.2.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261019    clang-20
sparc64               randconfig-1001-20261019    clang-20
sparc64               randconfig-2000-20261018    clang-24
sparc64               randconfig-2001-20261018    gcc-8.5.0
sparc64              randconfig-r2309-20261018    gcc-8.5.0  sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261019    clang-20
um                    randconfig-1001-20261019    clang-20
um                    randconfig-2000-20261018    gcc-14
um                    randconfig-2001-20261018    clang-18
um                   randconfig-r2103-20261018    clang-22   cocci
um                   randconfig-r2110-20261018    gcc-14     cocci
um                   randconfig-r2200-20261019    gcc-14     smatch
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261019    clang-22
x86_64      buildonly-randconfig-1001-20261019    clang-22
x86_64      buildonly-randconfig-1002-20261019    clang-22
x86_64      buildonly-randconfig-1003-20261019    clang-22
x86_64      buildonly-randconfig-1004-20261019    clang-22
x86_64      buildonly-randconfig-1005-20261019    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261019    clang-22
x86_64                randconfig-1001-20261019    clang-22
x86_64                randconfig-1002-20261019    clang-22
x86_64                randconfig-1003-20261019    clang-22
x86_64                randconfig-1004-20261019    clang-22
x86_64                randconfig-1005-20261019    clang-22
x86_64                randconfig-1006-20261019    clang-22
x86_64                randconfig-1007-20261019    clang-22
x86_64                randconfig-1008-20261019    clang-22
x86_64                randconfig-1009-20261019    clang-22
x86_64                randconfig-1010-20261019    clang-22
x86_64                randconfig-1011-20261019    clang-22
x86_64                randconfig-1012-20261019    gcc-14
x86_64                randconfig-1013-20261019    gcc-14
x86_64                randconfig-1014-20261019    gcc-14
x86_64                randconfig-1015-20261019    gcc-14
x86_64                randconfig-1016-20261019    gcc-14
x86_64                randconfig-1017-20261019    gcc-14
x86_64                randconfig-2000-20261018    clang-22
x86_64                randconfig-2001-20261018    gcc-14
x86_64                randconfig-2100-20261018    clang-22   cocci
x86_64                randconfig-2101-20261018    clang-22   cocci
x86_64                randconfig-2102-20261018    clang-22   cocci
x86_64                randconfig-2103-20261018    gcc-14     cocci
x86_64                randconfig-2104-20261018    gcc-14     cocci
x86_64                randconfig-2105-20261018    clang-22   cocci
x86_64                randconfig-2200-20261018    gcc-14     smatch
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                randconfig-1000-20261019    clang-20
xtensa                randconfig-1001-20261019    clang-20
xtensa                randconfig-2000-20261018    gcc-8.5.0
xtensa                randconfig-2001-20261018    gcc-16.2.0
xtensa                          virt_defconfig    clang-24

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
