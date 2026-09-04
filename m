Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD15E407569;
	Fri,  4 Sep 2026 04:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788497206; cv=none; b=oqRBcbpg1aWEitk6j0JYYyQTOXYU4eHQ0F0W20fsv828o3KRHUWyrMyMH5bPnKw7naR2EXij5y9E35ti52O9yr65wJTLxKcxvHqHJFEJap2SD1urz7QppUjtunNSyhU0IxDJBJmbLJNlaUij/lT9cTr94Caj2to26il6g00MmFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788497206; c=relaxed/simple;
	bh=N9bxtI4ua4H4OvKz0DdaKQFIMvrLSiOpn5uaDIa+Qrg=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G5UjOAnvm0gOOsDDPeuZqI0ZewnBuVHOypvtYcyG7KcTMDh+zQI3Z3UIFjtYZmPpcDceJ73O8VfbycSnetM/862P5ohqJsbIwQpxH34XObnSPe3SGglMwFPboBnRLyqVDBWF9Hwx0XkHTTfg0jPQbgsX51xnb0ImTFZbqD3kgDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ke9CNHkL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ke9CNHkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406051F00A3E;
	Fri,  4 Sep 2026 04:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788497204;
	bh=L5t2G2x+edMWQ2G4kHFyewpYx1XgaEAM3WfqsJc3CGo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Ke9CNHkLWoYdH77uuxNjhlCukXB8EqBwbEvn+fknswbPdZUzXxt2uLEh5NMDfLAYY
	 4eR5MbkgYekT+xXYFwc/YJrxIYv+40gj4AvDf6scau0BUkFLXmSq3s2P4ejTrdFRtK
	 0r4zxuDVpII+/jqF8PoN7T1avR+AHMqlxtVJF0IsA0kPJ+0+3GL38rjaoIdS4SIL86
	 aJVliXX5IfrWo3lxlUwtyikZlwp6x6d3Y6vare5n5XQiWJf0AR7gfmUqu39AtwXgy7
	 KjQbn5ewXhTXvc5UD80cFL9zN7cBN6ncGsiR/azuEPW6dzlMvmbSgvw17Ui+wNWqES
	 PCAp2Twd9tdFg==
Subject: Re: [PATCH net-next v3 04/13] net: mana: swap queue sets in
 mana_set_ringparam
From: netdev-bot+sashiko@kernel.org
To: longli@microsoft.com
Cc: kotaranov@microsoft.com, kuba@kernel.org, davem@davemloft.net,
 pabeni@redhat.com, edumazet@google.com, andrew+netdev@lunn.ch, jgg@ziepe.ca,
 leon@kernel.org, haiyangz@microsoft.com, kys@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, shradhagupta@linux.microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, stephen@networkplumber.org,
 shirazsaleem@microsoft.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Fri, 04 Sep 2026 04:46:42 +0000
Message-ID: <178849720277.4131868.12258037166166867205@kernel.org>
In-Reply-To: <20260901014442.2945689-5-longli@microsoft.com>
References: <20260901014442.2945689-5-longli@microsoft.com>
X-sashiko-severity: Medium
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

Critical: 0 · High: 0 · Medium: 1 · Low: 0

- [Medium] The changelog of "net: mana: swap queue sets in
  mana_set_ringparam" states: "This drops the fallback on failure.

--

net: mana: swap queue sets in mana_set_ringparam

This converts the ethtool ring size path to build a new queue set,
publish it with mana_publish_qset() and retire the old one, instead of
running mana_detach()/mana_attach() over the live configuration. It also
returns early when the rounded sizes already match the current ones.

> This drops the fallback on failure. Previously a failed mana_attach() was
> retried with the previous values, or the defaults, or the minimums, so a
> user who asked for a specific size could end up with a different one with
> no indication beyond dmesg. There is nothing to recover from now, so the
> error is returned.

[Severity: Medium]
Does the retry chain described here actually exist in the code being
replaced?  In the pre-image of mana_set_ringparam() a failed mana_attach()
only writes the old sizes back into apc and returns the error:

	err = mana_attach(ndev);
	if (err) {
		netdev_err(ndev, "mana_attach failed: %d\n", err);
		apc->tx_queue_size = old_tx;
		apc->rx_queue_size = old_rx;
	}
out:
	mana_pre_dealloc_rxbufs(apc);
	return err;

mana_attach() in mana_en.c makes a single attempt:

	err = mana_init_port(ndev);
	if (err)
		return err;

	if (apc->port_st_save) {
		err = mana_alloc_queues(ndev);
		if (err) {
			mana_cleanup_port_context(apc);
			return err;
		}
	}

There is no second attach at the previous values, the defaults or the
minimums; the only other writers of apc->tx_queue_size /
apc->rx_queue_size in the driver are the one-time defaults set in
mana_probe_port().

Also, the restored size fields do not describe a working port after that
failure: mana_detach(ndev, false) already ran, so
mana_dealloc_queues() -> mana_destroy_vport() -> mana_uncfg_vport() has
released the vport and the interface stays detached until an explicit
down/up, with the vport claimable by RDMA in the meantime.

Could the changelog be reworded to describe what the old path really did,
so the connectivity aspect of this change is not presented as a cosmetic
"user may end up with a different size" cleanup?

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> index 2ef3d461e7072..24353dfddde3c 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c

[ ... ]

> @@ -790,32 +788,61 @@ static int mana_set_ringparam(struct net_device *ndev,
>  	netdev_info(ndev, "Using nearest power of 2 values for Txq:%d Rxq:%d\n",
>  		    new_tx, new_rx);
>  
> -	/* pre-allocating new buffers to prevent failures in mana_attach() later */
> -	apc->rx_queue_size = new_rx;
> -	err = mana_pre_alloc_rxbufs(apc, ndev->mtu, apc->num_queues);
> -	apc->rx_queue_size = old_rx;
> -	if (err) {
> -		netdev_err(ndev, "Insufficient memory for new allocations\n");
> -		return err;
> +	if (new_rx == apc->rx_queue_size && new_tx == apc->tx_queue_size)
> +		return 0;

[ ... ]

> -	err = mana_attach(ndev);
> +	err = mana_publish_qset(apc, &newq, &oldq);
>  	if (err) {
> -		netdev_err(ndev, "mana_attach failed: %d\n", err);
> -		apc->tx_queue_size = old_tx;
> -		apc->rx_queue_size = old_rx;
> +		NL_SET_ERR_MSG_FMT(extack, "failed to change ring params: %d",
> +				   err);
> +		mana_free_qset(scratch, &newq);
> +		goto free_scratch;
>  	}
> -out:
> -	mana_pre_dealloc_rxbufs(apc);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260901014442.2945689-1-longli%40microsoft.com
