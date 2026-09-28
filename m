Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E8E3B1ED0;
	Mon, 28 Sep 2026 19:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790623362; cv=none; b=dPpGTamRHAMmQo0TLVZXHPc+TddDF/mYuZ+jGbZ73vaQF1HNuNk0XuBrtJ0TmdKQff2GCxBw8g7qJMLhRCb8jCrOaOUS9IN4iA1kgIxMGJ9MB3JiM1HqbV96df0mLXkNcyBM4/u4zNx1uXy8DNuaIczIO+wZMwhBdAUDxGAI818=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790623362; c=relaxed/simple;
	bh=IzW2nsqlf5P75lhE6jm/a3IKq2x3LPjcPGXGnavsXgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j+iI7Sg9O1dIX94sg2wfPBhWx+14NU8HYWATSMBF/yfyZX3tRKL7Sx1WGPJofSbi5T/uOjUvk/CZE6NsAwvQ+eG3gJ1s+xRxgziIODVH3W1fsA7p0XSUL9YaaopZFHPH0xN/TaYKsyGVWyco91SO4oKfL+uDwHHyFeWUt4vwgFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PbWcEIwa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PbWcEIwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C361F000FF;
	Mon, 28 Sep 2026 19:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790623360;
	bh=BtQtx4AiOoxIUWF52v492teIG0M7J+4dI2QJwDWLz0I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PbWcEIwaUcODHGEWBMbiqHhtpku8qEZ8fQhiKRaNWnk16t11t8skaxOev2PtGa0fU
	 12Xb/igtIUBYB+dLAbDmyJMHBy4H57dPnbrKr3Jh0c718ZSQDgRDYXrmpqPnicFZBG
	 SjE+Ug5FK9OVyGYh8gyFjJ/gy+cUzo9MqXOUBwhBFUNgpfEt3cqqQwTeXbxTqEI3BK
	 GDJuEvvYsA3rwpwXNq7pYOlbBvXNbPTEQSVZUnPO9GLdV5HaqCPPuAUrtPyZXyAESY
	 KaTPDy7yvIPdvqAhdOgbBtU8lxMCCAl+OKIItBJ8X+g0ooydylrHmdCtqMAxsTpmBQ
	 tZjwOXvrOw/PA==
Date: Mon, 28 Sep 2026 22:22:36 +0300
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
Subject: Re: [PATCH v7 03/10] net/mlx5: Extract MLX5_SET/GET macros into
 mlx5_ifc_macros.h
Message-ID: <20260928192236.GF563127@unreal>
References: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
 <3-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>

On Mon, Sep 21, 2026 at 07:35:43PM -0300, Jason Gunthorpe wrote:
> Extract the entire MLX5_SET/GET macro family and their internal
> helpers from device.h into a new lightweight header
> (include/linux/mlx5/mlx5_ifc_macros.h).  device.h cannot be
> included by the VFIO selftest because it pulls in rdma/ib_verbs.h;
> the macros themselves depend only on endian helpers, BUILD_BUG_ON,
> and basic C types.
> 
> The moved macros include the internal helpers (__mlx5_nullp through
> __mlx5_st_sz_bits), all size/address macros (MLX5_ST_SZ_BYTES,
> MLX5_BYTE_OFF, MLX5_ADDR_OF, etc.), the 32-bit accessors (MLX5_SET,
> MLX5_GET, MLX5_SET_TO_ONES, MLX5_ARRAY_SET, MLX5_GET_PR), the
> 64-bit accessors (MLX5_SET64, MLX5_GET64, MLX5_ARRAY_SET64,
> MLX5_GET64_PR), the 16-bit accessors (MLX5_GET16, MLX5_SET16), and
> the big-endian getters (MLX5_GET64_BE, MLX5_GET_BE).
> 
> device.h includes the new header so existing kernel code is
> unchanged.
> 
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  include/linux/mlx5/device.h          | 117 +----------------------
>  include/linux/mlx5/mlx5_ifc_macros.h | 133 +++++++++++++++++++++++++++
>  2 files changed, 134 insertions(+), 116 deletions(-)
>  create mode 100644 include/linux/mlx5/mlx5_ifc_macros.h
> 

Thanks,
Acked-by: Leon Romanovsky <leonro@nvidia.com>
