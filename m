Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793813923;
	b=u7b3IpUyR/b9+QzDrdseeh+RDkyLQX4Ff65+fPFdzHP1nGSdxw2ONaHrazRI/tADFd/b
	 F1JIYrfa2nzk7IKY9353A/gf450R7GHeQKXCZzaxDCxMxpZ1TON1cixENltHEud6c3YMw
	 8Kc2D7k/o8/ifYLyvSfjp6JDUdNQ1FJfUb6in5j30qResbDvaGM6aMUYZLSVvHoZhd2vO
	 OWqKxcBKkg0lCSaDDYRNITnedcZ0rR6MUDAh/dkRSDNK7WAM0pw9yBXyKBNE+p0AFUA9F
	 wl6L2amzrR/jHhn2F5HZtbR/gzBPX2qi8bKFDz01TBFNvfp5n+OVcuQBUz2/IRlpHbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793813923;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=yl3p6kivD+pbgaW7MJkK3w3sK9j5Q+Oatf9YNzkPHuQ=;
	b=SeS2aqCT56Rnzh0cCNbPZJIzozXh/d4DrZDJir31L0sN/uZbpbYvFoTNp9eSOW1zwiij
	 +z5Vh6RGQVzwEH1H8VrVx4jlj2/MoWWFlCRvw0vg6XwEAYWUqpEdKJS/ezSPUpJxUh8Af
	 o5SQqxnkKyKYi4SGd4ohzhkoFetOIlDlqbQcR3/R0ucgvtBTuTFp+KmMaLSmKOrtUBvar
	 Ywd3SWY5SqCEWTmfUaDrYxOEkkEjBmp7Pp4jls7F67HLwY4uiE6yRzskHoJYsqKy/iA8O
	 BYJEmAK/Wb9cODfzCVqmyZlfB5IsNj84KmEVNH3L5bNqivktZZXeoRqsr5c5uYqCAjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=mrY8ROdm;
	arc=none smtp.remote-ip=209.85.222.175
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAA7606A328
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 17:38:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2CAA7606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=mrY8ROdm
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-9441591aa5cso244869485a.1
        for <linux-rdma@vger.kernel.org>; Wed, 04 Nov 2026 09:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793813921; x=1794418721; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yl3p6kivD+pbgaW7MJkK3w3sK9j5Q+Oatf9YNzkPHuQ=;
        b=mrY8ROdmQ1U8qG1WVkHwFlUc3uGFi+mfdwhSWPL3i9Jp9h8f89iHmTdDBHaGoSb9fV
         Qf9rVp7RKUT19nXLbySXsX1HX9ejTq1RkMbi9uctb50nDdYeaJxGrg0TKGC3n5LuHDCN
         s/MNCqdyz7OsSy5/Xj4hUz7Xx9K8J+nT+Rgtz/TEx7hQSBym/uHrT0083IL7OdGOVSoW
         QWTluEuJP2tc6R56IYPlBHffsnVWwQA6M5o6QgL6HcwG3w2leCaMPqVjEYBQupV7hAqq
         SD6IF6/nTL+K1g1CWe1MCWd4YJ9zVV8/dLg6SmJyJNXdrhSgMr1A+M+/81J0lXd5xQmn
         obNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793813921; x=1794418721;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yl3p6kivD+pbgaW7MJkK3w3sK9j5Q+Oatf9YNzkPHuQ=;
        b=FRKN1du448lgKMqv7PQrLEtxpgth2ReUeTQPFk1jqLHcz80/xVEkv/VOKJB6cEwUd3
         EfXukN5Z1NcADaxth1CmPI9ya+QoDBQfWhbjC0OPvpWsTC+OOhkBIZXOn2urvUHRGnw4
         KjeOGxtH5cHpVa/OHS0GtWk6vieE5e1RwJLC76zK0PqgCx8z8tg2eDkAXioMylhlE5NI
         8XI9B4RrA7sEYDrAo/sttsU18VHeIDgL6Hl9PRkF72kIeLqRLTF6IgFFdDbZtfcT04OR
         RXEw6GJIv5+J1qH2Jmbw/uYvnFjpNux5veVZ3k3p6505UjzQ5TSsT5yC2DdpNgTkHzej
         tAww==
X-Forwarded-Encrypted: i=1; AKwUvBwDUg5ilgYtHHHKeybatHiDrXPm9SNojbhP4IAd2XzxI7lb/r4TfS19AiZpuuIVmCQjYwjqCOKn9mEt@vger.kernel.org
X-Gm-Message-State: APuU4Z9gqC8stmhLZ+C7PfYMQL3aLtxCWOscM4IngK0BbJNZVB35Rz3p
	EhErzb8I4OsAVA5QjA0Kwq+y6S/hgri48eSKT65KrsUYiGPKh7Iw7Sy90WW7ZTsw2tkKI3eWNMi
	wsE63
X-Gm-Gg: AYBFou1fh72EI0Cx6Jtk3mILt9QbCgC4pxITnuUVGp2BMSKZyGwvgMiv2dqxAcxqjgs
	GQwBnn6euuqiTonXd0n20kbw7knT6ITwG1Bq575P/sotxipgk0CJoHEPjiePpyV4FXNS1kyyTxl
	BV0WOESmm5/bEanrKQ6xFmyqhZDHXXnY43rd81Itnn3D+gQ2BCGjQ+UoWZCyCVRqsurTBBEhkZX
	jvIU06iwWa9SVyztBxfOIfzWqUTXxPiqplWhyI/IE/Q58EchVUBYdQwXdUgWGxB4TsDJy0MXj8T
	kZz11CLlxStSmMLwnn501ayI7/oOwQF7cEPi1biWeAlQqXlijEfZPX7T31PUf0K6mv8hDj4SWmq
	K+bbMiEVorxStkNPPyRGh/tOoPnKVjgBA0LCwln49T0AopRuLBipGrc+Bf+imi2PnxoLPJFlFTt
	t5wkDN6biqQPbkbIAPI/96zuQ7/jn/ya40dLDNAriuAC8lamd95U4t8xDYT1nruwBrWTF+Sb2BW
	43qCOsO1xAeyly38zlBMpk0fJSthDNVIaR9VsNC/huZ9gDcOqWDXDAKetOD9gWXSzknbxi9tbwJ
	vaGlxLx4+7n5g+y+/c6LIFqVLE9pExm7A4ThCgczal0t3mQlZPN9GOwA2VOgK6xbaJV/11V5EG7
	pKS6MT/zSdg==
X-Received: by 2002:a05:620a:258b:b0:93c:3863:ff7f with SMTP id af79cd13be357-945e1231638mr47030585a.0.1793813921165;
        Wed, 04 Nov 2026 09:38:41 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-945d479ddb7sm249464685a.9.2026.11.04.09.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 09:38:40 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xOewa-0000000Gz0A-0aRN;
	Wed, 04 Nov 2026 13:38:40 -0400
Date: Wed, 4 Nov 2026 13:38:40 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: 0z5a <dezhen.lu@student.uni-tuebingen.de>
Cc: leon@kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/mlx5: Fix DevX umem page size truncation
 for pages >= 4G
Message-ID: <20261104173840.GX3889730@ziepe.ca>
References: <20261103142804.67210-1-dezhen.lu@student.uni-tuebingen.de>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103142804.67210-1-dezhen.lu@student.uni-tuebingen.de>

On Tue, Nov 03, 2026 at 03:28:04PM +0100, 0z5a wrote:
> From: Dezhen Lu <dezhen.lu@student.uni-tuebingen.de>
> 
> devx_umem_find_best_pgsize() computes the page size in an unsigned long
> but returns it as unsigned int, and devx_umem_reg_cmd_alloc() stores it
> in an unsigned int. When the DMA mapping of the umem is contiguous and
> aligned to 4 GiB or more, and the umem length is a multiple of that
> size, ib_umem_find_best_pgoff() selects a page size >= 2^32. Since the
> value is a power of two, the truncation turns it into 0 and the
> registration fails with -EINVAL.
> 
> The umem log_page_size field is 5 bits wide on top of
> MLX5_ADAPTER_PAGE_SHIFT, so the command can encode these page sizes.
> 
> Seen on two GH200 nodes (ConnectX-7, firmware 32.38.3056 and
> 32.43.1014) with a dma-buf exported from cudaMalloc memory: registering
> 4 GiB or 8 GiB umems at 4 GiB-aligned offsets of the dma-buf fails with
> EINVAL every time, while 2 GiB umems at the same offsets and
> ibv_reg_dmabuf_mr() of the same ranges succeed. Restricting the user
> pgsz_bitmap to <= 2 GiB makes all of them succeed.
> 
> Other large physically contiguous buffers, such as a 16 GiB hugetlb
> page on an arm64 kernel with 64K base pages, should hit the same path.
> 
> Use unsigned long for the page size, as commit f0c2427412b4
> ("RDMA/mlx5: Fix page_size variable overflow") already did for the MR
> paths.
> 
> The bug was found by an AI coding assistant (Claude Opus 5.5, Anthropic)
> during an audit of 32-bit truncations of page sizes and offsets in
> drivers/infiniband/core and drivers/infiniband/hw/mlx5. The assistant
> also wrote the reproducer and this patch. The reproducer was run on the
> GH200 nodes described above.
> 
> Fixes: 7610ab57de56 ("RDMA/mlx5: Allow larger pages in DevX umem")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dezhen Lu <dezhen.lu@student.uni-tuebingen.de>
> ---

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

>     - So I have not verified that CREATE_UMEM accepts log_page_size values
>       for pages >= 4 GiB. If it does not, capping pgsz_bitmap at 2^31 in
>       devx_umem_find_best_pgsize() is the alternative fix.

It is userspace's problem to provide a correct bitmap in
MLX5_IB_ATTR_DEVX_UMEM_REG_PGSZ_BITMAP
for whatever it is doing. FW can reject large sizes outside what it
supports if userspace sends the incorrect bitmap.

Jason
