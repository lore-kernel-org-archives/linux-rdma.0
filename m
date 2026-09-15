Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939D239A04D
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 23:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789514114; cv=fail; b=C67cIfVU0MDurFBFobi1SX420yV/sOZA0AObZQto9dUk85GigeVoJv1gf4NaVqb6KrJRLfgeq8eX7jnihchfb+aCqljGJqWca77mSElHU57HafBsigr0KqglopTBwlSwBawKKqnmc3CcChR1jNhEgIYuKBFHGwpjdJieOvyTphU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789514114; c=relaxed/simple;
	bh=Rmo+TwHeElx+2npaJnRSKbzBj193sekBXZLZI35ZXwM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ltvz0U0DW5cxUIAmdpHtlzc8jggu6gjJnB+XjozmctNmXtk3AjnAwAUTPkH/18UTo8L5Vc8MLWPRPKzY+xb5nOb9IZeWUERB2C7etCWFvrcEL4XqutSTKUGoyM/d2AXX7GnJAyxzN9QtEgBJpq9GknBPwpIfOdbdojOQTXwKKb8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=SIXx0xrA; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="SIXx0xrA"
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMOXKg1472216
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 16:15:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=9wSKnU6K8x6VtxP/QNuLN7MLmNw6mKZQmf+9X
	IiVvUU=; b=SIXx0xrA+TwjdlTogR7fvr6LvG2I7Icv08Az9vCa/jwMZH5282lDb
	fITP5NGPExDCwMPo2NWJYTt4cs//NI3xZM6vnLSwvCKR03RHUaKT4FRbZQXF7pW8
	wsxiplIBxZPBMsM/WO1a6MO0wTOImFGp0ZNUrmacGmQkr1i93e3ApULxS50+MCOG
	RDvPl4MJ2C+2R6YDeiugKDUPRPGote74ERplmgd5+LniAtVGTlx4x2BIu1DmUtp6
	4bCDxqPm0RNRhVOR0xeEdOywHGun5E4lFBdCvFLcju9Nq0rmk6h1Ixd6uFDthHXF
	laYCFWUso+8lYVXC18+EsNnAdYEHhqNkw==
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gqdwn8pyj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 16:15:11 -0700 (PDT)
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7ffe94da829so2845168a34.1
        for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 16:15:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789514111; cv=none;
        d=google.com; s=arc-20260327;
        b=nCGsy3lWBn8P98imiFlE17pYBJjkjl7x3UmXAmnbh86WS/RtEsXVsyWSClcD1g4iWD
         W2ZXIeiNulLgO0iDwHbhGilAqUZNXLpdfNTQpwpJ9o3vICs4YWAIuGnArBMFB+4GH83M
         wlFeA01HjuIoZdh1RikVYMNtAdEaYay45TJGhr/vEBVCfGoHKBzi0Li/hnJCTB9HrO9N
         LKbW2+EkMl8W7x9vW4xcH518W5/kQon45RfB1sjHg669aj1+bkrYypOdldkTI0HXbfZ4
         oZw3NK1feDh63GMV+AL4MCehsV/QqNXmwsowzATgfmLAc4B3VjK214rn/1uPINiOKPJc
         cSgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=5Z9FH4pGg+zZG5DGIDh+CM+cqcFCAu2VEGfh4kw4QyM=;
        fh=6LxXgcmJEsgwlj9dJtk6CG8gAm/SzGg5gs1Sc5OPYoc=;
        b=HGAYmnXHT+5fUFYE7bp9xFRMZluUqC3uWMKHLIDSxsoNydQATLrGgmUYV4K+mxriVg
         XiZi9/41J5GX1Gzp/49kvVc7fpkujiJs4BCM4TYjksDanituw8s44viUWmkx/01zcw/C
         e2fzMjbavvvjnNnXewer4yvHRQ7p6GuYyLvXXkwUdNHQP/25M8VNUkB2FvYOs/NVDNV8
         9wMtBgiL9f4s+MsMocOaAgr2LVmBXfTHGw3OFRfZ6dIOzZ9lCozZsiAwQGG3hC3Zd5if
         Vb+qhu++v8yc0I36hV0yJc5n3uUKVQc7nMs7xoOczSYyzSEsiwWd6EYNFvSdY85GWK9T
         bvMQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514111; x=1790118911;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5Z9FH4pGg+zZG5DGIDh+CM+cqcFCAu2VEGfh4kw4QyM=;
        b=HUSwFFsNqV2xpaFrBA8B13iEI/y9U4QcfMsyd6jDMJE0sgE3Md84tT6fdWNBO4VQll
         I6duk2V8zMKy9bPw87mOU0hs0MaqGc6OxQbf/YjeqV1VbTcdhJV39fR2VloCTq5ecei4
         P/Vba+2x4nlrxu+jc8Yb0q5u2sThx3gZsawzyUyFsJ4pUFRVhnbd3f4JYKrlO5pErw8A
         MFuu+PGGOFa8qDX94nlXDeGS9TSEAC05T02bFTGUzNeRbDz1mIFknmK/jCcOTgbSWkQK
         iFHxNvM1gpqJfljE2MtH58E4cKQMn6kUTgo23i0xupqxTqPSLnxsnBBuRU8Y3vcBgkgN
         SYoA==
X-Forwarded-Encrypted: i=1; AKwUvBy6FN3NQbunAtz/QXDhJ+gKJ9Hv3TGaffPhcn6VerP/SDvjDNLWHsFbY3ZMibwWnBz4KlMHuTM2HKmg@vger.kernel.org
X-Gm-Message-State: AFuF++nSGChqCKza1A67EIHM2NqJExSdEXgUHRT9rFrHIbfdCmVR3ilv
	vrvwrDZkvXsvDCC1pwNj9MD5oh4G8fi4tRYme6WMwyR7derkkgqabGKEdOwHbvk/i1npTbS/PsS
	qC5hedzsylKodLYI2YAnIEvqpVdCXHBuJXgI/2yJV617sLAJWqhf3NWo4RyOHMeTffY6Ft8WOXO
	8dev9QaX+P5gPiANA2ZHjRcLhuQeX3F43Hnkg1
X-Gm-Gg: AYBFou2DznSLMWR0o99f1JejEd7Tv0Y4QMxv7G+0FDuJeXk9K0rzyP5H09OdbPZGdnA
	lKoVVPzmiMfnNizp3jvs3Aok1UP84uDipKe2+1JXFJggwi0leYytonw2E5vqBSpEMQvNPyfFWSe
	zJLD+p6+99WcfBv7DZiMVCFqfHEM9zrbAfmn/7XKkx9bPJ8fhwMJ9oAkshCH98DqdeSkJuE8dn
X-Received: by 2002:a05:6830:6001:b0:7f9:555:1def with SMTP id 46e09a7af769-80b37d7fdc1mr343247a34.11.1789514110407;
        Tue, 15 Sep 2026 16:15:10 -0700 (PDT)
X-Received: by 2002:a05:6830:6001:b0:7f9:555:1def with SMTP id
 46e09a7af769-80b37d7fdc1mr343224a34.11.1789514110002; Tue, 15 Sep 2026
 16:15:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260731211601.3033906-2-zhipingz@meta.com> <20260915221924.GA876929@bhelgaas>
In-Reply-To: <20260915221924.GA876929@bhelgaas>
From: Zhiping Zhang <zhipingz@meta.com>
Date: Tue, 15 Sep 2026 16:14:58 -0700
X-Gm-Features: AcwNN1XwigNQ9uW6nBUmoxE2F8a1TK24gfEznyxrn867tS2zzsfZXU6D-kJDtU4
Message-ID: <CAH3zFs2EyhpkJXRr7gbC+Oyb3y6Y+yyVzAgXCvg7_won0er4oQ@mail.gmail.com>
Subject: Re: [PATCH v13 1/5] PCI/TPH: treat reserved 0b10 completer encoding
 as unsupported
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian Konig <christian.koenig@amd.com>,
        Alex Williamson <alex@shazbot.org>,
        Bjorn Helgaas <bhelgaas@google.com>, kvm@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Chengwen Feng <fengchengwen@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDMzOSBTYWx0ZWRfXywYaO8+K6Zru
 I356I3++pcEFA3Gef0eqncLGakEC0TM0wRM7pYZ600sQIRly5rteudd36XB3Vb5DtXjakI4btm+
 NG0+eL2eZAsHSpu05CF7ep0KF8FuF0E=
X-Proofpoint-GUID: tlxS9cPIFBOQOUdp8VfAl6P2YECwkcqZ
X-Proofpoint-ORIG-GUID: tlxS9cPIFBOQOUdp8VfAl6P2YECwkcqZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDMzOSBTYWx0ZWRfXxmEVfvcO0Nou
 00LNDLiuVBZ98zVCt6WXLgLGefCPEbY95j9P5rzSTBvUx4OQzxzWntc+qvG/VJWTttiNRGKV9mb
 3EhJLU22LD8OMyYebvnHK3+32Be+W97iH3rZN5gIwlqk+RaZbT/AWIgXSmYsVH5GGH1ULDUKxrl
 dLOZvUC4Tn3LmkKcd60NTAjqbwJn59WEgkzrBuKtNqsQjPTS5gng8xYoG7cznzevxJ/ZXEA5Jq5
 SRJCsdoKw7FNS9k1ayPCcpSdhnzfY5AqtP58qIhTWTMYknu1/V0aBH9eWsl7nZnZqnp64feHU2u
 hwE7ISA8uwCirMlH3KdljpatA/Fc9fYeeG3QeV0eDxCLEgwHnnHbvX+9R7JNQaXW5H+D27a6n2z
 wyE0Z8h8xtdVAD+pVKfUBFS8vNVGxUDvl1effoigceT0YEQmkwY++B5tRC4LBG1Iuhh2vXAyFpY
 Nfi5wuVpUuvJgQCz/jA==
X-Authority-Analysis: v=2.4 cv=LpEHWXdc c=1 sm=1 tr=0 ts=6aa9d17f cx=c_pps
 a=z9lCQkyTxNhZyzAvolXo/A==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=tpM8CJlwf7uhpglF1g9U:22
 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8 a=i0EeH86SAAAA:8 a=1XWaLZrsAAAA:8
 a=4OgE2WNpP8yww339eGMA:9 a=QEXdDO2ut3YA:10 a=EyFUmsFV_t8cxB2kMr4A:22
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01

On Tue, Sep 15, 2026 at 3:19=E2=80=AFPM Bjorn Helgaas <helgaas@kernel.org> =
wrote:
>
> >
> On Fri, Jul 31, 2026 at 02:15:48PM -0700, Zhiping Zhang wrote:
> > get_rp_completer_type() returns the Root Port's "TPH Completer
> > Supported" field (bits 13:12 of Device Capabilities 2) verbatim. The
> > 0b10 encoding is reserved, but pcie_enable_tph() feeds the raw value
> > into the requester type:
> >
> >       pdev->tph_req_type =3D min(pdev->tph_req_type, rp_req_type);
> >
> > and later writes tph_req_type to the TPH Requester Enable field, which
> > only defines 0b00 (disable), 0b01 (TPH only) and 0b11 (extended TPH).
> >
> > No known hardware presents the reserved 0b10 in this field, so this is
> > defensive hardening rather than a fix for observed silicon: fold the
> > reserved encoding into "not supported" so only the three architected
> > values can ever reach the Requester Enable field.
> >
> > Signed-off-by: Zhiping Zhang <zhipingz@meta.com>
> > Acked-by: Chengwen Feng <fengchengwen@huawei.com>
>
> In subject, to match history of the file:
>
>   PCI/TPH: Treat reserved 0b10 completer encoding as unsupported
>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
>

Thanks Bjorn! I'll fix the subject to match the file's history and
carry your Acked-by in v14, which will otherwise just be a rebase of
v13 onto 7.3.

Thanks,
Zhiping
