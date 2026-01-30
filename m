Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E0A318EEC
	for <linux-rdma@vger.kernel.org>; Fri, 30 Jan 2026 14:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769781681; cv=none; b=aPjSF3DYRAZTntZYLXXx+Q9XZYzkkq44fWxJD1/zmqet7kkqGvJfW11Msg1PUVAw9XkPLqWep83fqUnro/NI/arG58cvvYa6Y2xzU9z8ckqwhiwHKYURm2qvNebwjebTl+QooqcruXZtI16p+/F57narjgYyyRtPgF1TGzQBvO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769781681; c=relaxed/simple;
	bh=B2BjUDXErJP5w+VRNup6GLKty66RY3PW3GzWxgahGUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HmN9hKa3HdrWRdB9Lm5gvCyJ0hQCdp/kJM88R/7F2ws1n6xFd9cMTV5lya2t0Ux563MCq7ycxLRWpLPrG00vKu4AScWZbJ6fjuZQbA2eoKi2YebQOQWq9wDVUMk0GgI2EB37sE4UHJ7myNNTrYQd1HvRORSc9to2jtiQD9olx9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=RPXkfxnK; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="RPXkfxnK"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8c710439535so170149385a.1
        for <linux-rdma@vger.kernel.org>; Fri, 30 Jan 2026 06:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1769781679; x=1770386479; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RZzJd1rUXnKgbbFoik2J/HwA+Mcwjh2UI/kxMGq+fms=;
        b=RPXkfxnKERVpanY6KK8kMqA92D1aCsm0leVXLFCXjOhb2U3nX2ibmil5e1rKJjRbmZ
         f9DLF2ispAd3BC5/e/B7PIP41q9T7cXh+rFnMjLhQTQVOAwPscRHX0yuVltxMo+SX0va
         xizd3lnopuOyDgwqxrfBFFPETq8K7uDdD1AiHlNN/WTPGOisvesviEelnt4KuWRuvyRg
         C1fgBVRD7H2M7lHZPygk3VfxwbCekxUo86H7EPdB+A5bCR3cOm6bbT7bRiRKk5cUFTZ8
         6U8v+ce+eW1niOc5yZS8lVBKLeRT4st0EvTSZ8FDC2mKySNBjdyDwdy1kxq6nDeMR7Sh
         lduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769781679; x=1770386479;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RZzJd1rUXnKgbbFoik2J/HwA+Mcwjh2UI/kxMGq+fms=;
        b=JPz27LppCLlzAn9zWajt2UR4e45VQcMxUOE9caeAKvTY8UefMNwrRcOx0h55daIjHe
         2Bn+7rVzhkcXFOjW9ukA3xJST0H+Wh4JWdYOiK8dzkq/IEtl9YdyP8aq1rHmePXPTn1C
         ZaCl76KjSbDehjDroM4z7QVc54ZQqZCsT5L9U5M1le+wCsX2UGRKHOBmTnhWbVdnjZb5
         xV7VPJNQtO04XvbhT1LulEO3NvnB9Yrg+n6P9uYPB929LDhjUz11WeW6ecz+EHISDU9X
         qwMpXanwVThf1qJSbwlHHUL+1r0ExxQtKlBjIWtKJrPH0Yf/5QpVLj6wo91wiB+xatUV
         Z44A==
X-Forwarded-Encrypted: i=1; AJvYcCV9akowB68BmI4ejua9XEZyC4EjNsXyNdjc4WxuqvPwzoEKldgYl3ovMUxTxQi7U0/Nh46qnC3h6nw0@vger.kernel.org
X-Gm-Message-State: AOJu0YzG6NbtElM+aRnii6YClgbJMS2ZXCeqFjdouQDv6wBxFV60TWFs
	YrODnlbzRr4pT5yoaHmI7vTtnq0y3oZ2Z5G5Y/Y/cSqFH8WDjb1SWrMLxe3TK7br5oE=
X-Gm-Gg: AZuq6aLfeZJ7Vq57T9j5PAEhAZbyHmq7b9tzRXhqyfhEGxVPEh1OA8t2Dp1jcU+CZmM
	wTQdidb5pZU7Rjhq9fjPi2KzOuAMHWYzw4B6w/Pvw0Hy86vxU//dzF+Fno6IdWgiB2Ln/sp1Rvf
	BaPpxr/GhrjvFP634AlhWXMnAxeLK2pIxRoxcvdfOLP3R4ronYecaq+RwmIdwdey2qMYs2lI4lF
	oZyoNvwMUvbngXR3EC29hiYzmFXhrPGf1Tm30SvEWwa3S1Hzq4i+8zMd6wf1kvxv2ovPbfhmuo3
	uYGMERpN06aNsgQ/chetRgn0LsOvGzyufV0wiKXHtdTMxzR8CJf4FmVLKo9A1BEN0aOHsBZJMPe
	YoGcPiyqBKp/q4V3NTMcBcPrLt4QWYqrZCtUGUbA4XspsqTWdt/MNTXnb2eOSJPaOz6vsziVEnJ
	KhWdEYFms85V4FeNGe/ZUG0NYFuM+W5dpszpO3oR3BhV+rf0FMtvJBIzgzvfGGu5FjftMPTFHE7
	hlOLg==
X-Received: by 2002:a05:620a:290f:b0:8c3:650d:577e with SMTP id af79cd13be357-8c9eb224827mr368793585a.4.1769781649371;
        Fri, 30 Jan 2026 06:00:49 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711b95e4esm700915485a.15.2026.01.30.06.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 06:00:48 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vlp3H-0000000Annc-1AWG;
	Fri, 30 Jan 2026 10:00:47 -0400
Date: Fri, 30 Jan 2026 10:00:47 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v5 6/8] dma-buf: Add dma_buf_attach_revocable()
Message-ID: <20260130140047.GD2328995@ziepe.ca>
References: <20260124-dmabuf-revoke-v5-0-f98fca917e96@nvidia.com>
 <20260124-dmabuf-revoke-v5-6-f98fca917e96@nvidia.com>
 <b4cf1379-d68b-45da-866b-c461d6feb51b@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b4cf1379-d68b-45da-866b-c461d6feb51b@amd.com>

On Fri, Jan 30, 2026 at 09:43:22AM +0100, Christian König wrote:
> On 1/24/26 20:14, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Some exporters need a flow to synchronously revoke access to the DMA-buf
> > by importers. Once revoke is completed the importer is not permitted to
> > touch the memory otherwise they may get IOMMU faults, AERs, or worse.
> 
> That approach is seriously not going to fly.
> 
> You can use the invalidate_mappings approach to trigger the importer
> to give back the mapping, but when the mapping is really given back
> is still completely on the importer side.

Yes, and that is what this is all doing, there is the wait for the
importer's unmap to happen in the sequence.

> In other words you can't do the shot down revoke semantics you are
> trying to establish here.

All this is doing is saying if dma_buf_attach_revocable() == true then
the importer will call unmap within bounded time after
dma_buf_invalidate_mappings().

That's it. If the importing driver doesn't want to do that then it
should make dma_buf_attach_revocable()=false.

VFIO/etc only want to interwork with importers that can do this.

Jason
