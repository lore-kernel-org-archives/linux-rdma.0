Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F308490BE9
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 23:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789514869; cv=fail; b=FC2mR2pu58zu8Q+A9VXw/+BuGU73mJTRPg/K49h5SFXL2ioPAJJsjv8ZFo62ljnQMu9Mxls86DoN+horg0bz6ZwP52TAAA9igFW6AHMI1ebFtn3fscf5g16Yb3ge4qwD3qA2gJhET9SiWWBOOFGg1VW0YzwnjI9kvZoE83L1v6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789514869; c=relaxed/simple;
	bh=660xTiVCFMGhryydhz3t8ZyEjYsku0AbA68go+LIyfs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kyT+Dh3J9cH6N22MhH3Zdj4aTonDPlu9AceETXtMjq6/rQb9A9bFmop6N+Q0emT3AkTo3veSJhwzxV4HzhcjSEbA6BIlq6gTzlXW34Fal/aNYw20Jf3F0ecg7fKt+rO/rNQ63BroschDrQUO7PQwUSoF/xkBvvD1uHGcDrXnyQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=P7LdrCN5; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="P7LdrCN5"
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMP4Nf1202986
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 16:27:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=puTYzaznhw4+fIfX1uaMmGMJC1CZW9OyuJIqa
	VoOjFA=; b=P7LdrCN5RlHrQAwR3lh1Sw42HEUBPv6LyCl+r8hwB62t5uwriMQbD
	rm3NHwvD0PaefgR6OLHyroy5wHF4NVm+G4W63yP3NyZYHZWKoV3mbJ6JwD/WzgDa
	RCeXKORnF3xngXyoH0nHuBfJCW8zHXhDCn33h+JKiHawytHEapppS8dI22J6V2E6
	w+wP3sWCpYGwv46N0moEuenEzZJXV3cz3DJ4nWBpzrkR/rAXp/InbRpHQnm4a4Mq
	Krw1zm+PNYoHvCoper3L8ztW3x3PaHAyJrFmTd5OAYW7ZeVhs4ef8tPXRuwdBjYQ
	kousKyfTwk1c3s9n+5u7EB3H7XOriOxrw==
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gqcw197tf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 16:27:47 -0700 (PDT)
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-8009280834fso6031363a34.2
        for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 16:27:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789514866; cv=none;
        d=google.com; s=arc-20260327;
        b=rV9woSOQBt8HecTCJyXuZzE+EYuRwLRmXbepEgJgI7luaY8Q8Wco+q/XUNhxOs7E/7
         vlSu7owTvJLmL2zuBPEJdiKHIlw6/+K9ZLDyagrE4xqCzNQj0sU4GxPj2VVVoNwclRlo
         Goj2KPVK6ZkIPPE80tVcyWYS+0K0SMpcxL03p9/30x4LBDOhrwxnG0UUcdwy4da9CW48
         vHPoViIr6VjsgXq8KGvMRQaafuHS5HidIeCUSxiZRTZ1PPWH0i3/u3FnYRrBPIZ5qPvi
         uOnfJK5R032vvQmkvqMSyE6oyY+9T9hinLjp+nZf4gCboenne7YEmLP7xD2ebf2nqKn3
         dahQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=SJKC0cK2PwsxosA12SybEYsbNkrOGaDMLHL+9hzWLps=;
        fh=+d3VBKn77IXSZm7DSUzyf3zT8Za4LPFOkd50yir7XNM=;
        b=jYA+ZlLOuIj1pCxNgq2reHuijTjbAKEdMI6ZNz74vjmN1FS5i3nUPO+VEMGpwuw8PD
         PuxJX8mF1hmGfmiTn9tMBVJcM7gxJaGKkTiCqaVg8rKECkV8ZFZiC0nbu5I6oC6kbTB7
         MVdAT2eXSg1Kwfux8SUlwVLNXk+NywrURnyGUkCmC1wo70fpO5WHpnpAZIVu4nk/64Be
         X3J3MQ+QiRzkY6ogqWMBhUE5Q8N60w9zVmfp3TAdiHwzdjuTMMJsaKl8gXh4dEgSmwCZ
         QI3kgCB2/1kowQ4JZg1hyZ3JQu14fPsDxS/o0XfcYwZOq4SSxIaS1wWmbYhw+dS9s++x
         dzyQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514866; x=1790119666;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SJKC0cK2PwsxosA12SybEYsbNkrOGaDMLHL+9hzWLps=;
        b=T8yz2EAqYNmYW2gSFlh5oHm0wdmcr+nV0SxCDqZGhYy+CktAmU1skZdQ6C0BiDPHsD
         WU4u+/3tm06LCkCT6p5xcKrL+D07PvKdmPQlul814gR11EcYI5QdpSKxzjNFdKa+ApEN
         0p6GHiQTJHZvvxu/RWoMTVAUMIxuBtmrzdKX06seqJKsZKewqXE5/q/LqNQY3P1+EQbl
         Huc2pv7an11NzIZrdFTrEfld76N6514aA9T310CEOIp98uhjsqekNAQUM1EiT2NXix1r
         wChg8nlr1Lc2ALpkQuqLnkhTrNCWcvbThKdjf2veUeWWToqIArD5j6WW+KeiOnfud15P
         iP0A==
X-Forwarded-Encrypted: i=1; AKwUvBxvSUkZUztpMzgc4uGE1PZkup41tbwUhxYiyfbryiQyHiysr+KZPrtJxHSS9C09v1b1c9UWJCEWodcW@vger.kernel.org
X-Gm-Message-State: AFuF++knUs+cEw4+gwGbDbnHyMigm3LDhmgsXXPIM4QAOaxIzjBKeAoe
	qcL5RGRt6zJRVTcl7ECdHAXpaJZJwlxC19vUMo9WP0TJw2hWh3d5yhGm1djZmRCHSxMt6yvhx0/
	IO4ioYzoB/5LGC7tgsjybtY6mxPpBgrlgwWncl+sCevehw6Klhw092tkPjlUpNMmqNXRf7t3Sei
	kK16kygBz0QiZkK/qWFsLFcxlFH0SNrFZyTcAA/WD19vm+XTw=
X-Gm-Gg: AYBFou1oi1hs3ZRmkFK7wuFmyhwAAEbrGKOrSoGXTLe5bIZh24xOpSZLwB2fUJuYQ2m
	dT+4wdh4TQHOyl9bShdq2bpPRbA6EyJb78Uet6kgMm+7m3LB34DDPr340VenLySSWSrNAxCfLpP
	TbB5lmAu7PWpvUGDogvf0ulQg9zcj2umi3eokZ7kJd+AyVPbaiX1eNQxXqGg+F6rEQGTu2Xe4s
X-Received: by 2002:a05:6830:6602:b0:806:75db:bb32 with SMTP id 46e09a7af769-80b2df3d962mr1439119a34.9.1789514866368;
        Tue, 15 Sep 2026 16:27:46 -0700 (PDT)
X-Received: by 2002:a05:6830:6602:b0:806:75db:bb32 with SMTP id
 46e09a7af769-80b2df3d962mr1439055a34.9.1789514865867; Tue, 15 Sep 2026
 16:27:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260731211601.3033906-3-zhipingz@meta.com> <20260915222303.GA877199@bhelgaas>
In-Reply-To: <20260915222303.GA877199@bhelgaas>
From: Zhiping Zhang <zhipingz@meta.com>
Date: Tue, 15 Sep 2026 16:27:34 -0700
X-Gm-Features: AcwNN1Ur2HGTwLfzS3v5GCfBM43O6loZu_h11eJ9ffO6Ol-LlJuiRokJ9Mq3XW4
Message-ID: <CAH3zFs1hpotRvvTziNhSSNR1fLiFekSAMCA7oKsNJbobgeckRw@mail.gmail.com>
Subject: Re: [PATCH v13 2/5] PCI/TPH: Add requester/completer type helpers
To: Bjorn Helgaas <helgaas@kernel.org>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MyBTYWx0ZWRfX8YcvPeHjVCxX
 w13KufrlMQSDGbT4XeJOetgeaJukCijMBmGeuu1+/9e5PZLA1iWR/IG/9XZSOj0LcE1+Vc/bSCn
 D39VErdiXPhMQOuxvE1Is4zrEqISKPcZYXOA/GFOOMMnUVGfIEpGfLtKCGkFHZ6fEM+4OqBiNQA
 IPY1sSUKmAmOMOqROoeljg9UuEhtFH95v+94Rkb2EHacrC69O7k2s1ZXk0kEEC1G4xEzARNkkZz
 ogDQkwz8poDLgDyLj79fGxPmPafRYGRS2MCpTQCP+Fwr2LwJIs/hbAKCVWub2YZcMmCcst0eMeR
 Vtd4NGUs6Bnfx/bs5s9FUxNmYSPRLnjP7ltqIKgqRJBJxW1LN7ne1WgGd2rlSPn4nGCtzBKln1k
 W9ZL2Mq/lskmyyLRmSn5Et/lcfN9AN70pwulZ3khedfsT2K3pWnonhWpqNCWr2JCy+Gasp7pUQS
 79X7zUPQfuCHfQEW1GA==
X-Proofpoint-ORIG-GUID: _6hOk1Zec8mYhUIjl4j1dJPXulymSBD6
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MyBTYWx0ZWRfX9JMYkTx9biGE
 YBGZBoDCoK3ESvEd3hBTWceoMmDv/e34gES4pWzarhs3wIb+FnMUM7H0IC4Czvod2u9o6ZHyZc9
 6AQQOa0dhzu2TbzYjh34McdLZHINWbE=
X-Authority-Analysis: v=2.4 cv=HKBWhYtv c=1 sm=1 tr=0 ts=6aa9d473 cx=c_pps
 a=z9lCQkyTxNhZyzAvolXo/A==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=GbPsI2Ihf5RTnMjR_gZv:22
 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8 a=1XWaLZrsAAAA:8 a=B6l6obb3YNMg1WPjzLYA:9
 a=QEXdDO2ut3YA:10 a=EyFUmsFV_t8cxB2kMr4A:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: _6hOk1Zec8mYhUIjl4j1dJPXulymSBD6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01

On Tue, Sep 15, 2026 at 3:23=E2=80=AFPM Bjorn Helgaas <helgaas@kernel.org> =
wrote:
>
> >
> On Fri, Jul 31, 2026 at 02:15:49PM -0700, Zhiping Zhang wrote:
> > Add pcie_tph_enabled_req_type() so drivers can query the enabled TPH
> > requester mode without reaching into pci_dev internals.
> >
> > Add pcie_tph_completer_type() so drivers that publish TPH metadata for a
> > device acting as a completer can gate on the "TPH Completer Supported"
> > field of Device Capabilities 2 (bits 13:12, PCI_EXP_DEVCAP2_TPH_COMP_MA=
SK)
> > rather than reusing requester-side state. It applies the same reserved-
> > encoding fold as get_rp_completer_type(), inlined, so the reserved 0b10
> > value never reaches callers.
> >
> > This keeps pci_dev::tph_req_type and the completer-capability decode
> > inside the PCI/TPH code and provides !CONFIG_PCIE_TPH stubs for callers.
> >
> > Signed-off-by: Zhiping Zhang <zhipingz@meta.com>
>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
>
> > ---
> >  drivers/pci/tph.c       | 44 +++++++++++++++++++++++++++++++++++++++++
> >  include/linux/pci-tph.h |  8 ++++++++
> >  2 files changed, 52 insertions(+)
> >
> > diff --git a/drivers/pci/tph.c b/drivers/pci/tph.c
> > index 5cbb381e2a02..d0202ff7a1b2 100644
> > --- a/drivers/pci/tph.c
> > +++ b/drivers/pci/tph.c
> > @@ -223,6 +223,50 @@ static u8 get_rp_completer_type(struct pci_dev *pd=
ev)
> >       return PCI_EXP_DEVCAP2_TPH_COMP_NONE;
> >  }
> >
> > +/**
> > + * pcie_tph_enabled_req_type - Return the device's enabled TPH request=
er type
> > + * @pdev: PCI device to query
> > + *
> > + * Return: PCI_TPH_REQ_DISABLE, PCI_TPH_REQ_TPH_ONLY or PCI_TPH_REQ_EX=
T_TPH.
> > + */
> > +u8 pcie_tph_enabled_req_type(struct pci_dev *pdev)
> > +{
> > +     return pdev->tph_req_type;
> > +}
> > +EXPORT_SYMBOL(pcie_tph_enabled_req_type);
> > +
> > +/**
> > + * pcie_tph_completer_type - Return the device's TPH Completer support
> > + * @pdev: PCI device to query
> > + *
> > + * Reads the "TPH Completer Supported" field (bits 13:12) of Device
>
> s/Reads/Read/ to match other doc ("Return ... type" above, "Write tag" be=
low)
>
> > + * Capabilities 2. The reserved 0b10 encoding is folded into
> > + * "not supported" so callers only need to compare against the three
> > + * defined values.
>
> s/The reserved 0b10 encoding is folded/Fold reserved 0b10 encoding/
>

Thanks Bjorn for the ack. I'll incorporate both wording fixes in v14.
The kernel-doc becomes:

/**
 * pcie_tph_completer_type - Return the device's TPH Completer support
 * @pdev: PCI device to query
 *
 * Read the "TPH Completer Supported" field (bits 13:12) of Device
 * Capabilities 2. Fold reserved 0b10 encoding into "not supported" so
 * callers only need to compare against the three defined values.
 *
 * Return: one of %PCI_EXP_DEVCAP2_TPH_COMP_NONE,
 *         %PCI_EXP_DEVCAP2_TPH_COMP_TPH_ONLY or
 *         %PCI_EXP_DEVCAP2_TPH_COMP_EXT_TPH.
 */

  Thanks,
  Zhiping
