Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08DC369D71
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 23:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791590179; cv=none; b=VxLSjS2cq4FD+O0g6TWnismXJyehNOHqnvnwlGPPw0jTALoO5BMm4xad7QA4VrmUe2Vmhllf76Xh+Y8em6xGDnTW/2SSJ4hEJmjskkL+4Yr1U8tvzzYa/IvzOM3z8MnfStIxt/0yDwI1uOI+FXJmJcYrYhcBJ1D2lA1VqWenNjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791590179; c=relaxed/simple;
	bh=w+EnAGDBTRoV6kGl8ePH2ZmhxNkN1MimLuNeLOhmzDY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gGDLcivbxC92BF/3BR6pirpxF19CoPPwKMkDICAhqlXPW11CGavPrZG2cKEMraEr+R9OMjK234v/jfjBdnxqSu4zm3/Q6mZdvrWrmDZ47nZaV3TZ4/CU7/CVfo+2sY53UbVIEuVAVxtDo0HJEN9+TXCImmaf+ApKEoXBsbILjZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xm+ZqmPx; arc=none smtp.client-ip=74.125.82.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xm+ZqmPx"
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-14fed306427so811369c88.1
        for <linux-rdma@vger.kernel.org>; Fri, 09 Oct 2026 16:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791590177; x=1792194977; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=67OMwYu7X4+eTnAv5rgY2LsEF+yBHbT0zM8irZPKTFA=;
        b=Xm+ZqmPxgFE2t14nkuvH7gQKh6HPcZ0OaqG+2nXnN3GOEbZlyATl4yNbtD+eE6ODeB
         z0Ay+OckFOZ46lRzUYKBbqPf5iZ8FadRRamUlS1tZJ6eUG9T2H53L3YznYbQYFOdkK4n
         vzVu0enIy9faSuKBzzICLl09MPe32Gb4QPY+JIehAh4jNr+OUDml1gp6Rh8Y5g0mM4V4
         LY/i/QkZQ+chXAJnTXhwuPE4Fc85wG5x8YwvO/qlQXe72kkgMwV/qT8t1flVFld+wkeA
         31JyDlv4fpI42iOK2Q5X/5Yv2wBTdjOInFK+8dZBbM6OhhaRCI70LA77UpG85gpy4ak9
         5VrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791590177; x=1792194977;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=67OMwYu7X4+eTnAv5rgY2LsEF+yBHbT0zM8irZPKTFA=;
        b=k2P7HI7xqPg66J/p6SQCAtohkXNk+qH1eIDrYG7+ynjgvoJGhoiaTSn+lKs4YG62Go
         v9in91En420T1ZVOA007qVciTEKnblNRZa1XPjncQlk9KWUfN/d8UenF61blAp0eH+Kj
         N2VwneRV9bU5tQEP892VLPQvWzdPXxPv6TUd7UoMMgc4k3kvWYMKUlgnQbiZKEOR1a6E
         /vjJa+ivDTmcdoOSnNanb/tXbdwY7tCl5Gk/2XZ6IasdfSWep0G/fVjjoUyUGiMIGWga
         acWhgtPJHGKjeDDYapoKGKExL0UmK4X+FxdaYWexy9MkOMhFZDWMU0Bsw7DifCHgP3fo
         02fw==
X-Forwarded-Encrypted: i=1; AKwUvBzJdzrz8XF6kpa8x3EEmujshqKUKg7wxV273JlDlt8iFoaW9bJwRcEk9cCSjP0k3v+j7Bxos9xh/h6l@vger.kernel.org
X-Gm-Message-State: AFq9FYIupns7h25zTk3S5veluD70Qz27spMk+TT70lrVqc4LMgo4m5Mp
	CgSUo7Dca6ZKXSK3BfnEWbPOa/CdTqBBdQeyNV3rwB9oiZhuKqZeeUotkNjnfAOkaQ7R3BaRdLs
	Z7lyC5cuTM9xcaBVvaK8l/8X+wg==
X-Received: from dldz3-n1.prod.google.com ([2002:a05:701b:4183:10b0:165:6e49:2631])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:422:b0:168:3243:c911 with SMTP id a92af1059eb24-16a60ced242mr6217746c88.37.1791590176439;
 Fri, 09 Oct 2026 16:56:16 -0700 (PDT)
Date: Fri,  9 Oct 2026 23:56:15 +0000
In-Reply-To: <20261008132815.654147-9-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261008132815.654147-1-tariqt@nvidia.com> <20261008132815.654147-9-tariqt@nvidia.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261009235615.3825992-1-almasrymina@google.com>
Subject: Re: [PATCH net-next 08/10] net/mlx5e: Recreate netdev channels on
 data direct device unbind
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
	Yue Haibing <yuehaibing@huawei.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 8, 2026 at 6:28 AM Tariq Toukan <tariqt@nvidia.com> wrote:
> From: Dragos Tatulea <dtatulea@nvidia.com>
>
> Note that this does not tear down dmabuf bindings attached to the data
> direct device; the recreated channels will still pick up the binding via
> rxq->mp_params and post DMA addresses from the data direct IOMMU domain
> to the PF, causing IOMMU faults. A devmem revoke hook is needed to close
> those bindings before the switch.

(Note: LLM-assisted review comment below.)

Rather than shipping this known IOMMU fault window on MLX5_DATA_DIRECT_UNBIND,
could we add the core detach helper in patch 09/10 and invoke it here under
netdev_lock(priv->netdev) before mlx5e_safe_switch_params()?

Specifically, reopening channels on the PF without detaching active bindings
leaves three issues:
1. RX: reopened queues pick up stale rxq->mp_params and post data_direct IOVAs
   onto ch->pdev.
2. TX: active TX bindings (net_devmem_dmabuf_bindings) and in-flight or
   retransmitted skbs still hold data_direct IOVAs while mlx5e_xmit() switches
   to sq->mkey_be (ch->pdev).
3. DMA unmap ordering: binding->sgt / binding->attachment stay mapped to
   &dd_dev->pdev->dev until userspace closes all sockets, after
   mlx5_data_direct_remove() has already returned.

If mlx5e_data_direct_event() calls a core helper such as
netdev_unbind_dmabuf_dma_dev(priv->netdev, &dd_dev->pdev->dev) before
mlx5e_safe_switch_params():
- netif_mp_close_rxq() clears rxq->mp_params so reopened channels use host
  page_pool pages on ch->pdev.
- Clearing WRITE_ONCE(binding->dev, NULL) + synchronize_net() causes existing
  validate_xmit_unreadable_skb() (READ_ONCE(binding->dev) != dev) to drop any
  in-flight/retransmitted TX skbs automatically with zero driver fast-path
  changes.
- dma_buf_unmap_attachment_unlocked() + dma_buf_detach() complete synchronously
  before mlx5_data_direct_remove() finishes.

-- 
Thanks,
Mina
