Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793067370;
	b=G7Fm7sDhpmQ8kvtQuXewZsGFn4XScQ9McoRrjF4Cev12MhW/lZLm3U6wGG+67q6n4fIK
	 r1OfJqrAjVTMWbBKVvTtryveeFgbYntIT8IZG5CReyrz/qJpVESWwcy5iHc+zxuxbabLX
	 2ydnd+HcesFD/NyJmBaRzhJ5lkTTWyuM4np4z8DGkC/WeeCUdLjOJnvtp3jlmPBzVfVqi
	 aWuRRmTlUnSHc7/R7qve4HxWzAdLGMy1MMES/2UMtw5/qVSUOcbtMpYUoY922taTD+au+
	 YamE4ZIo9QHuClGHk5ooyf9C8SGW9139txVcfWUxPDEF/JdfRbZdz9qOgNFQSfvXoiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793067370;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=213hVxaY8zz7NJ3gzXzSYUeeO0Hb0kJ1MH6CZUy6aio=;
	b=mPPc4nZQeLpsUl9zbs3VUkuGuos0hvKdRyYA1Q2VKthbdWOHKxBc5ItGxkSLlrQto4Ky
	 nOQxwu0lRlubdSjNKoyEgVKh2y9sAKrU274jIM+iB1h3iOr6l+EB+H7pd52fm3ksStukX
	 w7MPxIKZ1rlrk/QsaGSaIBzHsh2wzpmYZKJT8kXsM2etSvqsseN9PK8L9Bh6kZAtkJQPo
	 eBuPtIhsILrMjholw1zr67BSnktgtilV8WXab1ECUzPxUaXtfFSy8duLD/Yzd4tj1Z0+F
	 KV51NG3thUE1q+wpVmI0xUGG9o7GWCy2L/8t3tjF7h9gDGyBsGYzZfh3JkBhUms9NNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=TtZulEcb;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F17606A31A
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 02:16:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99F17606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=TtZulEcb
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48e00eee27dso2272824f8f.0
        for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 19:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793067368; x=1793672168; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=213hVxaY8zz7NJ3gzXzSYUeeO0Hb0kJ1MH6CZUy6aio=;
        b=TtZulEcbNFyPlav19CVn8JOkrTSk7zs5dARKhv/oeoNxPjJo58m0J8bDm9HAf9vao/
         8uZSan2SUjjiCCDBxLRs8IF5s57PpOn73FCF22A5kq4GpKRfcSDCmUa/Ydya2gdhjRpl
         Ez7bf27k4X4CIx8vN52T+Hib0PJbfYbJXIa1FWytTOLGP7IJp5CmR55JW9w2yJeqbhtQ
         HCDFHOFmOq9K+fvXfhW+tkfafj5ok0zg3TAabBQASrvYyWvCy59VBXNfNj4CLRe2fzP6
         s4M63mxt1ERrLwgQCvR4oWTyymbUt6Fyyoe6QR7IkJ80D4GR6dzBQcz1zrFf+yNjvahP
         S5Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793067368; x=1793672168;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=213hVxaY8zz7NJ3gzXzSYUeeO0Hb0kJ1MH6CZUy6aio=;
        b=hob/NpGLWGw68VpinfmSbDon70Mo2kH+ss09x1SwKxzoxooRxce8YoL0nEvSrD8apz
         +iNOza5UvwWid7c+WdUXaCrPQVaAA2Td9DxjBxdn2r67wvth0EUaHz2UUaPkqUtldjxL
         DeWRQ0Qn5X2tgCaKlaqo8f05NbSQGlAoxe+RSSoXiwO3CHVYrj98qNo0k+UN2Lb+DIJE
         +ID/EwF/WTdQ6/iunDZatYpl9UJp70JDKqN1a4a8Y2iAVPjEndd9HhsDsUBk+0/jhO2u
         EjQq7qlab7GD7DvD9pT1mnFmE02ecn0FwxAwCzdq3gUB16fDB6URpeGUbGB/qC7yrFjG
         fmCA==
X-Forwarded-Encrypted: i=1; AKwUvBw53YbEjZY7VLWCVkGgRKmMVxrrekDbiHGHIkKZ7QDemhrQaKDIqTL9050+R7FhqdqEY0SNOHgeq6Rv@vger.kernel.org
X-Gm-Message-State: AFq9FYLdkpbah59ZlvbMvRiMBcUht5U4UeWMZ2+nnHFO7nPBBR5lI21t
	6e05GibHhHgxU0KksweFIxPdk3RVQpt5pZUwV9u7hKbBSafEp0G4Bh0z
X-Gm-Gg: AYBFou3UzRTl5JxpQAeVnfkTNkpBpkZj/Vvf2JtQgCRQlIicG/TlnBQxUyKhGnz9VSF
	h+4wpX4YkvdHnv/MB9KLuiRn6l6Fbc68sThtijY0h4zgef09Y9SGbSHJgrllf70tKJp9sphMXJS
	TKDkVHWqCaOjjmuvaI5YXNte5MXgJXSElDWvNw1sdhb9GWFN2akyJTjJdHpUXJu3V6hMIgg/qbZ
	7SZlq0FeXshPmDYe8v9898M63ehVQo0aoZMPHOPRlNUo/lk1Z70huYVORPCg4YRCr3FN6LzaYqD
	lX1IpPVqs7f5g3OfSgjNSBD0SrhT/fTeGh7UuYLB0z1aAN/W1M0DRq6IBLY6U01bHn7ORznU6b0
	1u344Mi+iHUju18d3lUbUH/aZPccgDZ5lTs1Ar80X6Akz2Znj9pSOEEKTtsL0cmKhl6JKxOmC61
	GR0zIH9QoHv+4Vvkrk4p3GJawk4hwEuIbxgzYzKHorgmpON0lh8ZENYu5tRd9/adwBk4rc33qIF
	+F38IlvcDudL4s6M3BG3Fcds+VWb7x1HkApp9NLaDk55i6dm4PlQ4as+X8Zj8XDir/zQlF1Vw6y
	Pxe/guaus3hUQ8xMnDzSi0L8gdkC76IeJm1uUosoVcWLR6tdossUt77NHXL2FYzS9l8lMwLupJy
	KkKQFMN34NINVeBN5SAgBJ2Jlb/db0U5vSTAY+ayl
X-Received: by 2002:a5d:6406:0:b0:48e:202:6718 with SMTP id ffacd0b85a97d-48e3eb8bbe9mr13317253f8f.25.1793067367758;
        Mon, 26 Oct 2026 19:16:07 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-095-117-118-122.95.117.pool.telefonica.de. [95.117.118.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebc3dcbsm19591505f8f.14.2026.10.26.19.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 19:16:07 -0700 (PDT)
Date: Tue, 27 Oct 2026 03:15:34 +0100
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: dri-devel@lists.freedesktop.org, christian.koenig@amd.com, 
	sumit.semwal@linaro.org, jgg@nvidia.com, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Simona Vetter <simona.vetter@ffwll.ch>, 
	Matthew Brost <matthew.brost@intel.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Dongwon Kim <dongwon.kim@intel.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Kevin Tian <kevin.tian@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Baolu Lu <baolu.lu@linux.intel.com>, Felix Kuehling <felix.kuehling@amd.com>, 
	Alex Deucher <alexander.deucher@amd.com>, intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, 
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org, 
	iommu@lists.linux.dev, Alexey Kardashevskiy <aik@amd.com>, zhipingz@meta.com, 
	treding@nvidia.com, jhubbard@nvidia.com
Subject: Re: [PATCH 23/26] treewide: Rename dma_buf_attach() to
 dma_buf_sgt_attach()
Message-ID: <auAIO0y09SXk34CN@gmail.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-24-apopple@nvidia.com>
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
In-Reply-To: <20261026053623.202642-24-apopple@nvidia.com>

On Mon, Oct 26, 2026 at 04:36:14PM +0100, Alistair Popple wrote:

Testing the series on a Jetson Nano exposed this path. A 3 MiB system-heap
buffer was imported into Tegra DRM and scanned out over HDMI. With
CONFIG_DMABUF_DEBUG=y the PRIME import succeeded, but scanout immediately
produced display SMMU faults starting at 0x300000.

Tracing the fault led here:

> @@ -475,7 +475,7 @@ static struct tegra_bo *tegra_bo_import(struct drm_device *drm,
>  	 * domain, map it first to the DRM device to get an sgt.
>  	 */
>  	if (tegra->domain) {
> -		attach = dma_buf_attach(buf, drm->dev);
> +		attach = dma_buf_sgt_attach(buf, drm->dev);

tegra_bo_import() passes the attachment SGT to iommu_map_sgtable(), which
uses sg_phys() and sg->length. The SGT mapping contract only guarantees the
DMA address and length fields. The debug wrapper clears the page-side fields,
so iommu_map_sgtable() maps zero bytes. 

Tegra only treats negative returns as errors and keeps the reserved
IOVA, which scanout then faults on.

This page-side use predates the series, so the fault is not itself a v2
regression. Is dma_buf_sgt_attach() valid for this call site, or does Tegra
need a page/physical mapping type first?

Karl
