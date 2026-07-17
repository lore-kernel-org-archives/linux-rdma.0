Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE913DD525
	for <linux-rdma@vger.kernel.org>; Fri, 17 Jul 2026 11:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784286274; cv=none; b=g4CpF8QQPNxUD1c+tpaM3Nc2QNskdJH0xbSlTbVEC6AitxFSVGP3rRXnh1k4YNssjU1bdfef9s7X8gUlUky+urUBRs3FI25Jd+4dNq52+V955AR0PJT08UyWShjVUz9VtfnUWLxkkpM1p4Tv7RH//YOcLc7Xn7CLdhJX5o13tyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784286274; c=relaxed/simple;
	bh=0+DFrTuFElXxDGGuOCsjlXbyfigMk5A+r3bWyZaBXeQ=;
	h=Date:From:To:Cc:Subject:Message-ID; b=KxtwXCnDTQSRLYIiHXzrIJk0RNhLHI3wgZD6aqaQnF9bVD37fET0WhG07A+i2gzvXoU/MicKaTm5oeH0AyWWjiTm1RaDNxNKBghYKi1xzR21t1Wnn4uUljblu5RLcKMVjHGv4wN5NyaUixdWtGXLU+Sdtxj+5nYNbSN6IHXLPmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JTpeD4S5; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JTpeD4S5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784286265; x=1815822265;
  h=date:from:to:cc:subject:message-id;
  bh=0+DFrTuFElXxDGGuOCsjlXbyfigMk5A+r3bWyZaBXeQ=;
  b=JTpeD4S54dYV4ctPK8ojVjYiRm/JPoFRoM12Vo2zDJpjnfz9UvLIxrET
   itPdl3/BIOl7AyLfko49QuJe0Nm9Zy/GXlMh/ovw84vNoQKdeZ2cEAWzf
   m2WYF/IvmD3qjJTwJckmAQKwI3qzVDdr+V2mf9u7pEmJ76hERYEeguZk7
   Dlt8MwbQNH0saXuoFqSO7NBJh6PzWJPKHj/lstSmzR/ppTf13OsaLQu0s
   M6x1FNLIJoWYiULA72XcnGCGJmkc3vasoD52AtOaLie/sftIRu4YMXbYO
   HEPykhRM8L7Ev37iktn/sVJffPtDaPZMBIVjXYc6XHI7srAn1lgDztUwU
   w==;
X-CSE-ConnectionGUID: YMAN8rTGT0WOLoNDAIVtZQ==
X-CSE-MsgGUID: 4IRKRHEmQLatn4t5/2AeQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="84834135"
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="84834135"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 04:04:20 -0700
X-CSE-ConnectionGUID: ck+bbC18RfqQGcZIpX3JpA==
X-CSE-MsgGUID: txic0AQcRkCMkCuH7r2LEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="254126169"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 17 Jul 2026 04:04:18 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wkgMa-00000000Sf6-0pVN;
	Fri, 17 Jul 2026 11:04:16 +0000
Date: Fri, 17 Jul 2026 19:03:25 +0800
From: kernel test robot <lkp@intel.com>
To: Leon Romanovsky <leonro@nvidia.com>
Cc: Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [rdma:wip/leon-for-next] BUILD SUCCESS
 dab886bc4fab45b84d893aea81a86074a57d848b
Message-ID: <202607171910.ViEauuUt-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git wip/leon-for-next
branch HEAD: dab886bc4fab45b84d893aea81a86074a57d848b  RDMA/mana_ib: Adopt robust udata

elapsed time: 876m

configs tested: 17
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                  allnoconfig    gcc-16.1.0
alpha                 allyesconfig    gcc-16.1.0
alpha                    defconfig    gcc-16.1.0
arc                   allmodconfig    gcc-16.1.0
arc                   allyesconfig    gcc-16.1.0
csky                  allmodconfig    gcc-16.1.0
i386                  allmodconfig    gcc-14
i386       randconfig-006-20260717    gcc-14
loongarch                defconfig    clang-24
loongarch  randconfig-002-20260717    clang-24
nios2                 allmodconfig    gcc-11.5.0
nios2                  allnoconfig    gcc-11.5.0
parisc                allmodconfig    gcc-16.1.0
parisc                allyesconfig    gcc-16.1.0
parisc                   defconfig    gcc-16.1.0
sh                       defconfig    gcc-16.1.0
xtensa       audio_kc705_defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
