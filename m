Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66393D333E
	for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 01:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786671427; cv=none; b=TqrT6XG7v6hP3yopVMOV8Yfok8m2d4GCn1vJ6EQl1n24nI4ukkcg5dJwTYxe0t3qWv4wwOXSx3EBePtLin4avPRMrocMRPR7j+whK0+fqSqRtNbF/3k2Ii8Ch+JkojFGxaaqYhyn6+ZG1k/aXLuQvU5QVtoGw9IZzRSmeEsLIo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786671427; c=relaxed/simple;
	bh=hh4fHt8z/njeLfQ0+k9Ub6Ly+y3gNyyDq4jKliyLgDA=;
	h=Date:From:To:Cc:Subject:Message-ID; b=EGyYNSUUpMs8p/qy1ZMJtbFMy4e930FvjAwBxL9PyhNuGwQgcCdDH3gK0yRd42in991adIE1j6/7QMOtL3n4Hkb1hS81ZKO23K7OrGiuVVQACiSVjLtK0Uik3Kp9lpZ4o18ZAAuwt8+1E4fzJCYPGd7vfvIsRCgSJRV5gOYgkQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Df9KGJz1; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Df9KGJz1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786671424; x=1818207424;
  h=date:from:to:cc:subject:message-id;
  bh=hh4fHt8z/njeLfQ0+k9Ub6Ly+y3gNyyDq4jKliyLgDA=;
  b=Df9KGJz1C6ZcAuBPpWwTE/Tq0snsT5Po/BF+PB/kDKjexxc8tl6oJMmc
   /UzZcBzTtGeRqSHhBbUWCvGy5Qq+p5esTKwd6ngD+D264OGSzDFl2azA/
   Rb8zBjYEVAgOTj9R8ebclwML1xCzDXXy1nh7idSzID4Ct/vxCHAGB2RD5
   Vs4Fs6PT4SoVtAqItclrIysZsboXIcj3tHWqID+LwvnznqM2/zHNsoCp2
   vu2JRSnajZBPKSABm1i7MtnVebrA4usNzDqn8AexDroXsXW7faDmV4ObR
   5oybbtKYLIHSNX4YW79plsVo6bNwWksDu4acbcZeFE7d7wb+luMsr4FbJ
   Q==;
X-CSE-ConnectionGUID: DKu4dF8eQYGXbGxmrpSAHA==
X-CSE-MsgGUID: HZkNVgvkQseZ4rOcMM19Ww==
X-IronPort-AV: E=McAfee;i="6800,10657,11874"; a="98611154"
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="98611154"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 18:36:51 -0700
X-CSE-ConnectionGUID: T+NPcwEoQriVCE3IgicD9g==
X-CSE-MsgGUID: hjenLb+bTqCXwdsxl+pKaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="268362506"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 13 Aug 2026 18:36:47 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wugqi-00000000XKG-3YS2;
	Fri, 14 Aug 2026 01:36:44 +0000
Date: Fri, 14 Aug 2026 09:36:37 +0800
From: kernel test robot <lkp@intel.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [rdma:wip/leon-for-next] BUILD REGRESSION
 c9085ec66448094d7863a80c4633954bdd1f1e4e
Message-ID: <202608140923.gmPYKSVT-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git wip/leon-for-next
branch HEAD: c9085ec66448094d7863a80c4633954bdd1f1e4e  RDMA/ucma: Allow path records to exactly fit the output buffer

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/infiniband/hw/cxgb4/mem.c:584:1: internal compiler error: in final_scan_insn_1, at final.cc:2823
    drivers/infiniband/hw/mthca/mthca_provider.c:946:1: internal compiler error: in final_scan_insn_1, at final.cc:2823

Error/Warning ids grouped by kconfigs:

recent_errors
`-- csky-allmodconfig
    |-- drivers-infiniband-hw-cxgb4-mem.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
    `-- drivers-infiniband-hw-mthca-mthca_provider.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc

elapsed time: 769m

configs tested: 15
configs skipped: 0

tested configs:
alpha             allnoconfig    gcc-16.1.0
alpha            allyesconfig    gcc-16.1.0
alpha               defconfig    gcc-16.1.0
arc              allmodconfig    gcc-16.1.0
arc              allyesconfig    gcc-16.1.0
csky             allmodconfig    gcc-16.1.0
i386             allmodconfig    gcc-14
loongarch           defconfig    clang-24
nios2            allmodconfig    gcc-11.5.0
nios2             allnoconfig    gcc-11.5.0
parisc           allmodconfig    gcc-16.1.0
parisc           allyesconfig    gcc-16.1.0
parisc              defconfig    gcc-16.1.0
sh         ap325rxa_defconfig    gcc-16.1.0
sh                  defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
