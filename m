Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336037;
	b=FstOU9+CDGtig7vhnZT6hVVigjV0VAOPC7Ba4VlO0JZZuQTnLAsxIhMtPfX/ZxUBZOVU
	 UW09ShnvzHeBIqPOyxTswV0uO2ql4iuJf3nMsjOWJWODzOAvGlueKA6hZs1hmdea075H/
	 vP7bq4r7FhQ/FFS95aayHOwWj2HXIOWzOfVTS8GPlY4DFI7okyPXhW5M6bGqRfa85wx0S
	 Zk/M/XFWRzCloEu/c6Hy7HpVkIgNUlJUx87mmhe9hVEv3HWSFnS4HPJ9/l8tPFCdvGgJw
	 7NEhjz/J0kEc9sr6Z4GDUO+qFWT3YSU+FhaZvOwFiwAZe+TXqNOL0fqJQLrJ3X7qi7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336037;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=fo63kHnTTdpmA3nwVAGZN/RGaMNHgl/7dJJnSEM5/bg=;
	b=Sbzn7HSahgye1tlONn6SBUr8g+MV8h+UNn742glH4SeJUstCwRJuQyb7NTjo+SgqMLHZ
	 srp14lT1FWC6EpUE8xxB8enybKxywYP14s7JcrgY5S1sqIuewjvm97D1+mk2lsac5ZAC0
	 RYIHGetgJywngx7JM17+OUFkBkFHMf/NSEYJVkBSm9nkmm+96c4ilep9fIFDdrW91XxxU
	 DkachqPdjbWmj5r0cgqJYZFHgS5ANtB+a/+43gOIMuHYiisjTh7DPAVztD01rb++PiAik
	 bYgB8/3zTs6Q8hX8rk6u3qdIHSOEe0Rdo9pPaP5qM5M/y6mX/X0kvKRCmEmOt2dKjww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nkos66Ga;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4043A606A327;
	Fri, 30 Oct 2026 04:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nkos66Ga
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2681F000C1;
	Fri, 30 Oct 2026 04:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336036;
	bh=fo63kHnTTdpmA3nwVAGZN/RGaMNHgl/7dJJnSEM5/bg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nkos66GaOwkjNTnfMc9CbYf1dD5nWycPk6Xwq7cPspTROFD5fEWNtf4qGdx5ViNQn
	 t/pisdzde0vXdmEEuAlpNaj28hYnY39SKMhNbtyr2JcNWBt4jTaHuHgJA/2bOetjtZ
	 MvQ6MdEkKruvFI0qSfJa8JGhYu1kXz7JzVGJ0juXh5bGFmGqjC5/JbwgOmpX0Ep63d
	 H5inWHaXnVkNlCer1AykSLPOQJ97awlTdWS95oGgwyfoOIJ8JgiWOkuswiqNzxQVHc
	 CwURngisSN/kLgnDzL4rpJuQKcfVHmy5Hsl4QtI9hENT6GxBBK0tNMaIceUF0MaAqF
	 RDgGXbw59x/dA==
Message-ID: <sashiko-outbox-190384@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 3/8] net: devmem: support TX over
 NETMEM_TX_NO_DMA devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bobby Eshleman" <bobbyeshleman@gmail.com>
Cc: linux-rdma@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20260507-tcp-dm-netkit-v3-3-52821445867c@meta.com>
References: <20260507-tcp-dm-netkit-v3-3-52821445867c@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:56 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] Missing reference counting on `dev` and `vdev` leads to a Use-=
After-Free when the netlink socket is closed.
- [High] `validate_xmit_unreadable_skb()` completely skips validation for n=
etkit guest devices, breaking virtual device isolation.
- [High] Acquiring multiple `net_device` locks sequentially triggers a lock=
dep recursive locking warning.
- [Medium] A netmem TX binding is leaked if `genlmsg_reply()` fails in `net=
dev_nl_bind_tx_doit()`.
--

commit c3a040f13f3fa1b8e979677a0a83d0686597944b
Author: Bobby Eshleman <bobbyeshleman@meta.com>

net: devmem: support TX over NETMEM_TX_NO_DMA devices

When a netkit virtual device leases queues from a physical NIC, devmem
TX bindings created on the netkit device must still result in the dmabuf
being mapped for dma by the physical device. This patch accomplishes
this by teaching the bind handler to search for the underlying
DMA-capable device by looking it up via leased rx queues.

> diff --git a/net/core/dev.c b/net/core/dev.c
> index fbe4c328a3674..268417c9ef224 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3999,6 +3999,9 @@ static struct sk_buff *validate_xmit_unreadable_skb=
(struct sk_buff *skb,
>  	if (dev->netmem_tx =3D=3D NETMEM_TX_NONE)
>  		goto out_free;
> =20
> +	if (dev->netmem_tx =3D=3D NETMEM_TX_NO_DMA)
> +		goto out;
> +

The commit message states that the skb is validated twice: once on the netk=
it
guest device and again on the physical NIC. However, this check seems to
completely bypass the validation for the guest device rather than validating
it.

Since all virtual devices leasing queues from the same physical NIC share t=
he
same binding->dev, the physical NIC cannot distinguish between their devmem
payloads. Should this instead explicitly validate that
READ_ONCE(binding->vdev) =3D=3D dev to preserve isolation?

>  	shinfo =3D skb_shinfo(skb);
> =20
>  	if (shinfo->nr_frags > 0) {

> diff --git a/net/core/devmem.c b/net/core/devmem.c
> index cde4c89bc146a..644c286b778f1 100644
> --- a/net/core/devmem.c
> +++ b/net/core/devmem.c
[ ... ]
> @@ -212,6 +212,7 @@ net_devmem_bind_dmabuf(struct net_device *dev,
>  	}
> =20
>  	binding->dev =3D dev;
> +	binding->vdev =3D vdev;
>  	xa_init_flags(&binding->bound_rxqs, XA_FLAGS_ALLOC);

Are dev and vdev missing reference counting here?

Because TX bindings are not attached to device queues, their lifetime is
strictly tied to the netlink socket's priv->bindings list. If either network
device is unregistered and its memory freed while the socket remains open,
binding->dev and binding->vdev would become dangling pointers.

When the socket is later closed, netdev_nl_sock_priv_destroy() iterates over
the bindings and could dereference the freed memory, causing a use-after-fr=
ee.
Also, net_devmem_get_binding() might compare dst_dev to the dangling vdev
pointer.

> diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
> index 4d2c49371cdb4..b4d48f3672a5b 100644
> --- a/net/core/netdev-genl.c
> +++ b/net/core/netdev-genl.c
[ ... ]
> @@ -1171,22 +1205,41 @@ int netdev_nl_bind_tx_doit(struct sk_buff *skb, s=
truct genl_info *info)
>  		goto err_unlock_netdev;
>  	}
> =20
> +	bind_dev =3D netdev_find_netmem_tx_dev(netdev);
> +	if (!bind_dev) {
> +		err =3D -EOPNOTSUPP;
> +		NL_SET_ERR_MSG(info->extack,
> +			       "No DMA-capable device found for netmem TX");
> +		goto err_unlock_netdev;
> +	}
> +
> +	if (bind_dev !=3D netdev)
> +		netdev_lock(bind_dev);
> +

Will acquiring this second lock trigger a lockdep recursive locking warning?

The virtual device's lock is acquired implicitly via
netdev_get_by_index_lock() earlier. Here we explicitly call
netdev_lock(bind_dev) to lock the physical device.

Since all net_device locks (dev->lock) are initialized at the same call site
in alloc_netdev_mqs(), lockdep assigns them to the identical lock class.
Acquiring two instances of the same lock class sequentially without a nesti=
ng
annotation might violate locking rules.

> +	dma_dev =3D netdev_queue_get_dma_dev(bind_dev, 0, NETDEV_QUEUE_TYPE_TX);
> +
> +	binding =3D net_devmem_bind_dmabuf(bind_dev,
> +					 bind_dev !=3D netdev ? netdev : NULL,
> +					 dma_dev, DMA_TO_DEVICE, dmabuf_fd,
> +					 priv, info->extack);
>  	if (IS_ERR(binding)) {
>  		err =3D PTR_ERR(binding);
> -		goto err_unlock_netdev;
> +		goto err_unlock_bind_dev;
>  	}
> =20
>  	nla_put_u32(rsp, NETDEV_A_DMABUF_ID, binding->id);
>  	genlmsg_end(rsp, hdr);
> =20
> +	if (bind_dev !=3D netdev)
> +		netdev_unlock(bind_dev);
>  	netdev_unlock(netdev);
>  	mutex_unlock(&priv->lock);
> =20
>  	return genlmsg_reply(rsp, info);

Does this leak the netmem TX binding if genlmsg_reply() fails?

After successfully establishing the TX binding, the function unlocks the
devices and calls genlmsg_reply(), directly returning its error code. If
genlmsg_reply() fails (e.g., due to socket buffer exhaustion), the user
application receives an error and assumes the bind operation failed.

However, the binding remains fully active in the kernel and is attached to =
the
socket's priv->bindings list. Because the user never received the binding->=
id,
they cannot explicitly unbind it.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260507-tcp-dm-net=
kit-v3-0-52821445867c@meta.com?part=3D3
