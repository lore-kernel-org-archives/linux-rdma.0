Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793161814;
	b=VcNh2dPaw7q/KenULqSwjYQbPzhw6iX5dZn3NrpGOFKGuPs/G/zcPOZ8MCgnfO/uuTO1
	 nkWBxYJFkmtP7ZZMX3/2tiVE7no53UI2Bt1VbFlZ0F5pJQKhdsE52+1hWo5HmH1LPy/vw
	 6nK/kxvoUYX/5aXbIjSXqUckXzSusdQzpRGfcHZcCihQ+GzYwgnMl5LfFPiQBoXuDz4Dr
	 25SHLUSTkpoGHzT23RRyio8knO2vjAIvBBmR3Z0ft88JVkXsrT67R6Ez+h1Gyw3BSy50W
	 MeoFNlAlUKP6GDE1AavUnB/qsKO0BHdaFvToqGJ6JGj4m5uxgcLEXQlvL0jragnEfMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793161814;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=2ED/NuJiDRaufiacKCTA+irIPTjYh0iR6Lw2mKDG8dE=;
	b=SxBKLTIKDTnYD9wS3pXBeQSCjd2+oyamR1Mm7nfnu9lQne2tnnAcIo4F41gKotEV7FfG
	 RT4aStTjfUPo2GLyGD15weP5S00pn+DOgWnkNPWA07y7JX/Qm/EXwza506q1KGp0nvN99
	 IQA3my5G1BAF3HFZjRK+ipVmQEJxJ6M4Dx1S9nsTZ07nY1xpX7pVhI2sManvlAsaDlUUf
	 ZXNXOMVUsZZrGaJ9z5WgaE1TRpN7/tBCCBgqucUNfqTqnNLnheAlFqsByGcg3yIY9AvX4
	 YZYzYMdpWOoC1Wo6HL265XIuxtnJLR8JytZBzJnL188tdG+37wJtGrAdGC2IbG8bG3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=T8YuAcGV;
	arc=none smtp.remote-ip=192.198.163.12
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279CC606A31F
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 04:30:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 279CC606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=T8YuAcGV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793161813; x=1824697813;
  h=date:from:to:cc:subject:message-id;
  bh=ZQPUDIGESqdKffWmVQvftVIi9IXIFluQsm0uvfeoZkM=;
  b=T8YuAcGVRZeS6u1d42B3rJ0EEPiqGqt79He1vYEjry1h/Gt52b0QhCx7
   JHicweK0+/uFZ/mfX2E9CZTYHMAr2x7k2u1tVaLMesN014VatohILCvYb
   fmiOEEtYWR2OnAA2mhsaVS/hk5ppMIX5gBXJI8xeLfaNlbN4u6YeLaHD3
   oFHnT0mA6jJJT+8Qd23bOdetbDjeZN5XasD2gbi2yjWkjn1C+5zAuijgD
   qkl7OV0SXTnD4Ocw1Y/nsGYuYOH+LgQ1/bOSi4q2rgyUBlgH5J1Yl1gfv
   JndRYPGOfEL3oItFN5ZOCQnVlQLgXcHFlLnT7e93cH01RGzW1EkrYjkQc
   w==;
X-CSE-ConnectionGUID: DcsvqVBKRtO35ppxWrlcWQ==
X-CSE-MsgGUID: S6+eRDgmQBauRngAAT1vPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11948"; a="1772475"
X-IronPort-AV: E=Sophos;i="6.27,182,1787036400"; 
   d="scan'208";a="1772475"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 21:30:12 -0700
X-CSE-ConnectionGUID: tueKtubPRvmEvnDW+VtBVw==
X-CSE-MsgGUID: 3vYBBRrvTE26QwXHdnGPRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,182,1787036400"; 
   d="scan'208";a="4700647"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 27 Oct 2026 21:30:11 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xLvIe-00000000YCD-1rHf;
	Wed, 28 Oct 2026 04:30:08 +0000
Date: Wed, 28 Oct 2026 12:29:52 +0800
From: kernel test robot <lkp@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Subject: [rdma:hmm] BUILD SUCCESS
 c5277e5b71e39d5ff63c7544270dab5305fdb38d
Message-ID: <202610281249.XUyrYmJQ-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git hmm
branch HEAD: c5277e5b71e39d5ff63c7544270dab5305fdb38d  coco/tsm: Update maintainership

elapsed time: 9749m

configs tested: 545
configs skipped: 22

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                randconfig-r2111-20261022    gcc-12     cocci
alpha                randconfig-r2201-20261022    gcc-8.5.0  smatch
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                               allyesconfig    gcc-16.2.0
arc                           axs103_defconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261023    gcc-14.4.0
arc                   randconfig-1000-20261024    clang-24
arc                   randconfig-1001-20261023    gcc-14.4.0
arc                   randconfig-1001-20261024    clang-24
arc                   randconfig-2000-20261021    clang-24
arc                   randconfig-2000-20261022    clang-24
arc                   randconfig-2001-20261021    clang-24
arc                   randconfig-2001-20261022    clang-24
arc                  randconfig-r2103-20261022    clang-24   cocci
arc                  randconfig-r2109-20261021    gcc-8.5.0  cocci
arc                  randconfig-r2109-20261022    clang-24   cocci
arc                  randconfig-r2308-20261021    gcc-15.3.0 sparse
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    gcc-16.2.0
arm                           ixp4xx_defconfig    gcc-16.2.0
arm                          orion5x_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261023    gcc-14.4.0
arm                   randconfig-1000-20261024    clang-24
arm                   randconfig-1001-20261023    gcc-14.4.0
arm                   randconfig-1001-20261024    clang-24
arm                   randconfig-1002-20261023    gcc-14.4.0
arm                   randconfig-1002-20261024    clang-24
arm                   randconfig-1003-20261023    gcc-14.4.0
arm                   randconfig-1003-20261024    clang-24
arm                   randconfig-2000-20261021    clang-24
arm                   randconfig-2000-20261022    clang-24
arm                   randconfig-2001-20261021    clang-24
arm                   randconfig-2001-20261022    clang-24
arm                  randconfig-r2105-20261021    clang-20   cocci
arm                  randconfig-r2200-20261021    gcc-10.5.0 smatch
arm                  randconfig-r2202-20261021    gcc-13.5.0 smatch
arm                  randconfig-r2302-20261022    clang-22   sparse
arm                            sama5_defconfig    clang-19
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261023    gcc-8.5.0
arm64                 randconfig-1000-20261024    gcc-10.5.0
arm64                 randconfig-1001-20261023    gcc-8.5.0
arm64                 randconfig-1001-20261024    gcc-10.5.0
arm64                 randconfig-1002-20261023    gcc-8.5.0
arm64                 randconfig-1002-20261024    gcc-10.5.0
arm64                 randconfig-1003-20261023    gcc-8.5.0
arm64                 randconfig-1003-20261024    gcc-10.5.0
arm64                 randconfig-2000-20261021    clang-24
arm64                 randconfig-2000-20261022    clang-18
arm64                 randconfig-2001-20261021    clang-24
arm64                 randconfig-2001-20261022    clang-18
arm64                randconfig-r2100-20261022    gcc-16.2.0 cocci
arm64                randconfig-r2105-20261021    clang-24   cocci
arm64                randconfig-r2108-20261022    gcc-16.2.0 cocci
arm64                randconfig-r2200-20261022    clang-24   smatch
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261023    gcc-8.5.0
csky                  randconfig-1000-20261024    gcc-10.5.0
csky                  randconfig-1001-20261023    gcc-8.5.0
csky                  randconfig-1001-20261024    gcc-10.5.0
csky                  randconfig-2000-20261021    clang-24
csky                  randconfig-2000-20261022    clang-18
csky                  randconfig-2001-20261021    clang-24
csky                  randconfig-2001-20261022    clang-18
csky                 randconfig-r2101-20261021    gcc-8.5.0  cocci
csky                 randconfig-r2103-20261022    gcc-16.2.0 cocci
csky                 randconfig-r2104-20261021    clang-20   cocci
csky                 randconfig-r2202-20261022    gcc-16.2.0 smatch
csky                 randconfig-r2300-20261021    clang-22   sparse
csky                 randconfig-r2303-20261022    clang-22   sparse
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261023    clang-17
hexagon               randconfig-1000-20261024    clang-24
hexagon               randconfig-1001-20261023    clang-17
hexagon               randconfig-1001-20261024    clang-24
hexagon               randconfig-2000-20261021    clang-24
hexagon               randconfig-2000-20261022    clang-18
hexagon               randconfig-2001-20261021    clang-24
hexagon               randconfig-2001-20261022    clang-18
hexagon              randconfig-r2101-20261022    gcc-16.2.0 cocci
hexagon              randconfig-r2102-20261022    clang-24   cocci
hexagon              randconfig-r2201-20261022    clang-17   smatch
hexagon              randconfig-r2202-20261021    clang-18   smatch
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261023    clang-22
i386        buildonly-randconfig-1000-20261024    clang-22
i386        buildonly-randconfig-1001-20261023    clang-22
i386        buildonly-randconfig-1001-20261024    clang-22
i386        buildonly-randconfig-1002-20261023    clang-22
i386        buildonly-randconfig-1002-20261024    clang-22
i386        buildonly-randconfig-1003-20261023    clang-22
i386        buildonly-randconfig-1003-20261024    clang-22
i386        buildonly-randconfig-1004-20261023    clang-22
i386        buildonly-randconfig-1004-20261024    clang-22
i386        buildonly-randconfig-1005-20261023    clang-22
i386        buildonly-randconfig-1005-20261024    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261022    gcc-13
i386                  randconfig-1000-20261023    gcc-14
i386                  randconfig-1000-20261024    clang-22
i386                  randconfig-1001-20261022    gcc-13
i386                  randconfig-1001-20261023    gcc-14
i386                  randconfig-1001-20261024    clang-22
i386                  randconfig-1002-20261022    gcc-13
i386                  randconfig-1002-20261023    gcc-14
i386                  randconfig-1002-20261024    clang-22
i386                  randconfig-1003-20261022    gcc-13
i386                  randconfig-1003-20261023    gcc-14
i386                  randconfig-1003-20261024    clang-22
i386                  randconfig-1004-20261022    gcc-13
i386                  randconfig-1004-20261023    gcc-14
i386                  randconfig-1004-20261024    clang-22
i386                  randconfig-1005-20261022    gcc-13
i386                  randconfig-1005-20261023    gcc-14
i386                  randconfig-1005-20261024    clang-22
i386                  randconfig-1006-20261022    gcc-13
i386                  randconfig-1006-20261023    gcc-14
i386                  randconfig-1006-20261024    clang-22
i386                  randconfig-1007-20261022    clang-22
i386                  randconfig-1007-20261023    clang-22
i386                  randconfig-1007-20261024    gcc-14
i386                  randconfig-1008-20261022    clang-22
i386                  randconfig-1008-20261023    clang-22
i386                  randconfig-1008-20261024    gcc-14
i386                  randconfig-1009-20261022    clang-22
i386                  randconfig-1009-20261023    clang-22
i386                  randconfig-1009-20261024    gcc-14
i386                  randconfig-1010-20261022    clang-22
i386                  randconfig-1010-20261023    clang-22
i386                  randconfig-1010-20261024    gcc-14
i386                  randconfig-1011-20261022    clang-22
i386                  randconfig-1011-20261023    clang-22
i386                  randconfig-1011-20261024    gcc-14
i386                  randconfig-1012-20261022    clang-22
i386                  randconfig-1012-20261023    clang-22
i386                  randconfig-1012-20261024    gcc-14
i386                  randconfig-1013-20261022    clang-22
i386                  randconfig-1013-20261023    clang-22
i386                  randconfig-1013-20261024    gcc-14
i386                  randconfig-2000-20261021    clang-24
i386                  randconfig-2000-20261022    clang-24
i386                  randconfig-2001-20261021    clang-24
i386                  randconfig-2001-20261022    clang-24
i386                  randconfig-2100-20261021    gcc-14     cocci
i386                  randconfig-2100-20261022    gcc-14     cocci
i386                  randconfig-2101-20261021    gcc-14     cocci
i386                  randconfig-2101-20261022    gcc-14     cocci
i386                  randconfig-2102-20261021    gcc-14     cocci
i386                  randconfig-2102-20261022    gcc-14     cocci
i386                  randconfig-2103-20261021    gcc-14     cocci
i386                  randconfig-2103-20261022    gcc-14     cocci
i386                  randconfig-2104-20261021    gcc-14     cocci
i386                  randconfig-2104-20261022    gcc-14     cocci
i386                  randconfig-2105-20261021    gcc-14     cocci
i386                  randconfig-2105-20261022    gcc-14     cocci
i386                  randconfig-2200-20261021    clang-22   smatch
i386                  randconfig-2200-20261022    gcc-14     smatch
i386                  randconfig-2300-20261021    clang-22   sparse
i386                  randconfig-2300-20261022    gcc-14     sparse
i386                  randconfig-2301-20261021    clang-22   sparse
i386                  randconfig-2301-20261022    gcc-14     sparse
i386                  randconfig-2302-20261021    clang-22   sparse
i386                  randconfig-2302-20261022    gcc-14     sparse
i386                 randconfig-r2104-20261021    clang-24   cocci
i386                 randconfig-r2105-20261022    gcc-12     cocci
i386                 randconfig-r2106-20261021    clang-20   cocci
i386                 randconfig-r2302-20261021    gcc-10.5.0 sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261023    clang-17
loongarch             randconfig-1000-20261024    clang-24
loongarch             randconfig-1001-20261023    clang-17
loongarch             randconfig-1001-20261024    clang-24
loongarch             randconfig-2000-20261021    gcc-11.5.0
loongarch             randconfig-2000-20261022    gcc-11.5.0
loongarch             randconfig-2001-20261021    gcc-11.5.0
loongarch             randconfig-2001-20261022    gcc-11.5.0
loongarch            randconfig-r2101-20261022    gcc-16.2.0 cocci
loongarch            randconfig-r2106-20261021    clang-24   cocci
loongarch            randconfig-r2200-20261022    clang-24   smatch
loongarch            randconfig-r2300-20261021    gcc-10.5.0 sparse
loongarch            randconfig-r2305-20261021    gcc-10.5.0 sparse
loongarch            randconfig-r2307-20261021    gcc-15.3.0 sparse
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                        m5275evb_defconfig    gcc-16.2.0
m68k                             mac_defconfig    gcc-16.2.0
m68k                           multi_defconfig    gcc-16.2.0
m68k                 randconfig-r2102-20261021    gcc-8.5.0  cocci
m68k                 randconfig-r2105-20261022    gcc-14     cocci
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r2102-20261022    gcc-16.2.0 cocci
microblaze           randconfig-r2106-20261022    gcc-12     cocci
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                   cavium_octeon_defconfig    gcc-16.2.0
mips                            ci20_defconfig    gcc-16.2.0
mips                        lemote2f_defconfig    gcc-16.2.0
mips                         omega2p_defconfig    clang-19
mips                         omega2p_defconfig    gcc-16.2.0
mips                 randconfig-r2106-20261022    gcc-14.4.0 cocci
mips                 randconfig-r2111-20261021    clang-24   cocci
mips                 randconfig-r2301-20261022    clang-22   sparse
nios2                          3c120_defconfig    gcc-16.2.0
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261023    clang-17
nios2                 randconfig-1000-20261024    clang-24
nios2                 randconfig-1001-20261023    clang-17
nios2                 randconfig-1001-20261024    clang-24
nios2                 randconfig-2000-20261021    gcc-11.5.0
nios2                 randconfig-2000-20261022    gcc-11.5.0
nios2                 randconfig-2001-20261021    gcc-11.5.0
nios2                 randconfig-2001-20261022    gcc-11.5.0
nios2                randconfig-r2200-20261022    gcc-11.5.0 smatch
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.2.0
openrisc             randconfig-r2100-20261022    gcc-16.2.0 cocci
openrisc             randconfig-r2103-20261022    gcc-16.2.0 cocci
openrisc             randconfig-r2104-20261022    gcc-14.4.0 cocci
openrisc             randconfig-r2110-20261022    gcc-12     cocci
openrisc             randconfig-r2111-20261022    gcc-14.4.0 cocci
openrisc             randconfig-r2304-20261021    gcc-10.5.0 sparse
openrisc             randconfig-r2311-20261021    gcc-15.3.0 sparse
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261023    gcc-15.3.0
parisc                randconfig-1000-20261024    clang-24
parisc                randconfig-1001-20261023    gcc-15.3.0
parisc                randconfig-1001-20261024    clang-24
parisc                randconfig-2000-20261021    gcc-11.5.0
parisc                randconfig-2000-20261022    gcc-11.5.0
parisc                randconfig-2001-20261021    gcc-11.5.0
parisc                randconfig-2001-20261022    gcc-11.5.0
parisc               randconfig-r2104-20261022    gcc-12     cocci
parisc               randconfig-r2109-20261022    gcc-16.2.0 cocci
parisc               randconfig-r2301-20261021    clang-22   sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                     amigaone_defconfig    gcc-16.2.0
powerpc                       chrp32_defconfig    gcc-16.2.0
powerpc                         fsp2_defconfig    gcc-16.2.0
powerpc                     gamecube_defconfig    clang-19
powerpc                     ge_imp3a_defconfig    gcc-16.2.0
powerpc                   iss476-smp_defconfig    gcc-16.2.0
powerpc                       pmac32_defconfig    gcc-16.2.0
powerpc                          ps3_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261023    gcc-15.3.0
powerpc               randconfig-1000-20261024    clang-24
powerpc               randconfig-1001-20261023    gcc-15.3.0
powerpc               randconfig-1001-20261024    clang-24
powerpc               randconfig-2000-20261021    clang-24
powerpc               randconfig-2000-20261022    clang-24
powerpc               randconfig-2001-20261021    clang-24
powerpc               randconfig-2001-20261022    clang-24
powerpc              randconfig-r2109-20261022    gcc-16.2.0 cocci
powerpc              randconfig-r2201-20261022    gcc-8.5.0  smatch
powerpc                          wii_defconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261023    gcc-15.3.0
powerpc64             randconfig-1000-20261024    clang-24
powerpc64             randconfig-1001-20261023    gcc-15.3.0
powerpc64             randconfig-1001-20261024    clang-24
powerpc64             randconfig-2000-20261021    clang-24
powerpc64             randconfig-2000-20261022    clang-24
powerpc64             randconfig-2001-20261021    clang-24
powerpc64             randconfig-2001-20261022    clang-24
powerpc64            randconfig-r2103-20261021    gcc-8.5.0  cocci
powerpc64            randconfig-r2104-20261022    gcc-14     cocci
powerpc64            randconfig-r2107-20261022    gcc-14.4.0 cocci
powerpc64            randconfig-r2111-20261022    gcc-14     cocci
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261022    gcc-13.5.0
riscv                 randconfig-1000-20261023    gcc-16.2.0
riscv                 randconfig-1000-20261024    gcc-11.5.0
riscv                 randconfig-1001-20261022    gcc-13.5.0
riscv                 randconfig-1001-20261023    gcc-16.2.0
riscv                 randconfig-1001-20261024    gcc-11.5.0
riscv                 randconfig-2000-20261021    clang-18
riscv                 randconfig-2000-20261022    gcc-15.3.0
riscv                 randconfig-2001-20261021    clang-18
riscv                 randconfig-2001-20261022    gcc-15.3.0
riscv                randconfig-r2105-20261022    gcc-14.4.0 cocci
riscv                randconfig-r2108-20261022    clang-24   cocci
riscv                randconfig-r2110-20261022    gcc-14     cocci
riscv                randconfig-r2111-20261021    clang-20   cocci
riscv                randconfig-r2300-20261022    clang-22   sparse
riscv                randconfig-r2301-20261021    gcc-10.5.0 sparse
s390                              alldefconfig    gcc-16.2.0
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261022    gcc-13.5.0
s390                  randconfig-1000-20261023    gcc-16.2.0
s390                  randconfig-1000-20261024    gcc-11.5.0
s390                  randconfig-1001-20261022    gcc-13.5.0
s390                  randconfig-1001-20261023    gcc-16.2.0
s390                  randconfig-1001-20261024    gcc-11.5.0
s390                  randconfig-2000-20261021    clang-18
s390                  randconfig-2000-20261022    gcc-15.3.0
s390                  randconfig-2001-20261021    clang-18
s390                  randconfig-2001-20261022    gcc-15.3.0
s390                 randconfig-r2110-20261021    clang-24   cocci
s390                 randconfig-r2200-20261022    gcc-8.5.0  smatch
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                           kfr2r09_defconfig    gcc-16.2.0
sh                    randconfig-1000-20261022    gcc-13.5.0
sh                    randconfig-1000-20261023    gcc-16.2.0
sh                    randconfig-1000-20261024    gcc-11.5.0
sh                    randconfig-1001-20261022    gcc-13.5.0
sh                    randconfig-1001-20261023    gcc-16.2.0
sh                    randconfig-1001-20261024    gcc-11.5.0
sh                    randconfig-2000-20261021    clang-18
sh                    randconfig-2000-20261022    gcc-15.3.0
sh                    randconfig-2001-20261021    clang-18
sh                    randconfig-2001-20261022    gcc-15.3.0
sh                   randconfig-r2107-20261021    clang-24   cocci
sh                   randconfig-r2108-20261022    gcc-16.2.0 cocci
sh                   randconfig-r2303-20261021    gcc-10.5.0 sparse
sh                   randconfig-r2304-20261021    clang-22   sparse
sh                           rsk7201_defconfig    gcc-16.2.0
sh                            se7724_defconfig    gcc-16.2.0
sh                              sh03_defconfig    clang-19
sh                              sh03_defconfig    gcc-16.2.0
sh                   sh7785lcr_32bit_defconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261022    gcc-12
sparc                 randconfig-1000-20261023    clang-24
sparc                 randconfig-1000-20261024    gcc-14
sparc                 randconfig-1001-20261022    gcc-12
sparc                 randconfig-1001-20261023    clang-24
sparc                 randconfig-1001-20261024    gcc-14
sparc                 randconfig-2000-20261021    gcc-16.2.0
sparc                 randconfig-2000-20261022    gcc-15.3.0
sparc                 randconfig-2001-20261021    gcc-16.2.0
sparc                 randconfig-2001-20261022    gcc-15.3.0
sparc                        sparc32_defconfig    clang-19
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261022    gcc-12
sparc64               randconfig-1000-20261023    clang-24
sparc64               randconfig-1000-20261024    gcc-14
sparc64               randconfig-1001-20261022    gcc-12
sparc64               randconfig-1001-20261023    clang-24
sparc64               randconfig-1001-20261024    gcc-14
sparc64               randconfig-2000-20261021    gcc-16.2.0
sparc64               randconfig-2000-20261022    gcc-15.3.0
sparc64               randconfig-2001-20261021    gcc-16.2.0
sparc64               randconfig-2001-20261022    gcc-15.3.0
sparc64              randconfig-r2102-20261022    gcc-16.2.0 cocci
sparc64              randconfig-r2106-20261022    gcc-14     cocci
sparc64              randconfig-r2305-20261021    clang-22   sparse
sparc64              randconfig-r2305-20261022    clang-22   sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261022    gcc-12
um                    randconfig-1000-20261023    clang-24
um                    randconfig-1000-20261024    gcc-14
um                    randconfig-1001-20261022    gcc-12
um                    randconfig-1001-20261023    clang-24
um                    randconfig-1001-20261024    gcc-14
um                    randconfig-2000-20261021    gcc-16.2.0
um                    randconfig-2000-20261022    gcc-15.3.0
um                    randconfig-2001-20261021    gcc-16.2.0
um                    randconfig-2001-20261022    gcc-15.3.0
um                   randconfig-r2107-20261022    gcc-12     cocci
um                   randconfig-r2107-20261022    gcc-14     cocci
um                   randconfig-r2110-20261022    gcc-14.4.0 cocci
um                   randconfig-r2201-20261021    clang-24   smatch
um                   randconfig-r2303-20261021    clang-22   sparse
um                            x86_64_defconfig    clang-19
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261022    gcc-14
x86_64      buildonly-randconfig-1000-20261023    clang-22
x86_64      buildonly-randconfig-1000-20261024    gcc-14
x86_64      buildonly-randconfig-1001-20261022    gcc-14
x86_64      buildonly-randconfig-1001-20261023    clang-22
x86_64      buildonly-randconfig-1001-20261024    gcc-14
x86_64      buildonly-randconfig-1002-20261022    gcc-14
x86_64      buildonly-randconfig-1002-20261023    clang-22
x86_64      buildonly-randconfig-1002-20261024    gcc-14
x86_64      buildonly-randconfig-1003-20261022    gcc-14
x86_64      buildonly-randconfig-1003-20261023    clang-22
x86_64      buildonly-randconfig-1003-20261024    gcc-14
x86_64      buildonly-randconfig-1004-20261022    gcc-14
x86_64      buildonly-randconfig-1004-20261023    clang-22
x86_64      buildonly-randconfig-1004-20261024    gcc-14
x86_64      buildonly-randconfig-1005-20261022    gcc-14
x86_64      buildonly-randconfig-1005-20261023    clang-22
x86_64      buildonly-randconfig-1005-20261024    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261022    clang-22
x86_64                randconfig-1000-20261023    gcc-14
x86_64                randconfig-1000-20261024    gcc-14
x86_64                randconfig-1001-20261022    clang-22
x86_64                randconfig-1001-20261023    gcc-14
x86_64                randconfig-1001-20261024    gcc-14
x86_64                randconfig-1002-20261022    clang-22
x86_64                randconfig-1002-20261023    gcc-14
x86_64                randconfig-1002-20261024    gcc-14
x86_64                randconfig-1003-20261022    clang-22
x86_64                randconfig-1003-20261023    gcc-14
x86_64                randconfig-1003-20261024    gcc-14
x86_64                randconfig-1004-20261022    clang-22
x86_64                randconfig-1004-20261023    gcc-14
x86_64                randconfig-1004-20261024    gcc-14
x86_64                randconfig-1005-20261022    clang-22
x86_64                randconfig-1005-20261023    gcc-14
x86_64                randconfig-1005-20261024    gcc-14
x86_64                randconfig-1006-20261022    clang-22
x86_64                randconfig-1006-20261023    gcc-14
x86_64                randconfig-1006-20261024    gcc-13
x86_64                randconfig-1007-20261022    clang-22
x86_64                randconfig-1007-20261023    gcc-14
x86_64                randconfig-1007-20261024    gcc-13
x86_64                randconfig-1008-20261022    clang-22
x86_64                randconfig-1008-20261023    gcc-14
x86_64                randconfig-1008-20261024    gcc-13
x86_64                randconfig-1009-20261022    clang-22
x86_64                randconfig-1009-20261023    gcc-14
x86_64                randconfig-1009-20261024    gcc-13
x86_64                randconfig-1010-20261022    clang-22
x86_64                randconfig-1010-20261023    gcc-14
x86_64                randconfig-1010-20261024    gcc-13
x86_64                randconfig-1011-20261022    clang-22
x86_64                randconfig-1011-20261023    gcc-14
x86_64                randconfig-1011-20261024    gcc-13
x86_64                randconfig-1012-20261023    clang-22
x86_64                randconfig-1012-20261024    clang-22
x86_64                randconfig-1013-20261023    clang-22
x86_64                randconfig-1013-20261024    clang-22
x86_64                randconfig-1014-20261023    clang-22
x86_64                randconfig-1014-20261024    clang-22
x86_64                randconfig-1015-20261023    clang-22
x86_64                randconfig-1015-20261024    clang-22
x86_64                randconfig-1016-20261023    clang-22
x86_64                randconfig-1016-20261024    clang-22
x86_64                randconfig-1017-20261023    clang-22
x86_64                randconfig-1017-20261024    clang-22
x86_64                randconfig-2000-20261021    clang-24
x86_64                randconfig-2000-20261022    clang-24
x86_64                randconfig-2001-20261021    clang-24
x86_64                randconfig-2001-20261022    clang-24
x86_64                randconfig-2100-20261021    clang-22   cocci
x86_64                randconfig-2100-20261022    gcc-14     cocci
x86_64                randconfig-2101-20261021    clang-22   cocci
x86_64                randconfig-2101-20261022    gcc-14     cocci
x86_64                randconfig-2102-20261021    clang-22   cocci
x86_64                randconfig-2102-20261022    gcc-14     cocci
x86_64                randconfig-2103-20261021    clang-22   cocci
x86_64                randconfig-2103-20261022    gcc-14     cocci
x86_64                randconfig-2104-20261021    clang-22   cocci
x86_64                randconfig-2104-20261022    gcc-14     cocci
x86_64                randconfig-2105-20261021    clang-22   cocci
x86_64                randconfig-2105-20261022    gcc-14     cocci
x86_64                randconfig-2200-20261021    clang-22   smatch
x86_64                randconfig-2200-20261022    gcc-14     smatch
x86_64                randconfig-2300-20261021    clang-22   sparse
x86_64                randconfig-2300-20261022    gcc-14     sparse
x86_64                randconfig-2301-20261021    clang-22   sparse
x86_64                randconfig-2301-20261022    gcc-14     sparse
x86_64                randconfig-2302-20261021    clang-22   sparse
x86_64                randconfig-2302-20261022    gcc-14     sparse
x86_64               randconfig-r2100-20261022    clang-24   cocci
x86_64               randconfig-r2101-20261022    clang-24   cocci
x86_64               randconfig-r2302-20261021    clang-22   sparse
x86_64               randconfig-r2304-20261022    clang-22   sparse
x86_64               randconfig-r2309-20261021    gcc-15.3.0 sparse
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
xtensa                            alldefconfig    gcc-16.2.0
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                 generic_kc705_defconfig    gcc-16.2.0
xtensa                randconfig-1000-20261022    gcc-12
xtensa                randconfig-1000-20261023    clang-24
xtensa                randconfig-1000-20261024    gcc-14
xtensa                randconfig-1001-20261022    gcc-12
xtensa                randconfig-1001-20261023    clang-24
xtensa                randconfig-1001-20261024    gcc-14
xtensa                randconfig-2000-20261021    gcc-16.2.0
xtensa                randconfig-2000-20261022    gcc-15.3.0
xtensa                randconfig-2001-20261021    gcc-16.2.0
xtensa                randconfig-2001-20261022    gcc-15.3.0
xtensa               randconfig-r2100-20261021    gcc-8.5.0  cocci
xtensa               randconfig-r2107-20261021    clang-20   cocci
xtensa               randconfig-r2108-20261021    gcc-8.5.0  cocci
xtensa               randconfig-r2110-20261021    clang-20   cocci
xtensa               randconfig-r2201-20261022    gcc-12.5.0 smatch
xtensa               randconfig-r2306-20261021    gcc-15.3.0 sparse
xtensa               randconfig-r2310-20261021    gcc-15.3.0 sparse
xtensa                     xip_kc705_defconfig    gcc-16.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
