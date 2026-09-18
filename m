Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DC451AFEC
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 18:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789755159; cv=none; b=YR0jbZa2l5FiyxqxtpbpkffNnjTMJDIQNDOBBoOH68pv2WYRzEpk0IpQYBsXDmYf0GlQJCIdysm+BgCYS3l5IIL3C5CPKcMNf1GlgEq/H96d9xk7p4tQNlkZ2kChqKevZksM43oYpeplwQkfdjAoQXeCA9IbFIe6p8HqTRGOj18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789755159; c=relaxed/simple;
	bh=tdBhP5gX2TFR5GvMnW+RZXBm/nwNnDaLpbnK80Y29CE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oPQKIkkgcum9kxML7YsyPHJ9nSqoV2DR11+NGRDS+NAJ7rPdcd3EkQazRk3lru6sdxf73yqgFFR7oheH1Bn15RiUD9E8bD9UKZzHq8ff8dW8I2zgaA1IfdtzUuRhPvuCOYLLY5KR9e4P5EQn1mWyEltONCqsiN94tEtpEZC5KmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BoxMRNKJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BoxMRNKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A869F1F00898;
	Fri, 18 Sep 2026 18:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789755157;
	bh=LZ8KqucGKpWSI42MlvXHBAt6eVr2Wnw6HLOX+3uK5K8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BoxMRNKJqTXiUjRjrCeAO7aCiliu+tVV7jBH2Vo8wbopnL2vyojbxw6rWGc5oXvPu
	 cMF2XlzP/Rzl40LaATEtLMDmxAHsHyra4B+VbPO120bCIMAYKNESU5CGT5JEpoDHPI
	 NdokQzkBGQIWi6jUU5adcyzzZa4uphIaMUGI1l9PT2XLgdQZo44/T3Ittg+1dUjnGS
	 b196QwCAPTY1wWEvsGsFbQTrsta/mF1BDkk5EbpjuqCUB9WXPBjZsSkXk8B+AnmA69
	 /IJ3sXDKqoOwSRNshTZ3GCKmVBktjn7+IoqhOJ0t+f+C9LBWrQ1WND3moIyHus5tyP
	 uuh8jpmjblnUQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 7/7] net/mlx5e: shampo: Do not merge PSP packets
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917175433.4090878-8-tariqt@nvidia.com>
References: <20260917175433.4090878-1-tariqt@nvidia.com>
 <20260917175433.4090878-8-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 18:12:37 +0000
Message-Id: <20260918181237.A869F1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] net/mlx5e: redundant #ifdef for PSP in mlx5e_hw_gro_psp_match()
--

commit 872235ad0cec4a5566df3f8f48c830d7961b5ad2
Author: Cosmin Ratiu <cratiu@nvidia.com>

net/mlx5e: shampo: Do not merge PSP packets

This patch prevents merging of PSP packets in hardware GRO (SHAMPO) by
enforcing no match in SW. This resolves an issue where the HW GRO machinery
blindly merges UDP-encapsulated PSP packets as if they were regular UDP
payloads.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_rx.c
> index 7bd0606a52538..5e07cc8586f66 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -2224,6 +2224,16 @@ static bool mlx5e_hw_gro_skb_has_enough_space(stru=
ct sk_buff *skb,
>  		return page_size * nr_frags + data_bcnt <=3D GRO_LEGACY_MAX_SIZE;
>  }
> =20
> +static bool mlx5e_hw_gro_psp_match(struct sk_buff *skb, struct mlx5_cqe6=
4 *cqe)
> +{
> +#ifdef CONFIG_MLX5_EN_PSP
> +	/* PSP packets cannot be merged. */
> +	return !mlx5e_psp_is_rx_flow(cqe);
> +#else
> +	return true;
> +#endif

[Severity: Low]
This isn't a bug, but is this #ifdef necessary here?

Looking at drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h, it
already provides a dummy implementation of mlx5e_psp_is_rx_flow() that
returns false when CONFIG_MLX5_EN_PSP is disabled.

Because !mlx5e_psp_is_rx_flow(cqe) will correctly evaluate to true when
the config is disabled, could this #ifdef block be safely removed to avoid
macro clutter in the .c file?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917175433.4090=
878-1-tariqt@nvidia.com?part=3D7
