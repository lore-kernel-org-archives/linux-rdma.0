Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.230.202
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795194895;
	b=Olg6k5/Huxq2dXvXyK9V6b80nB0ZwqUBgK+uowI4cBQfqjwy+a4RMUJFcHN3jV9e4RSc
	 KoNz2prYW98AvgegAcY23FjcEf/Z9jIQ21b2O/uq/vlcXe/Vltl7HmU8EEzFmeIRk2Gx1
	 iLkX8DxE2JGnJUyUZTUAWhjZFOGc76fkUyq1p6OARWCc60ocZM2XRwfAOhcDqsNL/he+V
	 NcREUDkexq1XoByzwgHS9ZDHIKG/UFP9YzRylzl65mXE6sRLyRJVfME5xfTNSAjgix8ZV
	 CJlvI/keb+cOCZG6EkwbRq/sCaaiX1z+a2SowCjZpr//rq2bOv1ud/6qlsR6cIZsyaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795194895;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=LkHPVV5puI4vDTHgviLsfMcYaMRsroW0UN+lwZ6xwNI=;
	b=zmrPM88EMWusfhzR7VCy2dJevMSgBR+y8pRSMZHpVFjI9IFyUIvuLjDCkUgaqaS1yR5c
	 tOPAbmMBJsA9+siF/Y51Z4rKj5+59Cthk9tPAdBdf/zEzJJEtumUeAa2r4FVsOnUmTSWK
	 IPquqr1gt/noUh9tWY/81RYi364+mAok/EWUHGkwSSX+P0WreKNxwqlg8KAYZQR+4zWyl
	 I84nwKz2Km7C4ZQW9NK2GvkJX5dqDaXkE/sphDKPcGxwNG1Miy7pUoVBBFg1MuAjnrh66
	 qktvxLXWOI9zOFDhIoBw/6lkhaOV7knJbYT2NCtrdQ71ND1ytkKkkZjUOeeS6tAr8FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=h5JzbllR;
	arc=none smtp.remote-ip=74.125.230.202
Received: from mail-qk2-f10.google.com (mail-qk2-f10.google.com [74.125.230.202])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEE060A261E
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 17:14:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FEE060A261E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=h5JzbllR
Received: by mail-qk2-f10.google.com with SMTP id d75a77b69052e-5365ff8db40so5938911cf.1
        for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 09:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795194894; x=1795799694; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LkHPVV5puI4vDTHgviLsfMcYaMRsroW0UN+lwZ6xwNI=;
        b=h5JzbllRY3FFd7SIlh0QHu3I3pNyf2yBnW2eYr8i9y2WY8PUKpO6C0LnWiy/0p0xH9
         Efz3vuIykc6aRoNZE3Ar6sFTIWmBCvtC6CWCwJu2ipXHHsgbLsUhDIWVqKO5P/9SVZLK
         IEZDUKZFV79jb8XUORh13uLelSXXNTemAw1RfDRIJh4C4RmqHr94Aw1JHoU4EtWxjeM3
         RbZJp4jfvF55Q1A+Ix1ERuQ8Iyp8iv0qki41OhjQ3wNcd1Uk8XX50JJyTil6lCuvX94K
         zasNhD4NETRKK/ruAOeeFZKNgz5N2pOn6TxPQDJWzHWaB+ZwXPwPfFXSnFrc9ccFzUoI
         6DCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795194894; x=1795799694;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LkHPVV5puI4vDTHgviLsfMcYaMRsroW0UN+lwZ6xwNI=;
        b=0YAeogo3NjntvjMzkPKli3syZaVfPugBpTgnExIXER07K0ahHQsgXuMuPJkkBxCywN
         JwmQ/xySSioOnetrpVkDD+0rFzWrSBUaks+1sTPiXLSWU89q3zJVj0UGfi1A1AYpA/Dq
         9sTPpiid+IJy/MSaCQ0Fulpybsi123PynDWGeNmXgEZU1YO65Be9ypPJ3o+Z/vMIMbu/
         +WBBxPzwpykoa/KwSVsQnmMo6xKx1rIrBoHY/DT3LhBTVg+4j9zd/k+xlAGt8GMsxvs0
         hFwUmNye0cSB373KoX1yWquB5/u6caqs7+5PFKG5O6dvg6q7tThuBwEz0nWriCJzkIAs
         6Yig==
X-Forwarded-Encrypted: i=1; AL+hErHxSwTUKQ3CerLc0Be+3DQhNXI6UfsUnwiSjkXyqx3KjE35lgCWZzyu0sB/Se8e43gIMYfhlEhcCNs6@vger.kernel.org
X-Gm-Message-State: APuU4Z/giaUwwx+4A2g0+pff7ANwyTgbglwfCjhmkSkLMW/AavrR3TMx
	iRBO4Vg9rWvkN1iureDFZ5MxVSct9t8JDylIeFMWarYfWMApuraMG//3
X-Gm-Gg: AYBFou2eJbKDl+XqclQ/S3w1eh71VX5bhrYYZV5Z0+qyFntwJik78qvsw9XarYFychE
	3otvI8vXXis1mwb4QPiorTjVC9/87F6oK/wjkCqDIHO8z+3SNB2xeOrLq+cfHY4YmtdVKjzunEw
	I5C/Jj+pE+loZkXlhmN4Czpr7W+k8c634fowOuPEzgGu0ICFjoPtopauyG0xiC08h96lKnpOzo0
	qnIrpL1u8goOOmbQDFBPfaFnr4T1K3v4wLjOEM9Cme/p5ldlsqQlCe3yJ2wXv+DuO5lwVsDMZrA
	9BcLCG9GQLPsd5yTv5rWlpPE3JMRE7/DXz0sAZm7XnUFwIvmAxovSvqkBiIToj6rRokKCiLyAR2
	yXZvVh7R+vSnjcrLBDAWRQcpY+Az7Rlb3BtRf2AvGDIonLA04YJwdlHHqRx2HmQN3dRr+j4uQY8
	Io/99Agt1cF3Ihqgb3UW9L2IOSOjrTl+B4QrFl5320O/nhnXK52Iyw38rnRpuYkE52xQv5lcubl
	pVBjN5om8lA5+nVBaivCHLX4C4AMFLQDYa+1RAx7eNKGag9XBVapqwn0e4o5epa/LY44TmC2ZJj
	ZbRCGWI6Zg/eMJfMS97jXqY=
X-Received: by 2002:ac8:5f0b:0:b0:54b:5cc6:6036 with SMTP id d75a77b69052e-55d76afed61mr72126961cf.58.1795194893996;
        Fri, 20 Nov 2026 09:14:53 -0800 (PST)
Received: from localhost ([2a03:2880:9ff:68::])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d788116c9sm27280191cf.4.2026.11.20.09.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 09:14:53 -0800 (PST)
Date: Fri, 20 Nov 2026 09:14:49 -0800
From: Stanislav Fomichev <sdf.kernel@gmail.com>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Mina Almasry <almasrymina@google.com>, 
	Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, 
	Bobby Eshleman <bobbyeshleman@meta.com>, Carolina Jubran <cjubran@nvidia.com>, 
	Cosmin Ratiu <cratiu@nvidia.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	David Wei <dw@davidwei.uk>, Erfan Sharafzadeh <erfansh@meta.com>, 
	Gal Pressman <gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, 
	Kaifeng Wang <kaifengw@google.com>, Leon Romanovsky <leon@kernel.org>, 
	open list <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, 
	Matt Fleming <mfleming@cloudflare.com>, Nikolay Aleksandrov <razor@blackwall.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, 
	Stanislav Fomichev <sdf@fomichev.me>, William Tu <witu@nvidia.com>
Subject: Re: [PATCH net-next V2 00/13] net/mlx5e: Add netdev support for data
 direct
Message-ID: <awB_rJxrIDQ3u-73@devvm16445.scu0.facebook.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
 <b5305251-b758-45cf-a28d-406b04d8bccd@nvidia.com>
 <CAHS8izMhSVabXgMmNbHHLm8cYqW_EVQbpXME2z_tUEJuN2BTnA@mail.gmail.com>
 <0a1be802-1c53-46ff-a08c-614c3a2d6f41@nvidia.com>
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
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0a1be802-1c53-46ff-a08c-614c3a2d6f41@nvidia.com>

On 11/20, Dragos Tatulea wrote:
> On 20.11.26 17:38, Mina Almasry wrote:
> > On Fri, Nov 20, 2026 at 6:39 AM Dragos Tatulea <dtatulea@nvidia.com> wrote:
> >>
> >> Hi all,
> >>
> >> On 10.11.26 19:38, Tariq Toukan wrote:
> >> [...]
> >>>
> >>>  .../ethernet/mellanox/mlx5/core/data_direct.c |   9 +-
> >>>  drivers/net/ethernet/mellanox/mlx5/core/en.h  |  14 +
> >>>  .../ethernet/mellanox/mlx5/core/en/params.c   |  18 +-
> >>>  .../ethernet/mellanox/mlx5/core/en/params.h   |   2 +
> >>>  .../mellanox/mlx5/core/en/reporter_rx.c       |   1 +
> >>>  .../mellanox/mlx5/core/en/reporter_tx.c       |   1 +
> >>>  .../ethernet/mellanox/mlx5/core/en_common.c   |  38 ++-
> >>>  .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  67 +++++
> >>>  .../net/ethernet/mellanox/mlx5/core/en_main.c | 253 +++++++++++++++++-
> >>>  .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  33 +--
> >>>  .../net/ethernet/mellanox/mlx5/core/en_tx.c   |   4 +-
> >>>  .../net/ethernet/mellanox/mlx5/core/main.c    |   1 +
> >>>  include/linux/mlx5/driver.h                   |   1 +
> >>>  include/net/netdev_queues.h                   |   1 +
> >>>  include/net/netmem.h                          |  24 ++
> >>>  net/core/devmem.c                             |  85 ++++++
> >>>  net/core/devmem.h                             |   6 +
> >>>  net/core/netdev_queues.c                      |  51 ++++
> >> While working on V3 I realized that keeping the core part in
> >> this series is not the best approach. Initially it made sense
> >> because the change was small.
> >>
> >> I think I should re-spin it in a separate series with netdevsim
> >> based selftests for the new APIs. I would base it on Mina's devmem
> >> leased queues unregister [1].
> >>
> >> Any reason not to?
> >>
> > 
> > I honestly wanted to comment that you should base it on the leased
> > queues series from me but didn't want to be annoying, especially
> > because I made you wait for the previous series.
> >
> I realized that quite a few changes were needed after your series
> so I decided to base it on it.
> 
> > My series creates binding->bind_dev, and binding->map_dev, and core
> > will (should) handle things correctly across both devices. This seems
> > perfect for you, because you have a bind device and a separate map
> > device and their lifetime is different.
> > 
> In my series I am actually skipping leased rx queues in
> net_devmem_unbind_dma_dev() because we need some kind of notification
> mechanism + netkit implementation. I think this should be added later
> if there is a usecase. For now mlx5 simply doesn't support the combo.
> 
> One note on net_devmem_unbind_dmabuf(). Posting it here as I don't
> find the right place to mention in your series:
> 
> @@ -234,8 +234,17 @@ void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding)
>                                 busy = true;
>                 }
>  
> -               if (binding->direction == DMA_FROM_DEVICE && !busy)
> +               if (binding->direction == DMA_FROM_DEVICE && !busy) {
> +                       struct net_device *map_dev = NULL;
> +                       netdevice_tracker dev_tracker;
> +
> +                       /* Leased queue: attachment readers hold map_dev's lock. */
> +                       if (READ_ONCE(binding->map_dev) != binding->bind_dev)
> +                               map_dev = net_devmem_lock_dev(&binding->map_dev,
> +                                                             &dev_tracker);
>                         net_devmem_dmabuf_binding_unmap(binding);
> +                       net_devmem_unlock_dev(map_dev, &dev_tracker);
> +               }
>                 WRITE_ONCE(binding->bind_dev, NULL);
>         }
> 
> map_dev devmem lock is taken to prevent use after free in
> netdev_has_dmabuf_binding() when called in parallel with
> net_devmem_unbind_dmabuf(). As this can happen in my series I added it
> there.
> 
> Waiting for feedback from Stan/Jakub/Paolo for a few more hours and
> will post the series tomorrow.

More and more workloads are moving into ns/netkit setup on our side,
so it would be nice to have netkit support as well. We can start with
what you have so you're not blocked for too long, but we do want the
netkit portion as well :-)
