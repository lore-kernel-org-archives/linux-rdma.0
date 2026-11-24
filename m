Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795533179;
	b=kcqIptr2at5oK9/myxT+2W7Cq1Sf7o4N3qEIko0cEtnGSpBKJq9cg9sQB3JrMVjuZjVR
	 dFJjNuQCN/811nqoYZIobgamyMKOIcy0kexRek8dt2+XfcHd5L+ZVkzW+AxRw7ILARdqn
	 vvQdAaG+7l8nB6zHlk+H5PJsOabQAybqbjZx5eb2uNLgdGZEf+4s5twQCKGdMfhnowOb3
	 UPH9yVwRvgAH8FusMtfuouGH/4lUmltJwbO71KgEk/Lpz1o5P8xeVwVjZ+oqop5wU43TX
	 RgMLZzASY3aUeZpql6W8mkXRslHw5CyuocKAmWktcKfzdnlAp9LMvxVlMSUNRPsWvQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795533179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6Uar3t/+oC60cS1BrmaHO8k37ywHjnvxhO9kNhoiN88=;
	b=SHEswaAwRouk0qCTBoqbFQOlj4GZzzS8BMfntL5nBGiZFx5J9dcdgy7f0l++bhsXyLD1
	 gSH52JQ3RbuwjKT9/1AWpIcwh/eAc3lF5lrZjqO9VFiRIxsery1i2oqCppAtbxtXgBeK2
	 Q9qOikJ+iG4SCb7anxDuVC85efbKr+aH7gzBvWzWfhPCfQt4anIT01kx58xz8slNf10l6
	 H33Le82RSiCwMuiC0REknKxN87xgHIbkKLpefVqpEF10Ru69+5784mAbwi2X4dNC6eCq3
	 HqpEJhttG1r2dbPIsK9CNXwlsflSUThiA7b234HvxbhdIDtZrb/aBqaFD390MVoKodw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G+nNIFQ6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C46606A31E;
	Tue, 24 Nov 2026 15:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G+nNIFQ6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160881F000D0;
	Tue, 24 Nov 2026 15:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795533178;
	bh=6Uar3t/+oC60cS1BrmaHO8k37ywHjnvxhO9kNhoiN88=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=G+nNIFQ6jPsv18hssdU/aidLe43A5eos1FHdc/bh6x+c8CD5jfD6I4PWARXscaOBN
	 D7E1ZsP0YHF4CzUVbWfjmhXcrl1aPrxDi3UHNgE3xSX9ZHzHWTCTsm1wsiVwh1pMtt
	 ZNP4NYqq6RnetdnFjGdn8KDvSFjYBBqz3ctBl9/+UbzwNl3A74itsQerDBIzPI55Xb
	 yGQdtSmdx15Ss8gU6fcPzdrtmR3jcgtOcKLOuFKG3GOhgHDN1zcdmOqNIWQ5tfLMHF
	 DhCgfRZwEMHxdd1sm+y8zc15LdE+6SA1YJ4bM4fRExDteZHrNevMaCA5YY7z7JHWw/
	 eX3XpigD1u5OQ==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>, Maciej Fijalkowski
 <maciej.fijalkowski@intel.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
 <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi
 <memxor@gmail.com>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Alexander Duyck <alexanderduyck@fb.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Mark Bloch
 <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Michael Chan
 <michael.chan@broadcom.com>, Pavan Chebbi <pavan.chebbi@broadcom.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
 bpf@vger.kernel.org, netdev@vger.kernel.org, Stuart Clark
 <stuclar@meta.com>, Stanislav Fomichev <sdf@fomichev.me>, Simon Horman
 <horms@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Mina Almasry
 <almasrymina@google.com>, Song Liu <song@kernel.org>, Yonghong Song
 <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis
 <emil@etsalapatis.com>, Ihor Solodrai <ihor.solodrai@linux.dev>, Randy
 Dunlap <rdunlap@infradead.org>, kernel-team@meta.com, Dimitri Daskalakis
 <dimitri.daskalakis1@gmail.com>, Bobby Eshleman <bobbyeshleman@meta.com>,
 Mohsin Bashir <mohsin.bashr@gmail.com>, Kees Cook <kees@kernel.org>, Breno
 Leitao <leitao@debian.org>, Maxime Chevallier
 <maxime.chevallier@bootlin.com>, Tao Cui <cuitao@kylinos.cn>, Vadim
 Fedorenko <vadim.fedorenko@linux.dev>, "Mike Marciniszyn (Meta)"
 <mike.marciniszyn@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 Jiayuan Chen <jiayuan.chen@linux.dev>, Martin Karsten
 <mkarsten@uwaterloo.ca>, Nikolay Aleksandrov <razor@blackwall.org>, David
 Wei <dw@davidwei.uk>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 06/15] xsk: Lend UMEM chunks to the page pools
 of a queue
In-Reply-To: <CAJ8uoz3f2MPpDevbMY3q_Nx=SQ2Om1ojAxBTsYhNw1V9_NXQMA@mail.gmail.com>
References: <20261124112707.118678-1-bjorn@kernel.org>
 <20261124125654.183091-6-bjorn@kernel.org>
 <CAJ8uoz3f2MPpDevbMY3q_Nx=SQ2Om1ojAxBTsYhNw1V9_NXQMA@mail.gmail.com>
Date: Tue, 24 Nov 2026 16:12:56 +0100
Message-ID: <875wxmp8jr.fsf@all.your.base.are.belong.to.us>
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

Magnus Karlsson <magnus.karlsson@gmail.com> writes:

> On Tue, 24 Nov 2026 at 13:59, Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org> wr=
ote:
>> +/* RX buffers follow the device's layout: a page-sized chunk may hold
>> + * several of them, a packet may span chunks, and the device picks the
>> + * offsets. A FILL entry lends a chunk to the kernel. Needs aligned
>> + * page-sized chunks and no headroom.
>> + */
>> +#define XDP_UMEM_DRV_LAYOUT            (1 << 4)
>
> First of all, this looks a lot better than the previous patch set.
> Much simpler from a driver point of view, fewer changes to core
> networking code, and that with just a small change/extension to the
> uAPI.

Thanks, I do as well. Credits to Kuba that took me down this path.

> But I do not think this name is good. Most users of this API do not
> care about driver details such as the layout. Why not call it
> something that has to do with what has changed from the user's point
> of view? Previously we had implicit ownership transfers. You got a
> packet in Rx, you own the chunk. Now we have explicit ownership
> transfer. You do not own the chunk the packet is in, unless you get
> the new flag back (introduced later). So something with "explicit
> ownership" or something similar would be better. Or focus the name on
> that you can support larger chunks, but that is for later patches so
> might not be the best choice.

Magnus... naming is hard! Good point. There are two things in play; You
cannot choose your geometry, and explicit ownership.

XDP_UMEM_EXPLICIT_OWNERSHIP?
XDP_UMEM_EXPLICIT_RELEASE?
XDP_UMEM_CHUNK_COMPLETION?
XDP_UMEM_PACKED_RX?

I'm leaning towards XDP_UMEM_EXPLICIT_RELEASE, and naming the flag
XDP_RX_CHUNK_RELEASED?

>> diff --git a/net/xdp/xsk_sink.c b/net/xdp/xsk_sink.c
>> new file mode 100644
>> index 000000000000..b78116f25e71
>> --- /dev/null
>> +++ b/net/xdp/xsk_sink.c

>> +static netmem_ref xsk_sink_alloc_netmems(struct page_pool *pp, gfp_t gf=
p)
>> +{
>> +       struct xsk_sink *sink =3D pp->mp_priv;
>> +       /* The NAPI owns the need_wakeup flags */
>> +       bool napi =3D in_softirq() && !in_hardirq();
>> +       struct xsk_queue *fq;
>> +       dma_addr_t dma;
>> +       u32 i, n;
>> +
>> +       /* The page pool refills only an empty cache */
>> +       if (WARN_ON_ONCE(pp->alloc.count))
>> +               return 0;
>> +
>> +       spin_lock_bh(&sink->lock);
>> +       n =3D xsk_sink_take_fill(sink, pp);
>> +       n =3D xsk_sink_take_released(sink, pp, n);
>> +       fq =3D sink->fq;
>> +       /* Ask for kicks only while FILL runs dry, as zero copy drivers =
do: a
>> +        * kick schedules the NAPI, which a busy poller would rather run
>> +        * itself. Process context refills new queues only and leaves the
>> +        * flags to their NAPI and to bind.
>> +        */
>> +       if (napi && fq && sink->pool->uses_need_wakeup) {
>
> Was not need_wakeup a requirement for using this new mode? If so, why
> not just set it somewhere and not test it after that?

Argh, indeed. 08/15 makes XDP_USE_NEED_WAKEUP mandatory and removes both
checks when it enables the mode. I'll move that so the requirement is
clear from the start. Good catch.

>> +int xsk_sink_bind(struct xsk_buff_pool *pool, struct net_device *dev,
>> +                 u16 queue_id, u16 flags)
>> +{
>> +       u32 needed =3D NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT;
>> +       struct pp_memory_provider_params p =3D { .mp_ops =3D &xsk_sink_o=
ps };
>> +       struct device *dma_dev;
>> +       struct xsk_sink *sink;
>> +       int err;
>> +
>> +       if (flags & XDP_USE_SG)
>> +               needed |=3D NETDEV_XDP_ACT_RX_SG;
>> +       if (flags & XDP_COPY || !dev->queue_mgmt_ops ||
>> +           (dev->xdp_features & needed) !=3D needed ||
>> +           queue_id >=3D dev->real_num_rx_queues)
>> +               return -EOPNOTSUPP;
>> +
>> +       /* The program of another device would see a leased queue's pack=
ets */
>> +       if (netif_rxq_is_leased(dev, queue_id))
>> +               return -EOPNOTSUPP;
>> +
>> +       /* The device of the queue's page pools, which may differ per qu=
eue */
>> +       dma_dev =3D netdev_queue_get_dma_dev(dev, queue_id, NETDEV_QUEUE=
_TYPE_RX);
>> +       if (!dma_dev)
>> +               return -EOPNOTSUPP;
>> +
>> +       /* Without a program, drivers would build skbs from the buffers =
*/
>> +       if (!dev_xdp_drv_prog_held(dev))
>> +               return -ENOENT;
>> +
>> +       err =3D xp_dma_map(pool, dma_dev, XSK_SINK_DMA_ATTR, pool->umem-=
>pgs,
>> +                        pool->umem->npgs);
>> +       if (err)
>> +               return err;
>> +
>> +       sink =3D xsk_sink_create(pool, dma_dev);
>> +       if (IS_ERR(sink)) {
>> +               xp_dma_unmap(pool, XSK_SINK_DMA_ATTR);
>> +               return PTR_ERR(sink);
>> +       }
>> +
>> +       /* Until the first refill of the NAPI: the queue may need FILL to
>> +        * start. Set before the NAPI runs, which owns the flags after t=
hat.
>> +        */
>> +       if (pool->uses_need_wakeup)
>> +               xsk_set_rx_need_wakeup(pool);
>> +
>> +       /* The core keeps sink buffers to the socket once the queue runs=
 */
>> +       static_branch_inc(&xdp_sink_key);
>> +       sink->rxq =3D __netif_get_rx_queue(dev, queue_id);
>> +       pool->sink =3D sink;
>> +       p.mp_priv =3D sink;
>> +       err =3D netif_mp_open_rxq(dev, queue_id, &p, NULL);
>> +       if (err) {
>> +               xsk_sink_detach(pool);
>> +               return err;
>> +       }
>> +
>> +       return 0;
>> +}
>
> At a first glance it feels like some of this code could be shared with
> the current bind, but I guess you have already tried and it is not
> worth it, or? The commonality seems somewhat spread out.

Pool setup and registration are already shared in xp_assign_dev(). The
main difference is how we start the queue. Classic ZC calls the driver
with XDP_SETUP_XSK_POOL; this path maps the UMEM and installs a memory
provider with netif_mp_open_rxq().

I'll look for checks we can share without mixing the two setup and
unwind paths.


Thanks for having a look!
Bj=C3=B6rn
