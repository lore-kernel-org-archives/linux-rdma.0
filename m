Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EA04BA1D6
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 10:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792061244; cv=none; b=qzG6GAvepDqK/33qla0jBI2cWHhX5LC+uCTyvxyJ2KCd11D+Ry3p3n7FIkF09WJvUeU1ACJTMdr4HjAnUQJzzqNZkgXp+bTMFyNo8GeVamHL4uyEZclDvuN/BtlxXKR2gUHMFioa/aTs4Cn50ylQSjpg0lNi74swowsH4cbTzR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792061244; c=relaxed/simple;
	bh=nPsaE0cjJfQd8HQjP//fIhn7NdaBhnOE1vf8C6hDdHc=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=LayJ4pwzywpGfndJggNoSbRAdOkryBPUBaZ5fzsPPLbIMsYwrHJUMHzu5rxPXuokgQAz9qznIG5NjNsI5O0s+4bTT+XwlGh0kgvjr7ut5vq1tJOEdwndEmOy1hn7Ku3znVBdBFqfrvPyFFYxUinI7YVmjduuhjmKAn8bW4QkhVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Er6G3izw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Er6G3izw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23701F000C5;
	Thu, 15 Oct 2026 10:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792061243;
	bh=nPsaE0cjJfQd8HQjP//fIhn7NdaBhnOE1vf8C6hDdHc=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Er6G3izwabSvLPrpliK5BAPtmEVQ0DC5Om8ZTlQ1g3Qz9GlhivIXDkvCho/ozxE1V
	 BUbZdky6CcJXHq8Wuqyh/bCQ+J4ZUXjeyCe6dHgonS1xCH7wxvqk84et4N2qPQ8bP4
	 PMUIpykEhE2N5j62BEWrPlAmnQuN3hR+bJ/QCiICyVxOZYz19cTrFNJI3S7G+0wWRb
	 iEMGAm49naWEEjSF8lNABmmhNH+jgabg6A/mAay79ULms5kXlQ02dXeKgdyAw+BWr1
	 wXJ0ubK7E28S0Yo9VWp0bP4mazly2+/oiQT3io9h+QByA51jwopAB/SKl4gGK35GCy
	 LTtOrsYw/UJEg==
Message-ID: <sashiko-outbox-172678@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] IB/rdmavt: Fix error unwind path for qp_priv_init() in
 rvt_create_qp()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Serhat Kumral" <serhatkumral1@gmail.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261015102518.15780-1-serhatkumral1@gmail.com>
References: <20261015102518.15780-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 10:47:23 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> If driver_f.qp_priv_init() fails, execution jumps to bail_rq_wq, which
> bypasses bail_qpn. Because alloc_qpn() has already succeeded at this poin=
t,
> the allocated QP number is left unreleased.
>=20
> Jump to bail_qpn instead to ensure the QPN is properly freed via
> rvt_free_qpn().
>=20
> Fixes: 5190f052a3654 ("IB/hfi1: Allow the driver to initialize QP priv st=
ruct")
> Assisted-by: LLM
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015102518.1578=
0-1-serhatkumral1@gmail.com?part=3D1

