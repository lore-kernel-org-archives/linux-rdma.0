Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7787D3C5849;
	Thu, 16 Jul 2026 23:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784244138; cv=none; b=XquskYr4NSzZbN5RuMrU65rKzkszw04sMvN8MbNoVkgqlLxcq+hGSem6B+Oz4vhrJOev7AbccyNavWVyGc+DzVSq9ioAYim6ERq4k1XJw7/lbFUQuW05+JoQ+G3qUCJURx+eTOn9d0ldo4UpbUHncvTm5EiAW3iuocC+yd0eqME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784244138; c=relaxed/simple;
	bh=Gfn0/+CmqhHCqdMGbsdfpLCBDcASJ2iWJ2fc/bSCHVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HCEqq1HS0qpLAt2woe7z4FZOnUxfEETlMJex3ZWAzNPMp+UZwzPXpG34MrTC62wEtwms7mmzOpIeVC/NvhQ7GxbYG6Xak2RxEkAxDPxxmEQDYbsninCwsvKfIcNBKapJo4oaANsnxqEv7VY5BSJVS1jsE/D+2Pva1mpSbEW+xjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aY295KNW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aY295KNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EFE1F000E9;
	Thu, 16 Jul 2026 23:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784244137;
	bh=g/aghe2CnYgAgeQmYgALqhq56GHiof2OpgCCZVP+lpM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aY295KNWGTg7rHwOF9SQrkFe9qsMOcWiDvxQy1RueBU616Hy+ntLOh2STTvSTmRUv
	 8Aay4O0FpoXViQ1fIJgyL0Loi+6xW05HVu1spdTGIHQYk7wafJQIAmqdAAClxKd28B
	 eIeRaIVVvlCpad+sjt5y0Ccfy/LThbqGTSqcThxohlKQxuPP0qEsyUCYwznViGdqm3
	 L/9OpYVhORRqfRbW/bOjaGuu5LkoOdB8jwjys+myrSerA0t+fW8yRUVKg2Q/yWHzVa
	 ywJIX2HE8NKRwtkiC1oBCfWzppdmOFQCltYScz8QCe3vEjHhSUTMA8rEuM3hjOx6BT
	 W7gKabgtgH5NA==
Date: Thu, 16 Jul 2026 16:22:10 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, David Matlack <dmatlack@google.com>,
	Justin Stitt <justinstitt@google.com>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, llvm@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>, Bill Wendling <morbo@google.com>,
	Nick Desaulniers <ndesaulniers@google.com>, netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH v3 06/11] selftests: Fix arm64 IO barriers to match kernel
Message-ID: <20260716232210.GA700430@ax162>
References: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
 <6-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>

On Thu, Jul 16, 2026 at 02:03:22PM -0300, Jason Gunthorpe wrote:
> The tools/include readl/writel MMIO accessors on arm64 use
> inner-shareable barriers (dmb ish) while the kernel uses
> outer-shareable (dmb osh).  Fix them to match.
> 
> Add __io_bw() and __io_ar() definitions matching the kernel's
> arch/arm64/include/asm/io.h, including the dummy control dependency
> in __io_ar() that orders MMIO reads against all subsequent
> instructions.
> 
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
...
> diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> index f02cc8a2e4ae32..fdd22df9174b88 100644
> --- a/tools/testing/selftests/lib.mk
> +++ b/tools/testing/selftests/lib.mk
> @@ -5,9 +5,14 @@ ifneq ($(filter %/,$(LLVM)),)
>  LLVM_PREFIX := $(LLVM)
>  else ifneq ($(filter -%,$(LLVM)),)
>  LLVM_SUFFIX := $(LLVM)
> +else ifneq ($(LLVM),1)
> +$(error Invalid value for LLVM, see Documentation/kbuild/llvm.rst)
>  endif
>  
>  CLANG := $(LLVM_PREFIX)clang$(LLVM_SUFFIX)
> +LD := $(LLVM_PREFIX)ld.lld$(LLVM_SUFFIX)
> +# Selftests link through $(CC), so point clang at the LLVM linker.
> +LDFLAGS += --ld-path=$(LD)
>  
>  CLANG_TARGET_FLAGS_arm          := arm-linux-gnueabi
>  CLANG_TARGET_FLAGS_arm64        := aarch64-linux-gnu

Was this hunk intended to be included in this change? It is not
mentioned anywhere. I assume this is the only reason that the LLVM folks
were CC'd on this series.

-- 
Cheers,
Nathan
