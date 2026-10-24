Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792827512;
	b=xwOjChJ8eJZAWUXsV+FH4jjerQC9mZyLCc0t2Tyv0Hig5XKfzoTjojFooa9ZqePalJw7
	 zRHukapLVFYn8cvFnH6aYFUhOBsbaJ+5YPtadkRDJIOAf701wVod3blXlu3CbRLL3nJVx
	 9Qchm5e/HzeZOJfdlbPB9R/nFbXthDDgFM/86K+UV8nxvPBfFCFXVBqEbj1HLYzzrdODq
	 anHmdYe/3LcA0AH+gRt8evt8yCcCBdrCSA97SDLwZTmYPeM6yTzaDkJjAbaGYqbtKrdHd
	 SSAGRlf+2ueAAPATe8BlYVNvnIdwL0Fe8Cy/PIUzLJP3jn2sd4baBf8EGjUUADsUfdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792827512;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=heQNifP5vkL+EUpiTe4xMYlcUgrYoLQ8351WAJfga94=;
	b=OCimy5n9V9eTevgTH/h3i6ioem1XNtq0kKNuDP+yYqX0zigmv4uJkiFb9s3K7AbXT8zv
	 SXh0eSA0Ay540wWDIXgngJAI+koV1OxMNPTP2tZvB79QB2xC34Mw2ww4cg0vzOgcaLOf6
	 rwG6jZw3MzMyI3sniY3cztKcjFsOvoyae6aq4Yzuhu6ewicfF5CQZWaJ4jMjZr9UpfgQ0
	 NnOt8NWp0s2mtu/p55Xv+7Lu1koXbFX5EU+kJeAew5MqQQ/0ILXDoeS2f88kQWYDAhQdp
	 rP5ztq214OxICpoPYJzVJ5sdhEpJkg+j9MXp+g2fzEBFAG0PYzRyVZw8PvNnhDId+Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S9mSaJAG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C8F606A31A
	for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 07:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S9mSaJAG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579661F01825;
	Sat, 24 Oct 2026 07:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792827511;
	bh=heQNifP5vkL+EUpiTe4xMYlcUgrYoLQ8351WAJfga94=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S9mSaJAGsjGdaLpw9lKvwAdWBOebwiw/26/oaR4NKFmtdXy16/MqdoSKWlO5uJ5eu
	 9pGrDh/zAhQFgaE8kw+rg9zC7+BUw/2rBp6grjwTwripyCgjihYPBYpkGtO8ctSdlV
	 3Bcyc6TqyyrTLcgqtcQmbnuSgho+4QucZi1mmpELYBmnrgxVCZN/jE8id/yBd3qZ5E
	 bWX7xEGzrPUcyhJ2YN4V5pEx7HySpChWl4d49eB5YfGEu6THmx8ZQwGQJkIzLdxrLc
	 wZy6ZhDPRUSAlcqIzlIZqK6xvzpD18zKxc3VP59SHG8NSRqMforwvAxII4bluVIOAe
	 iZUy/e844g/ug==
Message-ID: <sashiko-outbox-183588@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/7] RDMA/zrdma: Add device probe and remove logic
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261024071539.2182864-6-zhang.yanze@zte.com.cn>
References: <20261024071539.2182864-1-zhang.yanze@zte.com.cn>
 <20261024071539.2182864-6-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 07:38:30 +0000
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
- [Medium] RDMA/zrdma: memory leaks on error paths in zxdh_probe()
--

commit 28ece0add9abc6cac3d040b5b5512cf8b3c518c3
Author: Yanze Zhang <zhang.yanze@zte.com.cn>

RDMA/zrdma: Add device probe and remove logic

This commit implements the auxiliary bus probe and remove callbacks for the
zrdma driver, including device initialization, hardware resource setup, and
IB device registration.

> diff --git a/drivers/infiniband/hw/zrdma/zrdma_main.c b/drivers/infiniban=
d/hw/zrdma/zrdma_main.c
> new file mode 100644
> index 0000000000000..5127e56fd1642
> --- /dev/null
> +++ b/drivers/infiniband/hw/zrdma/zrdma_main.c
> @@ -0,0 +1,294 @@

[ ... ]

> +static int zxdh_probe(struct auxiliary_device *aux_dev,
> +		      const struct auxiliary_device_id *id)
> +{
> +	struct zxdh_auxiliary_dev *zxdh_adev =3D
> +		container_of(aux_dev, struct zxdh_auxiliary_dev, adev);
> +	struct zxdh_handler *hdl;
> +	struct zxdh_device *zdev;
> +	struct zxdh_pci_f *rf;
> +	struct net_device *netdev;
> +	int err;
> +
> +	if (!zxdh_adev->rdma_ops || !zxdh_adev->rdma_ops->get_rdma_netdev) {
> +		pr_err("zrdma: rdma_ops or get_rdma_netdev is NULL\n");
> +		return -EINVAL;
> +	}
> +
> +	netdev =3D zxdh_adev->rdma_ops->get_rdma_netdev(zxdh_adev->parent);
> +	if (!netdev) {
> +		pr_err("zrdma: failed to get netdev\n");
> +		return -ENODEV;
> +	}
> +
> +	zdev =3D ib_alloc_device(zxdh_device, ibdev);
> +	if (!zdev)
> +		return -ENOMEM;
> +
> +	zdev->zxdh_adev =3D zxdh_adev;
> +	zdev->netdev =3D netdev;
> +
> +	zdev->rf =3D kzalloc_obj(*zdev->rf);
> +	if (!zdev->rf) {
> +		ib_dealloc_device(&zdev->ibdev);
> +		return -ENOMEM;
> +	}
> +
> +	zxdh_fill_device_info(zdev, zxdh_adev->zxdh_info);
> +
> +	hdl =3D kzalloc_obj(*hdl);
> +	if (!hdl) {
> +		ib_dealloc_device(&zdev->ibdev);
> +		return -ENOMEM;
> +	}
> +
> +	hdl->zdev =3D zdev;
> +	zdev->hdl =3D hdl;
> +	zdev->netdev_speed =3D SPEED_UNKNOWN;
> +
> +	rf =3D zdev->rf;
> +	err =3D zxdh_ctrl_init_hw(rf);
> +	if (err)
> +		goto err_ctrl_init;
> +
> +	err =3D zxdh_ib_register_device(zdev);
> +	if (err)
> +		goto err_ib_reg;
> +
> +	/* Publish the handler only after the device is registered, so a
> +	 * failed probe cannot leave a freed handler on the global list.
> +	 */
> +	zxdh_add_handler(hdl);
> +
> +	dev_set_drvdata(&aux_dev->dev, zdev);
> +
> +	return 0;
> +
> +err_ib_reg:
> +err_ctrl_init:
> +	ib_dealloc_device(&zdev->ibdev);
> +
> +	return err;
> +}

[Severity: Medium]
Does zxdh_probe() leak zdev->rf, hdl, and the hardware resource buffers on =
its
error paths?

When kzalloc_obj(*hdl) fails, zxdh_probe() calls
ib_dealloc_device(&zdev->ibdev) and returns -ENOMEM without freeing zdev->rf
or destroying zdev->ah_list_lock initialized in zxdh_fill_device_info().

Similarly, zxdh_ctrl_init_hw() -> zxdh_initialize_hw_rsrc() allocates
rf->qp_cnt_8k_idxs and rf->mem_rsrc with vzalloc():

drivers/infiniband/hw/zrdma/zrdma_hw.c:zxdh_initialize_hw_rsrc() {
	...
	rf->qp_cnt_8k_idxs =3D vzalloc(rf->max_8k_idx * sizeof(u32));
	if (!rf->qp_cnt_8k_idxs) {
		ret =3D -ENOMEM;
		goto mem_8k_qp_cnt_vmalloc_fail;
	}

	rsrc_size =3D zxdh_calc_mem_rsrc_size(rf);
	rf->mem_rsrc =3D vzalloc(rsrc_size);
	...
}

If zxdh_ctrl_init_hw() or zxdh_ib_register_device() fails, jumping to
err_ctrl_init or err_ib_reg only calls ib_dealloc_device(&zdev->ibdev),
leaking hdl, zdev->rf, rf->qp_cnt_8k_idxs, and rf->mem_rsrc.

Later in the series, commit 42854f9bc8b3 ("RDMA/zrdma: Implement context, P=
D,
and mmap operations") wires up zxdh_ib_dealloc_device() as .dealloc_driver =
in
zxdh_dev_ops. However, ib_set_device_ops(&zdev->ibdev, &zxdh_dev_ops) is on=
ly
called inside zxdh_ib_register_device() -> zxdh_init_rdma_device() after the
roce_mode check. If zxdh_probe() fails at the hdl allocation, during
zxdh_ctrl_init_hw(), or before ib_set_device_ops() is reached,
zdev->ibdev.ops.dealloc_driver is still NULL when ib_dealloc_device() runs,=
 so
zxdh_ib_dealloc_device() will not be called to clean up those allocations
(and hdl is not freed by zxdh_ib_dealloc_device() either).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261024071539.2182=
864-1-zhang.yanze@zte.com.cn?part=3D5
