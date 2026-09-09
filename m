Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4D13515E3;
	Wed,  9 Sep 2026 03:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788924591; cv=none; b=bCHNLAux4pRVNTbM9zVDo67yd003rLtwte2i5w7f/MysABes8hLmQf8vw5B7YY9c4CEbIr1EbD6wx9HH87E9ozdCMlRKRYWhoecY4WPFZIdZ91i3f6xw1zsUL1GKmGubDEUarEUMBCxhDtjoiY1zb1NkzPIX9CvnFkt+bX8GdNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788924591; c=relaxed/simple;
	bh=aWDX0eKq3WukvtmXiRGbwwPWbGL0GZtflp/b7q1H6g8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UUvBONr8UquMn9GIlOk6Kk29l7Dz4zIm8uwcgFfZLlZqVK2v7UjPEGbX7fwM0bdOXfrBMPC49g77AiqNOjCaou4E/7XyjGcsomvZdKvlee2aznAS8FLqjg4xyIA6sz5xtxkDSHG/TpCnwEG9vw0PUC0p1Grrha97VTaxIFW6E6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Os4JQw1z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Os4JQw1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AFE1F00A3A;
	Wed,  9 Sep 2026 03:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788924589;
	bh=uJu9ncXQMIAr0vqyDpNtGqep43wwM8ObTpEXJeKFO6o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Os4JQw1zqJd0AuUqJ6KHhG54OK2cDhEn7vfMtrTUPHaX9RjS2iIrJk5GfaohsV6EW
	 Hc4DGhAD0tWBlEHqQgvxwMI5jVopGEVkSzd+p4IMJD8cHYGxJxSHfKBe/UD+hvNYLg
	 gtXOjpz2gSmzSvIgzn96RZBSSuw/aZe9ZxAWWdwNjnuZenmjW2XfeOvJjG9BynLtMl
	 3TQ+eTxdRKMWZNNRse183gI1pMGGCGhj7dxOduht/aNPSEqNiDjX28QdDJmsWLROGC
	 ai7Lrki/PpTOg3bd/Tau4kQIsQ64DybcKzCc1hO2tGs2nbhgKaaW0AfIDJxbeLApBl
	 WvxGaw7ftY1KA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 11/13] net: mana: keep a user-configured RSS
 table across a queue rebuild
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260908032843.397667-12-longli@microsoft.com>
References: <20260908032843.397667-1-longli@microsoft.com>
 <20260908032843.397667-12-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 03:29:48 +0000
Message-Id: <20260909032949.46AFE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Silent replacement of an invalid RSS table in `mana_alloc_queues` =
without notifying the ethtool core causes the table to be falsely treated a=
s user-configured, permanently breaking default table auto-scaling.

Pre-existing issues:
- [High] Heap out-of-bounds read and write due to untrusted hardware config=
uration changing across resets.
--

commit 935252e88b1186422d52dcb7eb47455372ea3ed9
Author: Long Li <longli@microsoft.com>
Subject: net: mana: keep a user-configured RSS table across a queue rebuild

Preserve a user RSS table whenever all entries fit the requested queue
count. Regenerate driver defaults. On growth, a retained user table does
not steer RSS traffic to the added queues until the user updates it.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/=
ethernet/microsoft/mana/mana_en.c
> index fc96837d69a00..78be88b29c99b 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -3548,6 +3548,27 @@ static void mana_rss_table_init(struct mana_port_c=
ontext *apc)
>  			ethtool_rxfh_indir_default(i, apc->num_queues);
>  }
> =20
> +/* Keep user tables with valid indices; defer loss notification. */
> +static bool mana_rss_table_keep(struct mana_port_context *apc,
> +				unsigned int num_queues, bool *lost)
> +{
> +	u32 i;
> +
> +	*lost =3D false;
> +
> +	if (!netif_is_rxfh_configured(apc->ndev))
> +		return false;
> +
> +	for (i =3D 0; i < apc->indir_table_sz; i++) {
> +		if (apc->indir_table[i] >=3D num_queues) {

[Severity: High]
This is a pre-existing issue, but can this out-of-bounds read occur if the
hardware configuration changes across resets?

If the hardware/firmware returns a larger num_indirection_ent during a
device reset (e.g., timeout recovery triggering mana_attach()),
mana_init_port() updates apc->indir_table_sz via mana_query_vport_cfg().
However, mana_attach() fails to reallocate apc->indir_table to accommodate
this potentially new size.

When mana_alloc_queues() is subsequently called, mana_rss_table_keep() and
mana_rss_table_init() iterate up to the new, larger apc->indir_table_sz,
causing an out-of-bounds read and write on the statically allocated buffer.

> +			*lost =3D true;
> +			return false;
> +		}
> +	}
> +
> +	return true;
> +}
> +

[ ... ]

> @@ -3863,7 +3885,9 @@ int mana_alloc_queues(struct net_device *ndev)
>  		goto destroy_rxq;
>  	}
> =20
> -	mana_rss_table_init(apc);
> +	/* Loss notification needs a netdev instance lock we may lack. */
> +	if (!mana_rss_table_keep(apc, apc->num_queues, &indir_lost))
> +		mana_rss_table_init(apc);

[Severity: High]
Does this silent replacement of an invalid RSS table without notifying the
ethtool core permanently break default table auto-scaling?

If a user configures a custom RSS table, lowers the queue count while the
port is down, brings the port up, and then increases the queue count while
the port is up, the newly added queues might permanently receive no RSS
traffic.

Because the driver silently replaces the invalid custom table with a
smaller default table during the down/up cycle but fails to notify the
ethtool core (by intentionally omitting a call to ethtool_rxfh_indir_lost()=
),
the core remains desynchronized.

Later, when the queue count is increased, mana_grow_qset() falsely assumes
the small default table is the user's custom table and preserves it,
failing to scale the RSS indirection table to include the new queues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908032843.3976=
67-1-longli@microsoft.com?part=3D11
