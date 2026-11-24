Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795530037;
	b=fMvJxkuolKIUKQr6Ux7LoBuSwVObiuXyGAWylVSSELiaFVCKUfWdRRW8nH22ZqfcLsSI
	 o8VzMQYt++b04eoGU4MuLnFOKPMA5JR1eoETvW3iM5ZLeRAZu7/+qhHmR9swk1q4lBRbS
	 FD6cfNmBwBINnen1J0CkQ+/oxb+Jj15vFAnHN1oKQfauVhDsEwzGFR1JAtkcAz5Nnm0m/
	 9FTdm42O8T4sCWCmm0TUFL6NMZrclXRR0V1EgLSIv/TRjlnNoLnu9B60DcAaW5cyB3O0i
	 6xmQl9FXWasWPOrFKwfLkxNpf0q0cgr7WuG9dYektueg4DKOMHLM7TSmrTW+GNTITMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795530037;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=Hoa2uDGRiz+jXLxbcD4HBQF2SzMfWsHt0csEQeOTfAo=;
	b=PML2tytbhbvznKI8IryWEw4zH4+LqGX6UsLpaKbug8uuMKQcD+jX+JUAKMojXVyqLO9X
	 FpNm3WEnftZ8AwURj1dnNyXM6BEH2OgLFCDwlImO9xGSUkCBZs3QRHU2troL0MoZxzYu5
	 g7LpkdWK3VgPWbqP4kxFgLp8cgoRisDh0dQ19MR9I58Z81xg05HoG7dGPKl5lF+ini+OI
	 Kq8E9FDnZC+uUKOoKDxR2X9SKy/KlYZs2fC8elPAKA1DcC/w9hZWftGoQo9LwMJt+h+tB
	 2qSGsxoeANhj4AbZpIt/P5UOs/8EC9YHXXkWT1Zq/dRucXdI2VzDaUU9r7fLqtkdlig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=jBiTgo2W;
	arc=none smtp.remote-ip=209.85.218.51
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A021E606A32A
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 14:20:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A021E606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=jBiTgo2W
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c4d2b741ed9so744871366b.2
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 06:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795530035; x=1796134835; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Hoa2uDGRiz+jXLxbcD4HBQF2SzMfWsHt0csEQeOTfAo=;
        b=jBiTgo2WnjFhpkgbIBu6On5by8ux66WiKBLBzWJdf4Pf6RCn1pmz1agYiK7SMfaxFg
         3/2YrNhOySAcSPgNeJdOxPH8P45jGqKY5S64rDyy/GqimZuTwtSLFUBdu/5vJlpZdzzr
         s4bwl1Rg4R2P3YXWI3cJVNf2474sYNB2WqyefKmd2Q9zmRyjanVGbBx1PSJBmR/NBbVb
         Em8am7TBb+PrC/eYOYbEaS+JpnHnvhpW0bM+eu6neOm7LPUdBWC1Zs5EIHxnkkBtcy2S
         FqTLqasaecjeohA6M/KuBjaSrElM71neIK7tdakJn6qod53aVVQSxRc62gnUmZLJzDVT
         ZSLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795530035; x=1796134835;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Hoa2uDGRiz+jXLxbcD4HBQF2SzMfWsHt0csEQeOTfAo=;
        b=NSYyyVpbhiEUdoz2soCeQTJYhB30J3uxU4gQQVOT60HVmPSmXhCs3w2oW/9kBFs/Nd
         NkprEVYCccenwo1Nf6/feHSg47XmkkpGWSs1lRT0o59NpUMr/Sf5Cc6AQPdlhmJ+apwI
         m/6xoNzjHgTPSdcW90hNJ+lCDcf38c2fQU6AfshAyj4WRDZO7zgm/TG0awe4Bt4cDO2/
         Dq85fHYh9chTnxMiJMXmSbzSG4/dB+7FTufmSZr/eE3sAypKHk+0L3T/eey4kK+UCxWB
         KtsUuT7XDZf5Wyi6Kbr6zWrXuU+5zxqByUO1zr23Yf5CM+UF2hr43rEhJ+vwoVXRNkRf
         t3bg==
X-Forwarded-Encrypted: i=1; AL+hErFui5MPnR+WPoIXRtRCbayDm+a7KqT21yPSqw+i3aVrL3VP/A+AdFVTw/0jLIkrHoOxkE5O/Phtaxd5@vger.kernel.org
X-Gm-Message-State: APuU4Z9GtkYaH8DkppMdrl20mm3h+o6m7HNdXvGusxLDF85ZzXysxaQx
	xvoHd5BEHmV8SRIFLZVWSSwXBznXEnpmcOGjVaAcc7uRcBh7hXDoFI/XUrNplxIspLg=
X-Gm-Gg: AZFdTZdKpenMAsEnqKh5KfyGWOId3958UBxK6Z4f8IyJyZQ/JVTNUbp+Lb/UCv5saOo
	04VEooeb2eqj81ikRbUDZZHrc7U1si/kR0ol20MFEcVi9X+LodvmHmVQJPggOj/4lGZLUpPnLBf
	J5GYKcXMQRvfoYsKCWh3TmcS7u+BzBCApL5u1IoSwD4iSFx1l4TOvL0q6m/9zdX6JLvp3AiaxWN
	GK/uHrj7MIqzBBfK8JXbdgZkFQ3UwSFIkuPzGthFYWt+A4XirAkxzFMmUoiHvIpkDLpLIcC/v43
	IINAxRtwev6ijMK6laDNEQD8VRrzckiPvKNWS6bLyQolbH41A0I4WnWfZvgX87PVWJEkNEnitYe
	WLu153OAWeN1EpRelJo1XkSnnYW9qpdb+cE5SZNup14Ap3DUrYHKQWvKY5I6YGcJ7xDuFbiaDTk
	rZUNjyAY8bBDsd6l4TeRZG6gJQUS6GZdPvN4FTGYLbHUZOy0E7Yy5wkb3YQb27TUN49HkOHz9nJ
	/e7Wr7VSm/L7li6lEQnHJp1483u2xahCRPVPFA+roZel/D3kM1gKqYWKFlEAzeam+Acpi5XlUF5
	hHhhLm+nfU2sa5HERl7UbNpdU2k=
X-Received: by 2002:a17:906:eec9:b0:c51:5589:35a1 with SMTP id a640c23a62f3a-c515589d211mr891019366b.5.1795530034479;
        Tue, 24 Nov 2026 06:20:34 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513ae8dc60sm518286266b.34.2026.11.24.06.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 06:20:33 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVrNo-00000000RS3-1UVp;
	Tue, 24 Nov 2026 10:20:32 -0400
Date: Tue, 24 Nov 2026 10:20:32 -0400
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
Message-ID: <20261124142032.GN9566@ziepe.ca>
References: <20261120-dma_mapping_type_v4-v3-0-c0183a409bdf@nvidia.com>
 <20261120-dma_mapping_type_v4-v3-3-c0183a409bdf@nvidia.com>
 <ad46d60a-189d-4dd5-9ad8-ecfd3c90f9d9@amd.com>
 <20261123165716.GM179082@ziepe.ca>
 <7ac7edd0-5c38-440a-b26a-21bcbb6f4702@amd.com>
 <awT8prWsj11TBdmP@nvdebian.thelocal>
 <63eb7b6e-e0a8-4443-a434-0301ed59beae@amd.com>
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
In-Reply-To: <63eb7b6e-e0a8-4443-a434-0301ed59beae@amd.com>

On Tue, Nov 24, 2026 at 01:36:21PM +0100, Christian König wrote:
> > The core then negotiates compatible types and adds converters between them,
> 
> I have strong objections to that plan and would potentially NAK it.
> 
> DMA-buf should *NEVER* accept CPU physical addresses nor provide
> conversion between different address types.
> 
> Keep in mind that DMA-buf is solely a container for DMA addresses,
> nothing else and it should not provide any mapping functionality
> whatsoever.

dmabuf needs to provide support for drivers to help them use the
interface, and going from physical to dma_addr_t is absolutely a
common task every driver must do. I don't care how you call it, but it
is a service that must be provided by *something* and matched to the
needs of dmabuf.

I will definitely NAK any direction to open code dma mapping in every
driver again. If we are going away from SGT then we are fixing all the
DRM mistakes, including the wrong open coded DMA mapping, sketchy use
of SGT, and abuse of P2P that seems to be endemic in drm.

Meaing the exporter constructs a phys_addr list, gets a P2P provider,
and some common code constructs what is passed to the importer. I
don't care if this is in "dmabuf" or some "dmabuf library" or
*whatever* but it must exist as common shared code.

dma_buf_phys_vec_to_sgt() is the template how to implement this
transformation.

> > and having SGT as a type is what allows that. It only exists for unconverted
> > exporters and importers and eventually goes away once everything is converted.
> > The idea being we don't have to convert everything all at once, whilst also being
> > able to add support for different interconnect types. Are you ok with the SGT
> > type if it is just transitional?
> 
> Not really, it just complicate things.
> 
> What we should do with the mapping interface is to add the
> information in which domain the DMA addresses are to be used.

You need to negotiate the actual C data types too, especially if you
want to do that nasty idea where dmabuf populates an iommu domain.

Jason
