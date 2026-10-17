Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6429A335564;
	Sat, 17 Oct 2026 15:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792251572; cv=none; b=kCaSdhyVDUvdRIIe/nPtKhds7VAqcKM0xP40LefV3I8jm9gmHouBGL16ZuebygChHSrQc0uYPrqDegeAct0i4QrlojC7xCscrVawJrtGkuVPSud3SrLMKjr0F1zcxHvf3y3lsaSIOFlt8tKy8M9IeBTNbuJaPUQhy2SWQVlUXKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792251572; c=relaxed/simple;
	bh=41Ql2wSTwTFluco6sBN97XsOvjVBiZYZB/6Vm2quEtU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=BhOAyzmqA406pkHbErV1f/vKhgoKUZj2/+J4YTI1eqkiXRB6aKD1UlH/ra5vjEqW7YslUk1T7zKBHVoVmbkV94qq0RY59DSs6lPqoaelWt9A2yf/wutds1fGM7sSOstV6VqvptePawWQmyA3uJCM6OKTPGDuvXoqP1ZCB2aoObY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e+/5Az2y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e+/5Az2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4461F000C5;
	Sat, 17 Oct 2026 15:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792251571;
	bh=ItID+Y26A9wu+U7VS6p+ThOpdoyQC7SY4kbM/9z/MKs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e+/5Az2yI+SLDcbE63cEJdZX8C9EazqFQXtZ6D4TxMvnZ+PyvtJCbT8qTc43eLsZ1
	 /KGGwDYwIqnjVslgB7awJQWF7mBo9QwjAS7SI0E2rEvMU92Vcu8N6QzL/blb0mUG6k
	 Sp1IEYxQheT0RaAfxT4HXaIbFqJizFyeHoGac8I75n9uiol69Hbeo2AACG4zG+5fG4
	 4q7cNGwrkNlRkpPDufkUPDAoCE2eZ+MOHyXwnEC9C5mmpshsG92V/sRSMGPzDoNsnJ
	 u+zCIOcfDs2IdA7AEXoxWXDxgnxDRm0mF2imOyR7Gt8VxIWri0J1hhD8tV7581O3Uv
	 7+E2ftaH13jIg==
Message-ID: <sashiko-outbox-175611@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 11/13] net: mana: keep a user-configured RSS
 table across a queue rebuild
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <e3a74aa4b30eb004c9a9f16168b734c563f27a15.1791710735.git.weh@linux.microsoft.com>
References: <cover.1791710735.git.weh@linux.microsoft.com>
 <e3a74aa4b30eb004c9a9f16168b734c563f27a15.1791710735.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 15:39:30 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] net: mana: State desynchronization on silent RSS table reset lea=
ves queues unutilized
--

commit f7f07913c3b72971a54af27655b2426b066f266e
Author: Long Li <longli@microsoft.com>

net: mana: keep a user-configured RSS table across a queue rebuild

Preserve a user RSS table whenever all entries fit the requested queue
count. Regenerate driver defaults. On growth, a retained user table does
not steer RSS traffic to the added queues until the user updates it.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/=
ethernet/microsoft/mana/mana_en.c
> index 2aa18cb10d902..7cf7ce9bfa28c 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -3936,7 +3958,9 @@ int mana_alloc_queues(struct net_device *ndev)
>  		goto destroy_rxq;
>  	}
> =20
> -	mana_rss_table_init(apc);
> +	/* Loss notification needs a netdev instance lock we may lack. */
> +	if (!mana_rss_table_keep(apc, apc->num_queues, &indir_lost))
> +		mana_rss_table_init(apc);

[Severity: Medium]
Does this silent reset desynchronize the driver from the ethtool core?

By silently reinitializing the table in mana_alloc_queues() without calling
ethtool_rxfh_indir_lost(), it leaves the ethtool core's
dev->ethtool->rss_indir_user_size > 0. If a user subsequently increases the
queue count, the ethtool core will falsely validate the small table, and
the newly added Rx queues will receive no RSS traffic.

The comment mentions lacking a netdev instance lock. However, callers of
mana_alloc_queues() like mana_open() and mana_attach() hold the RTNL lock,
which satisfies the locking requirements of ethtool_rxfh_indir_lost():

net/ethtool/common.c:ethtool_rxfh_indir_lost() {
	WARN_ONCE(!rtnl_is_locked() &&
		  !lockdep_is_held_type(&dev->ethtool->rss_lock, -1),
		  "RSS context lock assertion failed\n");
    ...
}

Can we safely call ethtool_rxfh_indir_lost() here to keep the states
synchronized?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791710735.gi=
t.weh@linux.microsoft.com?part=3D11
