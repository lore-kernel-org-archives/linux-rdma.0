Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131353E49FD
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 16:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784650537; cv=pass; b=cA0o2g5H6+3UBPNhgrIf7dRny0Uew+sbVV++IJ1bcW4Sio7HEvbYo7SqZ2qrm5TplbeZg1dg1fOabktEt/wtH30Q7UKRzf2P2JcqCjuE7Q2bfG6hsplO6GK/d9AVZRwcpH+j5nJzzKKnG8fSC+S8kP2V9LViU31S8V2i/eaEXEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784650537; c=relaxed/simple;
	bh=lTgHdKMh+BlzjJFXdBt8hCdAGNDjBwZXNyyCB+G0i5E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hfCIru3iXNRerpsrc530r9ANzMXqyFjPHiC4CdCoI2g6sXMlsZKlKiPyaFEFmLCPNwWxFftcXkFmOLKFfMXbor7UHMmybOPIcBFq8iTqOiEwNhQcwkNUSxd6ThKyagZc0DhAvm4XIH4JB2uN615aXyc5ZsBjtYQD5vd5GKE+8aA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H2PnQFOz; arc=pass smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H2PnQFOz"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-497e6956acfso4229493b6e.1
        for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 09:15:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784650534; cv=none;
        d=google.com; s=arc-20260327;
        b=aLSEJgAUWrhX3nLIjfooq6sZ7ZPJQ2erCzH3fIBpC3NgjkbWNFnMNN3v3Qvt294dAI
         MOiYC0lEni8kg6d6xck9eLBcFYzrgMIsk5ofw3uBV68vXFlLIfTCJ9g8gbSM4hAGWm5B
         yJ/gyUbnFaC1vX0Xk4ZVbSQL48wtKhTQ3ZfBB/ZXLAONVdo0YTCnQBDarphjaIUX7qvr
         U+Y39QNouIwsTzkjwqz1q6pHlLMU3ubVRTKNFEsxJOfk1/653MG//NhIo+EqTv3RccWJ
         Y92jfpI0bcHs9vASPhsnV9vV4cG2jPLvrmNyCj5Fk41y99fJYwFo4yeWQkhGdImHIVaA
         SKjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=061OgT0DczhRmlwQ4HiKPIppyoeB89N03B5P6SpVAYA=;
        fh=HZNAYZsgxYSHOq2eBtbfW58b4+fgMeozaDsWkMdSonk=;
        b=TiRgP2uUr95vw5mDbUh/Gcb/9btvv1Cl1lRO9lY6ibWWaHLaqVG0LTUrycDr39zIhR
         4MlmHmbm9ungbjqlBUghw369mIPlaXJryS49qS3MfN86AIeRYAqVss7eYK+SZV1c5OTA
         +YNmZbKIHjyUWUV27P9ClCjWYA2YofaKrStHJyChBtpRQwQJ5fIj6vFyM+hblPEIbZE/
         9ZvuP+1GaHk2ikTHpco4H+qVa7ploNl62mJMZYvVnA6gYH97h/oBGE4arCO/jwhPgV4O
         +uPk2j1j1zDd7xu3UJci2t8b9kr3/qorJ6LDZLAaj7e/UmWWPZtT88dlD4DYuXoB8DTa
         Wx7A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784650534; x=1785255334; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=061OgT0DczhRmlwQ4HiKPIppyoeB89N03B5P6SpVAYA=;
        b=H2PnQFOzVNYRzmFYOfoStd9nFwGKD2kofFWsM3xBYo92RQA+9UjLuQyS5sw63py8MJ
         ooLw2RxaBhUOZ+geKaX4vp4wZLkFsYtATEB1lddY4Sv37TvcyTPCuX1UkOvEIi2jRSWv
         eXgGUBpb2O+Bkiv1RhGvk6QfvMIzSMsc/zZ6qg0AZB3uaL3MCHG26dfpdwlZDMix4sII
         90wHL5fU9YaWxK0c3KXYApXrzV2M0SdKZVbaOQFJnSkTumUrEDWnhgqO95cNMx7juoX+
         Okde3pWqG/yAANLrkFgJLr+u+TftYeh0zyU+vv71ln0jU0D6qtki1YLQzF3Kpivgkd7l
         9Fcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784650534; x=1785255334;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=061OgT0DczhRmlwQ4HiKPIppyoeB89N03B5P6SpVAYA=;
        b=CVpGmkX4gGf+XxbD+8y6R6ZNQYWOq3Qer592oPrIWFiW5BImp+eBfBIUeIt/QX+7K8
         3PV4hHeQDkqGvm6FDX1ixLzLXxexv02YzK0lJA9ixM1z57eMBHJW28Wc2s95ndixou8r
         EvhxOpJXEql1UojwpJrn9gKggOP5RNBEf9VmGPBm21WUc3F6HIGYCwg6dzGgpcNfXHPb
         N54/9iQfSe8y74xELi4TBQNRvf22lJpBGJXT6wQOsgXB3kCMxToMj0PKE0Fg3myPDDMc
         VCJs7rD/V7x0mEhtSa40CZp74brN77wnCqyyjq9bByhLRysgD+RfAKlG6vFKZFG9wt+M
         Tu+g==
X-Forwarded-Encrypted: i=1; AHgh+Rr7nyVm3FmSpurBi+fEoDwJHmcf0sTB3OqLPworH1lapDxL3T96q0bsYKxPRc0j9xgXljITvv9TXBUu@vger.kernel.org
X-Gm-Message-State: AOJu0YxlKuch4eoRoSzIonuS78+RQHnEOFbkGvcl3z6RVU32JyKCH2b5
	q7l/S1jgnoEqIUX31DRyZeX2pY8uueZrgcdXAQaZ2csGKJgGuC5oyHykRdhIXa3d8mJcQa+ITGZ
	YPtUDI+xekjQ3mN4YoAT3mETa+XRWgVQ=
X-Gm-Gg: AfdE7cn4J5BAKwILmrCsUQZyNvt59r7msLya5ObnmoLBQbdzbPIRMJWTcVLTiacdek+
	yZ5tRy4dYpmdmxpVKKrjEAZZNjDNKpV7aCQERbZueoBTgaGbSF8qMIecO/iGyUdZN98WvcVhUVc
	Yh0MP1z7vPdYifVv7SXK2yWEsakh2t0R2yrBQDxC31chD7sfuDAYQEUeUISsRN07crb7y0GBqSy
	WozEjcevIZ8NI2niPrC/uKxG7m/vBrOU0/aoetKWJ31X6b3A5ebjW4w5bCSBYk=
X-Received: by 2002:a05:6808:1719:b0:495:ca1b:7865 with SMTP id
 5614622812f47-4aaaa45f35fmr115856b6e.11.1784650533635; Tue, 21 Jul 2026
 09:15:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260719175857.4071636-1-ap420073@gmail.com> <20260719175857.4071636-3-ap420073@gmail.com>
 <CAHS8izMU4gQCH2v0dcOFkjP6Sxj7RUvC8=Baet=+pFXG24qh7A@mail.gmail.com>
In-Reply-To: <CAHS8izMU4gQCH2v0dcOFkjP6Sxj7RUvC8=Baet=+pFXG24qh7A@mail.gmail.com>
From: Taehee Yoo <ap420073@gmail.com>
Date: Wed, 22 Jul 2026 01:15:21 +0900
X-Gm-Features: AUfX_myzxRudA1U0N4kTpj_-EeksspXQRshMpn_Oino0jucUwXolnXuNEcZWdbw
Message-ID: <CAMArcTXba+A+MR2rpODbpdWbHOE3XLi6RfkCsK9fjgWzzTxSow@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 02/13] net: devmem: extend memory provider
 for knod
To: Mina Almasry <almasrymina@google.com>
Cc: Alex Deucher <alexander.deucher@amd.com>, Alexei Starovoitov <ast@kernel.org>, 
	amd-gfx@lists.freedesktop.org, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Andrii Nakryiko <andrii@kernel.org>, Bill Wendling <morbo@google.com>, bpf@vger.kernel.org, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, David Airlie <airlied@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Donald Hunter <donald.hunter@gmail.com>, 
	dri-devel@lists.freedesktop.org, Eduard Zingerman <eddyz87@gmail.com>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Eric Dumazet <edumazet@google.com>, 
	Felix Kuehling <Felix.Kuehling@amd.com>, Hoyeon Lee <hoyeon.rhee@gmail.com>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Jakub Kicinski <kuba@kernel.org>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Leon Romanovsky <leon@kernel.org>, 
	linaro-mm-sig@lists.linaro.org, linux-hardening@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-rdma@vger.kernel.org, llvm@lists.linux.dev, 
	Mark Bloch <mbloch@nvidia.com>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Michael Chan <michael.chan@broadcom.com>, Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org, 
	Nick Desaulniers <ndesaulniers@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Shuah Khan <shuah@kernel.org>, Simona Vetter <simona@ffwll.ch>, Simon Horman <horms@kernel.org>, 
	Song Liu <song@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Tariq Toukan <tariqt@nvidia.com>, 
	Yonghong Song <yonghong.song@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 21, 2026 at 4:44=E2=80=AFAM Mina Almasry <almasrymina@google.co=
m> wrote:
>

Hi Mina,
Thanks a lot for your review!

> On Sun, Jul 19, 2026 at 11:03=E2=80=AFAM Taehee Yoo <ap420073@gmail.com> =
wrote:
> >
> > Extend the devmem memory-provider path so a knod accelerator can back a
> > NIC page_pool with accelerator-exported memory (dma-buf), letting the
> > NIC DMA received packets directly into accelerator memory.
> >
> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>
> Changes look fine in general but I do not understand in the design how
> the page_pool not bound to rx queue would be used. Maybe elaborate on
> the design in the commit message or cover letter in the next
> iteration.
>

Sorry, this is not clear from the commit message or cover letter.

We added a custom provider type for page_pool that allocates GTT memory
- host memory that is also mapped to a GPU VA, which lets us copy between
VRAM and host without a separate staging buffer. So when the XDP verdict
is XDP_PASS, or on the IPsec path, this page_pool is used for the
allocation. To configure the page_pool with our KNOD backend, we
define mp_ops/priv in knod_core.c and set them directly as the
page_pool's mp_ops/priv, rather than going through netdev_rx_queue.

As a result, each combined channel has two page_pools: a NETMEM
page_pool created by the device driver to refill the RX ring through
the normal netdev_rx_queue path, and one CUSTOM_PROVIDER page_pool
created and managed by knod core for the XDP_PASS / IPsec allocations.
The latter is created per channel by knod core, so it is not bound
through netdev_rx_queue.

We will describe this distinction in the next revision.

> > (cherry picked from commit d511a8cb3e229f8f5cf060985880d45bd384db87)
>
> I guess remove unintended cherry-pick tag.
>

Yes, we will remove it.

> > ---
> >  include/net/devmem.h                    |  58 +++++++++++++
> >  include/net/netmem.h                    |   9 +++
> >  include/net/page_pool/memory_provider.h |   4 +
> >  include/net/page_pool/types.h           |  23 +++++-
> >  net/core/devmem.c                       | 103 +++++++++++++++++++-----
> >  net/core/devmem.h                       |   7 +-
> >  net/core/page_pool.c                    |  22 ++++-
> >  7 files changed, 198 insertions(+), 28 deletions(-)
> >  create mode 100644 include/net/devmem.h
> >
> > diff --git a/include/net/devmem.h b/include/net/devmem.h
> > new file mode 100644
> > index 000000000000..f1c3895d7833
> > --- /dev/null
> > +++ b/include/net/devmem.h
>
> Try to keep only include/net/netmem.h and net/core/devmem.h rather
> than add an include/net/devmem.h
>

Thanks. We will keep the declarations in include/net/netmem.h and

> > @@ -0,0 +1,58 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > +/*
> > + * Device memory TCP support
> > + *
> > + * Authors:    Mina Almasry <almasrymina@google.com>
> > + *             Willem de Bruijn <willemb@google.com>
> > + *             Kaiyuan Zhang <kaiyuanz@google.com>
> > + *
> > + */
> > +#ifndef _NET_DEVMEM_H
> > +#define _NET_DEVMEM_H
> > +
> > +#include <linux/dma-direction.h>
> > +#include <linux/err.h>
> > +#include <linux/types.h>
> > +
> > +struct device;
> > +struct dma_buf;
> > +struct dma_buf_attach_ops;
> > +struct net_device;
> > +struct net_devmem_dmabuf_binding;
> > +struct netlink_ext_ack;
> > +
> > +#if defined(CONFIG_NET_DEVMEM)
> > +struct net_devmem_dmabuf_binding *
> > +__net_devmem_binding_create(struct net_device *dev, struct device *dma=
_dev,
> > +                           struct dma_buf *dmabuf,
> > +                           enum dma_data_direction direction,
> > +                           const struct dma_buf_attach_ops *importer_o=
ps,
> > +                           struct netlink_ext_ack *extack);
> > +int net_devmem_bind_dmabuf_to_queue_direct(struct net_device *dev, u32=
 rxq_idx,
> > +                                          struct net_devmem_dmabuf_bin=
ding *binding);
> > +void net_devmem_unbind_dmabuf_direct(struct net_devmem_dmabuf_binding =
*binding);
> > +#else
> > +static inline struct net_devmem_dmabuf_binding *
> > +__net_devmem_binding_create(struct net_device *dev, struct device *dma=
_dev,
> > +                           struct dma_buf *dmabuf,
> > +                           enum dma_data_direction direction,
> > +                           const struct dma_buf_attach_ops *importer_o=
ps,
> > +                           struct netlink_ext_ack *extack)
> > +{
> > +       return ERR_PTR(-EOPNOTSUPP);
> > +}
> > +
> > +static inline int
> > +net_devmem_bind_dmabuf_to_queue_direct(struct net_device *dev, u32 rxq=
_idx,
> > +                                      struct net_devmem_dmabuf_binding=
 *binding)
> > +{
> > +       return -EOPNOTSUPP;
> > +}
> > +
> > +static inline void
> > +net_devmem_unbind_dmabuf_direct(struct net_devmem_dmabuf_binding *bind=
ing)
> > +{
> > +}
> > +#endif
> > +
> > +#endif /* _NET_DEVMEM_H */
> > diff --git a/include/net/netmem.h b/include/net/netmem.h
> > index bccacd21b6c3..3ddfbd37500f 100644
> > --- a/include/net/netmem.h
> > +++ b/include/net/netmem.h
> > @@ -127,6 +127,15 @@ static inline void net_iov_init(struct net_iov *ni=
ov,
> >         niov->type =3D type;
> >  }
> >
> > +/* Global page index within the dma-buf, accounting for multi-chunk
> > + * scatter-gather layouts where each chunk owner's niovs start at 0.
> > + */
> > +static inline unsigned int net_iov_binding_idx(const struct net_iov *n=
iov)
> > +{
> > +       return (net_iov_owner(niov)->base_virtual >> PAGE_SHIFT) +
> > +              net_iov_idx(niov);
> > +}
> > +
> >  /* netmem */
> >
> >  /**
> > diff --git a/include/net/page_pool/memory_provider.h b/include/net/page=
_pool/memory_provider.h
> > index 255ce4cfd975..4b58a9702fb7 100644
> > --- a/include/net/page_pool/memory_provider.h
> > +++ b/include/net/page_pool/memory_provider.h
> > @@ -23,6 +23,10 @@ bool net_mp_niov_set_dma_addr(struct net_iov *niov, =
dma_addr_t addr);
> >  void net_mp_niov_set_page_pool(struct page_pool *pool, struct net_iov =
*niov);
> >  void net_mp_niov_clear_page_pool(struct net_iov *niov);
> >
> > +void page_pool_provider_set_netmem(struct page_pool *pool, netmem_ref =
netmem,
> > +                                  dma_addr_t addr);
> > +void page_pool_clear_pp_info(netmem_ref netmem);
> > +
> >  int netif_mp_open_rxq(struct net_device *dev, unsigned int rxq_idx,
> >                       const struct pp_memory_provider_params *p,
> >                       struct netlink_ext_ack *extack);
> > diff --git a/include/net/page_pool/types.h b/include/net/page_pool/type=
s.h
> > index 03da138722f5..3e866f249768 100644
> > --- a/include/net/page_pool/types.h
> > +++ b/include/net/page_pool/types.h
> > @@ -31,8 +31,16 @@
> >   */
> >  #define PP_FLAG_ALLOW_UNREADABLE_NETMEM BIT(3)
> >
> > +/* Driver-managed pool with a directly-supplied memory provider, not b=
ound to a
> > + * netdev rx queue. Setting this flag requires page_pool_params.mp_ops=
 and
> > + * .mp_priv to both be set.
> > + */
> > +#define PP_FLAG_CUSTOM_MEMORY_PROVIDER BIT(4)
> > +
> >  #define PP_FLAG_ALL            (PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV=
 | \
> > -                                PP_FLAG_SYSTEM_POOL | PP_FLAG_ALLOW_UN=
READABLE_NETMEM)
> > +                                PP_FLAG_SYSTEM_POOL | \
> > +                                PP_FLAG_ALLOW_UNREADABLE_NETMEM | \
> > +                                PP_FLAG_CUSTOM_MEMORY_PROVIDER)
> >
> >  /* Index limit to stay within PP_DMA_INDEX_BITS for DMA indices */
> >  #define PP_DMA_INDEX_LIMIT XA_LIMIT(1, BIT(PP_DMA_INDEX_BITS) - 1)
> > @@ -54,11 +62,11 @@
> >   * would have to take a slower code path.
> >   */
> >  #if PAGE_SIZE >=3D SZ_64K
> > -#define PP_ALLOC_CACHE_REFILL  4
> > +#define PP_ALLOC_CACHE_REFILL  256
> >  #elif PAGE_SIZE >=3D SZ_16K
> > -#define PP_ALLOC_CACHE_REFILL  16
> > +#define PP_ALLOC_CACHE_REFILL  1024
> >  #else
> > -#define PP_ALLOC_CACHE_REFILL  64
> > +#define PP_ALLOC_CACHE_REFILL  4096
> >  #endif
> >
>
> I'm guessing this is just a workaround/optimization. You need a proper
> change for this, maybe make it configurable arguments when creating a
> pp or something.
>

Agreed. We will rework this as a per-pool setting instead of changing
the global page_pool cache size.

> >  #define PP_ALLOC_CACHE_SIZE    (PP_ALLOC_CACHE_REFILL * 2)
> > @@ -67,6 +75,8 @@ struct pp_alloc_cache {
> >         netmem_ref cache[PP_ALLOC_CACHE_SIZE];
> >  };
> >
> > +struct memory_provider_ops;
> > +
> >  /**
> >   * struct page_pool_params - page pool parameters
> >   * @fast:      params accessed frequently on hotpath
> > @@ -83,6 +93,9 @@ struct pp_alloc_cache {
> >   * @queue_idx: queue idx this page_pool is being created for.
> >   * @flags:     PP_FLAG_DMA_MAP, PP_FLAG_DMA_SYNC_DEV, PP_FLAG_SYSTEM_P=
OOL,
> >   *             PP_FLAG_ALLOW_UNREADABLE_NETMEM.
> > + * @mp_ops:    driver-supplied memory provider for a pool not bound to=
 a
> > + *             netdev rx queue (NULL to use rxq->mp_params instead)
> > + * @mp_priv:   context passed to @mp_ops
> >   */
> >  struct page_pool_params {
> >         struct_group_tagged(page_pool_params_fast, fast,
> > @@ -99,6 +112,8 @@ struct page_pool_params {
> >                 struct net_device *netdev;
> >                 unsigned int queue_idx;
> >                 unsigned int    flags;
> > +               const struct memory_provider_ops *mp_ops;
> > +               void *mp_priv;
> >  /* private: used by test code only */
> >                 void (*init_callback)(netmem_ref netmem, void *arg);
> >                 void *init_arg;
> > diff --git a/net/core/devmem.c b/net/core/devmem.c
> > index 957d6b96216b..9e21cffc9643 100644
> > --- a/net/core/devmem.c
> > +++ b/net/core/devmem.c
> > @@ -121,12 +121,9 @@ void net_devmem_free_dmabuf(struct net_iov *niov)
> >         gen_pool_free(binding->chunk_pool, dma_addr, PAGE_SIZE);
> >  }
> >
> > -void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *bindin=
g)
> > +static void
> > +net_devmem_binding_unpublish(struct net_devmem_dmabuf_binding *binding=
)
> >  {
> > -       struct netdev_rx_queue *rxq;
> > -       unsigned long xa_idx;
> > -       unsigned int rxq_idx;
> > -
> >         xa_erase(&net_devmem_dmabuf_bindings, binding->id);
> >
> >         /* Ensure no tx net_devmem_lookup_dmabuf() are in flight after =
the
> > @@ -136,6 +133,15 @@ void net_devmem_unbind_dmabuf(struct net_devmem_dm=
abuf_binding *binding)
> >
> >         if (binding->list.next)
> >                 list_del(&binding->list);
> > +}
> > +
> > +void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *bindin=
g)
> > +{
> > +       struct netdev_rx_queue *rxq;
> > +       unsigned long xa_idx;
> > +       unsigned int rxq_idx;
> > +
> > +       net_devmem_binding_unpublish(binding);
> >
> >         xa_for_each(&binding->bound_rxqs, xa_idx, rxq) {
> >                 const struct pp_memory_provider_params mp_params =3D {
> > @@ -151,6 +157,47 @@ void net_devmem_unbind_dmabuf(struct net_devmem_dm=
abuf_binding *binding)
> >         percpu_ref_kill(&binding->ref);
> >  }
> >
> > +/* Bind/unbind variants for in-kernel offload importers that drive the=
 rx
> > + * queue lifecycle themselves. The mp_params are poked directly, witho=
ut the
> > + * tcp-data-split/XDP guards or the queue reconfigure that the netlink=
 control
> > + * plane applies through netif_mp_open_rxq()/netif_mp_close_rxq().
> > + */
> > +int net_devmem_bind_dmabuf_to_queue_direct(struct net_device *dev, u32=
 rxq_idx,
> > +                                          struct net_devmem_dmabuf_bin=
ding *binding)
> > +{
>
> The LLM says in this function you need to check if the queue is
> already bound to a devmem tcp memory provider.
>

Right. We will reject the bind if the RX queue already has a memory
provider.

Thanks a lot!
Taehee Yoo

> --
> Thanks,
> Mina
