Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794512171;
	b=saGwbzzk4j48TFWqrm4LbUNpMk68hRnvOna1BcoK2S7Z4CJ1sYCzbl43CeVVHfm4V9Fs
	 GLL0qusJM2NPfqPqStQUgLmP6TnWzkfoft/JcqwNiFYs0VlWYIESSt6Y62m4Fm2k3vg/A
	 e3VWJHQMNw6HwiKx0ZYW1+/cwgP6oOlw4IN7WJDjaJCKppz3FA6I60mYvGloLffbzzBuI
	 W3KCYWMYLAnKmA9caUDiEjYUBbqSx1LS4fgM8zPjAxPUq1gqZr1QPqhnH9xRpi4MLFr11
	 YMxqxatDjG+/b7DxAgrvyve3ZY0FKwYo0wPzImNFh0MTB/JNUCqwPdrcOtmlgCeEZHA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794512171;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=Q3u7I1yY3nJmuq+49fNnSVZ6NxAiKftF5EDGZUfjWaE=;
	b=FZbq0TNKVsEwwbRKYjVGh39ujQ6z5xYBEH+YdpmOvyXCyz4YI5EDoxrLwuGeRzWqato5
	 MJS/hckh6YORIeh1JhY9s4jkScyK1Tu+kXfIxdnHhQaQwus1bmlS7FxU9cCS+E3d4Y4JM
	 xp+hxRP139o04JxbzyJJCV40Jt6BQ5I1zkobVSOLtKPsowm3tyqiVSC359j1B6OyR26Wu
	 Ip8dUGbCrt1/Cfx3NmivJwl+V/ddFa0l9Mog+/4UyPBNM2pO6K4Og0Pif2hBFVPBtgcx1
	 H9i5g7GmBW3MrnNYP4SrVP6KP3d8S+YMekc0IUOGgQDtobGGsV2tO3kKFbcGpe9UWkw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=LU8nJzdq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1C4606A32A
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 19:36:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C1C4606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=LU8nJzdq
Received: from pps.filterd (m0528005.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ACFaatB2661971
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 11:36:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=Q3u7I1yY3nJ
	muq+49fNnSVZ6NxAiKftF5EDGZUfjWaE=; b=LU8nJzdqTuFeXxiCts/Icr9sphO
	9JwQ6qneW0n34BTZV0JOHdPmVmq6v/o8AAukNp0VfJtyC1BxJESUVBZnUPO6bTJz
	heXDvu278xn0fp985Ow2X7KOpGQZ22QPNDE8ZkenXzSOzsL3mE+pV15Ld4NYN0ke
	Z4xYE3FlOFj/3hNCfLYkNWEOgkL+E1fKr1d8mgMFhG4bM25au11LSDbP1ZpUQNkL
	P4j6oE2OX8TxKs7kHuTuK5VSeUo2ZEx/0qtZHGl8RSf7BrtesxK08+eNxS3Ts9nr
	J4HURg6r5rm/vNvQFI8Dm0i35N/VUkWCnNGSvZbKTT+YhzyAn8Y9jOOTXJQ==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hvbxcpxyw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 11:36:10 -0800 (PST)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cdba239d0easo189815a12.3
        for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 11:36:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794512169; cv=none;
        d=google.com; s=arc-20260327;
        b=IOtjEyTd+YBCSFGAmbGR0eLJaaNjxs0C/1tFMcSyVtUIIkXCSD3UcSf0VOgstwaD/n
         xyKaiRCRTLTgIOnjWWh0S3I1I+aEUwCAfeQR4c6cF5Bp4+XVY1OneKyICH5+sP6wHRH3
         hUama62Y615TTdYE4ovwh7ecpAo+r8mQGM51nUFdMjl8Rn0alITEK7AxpYzhiQLSftB+
         UL8d4JEvByiCFaK/dbTdlmL2JOZF4DqQ1BFfynMN1zUhP6KCNlMucFwHh3WNzF/Ex9ev
         iP3TbVXsK/6nDHju3TwdQHqGxdLgXO7Lmf5/yBWATyXR8cW/FG34T+gxlP5f13r0DcJa
         Md9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=Q3u7I1yY3nJmuq+49fNnSVZ6NxAiKftF5EDGZUfjWaE=;
        fh=Nk9Q7nFl3uzmJM7V/lJFUi9IXqZHtP3bmrf0B/Yw3Bk=;
        b=mjj+x1++gaXaPz7N4j7bWC9GpzjtpidYXleQjuS+lx8v9oT9m/uiofgkiKNomkKZ6u
         T0C0fhr2DXp7Vq04//AqMn3ovfpbjdyvcl5tkCXe1LGd1d6mMQNyep5BygtvwvKEGLIQ
         3UdXUrCRjzzSvjdkAcKFnQxOl1hduNA3Mn2gzDfSxB4w4HgMtGaYvvXDJeiT/vVcoUqC
         fwScmO1rijRfSluZnREyWrWEXVE6kNuyJVvi5kUaKswl6NeQElT020iejNKg3P/dLEaC
         ucg1Zh+0Wh31whKK4ejvDsgiYFv/Cp3BdTnhFnQ07jXZnafJFeOTUuDO0ldYvZkwG+Jx
         bSgA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794512169; x=1795116969;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Q3u7I1yY3nJmuq+49fNnSVZ6NxAiKftF5EDGZUfjWaE=;
        b=MOQORVkNKHc0zJU+GfW4OjlLHePtFGR5n3e5TYan2xrlWYuXpVWxOkf9YBoO97KgXi
         s2jqR4m8w+tg1QGySE2n06LtypQpf5UX2eXQNXO1EcqTNv3hedi8pKSE4I53UXgyezb0
         HQpiVxjtEz+Ln2D4xOhmDDLFz0nAyR1bSVjpJyPo11cS2YLR96kkKLhgCFl5dOwGyztk
         6sVApVaI69+kBvpCumnpRMF96P+IHIEMYENpOEjYqgA4SG4pSHCGo1UkKnGh4xSSFKJ4
         aTelrthza3eS0YBZLk5guIfbotaaa/F2yXJzWDTmJuPOCfAaHYrvOXEvyCQugPnlDQ89
         lKkA==
X-Forwarded-Encrypted: i=1; AL+hErH9yhHil0u2Q7fU/s2WDAZhrr03lGaydBBLLbSgifew6pMc8YoFJVxjSelkYCDTNrcpnAh1kL0DK8dL@vger.kernel.org
X-Gm-Message-State: APuU4Z+PzxxLfSYCGol6ZZs6lCR1J273mjA8Cy4LbdVPVUiRWuJwYBmy
	IhTHO3dntKpIOCrts3uWakJpyKN1c/qXHfe1AwCZEKx8tjvCVUcGpBCfcUm9gLI1WTQCElILd9I
	FHvdh4AyK/BscMSb730Fp+gjGHqkTPOb3BIyqCLEKnpHcySe8kM6eIea1hvtYy9LzMTb9s5xnE4
	71Nc4TdZKud9UaJ00TLcDONVfkIcX+gKKqH9rN
X-Gm-Gg: AYBFou38qNNGYXZV/qmuP8rKDKX2vxG2jw3GTcHRB8w8laNm375yFPfPdasxZ9qZa9j
	DggaShgKdO9ZYg9XDRQE4F00NkUmha0y1nEtzxRxVA2LGTBVoQz/Tm96ffLIm2YF93fUHb6R6ni
	jfH4zdvzjC17vS74GXacHyTRmAO52vDkrkbiJ1dbzoit3LMku4m5cQyjVe13ZdthuU9a4z5BotY
	1/m4RGDogcKb8t5c5t4bsfRohyRHjs3
X-Received: by 2002:a05:6a21:798f:b0:3e2:2b76:bf40 with SMTP id adf61e73a8af0-3f7a6e9f331mr163993637.26.1794512169092;
        Thu, 12 Nov 2026 11:36:09 -0800 (PST)
X-Received: by 2002:a05:6a21:798f:b0:3e2:2b76:bf40 with SMTP id
 adf61e73a8af0-3f7a6e9f331mr163970637.26.1794512168673; Thu, 12 Nov 2026
 11:36:08 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111005533.6436-1-toddfreed@meta.com> <DMSJJY9PLHSR.39PSNUXEC82J4@gmail.com>
In-Reply-To: <DMSJJY9PLHSR.39PSNUXEC82J4@gmail.com>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Thu, 12 Nov 2026 11:35:57 -0800
X-Gm-Features: AclHuK-L78K4XX2ZOiQNpBmdIZKiLWCeJjgy0X9ZblQI3qzdXkkSafaXrEWKuy4
Message-ID: <CADh2yMzE1ipKD7N4YBjb0oP1Ko-Z5J6uN4k4_kK=gosHyfsKWQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 00/15] psp: introduce socket-less associations
To: Daniel Zahka <daniel.zahka@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew+netdev@lunn.ch>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Donald Hunter <donald.hunter@gmail.com>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-rdma@vger.kernel.org, Martin KaFai Lau <martin.lau@linux.dev>,
        Paolo Abeni <pabeni@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Simon Horman <horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        Wei Wang <weiwan@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA3OCBTYWx0ZWRfX/aPDV94m6LGX
 VEp9ejCB5YgpKh6p8d+2RRGpZoKoAYZeTUB+/z9UpXedDihJcJY6CngORgLrR8Z1Hqn1uEY7ARG
 2kxMsoJJY1drFNOct6LluxUvRXGy4Zkb0DjtdRALDgpWVRIB6NW8nIQ7RmyNKBi5NrwexBn4Vpc
 teugs9Y2VFNoNUcq5hBwwSKl2sqbsovHZljYWi54l5c7IgPl4KfEyI4JxAc0xFO98vCjCjfNr6v
 hHXiAGmDNK3iUvMBscSMiKPvujddppvR9eY51xzwUn9b53F86Qox8CpbdMjnk/PKU/JzuyMYqqi
 jmsur/dtxyG39p10Gj/TQaR5zBlXKIQxGA3IM1sGXW24iwtNVWeAC3JrTMd68XL/OT6gt+ftqS1
 Est4k3FomB0jmKoVPaeN3kwkh6UZy2WFzass6p1ymO19/jKMvuO/VnkTzp4QfxN0cZQffRomtTR
 VXgi01Z1rXt662gZr+g==
X-Proofpoint-ORIG-GUID: L25J3tgSFVivISbpw1NFCeSDfSMqcdAN
X-Proofpoint-GUID: L25J3tgSFVivISbpw1NFCeSDfSMqcdAN
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA3OCBTYWx0ZWRfX5n94UUEcpLhX
 wkWvrNn8Neh56jfNufDIty0UNwlLkvekRxGqVBMA8MOIaIfQn78uJxs2GfFrXzjgQCWyGPfKKNF
 0XjgtCXrD3BjPs4PbmwuiZNdcBjGmTU=
X-Authority-Analysis: v=2.4 cv=ZdKIpcVA c=1 sm=1 tr=0 ts=6af6152a cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=jCddH8ec0KUNCymVuxII:22
 a=FSGtspZVazLKPRRdjFEA:9 a=QEXdDO2ut3YA:10 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_02,2026-11-11_03,2025-10-01_01

> Some of these can probably stand alone like the bpf decrypted, psp encap
> helper, and timewait validation, and be submitted first to shorten the
> series. That's just a suggestion though. If there are dependencies on
> the main series you can ignore.

Ok, I will re-post 6, 7, and 8 as Fixes to net.

-Todd
