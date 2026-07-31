Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30342F3621
	for <linux-rdma@vger.kernel.org>; Fri, 31 Jul 2026 14:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785507325; cv=none; b=tqN/coiIA7kMNUgQufN49Br+iNE3GL5shw6N/uS0dHWOci3maQZ7q4HIjI1XAm2sfsHljhflAxzQWb/G8zsa9VsfECONacgsyBwz1k1ep0qeJ8hJsZkNVZKcZk2BD4q0ZKKrcY7zDLLRuCteKYaQ+9Zo3tS5RaNPh6nlA8uNv8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785507325; c=relaxed/simple;
	bh=cPqEZ+gqgB0Ce6K3lXHBufEYkEitYZ7bMzxJ0Hvf5X4=;
	h=Date:From:To:Cc:Subject:Message-ID; b=YJMSSnmKTFe8nKDQs0NnhLZjSV7+ANPKrWaMM/Y/fl7rnjmpMVMSScDgp8kpJ0mefYJlQWtaDBA7suqs58uJav/t9hYxJ0qVb94THZpXyrpH6XZXcrL7kU6VaEn26+7EvlVJ58U1FcgP0aqttSCwEmsiTfPMmeJQ/NsOki5z3TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GJgs1TLG; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GJgs1TLG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785507323; x=1817043323;
  h=date:from:to:cc:subject:message-id;
  bh=cPqEZ+gqgB0Ce6K3lXHBufEYkEitYZ7bMzxJ0Hvf5X4=;
  b=GJgs1TLGZnqGDfGHAAvVJo7otFpW+gyt1Wnn1fgC0xfFolkSYv9EfTBD
   L0n5msc9kZzkkLgaRgoutoT5OXcYhecF0RkdbGnmx0SgATtb2lwhnZjFq
   xRwe9bceTdoy//LzJtEO28h70a9WWXc+HjHZJk7/onhXCytK5A5v3ajAG
   /g+fcLBLohgmOBh9GevUc/1RoSOqck4JuM3A6jLc1q2P/ctTOM8ECT8bA
   wvho/9fgUMWTx0aVTvdG6mlXN3dVpnBD2vK2hwpXl3gWDCn4vYG1W1ZIH
   pRnjNlRYuWb1OpcB5OmhBvfGxxG1imqMYArUjV95HNb6BivITmy6IC6E7
   Q==;
X-CSE-ConnectionGUID: mjtg4tGiSnSj+7LyHkYT4w==
X-CSE-MsgGUID: ij75QXH+Qf284fVBxnw3WA==
X-IronPort-AV: E=McAfee;i="6800,10657,11861"; a="97290540"
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="97290540"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 07:15:23 -0700
X-CSE-ConnectionGUID: OxYr5DjXTE2tIqZKUJPLPQ==
X-CSE-MsgGUID: x1MOfp42QVmluwrC7jN4oQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="283920594"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 31 Jul 2026 07:15:22 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wpo19-000000001AF-1rzL;
	Fri, 31 Jul 2026 14:15:19 +0000
Date: Fri, 31 Jul 2026 22:14:37 +0800
From: kernel test robot <lkp@intel.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [rdma:wip/leon-for-next] BUILD REGRESSION
 43598807f71ac1c9164f26004acf2496d4038daf
Message-ID: <202607312223.dwI4RI4f-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git wip/leon-for-next
branch HEAD: 43598807f71ac1c9164f26004acf2496d4038daf  IB/mad: cleanup all kernel-doc comments

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/infiniband/hw/mthca/mthca_provider.c:946:1: internal compiler error: in final_scan_insn_1, at final.cc:2823

Error/Warning ids grouped by kconfigs:

recent_errors
`-- csky-allmodconfig
    `-- drivers-infiniband-hw-mthca-mthca_provider.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc

elapsed time: 799m

configs tested: 16
configs skipped: 1

tested configs:
alpha             allnoconfig    gcc-16.1.0
alpha            allyesconfig    gcc-16.1.0
alpha               defconfig    gcc-16.1.0
arc              allmodconfig    gcc-16.1.0
arc              allyesconfig    gcc-16.1.0
arc        nsim_700_defconfig    gcc-16.1.0
csky             allmodconfig    gcc-16.1.0
i386             allmodconfig    gcc-14
loongarch           defconfig    clang-24
nios2            allmodconfig    gcc-11.5.0
nios2             allnoconfig    gcc-11.5.0
parisc           allmodconfig    gcc-16.1.0
parisc           allyesconfig    gcc-16.1.0
parisc              defconfig    gcc-16.1.0
sh                  defconfig    gcc-16.1.0
sparc64          alldefconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
