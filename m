Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0713E49DD
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 17:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654747; cv=none; b=oAyhxBl+Sct45rP/FjS/WcOhSRlLAu+WAepOzgaKEXou1TUZg+qHxB08KsNse8uKnwWoLikfTReNqznGpPnDzu/DG6C5jXw5ySCtBTXIFLZ2BORj4uQ+GJe3nDlYMHe6d15mnI8tMu1vHRQf006MQ1qssJvib/WaDMVR4gU1e4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654747; c=relaxed/simple;
	bh=ljg6pb9cjDDQp5XnvzHAPN5YDDXFehpoQBGlkpZwqfQ=;
	h=Date:From:To:Cc:Subject:Message-ID; b=PMZdifGeJy4y6pdiN7wARS5S3Y1b2OmAyuAnFkKt4o19ulH9H22ZFeM65QrB/07sWOPkUwbVkL8+CGx1oOZKJwA2/SNbh1MHDfku4sBzdLe27ivxQ3fPK/utBUKAQoPwIqj8SRzrljexD5KsAoMK6osacbTyQLI3d9DBGKtQegI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TcHqF8cJ; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TcHqF8cJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784654745; x=1816190745;
  h=date:from:to:cc:subject:message-id;
  bh=ljg6pb9cjDDQp5XnvzHAPN5YDDXFehpoQBGlkpZwqfQ=;
  b=TcHqF8cJANi/gRwXiBEVbLcGC9XHOAcf251H1urIOzJVLOKcG/rhFuSI
   ReUsjG8Kw4k3ACUoMXom14s+87rmyn1kJHi6EO3lWOGp/GDa0M19h0Dh7
   FxbztqYw5MLdZ2sv3GIxET8JY6Auv/DpGp+yQuZvy9NSkTQkcOut4Y3yb
   cKQa0VzeKhunIQtDdqRiep0iBO9V49g+h31EwGYFr06P4aLtXn2u/msUg
   7CeapoBcpzSDNENRkcObyThsTiAQCvOMDZk5yFeGMvyWNhE704LnXSoiS
   n5nMzpNkWI4icIUHDgzq/6h5opnArk5ck3cfED1FJNbZ1/zAQYG6KTU86
   Q==;
X-CSE-ConnectionGUID: dj1yM2EzS1mf5a5bp7oetQ==
X-CSE-MsgGUID: VySzT+AaRlOe4PPmZ3mFVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11853"; a="85027153"
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="85027153"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 10:25:44 -0700
X-CSE-ConnectionGUID: k6+k7Sb+RDOU34KSa+8Q/A==
X-CSE-MsgGUID: iq0dcJF3Qi6ryUZgC0PvlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="259803388"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 21 Jul 2026 10:25:43 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wmEDs-00000000Xmq-2Rq9;
	Tue, 21 Jul 2026 17:25:40 +0000
Date: Wed, 22 Jul 2026 01:24:48 +0800
From: kernel test robot <lkp@intel.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [rdma:for-next] BUILD SUCCESS
 28a06de7318fad1d0dec9bf54fe04243cc0635ff
Message-ID: <202607220134.vIYFQAOq-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git for-next
branch HEAD: 28a06de7318fad1d0dec9bf54fe04243cc0635ff  RDMA/ionic: Add robust udata compatibility checks to all uapi verbs

elapsed time: 1486m

configs tested: 105
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                           randconfig-001    gcc-8.5.0
arc                  randconfig-001-20260721    gcc-11.5.0
arc                  randconfig-002-20260721    gcc-13.4.0
arm                  randconfig-001-20260721    clang-17
arm                  randconfig-002-20260721    gcc-8.5.0
arm                  randconfig-003-20260721    gcc-13.4.0
arm                  randconfig-004-20260721    gcc-8.5.0
arm                        wpcm450_defconfig    gcc-16.1.0
arm64                randconfig-001-20260721    clang-17
arm64                randconfig-002-20260721    gcc-9.5.0
arm64                randconfig-003-20260721    gcc-8.5.0
arm64                randconfig-004-20260721    gcc-13.4.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260721    gcc-16.1.0
csky                 randconfig-002-20260721    gcc-11.5.0
hexagon              randconfig-001-20260721    clang-17
hexagon              randconfig-002-20260721    clang-17
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260721    gcc-14
i386       buildonly-randconfig-002-20260721    gcc-14
i386       buildonly-randconfig-003-20260721    clang-22
i386       buildonly-randconfig-004-20260721    clang-22
i386       buildonly-randconfig-005-20260721    gcc-14
i386       buildonly-randconfig-006-20260721    clang-22
i386                 randconfig-001-20260721    clang-22
i386                 randconfig-002-20260721    clang-22
i386                 randconfig-003-20260721    clang-22
i386                 randconfig-004-20260721    clang-22
i386                 randconfig-005-20260721    clang-22
i386                 randconfig-006-20260721    clang-22
i386                 randconfig-007-20260721    clang-22
i386                          randconfig-011    clang-22
i386                 randconfig-011-20260721    clang-22
i386                 randconfig-012-20260721    clang-22
i386                 randconfig-013-20260721    clang-22
i386                 randconfig-014-20260721    clang-22
i386                 randconfig-015-20260721    clang-22
i386                 randconfig-016-20260721    gcc-14
i386                 randconfig-017-20260721    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260721    gcc-15.2.0
loongarch            randconfig-002-20260721    clang-24
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260721    gcc-11.5.0
nios2                randconfig-002-20260721    gcc-8.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260721    gcc-8.5.0
parisc               randconfig-002-20260721    gcc-12.5.0
powerpc              randconfig-001-20260721    clang-24
powerpc              randconfig-002-20260721    clang-18
powerpc64            randconfig-001-20260721    gcc-11.5.0
powerpc64            randconfig-002-20260721    clang-24
riscv                         randconfig-001    gcc-13.4.0
riscv                randconfig-001-20260721    gcc-15.2.0
riscv                randconfig-002-20260721    clang-17
s390                 randconfig-001-20260721    clang-24
s390                 randconfig-002-20260721    clang-18
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260721    gcc-13.4.0
sh                   randconfig-002-20260721    gcc-11.5.0
sh                 sh7785lcr_32bit_defconfig    gcc-16.1.0
sparc                         randconfig-001    gcc-16.1.0
sparc                randconfig-001-20260721    gcc-16.1.0
sparc                randconfig-002-20260721    gcc-14.3.0
sparc64              randconfig-001-20260721    clang-24
sparc64              randconfig-001-20260722    gcc-11.5.0
sparc64              randconfig-002-20260721    clang-24
um                   randconfig-001-20260721    gcc-14
um                   randconfig-002-20260721    gcc-14
x86_64     buildonly-randconfig-001-20260721    gcc-14
x86_64     buildonly-randconfig-002-20260721    clang-22
x86_64     buildonly-randconfig-003-20260721    gcc-14
x86_64     buildonly-randconfig-004-20260721    clang-22
x86_64     buildonly-randconfig-005-20260721    clang-22
x86_64     buildonly-randconfig-006-20260721    gcc-14
x86_64                        randconfig-001    gcc-14
x86_64               randconfig-001-20260721    clang-22
x86_64               randconfig-002-20260721    clang-22
x86_64               randconfig-003-20260721    gcc-14
x86_64               randconfig-004-20260721    clang-22
x86_64               randconfig-005-20260721    clang-22
x86_64               randconfig-006-20260721    gcc-13
x86_64                        randconfig-011    gcc-14
x86_64               randconfig-011-20260721    clang-22
x86_64               randconfig-012-20260721    gcc-14
x86_64               randconfig-013-20260721    clang-22
x86_64               randconfig-014-20260721    clang-22
x86_64               randconfig-015-20260721    clang-22
x86_64               randconfig-016-20260721    clang-22
x86_64               randconfig-071-20260721    clang-22
x86_64               randconfig-072-20260721    gcc-14
x86_64               randconfig-073-20260721    gcc-14
x86_64               randconfig-074-20260721    clang-22
x86_64               randconfig-075-20260721    gcc-14
x86_64               randconfig-076-20260721    clang-22
xtensa               randconfig-001-20260721    gcc-12.5.0
xtensa               randconfig-002-20260721    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
