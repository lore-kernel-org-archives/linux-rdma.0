Received: from mail-qt1-f196.google.com (mail-qt1-f196.google.com [209.85.160.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B13732ED21
	for <linux-rdma@vger.kernel.org>; Wed, 21 Jan 2026 13:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769003992; cv=none; b=YO5iqM5mNtkGR+0SIvMB2cLvktzYvuVqhD4n14I9QbokoML+md6PtHb9sDjLdNNvXQvsYWvGGNz6ox6HKwoEXoeCNQgX4B35KnpHF2IKHZNIrP5qI+pYLeIJuoeRw2GCXFsBiZNtSID33LGtlv0WDzFeIbcGldCxqo5DIP9kgMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769003992; c=relaxed/simple;
	bh=tR+AFnMPEtzcHlOQnrldwGxBaKLMhAwLG9LVsjQDN2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jK2IU0rwsSudhr804onnrcyhN578lGxi8ED4XQF7LRsT081RnH0ImR7Hk6tuIca8vC4slZ6X2qvErF0Ho0kPB8AbwA3hwUiTm+yDo7zsf2bjB8s8z4PsEWqvv9lQb51hC5csKI49I5YAC0d3M01EOshADote66Tsz5I6fZAh54o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Jze1fF0Q; arc=none smtp.client-ip=209.85.160.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Jze1fF0Q"
Received: by mail-qt1-f196.google.com with SMTP id d75a77b69052e-5029901389dso42948741cf.2
        for <linux-rdma@vger.kernel.org>; Wed, 21 Jan 2026 05:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1769003989; x=1769608789; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NrFwAYZYjJdV2hWLBqDeijXZcUvvrfRZB3KhQxPCGpU=;
        b=Jze1fF0Qh0XqI4BuP54hDc4hfELdDetpltdtEDmBXNzTnuSGNNQVroYyi9QrehQ2o9
         4PoUpTuwKH0WFeXOtdWPP5cSMSEplNmxiH+jdQS+EI+Kyarl3xrrJlpYkMYwv2kuaWPt
         ZV8Ff+4ClFwnu45Xff3eVIaffTmCx/lCQwGQUrSH7Y0Npj6TbtsTjjjVWFNKiHOySOP4
         ZaJy5GUCHmmwvgyyugkTYFGvW4Co8LSNP1BN9pYmqtYi7m1exostNPSVMF836p/0m79j
         dNW7ByNav3nois3lD6T0pQCM0sOhhfAOr+N2WiKOCtyZq+xysFKpplttTYfq8WRty2NR
         U7hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769003989; x=1769608789;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NrFwAYZYjJdV2hWLBqDeijXZcUvvrfRZB3KhQxPCGpU=;
        b=lO2KmntjS4MqSGVWmYg0azxHgBQJbKnpt0/cAL8/Pw6VLThxpjmSU7gw9tcvvBUAPf
         czib5a6Mjqq4bCib6++yEK80PmrC65Oey7TH96nTooCQmeWRMtfX5dGBV93DmA3iV7Yg
         /cYi2HWObPklbPOJyDTYQf8s5/aRZKRnuEW9zhi3IwE4QCd+uPvgwNmRPb9ZRRljsZ8g
         KTh2s7FpETBJe4pZQ2UtBsSKxWOEBmZANCWMFmE2oEDX1AqmwYzOnfkmDiUy5NPIzY+J
         eHQ9Py9mchBhxwJOQ7krHAxWbHxPKkHqw0EuozH/+4dW5Gqi11MNLw8vWNe3GyWde5h1
         h3ew==
X-Forwarded-Encrypted: i=1; AJvYcCXeiooRoURUcxPmG3tPpUKMjgcU5xqMS3OZ2UtG+MW50VK6rHflzafz6bdK/kIdzEOPxuS13s7swSdd@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+gEQW/s8duEkblZHtEFnlDeAXLrmKtpF4j7O4WezGDAdDivQR
	EQbH4lkp0SQhcJ2KYFRdHKW0ACoCMSMmU/YIvnQUpmzTFZduhEA1YofiETwuNHEdyu4=
X-Gm-Gg: AZuq6aKvqFG1ugKQg7Rne0Wp6po+AS/WlqChPDWXg2adZqzsZQHOBGQ9rU1cNudHnS1
	XIzyBJUKpn/7fWbN24DnWhrFl7w7I8BelgVL0hbbA5JBES9RN1MQsF2vYx2kuFoa6KNEuG4Dd6Y
	wOWseoFbR6dlBasjPq5GHrGw2AU32FHN6vv1TMy7PLOtYmpwwGRApX+pGQl2ZuQEA0lF4SKUyVi
	tN8vEbNOFSomhSQ0YnWKjx+U92kPDHTVDpDQqeBMWSGAIqKiHENoJCY81Ii18BVAZ+O3BiYxVJw
	cDgL5UkVJ17XPXvTb/SCbVoxKGDh1eqTyJZ5J6358lt+q/vTUy9vuNaGrdHNr9Wg76UYJF8sqGb
	GCkVOiAseYDFl0kSGvTLvity9asKHmOy8hum2ZTDb09inuiA2HUchxUzHN09C7DgRjO4HbsPOXr
	yY55dEpMLnqW1z7hFR8vIbCDAueeyWToxZubQYQ9hqUMuMYo6ZhPfVWrc7x36Gj679yx0=
X-Received: by 2002:ac8:5d14:0:b0:4ff:c5f7:f812 with SMTP id d75a77b69052e-502d855fe29mr65972911cf.38.1769003989233;
        Wed, 21 Jan 2026 05:59:49 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-502a1d9f480sm113423091cf.13.2026.01.21.05.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 05:59:48 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1viYkO-00000006E8Z-0XjE;
	Wed, 21 Jan 2026 09:59:48 -0400
Date: Wed, 21 Jan 2026 09:59:48 -0400
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
Subject: Re: [PATCH v3 3/7] dma-buf: Document RDMA non-ODP
 invalidate_mapping() special case
Message-ID: <20260121135948.GB961572@ziepe.ca>
References: <20260120-dmabuf-revoke-v3-0-b7e0b07b8214@nvidia.com>
 <20260120-dmabuf-revoke-v3-3-b7e0b07b8214@nvidia.com>
 <4fe42e7e-846c-4aae-8274-3e9a5e7f9a6d@amd.com>
 <20260121091423.GY13201@unreal>
 <7cfe0495-f654-4f9d-8194-fa5717eeafff@amd.com>
 <20260121131852.GX961572@ziepe.ca>
 <8a8ba092-6cfa-41d2-8137-e5e9d917e914@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8a8ba092-6cfa-41d2-8137-e5e9d917e914@amd.com>

On Wed, Jan 21, 2026 at 02:52:53PM +0100, Christian König wrote:
> On 1/21/26 14:18, Jason Gunthorpe wrote:
> > On Wed, Jan 21, 2026 at 10:17:16AM +0100, Christian König wrote:
> >> The whole idea is to make invalidate_mappings truly optional.
> > 
> > But it's not really optional! It's absence means we are ignoring UAF
> > security issues when the exporters do their move_notify() and nothing
> > happens.
> 
> No that is unproblematic.
> 
> See the invalidate_mappings callback just tells the importer that
> the mapping in question can't be relied on any more.
> 
> But the mapping is truly freed only by the importer calling
> dma_buf_unmap_attachment().
> 
> In other words the invalidate_mappings give the signal to the
> importer to disable all operations and the
> dma_buf_unmap_attachment() is the signal from the importer that the
> housekeeping structures can be freed and the underlying address
> space or backing object re-used.

I see

Can we document this please, I haven't seen this scheme described
anyhwere.

And let's clarify what I said in my other email that this new revoke
semantic is not just a signal to maybe someday unmap but a hard
barrier that it must be done once the fences complete, similar to
non-pinned importers.

The cover letter should be clarified with this understanding too.

Jason
