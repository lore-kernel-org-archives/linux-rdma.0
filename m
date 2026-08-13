Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07B6484249;
	Thu, 13 Aug 2026 17:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786641678; cv=none; b=ZRMPI5N5RpH7WAcfur5wJ/e9wO2q8c5RRBYdj5lX9maYGAQLpBNNRTcCG7w7JGhedZpAOC4ZySipqGo3IrHbX9AidDE6zniIb8CB6hSWK7Y/Q6C+tPfEB0otYERhtqGPm0KLzj7eS3rAt34DS+zRxI32qhJ1G/29rJOkBhl6dTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786641678; c=relaxed/simple;
	bh=Mkidty/zRD+x27WcHPxXMrfSjcU9wppgFrqjf9p/0RQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fu6JmEh/bpCDHofYwwV//n1kgCXVk7AulZQpN62D7MCnQ/Zw8dwAMXE2cp/HdKrZUas/ZB8ddwKLYQBBWs+hFvryfqeSQr5TXdZjc7blbOUMr6fYLVnZZvZrrBm4eS1NlMcMmWVkSoBOvWLy/Nw95f+FN8118x7Thd1kMaQCShU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YIWuEi1+; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YIWuEi1+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786641676; x=1818177676;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Mkidty/zRD+x27WcHPxXMrfSjcU9wppgFrqjf9p/0RQ=;
  b=YIWuEi1+f8Hf5JhEgMhazoQ+c3a7Um84uEQZSPkHvAM2UnPM9oZ0xfhD
   aFngRI8N6SaNxOBIoUhOzTXZvj2bGGM7ON2fCFKJxThHiTNUwI2PZtdo3
   i8FlfT0nVybSyoNx4XQVju58fby+7E8mdcQLOJicGESIju6AeIq6egAgd
   ut4qPwYG+xDII20FRtiCM+fA3GVnNwOObzkK47XRRvoDSZE9aNDx7WetY
   o13ANgzdV6h/lWFGWondnCbLUhztT9YacjAUOkeYEcDsxe6+Ryosdc1yo
   shdOj9mpPUZViHAcscZ5krhO7WAnBZ5FbDqcIBlv8RFGSkWqb49wzVuvv
   Q==;
X-CSE-ConnectionGUID: E5fWtnuATEGNWXxlptvv2Q==
X-CSE-MsgGUID: C0pNClVZR3+4NvwIWsA+wg==
X-IronPort-AV: E=McAfee;i="6800,10657,11874"; a="89743047"
X-IronPort-AV: E=Sophos;i="6.25,221,1779174000"; 
   d="scan'208";a="89743047"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 10:21:13 -0700
X-CSE-ConnectionGUID: fkQBEffCRJievkpflTJP6A==
X-CSE-MsgGUID: y5sJH6QgRc2ns20kGIimmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,221,1779174000"; 
   d="scan'208";a="263549106"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 13 Aug 2026 10:21:10 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wuZ75-00000000W0A-0mQw;
	Thu, 13 Aug 2026 17:21:07 +0000
Date: Fri, 14 Aug 2026 01:20:57 +0800
From: kernel test robot <lkp@intel.com>
To: Chengfeng Ye <nicoyip.dev@gmail.com>,
	Allison Henderson <achender@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Santosh Shilimkar <santosh.shilimkar@oracle.com>,
	Ka-Cheong Poon <ka-cheong.poon@oracle.com>,
	Dan Carpenter <error27@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org, Chengfeng Ye <nicoyip.dev@gmail.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] rds: synchronize info callbacks with connection teardown
Message-ID: <202608140151.MOvRf1jc-lkp@intel.com>
References: <20260720184955.3008978-1-nicoyip.dev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720184955.3008978-1-nicoyip.dev@gmail.com>

Hi Chengfeng,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net/main]
[also build test WARNING on linus/master horms-ipvs/master v7.2-rc7]
[cannot apply to net-next/main next-20260812]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Chengfeng-Ye/rds-synchronize-info-callbacks-with-connection-teardown/20260812-225931
base:   net/main
patch link:    https://lore.kernel.org/r/20260720184955.3008978-1-nicoyip.dev%40gmail.com
patch subject: [PATCH] rds: synchronize info callbacks with connection teardown
config: mips-randconfig-r134-20260813 (https://download.01.org/0day-ci/archive/20260814/202608140151.MOvRf1jc-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 11.5.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260814/202608140151.MOvRf1jc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608140151.MOvRf1jc-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> net/rds/info.c:83:9: sparse: sparse: cast removes address space '__rcu' of expression
>> net/rds/info.c:83:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/rds/info.c:83:9: sparse:    void ( [noderef] __rcu * )( ... )
   net/rds/info.c:83:9: sparse:    void ( * )( ... )
   net/rds/info.c:84:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/rds/info.c:84:9: sparse:    void ( [noderef] __rcu * )( ... )
   net/rds/info.c:84:9: sparse:    void ( * )( ... )
   net/rds/info.c:96:9: sparse: sparse: cast removes address space '__rcu' of expression
   net/rds/info.c:96:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/rds/info.c:96:9: sparse:    void ( [noderef] __rcu * )( ... )
   net/rds/info.c:96:9: sparse:    void ( * )( ... )
   net/rds/info.c:97:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/rds/info.c:97:9: sparse:    void ( [noderef] __rcu * )( ... )
   net/rds/info.c:97:9: sparse:    void ( * )( ... )
   net/rds/info.c:222:16: sparse: sparse: cast removes address space '__rcu' of expression
   net/rds/info.c:222:16: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/rds/info.c:222:16: sparse:    void ( [noderef] __rcu * )( ... )
   net/rds/info.c:222:16: sparse:    void ( * )( ... )

vim +/__rcu +83 net/rds/info.c

    75	
    76	void rds_info_register_func(int optname, rds_info_func func)
    77	{
    78		int offset = optname - RDS_INFO_FIRST;
    79	
    80		BUG_ON(optname < RDS_INFO_FIRST || optname > RDS_INFO_LAST);
    81	
    82		spin_lock(&rds_info_lock);
  > 83		BUG_ON(rcu_access_pointer(rds_info_funcs[offset]));
    84		rcu_assign_pointer(rds_info_funcs[offset], func);
    85		spin_unlock(&rds_info_lock);
    86	}
    87	EXPORT_SYMBOL_GPL(rds_info_register_func);
    88	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
