Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792866823;
	b=MX7as4W1g2/8yV/AYTnf2SRgfhbaLqNrFfHG4co5l7wIiDdNcwbTD4Td7ZWQ07KFd70Y
	 ZEMRQ81Xpts73t6LmjJ2fifLZeQH8RKl5YRFJpeEJxDG/POwPaGN4e1nlsuSzD2dttFk9
	 dg2Dqc/HooRx2KKIE7aOiWpO9FafxSw+6fIH2jyTExiw35vXeLjoCTc0taFPn/gdH6b3Y
	 dyIi2F3+LXW1re6MHKkirjVle1dZbFu8AsT9C4K/rLQw4RHc23EZ/VZBAQ8kaW11ouHSf
	 zu3/OVBgZaVKzqm+Zhh7GObk1jUfoV/ejI7oxawDq1djmJ7uM7zyX2hsI2XjqOuM+Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792866823;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=MpDSBIRCj1QunKXvcZFAv0RRVDRwfRhTAxxqEdIKKTM=;
	b=WaH3q5jLZd8hyUMAOzTEtsL6hM6OcQfnNdgM6eAqniYlWkDvaiUPorIPBrc5I95X9Q7R
	 Y4mU7DzGDGOBOhIJzZVdpxJg2qqrxuae97LHI8Tekr/NdHdGBJ/36GuMYaAUBCof9LIUj
	 hPJqRMq8yxtWeU/+8xFx0u8A9nceWZeuawXoALNh/MMrtlwRIlWrLaA6nC3kOjcCWnJX7
	 /Hv+VuBjRzXrnVe8OAuQRYdMy7NdABLevfZantXvZQWNGCZvUpaLsVxvbtwymqabNUEC+
	 K4fbMDRe7iCBYBmggEF5mfqjspdK1SvmddzWkDMLu0nLIKuZaCOpBpK1N3Rzu6nI/tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ArfG7QyV;
	arc=none smtp.remote-ip=192.198.163.18
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1684D606A31B;
	Sat, 24 Oct 2026 18:33:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1684D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ArfG7QyV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792866820; x=1824402820;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RquEUI+yYXMUfYVUXUPoh6ukcS/r+3U9HE1c0P1RnRQ=;
  b=ArfG7QyVUkEHAjvEbpZxzJ5kWuqNUtpP3IPTmOz5uqII40u3aSk83rbU
   yY1mLgc+hKahwl1aorYFmMZfdkdomP5lYG4fGr84uUnK0dirdhp6qTzhx
   8e+khwJrpDLNNosTK7eWvzIeF6nftaLspKWSSEJxQqRhmssh6i+mzAtwA
   AQogvZR2T9TofqsMojrZ96FgQ6uAw60GwcpavpECs6JG/Yu2kZlO/0z9U
   os7GDFFdlUAzPEdWYkkYQsM0oMoMz/SfNpv7pg8b3g2oaHoGKo0p/zGwe
   wdh2wQcsAtECqA2AmNI9F7a5BEqVTFCGqEGL+S+L3JtnJxIgSI70T85/B
   w==;
X-CSE-ConnectionGUID: USLQv6ApTf+TqVctFTdNtg==
X-CSE-MsgGUID: wemrWVsqQ1GkUVevKDL4kA==
X-IronPort-AV: E=McAfee;i="6800,10657,11945"; a="1625489"
X-IronPort-AV: E=Sophos;i="6.27,176,1787036400"; 
   d="scan'208";a="1625489"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2026 11:33:39 -0700
X-CSE-ConnectionGUID: qnH8VoBaTs+N4wLT7/cAfQ==
X-CSE-MsgGUID: Ro3hdMygQkaZzG5VZqku6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,176,1787036400"; 
   d="scan'208";a="3833734"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 24 Oct 2026 11:33:36 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xKgYe-00000000U98-3O8J;
	Sat, 24 Oct 2026 18:33:32 +0000
Date: Sun, 25 Oct 2026 02:33:09 +0800
From: kernel test robot <lkp@intel.com>
To: Yanze Zhang <zhang.yanze@zte.com.cn>, jgg@ziepe.ca, leon@kernel.org,
	julianbraha@gmail.com, huangjunxian6@hisilicon.com,
	yanjun.zhu@linux.dev, lkp@intel.com
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, wei.quan@zte.com.cn,
	han.junyang@zte.com.cn, ran.ming@zte.com.cn,
	han.chengfei@zte.com.cn, zhang.yanze@zte.com.cn
Subject: Re: [PATCH 2/7] RDMA/zrdma: Add core data structures and ABI
 definitions
Message-ID: <202610250256.rhuaT37h-lkp@intel.com>
References: <20261024071539.2182864-3-zhang.yanze@zte.com.cn>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261024071539.2182864-3-zhang.yanze@zte.com.cn>

Hi Yanze,

kernel test robot noticed the following build errors:

[auto build test ERROR on rdma/for-next]
[also build test ERROR on linus/master v7.3 next-20261023]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yanze-Zhang/RDMA-zrdma-Add-build-infrastructure-and-module-skeleton/20261024-151533
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git for-next
patch link:    https://lore.kernel.org/r/20261024071539.2182864-3-zhang.yanze%40zte.com.cn
patch subject: [PATCH 2/7] RDMA/zrdma: Add core data structures and ABI definitions
config: x86_64-rhel-9.4-kselftests (https://download.01.org/0day-ci/archive/20261025/202610250256.rhuaT37h-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261025/202610250256.rhuaT37h-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610250256.rhuaT37h-lkp@intel.com/

All errors (new ones prefixed by >>):

>> error: include/uapi/rdma/zrdma_abi.h: missing "WITH Linux-syscall-note" for SPDX-License-Identifier
   make[3]: *** [scripts/Makefile.headersinst:63: usr/include/rdma/zrdma_abi.h] Error 1
   make[3]: Target '__headers' not remade because of errors.
   make[2]: *** [Makefile:1523: headers] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
