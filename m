Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1143E3B71A6;
	Fri,  3 Jul 2026 10:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783076330; cv=none; b=fICRNBwynurslbYzZAEnjXqjKZZ9L/BneX4tUF11JFn3P2EK4kNPbU6VZc2xJSkdAt7Z3P28sNB4PGy2P2uJUuhbOuASQg6OycY7jhXfcUIrkQRNvXXjRWK+P2utCR/JuBtnvvo7+b8jGsu68aqVCXK5vPEtaUoMs9r5oxfS/4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783076330; c=relaxed/simple;
	bh=WKztYfUtYrSMu4Ej2zz70U0Lx8hwzhCWc55iHPpQtAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vk/qyFvm1H78hRODyjH2FOCMZpXoKPUp0CB6Vng3VzxSJjUmzAgwlfCSS2iDG/c8+PJdhI0OzlD7/YU5dtG/faEd3sxJdTP+Uk1HPA0YWlEFtnQYa98G9zIyjAKv9cPHWl3ckY04ECRzRY8to+d733bmg6xuohYASyFn7OqqXC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DsECINif; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DsECINif"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783076328; x=1814612328;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WKztYfUtYrSMu4Ej2zz70U0Lx8hwzhCWc55iHPpQtAc=;
  b=DsECINifunT7K8/DR4ggd3j+Fkr+ph2NdC+q/d46T+AYBl59fmeELgxD
   xZH9U3TNtjgjR17tmedc6j7VvLC6lrF+skzLvhAnOEbFvpxypRcrafmA2
   9dFWL34KF0usQyDb4uR3mC2f9tGT3ltwPhok5/G+8CSuNNCRmOCeNjJwe
   j9pEasOYK8Pjn11JvzcL8a3JmFtAPtU+vdeGgtouAIjiMVT2taijfTJky
   9T7Ho7rEa8WGmTWtQF9lyOy4fH8I2fov2/rYlgnynKjPpzmOe2yRx5/7K
   J3Jfn31QtaDsnMNiT9YQovwRLZSlOGqEUyiK2MipR6Ex4NrCVH8o8RuCL
   A==;
X-CSE-ConnectionGUID: KVEF5U+tQ9+lqyN6JH3Lgg==
X-CSE-MsgGUID: U8eRDE2CTPC7FyNT/ppXHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11835"; a="86377353"
X-IronPort-AV: E=Sophos;i="6.25,145,1779174000"; 
   d="scan'208";a="86377353"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2026 03:58:46 -0700
X-CSE-ConnectionGUID: Zfja6slBTMGIuGRH8qgqkQ==
X-CSE-MsgGUID: igGjEnQtTmS+eQHkuTQdkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,145,1779174000"; 
   d="scan'208";a="291228523"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 03 Jul 2026 03:58:42 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wfbbT-00000000C1n-0ERm;
	Fri, 03 Jul 2026 10:58:39 +0000
Date: Fri, 3 Jul 2026 18:58:35 +0800
From: kernel test robot <lkp@intel.com>
To: Ren Wei <enjou1224z@gmail.com>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc: oe-kbuild-all@lists.linux.dev, achender@kernel.org, davem@davemloft.net,
	edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
	andy.grover@oracle.com, yuantan098@gmail.com, yifanwucs@gmail.com,
	tomapufckgml@gmail.com, zcliangcn@gmail.com,
	dstsmallbird@foxmail.com, bronzed_45_vested@icloud.com,
	enjou1224z@gmail.com
Subject: Re: [PATCH net 1/1] net: rds: reject oversized TCP receive messages
Message-ID: <202607031832.sftbLQWx-lkp@intel.com>
References: <c83365078ea649d7ab2d9c198a445469bffb2550.1782850818.git.bronzed_45_vested@icloud.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c83365078ea649d7ab2d9c198a445469bffb2550.1782850818.git.bronzed_45_vested@icloud.com>

Hi Ren,

kernel test robot noticed the following build errors:

[auto build test ERROR on net/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Ren-Wei/net-rds-reject-oversized-TCP-receive-messages/20260703-135123
base:   net/main
patch link:    https://lore.kernel.org/r/c83365078ea649d7ab2d9c198a445469bffb2550.1782850818.git.bronzed_45_vested%40icloud.com
patch subject: [PATCH net 1/1] net: rds: reject oversized TCP receive messages
config: x86_64-buildonly-randconfig-006-20260703 (https://download.01.org/0day-ci/archive/20260703/202607031832.sftbLQWx-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260703/202607031832.sftbLQWx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607031832.sftbLQWx-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "__rds_conn_path_error" [net/rds/rds_tcp.ko] undefined!

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
