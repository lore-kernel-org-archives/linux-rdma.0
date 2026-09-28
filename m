Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCD64EB87C;
	Mon, 28 Sep 2026 19:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790623501; cv=none; b=D+oHT8xZ+xFQYEEx3B+IP8MR1CFz4KvXzzFTOAU8M2jqkl9OVQLYL7IINVpPspBhX9tK+eVB39/3DG5H3fQ93sgDs73EglG+t98JMw35MVRw/GWbvtoY8Wgar9npVY0/opBWtedpNtFakAaTg4YDvwlAjCMEVRgK80pNUi02nD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790623501; c=relaxed/simple;
	bh=ro3/3fheEqjppbkTvnlG9BjmlBEOGBFlHvLL8uCC8rE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o57Csftpy8Q5lCvV9eF8GhnYOJ4dVn3Fz91GSgvPcxgTcCgVM3JD29CsmFmTbRRqMh+2pbuNBO+braFK2ZwkRnnqQhNa5nt7mvngl1O8lwJoryJgVY8W+dZqVEe3MUEColdIxYcY+WCjkIkwYfJQ97836RFCANOvWxotbodrH/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XYEG3iWA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XYEG3iWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385251F000FF;
	Mon, 28 Sep 2026 19:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790623499;
	bh=zxaPe3RXYWfDysMbj1dNL8wCloA5fdLhj22QTkhmqgI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XYEG3iWArZn3su6Y0OK3+bWiRF575+VJU1q1+F+6KpJ02oYyJ9WXJX1dWH78AywBP
	 epGowUkfpKZONyTD2QyDEuS1h9FCT7IPC/xC640Ys19a4cm6rXRr9XfCDxlaWB3BGc
	 vu0xEdw9c3VLSmR9Xp1FViIj9iMn3+H3sIXFEnPiNhir4UQT8zqSjGsTlI6kFekF3D
	 4yGgHlvB9v/q+Gn0fWxY8KIWzT+xBilBwVCfRbnttO7X7GOnTVUsKSGpOTro/mclzi
	 ElIbrwOtezft7+rOlwl1tCtyLl2ApnJaqnbVvGJEBD94682YxcSIZy1b9sCPEAPyWY
	 2ihxu6ypJckhA==
Date: Mon, 28 Sep 2026 22:24:56 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, David Matlack <dmatlack@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, Oliver Upton <oupton@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sean Christopherson <seanjc@google.com>,
	Steffen Eiden <seiden@linux.ibm.com>, Shuah Khan <shuah@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Tariq Toukan <tariqt@nvidia.com>, Zenghui Yu <yuzenghui@huawei.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v7 04/10] net/mlx5: Add ONCE and MMIO accessor variants
 to mlx5_ifc_macros.h
Message-ID: <20260928192456.GG563127@unreal>
References: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
 <4-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>

On Mon, Sep 21, 2026 at 07:35:44PM -0300, Jason Gunthorpe wrote:
> Add MLX5_GET_ONCE / MLX5_SET_ONCE which include READ_ONCE/WRITE_ONCE
> semantics for touching ownership bits that hardware may read or write
> at any time. The kernel driver doesn't use the IFC struct for these
> ownership bits, but the VFIO driver will and needs these helpers.
> 
> Add MLX5_GET_MMIO / MLX5_SET_MMIO for accessing the init seg using
> the IFC offsets. They embed a readl/writel using the IFC struct to
> generate the addressing.
> 
> Add MLX5_ARRAY_GET64(), the missing counterpart to
> MLX5_ARRAY_SET64().
> 
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  include/linux/mlx5/mlx5_ifc_macros.h | 52 ++++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)

You should have updated the copyright in this commit or the preceding one.
However, this is not important, so there is no need to respin the series
just for this.

Thanks,
Acked-by: Leon Romanovsky <leonro@nvidia.com>
