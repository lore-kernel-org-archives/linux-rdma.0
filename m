Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795611614;
	b=2sxjlykzaRisQKMonoEqzpi56GQCkk2On5uFakP8pekPKQ9y6Bm/uuFj+YDUO7HUYnsx
	 VMYMcaDCLx2vCB8Zall0VWEkBlXdjafw0alVAq3iTxwx/vI354HNvwPFiVC2giE+2ZzFK
	 A32XoN3qL5GQcq6kuVR9TsIq4pAAmb4UDxWWkp2TRCuRn8BcS0Q60B52AkG++sz/rwsSj
	 M+X37X8VKDdgIRz92/ig2FV2iCBkWOUOmkRvti/E/WeAYqhlohAygld/jQmYVB6YVCWxA
	 ByJ4aBm/9YogtU+K2LMsUOUWftgj+tDLIPcoUSjVcGfiqetWLrB5vsiMZ4XmPlhwr/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795611614;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=teUXdgF3Q1iwMvSJnDYofJDUIEsTDxCe5AEiTGPEreY=;
	b=sxkO/VOftGCKeBu/NQOlrQVSQqFRxCaxQR8Y74IXa6xWyqvCKyaETvNQGEq7lKQ0QJuZ
	 d6slpEBZJH20JI1DoyS1/spCV8RDbo//e/VgbXtXd/ljGzl6/UrXBFLgO3g/57yAh+9WD
	 NHBvYgeqaAv/2+fo4uqw1XGsFeHAYm5RPqVhlnnrtZWAVCuxalAFzIdX03W/quPdyUTaq
	 YdU8rdaAu6zKgn2T2V5aq0TSbaFwUds0DL5hBIxXfvOOHgfygw6xZbhxEijQXdc8OgOKx
	 Z7J/2vAyq77vJRcUAFE6g0lb2maprtsU33e7EEEMoY5Vy6LW4zTVm5f7zoZxLPjcLRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UYL57BdN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19AB60A2603;
	Wed, 25 Nov 2026 13:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UYL57BdN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699C31F000C0;
	Wed, 25 Nov 2026 13:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795611614;
	bh=teUXdgF3Q1iwMvSJnDYofJDUIEsTDxCe5AEiTGPEreY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UYL57BdN4MIjJF8aNX7/7r9z09CtEUlP6JyJzwVcQ79/iTZ1DgvdYIZQZAwSSco4s
	 CJLCRRGwsadq1JUaEQd88JqoMPvHPAKNgiuKhF0uV0mXB1OyjUATbbabEhROT78Sb5
	 r33YS+tCCTBih7LBtpYpQZopVzaKp6/tHI5DwNWIEMgxe6N8Oys4w8VHl/yTmmAHGz
	 omKw6msVIchiao260e954eKaOAGoDUMYZX4TETMf9JC4Lm3hUCo39vwVYijXRzPSfK
	 IUq/sriwWLRyXYqyO1MTH6wfbcvawe3Iqh94Oo4+ATQdxso0ZKixZ+VkhfVPrTzDyf
	 EsrtwAvgGhzkg==
Message-ID: <sashiko-outbox-233418@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 08/15] xsk: Receive in the device's buffer
 layout
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, bpf@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261124125654.183091-8-bjorn@kernel.org>
References: <20261124112707.118678-1-bjorn@kernel.org>
 <20261124125654.183091-8-bjorn@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 13:00:14 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] xsk: skipped synchronous unbind in xsk_sink_release() for
  TX-only pool
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [High] xsk: data race on pool->cached_need_wakeup in
  xsk_set_rx_need_wakeup() [1]
--

commit 66e818b77c20713dcc88b2972bf6bf3dfff915da
Author: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

xsk: Receive in the device's buffer layout

This commit wires up XDP_UMEM_DRV_LAYOUT so AF_XDP sockets can register a U=
MEM
in the device's buffer layout, install the sink memory provider on bind, and
wake the queue NAPI from recvmsg() and poll().

> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 0753fac8d4a85..c015894a6ccba 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -55,7 +55,8 @@ void xsk_set_rx_need_wakeup(struct xsk_buff_pool *pool)
>  		return;
> =20
>  	pool->fq->ring->flags |=3D XDP_RING_NEED_WAKEUP;
> -	pool->cached_need_wakeup |=3D XDP_WAKEUP_RX;
> +	WRITE_ONCE(pool->cached_need_wakeup,
> +		   pool->cached_need_wakeup | XDP_WAKEUP_RX);
>  }
>  EXPORT_SYMBOL(xsk_set_rx_need_wakeup);
> =20
> @@ -72,7 +73,8 @@ void xsk_set_tx_need_wakeup(struct xsk_buff_pool *pool)
>  	}
>  	rcu_read_unlock();
> =20
> -	pool->cached_need_wakeup |=3D XDP_WAKEUP_TX;
> +	WRITE_ONCE(pool->cached_need_wakeup,
> +		   pool->cached_need_wakeup | XDP_WAKEUP_TX);
>  }
>  EXPORT_SYMBOL(xsk_set_tx_need_wakeup);
> =20
> @@ -82,7 +84,8 @@ void xsk_clear_rx_need_wakeup(struct xsk_buff_pool *poo=
l)
>  		return;
> =20
>  	pool->fq->ring->flags &=3D ~XDP_RING_NEED_WAKEUP;
> -	pool->cached_need_wakeup &=3D ~XDP_WAKEUP_RX;
> +	WRITE_ONCE(pool->cached_need_wakeup,
> +		   pool->cached_need_wakeup & ~XDP_WAKEUP_RX);
>  }
>  EXPORT_SYMBOL(xsk_clear_rx_need_wakeup);
> =20
> @@ -99,7 +102,8 @@ void xsk_clear_tx_need_wakeup(struct xsk_buff_pool *po=
ol)
>  	}
>  	rcu_read_unlock();
> =20
> -	pool->cached_need_wakeup &=3D ~XDP_WAKEUP_TX;
> +	WRITE_ONCE(pool->cached_need_wakeup,
> +		   pool->cached_need_wakeup & ~XDP_WAKEUP_TX);
>  }
>  EXPORT_SYMBOL(xsk_clear_tx_need_wakeup);

[Severity: High]
This problem wasn't introduced by this patch, but can concurrent updates to
pool->cached_need_wakeup lose wakeup flags [1] when RX and TX run in
separate NAPI contexts?

On drivers with separate RX and TX NAPI instances sharing the same
xsk_buff_pool (such as virtio_net), WRITE_ONCE() still performs a non-atomic
read-modify-write on pool->cached_need_wakeup:

CPU0 (RX NAPI)                    CPU1 (TX NAPI)
xsk_set_rx_need_wakeup()          xsk_set_tx_need_wakeup()
  read pool->cached_need_wakeup
                                    read pool->cached_need_wakeup
  write XDP_WAKEUP_RX
                                    write XDP_WAKEUP_TX  <-- drops RX flag

Dropping XDP_WAKEUP_RX or XDP_WAKEUP_TX stops userspace from waking the
queue to replenish the FILL ring or drain the TX ring, stalling packet
processing.

[ ... ]

> @@ -1585,6 +1605,29 @@ static void xsk_delete_from_maps(struct xdp_sock *=
xs)
>  	}
>  }
> =20
> +/* The pool may outlive the socket, see xp_put_pool(). A queue in the
> + * device's buffer layout stops receiving when its receiving socket goes,
> + * so that its program can go right after.
> + */
> +static void xsk_sink_release(struct xdp_sock *xs)
> +{
> +	struct xsk_buff_pool *pool =3D READ_ONCE(xs->pool);
> +	struct net_device *dev;
> +
> +	if (!pool || !READ_ONCE(pool->sink))
> +		return;
> +
> +	rtnl_lock();
> +	dev =3D pool->netdev;
> +	if (dev) {
> +		netdev_lock_ops(dev);
> +		if (pool->sink && xsk_sink_sock(pool->sink) =3D=3D xs)
> +			xsk_sink_unbind(pool);
> +		netdev_unlock_ops(dev);
> +	}
> +	rtnl_unlock();
> +}

[Severity: Medium]
Does xsk_sink_release() skip xsk_sink_unbind() when a TX-only socket creates
a pool with XDP_UMEM_DRV_LAYOUT and closes before any RX socket binds?

xsk_bind() allows a socket with xs->tx set and xs->rx =3D=3D NULL to create=
 a
pool, and xp_assign_dev() unconditionally calls xsk_sink_bind() when
XDP_UMEM_DRV_LAYOUT is set. Because xsk_sink_add_sock() only sets sink->xs
when xs->rx is non-NULL, sink->xs remains NULL:

net/xdp/xsk_sink.c:xsk_sink_add_sock() {
	if (xs->rx && !sink->xs) {
		/* The NAPI acquires the socket once it is set up */
		smp_store_release(&sink->xs, xs);
	}
}

When the TX-only socket is closed, xsk_sink_sock(pool->sink) =3D=3D xs is f=
alse
(NULL !=3D xs), so xsk_sink_unbind() is not run synchronously in xsk_releas=
e().
Because AF_XDP sockets use SOCK_RCU_FREE and xp_put_pool() defers pool
destruction to a workqueue, the MP_XDP_ONLY provider stays attached after
close() returns and causes an immediate XDP program detach to fail with
-EBUSY.

[1] https://sashiko.dev/#/bug/linux-3603ff9e-34c0-4710-bf99-5f028a2aa37d

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124112707.1186=
78-1-bjorn@kernel.org?part=3D8
