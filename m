Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A01374A01;
	Tue,  4 Aug 2026 23:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785885764; cv=none; b=GQdBRrpx1SxUuF9+Jdz3nXzsTJjp992mt+HYmBpgkACmRF/aFJuXJwZEit+7KL7DVLoeDstrSFXfbBAGV9inoX/RxWnZZWWZPNu4KUScnlUW1o7TnCi+34a0AQpZQsaUkUTMhfo8v/N1gfeHcfWvs2NRI+ncArP39+CN4ry3G6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785885764; c=relaxed/simple;
	bh=Z6rdk3+ZACGv6xMckRBzF3XjZ36GzektoiXHKVQ5/yI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CF+pJ69bqVdU+79QiPS1kvmj+znz7q9KjYtQzoSvh2drzTl8INKkjJ+FZNIrD4JbJZT2wwjZZe1l/yKZEyFaeGDC77CB0NH5UVejv9eH5U7nfrIou3zGrPIaqUtEhKCuyVy1mhxZCtXRyo/Pt2svR0XwGGc/OBlawO7FqCDBC4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GHz8VKZj; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GHz8VKZj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785885762; x=1817421762;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Z6rdk3+ZACGv6xMckRBzF3XjZ36GzektoiXHKVQ5/yI=;
  b=GHz8VKZjsELTvxNshLGoeF2LZyMwYEjl0wWJOlEhnxceLQMKOioOgdf7
   ZevRGUn6ZnAeG+BHFsOSujwPAp4oTSNlcXyCz29gVNx3DFjCyJRTg+kYt
   F/Ph8H5THF+8+yvnokIEpdPhhD2lmKaDf0cvH9o3/x6XYZkjwbIrHuVlw
   nZJ6mpoAGp6Bu6/1qA72lWO+Zg/0YaNSNfClaFVhIGzts/QOxAehn+lGz
   L0Lx32A/tuVhtSCX5kaiYVD5fodEFkcQTz1zzn+qiRQ5DwswvjI5XSpr5
   IYAWVy+Si2nA7+06NertipWabNWC46rPXHxcpva+a3EWnrUttPQ/haPxj
   Q==;
X-CSE-ConnectionGUID: FdDE634LTTeU4VvwXZHGhw==
X-CSE-MsgGUID: iOORMbPBSpaes4P/5eP8Gg==
X-IronPort-AV: E=McAfee;i="6800,10657,11865"; a="86327473"
X-IronPort-AV: E=Sophos;i="6.25,205,1779174000"; 
   d="scan'208";a="86327473"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2026 16:22:41 -0700
X-CSE-ConnectionGUID: LrK5kGOGQUq3nNzhjqMtEQ==
X-CSE-MsgGUID: mZeqokLyS2Sdj85xjW4irQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,205,1779174000"; 
   d="scan'208";a="299847314"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 04 Aug 2026 16:22:38 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wrOSw-00000000Awb-2wyW;
	Tue, 04 Aug 2026 23:22:34 +0000
Date: Wed, 5 Aug 2026 07:21:37 +0800
From: kernel test robot <lkp@intel.com>
To: Chenguang Zhao <chenguang.zhao@linux.dev>, leon@kernel.org,
	jgg@ziepe.ca, saeedm@nvidia.com, tariqt@nvidia.com,
	mbloch@nvidia.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org, chenguang.zhao@linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>
Subject: Re: [PATCH v2] RDMA/core: quiesce CQ polling before device shutdown
 on reboot
Message-ID: <202608050723.aNI2gkmv-lkp@intel.com>
References: <20260714075558.1420384-1-chenguang.zhao@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714075558.1420384-1-chenguang.zhao@linux.dev>

Hi Chenguang,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v7.2-rc6 next-20260804]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Chenguang-Zhao/RDMA-core-quiesce-CQ-polling-before-device-shutdown-on-reboot/20260805-044210
base:   linus/master
patch link:    https://lore.kernel.org/r/20260714075558.1420384-1-chenguang.zhao%40linux.dev
patch subject: [PATCH v2] RDMA/core: quiesce CQ polling before device shutdown on reboot
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20260805/202608050723.aNI2gkmv-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260805/202608050723.aNI2gkmv-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608050723.aNI2gkmv-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/kernel.h:23,
                    from drivers/infiniband/hw/mlx5/mlx5_ib.h:10,
                    from drivers/infiniband/hw/mlx5/ah.c:33:
   include/linux/mlx5/driver.h: In function 'mlx5_core_is_shutting_down':
>> include/linux/mlx5/driver.h:661:65: error: invalid use of undefined type 'struct mlx5_core_dev'
     661 |         return test_bit(MLX5_INTERFACE_STATE_SHUTTING_DOWN, &dev->intf_state);
         |                                                                 ^~
   include/linux/bitops.h:44:44: note: in definition of macro 'bitop'
      44 |           __builtin_constant_p((uintptr_t)(addr) != (uintptr_t)NULL) && \
         |                                            ^~~~
   include/linux/mlx5/driver.h:661:16: note: in expansion of macro 'test_bit'
     661 |         return test_bit(MLX5_INTERFACE_STATE_SHUTTING_DOWN, &dev->intf_state);
         |                ^~~~~~~~
>> include/linux/mlx5/driver.h:661:65: error: invalid use of undefined type 'struct mlx5_core_dev'
     661 |         return test_bit(MLX5_INTERFACE_STATE_SHUTTING_DOWN, &dev->intf_state);
         |                                                                 ^~
   include/linux/bitops.h:45:23: note: in definition of macro 'bitop'
      45 |           (uintptr_t)(addr) != (uintptr_t)NULL &&                       \
         |                       ^~~~
   include/linux/mlx5/driver.h:661:16: note: in expansion of macro 'test_bit'
     661 |         return test_bit(MLX5_INTERFACE_STATE_SHUTTING_DOWN, &dev->intf_state);
         |                ^~~~~~~~
>> include/linux/mlx5/driver.h:661:65: error: invalid use of undefined type 'struct mlx5_core_dev'
     661 |         return test_bit(MLX5_INTERFACE_STATE_SHUTTING_DOWN, &dev->intf_state);
         |                                                                 ^~
   include/linux/bitops.h:46:57: note: in definition of macro 'bitop'
      46 |           __builtin_constant_p(*(const unsigned long *)(addr))) ?       \
         |                                                         ^~~~
   include/linux/mlx5/driver.h:661:16: note: in expansion of macro 'test_bit'
     661 |         return test_bit(MLX5_INTERFACE_STATE_SHUTTING_DOWN, &dev->intf_state);
         |                ^~~~~~~~
>> include/linux/mlx5/driver.h:661:65: error: invalid use of undefined type 'struct mlx5_core_dev'
     661 |         return test_bit(MLX5_INTERFACE_STATE_SHUTTING_DOWN, &dev->intf_state);
         |                                                                 ^~
   include/linux/bitops.h:47:24: note: in definition of macro 'bitop'
      47 |          const##op(nr, addr) : op(nr, addr))
         |                        ^~~~
   include/linux/mlx5/driver.h:661:16: note: in expansion of macro 'test_bit'
     661 |         return test_bit(MLX5_INTERFACE_STATE_SHUTTING_DOWN, &dev->intf_state);
         |                ^~~~~~~~
>> include/linux/mlx5/driver.h:661:65: error: invalid use of undefined type 'struct mlx5_core_dev'
     661 |         return test_bit(MLX5_INTERFACE_STATE_SHUTTING_DOWN, &dev->intf_state);
         |                                                                 ^~
   include/linux/bitops.h:47:39: note: in definition of macro 'bitop'
      47 |          const##op(nr, addr) : op(nr, addr))
         |                                       ^~~~
   include/linux/mlx5/driver.h:661:16: note: in expansion of macro 'test_bit'
     661 |         return test_bit(MLX5_INTERFACE_STATE_SHUTTING_DOWN, &dev->intf_state);
         |                ^~~~~~~~


vim +661 include/linux/mlx5/driver.h

   658	
   659	static inline bool mlx5_core_is_shutting_down(struct mlx5_core_dev *dev)
   660	{
 > 661		return test_bit(MLX5_INTERFACE_STATE_SHUTTING_DOWN, &dev->intf_state);
   662	}
   663	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
