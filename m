Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A827833F38A;
	Wed,  9 Sep 2026 03:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788924586; cv=none; b=jXUTkJVVk5J6c4D8Q8+5bw27Qi1NL/z6sD6hkqArMb6sSE/yKJwDb5W78YozdMOujd5sf0vV6KMFi2lgYxoQWNmXGZJpRCGTw9xB9/2ynM/jsdcyfv6fle9fMJ2iTQaZxAWfjE0S8lN66LBxbg2Cw99ss4/NUh7Zwh8mb/5zecA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788924586; c=relaxed/simple;
	bh=xP5ZaeiS0vCJ46pDnR1XL3rkMkhAkIl2duVyMjUXeoA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=elG3Ue63j9TLsce5/7eWdMmMv6dQJBWDj6252tcsenjunmQCsFtiZL+uX+uh9uBxDY/2yqsW7xhj403T32d1EQYBJFzI1A8kAUf7B8RcCjlLWwQSey4hjqF7iQQYUX5J2V7LtK29McUG5APd0thD29z39vAXmEAWmH/Nka8aQ24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BUzuxtzm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BUzuxtzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3E41F00A3A;
	Wed,  9 Sep 2026 03:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788924585;
	bh=a4d6nYg8CehvunuGT3xArAn+wof2T6ixvkjQhkuA4+s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BUzuxtzmU8mNLK9DjxbR580wD6EX2kYCvD50zw8Znkc/Z8bMVDFH7IqBSngBOzGGP
	 WDOvhze2M0m0lJ2PCbfrodUmYDeLjBwQhA6oMh3Mgmy3YNH2CIWTvVa1cR8yepGExx
	 KsKMyZL4oluMvKKaZKctdMh1HP/uKXRKu5TipFgDhBNxj3TWj/X0D2o4esZueRCJR5
	 Iq7L591mmC+VM1fD+qIyxRjVjhRgci3vlp5D3AGJp2lpIJYbd5FrCe0JNEEz9XpLBP
	 4WDCHKiAMRmTlA3jaZesXJpU65mPTFx4e6uhG786QXy/Hu7y2h+XNCDAl8Hllm1pUs
	 MJkndLFQnqseQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 04/13] net: mana: swap queue sets in
 mana_set_ringparam
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20260908032843.397667-5-longli@microsoft.com>
References: <20260908032843.397667-1-longli@microsoft.com>
 <20260908032843.397667-5-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 03:29:44 +0000
Message-Id: <20260909032945.2C3E41F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The patch introduces an ad-hoc locking pattern using a boolean f=
lag (`apc->channel_changing`) to guard the reconfiguration critical section=
 in `mana_set_ringparam`.
--

commit 40668ebf41a83bf44835ffb33803930c039ce405
Author: Long Li <longli@microsoft.com>

net: mana: swap queue sets in mana_set_ringparam

This commit replaces detach/attach operations in mana_set_ringparam() with
queue-set allocation and publication. Failed allocations now leave the
running queues and ring sizes unchanged instead of risking a detached port.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers=
/net/ethernet/microsoft/mana/mana_ethtool.c
> --- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
[ ... ]
> @@ -774,32 +772,56 @@ static int mana_set_ringparam(struct net_device *nd=
ev,
>  	netdev_info(ndev, "Using nearest power of 2 values for Txq:%d Rxq:%d\n",
>  		    new_tx, new_rx);
> =20
> -	/* pre-allocating new buffers to prevent failures in mana_attach() late=
r */
> -	apc->rx_queue_size =3D new_rx;
> -	err =3D mana_pre_alloc_rxbufs(apc, ndev->mtu, apc->num_queues);
> -	apc->rx_queue_size =3D old_rx;
> -	if (err) {
> -		netdev_err(ndev, "Insufficient memory for new allocations\n");
> -		return err;
> +	if (new_rx =3D=3D apc->rx_queue_size && new_tx =3D=3D apc->tx_queue_siz=
e)
> +		return 0;
> +
> +	if (!apc->port_is_up) {
> +		apc->rx_queue_size =3D new_rx;
> +		apc->tx_queue_size =3D new_tx;
> +		return 0;
>  	}
> =20
> -	err =3D mana_detach(ndev, false);
> -	if (err) {
> -		netdev_err(ndev, "mana_detach failed: %d\n", err);
> -		goto out;
> +	/* Exclude RDMA through failure cleanup, which may release the vport. */
> +	mutex_lock(&apc->vport_mutex);
> +	if (apc->channel_changing) {
> +		mutex_unlock(&apc->vport_mutex);
> +		return -EBUSY;
> +	}
> +	apc->channel_changing =3D true;
> +	mutex_unlock(&apc->vport_mutex);

[Severity: Medium]
Does this code introduce an ad-hoc locking pattern using the
apc->channel_changing boolean flag?

The networking drivers subsystem guidelines indicate that using a boolean
flag set on entry and cleared on exit to guard a reconfiguration critical
section bypasses lockdep and provides weaker synchronization guarantees than
using a proper lock.

Could a standard kernel synchronization primitive be used for this critical
section in mana_set_ringparam() instead of relying on the
apc->channel_changing flag?

[ ... ]
> +clear_flag:
> +	mutex_lock(&apc->vport_mutex);
> +	apc->channel_changing =3D false;
> +	mutex_unlock(&apc->vport_mutex);
>  	return err;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908032843.3976=
67-1-longli@microsoft.com?part=3D4
