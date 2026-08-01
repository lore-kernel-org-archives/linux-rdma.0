Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8933546C0;
	Sat,  1 Aug 2026 02:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785552144; cv=none; b=RoCD0CFmXvc2NCAY0gxh+71mO6xOcyPYC2JBM5kOuAfrxM9kT1uliA0sdy1e/FmDK/ElyAQrD1Z4E+tHSthWBJIVx7mLAS75EwR33vekTp9oh4AMo8R/77qp9xzR9OrKWD++iDJmha/AxMN0WRA3R9uVPAXZxqoFEw3yKeGl7/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785552144; c=relaxed/simple;
	bh=ubNCwz9ooEttgdYl2GnjPLsDUK4JMODzOzvnbW6qKJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SzvV1RincMKb4gyrhOoOC+1ZAPSKQwu9O/pSHIaDOhx/YyyOUp/ABOOwELeDCWCLwpKdk/UIpJrKqXEtEIfozIr5cjueo6H48rnMbCQpfbPRSpvDIf3U2cEv50cOWN9UONGRtjTpTmP83/3oAgpO6me8CEuH9GO2hT8UsP7jgdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q6OuXX8D; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q6OuXX8D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785552142; x=1817088142;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ubNCwz9ooEttgdYl2GnjPLsDUK4JMODzOzvnbW6qKJA=;
  b=Q6OuXX8DxAWX0q63cEAJtp+eJxSr4Ggc5wGpV1XwGs4lwPL5FSVWZTPu
   Eh6G0Wk0suGnmd3vbPGeytLdMQdMS31xl2VfGbSVy1Hc8QYGNuzSiGMSY
   nm1/zqRwITHRpNZk/AhNx7GneWQXZNGOzpKI9ZpgoA4UlAoSJ2gcsltq0
   5j++5GnHtSXmHcOrfE1WLSEl8DMIV2Jd1h2VJqqs5q9Vk/PCMkzaDuzAh
   YshsPJ0cD5FA0irOwh6XOCJ8GkZVil7Vf9bFc1Zpt/9cmZtp19QyviFlC
   2sBxU4sfl+RzO7D+4XCBCZa54Vo/WneZOgPv6vv5gVMcLXU8WHJ3QYuWt
   A==;
X-CSE-ConnectionGUID: zpYZP7GsStGVhKAqCPW7xA==
X-CSE-MsgGUID: WlO+XHn1SayHWcAPkmPpwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11861"; a="85152011"
X-IronPort-AV: E=Sophos;i="6.25,197,1779174000"; 
   d="scan'208";a="85152011"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 19:42:21 -0700
X-CSE-ConnectionGUID: PfxMt0sISvmJE5X86coIcg==
X-CSE-MsgGUID: bnQr7yK1R8+fDVpzAMM8Jw==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 31 Jul 2026 19:42:18 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wpzfz-000000002dJ-1XGw;
	Sat, 01 Aug 2026 02:42:15 +0000
Date: Sat, 1 Aug 2026 10:41:27 +0800
From: kernel test robot <lkp@intel.com>
To: Yanze Zhang <zhang.yanze@zte.com.cn>, jgg@ziepe.ca, leon@kernel.org,
	julianbraha@gmail.com, huangjunxian6@hisilicon.com
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, wei.quan@zte.com.cn,
	han.junyang@zte.com.cn, ran.ming@zte.com.cn,
	han.chengfei@zte.com.cn, zhang.yanze@zte.com.cn
Subject: Re: [PATCH rdma v4 2/2] RDMA/zrdma: Add hardware config code and
 improve driver init flow
Message-ID: <202608011042.ZdKTOgxW-lkp@intel.com>
References: <20260704082640.664061-3-zhang.yanze@zte.com.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260704082640.664061-3-zhang.yanze@zte.com.cn>

Hi Yanze,

kernel test robot noticed the following build errors:

[auto build test ERROR on rdma/for-next]
[also build test ERROR on linus/master v7.2-rc5 next-20260731]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yanze-Zhang/RDMA-zrdma-Add-ZTE-Dinghai-Ethernet-Protocol-Driver-for-RDMA/20260801-003905
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git for-next
patch link:    https://lore.kernel.org/r/20260704082640.664061-3-zhang.yanze%40zte.com.cn
patch subject: [PATCH rdma v4 2/2] RDMA/zrdma: Add hardware config code and improve driver init flow
config: nios2-allmodconfig (https://download.01.org/0day-ci/archive/20260801/202608011042.ZdKTOgxW-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260801/202608011042.ZdKTOgxW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608011042.ZdKTOgxW-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/infiniband/hw/zrdma/zrdma_main.h:11,
                    from drivers/infiniband/hw/zrdma/zrdma_main.c:14:
>> drivers/infiniband/hw/zrdma/zrdma_type.h:92:27: error: field 'msix_entries' has incomplete type
      92 |         struct msix_entry msix_entries;
         |                           ^~~~~~~~~~~~


vim +/msix_entries +92 drivers/infiniband/hw/zrdma/zrdma_type.h

    81	
    82	struct zxdh_core_dev_info {
    83		struct pci_dev *pdev;
    84		struct auxiliary_device *adev;
    85		u32 __iomem *hw_addr;
    86		struct zxdh_ver_info ver;
    87		void *auxiliary_priv;
    88		enum zxdh_function_type ftype;
    89		u16 vport_id;
    90		u16 slot_id;
    91		struct net_device *netdev;
  > 92		struct msix_entry msix_entries;
    93		u16 msix_count;
    94		void *dh_dev;
    95	};
    96	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
