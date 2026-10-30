Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793384630;
	b=ndNzM9GBDP11ToiWe+j2GuXtJFoeSBu4G+t2ARccxY/ko2iYDDhtVIYP4Ev725RpMv6I
	 bs7eMOso/uPVcjk+dMp2VSC0jDomamAYfhAs79sAx3vZnWoTeqIfL2btc/YNV/JIwMwu/
	 xf3/9+lPqu6OP9HP53/e8V/LbgN5ywlhUAjxulukSQM2p7TcuCgdNGN16K8bdozuYu9mL
	 hq1rRC/8wpzwS/T3wS7bZuIW88mSL0/zkvRHysS7d+dCGfcfXaTrpLUlwdph/X57IH5Rj
	 Fa8lzzPdFJSoieX0xhUXjXUXTm7a1E/44ufznoR/BG0WkYDsjjdE2nMXplvHM1BKeJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793384630;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2uKzhBxzcFDdotXtvivq4Th9ZfuMq4F3f4y5ZDUzrgY=;
	b=DFiA4lZFTlFF5sdjRaOWUdtqaCb4rdFdAjeZ1QkgF/fpqm/vEKescpQ3stdz6xCyncAI
	 rhKlRA64k0x5BHi3sCN90zvXgPG9TfARml+GeJdFeWUQHjFASc/HQKyvrGJ7Y8I5VolDR
	 onsSo/kY9uWUU6HZzuU+Mt31EYRoxSHO6Z3svk2tg66+TJ1FWDM/wMJPD8VI5lsvJvo0a
	 vyTlfvBbdnO+9t+U/0aE66qC/Wamywm1lzCL3wPJv5CIEKXCV6FwmNYaVSed31PUAmmYv
	 GgqUUZEkpzmKfkY4qgGDu19oS178BBZsNtW9dnpwT65enP5nhdFyCEAljtSivF253Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RZW+jOc2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A72D606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 18:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RZW+jOc2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A251F000C1;
	Fri, 30 Oct 2026 18:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793384630;
	bh=2uKzhBxzcFDdotXtvivq4Th9ZfuMq4F3f4y5ZDUzrgY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RZW+jOc2GwCSjQ04/6l7jyknfmwm4aD/Us84Us3JnAcwDd4q0ysTIWDHeB9zUEpHd
	 GXxW0iWLINqLnG+TRnGtE4dpIU5iZSkfs9CgDZMbaJezEffSLDkZs73bW92ktho8E8
	 VgOvDBkZaweYqrec1CznLcEYndztLUkwkY+H2HGeY8k3ylASP23sJpIbPAaB8jCXWz
	 qK514J/R9lQxWOOeaHpqKcJMprk07MBniUzfT8kHZtySFu//ycKvJhXCmvhZDjrp9l
	 Dps+SeNx1N+EY99QBHOIodIT+RPPfPteoa0sd0YSXTWs9tmk3rbv1v+OpwOU+Ia2Ue
	 eEJJHplJDG/cA==
Message-ID: <sashiko-outbox-191405@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v4 1/6] RDMA/irdma: Plumb uverbs_attr_bundle
 for QP, SRQ
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030181512.2056056-2-dhu@x6u.co>
References: <20261030181512.2056056-1-dhu@x6u.co>
 <20261030181512.2056056-2-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 18:23:49 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: David Hu <xuehaohu@google.com>
>=20
> In preparation to support modern UVERBS ioctl attributes (such
> as UVERBS_ATTR_UMEM for CoCo DMA bounce buffers), we pass down
> `uverbs_attr_bundle` for inner QP, SRQ routines. Since standard
> uAPIs provide `ib_udata`, we derive it via the helper macro,
> `rdma_udata_to_uverbs_attr_bundle`. `irdma_create_cq()` supports
> `uverbs_attr_bundle` already, therefore, this patch fills the gap for QP
> and SRQ.
>=20
> QP, SRQ uAPI will now have `ib_udata`, and CQ uAPI has `uverbs_attr_bundl=
e`
> as a top level input. However, we think it is a future project to unify
> them.
>=20
> Signed-off-by: David Hu <xuehaohu@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030181512.2056=
056-1-dhu@x6u.co?part=3D1

