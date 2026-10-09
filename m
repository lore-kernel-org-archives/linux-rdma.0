Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D3B4DE71A
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 13:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791552668; cv=none; b=dxAS5yv99hgBGEdmcEUPFeJoeoDluJoO+rLpzSMBNCBEtPmuBg4W+LLk4xFsQmzu+RIVqikxJYr+2O50X04mmykZkxwAUr1evyIykVYjExVk5WsJMgtpvV+h7BbkfmoM+QOF/41oCeeAmRuYUtTXdp1L/JpAi1OSj7EKKj9oa6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791552668; c=relaxed/simple;
	bh=lrRzdCPOlGUolRfzMWQGBEIXeN5ccMnr3a4ac3FKIrs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=LfVPeGUVXEw/sVOmC97b5dl5XzU3Llx3CcxkjFnNPJEuVFCb9mdAaj4janhjWbWIaQUdU/EaAZao3W1vmIbj//IpvmdP+llU+D2lKsh5zWHsGRl1wSKdIC8G1Ou6sKjQZcCDike2GXPAzlNk7122edQfm6PKsyQqJLxssN/bsDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pl45mnWv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pl45mnWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A941F00898;
	Fri,  9 Oct 2026 13:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791552667;
	bh=JW7ybw9RnhSfuseSM33PBw41ET3d1N2/iJm+JymQ16s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Pl45mnWv/PRoNER63lqqL8So+S7q4F4PHhX19X2Drn/eu8a+2/Lf8sI4CtmyWDVw2
	 wvNLYcvNMW8sTcjqXrPIGqPKUGYr3duhnWbHnBijlM60VGf7HC93BaJFLvbf9c7c0p
	 yHc2n5UncXTn50zKCOEPk6CzykT/MXGtlQ1aAqgKzwk9xsc1y6Ai+hWSEB9BhH3idH
	 POCeiBtuZV1qQ4mAp2O+kBfUf6n1bKItSWLT3Bd45+o2bLBZ0Ek/NiWM3GsbZpkWw+
	 q3nEqmC8dqw02MRFkpmvyxvX1CxW+C7NGXb5CeqDdVoN0/u/DC25MK2YYy0wYZyJ7n
	 xVFPRVEF3eLoA==
Message-ID: <sashiko-outbox-165643@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 09/10] net: devmem: add
 netdev_has_dmabuf_binding() helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008132815.654147-10-tariqt@nvidia.com>
References: <20261008132815.654147-1-tariqt@nvidia.com>
 <20261008132815.654147-10-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 13:31:06 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net: UAF in netdev_nl_sock_priv_destroy() via dangling TX dmabuf b=
inding
--

commit 40bdbb4bbbf641843a6898fd459c6b04de1f14f3
Author: Dragos Tatulea <dtatulea@nvidia.com>

net: devmem: add netdev_has_dmabuf_binding() helper

Currently there is no way to check whether a dmabuf is bound on a TX queue.
To help with that, add a helper to check whether a devmem dmabuf binding may
still be in use on a given netdev. A new list is introduced to track bindin=
gs
for their whole lifetime.

> diff --git a/net/core/devmem.c b/net/core/devmem.c
> index 07c62e2e3088c..173d66d1cb6e2 100644
> --- a/net/core/devmem.c
> +++ b/net/core/devmem.c
[ ... ]
> @@ -357,6 +368,25 @@ struct net_devmem_dmabuf_binding *net_devmem_lookup_=
dmabuf(u32 id)
>  	return binding;
>  }
> =20
> +bool netdev_has_dmabuf_binding(struct net_device *dev, struct device *dm=
a_dev)
> +{
> +	struct net_devmem_dmabuf_binding *binding;
> +	bool found =3D false;
> +
> +	spin_lock(&net_devmem_live_bindings_lock);
> +	list_for_each_entry(binding, &net_devmem_live_bindings, live_list) {
> +		if (dev =3D=3D READ_ONCE(binding->dev) &&

[Severity: High]
Can this lead to false positive matches and a use-after-free if the underly=
ing
net_device is freed?

Looking at the lifecycle of TX dmabuf bindings, binding->dev is cached duri=
ng
net_devmem_bind_dmabuf() without holding a reference. However, there is no
unregister hook to clear binding->dev for TX bindings when the device is
unregistered.

If a user creates a TX binding on a virtual network device, unregisters the
device, but keeps the netlink socket open, binding->dev becomes a dangling
pointer.

If the slab allocator reuses this freed memory address for a new device, wo=
n't
this dev =3D=3D READ_ONCE(binding->dev) check match the wrong device and re=
turn a
false positive?

Additionally, when the netlink socket is eventually closed,
netdev_nl_sock_priv_destroy() will iterate over the socket's bindings and
attempt to hold a reference to the device:

netdev_nl_sock_priv_destroy()
    ...
    netdev_hold(dev, &dev_tracker, GFP_KERNEL);

Will this result in a use-after-free on the freed device memory?

> +		    (!dma_dev || binding->attachment->dev =3D=3D dma_dev)) {
> +			found =3D true;
> +			break;
> +		}
> +	}
> +	spin_unlock(&net_devmem_live_bindings_lock);
> +
> +	return found;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008132815.6541=
47-1-tariqt@nvidia.com?part=3D9
