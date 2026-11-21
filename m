Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795240728;
	b=c46JtbYcGojcUnR7Ntm12XKigjBvvgZToRL/tL8+sareeT0a2h18VuGpVd8+L9u7AEal
	 EaN8dqF6HHediRGU7aOjHreIuuHuwtD2+cL5PAF1KizN/KW4TPdWMoADxhaAI7Dd87SkA
	 2FHd7+MPi+eX5Jm+fHetLGoZXDafWOhng9ls4NX23EF1pA0aFlJCQRkVHy3LKFXv7Zo2j
	 IsGy6FKb1opjzClA9uVUNOTOHE9wyhis7kBB/oLsgIS700bwSeQmYC4XUs/Y0AltoDLHm
	 QmZJ+9rFn/u2hOPcVvjoeeaYIRFBAdb2BmeT7n1m60vBdVZsPFCb7H4R/3KMlFAo/GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795240728;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nHgcj4reAewShIct0fcYEQHlKrmsjIW5S883i48uYO0=;
	b=HdzPMn6h0Znbo7luXOQlomCk4x4vCiuhcrgzILxNGWY3sQ60bc7cvrkQ5FZWiYd78vrc
	 Jvtr/iYM13POfwrZvfCBi+p5YzCG6QGhE8DK1/ZGIuZ84g7pi2Q+/chuNuRhgSKo1vgIE
	 ymDZlOrd04biaAt3aRIwyhO2x9nNvlpPNORl0KneP72Y5FFspzaWqgiB35s97TcAsciMX
	 CtMURAzDf/FBEuLC2Zq8xsGR/9cPXrpsfA/2yT12vij26vvmgyaSENrLyZO2O5mcy1Jt0
	 j45goIgGziAY1PxJDPlGle+nlAQjV+I8gMQ/c8JAN4Q8sb6N2SOJPGDXiDxF2+ox/fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NKTiTFCm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676C3606A68B
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 05:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NKTiTFCm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DF51F000C4;
	Sat, 21 Nov 2026 05:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795240728;
	bh=nHgcj4reAewShIct0fcYEQHlKrmsjIW5S883i48uYO0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NKTiTFCmUe9wV/wkagz+EE4Kd6FBLLeeRild/NLY+1KadNk2ZDKp+Aol1cruswpDc
	 dyoxXGVMj2zWLx1VrpmZdBd5cvQT7anKY5OWfaFpfwcwAHH17lung+G3bGPvkL2CbA
	 dnkqBIt9f6NaoRWUZQvkcEeyveyi8ETSBlP51zM6mF7LvR68mzS90wjinQAqySZftz
	 x16OkaQd0ZdtTxTcpVgI33MAFFC6H59HWgr8N7jxVjZ02oVCR2TGNmJrSKmKL6Nef0
	 tbprkB97zbxR6P0oJcAHbQPOBK3bc+ItmqIKVHkT0so+bJF8nWG5rVwZ+NHRJvOz3o
	 ywc7F1pQrtbqg==
Message-ID: <sashiko-outbox-226681@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 13/24] udmabuf: Convert to the SGT mapping type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: media-ci@linuxtv.org
In-Reply-To: <20261120-dma_mapping_type_v4-v3-13-c0183a409bdf@nvidia.com>
References: <20261120-dma_mapping_type_v4-v3-0-c0183a409bdf@nvidia.com>
 <20261120-dma_mapping_type_v4-v3-13-c0183a409bdf@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 05:58:47 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] udmabuf: premature publication of ubuf->sg in
  begin_cpu_udmabuf()
--

commit f138ffdf3b226fef46f9eda6001d750e3e320cdd
Author: Alistair Popple <apopple@nvidia.com>

udmabuf: Convert to the SGT mapping type

This commit converts udmabuf to the SGT mapping type by having
get_sg_table() and put_sg_table() operate on a caller-allocated struct
sg_table and embedding the DMA-buf mapping table in struct
dma_buf_sgt_mapping.

> diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
> index df6dd00462423..ef77ae063ae4c 100644
> --- a/drivers/dma-buf/udmabuf.c
> +++ b/drivers/dma-buf/udmabuf.c

[ ... ]

> @@ -226,16 +233,19 @@ static int begin_cpu_udmabuf(struct dma_buf *buf,
>  	struct device *dev =3D ubuf->device->this_device;
> =20
>  	if (!ubuf->sg) {
> -		ubuf->sg =3D get_sg_table(dev, buf, direction);
> -		if (IS_ERR(ubuf->sg)) {
> -			int ret;
> +		int ret;
> +
> +		ubuf->sg =3D kzalloc_obj(*ubuf->sg);
> +		if (!ubuf->sg)
> +			return -ENOMEM;
> =20
> -			ret =3D PTR_ERR(ubuf->sg);
> +		ret =3D get_sg_table(dev, buf, ubuf->sg, direction);
> +		if (ret) {
> +			kfree(ubuf->sg);
>  			ubuf->sg =3D NULL;
>  			return ret;
> -		} else {
> -			ubuf->sg_dir =3D direction;
>  		}
> +		ubuf->sg_dir =3D direction;
>  	}
> =20
>  	dma_sync_sgtable_for_cpu(dev, ubuf->sg, direction);

[Severity: High]
Can assigning ubuf->sg before get_sg_table() finishes expose an
uninitialized, unmapped, or freed sg_table to concurrent
DMA_BUF_IOCTL_SYNC callers?

dma_buf_ioctl() invokes begin_cpu_udmabuf() and end_cpu_udmabuf() without
holding a lock.  Previously, get_sg_table() allocated, populated, and
DMA-mapped a local struct sg_table before returning it to be stored in
ubuf->sg.  With ubuf->sg assigned immediately after kzalloc_obj(), a
second thread can observe a non-NULL ubuf->sg while the first thread is
still inside get_sg_table() (or after kfree(ubuf->sg) on the error path):

CPU0                                  CPU1
begin_cpu_udmabuf()
  ubuf->sg =3D kzalloc_obj(...)
  get_sg_table(..., ubuf->sg, ...)
    sg_alloc_table_from_pages()
                                      begin_cpu_udmabuf()
                                        if (!ubuf->sg) /* false */
                                        dma_sync_sgtable_for_cpu(...,
                                                                 ubuf->sg,
                                                                 ...)
                                          /* uninitialized or freed sgt */

If two threads both enter the !ubuf->sg block, the second kzalloc_obj()
also overwrites ubuf->sg while the first thread passes ubuf->sg to
get_sg_table(), leaking the first allocation and initializing the same
struct sg_table concurrently.

Allocating into a local struct sg_table *sg and assigning ubuf->sg only
after get_sg_table() succeeds avoids publishing the table prematurely.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-dma_mappin=
g_type_v4-v3-0-c0183a409bdf@nvidia.com?part=3D13
