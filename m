Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7541D470446
	for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 23:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785453113; cv=fail; b=FJ2A1OcBcDAIwhWp6YfhWe4kWrzzLf2CQgFr78Dxn48qRuIjIsLeeJZwEesPoeEEagTIsdh/dKkLGST9iffWEzhASXrWDmdw3jd1AzmvEHiB/Xvv92tUXHs+3PBNVJS4EUOjtGGMwo+C9xVyb8YqSNk4jdT4acMvQPNjamwlQ/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785453113; c=relaxed/simple;
	bh=mZkWuf8Tw1ScJOiGAEPnxEFupaFuqq16dRc3IKYjOE0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p+xxZpivyMfczPz6sg1TDH4rU5EOIfSIF7d712sk2XRQUIehFSSL7z5QohCx1ErftDfwPNa5T+pyDBxDZwiYXA1l3wqqmOjiwurWhHr8Fvn9M8mdJ79Fx9iP/0okOPwr0xQ6aLyTsV5LeZNB5Z+FkB+eGnyeFQ7pNkhSQ8Mz7DE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=ZPG5m1H0; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="ZPG5m1H0"
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UMqmdD3811518
	for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 16:11:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=MQZvIZut96GvNci3X99SyHgHT1lUNbmnZFvwy
	HttL9g=; b=ZPG5m1H0kFzvBQXgU72AfKEr0Mo8eXoJw9AH1/+AoyWU7osEmWB1z
	iNvtHmV80qUf0k9PBJJTcfkIlfCWYzIDz54TT6UqLhtCav/aSCsuKdYrdK+yjbKs
	bLeCRcQNikVbp+ifEJTkQF3dR/DeItQRPhrhflZt5x+CoUScOi5/4/E7yWqcX670
	kgPGlHlvmS28rVFWAQpIoVsZj++Jep54aE6u7ej0D9jHz7rWOgyDQehRxNzMoS5D
	GOzc8kDSWwGuciCoGmrGUEb8lyCkbAj6zA7QsFCBgTCnZkV/Rjub+sbXqVZAkzK3
	T1khLdV0Lkx8g/3l2RUTYYemAI4aFv/gw==
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4fqrnqs5k8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 16:11:49 -0700 (PDT)
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7ee59eeb8c1so330725a34.0
        for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 16:11:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785453109; cv=none;
        d=google.com; s=arc-20260327;
        b=YBLOAqoACHM7BkA4Le1EikLP7zSO/901AOrKTFvzIeyx4FU20wuZr7JYHiQQyKQETP
         c55ZEunoJdmAqBH5Keptc7EOOoEHVWCjgJNh/oPBL+8EH2fFHtDetmIFMhwjOl8G+mRD
         73dZ220eyzevm7y9zPKsRG6EFm8hWuDFhFMCHxj9C2Jv/CBZ17nA+u1HTIblINw/wv+v
         3M6F8xp4jaQv09HKahW+pxUHZktXxVtDJGaw0z1niLJ3PsEnGtkhrWWjFap8GwmqR2ND
         iR9g7h4y0u76uPywrsgLHhSL83uFCzq5j0KR0ETgCg83Eo0LKEas9ff4bau9kQ6xhGLf
         O9ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=M/ULMas6IYvKWt6d/m/OrKQfnMR4mdz7pKS0PvlT0yk=;
        fh=64/MtubRqa7L6Y7814PCaKHDv0B43hblHf8Vs7bB+Do=;
        b=HEwVScP48Jzb/P0to2qASwErJfZkDp0mEg/ehHVAfeZpELZDUXkGxD7MhUCWAwisKi
         q6fYsM+ZokUwuVbZB0ek7WDS2TJZhAqhqZJ/7LXdBM2gYza56Vbvm7fqIEtOROFXdv1P
         N/DSbXqUw1Z46VPOMK5C/+Vk4L3lWh5FWyNi7BHV4io8dFRGLcj00qwi5F9jn249QwQ+
         6a0Bn7pbh6Op0PHNVhHx9RyBLTHNeuK12LzYFVdmRoil2FJM4YLRoIognmcD2JaO5Cxd
         hvi9h2W1l60Z99/QUeel4sMtr+rSvhREear6NrkjnMGnDGY08JYwQQfawdPsK2aphAkF
         q7Xw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785453109; x=1786057909;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M/ULMas6IYvKWt6d/m/OrKQfnMR4mdz7pKS0PvlT0yk=;
        b=YHA8Zgq0YwCetfHzTJC7wf8m0OhSfj8YYjQxPbSxha8xUXe6GZgEo8dmvY1qUss7pX
         j+BHC/2O+vxnIIRmaJvJiwkqA80hLftvjnX0RfGGCzZiavF/5o7P2M11lWKjmuwnBJn8
         HusPNmTeaKyXe2tjKXs359fNpSPdtuHrfilepmb8y2Ppa9rfYUwcTRQu6NmsvnbhURMy
         Tz/uacix7uacfZqMALPjONh3JSQNvXK0HApbXpXej07G/NlP9SBj2o7O4rJGALPkahIf
         dsKOE+qCqgl2C2BHPoTBNdq0LzGuGi58tOWesnq/Y/v4KFxHQ4nmD5+FcKC2f+efXrru
         Q5oQ==
X-Forwarded-Encrypted: i=1; AHgh+RpzUUR4u7t1AZeeY/tzAbiFY5YUDAH2RLRK0TB15RHxvL6RPDGbgCMn+1zWoB4vyYlJ0P7U142FDyUR@vger.kernel.org
X-Gm-Message-State: AOJu0YyJxmXXOLapxkoFaB4FIdoWfO8Iavn4ueu7PaLjx//0+OGHPVFH
	Y6p7sb6WR7upBGZTmdTj+zqrgNGKOQkN8BWD1Br5rheKYLstHYZaX1Ur9yay4NRvHuTLfsHTqTG
	umH503y6ZI/j5uu3rawbKtB5YDKcPt10EmtvScZSaDuzzJFzAliFAx0ZhsG+2z/kf/5mugnUZbm
	ZYIQrH3QyQ7XFaDtDnhto9yeZbjs4HFK1unmIj
X-Gm-Gg: AR+sD12T1EYshDr82gB8QT/iHvqSAq+sl1Oopc7F2LQsS0wzXPtNpiodetnKXRmtNRU
	SulEIWaL6qfJEYn1lOEM87vHed2h1nfyXzZC3Wure7rW+NieO1c6QJhzxUau56tNy0RRBV1FIDQ
	c3lPP2UFh2uWfikqXt8PgC4EHmkc1IQ1Q5mtgqvGPYjHulYInZULC8ekB/TK7p8GsL1QvedWDV
X-Received: by 2002:a05:6830:2b27:b0:7e6:e349:538e with SMTP id 46e09a7af769-7f02c164dfdmr3481508a34.19.1785453109097;
        Thu, 30 Jul 2026 16:11:49 -0700 (PDT)
X-Received: by 2002:a05:6830:2b27:b0:7e6:e349:538e with SMTP id
 46e09a7af769-7f02c164dfdmr3481462a34.19.1785453108481; Thu, 30 Jul 2026
 16:11:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260720172304.117134-1-zhipingz@meta.com> <154760d3-a880-4d1a-b949-7d22efb805ce@huawei.com>
In-Reply-To: <154760d3-a880-4d1a-b949-7d22efb805ce@huawei.com>
From: Zhiping Zhang <zhipingz@meta.com>
Date: Thu, 30 Jul 2026 16:11:37 -0700
X-Gm-Features: AUfX_mw5Pss60TeCzA9vFQZ6X_FK0vCL-oQCe7PFRlEJhncMdwP-o_KTKHFf72o
Message-ID: <CAH3zFs0L-k209Ct-uJn9UOctesJRWf6RmVNyD0kfhDdDtpu7JQ@mail.gmail.com>
Subject: Re: [PATCH v3] PCI/TPH: treat reserved 0b10 completer encoding as unsupported
To: fengchengwen <fengchengwen@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Wei Huang <wei.huang2@amd.com>,
        linux-pci@vger.kernel.org, Christian Konig <christian.koenig@amd.com>,
        Alex Williamson <alex@shazbot.org>, linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: 5iGcp6Gc9flmkboB0t_0TihShDe3blwY
X-Authority-Analysis: v=2.4 cv=LsyiDHdc c=1 sm=1 tr=0 ts=6a6bda35 cx=c_pps
 a=OI0sxtj7PyCX9F1bxD/puw==:117 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=JnKecZnUtZousrUlYMGU:22
 a=i0EeH86SAAAA:8 a=VabnemYjAAAA:8 a=Ey0NKmTq3IFYR9_H72sA:9 a=QEXdDO2ut3YA:10
 a=Z1Yy7GAxqfX1iEi80vsk:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: 5iGcp6Gc9flmkboB0t_0TihShDe3blwY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDE2NSBTYWx0ZWRfX61WFse4MVx47
 XcTAIMwZ0X5qvqodmF/WnTQ21akg7YDql1RNbQzZGO5hFUcRZ+L/7N8mgP3LqN83KRoP2RG79WD
 g6GhBG/8Nkt0gpvCF5dfH+B40v90lgsBexhRRedV3/7/BSdKF4l4IORRi+JMuJWD9Xbkpz0+Ote
 aTz6Fzm7TN0kh4kFIApDlMI8MdgcQRlFwhR31uPcc27UVwTw7Rwk3BO3kgFmDwNSwvbf3WmpeEa
 2181H7ljGUVr8y+p+NJQUN8nISXOfv5GaWeJN/sBYrYvlLqnKp6TtIiq+ijvAIinZNc0B+JZ6No
 +MrNSJ03VjAQk9pEeYBZVxO+60TOCPklXj0rRsfHxI24OLs/EklK4sgZZrJXBEYVVgej/rNdFa4
 H94VG1kPPcT08hoTgh8+dz3AcBKcR4TQt9OFLQRZnFErLDOuU0YkEj6qDfNGyXJeykRIZXXzj0v
 g6Qwk7h+ia+GWgvopcQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDE2NSBTYWx0ZWRfX1/b4Btqrtm3A
 50RzOSEAZjm0IAARkB3/co60dRNKciRGX1j24CFgea+bwfGvfARElXdNAz6qte0y6nS2y1OsdoK
 /qF/ZWTPz/oc4WSJlwB4PiZsXfyqIWo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_07,2026-07-30_01,2025-10-01_01

Thanks Fengcheng and all!

Alex pointed out in the vfio/dma-buf TPH thread that keeping this as a
separate dependency makes the main series harder for review tooling to
apply, while this patch is a self-contained hardening change with no
known affected hardware. That makes sense to me.

Unless you prefer this to remain a standalone PCI patch, I plan to
include it as the first patch in the next respin of the vfio/dma-buf
TPH series.

Thanks,
Zhiping

On Mon, Jul 20, 2026 at 4:42=E2=80=AFPM fengchengwen <fengchengwen@huawei.c=
om> wrote:
>
> >
> Acked-by: Chengwen Feng <fengchengwen@huawei.com>
>
> On 7/21/2026 1:22 AM, Zhiping Zhang wrote:
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
> > Fixes: f69767a1ada3 ("PCI: Add TLP Processing Hints (TPH) support")
> > Signed-off-by: Zhiping Zhang <zhipingz@meta.com>
>
