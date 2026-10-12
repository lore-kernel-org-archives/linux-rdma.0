Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CA6370AD4
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 23:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791846141; cv=none; b=CnrrfLQX6SXLDBfU14ZRQtLa5Vw//CjQmj5j1RgTPOELqSZ9AMSIR0ojC6rOmWn/PeZWxJWA68XqkW1kRHAl3I4A2X7bYLgAIYxPmZXG8BH8LTGcZC8aZG7WCf3a27nuQTFafmzh0F0AqbqB6IgdsyzVCCI6v5X/qQEi6GMR9m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791846141; c=relaxed/simple;
	bh=4Y2tEE3ZQWxWAfXcdJf+Qy8th0bGstPdyvr81dJA5YU=;
	h=Date:From:To:Cc:Subject:Message-ID; b=S1SKNO74YHhHl0byf9FDrIwX0fNr8CSpJ9xPHeje4cL1PjV8Tq9iO37mO1G10BgSCN4J8w3CPGDJsE8SqAVPxVlJjO87r6Do/Gw0cM/H2V5kbb2mifyBhkK8sF53XAx2k8pCYrlGCU3xFJ6ft+kRmJFYkpzZ/p6UeO9AXyQcA78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YZWji1Pm; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YZWji1Pm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791846139; x=1823382139;
  h=date:from:to:cc:subject:message-id;
  bh=4Y2tEE3ZQWxWAfXcdJf+Qy8th0bGstPdyvr81dJA5YU=;
  b=YZWji1PmALOLDjVZ6hpj2OUY7ZQb0ytEXCHFwL0l348n7pUoedGxhLby
   zJq6lEsGl7sse36nqWtxkGOZobm5UIyOBOIs0er3rO1UfnjihZQ7Ca5HH
   3gI6AlaxzKcA0IX69zbI3oFP3DtFe9/Y/au4eSjPlcExOoWx1aZATbNYZ
   QfvluBSMm2dqmsk0xzRVwSOusbII0oESwDTeIaAZZZEs26LtcPou5vMsr
   +vE9Ynndrg0ql0+zaQuh38e1VHqv88qH8iMd0llJaLV0BsDPwPhfBD/vj
   eP2va7eP3zUl+P+UW2mvTH1LQcsWokgASwFGVHjpKBC/VuuBPhd3uRuEk
   w==;
X-CSE-ConnectionGUID: V3S+vQvJTXac3A8hfRLkWw==
X-CSE-MsgGUID: EnYo4RIhRvaj2+xwYp7xEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11933"; a="556287"
X-IronPort-AV: E=Sophos;i="6.27,154,1787036400"; 
   d="scan'208";a="556287"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 16:02:18 -0700
X-CSE-ConnectionGUID: dAQ73uMxR7iCAPVFB04U7g==
X-CSE-MsgGUID: oCUvYGEXR7CqNvODMrwCig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,154,1787036400"; 
   d="scan'208";a="2766763"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa013.fm.intel.com with ESMTP; 12 Oct 2026 16:02:16 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xGP25-00000000CCi-3x0f;
	Mon, 12 Oct 2026 23:02:13 +0000
Date: Tue, 13 Oct 2026 07:01:14 +0800
From: kernel test robot <lkp@intel.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [rdma:wip:leon-for-next] BUILD SUCCESS
 d37e98844afea39a9614cac0de837701263c90f7
Message-ID: <202610130708.RL4NaNdx-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git wip/leon-for-next
branch HEAD: d37e98844afea39a9614cac0de837701263c90f7  RDMA/core: Clear driver_udata before destroying objects in rdma_core

elapsed time: 1587m

configs tested: 649
configs skipped: 9

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2103-20261011    gcc-8.5.0  cocci
alpha                randconfig-r2106-20261011    clang-24   cocci
alpha                randconfig-r2108-20261012    gcc-10.5.0 cocci
alpha                randconfig-r2110-20261012    gcc-10.5.0 cocci
alpha                randconfig-r2111-20261012    gcc-8.5.0  cocci
alpha                randconfig-r2202-20261011    gcc-16.1.0 smatch
alpha                randconfig-r2202-20261012    gcc-15.2.0 smatch
alpha                randconfig-r2300-20261012    clang-19   sparse
alpha                randconfig-r2302-20261011    gcc-15.2.0 sparse
alpha                randconfig-r2304-20261011    clang-24   sparse
alpha                randconfig-r2304-20261011    gcc-14.3.0 sparse
alpha                randconfig-r2305-20261011    clang-24   sparse
alpha                randconfig-r2309-20261012    gcc-12.5.0 sparse
alpha                randconfig-r2309-20261012    gcc-16.1.0 sparse
alpha                randconfig-r2311-20261012    clang-22   sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261012    gcc-8.5.0
arc                   randconfig-1000-20261013    clang-24
arc                   randconfig-1001-20261012    gcc-8.5.0
arc                   randconfig-1001-20261013    clang-24
arc                   randconfig-2000-20261011    gcc-8.5.0
arc                   randconfig-2000-20261012    gcc-16.1.0
arc                   randconfig-2001-20261011    gcc-8.5.0
arc                   randconfig-2001-20261012    gcc-16.1.0
arc                  randconfig-r2109-20261011    gcc-16.1.0 cocci
arc                  randconfig-r2200-20261012    gcc-16.1.0 smatch
arc                  randconfig-r2304-20261012    clang-19   sparse
arc                  randconfig-r2311-20261011    clang-24   sparse
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                   randconfig-1000-20261012    gcc-8.5.0
arm                   randconfig-1000-20261013    clang-24
arm                   randconfig-1001-20261012    gcc-8.5.0
arm                   randconfig-1001-20261013    clang-24
arm                   randconfig-1002-20261012    gcc-8.5.0
arm                   randconfig-1002-20261013    clang-24
arm                   randconfig-1003-20261012    gcc-8.5.0
arm                   randconfig-1003-20261013    clang-24
arm                   randconfig-2000-20261011    gcc-8.5.0
arm                   randconfig-2000-20261012    gcc-16.1.0
arm                   randconfig-2001-20261011    gcc-8.5.0
arm                   randconfig-2001-20261012    gcc-16.1.0
arm                  randconfig-r2101-20261012    gcc-15.2.0 cocci
arm                  randconfig-r2107-20261011    gcc-8.5.0  cocci
arm                  randconfig-r2107-20261012    gcc-9.5.0  cocci
arm                  randconfig-r2108-20261011    clang-24   cocci
arm                  randconfig-r2110-20261012    clang-24   cocci
arm                  randconfig-r2200-20261011    gcc-11.5.0 smatch
arm                  randconfig-r2201-20261011    gcc-13.4.0 smatch
arm                  randconfig-r2201-20261012    gcc-10.5.0 smatch
arm                  randconfig-r2303-20261011    gcc-8.5.0  sparse
arm                  randconfig-r2306-20261012    gcc-12.5.0 sparse
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261012    clang-24
arm64                 randconfig-1000-20261013    gcc-9.5.0
arm64                 randconfig-1001-20261012    clang-24
arm64                 randconfig-1001-20261013    gcc-9.5.0
arm64                 randconfig-1002-20261012    clang-24
arm64                 randconfig-1002-20261013    gcc-9.5.0
arm64                 randconfig-1003-20261012    clang-24
arm64                 randconfig-1003-20261013    gcc-9.5.0
arm64                 randconfig-2000-20261011    clang-24
arm64                 randconfig-2000-20261011    gcc-16.1.0
arm64                 randconfig-2000-20261012    gcc-16.1.0
arm64                 randconfig-2001-20261011    gcc-12.5.0
arm64                 randconfig-2001-20261011    gcc-16.1.0
arm64                 randconfig-2001-20261012    gcc-16.1.0
arm64                randconfig-r2100-20261011    gcc-16.1.0 cocci
arm64                randconfig-r2101-20261012    gcc-15.2.0 cocci
arm64                randconfig-r2105-20261011    gcc-8.5.0  cocci
arm64                randconfig-r2106-20261011    clang-22   cocci
arm64                randconfig-r2108-20261012    clang-24   cocci
arm64                randconfig-r2108-20261012    gcc-15.2.0 cocci
arm64                randconfig-r2109-20261012    gcc-11.5.0 cocci
arm64                randconfig-r2200-20261012    clang-24   smatch
arm64                randconfig-r2201-20261012    gcc-10.5.0 smatch
arm64                randconfig-r2303-20261012    clang-24   sparse
arm64                randconfig-r2305-20261012    clang-24   sparse
arm64                randconfig-r2306-20261011    gcc-8.5.0  sparse
arm64                randconfig-r2308-20261011    clang-17   sparse
arm64                randconfig-r2308-20261012    gcc-11.5.0 sparse
arm64                randconfig-r2311-20261012    gcc-12.5.0 sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261012    clang-24
csky                  randconfig-1000-20261013    gcc-9.5.0
csky                  randconfig-1001-20261012    clang-24
csky                  randconfig-1001-20261013    gcc-9.5.0
csky                  randconfig-2000-20261011    gcc-16.1.0
csky                  randconfig-2000-20261011    gcc-9.5.0
csky                  randconfig-2000-20261012    gcc-16.1.0
csky                  randconfig-2001-20261011    gcc-16.1.0
csky                  randconfig-2001-20261012    gcc-16.1.0
csky                 randconfig-r2100-20261012    gcc-12.5.0 cocci
csky                 randconfig-r2106-20261012    gcc-14     cocci
csky                 randconfig-r2108-20261011    gcc-8.5.0  cocci
csky                 randconfig-r2108-20261012    gcc-15.2.0 cocci
csky                 randconfig-r2111-20261012    gcc-10.5.0 cocci
csky                 randconfig-r2200-20261012    gcc-10.5.0 smatch
csky                 randconfig-r2202-20261011    gcc-9.5.0  smatch
csky                 randconfig-r2202-20261012    gcc-16.1.0 smatch
csky                 randconfig-r2302-20261012    clang-24   sparse
csky                 randconfig-r2303-20261012    gcc-9.5.0  sparse
csky                 randconfig-r2304-20261011    gcc-16.1.0 sparse
csky                 randconfig-r2304-20261012    gcc-13.4.0 sparse
csky                 randconfig-r2307-20261011    gcc-11.5.0 sparse
csky                 randconfig-r2309-20261011    gcc-8.5.0  sparse
csky                 randconfig-r2309-20261012    clang-22   sparse
csky                 randconfig-r2310-20261012    gcc-16.1.0 sparse
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20261012    clang-17
hexagon               randconfig-1000-20261013    clang-24
hexagon               randconfig-1001-20261012    clang-17
hexagon               randconfig-1001-20261013    clang-24
hexagon               randconfig-2000-20261011    clang-19
hexagon               randconfig-2000-20261011    gcc-16.1.0
hexagon               randconfig-2000-20261012    gcc-16.1.0
hexagon               randconfig-2001-20261011    clang-17
hexagon               randconfig-2001-20261011    gcc-16.1.0
hexagon               randconfig-2001-20261012    gcc-16.1.0
hexagon              randconfig-r2102-20261011    clang-17   cocci
hexagon              randconfig-r2102-20261012    clang-24   cocci
hexagon              randconfig-r2104-20261011    clang-24   cocci
hexagon              randconfig-r2104-20261012    clang-24   cocci
hexagon              randconfig-r2106-20261012    gcc-16.1.0 cocci
hexagon              randconfig-r2107-20261012    gcc-8.5.0  cocci
hexagon              randconfig-r2109-20261012    clang-24   cocci
hexagon              randconfig-r2110-20261012    gcc-14     cocci
hexagon              randconfig-r2302-20261012    clang-17   sparse
hexagon              randconfig-r2303-20261012    gcc-13.4.0 sparse
hexagon              randconfig-r2304-20261012    clang-17   sparse
hexagon              randconfig-r2307-20261012    gcc-12.5.0 sparse
hexagon              randconfig-r2308-20261011    clang-24   sparse
hexagon              randconfig-r2309-20261011    clang-24   sparse
hexagon              randconfig-r2310-20261011    clang-24   sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261012    clang-22
i386        buildonly-randconfig-1001-20261012    clang-22
i386        buildonly-randconfig-1002-20261012    clang-22
i386        buildonly-randconfig-1003-20261012    clang-22
i386        buildonly-randconfig-1004-20261012    clang-22
i386        buildonly-randconfig-1005-20261012    clang-22
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20261012    gcc-14
i386                  randconfig-1001-20261012    gcc-14
i386                  randconfig-1002-20261012    gcc-14
i386                  randconfig-1003-20261012    gcc-14
i386                  randconfig-1004-20261012    gcc-14
i386                  randconfig-1005-20261012    gcc-14
i386                  randconfig-1006-20261012    gcc-14
i386                  randconfig-1007-20261012    clang-22
i386                  randconfig-1008-20261012    clang-22
i386                  randconfig-1009-20261012    clang-22
i386                  randconfig-1010-20261012    clang-22
i386                  randconfig-1011-20261012    clang-22
i386                  randconfig-1012-20261012    clang-22
i386                  randconfig-1013-20261012    clang-22
i386                  randconfig-2000-20261011    gcc-8.5.0
i386                  randconfig-2000-20261012    gcc-16.1.0
i386                  randconfig-2001-20261011    gcc-8.5.0
i386                  randconfig-2001-20261012    gcc-16.1.0
i386                  randconfig-2100-20261011    gcc-14     cocci
i386                  randconfig-2100-20261012    clang-22   cocci
i386                  randconfig-2100-20261012    gcc-14     cocci
i386                  randconfig-2101-20261011    gcc-14     cocci
i386                  randconfig-2101-20261012    clang-22   cocci
i386                  randconfig-2101-20261012    gcc-14     cocci
i386                  randconfig-2102-20261011    gcc-14     cocci
i386                  randconfig-2102-20261012    clang-22   cocci
i386                  randconfig-2103-20261011    gcc-14     cocci
i386                  randconfig-2103-20261012    clang-22   cocci
i386                  randconfig-2104-20261011    gcc-14     cocci
i386                  randconfig-2104-20261012    clang-22   cocci
i386                  randconfig-2105-20261011    gcc-14     cocci
i386                  randconfig-2105-20261012    clang-22   cocci
i386                  randconfig-2200-20261011    clang-22   smatch
i386                  randconfig-2200-20261012    clang-22   smatch
i386                  randconfig-2300-20261011    gcc-14     sparse
i386                  randconfig-2300-20261012    gcc-14     sparse
i386                  randconfig-2301-20261011    gcc-14     sparse
i386                  randconfig-2301-20261012    gcc-14     sparse
i386                  randconfig-2302-20261011    gcc-14     sparse
i386                  randconfig-2302-20261012    gcc-14     sparse
i386                 randconfig-r2100-20261012    gcc-11.5.0 cocci
i386                 randconfig-r2103-20261011    gcc-14     cocci
i386                 randconfig-r2104-20261012    gcc-8.5.0  cocci
i386                 randconfig-r2106-20261011    gcc-8.5.0  cocci
i386                 randconfig-r2109-20261012    gcc-15.2.0 cocci
i386                 randconfig-r2200-20261011    clang-22   smatch
i386                 randconfig-r2202-20261012    clang-22   smatch
i386                 randconfig-r2300-20261011    gcc-14     sparse
i386                 randconfig-r2300-20261012    gcc-13.4.0 sparse
i386                 randconfig-r2300-20261012    gcc-9.5.0  sparse
i386                 randconfig-r2301-20261012    clang-22   sparse
i386                 randconfig-r2302-20261011    gcc-14.3.0 sparse
i386                 randconfig-r2302-20261011    gcc-16.1.0 sparse
i386                 randconfig-r2302-20261011    gcc-8.5.0  sparse
i386                 randconfig-r2304-20261011    gcc-14     sparse
i386                 randconfig-r2307-20261012    gcc-12.5.0 sparse
i386                 randconfig-r2310-20261012    gcc-12.5.0 sparse
i386                 randconfig-r2311-20261011    gcc-11.5.0 sparse
i386                 randconfig-r2311-20261011    gcc-14     sparse
i386                 randconfig-r2311-20261012    clang-22   sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261012    clang-17
loongarch             randconfig-1000-20261013    clang-24
loongarch             randconfig-1001-20261012    clang-17
loongarch             randconfig-1001-20261013    clang-24
loongarch             randconfig-2000-20261011    gcc-8.5.0
loongarch             randconfig-2000-20261012    gcc-11.5.0
loongarch             randconfig-2001-20261011    gcc-8.5.0
loongarch             randconfig-2001-20261012    gcc-11.5.0
loongarch            randconfig-r2100-20261012    gcc-10.5.0 cocci
loongarch            randconfig-r2100-20261012    gcc-15.2.0 cocci
loongarch            randconfig-r2101-20261012    clang-24   cocci
loongarch            randconfig-r2102-20261012    gcc-12.5.0 cocci
loongarch            randconfig-r2103-20261012    gcc-10.5.0 cocci
loongarch            randconfig-r2106-20261012    gcc-10.5.0 cocci
loongarch            randconfig-r2111-20261012    gcc-16.1.0 cocci
loongarch            randconfig-r2201-20261012    clang-20   smatch
loongarch            randconfig-r2301-20261011    gcc-16.1.0 sparse
loongarch            randconfig-r2301-20261012    gcc-13.4.0 sparse
loongarch            randconfig-r2302-20261012    clang-24   sparse
loongarch            randconfig-r2302-20261012    gcc-13.4.0 sparse
loongarch            randconfig-r2303-20261011    clang-19   sparse
loongarch            randconfig-r2303-20261011    gcc-16.1.0 sparse
loongarch            randconfig-r2305-20261012    clang-22   sparse
loongarch            randconfig-r2308-20261011    clang-24   sparse
loongarch            randconfig-r2310-20261012    gcc-12.5.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
m68k                 randconfig-r2101-20261012    gcc-10.5.0 cocci
m68k                 randconfig-r2103-20261012    gcc-12.5.0 cocci
m68k                 randconfig-r2109-20261012    gcc-12.5.0 cocci
m68k                 randconfig-r2111-20261011    gcc-8.5.0  cocci
m68k                 randconfig-r2201-20261012    gcc-13.4.0 smatch
m68k                 randconfig-r2202-20261011    gcc-16.1.0 smatch
m68k                 randconfig-r2305-20261012    clang-24   sparse
m68k                 randconfig-r2305-20261012    gcc-13.4.0 sparse
m68k                 randconfig-r2310-20261011    clang-24   sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r2102-20261012    gcc-10.5.0 cocci
microblaze           randconfig-r2104-20261011    gcc-13.4.0 cocci
microblaze           randconfig-r2104-20261012    gcc-16.1.0 cocci
microblaze           randconfig-r2105-20261011    clang-24   cocci
microblaze           randconfig-r2109-20261012    gcc-15.2.0 cocci
microblaze           randconfig-r2202-20261012    gcc-15.2.0 smatch
microblaze           randconfig-r2300-20261012    clang-24   sparse
microblaze           randconfig-r2306-20261011    clang-24   sparse
microblaze           randconfig-r2306-20261012    gcc-12.5.0 sparse
microblaze           randconfig-r2308-20261011    gcc-8.5.0  sparse
microblaze           randconfig-r2308-20261012    gcc-12.5.0 sparse
microblaze           randconfig-r2309-20261011    clang-24   sparse
microblaze           randconfig-r2310-20261012    clang-22   sparse
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                 randconfig-r2100-20261012    clang-24   cocci
mips                 randconfig-r2103-20261011    gcc-16.1.0 cocci
mips                 randconfig-r2106-20261011    clang-24   cocci
mips                 randconfig-r2106-20261012    gcc-8.5.0  cocci
mips                 randconfig-r2110-20261012    gcc-10.5.0 cocci
mips                 randconfig-r2201-20261012    gcc-10.5.0 smatch
mips                 randconfig-r2202-20261011    gcc-15.2.0 smatch
mips                 randconfig-r2300-20261012    clang-17   sparse
mips                 randconfig-r2304-20261012    clang-24   sparse
mips                 randconfig-r2305-20261012    clang-17   sparse
mips                 randconfig-r2306-20261011    gcc-11.5.0 sparse
mips                 randconfig-r2306-20261012    clang-22   sparse
mips                 randconfig-r2307-20261011    gcc-8.5.0  sparse
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261012    clang-17
nios2                 randconfig-1000-20261013    clang-24
nios2                 randconfig-1001-20261012    clang-17
nios2                 randconfig-1001-20261013    clang-24
nios2                 randconfig-2000-20261011    gcc-8.5.0
nios2                 randconfig-2000-20261012    gcc-11.5.0
nios2                 randconfig-2001-20261011    gcc-8.5.0
nios2                 randconfig-2001-20261012    gcc-11.5.0
nios2                randconfig-r2101-20261011    gcc-8.5.0  cocci
nios2                randconfig-r2102-20261012    gcc-11.5.0 cocci
nios2                randconfig-r2107-20261012    gcc-10.5.0 cocci
nios2                randconfig-r2108-20261012    clang-24   cocci
nios2                randconfig-r2108-20261012    gcc-12.5.0 cocci
nios2                randconfig-r2110-20261012    gcc-8.5.0  cocci
nios2                randconfig-r2111-20261012    gcc-15.2.0 cocci
nios2                randconfig-r2202-20261011    gcc-8.5.0  smatch
nios2                randconfig-r2307-20261011    clang-24   sparse
nios2                randconfig-r2307-20261012    gcc-8.5.0  sparse
nios2                randconfig-r2308-20261011    gcc-11.5.0 sparse
nios2                randconfig-r2311-20261012    gcc-16.1.0 sparse
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2101-20261012    clang-24   cocci
openrisc             randconfig-r2103-20261012    clang-24   cocci
openrisc             randconfig-r2104-20261011    clang-22   cocci
openrisc             randconfig-r2104-20261012    gcc-14     cocci
openrisc             randconfig-r2105-20261012    gcc-15.2.0 cocci
openrisc             randconfig-r2109-20261012    gcc-10.5.0 cocci
openrisc             randconfig-r2300-20261011    gcc-8.5.0  sparse
openrisc             randconfig-r2305-20261011    gcc-14.3.0 sparse
openrisc             randconfig-r2306-20261011    gcc-8.5.0  sparse
openrisc             randconfig-r2309-20261012    gcc-16.1.0 sparse
openrisc             randconfig-r2310-20261011    gcc-11.5.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261012    gcc-8.5.0
parisc                randconfig-1001-20261012    gcc-8.5.0
parisc                randconfig-2000-20261011    gcc-8.5.0
parisc                randconfig-2000-20261012    gcc-11.5.0
parisc                randconfig-2001-20261011    gcc-8.5.0
parisc                randconfig-2001-20261012    gcc-11.5.0
parisc               randconfig-r2100-20261011    gcc-8.5.0  cocci
parisc               randconfig-r2100-20261012    clang-20   cocci
parisc               randconfig-r2101-20261012    clang-20   cocci
parisc               randconfig-r2102-20261012    gcc-15.2.0 cocci
parisc               randconfig-r2105-20261011    gcc-8.5.0  cocci
parisc               randconfig-r2105-20261012    gcc-9.5.0  cocci
parisc               randconfig-r2110-20261011    gcc-15.2.0 cocci
parisc               randconfig-r2110-20261012    gcc-9.5.0  cocci
parisc               randconfig-r2111-20261012    gcc-9.5.0  cocci
parisc               randconfig-r2201-20261011    gcc-11.5.0 smatch
parisc               randconfig-r2201-20261012    gcc-16.1.0 smatch
parisc               randconfig-r2300-20261011    gcc-16.1.0 sparse
parisc               randconfig-r2301-20261012    clang-19   sparse
parisc               randconfig-r2303-20261012    clang-22   sparse
parisc               randconfig-r2304-20261012    clang-22   sparse
parisc               randconfig-r2304-20261012    gcc-9.5.0  sparse
parisc               randconfig-r2311-20261011    gcc-8.5.0  sparse
parisc               randconfig-r2311-20261012    gcc-12.5.0 sparse
parisc64                             defconfig    clang-24
powerpc                            allnoconfig    clang-24
powerpc                     amigaone_defconfig    gcc-16.1.0
powerpc                       ep88xc_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20261012    gcc-8.5.0
powerpc               randconfig-1001-20261012    gcc-8.5.0
powerpc               randconfig-2000-20261011    clang-22
powerpc               randconfig-2000-20261012    gcc-14
powerpc               randconfig-2001-20261011    clang-22
powerpc               randconfig-2001-20261012    gcc-14
powerpc              randconfig-r2101-20261011    gcc-8.5.0  cocci
powerpc              randconfig-r2103-20261012    clang-24   cocci
powerpc              randconfig-r2103-20261012    gcc-11.5.0 cocci
powerpc              randconfig-r2105-20261012    gcc-10.5.0 cocci
powerpc              randconfig-r2106-20261012    clang-24   cocci
powerpc              randconfig-r2106-20261012    gcc-15.2.0 cocci
powerpc              randconfig-r2106-20261012    gcc-9.5.0  cocci
powerpc              randconfig-r2111-20261011    clang-24   cocci
powerpc              randconfig-r2111-20261011    gcc-11.5.0 cocci
powerpc              randconfig-r2302-20261012    clang-19   sparse
powerpc              randconfig-r2305-20261011    gcc-16.1.0 sparse
powerpc              randconfig-r2305-20261012    clang-19   sparse
powerpc              randconfig-r2306-20261011    clang-24   sparse
powerpc              randconfig-r2309-20261012    clang-22   sparse
powerpc              randconfig-r2311-20261011    clang-24   sparse
powerpc64             randconfig-1000-20261012    gcc-8.5.0
powerpc64             randconfig-1001-20261012    gcc-8.5.0
powerpc64             randconfig-2000-20261011    clang-22
powerpc64             randconfig-2000-20261012    gcc-14
powerpc64             randconfig-2001-20261011    clang-22
powerpc64             randconfig-2001-20261012    gcc-14
powerpc64            randconfig-r2100-20261011    gcc-8.5.0  cocci
powerpc64            randconfig-r2101-20261011    gcc-16.1.0 cocci
powerpc64            randconfig-r2104-20261012    gcc-15.2.0 cocci
powerpc64            randconfig-r2105-20261012    clang-24   cocci
powerpc64            randconfig-r2108-20261012    clang-20   cocci
powerpc64            randconfig-r2110-20261011    clang-22   cocci
powerpc64            randconfig-r2301-20261011    gcc-12.5.0 sparse
powerpc64            randconfig-r2302-20261011    clang-24   sparse
powerpc64            randconfig-r2302-20261012    clang-22   sparse
powerpc64            randconfig-r2304-20261011    gcc-8.5.0  sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20261012    clang-24
riscv                 randconfig-1000-20261013    gcc-9.5.0
riscv                 randconfig-1001-20261012    clang-24
riscv                 randconfig-1001-20261013    gcc-9.5.0
riscv                 randconfig-2000-20261011    gcc-13.4.0
riscv                 randconfig-2000-20261011    gcc-8.5.0
riscv                 randconfig-2000-20261012    gcc-14.3.0
riscv                 randconfig-2001-20261011    gcc-13.4.0
riscv                 randconfig-2001-20261011    gcc-8.5.0
riscv                 randconfig-2001-20261012    gcc-14.3.0
riscv                randconfig-r2102-20261012    gcc-15.2.0 cocci
riscv                randconfig-r2103-20261012    gcc-15.2.0 cocci
riscv                randconfig-r2106-20261011    clang-21   cocci
riscv                randconfig-r2107-20261011    clang-24   cocci
riscv                randconfig-r2110-20261011    clang-24   cocci
riscv                randconfig-r2110-20261012    gcc-15.2.0 cocci
riscv                randconfig-r2111-20261012    clang-24   cocci
riscv                randconfig-r2202-20261012    clang-24   smatch
riscv                randconfig-r2300-20261012    clang-22   sparse
riscv                randconfig-r2301-20261011    clang-24   sparse
riscv                randconfig-r2303-20261012    clang-19   sparse
riscv                randconfig-r2305-20261011    gcc-8.5.0  sparse
riscv                randconfig-r2308-20261012    gcc-16.1.0 sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20261012    clang-24
s390                  randconfig-1000-20261013    gcc-9.5.0
s390                  randconfig-1001-20261012    clang-24
s390                  randconfig-1001-20261013    gcc-9.5.0
s390                  randconfig-2000-20261011    clang-17
s390                  randconfig-2000-20261011    gcc-13.4.0
s390                  randconfig-2000-20261012    gcc-14.3.0
s390                  randconfig-2001-20261011    clang-24
s390                  randconfig-2001-20261011    gcc-13.4.0
s390                  randconfig-2001-20261012    gcc-14.3.0
s390                 randconfig-r2105-20261012    gcc-14     cocci
s390                 randconfig-r2111-20261012    gcc-14     cocci
s390                 randconfig-r2201-20261012    clang-17   smatch
s390                 randconfig-r2202-20261012    gcc-14.3.0 smatch
s390                 randconfig-r2305-20261011    clang-24   sparse
s390                 randconfig-r2306-20261012    clang-22   sparse
s390                 randconfig-r2306-20261012    gcc-13.4.0 sparse
s390                 randconfig-r2307-20261012    gcc-16.1.0 sparse
s390                 randconfig-r2309-20261012    gcc-12.5.0 sparse
s390                 randconfig-r2310-20261011    gcc-8.5.0  sparse
s390                 randconfig-r2310-20261012    clang-22   sparse
s390                 randconfig-r2310-20261012    gcc-16.1.0 sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                    randconfig-1000-20261012    clang-24
sh                    randconfig-1000-20261013    gcc-9.5.0
sh                    randconfig-1001-20261012    clang-24
sh                    randconfig-1001-20261013    gcc-9.5.0
sh                    randconfig-2000-20261011    gcc-13.4.0
sh                    randconfig-2000-20261012    gcc-14.3.0
sh                    randconfig-2001-20261011    gcc-13.4.0
sh                    randconfig-2001-20261011    gcc-16.1.0
sh                    randconfig-2001-20261012    gcc-14.3.0
sh                   randconfig-r2101-20261012    gcc-11.5.0 cocci
sh                   randconfig-r2106-20261012    gcc-10.5.0 cocci
sh                   randconfig-r2107-20261012    clang-24   cocci
sh                   randconfig-r2107-20261012    gcc-10.5.0 cocci
sh                   randconfig-r2107-20261012    gcc-15.2.0 cocci
sh                   randconfig-r2108-20261011    gcc-16.1.0 cocci
sh                   randconfig-r2110-20261011    gcc-8.5.0  cocci
sh                   randconfig-r2201-20261012    gcc-9.5.0  smatch
sh                   randconfig-r2300-20261012    clang-24   sparse
sh                   randconfig-r2301-20261011    gcc-8.5.0  sparse
sh                   randconfig-r2301-20261012    clang-24   sparse
sh                   randconfig-r2303-20261011    clang-24   sparse
sh                   randconfig-r2307-20261012    gcc-16.1.0 sparse
sh                   randconfig-r2309-20261012    gcc-16.1.0 sparse
sh                   randconfig-r2311-20261012    gcc-12.5.0 sparse
sh                           rsk7201_defconfig    gcc-16.1.0
sh                           sdk7780_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261012    clang-20
sparc                 randconfig-1001-20261012    clang-20
sparc                 randconfig-2000-20261011    gcc-8.5.0
sparc                 randconfig-2000-20261012    gcc-8.5.0
sparc                 randconfig-2001-20261011    gcc-8.5.0
sparc                 randconfig-2001-20261012    gcc-8.5.0
sparc                randconfig-r2100-20261011    gcc-13.4.0 cocci
sparc                randconfig-r2100-20261012    gcc-15.2.0 cocci
sparc                randconfig-r2101-20261012    gcc-12.5.0 cocci
sparc                randconfig-r2105-20261011    clang-24   cocci
sparc                randconfig-r2105-20261012    gcc-8.5.0  cocci
sparc                randconfig-r2107-20261011    clang-24   cocci
sparc                randconfig-r2109-20261011    gcc-8.5.0  cocci
sparc                randconfig-r2111-20261011    clang-24   cocci
sparc                randconfig-r2200-20261011    gcc-8.5.0  smatch
sparc                randconfig-r2200-20261012    gcc-11.5.0 smatch
sparc                randconfig-r2201-20261011    gcc-14.3.0 smatch
sparc                randconfig-r2300-20261011    clang-24   sparse
sparc                randconfig-r2303-20261012    clang-17   sparse
sparc                randconfig-r2307-20261011    clang-24   sparse
sparc                randconfig-r2309-20261011    gcc-11.5.0 sparse
sparc                randconfig-r2310-20261012    gcc-8.5.0  sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261012    clang-20
sparc64               randconfig-1001-20261012    clang-20
sparc64               randconfig-2000-20261011    clang-24
sparc64               randconfig-2000-20261011    gcc-8.5.0
sparc64               randconfig-2000-20261012    gcc-8.5.0
sparc64               randconfig-2001-20261011    gcc-10.5.0
sparc64               randconfig-2001-20261011    gcc-8.5.0
sparc64               randconfig-2001-20261012    gcc-8.5.0
sparc64              randconfig-r2100-20261012    clang-24   cocci
sparc64              randconfig-r2102-20261012    clang-20   cocci
sparc64              randconfig-r2109-20261011    gcc-8.5.0  cocci
sparc64              randconfig-r2111-20261011    clang-22   cocci
sparc64              randconfig-r2200-20261012    clang-20   smatch
sparc64              randconfig-r2302-20261012    gcc-9.5.0  sparse
sparc64              randconfig-r2309-20261011    gcc-16.1.0 sparse
sparc64              randconfig-r2311-20261012    gcc-16.1.0 sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261012    clang-20
um                    randconfig-1001-20261012    clang-20
um                    randconfig-2000-20261011    gcc-14
um                    randconfig-2000-20261011    gcc-8.5.0
um                    randconfig-2000-20261012    gcc-8.5.0
um                    randconfig-2001-20261011    gcc-14
um                    randconfig-2001-20261011    gcc-8.5.0
um                    randconfig-2001-20261012    gcc-8.5.0
um                   randconfig-r2101-20261011    gcc-8.5.0  cocci
um                   randconfig-r2102-20261011    gcc-16.1.0 cocci
um                   randconfig-r2102-20261012    clang-24   cocci
um                   randconfig-r2103-20261012    clang-20   cocci
um                   randconfig-r2104-20261012    gcc-10.5.0 cocci
um                   randconfig-r2105-20261012    gcc-16.1.0 cocci
um                   randconfig-r2107-20261012    gcc-16.1.0 cocci
um                   randconfig-r2110-20261012    gcc-16.1.0 cocci
um                   randconfig-r2202-20261012    clang-17   smatch
um                   randconfig-r2301-20261011    gcc-14.3.0 sparse
um                   randconfig-r2301-20261012    clang-17   sparse
um                   randconfig-r2303-20261011    gcc-14.3.0 sparse
um                   randconfig-r2307-20261012    clang-22   sparse
um                   randconfig-r2308-20261012    gcc-16.1.0 sparse
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261012    clang-22
x86_64      buildonly-randconfig-1001-20261012    clang-22
x86_64      buildonly-randconfig-1002-20261012    clang-22
x86_64      buildonly-randconfig-1003-20261012    clang-22
x86_64      buildonly-randconfig-1004-20261012    clang-22
x86_64      buildonly-randconfig-1005-20261012    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261012    clang-22
x86_64                randconfig-1001-20261012    clang-22
x86_64                randconfig-1002-20261012    clang-22
x86_64                randconfig-1003-20261012    clang-22
x86_64                randconfig-1004-20261012    clang-22
x86_64                randconfig-1005-20261012    clang-22
x86_64                randconfig-1006-20261012    clang-22
x86_64                randconfig-1007-20261012    clang-22
x86_64                randconfig-1008-20261012    clang-22
x86_64                randconfig-1009-20261012    clang-22
x86_64                randconfig-1010-20261012    clang-22
x86_64                randconfig-1011-20261012    clang-22
x86_64                randconfig-1012-20261012    gcc-14
x86_64                randconfig-1013-20261012    gcc-14
x86_64                randconfig-1014-20261012    gcc-14
x86_64                randconfig-1015-20261012    gcc-14
x86_64                randconfig-1016-20261012    gcc-14
x86_64                randconfig-1017-20261012    gcc-14
x86_64                randconfig-2000-20261011    clang-22
x86_64                randconfig-2000-20261012    gcc-14
x86_64                randconfig-2001-20261011    clang-22
x86_64                randconfig-2001-20261012    gcc-14
x86_64                randconfig-2100-20261011    gcc-12     cocci
x86_64                randconfig-2100-20261011    gcc-14     cocci
x86_64                randconfig-2100-20261012    clang-22   cocci
x86_64                randconfig-2101-20261011    gcc-14     cocci
x86_64                randconfig-2101-20261012    clang-22   cocci
x86_64                randconfig-2102-20261011    gcc-14     cocci
x86_64                randconfig-2102-20261012    clang-22   cocci
x86_64                randconfig-2103-20261011    gcc-14     cocci
x86_64                randconfig-2103-20261012    clang-22   cocci
x86_64                randconfig-2104-20261011    clang-22   cocci
x86_64                randconfig-2104-20261011    gcc-14     cocci
x86_64                randconfig-2104-20261012    clang-22   cocci
x86_64                randconfig-2105-20261011    gcc-14     cocci
x86_64                randconfig-2105-20261012    clang-22   cocci
x86_64                randconfig-2200-20261011    clang-22   smatch
x86_64                randconfig-2200-20261012    gcc-14     smatch
x86_64                randconfig-2300-20261011    gcc-14     sparse
x86_64                randconfig-2300-20261012    gcc-14     sparse
x86_64                randconfig-2301-20261011    gcc-14     sparse
x86_64                randconfig-2301-20261012    gcc-14     sparse
x86_64                randconfig-2302-20261011    gcc-14     sparse
x86_64                randconfig-2302-20261012    gcc-14     sparse
x86_64               randconfig-r2104-20261012    gcc-10.5.0 cocci
x86_64               randconfig-r2105-20261012    gcc-10.5.0 cocci
x86_64               randconfig-r2107-20261011    clang-22   cocci
x86_64               randconfig-r2107-20261012    gcc-14     cocci
x86_64               randconfig-r2108-20261011    gcc-8.5.0  cocci
x86_64               randconfig-r2108-20261012    gcc-11.5.0 cocci
x86_64               randconfig-r2109-20261011    gcc-8.5.0  cocci
x86_64               randconfig-r2109-20261012    clang-20   cocci
x86_64               randconfig-r2300-20261011    gcc-14.3.0 sparse
x86_64               randconfig-r2304-20261012    clang-24   sparse
x86_64               randconfig-r2305-20261012    gcc-9.5.0  sparse
x86_64               randconfig-r2307-20261012    clang-22   sparse
x86_64               randconfig-r2308-20261012    clang-22   sparse
x86_64               randconfig-r2310-20261011    clang-22   sparse
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
xtensa                randconfig-1000-20261012    clang-20
xtensa                randconfig-1001-20261012    clang-20
xtensa                randconfig-2000-20261011    gcc-8.5.0
xtensa                randconfig-2000-20261012    gcc-8.5.0
xtensa                randconfig-2001-20261011    gcc-13.4.0
xtensa                randconfig-2001-20261011    gcc-8.5.0
xtensa                randconfig-2001-20261012    gcc-8.5.0
xtensa               randconfig-r2102-20261011    gcc-8.5.0  cocci
xtensa               randconfig-r2103-20261011    gcc-8.5.0  cocci
xtensa               randconfig-r2104-20261011    gcc-8.5.0  cocci
xtensa               randconfig-r2104-20261012    gcc-9.5.0  cocci
xtensa               randconfig-r2105-20261011    clang-22   cocci
xtensa               randconfig-r2110-20261011    clang-24   cocci
xtensa               randconfig-r2200-20261012    gcc-8.5.0  smatch
xtensa               randconfig-r2301-20261012    clang-24   sparse
xtensa               randconfig-r2301-20261012    gcc-9.5.0  sparse
xtensa               randconfig-r2303-20261012    clang-24   sparse
xtensa               randconfig-r2306-20261012    gcc-16.1.0 sparse
xtensa               randconfig-r2307-20261011    gcc-8.5.0  sparse
xtensa               randconfig-r2308-20261012    clang-22   sparse
xtensa                     xip_kc705_defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
