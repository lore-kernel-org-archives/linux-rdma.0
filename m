Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCA8328B5E;
	Wed,  9 Sep 2026 03:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788924584; cv=none; b=TGw9cy8saEZqOGoqpVRx32XE1EsZ5FiN9GY6NB4Wyj8kBgd7OZ5Zk1+kn5FcHdUvTMvWBIAje22C5PHI/eTueSW2bNabBiJaXfJJCkWtUFhlx+UkIMbl70kjUQyRlnLdEmSypQzVYs2LpwoFge4g5AoK1o0NyUbjKYqwEr5Slh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788924584; c=relaxed/simple;
	bh=j40YAeY17xA8/GHg5ifsjYJsZxdfnc4Tf6lKF+Stk8E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=N1JIv7nchoTMNWrzRgQOXmuO4FfEA+KqvIpfSn1ROU9cvoIFWruWk/7rxT08z7MupEW0xcMmCcvJrjvV8djoQyf0dwJ3zVGgtWM7yxFZQWZ8wbN9j3xqza6B1wRCgxMt9INjscy/aJn2fQ9NSPQV/X1ib5UcYwnSPXX5l/ltIxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HzB/SYE6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HzB/SYE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082491F00A3A;
	Wed,  9 Sep 2026 03:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788924583;
	bh=cutRSEvTT+PEqbEIHriLj7ycJZuQB13TP1pWWBbnito=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HzB/SYE6cZQHZ/icaqd58t2c8Kp3Hqx+U/VKCQxWHUDIPgQxtAmwkzl+oOH+3TWEq
	 3jnfp9bssNy1ejRJlJvIzFEHV+SsuxTzH9766yYmDWSw6yPsocgqi+POn4yYDOONRh
	 plt1udVZtoSgDvXCNSJ+99QJhB7G4RBPwV4oiM2cP/TBNje4ngqAg+ogg+KhTcPs5s
	 rT2/x/QjqIsFL2N4v88tVAaTfqmol0ICpOv22MtSicR1mDfPZ2CXPYxxruIeHKV+Jr
	 qniqcHmn1OG9pEj5Th13k88NZcHTAnQcOil3NI/ayLSA30wsV5xhS4L4awWD4gyjJY
	 M4coAeWZZwTIQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 06/13] net: mana: swap queue sets in
 mana_change_mtu
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20260908032843.397667-7-longli@microsoft.com>
References: <20260908032843.397667-1-longli@microsoft.com>
 <20260908032843.397667-7-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 03:29:42 +0000
Message-Id: <20260909032943.082491F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] mana_change_mtu lacks channel_changing protection, causing a race =
condition with RDMA vport configuration on failure.
--

commit 1868db24408cc9d4a118e97d242371346d9b0c67
Author: Long Li <longli@microsoft.com>

net: mana: swap queue sets in mana_change_mtu

This commit updates mana_change_mtu to carry the MTU in the queue set,
replacing RX buffers and rebuilding all queues using a temporary queue set
swap instead of just detaching and attaching.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/=
ethernet/microsoft/mana/mana_en.c
> index bb9ef4e634a6e..7f7833f3e1aad 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -902,32 +902,37 @@ int mana_pre_alloc_rxbufs(struct mana_port_context =
*mpc, int new_mtu, int num_qu
>  static int mana_change_mtu(struct net_device *ndev, int new_mtu)
>  {
>  	struct mana_port_context *mpc =3D netdev_priv(ndev);
> -	unsigned int old_mtu =3D ndev->mtu;
> +	struct mana_port_context *scratch;
> +	struct mana_qset newq, oldq;
>  	int err;
> =20
> -	/* Pre-allocate buffers to prevent failure in mana_attach later */
> -	err =3D mana_pre_alloc_rxbufs(mpc, new_mtu, mpc->num_queues);
> -	if (err) {
> -		netdev_err(ndev, "Insufficient memory for new MTU\n");
> -		return err;
> +	if (!mpc->port_is_up) {
> +		mpc->configured_mtu =3D new_mtu;
> +		WRITE_ONCE(ndev->mtu, new_mtu);
> +		return 0;
>  	}
> =20
> -	err =3D mana_detach(ndev, false);
> -	if (err) {
> -		netdev_err(ndev, "mana_detach failed: %d\n", err);
> -		goto out;
> -	}
> +	scratch =3D mana_qset_scratch_alloc(mpc);
> +	if (!scratch)
> +		return -ENOMEM;
> =20
> -	WRITE_ONCE(ndev->mtu, new_mtu);
> +	err =3D mana_alloc_qset(mpc, scratch, mpc->num_queues,
> +			      mpc->rx_queue_size, mpc->tx_queue_size,
> +			      mpc->priv_flags, new_mtu, &newq);
> +	if (err)
> +		goto free_scratch;

[Severity: High]
This is a pre-existing issue, but does mana_change_mtu() need to set the
channel_changing flag to protect against concurrent RDMA operations? Unlike
the ethtool queue configuration paths, this function initiates a queue set
swap without taking vport_mutex to set apc->channel_changing to true.

> =20
> -	err =3D mana_attach(ndev);
> +	err =3D mana_publish_qset(mpc, &newq, &oldq);
>  	if (err) {
> -		netdev_err(ndev, "mana_attach failed: %d\n", err);
> -		WRITE_ONCE(ndev->mtu, old_mtu);
> +		mana_free_qset(scratch, &newq);
> +		goto free_scratch;
>  	}
> =20
> -out:
> -	mana_pre_dealloc_rxbufs(mpc);
> +	mana_free_qset(scratch, &oldq);
> +
> +free_scratch:
> +	mana_publish_close_if_needed(mpc);
> +	mana_qset_scratch_free(scratch);
>  	return err;
>  }

[Severity: High]
This isn't a bug introduced by this patch, but can this failure path race
with RDMA vport configuration?

On failure, mana_publish_close_if_needed() triggers a vport teardown via
mana_dealloc_queues() and mana_destroy_vport(). Because the
channel_changing flag is not set, a concurrent RDMA operation (such as
creating an RDMA RAW QP from userspace) could grab the vport mid-teardown,
specifically between mana_uncfg_vport() and mana_pf_deregister_hw_vport().

If this race occurs, the Ethernet driver might send a hardware deregister
command for a vport that RDMA just configured, potentially causing hardware
state corruption or PCIe errors.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908032843.3976=
67-1-longli@microsoft.com?part=3D6
