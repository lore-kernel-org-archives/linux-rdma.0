Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793068430;
	b=WybcSZr92tA8W8R5N0nViEL1hbk/33RqFtAMLSdse1PlBv0lfX5Y/NVf8mIuFuslcoGQ
	 Baopg715sKSULuAdExmCGzHPimacWoSl2SwNUkdp8/XRomLpoPCaw/5dn6Jb3Pki2o3ov
	 MI7/AoLVF4ArXLsD6Ahv5HNuRh23c2epCanjHWqydT45uByNwV/VpVBxC9MaCE0NXEtCT
	 1bvHQi+7wu69EiC8eQqVqwXUXpGkJDEWXKeOhx2vlult+rZ4+jTxi2rauqMoyh3+L2xdL
	 7VNpzso/5xPfLcdtdEu2PRBBehuyukopxPVd/0kVWZlFN2mqytKz4DjW8OtMmROhqkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793068430;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QcyDTcBYepouHcMJ/BglDrUpJfPUc7Jg8wsmAgfQ6eo=;
	b=ySoBWB2ktFYHTKKqoA5EV2NR+Pogpm8M5QEmCnQzWJUJcRY7ABi+plhRDuEzqR0dKfgK
	 vQLUjWKTuihvOpjMywX+MtLielfHE9/lwLwPWKspQuQ0yWh3VULhMQ+kELlv+aLT/owcf
	 RwJDmSE2H5A3v9gbEejQpQlQJQ0B590T+kIiaOCInuyg1JyNOr2VVJmQhfSGXnkUyWbQ3
	 Nlagm704KvJAVWbbgW5ni2LgNBWRfpq7yCLDh1i2x3t4q6FcRDF5UYa7hrjmcxNDzOwr4
	 iYq3TZJ/mz6RRBkWxVgxnDWM/jPl7s8WLw4J1mUJKZFXfAlvQafWExoD0RySBgbkpeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=leegTTfw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37ABA606A31B
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 02:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=leegTTfw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD521F01825;
	Tue, 27 Oct 2026 02:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793068429;
	bh=QcyDTcBYepouHcMJ/BglDrUpJfPUc7Jg8wsmAgfQ6eo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=leegTTfwV2TbWJv0EebC9Idx6WyV3KYKECKr/U2wv7LzetxMqEF84NoG9wfA0w2u8
	 nfe3hRtKpT78WGK3s3hn+Lhhv4fdKkOQfiilzlGdeWpSgNfNzenYfBYdXYwkKys7XG
	 +vWyh5ZzQYWuxBZwvKPBg7RjyKUbq4x5CPCC+5uDuomch55HXdElOYYGiuZKOQqIMN
	 QjQsMDYql5wfYqU8/hTrvJfZVseL4HyUkvo2V5iyiMG6ye0fCZvgZtiSDIhyprhfzi
	 pbAguUnxIuMfcw/3AHrC+uPWOgyq/hrYBwQH+SLN/KgqU3nP7OoHr0Jf7sZ+GdrcSr
	 XKB6xuPaQH/kQ==
Message-ID: <sashiko-outbox-186023@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma v7 7/7] RDMA/zrdma: Implement device and port query
 operations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261027021119.2325798-8-zhang.yanze@zte.com.cn>
References: <20261027021119.2325798-1-zhang.yanze@zte.com.cn>
 <20261027021119.2325798-8-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 02:33:49 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RDMA/zrdma: broken conditional RTNL locking in zxdh_get_drvinfo()
--

commit f5a32e13f5abe916870114665b95d03769a17e3b
Author: Yanze Zhang <zhang.yanze@zte.com.cn>

RDMA/zrdma: Implement device and port query operations

This commit implements RDMA device and port query callbacks, including devi=
ce
attributes, port attributes, PKey, link layer, port immutable data, and
firmware version string extraction for the zrdma driver.

> diff --git a/drivers/infiniband/hw/zrdma/zrdma_verbs.c b/drivers/infiniba=
nd/hw/zrdma/zrdma_verbs.c
> index abac97e694138..ceaad155fc5ae 100644
> --- a/drivers/infiniband/hw/zrdma/zrdma_verbs.c
> +++ b/drivers/infiniband/hw/zrdma/zrdma_verbs.c

[ ... ]

> @@ -352,6 +354,252 @@ static int zxdh_mmap(struct ib_ucontext *context, s=
truct vm_area_struct *vma)
>  	return ret;
>  }
> =20
> +/* Fetch the driver info for @zdev->netdev, or for its first lower device
> + * when it is a bond. The lower device list is protected by rtnl_lock, a=
nd
> + * the core may call this from a netdev notifier that already holds the
> + * lock, so it is only taken when it is not held already.
> + */
> +static bool zxdh_get_drvinfo(struct zxdh_device *zdev,
> +			     struct ethtool_drvinfo *info)
> +{
> +	struct net_device *slave =3D NULL, *dev;
> +	struct list_head *iter;
> +	bool locked;
> +	bool ret =3D true;
> +
> +	memset(info, 0, sizeof(*info));
> +
> +	locked =3D !rtnl_is_locked();
> +	if (locked)
> +		rtnl_lock();
> +
> +	if (zdev->netdev->priv_flags & IFF_BONDING)
> +		netdev_for_each_lower_dev(zdev->netdev, slave, iter)
> +			break;
> +
> +	dev =3D slave ? slave : zdev->netdev;
> +	if (dev->ethtool_ops && dev->ethtool_ops->get_drvinfo)
> +		dev->ethtool_ops->get_drvinfo(dev, info);
> +	else
> +		ret =3D false;
> +
> +	if (locked)
> +		rtnl_unlock();

[Severity: High]
Can this conditional locking in zxdh_get_drvinfo() cause an unlocked
traversal of zdev->netdev->adj_list.lower and a use-after-free on slave when
another task holds rtnl_mutex?

In net/core/rtnetlink.c, rtnl_is_locked() checks whether any task on any cpu
currently holds rtnl_mutex, rather than whether current owns it:

int rtnl_is_locked(void)
{
	return mutex_is_locked(&rtnl_mutex);
}

When zxdh_get_drvinfo() is called through zxdh_query_device() or
zxdh_get_dev_fw_str() while another task on another cpu holds rtnl_mutex
(for example, while unlinking a bonding lower device via
netdev_upper_dev_unlink() or unregistering a slave net_device),
rtnl_is_locked() returns true.

As a result, zxdh_get_drvinfo() skips rtnl_lock() and calls
netdev_for_each_lower_dev() -> netdev_lower_get_next() and
dev->ethtool_ops->get_drvinfo(dev, info) without holding rtnl_mutex, racing
directly with the task modifying the lower device list or tearing down the
slave device.

Since zxdh_get_drvinfo() is only called from process context through
zxdh_query_device() and zxdh_get_dev_fw_str(), neither of which holds
rtnl_mutex, should zxdh_get_drvinfo() unconditionally call rtnl_lock() and
rtnl_unlock()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027021119.2325=
798-1-zhang.yanze@zte.com.cn?part=3D7
