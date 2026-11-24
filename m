Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795528842;
	b=bL/3lN6k+o6CN9MfecEOtE0tJUWNQHmoCGSrh0KsDdXi7be8lGVQ8EzUNugykONDFVQK
	 O+fkI5dA+RG+3CaHtNC+nSC8yW18GcO4dBrxyJV2blluhsKr/TJyBsfDcr7IMdSueJnqJ
	 MYesNwxbuFDIWOL2nDO07XnTipVJSG3gHfW5HmseNL8DvQiJZTddeEeNpytQfuJlZ/hDY
	 GwpefVXH7XpaQP4jvYJr9tPFCagvQ3x3fMzHs7NBJ5B8crI2uy0qBoeYQnxSTBKphI6VU
	 gbSCw1jMUUP3runa3iUs2okZUfY0ApAuDSIwyIxzf8bD4czFhgBfH+YGjr1DkUVrX+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795528842;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=o+7iSwGfMjtzT2Y6Ygii4nLjUX3g93NcfuA7HOwwEkw=;
	b=JHGVLnvR5Q4GWInHIUYtnt/eoxR/FKTwjeILZKNzcycyzTVKvaTfZHFSZKT8+TanxCXy
	 8AEz//Os4AGNs/2t0ePjvyaPWnZxqdGQjgWMucPcpIQ3crarmzE1SZdkhaBqhz75FsTJ3
	 EAR5wWY3Vl8jphzWufTJSq/m8hb4MPQc9ZwoEO4CYV04YPjBZX6ywqiogiSXiqwfVyZ6d
	 QyEwFR5oBsvPOCRGy5oVCuEbKNAoB45QKh4uR5mTDw+ianCXfLTjTjIziu8CMdtBoUFWk
	 w0pmQZgDk2OP0OrHEP4e/j/IiVOIS6rOE+kzAIKjMHbPKw0IbTXrWilmpp/+Ep19GoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=V30Q+iur;
	arc=none smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC378606A31E
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 14:00:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC378606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=V30Q+iur
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c40e30c26a4so1089074266b.0
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 06:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795528840; x=1796133640; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=o+7iSwGfMjtzT2Y6Ygii4nLjUX3g93NcfuA7HOwwEkw=;
        b=V30Q+iurO56H29PrX9q7wVWHAj934LHyh9dyaSa8KHPs1wYEL79KlkRZ8Ndk67ZYFP
         8Moy2ZuuvXyGxj6hxEU5MHXoHu4tO+Fkx1FOmb3i6VmcSl2yRSR7ozCFXelACXZQQdpH
         73eeCdMmnAdK5bgaPJM2yLbbq+7EGbpzKQXhHQ+LiUd9gwn3Zcp08lnZgZpi+N/nP0qn
         CCEUWkIh7w7v7yFw7Ka90+w4XwePfoZZMNmE95Z67q//yab58k2vPq4mUMHNrX/ny0rT
         lztbpD17efmc4Yo1kTZgqTWxQyLSdMFoAnYsApctQXm4VrrSm5WoZqx2pG7gjDZXr6oU
         zvzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795528840; x=1796133640;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=o+7iSwGfMjtzT2Y6Ygii4nLjUX3g93NcfuA7HOwwEkw=;
        b=Cf/sH3IZ6mhc6rjoxcUAlVc0KRAH5VeZqFlrLP2xBerIFVfSoLKzrJ2z7UjBGai/Ne
         bIE5io9cBav7RWndVJ3fcICo1xVxOQPGgSeLR1Qa6dZbLMdyMY0zpX4q8MT4vWB3RyPX
         5QxVuAdGj7H1YF2olcNbgIXA+fPm3yCln5ufWiO9lnorBSMzjLxILaoNCRRvUSJYJRMM
         ROjonlDrPUYmTu/KZpuQmXRDAtBlUjZAliYiZuJQIqA474LFsJSnwaMoWMaK4IgdTkk3
         q3AoTD1UdEhkP6CRBrP52t+OVLCx0HYU01hDBVKtLHdPGRw6v1oOgDzv7Haz7wCgI05W
         eDBA==
X-Forwarded-Encrypted: i=1; AL+hErFtCggDXKLJLmo5NoJm1zCZ+5T9JuxWJsxixrLIA9NY+vCow9AkkGAqC4x+0m/hdJN0eVGne2/gfg09@vger.kernel.org
X-Gm-Message-State: APuU4Z/dhtzBWRJhCq6lnqkVFEO6T9w8vo7Y8AHm/GBHzp2nOybsebHp
	kYRBYhEX7xjAFJDa51BSiwVsLSrqlNUISBuHdNTBJcieFCJ0XJaTe1hfVBwmXuPg7Tg=
X-Gm-Gg: AZFdTZcMpLboP+igRCvHa1dCSCIq42dZp7ewJo2/bto8Nj+Fk9D6ZgKnXOxEbIKCc+I
	1RBbdMTsUS6e4vpxCSnKaTvDTfLuyoN2ycTLm9GEd/bld5+IJ5qZZ6Fk1Lyh8h5UIYP40AG8klG
	fAWrRbS09oF7JdhIIRJgmyLi00qYsJ+TVPnAvEvZlf5MFEi+Ngv3b/mhNKbHHxieeGiu7nGJQGI
	XZmIwjgQc821yT6jhhaqGUcklr2FTocgs3D/VB5J1NKHTtFIPavUzqO2xelOKDcZfBSBuF3MHLS
	L6m/l+eio1MRY/eWO5u/phdof9sLUz4ir9Tfwcd+ueP4rogRKAOX/o1R2Ll4NUixJy5tDHzfdEI
	Gj3bt1k2S3WV2QBr/dyZ1vUyXneGAiUI+0Yv7NJGabbWSFG3k2tWA+HQ7CYDC0vd0rDGrLscgLj
	b2e+IQX6gz5dCMXijLPmLuwnAw1sNf2VIxn2dlD4Ko8xoATlDralW2JG6U0AvAptzVyGybrgDGt
	5YOONuq9JpB0ej97+QT6l4B5HsigxVs8Xm8JgTRm8sEaPhgnVdMHtdY1PgHKGuZ1/eZpG5Idisr
	t20cpg==
X-Received: by 2002:a17:907:3e86:b0:c36:777f:824c with SMTP id a640c23a62f3a-c51315851d7mr1405271066b.4.1795528839874;
        Tue, 24 Nov 2026 06:00:39 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6ba370cc257sm6492195a12.13.2026.11.24.06.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 06:00:39 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVr4W-00000000QnE-3MAi;
	Tue, 24 Nov 2026 10:00:36 -0400
Date: Tue, 24 Nov 2026 10:00:36 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Matthew Brost <matthew.brost@intel.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Dongwon Kim <dongwon.kim@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	linux-nvme@lists.infradead.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org,
	Alexey Kardashevskiy <aik@amd.com>, zhipingz@meta.com,
	treding@nvidia.com, jhubbard@nvidia.com, chaitanyak@nvidia.com,
	Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v3 03/24] dma-buf: Add the SGT DMA mapping type
Message-ID: <20261124140036.GM9566@ziepe.ca>
References: <20261120-dma_mapping_type_v4-v3-0-c0183a409bdf@nvidia.com>
 <20261120-dma_mapping_type_v4-v3-3-c0183a409bdf@nvidia.com>
 <ad46d60a-189d-4dd5-9ad8-ecfd3c90f9d9@amd.com>
 <20261123165716.GM179082@ziepe.ca>
 <7ac7edd0-5c38-440a-b26a-21bcbb6f4702@amd.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7ac7edd0-5c38-440a-b26a-21bcbb6f4702@amd.com>

On Mon, Nov 23, 2026 at 07:37:41PM +0100, Christian König wrote:
> > Part of the design of this series was to allow the conversion away
> > from SGT to be done incrementally without breaking compatibility.
> 
> Do you know the joke from the hitchhikers guide to the galaxy where
> the dolphins are happy for exactly the same reasons?
> 
> I'm pushing against this plan for exactly the same reason because I
> think it will make the conversation away from SGT even more
> problematic than it already is.

I think it is well proven that trying to do big bang conversions in
software doesn't work well. :(
 
> > So it is effectively this:
> > 
> >> The framework should then either connect the SGT directly if both
> >> importer and export are using the "classic" interface 
> 
> Yeah but that should not be a separate mapping type, it's rather
> that we just convert back and forth from DMA addresses to SGT for
> compatibility reasons.

The mapping type is to support ualink/etc that don't do "DMA".

Only DMA API can create dma_addr_t's, you can't reuse those types for
something else.

And you still need a scheme to negotiate exactly what kind of
connection you need. Focusing on the SGT is missing the big picture of
why this was organized like this.

> > As this is actually quite complicated and needs discussion exactly
> > what it will look like.
> 
> Actually that is the easy step I think because quite a lot of
> drivers already convert the SGT to a DMA addr array outside of the
> DMA-buf framework anyway.

Given the importer an array is not so bad. Getting the sgt out of the
importer will be a debate.

Jason
