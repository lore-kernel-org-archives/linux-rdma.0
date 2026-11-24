Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.216.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795530860;
	b=lKzb/HZpHU6U1pjEAMEpxC40Vn8V93kOk9aXwZ1xcUI1fc8IxC4KLAi1SisTd9tcCIpD
	 q4MXJ00dY+p14xXG2r7+XY+91sQJq+TjfTp4TL7jclGC4aD+0KAv+SLhnJ/XzK/YpzNsz
	 MdlK9qQrgjgRp7k9LkOUKF+Nvf2zx8MQ6jcAs0+f9xX480dycRo8loK/XE8r7UE8fxTPQ
	 wHIcxmtWFKAcdLIXQsp+YnmQchNXZARxWj9BveiA97MzjmUmBv2leFwF5jHjhJKbBHQbA
	 E98CJfu7htccnINwvyewxI3U/pMGYPeKPjHA7O0ec2fYh/9TuwZ5MfDfov4usBY5viA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795530860;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=hS5QgEEx1tklgksYhfvpWC9lTYvUv8y2W5i5K54YV1g=;
	b=PZT6JNp6VhX4HOYZ0VtKr8ZVPZebqrxii1ixzwEu5drQYfarKozdxzBsujbOD0QFj5GJ
	 DPYDuDlVVbpmvhyuEWMpH0UOBqiaHHGaypmxQS8mtot66a1KMDg2QIRr9UHe2kG+3qAxO
	 QBVjsQgcQen21JpKtLYTL7gPRvjq0Vqxv0O/W5HviFeauCYNJ0XlSQ6EDj1lozsrTToiC
	 wDxfkfgUnA5jll5Ug72LH2J3ZxrEq+pHVULcDsRz3Yr5Z5oSTxx8+ZbaF8ShynMhNzu/d
	 385o89Ac9F5dnc85iwuo8OZoIfsFSOuv0h9SrMrwM7fzhkip9zP9DUFhWse7pdGM+Ew==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qg5IK6iC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.216.45
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B276606A329
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 14:34:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B276606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qg5IK6iC
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3ae6b4c669fso4574670a91.0
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 06:34:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795530859; cv=none;
        d=google.com; s=arc-20260327;
        b=OiqcejvlQzy76wNP9XZTmip8vU0566HA4uDTyD6yMvNY8bWISYEVXc+z9u/4YiCfMJ
         QUkWcOU82FFxYvyjPL2Dm4gmbo2BrSczI8QWUwg0GfC+HuudOxH6jHh3ekMioafa0CZA
         Wyi2FCWdOUswr+cXFKbciMZzyw2R1XYy4ms2CnBn+ioSLnxg1+ji4mNV8hHMFfVwW5A4
         gM3/qy25giopD7yLdprqdN8cpAj3sk4LsWg7BVbHHbQseiBXG7NIZFFHBu0wLIR2Ai+i
         nNKOq9DBsSSQ4+g6nFXDmTwL/++kdvv8JYGXCv1EipL8B7qSA0gKPcO2qnjeFlIe/mQ8
         uE9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hS5QgEEx1tklgksYhfvpWC9lTYvUv8y2W5i5K54YV1g=;
        fh=E8oQn8KWVzNgW+kCsUQSNu8hmMsRZ6uSe7OkdAfzubU=;
        b=CLcBe6pKTSU4AzIZDs86m4mOHk94ztKcnTnJ/QNI7sFTpCFgJcb5I33Y4vf51SfApD
         2sGyrHWSHCmIDdgReSTxqW8O4mDW7+P5VlNWTF8E3pDCDhp97TbelxgAp3+ldoOAykLT
         kbjrKR6akxdaDiIJZPEmguqk0XgYwjs9VK3Dh9dhgO8OIbcc1tAkaj3ZqxzjneDabAm0
         U5OvYU4OoPuhrWecCNNNMNH9htLmKUwWK09libeFdJBwjVZFixoj6EmCL5+8GJnI//17
         g8RXXC8PskkATqYzT4mPQamdsoKiZ24ezfelLIh61lg39fAoJV4CT8A4p4rIfeiVruCk
         UffA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795530859; x=1796135659; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hS5QgEEx1tklgksYhfvpWC9lTYvUv8y2W5i5K54YV1g=;
        b=qg5IK6iCkghKN/Y/DZjLQKj/E2qBnS5qQ0u12N4SM9CIqa9uoN0AYTK4HfRSDMgV6X
         6ihjhE+9mJs3CdYRPq2L80EMHn+kmLijO3iG30QIKESMMLEYT/CysKuXphG05M1oCk+X
         /nR9+jqjixnZMk3qxsfWgqn35OA/BF3A+NbkpieP/YqaiRb5Qqwy8Bd1voPP8hCpELOQ
         31U0vsyJTM4F8EULf//yBEQlI+Ajx5s1NA/5l+w9PK6XV76632BMdrALpyb/vs6yyIWi
         RXgmyr5GeOLIQ1AbzS8ljT/ecVul/0EnN29aL4SODC0wq+0kFj1mlj9ChgIaiEPCPOsA
         KdtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795530859; x=1796135659;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hS5QgEEx1tklgksYhfvpWC9lTYvUv8y2W5i5K54YV1g=;
        b=iKmEoVbryoGrbG6EWPhTOz2UN7+GXMI4RXNvtOs3WkeL26U/aAIQ5PMz1i6L/JkgNO
         NGfWTgVTmMN/lCkWB/CTKqBC05x2tvA3kHZBZ9ZXT+geXHFKS9Kj8etzT68Ti6L40WmR
         skIg7vuOQ2uCkS8q9mPBIoD960U+elr7y9IjFGh8UtnQ0fWBXTuGFuS/QODZWCVm0ciY
         HDXDwItARKIBNiGExjQSurY+CLRAaq3u0y7S1cD5EbmBC5qEj/eTBYqfgKZN/WTBFEtG
         8tAxGaXIjbCHKug/t7vbfGIpKdh4AdUXOxpC+ABFQTjhFphvwHK9Ey5xt6yeCPklbD/y
         d/sA==
X-Forwarded-Encrypted: i=1; AL+hErHTZYJyhgjJVWIX1q7at+U2tzydfTCjS+3UTbXBV1037zSjYGP9/VZffXcs9kjxH0+3Vv3WKu4CYeqk@vger.kernel.org
X-Gm-Message-State: APuU4Z89ZOtw2xOD3dsu0ggGaJyuPRKmhLSLcBhF3UkxrycgPQltBaex
	YlW2fqnXGfOad5PLEMHo30nE91kuqat2ipFM59wwo1rnW3WClycNd00hayhic2qvSwdU0dHOQO/
	6nfPJNoC5E50Fir/llfK+t1PP/06CAoQ=
X-Gm-Gg: AZFdTZep7260jkDyBe65naUEspjRnpWYXJB/Zl3+JjjW9eqNQw1l2VH82bNpHtCyIeu
	iqRHaiJkKfq4uKSLseEVbPuC7MCa+/YJ2aXxahECsvlSBq9C9G1W/R7StxYzRYdiQ8RuH+mUksi
	rz8wW46fjA0bFyYOGGNvABdNeoBQfGH6gL2fgbiUnZ0X8tG9A5xk6HhQ4YS5Ah+SqqLoYI6tn38
	EjivUQUM49qyWApYDtY0uKm8MkcggQjtFG2ZMslxo028yqtWtNVwf/O2/a5opjGGXUAgHgJWvH3
	4wV2rJtDiN88hOyY/SNVEzk8xcTCIluOPu3U0LrVjvR+mewgCWmyQCImpj3WIbKimgWaE8Q6SW9
	p7KVkID92V0vIO29HNrgA9IzjiJcpviBBYvCHHdU=
X-Received: by 2002:a17:90b:3b8f:b0:3ac:b3c7:de04 with SMTP id
 98e67ed59e1d1-3b41c95f0e1mr9916840a91.34.1795530858458; Tue, 24 Nov 2026
 06:34:18 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261124112707.118678-1-bjorn@kernel.org> <20261124125654.183091-6-bjorn@kernel.org>
In-Reply-To: <20261124125654.183091-6-bjorn@kernel.org>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Tue, 24 Nov 2026 15:34:05 +0100
X-Gm-Features: Aa3M54qKl1OMgoup1B2gY7tanBh1jIDvMvtePBuNFJLWwM_Jb3N7Yv62zEuX8ew
Message-ID: <CAJ8uoz3f2MPpDevbMY3q_Nx=SQ2Om1ojAxBTsYhNw1V9_NXQMA@mail.gmail.com>
Subject: Re: [PATCH net-next 06/15] xsk: Lend UMEM chunks to the page pools of
 a queue
To: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>, 
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Alexander Duyck <alexanderduyck@fb.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, bpf@vger.kernel.org, netdev@vger.kernel.org, 
	Stuart Clark <stuclar@meta.com>, Stanislav Fomichev <sdf@fomichev.me>, Simon Horman <horms@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Mina Almasry <almasrymina@google.com>, 
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	Randy Dunlap <rdunlap@infradead.org>, kernel-team@meta.com, 
	Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>, Bobby Eshleman <bobbyeshleman@meta.com>, 
	Mohsin Bashir <mohsin.bashr@gmail.com>, Kees Cook <kees@kernel.org>, 
	Breno Leitao <leitao@debian.org>, Maxime Chevallier <maxime.chevallier@bootlin.com>, 
	Tao Cui <cuitao@kylinos.cn>, Vadim Fedorenko <vadim.fedorenko@linux.dev>, 
	"Mike Marciniszyn (Meta)" <mike.marciniszyn@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Jiayuan Chen <jiayuan.chen@linux.dev>, Martin Karsten <mkarsten@uwaterloo.ca>, 
	Nikolay Aleksandrov <razor@blackwall.org>, David Wei <dw@davidwei.uk>, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-rdma@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Nov 2026 at 13:59, Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org> wrot=
e:
>
> Currently, AF_XDP zero copy makes the device fill one UMEM chunk per
> buffer, at the UMEM headroom. Drivers bend their RX geometry to that
> and carry a second RX path for it, and packets that the stack would
> build from several buffers, or pack into one page, cannot be received
> without a copy.
>
> Let the device lay out buffers in UMEM chunks as it does in pages, for
> a UMEM registered with the new flag XDP_UMEM_DRV_LAYOUT. First, let
> the chunks of such a UMEM back the RX page pools of the bound queue,
> through a sink memory provider that the socket installs with the queue
> management API, so drivers need no AF_XDP code.
>
> The chunk is the unit of ownership. A FILL entry lends a chunk to the
> kernel until the kernel gives it back, see the next patch. A chunk
> that is lent twice, or lies outside the UMEM, counts as an invalid
> FILL entry, so userspace cannot make the device use a chunk twice. A
> refill takes at most a page pool cache worth of FILL entries, bounding
> the NAPI work. Chunks that a page pool released when it went away, as
> at a queue restart, stay on a list that refills take from only when
> FILL gives too few, so every chunk taken from it stays in circulation.
> The pool allocates no xdp_buff_xsk per chunk, which saves 128 bytes
> per 4 KiB chunk. The kernel mapping of the UMEM is the XDP view of its
> net_iovs, so XDP reads the chunks in place.
>
> The provider refuses page pools with pages larger than a chunk, with
> another DMA device, or so large that the device could hold every
> chunk. Binding needs a native XDP program, which cannot be detached
> while the provider is installed, as drivers would otherwise build skbs
> around the buffers. Unbind restarts the queue without the provider, or
> closes the device if that fails, as the old queue may go on receiving
> into the UMEM. Device unregister may uninstall the provider before the
> socket unbinds, and unbind then only frees what is left.
>
> Bind sets the RX need_wakeup flag before the queue starts, as the
> queue may need FILL entries to start. After that only the queue NAPI
> changes the flag, asking for a kick only while FILL is empty.
> Process-context refills, as when bnxt fills a new queue, leave it
> alone.
>
> DMA syncs work as with page pools. The UMEM is mapped once, at bind,
> the provider syncs a chunk for the device when it lends it, page pools
> sync the chunks they recycle, and drivers sync each buffer for the CPU
> before XDP runs.
>
> None of this is reachable until UMEM registration accepts
> XDP_UMEM_DRV_LAYOUT, two patches later.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
> ---
>  include/linux/netdevice.h         |   2 +
>  include/net/xsk_buff_pool.h       |   3 +
>  include/uapi/linux/if_xdp.h       |   7 +
>  net/core/dev.c                    |  30 +++
>  net/xdp/Kconfig                   |   1 +
>  net/xdp/Makefile                  |   2 +-
>  net/xdp/xsk_buff_pool.c           |  30 ++-
>  net/xdp/xsk_sink.c                | 416 ++++++++++++++++++++++++++++++
>  net/xdp/xsk_sink.h                |  14 +
>  tools/include/uapi/linux/if_xdp.h |   7 +
>  10 files changed, 505 insertions(+), 7 deletions(-)
>  create mode 100644 net/xdp/xsk_sink.c
>  create mode 100644 net/xdp/xsk_sink.h
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 5fd2bec1178a..5a7247873ce8 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -4459,6 +4459,8 @@ u32 dev_xdp_prog_id(struct net_device *dev, enum bp=
f_xdp_mode mode);
>
>  u32 dev_get_min_mp_channel_count(const struct net_device *dev);
>  bool dev_mp_blocks_xdp(const struct net_device *dev);
> +bool dev_has_xdp_only_mp(const struct net_device *dev);
> +bool dev_xdp_drv_prog_held(struct net_device *dev);
>
>  int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
>  int dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> index 02e89350faf9..376408994a33 100644
> --- a/include/net/xsk_buff_pool.h
> +++ b/include/net/xsk_buff_pool.h
> @@ -11,6 +11,7 @@
>  #include <net/xdp.h>
>
>  struct xsk_buff_pool;
> +struct xsk_sink;
>  struct xdp_rxq_info;
>  struct xsk_cb_desc;
>  struct xsk_queue;
> @@ -54,6 +55,8 @@ struct xsk_buff_pool {
>         spinlock_t xsk_tx_list_lock;
>         refcount_t users;
>         struct xdp_umem *umem;
> +       /* RX in the device's buffer layout, see net/xdp/xsk_sink.c */
> +       struct xsk_sink *sink;
>         struct work_struct work;
>         /* Protects generic receive in shared and non-shared umem mode. *=
/
>         spinlock_t rx_lock;
> diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
> index 50d67df78911..160a437ed540 100644
> --- a/include/uapi/linux/if_xdp.h
> +++ b/include/uapi/linux/if_xdp.h
> @@ -45,6 +45,13 @@
>   */
>  #define XDP_UMEM_TX_METADATA_LEN       (1 << 2)
>
> +/* RX buffers follow the device's layout: a page-sized chunk may hold
> + * several of them, a packet may span chunks, and the device picks the
> + * offsets. A FILL entry lends a chunk to the kernel. Needs aligned
> + * page-sized chunks and no headroom.
> + */
> +#define XDP_UMEM_DRV_LAYOUT            (1 << 4)

First of all, this looks a lot better than the previous patch set.
Much simpler from a driver point of view, fewer changes to core
networking code, and that with just a small change/extension to the
uAPI.

But I do not think this name is good. Most users of this API do not
care about driver details such as the layout. Why not call it
something that has to do with what has changed from the user's point
of view? Previously we had implicit ownership transfers. You got a
packet in Rx, you own the chunk. Now we have explicit ownership
transfer. You do not own the chunk the packet is in, unless you get
the new flag back (introduced later). So something with "explicit
ownership" or something similar would be better. Or focus the name on
that you can support larger chunks, but that is for later patches so
might not be the best choice.

>  struct sockaddr_xdp {
>         __u16 sxdp_family;
>         __u16 sxdp_flags;
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 8a1d5a284e53..3bc20c7e409f 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -10860,6 +10860,11 @@ static int dev_xdp_attach(struct net_device *dev=
, struct netlink_ext_ack *extack
>                 NL_SET_ERR_MSG(extack, "Active program does not match exp=
ected");
>                 return -EEXIST;
>         }
> +       if (cur_prog && !new_prog && !link && mode =3D=3D XDP_MODE_DRV &&
> +           dev_has_xdp_only_mp(dev)) {
> +               NL_SET_ERR_MSG(extack, "An XDP-only memory provider needs=
 the program");
> +               return -EBUSY;
> +       }
>
>         /* put effective new program into new_prog */
>         if (link)
> @@ -11163,6 +11168,31 @@ bool dev_mp_blocks_xdp(const struct net_device *=
dev)
>         return false;
>  }
>
> +/* A native program is attached, and dev_xdp_attach() keeps it while an
> + * AF_XDP socket receives in the buffer layout of @dev. A BPF link could=
 go
> + * without asking, and so could a program that an upper device propagate=
d.
> + */
> +bool dev_xdp_drv_prog_held(struct net_device *dev)
> +{
> +       return dev_xdp_prog_id(dev, XDP_MODE_DRV) &&
> +              !dev_xdp_link(dev, XDP_MODE_DRV) && !dev->xdp_from_upper;
> +}
> +
> +/* A queue of @dev has an XDP-only memory provider */
> +bool dev_has_xdp_only_mp(const struct net_device *dev)
> +{
> +       const struct memory_provider_ops *ops;
> +       unsigned int i;
> +
> +       for (i =3D 0; i < dev->real_num_rx_queues; i++) {
> +               ops =3D dev->_rx[i].mp_params.mp_ops;
> +               if (ops && ops->flags & MP_XDP_ONLY)
> +                       return true;
> +       }
> +
> +       return false;
> +}
> +
>  u32 dev_get_min_mp_channel_count(const struct net_device *dev)
>  {
>         int i;
> diff --git a/net/xdp/Kconfig b/net/xdp/Kconfig
> index 71af2febe72a..c9c68d3b3712 100644
> --- a/net/xdp/Kconfig
> +++ b/net/xdp/Kconfig
> @@ -2,6 +2,7 @@
>  config XDP_SOCKETS
>         bool "XDP sockets"
>         depends on BPF_SYSCALL
> +       select PAGE_POOL
>         default n
>         help
>           XDP sockets allows a channel between XDP programs and
> diff --git a/net/xdp/Makefile b/net/xdp/Makefile
> index 30cdc4315f42..73a638f12843 100644
> --- a/net/xdp/Makefile
> +++ b/net/xdp/Makefile
> @@ -1,4 +1,4 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  obj-$(CONFIG_XDP_SOCKETS) +=3D xsk.o xdp_umem.o xsk_queue.o xskmap.o
> -obj-$(CONFIG_XDP_SOCKETS) +=3D xsk_buff_pool.o
> +obj-$(CONFIG_XDP_SOCKETS) +=3D xsk_buff_pool.o xsk_sink.o
>  obj-$(CONFIG_XDP_SOCKETS_DIAG) +=3D xsk_diag.o
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index 5ec092f7cb6f..7ece7d9e3937 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -7,6 +7,7 @@
>  #include <net/xdp_sock_drv.h>
>
>  #include "xsk_queue.h"
> +#include "xsk_sink.h"
>  #include "xdp_umem.h"
>  #include "xsk.h"
>
> @@ -69,9 +70,14 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct=
 xdp_sock *xs,
>         if (!pool)
>                 goto out;
>
> -       pool->heads =3D kvzalloc_objs(*pool->heads, umem->chunks);
> -       if (!pool->heads)
> -               goto out;
> +       /* Receiving in the device's buffer layout and copy TX take none =
*/
> +       if (!(umem->flags & XDP_UMEM_DRV_LAYOUT)) {
> +               pool->heads =3D kvzalloc_objs(*pool->heads, umem->chunks)=
;
> +               if (!pool->heads)
> +                       goto out;
> +               pool->heads_cnt =3D umem->chunks;
> +               pool->free_heads_cnt =3D umem->chunks;
> +       }
>
>         if (xs->tx)
>                 if (xp_alloc_tx_descs(pool, xs, max_segs))
> @@ -79,8 +85,6 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct =
xdp_sock *xs,
>
>         pool->chunk_mask =3D ~((u64)umem->chunk_size - 1);
>         pool->addrs_cnt =3D umem->size;
> -       pool->heads_cnt =3D umem->chunks;
> -       pool->free_heads_cnt =3D umem->chunks;
>         pool->headroom =3D umem->headroom;
>         pool->chunk_size =3D umem->chunk_size;
>         pool->chunk_shift =3D ffs(umem->chunk_size) - 1;
> @@ -211,6 +215,13 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
>          */
>         hlist_add_head(&pool->dev_node, &netdev->xsk_pools);
>
> +       if (pool->umem->flags & XDP_UMEM_DRV_LAYOUT) {
> +               err =3D xsk_sink_bind(pool, netdev, queue_id, flags);
> +               if (err)
> +                       goto err_unbind;
> +               return 0;
> +       }
> +
>         if (force_copy)
>                 /* For copy-mode, we are done. */
>                 return 0;
> @@ -268,6 +279,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
>  err_unreg_pool:
>         if (!force_zc)
>                 err =3D 0; /* fallback to copy mode */
> +err_unbind:
>         if (err) {
>                 pool->umem->flags =3D umem_flags;
>                 xsk_clear_pool_at_qid(netdev, queue_id);
> @@ -285,6 +297,9 @@ int xp_assign_dev_shared(struct xsk_buff_pool *pool, =
struct xdp_sock *umem_xs,
>         struct xdp_umem *umem =3D umem_xs->umem;
>
>         flags =3D umem->zc ? XDP_ZEROCOPY : XDP_COPY;
> +       /* The device layout has no copy mode */
> +       if (umem->flags & XDP_UMEM_DRV_LAYOUT)
> +               flags =3D 0;
>
>         if (umem->flags & XDP_UMEM_SG_FLAG)
>                 flags |=3D XDP_USE_SG;
> @@ -300,7 +315,10 @@ static void __xp_clear_dev(struct xsk_buff_pool *poo=
l)
>         struct net_device *netdev =3D pool->netdev;
>
>         netdev_assert_locked_ops_compat(netdev);
> -       xp_disable_drv_zc(pool);
> +       if (pool->sink)
> +               xsk_sink_unbind(pool);
> +       else
> +               xp_disable_drv_zc(pool);
>         xsk_clear_pool_at_qid(netdev, pool->queue_id);
>         hlist_del(&pool->dev_node);
>         pool->netdev =3D NULL;
> diff --git a/net/xdp/xsk_sink.c b/net/xdp/xsk_sink.c
> new file mode 100644
> index 000000000000..b78116f25e71
> --- /dev/null
> +++ b/net/xdp/xsk_sink.c
> @@ -0,0 +1,416 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* AF_XDP RX in the device's buffer layout
> + *
> + * Userspace lends page-sized UMEM chunks through the FILL ring. Each ch=
unk
> + * becomes a net_iov of a page pool memory provider, and the device spli=
ts it
> + * as it splits pages: a chunk may hold several RX buffers, and a packet=
 may
> + * span chunks.
> + *
> + * The kernel maps the chunks through the UMEM mapping, so XDP programs =
read
> + * and write the packets in place. The kernel stores none of its own dat=
a in
> + * the chunks: the shared info of a packet lives in the sink, see
> + * %XDP_FLAGS_SINFO_EXT, and the core turns every verdict that would bui=
ld an
> + * skb or a frame in the buffers into a drop.
> + */
> +
> +#include <linux/nospec.h>
> +#include <net/netdev_queues.h>
> +#include <net/netdev_rx_queue.h>
> +#include <net/page_pool/helpers.h>
> +#include <net/page_pool/memory_provider.h>
> +#include <net/xdp_sock_drv.h>
> +
> +#include "../core/dev.h"
> +#include "xsk_queue.h"
> +#include "xsk_sink.h"
> +
> +#define XSK_SINK_DMA_ATTR (DMA_ATTR_WEAK_ORDERING | DMA_ATTR_SKIP_CPU_SY=
NC)
> +/* Chunks a refill tops up to with released ones */
> +#define XSK_SINK_RESERVE       32
> +
> +/* &net_iov.mp_state: whether userspace has the chunk or lent it */
> +enum {
> +       XSK_SINK_USER,
> +       XSK_SINK_LENT,
> +};
> +
> +struct xsk_sink {
> +       struct net_iov_area area;
> +       struct device *dev;
> +       /* Valid until the socket unbinds */
> +       struct xsk_buff_pool *pool;
> +       /* NULL once no queue uses the provider */
> +       struct netdev_rx_queue *rxq;
> +       /* Protects fq, which stays set while the UMEM is mapped, and kee=
ps
> +        * refills the only taker of released chunks. Besides the queue N=
API,
> +        * drivers refill from process context, as bnxt fills the rings o=
f a
> +        * new queue while the old one still runs.
> +        */
> +       spinlock_t lock;
> +       struct xsk_queue *fq;
> +       refcount_t refs;
> +       /* One node per chunk: chunks that page pools released, from any
> +        * context
> +        */
> +       struct llist_node *nodes;
> +       struct llist_head released;
> +};
> +
> +static void xsk_sink_free(struct xsk_sink *sink)
> +{
> +       kvfree(sink->nodes);
> +       kvfree(sink->area.niovs);
> +       kfree(sink);
> +}
> +
> +static void xsk_sink_put(struct xsk_sink *sink)
> +{
> +       if (refcount_dec_and_test(&sink->refs))
> +               xsk_sink_free(sink);
> +}
> +
> +static int xsk_sink_init(struct page_pool *pp)
> +{
> +       struct xsk_sink *sink =3D pp->mp_priv;
> +
> +       /* Each net_iov is one chunk, mapped for one device */
> +       if (pp->p.order)
> +               return -E2BIG;
> +       if (pp->p.dev !=3D sink->dev || pp->p.offset + pp->p.max_len > PA=
GE_SIZE)
> +               return -EINVAL;
> +       /* Rings that keep every chunk posted leave none to replace the o=
nes
> +        * the device filled: mlx5 posts about 16K pages per queue at MTU
> +        * 9000.
> +        */
> +       if (pp->p.pool_size + PP_ALLOC_CACHE_SIZE >=3D sink->area.num_nio=
vs)
> +               return -ENOSPC;
> +
> +       refcount_inc(&sink->refs);
> +       return 0;
> +}
> +
> +static void xsk_sink_destroy(struct page_pool *pp)
> +{
> +       xsk_sink_put(pp->mp_priv);
> +}
> +
> +/* Takes the chunks that FILL entries lend into the cache of @pp, which =
still
> + * holds those it gave back before. A chunk that an earlier page pool st=
ill
> + * holds goes back to it. Returns the number of chunks taken.
> + */
> +static u32 xsk_sink_take_fill(struct xsk_sink *sink, struct page_pool *p=
p)
> +{
> +       struct net_iov *niov, *niovs =3D sink->area.niovs;
> +       u32 i, entries, cons, mask, nr, n =3D 0;
> +       struct xsk_queue *fq =3D sink->fq;
> +       struct xdp_umem_ring *ring;
> +       struct page_pool *owner;
> +       netmem_ref netmem;
> +       u64 addr;
> +
> +       lockdep_assert_held(&sink->lock);
> +
> +       /* One cache worth, bounding NAPI work */
> +       entries =3D fq ? xskq_cons_nb_entries(fq, PP_ALLOC_CACHE_SIZE) : =
0;
> +       if (!entries)
> +               return 0;
> +
> +       nr =3D sink->area.num_niovs;
> +       ring =3D (struct xdp_umem_ring *)fq->ring;
> +       mask =3D fq->ring_mask;
> +       cons =3D fq->cached_cons;
> +       for (i =3D 0; i < entries; i++) {
> +               addr =3D ring->desc[(cons + i) & mask];
> +               niov =3D &niovs[array_index_nospec((u32)(addr >> PAGE_SHI=
FT),
> +                                                nr)];
> +               /* A chunk lent twice would be in two places at once */
> +               if (unlikely(addr >=3D (u64)nr << PAGE_SHIFT ||
> +                            READ_ONCE(niov->mp_state) =3D=3D XSK_SINK_LE=
NT)) {
> +                       fq->invalid_descs++;
> +                       continue;
> +               }
> +
> +               WRITE_ONCE(niov->mp_state, XSK_SINK_LENT);
> +               netmem =3D net_iov_to_netmem(niov);
> +               owner =3D netmem_get_pp(netmem);
> +               if (owner && owner !=3D pp) {
> +                       page_pool_put_unrefed_netmem(owner, netmem, -1, f=
alse);
> +                       continue;
> +               }
> +               if (!owner)
> +                       net_mp_niov_set_page_pool(pp, niov);
> +               pp->alloc.cache[n++] =3D netmem;
> +       }
> +
> +       xskq_cons_release_n(fq, entries);
> +       __xskq_cons_release(fq);
> +       return n;
> +}
> +
> +/* Tops up the cache of @pp, which holds @n chunks, with chunks that pag=
e
> + * pools released. A reserve, not a source. Each chunk it adds stays in
> + * circulation, so take only what FILL could not give. The lock keeps th=
is
> + * the only consumer of the list, as llist_del_first() needs.
> + */
> +static u32 xsk_sink_take_released(struct xsk_sink *sink, struct page_poo=
l *pp,
> +                                 u32 n)
> +{
> +       struct llist_node *node;
> +       struct net_iov *niov;
> +
> +       lockdep_assert_held(&sink->lock);
> +
> +       /* The page pool cache has 8 entries with 64K pages */
> +       while (n < min(XSK_SINK_RESERVE, PP_ALLOC_CACHE_SIZE)) {
> +               node =3D llist_del_first(&sink->released);
> +               if (!node)
> +                       break;
> +               niov =3D &sink->area.niovs[node - sink->nodes];
> +               net_mp_niov_set_page_pool(pp, niov);
> +               pp->alloc.cache[n++] =3D net_iov_to_netmem(niov);
> +       }
> +       return n;
> +}
> +
> +static netmem_ref xsk_sink_alloc_netmems(struct page_pool *pp, gfp_t gfp=
)
> +{
> +       struct xsk_sink *sink =3D pp->mp_priv;
> +       /* The NAPI owns the need_wakeup flags */
> +       bool napi =3D in_softirq() && !in_hardirq();
> +       struct xsk_queue *fq;
> +       dma_addr_t dma;
> +       u32 i, n;
> +
> +       /* The page pool refills only an empty cache */
> +       if (WARN_ON_ONCE(pp->alloc.count))
> +               return 0;
> +
> +       spin_lock_bh(&sink->lock);
> +       n =3D xsk_sink_take_fill(sink, pp);
> +       n =3D xsk_sink_take_released(sink, pp, n);
> +       fq =3D sink->fq;
> +       /* Ask for kicks only while FILL runs dry, as zero copy drivers d=
o: a
> +        * kick schedules the NAPI, which a busy poller would rather run
> +        * itself. Process context refills new queues only and leaves the
> +        * flags to their NAPI and to bind.
> +        */
> +       if (napi && fq && sink->pool->uses_need_wakeup) {

Was not need_wakeup a requirement for using this new mode? If so, why
not just set it somewhere and not test it after that?

> +               if (n)
> +                       xsk_clear_rx_need_wakeup(sink->pool);
> +               else
> +                       xsk_set_rx_need_wakeup(sink->pool);
> +       }
> +       if (fq && !n)
> +               fq->queue_empty_descs++;
> +       spin_unlock_bh(&sink->lock);
> +       if (!n)
> +               return 0;
> +
> +       for (i =3D 0; i < n; i++) {
> +               dma =3D page_pool_get_dma_addr_netmem(pp->alloc.cache[i])=
;
> +               dma_sync_single_range_for_device(pp->p.dev, dma, pp->p.of=
fset,
> +                                                pp->p.max_len, pp->p.dma=
_dir);
> +       }
> +
> +       pp->alloc.count =3D n - 1;
> +       return pp->alloc.cache[n - 1];
> +}
> +
> +static bool xsk_sink_release_netmem(struct page_pool *pp, netmem_ref net=
mem)
> +{
> +       struct net_iov *niov =3D netmem_to_net_iov(netmem);
> +       struct xsk_sink *sink =3D pp->mp_priv;
> +
> +       net_mp_niov_clear_page_pool(niov);
> +       llist_add(&sink->nodes[net_iov_idx(niov)], &sink->released);
> +       return false;
> +}
> +
> +static int xsk_sink_nl_fill(void *mp_priv, struct sk_buff *rsp,
> +                           struct netdev_rx_queue *rxq)
> +{
> +       return 0;
> +}
> +
> +/* No queue DMAs to the UMEM any longer */
> +static void xsk_sink_stop(struct xsk_sink *sink)
> +{
> +       bool unmap;
> +
> +       spin_lock_bh(&sink->lock);
> +       WRITE_ONCE(sink->rxq, NULL);
> +       unmap =3D sink->fq;
> +       sink->fq =3D NULL;
> +       spin_unlock_bh(&sink->lock);
> +
> +       /* Wait for wakeups that found the sink or the queue */
> +       synchronize_net();
> +       if (unmap)
> +               xp_dma_unmap(sink->pool, XSK_SINK_DMA_ATTR);
> +}
> +
> +/* Device unregister, after the queue stopped */
> +static void xsk_sink_uninstall(void *mp_priv, struct netdev_rx_queue *rx=
q)
> +{
> +       memset(&rxq->mp_params, 0, sizeof(rxq->mp_params));
> +       xsk_sink_stop(mp_priv);
> +}
> +
> +static const struct memory_provider_ops xsk_sink_ops =3D {
> +       .alloc_netmems  =3D xsk_sink_alloc_netmems,
> +       .release_netmem =3D xsk_sink_release_netmem,
> +       .init           =3D xsk_sink_init,
> +       .destroy        =3D xsk_sink_destroy,
> +       .nl_fill        =3D xsk_sink_nl_fill,
> +       .uninstall      =3D xsk_sink_uninstall,
> +       .flags          =3D MP_XDP_ONLY,
> +};
> +
> +static struct xsk_sink *xsk_sink_create(struct xsk_buff_pool *pool,
> +                                       struct device *dev)
> +{
> +       u32 i, nr =3D pool->umem->chunks;
> +       struct xsk_sink *sink;
> +       struct net_iov *niov;
> +       dma_addr_t dma;
> +
> +       sink =3D kzalloc_obj(*sink, GFP_KERNEL_ACCOUNT);
> +       if (!sink)
> +               return ERR_PTR(-ENOMEM);
> +
> +       /* See &xdp_rxq_info.sink_area */
> +       BUILD_BUG_ON(offsetof(struct xsk_sink, area));
> +
> +       sink->area.niovs =3D kvcalloc(nr, sizeof(*niov), GFP_KERNEL_ACCOU=
NT);
> +       sink->nodes =3D kvcalloc(nr, sizeof(*sink->nodes), GFP_KERNEL_ACC=
OUNT);
> +       if (!sink->area.niovs || !sink->nodes) {
> +               xsk_sink_free(sink);
> +               return ERR_PTR(-ENOMEM);
> +       }
> +
> +       sink->area.num_niovs =3D nr;
> +       /* Chunks are pages, see XDP_UMEM_DRV_LAYOUT */
> +       sink->area.xdp_vaddr =3D pool->addrs;
> +       sink->area.xdp_vsize =3D (size_t)nr << PAGE_SHIFT;
> +       sink->area.xdp_shift =3D PAGE_SHIFT;
> +       sink->dev =3D dev;
> +       sink->pool =3D pool;
> +       sink->fq =3D pool->fq;
> +       spin_lock_init(&sink->lock);
> +       init_llist_head(&sink->released);
> +       refcount_set(&sink->refs, 1);
> +
> +       /* Chunks are pages, see XDP_UMEM_DRV_LAYOUT */
> +       for (i =3D 0; i < nr; i++) {
> +               niov =3D &sink->area.niovs[i];
> +               dma =3D pool->dma_pages[i] & ~XSK_NEXT_PG_CONTIG_MASK;
> +               net_iov_init(niov, &sink->area, NET_IOV_XSK);
> +               if (net_mp_niov_set_dma_addr(niov, dma)) {
> +                       xsk_sink_free(sink);
> +                       return ERR_PTR(-ERANGE);
> +               }
> +       }
> +
> +       return sink;
> +}
> +
> +/* Sockets sharing the pool find no sink after the grace period of
> + * xsk_sink_stop(), see xsk_wakeup()
> + */
> +static void xsk_sink_detach(struct xsk_buff_pool *pool)
> +{
> +       struct xsk_sink *sink =3D pool->sink;
> +
> +       WRITE_ONCE(pool->sink, NULL);
> +       xsk_sink_stop(sink);
> +       xsk_sink_put(sink);
> +       static_branch_dec(&xdp_sink_key);
> +}
> +
> +/**
> + * xsk_sink_bind - install the UMEM of @pool as the provider of an RX qu=
eue
> + * @pool: buffer pool with an XDP_UMEM_DRV_LAYOUT UMEM
> + * @dev: device of the queue
> + * @queue_id: RX queue
> + * @flags: bind flags
> + *
> + * Context: RTNL and the instance lock of @dev.
> + * Return: 0 on success. No copy mode takes over on error.
> + */
> +int xsk_sink_bind(struct xsk_buff_pool *pool, struct net_device *dev,
> +                 u16 queue_id, u16 flags)
> +{
> +       u32 needed =3D NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT;
> +       struct pp_memory_provider_params p =3D { .mp_ops =3D &xsk_sink_op=
s };
> +       struct device *dma_dev;
> +       struct xsk_sink *sink;
> +       int err;
> +
> +       if (flags & XDP_USE_SG)
> +               needed |=3D NETDEV_XDP_ACT_RX_SG;
> +       if (flags & XDP_COPY || !dev->queue_mgmt_ops ||
> +           (dev->xdp_features & needed) !=3D needed ||
> +           queue_id >=3D dev->real_num_rx_queues)
> +               return -EOPNOTSUPP;
> +
> +       /* The program of another device would see a leased queue's packe=
ts */
> +       if (netif_rxq_is_leased(dev, queue_id))
> +               return -EOPNOTSUPP;
> +
> +       /* The device of the queue's page pools, which may differ per que=
ue */
> +       dma_dev =3D netdev_queue_get_dma_dev(dev, queue_id, NETDEV_QUEUE_=
TYPE_RX);
> +       if (!dma_dev)
> +               return -EOPNOTSUPP;
> +
> +       /* Without a program, drivers would build skbs from the buffers *=
/
> +       if (!dev_xdp_drv_prog_held(dev))
> +               return -ENOENT;
> +
> +       err =3D xp_dma_map(pool, dma_dev, XSK_SINK_DMA_ATTR, pool->umem->=
pgs,
> +                        pool->umem->npgs);
> +       if (err)
> +               return err;
> +
> +       sink =3D xsk_sink_create(pool, dma_dev);
> +       if (IS_ERR(sink)) {
> +               xp_dma_unmap(pool, XSK_SINK_DMA_ATTR);
> +               return PTR_ERR(sink);
> +       }
> +
> +       /* Until the first refill of the NAPI: the queue may need FILL to
> +        * start. Set before the NAPI runs, which owns the flags after th=
at.
> +        */
> +       if (pool->uses_need_wakeup)
> +               xsk_set_rx_need_wakeup(pool);
> +
> +       /* The core keeps sink buffers to the socket once the queue runs =
*/
> +       static_branch_inc(&xdp_sink_key);
> +       sink->rxq =3D __netif_get_rx_queue(dev, queue_id);
> +       pool->sink =3D sink;
> +       p.mp_priv =3D sink;
> +       err =3D netif_mp_open_rxq(dev, queue_id, &p, NULL);
> +       if (err) {
> +               xsk_sink_detach(pool);
> +               return err;
> +       }
> +
> +       return 0;
> +}

At a first glance it feels like some of this code could be shared with
the current bind, but I guess you have already tried and it is not
worth it, or? The commonality seems somewhat spread out.

> +
> +/* Context: RTNL and the instance lock of the device */
> +void xsk_sink_unbind(struct xsk_buff_pool *pool)
> +{
> +       struct xsk_sink *sink =3D pool->sink;
> +       struct pp_memory_provider_params p =3D {
> +               .mp_ops =3D &xsk_sink_ops,
> +               .mp_priv =3D sink,
> +       };
> +
> +       /* Unregister may have uninstalled the provider already. A queue =
that
> +        * cannot restart without it may still use the UMEM: stop the dev=
ice.
> +        */
> +       if (READ_ONCE(sink->rxq) &&
> +           netif_mp_close_rxq(pool->netdev, pool->queue_id, &p))
> +               netif_close(pool->netdev);
> +       xsk_sink_detach(pool);
> +}
> diff --git a/net/xdp/xsk_sink.h b/net/xdp/xsk_sink.h
> new file mode 100644
> index 000000000000..3f201163c530
> --- /dev/null
> +++ b/net/xdp/xsk_sink.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* AF_XDP RX in the device's buffer layout, see xsk_sink.c */
> +
> +#ifndef XSK_SINK_H_
> +#define XSK_SINK_H_
> +
> +struct net_device;
> +struct xsk_buff_pool;
> +
> +int xsk_sink_bind(struct xsk_buff_pool *pool, struct net_device *dev,
> +                 u16 queue_id, u16 flags);
> +void xsk_sink_unbind(struct xsk_buff_pool *pool);
> +
> +#endif /* XSK_SINK_H_ */
> diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux=
/if_xdp.h
> index 50d67df78911..160a437ed540 100644
> --- a/tools/include/uapi/linux/if_xdp.h
> +++ b/tools/include/uapi/linux/if_xdp.h
> @@ -45,6 +45,13 @@
>   */
>  #define XDP_UMEM_TX_METADATA_LEN       (1 << 2)
>
> +/* RX buffers follow the device's layout: a page-sized chunk may hold
> + * several of them, a packet may span chunks, and the device picks the
> + * offsets. A FILL entry lends a chunk to the kernel. Needs aligned
> + * page-sized chunks and no headroom.
> + */
> +#define XDP_UMEM_DRV_LAYOUT            (1 << 4)
> +
>  struct sockaddr_xdp {
>         __u16 sxdp_family;
>         __u16 sxdp_flags;
> --
> 2.56.1
>
>
