Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC7B517BC5;
	Wed, 16 Sep 2026 23:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789602163; cv=none; b=M29foK4g1D4oVqbfAJu7MtRUTOM23KwYwrflrR32j+gNXp/XQYD8Q34WMlLcX/oayXvLwCRYQe7xSyutaXRqFJO6kLLuqQN18fTmvWMZeYCanozhDyyv8QpSlJbBxfqC46sTDP47GIAlYkitsAsIRySGIO2UpoR/shg/VcX1SNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789602163; c=relaxed/simple;
	bh=kWYy1PQXA+7DHbMTI6w1XB0iRmxKh7Jf9HGtR6JFxrc=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uJKeg8uLo9nIBys1jtC45q73e0qVlM2jDlQwF2jFxPg7DXhdXLGd0eq+XcV8CzrLh/eS7jcFoJ4GeF8G3p7PbE+tEG+/6q/t31yH5PGDYq2Kr5K2we0ArsviRN6vwxA8niXIzfeP8UxcQf1qgd9VQhpx58x1yKvn7tKZPiufwcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kFZ+nfgl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kFZ+nfgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4273E1F00898;
	Wed, 16 Sep 2026 23:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789602162;
	bh=85uWKwpmF5gi1QZlMuzRzmcyieBVYjzFiSEl42U0mXQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=kFZ+nfglFjp+5GI4dvbQyFl1BVQisH267RQBPMcyRLjYscZNDun2CgDWtpj/mT9Aa
	 ek9KbItI/Zg1g0Xe/LwSw37SNlRqIq1stR2IJHFbaDir6tEZ51RofX5sj4KVw1A77a
	 XrtAcnkIsiCJGDuKkY3LdWItwmvSMPOh6I+WgKCGXB3bPhOboA/sAT6rOu6FW6Ky/J
	 sf6LH1OrxBEfQu8Rvem3T8zTwOR3MsQYf9yJUlntbojSVKqiJr0OxvJk4GJ6iGejbt
	 693xplhTMq8UlGr0zpNH3dDuZazsVv5Ixt6DocfgC9l5i3gdX+4EiPuQ4OKjIsd6wh
	 0UgO5phO2FL7w==
Subject: Re: [PATCH net-next 6/6] net/mlx5: HWS, Remove unneeded WRITE_ONCE in
 post send
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, erezsh@nvidia.com,
 gal@nvidia.com, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, saeedm@nvidia.com,
 kliteyn@nvidia.com
Date: Wed, 16 Sep 2026 23:42:40 +0000
Message-ID: <178960216085.22033.7885415920375901762@kernel.org>
In-Reply-To: <20260915111912.3926585-7-tariqt@nvidia.com>
References: <20260915111912.3926585-7-tariqt@nvidia.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 0 · Low: 1

- [Low] Incomplete cleanup plus an incorrect commit-message premise.

--

net/mlx5: HWS, Remove unneeded WRITE_ONCE in post send

This drops the WRITE_ONCE(doorbell_cseg, NULL) statement and its comment
from hws_send_engine_post_ring() in the HWS send path, on the grounds that
the store targets a by-value parameter and therefore has no effect.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
> index bddac018b44b8..8b70040eaca03 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
> @@ -111,9 +111,6 @@ static void hws_send_engine_post_ring(struct mlx5hws_send_ring_sq *sq,
>  	wmb();
>  
>  	mlx5_write64((__be32 *)doorbell_cseg, sq->uar_map);
> -
> -	/* Ensure doorbell is written on uar_page before poll_cq */
> -	WRITE_ONCE(doorbell_cseg, NULL);
>  }

[Severity: Low]
The changelog says:

    b) This code originated from another place (copy-paste bug),
    where there was actually a CQ polling right after this line,
    and the WRITE_ONCE was writing to another place.

Does that match the in-tree origin?  The only other place carrying this
exact comment and idiom is mlx5_aso_post_wqe() in
drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c:

	mlx5_write64((__be32 *)doorbell_cseg, aso->uar_map);

	/* Ensure doorbell is written on uar_page before poll_cq */
	WRITE_ONCE(doorbell_cseg, NULL);

and there doorbell_cseg is also a by-value parameter:

	void mlx5_aso_post_wqe(struct mlx5_aso *aso, bool with_data,
			       struct mlx5_wqe_ctrl_seg *doorbell_cseg)

so the store is dead at that site too, rather than "writing to another
place".  That line predates the HWS send path (it came in with commit
c491ded04325b9 in 2022).

Should aso.c get the same deletion in this patch?  Unlike the HWS site, the
aso.c one really is followed by CQ polling in every caller, for example
mlx5e_ipsec_aso_query():

	mlx5_aso_post_wqe(aso->aso, false, &wqe->ctrl);
	read_poll_timeout_atomic(mlx5_aso_poll_cq, ret, !ret, 10,
				 10 * USEC_PER_MSEC, false, aso->aso, false);

with the same pattern in mlx5e_tc_meter (en/tc/meter.c) and the macsec
paths, so the comment there documents an ordering guarantee the code never
implemented.  No runtime failure follows from it, since all of those
callers poll inside a read_poll_timeout*() retry loop and simply retry.

After this change, the two functionally identical doorbell-ring helpers in
the same driver no longer agree, and the construct the changelog calls
erroneous is still present at the site the changelog points to as its
origin.  Would it make sense to either remove it there as well, or, if some
real ordering requirement exists at that site, add an actual barrier
instead of a store to a local?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260915111912.3926585-1-tariqt%40nvidia.com
