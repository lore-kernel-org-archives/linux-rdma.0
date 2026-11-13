Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794567497;
	b=Lvu6w1nYQF2pTNA/4S3JWgE9vY9AgzyP9i4d1ffjgxq/Z5aELxX7BVyhE+qxWbRb2Jmt
	 xSiHbOS6hQP7edzvlVg8GG4rkoXjSwW5cEbbwUOHrSvA7wbYf4pNfv6jUGjsoHO+RNxSC
	 hp5NIWFFFOXte4pDG/e+SrMtnQme5LoL5OITa/m+DvdVn5wmpPKmDZOwqDiCBwbkZ7Ba7
	 CygoDD7o7+U1vy1nhn+lN+MWhZaYIHByv+VVFK8rRLVf36tUch9tIYn/JabmI/6HzM78d
	 hrA8ZUp8Ocf3/nTTqE1SeXqDpMmimBdBKhs3CybIjwdW09blxCQSoDM6hDtxNIz7T1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794567497;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hl5UhwmBpkyc5BdJ+qHMQAS5l0WAMi5yURieiadLYeA=;
	b=IYQuh4caURcflApyeWy/WTNU8b+fprdtA27rm7+lKgSNEnYL172rLaVkroBV2TtLuYDk
	 OyFzdUpnTeLvHCalKcaXgyI55lePiDQEhT7lqQz2dYpc34PH5Thu+hK5Ny/saNGe3i2Yh
	 lx6Qu3UXZuOVstaglZenp4yI+lUCcZ4NzXLZ27WoYcMjJ9Y4l8L3mGaTTWaZsLXDih9Nb
	 Nrb/l88Z+aWt6xhDcRqM6GYa271OHlbHwQ8/JRrsTXbS/TT2l1ke6RqkXWM+wyeTcONQw
	 fptTyKEw31ZFNtP/ObAS+8OdNe6RBhYBXop7bf9IttH4zKNBxcoAph8bNSFIHAjn88g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WDVZVMcX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97698606B24F;
	Fri, 13 Nov 2026 10:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WDVZVMcX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0655A1F000C4;
	Fri, 13 Nov 2026 10:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794567497;
	bh=hl5UhwmBpkyc5BdJ+qHMQAS5l0WAMi5yURieiadLYeA=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=WDVZVMcXJttmyhG4HI3lH1D+c9CfWmyPY6jEOwz7d5lURfMK0DKp/z0muu4yvhkjJ
	 B+X3lpVJ+h8dtwI1+YS8nTJwelqRMqXIFTxBWM62bnOKz3+Q0+KzmbxnNc3aOIqdBY
	 qsyZ3RSLyGNggdXAmg1xZuljIpDv4eQB9rD4DnVonsGRy87OkztAvUvd9mGmVhdEfe
	 ooaYoPu7TCRplsJjh64gZfs5v/z+SyRoC2zgtWWzFvfJrVqFJWdoNIYMEE1xm5Uswz
	 NeT8d/V0a8SJlhuR3S/zkVeXAMge2YDfhdidK9JtxQuLKPvlZk2UbPvpCSOLhZ+OW9
	 Crkrfm8WE1wiw==
Message-ID: <sashiko-outbox-212652@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next] net: mana: Add CQE polling as first-level TX
 timeout recovery
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sahil Chandna" <sahilchandna@linux.microsoft.com>, linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261112105752.978446-1-sahilchandna@linux.microsoft.com>
References: <20261112105752.978446-1-sahilchandna@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 10:58:16 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] net: mana: missing netdev_lock() in mana_detach() callers
  [1]
--

commit 6f4e15a96596e896188b6e028bb49a0d4c04269b
Author: Sahil Chandna <sahilchandna@linux.microsoft.com>

net: mana: Add CQE polling as first-level TX timeout recovery

This commit adds a first-level TX timeout recovery mechanism that polls
the stalled queue's TX CQ via napi_schedule() before escalating to a
port-level queue reset.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/=
ethernet/microsoft/mana/mana_en.c
> index e6d494df22e4d..0d8c8b8fbc83f 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -336,6 +336,9 @@ static void mana_per_port_queue_reset_work_handler(st=
ruct work_struct *work)
>  	if (err)
>  		netdev_err(ndev, "mana_attach failed: %d\n", err);
> =20
> +	/* Let the next TX timeout try a CQE poll recovery first */
> +	WRITE_ONCE(apc->last_tx_timeout, 0);

[Severity: Critical]
This problem wasn't introduced by this patch, but should
mana_per_port_queue_reset_work_handler() (along with mana_remove(),
mana_probe() on resume, and mana_xdp_set()) hold netdev_lock(ndev) around
mana_detach() and mana_attach() [1]?

Because mana_devops sets .net_shaper_ops, netdev_need_ops_lock() is
enabled on MANA net_device instances.  Queue teardown in mana_detach()
calls napi_disable_locked() and netif_napi_del_locked() via
mana_destroy_txq() and mana_destroy_rxq(), while mana_attach() calls
netif_napi_add_locked(), netif_napi_add_weight_locked(), and
napi_enable_locked().  Calling these under rtnl_lock() alone violates
netdev_assert_locked(), leaves NAPI state unserialized against netdev-genl
operations, and allows ops-locked ethtool callbacks (such as
mana_get_ethtool_stats() or mana_set_coalesce()) running under
netdev_lock() without rtnl_lock() to race with apc->rxqs and apc->tx_qp
teardown, leading to a use-after-free or NULL pointer dereference.

[1] https://sashiko.dev/#/bug/linux-2946b7e7-6855-49c0-921d-a6daa482c10c

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112105752.9784=
46-1-sahilchandna@linux.microsoft.com?part=3D1
