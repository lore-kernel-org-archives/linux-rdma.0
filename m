Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795637802;
	b=ifn+iycOPBK0VVNYVj4S3Ei6ACOA6+FJbWWp16CsJMYhaRai35iGq0FelmGHv8FVmZM5
	 WucTrMjnLIrCmo53OnAYEECI6Ns8tQIMLi/Q2nF2RV3Ymdw96aiKOc+r5r+k85LXOgFii
	 jGBV3Xct5NzDKGtyQjys8MIqc+QvGb7OB4QHoQh++o2rJP9/w0gARTcGkVSJrsWIGb+Yj
	 ejki2j8y5H0gTA3ilsqdC19fsGssX7Hubz7eQ9MV+jAtHSwkilHQAsvPnrlzBTdpBqH9p
	 /rcpNyJ+gQkw66u1/5RG46iCDDCeDeI5i6e7+T8bazd+MCH3P0cIZpxMibGy2+uu5Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795637802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FMoTVIsv2IP6m7YESB31vaDMuhfNof+tzgvvUh6wb7I=;
	b=pyqOocE9IomqniU1u9UmgUpXJERB9mY3KVFDEJHgzOJNY/8BM9z7U8Moa8NCAdPbE8Qe
	 f/QbBWNs0Ujq6d8cjTiB2l8pRgVpxv6DOHalcx9PwdO/cP8O4UJFn1Ppsy6PO6vcaLnGe
	 yLysMyROo4/VYexbtA+azZSq7PZaMaSX1O+mZW31s8420EKNuAEXsd7rJqa1csGZ2ABYn
	 0Qfr/lmh9NjJsp3zE3ODY2kX9nia8S/ePgAt6x3pYKTDJiXiDBxpVm3MBefTGyDQZVwX2
	 X0/B6begCRTwUoZVq+2Pmjqewbo4V7SwVDSJNAIthg8zVPufKveiPvGzxg8PJgvrw7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="il/dmMEK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F48606A327;
	Wed, 25 Nov 2026 20:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=il/dmMEK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167F81F000D3;
	Wed, 25 Nov 2026 20:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795637801;
	bh=FMoTVIsv2IP6m7YESB31vaDMuhfNof+tzgvvUh6wb7I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=il/dmMEKcJqRKHQ63Xsm7kj9wIdp1Rb/LuTssYKXM/Zs+sJLJyuzFCGGqSWBc1sGV
	 3DesCnw1x+Uv2XW5HLmVyYKNHmQMZf1mdxj/BACtRNq8wYAYKDOipgsB7/xDFzBRq9
	 jKl7WTugFvxx7goJSD+IfPjaCUFuLcQkbi9KwTu14KT5UPEFDZYJm1xHCB+St/BVKG
	 M8TlDq43AMWBe79ckUsZ978D6WYxql7h/C7lrvk5FkmtHtjaR6edvaiDn+NQUrJeje
	 reORIEhjWYS71Qgch7Li9ftHyz57mY3Y52bO5SLcm8ARXylD7Qt9MlUkEw/G0FeT77
	 zFKqlPMP3dxOg==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: netdev-bot+sashiko@kernel.org
Cc: magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, andrew+netdev@lunn.ch, ast@kernel.org,
 daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
 andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com,
 ilias.apalodimas@linaro.org, alexanderduyck@fb.com, saeedm@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 michael.chan@broadcom.com, pavan.chebbi@broadcom.com, corbet@lwn.net,
 shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
 stuclar@meta.com, sdf@fomichev.me, horms@kernel.org, martin.lau@linux.dev,
 almasrymina@google.com, song@kernel.org, yonghong.song@linux.dev,
 jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev,
 rdunlap@infradead.org, kernel-team@meta.com,
 dimitri.daskalakis1@gmail.com, bobbyeshleman@meta.com,
 mohsin.bashr@gmail.com, kees@kernel.org, leitao@debian.org,
 maxime.chevallier@bootlin.com, cuitao@kylinos.cn,
 vadim.fedorenko@linux.dev, mike.marciniszyn@gmail.com, kuniyu@google.com,
 jiayuan.chen@linux.dev, mkarsten@uwaterloo.ca, razor@blackwall.org,
 dw@davidwei.uk, asml.silence@gmail.com, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 08/15] xsk: Receive in the device's buffer layout
In-Reply-To: <179561570478.3135.6883565218778603025@kernel.org>
References: <20261124125654.183091-8-bjorn@kernel.org>
 <179561570478.3135.6883565218778603025@kernel.org>
Date: Wed, 25 Nov 2026 21:16:39 +0100
Message-ID: <875wxkmztk.fsf@all.your.base.are.belong.to.us>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

netdev-bot+sashiko@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 6 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 1 =C2=B7 Medium: 2 =C2=B7 Low: 3
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
>
> - [High] Since this patch, a process with only CAP_NET_RAW in the
>   device's netns can install an XDP-only memory provider on an RX queue.
> - [Medium] With an XDP_UMEM_DRV_LAYOUT UMEM, a bind that passes
>   XDP_ZEROCOPY succeeds, but the socket is not reported or treated as=E2=
=80=A6
> - [Medium] xsk: skipped synchronous unbind in xsk_sink_release() for TX-
>   only pool
> - [Low] xsk_sink_wakeup() (net/xdp/xsk_sink.c) is the first lockless
>   reader of rxq->napi.
> - [Low] The commit message of "xsk: Receive in the device's buffer
>   layout" lists the new bind rules in detail: one receiver, -EBUSY,=E2=80=
=A6
> - [Low] (Baseline: rejected.) The concern was that XDP_UMEM_DRV_LAYOUT
>   and XDP_RX_CHUNK_FREE have no documentation or selftests.
>
> --
>
> xsk: Receive in the device's buffer layout
>
> This patch accepts XDP_UMEM_DRV_LAYOUT at UMEM registration and installs
> the xsk_sink memory provider when a socket with such a UMEM binds to a
> queue. A queue in this mode has one receiving socket, and the provider is
> removed when that socket closes. recvmsg() and poll() now schedule the
> queue NAPI when the RX need_wakeup flag is set.
>
>> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
>> index cd8643360eb3a..5989e5e0e17e5 100644
>> --- a/net/xdp/xdp_umem.c
>> +++ b/net/xdp/xdp_umem.c
>> @@ -153,6 +153,7 @@ static int xdp_umem_account_pages(struct xdp_umem *u=
mem)
>>  		XDP_UMEM_UNALIGNED_CHUNK_FLAG | \
>>  		XDP_UMEM_TX_SW_CSUM | \
>>  		XDP_UMEM_TX_METADATA_LEN | \
>> +		XDP_UMEM_DRV_LAYOUT | \
>>  	0)
>
> [Severity: High]
>
> With this flag accepted, can a process that has only CAP_NET_RAW in the
> device's netns take over an RX queue that the administrator's native XDP
> program runs on?
>
> xsk_create() only checks:
>
> 	if (!ns_capable(net->user_ns, CAP_NET_RAW))
> 		return -EPERM;
>
> The bind path xsk_bind()->xp_assign_dev()->xsk_sink_bind() checks device
> features, queue leasing and dev_xdp_drv_prog_held(). It does not check
> privilege before:
>
> 	err =3D netif_mp_open_rxq(dev, queue_id, &p, NULL);
>
> Once the provider is installed, bpf_prog_run_xdp() overrides the
> program's verdicts for every buffer on that queue:
>
> 	if (static_branch_unlikely(&xdp_sink_key) && xdp_buff_is_sink(xdp) &&
> 	    (act =3D=3D XDP_PASS || act =3D=3D XDP_TX))
> 		act =3D XDP_DROP;
>
> While dev_has_xdp_only_mp() is true, dev_xdp_attach() also refuses with
> -EBUSY to detach the native program. If netif_mp_close_rxq() fails at
> socket close, xsk_sink_unbind() calls netif_close() on the whole device.
>
> The other memory provider install paths require CAP_NET_ADMIN. io_uring
> zcrx uses capable(CAP_NET_ADMIN), and the devmem netlink bind is admin
> only. Classic AF_XDP zero copy under CAP_NET_RAW does not override
> XDP_PASS or XDP_TX on the queue.
>
> Should xsk_sink_bind() require CAP_NET_ADMIN in the device's netns before
> it installs the provider?

Ah, yes, like devmem and iouring rz do.

> [Severity: Low]
>
> This isn't a bug, but this change makes XDP_UMEM_DRV_LAYOUT (and
> XDP_RX_CHUNK_FREE) usable from userspace before they have documentation
> or selftests.
>
> Two later patches in the series close this gap:
>
>   "selftests: net: xsk: Test the device's RX buffer layout" adds -D mode
>   to xskxceiver.
>
>   "Documentation: networking: Describe AF_XDP RX in the device's layout"
>   adds a Device Buffer Layout section to af_xdp.rst.
>
> [ ... ]

Right.

>> diff --git a/net/xdp/xsk_sink.c b/net/xdp/xsk_sink.c
>> index 9f1f7cf822667..2c23fecb59d41 100644
>> --- a/net/xdp/xsk_sink.c
>> +++ b/net/xdp/xsk_sink.c
>
> [ ... ]
>
>> @@ -501,6 +501,10 @@ int xsk_sink_bind(struct xsk_buff_pool *pool, struc=
t net_device *dev,
>>  	struct xsk_sink *sink;
>>  	int err;
>>=20=20
>> +	/* Without a wakeup, a queue that used up the FILL ring stays dry */
>> +	if (!(flags & XDP_USE_NEED_WAKEUP))
>> +		return -EINVAL;
>> +
>
> [Severity: Low]
>
> The commit message lists the new bind rules: one receiver, -EBUSY,
> XDP_COPY fails, no fallback. It does not mention this new -EINVAL for a
> bind without XDP_USE_NEED_WAKEUP.
>
> It also does not mention that the pool->uses_need_wakeup checks are
> removed from xsk_sink_bind() and xsk_sink_alloc_netmems(). Those checks
> were added by "xsk: Lend UMEM chunks to the page pools of a queue".
>
> The UAPI comment on XDP_UMEM_DRV_LAYOUT in include/uapi/linux/if_xdp.h
> only lists the registration constraints ("Needs aligned page-sized chunks
> and no headroom").
>
> af_xdp.rst documents the EINVAL later in the series, so this only affects
> the description of this patch. Could the commit message mention that
> XDP_USE_NEED_WAKEUP is now required, and why the uses_need_wakeup guards
> are removed?

Yeah, I'll add this.

>>  	if (flags & XDP_USE_SG)
>>  		needed |=3D NETDEV_XDP_ACT_RX_SG;
>>  	if (flags & XDP_COPY || !dev->queue_mgmt_ops ||
>
> [Severity: Medium]
>
> XDP_COPY is rejected here. What happens with XDP_ZEROCOPY?
>
> xp_assign_dev() sends every DRV_LAYOUT pool to xsk_sink_bind(). It
> returns before the force_zc and zero copy setup:
>
> 	if (pool->umem->flags & XDP_UMEM_DRV_LAYOUT) {
> 		err =3D xsk_sink_bind(pool, netdev, queue_id, flags);
> 		...
> 		return 0;
> 	}
>
> So umem->zc stays false, and xsk_bind() then sets xs->zc =3D xs->umem->zc.
>
> A bind with XDP_ZEROCOPY | XDP_USE_NEED_WAKEUP therefore succeeds. After
> that, getsockopt(XDP_OPTIONS) does not report XDP_OPTIONS_ZEROCOPY, and
> TX goes through xsk_generic_xmit() in copy mode.
>
> Documentation/networking/af_xdp.rst says "the XDP_ZEROCOPY flag will
> force the socket into zero-copy mode or fail". The section added at the
> end of the series says these sockets transmit in copy mode. It does not
> say what XDP_ZEROCOPY means for them.
>
> Should xsk_sink_bind() also reject XDP_ZEROCOPY? Otherwise, should the
> documented semantics be updated before this becomes ABI?

Same as patch 6.

> [ ... ]
>
>> @@ -591,6 +594,22 @@ void xsk_sink_unbind(struct xsk_buff_pool *pool)
>>  	xsk_sink_detach(pool);
>>  }
>>=20=20
>> +int xsk_sink_wakeup(struct xsk_sink *sink)
>> +{
>> +	struct netdev_rx_queue *rxq;
>> +	struct napi_struct *napi;
>> +
>> +	rxq =3D READ_ONCE(sink->rxq);
>> +	napi =3D rxq ? READ_ONCE(rxq->napi) : NULL;
>
> [Severity: Low]
>
> Does this lockless read of rxq->napi pair with anything on the writer
> side?
>
> struct netdev_rx_queue documents napi as "ops protected". Other readers,
> such as xsk_bind() and netdev-genl, hold the instance lock. This one is
> reached from recvmsg() and poll() through xsk_wakeup() with only
> rcu_read_lock() held.
>
> The writer, netif_queue_set_napi(), does a plain store:
>
> 	rxq->napi =3D napi;
>
> Drivers call it during queue restarts, for example in
> mlx5e_activate_channel() and mlx5e_deactivate_channel(). A poll() that
> races with an ethtool ring change would then be an unannotated data race
> that KCSAN reports.
>
> The lifetime of the napi_struct is also not tied to the sink:
>
>   The synchronize_net() in xsk_sink_stop() covers sink->rxq, not the
>   NAPI.
>
>   __netif_napi_del_locked() does not clear rxq->napi.
>
> mlx5, bnxt and fbnic all clear rxq->napi and go through synchronize_net()
> before they free the NAPI. The core does not document or enforce that.
>
> Would this need WRITE_ONCE() in netif_queue_set_napi() and a documented
> RCU rule for rxq->napi?

We can do that, and document the rules.

>> +	if (!napi)
>> +		return -ENETDOWN;
>> +
>> +	local_bh_disable();
>> +	napi_schedule(napi);
>> +	local_bh_enable();
>> +	return 0;
>> +}
>
> [ ... ]
>
>> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
>> --- a/net/xdp/xsk.c
>> +++ b/net/xdp/xsk.c
>> @@ -1585,6 +1605,29 @@ static void xsk_delete_from_maps(struct xdp_sock =
*xs)
>>  	}
>>  }
>>=20=20
>> +/* The pool may outlive the socket, see xp_put_pool(). A queue in the
>> + * device's buffer layout stops receiving when its receiving socket goe=
s,
>> + * so that its program can go right after.
>> + */
>> +static void xsk_sink_release(struct xdp_sock *xs)
>> +{
>> +	struct xsk_buff_pool *pool =3D READ_ONCE(xs->pool);
>> +	struct net_device *dev;
>> +
>> +	if (!pool || !READ_ONCE(pool->sink))
>> +		return;
>> +
>> +	rtnl_lock();
>> +	dev =3D pool->netdev;
>> +	if (dev) {
>> +		netdev_lock_ops(dev);
>> +		if (pool->sink && xsk_sink_sock(pool->sink) =3D=3D xs)
>> +			xsk_sink_unbind(pool);
>> +		netdev_unlock_ops(dev);
>> +	}
>> +	rtnl_unlock();
>> +}
>> +
>>  static int xsk_release(struct socket *sock)
>>  {
>>  	struct sock *sk =3D sock->sk;
>
> [Severity: Medium]
> What happens when the socket that creates a DRV_LAYOUT pool has no RX
> ring?
>
> xsk_bind() only requires xs->rx or xs->tx. A TX-only socket with a
> FILL and COMPLETION ring can therefore create its own pool, either
> with its own UMEM or through XDP_SHARED_UMEM on another queue or
> device. xp_assign_dev() then hands the pool to xsk_sink_bind() without
> looking at xs->rx, and netif_mp_open_rxq() installs the provider on
> the RX queue. xsk_sink_add_sock() only records a socket that has an RX
> ring, so sink->xs stays NULL.
>
> While that socket is open, the queue runs with the provider, but its
> packets reach no socket.
>
> When it closes, xsk_sink_release() compares xsk_sink_sock(pool->sink)
> with xs. The sink socket is NULL, so xsk_sink_unbind() is skipped.
>
> The provider then stays until the pool itself goes:
>
>   The socket is SOCK_RCU_FREE, so its destructor runs after a grace
>   period.
>
>   The destructor drops the pool with xp_put_pool(), which defers
>   xp_release_deferred() to system_freezable_wq.
>
>   Other TX-only sockets that share the pool keep it longer still.
>
> Until then dev_has_xdp_only_mp() stays true, and dev_xdp_attach()
> refuses to detach the program with -EBUSY.
>
> The commit message says the provider goes with the receiving socket so
> that the program can be detached right after. That does not hold when
> no receiving socket ever bound.
>
> Should xsk_sink_bind() refuse a bind without an RX ring? Or should
> xsk_sink_release() also unbind when sink->xs is NULL and xs is the
> last socket of the pool? The -EBUSY check in xsk_bind() lets a later
> RX socket join a sink that has no receiver yet, so it is not clear
> which of the two is intended.

Good one! TX-only sockets has to keep working.
