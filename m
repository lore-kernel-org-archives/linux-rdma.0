Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B63F423E9A
	for <linux-rdma@vger.kernel.org>; Tue, 28 Jul 2026 10:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785235668; cv=none; b=qyiiA1ipFcwpIfReIDul9kc1qHsz6c9NlUN7qdt2jzyGVc0nl9UyHAslJw4j5B0qOsGPs6O9izE83FFgDVo0DISObvdr9mKM7q/J7iMjKR+U9BeLaT58x6s8V8OlB+fQ3GntoU600FbXRu7cDQLoSdqLUd32lU+16gTUhzbdMNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785235668; c=relaxed/simple;
	bh=GYdjdOeB4gjSzA8hQv5GyOACOFUxIUcw9F0IJygXN3c=;
	h=Date:From:To:Cc:Subject:Message-ID; b=Q6qfJhwwSWnBeqVcJudHU1uMJ/nXTzk1Sf1a053n3kSX68ABEoFrVapoISfy1friBwE8Rfev5QXIPtF3JjQBp79AWDXKQ94RlE3MlwSvfciocspXW3X8mUZoNAOrn0Sb+yEXmazPTP58CBnimlpqzGh5iVDPLVwOiQWsVUCWs6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RTo1djWS; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RTo1djWS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785235666; x=1816771666;
  h=date:from:to:cc:subject:message-id;
  bh=GYdjdOeB4gjSzA8hQv5GyOACOFUxIUcw9F0IJygXN3c=;
  b=RTo1djWSzxGr+ec0yViuKqma3PxCI23Zv19Ec/hS41hmkiYif0wtWDf3
   YFxOV+I1ilv7ItXvKDbY+hqwwZy3HZGpcLsURA0Kq+VOxLfXn0hDDssHz
   LEZgheM/5xx/BmTaqhGOvEZEAA56zuT3ZVv1C0epgJTqexXx4wyVOOdB5
   kinlCFnnVRUWQ47fcvEdobaiOq6w0fahjodY7iPQ/oC/zlDGiFUCTQo+S
   fmqCMAHTMbmxAl2CxUyUVVKkss9fz7k/SxV9Nj01TCO5Y1FzWY7V3MRR/
   VU5g76h1kvm505Pj/Gb/XJJlAEH+BZ7Oq4jbZEjzy5p1FHgqdLqm0j3wN
   g==;
X-CSE-ConnectionGUID: 4Bsf3K/eS+S1ii5ozW74zg==
X-CSE-MsgGUID: 1/AmIcJlTcuUPtkuc7hrnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11858"; a="96970497"
X-IronPort-AV: E=Sophos;i="6.25,190,1779174000"; 
   d="scan'208";a="96970497"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2026 03:47:45 -0700
X-CSE-ConnectionGUID: k3i/nlISSm2x6IMfOgCKPg==
X-CSE-MsgGUID: 8H/gbLSrQau+bO6JGHcO3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,190,1779174000"; 
   d="scan'208";a="261645882"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 28 Jul 2026 03:47:44 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wofLZ-00000000eGF-00iv;
	Tue, 28 Jul 2026 10:47:41 +0000
Date: Tue, 28 Jul 2026 18:47:32 +0800
From: kernel test robot <lkp@intel.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [rdma:wip/leon-for-next] BUILD SUCCESS
 983c450ae26317c58b62cac5afa58725ada7d256
Message-ID: <202607281817.lORPYssQ-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git wip/leon-for-next
branch HEAD: 983c450ae26317c58b62cac5afa58725ada7d256  RDMA/efa: Fix PBL chunk length computation

elapsed time: 822m

configs tested: 23
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                  allnoconfig    gcc-16.1.0
alpha                 allyesconfig    gcc-16.1.0
alpha                    defconfig    gcc-16.1.0
arc                   allmodconfig    gcc-16.1.0
arc                   allyesconfig    gcc-16.1.0
arm             mvebu_v5_defconfig    gcc-16.1.0
csky                  allmodconfig    gcc-16.1.0
i386                  allmodconfig    gcc-14
loongarch                defconfig    clang-24
nios2                 allmodconfig    gcc-11.5.0
nios2                  allnoconfig    gcc-11.5.0
parisc                allmodconfig    gcc-16.1.0
parisc                allyesconfig    gcc-16.1.0
parisc                   defconfig    gcc-16.1.0
sh                       defconfig    gcc-16.1.0
sparc      randconfig-001-20260728    gcc-13.4.0
sparc      randconfig-002-20260728    gcc-8.5.0
sparc64    randconfig-001-20260728    gcc-13.4.0
sparc64    randconfig-002-20260728    gcc-8.5.0
um         randconfig-001-20260728    clang-24
um         randconfig-002-20260728    clang-24
xtensa     randconfig-001-20260728    gcc-8.5.0
xtensa     randconfig-002-20260728    gcc-11.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
