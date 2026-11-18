Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794993130;
	b=ht3KFlbAKM8LI5/wBIxeq2/nrWlISSedcfbwat2+dSuk0wpUyI70ZwCCg7t/VOWbmZoG
	 iGxbgGI/jiHCdBeBK3NNEa7Pb0zMwwucWJ8IsAOa855DQb+D0Cd9QxYyX/JhlPLkOyGQv
	 Bb03Clt26+D5BjzehS2ARPgeNVnmtXP15ok8D59h7RYgWPOSLXCiIQuS5BrxaVzSNI3Vf
	 7xmk2U167U0gc0yQ/Io9aKYvcM5tQVTolvbAInwWpIqwAgurPp1zlnpuxdVg7M6u0wVGM
	 GLqTgrx8QQJ9+jJ09u3j+gv/eZQZGfOl2nQDAdN3dN+uEIYxC5W9pJddcA4OdGIEpwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794993130;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=kyPEMtNB1WsJRDOsvvodLv8gkX0hMfYjt/jgN5NieCg=;
	b=GI3zmxJTJ+EeO97Jdx7t1O8NEnrPNYbZkQbhb0gk/gr0G/uQiFOJNuAKWRrIca1BmDCW
	 JusBsvnH+Qfd/3hZ4DS3BQuGt1eS3zjAAcUSOo/4COFEuyIJla+EjqoLDWktzyKChKLIf
	 /s8KL9P69WRg31gA73NtMd3jVjXohFa2PweFBjT3H9i5P9EDeOhL2dc/hyKRAEgRvdLKN
	 FvX0d5ltlWW7QXU9+fX+OloDSiWQjRFZKu3B5SXIDhEItikKlNolHH8sHIAYJAk3mbjFe
	 KiMKfONxiC6LXRn6f5PafhmNkhTvxmlNlZRuN4GWGkIxYZEusV5RtPJ42MLiLdiz+qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HSs0rVMk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963A5606A88E;
	Wed, 18 Nov 2026 09:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HSs0rVMk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8F31F000CE;
	Wed, 18 Nov 2026 09:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794993130;
	bh=kyPEMtNB1WsJRDOsvvodLv8gkX0hMfYjt/jgN5NieCg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=HSs0rVMkt8QPfo1izHLhXCbm2oXS26L7g07R6UtZ+fWcSQsH8sure7+EyY1i2C4rj
	 4WMPyBNQ1tYAG/lNCYR9MNyxmYCTR4d5K5M06M+Al/KlVaAw6gXGmUUC1f47py2GJK
	 maqFVHOYoh6ljsrz5YrRLWdIvBP+lVKQCrRyui0Wcq5gnWeDYnHojxjPjeE8tRmYwn
	 Pf9j9RLgt7HhZg5lUFQZgWHM+mfPCD/7xDR6xB07vbyWrw/lJSMtwj5cr8R0rXPMVv
	 xBBeIZpkGfPYEGk1mmQQ4vqUw87waj71xL2GFL1MedESdKWo8EuVMSvjt39r0k845X
	 3JlLFAsXvrZ0Q==
Subject: Re: [PATCH net-next] net/mlx5: E-Switch, Size FDB peer groups for
 asymmetric peers
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, gal@nvidia.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, moshe@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com,
 udar@nvidia.com
Date: Wed, 18 Nov 2026 09:12:08 +0000
Message-ID: <179499312875.3136.7073415507714082354@kernel.org>
In-Reply-To: <20261116210917.1297111-1-tariqt@nvidia.com>
References: <20261116210917.1297111-1-tariqt@nvidia.com>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In SMFS/HMFS mode, esw_max_vports() returns the fixed
  MLX5_ESW_MAX_VPORT_ID (4095) and ignores esw->total_vports.
- [Low] The patch changed how the send-to-vport and peer-miss groups are
  sized, but left the comment and the table_size formula in…

--

net/mlx5: E-Switch, Size FDB peer groups for asymmetric peers

The patch changes how the slow path FDB send-to-vport and peer-miss groups
are sized in SW and HW steering modes. They now use a fixed architectural
vport maximum, MLX5_ESW_MAX_VPORT_ID, instead of the local total_vports.
This lets asymmetric peers pair. FW steering keeps the existing sizing.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index 4747841310914..20eca8b89b8f4 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -1744,6 +1744,17 @@ esw_chains_destroy(struct mlx5_eswitch *esw, struct mlx5_fs_chains *chains)
>  
>  #endif
>  
> +/* SW and HW steering tables are unbounded, so they can be sized for any peer.
> + * FW steering is bounded by log_max_ft_size, so it uses local total_vports.
> + */
> +static int esw_max_vports(const struct mlx5_eswitch *esw)
> +{
> +	if (esw->dev->priv.steering->mode == MLX5_FLOW_STEERING_MODE_DMFS)
> +		return esw->total_vports;
> +
> +	return MLX5_ESW_MAX_VPORT_ID;
> +}

[Severity: Medium]
In SMFS/HMFS mode, can esw_max_vports() return less than the old sizing?

MLX5_ESW_MAX_VPORT_ID is 4095, which is the width of the ESW_VPORT_BITS
field in the reg_c_0 source-port metadata. It limits the number of vports
only when vport-match metadata is enabled. In that case
esw_offloads_vport_metadata_setup() fails with -ENOSPC if there are more
than 4095 vports:

	return vport->metadata ? 0 : -ENOSPC;

Metadata matching can be turned off, though. One way is the
esw_port_metadata devlink parameter. Another is a device without metadata
support. The FDB then matches on the 16-bit source_port/source_sqn space,
and nothing limits total_vports to 4095. total_vports comes from firmware
(VFs plus mlx5_sf_max_functions() and the host-PF/SPF SFs and EC VFs).

If total_vports goes above 4095 in that configuration, both groups end up
smaller than before:

  send-to-vport: 8 * (4095 * 32 + 256) = 1,050,368 entries,
                 versus 8 * (32 * N + 256) before
  peer-miss:     4094 * 7 = 28,658 entries,
                 versus (N - 1) * 7 before

Once the number of rules goes past the new capacity, would insert_fte()
fail here?

	index = ida_alloc_max(&fg->fte_allocator, fg->max_ftes - 1, GFP_KERNEL);

Peer-miss or send-to-vport rule installation would then fail, where the old
sizing worked.

Would max(esw->total_vports, MLX5_ESW_MAX_VPORT_ID) keep the old sizing as
a lower bound?

A smaller point: the new public macro is named MLX5_ESW_MAX_VPORT_ID, but
real vport numbers are 16-bit (MLX5_VPORT_UPLINK is 0xffff and
MLX5_VPORT_ECPF is 0xfffe). Here it is used as a vport count, not an ID.
Would a name tied to the metadata field width be clearer?

> +
>  static int
>  esw_create_send_to_vport_group(struct mlx5_eswitch *esw,
>  			       struct mlx5_flow_table *fdb,
> @@ -1771,7 +1782,9 @@ esw_create_send_to_vport_group(struct mlx5_eswitch *esw,
>  	}
>  
>  	/* See comment at table_size calculation */
> -	count = MLX5_MAX_PORTS * (esw->total_vports * MAX_SQ_NVPORTS + MAX_PF_SQ);
> +	count = MLX5_MAX_PORTS *
> +		(esw_max_vports(esw) * MAX_SQ_NVPORTS + MAX_PF_SQ);
> +

[Severity: Low]
This isn't a bug, but should the comment and the table_size calculation in
esw_create_offloads_fdb_tables() be updated as well? The cross-reference
above now points at text that no longer matches this group:

	/* To be strictly correct:
	 *	MLX5_MAX_PORTS * (esw->total_vports * MAX_SQ_NVPORTS + MAX_PF_SQ)
	 [ ... ]
	 * the peer miss group should also be created based on the number of
	 * total vports of the peer (currently is also uses esw->total_vports).
	 */
	table_size = MLX5_MAX_PORTS * (esw->total_vports * MAX_SQ_NVPORTS + MAX_PF_SQ) +
		     esw->total_vports * MLX5_MAX_PORTS + MLX5_ESW_MISS_FLOWS;

In SMFS/HMFS, both the send-to-vport group and the peer-miss group now use
esw_max_vports(). table_size, and so ft_attr.max_fte, is still computed
from total_vports. The group index layout therefore goes well past the
max_fte the table asks for.

This works today only because mlx5_cmd_dr_create_flow_table() and the HWS
create path overwrite the value:

	ft->max_fte = INT_MAX;

Nothing at the table_size site records that dependency. Could the comment
mention it?

>  	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
>  	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, *ix + count - 1);
>  	*ix += count;

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116210917.1297111-1-tariqt%40nvidia.com
