Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793945170;
	b=OdZkpT2we/d81u2rGqtrTXPCArSg4OxnNZ91kDzBYzZKRdT4QnLKC10e95RCVKvPXvQG
	 k6xbYFMPCk42nvYZ36i9SxAiXqUaR/sree/7qlohw3lU98f1x67pUdBUUkgYfCnwh++ON
	 h3tLaR/BKFczFaMe6fJ4bYoKkB+1bOAzrVX2VWHpQn3TwOt/HEEdpCnJiYMwrQh9ziq5J
	 KeU29Gl+DbQcSfCz7Hu5v1cxub7OI9qgYxcjclaa8ujnvW9DwpcvCHSKZqlFfne2FLkKr
	 jARhNJThlo4A6az1FPq7JgfKU0Cu9JOjNQ62f2JkBWeipSMQZdluvHCT5/L2fDPKO2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793945170;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=gVTTJvwocEtm1PMNVMKTeSVxoE9g7JiIg2s+hJaYmhc=;
	b=owOnXYj0dpOgMs/qrsPfggBEDFsCOXxKjJHFPG9DHwcTe1lpnpcBRSQAKDosK5oLPefx
	 LBvBDVIpnGU3Zng02JIwwoJduJ6p88JoYbSwR3ng7mHxsvB03ImlwVijHr4UIaibRmzwT
	 hJ4tRpK6MNtwiXtZZ9O86hYkEOLg9UflTOYntgcweZ97tAQAfMjxYuaQWADLRRU8iiJCD
	 1Gy3Z9fknHQ2P0rBVcspOADB5qSOuiKXBmBYcBgTwuBq12D1O37NRCDSyXCbj0ZB/6SRI
	 38Nqb2VNNxNqum5D9Ln1DZY5Fp+pjntNaxG9dpI2DjOqUq9DG1gFXiNl+/W77uwL6CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZHG6eBV+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5099606A328;
	Fri,  6 Nov 2026 06:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZHG6eBV+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CB21F0089F;
	Fri,  6 Nov 2026 06:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793945169;
	bh=gVTTJvwocEtm1PMNVMKTeSVxoE9g7JiIg2s+hJaYmhc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ZHG6eBV+q9bv55sb54HBFxlorpjO25JQMN4caUt60ZGLh6Ya7DUDmiovKC+YRL2/S
	 GQFvEnjsztl9FsbtwLjihznoFqOG64LEeVI+Peb2eJReL+L8FJx8JmPLx2mkoF651e
	 UAsts/s8BUghu3s42fP2hLyT+h4uehOq5nQk5hEqDZpxPDn3ve4o7PoBKUZrugQj+Q
	 hU1jp3upQuAl9FWa2I2Mrzd0ce3K+vugjyV4fnGz4GzTKtmV7m9rnElBNgORcglj+4
	 5q8RbHAu6ALfWjrpN/JGWLDe1k8ARkXmEW55UobCRwbwRQykCRJG25vysxWA9lTR4W
	 qOSfE9CyfKqSw==
Subject: Re: [BUG] net/mlx5: nf flowtable offload rules never hit in switchdev
 - root chain misses to slow path, not to the FT chain
From: netdev-bot+sashiko@kernel.org
To: mzuhayr@earthlink.iq
Cc: netdev@vger.kernel.org, saeedm@nvidia.com, leonro@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, linux-rdma@vger.kernel.org,
 kuba@kernel.org
Date: Fri, 06 Nov 2026 06:06:08 +0000
Message-ID: <179394516873.994134.1671850395426244837@kernel.org>
In-Reply-To: <AM0PR02MB4307F6D53A2B0AD628D91C81C6682@AM0PR02MB4307.eurprd02.prod.outlook.com>
References: <AM0PR02MB4307F6D53A2B0AD628D91C81C6682@AM0PR02MB4307.eurprd02.prod.outlook.com>
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

- [Medium] The commit cannot be merged as written.
- [Low] The patch fixes a long-standing functional bug: in switchdev
  mode, mlx5 nf flowtable hardware offload rules never get hit, so…

--

net/mlx5: nf flowtable offload rules never hit in switchdev - root chain misses to slow path, not to the FT chain

This commit moves the mlx5_chains_set_end_ft() call in esw_chains_create()
so it runs before the root (chain 0, prio 1) table is opened. As a result,
mlx5_chains_create_prio() uses nf_ft as the root's miss destination instead
of the slow path tc_miss_table, and nf flowtable hardware offload rules can
be hit in switchdev mode.

> net/mlx5: nf flowtable offload rules never hit in switchdev - root chain misses to slow path, not to the FT chain
>
> Hi,

[ ... ]

> The order changed in "net/mlx5: Refactor multi chains and prios support"
> (Sep 2020, merged for v5.10), which introduced esw_chains_create() with
> mlx5_chains_set_end_ft() after the root is opened.

[Severity: Low]
The culprit commit is named here, but the message has no Fixes: tag and
no Cc: stable. At the baseline, git blame on esw_chains_create() shows that
the root prio open and the late mlx5_chains_set_end_ft() call both come
from ae430332557a.

Should the message carry this tag:

Fixes: ae430332557a ("net/mlx5: Refactor multi chains and prios support")

Without it, stable tooling may not pick up the fix. The report was made on
a 6.12 based kernel, and the message says the code is unchanged through
v7.4-rc1.

[ ... ]

> Suggested fix (against mainline; compile/runtime UNTESTED on my side)
> ---------------------------------------------------------------------

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index c712848b202db..445aad4fac2bf 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -1693,6 +1693,11 @@ esw_chains_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *miss_fdb)
>  		goto nf_ft_err;
>  	}
>  
> +	/* Set the end table before opening the root, so the root's miss
> +	 * rule points to the nf flowtable chain and not to the slow path.
> +	 */
> +	mlx5_chains_set_end_ft(chains, nf_ft);
> +
>  	/* Always open the root for fast path */
>  	ft = mlx5_chains_get_table(chains, 0, 1, 0);
>  	if (IS_ERR(ft)) {

[Severity: Medium]
The reordering looks correct. Once mlx5_chains_set_end_ft() is moved up,
mlx5_chains_create_prio() picks the root prio's miss destination at a point
where chains_end_ft() already equals nf_ft:

lib/fs_chains.c:mlx5_chains_create_prio() {
    ...
        next_ft = (chain == mlx5_chains_get_nf_ft_chain(chains)) ?
                  chains_default_ft(chains) :
                  chains_end_ft(chains);
    ...
}

The next_ft == chains_end_ft(chains) check in mlx5_chains_add_miss_rule()
still holds, so the only change to the root miss rule is its destination.
This matches the root to nf_ft wiring that was measured after the
workaround rule was deleted.

The commit can't be applied in this form, though. The changelog is the bug
report email pasted in as is. It starts with:

  Hi,

and ends with:

  Suggested fix (against mainline; compile/runtime UNTESTED on my side)

It also has no Signed-off-by line. The subject describes the symptom
instead of being an imperative summary.

Could this be resent as a [PATCH net] with these changes?

- a Signed-off-by line
- an imperative subject, such as "net/mlx5: Set FDB chains end table
  before opening the root prio"
- a trimmed changelog
- test results from running this diff

All the numbers in the message come from the prio 2 tc filter workaround,
not from this change.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/AM0PR02MB4307F6D53A2B0AD628D91C81C6682%40AM0PR02MB4307.eurprd02.prod.outlook.com
