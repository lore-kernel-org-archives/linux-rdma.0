Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795453039;
	b=TeVwMiGxGuUepEpmb8/3cWCJgQfejJuG9Orx/C7s40vkmWL8p0T6GdVg1yCnXMY77hq+
	 MtTWpvOrY/B502EvrwY8PmbMqCpbbR9HiaM/kFj6TjTXA8NZoXyFM02od6tNduVtP47gv
	 tdo2rg4HdUjMiXKB+BNQRx6gpaXG1C5Qnn336LS5N7T2xKmYPf3d63TOX7+ISz7AVRVXg
	 3LvCWNERpSX9u8u514OOwb1aHQmQi+JmLFGjD+KcEfdLCvkscxyhflxxiZOEmSZuw9U6+
	 FrKYIuUJ8ylNa7bbgiQOEUixZfi0Qg2AQ6mQ3QpsnTHV4sCQzNKBFLcUYp2BXe8QIwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795453039;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=j5i4WU3qjrhh//MRl3wcVLLT33h5NdpwdC0V5dWlBjs=;
	b=1pCSisdg+kB32Y9ukeo1Jq/OL+cwVIYyNeNT/TSC+C87d3PsPjuFrtrISMPPIAqCanQo
	 xrrDliv4NcEzpBwfTqRtpFZuVKmuA6Q4QsDOiO1A+4EqH2u0cpcYcmfZb+b/AHhVlttbW
	 Vk0Rs16dKVXkjih10WVR55tGJAEGXIWUt4b2sOsxvASD6cOs2aLb5NI1iVDhcevVbOfl9
	 9lEtxqZu2JWrhP7SXTlhoSQ/VTECOOVo9jEERUgS3JXfMlb1s5lEbOosMEeZyn1x+ZtZr
	 tbj1tx/2iPkrL29/qIyt98B7PP8Iumypsa/fVKwSH2AzCLjCpz1KqfB5iKhF4lFHDsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=M0q5ij1L;
	arc=none smtp.remote-ip=209.85.219.49
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0992606A31E
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 16:57:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0992606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=M0q5ij1L
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-9212dac247aso37819586d6.1
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 08:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795453037; x=1796057837; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=j5i4WU3qjrhh//MRl3wcVLLT33h5NdpwdC0V5dWlBjs=;
        b=M0q5ij1LhLu1pt/WBsCTfGk2pgdeixAIFRjKrLvHL/TTIbhR0zt6Py+dVE/jZCi574
         A8p5TyscgxlbeCsN2akPCKF/4Um0svMxtMatqEPC/2EBpqTcJeSfimdHF7dS8Kn/NmhR
         fPcup6GYHWoAJR5DTrkXCJUmy0m0UkqFuQbOrzCu00RVDCiRq1oTKMQMxk38soR4095I
         p8ph6lOgLEJtA4VE9QO8AtZnh3D9Rp+2YCN94vxecamNCBtfMhYrqMY/8OzDajFYcYL5
         RMMotB/CqaFXeKYlXBaMAaqAxQjbgnQ7b+ojHvRq3DU6MG2WDLWnc5aQbE129lDGEHax
         NPOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795453038; x=1796057838;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=j5i4WU3qjrhh//MRl3wcVLLT33h5NdpwdC0V5dWlBjs=;
        b=Syt6uSj20djiXcfFaE9NnyEXN9VRUtI2Hxmvq3ysSRuI8RTu6q5RBEgRFVJGhBVp+F
         28N1Akmo3DQoqUzj0Ay8nxFPpD4NnYg6t9JOpJVQdEnupXuKDX4SOZpsZZU+fGe4jaiR
         gZ512ZL0TgDGt6j1yhzmyzCnAlB3GFnGIxqeVvWPwaX/H8fpAnh5bPjUNcktsaxptMEx
         lcggTB0abKr61B2who6E54WigChrDFDNnN6a5/iEsOJCHEoZzWmuXQuA7OowT9sowzl3
         tZaBcYT+2TtWCQzx98QXijnMAWKMKcoDNaEeJBon0jEukjD0ay0o7FgmwhNaPZrZ0H6N
         Brsw==
X-Forwarded-Encrypted: i=1; AL+hErHw+VMZV30nuA8VIRTzcJYMA0LPu0dccL7tMvPm8lf1lhCdRUrdrhqNVIV+6ErCU6ct8X2tKtsz4JqO@vger.kernel.org
X-Gm-Message-State: APuU4Z/iEljkl7sobQXbuuk0Y6UDG8Cye0VVDBxciU2pZ+81jOVjxgPY
	6nc3D8Wfq//KMsj+pqo8Bpv/Z1ONcpup1H5ty3KkmKQ0NMNhKZ6aCHrWKExIAsS1zM0=
X-Gm-Gg: AZFdTZezZ7APH/B/7/a2kv+WTF9vqF1IlOaXe0FH6+KjxS5Y2PbFyqQ27dTwfdttu9G
	J4T5mOmrwneZvEGVJHQH38vfevIjhcgbA/XwpgUneIosP3gSWli5FbUZQQ0FxGjMdEs+sdeabr1
	XAF4peyPOgVwPYJRtO8A1iNH6uRqYxAEWzR696v4rZ/J/DBJOSmbGVyG6yEzFLP/t9QRMipHN6s
	ksQrclYdbe7mxibI9diUoL/Go0z6PLvrlpMe8ulsME8RRrXfONcBa5clJkbpLOiK0hiG1+WoRwo
	0K/uP492mpV/l+SOrlucmz5TkRxT8BubxYwh5T69hT/wp8PpY+UiRkIOPdvb0vL8TFLe9ZtTDER
	1oU4M1gBj5AfuL2X7K0KRYYsv67/KR0QxF5yma4/jLkN9H+bHHNzsaj+KNN+5VePf8MX83oEPRs
	7koS8pXfmZMkK12SxhyFbkRKaH31MrAJrCNQtGzAH7UPJyFW96raOOIoGKFTsCQ47NkWFgXV3lH
	4PVZtqXQipkA7JiWkNLwp8m9qjQWzltSd+jJ/mD7FMjx/NTKFSDV7LFAZxnMDXnzsApqKfHnCzk
	eyS5i3m/OZAMDgf0iy1MF0W69CpuGQ+AYHc+TYMs7hSee0QRwE7ltVEjcq2YnbkxC/1s43/1yca
	nqeAu0fV60tGkpVeDQRF0gKw0
X-Received: by 2002:a05:620a:270d:b0:949:8109:8bcd with SMTP id af79cd13be357-949bab6d24dmr1950593985a.77.1795453037117;
        Mon, 23 Nov 2026 08:57:17 -0800 (PST)
Received: from ziepe.ca (stjhnbsu6iw-159-2-142-59.dhcp-dynamic.fibreop.nb.bellaliant.net. [159.2.142.59])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb031601sm844162485a.6.2026.11.23.08.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 08:57:16 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVXLw-00000000woc-0Jy7;
	Mon, 23 Nov 2026 12:57:16 -0400
Date: Mon, 23 Nov 2026 12:57:16 -0400
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
Message-ID: <20261123165716.GM179082@ziepe.ca>
References: <20261120-dma_mapping_type_v4-v3-0-c0183a409bdf@nvidia.com>
 <20261120-dma_mapping_type_v4-v3-3-c0183a409bdf@nvidia.com>
 <ad46d60a-189d-4dd5-9ad8-ecfd3c90f9d9@amd.com>
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
In-Reply-To: <ad46d60a-189d-4dd5-9ad8-ecfd3c90f9d9@amd.com>

On Mon, Nov 23, 2026 at 02:36:46PM +0100, Christian König wrote:
> On 11/20/26 06:55, Alistair Popple wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > The SGT (Scatter Gather Table) DMA mapping type represents the existing
> > sg_table/scatterlist based DMA mapping. For now it continues to use a
> > sg_table for map/unmap, but this will allow a future patch series to
> > convert to using a different data structure for importers without having
> > to convert all at once.
> 
> I strongly think we shouldn't have an SGT mapping type in the new DMA-buf mapping API.
> 
> Instead we should have something like either an array or an xarray
> of DMA addresses.

My plan was always to get there, but I don't think it is reasonable to
start there? There are too many places all over the place that are
just hardwired to do SGT right now.

Part of the design of this series was to allow the conversion away
from SGT to be done incrementally without breaking compatibility.

So it is effectively this:

> The framework should then either connect the SGT directly if both
> importer and export are using the "classic" interface 

And this:

> or convert
> from DMA-addr array to SGT and back if either of them are using this
> new interface.

Is something I imagined as a followup series.

As this is actually quite complicated and needs discussion exactly
what it will look like.

Jason
