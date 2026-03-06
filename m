Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4BC2405E7
	for <linux-rdma@vger.kernel.org>; Fri,  6 Mar 2026 02:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772765931; cv=none; b=jO0PSmiogF+bN5k9cKpqj9K5hOU8StWRLgtenysstWGzSXnpVFgSFF8+YyDeX04BLud+2J43bo8ne414W2xsqZ/cqNrtYrD8k2nmcWFmMxV3uQNHg/jMXM9UkoxKTQRIZBawL1+GlIC3bwPooWdoAtPqKdAb0/560xLCNRppJxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772765931; c=relaxed/simple;
	bh=Pz6+P86PyyQvcqGlbAFnCdBMt/lwH/0o+Bui2t/Re1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YLrNv9t2O1tmbIu8fn8oGR2G5EOepUOow5a1/7ZoG/B1CQPTt964ByIltRHngKRucSqIhDJWpBd99hp29WJOQBq4TigPjnO/J2nop5arROQBxwsQEz6JKxb6W4u+3mjEYLcpj3H87YMu9I5MfhkuSc87MuIdl1QTUMEvHi9YadI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YvWoq4Zc; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YvWoq4Zc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772765927; x=1804301927;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Pz6+P86PyyQvcqGlbAFnCdBMt/lwH/0o+Bui2t/Re1w=;
  b=YvWoq4ZcAwrpn2MdvElHwLFlxFGT91fV5FN+yGzz5KodUj7LY30JTGbM
   2b7lS7TKNeO8nB+ETOtH//5Unot9387Kf9LIfrvAZOKdRNyd3qC6MUMQm
   FoNnBuF+5ZKRhzGHMM0XHMuAzPKFMDpfXNpmd80YpE9+1YDVRvkVD5TgT
   1Q6nq9VXQsqupMx2bpZiLbUpO6X8x6B20VR2OORdYFeveJ2GZxBS+N0fX
   JmLFeKFBm7GyZbhO572mxfcbAzh95r1PEyL4Ptgz0V7LL0/QraQVPnl0i
   V1RWvUhn2RCJl+/b6BNbJ8tEU/+sC9pavZEkTrrOKsqoDF28Ht9yk/vkJ
   A==;
X-CSE-ConnectionGUID: fL6S8wI6TzuiVWt7FroivQ==
X-CSE-MsgGUID: 07ZcRi++TEKZ4D6RcjhTIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="84581721"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="84581721"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 18:58:47 -0800
X-CSE-ConnectionGUID: dCpylN9KRVu5crLdHnB61w==
X-CSE-MsgGUID: WBKSoyn6SvCzpZg86Zqc9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="218011886"
Received: from lkp-server01.sh.intel.com (HELO 058beb05654c) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 05 Mar 2026 18:58:44 -0800
Received: from kbuild by 058beb05654c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vyLOj-000000000Ej-38O3;
	Fri, 06 Mar 2026 02:58:41 +0000
Date: Fri, 6 Mar 2026 10:58:00 +0800
From: kernel test robot <lkp@intel.com>
To: Zhu Yanjun <yanjun.zhu@linux.dev>, jgg@ziepe.ca, leon@kernel.org,
	zyjzyj2000@gmail.com, dsahern@kernel.org,
	linux-rdma@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCHv2 1/1] RDMA/rxe: Add the support that rxe can work in net
 namespace
Message-ID: <202603061015.zwXUa3OS-lkp@intel.com>
References: <20260304041607.11685-1-yanjun.zhu@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304041607.11685-1-yanjun.zhu@linux.dev>

Hi Zhu,

kernel test robot noticed the following build warnings:

[auto build test WARNING on rdma/for-next]
[also build test WARNING on linus/master v7.0-rc2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Zhu-Yanjun/RDMA-rxe-Add-the-support-that-rxe-can-work-in-net-namespace/20260304-121951
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git for-next
patch link:    https://lore.kernel.org/r/20260304041607.11685-1-yanjun.zhu%40linux.dev
patch subject: [PATCHv2 1/1] RDMA/rxe: Add the support that rxe can work in net namespace
config: x86_64-randconfig-014-20260305 (https://download.01.org/0day-ci/archive/20260306/202603061015.zwXUa3OS-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260306/202603061015.zwXUa3OS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603061015.zwXUa3OS-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

>> WARNING: modpost: drivers/infiniband/sw/rxe/rdma_rxe: section mismatch in reference: rxe_namespace_exit+0x7 (section: .exit.text) -> rxe_net_ops (section: .init.data)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
