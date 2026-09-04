Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5AC3B635B
	for <linux-rdma@vger.kernel.org>; Fri,  4 Sep 2026 23:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788562812; cv=none; b=qHaaQ/39eBFznqLsXuDo9c0gsosMwjqaJA2d0rZ9drUcbp9RZpTWgs8Cp47fXv2C3kGLXPjApIr1kd0S5tdGwhXn7VGMhDtB31zAvI9ZxIZ11ibB1YhGZrT86czDmW6oZHVVZMvf3Nf8wNm5EQI9g6v9I8ZGahfU2Ai0UOcXE00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788562812; c=relaxed/simple;
	bh=byQkFS346xcxD6ACrFeFRWtIELFIMMfEEHW0OqbcdwA=;
	h=Date:From:To:Cc:Subject:Message-ID; b=XiyMf+bzGKsgMHRUQcTZYTPtGMLoflZJFZZBw3T/kDGnLhMoTLc4c0B7MWaIySPRpDQEP2ORxchdv80oB3i3EHlvAGWoTUy0f45SXlYNd37bLV5mzygXRuf8PwefHN/rw2Y9pfNGi8mg9h/ZKoNT89OSYiKtdsdgx2r2OauKQvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S7imRAI9; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S7imRAI9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788562810; x=1820098810;
  h=date:from:to:cc:subject:message-id;
  bh=byQkFS346xcxD6ACrFeFRWtIELFIMMfEEHW0OqbcdwA=;
  b=S7imRAI95ociKGRRHzWxUH1sSVlEf2TXHUlg9VA27eZ/Wz+pOp39jYMW
   lvQfsxrtvbIzdIfi4BBIXmlnp3mJlAa8VkyXdk/vXEj6SvqMMmnPfu6Sr
   w8HLv4uNM8pjvDjY+M9vGWf8iJkz4ormiqUIeVV9fWE/cUZKeoXqWOsnp
   agRcdezpFHowuiH8y6xZRfDJP1cF03IXpwNNMbklGXqAQm8Qw+pe+24Ff
   kgSzr/J7NPWuc+xg1qHuT0F3gaJu3d3Iw0tO+SUG1dFLQ3DSmfLDyF7ZQ
   BJcil9C6m2qIbnIObjhFEW2SgD4FmrE206jeIQ5eE2OeqrqOj+ceLXre2
   A==;
X-CSE-ConnectionGUID: s66veHRQSwGlVaHE7FXPjg==
X-CSE-MsgGUID: IkAEtyFSTX6DBrIAvcnJgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11896"; a="88832355"
X-IronPort-AV: E=Sophos;i="6.25,262,1779174000"; 
   d="scan'208";a="88832355"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 16:00:09 -0700
X-CSE-ConnectionGUID: 3V83/fcwSrKSXzpupD+DMg==
X-CSE-MsgGUID: 1XDvdaNARmGpvFmhwAnSMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,262,1779174000"; 
   d="scan'208";a="270133075"
Received: from lkp-server01.sh.intel.com (HELO bfac249b2189) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 04 Sep 2026 16:00:07 -0700
Received: from kbuild by bfac249b2189 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x2ctA-00000000AEk-21CD;
	Fri, 04 Sep 2026 23:00:04 +0000
Date: Sat, 05 Sep 2026 06:59:09 +0800
From: kernel test robot <lkp@intel.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [rdma:for-rc] BUILD SUCCESS
 3fb905f07ea45b31c8f67ba6e4668de46f527e65
Message-ID: <202609050606.DRKKgVUA-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git for-rc
branch HEAD: 3fb905f07ea45b31c8f67ba6e4668de46f527e65  RDMA/irdma: Enforce local fence for IB_WR_REG_MR

elapsed time: 3250m

configs tested: 53
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
arc          allmodconfig    clang-24
arc           allnoconfig    gcc-16.1.0
arc          allyesconfig    clang-24
arm           allnoconfig    gcc-16.1.0
arm          allyesconfig    clang-24
arm64        allmodconfig    clang-24
arm64         allnoconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
csky          allnoconfig    gcc-16.1.0
hexagon      allmodconfig    gcc-16.1.0
hexagon       allnoconfig    gcc-16.1.0
i386         allmodconfig    clang-22
i386          allnoconfig    gcc-16.1.0
i386         allyesconfig    clang-22
loongarch    allmodconfig    clang-24
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
parisc       allyesconfig    gcc-16.1.0
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    clang-24
riscv        allmodconfig    clang-24
riscv         allnoconfig    clang-24
riscv        allyesconfig    clang-24
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    clang-24
sh           allyesconfig    gcc-16.1.0
sparc         allnoconfig    clang-24
sparc64      allmodconfig    clang-20
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
