Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1202847CA82
	for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 21:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786482889; cv=none; b=nulk12EdEuiacI0ZG7UD98Brop8GQ/pAKCY0729jBxcuiqWgEqAL0yEUFQNFzxJEG3M9MnLsBGpV6o1P6ltdTMtQOOfqz3r2jMFVil6IMP7zAhmLy6aXpzIDQ14XN/R99AbSCP6J0i++txhoPXYETntx8dZCv1XiA1grKf7BokU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786482889; c=relaxed/simple;
	bh=vELLWw0jcQS3izlB2sdDvaRC3WcKac/J6CTcP0dIWC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WUvPcrSqOw4PhPZ6l78qxRSZOWsVnLyGVqU4QdPhvlVABITAvpaSWt7PW0GBGo0VFR6gBu4uVzMOLMM7sLrPE/gVb4kByBjdW/5/j6xQJR/wth0YqmhII97JWRSoKLODBwNZ/oq0A/1jqA69W6I8IsCxGObW1wrFNghFNzq5rU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H+MFTJjL; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H+MFTJjL"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84e0688b7e8so330927b3a.1
        for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 14:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786482886; x=1787087686; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bsIA9G0uzM6tK8/PrMCXpabodZWsD0MRjRT85WaMGF4=;
        b=H+MFTJjL6DsFW2bzdPklh53KwLU1o6fu5ZdLvHvRyYZBSRBDNXc1mfw7Rmn9vx6wuB
         TVL7t3DDP0gxCQVFmbfKbcee4LFVgaOGZOaUQx9FJF3AYplQJbE9EDUE87C5KLY9x3VM
         K3o0LEMu+2mAPcQQ2tWaFzZBlhDEcv3QXxFikaf8A5j61EaZPghIAgORHVnuYl11g6P9
         ut9OCBpauyhJ5uYP+FdxMdDsJ2RZsV+BNdYEG8y3aRr26tm9HI5uHwS2ON5THX5QAZ9h
         bsXvRj3D6ROk1ILtMYNTwLm5ueHhrmCD6V1SuuEoA7k+faqDM810Sa50pDHDK93z2YRR
         sKdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786482886; x=1787087686;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bsIA9G0uzM6tK8/PrMCXpabodZWsD0MRjRT85WaMGF4=;
        b=Z3jIMmIkTGCpnTMdOtVDCyGwYi30gTrBebsDmHzIb6bF0ltJilPwL9GGffkBEMLP62
         HyCC33xBNngLZsAQF5HHZOLwXNwllZBdnTTfG/11LZRfUkEEfaGdITzvZ4BX6FxQyAxm
         Kl9xd0hMleTQQjSNmrOjwCvYhqgXfnIVDQyi7H6C+dm5RuwwYoX4hwX4cPWISvfxad8n
         mGjHb/zwZI5K73GIuob852CiBPsMQcbx6zBQQDWnFaUPKnvDRlg8YwGkElrhTApeIk93
         LxuT+/7glRILdyihI1EBdDhj0iIgXe9Mhrf0qGHr0gw78rmFEyliaD9SxWf8rU1omIpl
         kKsw==
X-Forwarded-Encrypted: i=1; AHgh+RpPcNGYbMygglybP0I+pU60GqL0KSgtoWqX7tWThbp9M3jWoLw7TqaW+LKr+RfbhenMTnR+zirRVlzi@vger.kernel.org
X-Gm-Message-State: AOJu0YwUyrIS8gEB80cm3uD46SWqiYy9BTKnhBEGj69dRvsl993DAUyy
	EPVfGdvjDoDTvldNr5qXOVecwjpqjDM8yc3DaXAoTtM6ZYeo/X1bwanQc7zmYRJqWQ==
X-Gm-Gg: AR+sD13K3y3iSUMmNmK0FgmIzAuyK89n3/8SnpJFEI8Wet/nwfjk0UbxzWCu3gWsKPq
	xvc+BHH2vTaLZ8VD2JVLnXRlSqj8YlHAfeiM9Q2lEhQdElSFN3TWjwqhcDF35KR82c2fH9r4E0Q
	sKyRmczTzYJMcQmHcx1XxDnS911Ef0i6xAHgIFPpPPn5sOxE2osgSMfo/ilvyBYXNf0GIKACcce
	j12qK08QKiNztxAw4kG1B56fQlcdH+RramfRr4/M7gXEIgIJSJe7OWPcrXVaRp6a146/zY9b0yy
	sTJFHIY3UExkmsxVJRDOlD0gbyfrXW9I/PjvvpXLZ9dozeea25ZgC0yL1xM537gH55j4YPHoOSx
	LJgOpQOnVIGYxJ8tPbyakK4p1S7ZdFMdXw3hbvn527giqEUgBT52vsK8bZcuFtTyMi3t2tjbWnz
	Q3dP9uCaSihkN2TKRBpv9tW8NYLV/D5LObV8/KQNzjcGn8qV/iz5O/voFH4t6+aN+dkFXHbYCe4
	Bjj43CQ9ookxTnm6SIKCNAWTRm8Tg==
X-Received: by 2002:a05:6a00:1d98:b0:848:4c0c:9482 with SMTP id d2e1a72fcca58-84fb5596c31mr161407b3a.35.1786482885795;
        Tue, 11 Aug 2026 14:14:45 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84fb1f2645bsm237399b3a.50.2026.08.11.14.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 14:14:45 -0700 (PDT)
Date: Tue, 11 Aug 2026 21:14:42 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Justin Stitt <justinstitt@google.com>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, llvm@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>, Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>, netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH v3 06/11] selftests: Fix arm64 IO barriers to match kernel
Message-ID: <anuQwhVv5UhjS_ER@google.com>
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

On 2026-07-16 02:03 PM, Jason Gunthorpe wrote:
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

With the changes to tools/testing/selftests/lib.mk removed,

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  tools/arch/arm64/include/asm/io.h | 20 ++++++++++++++++++++
>  tools/include/asm/io.h            |  2 ++
>  tools/testing/selftests/lib.mk    |  5 +++++
>  3 files changed, 27 insertions(+)
>  create mode 100644 tools/arch/arm64/include/asm/io.h
