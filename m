Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8374D6C2E;
	Wed, 16 Sep 2026 23:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789602159; cv=none; b=QgUIEQEwX4XBV/uQFP584ud7Aer8D4vLC/zG6ewoY0pPmyOc4ZYjAeJdtHSdYdilZWFaXBbjVCCCQ/eGwX72KHouoWp6/UcPnGnzZ3tXNsdaaMPSXpr7C25mlsOUaneV0YSvCRMuh/bed/wQhGCLbehCOHXbh7JIlvQ4qfBkrec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789602159; c=relaxed/simple;
	bh=cvt0Bf4h1E38x2Cycyrgt5rO6E5xf9qiVd7pPeSkSrY=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZnDLo3/l0OjlXqXMttCH3l04RmD4vZhMF3rKSx/C7xHhH7Ahc1OzgasldYmQdAnk2Nvqm+JZbBEU9U750bh2hjrf3GooPTOH+YURZp446RsT7nrrGAD3zyr2PTMgT1iZ3L21AdFKU+5l1+yRajGFgwKvjMRq5yuV+QNCVMMFUVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nkbzet67; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nkbzet67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F331F00893;
	Wed, 16 Sep 2026 23:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789602157;
	bh=qK706Jbs6uPoqtPD0KtmUTPzMynAfe7tPJsec149WIw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=nkbzet67Cn25yOgIAqE4CQYyn4ub+7qyZPUqPWpZxVtG105jNPkQGurzfIysbT5GS
	 7RQ11T/3o+y3flndicpYSasA2SdqZFMajyPjsO4cWVEyX9vNRJv5daWAdTziDvx8vg
	 5tZM+AzYevyD5B5uthP5grBLBNUq8/cz5UqoUOsNna//JKm1/8SztbCMRCiY8u9mLy
	 5G3HDBybIXjxOnEV7AB8tHsuN90wzmxrZCFesfoZFXv2BNlP6n329EMiLZvDQzr1XM
	 eZje8dk+0jo8T6LtAasWt+xD48OJ1P0STis25/4kx/TXKVD0uv4TiTfxSK309txpwi
	 CKhR8ow9tWrOA==
Subject:
 Re: [PATCH net-next 3/6] net/mlx5: HWS, Replace kzalloc with kzalloc_obj
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, erezsh@nvidia.com,
 gal@nvidia.com, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, saeedm@nvidia.com,
 kliteyn@nvidia.com
Date: Wed, 16 Sep 2026 23:42:36 +0000
Message-ID: <178960215650.22033.278373355356901464@kernel.org>
In-Reply-To: <20260915111912.3926585-4-tariqt@nvidia.com>
References: <20260915111912.3926585-4-tariqt@nvidia.com>
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

- [Low] Commit message names the wrong helper and does not describe the
  actual (partial) scope of the change.

--

net/mlx5: HWS, Replace kzalloc with kzalloc_obj

This converts one allocation in hws_send_ring_alloc_sq() from an open-coded
kzalloc(sizeof(*p) * n, GFP_KERNEL) to the newer object-array allocation
macro.

>  net/mlx5: HWS, Replace kzalloc with kzalloc_obj
>
>  Replace kzalloc with the newer kzalloc_obj allocation function.

[Severity: Low]
This isn't a bug in the code, but does the changelog name the right helper?

The subject and body both say kzalloc_obj, while the only converted site
uses the array variant kzalloc_objs(). include/linux/slab.h defines these
as two separate macros:

  #define kzalloc_obj(P, ...) \
	__alloc_objs(kzalloc, default_gfp(__VA_ARGS__), typeof(P), 1)

  #define kzalloc_objs(P, COUNT, ...) \
	__alloc_objs(kzalloc, default_gfp(__VA_ARGS__), typeof(P), COUNT)

Grepping this patch for kzalloc_obj as written in the message finds nothing.

Also, the message reads as a general replacement sweep, but only this one
array allocation is converted.  The single-object kzalloc(sizeof(*x),
GFP_KERNEL) sites that kzalloc_obj would actually apply to are still present
in the same driver, for example in hws/bwc_complex.c:

	subm->bwc_matcher = kzalloc(sizeof(*subm->bwc_matcher), GFP_KERNEL);

as well as the cdata and sr_data allocations in the same file, and they
remain unconverted at the end of the series.  Could the message mention that
the conversion is limited to this call site?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
> index 80cfd0ddba08b..49dee44d0bef5 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
> @@ -732,7 +732,7 @@ static int hws_send_ring_alloc_sq(struct mlx5_core_dev *mdev,
>  		goto destroy_wq_cyc;
>  	}
>  
> -	sq->wr_priv = kzalloc(sizeof(*sq->wr_priv) * buf_sz, GFP_KERNEL);
> +	sq->wr_priv = kzalloc_objs(*sq->wr_priv, buf_sz);
>  	if (!sq->wr_priv) {
>  		err = -ENOMEM;
>  		goto free_dep_wqe;

The expansion here looks equivalent to the old code, with default_gfp()
yielding GFP_KERNEL and __alloc_objs() using size_mul() for the product, so
no functional change is expected.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260915111912.3926585-1-tariqt%40nvidia.com
