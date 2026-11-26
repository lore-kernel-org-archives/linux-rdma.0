Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795732202;
	b=MgtO10okkv6BDczBAlFlXUU6o5Vaq0Y1PBEhsnKeOlgdxwKEgkjb71scq1gE5YKRpuvW
	 MqOtnTFusbTYKf1Av2z2+Q/egNXYUbH3LcvMvgQr7ngBU+G8NqF4GpO+Cf1WBHh9SxxTt
	 ZDcerNZR4FT4WsFEsI460UN+VOjRmXmYGMNfQFHJlUVmzhFtNIN5nEQFoHoVsoiYdKmFR
	 ka4zzX71hd8fod3CNSRevGha3+FY+8kenuWmPMgllEkl6hchUkyBGrs6cjMHzgf4I9WiZ
	 c/yNX2CjZHDwekBa46OwHQfuX/W7hUFjqwrjPtn3yi0OZD/Z1VeTCmA66a3K2LLeX/Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795732202;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=MUCXb4AyKiyK8pPk+hGYGeIEyQmwImYeURjhzfVH220=;
	b=Nn3G4lY7o+sXcru42982vqaONkzGUfs2iB1JGyRaoXLPxDkBNZIwgHMCJY/AETG9pnBT
	 v24TIMWvCJaC3D6LsUM0CP49j9Pk7vXp0fzRxDHjlVqy75A5kEaUiUrZP15hxupA4E0TL
	 zXlxKSCFmUzcWg588WRBwGCo1DwCkg4viL5+54FwDAOlqm61J4cn/zZHA/e9Mg+oyDtQ2
	 kAE6fLEaYnudE2q57NvqQQ8PWue7Exwx1StlNglXAr+Te4gElhrzAsbgcWGJjmralbyrF
	 C/DJozJMpRja5s0aUyxiM0ETE2g7GA4cYiTRtrtpRHcVJqJmRkNncRby0w+6PR9cREg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wc3hcrgp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.54
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57475606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 22:30:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57475606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wc3hcrgp
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-92134c4592dso65091086d6.0
        for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 14:30:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795732201; cv=none;
        d=google.com; s=arc-20260327;
        b=HEETNP7N7m1n9iWLN3Xb5WpoaQ/jOTqOWmgfaccCC3RqxzeiTh1qcQVMWi2qOB9AXN
         0YODikGFVnwVHQAqkQO9pjFp0rTohGxnhZn17MCHJy/PMKzi/4L1Qvzn/tKlhrdfA+eN
         tuygg7VyPSxVh6rsPc8ogSYjAB3OVdWIj+iHwP7IQSoIDAJUcyNXTxtYHTTpoHHN2/zE
         nOBmokEig1rEb2Xm9o/LVdfodFNB6xaldJFRgEp1iaiiJLWYF8+pSUchgBl8htALm/xf
         XdkhzF1AKvIqUO5dKJblkH2MxIGwyXHknWN8GiUyuHZJvc4GJVS7C7vExmWGCwfhocBP
         dBxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MUCXb4AyKiyK8pPk+hGYGeIEyQmwImYeURjhzfVH220=;
        fh=9BYFcvqXIbwbL0c2WRXjTUvVfnEIUuZxwUMo6Pq3kl8=;
        b=JQGRlolRD3s0oxyXwIKlNUjdFfybyhGGw+9Z4m6O8DpXTbEl+rG5zn6QkAAC3LpWgz
         vT3sg73qlsq9ieEI9CWyBUZ8x7tGthjTpmiOSDl76jJjzcMXLfLwsYU+wH4qCPCWep1a
         vEnWZ5uNtJNzlj1ssMTrUZ8h2cKxZ8jfwPkNvRwF7+7D3UobD7n2P+02axs3tQmkKTJ/
         Qqp4kfjUDoHCkjnM0kzeAx1ETTfkaVVqWG18D8/kYnHPa1TMRoLocGsE2oni263MdV7P
         JRSMwurQm/uSvjEJD+HKETXTLsxtZkgumAHVGzTjeFBIQ15gideoqvyq13zDbtpIQ+sY
         ARdQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795732201; x=1796337001; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MUCXb4AyKiyK8pPk+hGYGeIEyQmwImYeURjhzfVH220=;
        b=wc3hcrgpQyGy3NzEGt5a1A+uGla3D/nfNujGZRFuKyIiFzGqOi21KC7DS2glXgMkkm
         9h+Y4LWOCdhZ4sEeYplSgjFWfGOy0iCWIPHuZnevX4/R3jFDvCOgmtppJtyFtx1IxNdH
         eXAQ2kMqLigrG3VQ7L3vaBZAxoIJsEIOVBSmO4v+20XWj5DUiAY/3UBMNyfrzs40DHnk
         r46jDcx/WuEV9uFDWfB6U3jrMvrhigI8lr20ob33mdCUncAOmSF/tRl+SKLEvXo5d4my
         7a5UMj4aKiGjOk5KCF0X2jdUx9ks4t5/JZk8hoF6YckdILXvMPn98jKHI73lbTL6bDfW
         9Dzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795732201; x=1796337001;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MUCXb4AyKiyK8pPk+hGYGeIEyQmwImYeURjhzfVH220=;
        b=VRJ2El+FAQLJW8urdZDHTkq3ogZ2Wu0WLVXDco4bvy6u+P4ZtfeMBcE3omrzhzm3+X
         9xPzBwQ/6WZ5pOc82inYHGoI9hT0rm9vAVbl4+ZQCD4xD0iaPPZH1KsdIom8ThpR5+f0
         vVUEVLTNTBAIqatFPRp3GwjVDoqMvYSTuBDJkhJGI1x+sTFrDhJQt+29EbFQvkIEz7S6
         FlrC/nAkQVmpkt3HSVshoMfVbENjz4tyPO9Owr1PIjpLB2tjPpoxnSWDD8JXtfoIJyeg
         TVneuhVAFe1vNDZZ+1pW4uZwYAMfY026Hq/88DZWZPtKNkXWIuntoLwulGwCMJxa9zlc
         5bEw==
X-Forwarded-Encrypted: i=1; AL+hErGyxdeOv+QxjMB93tK8kleAj7/i0Rk5Pkx/18jwAHDPkpSHZRd/t8/9Rx/C6zB1CV25yFxsYm60t5Oj@vger.kernel.org
X-Gm-Message-State: APuU4Z/7xkFD2KMbcRhIdlPAvcLxLOSCKCHclV+10Bf+TvYjSE0iO6G/
	UNCDer1qZeaHEIG7Ap0+5GeemFplnR4BqHhWo5SF5Pa2U/V/mPI4jV3v6wVojwSmhVbobmvZ4WB
	gNwJy8rJOb7RT4BuUtU6I3nN8AXSE4mg=
X-Gm-Gg: AZFdTZctJz+EnH74eRS3FgPOyj5h5CselJLENJZA3pawGHYrsHJLahiXFVRuE5neE4r
	tdSvBeVli8DUtUEDLZ7DAEnxLsoUpDe5NLLP7inbWSHQMAt4rGIg9Uxi7Nz3VdTtFVn2XEg8658
	QPYG0iNQttpNYln/cpRuvPjj9NLogeRCT+W+xHiwz4Ec+hiJXxhksvxwHA7D+c5eIZImkaEvCdE
	WS4MRcplXOS27ScuSe4A3zigq2iGW4xKPETiWI/C8BPCN4iObdUhflTW2vI3DdYa8/uqOMG8hRj
	dQA/Vm0Q/1eGUeITcIBmWlviybHSXILcjlOuymA7tgVKpdHPu9uSEE0SNFjikqiojVxZm639iJc
	P1IY27CNFOaG56uXQBEMUqMQWDI0ErYHVmnQv6GW/nrWC5wHmgmuODOPH3i7I2aiWqxOs94y1sm
	CsY1M/GGpTl/rlZjFv8eWK3w==
X-Received: by 2002:ad4:5d61:0:b0:91e:8bb3:82 with SMTP id 6a1803df08f44-92134988818mr432424486d6.4.1795732201165;
 Thu, 26 Nov 2026 14:30:01 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261120-dma_mapping_type_v4-v3-0-c0183a409bdf@nvidia.com>
 <20261120-dma_mapping_type_v4-v3-3-c0183a409bdf@nvidia.com>
 <ad46d60a-189d-4dd5-9ad8-ecfd3c90f9d9@amd.com> <20261123165716.GM179082@ziepe.ca>
 <7ac7edd0-5c38-440a-b26a-21bcbb6f4702@amd.com> <awT8prWsj11TBdmP@nvdebian.thelocal>
 <63eb7b6e-e0a8-4443-a434-0301ed59beae@amd.com>
In-Reply-To: <63eb7b6e-e0a8-4443-a434-0301ed59beae@amd.com>
From: Dave Airlie <airlied@gmail.com>
Date: Fri, 27 Nov 2026 08:29:49 +1000
X-Gm-Features: Aa3M54rvnH00v1NCtGrc73zPMs4ZrSy5Ip3saymlbe4-GLTg5bt7TBC0zEJEFjg
Message-ID: <CAPM=9txheaE3=fp7=n4fYh-xshxOm+Tv=eQn9wvHVAc-b1JKDQ@mail.gmail.com>
Subject: Re: [PATCH v3 03/24] dma-buf: Add the SGT DMA mapping type
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Sumit Semwal <sumit.semwal@linaro.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Simona Vetter <simona.vetter@ffwll.ch>, Matthew Brost <matthew.brost@intel.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, Dongwon Kim <dongwon.kim@intel.com>, 
	Kevin Tian <kevin.tian@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Karl Mehltretter <kmehltretter@gmail.com>, Baolu Lu <baolu.lu@linux.intel.com>, 
	Felix Kuehling <felix.kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, 
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org, 
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev, 
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org, 
	Alexey Kardashevskiy <aik@amd.com>, zhipingz@meta.com, treding@nvidia.com, jhubbard@nvidia.com, 
	chaitanyak@nvidia.com, Leon Romanovsky <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Nov 2026 at 03:26, Christian K=C3=B6nig <christian.koenig@amd.co=
m> wrote:
>
> On 11/24/26 07:23, Alistair Popple wrote:
> > On 2026-11-24 at 05:37 +1100, Christian K=C3=B6nig <christian.koenig@am=
d.com> wrote...
> >> On 11/23/26 17:57, Jason Gunthorpe wrote:
> >>> On Mon, Nov 23, 2026 at 02:36:46PM +0100, Christian K=C3=B6nig wrote:
> >>>> On 11/20/26 06:55, Alistair Popple wrote:
> >>>>> From: Jason Gunthorpe <jgg@nvidia.com>
> >>>>>
> >>>>> The SGT (Scatter Gather Table) DMA mapping type represents the exis=
ting
> >>>>> sg_table/scatterlist based DMA mapping. For now it continues to use=
 a
> >>>>> sg_table for map/unmap, but this will allow a future patch series t=
o
> >>>>> convert to using a different data structure for importers without h=
aving
> >>>>> to convert all at once.
> >>>>
> >>>> I strongly think we shouldn't have an SGT mapping type in the new DM=
A-buf mapping API.
> >>>>
> >>>> Instead we should have something like either an array or an xarray
> >>>> of DMA addresses.
> >>>
> >>> My plan was always to get there, but I don't think it is reasonable t=
o
> >>> start there? There are too many places all over the place that are
> >>> just hardwired to do SGT right now.
> >
> > Right. There are around 70 drivers upstream that make use of the sg_tab=
le handed
> > down via a dma-buf import, so I don't think it's tractable to convert t=
hem all
> > in one go. So obviously we will need some way of phasing this in to giv=
e time
> > for each driver change to be implemented, reviewed, etc.
>
> My suggestion is not to convert all drivers in one go, but rather to come=
 up with some sane representation of the DMA addresses instead of using an =
SGT in the new interface.
>
> > Obviously some of those will share a common structure/helper and conver=
sions
> > will be similar, so that is an over-estimate. But based on an initial p=
oke
> > around there are plenty of drivers that bake the sg_table more deeply i=
nto their
> > data structures.
> >
> >>> Part of the design of this series was to allow the conversion away
> >>> from SGT to be done incrementally without breaking compatibility.
> >>
> >> Do you know the joke from the hitchhikers guide to the galaxy where th=
e dolphins are happy for exactly the same reasons?
> >>
> >> I'm pushing against this plan for exactly the same reason because I th=
ink it will make the conversation away from SGT even more problematic than =
it already is.
> >>
> >>> So it is effectively this:
> >>>
> >>>> The framework should then either connect the SGT directly if both
> >>>> importer and export are using the "classic" interface
> >>
> >> Yeah but that should not be a separate mapping type, it's rather that =
we just convert back and forth from DMA addresses to SGT for compatibility =
reasons.
> >
> > Right, I think this is actually fairly close to my plan, which is to pr=
ovide a type
> > for each address class an exporter can produce - either a CPU physical =
address
> > or some device context + P2P/MMIO address but in future could be some o=
ther
> > interconnect type.
> >
> > The core then negotiates compatible types and adds converters between t=
hem,
>
> I have strong objections to that plan and would potentially NAK it.
>
> DMA-buf should *NEVER* accept CPU physical addresses nor provide conversi=
on between different address types.
>
> Keep in mind that DMA-buf is solely a container for DMA addresses, nothin=
g else and it should not provide any mapping functionality whatsoever.

Is that because it's called dma-buf, if we just called it's shared-buf
would that alleviate things? I just feel like there are use-cases
where it containing CPU physical addresses might be what is optimal
for a certain scenario, and re-creating a whole parallel
infrastructure that ends up being 'I-can't-believe-it's-not-dma-buf'
would end up being bad.

If we need to shared object backings and have clearly typed and
negotiated on what the backing contains then we should allow it.
However I mostly agree on the mapping thing, I'd want drivers to
negotiate and natively support whatever backings they can rather than
having an intermediate trying to handle the conversions Not saying the
code doing the conversions can't be a helper, bit it shouldn't ever be
autoamtic or outside driver control.

Dave.
