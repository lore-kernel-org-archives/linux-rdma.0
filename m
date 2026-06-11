Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72B5367B63
	for <linux-rdma@vger.kernel.org>; Thu, 11 Jun 2026 23:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781219283; cv=fail; b=gQVOQc8Lky5/TOaRbsWZHL9WmlmjxSAKyETFUU309q+kWL1vPl78yYmrJwFwiVwOPwJO3Qm32DiG4oid3wWrRrzXKay2NmMNq81ywQr+CMJWixaatCXWZObGD4u7G0tIHOJgB8v4zLpTIPgjfCAWqe40vwS6M7qI3D8cdHYyQzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781219283; c=relaxed/simple;
	bh=Xy3ScJnXdGO1uSMgz2W54lBdlaGYi8w2p6RzwRoDR08=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QPW4X9EyZ9+7sy/CQn/hft5SkOB8xqZ4Ad6NdAzbnwHQhwiJpCR12qF4ZxEvbuOEYmXeNaDGW7NAiJfbfTBcUP2mJEVCnt1y6DGvRd67ZQXOeiQsZoRZpWPY5tTIZJ6lH6ePjPARKyCnlffarQlE6b7Za3+x9tVpmmiE4KrFxzQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=S/OjtqUr; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="S/OjtqUr"
Received: from pps.filterd (m0528008.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65BLNEt63265034
	for <linux-rdma@vger.kernel.org>; Thu, 11 Jun 2026 16:08:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=eSd4DfDWKCJhrlk+WFf1HJuCXJjV3yJV405FpCwAOa8=; b=S/OjtqUrfaHy
	U2tzFcZ8mycupW/bmzC0ry9dC6/TLZhsjYUOLx9kRDPB0KY54IyAWb3v/8NCzgIb
	Lo7j7/o2b10gCRzYHkStHM3+46rjVxu480Rw69rpMHhOshrelnhYeaEHIAZWHY2c
	45cn3iSQuWvr09tWHy11Rg98ilzmEcTlYqqh9Q7sHC11wTUiTKCHHmUjQuUuiz+2
	BUzCK5pTcOnMAmuXtXpOjrSB6KpO6VLwRJcO/kgZ1gLYJTGY+KSd+TwJCKLMpmK8
	S3GzefST7H4aOVX962Ewe73xPQFn9Ny/oy+d2hIXiJkNWwIp7UrGbCvYz36QF7sN
	eBQXf3TFYQ==
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4eqe7chd4w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Thu, 11 Jun 2026 16:07:59 -0700 (PDT)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7e60737a964so850995a34.3
        for <linux-rdma@vger.kernel.org>; Thu, 11 Jun 2026 16:07:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781219279; cv=none;
        d=google.com; s=arc-20240605;
        b=NHH/xKwO/ZBFw14cOgDutVq6CZPJEiMZW9nuFN81PpkK2SD3xzN10uhQPLDdxWf48p
         nzMsLWp0fQ2ZDXP3kyWv3sDZlnYgNCznEG5myc7NnUENF4wlRZv+LlKbZY1uVjobrhkb
         d02sZkXxZzvWYLW2xNEYg6ikjom5JkPFjybduo8iXbGzRvw92DPbyP253yjEGfbCx8wG
         hKmBNOm7UDs+VAk8ucdCSl5vPS47Pk6iE0djZP7PAiQT82T5gcz/WCUBrkSpNHcSHraI
         DBmYjfHK1Y7SfrtO/6CJ8iyIOcqVmWL7eHvEICV+mdlDVkpbM+J13yCt3MGkCoiXMHRK
         g8kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=jKBgDS5EhOCeCGVgkUxAvmWq6B4D8KMNSa2GuVyeKb0=;
        fh=A85D6x6sDh8/lkVUHw0pwxNLJf4v7/SVIS+39ej0K8A=;
        b=Ka0Bxc5gUrOfJkFIYKTaXHB9DpGpzVfqBSavP35ESxGxhoEQERDMSgBAp54p7oVvn8
         N+bFdx1xfSWIh8pEWLPLXYGF7b+5Y3nN3Ql5mWoisaWm2uvq3+0+LbjKu55ByoRtqrrB
         ncmCMwRvyn2mdx0aSkldideLoLXbaZ2aacP06SHCG2q6L1mG84206ydSuznbNzpiBoa8
         +JcrfPjN9yrP3cB9LDqHWscTW6gEdtgWxEy7XvDP86EtWssQmf7eVUUsUu7CQ1QuR++6
         4/2iN8ZByvQOs2kovTZmJOn7GmN9Js2DEX8S1Q9oB+mpPcsypUrrHWbdwg8tPU9a/Psr
         hbkw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781219279; x=1781824079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jKBgDS5EhOCeCGVgkUxAvmWq6B4D8KMNSa2GuVyeKb0=;
        b=Khs/GEqOh1PbBbarGhCU/AGybXTmCY6VbraSrQmC60WV68o5pgviCAcdo/lNMBSuWB
         afuJXCMNj7fAQf5EQyRQE0lV6ZWd7JyNajQLguNEpgBCC+vQOd3pKcqZzbU0duG4DLPb
         cup43vi9QSYG0ntNEckeyaavInKjQ/SkLyM3oTQm04+obLwAg7sDne4ZiKBXMpX4izJ0
         i+jGXWvewbFnBt7C0c/d0/5XjJuZfozJ4ruSFpCmdqBahttvCiNe+9NrhHcnmnjeh4pw
         dgA4ZQaT5mm4ocXskJJiIZXJ4fbIXX6zkvMNas12CXa0qf/zOHkiF3zzaNCJSGi0CvSg
         rTKw==
X-Forwarded-Encrypted: i=1; AFNElJ8tgp18ys0Rmeoq5EycQS8VjzkLZckyfk/QSRlvjmFwvBlemhxUDMWw3WGWOx6C17se1LmtGVv6IDgC@vger.kernel.org
X-Gm-Message-State: AOJu0YwmSw1DnvzFVwyrKhtuAWumf5LN3tnDBmCRre74pf9lUYcEC6yq
	4Oujqah461ipdY1suxT6QTYf60Kmlvt3NgIBRR398AVS9pquK1mwZchdmEeWY7jslyV7pUFBSE1
	tM6vjQ+pCxvHd2Ws9o+/fboS9jnqpWBwm6osWDCUxJ7ryT30OOTpK7IUVFlv9LCR6C1WeIcPoVq
	cYYnbLMfd36dXDYITf6G4tPFrm0VB8too/xjCT
X-Gm-Gg: Acq92OEl4WzvgDPL51YF3YjvqEB8uq984mM+pYka1kjIW+0V7uBtuQa6R6hddnLCsO/
	ZvGq8P/FFKQ+rZ4eO6RWVsolaQqIjcFcZqlgaL8ysiB7+UOWBjqZOHKXo17X3rC1ANH9hdca2ZY
	92ijauDuUypGRkJovqm1C6Iqxu0sGiN6FeVaUkJxa8GbrZA5WWqOpzAaUPebL00kch1wGHxebRj
	AiaCZ4xnSk9AEKafN2G1A==
X-Received: by 2002:a05:6830:6810:b0:7db:b7ae:ef0b with SMTP id 46e09a7af769-7e7848a9e26mr96712a34.24.1781219279128;
        Thu, 11 Jun 2026 16:07:59 -0700 (PDT)
X-Received: by 2002:a05:6830:6810:b0:7db:b7ae:ef0b with SMTP id
 46e09a7af769-7e7848a9e26mr96676a34.24.1781219278679; Thu, 11 Jun 2026
 16:07:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260610193158.2614209-1-zhipingz@meta.com> <20260610193158.2614209-4-zhipingz@meta.com>
 <98b65e1f-1b5f-47fc-a4fb-0cdfab6725ed@amd.com>
In-Reply-To: <98b65e1f-1b5f-47fc-a4fb-0cdfab6725ed@amd.com>
From: Zhiping Zhang <zhipingz@meta.com>
Date: Thu, 11 Jun 2026 16:07:47 -0700
X-Gm-Features: AVVi8CfN6ELCKVsJhBpTTQfWRh3GrCVI0SUXGM4wH5Fa1maXhiidrAdOyWsdUPU
Message-ID: <CAH3zFs1=CKtS524vU6f2inbX05JcyMi-5FouDxSCZAjNG0OUmQ@mail.gmail.com>
Subject: Re: [PATCH v7 3/5] dma-buf: add optional get_tph() callback
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Bjorn Helgaas <helgaas@kernel.org>, kvm@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Busch <kbusch@kernel.org>, Yochai Cohen <yochai@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDIzMSBTYWx0ZWRfX+NxB0yj36n+z
 T+yiMy/w97pFKaOc64wEDwgEfo61kST4LzJ3Utyq7W41xGFHbnjNINhC36c45bI/1GwNXyPRlAc
 6ZnYPBiRCvvNdkyBYG2D3j5Kk8/k+PU471tOrf48d9GFJP7GqzI/UXeLAIb0hkIHsH2zTPPPU7d
 alkrT0ESxqS7oZm8l9BEWaQNYwZ4F0AAeUq0xeLD5tIMzqkBzf7lMx4VbxeV33H+QeyIFB5Eb5E
 nqvag981Ku03V5grVuVyms7S9FvHqGl0X8icqXUPw+8lyWvCDaZd0mxUuha6fNw7TU5pbTFhfIg
 RnjSQvG3yIpsiXekijP4ZuA2se9Xi8lfrOwccuD5kesCBJKnolRCoyyoz4aX/cuHiINByXEqry/
 p42vvRTlKwIGjT960JKQzFDtWv2gDtdWa+Pkxol2rujmRXuO9Nz7SIRB5Zxh0T4KjAIxtChf0ao
 FurV88Yz2oKtRlVDTdw==
X-Proofpoint-GUID: NRGAG1Q1akGXlNwaRiOmOTev5euVdLTe
X-Authority-Analysis: v=2.4 cv=U+2iy+ru c=1 sm=1 tr=0 ts=6a2b3fcf cx=c_pps
 a=+3WqYijBVYhDct2f5Fivkw==:117 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=_1IyUuN4QrATX339ibzo:22
 a=zd2uoN0lAAAA:8 a=VabnemYjAAAA:8 a=Zb6pUuT0p51Zl8jFNtYA:9 a=QEXdDO2ut3YA:10
 a=eYe2g0i6gJ5uXG_o6N4q:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: NRGAG1Q1akGXlNwaRiOmOTev5euVdLTe
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjExMDIzMSBTYWx0ZWRfX2x1u4JfmDk39
 SlQLrj8x7D4XdKR0HJ5nndtZDx+C/agsuxqyJBf20619bLkA6VTaVhtATlHPEAQMPuxeIuR7o2Q
 YeZAHMSTD+tQzjrMYTf12RgFBtCnL4s=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_05,2026-06-11_01,2025-10-01_01

On Thu, Jun 11, 2026 at 3:35=E2=80=AFAM Christian K=C3=B6nig
<christian.koenig@amd.com> wrote:
>
> >
> On 6/10/26 21:31, Zhiping Zhang wrote:
> > Add an optional dma_buf_ops.get_tph callback and a dma_buf_get_tph()
> > wrapper for importers.
> >
> > 8-bit ST and 16-bit Extended ST are distinct PCIe TPH namespaces, so
> > the importer requests the namespace it can emit and the exporter
> > returns the matching ST/PH tuple or -EOPNOTSUPP.
> >
> > dma_buf_get_tph() is the importer entry point. It returns -EOPNOTSUPP
> > when the exporter lacks the callback and requires dmabuf->resv to be
> > held while the callback runs.
> >
> > The first user is VFIO_DEVICE_FEATURE_DMA_BUF_TPH in vfio-pci, with
> > mlx5 as the first importer.
> >
> > Signed-off-by: Zhiping Zhang <zhipingz@meta.com>
> > ---
> >  drivers/dma-buf/dma-buf.c | 25 +++++++++++++++++++++++++
> >  include/linux/dma-buf.h   | 21 +++++++++++++++++++++
> >  2 files changed, 46 insertions(+)
> >
> > diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> > index d504c636dc29..aff79ea12e43 100644
> > --- a/drivers/dma-buf/dma-buf.c
> > +++ b/drivers/dma-buf/dma-buf.c
> > @@ -1144,6 +1144,31 @@ void dma_buf_unpin(struct dma_buf_attachment *at=
tach)
> >  }
> >  EXPORT_SYMBOL_NS_GPL(dma_buf_unpin, "DMA_BUF");
> >
> > +/**
> > + * dma_buf_get_tph - Retrieve TPH metadata from an exporter
> > + * @dmabuf: DMA buffer to query
> > + * @extended: false for 8-bit ST, true for 16-bit Extended ST
> > + * @steering_tag: returns the raw steering tag for the requested names=
pace
> > + * @ph: returns the TPH processing hint
> > + *
> > + * Wrapper for the optional &dma_buf_ops.get_tph callback.
> > + *
> > + * Must be called with &dma_buf.resv held. Returns -EOPNOTSUPP if the
> > + * exporter does not implement the callback or has no metadata for the
> > + * requested namespace.
> > + */
> > +int dma_buf_get_tph(struct dma_buf *dmabuf, bool extended,
> > +                 u16 *steering_tag, u8 *ph)
>
> That name needs improvement, maybe something like dma_buf_get_pci_tph().
>
> It also needs some brief explanation what TPH is, maybe a reference to th=
e PCIe spec name etc...
>
> And document in the list of functions that this one should be called with=
 the lock held.
>
> > +{
> > +     dma_resv_assert_held(dmabuf->resv);
> > +
> > +     if (!dmabuf->ops->get_tph)
> > +             return -EOPNOTSUPP;
> > +
> > +     return dmabuf->ops->get_tph(dmabuf, extended, steering_tag, ph);
> > +}
> > +EXPORT_SYMBOL_NS_GPL(dma_buf_get_tph, "DMA_BUF");
> > +
> >  /**
> >   * dma_buf_map_attachment - Returns the scatterlist table of the attac=
hment;
> >   * mapped into _device_ address space. Is a wrapper for map_dma_buf() =
of the
> > diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> > index d1203da56fc5..6a54e0f251a2 100644
> > --- a/include/linux/dma-buf.h
> > +++ b/include/linux/dma-buf.h
> > @@ -113,6 +113,25 @@ struct dma_buf_ops {
> >        */
> >       void (*unpin)(struct dma_buf_attachment *attach);
> >
> > +     /**
> > +      * @get_tph:
> > +      * @dmabuf: DMA buffer for which to retrieve TPH metadata
> > +      * @extended: false for 8-bit ST, true for 16-bit Extended ST
> > +      * @steering_tag: Returns the raw TPH steering tag for the reques=
ted
> > +      *                namespace
> > +      * @ph: Returns the TPH processing hint (2-bit value)
> > +      *
> > +      * Return TPH metadata for the namespace selected by @extended. R=
eturn
> > +      * 0 on success, or -EOPNOTSUPP if no metadata is available.
> > +      *
> > +      * This callback is optional. Importers must not call it directly;
> > +      * the dma_buf_get_tph() wrapper is the only entry point and hand=
les
> > +      * the NULL-callback case. The callback is invoked with
> > +      * &dma_buf.resv held.
>
> That most of that should be obvious, we only need that it's optional and =
that the lock should be held. Everything else can be dropped.
>
> And most of the description/documentation should be on the wrapper functi=
on, exporters who implement the callback should know what they are doing.
>
> Regards,
> Christian.
>

sure will do

Thanks,
Zhiping
