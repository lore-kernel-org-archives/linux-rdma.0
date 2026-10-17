Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF021891A9;
	Sat, 17 Oct 2026 15:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792251569; cv=none; b=T0Afjv/Fh66cSvehr18dqH6SHJJpJnOKkEioU3/xkY/O1FCZLRZvfqCDv3tzd75Ml/uFk7yJdj1W8QJ1UReCWeHI3ReABqg5+LuXwkksLk/MhnbcgqUXQtxv5uXC2vE+wqcHjEFPTkXbr0jdLr8ukz9QqoSLro9cxnsJu82LmwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792251569; c=relaxed/simple;
	bh=PnM8Ax0YLDhYcBVp0J9WKMDuxfLuTMH9gUPeB6B3xF4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=DZEsIe44JHxhqGGm46LZsCGlHzqwqOZww0/JASASHkoLPUbSqdlV4o+BJhUpTB9Czog1LhqYLqIbZk6zgnyh7BDMZ3bxgs2tvrWcYXTbLE9ntfAvYTw5utp7WYIQgeAfU3Gfgci12svK6/MMT0DtaDA3BRc0/Ccy0YFDvfuvARE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sa3ANbSd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sa3ANbSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B53A1F000C5;
	Sat, 17 Oct 2026 15:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792251567;
	bh=Gl8WMeD+3oa4GnsVZ2ajE3Dwoj8yOdPyAM/79pPNeeE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Sa3ANbSdiXI6wTcQIzy70/KioW76880zDQcqVfCIEo88uYX5UXxkRgteZ6edHNsTf
	 1OgreDfAyzZBkwwSA+5eDSldKnqbEtCOb1BjJcTfqAAFJuEfK+YRdA+1s3xy3I6EZF
	 3lMkDf3L7azu9iwJzbGx00iSakniQG91RFVodsDCiwF1rIpqlMwHAak0B9hvTo9x9q
	 gWWf+y8QL345Bq2uGO1k7op6GC5ES1qUGo5xQCWURBKWiaHIf79jJUrHm7OSCSkuxN
	 UimUw25h2AUmt9RQAUloNzu4Jx4v2J8DPlSk9P5GDi/q5p12kXITHEtykL5tZY1iR+
	 doXL7APi4cD9Q==
Message-ID: <sashiko-outbox-175606@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 06/13] net: mana: swap queue sets in
 mana_set_priv_flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <c1a2032792858ac0234807bbb5b26b81af4d10b1.1791710735.git.weh@linux.microsoft.com>
References: <cover.1791710735.git.weh@linux.microsoft.com>
 <c1a2032792858ac0234807bbb5b26b81af4d10b1.1791710735.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 15:39:27 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] net: mana: ad-hoc trylock using channel_changing flag
--

commit 1135b1db29f999b173b293508a85336e600ae80e
Author: Long Li <longli@microsoft.com>

net: mana: swap queue sets in mana_set_priv_flags

Rebuild queues through the swap path when USE_FULL_PAGE_RXBUF changes
the RX layout. Carry priv_flags with the queue set so allocation failure
leaves the live configuration unchanged and rollback restores the flags.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers=
/net/ethernet/microsoft/mana/mana_ethtool.c
> index a643a8cc81e00..9c7c9879d0aa4 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> @@ -891,54 +892,50 @@ static int mana_set_priv_flags(struct net_device *n=
dev, u32 priv_flags)
>  	if (priv_flags & ~GENMASK(MANA_PRIV_FLAG_MAX - 1, 0))
>  		return -EINVAL;
> =20
> -	apc->priv_flags =3D priv_flags;
> -
> -	if (changed & BIT(MANA_PRIV_FLAG_USE_FULL_PAGE_RXBUF)) {
> -		if (!apc->port_is_up)
> -			return 0;
> -
> -		/* If XDP is attached or the MTU already forces one buffer per
> -		 * page, single-buffer-per-page is used regardless of this
> -		 * flag. Skip the expensive detach/attach cycle since nothing
> -		 * changes.
> -		 */
> -		if (mana_single_rxbuf_per_page_forced(apc, ndev->mtu))
> -			return 0;
> +	/* No rebuild is needed if the RX buffer flag is unchanged, the port is
> +	 * down, or full-page RX buffers are already required by MTU or XDP.
> +	 */
> +	if (!(changed & BIT(MANA_PRIV_FLAG_USE_FULL_PAGE_RXBUF)) ||
> +	    !apc->port_is_up ||
> +	    mana_single_rxbuf_per_page_forced(apc, ndev->mtu)) {
> +		apc->priv_flags =3D priv_flags;
> +		return 0;
> +	}
> =20
> -		/* Block RDMA from grabbing the vport during detach/attach */
> -		mutex_lock(&apc->vport_mutex);
> -		apc->channel_changing =3D true;
> +	mutex_lock(&apc->vport_mutex);
> +	if (apc->channel_changing) {
>  		mutex_unlock(&apc->vport_mutex);
> +		return -EBUSY;
> +	}
> +	apc->channel_changing =3D true;
> +	mutex_unlock(&apc->vport_mutex);

[Severity: Medium]
Does this code introduce an open-coded trylock pattern?

Setting a flag on entry and clearing it on exit to prevent concurrent execu=
tion,
and returning -EBUSY to skip the work, appears to act as an ad-hoc lock
substitute for the queue rebuild section. Could a proper lock or synchroniz=
ation
primitive be used instead to guard this state?

> =20
> -		err =3D mana_pre_alloc_rxbufs(apc, ndev->mtu, apc->num_queues);
> -		if (err) {
> -			netdev_err(ndev,
> -				   "Insufficient memory for new allocations\n");
> -			apc->priv_flags =3D old_priv_flags;
> -			goto clear_flag;
> -		}
> +	scratch =3D mana_qset_scratch_alloc(apc);
> +	if (!scratch) {
> +		err =3D -ENOMEM;
> +		goto clear_flag;
> +	}
> =20
> -		err =3D mana_detach(ndev, false);
> -		if (err) {
> -			netdev_err(ndev, "mana_detach failed: %d\n", err);
> -			apc->priv_flags =3D old_priv_flags;
> -			goto out;
> -		}
> +	err =3D mana_alloc_qset(apc, scratch, apc->num_queues, apc->rx_queue_si=
ze,
> +			      apc->tx_queue_size, priv_flags, &newq);
> +	if (err)
> +		goto free_scratch;
> =20
> -		err =3D mana_attach(ndev);
> -		if (err) {
> -			netdev_err(ndev, "mana_attach failed: %d\n", err);
> -			apc->priv_flags =3D old_priv_flags;
> -		}
> +	err =3D mana_publish_qset(apc, &newq, &oldq);
> +	if (err) {
> +		mana_free_qset(scratch, &newq);
> +		goto free_scratch;
>  	}
> =20
> -out:
> -	mana_pre_dealloc_rxbufs(apc);
> +	mana_free_qset(scratch, &oldq);
> +
> +free_scratch:
> +	mana_publish_close_if_needed(apc);
> +	mana_qset_scratch_free(scratch);
>  clear_flag:
>  	mutex_lock(&apc->vport_mutex);
>  	apc->channel_changing =3D false;
>  	mutex_unlock(&apc->vport_mutex);
> -
>  	return err;
>  }
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791710735.gi=
t.weh@linux.microsoft.com?part=3D6
