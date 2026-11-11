Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794433585;
	b=Ff32U3e1++ImVchDRAKBynkym2MzX/kQwMxma/8VFw2OXUM+6VRY1Mx5gjOQKt95Md+/
	 gp3+eUqOJXV8A8nvZAJsGNmv7lJxO4pIhS2zwhwXXjpiq62V6YilBq/WRFsj7jNKLM/6m
	 lvCKAcx0xwUngjZerjkhFvo/N+8D3WEfJqjcTQvPsE1atVG2nZzvvtT24nh/qyoU5m8z/
	 5VGT7jSbhGBqMNXSWk78WYw1TkssJZ/w7KDi5SvELK04xpkMh0N0mQWQXlTStoHLEY3KQ
	 0n/3gfO2QA54Ay7sVwKysPC9RO4rLuMmqZvRvK00HE05rEdtbk3XULL82uH9LUSbvzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794433585;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Bn/IuH8puJguqpDa5kmTTntls8rnsQ/IRNg4aGISG5k=;
	b=UvAsHbJiHfbywAGfu9BI7hgovVXpTkU7OFoIKlbYT+eH9LRWxitaOs4Nvwj8zjabOjpS
	 c8xzC2F70B6/Ty0FtSFtZi1aCNNr0QLT4lgpTLxpxyEhqMxP0cJgxwCT4T27V17xzL52y
	 aLDFryKZIw6oXQaVoxezhnwcJX9gxgbznpd/g+s8GBZq2ruPob/5nbVxyLwtK7Xrgq173
	 MTpuOIpFUgvDQl1tMafLW0CsJvb3ctVdwHgJ/oY1QpXQfbdfn9MCpOAT2XAQhqEgUdwSt
	 aqPQpIc/eMUwfbjkZH+JCjgEvE274ILRJUEFd5cWyUdOcxDKi37btLUnWChU0HjJ7rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jFi1bM75;
	arc=none smtp.remote-ip=74.125.229.5
Received: from mail-dy2-f5.google.com (mail-dy2-f5.google.com [74.125.229.5])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F7E606A321
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 21:46:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60F7E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jFi1bM75
Received: by mail-dy2-f5.google.com with SMTP id 5a478bee46e88-36caa19b0ffso2226792eec.0
        for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794433584; x=1795038384; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Bn/IuH8puJguqpDa5kmTTntls8rnsQ/IRNg4aGISG5k=;
        b=jFi1bM75O8kdx8AOApDpXo4TIMOuvEQfJRet5WygZXfXP5PmCqTzGg2c41ne34+aW2
         4q5ELFq+Thob7N6LqY8n5NCbIO/rVT4cyHu3OyEFjdgMD8UxuMV1eRc1sWkkNsBffeVo
         UmjfhDQyqrrZ7S6JTr6o/MkllBl+R5O5oIZ2/MNDweQdsAtK8ijlylfHKW9cDZzg80u+
         mQGKEfbCj+8sho1K+5iRyGswRqAYqOX4aRD9WkKk1GXE+OGV50vqooJCqzpNMxbxx0Sf
         SuHoUuDv4zYZM5WuDB0NXzJjkTRkrCqwgXYcwyRk4D+Iz7am7moHfSgFDINggUfImQIO
         qi2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794433584; x=1795038384;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Bn/IuH8puJguqpDa5kmTTntls8rnsQ/IRNg4aGISG5k=;
        b=ksvE3jX5oqMG9Wf3G+i5tIM/SDGjmxPeJTLWf2brO7vpaISvC/Si1Z4dgi3aSlHuNk
         3HbQsX5NjN4NjJ/hfV1yljokVI7UWe39aOVwkvipGrpGG3kB7LNAZcQk//S6tUFs8867
         hrWW9GSaoXoP77cRJdhXWIUOF1DF7p1+dQbW2A13a80059MmZKWuDppWe8wEDro77hhP
         jR2P5y9ZMTiWzHHGR1OwripXs3wFvKi5ppk9cj0fEcOzMWSsnr5/EKPy/t5ehtmby1Gn
         2RvXk0FK7nwPjHZy0ypbAEE2psr2d+iZzQTNGgRtDJJs5WRSvJ32cwiOI3F1b4GLymri
         02FQ==
X-Forwarded-Encrypted: i=1; AL+hErHKRWS1OvjnvNnWNNjHuxgEmHlzgyIxa4+/NJcA7I2BQPywfnndhsSG+eUPXl1e4XRb5UwXukHtePeh@vger.kernel.org
X-Gm-Message-State: APuU4Z8NsFK2JQITD0FeyqRsWrwQ8BweJ6LInY7WUUUh0fx1DfZ6PRcf
	wwE9rGWgE4/HyctQL+UfrIIfIvOWFc5qFxBWJqQJEULnNre1esx6GAgh
X-Gm-Gg: AYBFou3MsDOO+HiYgtgfAw1ZOaKj4Q+wYAqMiy8wY9ZHndUhfcR7obSWo4zm5BYV5NO
	n4mLA1BHZqZ36sfqR+Ltx2Ik7dvj5LyjbhQexwHJTfaB9ff3QavXfu+8Mza+PoyM7SQJGIKJtrL
	1PXdrh6dEeWfmqjOhUaHxmE48tbcdl+5MoPxH0+DB1j5TCrPbyMAsB2XP4t/gqvV+gr6A6daei0
	UaGZUym7JU+UyKqvC+w7paQEqQXasUNgokhVJNQHmyrgPIJ4XhTcXMEzGVpDEIMXwuXtM9m6SF+
	Hou2tShed8Cppytu1R5tP4d77DNL9b+5uzc49PCQdwm45QLcjY47dTIyRQuxzQt9ROD9hVgxAp9
	HYIB7s2RabuKgR2G1r7P8Upzj7oSy3DQOPLHb8a7HYVvIKCCj0eqfjdhbrDEo78JlA2ZykfbLs7
	c/HJ1gi/dPiczaaZzXEwVlX4m/NZhTr6Yoollz4AWmajU9vUQ3E0Sx1flxBgR14gB7CuS2b65Ql
	CleioNbOSpwM4rY36OwO1/CkxWfyTt1vNOg56Ga48IY4TMeynAycpz9uWbAyX1Xx18iEOX82uSd
	dlcuQeK5OAXb+I6rf+fcQd6VjA1SfVxZfMlBLe9himBd
X-Received: by 2002:a05:7022:3b84:b0:147:8a40:cdf3 with SMTP id a92af1059eb24-1b3c031b07bmr3568513c88.24.1794433584029;
        Wed, 11 Nov 2026 13:46:24 -0800 (PST)
Received: from localhost ([2a03:2880:9ff:6a::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b1003fsm17414257c88.6.2026.11.11.13.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 13:46:23 -0800 (PST)
Date: Wed, 11 Nov 2026 13:46:19 -0800
From: Stanislav Fomichev <sdf.kernel@gmail.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, 
	Bobby Eshleman <bobbyeshleman@meta.com>, Carolina Jubran <cjubran@nvidia.com>, 
	Cosmin Ratiu <cratiu@nvidia.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	David Wei <dw@davidwei.uk>, Dragos Tatulea <dtatulea@nvidia.com>, 
	Erfan Sharafzadeh <erfansh@meta.com>, Gal Pressman <gal@nvidia.com>, 
	Jacob Keller <Jacob.e.keller@intel.com>, Kaifeng Wang <kaifengw@google.com>, 
	Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, 
	Matt Fleming <mfleming@cloudflare.com>, Mina Almasry <almasrymina@google.com>, 
	Nikolay Aleksandrov <razor@blackwall.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	Simon Horman <horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, 
	William Tu <witu@nvidia.com>, Bobby Eshleman <bobbyeshleman@gmail.com>
Subject: Re: [PATCH net-next V2 10/13] net: devmem: add
 netdev_has_dmabuf_binding() helper
Message-ID: <avTdfAaW9tlBRM34@devvm16445.scu0.facebook.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
 <20261110183826.2927274-11-tariqt@nvidia.com>
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
In-Reply-To: <20261110183826.2927274-11-tariqt@nvidia.com>

On 11/10, Tariq Toukan wrote:
> From: Dragos Tatulea <dtatulea@nvidia.com>
> 
> Currently there is no way to check whether a dmabuf is bound on a TX
> queue. RX side has netif_rxq_has_unreadable_mp() which gives a hint
> of it.
> 
> To help with that, add a helper to check whether a devmem dmabuf
> binding may still be in use on a given netdev, optionally filtered by
> the DMA device the dmabuf was mapped against.
> 
> A binding can outlive the user's unbind: it can still be referenced by
> in-flight TX skbs, whose DMA mappings are only valid for the device the
> dmabuf was attached to. Reporting such a binding as gone would let a
> driver swap the DMA device out from under those skbs. Bindings stay in
> the bindings xarray until they are freed, so walk it and report every
> binding of the netdev that is still mapped. Bindings that were already
> unmapped are not reported.
> 
> This API is necessary for the upcoming support of data direct in mlx5e.
> 
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Cc: Bobby Eshleman <bobbyeshleman@gmail.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  include/net/netmem.h | 24 ++++++++++++++++++++++++
>  net/core/devmem.c    | 43 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 67 insertions(+)
> 
> diff --git a/include/net/netmem.h b/include/net/netmem.h
> index fb693bc1702a..35bb6fa0f719 100644
> --- a/include/net/netmem.h
> +++ b/include/net/netmem.h
> @@ -397,16 +397,40 @@ static inline unsigned long netmem_get_dma_addr(netmem_ref netmem)
>  	return netmem_to_nmdesc(netmem)->dma_addr;
>  }
>  
> +struct net_device;
> +
>  #if defined(CONFIG_NET_DEVMEM)
>  static inline bool net_is_devmem_iov(const struct net_iov *niov)
>  {
>  	return niov->type == NET_IOV_DMABUF;
>  }
> +
> +/**
> + * netdev_has_dmabuf_binding - is there a dmabuf binding for a
> + * given @dev and @dma_dev
> + *
> + * @dev: netdev to check bindings
> + * @dma_dev: dma device to check, when NULL it will not be checked
> + *
> + * A binding is reported for as long as it is mapped, which can be long
> + * after the user unbound it: net_iovs of a TX binding can still be queued
> + * in flight, with DMA mappings that are only valid for the device the dmabuf
> + * was attached to.
> + *
> + * Return: true if a binding is found under @dev and possibly @dma_dev
> + */
> +bool netdev_has_dmabuf_binding(struct net_device *dev, struct device *dma_dev);
>  #else
>  static inline bool net_is_devmem_iov(const struct net_iov *niov)
>  {
>  	return false;
>  }
> +
> +static inline bool netdev_has_dmabuf_binding(struct net_device *dev,
> +					     struct device *dma_dev)
> +{
> +	return false;
> +}
>  #endif
>  
>  void net_iov_inc_ref(struct net_iov *niov);
> diff --git a/net/core/devmem.c b/net/core/devmem.c
> index 5c7d9640e9d1..dd3987bbd9f6 100644
> --- a/net/core/devmem.c
> +++ b/net/core/devmem.c
> @@ -513,6 +513,49 @@ struct net_devmem_dmabuf_binding *net_devmem_lookup_dmabuf(u32 id)
>  	return binding;
>  }
>  
> +/* The attachment is cleared once the binding has been unmapped. */
> +static bool
> +net_devmem_binding_mapped_to(struct net_devmem_dmabuf_binding *binding,
> +			     struct device *dma_dev)
> +{
> +	lockdep_assert_held(&binding->lock);
> +
> +	return binding->attachment &&
> +	       (!dma_dev || binding->attachment->dev == dma_dev);
> +}
> +
> +bool netdev_has_dmabuf_binding(struct net_device *dev, struct device *dma_dev)
> +{
> +	struct net_devmem_dmabuf_binding *binding;
> +	unsigned long xa_idx;
> +	bool found = false;
> +
> +	netdev_assert_locked(dev);
> +
> +	/* A binding stays in the xarray until it is freed. binding->dev is
> +	 * only cleared under the instance lock of that netdev, and the free
> +	 * takes it before erasing the binding, so a binding found under @dev
> +	 * stays alive while the xarray lock is dropped.
> +	 */
> +	xa_lock(&net_devmem_dmabuf_bindings);
> +	xa_for_each(&net_devmem_dmabuf_bindings, xa_idx, binding) {
> +		if (READ_ONCE(binding->dev) != dev)
> +			continue;
> +
> +		xa_unlock(&net_devmem_dmabuf_bindings);
> +		mutex_lock(&binding->lock);
> +		found = net_devmem_binding_mapped_to(binding, dma_dev);
> +		mutex_unlock(&binding->lock);
> +		xa_lock(&net_devmem_dmabuf_bindings);

Sorry, my cache is already empty after c4466d2c3e77.. I wonder if it would
be easier to change kfree(binding) to kfree_rcu(binding, ...) and then
we can rcu_lock/xa_for_each here without xa_lock/mutex? All we care is our
netdev bindings, and these are not being changed as long as we
hold the instance lock (but the other ones are now concurrently freed,
hence rcu so we can safely do READ_ONCE on the binding)..

And then the same applies to path 11?

(trying to keep all the complexity in net_devmem_dev_unregister)
