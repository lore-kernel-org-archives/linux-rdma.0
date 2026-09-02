Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113AD3AFCE6
	for <linux-rdma@vger.kernel.org>; Wed,  2 Sep 2026 20:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788382446; cv=pass; b=S2jzFJ3kr/h9WjMkQ3eUtWginGgB0qNGwChwGDZCMUS9gSKHQtx9pTOCl5NqIXYbs8W24w9eTR4GPwL+8MxgF7xaDTD7uV8I+DvoYAF0d2HMk0lOkGLKtIpubu9mw/GeSL5yKF84qf2UEqH6A79k88UhrjPann+Pb8A6u/236p0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788382446; c=relaxed/simple;
	bh=UyfVQsMxJuVHDr9tnaZqx4XeRllFUZGvJm2XPpQicuY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TvqEWlVUPoSzrMfmO0YQIZ82z8N5fN+a0FeFj1meaHDo4BvJ3ZRXMKCx3xQkNucK7AiZ4uQk84ZkM81w/dLoLGIU3X904VB8ox8z9wyP+cON41qncIYRU18Ew42pFUQnLUmuwikwLERr4OOpZwlvWYA8tYY7NBSdwKOXClDRG1Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=E1BnX78Q; arc=pass smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="E1BnX78Q"
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682KIdmm2333212
	for <linux-rdma@vger.kernel.org>; Wed, 2 Sep 2026 13:54:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=slP6R/eaA5o7SI2c2fvL5HowCLSeF5yWKjN3z
	D5fFhc=; b=E1BnX78QMPOajuTpKiFcgnyOA637N6mEbVYBap7iq3JFNa20fU1yk
	7cYBnwisH6q1ygtZ2lRFyza9f5+R3zeypp0Z6N//luTubwhqvthDfKEtHBDG91p2
	KIv6N+01vZyHWwGg2HhXwQ3EkUlbDcLvtsVioORnzBblxazv+DqDq9thZ1somu0i
	H6FCuK7vJCntpe7f568BAufpH0KR9XgsPL/Iixe/1SRJAD9fChVpFj/Ew5goBYER
	XbfDIJnH+lGkvHzzT74WvPSAXKEuOeP/4MfqT2aVrkOUu2fus6j2nCYcy5xk+LFo
	j49p983gU7k9YS3S61lgqyC0tONksP2og==
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gdxqp3p6f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Wed, 02 Sep 2026 13:53:59 -0700 (PDT)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7f4fa572ba2so864066a34.3
        for <linux-rdma@vger.kernel.org>; Wed, 02 Sep 2026 13:53:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788382439; cv=none;
        d=google.com; s=arc-20260327;
        b=TAvtRKlckAeSmPoGhfviNCIUlB0g41cNc2e8jQmiy0T7r3wGLeLnuR4tcp4og7Gp5O
         hD9HMTHIVMAcu/kMyFUzTpKRU5wIkiMPnyiMyYMfRfLC4EoHJQix8ONnSW2ZH9cRrHG2
         4HEBAsjJYdkiLxn6fSEWzcJW6+GTsQlG+qiOPlfp72wGzPx8h8QMAjD5FNmotqdhSe7X
         hzUJl7FFx6BPlzp31yx4tJDKTTZEtX37OMoKIQ9OZR40erD132F7ooTfAKxNGdBjUn1z
         TGRJGVI2XWK872BHJWv7J9FNyjh34U9BmvH3MlBbKN5H8Y9Frq7oJEV3omymCJUYvXPN
         rC5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=slP6R/eaA5o7SI2c2fvL5HowCLSeF5yWKjN3zD5fFhc=;
        fh=7f6gTvExMk5iw2cLza9Zag48FnVF7XqB+cdPEVPv6Vg=;
        b=CbbNkc3Q5497hcoWBXWZqcqhL0g+C+r9/cb3LgtvBR3yHjBENSSQD1NExIzbl5BSYs
         t487UNfTSEOu/mMpYyTp895ho9SKJGG0aBsJfv4PdOncRTIET/AcZGZlfGoGwEjAuepm
         RRAod1irlG+NvrWa+bSDJi9FQLAXkqyiXvNWkNPLvWh7pLjf1X6HXYwl2Qv17VhVo7Mw
         0lVLLW4Q8Q16SZncNAczwcw/6nvduD7YV/APra+k7KWN1y/hBu049dp4NpPKiap5YVs2
         LMQaGreebVfRMipgTHXWvbfezy4VJWx62PM92y8jfLEuLwLTwBjNhidv6NknVmglyla9
         FxoA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788382439; x=1788987239;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=slP6R/eaA5o7SI2c2fvL5HowCLSeF5yWKjN3zD5fFhc=;
        b=E/y7NDEKIbeD/cy87HXkZUsRy6B03Wu8EreAGY5hwJAQDVh2Cb67UXZCfGRbhSSub8
         sjJSQhtcWrey4BCzRfHN0AlKeOOCrEYDgLrnE3VJzLwJ0+V+aiXbUAMcvRmsBSKkVa8K
         aUeBfSTs6aILUMwwstnsAy0YioWr0Mvx5UHh6CFCobPOEYLXCrBhzaxULiGMsvvTDNUD
         A+a080s8i+nYQo8LiABe36sFJerOCC0Je2jIMCLliXbe90Ro9cBDArrMK+81UN5YJivV
         5l9iL4YtfzyvE1Imz0HQVKH9ZA5ET9pQClfpFJSYaZNKqSXP1b/M+jUYAdjchkqq0/K1
         HkRg==
X-Forwarded-Encrypted: i=1; AHgh+Rp85QiXN4cZPvcUQjeHubOVhyVvgKbyjXGdlvTa37xzFZIS/K7ZqpQqdn1N201bk45kVa8fhOoucY0D@vger.kernel.org
X-Gm-Message-State: AFuF++nviLjjUDSCybaAITDa1ebj8gDepOQSQQ/SSLLC123bPHEZcthp
	7c/cEU+vZmOL+OP47sB9STdfqVxo0a0QDCBzHIwGjqsyNhQQz5vKFJjFjLL1vPD7bm0W/h1Rj09
	eBk7K4+hQAzkh3wnP7ILY/NnJRBQLR1xLF4st8gSQbXh5Uyani99sKCAOT1WMeYqwZ5SLFWr7xe
	SA7kqugNxCICJUwm8Qyx4ZF4Ye6Vgbm3sfSBTN
X-Gm-Gg: AR+sD13mMd7K1RR5IVzl5q9eX7s7U/b645qqfrVluJKKXmRtPwljtgJuWWIC+HRKSjq
	HEOaegW7UDppGGVamaOcAFfEXDekhoptZBonpeVZ92Wljh4+X2+A+1HaTnKs5YENTlyXzhbacEP
	dVc1O/sqX9an0S0hLPfLDE74C+jQ0safay6kB4/xF7griNDcr4u9vNOdaPdY4z9LthrOOW836q
X-Received: by 2002:a05:6830:2318:b0:7dc:e336:c828 with SMTP id 46e09a7af769-7f78118c5bfmr7645628a34.10.1788382438956;
        Wed, 02 Sep 2026 13:53:58 -0700 (PDT)
X-Received: by 2002:a05:6830:2318:b0:7dc:e336:c828 with SMTP id
 46e09a7af769-7f78118c5bfmr7645573a34.10.1788382438385; Wed, 02 Sep 2026
 13:53:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260731211601.3033906-1-zhipingz@meta.com> <CAH3zFs0vQidHOWif_LmS0=65S9iiCo7yGibqLvFT5jadjj8wVA@mail.gmail.com>
In-Reply-To: <CAH3zFs0vQidHOWif_LmS0=65S9iiCo7yGibqLvFT5jadjj8wVA@mail.gmail.com>
From: Zhiping Zhang <zhipingz@meta.com>
Date: Wed, 2 Sep 2026 13:53:47 -0700
X-Gm-Features: AcwNN1XXj8kbotAle5RRTxM4j9lLg4IWUd1UaMxGDPIdO-M5-6hRyJEApT1F7Gg
Message-ID: <CAH3zFs2XnH6gT0fO4=WLi4x1SL2+Y0S=Jo45SWkR=unPegQ8Hw@mail.gmail.com>
Subject: Re: [PATCH v13 0/5] vfio/dma-buf: add TPH support for peer-to-peer access
To: Christian Konig <christian.koenig@amd.com>
Cc: kvm@vger.kernel.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Bjorn Helgaas <bhelgaas@google.com>,
        Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=U6yiy+ru c=1 sm=1 tr=0 ts=6a988ce8 cx=c_pps
 a=7uPEO8VhqeOX8vTJ3z8K6Q==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=tpM8CJlwf7uhpglF1g9U:22
 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8 a=Tz3jYIXQlW6mLFCxu40A:9 a=QEXdDO2ut3YA:10
 a=EXS-LbY8YePsIyqnH6vw:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: zS9rQelswP34uEdyKOEEBoMYoTgUY5Md
X-Proofpoint-ORIG-GUID: zS9rQelswP34uEdyKOEEBoMYoTgUY5Md
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE4NCBTYWx0ZWRfXyjWCY3hAnNTN
 Hbwzs2beSWTSGPdwFpxXISxPLgGwCgY4zbWWXvOdWLh6VzjSI62Qe77DxLUR+OT2mLx9tTrx23l
 VZeaSqu443vfPJJq7tjHFuuv74jr+OlLFlZBZMDAqcxTzN/Ag9mroWOmlPej9kVF3L/hQ3O/NwH
 QmgYarFrNIKMmGexxSVCx4eH6cwpmMNKFtYGYaDyGwBmW8dXEY1xgjq9rdw+qAjtCBrZdNQq42s
 MMuEq2xxUl+V53oKGpZyz0FAOQ77d4SUJolsRA7nY9Ef6Je/TdrkiKvdyXD6fznHA3fZsdd+uFj
 azqPGT21bwE121EQt//DPk3R3JN6Gw4OnHwqtTc8OBE0hfjTWnP+iYqah4ikk0zz1n6ZwDOjFL3
 OSAhRz33Ge//YbZOSKhuKn1eeH8lnLsbsImeG6zflaDydxSGsrRIc6Gli0//rmG1c0g8SN9S4Db
 PVOemQP53phc91y1xRA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE4NCBTYWx0ZWRfX6GYs0Rx2PWGj
 whfgNu6MooFJsiyg3oVIjazK8ahY+TxEJKTtyH2CU22VxAE1yEBbqqGr1LYiQEEkCPtOfWgI1LE
 9PIxfMuysPzidBBaWTkOs4ibQDM8I60=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-02_05,2026-09-02_04,2025-10-01_01

Hi Christian,

Another ping on this series for your attention. Pls see below for more deta=
ils.

Thanks,
Zhiping

On Fri, Aug 14, 2026 at 11:08=E2=80=AFAM Zhiping Zhang <zhipingz@meta.com> =
wrote:
>
>  Hi Christian,
>
> A gentle ping on this series, especially patch 3, which adds the
> optional dma-buf get_pci_tph() callback. Could you please review this
> when you have a chance?
>
> https://lore.kernel.org/linux-pci/20260731211601.3033906-4-zhipingz@meta.=
com/
>
> Thanks,
> Zhiping
>
>
> On Fri, Jul 31, 2026 at 2:22=E2=80=AFPM Zhiping Zhang <zhipingz@meta.com>=
 wrote:
> >
> > This series adds TLP Processing Hints (TPH) support to the VFIO dma-buf
> > export path, allowing importing drivers (e.g. mlx5) to use the
> > exporter's steering tag when performing peer-to-peer DMA into a
> > VFIO-owned device.
> >
> > There is no separate in-tree vendor kernel driver for the target device=
:
> > vfio-pci is the in-tree driver and the targeted device is managed
> > from userspace via VFIO passthrough. That is why the ST has to flow
> > through a uAPI: userspace owns the device and its ST table, so it is th=
e
> > entity that can configure a meaningful value for a given dma-buf. The
> > kernel-visible participants are still in-tree: vfio-pci exports the
> > dma-buf and mlx5 imports it.
> >
> > On the effect: the endpoint's PCIe ingress block uses the ST as
> > an in-band instruction for the incoming P2P TLP -- selecting a target
> > cache partition and, on writes, an in-flight operation on the data
> > before it lands. The dma-buf callback keeps this opaque to the
> > framework -- only the producer (userspace owner of the VFIO device)
> > and the consumer (endpoint block) need to interpret the value. The
> > dma-buf get_pci_tph callback itself is optional, but workloads that
> > depend on the endpoint's in-flight operation need it because fallback
> > does not produce the same result.
> >
> > The dma-buf hook is intentionally generic and discoverable rather than
> > a private side channel. The exporter owns the completing address
> > space for the dma-buf and decides whether it can provide a meaningful
> > ST/PH tuple for that completer; the dma-buf core keeps the tuple opaque=
,
> > and importers merely request the namespace they support and place the
> > returned value on generated TLPs. Exporters that cannot derive a
> > meaningful tuple simply return -EOPNOTSUPP.
> >
> > TPH is advisory: a steering tag that is not honored on the path (for
> > example an intermediate routing element that does not forward the TPH
> > prefix) is ignored and the request completes as an ordinary,
> > non-TPH transaction (PCIe Base 6.4 sec 2.2.7.1). This series therefore
> > targets the same-Root-Port / common-switch topology, where the ST
> > reaches the completer; cross-Root-Port P2P is best-effort and is not
> > gated in the uAPI, since supplying an unused ST is harmless and there
> > is no discoverable "TPH routing" capability to test against.
> >
> > Patch 1 folds the reserved 0b10 "TPH Completer Supported" encoding into
> > "not supported" in get_rp_completer_type(), so only architected values
> > can reach the TPH Requester Enable field. It was previously posted
> > standalone to linux-pci; per Alex Williamson's v12 review it now travel=
s
> > with the series, which removes the cross-tree ordering dependency and
> > lets review tooling apply the series as posted.
> > Patch 2 adds small PCI/TPH type helpers so drivers can query the enable=
d
> > TPH requester mode and the device's TPH Completer Supported field
> > without reaching into pci_dev internals (and so callers in
> > CONFIG_PCIE_TPH=3Dn builds get a clean fallback). pcie_tph_completer_ty=
pe()
> > applies the same reserved-encoding fold as get_rp_completer_type(),
> > inlined locally so the helper is self-contained.
> > Patch 3 adds the optional dma_buf_ops::get_pci_tph callback plus the
> > dma_buf_get_pci_tph() importer wrapper so importers can fetch TPH
> > metadata from an exporter under dmabuf->resv.
> > Patch 4 implements get_pci_tph in vfio-pci and adds the new uAPI
> > (VFIO_DEVICE_FEATURE_DMA_BUF_TPH) for userspace to attach the metadata.
> > Patch 5 wires up the mlx5 RDMA driver as a consumer. It also enforces t=
he
> > dma_buf_get_pci_tph() steering-tag lifetime: the tag is only valid for =
the
> > mapping it was queried against, and the mkey's TPH fields cannot be
> > reprogrammed in place. mlx5 therefore records the registration-time tup=
le
> > and re-queries after each dma-buf mapping is established under
> > dmabuf->resv; unchanged tuples continue with the existing mkey, while
> > changed or missing tuples fail the remap rather than continue with a
> > stale hint. For vfio-pci BAR dma-bufs this is expected to be a no-op
> > because invalidation is revoke/quiesce, not movement to a new backing
> > placement, and the userspace-provided tuple is not changed by the
> > revoke/un-revoke path.
> >
> > Build-tested with both CONFIG_PCIE_TPH=3Dy and CONFIG_PCIE_TPH=3Dn.
> > Functional validation on the target topology: PCIe analyzer captures
> > on the P2P TLPs confirm the ST emitted by mlx5 matches the value
> > configured through VFIO_DEVICE_FEATURE_DMA_BUF_TPH, and the end-to-end
> > P2P workload only produces results consistent with the endpoint's
> > ST-selected in-flight operation. For example, with userspace
> > configuring 8-bit ST=3D0xf0 and PH=3D2, an analyzer capture of a peer-t=
o-
> > peer MWr64 shows "STP MWr64 TC=3D0 OHC=3D2 ..." followed by "OHC-B
> > ST=3DF0h PH=3D2 HV=3D1":
> > (TLP Captures)
> > 08000260 -> STP MWr64 TC=3D0 OHC=3D2 TS=3D0 Attr=3D0 L=3D8
> > F0000004 -> RID=3D4h:0h.0h EP- Tag=3DF0h
> > E0200000 -> AddrH=3D000020E0h
> > 00080006 -> AddrL=3D06000800h
> > 90F00000 -> OHC-B ST=3DF0h PH=3D2 HV=3D1 AMA=3D0 AV-
> >
> > The dma-buf get_pci_tph interface has also been exercised by a second,
> > independent importer: a different vendor's NIC whose driver is not yet
> > upstream, locally taught to call dma_buf_get_pci_tph(). A PCIe analyzer
> > confirmed the ST it placed on outbound P2P TLPs matches the value
> > configured through VFIO_DEVICE_FEATURE_DMA_BUF_TPH, the same result as
> > with mlx5. Two unrelated importer drivers exercising the callback
> > end-to-end shows the interface is not tied to a single consumer. That
> > importer change is out-of-tree and not part of this series. For that
> > second importer, with userspace configuring 8-bit ST=3D0xe0 and PH=3D0,
> > an analyzer capture shows:
> > (TLP Captures)
> > 08200260 -> STP MWr64 TC=3D0 OHC=3D2 TS=3D1 Attr=3D0 L=3D8
> > 4E00004C -> RID=3D4Ch:0h.0h EP- Tag=3D4Eh
> > 00170000 -> AddrH=3D00001700h
> > 00200006 -> AddrL=3D06002000h
> > 10E00000 -> OHC-B ST=3DE0h PH=3D0 HV=3D1 AMA=3D0 AV-
> >
> > Changes since v12:
> >   Patch 1 (PCI/TPH, new to the series): the reserved-encoding fold,
> >   previously posted standalone to linux-pci [1], is now the first patch
> >   here (Alex Williamson). Sashiko could not apply v12 because of that
> >   external dependency; with the fold in-series and the mlx5 leak fix in
> >   linux-next, v13 has none. The code is unchanged from the standalone
> >   v3; the Fixes: tag is dropped, since no code path can reach the
> >   reserved encoding today and the patch is hardening rather than a fix
> >   for observed silicon.
> >
> >   Patch 2 (PCI/TPH): inline the reserved-encoding fold in
> >   pcie_tph_completer_type() rather than calling the helper that earlier
> >   folding revisions added; that helper was dropped in folding v3 per
> >   Bjorn Helgaas and Wei Huang.
> >
> >   Patch 3 (dma-buf): no functional change.
> >
> >   Patch 4 (vfio/pci): also gate the DMA_BUF_TPH feature on
> >   vdev->pci_ops->get_dmabuf_phys, matching
> >   vfio_pci_core_feature_dma_buf(). Without it PROBE reported the featur=
e
> >   as supported on a device that advertises TPH Completer support but
> >   cannot export a vfio dma-buf at all, so nothing could ever carry the
> >   metadata (Alex Williamson, who raised this to uAPI-affecting
> >   severity).
> >
> >   Patch 5 (mlx5): keep the !dev->st early-out in mlx5_st_alloc_index()
> >   ahead of the pcie_tph_get_cpu_st() call, so splitting out
> >   mlx5_st_alloc_index_by_tag() neither adds an ACPI _DSM invocation on
> >   devices without ST support nor changes the errno userspace sees when
> >   the _DSM lookup fails (Alex Williamson). The commit message now
> >   describes this rather than presenting the split as a pure extraction.
> >
> > Previous link:
> > v12: https://lore.kernel.org/linux-pci/20260715204008.3911275-1-zhiping=
z@meta.com/
> > v11: https://lore.kernel.org/linux-pci/20260702181025.2694961-1-zhiping=
z@meta.com/
> > v10: https://lore.kernel.org/linux-pci/20260630224328.3218796-1-zhiping=
z@meta.com/
> > v9: https://lore.kernel.org/dri-devel/20260622184211.2229399-1-zhipingz=
@meta.com/
> > v8: https://lore.kernel.org/dri-devel/20260615065912.2177918-1-zhipingz=
@meta.com/
> > v7: https://lore.kernel.org/dri-devel/20260611161546.4075580-1-zhipingz=
@meta.com/
> > v6: https://lore.kernel.org/dri-devel/20260608185646.4085127-1-zhipingz=
@meta.com/
> > v5: https://lore.kernel.org/dri-devel/20260526144401.1485788-1-zhipingz=
@meta.com/
> > v4: https://lore.kernel.org/linux-pci/20260519201401.1558410-1-zhipingz=
@meta.com/
> > v3: https://lore.kernel.org/linux-pci/20260512184755.4137227-1-zhipingz=
@meta.com/
> > v2: https://lore.kernel.org/linux-pci/20260430200704.352228-1-zhipingz@=
meta.com/
> >
> > Zhiping Zhang (5):
> >   PCI/TPH: treat reserved 0b10 completer encoding as unsupported
> >   PCI/TPH: Add requester/completer type helpers
> >   dma-buf: add optional get_pci_tph() callback
> >   vfio/pci: implement get_pci_tph and DMA_BUF_TPH feature
> >   RDMA/mlx5: get tph for p2p access when registering dma-buf mr
> >
> >  drivers/dma-buf/dma-buf.c                     |  32 ++++
> >  drivers/infiniband/hw/mlx5/main.c             |   1 +
> >  drivers/infiniband/hw/mlx5/mlx5_ib.h          |  11 ++
> >  drivers/infiniband/hw/mlx5/mr.c               | 151 +++++++++++++++++-
> >  drivers/infiniband/hw/mlx5/odp.c              |   7 +
> >  .../net/ethernet/mellanox/mlx5/core/lib/st.c  |  52 +++++-
> >  drivers/pci/tph.c                             |  55 ++++++-
> >  drivers/vfio/pci/vfio_pci_core.c              |   3 +
> >  drivers/vfio/pci/vfio_pci_dmabuf.c            | 120 +++++++++++++-
> >  drivers/vfio/pci/vfio_pci_priv.h              |  13 ++
> >  include/linux/dma-buf.h                       |  25 +++
> >  include/linux/mlx5/driver.h                   |  15 ++
> >  include/linux/pci-tph.h                       |   8 +
> >  include/uapi/linux/vfio.h                     |  43 +++++
> >  14 files changed, 517 insertions(+), 19 deletions(-)
> >
> > --
> > 2.53.0-Meta
> >
