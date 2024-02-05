Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4840610A2C
	for <linux-rdma@vger.kernel.org>; Mon,  5 Feb 2024 07:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707119902; cv=none; b=G8abu0LAvIKWN6E0cRKk2Ch9P9gM8jCwmB52AI/K6BGEYkXXEQ1JeeJsilKSfquCFAAqV4iWW/xyIctrge26OvTRI3J61VKb4hpR4IeGspCS/Kep00toZPRGUuUAl7Q0JusufGiLCYh4hlortbksCKDISlMjWdv09aoExK/EXSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707119902; c=relaxed/simple;
	bh=C1JYF1FWpSBMGGr1tZlKt6aacuvseCT05Hzht3z02+g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=CdYcbatuDVypBPWIU3w7FTWPMiizqCADl+By2+3TMr2Zta31oOq2eC8aFRFWcob31+Xs792j2nkEcsbP27hvZwV5/fhNK2cFTOP8FzJeM9qKPHWkK6bZngtWWzxDaG9m965VS3FI3RREF/f2uj9RTqKIfDPUtcPxnoSRUmGC89A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jsg7yQpU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jsg7yQpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C98C433C7;
	Mon,  5 Feb 2024 07:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707119901;
	bh=C1JYF1FWpSBMGGr1tZlKt6aacuvseCT05Hzht3z02+g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=jsg7yQpU6kL7V0f35yc0jHF7U1j/VUovOosYfl3j+Sts+vB1I29WZ8BbWieikrAVs
	 E/JgIvGZ8YX5RjYqE5/l8WMYypO4/+buDFuxtHXjxxHnpaoaKVCMd4Q5M1U53tlNuq
	 XAWaYPGH22Rton9QVylevTVGnyoDh9MYKWmP4U7WvmxaT4RJ+zF+xnWoJtDKfaFNVi
	 UdGFYQBHss49JHgOw65r1rXeA9aKhq/7oRmVJI9hZTabBOKKnGPqyM/P0q9At7nV8e
	 keS174PexHMnw99H/kCu9tQSZ0rI+VHLo8WvBPu9udw0V45jen6VrfD9me8JTCkVo7
	 drsf+buVBkvnw==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Bart Van Assche <bvanassche@acm.org>
Cc: linux-rdma@vger.kernel.org, LiHonggang <honggangli@163.com>
In-Reply-To: <20240205004207.17031-1-bvanassche@acm.org>
References: <20240205004207.17031-1-bvanassche@acm.org>
Subject:
 Re: [PATCH] RDMA/srpt: Support specifying the srpt_service_guid parameter
Message-Id: <170711989767.12126.15028858841791194927.b4-ty@kernel.org>
Date: Mon, 05 Feb 2024 09:58:17 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d


On Sun, 04 Feb 2024 16:42:07 -0800, Bart Van Assche wrote:
> Make loading ib_srpt with this parameter set work. The current behavior
> is that setting that parameter while loading the ib_srpt kernel module
> triggers the following kernel crash:
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> Call Trace:
>  <TASK>
>  parse_one+0x18c/0x1d0
>  parse_args+0xe1/0x230
>  load_module+0x8de/0xa60
>  init_module_from_file+0x8b/0xd0
>  idempotent_init_module+0x181/0x240
>  __x64_sys_finit_module+0x5a/0xb0
>  do_syscall_64+0x5f/0xe0
>  entry_SYSCALL_64_after_hwframe+0x6e/0x76
> 
> [...]

Applied, thanks!

[1/1] RDMA/srpt: Support specifying the srpt_service_guid parameter
      https://git.kernel.org/rdma/rdma/c/8658e2f26d8be1

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
