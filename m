Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2668F3BB9F8
	for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 10:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785407241; cv=none; b=JhBweoj7cRW9c9ME6EkmXAOYEz6gPA/RzJlLtxfDqXPrhcmSfcq0/1EE3nvh45RDazcXyXGFj7MG469tbbpiVWBaI0U0j8JZ0ch2ebEbxZL+EnpF14KmF3j6fPEmxH0X767ByZ0ZoHPu2am5jtBbkCP4chfmaGGpG5gWCI+TxMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785407241; c=relaxed/simple;
	bh=f7IjzBpuOq5XX4/CEuYws05MatN7Avv57/w5HFz6N7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pQt1tVfRgxybhJCwqUsEbD0FgSzORNnubWEeSX4VEB11QpZ++aTonFTIq2jtf+j73JW/kvBr4exmwfYS5lNyJHUViq+sjsEESQEzpyh6F/PZGTqAIn8VctkxB2zmXCtTzE2ggWePUg4HRw2COwxdP/xsGe6sXiIdcGeZeY6jJzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ox/wP/3x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ox/wP/3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E961F00A3A;
	Thu, 30 Jul 2026 10:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785407240;
	bh=6rSWr8fwtQYxD1TV1uSRrl7zL+hfWo5KR+aPAhxuFaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ox/wP/3xzPcJeze1Fbmzb28eblDtZOzvFInLef/Wmpb5eOLT5ZIpEFKjfMBF8bFCN
	 0GZ5fJxkl/vDAygREJIIa6DOkaBkqPcUksXAlVYGkHUu/IoAGmv8ah4JyDm2BiRD3T
	 reZ6b4Dv6CHXJTa1X9vC86eoJY2HNcvb8bXKk1pd4JhSA8m3Vc0QAv0r8yA7SXivFn
	 nGR413as5d7L0TCvbaAM26HnQRxMXIP9qRBQDDPQV/MtkDNw/Du4zZok2sEByOvvIP
	 Ouu8py23NZlBF1zHPZGL7e9OwU6f3S37ETDxUeLftzQtJ5HqesluqlFR8yS2ompMX4
	 7TsMFDQkSLqFA==
Date: Thu, 30 Jul 2026 13:27:13 +0300
From: Leon Romanovsky <leon@kernel.org>
To: kernel test robot <lkp@intel.com>, Marco Elver <elver@google.com>,
	Guo Ren <guoren@kernel.org>
Cc: Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: Re: [rdma:wip/leon-for-next] BUILD REGRESSION
 a273210687f255b12c2f6baf8f25ff80cdbb29ed
Message-ID: <20260730102713.GO12003@unreal>
References: <202607280004.TAQWia5O-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202607280004.TAQWia5O-lkp@intel.com>

On Tue, Jul 28, 2026 at 12:30:20AM +0800, kernel test robot wrote:
> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git wip/leon-for-next
> branch HEAD: a273210687f255b12c2f6baf8f25ff80cdbb29ed  RDMA/cxgb4: remove dead NULL checks after GFP_NOFAIL allocations
> 
> Unverified Error/Warning (likely false positive, kindly check if interested):
> 
>     drivers/infiniband/hw/mthca/mthca_provider.c:946:1: internal compiler error: in final_scan_insn_1, at final.cc:2823
> 
> Error/Warning ids grouped by kconfigs:
> 
> recent_errors
> `-- csky-allmodconfig
>     `-- drivers-infiniband-hw-mthca-mthca_provider.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc

AI suggests this is a GCC 16 bug, with mthca affected as collateral
damage.

"It’s a csky backend bug against GCC 16, exposed (not caused) by
commit 0fc1bd38a19c “slab: improve KMALLOC_PARTITION_RANDOM randomness”
switching the token to _CODE_LOCATION_."

Thanks

> 
> elapsed time: 884m
> 
> configs tested: 94
> configs skipped: 2
> 
> tested configs:
> alpha                            allnoconfig    gcc-16.1.0
> alpha                           allyesconfig    gcc-16.1.0
> alpha                              defconfig    gcc-16.1.0
> arc                             allmodconfig    gcc-16.1.0
> arc                             allyesconfig    gcc-16.1.0
> arc                           randconfig-001    gcc-8.5.0
> arc                  randconfig-001-20260727    gcc-8.5.0
> arc                  randconfig-002-20260727    gcc-8.5.0
> arm                      imx_v4_v5_defconfig    clang-24
> arm                  randconfig-001-20260727    gcc-8.5.0
> arm                  randconfig-002-20260727    gcc-8.5.0
> arm                  randconfig-003-20260727    gcc-8.5.0
> arm                  randconfig-004-20260727    clang-20
> arm64                         randconfig-001    gcc-14.3.0
> arm64                randconfig-001-20260727    gcc-9.5.0
> arm64                randconfig-002-20260727    gcc-8.5.0
> arm64                randconfig-003-20260727    gcc-8.5.0
> arm64                randconfig-004-20260727    gcc-15.2.0
> csky                            allmodconfig    gcc-16.1.0
> csky                 randconfig-001-20260727    gcc-11.5.0
> csky                 randconfig-002-20260727    gcc-9.5.0
> hexagon              randconfig-001-20260727    clang-22
> hexagon              randconfig-002-20260727    clang-24
> i386                            allmodconfig    gcc-14
> i386       buildonly-randconfig-001-20260727    gcc-14
> i386       buildonly-randconfig-002-20260727    gcc-14
> i386       buildonly-randconfig-003-20260727    gcc-14
> i386       buildonly-randconfig-004-20260727    clang-22
> i386       buildonly-randconfig-005-20260727    clang-22
> i386       buildonly-randconfig-006-20260727    gcc-14
> i386                 randconfig-001-20260727    clang-22
> i386                 randconfig-002-20260727    gcc-14
> i386                 randconfig-003-20260727    clang-22
> i386                 randconfig-004-20260727    gcc-14
> i386                 randconfig-005-20260727    gcc-12
> i386                 randconfig-006-20260727    clang-22
> i386                 randconfig-007-20260727    clang-22
> i386                 randconfig-011-20260727    clang-22
> i386                 randconfig-012-20260727    clang-22
> i386                 randconfig-013-20260727    clang-22
> i386                 randconfig-014-20260727    clang-22
> i386                 randconfig-015-20260727    clang-22
> i386                 randconfig-016-20260727    gcc-14
> i386                 randconfig-017-20260727    gcc-13
> loongarch                          defconfig    clang-24
> loongarch            randconfig-001-20260727    gcc-16.1.0
> loongarch            randconfig-002-20260727    gcc-15.2.0
> nios2                            allnoconfig    gcc-11.5.0
> nios2                randconfig-001-20260727    gcc-8.5.0
> nios2                randconfig-002-20260727    gcc-11.5.0
> parisc                          allmodconfig    gcc-16.1.0
> parisc                          allyesconfig    gcc-16.1.0
> parisc                             defconfig    gcc-16.1.0
> parisc               randconfig-001-20260727    gcc-12.5.0
> parisc               randconfig-002-20260727    gcc-8.5.0
> powerpc              randconfig-001-20260727    gcc-11.5.0
> powerpc              randconfig-002-20260727    gcc-8.5.0
> powerpc64            randconfig-001-20260727    gcc-8.5.0
> powerpc64            randconfig-002-20260727    clang-18
> riscv                randconfig-001-20260727    gcc-9.5.0
> riscv                randconfig-002-20260727    gcc-11.5.0
> s390                 randconfig-001-20260727    clang-24
> s390                 randconfig-002-20260727    gcc-8.5.0
> sh                                 defconfig    gcc-16.1.0
> sh                   randconfig-001-20260727    gcc-15.2.0
> sh                   randconfig-002-20260727    gcc-16.1.0
> sparc                         randconfig-001    gcc-16.1.0
> sparc                randconfig-001-20260727    gcc-16.1.0
> sparc                randconfig-002-20260727    gcc-8.5.0
> sparc64              randconfig-001-20260727    gcc-10.5.0
> sparc64              randconfig-002-20260727    gcc-12.5.0
> um                   randconfig-001-20260727    gcc-14
> um                   randconfig-002-20260727    clang-21
> x86_64     buildonly-randconfig-001-20260727    gcc-14
> x86_64     buildonly-randconfig-002-20260727    gcc-14
> x86_64     buildonly-randconfig-003-20260727    clang-22
> x86_64     buildonly-randconfig-004-20260727    clang-22
> x86_64     buildonly-randconfig-005-20260727    gcc-14
> x86_64     buildonly-randconfig-006-20260727    gcc-14
> x86_64                        randconfig-001    gcc-14
> x86_64               randconfig-001-20260727    gcc-13
> x86_64               randconfig-002-20260727    clang-22
> x86_64               randconfig-003-20260727    gcc-14
> x86_64               randconfig-004-20260727    clang-22
> x86_64               randconfig-005-20260727    clang-22
> x86_64               randconfig-006-20260727    clang-22
> x86_64               randconfig-071-20260727    gcc-12
> x86_64               randconfig-072-20260727    gcc-14
> x86_64               randconfig-073-20260727    gcc-14
> x86_64               randconfig-074-20260727    clang-22
> x86_64               randconfig-075-20260727    gcc-12
> x86_64               randconfig-076-20260727    gcc-14
> xtensa               randconfig-001-20260727    gcc-14.3.0
> xtensa               randconfig-002-20260727    gcc-8.5.0
> 
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
