Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793712015;
	b=n8+AV/KBoTWoRsvgWhWrik3bg946p5VL1W1IMtgpCVTm+dnJNjx7ntIvo3OXhjYCW0PH
	 7bk7IN4hShhdYd8xHVToEKY+5pTu3IxlDvyydzccVqgXXueKpx4iH28Cqp1m5RTtHAQVt
	 q9DayRSmz3GxvBLKNyIpKYeb1s7iFwNFE/hl+DBVoX2RPo7okXktGBQ5I0DgOgarjisOG
	 XvvRqlq0NQP5cZFqG/3o3cUvudiOp81nzZh4HDJa+EvqyKXkQPXEHKsWnXDVYR7Syofox
	 u6zeHiNInwW40qCozJ8zcKW5ewQ3EIZYdF34L2ei7hyHJAbGmZJj6mApIRPJbBJfcqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712015;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZDWxII4sFEZsrJTt8hfl8dfcMHNq9pW03ucmp4/u90Q=;
	b=3OinCyPHBISPasvDrBSVxkTUSfVeBLwmJusupgj8CIlvt83XoxkcaBCfpWUHraroLdH+
	 gW7ogGOQdgY+/DNfj2UDxOK7nNk2XwH61sOPnFn9RbIsMI+SDRCkOLVCg/RZ9Ew8jAi2I
	 ntRN/dGjHJr9XxaDw8gv0svZLlgyCNlxrta55aRNpdSk3DrHQgDRgocCxqij4/lSG56as
	 q7vc1mTJSQjZhaz+oOYYLHTUdB18zHWXeAzDoG0d1gqDNFwNVhw6WCaGqFvul4sSgvelH
	 O6p/V5riY8+qM++NxZMbMYlYtfERMBvNI0jWEfGzB2uT5NxSxJp2S3+tv9uZkA8Gj6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GFWk6oJD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A37F606A339
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 13:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GFWk6oJD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD521F00A02;
	Tue,  3 Nov 2026 13:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793712015;
	bh=ZDWxII4sFEZsrJTt8hfl8dfcMHNq9pW03ucmp4/u90Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GFWk6oJDRODIONfYxW7ovfwmNidoYQOOA03SVdcrajQMw7254zr+KTFGpr9+RLCO7
	 le3329IGNwX+eJOGlBlRZMX1VYj7svt//oUL1fX+PfVJrwvCE0sXuyf+VHXq55mFFD
	 ZfTJ6Z6le29SnElJ0V+UGWA4VNO+O8+zy2TlSs4bVvCJCGY4M/PQpTSXlRV/YNPtIm
	 3XOQDtKsD/6m1VN/00DJDZcddhn8zNiMGnqHsGQ8CynWE+jwB8qdlXY6JhzM6t3LV6
	 1nA4ngjmRiUAfIsAtVbufmKWY7iLPUCGxFaBzbtesiZJwKZyFvyvaqlEEWao1uoXF9
	 DgELZraiKL3OA==
Message-ID: <sashiko-outbox-195324@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma v9 1/7] RDMA/zrdma: Add build infrastructure and
 module skeleton
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103125654.2707069-2-zhang.yanze@zte.com.cn>
References: <20261103125654.2707069-1-zhang.yanze@zte.com.cn>
 <20261103125654.2707069-2-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 13:20:14 +0000
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
- [Low] RDMA/zrdma: open-coded zrdma_module_init() instead of module_auxili=
ary_driver()
--

commit 752d6c4a965c859c6d742178ece9515bf23454aa
Author: Yanze Zhang <zhang.yanze@zte.com.cn>

RDMA/zrdma: Add build infrastructure and module skeleton

This commit adds the MAINTAINERS entry, Kconfig, Makefile, and a minimal
auxiliary driver module skeleton for the ZTE DingHai RDMA driver.

> diff --git a/drivers/infiniband/hw/zrdma/zrdma_main.c b/drivers/infiniban=
d/hw/zrdma/zrdma_main.c
> new file mode 100644
> index 0000000000000..80856c7ff6b2a
> --- /dev/null
> +++ b/drivers/infiniband/hw/zrdma/zrdma_main.c

[ ... ]

> +static struct auxiliary_driver zxdh_auxiliary_drv =3D {
> +	.name =3D "rdma_aux",
> +	.id_table =3D zxdh_auxiliary_id_table,
> +	.probe =3D zxdh_probe,
> +	.remove =3D zxdh_remove,
> +};
> +
> +static int __init zrdma_module_init(void)
> +{
> +	return auxiliary_driver_register(&zxdh_auxiliary_drv);
> +}
> +
> +static void __exit zrdma_module_exit(void)
> +{
> +	auxiliary_driver_unregister(&zxdh_auxiliary_drv);
> +}
> +
> +module_init(zrdma_module_init);
> +module_exit(zrdma_module_exit);

[Severity: Low]
As reported by Sashiko on v8 [1], this isn't a bug, but since
zrdma_module_init() and zrdma_module_exit() only call
auxiliary_driver_register() and auxiliary_driver_unregister() on
zxdh_auxiliary_drv (including at the end of the patch series), could these
wrappers be replaced with module_auxiliary_driver(zxdh_auxiliary_drv) from
include/linux/auxiliary_bus.h?

[1] https://lore.kernel.org/r/20261102082026.2645777-2-zhang.yanze@zte.com.=
cn

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103125654.2707=
069-1-zhang.yanze@zte.com.cn?part=3D1
