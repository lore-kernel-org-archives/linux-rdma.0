Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0DC369D47
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 21:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790632082; cv=fail; b=g9TiId4aTlj5p1qEqeYBW+N4bJlo0/JbYiZJBQYdgtzK+F4qMSIQxnA7WZZ7snD7LFGYduBncUR+JJDQ7Oe9Umv+JwNgEF0PZWM/1CCVt3tKuQ0s5rMjADRjPZSIxXbCezg6UbKHYX33fkLAXKmwEPcdeG1iA20kLf6e96WqUVc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790632082; c=relaxed/simple;
	bh=BTOe3Am915BHVXg3ukWQGJbf2RonMUAlNyZzaCFwnm0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k8RDj4UcX62R/tKFJu93P6HKaNl1RrP5Q+2kgtJWk9yUMq0OODvEjqeurndMAi1ZXEv0b0Dl4rLx3Ca4wANTvgp8sdf3F607ZRNCgMs8QRR0iTLrAf6YpdmBFmfbviD8cpWCwUfYNS51F9ntGtm2RTCut7eGWQ82f+hZyJbhj98=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=kOlYqGiD; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="kOlYqGiD"
Received: from pps.filterd (m0528009.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SLTXpL621281
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 14:48:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=OVdNSiqQUhRQfp/JGpi7EaQ9UmFZis0CHFKmY
	zkvi1s=; b=kOlYqGiDxua0gnAE94K8BoX1NpPHaagCIF/NCVsflq+xJJtWzb0YO
	YBz6kPJxXBjaCNh3T3N0DhRurSOV0/7GVM28F/QnZ/33gICD9+BdtSZshieGanER
	vkLOi/B0XbuISnjkPoUk6rjCHlg1hWu9itC41ZN+PCfbNrj2xaueHxJIxQBEr4mX
	RYbT1AgUpkZn3AQcdT6NVr7FTzap0WZo1xshFg+qb7pA3nGyffOzxt/7/jstZw1c
	QAEC64RTXEw+vOSZeiCr82m/OtVaCK+KDEYEmzFgK2UQLd21WhAZEmuzhfp2WhSF
	CSFY0u34VEvqr/lTJHB4spcEJIIWbkwzg==
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gyva1jyxc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 14:47:59 -0700 (PDT)
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6c27804563dso6180978eaf.2
        for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 14:47:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790632079; cv=none;
        d=google.com; s=arc-20260327;
        b=ZFjuhwtE2mUX9dxdvsOTS+5V8M/Hhw06xj4Gie3nk6GebeS9NSjcPdl39jPB8lpJZW
         5WbYYDtdoPtK7a+xa0FASPBJ8NrjWEze2O0qmY1sCa7ONvxiDeavW190M/9TTBayQe1g
         /gXqyieAS+c8X0M6kuNzh/6/MVM7IRc0OtEU9xOGXwYEkRZWpjV2Uy5xfUFhoDz8IFzS
         ulW/BTu7hEwGC88SvxJz+hHBbgTWuceNl0GGfewYdAmQ/rVR+qIVArcgJ2T4jPp0y4oF
         rnfByjJ6KbBNGk3LVH1VPFieCaouodDxbID+L31kp0t51jqHbUdT0Zv84NfauC0BORKn
         O7jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=nsM/d13GDOKofLPZVXyaTADEaxrWWppyFB4m09sEx30=;
        fh=jGplzNcLztfIt0l6KFNOdb1G5he9/QPehRZtuDSIfow=;
        b=qnM/Xttm5rrINGrik5pu1WyJF9zxiwV82nqrefeJIB2WMX97zo3GtA5XJaxs4WQu4/
         lLUg4Yn1GvS6sFCQ69/DC0gj0aIUU6UDqOIkKvwB5i47ActPB997Qcbu8viNeKZ8mFNN
         +WJuO61FWsQ1zkEg7HZk3yHQNo8Yyak+Y8PM9RWiTDWJpT6nftExwp6tbBVv6g8LZHcZ
         Cd3Cvu8JJ630Xish08DIk/j7qPY9zktOaCZ1WcDzGFEPurgqYIU7V++JsnDb+oE4qKHy
         caCqF0sABILHZuDOpyB/XUHc30bG7pgr3psGIEmaEGuZmCL5Qk3oFr062kJn3wqSItWt
         2TOA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790632079; x=1791236879;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nsM/d13GDOKofLPZVXyaTADEaxrWWppyFB4m09sEx30=;
        b=w/nwTyW8Jg1NRmc0EBkyLAIh791hwTpyJn0RPpqkqTe6gMPVWhgwpI+tbZFPgOtbAT
         VpSK284zHgVvO1GDqTTmqrLViLCLZwbfPpMpeyiuz93GqaDKsyIwflBIRWj+NGVhPN+h
         2u5DEwbOXce7Lm92F/ELanzzv/6GvL8+X2goN+vsnbv1Z5NqHV6xzcyTdO/vX0aRP0y/
         0XJuvMIepspGDFQD1KSJ/s2jg94CNGew967IlAoW50xA8Tz76kdWWKqg6I9c6dsqrids
         grhvh1MXC8i4aNGFxa697Hl47nneKNYDHyfP73/jZ8DdN8aAOzKa9qerPvwSuUMvp5wM
         15ig==
X-Forwarded-Encrypted: i=1; AKwUvByZU4mcINA1IASX+Zwa0d32LPdd2VJa2LGIOUCcRufNLkLZoAiqSBqpcovqcLItceR2NcRN4ExQhhEa@vger.kernel.org
X-Gm-Message-State: AFuF++nZoKYjTxxd85lQacyiL+M909Ihjc/P/ev7IF7f6qa0c1fggrx0
	jHt6w16pCkcLRlNwTZdNFD58sSTFgFmvYaMFaPKXriHK9jbusg8yK5LfjWFH2oawLGD8RcWwYgi
	hlRNq41ZgapFapm0rQCZM9gtDq3h/FjmauyTOyhbgu294oiNU76qwQpeNrPdzbrSI+FvvSAm4NP
	Lu2x50JptHlZj1htLYAs4OvEg6ECWV/TxC8B2N
X-Gm-Gg: AYBFou3iccZF1BSRm1fLr/FuXOM2Y28EgjJlc+1oszim0/03DPelTjSzYgesHJlpFq8
	QbEihLrK3VuQBABd5xdRHCX83Tuc/0Hsbt7pEW7jK9dLnaxu6kxqyYLzm2fOR52BJppD3n246Yr
	QzyfbAz1L3Cr2wyuPZTTAaPMpP1EolIMhyl02B1ZKWAsDnNfxcBGMk3CtK+0UfWx7s2fd32Xtq
X-Received: by 2002:a05:6820:f012:b0:6d7:fe06:604 with SMTP id 006d021491bc7-6d7fe0607eemr5411475eaf.18.1790632079059;
        Mon, 28 Sep 2026 14:47:59 -0700 (PDT)
X-Received: by 2002:a05:6820:f012:b0:6d7:fe06:604 with SMTP id
 006d021491bc7-6d7fe0607eemr5411459eaf.18.1790632078491; Mon, 28 Sep 2026
 14:47:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260731211601.3033906-1-zhipingz@meta.com> <20260731211601.3033906-6-zhipingz@meta.com>
 <f4ff7ced-63b6-42e6-8e01-9f01d2e59843@huawei.com> <CAH3zFs24esHCGA=wPrkiH8oKQCv7SnOwcBbkMxrOEvOVtwstYg@mail.gmail.com>
 <20260924233058.GA163130@ziepe.ca> <CAH3zFs2rhg6-b-pVDps1V8LsM4Dn48t4J4LFVyKOZtT4axdY=Q@mail.gmail.com>
 <20260928172939.GK163130@ziepe.ca>
In-Reply-To: <20260928172939.GK163130@ziepe.ca>
From: Zhiping Zhang <zhipingz@meta.com>
Date: Mon, 28 Sep 2026 14:47:46 -0700
X-Gm-Features: AclHuK-FrHEzthVV7FZ3Ls3GrwbmAQee8rpJCMTJYpOGKi1s1NipCikGQwgcBpk
Message-ID: <CAH3zFs1mCujYjB=5ywo+huAjPJZQoe9u7NM4evNRYr5_ZQbcXQ@mail.gmail.com>
Subject: Re: [PATCH v13 5/5] RDMA/mlx5: get tph for p2p access when
 registering dma-buf mr
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: fengchengwen <fengchengwen@huawei.com>, Leon Romanovsky <leon@kernel.org>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian Konig <christian.koenig@amd.com>,
        Alex Williamson <alex@shazbot.org>,
        Bjorn Helgaas <bhelgaas@google.com>, kvm@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA4NiBTYWx0ZWRfX1ZalDoGYm5CH
 bwnxC95nfFmF/icYsa6cEhEGgVEVGL+t2RAinjYpqiufZ7CMfn8vMDYzHUZ24qzqJoBB1OrcQdk
 1xXAciwuUO6PjwFixbcHP8NQjFcDAab2n4FPPnSSGyOIat+EGmeCQ0kHuRqEnxEFMglivIJoxwM
 3G0aWslbgkBH+2PdxHYGZkdZxiGa0E9OvcERu58cs9nUFQJFqaZKessfK/26OnjddZe2gfXAPzg
 pZsDUaIFXg4p2Ql0CXtmJU5FBs0R18tY99xQGBn9NVWz3VbOmB/w8yFsN6MqNHrNIM56AhtCw8k
 MHJVFwYBzqAvzqSOEi3gud0O2wIQK/JJz2GXHNWG0MQp79DrkbcKe4qB60cpTO2/NGxkMWZVJtb
 J6X3Mtc8pS5oq4GNrYXB8amfACpReqwu2Qoa/L/RjhBUVwRViXbginZvfs27aPOR8Tluy9Rpz7x
 I9jGiy1hA8f8nXgis+Q==
X-Proofpoint-ORIG-GUID: -EWqmbjQlqVDhoBBY-9A3ZNsaUI5Mzp9
X-Proofpoint-GUID: -EWqmbjQlqVDhoBBY-9A3ZNsaUI5Mzp9
X-Authority-Analysis: v=2.4 cv=eJSGH3p1 c=1 sm=1 tr=0 ts=6abae08f cx=c_pps
 a=lVi5GcDxkcJcfCmEjVJoaw==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=U_y8lYiYyhHBU5rMqhb2:22
 a=VwQbUJbxAAAA:8 a=Ikd4Dj_1AAAA:8 a=9jRdOu3wAAAA:8 a=l_Ha6740zCVOtLZIeloA:9
 a=QEXdDO2ut3YA:10 a=rBiNkAWo9uy_4UTK5NWh:22 a=ZE6KLimJVUuLrTuGpvhn:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA4NiBTYWx0ZWRfX28XZI8FfzBiA
 9gk8aCtrDYGxts9fDRJjuf9R08j/AoKXVCfQKux4BQ/BjprtW9n4TkE/A0nArK1c3/QmyXtYLDJ
 E2di7k4uzo/SPldlY7w7WwWIhCJt4/0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_06,2026-09-21_02,2025-10-01_01

On Mon, Sep 28, 2026 at 10:30=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.ca> wro=
te:
>
> >
> On Thu, Sep 24, 2026 at 11:17:57PM -0700, Zhiping Zhang wrote:
> > On Thu, Sep 24, 2026 at 4:31=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca> =
wrote:
> > >
> > > >
> > > On Wed, Sep 23, 2026 at 11:24:56PM -0700, Zhiping Zhang wrote:
> > > > I don't think this belongs in the importer. Every in-tree dma-buf
> > > > caller of pci_p2pdma_distance() is the exporter, in its .attach,
> > > > clearing attach->peer2peer -- amdgpu_dma_buf.c, xe_dma_buf.c,
> > > > habanalabs memory.c. There is no importer-side caller.
> > >
> > > Right, and they shouldn't be doing that, but it still has to be
> > > checked that the st is going directly to the peer device not the host
> > > bridge. Not using the distance, but by the PCI_P2PDMA_MAP_BUS_ADDR
> > > indication.
> > >
> > > I fear you will need some of Leon's series to make that happen.
> > >
> > > So probably the proposed change to dmabuf ops is far too simple.
> > >
> > > Jason
> >
> > Hi Jason,
> >
> > Thanks for the comments.
> >
> > Agreed -- the tag should not be handed out unless the routing is
> > PCI_P2PDMA_MAP_BUS_ADDR. That can be enforced conservatively on 7.3
> > with two changes. I can fold both into patch 4.
> > ```
> > In drivers/pci/p2pdma.c, make pci_p2pdma_map_type() callable from
> > tristate VFIO_PCI_CORE:
> >
> >     EXPORT_SYMBOL_GPL(pci_p2pdma_map_type);
>
> No, that's been rejected several times already.
>
> > and in drivers/vfio/pci/vfio_pci_dmabuf.c,
> > vfio_pci_dma_buf_get_pci_tph() gains:
> >
> >     struct dma_buf_attachment *attach;
> >
> >     if (list_empty(&dmabuf->attachments))
> >         return -EOPNOTSUPP;
> >
> >     list_for_each_entry(attach, &dmabuf->attachments, node)
> >         if (pci_p2pdma_map_type(priv->provider, attach->dev) !=3D
> >             PCI_P2PDMA_MAP_BUS_ADDR)
> >                 return -EOPNOTSUPP;
> > ```
>
> Also no, this has to be done via PCI_P2PDMA_MAP_BUS_ADDR which also
> enforces putting the determination in the right place in the code
> flow..
>
> > Two properties are worth stating explicitly:
>
> Ah! AI!
>
> Jason

Thanks Jason, I see what you meant by Leon's series now:
  https://lore.kernel.org/all/20260928-fix-p2p-acs-v4-0-v8-0-404453b9c435@n=
vidia.com/

Looking at v8, it seems patches 1-4 can stay functionally unchanged,
while patch 5 uses dma_buf_p2pdma_map_type() on its own attachment for
both the initial TPH query and revalidation. Is that what you expect?

If so, would you prefer that I wait for Leon's series and rebase the
whole stack on it, or split the series so patches 1-4 can land first
and patch 5 follows after Leon's series?

Thanks,
Zhiping
