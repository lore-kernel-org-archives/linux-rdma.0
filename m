Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E77713776B
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 00:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789517842; cv=fail; b=tt33U4aaF8t5xLhcxzs8643VBDw0pG0f/fA5VrSvND+f8U1UD3IzMJ6NCSth8ZSvuDH5mYjgLy098PWKwFc4Tnmj982r8OQQbjuaFKuxTjDaplFIrMk9WqtBKUmyj6xYd240uewxuUIRHWJu6EIzQsG/ZfB0WCwhJ6lxuvtlFcM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789517842; c=relaxed/simple;
	bh=5av3QgEhikSP0tSNbBAG2bZkciaGDEOrmy5hau/6dIY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rLV/xwpivrqzDM4+4r3Wr7AdSHMDEG/8BLrzHi7Ld5cGHqRe0SfnsI7zP4U5U+pR6GareXPevvIrA5Vs8aDaGQy1WE9nJvRm8GxabmFAER4SBOGUVzaSoB9Zm4pxp7P7o1LoqbRbz5hcBqmTlMvlZFMdLWfFRlwpZeWi1TEefj4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=SV3hPlDn; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="SV3hPlDn"
Received: from pps.filterd (m0528006.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMOVoH1049128
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 17:17:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=y4AfS6tr9HrRnC6D4zpOkbqwXmfmGihLXHO3T
	H7isxM=; b=SV3hPlDnkLVLzLZ5wbnt0LfyWojFDHoTKaL9JlUmAXLtdCh4GpdZ/
	SKD174SCvrUikKcMBYauckYS3JgM+tWicqg6Oj1Bmcs0oYCNvfbaKfuYGlrVLJKf
	r6OwvK9Qe/f4pBy01MEWp1c9CWkCnaxUkeQw8Qd9+jvYiKtQS4cVfUVdETDA7xaZ
	i02VojdTANK3f3sj2LsPaRR7E9gJFNv8lt86XsIF/4fC95eqm/hGduydG7DxeyJK
	pir0xIEvbcfyHKR1q53dV/4//VMrQo9fK9ExB2hkeqKevwM0hhR489OnIDrdaCGJ
	MkoepWkx0zrAKKuQkN2Vqp+EvaVdA5v5g==
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gqe058y38-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 17:17:20 -0700 (PDT)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-8064fadbb1dso2472183a34.0
        for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 17:17:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789517839; cv=none;
        d=google.com; s=arc-20260327;
        b=DR40zJ/dz8Ko/wb5/YHZFHShae6SBM0Luhr7RdcchU4/2GlaM/qUFABL9LW5ed3Rys
         XQfbFbNqNJcEM14uj0+40NEJNoStRoifbtOGis167/SQZYuw2rI+0re2bqlLSn/2VqaV
         vb9ztNJ8X2Psgh5GLGtvXqwJTSX1a501GjTmoQW91LRs/4901XEU2G4yQGuZy0BMFmDR
         0moF9ilTWdX81vG02GM75nOJbzb95laMUPDUZH8NsOy4ziv5oYrK0hQc5dd2s8P29bbk
         gZNVf7dpDls8hOfdvrtLsBV5OuYBzCTAz3bu6qi2qM8hmey00jzcO1RkEASG+QMbVcbp
         E5Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=Kw8qhFcrPQrG+D+0UL2QgWXn6zGjS5meCnbxBsS+WIw=;
        fh=S0zVoQOixSLsc6O9UZ2a+ebByPuolWoOC3x0NkqoWKk=;
        b=H66GO+13jgBn03erSk8M5/blOo8o0fD98N6OBYR2RAKBWL458RdqHOTDhimBqaOVdG
         1PH8ppz0fkJr1KNcFOCffSKeL4t/xU/DhditP/22bTqXWBFAcfJrTNIrUsLbhlqxDBES
         sB1kKiEwWNScFDpE+L25rAhkBVQd7x+ZVTQEjcl80eofXFL68jQad3G9tj77gRiltfnB
         9dANx4LTPDP6Sd0d0z0YDG+RhVOIYb9PpydKeW2OL4chKtx1OGHQbf6Ymmom/LzBdCQE
         ZDAemk0sgibccdA1YWNDfNcISlbTWzIPdU40XAFGQ23jQNppZK9x0hZHbjq3GDtxgvcl
         jcpw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789517839; x=1790122639;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kw8qhFcrPQrG+D+0UL2QgWXn6zGjS5meCnbxBsS+WIw=;
        b=eHTbeeseARt3CyPxS4svjwx8sPBI56+B83DEZrSSyF708T+cYEOOPGPpR7lKSMGYjH
         +qHjIzF8F03rZL+OTrhIOaJE2XM6XeDuLEMtJnwuxAYKxSL2+cjarf2zuPgmGvgCER53
         5kPeblc68786R4Lc06PuoMD0O/6Z/v54s19qiZsNkucT59ihovqs34NzB/999z4Q3qUl
         mWRtkLaGsLbjn3NDpmru9vaO3eHbHJmN/AulaaW6dKZ/dgJyDmo8Anu8oAOa+A+NDaJu
         suBU+JqiWe8P3USwFG0+gR6jauAAmutwR0apB+nLbKsab0tfwE3gtRVk2ZnvF5eejXiq
         3+gg==
X-Forwarded-Encrypted: i=1; AKwUvByGd0ZYtbiC3S3Jx5ZnTwcOE+1Bl8jGGhL9Rql2CRjIBkYmR/Jgz7lotz7eVju+pFuP4wMkXfLBrjjK@vger.kernel.org
X-Gm-Message-State: AFuF++mGmcFEoKPgsjwLqmS/6VBqx7ArZZUTxdI40ice0h186QIcdA3j
	DyW2G21RHQeoF1CAHkmrIYJPwj3DBTMobJHyuTsl8G6b4cvvTWdKKG4n/mvO99jkjSfOJRz2n7g
	STCW2Jxof/HERBOn+0VD8F7h60tI4ThDDOadWy5F4y0uNgFac/7xMCkvmL7D6XSw9vimOePDPj8
	Sk3ZyuXsfdi493tJ0ux3IfOmRaaTp9mPLqDCPe
X-Gm-Gg: AYBFou2ZM8d64D8jijaizM39l5Jq8qz0AWWQ38HP2Xxgmdh770RkCA/cFLImceGs9kB
	4ui2piR6DNj7vrH5d0So5ylZknQXGJrLD87uTc072jUPykWlrwfwJ+f1PS0hj/KL65JTWtg/9cI
	Z+KBsLSgpV31Yi/ju+PLgZtD/SgqcU9oE3CjQusOtlCMj+L9de8KOuZbo+Jm6aIMmKvWjyMAVg
X-Received: by 2002:a05:6830:d0a:b0:7e6:d54e:8fe3 with SMTP id 46e09a7af769-80b2d408fadmr803744a34.9.1789517838950;
        Tue, 15 Sep 2026 17:17:18 -0700 (PDT)
X-Received: by 2002:a05:6830:d0a:b0:7e6:d54e:8fe3 with SMTP id
 46e09a7af769-80b2d408fadmr803625a34.9.1789517837178; Tue, 15 Sep 2026
 17:17:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260731211601.3033906-1-zhipingz@meta.com> <CAH3zFs0vQidHOWif_LmS0=65S9iiCo7yGibqLvFT5jadjj8wVA@mail.gmail.com>
 <CAH3zFs2XnH6gT0fO4=WLi4x1SL2+Y0S=Jo45SWkR=unPegQ8Hw@mail.gmail.com>
 <CAH3zFs2X8=x-XMXhwC7_aUZivCCPQOSuyXMy-ryKqxLEFY9u-Q@mail.gmail.com>
 <c0c8dea4-1571-482e-be33-f965c7c357d2@amd.com> <CAH3zFs3=t3rNDDjUsCAekfhEGOJPyx-YXKta7NdHy3kBKU_RHQ@mail.gmail.com>
 <20260915144901.554f905f@shazbot.org>
In-Reply-To: <20260915144901.554f905f@shazbot.org>
From: Zhiping Zhang <zhipingz@meta.com>
Date: Tue, 15 Sep 2026 17:17:06 -0700
X-Gm-Features: AcwNN1UDllFH7fZheftU62Oc0zcY8368FZvRR7u05GnfBjshQDxnxMnIHm9x8No
Message-ID: <CAH3zFs3MwpxLNL+qK9e-jPBLasjfxeMvudhgz5XzwrtvL1Dz=w@mail.gmail.com>
Subject: Re: [PATCH v13 0/5] vfio/dma-buf: add TPH support for peer-to-peer
 access - ping
To: Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Cc: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>, kvm@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
        dri-devel@lists.freedesktop.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: z29d2wJqxXtAC4NoVt7dkk_-wAjqElvP
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDAwMiBTYWx0ZWRfX+j7bWIh95R29
 BH8gSfyoJyiCJ0BRB1Q4Y3pFpfHOTKQ6g2xyalmoANV0rbrFOIKFYppiLSC8RqvYpimbDEMLk6k
 qBITjBBJrB00hMvUGnzAR69yalrwRXc=
X-Authority-Analysis: v=2.4 cv=L/KI0OT8 c=1 sm=1 tr=0 ts=6aa9e010 cx=c_pps
 a=+3WqYijBVYhDct2f5Fivkw==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=kkcUborcUVj0H7zxAXTl:22
 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8 a=r1p2_3pzAAAA:8 a=tEdGRIS0mffteslzfD0A:9
 a=QEXdDO2ut3YA:10 a=eYe2g0i6gJ5uXG_o6N4q:22 a=gKebqoRLp9LExxC7YDUY:22
 a=r_pkcD-q9-ctt7trBg_g:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDAwMiBTYWx0ZWRfXwAvqcpChXIU/
 /Fa/asqv1HxIWPVrS0KBdrPse5Td5FeXCYwLMdnAW/XEC4aNsUjYea0/Olby2dWuLv0olfB1ie+
 EKmprCr/lfWc6NaTkAjqyGTf+YL4SAogPg136WfOXfvTlJteN67w8MTYOwpl1wEYM87xsd61g0p
 tqHvTBJLSwYBEQmozImrYooaJj/I2jaJHKP47zU6UVkHAWA6CzOXY2oBNVJRmX6irgcsHOvFRTH
 /wSDcU1O/CKajBK9+cWId2AyhslS2bRtgV6pqr0D/xsS7td7/sHGpDjef+6R9Z1pXSUW6UNnQFZ
 FhPaZj4gC+hb/TLJpnfOjIDIUAvHicUE6YscynOUPVGR9oAlPf7WP2DXQsnsFadoSUBe1yMZphj
 Wv+5nYW+egA0jQRjEfGpMerJAzadxzXnZbstMQCZ9SHcoPhyk5dOAHNUNiKmGaPj2y9cCbdEjLr
 px3vbT+R4OWHwtishKw==
X-Proofpoint-GUID: z29d2wJqxXtAC4NoVt7dkk_-wAjqElvP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01

On Tue, Sep 15, 2026 at 1:49=E2=80=AFPM Alex Williamson <alex@shazbot.org> =
wrote:
>
> >
> On Mon, 14 Sep 2026 09:44:57 -0700
> Zhiping Zhang <zhipingz@meta.com> wrote:
>
> > Thanks Christian -- no worries on the bandwidth, I'll add the Acked-by
> > to patch 3.
> >
> > Hi Alex, Jason, Bjorn,
> >
> > Could you help with reviews on patch 4 (vfio/pci) and patch 5
> > (RDMA/mlx5), plus acks on patches 1-2 (PCI TPH core) so the set can
> > travel whole if it goes through the VFIO tree, which is the route
> > Christian suggests?
> >
> > I've also rebased the set onto 7.3 (base 5225b8eec4c9) and retested on
> > hardware -- PCIe analyzer captures confirming the requested ST and PH
> > on outbound TLPs, no splats.
> >
> > One thing to decide: upstream took 13 for
> > VFIO_DEVICE_FEATURE_ZPCI_ERROR after v13 went out, so
> > VFIO_DEVICE_FEATURE_DMA_BUF_TPH becomes 14 in the respin -- let me
> > know if you'd rather it be something else.
> >
> > I'll post v14 after I hear from you. Delta from v13 is the rebase,
> > that feature-number move, and nothing else functional.
>
> IIRC, we're pretty well settled on the vfio-pci front.  The feature
> number does need to be iterated to the next available.  We still need
> acks from PCI and mlx5, and given the extent of the mlx5 changes I
> expect I need to provide a branch for Jason/Leon once I merge it.
> Thanks,
>
> Alex
>

Thanks Alex, it is great to know the vfio-pci side is settled! Bjorn
acked patches 1 and 2 today, so PCI is covered.

Hi Jason, Leon, could you take a look at patch 5, the RDMA/mlx5 consumer?

https://lore.kernel.org/linux-pci/20260731211601.3033906-6-zhipingz@meta.co=
m/

Thanks,
Zhiping
