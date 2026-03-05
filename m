Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9279D38735D;
	Thu,  5 Mar 2026 11:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772709418; cv=none; b=FUkRU8oc04U6gXJyIYJJBjfEvRu5eWCZeXgB3eNPo17VNNoKdWjeh/MW+Gk45JzbkOk+5/U3sxD9nstfv1L7OUl8LjmCihJYtOJX+nb08dRZCAVaWuLeTY3+qJZnSmmgEgq7gGi74oY8Lfp8TjrVebg6PjSZIzQ/RigChQGIsOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772709418; c=relaxed/simple;
	bh=FIdCqi/37xP+b14PjxcZIAV+eBP/n6AMX/DfdPGJS/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oPhyuloUlaUUODwsZ58bXWI6/zd2iS09bbF/gxqWB5kJ8uqbgmCXRX0C7xzfP82fMcuwISQudCNpnyDdkUGxHlzMC8SRGI3rBYUWnQ82AbO0YjziHTOvRVU5o9rT6PbpiFgLRo6rYVC0zH77aYIcPKxMxyTE3hfcZgqqmVA3hh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BuTWdpfO; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BuTWdpfO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772709416; x=1804245416;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FIdCqi/37xP+b14PjxcZIAV+eBP/n6AMX/DfdPGJS/w=;
  b=BuTWdpfOmtV+BEEnFRF8s/flCW5sLEgKVlsctEf+TDhvykzwVtH0Pak0
   QnQDemv0Nremsq3Yf5Q3rBO2z0ICPvsfmfMuL8EukTW/JLzUYRnjmxddJ
   IbuhibMFW2IOZRIuzqazJc+HnDZTeRzwyvLNjI0fJdIqBusnTtUNzV+/S
   skjpDkoGAmTL1vJRnVsivRv5NWVR+BteOcx7XENe8EYT0Ud3kXyDM1Py5
   Ix6PmgnVFjC6xQtw6zvL49djiHEk/nD6HOgEzpkWbmUfESJf58ok8g8tQ
   VARiv5Iwcy9eplg52SuiSEUyIkDhkSfNL/5ZacnMq6WJvw/VB/CSZ8d+Z
   g==;
X-CSE-ConnectionGUID: T0EX/3vVRJqSXtMgHcdyIQ==
X-CSE-MsgGUID: WhueYYYjTe6ocDEXr0/pPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="91185313"
X-IronPort-AV: E=Sophos;i="6.23,102,1770624000"; 
   d="scan'208";a="91185313"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 03:16:55 -0800
X-CSE-ConnectionGUID: QukI1M3TQN+YJ8EolXxXmQ==
X-CSE-MsgGUID: G1dgtvoXTRiIcZexrcCvfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,102,1770624000"; 
   d="scan'208";a="217792854"
Received: from lkp-server01.sh.intel.com (HELO cadc4577a874) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 05 Mar 2026 03:16:51 -0800
Received: from kbuild by cadc4577a874 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vy6hE-000000000Ws-06uN;
	Thu, 05 Mar 2026 11:16:48 +0000
Date: Thu, 5 Mar 2026 19:16:38 +0800
From: kernel test robot <lkp@intel.com>
To: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>, saeedm@nvidia.com,
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, rama.nichanamatlu@oracle.com,
	manjunath.b.patil@oracle.com, anand.a.khoje@oracle.com,
	Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
Subject: Re: [PATCH] net/mlx5: poll mlx5 eq during irq migration
Message-ID: <202603051910.7oo8wCfc-lkp@intel.com>
References: <20260304161704.910564-1-praveen.kannoju@oracle.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304161704.910564-1-praveen.kannoju@oracle.com>

Hi Praveen,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]
[also build test WARNING on net/main linus/master v7.0-rc2 next-20260304]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Praveen-Kumar-Kannoju/net-mlx5-poll-mlx5-eq-during-irq-migration/20260305-003505
base:   net-next/main
patch link:    https://lore.kernel.org/r/20260304161704.910564-1-praveen.kannoju%40oracle.com
patch subject: [PATCH] net/mlx5: poll mlx5 eq during irq migration
config: loongarch-randconfig-r121-20260305 (https://download.01.org/0day-ci/archive/20260305/202603051910.7oo8wCfc-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 15.2.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260305/202603051910.7oo8wCfc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603051910.7oo8wCfc-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/net/ethernet/mellanox/mlx5/core/eq.c:25:14: sparse: sparse: symbol 'mlx5_reap_eq_irq_aff_change' was not declared. Should it be static?
>> drivers/net/ethernet/mellanox/mlx5/core/eq.c:958:6: sparse: sparse: symbol 'mlx5_eq_reap_irq_notify' was not declared. Should it be static?
>> drivers/net/ethernet/mellanox/mlx5/core/eq.c:978:6: sparse: sparse: symbol 'mlx5_eq_reap_irq_release' was not declared. Should it be static?

vim +/mlx5_reap_eq_irq_aff_change +25 drivers/net/ethernet/mellanox/mlx5/core/eq.c

    24	
  > 25	unsigned int mlx5_reap_eq_irq_aff_change;
    26	module_param(mlx5_reap_eq_irq_aff_change, int, 0644);
    27	MODULE_PARM_DESC(mlx5_reap_eq_irq_aff_change, "mlx5_reap_eq_irq_aff_change: 0 = Disable MLX5 EQ Reap upon IRQ affinity change, \
    28			 1 = Enable MLX5 EQ Reap upon IRQ affinity change. Default=0");
    29	enum {
    30		MLX5_EQE_OWNER_INIT_VAL	= 0x1,
    31	};
    32	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
