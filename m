Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794041877;
	b=Rc4SKEivOyyQ049lXU6U4XxU3EIg4B4+EdPPiLBdoM221oQur2KDr96LycPOa1WYs0j8
	 LfUguAnTSZaaz+4gOgXWR2CFKojP84WYNmVWXxEU9F09LjB6anvztZvsyqRMfT58krjg2
	 pqNnvt1+Dd3BHJU+yf6fC6dW1chHE/OcyMDbh5nwU6lQ7BO5TRLmA+skFfCfR/E9vw4c9
	 V/EYzoSIvsbh5hag+PUYBAGNegpPcpduJ7YBrupBNfyPmZlL7LJAmHTkgGlh53MSBixHK
	 hKchyGOEY7+bKNtg82qnRaHWSstJy3wWy/VKFp6Q0WNxsssd6CFNS787kMYCvv4UhBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794041877;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=kw2zLGhVUDQnO5rFq8cwt1gUENr7fOzbT4vb4xG8V9g=;
	b=kgJe8VVj3pWGtjTL/fhz7HmfS1Rzpbv46LcHE7o/kTmcRNPMfoV46g77sdpjw4wjrKxX
	 v9hmehJKTOjgITcWXlBvXCGyfc8OwKLS4J6kVij1OUMUYEpV/+af4hNsImFZjzBZkbJVA
	 iWQaEZjxggpTu7kK1Rl6BiJlvjGJ2PWozDynjLZEgPzaUETANy0K6CSlyOCBE1etPutQl
	 31AGT56OG5P3MFhBQRgrsxujjhWwW7z0KZYsb1NXEvEsuxt4xpcWupVTXHMYI6XeDmBq9
	 Q5xS2kY4uQOizK7fkGQEye8eUrHBedTcKYecqqeJvBy/oPNKNmlbkriLJwUSuMMYvPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lRpHPSXl;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F2C606A32E
	for <linux-rdma@vger.kernel.org>; Sat,  7 Nov 2026 08:57:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29F2C606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lRpHPSXl
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso13010995e9.1
        for <linux-rdma@vger.kernel.org>; Sat, 07 Nov 2026 00:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794041875; x=1794646675; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kw2zLGhVUDQnO5rFq8cwt1gUENr7fOzbT4vb4xG8V9g=;
        b=lRpHPSXl3OIr5GNRw75fM5ZVnwTATltcAGYuVDQrLmWlSaBacYmaetJd4o5f9uMRYU
         DMX7l+/tuuZFYvaoIeUpeGqnN8iBg54fGc4dx9tLUJVuWK/+HFoYsScHTNkhMM7GVBxB
         mLyHawMWuiONSA8LiJKkIrHvjPDEc3AbES34AOLSaJxGBQAde/NUpJ/ThkRJJ4+RS4RB
         sC8YxfIrvJ8/GJmqqXRCc6x9YLqpY4tlKjYhYzsOrOaNhbyyI+Cw28y5pLNJvgoWuw0E
         YPcPunJtCM2x/5gGAKnET9uHIB7H8FPhQzVHOBFNpmXv6dhQHtcVQEg2DDWQWYgFFWo5
         mgkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794041875; x=1794646675;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kw2zLGhVUDQnO5rFq8cwt1gUENr7fOzbT4vb4xG8V9g=;
        b=LvaShV4HvxYShKKR5MkPsaA5aZxrT7VJZns74xD1PwYVIy0HQTgnWcajFLyXYZRZMQ
         FPtDPfeoXDRLctdsrlbdG9WHuyseEKlO/UtMB/0PpNMvij370N249rwDu5CznuDmQVF/
         CtmRQW9W3NHogWsZFKyGX0iX7nkw2uns1gymiffcWHG3o6PN5Mcofi4x7Bf3kJfAniHK
         ez/t4J5drHOyEykCMwO9TDozmfCsYn0Fini7/NmTABdhUToYF4fKPtj5BMH7alTj49jy
         Jtda1o0F0M4vP/zPH/CzYTzMS73CRS0YV8el001FkekosSgRm8R149U0sbGn1VJ12vqj
         6i/w==
X-Forwarded-Encrypted: i=1; AKwUvBz7neU1t1FnpwKrn9RSU8f1P9lGyADUXMTJdZ4Hio8+jFfaUNuzz74+YUW35XsLB69f11Te3vbgCmuK@vger.kernel.org
X-Gm-Message-State: APuU4Z9i9zjaP0xNMgImtl35DB9y+9tBBvVek6HM0+TxVINE1l12Y6T/
	BZR1w5Lxy+Ru/ZsI0kHoILlAQicLzsdufTkh60BJUComb2V/5KrAmObW
X-Gm-Gg: AYBFou10YMxqcbniNTDlwTqhOr1xNaMdbQCJmm9kJ9O7dVLFq3cPWFk5DSh4kp34qJN
	DQVRytFrIQBNn+07KNpRFiD6x4i+lz9fKegO5FjmgV8ADAObrsCCDzm51Mq7h92YuTHDShfFWg/
	cfy8E/V6OH0pk56B3AdrvzauVCyAUtED4X+WnTui4IGr+lIsFwOXBK4AZ+1m9Dn9xPsM2kcdNj+
	juiXAWa4GoJAu9FkR5EfbrMHXT3ANNWWFbeR0x2SNDgxpodFVeSipmKi8Redes398TiGYDtrY6F
	5ZBB8mAVixJe8s9nzUW3rIWSrkBBRFWWEj+ruPcSe2lnvML5sJS7AglvE/3aMk11eej63VXqns0
	Bx1jqMu92WV4PA57Mc05x/uOFx2cz99usNslq+s/egohojsBdcrzTuwkHcty5Xr9+sawb9/klUt
	6vyQ3xMJs4ILenGt6IQXi5/b5eyrbhet6iNuNsVPoWEpmY3L3OWqAyo7U2usgQoFcHdvmO4KhUh
	ve8TBIcw8S6686J5hA6lwNkqwfcJorYwe15Fwus1z6NCkAKJDfmyp3mLeZDNYqTAMaF6eVXLCLW
	ywUMVKR/hCHBtOX+U4VH4noMolN9RciDu09cG8bn7oERk2ih2Zyx/tyjJnUxAUPLlTidkQBHIpp
	utailcSLUxKi5ldD4oor6c+/2K8qO/q08zpLcpbqjasuH1CCy+iORQ7a+/+Il+jnT
X-Received: by 2002:a05:600c:a015:b0:4a3:5a91:5f61 with SMTP id 5b1f17b1804b1-4b6df028f04mr88902585e9.14.1794041875269;
        Sat, 07 Nov 2026 00:57:55 -0800 (PST)
Received: from unknown748F3CBA5068 (dynamic-095-114-115-226.95.114.pool.telefonica.de. [95.114.115.226])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-492d7701af6sm8597238f8f.38.2026.11.07.00.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 00:57:54 -0800 (PST)
Date: Sat, 7 Nov 2026 09:57:22 +0100
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Simona Vetter <simona.vetter@ffwll.ch>, 
	Matthew Brost <matthew.brost@intel.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Dongwon Kim <dongwon.kim@intel.com>, Kevin Tian <kevin.tian@intel.com>, 
	Xu Yilun <yilun.xu@linux.intel.com>, Baolu Lu <baolu.lu@linux.intel.com>, 
	Felix Kuehling <felix.kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>, 
	dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, 
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org, 
	iommu@lists.linux.dev, Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org, Alexey Kardashevskiy <aik@amd.com>, 
	zhipingz@meta.com, treding@nvidia.com, jhubbard@nvidia.com, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2 06/23] dma-buf: Let the exporter select mapping type
 at pin/map
Message-ID: <au7mBMbRC8q6NILj@gmail.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-6-78b8dc9ae80a@nvidia.com>
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
In-Reply-To: <20261105-dma_mapping_type_v4-v2-6-78b8dc9ae80a@nvidia.com>

On Thu, Nov 05, 2026 at 05:40:41PM +0100, Alistair Popple wrote:
> + * A pin or map that fails after dma_buf_mapping_select() may reopen the
> + * choice only if it was the one that made it. A selection that predates the
> + * call belongs to a live pin or mapping and must survive, otherwise the next
> + * pin or map would reselect under it without an invalidate.
> + */
> +void dma_buf_mapping_unselect(struct dma_buf_attachment *attach,
> +			      bool was_selected)
> +{
> +	dma_resv_assert_held(attach->dmabuf->resv);
> +
> +	if (was_selected)
> +		return;
> +
> +	attach->selected = false;
> +	attach->selected_idx = 0;
> +}
> +

After dma_buf_invalidate_mappings(), attach->selected is false while
attach->selected_idx still holds that mapping's entry for a pending
unmap. 

If a pin/map fails before that unmap runs, was_selected is false and
dma_buf_mapping_unselect() resets attach->selected_idx to 0.

A subsequent dma_buf_unmap_sgt() then uses matches[0].

>  int dma_buf_pin(struct dma_buf_attachment *attach)
>  {
>  	struct dma_buf *dmabuf = attach->dmabuf;
> +	bool selected = attach->selected;
>  	int ret = 0;
>  
>  	WARN_ON(!attach->importer_ops);
>  
>  	dma_resv_assert_held(dmabuf->resv);
>  
> -	if (dmabuf->ops->pin)
> +	ret = dma_buf_mapping_select(attach);
> +	if (ret)
> +		return ret;
> +
> +	if (dmabuf->ops->pin) {
>  		ret = dmabuf->ops->pin(attach);
> +		if (ret)
> +			dma_buf_mapping_unselect(attach, selected);
> +	}

dma_buf_mapping_select() sets attach->selected = true before ops->pin()
and the map callbacks run.

In patches 14/15, xe/amdgpu migrate a VRAM buffer to system memory
during pin and map when the attachment does not accept P2P.

That migration calls dma_buf_invalidate_mappings() and clears
attach->selected on every attachment, also the one being pinned/mapped. 

When the callback succeeds, the attachment stays pinned or mapped with
attach->selected == false.

A later map/pin on the same attachment can then reselect without an
invalidation.

Thanks,
Karl
