Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B4B37FF53;
	Thu, 20 Aug 2026 04:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787200559; cv=none; b=rlI14X13EIuurtwZZ7k0WZ4mv/uxzM2oGy5rN8Q0/rfgAQQ3f4VGjNDgTXQp2TcG3w7qJGaJBgjE2yPzN6R+dpAcLHRhbE5LaTv5ilcmAYD8xwQccZtv2L1mt1pFuT7PdQei0NhMf4a31clGhqHLRjfaIR3dMkMC4Guv88fvwzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787200559; c=relaxed/simple;
	bh=cHi+EBIsyAL7cVoiVX4cgiKwfxoD+PMM44X8FOBuNWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eQ1FAGdlVtWNtdQ2oahi9Up15pSMTblMsqVhoSRYNiH/rlL6Eslo+LDdk6Vx2oaxMFj5PbN220j/QAfQ/d2jP7DPCXCJh4Ar5eTOxmcnXoX8Rh1yA8xB+LpVxdUPJEz5sTGiMtO1Wn/NtMFbIiIWhMqDyWGfJrc+Rt21KvcMXNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JXdt2rd0; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JXdt2rd0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787200558; x=1818736558;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cHi+EBIsyAL7cVoiVX4cgiKwfxoD+PMM44X8FOBuNWw=;
  b=JXdt2rd0ITI4PnPd6cG/6mx9BZrggjM4x1fG7yE4UlNc8jRL4oX9OjkM
   WlVcBQDw3A9k7DPjMMCidugehAj5Fo5vv3ENimQOj2j3NUAVeT4C9gg+E
   IMNEB+GlxFPCnw3L7ZpCKOTFH8Pvk5RlMui4x2xiXSuav32K3Y1lilHyT
   i6DXskx4e7RWqcp/IFSjo7eu5LkzUYJvQs4QlGYmAz71E+tbgfrkn0G5n
   1HV0blOn5kqdXV9f68HzCmuRqg2GUq+Qh7/F1L6ywU6D77tvETu2mmS3/
   Av34xIRvPM/w8vOuwglnSuIOQ9fHXqJiW3UkL/vRhZckdFxtlvnDIWQed
   A==;
X-CSE-ConnectionGUID: 5N84FpqxRS6as/7EA3DE6A==
X-CSE-MsgGUID: Peu2KeSDS4G6lKq8iobV6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11880"; a="87489142"
X-IronPort-AV: E=Sophos;i="6.25,232,1779174000"; 
   d="scan'208";a="87489142"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2026 21:35:58 -0700
X-CSE-ConnectionGUID: +aWBIx5CTUer/QfAUXjlDA==
X-CSE-MsgGUID: akvwOtsWQmimi/STGgxPlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,232,1779174000"; 
   d="scan'208";a="295745925"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 19 Aug 2026 21:35:56 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wwuVM-00000000hn3-2gsY;
	Thu, 20 Aug 2026 04:35:52 +0000
Date: Thu, 20 Aug 2026 12:35:45 +0800
From: kernel test robot <lkp@intel.com>
To: Guangshuo Li <lgs201920130244@gmail.com>,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Gioh Kim <gi-oh.kim@cloud.ionos.com>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>
Subject: Re: [PATCH] RDMA/rtrs-clt: Fix double free on path sysfs failure
Message-ID: <202608201231.bfKSlFoO-lkp@intel.com>
References: <20260714142838.1723076-1-lgs201920130244@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714142838.1723076-1-lgs201920130244@gmail.com>

Hi Guangshuo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on rdma/for-next]
[also build test WARNING on linus/master v7.2 next-20260819]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Guangshuo-Li/RDMA-rtrs-clt-Fix-double-free-on-path-sysfs-failure/20260815-173725
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git for-next
patch link:    https://lore.kernel.org/r/20260714142838.1723076-1-lgs201920130244%40gmail.com
patch subject: [PATCH] RDMA/rtrs-clt: Fix double free on path sysfs failure
config: i386-buildonly-randconfig-004-20260820 (https://download.01.org/0day-ci/archive/20260820/202608201231.bfKSlFoO-lkp@intel.com/config)
compiler: clang version 22.1.3 (https://github.com/llvm/llvm-project e9846648fd6183ee6d8cbdb4502213fcf902a211)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260820/202608201231.bfKSlFoO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608201231.bfKSlFoO-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c:470:1: warning: unused label 'del_kobj' [-Wunused-label]
     470 | del_kobj:
         | ^~~~~~~~~
   1 warning generated.


vim +/del_kobj +470 drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c

   424	
   425	int rtrs_clt_create_path_files(struct rtrs_clt_path *clt_path)
   426	{
   427		struct rtrs_clt_sess *clt = clt_path->clt;
   428		char str[NAME_MAX];
   429		int err;
   430		struct rtrs_addr path = {
   431			.src = &clt_path->s.src_addr,
   432			.dst = &clt_path->s.dst_addr,
   433		};
   434	
   435		rtrs_addr_to_str(&path, str, sizeof(str));
   436		err = kobject_init_and_add(&clt_path->kobj, &ktype_sess,
   437					   clt->kobj_paths,
   438					   "%s", str);
   439		if (err) {
   440			pr_err("kobject_init_and_add: %pe\n", ERR_PTR(err));
   441			goto free_stats;
   442		}
   443		err = sysfs_create_group(&clt_path->kobj, &rtrs_clt_path_attr_group);
   444		if (err) {
   445			pr_err("sysfs_create_group(): %pe\n", ERR_PTR(err));
   446			goto del_kobj_free_stats;
   447		}
   448		err = kobject_init_and_add(&clt_path->stats->kobj_stats, &ktype_stats,
   449					   &clt_path->kobj, "stats");
   450		if (err) {
   451			pr_err("kobject_init_and_add: %pe\n", ERR_PTR(err));
   452			kobject_put(&clt_path->stats->kobj_stats);
   453			goto remove_group;
   454		}
   455	
   456		err = sysfs_create_group(&clt_path->stats->kobj_stats,
   457					 &rtrs_clt_stats_attr_group);
   458		if (err) {
   459			pr_err("failed to create stats sysfs group, err: %pe\n", ERR_PTR(err));
   460			goto put_kobj_stats;
   461		}
   462	
   463		return 0;
   464	
   465	put_kobj_stats:
   466		kobject_del(&clt_path->stats->kobj_stats);
   467		kobject_put(&clt_path->stats->kobj_stats);
   468	remove_group:
   469		sysfs_remove_group(&clt_path->kobj, &rtrs_clt_path_attr_group);
 > 470	del_kobj:
   471		kobject_del(&clt_path->kobj);
   472		return err;
   473	
   474	del_kobj_free_stats:
   475		kobject_del(&clt_path->kobj);
   476	free_stats:
   477		free_percpu(clt_path->stats->pcpu_stats);
   478		kfree(clt_path->stats);
   479	
   480		/*
   481		 * Leave the path kobject reference to the caller so it can tear
   482		 * down the connections before rtrs_clt_path_release() frees it.
   483		 */
   484	
   485		return err;
   486	}
   487	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
