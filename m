Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFE9370AE2
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 05:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788844502; cv=none; b=Wje9TqsKkpjuNXBdjRbCUQYIXjLnG0rNzSlnGdDfTgQzYD4hm7iinshFT4gcbGh0cP55IU62q4lNX0PAB3RgjskmBHQ9xOzgAX2YOoH/rqtKcbgOW95HjvSxdLdDYJQcL95PCXKIiGJ+ehlayBxrYfe4BYX6BmrpGjd4B71D3mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788844502; c=relaxed/simple;
	bh=8lwFXFWbH9vYNCvnSqLZK1MnErvStEdtXP9qhTfMlBE=;
	h=Date:From:To:Cc:Subject:Message-ID; b=kJz33/ET+SqCCuOo1tkOj0ocrU6vtbI/mVi4AQ8KNUQ0swIMu42EFr4c0OCuyhWhRTUxeG+kBLU9DpeTt4yMxBvAsZMqHlfJgYlBY5v5+Qy5mbHjgPfdbO07ZeSjc5QK7Hj6NrjDRvlDR2yphrbWrXtPljgjBWHAJW0qo0CqaYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U0WdtrJl; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U0WdtrJl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788844501; x=1820380501;
  h=date:from:to:cc:subject:message-id;
  bh=8lwFXFWbH9vYNCvnSqLZK1MnErvStEdtXP9qhTfMlBE=;
  b=U0WdtrJl324KLqrVPKx84B0idhL6ARA8yjMGbajOlnav+0mRwE6ZnIXA
   qnSwByfSpHdiTjaEDBskr1hlia11CtZFu2NmHlFBB704PFHnwunVVzFG+
   1YXYE0MB3wpOFQKg1lgATpHg7d/a6+OaGKT/LjO6HwaRhMmp+5r97BuN3
   D84edObczoxonYrBWOPhLIXnmgJ5QnrhMLoPLavRkDqNs/QbiUkoDjnjv
   xVIUqoH2qFQS/dY6uIFt8bCyhp/TmkLw+dKTx9Z+GoBjaSj00svnMjbnY
   nTHyWYRUDBt5jRBXHOrARhOA7Y3shTsd3NXCIizLal7cGwc1+8f0mdZ3q
   Q==;
X-CSE-ConnectionGUID: ApbpgEwJTwChE/kgv8Jqyg==
X-CSE-MsgGUID: YiAp3MJMSiqUznIR2cS6FQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11899"; a="99896561"
X-IronPort-AV: E=Sophos;i="6.25,268,1779174000"; 
   d="scan'208";a="99896561"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2026 22:14:58 -0700
X-CSE-ConnectionGUID: BdhXaG8zQfqGL0PohDYDXg==
X-CSE-MsgGUID: Yjv3jJVJTB+IiRoaKWqtyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,268,1779174000"; 
   d="scan'208";a="266535127"
Received: from lkp-server01.sh.intel.com (HELO dff15f1b2031) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 07 Sep 2026 22:14:55 -0700
Received: from kbuild by dff15f1b2031 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x3oAX-000000001hT-0L4L;
	Tue, 08 Sep 2026 05:14:53 +0000
Date: Tue, 08 Sep 2026 13:14:22 +0800
From: kernel test robot <lkp@intel.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [rdma:wip:leon-for-rc] BUILD SUCCESS
 33fb59da49c4c3f5c2ec9f9d4447a56857a02c02
Message-ID: <202609081318.aIRiY3KQ-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git wip/leon-for-rc
branch HEAD: 33fb59da49c4c3f5c2ec9f9d4447a56857a02c02  RDMA/core: fix refcount bug in iwpm_get_nlmsg_request()

elapsed time: 1579m

configs tested: 71
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
nios2         allnoconfig    gcc-11.5.0
openrisc     allmodconfig    clang-20
openrisc      allnoconfig    clang-24
openrisc      allnoconfig    gcc-16.1.0
parisc       allmodconfig    gcc-16.1.0
parisc        allnoconfig    clang-24
parisc        allnoconfig    gcc-16.1.0
parisc       allyesconfig    clang-17
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    clang-24
powerpc       allnoconfig    gcc-16.1.0
riscv        allmodconfig    clang-24
riscv         allnoconfig    clang-24
riscv         allnoconfig    gcc-16.1.0
riscv        allyesconfig    clang-24
s390         allmodconfig    clang-17
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    clang-24
sh            allnoconfig    gcc-16.1.0
sh           allyesconfig    clang-17
sparc         allnoconfig    clang-24
sparc         allnoconfig    gcc-16.1.0
sparc64      allmodconfig    clang-20
um           allmodconfig    clang-17
um            allnoconfig    clang-17
um            allnoconfig    clang-24
um           allyesconfig    gcc-16.1.0
x86_64       allmodconfig    clang-22
x86_64        allnoconfig    clang-22
x86_64        allnoconfig    clang-24
x86_64       allyesconfig    clang-22
x86_64      rhel-9.4-rust    clang-22
xtensa        allnoconfig    clang-24
xtensa        allnoconfig    gcc-16.1.0
xtensa       allyesconfig    clang-20

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
