Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97413BFE4C
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 21:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791579844; cv=none; b=PYZ6NF1D221vAbsZmfK3HdUt/RaL9MRE+b/GG4imu0b2U10h5ASFkRar542renU/tq08CwADE83OknFJb1o5RIxm4NFYRVJqJ3nGU3yLP4JwSL3VR4TQ+51KrOPz+pEUNGxERB+2L3EOhhVfgd2juumDzU1aE0JcoLKwnqmH2OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791579844; c=relaxed/simple;
	bh=J/w2/pgB8hOiY5+azvqvBw389R36DDw2OasFlkoJ/UU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=AxSIk4RQl83tlq0fh6KV4+peIC8zIXVXevSd5elhKp0d/SAcXYjP+pBtbOXc2wEz1XCSAQKIdZ9V4aBgeJKyok6X0g20fYodcGk7549mSxU/GkMCG05Whqmprj3YvBO2sCZVrXO7jVwAEhVcPKXlNQkUiE4roYBAZhjzbrAMCV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NwRmkA7C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NwRmkA7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858801F00893;
	Fri,  9 Oct 2026 21:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791579843;
	bh=JRexz9Q2fxs/thx2XS+PjoYVg8EBojt+iaReWmzmF5M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NwRmkA7CZm4yWxVgYi5BIZgFFBEQS7cycww/zxM/tN/cEiEkFDnMfoPc/ny2uTcIU
	 Jv8b40JyLfCcEye8mB8MY2kL7u5xtjCnx5u3uqNS459/AAuv5r/TRHQOebbG9R11Ts
	 J7SbEM3kcl1dEOaUptWu9qwmMpPQxkRGiJ2lqnD9c5np5vy2HtC+I5WvL5EcI4tdoH
	 m60lOs1+9qUSal5J/P7cEcy9Il57DSpPPOecePkuWgYrAAv6avLpDjULRjhNKXrqsk
	 aQku6bdSFH3NMF6lxoKK7eA7opYtlEyuFyLATx0VosLzyAUBsz2FmCJUPr5TMaiV+w
	 EUxQduYXhffdA==
Message-ID: <sashiko-outbox-166075@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 08/10] netxen: use pskb_may_pull() to pull
 excess TX frags into the head
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-rdma@vger.kernel.org, intel-wired-lan@lists.osuosl.org
In-Reply-To: <20261008-b4-pskb-pull-tail-drivers-v2-8-8f2bd9bee138@toxicpanda.com>
References: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
 <20261008-b4-pskb-pull-tail-drivers-v2-8-8f2bd9bee138@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 21:04:03 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> netxen_nic_xmit_frame() pulls the frags that don't fit in a TX
> descriptor into the head with __pskb_pull_tail().  It already checks the
> result.  Switch to pskb_may_pull(), which takes the length the head
> should end up with and checks it against the skb, so this driver no
> longer calls __pskb_pull_tail() directly.
>=20
> __pskb_pull_tail() also releases empty frags, even when there's nothing
> to pull, so if the frags being pulled are all empty it still gets the
> frag count under the limit.  pskb_may_pull() returns early in that case,
> so follow it with skb_drop_empty_frags().
>=20
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008-b4-pskb-pu=
ll-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com?part=3D8

