Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB747340405
	for <linux-rdma@vger.kernel.org>; Tue,  9 Jun 2026 14:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781015903; cv=pass; b=WvX1JmUU5FeGuaA+nkwPZ/8ijnCdQgCLMnt+AlEl9ImZouyLg1lsuhnTy2DeIiuPDzxoTwea35asbH8Vom+62omXnYZc9AQE1HulnUZYARS2JlqchbSc9sRNE34dnSz11AB23UMm7zEg2zo7eBf0Svj0Rry3YoPcvHnDzIab5DU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781015903; c=relaxed/simple;
	bh=y3AzoKCQuHgd+PJJX0Ml7tfsX3S9F63aRJW3c7mG6Ic=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lUOUa1PS5xD+w/l3u9E65iFbWaPrNenOsZms1ak6xxi5IIpyk05alCzgGrGsn2jNsLcQgFhp+Gk8vzJBqUq/WlEnR+cgXca0x6g/xgTf9L9r2oGkswaBnUnaM4kMG27cZ2BQaYBDfWcF8D0uFHHiDRnWMG63QQLWbukvtm20Pt8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=b+bzFh5l; arc=pass smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="b+bzFh5l"
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 659BoJ7L4094947
	for <linux-rdma@vger.kernel.org>; Tue, 9 Jun 2026 07:38:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=A9sFQHsXqHrMgAiwxXHw
	qbtJi56QK9Hsrm8AczETl1g=; b=b+bzFh5lZdFG6ZMxUJUlD8Yt1iTFLbUkN44J
	0sEYOv5io+R4jUYJbE8CO/8bzyHasyD/fqldbu1TQANBQ68ej/P1D7bCh0Be/t9t
	77ignPYiVT73nQeplrY12DpT/Cb+rEjERmUU6TVCa6V7eUZ7JLMt94G73fGvajze
	zyUZleQxuZvCbUUSXYPL/gojMV01wKZCDt1r9+IxqZGQ1f29Qp3i37UJwt+6Vg4s
	mCO5U7LHFg4UrHlCu+BS9DH360ffxI9Csawy+GcEYer3nQpVrv42nRoVOUC7IsxZ
	e7IvZ+NUUzgTwRET8EbK90UUlwI9PBNVSniNuv50nJRdR5rglQ==
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4epja9s0ky-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Tue, 09 Jun 2026 07:38:21 -0700 (PDT)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7e71e43e89bso4367983a34.3
        for <linux-rdma@vger.kernel.org>; Tue, 09 Jun 2026 07:38:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781015900; cv=none;
        d=google.com; s=arc-20240605;
        b=Up4f6T+SW7dG+d1+PVK+6r9k372FlyG7JbLcDX9HL5CkD7T0Cf/Gk+d9nzmsgh3Xxr
         JhT0VeCHhlwZfJ/2usgEP0YNsbrDnq4eqDO41eSSUDwf4l9sdW7jFu3JgQtxl4njCzgb
         7k7si6j0wi5WNTbvWFiVv/YnnZHBu6Z0oydMbo+eMFdcoFD79S3mAvQTbeSIXlLlo5PY
         Sc507TDhhXJFyyqB+HOJeXSZA8Cufc9cqslHSaW+D9HJeOzWTLU31jaIliYGlfRAI/GP
         Is6CpAvhznHNWRVaNTc+Tb4uOmQu1/NGqj0cwarNfMgoWOMhG7M4QFrQ2CMS0X880zO5
         INJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=A9sFQHsXqHrMgAiwxXHwqbtJi56QK9Hsrm8AczETl1g=;
        fh=PBEHQK/GqjnV6oXpaJhg2aEkvEijGiwTHX1Gm8WOBs8=;
        b=k0FPsdTQGQvhgWLKsXlqkfYAXESpjldYPKAOx9DXqT32wsbTxs6weR2+7CZNAoj05q
         RpomO4c1XzMIT+YF3JaUZh5YAFrYOryA7uE4tcNBAcriIlAgBdK4N4reXQ777H08uj1D
         4dlm1D7GVGKZil8+6w3uZ/To3M+xAyw56aw6Rs61CBFRtZRCuUTDPvDBkXP1QgzUaGgT
         qY2G7vPqPMFuuajG13y+GiSTQAVIYCmkuVqYc7KyRW9eFZ2cMzGvBPgkWe4dgVpSqTIY
         OEANSPIMnxr5NaY3uZwoyx76graX5XDfDFe91Gd7MFKZdthT1NWxuQ6wsX7Gsw3NoDzm
         vXCg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781015900; x=1781620700;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A9sFQHsXqHrMgAiwxXHwqbtJi56QK9Hsrm8AczETl1g=;
        b=gG/j8MmwGBloQranjgM9T6llrCz1O6mQTFc09gebK+pkjB4sMyfFhdCS+X/DOga2Cd
         lyqtDJvsDRoQaBK8lWohblI7kU73UHhsN1fHTaLtZwxkWdMMhlgAaqb8xX7N/RdYRjb/
         QCyvNKXAfkcYeNHWm42/R/QZuujbDkR5hU0qkU2DV5OMI63cKkHqj4TVibIy9gS3Akv3
         fb7CPgvIhathZ8pu+42F5HFeftT9QWYklAb1yH4Q7JSn7cCXxPIazf17oy0MBSygkcOE
         rPnMGmNsR8bf8kTNeGk2LVtiHP10BAy8F6/jD9i1p05R+r7Ap9CRX3Lh8VaxVC6dQPeP
         FIgg==
X-Forwarded-Encrypted: i=1; AFNElJ/+GmwpEdGvwe5tHpBqCzh7095OvhcRzlfU9gRIOWkkNPTURYbL+fEP6JLIWiKGT9hN/1WDoXVxeegH@vger.kernel.org
X-Gm-Message-State: AOJu0YwuLoSegQWRdrTBZrywD1Ljcxqohk3cpJ6RkbaDoZyGyB98zaVS
	Js5h0AAJ05gCeRZBxUbf/cZMYhnw4sRql9ln3zdvBXzYlqeSS4Inz0VNCWfwac02hZd+eSXhsT8
	wGiBdlU5X6OdlR5zwjRh2g5uAhncB0IkcQ3NO4Mgc2sqUnC1DExM1OpMJLi29aPipsvUaKwLAJp
	7DPYkTzxu9DecFQ4Y0QqynCdR3KqVryPuARMnf8ZJIW9ob
X-Gm-Gg: Acq92OF+xS03pRpLG7X8Fcts/yd23ygQtWUuNK+RnaVDGBeuuV04urdSgwjkGjPD1AL
	UP4L8nQIKBLBaHRxRe3LBhQ0Gg+PRIE9LovEwevP9TA4UY4es/GVakrkiFdDWCVZj95RrAr04DF
	2pDCH3PfnI4+EOQ240JixY7b3o2Vtcq6azh4aVXnIqwFuIAH+s4u80gG19Mk5ccYzyidyUMLOWx
	mMtWy3RChmlqWFHEUa7ewhkfYrJ0/vLK5pE8f5uCrOLBe6XAG0=
X-Received: by 2002:a05:6830:6a96:b0:7d7:fb03:f6ba with SMTP id 46e09a7af769-7e70ca51cc9mr13515113a34.21.1781015900234;
        Tue, 09 Jun 2026 07:38:20 -0700 (PDT)
X-Received: by 2002:a05:6830:6a96:b0:7d7:fb03:f6ba with SMTP id
 46e09a7af769-7e70ca51cc9mr13515095a34.21.1781015899753; Tue, 09 Jun 2026
 07:38:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260608185646.4085127-1-zhipingz@meta.com> <20260608185646.4085127-4-zhipingz@meta.com>
 <40243782-e4ff-435c-ae40-3ac1c7c4815e@amd.com>
In-Reply-To: <40243782-e4ff-435c-ae40-3ac1c7c4815e@amd.com>
From: Zhiping Zhang <zhipingz@meta.com>
Date: Tue, 9 Jun 2026 07:38:07 -0700
X-Gm-Features: AVVi8CfGCq2wYUK9zUjDs8_E_dqHl5wHKtBE7B2eSNCP9pHNCaJrScoAmctUT8I
Message-ID: <CAH3zFs1eE2VrxOZA9FoowJ9AKeBkdZE5P6t1cH0bxXq0iY6AhA@mail.gmail.com>
Subject: Re: [PATCH v6 3/5] dma-buf: add optional get_tph() callback
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
X-Proofpoint-GUID: LCiYZghdeEqz44XhEyKFVJuVh0Gc0Dpi
X-Authority-Analysis: v=2.4 cv=V9JNF+ni c=1 sm=1 tr=0 ts=6a28255d cx=c_pps
 a=7uPEO8VhqeOX8vTJ3z8K6Q==:117 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=PAz_-FQ8hEVmOPYdF0yf:22
 a=KaHoPmoT-FsTecDK8CMA:9 a=QEXdDO2ut3YA:10 a=EXS-LbY8YePsIyqnH6vw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDEzOSBTYWx0ZWRfX8/xaqZRCspPL
 +MSlQKy/9QygV2p2fL+19WxK5f6zNBgD+0irTUlOSrloOXF+v2B52NusShdbcrIme72o1xPCLRK
 beKKSZIcD7UfPvvxoG2v26xbjhmsjl57fiI4RUDRHB/2knG7tHRscA5pnbeqLp5b0U4Ko8ci7Jv
 02cLNMAem1+BRiEqBzUR//jn2+qxJgSVyK/+1VK3cj+60Vhw2AnsJFm/OGJdGuHZ//bcEhF2ROi
 7PGjKdWT59K/uUlQPEIEjg0eLivpcsREmPeTVTKsAReUzZlzjiZ7aTl8TGVrFvFG/oYRqsEL27z
 kLrYhqP0aYJOfFInnC6JPgNc7J3BvfwxONN19xyVtUfT0d07IfE053pw8DtKpf0olQ9goJpT13P
 M2CyxcLNfGp/d3zJqwe5RkBAKUkzViYgoRRiitQwvdkrqKjE9seYYr3e7wxvCPEkTIyN54kp+y2
 0FgM40SwZBP8034WJwA==
X-Proofpoint-ORIG-GUID: LCiYZghdeEqz44XhEyKFVJuVh0Gc0Dpi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-09_03,2026-06-09_02,2025-10-01_01

> >  include/linux/dma-buf.h | 31 +++++++++++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> >
> > diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> > index d1203da56fc5..8437dbe4a83e 100644
> > --- a/include/linux/dma-buf.h
> > +++ b/include/linux/dma-buf.h
> > @@ -113,6 +113,37 @@ struct dma_buf_ops {
> >        */
> >       void (*unpin)(struct dma_buf_attachment *attach);
> >
> > +     /**
> > +      * @get_tph:
> > +      * @dmabuf: DMA buffer for which to retrieve TPH metadata
> > +      * @extended: false to request the 8-bit ST namespace, true to request
> > +      *            the 16-bit Extended ST namespace
> > +      * @steering_tag: Returns the raw TPH steering tag for the requested
> > +      *                namespace
> > +      * @ph: Returns the TPH processing hint (2-bit value)
> > +      *
> > +      * Return the TPH (TLP Processing Hints) metadata associated with this
> > +      * DMA buffer for the requested steering-tag namespace. 8-bit ST and
> > +      * 16-bit Extended ST are distinct namespaces in the PCIe TPH ST table
> > +      * and may both be present with different values, so the exporter must
> > +      * select the value that matches @extended and must not substitute one
> > +      * for the other.
> > +      *
> > +      * The exporter owns the completing address space for @dmabuf and
> > +      * therefore decides whether it can derive meaningful TPH metadata for
> > +      * that completer. The dma-buf core treats the returned ST/PH tuple as
> > +      * opaque transport metadata; importers that support TPH place it on
> > +      * outbound TLPs, while exporters that cannot derive a useful tuple
> > +      * simply return -EOPNOTSUPP.
> > +      *
> > +      * Return 0 on success, or -EOPNOTSUPP if no metadata is available for
> > +      * the requested namespace.
> > +      *
> > +      * This callback is optional.
> > +      */
> > +     int (*get_tph)(struct dma_buf *dmabuf, bool extended,
> > +                    u16 *steering_tag, u8 *ph);
> > +
>
> That needs a wrapper for importers to call which also handles if the callback isn't present.
>
> Regards,
> Christian.
>
agreed, will use a wrapper in next revision.

Thanks,
Zhiping
