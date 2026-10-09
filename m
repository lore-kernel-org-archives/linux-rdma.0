Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19DF496D40
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 23:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791590183; cv=none; b=PfaynRpOS70gbcvgv3Yzzw8k/U4YkPOzOLdnTaRM4mKrXP+Ceb0sONN3f98PEE+XFsvmzk/dboCEVAx5w2QGVLPPyKdGeWeYz2yAzBhj2fTzr8iuhm5opTknzxGn8tLvuhxuiqZUcqtCEpCO4bXr5mxRkaNsflMl5OKacdMo88g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791590183; c=relaxed/simple;
	bh=HJjEutuWqmXwhqtRudU4Sn1MORYvdSadpDAAbYlfYkA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OcCtqvbMPfenEepnym6oDoPQ7hKAzpL8Qt99a7ilplWf4dGhVEFwfODrclYiwURkhX7R2/YDIl6AVY+7Zg63J11sYDKvB9hh9QtsjYl0WZC8a2rA9PJFzD8bdUyhEYS6bmXQRbwJ1cb4mAUdWcjLOQksPYGK7rfOjY0OAdR+FsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dNmkwgJa; arc=none smtp.client-ip=74.125.82.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dNmkwgJa"
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-30bcb065bfdso490456eec.0
        for <linux-rdma@vger.kernel.org>; Fri, 09 Oct 2026 16:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791590181; x=1792194981; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5XaFCfc03yewNn7fG/JQ4ITn5aqHWRNRq1VQ5fsL4bc=;
        b=dNmkwgJaOAI3I7IqA6yrgLVhuOpKVxymOSmaW41dXnQkHu/BV3mTV5AB4F3xXu047D
         X6PK5khqhflvkQlAlrF2XVmsvFJf7DM5xRZbTqwTUwIfSP7LXKgRFXHxScdwh6aBWL/p
         k72lT8bUUPVvpCj/VBgJfGJ63ooXOf6VzgrNFm1N0vGkdNb+YU4qPqsz1dNRUFR3yD1s
         21a8l4j+c7A+GjeVL817QXX8x3IfLcY2/DoZ8sRq6DG3trOYo9NwZlpHcVDclgRy5wkG
         t2J9JNI/ZbwW081xCy2Z2YMuiinqcQlhtJO00pdCrdwQ9bi8FHwCxSg6eB+NflcJldHH
         4aqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791590181; x=1792194981;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5XaFCfc03yewNn7fG/JQ4ITn5aqHWRNRq1VQ5fsL4bc=;
        b=OrOH7X3rIqWMvcqOmtr6V7aAry0oVnZcJfx2h/tArTCioGg0JKm1EuuxS0WIPQs7s4
         uhNkbcR+vrijk/GferRNCSwy6FjNYwuOOgiFQTi2+/ZZ3ItYkv1GjWl24kb0ozIIxj7Q
         q5ot/M084lxb0xU4HOyBxlUu4vtqUJ4rzhxT9cRLbcPte4UVOqM/OYAVwsbHfYe4aqe7
         N0g2y63oyeYhhE3C+JOeFI1p6Rmem+TauOnzpXQq+FHGw0a73yZ3+v8JRMqZGMOacpoe
         I4Qgl34dng/o8mkKetX5+9yks/SCXl7jvVlgdSJyeUFqH/kCumXU6G6EyAlaBGZ/sRj/
         hLxg==
X-Forwarded-Encrypted: i=1; AKwUvBxjSDAv/tLaV3/EtyYQg8cK+7MoVqWH0Ktgx2mlPpSYfS4dJMosDt/gxn+F54Q2fYlhWYiEtintjeYe@vger.kernel.org
X-Gm-Message-State: AFq9FYLi2pmb0Q2j+Tj8Zyq44KL8PbQD4QCRSHnfTOD31pLHVjDBW8e3
	7coi+wcJWoBD9WpT8og9U1tqn9TblK3QDJfGoJql2p4BXD9xRg14F2Rk2cxIN12NpYaXMzgLgOU
	3KHcu8DMdEHBUnYpFEjux4loX5A==
X-Received: from dyz18.prod.google.com ([2002:a05:693c:4092:b0:34d:46b2:7513])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:f582:b0:353:5ae1:b0f5 with SMTP id 5a478bee46e88-3537e101bf0mr4196027eec.26.1791590180476;
 Fri, 09 Oct 2026 16:56:20 -0700 (PDT)
Date: Fri,  9 Oct 2026 23:56:19 +0000
In-Reply-To: <20261008132815.654147-10-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261008132815.654147-1-tariqt@nvidia.com> <20261008132815.654147-10-tariqt@nvidia.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261009235619.3826575-1-almasrymina@google.com>
Subject: Re: [PATCH net-next 09/10] net: devmem: add netdev_has_dmabuf_binding()
 helper
From: Mina Almasry <almasrymina@google.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Mina Almasry <almasrymina@google.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, 
	Bobby Eshleman <bobbyeshleman@meta.com>, Byungchul Park <byungchul@sk.com>, 
	Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, 
	Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, 
	Jacob Keller <Jacob.e.keller@intel.com>, Kees Cook <kees@kernel.org>, 
	Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, 
	Matt Fleming <mfleming@cloudflare.com>, Nikolay Aleksandrov <razor@blackwall.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shivaji Kant <shivajikant@google.com>, 
	Simon Horman <horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, 
	Stanislav Fomichev <sdf.kernel@gmail.com>, William Tu <witu@nvidia.com>, 
	Yue Haibing <yuehaibing@huawei.com>, Bobby Eshleman <bobbyeshleman@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 8, 2026 at 6:28 AM Tariq Toukan <tariqt@nvidia.com> wrote:
> From: Dragos Tatulea <dtatulea@nvidia.com>
>
> A binding can outlive its xarray slot: it can still be referenced by
> in-flight TX skbs, whose DMA mappings are only valid for the device the
> dmabuf was attached to. Reporting such a binding as gone would let a
> driver swap the DMA device out from under those skbs. For this reason,
> track bindings for their whole lifetime on a new list.

(Note: LLM-assisted review comment below.)

Two suggestions on the core design here:

1. Add a synchronous DMA detach helper (e.g. netdev_unbind_dmabuf_dma_dev(d=
ev,
   dma_dev)) alongside netdev_has_dmabuf_binding() so patch 08/10 can clean=
ly
   tear down active bindings on MLX5_DATA_DIRECT_UNBIND:
   - Separate DMA mapping lifetime (ends synchronously when queues stop and
     dev/vdev/dma_dev goes away) from CPU net_iov lifetime (ends in
     __net_devmem_dmabuf_binding_free() when binding->ref hits 0).
   - For bindings matching (dev, binding->attachment->dev =3D=3D dma_dev), =
close
     bound RX queues (netif_mp_close_rxq()), erase binding->id from
     net_devmem_dmabuf_bindings, clear WRITE_ONCE(binding->dev, NULL) /
     WRITE_ONCE(binding->vdev, NULL), call synchronize_net(), and unmap/det=
ach
     binding->sgt and binding->attachment synchronously (setting them to NU=
LL
     so __net_devmem_dmabuf_binding_free() skips them later).
   - Note: core devmem also has a pre-existing bug on physical/virtual
     NETDEV_UNREGISTER where mp_dmabuf_devmem_uninstall() and TX bindings l=
eave
     dma_buf mapped past pci_driver->remove() and TX bindings leave
     binding->dev / binding->vdev dangling; sharing a single core detach
     helper solves both cleanly with zero new fields in
     struct net_devmem_dmabuf_binding.

2. Once detach (and net_devmem_unbind_dmabuf() on TX unbind) clears
   WRITE_ONCE(binding->dev, NULL), runs synchronize_net(), and unmaps
   binding->sgt synchronously, any binding already erased from
   net_devmem_dmabuf_bindings is already DMA-unmapped and rejected by
   validate_xmit_unreadable_skb() (READ_ONCE(binding->dev) !=3D dev). That
   eliminates the need for net_devmem_live_bindings_lock / live_list =E2=80=
=94
   iterating net_devmem_dmabuf_bindings under netdev_lock(dev) suffices for
   both netdev_has_dmabuf_binding() and netdev_unbind_dmabuf_dma_dev().

--=20
Thanks,
Mina
