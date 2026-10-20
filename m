Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792514904;
	b=TZIWW+Nhw5wVfbeu0UXpsA5Yn2eG5YmDQ8yt2UnC30eFsGrGIoJZBD7UGt8oUF6bdx9b
	 VpsFp5bnyolhngR8Q0ZgLLG8S6yzx8gZyLZfmrt/lQxqzuaVpCg65kyVDWecLf5JR6+xF
	 nVx5CWEhwoN3TS2fkSEFTONVHWrFfGouU7qo0WonYmhxos6llnVYL/uSghE9mC3WSn1EP
	 WTH68h1zMlirSHQSHadYsl962hLY8dh/CrslbL5XAG36t+/MfWrVKVo0HnxHI+dM2nUcS
	 lZGN0l6+t+HTG5evBpdbBJpenVg5xKMaAsUK11AOqQMVgG4ieMZv9G9U6SC17G9MU7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514904;
	h=Received:Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 X-sashiko-severity:Content-Type:Content-Transfer-Encoding:
	 MIME-Version;
	bh=1illLIaBDeFU2zbxmo9prlGBOHfd+GAU8SDqkYsZmfU=;
	b=3SUWr/+FW4hC5IemJ4sZE2jzVU/W/J/HQFTXFJ52ei16KEbJZh+rFbOD7r87zZVlfrOf
	 7Uf/SUXL1Pg0f5GgyWV20V0hfeUXwEAqFW/MsWZ0mkJO0KwYh35GNi1wrFdGrS92lwJc3
	 YgrixkoMso2LWorQh/wLERT6xdy9f73cDCfPQeAjbs+14IKmc/MrCnHkZjO7Jk3T5fcNX
	 2uMfXFkpbVxWew4oV4xcUXUJFXvCyf/DicogyUcLObWlIkvEfGgbUaO0z4cjcZkP9FWZ3
	 SzLrH165aHIBExEyVR4uXcrWq2JcezvOBjVoMg3WQL1/z88MlEjZAcuPZK8WbavL4Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B9E606D574;
	Tue, 20 Oct 2026 16:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D921F000C9;
	Tue, 20 Oct 2026 16:48:22 +0000 (UTC)
Subject:
 Re: [PATCH net-next v7 07/13] net: mana: swap queue sets in mana_change_mtu
From: netdev-bot+sashiko@kernel.org
To: weh@linux.microsoft.com
Cc: longli@kernel.org, kotaranov@microsoft.com, kuba@kernel.org,
 davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 andrew+netdev@lunn.ch, jgg@ziepe.ca, leon@kernel.org, haiyangz@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, shradhagupta@linux.microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, stephen@networkplumber.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, sdf@fomichev.me, daniel@iogearbox.net, hawk@kernel.org,
 ast@kernel.org, john.fastabend@gmail.com, weh@microsoft.com,
 edumazet@kernel.org
Date: Tue, 20 Oct 2026 16:47:51 +0000
Message-ID: <179251487177.3135.3241052074893563065@kernel.org>
In-Reply-To: =?utf-8?q?=3C87e016ed7479a33be87128b01bb07d2e1807c87d=2E1791710?=
 =?utf-8?q?735=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
References: =?utf-8?q?=3C87e016ed7479a33be87128b01bb07d2e1807c87d=2E17917107?=
 =?utf-8?q?35=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
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

- [Medium] mana_change_mtu() adds a new use of the boolean
  channel_changing as an ad-hoc lock.

--

net: mana: swap queue sets in mana_change_mtu

With this patch, mana_change_mtu() builds a full replacement queue set
sized for the new MTU and swaps it in. It no longer does a detach and
attach. The MTU is carried in the queue set as configured_mtu, and
ndev->mtu is published only after RSS configuration succeeds.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index c80a06ffbe508..c1ff4d9b8d45f 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -956,32 +956,52 @@ int mana_pre_alloc_rxbufs(struct mana_port_context *mpc, int new_mtu, int num_qu
>  static int mana_change_mtu(struct net_device *ndev, int new_mtu)
>  {

[ ... ]

> +	/* Fail-close may release the Ethernet vport reference. */
> +	mutex_lock(&mpc->vport_mutex);
> +	if (mpc->channel_changing) {
> +		mutex_unlock(&mpc->vport_mutex);
> +		return -EBUSY;
> +	}
> +	mpc->channel_changing = true;
> +	mutex_unlock(&mpc->vport_mutex);
> +
> +	scratch = mana_qset_scratch_alloc(mpc);
> +	if (!scratch) {
> +		err = -ENOMEM;
> +		goto clear_flag;
>  	}
>  
> -	WRITE_ONCE(ndev->mtu, new_mtu);
> +	err = mana_alloc_qset(mpc, scratch, mpc->num_queues,
> +			      mpc->rx_queue_size, mpc->tx_queue_size,
> +			      mpc->priv_flags, new_mtu, &newq);
> +	if (err)
> +		goto free_scratch;
>  
> -	err = mana_attach(ndev);
> +	err = mana_publish_qset(mpc, &newq, &oldq);
>  	if (err) {
> -		netdev_err(ndev, "mana_attach failed: %d\n", err);
> -		WRITE_ONCE(ndev->mtu, old_mtu);
> +		mana_free_qset(scratch, &newq);
> +		goto free_scratch;
>  	}
>  
> -out:
> -	mana_pre_dealloc_rxbufs(mpc);
> +	mana_free_qset(scratch, &oldq);
> +
> +free_scratch:
> +	mana_publish_close_if_needed(mpc);
> +	mana_qset_scratch_free(scratch);
> +clear_flag:
> +	mutex_lock(&mpc->vport_mutex);
> +	mpc->channel_changing = false;
> +	mutex_unlock(&mpc->vport_mutex);
>  	return err;
>  }

[Severity: Medium]
Here, channel_changing seems to act as a lock around a code section rather
than as a record of object state. Is that the intent?

The flag is set under vport_mutex, and then the mutex is dropped. The whole
sleeping replacement runs after that: mana_qset_scratch_alloc(),
mana_alloc_qset(), mana_publish_qset(), mana_free_qset(),
mana_publish_close_if_needed() and mana_qset_scratch_free(). The flag is
cleared again at clear_flag.

The only reader is on the RDMA side, and it fails instead of waiting:

mana_cfg_vport() {
    ...
	mutex_lock(&apc->vport_mutex);
	if (apc->vport_use_count > 0 ||
	    (check_channel_changing && apc->channel_changing)) {
		mutex_unlock(&apc->vport_mutex);
		return -EBUSY;
	}
    ...
}

As a result, RAW-QP creation gets a transient -EBUSY during any MTU change
on a running port. Lockdep also cannot see this exclusion.

vport_mutex probably can't just be held across the region, because the
fail-close path takes it itself:

mana_publish_close_if_needed()
  -> mana_dealloc_queues()
    -> mana_destroy_vport()
      -> mana_uncfg_vport()
        -> mutex_lock(&apc->vport_mutex)

Can the -EBUSY check at the top of mana_change_mtu() ever trigger? Every
writer of channel_changing holds RTNL for its whole region, and RDMA only
reads the flag. The writers are mana_change_mtu(), the queue reset work,
the set_channels, set_ringparam and set_priv_flags handlers, and the XDP
setup path.

The same pattern already exists in the queue reset work,
mana_set_channels() and mana_set_priv_flags(). This patch extends it to
the MTU path, and it is still there at the end of the series. Could a real
lock, or some way for RDMA admission to wait, be used here?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791710735.git.weh%40linux.microsoft.com
