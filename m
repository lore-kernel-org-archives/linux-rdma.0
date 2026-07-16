Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD433859F3
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 18:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784227217; cv=pass; b=LpRuTUMYAmmjXqzlyyVVtmEsiT35m1maZbCaVYCLOT283tbt5jYqWA7LJdIx8Hh2vonXIC74l3RVreVpyHkuh6QowkBIlRX+TZywCNb1iI5JtSGDz0WbNKpLWBGJzlXCrYNkJGKf8YlnJXoz7NB4iU7Rj5QUmEWv1XfLHNwh0v8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784227217; c=relaxed/simple;
	bh=IqJ/0sviO4A2nNYWuQVlFxkW9otAAFWs/x9QVBRHv+w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mncadxXI9KsGy3plKYhsF0UUt9g+2LrQLNsGU1YGw6yzYvC2aY9vIsOf73MCrIoqtLwuTrI7LHcdFKpqE4KEuMrHt4SbdSK5XmOIbnl9jlsgdN+UYyhhiomOgNqHU8UEAIMmWrCs/0fxmkdSOkrhcDneaMwikDhdoqcokEANvs4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=tnRLNA+K; arc=pass smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="tnRLNA+K"
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GGTrfQ3548894
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 11:40:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=82XOXpHXgCbDqi6cGOJH
	4d4Jh0B4U0W+hHvIm54Ey4Q=; b=tnRLNA+K+U2IW5OflH47S3vGAWof2nUUZ6Nc
	R1wxkudx/G7z/bZhqLcx5UTbXaSCWuACf+dTIae4nXLPUIo99YVrmDL9Ep0mOfny
	CbN/vtB36/ccaLMCbRFVTMCdjo6EFBD9rgOKHo8ZowtqrPJSpf5L/mpryrDwkJ94
	jFOhMwlx/x5EbMpYiYyOIdL5BOhPURVq9nDit3plr/+uzLIvFPcohJ7Q4koukDUn
	GB1zfH7gHCzGmW4fRUz2q2pmak2ATpsBB24CVoqxfMETlz19p2gjMBl4pSlQEOVT
	NcQblIdIXI0xmA4l5p0JfTPF6K+OZP1SsGJJ1OvYygEb34GpSw==
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4fdqnere6r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 11:40:14 -0700 (PDT)
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7eb711362a2so5107965a34.1
        for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 11:40:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784227214; cv=none;
        d=google.com; s=arc-20260327;
        b=KEZwtyIGoSzI/P70jdbSoDT+13oQINRBslD2fQcEupPZcqVmkiHeXincclzcclk/6C
         YvOKsM0FT0g3QvkW7o0bxtU27E+338WB9aynMgvB4D1dmkw2H5B4h5vgp98mbCQnDsoS
         68M/Leb/P6P+qorSnVIUEIlRqAhpaeeYqmqlFW3dxSDSNo0hOuLbaVqr8RE6PFEvFNUy
         bHgI3paJTkUnUYVQjwTHVnKWQEfAyv8VhN1W1U1AeHwSVByJgFQ/K4yhFEmynnStsKpK
         /SYDUtcCRGorQ9ih0Rqd1+YNFQQbfjTm06FqiipzHuUujLPrp5tsqw9g0axTxEHQNjeD
         Svhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=82XOXpHXgCbDqi6cGOJH4d4Jh0B4U0W+hHvIm54Ey4Q=;
        fh=CgybAjGWyr4PDiTwmMJEpJduLDu3sUEMbuvDS+7Ee3U=;
        b=AyKxfSkIqRHN4echxpk2Tn5yGCArB7wHxEI2lBz6/LlrjlWmgcpNTMqsoBHay/Mvdr
         PvtRNVRsvw8BtonmW85ypgJwpUoghnBvnVmltQwszamNQR5F/RyH0lxNIGUn5leyL3Q6
         RFSmRN2oaEWQLHW6vvwUPa0wTFrLFaGcFyTZdLhuZAjykUlobOEJCocsV7XTm0KWS8xv
         5Ku0dOdZefoYkPEu0tQ4IlavUqR0M2ErYnR5Fhz9rX9HMDiyH8ZapoVPKFOY2wED5b/h
         f7kdz9KbItClJ+9QZmqOuL/i1PR04kFouoeyTxpgmAYwoIBGhMnTMuAigxN6m12c+eDE
         G4pg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784227214; x=1784832014;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=82XOXpHXgCbDqi6cGOJH4d4Jh0B4U0W+hHvIm54Ey4Q=;
        b=BDRPbmA67RagNaeuRdTtvIrN7Q+KC4dwP3R5Hnlzsg45EvUn/anp1OMXMW/Kf2FOvU
         k2fWmi9XA9NWBz3r2HlnSbOwPfCoNqSFvNuOgKRxHE7q/17IOOvDvbu700Eply4XvDhQ
         6OZjueIh9HLVxUoJ1X/gMSPGXLFkb/p5OzH0hpVv144m/GodSXbYVW6yHQ6l7Yogo/kB
         NMnB0dekrzvSaGpJjsN/HwcAGiexr3fx0U/A+wjdwtBM/sCz4d1H1szeagTdPYCidHaS
         tQtJqXvAVqckOCGDbv7RPPonD8V1FxGQWcnFBxlQFmnIRQ2K8S8s7+rB6c08FCu/jopS
         8vjw==
X-Forwarded-Encrypted: i=1; AHgh+Ro6kQCUIqRgdLSU9WNV1JIGMsrGnwaW1iJmWP6VbmDubh6WoMF+gC8AUp59rWoVr0NLqpd/zZzm1ZPL@vger.kernel.org
X-Gm-Message-State: AOJu0YwS05ZJdFOqzp1hrakADDBEnjzooF8nQxiIJSJyHVpMj4feqQAw
	FF7FJnP6uFTzGzm243A8gWq7MrAhLW8kytmF4S7ZPhO1bWWDj15x+36NLczhSkp7QJOGBcmbHev
	I4OOK0t6Gud/9lPwEcQczWFl3sbN6o5dfeCQnf7jpzUY0j8Fc8HCwGmW8b0/F/YvCrdWnAHKLcH
	qdf4dKUOxQHFLiIINSuztfYAa2T6JpzvgybAm2
X-Gm-Gg: AfdE7cnAWGR3RDyTVKuUn2FOXRED22NYpR4RcoHUz0hcGyvfXkv8M1vGyOaR+FWg1gh
	b9TZldP5isQ0x4MdcIcbdpqKKumBdWeptQ/8f0AX59kd4ZLVpc3eXbjJxt8WdaNawnz9z8dk9ht
	li58beDMHO1/UIQ3UcNMbyojwZ0taRl35oE4dfFYA4YvDXmldrs2XrRlkLzs4Uez8zs1f3JmY8
X-Received: by 2002:a05:6830:610f:b0:7e6:6f9f:7455 with SMTP id 46e09a7af769-7ec59b5190cmr5061448a34.10.1784227214048;
        Thu, 16 Jul 2026 11:40:14 -0700 (PDT)
X-Received: by 2002:a05:6830:610f:b0:7e6:6f9f:7455 with SMTP id
 46e09a7af769-7ec59b5190cmr5061427a34.10.1784227213551; Thu, 16 Jul 2026
 11:40:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715202409.3767494-1-zhipingz@meta.com> <20260715231525.GA224907@bhelgaas>
In-Reply-To: <20260715231525.GA224907@bhelgaas>
From: Zhiping Zhang <zhipingz@meta.com>
Date: Thu, 16 Jul 2026 11:40:02 -0700
X-Gm-Features: AUfX_mx-hKcW_3p8sxUUMvq5wUsM5VeNRvjv0Nzjm5kuSzGtA0D3Lx0TAISbWCc
Message-ID: <CAH3zFs3QptPFLgtJrJ1=e5r2yc8kJ_YCJ9GkzggUSONEPnVTwg@mail.gmail.com>
Subject: Re: [PATCH v2] PCI/TPH: fold reserved completer encoding in get_rp_completer_type()
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Christian Konig <christian.koenig@amd.com>,
        Alex Williamson <alex@shazbot.org>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Huang <wei.huang2@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-ORIG-GUID: YX5c2ilf8h_hP6397KADlgnih06MtG80
X-Proofpoint-GUID: YX5c2ilf8h_hP6397KADlgnih06MtG80
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDE5MCBTYWx0ZWRfXxN1PK+myVdfu
 FpYytndp+U08JdlFiLQno0kmCpCz9QYMbKb53XW0OCbTzWueY0ed8iboPq78mZFArSSIY3ZTeAD
 aTIJFNQP7Dtsohcwz2y+48bSVyrNCrw=
X-Authority-Analysis: v=2.4 cv=PfLPQChd c=1 sm=1 tr=0 ts=6a59258e cx=c_pps
 a=z9lCQkyTxNhZyzAvolXo/A==:117 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=tpM8CJlwf7uhpglF1g9U:22
 a=VwQbUJbxAAAA:8 a=r1p2_3pzAAAA:8 a=sOkTzQBYWZlZEqbE7xsA:9 a=QEXdDO2ut3YA:10
 a=EyFUmsFV_t8cxB2kMr4A:22 a=r_pkcD-q9-ctt7trBg_g:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDE5MCBTYWx0ZWRfXyUROhL98Tdsg
 cN2UqDDFcTR/YEoh/7OgHgF7KEwMl5XW/uvKlTIwGGLy8dYD5SwSjFa/p1ZpJSD5Zx6MKJEEL9Q
 GdYHiJlqkoi7hN9Doo9ALKMll/dWu/Vc6TQFU7vdr4gynt2TsgdFuyCsQ5FEwB2WALrVLduMw81
 axcHtppTE4WiNoiQeFUpeijo/9bOlwmFXFvl7Ca29CG2Xca/g8vtQ42tHD6UjhDXU8ZF8ffXH2a
 JKrHPOS2PE+fkNxX+saGOhawOpWgD2VOJNgquuHsy3ud0QgGq1qx/IXXEPd411dPDz9uPzIceQS
 WPZZbEht8SOadAlqIgS7MuK5T3oPrWbBm8oGq4+hNxnEbOIMKe0ITDvyNXmdYqzhsz0OgHwgYtr
 gv0a3RUtXM5SLGiAUpeRdQfB6mlrp5++ZznX8O+OwKK9a+2bLKk7CgzK1ps8Iv1TB3UP7EOVFfr
 o1hVTFQUu3Hkek1SuPg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_06,2026-07-15_02,2025-10-01_01

> > +static u8 tph_completer_type_fold(u8 comp)
> > +{
> > +     switch (comp) {
> > +     case PCI_EXP_DEVCAP2_TPH_COMP_TPH_ONLY:
> > +     case PCI_EXP_DEVCAP2_TPH_COMP_EXT_TPH:
> > +             return comp;
> > +     default:
> > +             return PCI_EXP_DEVCAP2_TPH_COMP_NONE;
> > +     }
> > +}
> > +
> >  /* Return device's Root Port completer capability */
> >  static u8 get_rp_completer_type(struct pci_dev *pdev)
> >  {
> > @@ -211,7 +226,8 @@ static u8 get_rp_completer_type(struct pci_dev *pdev)
> >       if (ret)
> >               return 0;
> >
> > -     return FIELD_GET(PCI_EXP_DEVCAP2_TPH_COMP_MASK, reg);
> > +     return tph_completer_type_fold(FIELD_GET(PCI_EXP_DEVCAP2_TPH_COMP_MASK,
> > +                                              reg));
>
> Is this just defensive programming, or is there some hardware out
> there that uses this reserved value?  It's kind of an ugly wart to add
> just for theoretical spec conformance testing.

Purely defensive -- no known RP presents the reserved 0b10 (Wei
confirms downthread). It was split out of my vfio/dma-buf TPH series
review [1], where the 0b10 passthrough was flagged. It matters because
the value flows through min(tph_req_type, rp_req_type) into the TPH
Requester Enable write, so a broken RP's reserved encoding could reach
hardware.

>
> If we really need it, I'd rather read something like this:
>
>     tph_comp = FIELD_GET(PCI_EXP_DEVCAP2_TPH_COMP_MASK, reg);
>     if (tph_comp == PCI_EXP_DEVCAP2_TPH_COMP_TPH_ONLY ||
>         tph_comp == PCI_EXP_DEVCAP2_TPH_COMP_EXT_TPH)
>             return tph_comp;
>
>     return 0;

Will do for v3, plus the comment Wei asked for. Note that series [1]
adds a second reader of this field (pcie_tph_completer_type()) needing
the same fold -- I can keep one helper or repeat the inline check.

Thanks,
Zhiping

[1] https://lore.kernel.org/linux-pci/20260709132602.6a3fb084@shazbot.org/
