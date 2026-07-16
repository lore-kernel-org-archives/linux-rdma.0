Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F59435674F
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 20:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784232672; cv=fail; b=PcID9ULOUgmmDdj5O+63pooDwmaam1XivRy2kWNHvBpn/xXIZGFl0VU0kf6t8g711KGzk3R4TIVicJmtOycQaeOYNFpPM++L/qsH/LmGSAQL6MPHS4y8rbJl9IeLbmLAoIU5lbg/DtP1MlGwTCmu9YY/sDyQvnip4xmhw2J+5KU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784232672; c=relaxed/simple;
	bh=FmELQBnFhyva8tqlkEZm6vsX9KbwpXPdoDW/5vArsKs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q3gjL49VjPGNNFu1HbrVRg/Fgs+dMaduSTsGisYqm02R2ETau7HrO1kuWkPvF9jz9rEFx1Mw0+J7ryG2+sQymhyjNUVtgWWmVw3ZPWwD51qFBC87v0AjD1JQxrCQ/tV9zJVQqlifzi47UWCGjF4lc2pbm+GkPfrx2B/Sh1IOXoY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=BeR11qvm; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="BeR11qvm"
Received: from pps.filterd (m0528009.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GJqPTE4029929
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 13:11:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=FmELQBnFhyva8tqlkEZm6vsX9KbwpXPdoDW/5vArsKs=; b=BeR11qvmnnNI
	DzI/KcfGXkxY1JZELI8FYHdPO9IXUhqdHYrWC8lX59Hu2MJ0ZHd4AsNG2hgDGQpG
	IHT6XH5Qlfcp5OP6jzCLd5FvYJglbau8ApcPoD8Xz8kK/fSxfdjJ8AN8toSgqmVe
	v5wge45nB//G/3uFGquRWqSQUTJvOt53gIka1wnS/2dOzX9ajVcld2KKhTTJDgb2
	HLYpsvHpWstKTDtQXwYKzP+utDzERk+q65fDYWCP+ttjXMpPWN/GGjFizYxN52+n
	0G14OHlgtzgd5o2++cURe6sCIkND9KFf2CJXFvIJACRpxYjoKeFIkldXMd9VvGym
	8BWJjHisZA==
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4fex4qu5xd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 13:11:10 -0700 (PDT)
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7ec5495f105so2065758a34.3
        for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 13:11:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784232670; cv=none;
        d=google.com; s=arc-20260327;
        b=dDEaV9zu50zu6dplFUMmkbrlyhr1uKiB+EUNQ5Jpc0w/h0iUnBy1k9eK2ewLofMfYZ
         zyf4AYf/4UQn6xU+adip+QDn2ugY/trvkf4ckj0V23hF+oVmi0Lbrx8wduS7pTkCN72R
         mgh9WR+LOKeRi0UdZ8MyVttrkvaWpxKikNBYzj9dKrKLCfoeG9nVLkXCPPZcRfqJ5FRG
         jTJi7s+QZc+/7bweqLGh+yjz1KrXHhKtM9ALOJ4G5KswgHX+/2n7AcWzQrq75wZ/XrbG
         TlMcfSb4dQtQU3x9MNasZ1JYH+VMTojWPQWiMfhSTZfIYlY/Iz5vKFtoKWashUybophi
         e14w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=h9z4CHpNCAe01AgBaapdbFFT33ePTDg6qz9BNy0e+IE=;
        fh=h7ZnkyjpaQDkhsq9zuc29Aot4QutZpG5HaHHNOWiDSs=;
        b=GTYXv+zDZaq937D5Q/bkPqOSpfz7bZuBpo2kmR+tWn7LeeVCprz3u5r8Zx2WJxQISc
         EmxtR7NbfHytCSWJCrhVfuz7Y9/7JJzDeoAFYYN9gz9LwzHRZ3KXimaEUjOB0/g1kPL1
         Iilwd0JFEckW2TZRdJnadkyTmO5+9mQH2a2xIvYIha1xwsC8eR1HkjX+uv28UrXtvJpv
         Lg0M9VSzfrfCs6Ry3VUpAYMPrTqaLT5A8FFRQsToxQhuSBrOWEPePeKATCQPNUpgapP4
         4+3AnL/4yoBzhcvLPKUPhXuV9sgzXDQdrw8pFlK8qFvk3QOLlv/N+K09fM+XlHtpLyD8
         XuYQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784232670; x=1784837470;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h9z4CHpNCAe01AgBaapdbFFT33ePTDg6qz9BNy0e+IE=;
        b=KdwCeHbgMrEobjqpw3cAo9BV0ruJGLDEH35yIP8x0s2LZljYzKLKGpoyNqspLvYsw1
         uxwqyqRnii0ilceBOhDeJABoCzgYpxhQPaYJCuyJ+mtsRMd808YIpRUHuyBQjIaaYMkr
         jpbVLrf6LSixTpRGfHeappqE4lHxIMXXwGkdudTQ4Lbcuy8jTB0F+LJnzyxZ49E/Nggw
         IwAYfvvvg4Wypv48NUFI03W0dqDy46RKftsHV7T14ga7i4sC9eoCDTj53VlaYO2vpc1w
         0dEfF50nyERNZqoYnx6Snmxqkr1kCzHjBmoLD8mcb65a/uPtPo3qKnCe2leT6/C2qT5t
         bvPA==
X-Forwarded-Encrypted: i=1; AHgh+Rp/Pp152IhKgmbOvnr+zE08d/HKDe6GHU7dvAV6BxGyycfn/Tf/MZ6O4VaQwEffM9laDX+5cQX+oAWM@vger.kernel.org
X-Gm-Message-State: AOJu0YxQp6mMVWe1y7h42P9nq+G8htGbqfKnon6X3TQ1d5ShMrkNYEmv
	JZ8/9DZx+ovBAnZlPV8vpIohWPmh4O9F6Y92Zbl2YUC8yZSyS4kaW6AraKqPWK9jNJeDTeRxaWB
	MQp54t83jKHDNNC5dNdyotx2Yohre7r8GZivCLk9EsOR0V0T4lvKcref0VEc6p+/+ZAX+4AYfUo
	3q5RrQwwIBdOKwLaTLoNuRqh6yRmzph7MoHguB
X-Gm-Gg: AfdE7cn3KrVGS6HZNyPLR1Qj4KpSU6OgiMRmTBmzc7PTjpbfAmMbJN/JQfcedrbUglu
	YdKQcg4t8QHPNox9IrDs/Xn2+MhOlfl5trWKMXHCtWARFaWysyp1dQCD8ewnnWvhody+6b6Lxre
	a9CnpnGPkTQt7/ToEH4p8Rg4FdIHYvFmu+WOLJDXPMdH0IlDKT1JaC0Lqg+qRrkySpU4IutUiVW
	eOh6hQS+fjl73S88z4=
X-Received: by 2002:a05:6830:6aaf:b0:7e6:e162:915 with SMTP id 46e09a7af769-7ec97340ddamr801698a34.5.1784232670059;
        Thu, 16 Jul 2026 13:11:10 -0700 (PDT)
X-Received: by 2002:a05:6830:6aaf:b0:7e6:e162:915 with SMTP id
 46e09a7af769-7ec97340ddamr801684a34.5.1784232669654; Thu, 16 Jul 2026
 13:11:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715204008.3911275-1-zhipingz@meta.com> <7dd5c995-a23c-4d3a-9ba0-7fc77972339f@huawei.com>
 <20260716144708.GD210048@ziepe.ca>
In-Reply-To: <20260716144708.GD210048@ziepe.ca>
From: Zhiping Zhang <zhipingz@meta.com>
Date: Thu, 16 Jul 2026 13:10:58 -0700
X-Gm-Features: AUfX_myheEIlUGdSHFK_vqkE1hm0qjp53c8YkJwDa1cVW2p7StXgd-p-wIuQhRA
Message-ID: <CAH3zFs2fLC5GodysR9_QhFMb169DjtsNFnfBeO9MPk9S=DLcfA@mail.gmail.com>
Subject: Re: [PATCH v12 0/4] vfio/dma-buf: add TPH support for peer-to-peer access
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDIwNiBTYWx0ZWRfX9Fz8XWs2nFv6
 bpFjzP7Hs4WoyfJ4kCBKSHucHok2+QUt6yUEnXXtfo5xEldLpqRa4UHyFY551aQ68lOpn5xKwV3
 j3Q4pgkvvx7hpAkJpqnWMj3bO4Tqg5c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDIwNiBTYWx0ZWRfXyCWN3MzU0Lyw
 zttUfFUsZ87Ps/LS+UUhhS02K9Os1wf4/MTCCoSlqeoG0AibqkQEjnfmXHxqRNc2eD6m1LeAl6J
 N/T00aXVXzfYSP3Xj6SmDd+zHCEAmx/LPh/i+7FyAkFH4XhozS346tn4RDE3ZjiNv2pPG/zJh8u
 pNRnBziUbGAJ19Ke0h/T+bLy5op55+0v6ddXjXSCFFgmlUmcpDOoGQcfHcszgJhc0Gw1aY3JOGM
 EDsC1f8B4GupgtE8bKaK2q46WZPwHCUbhBvAxYq8jmiEUtdfAe4ZXVV+inzsiSwin/2T8lYydge
 fT5hhgKyTFO6gNfMA2wwNQ57mPlDyei4jL3RllTejCymQQZLt5r6+q9G/BCwWLw7AISwoEnA1oQ
 ioNfGt0i2FhUUml6tD8cE9SiB+4uEIfl3R2U3+/nJ2jYsz3wVHbbJsld5ervlB8Iu11xJav0Ly/
 w4xx45SDVf8pSLWKogw==
X-Proofpoint-ORIG-GUID: cjgGb-d8Dih2_-QO4T_czBhG1JVJUolW
X-Proofpoint-GUID: cjgGb-d8Dih2_-QO4T_czBhG1JVJUolW
X-Authority-Analysis: v=2.4 cv=Cq6PtH4D c=1 sm=1 tr=0 ts=6a593ade cx=c_pps
 a=OI0sxtj7PyCX9F1bxD/puw==:117 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=U_y8lYiYyhHBU5rMqhb2:22
 a=9jRdOu3wAAAA:8 a=AMAE7NpZmBqY-1WNrTMA:9 a=QEXdDO2ut3YA:10
 a=Z1Yy7GAxqfX1iEi80vsk:22 a=ZE6KLimJVUuLrTuGpvhn:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_07,2026-07-15_02,2025-10-01_01

On Thu, Jul 16, 2026 at 7:47=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.ca> wrot=
e:
>
> >
> On Thu, Jul 16, 2026 at 09:07:35AM +0800, fengchengwen wrote:
> > Because cross-Root-Port P2P traffic with ST does not affect the host, b=
ut
> > merely the completer may experience some performance degradation because
> > it lacks the TPH hint. In this case, I suggest adding restrictions in t=
he
> > uAPI.
>
> I don't think this is complexity is worth doing for something that has
> no functional impact.
>
> There is no difference between supplying the TPH and not supplying it,
> so may as well supply it.
>
> Jason

Agreed, thanks -- that's the intended model. The ST is an advisory
hint; when it can't reach the completer the traffic just behaves as
the non-TPH baseline, so there's nothing to gate in the uAPI.

Thanks,
Zhiping
