Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5503F44DC
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 18:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784227448; cv=pass; b=UG+uPIjv19WIHxT8ucrs5gfFSRs9cFDEBhbcrPCx4SVDahPl1E2hHnXOgCziZKbjLT3o3SSxDmdn3l7kq88kMpa86/eF7AZ/03DbjkPWUk131c31weCsIMp+gCCQ3oDztBDjEjb6PBa0dNoBQs1gkhAWIMNze1YEciLZPFHb1FI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784227448; c=relaxed/simple;
	bh=B2lAv0Kke/zaTF5v6Dg4abddoHPxXuacOTWspld/Aos=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oLYE/4rAcwNo+IuXe24wgo8KIkLsph9OT5MJT+zY4SbVaB7wxW/4f0uoVZtez6O3xsoXIchIBrierBWiApB1BAFw4Fnj+EbuCz/jOjbIDdjsSUyNQ0m8BFNNvvYvLlb7tWxv//qLdo43xsX43IuyXXXbi/RcOEgZJOwquWHFK34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=n0Of2kn8; arc=pass smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="n0Of2kn8"
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GGUh7h3627139
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 11:44:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=tro2yUuohTej5GDynd1Qf3SmBPGMdcgG3ju1GffyhJ4=; b=n0Of2kn8kyXL
	4ODtaxekKt2V1jiqoP1wAYtYHiSFzPrRtxIXrNkgJ3JFUPd2F9bYVglDFCRg2vKt
	uHRh0j2ChOXBcYkrxPwS0c5XkQLYwskVTx8Z67DxOzdweLG2kVLFwWVfGSspYqu1
	8kJZE7tdRtTQ2b1k33QeEzyIFSJxlAIXKs24iNxEy3fQeFalZZtmyb6ciBZgZhxB
	bsMiq2//waTzd0k1CyrJUUQxy7H0EESCYz1yBMxtLRR3gBjys9HSOswkcnxKq7WX
	+q4vHE2spOqxvt/oLc57kNjmQW8HOMesed6hCSzGKRP1tfHAxqI7kJ+445iep1vb
	QfiIpbsSuw==
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4few7w2wed-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 11:44:04 -0700 (PDT)
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7e7624e584dso5728501a34.2
        for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 11:44:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784227444; cv=none;
        d=google.com; s=arc-20260327;
        b=oNcxnd9esp0uuz/xRP+CQwdFOoc3WdeBGTU519Y2UoJpkMKYs5gWXF/giOhr/n0+M0
         BGqY66rALTM+lvQrxRBfZfzgwKKjDw8BOfAPUJIHgtsYB9SmizP2UMnh6X5yPJf5FLf6
         3zPSfj/gIAMPMZkvzEPi+msOBbbJyduJDgeEUO7p5NwOhH7PvFF++N8TYRRyj79z/g6l
         6iFsMK+om2oLe0+W+yGwKB3PXdW65GxNcifkIhi8BIIC8vTzS78FfVcCFl0/PPnv4b1K
         FFhWC6F0YyIY0ygkpMZJFYSVCdnaZ1c+vNVP+5wMYS968pixx+riK4IteClFRk+16wEE
         T6IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=tro2yUuohTej5GDynd1Qf3SmBPGMdcgG3ju1GffyhJ4=;
        fh=mjkl4O/1CfH6vn680eCvay7X2pMGZfDKCBmdB4tvDLg=;
        b=Fu88CTeCG/8JBx9DTpFWoqqnaQi2Gm+iNwN9CibLAFPMhX7+7G/kJCJ3u5LUg8VLgc
         NpYxC53AYeByrnYkQ3L7YZkVJu9oSL/Yo+dIXHn9AzE5X77btPNDLCkNoLHc1SzEeTCi
         NFB7L4add5LYFlwCofEpfOCkvQGJWIov2UjA4SUuTPp6oGDdds5AZ4uveJqanAIi5mQ8
         yfN7fI7u+4Srgxt+lz+IHf0ej88jm95ZPIrj3Rj1OBXohcDf/0Vm6UYNPaqKUvlZai0D
         TQaWzFmgnDad8QZF4zeT1K6LrwQxciKr6LtIsJx+3eHi6Xs4K/Tl45oWUWxoKePvQCRj
         GUuA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784227444; x=1784832244;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tro2yUuohTej5GDynd1Qf3SmBPGMdcgG3ju1GffyhJ4=;
        b=cFrU5HajLZqEd6tsAg5MHuscgUy+PH1OQVyhJG3GAk+vH1erw6542NvW7HCi+PTf3s
         OlfJFHxfwt2MbSgYOlSXSQm6S87GfMBrFjaxjp058BzFyTTopq1dM1iWNSVlorOPD2/n
         NGrVjShYkTAyPl7mfZvS8EufGAInGldqxwnAqZnNv1ECwT4VHWunrvkMO+G95f2R7r0N
         7vjWjRClQVDjXWzwki5M8G+QOMIjZEPhzkQze1ItLkhx4cb1hRTCMh33BYXulVUEUCEa
         pdUw2ru/RML9kgvuP2ITLL8l18zGNxNx+zRWa2eIF34gWWWF28w+W257iRFnF/CFduQE
         EDrA==
X-Forwarded-Encrypted: i=1; AHgh+RqMnFN3icp+UJl+SWyDUm9N8Qp9Ht+T9HBNMhO0mWBZG6g8qa49qS7Rr+L/wSDKhhli4xUXUVtjMcpE@vger.kernel.org
X-Gm-Message-State: AOJu0YxVJcgEROuDYnWInoBtRhbDVcpDvOZdEll8hxYStLSqu0CCuCwa
	D5YlNpTT67vWDVzolojULOmOQnC1t7VhXb0BlBfrl1flLZXHW1B10r9YZhKJ+pW1cs5kWs8rPpv
	zUGFxsY1HBbF0WDIWibcAuK3s0Cx7qxXw1RzcGwsJZqPTiJiUMjMc2alQPtFp3LuJ+Xewg5uHD/
	CVrznwklWgXkiiQ/PPV2wUuvl/3rij+NzPOoBF
X-Gm-Gg: AfdE7cnHhwGHFjE5YzfKMIhXzYTDJzJ2NqMHewICTqvcClWbRhasodZWm8yCbCvRIUs
	tcy/GC+jL6gwMCM/eK/bAC1Mkuv93MYi8R9dHnLtR1EcQu2QevGTldCM8Onrperu4yomHmnBua3
	17n2gFsqwJ8Ym3pLQvTVoAP+0+EMHvlt+iJcnpF/hMSrIinVXmNLMxu6qFavDbSTvwEO99TXJ+
X-Received: by 2002:a05:6830:6c12:b0:7e3:d199:3164 with SMTP id 46e09a7af769-7ec9fc13f9emr564038a34.11.1784227444001;
        Thu, 16 Jul 2026 11:44:04 -0700 (PDT)
X-Received: by 2002:a05:6830:6c12:b0:7e3:d199:3164 with SMTP id
 46e09a7af769-7ec9fc13f9emr564008a34.11.1784227443523; Thu, 16 Jul 2026
 11:44:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715202409.3767494-1-zhipingz@meta.com> <20260715231525.GA224907@bhelgaas>
 <alhU7lktqNxAPB4E@weiserver>
In-Reply-To: <alhU7lktqNxAPB4E@weiserver>
From: Zhiping Zhang <zhipingz@meta.com>
Date: Thu, 16 Jul 2026 11:43:52 -0700
X-Gm-Features: AUfX_mzvgf0dz1HdxSS1kkTD-1brO-RbEuUYhiitRfY9lELwvz4jPCPOlSizCr0
Message-ID: <CAH3zFs2pGMHE8xg_hqVCwp4tPEKQ3B8Ldu85kU=bsguK_MgdmA@mail.gmail.com>
Subject: Re: [PATCH v2] PCI/TPH: fold reserved completer encoding in get_rp_completer_type()
To: Wei Huang <wei.huang2@amd.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org, Christian Konig <christian.koenig@amd.com>,
        Alex Williamson <alex@shazbot.org>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=MrViLWae c=1 sm=1 tr=0 ts=6a592674 cx=c_pps
 a=OI0sxtj7PyCX9F1bxD/puw==:117 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=JnKecZnUtZousrUlYMGU:22
 a=aoCffaJH-pVtSq24NWgA:9 a=QEXdDO2ut3YA:10 a=Z1Yy7GAxqfX1iEi80vsk:22
X-Proofpoint-ORIG-GUID: zmfNNU4b_7vefJ7DxtbBpGpoiuNnJAJB
X-Proofpoint-GUID: zmfNNU4b_7vefJ7DxtbBpGpoiuNnJAJB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDE5MiBTYWx0ZWRfX1wAXttiI96EO
 pLzfL4bgkhc5+Io+Gd6Pi9EAzP/RbA5PeER6YlzXnxvVLUQMfmasSS37NxBUv3qZXFLeYc/45DA
 qHI8Jw1ollyE9OV9ByGFw6fMu4Jd3dC+kM3G2ebU3yfjG/KKK5Qe36cNsG2x++JXIzddBj1YfRZ
 gv9HpMt87deSQ7RZP6wYsV1YhCrqMyxho4PBW8W32Pu1GH8kG4uVkHTSOoNyyzeO5GkdOplweuV
 wtJ61dhoD03QK3Zk0ZqOhELM2SyV13kyth7ysoZcYP3KalAG32F6TKlSCyJCnhztiLRhSWCe6cM
 C4DJCFFiffYjTh9fOsUrwbTKHcCy2DMsFwJNSRg/lqpGnk5in0I8uP/AO/+e+8D+Kl2xOVUbKJC
 orwHo7nFe76F8j0hIdGiwHRUnVECn3o/SPNwu7JTHRiK0i5wsloocRfJ2u3HUkohwxhRGfVt/Un
 6wmz15eBrkTwGLCYftQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDE5MiBTYWx0ZWRfX+J+S5Vvap2/O
 hRxV79C4doLRsJGOXG91WZEH69IuoEPcstKU30Wv+O1DoZzjgQOIkj8Y4cWbcfUDsseJs+KHwKm
 D2WUzqcJ67zKN5gsxFQIfM4WXDzjSUU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_06,2026-07-15_02,2025-10-01_01

> > > -   return FIELD_GET(PCI_EXP_DEVCAP2_TPH_COMP_MASK, reg);
> > > +   return tph_completer_type_fold(FIELD_GET(PCI_EXP_DEVCAP2_TPH_COMP=
_MASK,
> > > +                                            reg));
> >
> > Is this just defensive programming, or is there some hardware out
> > there that uses this reserved value?  It's kind of an ugly wart to add
> > just for theoretical spec conformance testing.
>
> I=E2=80=99m not aware of any hardware that actually uses this reserved va=
lue. While
> being cautious is great, my view is that such RP is bad =E2=80=94 arguabl=
y to the
> point where writing 0b10 straight to the device might be a right response
> (kidding).
>

Thanks for confirming -- I'll frame the changelog as defensive hardening.

> >
> > If we really need it, I'd rather read something like this:
> >
> >     tph_comp =3D FIELD_GET(PCI_EXP_DEVCAP2_TPH_COMP_MASK, reg);
>
> This looks reasonable to me. It might help to add a one-line comment
> explaining why tph_comp is sanitized here?
>

Yes -- v3 switches to Bjorn's inline form with:

        /*
         * 0b10 is reserved; treat it as "not supported" so only the
         * architected encodings reach the Requester Enable field.
         */

Thanks for the review,
Zhiping
