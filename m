Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369E436F8E9
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 05:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788844500; cv=none; b=A6AbVR5lVKntrxmenUV3UJiPgHDQsUa/AgeL7gTq68nU70LoScnSydU63a2680Z7vkwHHF1bBYDiH5xbbP6iX7Zp0Qkps/viaMJdwpVnpVp4nOyPhWf+U8yxWoXRWFpBl0pE96urJfePzTBNw1GIUYPRgJlgZE9qA8r7UzfWKaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788844500; c=relaxed/simple;
	bh=7nx/QDw7IuhYmCflc7/54+U+Np7nd+LusI5l9umkXss=;
	h=Date:From:To:Cc:Subject:Message-ID; b=EoRpF2meo6zh1r5gZJTZDcEW5RqbTREDTvQQZ8wqklyRK3fl8HI+fiVmuO3cRZ5B0A9m8CvMDKRXfpwnZvOptBUSCzwsMAm/BQzvSoCbSGoILGfgjbgJmxU9ifqW8EqWXa+NYliA7byabA7/zAO+DvtdBJ5Nv1JfCOpXU4cPcCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eBT/TJCr; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eBT/TJCr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788844498; x=1820380498;
  h=date:from:to:cc:subject:message-id;
  bh=7nx/QDw7IuhYmCflc7/54+U+Np7nd+LusI5l9umkXss=;
  b=eBT/TJCrqaM8MggGJjV3xW3Ss77FxetdQPAGrIo8qUDwqNQ3/pUH4vmm
   UH1ismLEyB6syUwOO2UTMxKDzqVh+gooY+vMfgmMEsqYQq9kS8DLJHtzP
   Mj4pMdPN9SvLduw8KEr9dVGROLTRpc1SHWFRaEf4bIp+XNecHxw3f2KM9
   1A3MuUC2PhXllnlZvHmBsmIfMCKX1Hhen/7h+xndYph+XV8TbdSEuqyg4
   0TBNmTHPC8jxxUnqtJ/dajmawXKyQbkhajMz65rS+yGE1VvIFZVNZLRdJ
   bvwNMqz1hwOjsqCWkX/f4oY0NVs/99qCq1o/0JbFkH/GyjhR0zDjaUvLF
   w==;
X-CSE-ConnectionGUID: e9l4VsscSNaU9sdtPqY8ig==
X-CSE-MsgGUID: NOHqQG9OT7CkZBD0b5Ozdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11899"; a="99896557"
X-IronPort-AV: E=Sophos;i="6.25,268,1779174000"; 
   d="scan'208";a="99896557"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2026 22:14:58 -0700
X-CSE-ConnectionGUID: fvtOwshcRUmYc2pwR+JUIg==
X-CSE-MsgGUID: rPQPND9AT+Sj9fm87hdkAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,268,1779174000"; 
   d="scan'208";a="266535125"
Received: from lkp-server01.sh.intel.com (HELO dff15f1b2031) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 07 Sep 2026 22:14:55 -0700
Received: from kbuild by dff15f1b2031 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x3oAX-000000001hR-07Sc;
	Tue, 08 Sep 2026 05:14:53 +0000
Date: Tue, 08 Sep 2026 13:13:58 +0800
From: kernel test robot <lkp@intel.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [rdma:wip:leon-for-next] BUILD SUCCESS
 63367df6e7255067ad6a83abe0d2799dfa491876
Message-ID: <202609081341.2Rm20nHM-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git wip/leon-for-next
branch HEAD: 63367df6e7255067ad6a83abe0d2799dfa491876  ABI: sysfs-class-infiniband: Drop the entries of the removed qib driver

elapsed time: 1579m

configs tested: 61
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
arc          allmodconfig    clang-24
arc           allnoconfig    gcc-16.1.0
arc          allyesconfig    clang-24
arc          allyesconfig    gcc-16.1.0
arm           allnoconfig    clang-17
arm           allnoconfig    gcc-16.1.0
arm          allyesconfig    clang-24
arm64        allmodconfig    clang-24
arm64         allnoconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
csky          allnoconfig    gcc-16.1.0
hexagon      allmodconfig    gcc-16.1.0
hexagon       allnoconfig    clang-24
hexagon       allnoconfig    gcc-16.1.0
i386         allmodconfig    clang-22
i386          allnoconfig    gcc-14
i386          allnoconfig    gcc-16.1.0
i386         allyesconfig    clang-22
loongarch    allmodconfig    clang-19
loongarch    allmodconfig    clang-24
loongarch     allnoconfig    clang-20
loongarch     allnoconfig    gcc-16.1.0
m68k         allmodconfig    gcc-16.1.0
m68k          allnoconfig    gcc-16.1.0
m68k         allyesconfig    clang-24
microblaze    allnoconfig    gcc-16.1.0
microblaze   allyesconfig    gcc-16.1.0
mips         allmodconfig    gcc-16.1.0
mips          allnoconfig    gcc-16.1.0
mips         allyesconfig    gcc-16.1.0
nios2        allmodconfig    clang-20
nios2         allnoconfig    clang-24
openrisc     allmodconfig    clang-20
openrisc      allnoconfig    clang-24
parisc       allmodconfig    gcc-16.1.0
parisc        allnoconfig    clang-24
parisc       allyesconfig    clang-17
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    clang-24
riscv        allmodconfig    clang-24
riscv         allnoconfig    clang-24
riscv        allyesconfig    clang-24
s390         allmodconfig    clang-17
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    clang-24
sh           allyesconfig    clang-17
sparc         allnoconfig    clang-24
sparc64      allmodconfig    clang-20
um           allmodconfig    clang-17
um            allnoconfig    clang-24
um           allyesconfig    gcc-16.1.0
x86_64       allmodconfig    clang-22
x86_64        allnoconfig    clang-24
x86_64       allyesconfig    clang-22
x86_64      rhel-9.4-rust    clang-22
xtensa        allnoconfig    clang-24
xtensa       allyesconfig    clang-20

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
