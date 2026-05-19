Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE18A33BBAF;
	Tue, 19 May 2026 14:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779201430; cv=none; b=uouh/Qlf1H0EhK/4yNYWUfyY/k0x5c28wiXTPXDvnERFpvS52hJWsciGthuVE7UqZAem94mh/8bp1w4HGm6e6qoxwHmyXy52i27WVmUCuAHgzrgBBv2VKH7H65ot4VMYDA3GWLI1Evz/5QgXUTnjuqUf2OV5UMtzI9hJOOsn7/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779201430; c=relaxed/simple;
	bh=+a2mLdBcsDsGU+5BGxIWppLWszl9Od7wqmJ0aNKiRJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D/gLHA81Jmq9z6MZnKD26jih7kH+8oKZY/q9P/Htk+KcCWtWZmD/Mwzh32kXdLA6zTsQ9+h1EqUmyN8EeGw2zZUOhwCp+UpHXXnCBwdlD0sfR82YpGSc/ufkIpIe3uV9TE2DemM8BIU1u/iVtj0uGtx4x2eGjq0UwAGq9fDMgtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cg/WX+0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cg/WX+0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C493DC2BCB3;
	Tue, 19 May 2026 14:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779201430;
	bh=+a2mLdBcsDsGU+5BGxIWppLWszl9Od7wqmJ0aNKiRJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cg/WX+0qLWt63pPbkt2cfcw3AIzRrO06o8o9d85fML38Pdxdw0/9KFC/l+/o4TpCn
	 C4Msv/nAseZVQNiI36nDHzcjWUXFGroxS6uE1OopMmZh6xfYHlNizSfHYxmI96gL6/
	 UxxCu4i8s7Z6Xd8wiYd9l0mT9yzKMaLAgpxxwdhyPU1CN+8XMY9E1prY9C6i1SvagB
	 quWE9mzHgyWNG/LNlRC0jPLCIIaqRvO8RUA7dGtFd1sUZoc1nb8h53zWCia1AYYSlG
	 W2W6S3mnlWN9SoOIVCeuXAXBdY5ggqq5GDBUkc1si0fj0VeDVmQVAfbO6YumkkhGAZ
	 pR/mnD6hCdn+A==
Date: Tue, 19 May 2026 17:37:04 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Max Makarov <makarov@volta.cloud>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, saeedm@nvidia.com,
	tariqt@nvidia.com, mbloch@nvidia.com
Subject: Re: [QUESTION] mlx5: format_select_dw_8_6_ext capability on
 ConnectX-7
Message-ID: <20260519143704.GY33515@unreal>
References: <177912266235.29998.14244693862353385829@volta.cloud>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <177912266235.29998.14244693862353385829@volta.cloud>

On Tue, May 19, 2026 at 01:44:22AM +0900, Max Makarov wrote:
> Hi,
> 
> Question about the cmd_hca_cap_2.format_select_dw_8_6_ext bit (introduced
> into mlx5_ifc.h in v6.12-rc1).
> 
> On all three of our standalone ConnectX-7 SKUs (PSIDs MT_0000000838,
> MT_0000000840, MT_0000000892, firmware 28.48.1000) this bit reads as 0 in
> both GET_CUR and GET_MAX modes. The DPDK code at
> drivers/net/mlx5/hws/mlx5dr_cmd.c reads it without any device-ID
> conditional, so it appears to be exclusively firmware-controlled — yet
> firmware reports 0 across all our CX-7 cards, including the latest
> public release.
> 
> This blocks DOCA Flow CT pipe for IPv6 (which requires the 11-DW jumbo
> STE format gated by this bit).
> 
> Two questions:
> 
>   1. Is the kernel's filter that rejects SET_HCA_CAP for cap_class != 
>      MLX5_CAP_GENERAL intentional? If so, what's the rationale?
> 
>   2. From the NVIDIA side: is this capability hardware-fused on standalone
>      CX-7 (BlueField-3 advertises it as 1), or could a future firmware
>      release enable it on CX-7?

Please contact your NVIDIA support representative.

Thanks

> 
> Thanks,
> Max Makarov
> Volta Cloud
> 
