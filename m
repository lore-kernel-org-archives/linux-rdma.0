Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A983CB54A
	for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 01:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786671422; cv=none; b=ix2kopJ7HKUVVHbpr+Pt++8m9FVt+0DziYaJlV+0IKNVN/SD03wpbAUJtWI/ix6yqEaKKEX2dSz+Ak7sVunRuVTzH/jBG+AD3XyB5KAJG451MwBzOhTHQq7LZmsRgtp3hSYacYCGU/Gihekari4tTEznt8iOswvFPaWC8MDxvaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786671422; c=relaxed/simple;
	bh=0Rou/TSqdWOtTy2UVI9G4EwSvXCYpStzS0yYuAQQwVg=;
	h=Date:From:To:Cc:Subject:Message-ID; b=d29tRIJv2wLjJaxT/rSx8ZUR0nUdYis2UPIxJXrbe+p6ttggdPtxhCW0ITbfZ74E33Uh6zwuKn+iJugdAw/3sqYljalCskbwa2GkFt10yUis46QxcSipaEcxzp1sPvqhpJ6P6I+hl47ElWeJ+QEdbxOL5Tcsw7utvV0Y9EJHwWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=azbOq+YO; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="azbOq+YO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786671420; x=1818207420;
  h=date:from:to:cc:subject:message-id;
  bh=0Rou/TSqdWOtTy2UVI9G4EwSvXCYpStzS0yYuAQQwVg=;
  b=azbOq+YOWIkLvT+Z0tlppx6jtNAPAnhLKFsqaazQeZqgeB7537/fbIC6
   TE4Llfq8UZksDzVkLTu5R5rYKk5N4YCSphHrOFFB6azu6ZPsGxxfCKQSx
   sUdzAuDp8v2cNdiUFx+GrV5ERtFltSl39e0YRbIkaGFup3MadBgAhq+2l
   LeB7vbHsk7zbCkti6/6aSSIP2zmsl3L2KgiFqv7z7TJAvwVYQhxQS43Gz
   B/xxux+m3WEi3kV0Lq43Ed91vATZyrnSZvq4EF+/5KXCWDG+1REIzs3kD
   Dp1ELztQ6RfycNfU8xHY8r82Dn1h/PKI007yYUwrOPoi1pJUANvk64uxy
   w==;
X-CSE-ConnectionGUID: ofMAuy9kQT6Z78P8Xla0Rg==
X-CSE-MsgGUID: SRkZX/nOTES3jzF9OA71IA==
X-IronPort-AV: E=McAfee;i="6800,10657,11874"; a="98611137"
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="98611137"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 18:36:51 -0700
X-CSE-ConnectionGUID: cfRTUaV2QrClYzh2qARjIw==
X-CSE-MsgGUID: WQy4ACNOSUOkaJ2AykD37Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="268362503"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 13 Aug 2026 18:36:47 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wugqi-00000000XKE-392H;
	Fri, 14 Aug 2026 01:36:44 +0000
Date: Fri, 14 Aug 2026 09:36:16 +0800
From: kernel test robot <lkp@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Subject: [rdma:for-next] BUILD SUCCESS
 d87924b995ab6d33e1c102a705837afdb8fff618
Message-ID: <202608140904.amsXuQ3x-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git for-next
branch HEAD: d87924b995ab6d33e1c102a705837afdb8fff618  RDMA/efa: Add support for 128B admin v2 SQ entry

elapsed time: 768m

configs tested: 16
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
alpha           defconfig    gcc-16.1.0
arc          allmodconfig    gcc-16.1.0
arc          allyesconfig    gcc-16.1.0
arc        hsdk_defconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
i386         allmodconfig    gcc-14
loongarch       defconfig    clang-24
nios2        allmodconfig    gcc-11.5.0
nios2         allnoconfig    gcc-11.5.0
parisc       allmodconfig    gcc-16.1.0
parisc       allyesconfig    gcc-16.1.0
parisc          defconfig    gcc-16.1.0
sh              defconfig    gcc-16.1.0
x86_64              kexec    clang-22

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
