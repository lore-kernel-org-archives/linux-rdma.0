Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0544533372A;
	Tue, 15 Sep 2026 20:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789505349; cv=none; b=P1fVf7vWpXsK79rR5FVlDOYQtfygICVgXcmjK0gIgWxhdvcHkgVG2tNYIjMVH3Afu2NCEgeIHGfBStVjEiQtlatrmqeAjwgNwJzgVQ/CxnR0V7m93iqQra1R4GdeZtAL696rKNeSFJ/3V1cj3hhF8/DjxB56PdzW57HL703W8uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789505349; c=relaxed/simple;
	bh=2rHiOpM1SWmmCWtl/HeTmj+udtNeazIbAVgh/06NKiQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZMlZge2UbufAxyx8+ZH3O+ahtiiiRSIFeHeTPjTcLkrlwE1FNBN5eoLEhYgfC3dq3V/r3epqGlh/B3y1HQT8ueIlFYug4GudlWNNjmh2idufVrD1RNHCGhAFog67aepvy3djl9OqO9DPfW6yLk+01iUagzdkmIW3oOe1PUeqlNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=S0XjJj46; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=FBVeIXN9; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="S0XjJj46";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="FBVeIXN9"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id E8AA87A019A;
	Tue, 15 Sep 2026 16:49:04 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 15 Sep 2026 16:49:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789505344;
	 x=1789591744; bh=Yu3kwCeYKncFj2yvTs8psD8GdjcBGRTHyepDYo8UUHQ=; b=
	S0XjJj46BMnulHOgquahdQXs9mFuZne1ZLNp33Xd/mArwF4m2Fs++B9xP025Q0Hy
	F+DtgIrbCRwMqoDcl6MoQrUMcJ8CFm/ADFO6+iLIKrI7eqpPsTqCXQ7r9St6+TRY
	CdjXnYhwCEXf+B7H8GPXmWgCQQcCzpLGoPOnDER5hfCBrfh0k00dQc/heaRti0/r
	7ZoowdPnGlH5VbBXS2uQ8Mv6qpiov1oKtj6+YH8CGsEoE6FOWDSObNma4C5gAbX5
	NHd6HqZtWknYrQWRymzSsa9TCei19l10z5XjPB73KJOFIR/6ykOGjsRB7g5RRsSo
	uo8YezYVyzw6J1xaARM1/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789505344; x=
	1789591744; bh=Yu3kwCeYKncFj2yvTs8psD8GdjcBGRTHyepDYo8UUHQ=; b=F
	BVeIXN9d2DdRi4eF/1h8zMnymRIuYXlwsLLj0B7g8FfQ52dM/zj1emLJH5Z9aCPV
	VIDvTjw8LV4193li4aJWNYqdBfWWa5Z7gcpRbylJPQXcQycnMR9QEfuDG4DnZvtV
	FmR2Q2iNQgVNBKk/hduJibIWJRsDxCyIayc5xNKgMQ0k8iHXvXxAPZJHsnRtmUZB
	aN+kidz81vSiO8Kr3ACx3BF6gGQ4EegNWH1N4lZFxrw1zhmGgZCsWCAv7mq7MsZL
	Uv906A6slGgzFGINTCSkG+gTqK1Qz74wzjZ/JVAB50GQ5Xge7j5SsjpW7ZyiTsTX
	mgslCg/NpETbge4vo2Dww==
X-ME-Sender: <xms:QK-pamdRWFATRVgAfgXeX7NSCi_EhiKHVd20JIkJAd4bdRGM-ifu3Q>
    <xme:QK-paswZfWNKelufFb9cL8fXDqfw-p8KEv74s5ETUAf7jZHYmGurZSYA9vDxxv9Vc
    0Ld1hyx9g4BQ8Iw0S3JReXGUViJYIDYDa2Q2c0bFVxg-UMUwM6tJ9U>
X-ME-Received: <xmr:QK-par98J-XQfx-ZgF7fwOJciyOK0Bo5wot8vpvaVi1F3TSNV_bSHjRU8_5cNQ>
X-ME-Proxy-Cause: dmFkZTEuF6bmHZCvCsnfNQtR2pOXNN9GBfAHzsleUwWU/Ky3k3ztGS8DqFsBQkAvAifzeZ
    +3OLgbKjr4Ahgl2Rz4LjksHmK+nPokDADeJ7RC8EmXDCKC56DD/0lZctu/0lv1YIWeFWhL
    0/QisnnHF3SR6dbciZO9DHXaM/SU8g7j44RQRNJnUhMgTlvyN3JSgOTiBbPulouLlarjKk
    Q6zyyRV2daCAHKnXse+tbtCRkc7NOP7bOsLpl+AIUSQYCbGO9uhNjsX2fQWE0BAFn5RGZK
    GaFWfhudUGaBA0bXAqDA9WkrRnenU4OErsupN76W8AfxfHM7nK4suUyRffTwF/yInlkkt/
    H1lr0zQ3AbBqIJid3B3ZDrfVL+Jw7BLrqoSUWOHJ9zubi9VUYOZ0PAPoLPD/79H29FN0zU
    QtEKUb82Yx+PAXO+DICkI8JXytWRTCKxlabITZwiiyHOE191ExOmAYhpWhU7/YDA5n77wy
    NjeusLBXHcsUYOP/FYGqUSLyVbNW9n2DmXuu1bdxBiIEx7Ocoxc0wZT+YcowXJc1675CXc
    wlgmk3BWetlB2knLZdbKRmfIT0xq8kdU8H//O8bU+ofDC4lu72UN88ofChN/G/Vip1NInn
    3dNOY18zp/NTxY49BWeK6qnPQsgukLLKo7cQcePrCM/zX1z211fh/mUYfPGw
X-ME-Proxy: <xmx:QK-paqy4bN46-gSxfMfV9pzNmCgMyui-EYFl7yQU3aMH_IkzK2LPSg>
    <xmx:QK-pajoB4yStycydEGpqIumtb9RXT2w3mu166GGZdfGt6z8iFk_0eA>
    <xmx:QK-pajoZPO68iDFSbicntOf-M1yV3Y18VJKoXmfwbhRDtIee-7_iXQ>
    <xmx:QK-parBCeY9-3ZhpmZ-u8k8PtxqLvPTrFKDJj8XJTZnmFVkoFQ734A>
    <xmx:QK-papWGpn8S2q_eydKHAiGT_m7f-82FywlZq8ajFF5XEHqze-AgyOgT>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Sep 2026 16:49:03 -0400 (EDT)
Date: Tue, 15 Sep 2026 14:49:01 -0600
From: Alex Williamson <alex@shazbot.org>
To: Zhiping Zhang <zhipingz@meta.com>
Cc: Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, Bjorn Helgaas <bhelgaas@google.com>,
 kvm@vger.kernel.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
 dri-devel@lists.freedesktop.org, alex@shazbot.org
Subject: Re: [PATCH v13 0/5] vfio/dma-buf: add TPH support for peer-to-peer
 access - ping
Message-ID: <20260915144901.554f905f@shazbot.org>
In-Reply-To: <CAH3zFs3=t3rNDDjUsCAekfhEGOJPyx-YXKta7NdHy3kBKU_RHQ@mail.gmail.com>
References: <20260731211601.3033906-1-zhipingz@meta.com>
	<CAH3zFs0vQidHOWif_LmS0=65S9iiCo7yGibqLvFT5jadjj8wVA@mail.gmail.com>
	<CAH3zFs2XnH6gT0fO4=WLi4x1SL2+Y0S=Jo45SWkR=unPegQ8Hw@mail.gmail.com>
	<CAH3zFs2X8=x-XMXhwC7_aUZivCCPQOSuyXMy-ryKqxLEFY9u-Q@mail.gmail.com>
	<c0c8dea4-1571-482e-be33-f965c7c357d2@amd.com>
	<CAH3zFs3=t3rNDDjUsCAekfhEGOJPyx-YXKta7NdHy3kBKU_RHQ@mail.gmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 14 Sep 2026 09:44:57 -0700
Zhiping Zhang <zhipingz@meta.com> wrote:

> Thanks Christian -- no worries on the bandwidth, I'll add the Acked-by
> to patch 3.
>=20
> Hi Alex, Jason, Bjorn,
>=20
> Could you help with reviews on patch 4 (vfio/pci) and patch 5
> (RDMA/mlx5), plus acks on patches 1-2 (PCI TPH core) so the set can
> travel whole if it goes through the VFIO tree, which is the route
> Christian suggests?
>=20
> I've also rebased the set onto 7.3 (base 5225b8eec4c9) and retested on
> hardware -- PCIe analyzer captures confirming the requested ST and PH
> on outbound TLPs, no splats.
>=20
> One thing to decide: upstream took 13 for
> VFIO_DEVICE_FEATURE_ZPCI_ERROR after v13 went out, so
> VFIO_DEVICE_FEATURE_DMA_BUF_TPH becomes 14 in the respin -- let me
> know if you'd rather it be something else.
>=20
> I'll post v14 after I hear from you. Delta from v13 is the rebase,
> that feature-number move, and nothing else functional.

IIRC, we're pretty well settled on the vfio-pci front.  The feature
number does need to be iterated to the next available.  We still need
acks from PCI and mlx5, and given the extent of the mlx5 changes I
expect I need to provide a branch for Jason/Leon once I merge it.
Thanks,

Alex


> On Fri, Sep 11, 2026 at 12:58=E2=80=AFAM Christian K=C3=B6nig
> <christian.koenig@amd.com> wrote:
> > =20
> > > =20
> > Hi Zhiping,
> >
> > sorry I'm completely underwater at the moment and don't have time to ta=
ke another look at the full set.
> >
> > But IIRC you already fixed my documentation requirements and skimming o=
ver the patch once more I can't see anything wrong of hand.
> >
> > So feel free to add Acked-by: Christian K=C3=B6nig <christian.koenig@am=
d.com> to patch "dma-buf: add optional get_pci_tph() callback" and push it =
upstream through the VFIO channels.
> >
> > Regards,
> > Christian.
> >
> > On 9/10/26 23:46, Zhiping Zhang wrote: =20
> > > Hi Christian,
> > >
> > > Third ping on this series. The only patch still without review is 3/5,
> > > which adds an optional get_pci_tph() callback to dma_buf_ops:
> > >
> > > https://lore.kernel.org/kvm/20260731211601.3033906-4-zhipingz@meta.co=
m/
> > >
> > > It lets an exporter report the PCIe TPH steering tag for a
> > > peer-to-peer mapping. The callback is optional -- exporters that don't
> > > implement it behave exactly as today -- and nothing else in dma-buf
> > > changes.
> > >
> > > The rest of the series is settled: Chengwen acked patch 2, the
> > > automated review is clean, and there are no open comments from v12.
> > > Alex is holding his ack until the dma-buf side has been looked at, so
> > > this one callback is gating the whole series.
> > >
> > > If you have concerns about the API shape or the locking, I'll respin.
> > > If someone else should review the dma-buf side, tell me who and I'll
> > > take it there. Otherwise I'll check with Alex and Jason next week on
> > > how to proceed, since 7.3 is in rc and the next window is about a
> > > month out.
> > >
> > > Thanks,
> > > Zhiping
> > >
> > > On Wed, Sep 2, 2026 at 1:53=E2=80=AFPM Zhiping Zhang <zhipingz@meta.c=
om> wrote: =20
> > >>
> > >> Hi Christian,
> > >>
> > >> Another ping on this series for your attention. Pls see below for mo=
re details.
> > >>
> > >> Thanks,
> > >> Zhiping
> > >>
> > >> On Fri, Aug 14, 2026 at 11:08=E2=80=AFAM Zhiping Zhang <zhipingz@met=
a.com> wrote: =20
> > >>>
> > >>>  Hi Christian,
> > >>>
> > >>> A gentle ping on this series, especially patch 3, which adds the
> > >>> optional dma-buf get_pci_tph() callback. Could you please review th=
is
> > >>> when you have a chance?
> > >>>
> > >>> https://lore.kernel.org/linux-pci/20260731211601.3033906-4-zhipingz=
@meta.com/
> > >>>
> > >>> Thanks,
> > >>> Zhiping
> > >>>
> > >>>
> > >>> On Fri, Jul 31, 2026 at 2:22=E2=80=AFPM Zhiping Zhang <zhipingz@met=
a.com> wrote: =20
> > >>>>
> > >>>> This series adds TLP Processing Hints (TPH) support to the VFIO dm=
a-buf
> > >>>> export path, allowing importing drivers (e.g. mlx5) to use the
> > >>>> exporter's steering tag when performing peer-to-peer DMA into a
> > >>>> VFIO-owned device.
> > >>>>
> > >>>> There is no separate in-tree vendor kernel driver for the target d=
evice:
> > >>>> vfio-pci is the in-tree driver and the targeted device is managed
> > >>>> from userspace via VFIO passthrough. That is why the ST has to flow
> > >>>> through a uAPI: userspace owns the device and its ST table, so it =
is the
> > >>>> entity that can configure a meaningful value for a given dma-buf. =
The
> > >>>> kernel-visible participants are still in-tree: vfio-pci exports the
> > >>>> dma-buf and mlx5 imports it.
> > >>>>
> > >>>> On the effect: the endpoint's PCIe ingress block uses the ST as
> > >>>> an in-band instruction for the incoming P2P TLP -- selecting a tar=
get
> > >>>> cache partition and, on writes, an in-flight operation on the data
> > >>>> before it lands. The dma-buf callback keeps this opaque to the
> > >>>> framework -- only the producer (userspace owner of the VFIO device)
> > >>>> and the consumer (endpoint block) need to interpret the value. The
> > >>>> dma-buf get_pci_tph callback itself is optional, but workloads that
> > >>>> depend on the endpoint's in-flight operation need it because fallb=
ack
> > >>>> does not produce the same result.
> > >>>>
> > >>>> The dma-buf hook is intentionally generic and discoverable rather =
than
> > >>>> a private side channel. The exporter owns the completing address
> > >>>> space for the dma-buf and decides whether it can provide a meaning=
ful
> > >>>> ST/PH tuple for that completer; the dma-buf core keeps the tuple o=
paque,
> > >>>> and importers merely request the namespace they support and place =
the
> > >>>> returned value on generated TLPs. Exporters that cannot derive a
> > >>>> meaningful tuple simply return -EOPNOTSUPP.
> > >>>>
> > >>>> TPH is advisory: a steering tag that is not honored on the path (f=
or
> > >>>> example an intermediate routing element that does not forward the =
TPH
> > >>>> prefix) is ignored and the request completes as an ordinary,
> > >>>> non-TPH transaction (PCIe Base 6.4 sec 2.2.7.1). This series there=
fore
> > >>>> targets the same-Root-Port / common-switch topology, where the ST
> > >>>> reaches the completer; cross-Root-Port P2P is best-effort and is n=
ot
> > >>>> gated in the uAPI, since supplying an unused ST is harmless and th=
ere
> > >>>> is no discoverable "TPH routing" capability to test against.
> > >>>>
> > >>>> Patch 1 folds the reserved 0b10 "TPH Completer Supported" encoding=
 into
> > >>>> "not supported" in get_rp_completer_type(), so only architected va=
lues
> > >>>> can reach the TPH Requester Enable field. It was previously posted
> > >>>> standalone to linux-pci; per Alex Williamson's v12 review it now t=
ravels
> > >>>> with the series, which removes the cross-tree ordering dependency =
and
> > >>>> lets review tooling apply the series as posted.
> > >>>> Patch 2 adds small PCI/TPH type helpers so drivers can query the e=
nabled
> > >>>> TPH requester mode and the device's TPH Completer Supported field
> > >>>> without reaching into pci_dev internals (and so callers in
> > >>>> CONFIG_PCIE_TPH=3Dn builds get a clean fallback). pcie_tph_complet=
er_type()
> > >>>> applies the same reserved-encoding fold as get_rp_completer_type(),
> > >>>> inlined locally so the helper is self-contained.
> > >>>> Patch 3 adds the optional dma_buf_ops::get_pci_tph callback plus t=
he
> > >>>> dma_buf_get_pci_tph() importer wrapper so importers can fetch TPH
> > >>>> metadata from an exporter under dmabuf->resv.
> > >>>> Patch 4 implements get_pci_tph in vfio-pci and adds the new uAPI
> > >>>> (VFIO_DEVICE_FEATURE_DMA_BUF_TPH) for userspace to attach the meta=
data.
> > >>>> Patch 5 wires up the mlx5 RDMA driver as a consumer. It also enfor=
ces the
> > >>>> dma_buf_get_pci_tph() steering-tag lifetime: the tag is only valid=
 for the
> > >>>> mapping it was queried against, and the mkey's TPH fields cannot be
> > >>>> reprogrammed in place. mlx5 therefore records the registration-tim=
e tuple
> > >>>> and re-queries after each dma-buf mapping is established under
> > >>>> dmabuf->resv; unchanged tuples continue with the existing mkey, wh=
ile
> > >>>> changed or missing tuples fail the remap rather than continue with=
 a
> > >>>> stale hint. For vfio-pci BAR dma-bufs this is expected to be a no-=
op
> > >>>> because invalidation is revoke/quiesce, not movement to a new back=
ing
> > >>>> placement, and the userspace-provided tuple is not changed by the
> > >>>> revoke/un-revoke path.
> > >>>>
> > >>>> Build-tested with both CONFIG_PCIE_TPH=3Dy and CONFIG_PCIE_TPH=3Dn.
> > >>>> Functional validation on the target topology: PCIe analyzer captur=
es
> > >>>> on the P2P TLPs confirm the ST emitted by mlx5 matches the value
> > >>>> configured through VFIO_DEVICE_FEATURE_DMA_BUF_TPH, and the end-to=
-end
> > >>>> P2P workload only produces results consistent with the endpoint's
> > >>>> ST-selected in-flight operation. For example, with userspace
> > >>>> configuring 8-bit ST=3D0xf0 and PH=3D2, an analyzer capture of a p=
eer-to-
> > >>>> peer MWr64 shows "STP MWr64 TC=3D0 OHC=3D2 ..." followed by "OHC-B
> > >>>> ST=3DF0h PH=3D2 HV=3D1":
> > >>>> (TLP Captures)
> > >>>> 08000260 -> STP MWr64 TC=3D0 OHC=3D2 TS=3D0 Attr=3D0 L=3D8
> > >>>> F0000004 -> RID=3D4h:0h.0h EP- Tag=3DF0h
> > >>>> E0200000 -> AddrH=3D000020E0h
> > >>>> 00080006 -> AddrL=3D06000800h
> > >>>> 90F00000 -> OHC-B ST=3DF0h PH=3D2 HV=3D1 AMA=3D0 AV-
> > >>>>
> > >>>> The dma-buf get_pci_tph interface has also been exercised by a sec=
ond,
> > >>>> independent importer: a different vendor's NIC whose driver is not=
 yet
> > >>>> upstream, locally taught to call dma_buf_get_pci_tph(). A PCIe ana=
lyzer
> > >>>> confirmed the ST it placed on outbound P2P TLPs matches the value
> > >>>> configured through VFIO_DEVICE_FEATURE_DMA_BUF_TPH, the same resul=
t as
> > >>>> with mlx5. Two unrelated importer drivers exercising the callback
> > >>>> end-to-end shows the interface is not tied to a single consumer. T=
hat
> > >>>> importer change is out-of-tree and not part of this series. For th=
at
> > >>>> second importer, with userspace configuring 8-bit ST=3D0xe0 and PH=
=3D0,
> > >>>> an analyzer capture shows:
> > >>>> (TLP Captures)
> > >>>> 08200260 -> STP MWr64 TC=3D0 OHC=3D2 TS=3D1 Attr=3D0 L=3D8
> > >>>> 4E00004C -> RID=3D4Ch:0h.0h EP- Tag=3D4Eh
> > >>>> 00170000 -> AddrH=3D00001700h
> > >>>> 00200006 -> AddrL=3D06002000h
> > >>>> 10E00000 -> OHC-B ST=3DE0h PH=3D0 HV=3D1 AMA=3D0 AV-
> > >>>>
> > >>>> Changes since v12:
> > >>>>   Patch 1 (PCI/TPH, new to the series): the reserved-encoding fold,
> > >>>>   previously posted standalone to linux-pci [1], is now the first =
patch
> > >>>>   here (Alex Williamson). Sashiko could not apply v12 because of t=
hat
> > >>>>   external dependency; with the fold in-series and the mlx5 leak f=
ix in
> > >>>>   linux-next, v13 has none. The code is unchanged from the standal=
one
> > >>>>   v3; the Fixes: tag is dropped, since no code path can reach the
> > >>>>   reserved encoding today and the patch is hardening rather than a=
 fix
> > >>>>   for observed silicon.
> > >>>>
> > >>>>   Patch 2 (PCI/TPH): inline the reserved-encoding fold in
> > >>>>   pcie_tph_completer_type() rather than calling the helper that ea=
rlier
> > >>>>   folding revisions added; that helper was dropped in folding v3 p=
er
> > >>>>   Bjorn Helgaas and Wei Huang.
> > >>>>
> > >>>>   Patch 3 (dma-buf): no functional change.
> > >>>>
> > >>>>   Patch 4 (vfio/pci): also gate the DMA_BUF_TPH feature on
> > >>>>   vdev->pci_ops->get_dmabuf_phys, matching
> > >>>>   vfio_pci_core_feature_dma_buf(). Without it PROBE reported the f=
eature
> > >>>>   as supported on a device that advertises TPH Completer support b=
ut
> > >>>>   cannot export a vfio dma-buf at all, so nothing could ever carry=
 the
> > >>>>   metadata (Alex Williamson, who raised this to uAPI-affecting
> > >>>>   severity).
> > >>>>
> > >>>>   Patch 5 (mlx5): keep the !dev->st early-out in mlx5_st_alloc_ind=
ex()
> > >>>>   ahead of the pcie_tph_get_cpu_st() call, so splitting out
> > >>>>   mlx5_st_alloc_index_by_tag() neither adds an ACPI _DSM invocatio=
n on
> > >>>>   devices without ST support nor changes the errno userspace sees =
when
> > >>>>   the _DSM lookup fails (Alex Williamson). The commit message now
> > >>>>   describes this rather than presenting the split as a pure extrac=
tion.
> > >>>>
> > >>>> Previous link:
> > >>>> v12: https://lore.kernel.org/linux-pci/20260715204008.3911275-1-zh=
ipingz@meta.com/
> > >>>> v11: https://lore.kernel.org/linux-pci/20260702181025.2694961-1-zh=
ipingz@meta.com/
> > >>>> v10: https://lore.kernel.org/linux-pci/20260630224328.3218796-1-zh=
ipingz@meta.com/
> > >>>> v9: https://lore.kernel.org/dri-devel/20260622184211.2229399-1-zhi=
pingz@meta.com/
> > >>>> v8: https://lore.kernel.org/dri-devel/20260615065912.2177918-1-zhi=
pingz@meta.com/
> > >>>> v7: https://lore.kernel.org/dri-devel/20260611161546.4075580-1-zhi=
pingz@meta.com/
> > >>>> v6: https://lore.kernel.org/dri-devel/20260608185646.4085127-1-zhi=
pingz@meta.com/
> > >>>> v5: https://lore.kernel.org/dri-devel/20260526144401.1485788-1-zhi=
pingz@meta.com/
> > >>>> v4: https://lore.kernel.org/linux-pci/20260519201401.1558410-1-zhi=
pingz@meta.com/
> > >>>> v3: https://lore.kernel.org/linux-pci/20260512184755.4137227-1-zhi=
pingz@meta.com/
> > >>>> v2: https://lore.kernel.org/linux-pci/20260430200704.352228-1-zhip=
ingz@meta.com/
> > >>>>
> > >>>> Zhiping Zhang (5):
> > >>>>   PCI/TPH: treat reserved 0b10 completer encoding as unsupported
> > >>>>   PCI/TPH: Add requester/completer type helpers
> > >>>>   dma-buf: add optional get_pci_tph() callback
> > >>>>   vfio/pci: implement get_pci_tph and DMA_BUF_TPH feature
> > >>>>   RDMA/mlx5: get tph for p2p access when registering dma-buf mr
> > >>>>
> > >>>>  drivers/dma-buf/dma-buf.c                     |  32 ++++
> > >>>>  drivers/infiniband/hw/mlx5/main.c             |   1 +
> > >>>>  drivers/infiniband/hw/mlx5/mlx5_ib.h          |  11 ++
> > >>>>  drivers/infiniband/hw/mlx5/mr.c               | 151 +++++++++++++=
++++-
> > >>>>  drivers/infiniband/hw/mlx5/odp.c              |   7 +
> > >>>>  .../net/ethernet/mellanox/mlx5/core/lib/st.c  |  52 +++++-
> > >>>>  drivers/pci/tph.c                             |  55 ++++++-
> > >>>>  drivers/vfio/pci/vfio_pci_core.c              |   3 +
> > >>>>  drivers/vfio/pci/vfio_pci_dmabuf.c            | 120 +++++++++++++-
> > >>>>  drivers/vfio/pci/vfio_pci_priv.h              |  13 ++
> > >>>>  include/linux/dma-buf.h                       |  25 +++
> > >>>>  include/linux/mlx5/driver.h                   |  15 ++
> > >>>>  include/linux/pci-tph.h                       |   8 +
> > >>>>  include/uapi/linux/vfio.h                     |  43 +++++
> > >>>>  14 files changed, 517 insertions(+), 19 deletions(-)
> > >>>>
> > >>>> --
> > >>>> 2.53.0-Meta
> > >>>> =20
> > =20

