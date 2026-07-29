Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8237374E4C
	for <linux-rdma@vger.kernel.org>; Wed, 29 Jul 2026 06:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785307732; cv=none; b=XrsJN6k/TJ07XeWx2JkWRbxqCCIKV+GTcqzFslgZoW5TZBq/gDB/MTtvXbSO0HhrwA69OCPLcB28OIyR+ytBR8jteTDcZx32HLiCJk1z9Y40vyLQHWbhrV9YtvJqkQnSbMYH7lpivUOJBrm51hUEEnDeUrB4Sf/I80sRSGNGMpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785307732; c=relaxed/simple;
	bh=PPujbQyME4ORRVmPoiwLZUIGQpVGcEaIft94WP65aWU=;
	h=Date:From:To:Cc:Subject:Message-ID; b=YbFuxaH/5Jc7sOQyv3Xja59HZbYOQHwZ137DVtW58aSn5qZnSM5vpu0ESWR4YhK2y2i+jCMum96WAY1zHfpL3d5yOt8vWQFnCQLH2FvV7Z9EgSvMvo9WkWbIZMfSV/syboehoCYBt1BL/VyUzgGENqf43aP81enXON7HeO8q3+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iTgLWXP2; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iTgLWXP2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785307731; x=1816843731;
  h=date:from:to:cc:subject:message-id;
  bh=PPujbQyME4ORRVmPoiwLZUIGQpVGcEaIft94WP65aWU=;
  b=iTgLWXP2hokiz3e0Ntr/kUrEgIda3emB8pekngIEsNIPpRqcF2V3egbB
   fQzGFrzEwKtWwcYCwV92KuK5MYBrzf+VIf5/mBFVZT+drTenRaS8t2k3J
   FJpnXSiKI+gvAICa5J9XfSYcZw3LKhnrH46Yl23EwBQE9V9yyKesZZFAj
   RXqhGu431NrE5u62VvDsbW4MSUXv5O3FOaULyhG3C0vAK9zIr/ZLGMuWG
   YOsKQVYAByqJzP2M+UEyA+2lsionx2wwSrOnnKfjp11oVG5EuyvbAkClF
   M6H/skGVpi0UAoUEgkgcdmyybrBpl0ttS3CN2cN32xXEq/Lnqlls7jpCb
   Q==;
X-CSE-ConnectionGUID: NitMoj4IShCVCnBJf0p5MQ==
X-CSE-MsgGUID: +zWM5zzLRc67hwkwtmdarQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="89725179"
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="89725179"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2026 23:48:50 -0700
X-CSE-ConnectionGUID: AsC6S3FGS2mPP6EFuy8nRQ==
X-CSE-MsgGUID: SRsKPjErT0G3/JTB04g0iQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="259989986"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 28 Jul 2026 23:48:47 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1woy5s-00000000f7d-2BWj;
	Wed, 29 Jul 2026 06:48:44 +0000
Date: Wed, 29 Jul 2026 14:47:53 +0800
From: kernel test robot <lkp@intel.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [rdma:wip/leon-for-next] BUILD REGRESSION
 229b42d7450c1cf96f45ec39ebb69211b06bc036
Message-ID: <202607291423.o2jmTn8q-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git wip/leon-for-next
branch HEAD: 229b42d7450c1cf96f45ec39ebb69211b06bc036  RDMA/efa: Fix PBL chunk length computation

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/infiniband/hw/mthca/mthca_provider.c:946:1: internal compiler error: in final_scan_insn_1, at final.cc:2823

Error/Warning ids grouped by kconfigs:

recent_errors
`-- csky-allmodconfig
    `-- drivers-infiniband-hw-mthca-mthca_provider.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc

elapsed time: 1012m

configs tested: 22
configs skipped: 1

tested configs:
alpha                  allnoconfig    gcc-16.1.0
alpha                 allyesconfig    gcc-16.1.0
alpha                    defconfig    gcc-16.1.0
arc                   allmodconfig    gcc-16.1.0
arc                   allyesconfig    gcc-16.1.0
csky                  allmodconfig    gcc-16.1.0
hexagon             randconfig-001    clang-17
hexagon    randconfig-001-20260729    clang-21
hexagon    randconfig-002-20260729    clang-17
i386                  allmodconfig    gcc-14
loongarch                defconfig    clang-24
loongarch  randconfig-001-20260729    clang-19
loongarch  randconfig-002-20260729    gcc-13.4.0
nios2                 allmodconfig    gcc-11.5.0
nios2                  allnoconfig    gcc-11.5.0
nios2      randconfig-001-20260729    gcc-11.5.0
nios2      randconfig-002-20260729    gcc-9.5.0
parisc                allmodconfig    gcc-16.1.0
parisc                allyesconfig    gcc-16.1.0
parisc                   defconfig    gcc-16.1.0
powerpc       mpc866_ads_defconfig    clang-17
sh                       defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
