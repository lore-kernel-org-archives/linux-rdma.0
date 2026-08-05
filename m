Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4CE371049;
	Wed,  5 Aug 2026 04:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785905431; cv=none; b=YR96tV7GDbYRen6SXqQRD2Apx5Qf7JAuDwMGgfY655O1SQzqng4GBSY/fo4K66whw+SeZA9wFMuId++57AqVdkRt8AuHcy9anUMfyIHT69qTssH5f0dltriiSNTvDudW1vZefepUcb4ZxfT+Fbwlge3pCk3EGtuIAHc+tKdPG50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785905431; c=relaxed/simple;
	bh=fuDgZ1JBZrhfquOP5MRMZKmVPqEh30hdFhALT5JRr+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SqRoo9rqWCJZpy+P17K3c9fPwI46Fxi0vn6n+a8K7g/gcW23GkszRNUV2JRkpFy5QaiFnupPOj1ifMs04F/WqSk7zqRCyTBL6qzbZuHcFKf/ZoM2GXA74BrV0RrztlMPqX4RGh8W4kSj5klEvrCjR00W7+diXYJxXdUyhmXcTMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CwxiUqiu; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CwxiUqiu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785905429; x=1817441429;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fuDgZ1JBZrhfquOP5MRMZKmVPqEh30hdFhALT5JRr+A=;
  b=CwxiUqiuE/snYltBsTTgda296KKTE+mvbWfBvpgspURQKRjwJlyGcRrp
   /bZO/30XAYshw56r7/4jA231zUCWoRV3OVXTRQECVOG03f6DgYjwy57pY
   y0l9uZt/GWvePwTZbiF2lWHtUN1fJnYvnNXAlhxYOcR9dmgaT6C2/CBym
   /qwAzdj49CaHYbl+IcqwpcZWSx7WggZ20SL3D9WBCSlnnmKrYFnYlrFhy
   DrwjI/hkoYB5w1iDmMZ60soA1kFbVxvqstrl48ijTw4MCvIFlrfbmcNtB
   BgHZATRtyHTMJvh+zoRez0BictWUZO/vthDfIHGndLXka6qEXeTCOiYh9
   A==;
X-CSE-ConnectionGUID: hTUg4jEYR8qaW/BzUBkegg==
X-CSE-MsgGUID: 7W1ZPsTTRx2hGFGH9nLU6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11865"; a="97834485"
X-IronPort-AV: E=Sophos;i="6.25,205,1779174000"; 
   d="scan'208";a="97834485"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2026 21:50:28 -0700
X-CSE-ConnectionGUID: SSRTzwnaROSRyWL+VBuREw==
X-CSE-MsgGUID: a/50yzd1QxqTh4CGbyzCUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,205,1779174000"; 
   d="scan'208";a="261131448"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 04 Aug 2026 21:50:25 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wrTaA-00000000BYP-2u05;
	Wed, 05 Aug 2026 04:50:22 +0000
Date: Wed, 5 Aug 2026 12:49:49 +0800
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
Message-ID: <202608051230.me79zRZh-lkp@intel.com>
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
config: s390-randconfig-002-20260805 (https://download.01.org/0day-ci/archive/20260805/202608051230.me79zRZh-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 9.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260805/202608051230.me79zRZh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608051230.me79zRZh-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/kernel.h:23,
                    from drivers/net/ethernet/mellanox/mlx5/core/cq.c:33:
   include/linux/mlx5/driver.h: In function 'mlx5_core_is_shutting_down':
>> include/linux/mlx5/driver.h:661:58: error: dereferencing pointer to incomplete type 'struct mlx5_core_dev'
     661 |  return test_bit(MLX5_INTERFACE_STATE_SHUTTING_DOWN, &dev->intf_state);
         |                                                          ^~
   include/linux/bitops.h:44:37: note: in definition of macro 'bitop'
      44 |    __builtin_constant_p((uintptr_t)(addr) != (uintptr_t)NULL) && \
         |                                     ^~~~
   include/linux/mlx5/driver.h:661:9: note: in expansion of macro 'test_bit'
     661 |  return test_bit(MLX5_INTERFACE_STATE_SHUTTING_DOWN, &dev->intf_state);
         |         ^~~~~~~~
--
   In file included from include/linux/kernel.h:23,
                    from drivers/net/ethernet/mellanox/mlx5/core/health.c:33:
   include/linux/mlx5/driver.h: In function 'mlx5_core_is_shutting_down':
>> include/linux/mlx5/driver.h:661:58: error: dereferencing pointer to incomplete type 'struct mlx5_core_dev'
     661 |  return test_bit(MLX5_INTERFACE_STATE_SHUTTING_DOWN, &dev->intf_state);
         |                                                          ^~
   include/linux/bitops.h:44:37: note: in definition of macro 'bitop'
      44 |    __builtin_constant_p((uintptr_t)(addr) != (uintptr_t)NULL) && \
         |                                     ^~~~
   include/linux/mlx5/driver.h:661:9: note: in expansion of macro 'test_bit'
     661 |  return test_bit(MLX5_INTERFACE_STATE_SHUTTING_DOWN, &dev->intf_state);
         |         ^~~~~~~~
   In file included from drivers/net/ethernet/mellanox/mlx5/core/health.c:37:
   include/linux/mlx5/driver.h:662:1: warning: control reaches end of non-void function [-Wreturn-type]
     662 | }
         | ^


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
