Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4546C50276F;
	Mon, 21 Sep 2026 18:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790016555; cv=none; b=J1voHsDUgNOTw0Lt/57xDvoHUx2B7MTJLqLEZnNdlLoi70b7LJtMiHO5IvbG9TzQa0YI+Hzm5VlWM1lp+e9wQOTzbdYWDPLxBO/o/kJaK0+2PaodesX+k181txh/7ngxMjoLI1q/JpsWzp4LH2kM5kgCGpowtMkW5zMr7FVapmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790016555; c=relaxed/simple;
	bh=AFL89REEBQLjBMFJITk4AzrZaVwR7eI3Fvytgd06XiQ=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UIzTsTgmuGZqXrzndxLP95b6p7ZRE65UAOUsc89IkvY4jTnCN3CSKeFXkxXc422bJt6YrzjuqG44yE11HM8rKadFzIl1myzOz6+0gW5Kffv17TBp7FdMvex4ceylrfBzfvZVLh3wdhYE+vj9zB3JQNRsMkfbucBBf83OmQAFNko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ya2DbeRf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ya2DbeRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646D21F000FF;
	Mon, 21 Sep 2026 18:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790016553;
	bh=G7hAYgZGFfOrmCCf0FsM0piPDmntH+vBA6Ukw0Nwpeg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Ya2DbeRf9WXDL11qKBZY1zZfmb/zwKX5HeF7CLBlIJwvQlVP9/t85v+sHqHaPE8/5
	 KNRP5c6PQu1D2bzyWKlc+bNfmvflXmxVKiDY4Etn2uKWAIR1kRv8QDtCADhHSBjFcU
	 eY2gNTnvNHhLn3M/NuSmTzC5KXKQ+j3SMe1gRbGtAK5yeLoW72T22YBJRnzFDfCfdp
	 Nv1YjKV7ftTxlbMdj7y9bIe2IE7dw2in0bZhA99Uc9kke5YoSzlXNP3vadr+lKy29D
	 wpJplrn/2i1mdVRSTodHmJQa8mOGqz5FcUl0624izM7KVvP9mh/KIFtZzF2E1MOtcG
	 DqkGBoPZRnIfQ==
Subject: Re: [PATCH net 7/7] net/mlx5e: shampo: Do not merge PSP packets
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 sd@queasysnail.net, borisp@nvidia.com, cjubran@nvidia.com, cratiu@nvidia.com,
 daniel.zahka@gmail.com, dtatulea@nvidia.com, ehakim@nvidia.com,
 gal@nvidia.com, jianbol@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, liorna@nvidia.com,
 mbloch@nvidia.com, parav@nvidia.com, raeds@nvidia.com, rrameshbabu@nvidia.com,
 roid@nvidia.com, saeedm@nvidia.com, steffen.klassert@secunet.com
Date: Mon, 21 Sep 2026 18:49:11 +0000
Message-ID: <179001655196.2160803.14482188682686687561@kernel.org>
In-Reply-To: <20260917175433.4090878-8-tariqt@nvidia.com>
References: <20260917175433.4090878-8-tariqt@nvidia.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] net/mlx5e: redundant #ifdef for PSP in mlx5e_hw_gro_psp_match()

--

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -2224,6 +2224,16 @@ static bool mlx5e_hw_gro_skb_has_enough_space(struct sk_buff *skb,
>  		return page_size * nr_frags + data_bcnt <= GRO_LEGACY_MAX_SIZE;
>  }
>  
> +static bool mlx5e_hw_gro_psp_match(struct sk_buff *skb, struct mlx5_cqe64 *cqe)
> +{
> +#ifdef CONFIG_MLX5_EN_PSP
> +	/* PSP packets cannot be merged. */
> +	return !mlx5e_psp_is_rx_flow(cqe);
> +#else
> +	return true;
> +#endif
> +}
> +
>  static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
>  {
>  	u16 data_bcnt		= mpwrq_get_cqe_byte_cnt(cqe) - cqe->shampo.header_size;

[Severity: Low]
The #ifdef CONFIG_MLX5_EN_PSP in mlx5e_hw_gro_psp_match() is
redundant. en_accel/psp_rxtx.h already provides a stub
mlx5e_psp_is_rx_flow() that returns false when CONFIG_MLX5_EN_PSP is
not set, so !mlx5e_psp_is_rx_flow(cqe) already evaluates to true in
that configuration, which is exactly what the #else branch returns.

Please drop the conditional and just return
!mlx5e_psp_is_rx_flow(cqe) unconditionally. That keeps both
configurations compiling the same code path, avoids the risk of the
two branches drifting apart when the PSP helper changes, and matches
the rest of the driver, which relies on the header stubs rather than
sprinkling #ifdefs through en_rx.c. It also means the stub keeps
getting type-checked when PSP is disabled.

While you are there: the skb argument of mlx5e_hw_gro_psp_match() is
never used. Is it there for a follow-up that will compare the
in-progress skb against the new CQE, or can it be dropped?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260917175433.4090878-1-tariqt%40nvidia.com
