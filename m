Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794056720;
	b=cAzsIugb0StJYgue37QnXAvr+MQYgMK8dSPkBaB3LnrfGl+BpQcTdjfzM6HQk3YDeAGA
	 ZB1ABY0qVwRSJCt/SbdJ3sTLdyf2lOaNvCGlIu9r1X/dole8A8sYtmfHOAwCbjDdTyrot
	 aNKCcCFRfSTiOWlXl/Dd5XksXmD6qdaawnGItYYuMbvmNHoEV8gHyX3IWwfWtK01dEnc6
	 VJdcCXrL48R30X6+4xLFMl9VMa8zpFrUlvi+wsvyXoihNYefy+qDF3Z7SkyYqkg6R8ye9
	 I7cmvmrLAnz/+8NmRWWrh7rH3tmDv7RLd7zZ7JuC404WCHiUSYJX9UFIIUl883LzbGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794056720;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=bY5y/UpFh5i7nT5MZ0PdGQ5Q5A6XBRtLcJX0AZBBR4U=;
	b=fY264O1aPx9fmRO383fpAAg1d2oHaT2R8b4Bqihlon6NmV8l3qFoWlMAAlbz2g/Fb+C8
	 YK5EpIp7w7MrLMBawyQAxe0CnD1vnbJFJ8HMYaJd39nooWfirB5zJtc/mrK3Qk5B6UxV6
	 ZGv9SOtrWGPPwkR7Gd1Bv4m+TiV8n0bTFi4voEs9LttdKFGBvv03QJbm6xiX2H/ekEa2z
	 d3cSitWRYmg66ptg/DhiNpvq43ZpzLag8Aj88ASlv+wHjp33KrgVKbZ2IHcOtZP6d5OTc
	 xWMlHUD9UTsXMbMX0FoDi96ZlCgq7upC7LRO58S9PWl36rPWve5UVvxFbMF180h00Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PU04oNnE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6154E606A326;
	Sat,  7 Nov 2026 13:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PU04oNnE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7561C1F0089F;
	Sat,  7 Nov 2026 13:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794056720;
	bh=bY5y/UpFh5i7nT5MZ0PdGQ5Q5A6XBRtLcJX0AZBBR4U=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=PU04oNnEZ2a79nE9+6dLinYdrWVrs3mu9neB8uYlLChA6jT5+HmBurhUeEWgL84hn
	 Jjb+2BDPkH8vKa/DEZsUKCo/gY0rZw+kC00a+QE/rDpBKfb0AUfFdm7zXacNSvDATh
	 f+m2ikejvLmjbgiM7Bfb24OqBLGJQk2+jkSrDhehHYUnoGTgDyLntOc3iPFmKGnS6+
	 /lxbF4gLKdo/2ZJI2WWiXqIzBBvBgM5oUZ1A8O8V1V6Vy4F2pXzTs2mfuStxLZnudM
	 erdgfHk2r9h7GSx0NLMw0mo9h8oixyT/EZhdgIMa1Cxujf+HMCZyVWwNy4dDSojWKq
	 JMSVQVKlF7qRw==
Subject: Re: [PATCH] net/mlx5e: TC, release meter if rule offload fails
From: netdev-bot+sashiko@kernel.org
To: vulab@iscas.ac.cn
Cc: saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Date: Sat, 07 Nov 2026 13:05:18 +0000
Message-ID: <179405671897.994134.13525993179862980932@kernel.org>
In-Reply-To: <20261103102856.1340672-1-vulab@iscas.ac.cn>
References: <20261103102856.1340672-1-vulab@iscas.ac.cn>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The new failure path in mlx5e_tc_rule_offload()
  (drivers/net/ethernet/mellanox/mlx5/core/en_tc.c) calls…

--

net/mlx5e: TC, release meter if rule offload fails

When mlx5_eswitch_add_offloaded_rule() fails, this patch makes
mlx5e_tc_rule_offload() release the flow meter and the post meter state
that mlx5e_tc_add_flow_meter() set up. Before the patch, that meter
reference leaked when mlx5e_tc_add_fdb_flow() failed.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 708b7987ea4cd..17bd92529a44a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c

[ ... ]

> @@ -503,9 +505,14 @@ mlx5e_tc_rule_offload(struct mlx5e_priv *priv,
>  		err = mlx5e_tc_add_flow_meter(priv, attr);
>  		if (err)
>  			return ERR_PTR(err);
> +		meter_added = true;
>  	}
>  
> -	return mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
> +	rule = mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
> +	if (IS_ERR(rule) && meter_added)
> +		mlx5e_tc_del_flow_meter(esw, attr);

[Severity: Medium]
Can this lead to a double free of the post meter and an extra meter put?

mlx5e_tc_del_flow_meter() kfree()s attr->meter_attr.post_meter and drops
the attr->meter_attr.meter reference, but it does not clear either
pointer:

mlx5e_tc_del_flow_meter() {
	mlx5e_post_meter_cleanup(esw, attr->meter_attr.post_meter);
	mlx5e_tc_meter_put(attr->meter_attr.meter);
}

attr->dest_ft and the FWD_DEST action bit set by
mlx5e_tc_add_flow_meter() also stay in place.

mlx5e_tc_rule_unoffload() treats a non-NULL meter pointer as a live
reference:

	if (attr->meter_attr.meter)
		mlx5e_tc_del_flow_meter(esw, attr);

So any later unoffload of the same attr releases the meter again.

That later unoffload looks reachable through mlx5e_reoffload_encap() in
en/tc_tun_encap.c. Consider a fast path FDB flow with a police or MTU
meter that redirects to an encap device:

mlx5e_invalidate_encap()
  mlx5e_tc_unoffload_fdb_rules(esw, flow, flow->attr)
    releases meter ref #1 and post_meter P1

mlx5e_reoffload_encap()
  mlx5e_tc_offload_fdb_rules()
    mlx5e_tc_rule_offload()
      mlx5e_tc_add_flow_meter()          takes ref #2 and P2
      mlx5_eswitch_add_offloaded_rule()  fails
      mlx5e_tc_del_flow_meter()          frees P2, puts ref #2,
                                         attr->meter_attr still set

mlx5e_reoffload_encap() then marks the flow as offloaded even when this
step fails:

		rule = mlx5e_tc_offload_fdb_rules(esw, flow, spec, flow->attr);
		if (IS_ERR(rule)) {
			mlx5e_tc_unoffload_flow_post_acts(flow);
			...
		}
		...
		flow_flag_set(flow, OFFLOADED);

The flow is now OFFLOADED and not SLOW. The next flow delete
(mlx5e_tc_del_fdb_flow()) or route event (mlx5e_invalidate_encap()) goes
through:

mlx5e_tc_unoffload_fdb_rules()
  mlx5e_tc_rule_unoffload()
    mlx5e_tc_del_flow_meter()
      mlx5e_post_meter_cleanup()  reads freed P2->type, destroys its HW
                                  objects again, kfree()s P2 again
      mlx5e_tc_meter_put()        drops a reference that is no longer
                                  held

The extra mlx5e_tc_meter_put() could also destroy a meter that other
flows using the same police index still rely on.

Before this patch, P2 and ref #2 leaked at the failure point and were
released exactly once by the later unoffload. With this patch they are
released twice.

The same mlx5e_tc_rule_unoffload() call also passes the stale
flow->rule[0] to mlx5_eswitch_del_offloaded_rule() on this path. That
problem already existed and comes from the unconditional OFFLOADED in
mlx5e_reoffload_encap(). The split_count failure branch in
mlx5e_tc_offload_fdb_rules() already left similar stale meter state
before this patch. The main path this commit targets, where
mlx5e_tc_add_fdb_flow() fails, does look correct.

Would it help to set attr->meter_attr.meter and
attr->meter_attr.post_meter to NULL, and undo the attr->dest_ft change,
after mlx5e_tc_del_flow_meter() in this failure path? A later unoffload
would then skip the meter release.

> +
> +	return rule;
>  }

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103102856.1340672-1-vulab%40iscas.ac.cn
