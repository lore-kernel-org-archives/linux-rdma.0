Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCAC3B1ED0;
	Mon, 28 Sep 2026 19:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790623310; cv=none; b=kyYy3pA4B/uWSgKnnOSMA11mWFX4t3HPNCqj9Cwfd+jdWa1qD/vQLCiqgm5T+XhvCzEy/vdLWBogi9WGdoQyK0+jY6ntxSH3uL8sZ7eTXAcgaYD3GpSqjlbpTgJPiQTee7j31KOJUlD1cn06KNcPcIrdWtOOeFq6gHOQhuW1SPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790623310; c=relaxed/simple;
	bh=xNiXji1JKicsNeq85zmSlTMlaaBW2ay1qxJ/c3HshA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RRuR70zaP9N+6kxp/oAUpqWnVzQlk9f12OtC/QKL+Ho9/Go4qgFDkluvLYY6AoEAwG+X/xkMGeVxcoCYYl9E5Ll34no1onRyXfa80tSxFgkhgbNl+aGPUlhuxFgOhcsyiHZ/xn5mtlVNnWztzIvCiOtY2dPgPXDd6XJt4RY9deU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MILeeDzR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MILeeDzR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41AA1F000FF;
	Mon, 28 Sep 2026 19:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790623309;
	bh=OjyoOz0KsWQkFno9NOBUUr/sWby/N/75GVMSb1/DBSc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MILeeDzRp99qBDIzkPGCbW2f53JAegthHipxBvkmjnNWzxzQ83S5u3cp9d/PkCCmc
	 UCCxnOZ5Cx+mKajzqzKDzFlCF4GYYjCakrowKRwuAp9o8dJds6utDmIR1hp8aPD26D
	 ZKZmEgLILYgMYp9emjLag8T3z3/XU8i0h98p+qZ9DSui+HMfabiubv1ap+hcBWtTLx
	 pqEPtgBBjvL+/3oNu13qkaUpsfGDW+H44+tKLsnkuLpghkIC6Rzb/w46HE8WdI5no6
	 EBIWbNMCdLarai8ktEfB5VItQnjYozThknmBZ0XgI01donUiERXuUsfMKhY5rZge7U
	 j/657lUFBgNiA==
Date: Mon, 28 Sep 2026 22:21:45 +0300
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
Subject: Re: [PATCH v7 02/10] net/mlx5: Move HW constant groups from
 device.h/cq.h to mlx5_ifc.h
Message-ID: <20260928192145.GE563127@unreal>
References: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
 <2-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>

On Mon, Sep 21, 2026 at 07:35:42PM -0300, Jason Gunthorpe wrote:
> Generally the IFC file should contain enums for the fields it
> defines. Move the ones in device.h that are relevant to the VFIO
> selftests over to the IFC file:
> 
>   wqe_ctrl_seg_bits.opcode: all MLX5_OPCODE_* WQE opcodes
>   wqe_ctrl_seg_bits.ce: new MLX5_WQE_CE_* completion/event modes
>   cqe64_bits.opcode: all MLX5_CQE_* CQE opcode values
>   eqe_bits.event_type: enum mlx5_event (all event types)
>   cmd_out_bits.status: all MLX5_CMD_STAT_* status codes
>   query_hca_cap_in_bits.op_mod: enum mlx5_cap_mode
> 
> Tidy MLX5_PCI_CMD_XPORT which is an alias of
> MLX5_CMD_QUEUE_ENTRY_TYPE_PCIE_CMD_IF_TRANSPORT.
> 
> No functional change. All existing users of device.h and cq.h
> continue to see these constants through the include chain.
> 
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  include/linux/mlx5/cq.h       |  10 ---
>  include/linux/mlx5/device.h   | 114 +------------------------------
>  include/linux/mlx5/mlx5_ifc.h | 123 ++++++++++++++++++++++++++++++++++
>  3 files changed, 124 insertions(+), 123 deletions(-)
> 

Thanks,
Acked-by: Leon Romanovsky <leonro@nvidia.com>
