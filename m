Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191A039CCF6
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 06:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790231111; cv=fail; b=tbwSP5uYDYa3PX690G/LzyIIC2qXw6iLan7etMpFB2dbTsgT8HYOCafjXqzyu2UMZwX7HPJop+iAYT7Q0yyprfWQWEv5i05gTA+hAivCQaUlGj7/QkUvnWB5cfZnu10RwdMzR8CSQS1gXKYGPFXzH0bryEymNqGrpT69S1L11I0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790231111; c=relaxed/simple;
	bh=dumiTwGbMEgraHXzScODaqcrl57xN/pkOOLYCcmVuK0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CdTJqd63ypd92AUMPqHg8UvjBOi8r0HDoTdvJYfGqSTtEYgOqRV6lG5A2cE2iKlIgoTbfDbVTBmlTip44RhkJ6zadyYi9+9aROGDCb6WP+5uvFkKoM4u0bRAQ2mn8Ohfa/CXdKZgd5nA18870FwY9drKiVDO3q78szrqGPfWWMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=kVpR4J2c; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="kVpR4J2c"
Received: from pps.filterd (m0528007.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5feU14147457
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 23:25:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=dumiTwGbMEgraHXzScODaqcrl57xN/pkOOLYC
	cmVuK0=; b=kVpR4J2cMlHzqIDDgIwDNRJKn8dds0XKZoAj3OuhpAobjcceNl0Bu
	lbg5D+lbA8CbPmTwKFk7+P9ILanDRGAi05aIxnTFuZ43UVMM/4+qDIBkN6C9YRFG
	IHueetZOt54ETnH+qsE4FIKotfPKQDH8rt4NVkm1+3IL6jolTyEOLLwJmpBn0uju
	gZkmJJjhBdcR/w50XWF7pn04IJiaJvS+3p3s6euzs154NtYbjvGfGPrlSbJ7kNRv
	rLyGbzA42lxnnIsp7gJ8tDUTh1gq3l85Sch1Tuo75/IOWkwLClaKgleRjE3hVug1
	TUvXeAqjqctf8mUTc4IxwuMOWegiHDbEw==
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gv04t705m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 23:25:09 -0700 (PDT)
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6c2c5c1f843so839330eaf.1
        for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 23:25:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790231108; cv=none;
        d=google.com; s=arc-20260327;
        b=USdg+mZEtTZkTgmANeFKuiTDu7BHyn4/Bb8W9FWkz6wP4MGZHzkgnQJzfjpU1i6P2j
         Pwyxz5UzY1+wEV6xSTUV5cU2X5h0//imwOhGnERynRIlH7x6bWdm7oC0P81bDzvCaSW5
         5QK+xLa/ghMrk66QWuli/+LG3aSoBxnkQfXzmwxm5GOokwYN+9Yk+ihTg8T0PPsmIJcQ
         UHhf0UJ9dlm76hVxuBjavxr9eYxFbhI0bA5BRTgFr+B4kx2yvQfpsUsXdkJkxGVIgHeN
         7Y+jiSpSWaP7AWfZybocZAOKn9YNDs1L2Ri/FElJDrw21dRaES4yuXvRGrfQS71Sh4pw
         YIKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=RHSnVwj4ta4xwY4ZaPurv5a8QLd5HiVRVFjxaoUelIo=;
        fh=XU9d8CdHIf0OUSqRGfvI16lFNt6pKLNAD9h2id3B7dQ=;
        b=A42PKIjUxmtsHfLptPVyDPJxDjZdKZ2BkG5Q9bc6BVnf8MJ/pGBjILnVf1D1XguD0N
         Xbs7POoXAOZbRQEE55hpl7BUGwQhw1Z5Z9FPbYpN7EhUgRvXgME0YIHqrsSCSOdMrntt
         mh13RMdlEraBgT0+GBontyI3XwVKAkJvti/MgbH4bzuYaoLFczfMuMILmzbT7nou/zQ3
         UhQKJSoq33ffYONbhtftXUpxLO+02I8nITvU+L2yxiMtvPNInfj1msrkQW+dvTPfwF/C
         yKTEhBDCRDaZO2Q4UYOEpW/BlCuFfss2oaQWFr8w1r7T4fHYg0SMwqa0WgBJ2rAr7aRx
         D1sw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790231108; x=1790835908;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RHSnVwj4ta4xwY4ZaPurv5a8QLd5HiVRVFjxaoUelIo=;
        b=gpwR+esvXF/+uzUHllepOcnxKWJ+Dwzx/sR71+4v8TuEc4UBhkfYCnGg+lKcwFJDFx
         bzhgOqR2dXnHsx8mJzy5PTLFNTCcmvfZYcoiIgwQLWCN/DcneJ5eXCHLn6bUI/4MoD5d
         3m6nti9n4avSBugB4xxJuNFpHGaemN4An+fIBl2K6Oy3DZ9RmEsnHUVd7jsp4OA9LF7y
         ShlY1sR0BdwOhxi6WTwIGhz+2jeIP7CXqrmr22JTBnIsqBfb8l5EE33dZzL+coDn4oKY
         n0zq8sUmjZ0z56txj/1zKv04t9lDwXU+AxHV/nwSvk4AukxaVItxUxUn32XU6xzskPSm
         ggeQ==
X-Forwarded-Encrypted: i=1; AKwUvBzeTcJLONZtDl/VSVayIoCkIOe6ShLrGuGRDNlVGJ+bhsehSxlHZvXbAG5ExzHH3f0JOTV8Xs0LGc1z@vger.kernel.org
X-Gm-Message-State: AFuF++mAYGoR3YFhdp8sCywSZW1LmC6G6xPWT+hlBU6PaNX8lJ+EguMi
	frVakezY5sRS9wHapfP3xEb2c29OrnyyxRMGscyfWOtJJCmWl9809OMqKLxdci3BvbB91dw6lKK
	NpH++0jij77DSr8MfNI7Heu1h2CYdgd/iDZOd64luUsNPqVdy1lvqQtNSSiE5tRv1iZIREB4TwZ
	BtbSz+ZZ1gc+tk1h+QeIYGvkOKG8rw6O5UaOzGrCXL8mZ0oDQ=
X-Gm-Gg: AYBFou18DnR/sCFHU9WPdmJhdwCksDPxz3XoJVIvcEnFfZsUDp5eaQMWTdw1HMBWbVW
	sntn67SLbM+0FOrlOwf9SavoEXOgnotarXojYzD/twO6cybLHt2gl6ZgmdK9IFFEIdiUjYSMjkN
	yhuhPTOC97YksSFNh+ejq9nxTWTj9MuHf/6Z2cLeQsGzmpN0bTmWUPy0D0YhXmhhMgYKY6PioLs
	TFAiRAP6R8uJ7SqEds=
X-Received: by 2002:a05:6820:a07:b0:6bd:f79e:5022 with SMTP id 006d021491bc7-6d43f4b92f1mr1105079eaf.23.1790231108122;
        Wed, 23 Sep 2026 23:25:08 -0700 (PDT)
X-Received: by 2002:a05:6820:a07:b0:6bd:f79e:5022 with SMTP id
 006d021491bc7-6d43f4b92f1mr1105058eaf.23.1790231107597; Wed, 23 Sep 2026
 23:25:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260731211601.3033906-1-zhipingz@meta.com> <20260731211601.3033906-6-zhipingz@meta.com>
 <f4ff7ced-63b6-42e6-8e01-9f01d2e59843@huawei.com>
In-Reply-To: <f4ff7ced-63b6-42e6-8e01-9f01d2e59843@huawei.com>
From: Zhiping Zhang <zhipingz@meta.com>
Date: Wed, 23 Sep 2026 23:24:56 -0700
X-Gm-Features: AclHuK8ihUvHi9sCYY6U80mehJKIocBbXx4TYk849EeeC-OYipx5xqfc_idP75U
Message-ID: <CAH3zFs24esHCGA=wPrkiH8oKQCv7SnOwcBbkMxrOEvOVtwstYg@mail.gmail.com>
Subject: Re: [PATCH v13 5/5] RDMA/mlx5: get tph for p2p access when
 registering dma-buf mr
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
X-Authority-Analysis: v=2.4 cv=X//Hu2Te c=1 sm=1 tr=0 ts=6ab4c245 cx=c_pps
 a=V4L7fE8DliODT/OoDI2WOg==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=4h92JMTCafKA-fb_NiOh:22
 a=i0EeH86SAAAA:8 a=L1Z5B5hNzKdfmK81vbcA:9 a=QEXdDO2ut3YA:10
 a=WZGXeFmKUf7gPmL3hEjn:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAyNyBTYWx0ZWRfX/XuLnFHkeas7
 /5Z4eyW8VsSPEMpUxSslxL/Dj2mRX8gfac11l2r5IQWDxTzg1B47YofOwHGYyWZS04ulhchexMG
 MKrKLqMRFRmYtxCCRnY44/GzsLMwaKl5AoRpZ8T+z8gxrDPWO4sVIb03INpi0XG4TZtW425s8vT
 9aHR+2qN9XKpYMDRH5GiJP+c9XO5IZJEmrxC+L06lf1OpSOTYMUg3t9kJBvqxZ5M2mqCdHGtrs9
 y1K46pp1+pvDlrszVdo6LW4eBK1gt9IHDl1g5Fwh/1s06yVsEOp0pkV5pDM8cRK9cTxSpk/hvKu
 koUISavkiJj9hQ2teyTh/j19gwrbhwhUVcTtZSCbHKF4oLS1N/Q61XVO06kdvnZg2jGeVcB8aC9
 +PtT1mEp/qx7Ww/jPbseTq3VsukU6OPhNYuR6V6/sDMUnXZfdNt82ykNnqvHURYPyZlk69jpLxI
 dP8BS14BE6QC7woPo0g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAyNyBTYWx0ZWRfX5qUyhGyJkyQ4
 eJ8nb5sG6vPgv++VuslR7ixqR9zQrmmtLxE9kpynnbyJRZ3R7PTz+jL5gLRchDCAE/0XlnozikW
 hH71/Xexq1W2LxDwQ1rJNUJR1lgudiM=
X-Proofpoint-GUID: m2JXSZOS--vHVd6QCRQUESaMJF2qyd3H
X-Proofpoint-ORIG-GUID: m2JXSZOS--vHVd6QCRQUESaMJF2qyd3H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01

On Wed, Sep 23, 2026 at 6:13=E2=80=AFPM fengchengwen <fengchengwen@huawei.c=
om> wrote:
>
> >
> Hi Zhiping,
>
> On 8/1/2026 5:15 AM, Zhiping Zhang wrote:
> > Peer-to-peer DMA between a mlx5 NIC and a foreign PCIe endpoint
> > (typically a GPU or a vfio-pci passthrough device) traverses the host
> > PCIe fabric. The endpoint exporting the dma-buf knows which PCIe TLP
> > Processing Hint (TPH) Steering Tag yields the best placement for the
> > traffic it will sink: per-endpoint hint selection lets the root complex
> > or switch direct DMA to a specific cache slice / NUMA node, cutting
> > cross-socket snoop traffic and DRAM pressure under sustained p2p
> > workloads.
> >
> > Until now the mlx5 importer had no way to learn the exporter's chosen
> > ST tag, so dma-buf MRs were registered without TPH and ran with the
> > default (no-hint) routing. With dma_buf_get_pci_tph() in place this
> > patch wires up mlx5_ib to query that metadata at MR registration time
> > for p2p access and use it to program requester-side TPH on the outbound
> > mkey. If the exporter has no metadata, fall back to the existing
> > no-TPH path so behavior for non-TPH-aware exporters is unchanged.
>
>
> While working on v21 of the VFIO PCIe TPH series, we got review
> feedback that importers must add pci_p2pdma_distance() validation
> before retrieving ST values from a dma-buf.
>
> Your mlx5 patch follows the same importer pattern =E2=80=93 it consumes
> dma-buf TPH metadata. I think this patch should also include the
> same distance check.
>
> Thanks,
> Chengwen
>

Hi Chengwen,

I don't think this belongs in the importer. Every in-tree dma-buf
caller of pci_p2pdma_distance() is the exporter, in its .attach,
clearing attach->peer2peer -- amdgpu_dma_buf.c, xe_dma_buf.c,
habanalabs memory.c. There is no importer-side caller.

mlx5 also can't be one: pci_p2pdma_distance() takes the exporter's
struct pci_dev, and an importer only has a struct dma_buf. Reaching it
would mean introducing PCI types into the dma-buf core, which is what
Christian's ack on patch 3 rules out.

The routing check is already enforced by the core before any p2p DMA
can happen: vfio_pci_dma_buf_map() goes through
dma_buf_phys_vec_to_sgt(), which switches on
pci_p2pdma_map_type(provider, attach->dev) and fails -EINVAL on
PCI_P2PDMA_MAP_NOT_SUPPORTED -- the same calc_map_type_and_dist()
computation pci_p2pdma_distance() performs. An ST that mlx5 programmed
into the mkey cannot reach the wire unless that mapping has succeeded.

Thanks,
Zhiping
