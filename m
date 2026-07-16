Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6962E3375D5
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 20:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784232554; cv=fail; b=PHI6asXJNHxgAaOI0a3K+LTde/nakXy+wVt7M0cIAasaO/HpXhrAs+VY0Gm57wiSXPDOIJhbJdiIzgjl2OzsEeUnPGIb1ZfbcMQWSxIm34PXRWjo0ONJScTo/l3D4EkUUvAkwxxqZXB7pcrmQ6giw+WUKStqovZJff4GF9qP0nU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784232554; c=relaxed/simple;
	bh=fyZCLJIQW6xH8mOeeNx9UNPdCdkhruJNt4u6M+kl3Po=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UKyKzYBZArmYXKDfkax4Q3tb9HiYctSbM3rn+DBWJuBRebk1cMWu84t2c/uPxqusmhnVCoF6GKd3sPlLvDYsDq9ibFy2CFy2QL+cd9g5s4Mx/GziFi1NTBrG2oFyANwqznsxkqOl1HcK03EK6U4kcx9aMyLZ8dMpkLIxM5sNDgY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=G0tBoJWd; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="G0tBoJWd"
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GJpREl4034150
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 13:09:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=fyZCLJIQW6xH8mOeeNx9UNPdCdkhruJNt4u6M+kl3Po=; b=G0tBoJWdvaDk
	Wz4me9U9EmzdxbVYlbLVAfjJCP27d6V5CRGhDCsQxHd1wC51VEIW5NDlLtPdhtid
	Y3QFaqMgURyUh0GfmaRtX7cvFRuYL/eUy7XWGSK3W1UnNuGcmMhoDVxFZhjVwFdj
	Y0SJW4IzIYBm2nOniFrlhPh4CgIXlUL6NYUYlHM5wq/J4bRwQDAxtQyQEQjDAlw2
	I9nTh3mwe1qX+xfUsDbEtUHrMMFEyBk5OmI7ZaemvGPdpXU1zn1/SUSGNVDz9JhF
	gyGozHXiVdrg4wtKnjIXepWNvHOqU/PxZvm4VTQ9a9r/fvoy4pXcJNqU6imFJJms
	GDfW2AvWUg==
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4ff4surgqe-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 13:09:11 -0700 (PDT)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7ec629d48b4so584800a34.0
        for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 13:09:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784232550; cv=none;
        d=google.com; s=arc-20260327;
        b=o2A22D/gn8T+FYTXUhWKD+sOakqQi01cmcB6ua3wgwcVyQcfj2Jg8c2V2kvoxJfNNo
         5S1Ku+QZWOhCi2KfCAsMsbCHxj5iW0iUgFXA9MZwozmTF1uTdmmJeg/eEfkrP+Iv73m2
         p20aKL7MQwd8uD3GNlrh/OZEgI4uYenwbacWvIKVloH4vUa6RJvlnKJSXawTLBEG2ZoU
         pLODuEQhjD4Tmr+mzC2JyRiBVQJZxjRPehbQbsqM2Uw4FNyS614KbcHPlihyzEPowj4/
         b/+VskxYfmRKzbl2pnhHT1SwwDVZk1hsNjKarCktmJBLC1Fzz6N8iyTH1LakCIvJodJE
         Jv+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=A/MBU9UxYJ0LTf7N8/pjvYID5QVas5vE3ImYU9370R0=;
        fh=95iWFEhlJc9nbhfnDtRK3CRxXDJNfvVAE9lnC2oiikQ=;
        b=N/sgbkbSy6I2xE2EJSy2Xw88ETtdccosJppPByOwIJCYHL2kpipu3u5zBt0hBiF9F9
         86ao4uEran5LW43Z1cmZ50XWphrVKWfYxhyHuX3/mG69yDdvltVeemVTyLwRHN7C6ZK2
         eaWu/fNDW7+qiCG5BV8TZX3pNXJAQ9LNrKzyQ+pvA55CA5iIAGrrgTqfKEZSUkPXuzrC
         qNMZAkXo2C9HoccRJcCqYE/T4+1OEEhfB13ZLA35TrZbVqcvj7zRyNow2TNgVcIXkE+t
         pL6K7/ty/YvDgs1qJnwTzxWYvJQsOkVPSAOZLD16TIVLjSkqam6MWxOC1zUp0ORLr3pG
         yzWQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784232550; x=1784837350;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A/MBU9UxYJ0LTf7N8/pjvYID5QVas5vE3ImYU9370R0=;
        b=CgwkQHICLixK7xZv+QMTQJlbljXE/jl7Lsp/ehQXE+sIZuqb9+z8st/wTAsTVP4Wcy
         dQIVOGQeh4IUVpqvPqALXubsntQoRDS5hoQ87RGs0h6WNec046lfCnok/kkxEcymYnfQ
         fi7Yla9b/rxP1eregZ52BHkHaWNyggt5FJeXefiMhmWYTiT1jQ+kRM8wbkIH91FUOG3p
         0YgDw4Jw4Bckco1LqlnNiokWb2EgV4OwjLLSLF8tZaF4yjhF56j6z4ZiWgT2jBdebVvQ
         7tV91DlUTeBB92SOEDIf9FQ5yuXtozo8RJ6qDenRcVoKHlSwt+UrTNCko8XFmlA9ikXp
         0FTw==
X-Forwarded-Encrypted: i=1; AHgh+Rq9wM8P72KMPsW5GFN740KSZ+FzRKbQIeV6Hwsp0DpLPHZMTzQyqs1fD4geUttXbmROiOeRdTTE4Uc7@vger.kernel.org
X-Gm-Message-State: AOJu0YwcBxptA4zkr2IjgSWd8B5GSVOKuQmZyJw84YgJ0Z0HANC3MQbb
	1gRDWu4ehJ2wJEvradzsnry5sXIZYzSsUXFKnJ/oThLaNmKxFf/xrAkNmi3yfaRobcm0srQF/n0
	yP5Kj8AaRxzGxKxQzqwtaLHxFw+7Sxabltt1QGFlbbRnrUUefXK60Iy5qZBZXas7ySG7f5GTeSf
	w+YBivT1w8WtG7HEEH1GY6MwRS/p1zbrmT0T1N
X-Gm-Gg: AfdE7cnlT+VrS2WgtdA6uOJbQwi9E1ojmkbmz9VY0zGbyRqXCb1YQGZqUXhInoGMYsX
	ck9cgGb+xSgy7hrvKwZ+wfwiVQIRzENlATNSY+7CdRAldGO//AfPsI/wp0PQyj4nywa0zKM5kWn
	883hNiILZkIpF+zfGvjuH3aiBCmz7N5nW64xi6wiyWKbgdEWXT4nmjHb+fTIB4QLP9R/jB6VbWF
	PaHuOCQCIZZa1LHPlU=
X-Received: by 2002:a05:6830:6aeb:b0:7e9:cc39:2ef0 with SMTP id 46e09a7af769-7ec59cc5592mr5232596a34.18.1784232550378;
        Thu, 16 Jul 2026 13:09:10 -0700 (PDT)
X-Received: by 2002:a05:6830:6aeb:b0:7e9:cc39:2ef0 with SMTP id
 46e09a7af769-7ec59cc5592mr5232532a34.18.1784232549056; Thu, 16 Jul 2026
 13:09:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715204008.3911275-1-zhipingz@meta.com> <7dd5c995-a23c-4d3a-9ba0-7fc77972339f@huawei.com>
In-Reply-To: <7dd5c995-a23c-4d3a-9ba0-7fc77972339f@huawei.com>
From: Zhiping Zhang <zhipingz@meta.com>
Date: Thu, 16 Jul 2026 13:08:58 -0700
X-Gm-Features: AUfX_mzMEcC_t0EX7NJOVZpINMLBmfJ4Fcr0yjX2dQzL33Xd9YvVjPxD4eAksO8
Message-ID: <CAH3zFs0Wbz5EYUMQArmUtT-jdAtisafw6e89RWKZJrJpipYQoA@mail.gmail.com>
Subject: Re: [PATCH v12 0/4] vfio/dma-buf: add TPH support for peer-to-peer access
To: fengchengwen <fengchengwen@huawei.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian Konig <christian.koenig@amd.com>,
        Alex Williamson <alex@shazbot.org>,
        Bjorn Helgaas <bhelgaas@google.com>, kvm@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: Xcw2cU379YwXmAv9Up8F7wMlSRPrgGmV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDIwNiBTYWx0ZWRfX9TqS0oqDGd+R
 Jfu3ng8r0nBXdUQRn9kq/fwK7QCO9ZA6JQx02Zc+AIxB7/5cViH1AmWBy7FihoImUibSrz5eQVE
 +VojwLkFdMpur0Flj2WuFY/EcNbOtdKaPj24kzz5vhCg4lpuPyw88aRkkzIhASb58isQ3+Dal8o
 9BY0UkpA+dMTKDx9CqPtZQr9qZf0UpxGz9Ui/jU0oNd+VdT6NHlGssR3TTy6ALacWe/if0Uo7Vc
 ieYP9KuqshHoH+zFrTX6Rz7mupENF4CUVTh47m8VLg3V5hBnAplNGr4i+qJ8QCPjlvAvF5Em1xj
 +VqTnP7nKIIj8ajaA1BNUJExSFb564mnRm5assYbHdXYfP6kGEXkOxrSVyAWXOBMxZGXUHTJnrq
 lo1lM5qeNeVztg7B/ISoMfGoT51Ijk+TWgg7hJfw0TafvPDboy6FLFqX8DeYJcR3o6QjWwqHz31
 cSmIPR4tOpHBqbkzfjA==
X-Authority-Analysis: v=2.4 cv=EqviaycA c=1 sm=1 tr=0 ts=6a593a67 cx=c_pps
 a=+3WqYijBVYhDct2f5Fivkw==:117 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=GbPsI2Ihf5RTnMjR_gZv:22
 a=i0EeH86SAAAA:8 a=G4JgLt0UOHroHTRVxaYA:9 a=QEXdDO2ut3YA:10
 a=eYe2g0i6gJ5uXG_o6N4q:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDIwNiBTYWx0ZWRfXyfzjaCnLPY5s
 FfgIhw9MLMDsf+KVtK+mhunmACrGPFEc/wDyqkjWSFxLmnjQqftVqz7PPW3LaCje4uYqLyedXup
 ekDNgGK0tnnLVQkFQ3MO3LNEyXrJE/8=
X-Proofpoint-GUID: Xcw2cU379YwXmAv9Up8F7wMlSRPrgGmV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_07,2026-07-15_02,2025-10-01_01

On Wed, Jul 15, 2026 at 6:07=E2=80=AFPM fengchengwen <fengchengwen@huawei.c=
om> wrote:
>
> >
> Hi Zhiping,
>
> One concern I'd like to raise is the implicit topology constraint of the
> TPH P2P path. TPH Steering Tag only works reliably when both importer and
> exporter devices sit under the same Root Port (or same TPH-aware switch).
>
> For cross-Root-Port P2P traffic (e.g. P2P devices located in different
> RC or even socket), most server-grade Root Complexes do not forward TPH
> prefixes through their internal routing. The ST field gets silently
> stripped before reaching the target device, so all TPH setup becomes
> ineffective with no error reported to user.
>
> Because cross-Root-Port P2P traffic with ST does not affect the host, but
> merely the completer may experience some performance degradation because
> it lacks the TPH hint. In this case, I suggest adding restrictions in the
> uAPI.
>
> A further step is to check whether the importer and exporter are under
> the same root port. However, this verification will cause the P2P TPH
> to be unsupported in the case of multi-host or multi-root PCIe switch.
>
> Thanks

Hi Fengcheng,

Agreed the RC may not preserve TPH across Root Ports (PCIe Base Spec
r6.4 =C2=A76.17.4 requires all intermediate routing elements to support
TPH, and cross-RP forwarding is optional/implementation-dependent, cf.
=C2=A72.2.10.4.2). But the uAPI can't gate it: there's no discoverable "TPH
routing" capability -- DevCap2[13:12] (r6.4 =C2=A77.5.3.15) describes the
completer, not P2P forwarding -- and a same-Root-Port check would
wrongly reject switch and multi-root topologies where ST does forward.

And it's harmless anyway: per r6.4 =C2=A72.2.7.1 an element without TPH
support ignores the TH bit and completes as if unhinted, so a stripped
ST just degrades to the non-TPH baseline.

Thanks,
Zhiping
