Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794932933;
	b=RJpOGtryyqHMWKnvIux71RzUazCY+aLtIkSlm7Msr/XDHzZNdcUs1DgTwNd/mtVAnmzt
	 MpFPDhzTGxJ+sCwdyqStNOBEPz+05Q96ihFpquikaYEi30RubVdzhNPqFpwGM05EB8LGZ
	 62H9GM5dgdmq/36DlESi7ja4DX06DrNKVdFfytbIfhGMn/f/NL9uKNDRUBojYj0Lj4pOg
	 I1aqgHsQX+GxXmeGH9nKXXoPr4yYAcgIl6vpGXPQ80eJRIwGn5EVaDF1NPqGQ7vXvNpru
	 QvmdPbQjLlMYA20rKYMUUMCpwMOguSIAJsCs9Vry6yBmFq3DjRFGr4oDotry8Exh7nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794932933;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=aRzzgfWfSvK9ZmrQDI05ghDsAV44Gh7D8UcpNBpE68A=;
	b=GCYPoH2roqr5bVOxXzVF4Pe+xgt28cagtLCev13G3aEuXTEdfT7d6+GSrmuQuMMSbAsF
	 jyf+mnPyRfpB/mzlxwaQq/DhhQu/NDV8nDUJPPWS4pA7eev7j+sOtho3aBxGKSfSZZN1b
	 jkdSxEDRaPQUPNYUNCjWQYpxPYGkeGLEw2kxsjFz6fg8QhsOsfMHWrHAi4sZ6lkViQUMb
	 TNtgMUrWsi5NCbo06ZmEg6EscVi00PihnDq5pfBWsJlP3zQHEopUe0ja54uogwRTCzuAh
	 xlG6F/fiIoA3mhoCYUuZpHQpfAfdAi93HDD9QZe6DgTmh/+vonm2B0AVK96p5+Uomvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="R/tyrjB8";
	arc=none smtp.remote-ip=198.175.65.17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4837606A32A
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 16:28:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4837606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=R/tyrjB8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794932933; x=1826468933;
  h=date:from:to:cc:subject:message-id;
  bh=7LmW6IeX3jc2UDla3JQb2dIDihWwNXpQE9nYWyZ8xTA=;
  b=R/tyrjB8UKA7FfA4UC+EgYc5gDZKMXr2OaWKvDexIJdM1HTbDHtaaxxl
   xscYq5i+fgrlITk4V7Pe3wiFpL48qnYdI+czK03/x5e9F1491VANuL0y6
   i+sFsVCwJ3VFZPlaeno/zhIiS04G03dvKfyb9pWR6hrq7Mv3dQs73zlqT
   91OHP6ZEyXuDMQ1eWZkl4TV0d78Qq/HxNlX5B4ewRtNn+QPbsj/UP27Wb
   r/pm16xa9qzXTJNWJ8j95JiJS/EL48IOWop0teJVksaf1RUimSV6INfBR
   3FeSgb6iTeRJrqU12mIK11f4w9KrQVESGXzCLqnOd7tF8o7nQgziiIsf9
   g==;
X-CSE-ConnectionGUID: qVyUbrafQ2ew91ZzeOkl6g==
X-CSE-MsgGUID: tqhSSULrQqqD1pLIhQ2KqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11969"; a="3729495"
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="3729495"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2026 08:28:52 -0800
X-CSE-ConnectionGUID: APj31Y8FQAO36QW0Ddp9LA==
X-CSE-MsgGUID: 9c/mxcStTk2g3UT5cAxAYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="9657272"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 17 Nov 2026 08:28:51 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xTM36-00000001C0b-2gJ0;
	Tue, 17 Nov 2026 16:28:48 +0000
Date: Wed, 18 Nov 2026 00:28:18 +0800
From: kernel test robot <lkp@intel.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [rdma:wip:leon-for-next] BUILD REGRESSION
 586be88310461aaded66e16c5579e384dde494b5
Message-ID: <20261118002818.qdRbNTPq-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git wip/leon-for-next
branch HEAD: 586be88310461aaded66e16c5579e384dde494b5  RDMA/ionic: use the v2 atomic send WQE layout

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202611162132.pYyZA0UN-lkp@intel.com

    drivers/infiniband/hw/mlx5/dm.c:217:11: error: no member named 'base' in 'struct mlx5_ib_dm'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- loongarch-allmodconfig
|   `-- drivers-infiniband-hw-mlx5-dm.c:error:no-member-named-base-in-struct-mlx5_ib_dm
`-- loongarch-allyesconfig
    `-- drivers-infiniband-hw-mlx5-dm.c:error:no-member-named-base-in-struct-mlx5_ib_dm

elapsed time: 1535m

configs tested: 53
configs skipped: 0

tested configs:
alpha       randconfig-2000-20261116    gcc-8.5.0
alpha       randconfig-2001-20261116    gcc-15.3.0
alpha       randconfig-2200-20261116    gcc-15.3.0 smatch
arc         randconfig-2200-20261116    gcc-15.3.0 smatch
arm         randconfig-2000-20261116    gcc-15.3.0
arm         randconfig-2001-20261116    clang-24
arm         randconfig-2002-20261116    gcc-8.5.0
arm64       randconfig-2000-20261116    gcc-8.5.0
arm64       randconfig-2001-20261116    clang-18
arm64       randconfig-2002-20261116    gcc-14.4.0
hexagon     randconfig-2200-20261116    clang-17   smatch
i386        randconfig-2200-20261116    gcc-14     smatch
loongarch   randconfig-2000-20261116    clang-24
loongarch   randconfig-2001-20261116    clang-24
loongarch   randconfig-2200-20261116    clang-19   smatch
m68k        randconfig-2000-20261116    gcc-12.5.0
m68k        randconfig-2001-20261116    gcc-10.5.0
microblaze  randconfig-2000-20261116    gcc-8.5.0
microblaze  randconfig-2001-20261116    gcc-15.3.0
nios2       randconfig-2000-20261116    gcc-11.5.0
nios2       randconfig-2001-20261116    gcc-11.5.0
nios2       randconfig-2200-20261116    gcc-11.5.0 smatch
openrisc    randconfig-2200-20261116    gcc-15.3.0 smatch
parisc      randconfig-2000-20261116    gcc-15.3.0
parisc      randconfig-2001-20261116    gcc-9.5.0
riscv       randconfig-2000-20261116    gcc-8.5.0
riscv       randconfig-2001-20261116    clang-24
riscv       randconfig-2002-20261116    gcc-16.2.0
riscv       randconfig-2003-20261116    clang-20
riscv       randconfig-2004-20261116    clang-24
riscv       randconfig-2005-20261116    clang-18
riscv       randconfig-2200-20261116    clang-24   smatch
s390        randconfig-2000-20261116    clang-17
s390        randconfig-2001-20261116    clang-24
s390        randconfig-2002-20261116    gcc-12.5.0
s390        randconfig-2003-20261116    gcc-8.5.0
s390        randconfig-2004-20261116    gcc-12.5.0
s390        randconfig-2005-20261116    clang-17
s390        randconfig-2200-20261116    gcc-10.5.0 smatch
sparc       randconfig-2000-20261116    gcc-16.2.0
sparc       randconfig-2001-20261116    gcc-15.3.0
sparc64     randconfig-2000-20261116    clang-20
sparc64     randconfig-2001-20261116    clang-20
sparc64     randconfig-2200-20261116    gcc-8.5.0  smatch
um          randconfig-2000-20261116    gcc-14
um          randconfig-2001-20261116    gcc-14
um          randconfig-2200-20261116    gcc-14     smatch
x86_64      randconfig-2000-20261116    gcc-13
x86_64      randconfig-2001-20261116    gcc-14
x86_64      randconfig-2002-20261116    clang-22
x86_64      randconfig-2003-20261116    clang-22
x86_64      randconfig-2004-20261116    gcc-14
x86_64      randconfig-2005-20261116    clang-22

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
