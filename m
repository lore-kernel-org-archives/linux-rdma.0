Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35CE50256D
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 13:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792069351; cv=none; b=D9KySgzvO2NFY0jM7jgNUWnwGNMAq6Dlrz7cAgtFfBLNJCka0qyGhIDKqcb9jmQASsvK2BB0ZSY717YTChZAt4nGvhVwqAJdSBJFC6Zsw/jAi8uNqMwXIEH8G4GgXqHKv1dal634JiXEH7h8cv8Gj+aMOOzWOurcwaoG2Pc734U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792069351; c=relaxed/simple;
	bh=8E6F6bCaQwEk5CCxJA9DCsKfHiQmPbmheJmqhlz6q0w=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=Jk/CxmxRC/cHgXczTujRnHoAfgrvnEuisulMESYlWM2Z7yFXsC4T3q9W9GtAV16Q2vnubdJ7VLA8b4xSn9tSik9pPZ8L1MIN3C+a+rg4l1AwOujvFkgPR+VLC8irmdk2Pps1wPuBNfMU84cQr7Y0Ksb09S8oDNYuwM50kwzQsnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SOV4rIll; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SOV4rIll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3981F000C4;
	Thu, 15 Oct 2026 13:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792069350;
	bh=8E6F6bCaQwEk5CCxJA9DCsKfHiQmPbmheJmqhlz6q0w=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=SOV4rIllA8kyqRUhfHSIYF4L76Mku7XWd0mdOH7fLbLCPNaVVgtcKjhMgb7t00O0x
	 30ieNghi/QstjwKYrxBcP31MHqd0Yay0SK50FB2GlOqjNi8VYR0HfyoVwb6U/UFlbP
	 dFWBmGdOQZTRf0FPlhBXBHZLsRN+6bzVupO+dl+xOM2GUEQo6Q1rs5YVlroWb56f1T
	 OIGdjHLlfQ2FapMccKEYshQQLEOmg2RKQuHQHYXRkhak34bKiNYi7OPtcJs9kNW1JT
	 xeEWea47Ot476jI/jR1qXwiueuSLFSca/robUd8IBI77aOId0w9nj2jdgUjG9XRhpZ
	 Y5HaMOAfuT3mw==
Message-ID: <sashiko-outbox-172892@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 2/3] RDMA/srp: Post command IUs inline
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrei-Alexandru Bleortu" <me@andrei-z.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261015125118.2966247-3-me@andrei-z.com>
References: <20261015125118.2966247-1-me@andrei-z.com>
 <20261015125118.2966247-3-me@andrei-z.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 13:02:29 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> srp_post_send() posts every information unit by reference, and the QP
> asks for no inline data. Before the HCA can send an SRP_CMD it
> therefore has to DMA-read the IU from host memory, and that read is
> on the latency path of every command.
>=20
> Ask for SRP_MAX_INLINE_DATA bytes of inline data when creating the QP,
> enough for an SRP_CMD with an additional CDB and an indirect table of
> two descriptors (116 bytes). If the device refuses, ask for less. Intel
> irdma has a fixed limit of 216, 101 or 48 bytes, depending on the
> generation, and Alibaba erdma one of 96. On those devices, found by
> vendor ID, try these limits first, then step down 16 bytes at a time to
> none. libfabric's verbs provider also probes the inline limit by trial
> QP creation. The RDMA/CM and IB/CM QP creation paths move into
> srp_create_qp() so the retries cover both. Post an IU without immediate
> data with IB_SEND_INLINE when it fits in the inline size the device
> granted.
>=20
> Providers copy inline data from sg_list[].addr as a kernel virtual
> address, so the inline path points iu->sge[0] at iu->buf.
> srp_post_send() resets it to iu->dma on every post, and iu->dma keeps
> the mapping.
>=20
> Assisted-by: LLM
> Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015125118.2966=
247-1-me@andrei-z.com?part=3D2

