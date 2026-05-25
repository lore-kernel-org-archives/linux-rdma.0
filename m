Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C372731A046
	for <linux-rdma@vger.kernel.org>; Mon, 25 May 2026 16:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779725114; cv=none; b=JZWuCUXzP7QRJdetSliLRvjFZb7ay+9sY0sn6QixuqnwD7PdnpXqp6R9VkBbhQBPauEVBQzgBBAtjTPOfg7tFMryxx6MUdJqld+0zDoD0pwZQ7NLJe1s64HWWS1VisaRN5V23qLF6Dlr9YgGBOX5IP0qxNMJjl8zdJbGLA+9KMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779725114; c=relaxed/simple;
	bh=84RmsC+/7GWaJ453Oa18VWq201D3brH872paynOh3Gs=;
	h=Date:From:To:Cc:Subject:Message-ID; b=iQ1oQil0veAb1ri9/argrOg3mGE3x+zX/AgS91eo3wOOXVpVKSpXY90VE+5l33PIw5vQ4eCB/TpE2arA0cnIb+lahOT10LUczx2L/RoX+dzgyrfaGDXPTygyxtiGuN1dwiWCzUiLPlcj+7+qgdONNYiP05CCovMjlocfDmLYbMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kOdQvacl; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kOdQvacl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779725113; x=1811261113;
  h=date:from:to:cc:subject:message-id;
  bh=84RmsC+/7GWaJ453Oa18VWq201D3brH872paynOh3Gs=;
  b=kOdQvaclDjmBG6FlFKAxGb2LCQw/nIl84A/YdAKaEkSduLs917NyH9tW
   lkKANI1+77ZWbwdP8ZKKSTwHIhN0XhrKRcJQM36EvUxP0FUYoza/VLwCx
   u9a0cAfLFjnglumVmN4ab9ukSmzUiD+1KzSvcONUSZCsiXd35tkxWPDRg
   cRCKwrtbRAcZnzxqT04Ha7/gV8W/fI6ZsHb2MH7Ah1ZSpx4O7gi0ODOc3
   XCCGK1dxjnr9NDjVjgN6FSjVpehB7FAHrFbeH/fKqGofi5mVi04XKOOjn
   j1aD2SibuneLGuychy/XRDSiYhWLf6zs5Q3d4fsf6kB+4WLQKpNpbdR+O
   g==;
X-CSE-ConnectionGUID: qqdMRe8TSQGQXFx+ydGrmA==
X-CSE-MsgGUID: oFMjmYTqQCee4EqL/1S72A==
X-IronPort-AV: E=McAfee;i="6800,10657,11797"; a="80580006"
X-IronPort-AV: E=Sophos;i="6.24,168,1774335600"; 
   d="scan'208";a="80580006"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2026 09:05:12 -0700
X-CSE-ConnectionGUID: oFOtF18uTTGyV8p3XQ4tYg==
X-CSE-MsgGUID: Szuxf0MfT9aRAJGb8C1fsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,168,1774335600"; 
   d="scan'208";a="241497099"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 25 May 2026 09:05:11 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wRXnf-000000001ba-3JWe;
	Mon, 25 May 2026 16:05:07 +0000
Date: Tue, 26 May 2026 00:04:55 +0800
From: kernel test robot <lkp@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Subject: [rdma:wip/jgg-for-next] BUILD SUCCESS
 d28654518c8db5d06d27bd3211c0e9a70c18f7c2
Message-ID: <202605260044.F8oudIi7-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git wip/jgg-for-next
branch HEAD: d28654518c8db5d06d27bd3211c0e9a70c18f7c2  RDMA/mana_ib: Use ib_get_eth_speed for reporting port speed

elapsed time: 1159m

configs tested: 54
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                   allnoconfig    gcc-15.2.0
alpha                  allyesconfig    gcc-15.2.0
arc                    allmodconfig    gcc-15.2.0
arc                     allnoconfig    gcc-15.2.0
arc                    allyesconfig    gcc-15.2.0
arm                     allnoconfig    clang-23
arm                    allyesconfig    gcc-15.2.0
arm64                  allmodconfig    clang-19
arm64                   allnoconfig    gcc-15.2.0
csky                   allmodconfig    gcc-15.2.0
csky                    allnoconfig    gcc-15.2.0
hexagon                allmodconfig    clang-17
hexagon                 allnoconfig    clang-23
i386                   allmodconfig    gcc-14
i386                    allnoconfig    gcc-14
i386                   allyesconfig    gcc-14
loongarch              allmodconfig    clang-19
loongarch               allnoconfig    clang-23
m68k                   allmodconfig    gcc-15.2.0
m68k                    allnoconfig    gcc-15.2.0
m68k                   allyesconfig    gcc-15.2.0
microblaze              allnoconfig    gcc-15.2.0
microblaze             allyesconfig    gcc-15.2.0
mips                   allmodconfig    gcc-15.2.0
mips                    allnoconfig    gcc-15.2.0
mips                   allyesconfig    gcc-15.2.0
nios2                  allmodconfig    gcc-11.5.0
nios2                   allnoconfig    gcc-11.5.0
openrisc               allmodconfig    gcc-15.2.0
openrisc                allnoconfig    gcc-15.2.0
parisc                 allmodconfig    gcc-15.2.0
parisc                  allnoconfig    gcc-15.2.0
parisc                 allyesconfig    gcc-15.2.0
parisc      randconfig-001-20260525    gcc-14.3.0
parisc      randconfig-002-20260525    gcc-14.3.0
powerpc                allmodconfig    gcc-15.2.0
powerpc                 allnoconfig    gcc-15.2.0
riscv                  allmodconfig    clang-23
riscv                   allnoconfig    gcc-15.2.0
riscv                  allyesconfig    clang-16
s390                    allnoconfig    clang-23
s390                   allyesconfig    gcc-15.2.0
sh                     allmodconfig    gcc-15.2.0
sh                      allnoconfig    gcc-15.2.0
sh                     allyesconfig    gcc-15.2.0
sparc                   allnoconfig    gcc-15.2.0
sparc64                allmodconfig    clang-23
um                      allnoconfig    clang-23
um                     allyesconfig    gcc-14
x86_64                 allmodconfig    clang-20
x86_64                  allnoconfig    clang-20
x86_64                 allyesconfig    clang-20
x86_64                rhel-9.4-rust    clang-20
xtensa                  allnoconfig    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
