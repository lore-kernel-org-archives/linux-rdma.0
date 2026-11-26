Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795706828;
	b=lfee4/YD3U/VFTB3tlVgyyWrqPLsHrYiqqEb2uSolpbFCEDTrWw3K+AKBDiFuUR80XJh
	 4Z90mq4CxnLn6pTzIrrRaFqKsJgtPYEJRyX7ZrlG+7V9EPHFfetiA0CQ/1usSaguBroNY
	 seyKHRTbOg6QppHWyJsqkioNMDuu1FUdOgAdWzTTRT6EvdbrrFcz9cx4zZBJBLML7B5BI
	 dakHnqBL9n75lEH/3dBTYlWqTfjyjGWm0tU0U8spp377v1b2ct0Rx1gjAB81fwGuslX/A
	 rEZSJ1QQ7B8UuZLd00KjHgNiPYxMa8+QX2NNNZg7eRGIh33vvVlcts7C7MfC/nWiRWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795706828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pQbqZcGbxJ+uscPuSMz/IRzY0GOV2w0fU4mvW1Tzpqk=;
	b=IKLXwfYwgetExAe9AEQ6Tc8v/gxC5h2w6oRIj5qvuaqQs0wEUGrXvgnQ95tdnybd22pW
	 8kS7tNf7Tnbba6gfsL8c15uQpvh26eUPAviKdJi/TYWUJ3GedE64o/eaz2jZjNwgb1yWX
	 usKlF2hs0mTquMnqKGJQnoEiben0iVebUF23i4bpM+OD8wOUfV6XDY9j8aeo4CTnzBuR7
	 vm34NhXIj1vEL4DROUdjYVl+43YVV3tAKShannROwWm8GIpI4Flw1Z4ZrxntFVOJuWbE5
	 NDs9EowhDZVS05dN/K0inQ2JoOqHegL0ALIcmRBzRLjQVQ9z9Nf3dBgwcb9aTdkOCUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i98MPiPp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE24606A326;
	Thu, 26 Nov 2026 15:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i98MPiPp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA9C1F000C0;
	Thu, 26 Nov 2026 15:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795706828;
	bh=pQbqZcGbxJ+uscPuSMz/IRzY0GOV2w0fU4mvW1Tzpqk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=i98MPiPpHdRyKLUYgLKAMej7QhKr9tu3lSzCbrCqmNcCmrUAQDfMibatJjZerutim
	 oett7b21vDlQ56v9pKMwpj92D+qZjZEybmAHikLaNAluJkqWeO3xqWWGWIfVAYxWHF
	 aqbUSEq5jMk47WVsUupd3b7L28mhah6QHl5FG6/y7oszmYeYAQrfIQ7Pei2p94nKOE
	 ybPrKVIpfZN2ZqwQk8F9c8roJ5lgpfOGdGR4fw0ZQiG5uQojAVQDAd5RuyU82vUzQH
	 zwEKLkqeQP/rczVL8hCbZZtybfgvxPPHPYtAlRWhodjw2Debmz8B9L7F9824TbxkA+
	 597gUVt/ctzRg==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: Todd Freed <toddfreed@meta.com>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Andrew Lunn
 <andrew+netdev@lunn.ch>, Boris Pismenny <borisp@nvidia.com>, Cosmin Ratiu
 <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Donald Hunter
 <donald.hunter@gmail.com>, Dragos Tatulea <dtatulea@nvidia.com>, Eric
 Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Jamal
 Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>, Leon
 Romanovsky <leon@kernel.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, Paolo Abeni
 <pabeni@redhat.com>, Pedro Tammela <pctammela@mojatatu.com>, Saeed
 Mahameed <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq
 Toukan <tariqt@nvidia.com>, Wei Wang <weiwan@google.com>, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 bpf@vger.kernel.org, =?utf-8?Q?Asbj=C3=B8rn?= Sloth =?utf-8?Q?T=C3=B8nnes?=
 =?utf-8?Q?en?= <ast@fiberby.net>, Qingfang
 Deng <qingfang.deng@linux.dev>, Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgense?=
 =?utf-8?Q?n?= <toke@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 Matthieu
 Baerts <matttbe@kernel.org>, David Ahern <dsahern@kernel.org>, Jonas
 =?utf-8?Q?K=C3=B6ppeler?= <j.koeppeler@tu-berlin.de>, Hangbin Liu
 <hangbin.liu@linux.dev>
Subject: Re: [PATCH net-next v3 05/12] net: add METADATA_PSP dst to carry a
 psp association on an skb
In-Reply-To: <20261124221758.3230929-6-toddfreed@meta.com>
References: <20261124221758.3230929-1-toddfreed@meta.com>
 <20261124221758.3230929-6-toddfreed@meta.com>
Date: Thu, 26 Nov 2026 16:27:04 +0100
Message-ID: <875wxjipfb.fsf@all.your.base.are.belong.to.us>
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

Todd Freed <toddfreed@meta.com> writes:

> Add a metadata_dst type holding a reference to a PSP association, so
> that an association can be attached to an skb that has no socket, e.g.
> by a tc action.
>
> Change psp_skb_get_assoc_rcu() to check for METADATA_PSP, then fall back
> to the socket, so that existing driver Tx paths (mlx5, netdevsim)
> encrypt such packets without any changes.
>
> Once an skb has been marked for PSP xmit, it must be transmitted on the
> correct device, otherwise it may go onto the wire in clear text. For
> packets of a PSP socket, sk_validate_xmit_skb() handles this.
>
> For socket-less PSP packets, the PSP metadata dst carries this
> information, but __dev_queue_xmit() normally releases the dst before
> queueing. Add a new check for a PSP metadata dst at that point. If it's
> the wrong device, drop the packet; if it's the right device, keep the
> dst so that the driver can use it.
>
> The right device is the PSP device's main netdev: devices associated
> with it (dev-assoc, e.g. veth or netkit) have its psp_dev too, but
> forward the packet rather than encrypt it, and drop the dst on the way.
> Prevent xmit on those.
>
> Also check that the packet will still fit the device's MTU once the
> device adds the PSP encapsulation (UDP + PSP + ICV, 40 bytes), and drop
> it with SKB_DROP_REASON_PKT_TOO_BIG otherwise. Note that no ICMP error
> is sent in this case. PSP sockets do leave room for it
> (psp_sk_overhead()).
>
> Check a packet with a METADATA_PSP dst again when it is validated at
> dequeue, in sk_validate_xmit_skb(). If the PSP device was unregistered
> since enqueue, the packet is dropped.
>
> A packet of a socket with its own encryption offload (PSP or kTLS) must
> not carry a METADATA_PSP dst: sk_validate_xmit_skb() would apply the
> socket's validator instead of checking the association. Whatever attaches
> the dst refuses such packets, but the socket can gain an offload while
> the packet is queued, so sk_validate_xmit_skb() drops a packet which has
> both. It reads sk->sk_validate_xmit_skb with READ_ONCE(), which pairs
> with the WRITE_ONCE() in psp_sock_set_tx_key().
>
> Put the new checks behind a static key, psp_md_needed, so that
> configurations which aren't using socket-less PSP don't pay to evaluate
> them. It's enabled while any METADATA_PSP dst exists.
>
> Signed-off-by: Todd Freed <toddfreed@meta.com>
> ---
>  include/net/dst_metadata.h  |  19 +++++++
>  include/net/psp/functions.h | 105 +++++++++++++++++++++++++++++++++++-
>  net/core/dev.c              |  50 ++++++++++++++---
>  net/core/dst.c              |   5 ++
>  net/psp/psp_main.c          |  31 +++++++++++
>  5 files changed, 201 insertions(+), 9 deletions(-)
>
> diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
> index 02fffbb85099..bc6ac51dde9c 100644
> --- a/include/net/dst_metadata.h
> +++ b/include/net/dst_metadata.h
> @@ -13,6 +13,7 @@ enum metadata_type {
>  	METADATA_HW_PORT_MUX,
>  	METADATA_MACSEC,
>  	METADATA_XFRM,
> +	METADATA_PSP,
>  };
>=20=20
>  struct hw_port_info {
> @@ -30,6 +31,14 @@ struct xfrm_md_info {
>  	struct dst_entry *dst_orig;
>  };
>=20=20
> +/**
> + * struct psp_md_info - PSP association to encrypt a packet with
> + * @pas: association, the metadata_dst holds a reference on it
> + */
> +struct psp_md_info {
> +	struct psp_assoc *pas;
> +};
> +
>  struct metadata_dst {
>  	struct dst_entry		dst;
>  	enum metadata_type		type;
> @@ -38,6 +47,7 @@ struct metadata_dst {
>  		struct hw_port_info	port_info;
>  		struct macsec_info	macsec_info;
>  		struct xfrm_md_info	xfrm_info;
> +		struct psp_md_info	psp_info;
>  	} u;
>  };
>=20=20
> @@ -51,6 +61,13 @@ static inline struct metadata_dst *skb_metadata_dst(co=
nst struct sk_buff *skb)
>  	return NULL;
>  }
>=20=20
> +static inline bool skb_psp_md(const struct sk_buff *skb)
> +{
> +	struct metadata_dst *md_dst =3D skb_metadata_dst(skb);
> +
> +	return md_dst && md_dst->type =3D=3D METADATA_PSP;
> +}
> +
>  static inline struct ip_tunnel_info *
>  skb_tunnel_info(const struct sk_buff *skb)
>  {
> @@ -127,6 +144,8 @@ static inline int skb_metadata_dst_cmp(const struct s=
k_buff *skb_a,
>  	case METADATA_XFRM:
>  		return memcmp(&a->u.xfrm_info, &b->u.xfrm_info,
>  			      sizeof(a->u.xfrm_info));
> +	case METADATA_PSP:
> +		return a->u.psp_info.pas !=3D b->u.psp_info.pas;
>  	default:
>  		return 1;
>  	}
> diff --git a/include/net/psp/functions.h b/include/net/psp/functions.h
> index 2380af3b9c86..8704e41a7fda 100644
> --- a/include/net/psp/functions.h
> +++ b/include/net/psp/functions.h
> @@ -5,7 +5,10 @@
>=20=20
>  #include <linux/skbuff.h>
>  #include <linux/rcupdate.h>
> +#include <linux/jump_label_ratelimit.h>
>  #include <linux/udp.h>
> +#include <net/dst_metadata.h>
> +#include <net/gso.h>
>  #include <net/sock.h>
>  #include <net/tcp.h>
>  #include <net/psp/types.h>
> @@ -22,10 +25,25 @@ bool psp_dev_encapsulate(struct net *net, struct sk_b=
uff *skb, __be32 spi,
>  int psp_dev_rcv(struct sk_buff *skb, u16 dev_id, u8 generation, bool str=
ip_icv);
>=20=20
>  /* Kernel-facing API */
> +#if IS_ENABLED(CONFIG_INET_PSP)
>  void psp_assoc_put(struct psp_assoc *pas);
>  struct psp_assoc *psp_assoc_get_by_id(struct net *net, u32 id);
> +struct metadata_dst *psp_md_alloc(struct psp_assoc *pas);
> +
> +extern struct static_key_false_deferred psp_md_needed;
> +
> +/* A METADATA_PSP dst may exist: the transmit path has to check for it */
> +static inline bool psp_md_needed_on(void)
> +{
> +	return static_branch_unlikely(&psp_md_needed.key);
> +}
> +
> +/* Pairs with psp_md_alloc(), from metadata_dst_free() */
> +static inline void psp_md_put(void)
> +{
> +	static_branch_slow_dec_deferred(&psp_md_needed);
> +}
>=20=20
> -#if IS_ENABLED(CONFIG_INET_PSP)
>  unsigned int psp_key_size(u32 version);
>  void psp_sk_assoc_free(struct sock *sk);
>  void psp_twsk_init(struct inet_timewait_sock *tw, const struct sock *sk);
> @@ -137,14 +155,84 @@ static inline struct psp_assoc *psp_sk_get_assoc_rc=
u(const struct sock *sk)
>  	return pas;
>  }
>=20=20
> +static inline struct psp_assoc *psp_skb_md_assoc(const struct sk_buff *s=
kb)
> +{
> +	struct metadata_dst *md_dst;
> +
> +	if (!psp_md_needed_on())
> +		return NULL;
> +
> +	md_dst =3D skb_metadata_dst(skb);
> +	if (md_dst && md_dst->type =3D=3D METADATA_PSP)
> +		return md_dst->u.psp_info.pas;
> +
> +	return NULL;
> +}
> +
>  static inline struct psp_assoc *psp_skb_get_assoc_rcu(struct sk_buff *sk=
b)
>  {
> +	struct psp_assoc *pas;
> +
> +	pas =3D psp_skb_md_assoc(skb);
> +	if (pas)
> +		return pas;
> +
>  	if (!skb->decrypted || !skb->sk)
>  		return NULL;
>=20=20
>  	return psp_sk_get_assoc_rcu(skb->sk);
>  }
>=20=20
> +/**
> + * psp_xmit_md() - validate psp association attached as a metadata dst
> + * @skb: packet about to be queued for transmission, or validated before
> + *	 the device transmits it
> + * @dev: device it is queued on, or transmitted by
> + *
> + * If the skb has a psp association attached as metadata dst, this indic=
ates
> + * intent to transmit encrypted, which will only happen when transmit on
> + * the main netdev of its psp device.
> + *
> + * Also check that the packet will still fit @dev's MTU once the device =
has
> + * added the PSP encapsulation. Sockets leave room for it (psp_sk_overhe=
ad()),
> + * whoever attached the association may not have.
> + *
> + * returns:
> + *   0 if @skb carries no psp association
> + *   1 if it does and the dst must be kept for the driver
> + *  -EINVAL if the packet must be dropped, @dev isn't the main netdev of
> + *	    its psp device
> + *  -EMSGSIZE if the packet must be dropped, too big once encapsulated
> + */
> +static inline int psp_xmit_md(const struct sk_buff *skb,
> +			      const struct net_device *dev)
> +{
> +	unsigned int psp_encap =3D sizeof(struct udphdr) + PSP_HDR_SIZE +
> +				 PSP_TRL_SIZE;
> +	struct psp_assoc *pas =3D psp_skb_md_assoc(skb);
> +	unsigned int mtu;
> +
> +	if (likely(!pas))
> +		return 0;
> +
> +	if (rcu_access_pointer(dev->psp_dev) !=3D pas->psd ||
> +	    dev !=3D pas->psd->main_netdev)
> +		return -EINVAL;
> +
> +	mtu =3D READ_ONCE(dev->mtu);
> +	if (mtu <=3D psp_encap)
> +		return -EMSGSIZE;
> +	mtu -=3D psp_encap;
> +	if (skb_is_gso(skb)) {
> +		if (!skb_gso_validate_network_len(skb, mtu))
> +			return -EMSGSIZE;
> +	} else if (skb->len - skb_network_offset(skb) > mtu) {
> +		return -EMSGSIZE;
> +	}
> +
> +	return 1;
> +}
> +
>  static inline unsigned int psp_sk_overhead(const struct sock *sk)
>  {
>  	int psp_encap =3D sizeof(struct udphdr) + PSP_HDR_SIZE + PSP_TRL_SIZE;
> @@ -153,6 +241,21 @@ static inline unsigned int psp_sk_overhead(const str=
uct sock *sk)
>  	return pas && pas->tx.spi ? psp_encap : 0;
>  }
>  #else
> +static inline void psp_assoc_put(struct psp_assoc *pas) { }
> +static inline bool psp_md_needed_on(void) { return false; }
> +static inline void psp_md_put(void) { }
> +
> +static inline struct psp_assoc *psp_assoc_get_by_id(struct net *net, u32=
 id)
> +{
> +	return NULL;
> +}
> +
> +static inline int psp_xmit_md(const struct sk_buff *skb,
> +			      const struct net_device *dev)
> +{
> +	return 0;
> +}
> +
>  static inline void psp_sk_assoc_free(struct sock *sk) { }
>  static inline void
>  psp_twsk_init(struct inet_timewait_sock *tw, const struct sock *sk) { }
> diff --git a/net/core/dev.c b/net/core/dev.c
> index a44b314f387b..2b1a2736ab3f 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -111,6 +111,7 @@
>  #include <net/pkt_cls.h>
>  #include <net/checksum.h>
>  #include <net/xfrm.h>
> +#include <net/psp/functions.h>
>  #include <net/tcx.h>
>  #include <linux/highmem.h>
>  #include <linux/init.h>
> @@ -4141,9 +4142,14 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
>  }
>  EXPORT_SYMBOL(skb_csum_hwoffload_help);
>=20=20
> -/* Checks if this SKB belongs to an HW offloaded socket
> - * and whether any SW fallbacks are required based on dev.
> - * Check decrypted mark in case skb_orphan() cleared socket.
> +/* Validate an skb for device encryption offload. If the skb belongs to =
an HW
> + * offloaded socket, apply the socket's callback, unless the skb also ca=
rries a
> + * PSP association: then it is dropped. Otherwise, an skb which carries =
a PSP
> + * association is checked again against dev: the PSP device may have been
> + * unregistered while the skb was queued. An skb marked decrypted (to be
> + * encrypted by the device) without either is dropped rather than sent i=
n clear
> + * text. The mark survives losing the socket to skb_orphan(), or the PSP
> + * metadata dst to routing.
>   */
>  static struct sk_buff *sk_validate_xmit_skb(struct sk_buff *skb,
>  					    struct net_device *dev)
> @@ -4156,13 +4162,32 @@ static struct sk_buff *sk_validate_xmit_skb(struc=
t sk_buff *skb,
>  	sk_validate =3D NULL;
>  	if (sk) {
>  		if (sk_fullsock(sk))
> -			sk_validate =3D sk->sk_validate_xmit_skb;
> +			sk_validate =3D READ_ONCE(sk->sk_validate_xmit_skb);
>  		else if (sk_is_inet(sk) && sk->sk_state =3D=3D TCP_TIME_WAIT)
>  			sk_validate =3D inet_twsk(sk)->tw_validate_xmit_skb;
>  	}
>=20=20
>  	if (sk_validate) {
> -		skb =3D sk_validate(sk, dev, skb);
> +		/* the socket's validator would apply instead of checking the
> +		 * association. A METADATA_PSP dst isn't given to the packets
> +		 * of a socket with its own offload, but the socket can gain
> +		 * one while such a packet is queued.
> +		 */
> +		if (psp_md_needed_on() && skb_psp_md(skb)) {
> +			kfree_skb_reason(skb, SKB_DROP_REASON_PSP_OUTPUT);
> +			skb =3D NULL;
> +		} else {
> +			skb =3D sk_validate(sk, dev, skb);
> +		}
> +	} else if (psp_md_needed_on() && skb_psp_md(skb)) {
> +		int psp =3D psp_xmit_md(skb, dev);
> +
> +		if (psp <=3D 0) {
> +			kfree_skb_reason(skb, psp =3D=3D -EMSGSIZE ?
> +					 SKB_DROP_REASON_PKT_TOO_BIG :
> +					 SKB_DROP_REASON_PSP_OUTPUT);
> +			skb =3D NULL;
> +		}
>  	} else if (unlikely(skb_is_decrypted(skb))) {
>  		pr_warn_ratelimited("unencrypted skb with no associated socket - dropp=
ing\n");
>  		kfree_skb(skb);
> @@ -5002,7 +5027,7 @@ int __dev_queue_xmit(struct sk_buff *skb, struct ne=
t_device *sb_dev)
>  	struct net_device *dev =3D skb->dev;
>  	struct netdev_queue *txq =3D NULL;
>  	enum skb_drop_reason reason;
> -	int cpu, rc =3D -ENOMEM;
> +	int cpu, psp, rc =3D -ENOMEM;
>  	bool again =3D false;
>  	struct Qdisc *q;
>=20=20
> @@ -5051,10 +5076,19 @@ int __dev_queue_xmit(struct sk_buff *skb, struct =
net_device *sb_dev)
>  			txq =3D netdev_tx_queue_mapping(dev, skb);
>  	}
>  #endif
> +	psp =3D psp_xmit_md(skb, dev);
> +	if (unlikely(psp < 0)) {
> +		reason =3D psp =3D=3D -EMSGSIZE ? SKB_DROP_REASON_PKT_TOO_BIG :
> +					    SKB_DROP_REASON_PSP_OUTPUT;
> +		rc =3D psp;
> +		goto drop;
> +	}
> +

Performance thoughts. These two functions (__dev_queue_xmit and
sk_validate_xmit_skb) are in the hotpath. The static key is globally for
all netdevs. My worry is that packets that doesn't care about PSP has to
touch more cachelines during ptr chasing. Cheaper, less instrusive
(flag?) per-skb check possible? (Or proof that it doesn't matter! ;-))


Bj=C3=B6rn
