Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795818740;
	b=PzUOC1pQdbnxaUV6Z8Wsy52Emdn+QJkH2t8zgIh2VmfSqFq1WnYVcn6MOjw7OXu8BkIr
	 ijHeFF5SqqNl8uRBPIUzg6h1zPYu0a6OzSKbOnoFQCGlLqv/XR8q0CIWqPtCsexdiE4gb
	 ipjDQQZ29LlzHTn88G/DSHQ5k1Sb66JHrDilBfFiMjfqxQ027hSWhAM8f9vH5SKsaQDyb
	 T1SE0SOaWxlxsu2A5EDcFFVxAiykEId/baqPshSZoaq+JJ+g1TJatUFSKEt4bYjb9aUDV
	 MG35xJCCKhuoVjiraHBtmQZzocmdhpezX6EkGtQIaTKDpvLmOvb0mTFfeA1xxyUU7iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795818740;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=nAJBQ8MIZaqTPQTUXwwLjElZiVs8zGff5Ry4tR4iEs8=;
	b=ola58XciaFMyTdMjhfsK/IXDifE7v+nXk3uA9WvvkYA+Fu21xwSUk4GwCFGzhBvPWzGG
	 v5wfGhEoOu/EggUiWJ0dDFsNrU3b8CeNxOEwwx8LZoe8T/DY39SNX44xiBG4Ou4DP+cvH
	 9DAkPpMINb2MkQgsQGHRfVXfsXwbC2xzHboBHtWJuHfUY+yP7j2iuFrOUl8advtsTK3It
	 lzlGYzcBdbOfPOzVzSJWe+HxehnHsAXUJq05PCHxsD5QxOLzPSf7mB9q/c0b81jJ/dcnI
	 xvTVk58haPZZ4H+Igxh85Yl7JpsR5WcraEXylhqAt69ycTpIn/uqRVipCVHXfg0Dj+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O6wCdCIk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2C1606A323;
	Fri, 27 Nov 2026 22:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O6wCdCIk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9B91F0089C;
	Fri, 27 Nov 2026 22:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795818739;
	bh=nAJBQ8MIZaqTPQTUXwwLjElZiVs8zGff5Ry4tR4iEs8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=O6wCdCIkjKpZGBkfK7+DnaI2/7sQIWJ/Ha5R1/FxHgG7ftY71DXI0iUmMdec6nonB
	 sAjHhNfKPGEfyjV1hyarAIQTl8c4Q6t2ApIRoyATXhUteqzp8TB3Jk4RZgat6+D7RN
	 lhXMlas90qf+Q9OJPkvMxaksIEbpvnlWKgwQKDxpVyDuwRVj3xBDa5SVfr+Kulf6TR
	 MBRVPUybMjxxsx2mdKias70gBI6R9m97zVOdYzlqjQ8blALJdyvqJOVR4Ut2cBbghh
	 8zUEWiQeCV4oUgaXkWPIRV20L4vygbSxu2wckzxtTdcVibb6+WRYW6tb8n1DnqPIo/
	 2VyajjiJjpFYQ==
Subject:
 Re: [PATCH net 10/10] net/mlx5e: Create IPsec flow counters once per SA
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 willemb@google.com, parri.andrea@gmail.com, borisp@nvidia.com,
 cratiu@nvidia.com, eedmunds@nvidia.com, gal@nvidia.com, jmassar@nvidia.com,
 jianbol@nvidia.com, kuniyu@google.com, leon@kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, phaddad@nvidia.com,
 raeds@nvidia.com, saeedm@nvidia.com, horms@kernel.org,
 sridhar.samudrala@intel.com, steffen.klassert@secunet.com
Date: Fri, 27 Nov 2026 22:32:18 +0000
Message-ID: <179581873809.3135.8819864252242771107@kernel.org>
In-Reply-To: <20261126215614.792598-11-tariqt@nvidia.com>
References: <20261126215614.792598-11-tariqt@nvidia.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The patch leaves dead per-SA counter fields behind.

--

net/mlx5e: Create IPsec flow counters once per SA

The IPsec flow counters used to be created and destroyed together with
the flow rules, so every rule update (for example after a neighbour
update) recreated them and lost the earlier counter values. This patch
creates the counters once when the SA is added, frees them when the SA
is freed, and moves them into a new sa_entry->fcs[] array.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> index e70189f81ffb9..2e8c6fc216de3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> @@ -216,13 +216,20 @@ struct mlx5e_ipsec_drop {
>  	struct mlx5_fc *fc;
>  };
>  
> +enum {
> +	MLX5_IPSEC_FC_RULE,
> +	MLX5_IPSEC_FC_REPLAY,
> +	MLX5_IPSEC_FC_AUTH,
> +	MLX5_IPSEC_FC_TRAILER,
> +	MLX5_IPSEC_FC_NUM,
> +};
> +
>  struct mlx5e_ipsec_rule {
>  	struct mlx5_flow_handle *rule;
>  	struct mlx5_flow_handle *status_pass;
>  	struct mlx5_flow_handle *sa_sel;
>  	struct mlx5_modify_hdr *modify_hdr;
>  	struct mlx5_pkt_reformat *pkt_reformat;
> -	struct mlx5_fc *fc;
>  	struct mlx5e_ipsec_drop replay;
>  	struct mlx5e_ipsec_drop auth;
>  	struct mlx5e_ipsec_drop trailer;

[Severity: Low]
This isn't a bug, but should replay, auth and trailer here still be
struct mlx5e_ipsec_drop?

After this patch nothing reads or writes
sa_entry->ipsec_rule.{replay,auth,trailer}.fc:

  rx_add_rule_drop_auth_trailer() and rx_add_rule_drop_replay() set
  only .rule.

  mlx5e_accel_ipsec_fs_del_rule() and the rx_add_rule() error path
  delete only .rule.

  mlx5e_xfrm_update_stats() now reads sa_entry->fcs[].

The only remaining user of mlx5e_ipsec_drop::fc is the shared
rx->status_checks.all rule in rx_create_status_checks(). That rule is
not per-SA.

As a result, every SA carries three counter pointers that are always
NULL, next to the real counters in sa_entry->fcs[]. A later change
that reads ipsec_rule.auth.fc, as mlx5e_xfrm_update_stats() did
before this patch, would still compile. It would then pass NULL to
mlx5_fc_query_cached(), which dereferences the counter without a
check.

Could these three members become plain struct mlx5_flow_handle
pointers, or use a rule-only type?

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> index d0f738fdeff3d..df90ae327f23f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c

[ ... ]

> @@ -212,19 +244,10 @@ static int rx_add_rule_drop_auth_trailer(struct mlx5e_ipsec_sa_entry *sa_entry,
>  	if (!spec)
>  		return -ENOMEM;
>  
> -	flow_counter = mlx5_fc_create(mdev, true);
> -	if (IS_ERR(flow_counter)) {
> -		err = PTR_ERR(flow_counter);
> -		mlx5_core_err(mdev,
> -			      "Failed to add ipsec rx status drop rule counter, err=%d\n", err);
> -		goto err_cnt;
> -	}
> -	sa_entry->ipsec_rule.auth.fc = flow_counter;
> -
>  	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP | MLX5_FLOW_CONTEXT_ACTION_COUNT;
>  	flow_act.flags = FLOW_ACT_NO_APPEND;
>  	dest.type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
> -	dest.counter = flow_counter;
> +	dest.counter = sa_entry->fcs[MLX5_IPSEC_FC_AUTH];

This is where the last write to ipsec_rule.auth.fc is removed. The same
happens to trailer.fc later in this function and to replay.fc in
rx_add_rule_drop_replay().

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261126215614.792598-1-tariqt%40nvidia.com
