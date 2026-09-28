Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4302F4279FE;
	Mon, 28 Sep 2026 19:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790623287; cv=none; b=UIdcqruGrapcKX0cO4ZHdn5zZJclEphS73DpEZg2bMR2J51lEBak7S5egikz59mZZXGLAlE+jL01eA9m81SR3vSW572T5elIlR5KrbKyourlpkBkA0bYZosw/whK9ImNL1meVorwoDWO7WyLag0YEwMrYRIeMJRxaTlAiszAc4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790623287; c=relaxed/simple;
	bh=b9lfiyIyYM8G17zyCirTa8wxaMOXO0jAkxDaziN70CA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZvWYL9udVL9z7DAXtCdLP/Qh0p4LrGHIYdQqhdq+bPlNVAaNzKWI4TFX6c+7M0Ye9kZg5JOJgG+L7goIAkzWSFpXJRFMWRtrG1Pr/EOsKZX+Q3guXs2SPuRK5tXdtCIH2iUwZrYyOKjzOuYiEK2EoKwICUnDGWOzYiuH1CpGhpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fEQ3jYA1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fEQ3jYA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566761F000FF;
	Mon, 28 Sep 2026 19:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790623286;
	bh=HWfeQceWTl+4wt/0jQZdDAsBX7hMCg9EEy37zg40zTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fEQ3jYA1LaaDKgA+/UrOu34F1HhqHXpi15LglY9DxnOWjKuUxoV3dTft11dnkB90y
	 sIz45jB/ip+pC9gztN4KLxmyTfyi4rVIcjaek0DpBn8NYP4/dj8L/S/JEc2zo0SMqJ
	 +8YDHxCzBDy1MaFFt383pMYzU4abMuCpalZ2ajVXPYaqdwNq2LqHjb3agczO1H8SjL
	 K3bsCuFjlP5lNKsU3RoJ5q9JDTAnMiXToMJy+GSCqv86ly8SiSBJEyC+yXWNm+Yw9g
	 7oOXgRPAaPPXj3qg7kiLnjkfmNCl9eEzNxgD3Ut2tQrsmY4cciRreoyea0uL5NP3xb
	 WLDPqoRMeNGYQ==
Date: Mon, 28 Sep 2026 22:21:21 +0300
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
Subject: Re: [PATCH v7 01/10] net/mlx5: Add IFC structures for CQE and WQE
Message-ID: <20260928192121.GD563127@unreal>
References: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
 <1-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>

On Mon, Sep 21, 2026 at 07:35:41PM -0300, Jason Gunthorpe wrote:
> Building the WQE and CQE using the IFC system is easier than with a
> C layout struct. Add definitions for their layout. Structs for:
> 
>   - wqe_ctrl_seg_bits (16B): WQE control segment
>   - wqe_raddr_seg_bits (16B): RDMA remote address segment
>   - wqe_data_seg_bits (16B): data segment
>   - cqe64_bits (64B): 64-byte CQE with error syndrome union
> 
> The VFIO mlx5 selftest will use these.
> 
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  include/linux/mlx5/mlx5_ifc.h | 55 +++++++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 

Thanks,
Acked-by: Leon Romanovsky <leonro@nvidia.com>
