Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.179
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794262518;
	b=PcoMv3FbRGAWJ6V6wEnulyczpki1gVBkdxoQVOryXAZ3AIWBzYSKNrwJkwj1stPDNwR6
	 ZTePSlFERt/fRC1LmD9kWjIeKT7nDWRceLfOltJiE0xvY92NlUZmBYEqQDhOPGoqpZpPA
	 n3fxqBAqd2AHTveBbaT2MjD3US2s1bQ2CKKLACBO7435CTZ8vB5BsZl0xKQ4ryQfOiBFc
	 oeqclx623Zo1cCpMbw7QyKYmypYtHn6OsDhZsoYESqQUuuwpWm2yesd9+P1hB2XsB2MlA
	 uF2Yan8pj5aKeQ8Edx9gtdYvQNkkEvJSxDndr0QPGCmuUZ2mKP1jR/M7CpQyR292nbg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794262518;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=zD/j+uY7QicxwzFZfKyAuCYeUIYmRXFTetf96EJ3FYI=;
	b=UImx7xmZZiJXDZCzJuTS5dIXo87ZzKhfTdsyU4xDAI/pYRBhqRN5N2/NCVWkEKcSyIuk
	 s+5wGClhA3R+uxptjlmzo+R7+5JklGPMGyVmYLRlmvssCnfT7pE9DlaWgL1eAYKBiEIqd
	 hvkG5VYLacOLh8q25o0En/1Kd4wszLgNGKQ9jcJT/vhK2Y0/IJNkeCznG6d3PqGq5X6wL
	 NiKhlEEysBDTJl2gTpDZqiB7mRG4qqac8qen4OmYdO2hPOPKvrcGpXdG7UGSVfiBB6aXA
	 gufNhONZ9tU38e14fEnyARzdTuJGpIp6ZoE8WnUW1FSPg8uv7qvNWVWe9NwHbOXK0Bg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=everpuredata.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=everpuredata.com header.i=@everpuredata.com header.a=rsa-sha256 header.s=google header.b=1O628pa1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.179
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E963606A32A
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 22:15:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E963606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=everpuredata.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=everpuredata.com header.i=@everpuredata.com header.a=rsa-sha256 header.s=google header.b=1O628pa1
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5ecda93627eso448126e0c.1
        for <linux-rdma@vger.kernel.org>; Mon, 09 Nov 2026 14:15:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794262515; cv=none;
        d=google.com; s=arc-20260327;
        b=mA7Eyy22kNaaOv/Pl/eg4sQlh3OP5hBTsdww6/GpS5iybzd5nsZ4Qm/M3TAtiOi/O3
         TJ79a7hgydXpWkGx0oZXoCDTP9SyaJQlhfVw7jFfnTG34xYZiNG4yvfqKKkAJTa1FDEL
         3ATe9/0XlpJNP4PnbAbgVCTuOF3t4j+HRCQ0zW4DT3UsOo9Exu/HKlj9tkvZ5MVPmjYq
         RbALVtxxy+3c5z5BVwzXYlkVdzO+aInNWQjyK8E9/9tn7rI7GZ3AYGjuAe0AWukYypIW
         9mwblerfCaS9aRVRYbvBJ8/Fh/LXHSl44dsDc3YD2dFaWq5mw3Zv/ZqbHKOFiTItG5lp
         FX4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zD/j+uY7QicxwzFZfKyAuCYeUIYmRXFTetf96EJ3FYI=;
        fh=Vs3ZsFmpZaMIMMZTMKoQWAbSUUNct8P/FlrTl8ksa4k=;
        b=ACffyTa8Lkxx3H4lolnd1oc1uED3nVH/8K/PrP6VKSSAIyflDo737HVg8RE1V7+w5Z
         ZXWJ7XwGi6611VzlAlirufEE3H7Xi/p8E0Y4l6k/9MoNhRsQb3duT0dnEqT7lOrnS5e8
         GBpEOhiGKn3nUkhFLPZthisAdR8xT6mD+p2ermyQ8PNq1CjQwhyx52vBHUpDoxPEVhAd
         J49HQ9lgsVzAzGKq8gV2j4a7YbJ7ku6tv6tXM618V8/GgefjDfE4vYOmdeXD2fO++5RH
         E0cjzTftD/U1Wv8OtrCqR9h+FMWEvczqOwLsjTpIkg4k8mlrRQy5e21qJAOSTaZBKpem
         TTrg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=everpuredata.com; s=google; t=1794262515; x=1794867315; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zD/j+uY7QicxwzFZfKyAuCYeUIYmRXFTetf96EJ3FYI=;
        b=1O628pa1h234nL/631ufgYuWxp+JPEA1EC21h44rBPn2YWbpKaDMo94x+duo+rj8Vg
         xKQ7s+sM2SiGWn21Tv02B8eJ4Sqvk2/z/Cuh/RP/tRSLag8m6U9wnpW1NFPIIU6Qo3BU
         lUWAADkoqTX43/pyJk7A7zz6yD4H38a4Zza3Js1KfjqJJp7EcjEBO/Fq6KaFcbuJal67
         Y0zajSHxFy53rhvalse3QIT/BIA5/7hGBzwM4++Qscheey465PEGErx3XGHD4smfC2wk
         StV+TvDSBavjsZIBqEHsJP19iDrgNl44f/8pnPZ3BYbickVbi0+NB3sZuT12XIWkDQJh
         /bIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794262515; x=1794867315;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zD/j+uY7QicxwzFZfKyAuCYeUIYmRXFTetf96EJ3FYI=;
        b=IocKRVNEwb1bR15l4kvwADgdxx7YQ8keElX1BJAgfZCqfY0nnHeXzEgh9b99YSWlK0
         qcbBAXl+LO9T49LXn2+Lu6iU/wRVZcUhBED9x/zejYQ4wXNIzAznpYoCFi6tBjloID2d
         NlSqFEvYKRhaaT6fRkS62R+s3X9O8sf6lWB4h1nkX3JdRJD/ottud5wJQ3wCtelC8SmP
         zQlpRMjF452EPCvrXuyKtKgxgwUbKsXiclusgXxRmCtNJ15/Ukok9d9gJtW/Vr8FDJY2
         U84ewJrTfMQruRc+CBxwZn2GrMt96a2cX1CS1QV+v+Za/JY538ZHcLrCttAF6HDG0LQ1
         nt4Q==
X-Forwarded-Encrypted: i=1; AL+hErFS1PHrKyzehuzUN9XEU3DVdpKl7eVpOAd/kc9IJLAqKpnQ6YnXhpUV2i24Ps63t2MNyVuk2vZWIEut@vger.kernel.org
X-Gm-Message-State: APuU4Z+lU6nOgY7OaataglHzN8cEaoZM1uyD2YS2320PJvVuAmF/oeh1
	AJqro32yRO3bNEhW05j2Gmjo8/rS61GT3RzgabmeYhKAjKZjS78I+PqiH6dmkTHbgqahPiIZv13
	K2kvrEvDiGWP4N38xXX7P0azXyj77p25z9Z2hSMfa9g==
X-Gm-Gg: AYBFou2hIB5hZ3mvJhu0oUCJ8LwCFi4Ox/hedZVZjiqJ/celwvhs/FIyqx0J3UJ4dqx
	TENP5uCuof0firq8KOff0tkbClBxyNj1VrQNOAwQk4y1PR3Oy3tM0JtAbY7iqb29VER4YcT2vCE
	cFPDbl6qM3Bt4CM88JXOF7/QUlvsQBsf8A+tMuzpAgwh9NGJlGrDzbD9fJ3v2AEpJBf1aqs2ikZ
	Mtrhj6lXIK34edKULa2RClgbWY2jhbCyilEP2MnOlexAhiAYOA/MePR/P8IxPCxc2MmXZ3D8nwT
	BqLvaWEozpn3tIL45LyKFK7LCZkJg7Wov9E9f2gUnYf00NImhtgHuBCmocljZZuVr2oX0Egucp3
	Av5FdgoSk5zTKnl//DSyTQD+MBechbOVEkADINA9efMC2PeSkVEWdXUT7gGwE/7virJdh4jWHk9
	unXH/4OLl3vBIFlw0wIM/w0+1dBqk/owJxqYekIwFCcx7EUGxNjKwdwm3K+n3PSFQrNW6OyETpt
	mD6Qz3cHPjYjbnXUpuaQzjy
X-Received: by 2002:a05:6122:c8f:b0:5ea:d14a:ef8f with SMTP id
 71dfb90a1353d-5ee0d0a8883mr233540e0c.4.1794262515029; Mon, 09 Nov 2026
 14:15:15 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261109114734.2087878-1-tariqt@nvidia.com> <20261109114734.2087878-8-tariqt@nvidia.com>
In-Reply-To: <20261109114734.2087878-8-tariqt@nvidia.com>
From: Rishikesh Jethwani <rjethwani@everpuredata.com>
Date: Mon, 9 Nov 2026 14:15:04 -0800
X-Gm-Features: AclHuK9j1OwlsHfQeJwA6s9PPtzDxE85HQ6rKN1IJUuBSgMWqtNT0r3Z_OQPFZM
Message-ID: <CAKaoeS2w15yqv-yd9t8KC3aZMJH1VXM=oepk4sR9h1pPjerKOw@mail.gmail.com>
Subject: Re: [RFC net-next 7/7] net/mlx5e: kTLS, Keep a TX connection on one
 SQ at a time
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org, 
	Paolo Abeni <pabeni@redhat.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Willem de Bruijn <willemb@google.com>, Alexander Graf <graf@amazon.com>, 
	Aviad Yehezkel <aviadye@mellanox.com>, Bobby Eshleman <bobbyeshleman@meta.com>, 
	Boris Pismenny <borisp@mellanox.com>, Boris Pismenny <borisp@nvidia.com>, 
	Carolina Jubran <cjubran@nvidia.com>, Costa Shulyupin <costa.shul@redhat.com>, 
	Dragos Tatulea <dtatulea@nvidia.com>, Eran Ben Elisha <eranbe@mellanox.com>, Gal Pressman <gal@nvidia.com>, 
	Ilya Lesokhin <ilyal@mellanox.com>, Jacob Keller <jacob.e.keller@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, Leon Romanovsky <leon@kernel.org>, linux-doc@vger.kernel.org, 
	open list <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, 
	Mark Bloch <mbloch@nvidia.com>, Martin Karsten <mkarsten@uwaterloo.ca>, 
	Randy Dunlap <rdunlap@infradead.org>, Richard Cochran <richardcochran@gmail.com>, 
	Saeed Mahameed <saeedm@mellanox.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Simon Horman <horms@kernel.org>, 
	Stanislav Fomichev <sdf@fomichev.me>, Stanislav Fomichev <sdf.kernel@gmail.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Tariq Toukan <tariqt@mellanox.com>, 
	Wang Zhan <wang.zhan@smartx.com>, William Tu <witu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 9, 2026 at 3:50=E2=80=AFAM Tariq Toukan <tariqt@nvidia.com> wro=
te:
>
> A kTLS TX connection must not post WQEs to another SQ while WQEs that it
> posted to its SQ may be pending: both SQs would update its TIS state
> with no ordering, corrupting the records on the wire. The stack and the
> driver keep the TX queue of such a connection stable
> (TLSDEV_F_STICKY_TXQ), but some paths bypass or defeat that: tc skbedit
> queue_mapping skips queue selection, sk_tx_queue_mapping is shared with
> the other devices on the route, and ooo_okay can be stale after an
> upper device's qdisc reordered the socket's skbs.
>
> Enforce it where the WQEs are posted. Each connection records the TX
> queue that it posts on. An skb on another TX queue moves the connection
> only if no other skb of its socket is in flight. An skb is freed only
> once the WQEs posted for it completed, or were destroyed with their SQ,
> so the connection then has no WQE pending on any SQ. An SQ that
> replaces another on the same TX queue was drained or destroyed first.
> Otherwise the skb is dropped before anything is posted, and counted in
> a new tx[i]_tls_drop_txq_move counter. TCP retransmits it.
>
> The move is made under the old TX queue's lock, taken with a trylock,
> under which the connection's skbs are posted there, so it cannot race
> with them. A connection that stays on its TX queue only compares the
> queue index.
>
> A move that the TX queue selection allows, when the socket has nothing
> else in flight, is made at selection. Otherwise the socket's next skbs,
> queued behind the first one on the new TX queue, would hold
> sk_wmem_alloc when it reaches the driver, and it would be dropped,
> although nothing of the connection is pending on the old SQ.
>
> Tested on ConnectX-6 Dx, with 128 channels and 32 kTLS TX offloaded
> connections streaming pattern data for 60 seconds to a software kTLS
> receiver that checks every byte, while an egress tc skbedit
> queue_mapping filter flips them between two TX queues every 20 ms.
> Without this patch, 23 of 55 connections failed decryption. With it,
> none did, and 7515 skbs were dropped over 2035 flips. Without the flips,
> no skb was dropped.
>
> Suggested-by: Rishikesh Jethwani <rjethwani@everpuredata.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  .../ethernet/mellanox/mlx5/counters.rst       |  7 ++
>  .../net/ethernet/mellanox/mlx5/core/en/selq.c | 16 +++--
>  .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 71 +++++++++++++++++++
>  .../mellanox/mlx5/core/en_accel/ktls_txrx.h   |  6 ++
>  .../ethernet/mellanox/mlx5/core/en_stats.c    |  4 ++
>  .../ethernet/mellanox/mlx5/core/en_stats.h    |  2 +
>  6 files changed, 100 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/ml=
x5/counters.rst b/Documentation/networking/device_drivers/ethernet/mellanox=
/mlx5/counters.rst
> index cc498895f92e..0a08ffddc834 100644
> --- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/coun=
ters.rst
> +++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/coun=
ters.rst
> @@ -711,6 +711,13 @@ the software port.
>         data.
>       - Acceleration
>
> +   * - `tx[i]_tls_drop_txq_move`
> +     - Number of TLS packets dropped on ring i because their connection =
still
> +       had packets in flight on another ring. Posting them on ring i wou=
ld
> +       break the ordering of the connection's TLS state updates in the
> +       device. TCP retransmits the dropped data.
> +     - Error
> +
>     * - `ptp_cq[i]_abort`
>       - Number of times a CQE has to be skipped in precision time protoco=
l due to
>         a skew between the port timestamp and CQE timestamp being greater=
 than
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/selq.c
> index dfaee2c3624e..0bac217bbfec 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
> @@ -9,6 +9,7 @@
>  #include "en.h"
>  #include "en/ptp.h"
>  #include "en/htb.h"
> +#include "en_accel/ktls_txrx.h"
>
>  struct mlx5e_selq_params {
>         unsigned int num_regular_queues;
> @@ -288,9 +289,6 @@ static int mlx5e_select_sticky_queue(struct net_devic=
e *dev,
>  {
>         int txq_ix;
>
> -       if (mlx5e_sk_txq_may_move(skb))
> -               return -1;
> -
>         txq_ix =3D sk_tx_queue_get(skb->sk);
>         if (txq_ix < 0 || txq_ix >=3D dev->real_num_tx_queues)
>                 return -1;
> @@ -309,6 +307,7 @@ u16 mlx5e_select_queue(struct net_device *dev, struct=
 sk_buff *skb,
>         struct mlx5e_priv *priv =3D netdev_priv(dev);
>         struct mlx5e_selq_params *selq;
>         struct sock *sk =3D skb->sk;
> +       bool may_move;
>         int txq_ix;
>
>         selq =3D rcu_dereference_bh(priv->selq.active);
> @@ -323,14 +322,19 @@ u16 mlx5e_select_queue(struct net_device *dev, stru=
ct sk_buff *skb,
>         if (likely(!mlx5e_sk_sticky_txq(sk)))
>                 return __mlx5e_select_queue(dev, skb, selq);
>
> -       txq_ix =3D mlx5e_select_sticky_queue(dev, skb, selq);
> -       if (txq_ix >=3D 0)
> -               return txq_ix;
> +       may_move =3D mlx5e_sk_txq_may_move(skb);
> +       if (!may_move) {
> +               txq_ix =3D mlx5e_select_sticky_queue(dev, skb, selq);
> +               if (txq_ix >=3D 0)
> +                       return txq_ix;
> +       }
>
>         txq_ix =3D __mlx5e_select_queue(dev, skb, selq);
>         /* Cache the final queue, as netdev_pick_tx() does with its own p=
ick. */
>         if (rcu_access_pointer(sk->sk_dst_cache))
>                 sk_tx_queue_set(sk, txq_ix);
> +       if (may_move)
> +               mlx5e_ktls_tx_select_txq(dev, skb, txq_ix);
>
>         return txq_ix;
>  }
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b=
/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> index 0bd4d961e704..9603ef4b3eb3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> @@ -92,12 +92,15 @@ enum {
>         MLX5E_KTLS_TX_RESYNC, /* WQEs lost, see mlx5e_ktls_tx_handle_lost=
() */
>  };
>
> +#define MLX5E_KTLS_TX_NO_TXQ (-1)
> +
>  struct mlx5e_ktls_offload_context_tx {
>         /* fast path */
>         u32 expected_seq;
>         u32 tisn;
>         bool ctx_post_pending;
>         unsigned long flags; /* MLX5E_KTLS_TX_* */
> +       int txq_ix; /* that it posts on, see mlx5e_ktls_tx_own_txq() */
>         /* control / resync */
>         struct list_head list_node; /* member of the pool */
>         union mlx5e_crypto_info crypto_info;
> @@ -505,6 +508,7 @@ int mlx5e_ktls_add_tx(struct net_device *netdev, stru=
ct sock *sk,
>
>         priv_tx->ctx_post_pending =3D true;
>         priv_tx->flags =3D 0;
> +       priv_tx->txq_ix =3D MLX5E_KTLS_TX_NO_TXQ;
>         atomic64_inc(&priv_tx->sw_stats->tx_tls_ctx);
>
>         return 0;
> @@ -846,6 +850,59 @@ void mlx5e_ktls_tx_handle_lost(struct mlx5e_txqsq *s=
q, struct sk_buff *skb)
>         rcu_read_unlock();
>  }
>
> +/* A connection must not post WQEs to another SQ while WQEs that it post=
ed to
> + * its SQ may be pending, see TLSDEV_F_STICKY_TXQ. Let it move to the TX=
 queue
> + * of @sq only if no other skb of its socket is in flight: an skb is fre=
ed only
> + * once the WQEs posted for it are done. The move is made under the lock=
 of the
> + * old TX queue, under which the connection posts there.
> + */
> +static bool mlx5e_ktls_tx_own_txq(struct net_device *netdev,
> +                                 struct mlx5e_ktls_offload_context_tx *p=
riv_tx,
> +                                 struct mlx5e_txqsq *sq, struct sk_buff =
*skb)
> +{
> +       int old =3D READ_ONCE(priv_tx->txq_ix);
> +       struct netdev_queue *old_txq;
> +       bool own;
> +
> +       if (old =3D=3D MLX5E_KTLS_TX_NO_TXQ)
> +               return cmpxchg(&priv_tx->txq_ix, old, sq->txq_ix) =3D=3D =
old;
> +
> +       old_txq =3D netdev_get_tx_queue(netdev, old);
> +       if (!__netif_tx_trylock(old_txq))
> +               return false;
> +
> +       own =3D READ_ONCE(priv_tx->txq_ix) =3D=3D old &&
> +             sk_wmem_alloc_get(skb->sk) <=3D skb->truesize;

This serializes the ownership check and update with posting on the old
queue. But selection bypasses it:

> +       if (own)
> +               WRITE_ONCE(priv_tx->txq_ix, sq->txq_ix);
> +       __netif_tx_unlock(old_txq);
> +
> +       return own;
> +}
> +
> +/* The TX queue selection lets the socket of @skb move to @txq_ix only w=
hile
> + * no other skb of the socket is in flight, see mlx5e_select_queue(), so=
 the
> + * connection has no WQE pending on any SQ: hand it the new TX queue now=
. Once
> + * @skb is queued there, the socket's next skbs queue up behind it and h=
old
> + * sk_wmem_alloc, and mlx5e_ktls_tx_own_txq() would refuse the move.
> + */
> +void mlx5e_ktls_tx_select_txq(struct net_device *netdev, struct sk_buff =
*skb,
> +                             u16 txq_ix)
> +{
> +       struct mlx5e_ktls_offload_context_tx *priv_tx;
> +       struct tls_context *tls_ctx;
> +
> +       if (!tls_is_skb_tx_device_offloaded(skb))
> +               return;
> +
> +       tls_ctx =3D tls_get_ctx(skb->sk);
> +       if (rcu_dereference_bh(tls_ctx->netdev) !=3D netdev)
> +               return;
> +
> +       priv_tx =3D mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
> +       WRITE_ONCE(priv_tx->txq_ix, txq_ix);
> +}
> +

This write relies on an earlier may_move check in mlx5e_select_queue(),
without locking the old queue or rechecking wmem.

With independent bond child qdiscs and skbedit selecting different upper
TX queues for A and B:

  1. A is dequeued asynchronously and reaches the lower mlx5e selector.
     Only A holds wmem, so may_move=3Dtrue.
  2. TCP emits B through another child qdisc. B sees both charges,
     reuses cached lower SQ0 and posts; its WQEs remain pending.
  3. A resumes, picks SQ1 and overwrites the owner. The xmit guard sees
     a matching index, so A posts on SQ1 while B's WQEs still reference
     the same TIS from SQ0.

A can be dequeued via a qdisc watchdog outside the socket lock. Lower
selection precedes the lower TX lock. Both packets use the socket's
offload slave. The same race exists when the owner is unclaimed and B
claims it first.

B must select and post between A's may_move check and owner write in
one mlx5e_select_queue() call. Hard IRQs, vCPU descheduling and
PREEMPT_RT preemption of BH-disabled sections can extend that short
window while B runs on another CPU.

Selection needs the same initial-claim CAS and locked handoff: recheck
the owner and current wmem under the old queue's lock, and leave
ownership unchanged on failure. Locking only the write leaves the wmem
check stale. Preserve zero self-charge for non-decrypted, possibly
partially orphaned skbs.

A failed transfer can fall back to the owner's queue, updating the
cache, if the index is in [0, real_num_tx_queues), still maps to a live
SQ and is not a PTP index. Keep the xmit ownership guard.

>  bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_tx=
qsq *sq,
>                               struct sk_buff *skb,
>                               struct mlx5e_accel_tx_tls_state *state)
> @@ -881,6 +938,10 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *net=
dev, struct mlx5e_txqsq *sq,
>
>         priv_tx =3D mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
>
> +       if (unlikely(READ_ONCE(priv_tx->txq_ix) !=3D sq->txq_ix) &&
> +           !mlx5e_ktls_tx_own_txq(netdev, priv_tx, sq, skb))
> +               goto err_move;
> +
>         /* WQEs naming the TIS, pending context params included, are
>          * posted only for an skb that uses it.
>          */
> @@ -929,6 +990,16 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *net=
dev, struct mlx5e_txqsq *sq,
>
>         return true;
>
> +err_move:
> +       /* Nothing was posted for the skb, TCP retransmits it. */
> +       stats->tls_drop_txq_move++;
> +       netdev_warn_once(netdev,
> +                        "kTLS TX connection moved to TX queue %d with pa=
ckets in flight, dropping\n",
> +                        sq->txq_ix);
> +       dev_kfree_skb_any(skb);
> +       mlx5e_tx_flush(sq, NULL);
> +       return false;
> +
>  err_lost:
>         /* Resync params may have moved the TIS state to the dropped skb.=
 */
>         set_bit(MLX5E_KTLS_TX_RESYNC, &priv_tx->flags);
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h=
 b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
> index a6b15dcd32b8..acfd1b4025aa 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
> @@ -30,6 +30,8 @@ void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e=
_txqsq *sq,
>                                            struct mlx5e_tx_wqe_info *wi,
>                                            u32 *dma_fifo_cc);
>  void mlx5e_ktls_tx_handle_lost(struct mlx5e_txqsq *sq, struct sk_buff *s=
kb);
> +void mlx5e_ktls_tx_select_txq(struct net_device *netdev, struct sk_buff =
*skb,
> +                             u16 txq_ix);
>
>  /* The WQEs posted for the skb may have not been executed. */
>  static inline void
> @@ -84,6 +86,10 @@ mlx5e_ktls_tx_handle_lost(struct mlx5e_txqsq *sq, stru=
ct sk_buff *skb) {}
>  static inline void
>  mlx5e_ktls_tx_try_handle_lost(struct mlx5e_txqsq *sq, struct sk_buff *sk=
b) {}
>
> +static inline void
> +mlx5e_ktls_tx_select_txq(struct net_device *netdev, struct sk_buff *skb,
> +                        u16 txq_ix) {}
> +
>  static inline bool
>  mlx5e_ktls_rx_handle_resync_list(struct mlx5e_icosq *sq, int budget)
>  {
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_stats.c
> index cd94bb44f6ab..d23790403714 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> @@ -132,6 +132,7 @@ static const struct counter_desc sw_stats_desc[] =3D =
{
>         { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_skip_no_sync_d=
ata) },
>         { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_drop_no_sync_d=
ata) },
>         { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_drop_bypass_re=
q) },
> +       { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_drop_txq_move)=
 },
>  #endif
>
>         { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_lro_packets) },
> @@ -441,6 +442,7 @@ static void mlx5e_stats_grp_sw_update_stats_sq(struct=
 mlx5e_sw_stats *s,
>         s->tx_tls_skip_no_sync_data +=3D sq_stats->tls_skip_no_sync_data;
>         s->tx_tls_drop_no_sync_data +=3D sq_stats->tls_drop_no_sync_data;
>         s->tx_tls_drop_bypass_req   +=3D sq_stats->tls_drop_bypass_req;
> +       s->tx_tls_drop_txq_move +=3D sq_stats->tls_drop_txq_move;
>  #endif
>         s->tx_cqes                  +=3D sq_stats->cqes;
>  }
> @@ -2303,6 +2305,7 @@ static const struct counter_desc sq_stats_desc[] =
=3D {
>         { MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_skip_no_sync_d=
ata) },
>         { MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_drop_no_sync_d=
ata) },
>         { MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_drop_bypass_re=
q) },
> +       { MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_drop_txq_move)=
 },
>  #endif
>         { MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, csum_none) },
>         { MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, stopped) },
> @@ -2456,6 +2459,7 @@ static const struct counter_desc qos_sq_stats_desc[=
] =3D {
>         { MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_skip_no_sy=
nc_data) },
>         { MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_drop_no_sy=
nc_data) },
>         { MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_drop_bypas=
s_req) },
> +       { MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_drop_txq_m=
ove) },
>  #endif
>         { MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, csum_none) },
>         { MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, stopped) },
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers=
/net/ethernet/mellanox/mlx5/core/en_stats.h
> index 09f155acb461..8f5fb0478f00 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
> @@ -237,6 +237,7 @@ struct mlx5e_sw_stats {
>         u64 tx_tls_skip_no_sync_data;
>         u64 tx_tls_drop_no_sync_data;
>         u64 tx_tls_drop_bypass_req;
> +       u64 tx_tls_drop_txq_move;
>
>         u64 rx_tls_decrypted_packets;
>         u64 rx_tls_decrypted_bytes;
> @@ -434,6 +435,7 @@ struct mlx5e_sq_stats {
>         u64 tls_skip_no_sync_data;
>         u64 tls_drop_no_sync_data;
>         u64 tls_drop_bypass_req;
> +       u64 tls_drop_txq_move;
>  #endif
>         /* less likely accessed in data path */
>         u64 csum_none;
> --
> 2.44.0
>
