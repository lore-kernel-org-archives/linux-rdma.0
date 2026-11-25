Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795613372;
	b=RSG7pWIDed//fMtm+6M36VXcqk9zGiOaAhoePV7MQqHWWq+eLtefP18U8vb4ejh+GB/H
	 kCxIYscR+fSj89Xaain66LB0gF0Y/ZmzwFFHIF5+x1Hx1UWpUgM/VfZ43EcEQsz/6PO0m
	 kHjSeNOHHBhhQP3RICB4sgvu7Nc043Y6PDLxqGU+fNptGJV4+yJobtw6MbjGimDl60TdW
	 TVPZcn+HUnY0uBKauL9gxkTVGTNaJtbXj0T0g8atr7d71q1tJJVZTTpiq/nSCAUg7Us8E
	 ut06ipHKmn/3wUMhYD2iXE85OKdu0JVfr+6fhFgcFi+JyZVfaDQtxCMHt2qF8/BsyWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795613372;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=MREAmVsMpWt0d6LopvXMCJWqj3NJInfKcqd/wmSDof0=;
	b=rziL2IdtCzCFPU6oZr4DU0H1/danrbXZZGwZ+phJV3miVukCFdsrE+S1UKiq2ZPQHJ8E
	 oERMOJR2+5Utc7wbSX6TcvQKLyqSLoVDioo6/q8crgzBriRBdYDPoDeyfEk/maAOxDoWF
	 9Ohl2EYtl64h0gZQa964yUz4IFwTLTNlBw49tXG0sw2QGwr4QXO1EXz+g3XIydG9xPDUS
	 zrOCziDK2eMA8/YoLMzWom4uIdOYB11sU0BEmts5CqYna3ZVyJaF4KxcQDclXjbhSUFH/
	 anB0ltwa234/C0kUSymHVVipddzLi3/eIiqXxRwggRl/BkTJ1xK/Dg400cT7uFgjrJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hyVxURu3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33602606A31E;
	Wed, 25 Nov 2026 13:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hyVxURu3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1421F000C0;
	Wed, 25 Nov 2026 13:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795613371;
	bh=MREAmVsMpWt0d6LopvXMCJWqj3NJInfKcqd/wmSDof0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hyVxURu3lneGuZKQdqMCK/A5/My4c7nH5bD2d8wlcPkZIZSgVQtrtM275+bi0HGhb
	 o0DI3jOfRueuBL74Cof3fpZ1TIuJ4qi6f6XuERff1HLWPBHn8c1LycSh9xxWgH2Ps7
	 InPNhR6in5KySLL10j1EuoyKRZDWagFGY2Zf6211g6Q7xJM7U+JVJ4Sy/n/rN0uUsi
	 XwjCnmTCUXd4UkotGCckPpozYFE0whNY+JJuJ0xD5N2KOR6sZhLOheizy6MkdXrb1W
	 GZSzcY3Ri3+YNTg08Lo56k70v61w1Q/UYL5K80NAsC5JWWbfMVcvHNoLmhU0uZ9CzB
	 ODSxh17BE7xdw==
Date: Wed, 25 Nov 2026 15:29:27 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Edward Srouji <edwards@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Sabrina Dubroca <sd@queasysnail.net>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, Akiva Goldberger <agoldberger@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>
Subject: Re: [PATCH rdma-next 00/11] RDMA/mlx5: Preparation for SD support
Message-ID: <20261125132927.GC14811@unreal>
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>

On Tue, Nov 17, 2026 at 04:01:11PM +0200, Edward Srouji wrote:
> This series prepares mlx5_ib for Socket Direct (SD), where one IB device
> spans several core devices, one per PCIe function. Today the driver
> assumes a single core device per IB device and reaches it through
> dev->mdev all over the code.
> 
> Instead, each call site now finds its core device through the resource
> it works on: QPs, SRQs, AHs and MWs through their PD, and DEVX objects,
> UARs and mmaps through their ucontext. A CQ and an MR store the core
> device they were created on, since they cannot always reach their owner
> when they need it. The SD series can then change where a resource lives
> in the resolvers, without touching the call sites.
> 
> The resolvers follow one naming scheme: <resource>_to_mdev() returns a
> core device and <resource>_to_dev() an IB device. Where several resource
> types are accepted, a _Generic() dispatches to per-type helpers, which
> are prefixed with '__' and are not meant to be called directly.
> 
> State kept once per IB device, such as the ODP page-fault EQ, delay drop
> and local loopback, stays on dev->mdev. The SD series decides how each
> of them works across core devices.
> 
> This series only changes how each call site finds its core device. With
> one core device per IB device every resolver returns dev->mdev, so the
> behaviour is unchanged. Pre-existing issues in the touched code are
> intentionally left alone so that each patch stays a mechanical
> conversion.
> 
> Patches 1-2:  name device pointers consistently, dev for the IB device
>               and mdev for the core device.
> Patches 3-7:  resolve the core device through the PD.
> Patches 8-11: resolve the core device through the ucontext, and keep it
>               on the CQ.
> 
> Signed-off-by: Edward Srouji <edwards@nvidia.com>
> ---
> Akiva Goldberger (11):
>       RDMA/mlx5: Enforce dev/mdev naming for device pointers
>       RDMA/mlx5: Rename to_mdev() helpers that return an IB device
>       RDMA/mlx5: Select the PD and SRQ core device through the PD
>       RDMA/mlx5: Select the core device through PD for QP commands
>       RDMA/mlx5: Cache the MR core device and resolve the MW's via its PD
>       RDMA/mlx5: Select the AH core device through their PD
>       RDMA/mlx5: Select the QP core device through its PD
>       RDMA/mlx5: Resolve core device from ucontext for DEVX resources
>       RDMA/mlx5: Cache the CQ core device and resolve it via cq_to_mdev()
>       RDMA/mlx5: Resolve the bfreg UAR-index core device from the ucontext
>       RDMA/mlx5: Resolve UAR and mmap core devices via the ucontext

This series does not apply cleanly to my wip/leon-for-next branch.
Please rebase and resend.

Thanks
