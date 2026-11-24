Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795549581;
	b=LnxaFFdp1sd4y1vCCjUeP8U4fBJ96PajV982nCVSnGwR9xUhthaYnCSN4ldqIuSHGuUk
	 +Q/4e4ps+Rc4aHASxvJQGXy2n2pNq3rS+dEuUb3tupKBfl3g24cpGXSeo1LTBJEv/sBHb
	 FXQeV73pypUt7sq+aGtvHEZ4XuASm8cDxjVuaLRCf43LkbS8LN0gtTVAPhwMrq5bymlIx
	 c27EmJqONqk5+dx17c9rWH4xFNWfTxrtvjIeUAtTsjuKnXacEIv6ptBAgA8+uDkOxaulq
	 AD8aG0tXeuUGrOLCXDzH5QMvqBDl8yqAz95kjmvylUEEb351p2Y3DCug55NvTTCuVxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795549581;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=cCMOaZdag+2OcXEDMl2EbRqTcxfKhXeKWu4Qydoaad0=;
	b=Jscq8e9ifpaHNUgegRYcs31M0pfnoXZt3QU34phBLWDkNA2aQxQjnRAfq2sWFKXuHE6D
	 bOdhz3pgQQGCXXaoYNVGzCYDXv7tqn5y1DeSELenF3r+G/JXLwBDm9t9iIkJmlIp1N0o3
	 dUtpBRAfXWupfuJeQDDJlFZBafR1Md9QCX3XQaFei2T6uM9gS+UM0p4zCTG2Y4FyWLE2H
	 TKBrB0saEuu6HtQCFG84JHYTlpfuuN24naZge/DGixRRsVk0Ju6SlYMrzVxwDdT/yR2p8
	 gCnqt4ncUt8WH/BobkiEUp0ONDMVWFbsb2XRwLGvLIjbOSY+EgtD+uYAI5PLJ3MiIfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=hNzo9bKF;
	arc=none smtp.remote-ip=209.85.160.180
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B66606A329
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 19:46:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09B66606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=hNzo9bKF
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-55d360ca878so44695121cf.2
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 11:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795549580; x=1796154380; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cCMOaZdag+2OcXEDMl2EbRqTcxfKhXeKWu4Qydoaad0=;
        b=hNzo9bKFfhVQc9qzPT4XFVGb8WWDhkAsWzEGNeoMtQsVv/UieKFHIx8duXK+pVyc+7
         K5tuXAPvt7SnRa+oW1TYccovCbxEoQMg8PMSal3gZtNqnBkfc9eaI8iRduIFPXdXeGyC
         7IqbxUGwhapkSK1PkTGpbVYuC07dIRe3KRRo51bldaV5T8p/83gXtSNREqT8fVb1HMZP
         lRwnNEOCDprIXQY+fn4dNi7XyHXAEaKdOG2aZhU8DQiLg94XiGTcamJqB2smYFg1x/Sg
         siI5MDO2hfLOudZP5xdAkje683/c7T63Kjq3de7kKz2KbuVb5db1oTFbL+o0yYQz2SQS
         i3lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795549580; x=1796154380;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cCMOaZdag+2OcXEDMl2EbRqTcxfKhXeKWu4Qydoaad0=;
        b=2MJ09lRloZPLEVtGOaqAipbK1QVnUod3q0sNbbPwz0ei2Cy/bFQMG5G0M8Z7OZe4YQ
         D4fnDIq4ttqFe0XcHXfJBD3NXtzIGxsNZkXi+Bj2cp36YcuzRMt8/9nXWVT84jJog8Ny
         qjYvQzNMqQnk2IgrRuCT+1mx/4NYJLzmAVBXhV8CUvZie/JyK3SLOoLmcyYyHgO7Gf4D
         LE0lQ+RxnQrbdHI1t3ukmVvFGfG0htUvC+tNMKw+nVTpokPq1ZOrCMyYceBoHmrn4ddF
         Jor2QafUmRobfNZk6XcgsOASz4O99zchwImdsxXMI0+YoZxSj7Vo5dZcMY9/vPP9pPou
         CSFQ==
X-Forwarded-Encrypted: i=1; AL+hErEC/KBAE5GKxKCtpvuOTPGI2dPgOX31pxBIvUqA0ZUYiL2tabGWcuimcvUqsUoJIa48sEiEt0S2lKwI@vger.kernel.org
X-Gm-Message-State: APuU4Z9DxyRK2gbxD1T+NaLYGGoebptaMFMPLR8na+K23CqrxS1x/nG+
	pTcZryvxwI15U63tlcs6zGAmbeFuIqqVyPtaJwA8Rg5LPOCZP9QoxMybn/7Cb+lGIvg=
X-Gm-Gg: AZFdTZebhjjolqJtikt2t+iuqt5DCMaTIYCSWP/Nz3mGEAhgrlCSMgboh4boK9dsy9G
	fupD3QkZ46P82rGEfDterY8tktGq8tBe8Xrt97mO6o+hkE7i2bgBrpIvg8Mi8A2kke86jMbxkmu
	znxhbM2Z4OTd5ws2MYTxChI0abYkqnVf3FdJ/deNKMM7fP94E0QDcqJMfBTS2kZ7EL4MvxcfbHf
	SeK6k/U84iVUC4H35U798CnN4yOuB+pB4z10ayHNfRMRWPQmuIEtSNCGbdHxBrbofh20Tbk8lNu
	ZXxx74qn2ejzmTNhBrhMC+ET7exgvzsr9rzfrgXsgQ/NhiqgdySE61PvtGjkqivSXrj2bL/KWRP
	53k5tT1Niyd9ZMqlZJz6PpHs5SyHSKxGG2vaPqWkI0giNTUbPDTA+ahSBuGXXO1BaHMXMetDYdJ
	2BjxYBXDp+BPQ5AmNrDHKultP/mZiIk904SY5SeFgx3dPiVvqz/dRlxiF1mMIXrino57Xifa/f1
	gRdvo6Wq5/WVcGOggy97D6F0Lu7P1eRQVc5Vqt2GOb0BwqPnMiWIcHtWlmCPnnpgROJBnNtwHVC
	ly/S4Q==
X-Received: by 2002:ac8:5c8a:0:b0:55c:66f0:5bfe with SMTP id d75a77b69052e-55d76a6f55fmr288174681cf.22.1795549579924;
        Tue, 24 Nov 2026 11:46:19 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d7882ea2dsm135596661cf.15.2026.11.24.11.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 11:46:19 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVwT4-0000000113s-3B2s;
	Tue, 24 Nov 2026 15:46:18 -0400
Date: Tue, 24 Nov 2026 15:46:18 -0400
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
Message-ID: <20261124194618.GC114530@ziepe.ca>
References: <20261120-dma_mapping_type_v4-v3-0-c0183a409bdf@nvidia.com>
 <20261120-dma_mapping_type_v4-v3-3-c0183a409bdf@nvidia.com>
 <ad46d60a-189d-4dd5-9ad8-ecfd3c90f9d9@amd.com>
 <20261123165716.GM179082@ziepe.ca>
 <7ac7edd0-5c38-440a-b26a-21bcbb6f4702@amd.com>
 <awT8prWsj11TBdmP@nvdebian.thelocal>
 <63eb7b6e-e0a8-4443-a434-0301ed59beae@amd.com>
 <20261124142032.GN9566@ziepe.ca>
 <7a5a2d3a-e42e-4dc0-8d22-8dd1bd249501@amd.com>
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
In-Reply-To: <7a5a2d3a-e42e-4dc0-8d22-8dd1bd249501@amd.com>

On Tue, Nov 24, 2026 at 05:02:31PM +0100, Christian König wrote:
> The whole conversion from phys_vec to DMA addresses is something
> some API should provide based on the data the exporter/importer have
> negotiated (e.g. p2pdma_provider for example).

Yeah, probably, and this is exactly why I think it will take some
time. Building a new something in lib/ like this is not a
straightforward task.

But also, this:

> > You need to negotiate the actual C data types too, especially if you
> > want to do that nasty idea where dmabuf populates an iommu domain.
> 
> Yeah agree as well, but to be honest that task is negligible. We
> first need to figure out where to put the code.

Means you need to get the phys_addr_t into the dma-buf code so it can
do this conversion.

I'm still absolutely NAKity against allowing any DRM driver visibility
to an importer's iommu_domain if we do this hack.

I don't see how to meet all these concerns without making dma-buf into
a "converter" framework...

Regards,
Jason
