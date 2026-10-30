Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336045;
	b=Vo40N6BMWdg4SvA2ocrbzKNcxlwSxBTTgGS8COgynoy5mPR3HnfCUM0JxPHhNfdfz395
	 kMh0+EsGehAyUd9QX1ORXM1+hlq2HQIdCuXZmm/UVGua8372KNPnWQ0bhuz8f0DK81IXs
	 mihi6GKr+NJcowW2yp/u1164gP6+97kNixvbdOpIXgOJtYpo119ZdSn5atwF7yqOWOW1d
	 I3Oy/wZG/CV1sIRQGCIzL3R5XNZufergSuPgoSfGyFaJO/ovFm0iH/bKLfV5/UNP+PxZ2
	 mdchYVMX6rXEpgsid2fKgGQkrOMD8gTV7G66olEsexBOYK9iaE5CgRCD68Rz2nMmmLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336045;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nLBjb4F3OeLFw5lNrBCe2Q7rzGMDWKNlWqk4bpqN4kA=;
	b=Zkj60UUtPVLoVj0SaIcHq4rpkSTec6qf/Yxeg6pzI2u4GG7ToeYH/EUQWx8iN39q9Ja1
	 EGAzuKgJaS9myo5VuZUiIyRRuJchS+pLdFfCz85KTMctcV82H6UyhStgr5Qa+7tAXBQH9
	 bqBhyJtW27AG1RvLW1Y0zpDO4vzJJ5s7myMiEL7dRDiJHHgYlfN/338LWZ/nK7dfwh3Z8
	 UJfhPVL31sq4YIKYEGEz5+KtDTttb3XcIZda374X6NNQLV8FrgoFts0Ast6Lp3thoMeji
	 XtjGtts6932EEivphpC/E9fJ0tEFZyMb/wuzoXuEI/0cDpleIyLL7c4MQ7L7vHUA3tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ke7wnBA2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67077606A32A
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ke7wnBA2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5891F000C1;
	Fri, 30 Oct 2026 04:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336045;
	bh=nLBjb4F3OeLFw5lNrBCe2Q7rzGMDWKNlWqk4bpqN4kA=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Ke7wnBA236mNSRXZoUBZN5M0ix8EvZqZPlI9FvenYRXS5AFXKSxbe8oM18KczDdex
	 MeMFvwCgIybL3YYbVzWA8uusizXa7Cd4fYSTxN37FIQlOyJwMjjuZpiU2Wc4+IZLJ/
	 2FcZftDT45T7NyrgI5lm5hc7javr52oQ4dLZKQsKrE7UGga5gFGteJsys3Q8Euoc02
	 4rELEbezkVXrOFjSMhZuaH8t5bBEWsRIDkprRe6xDDtvXAcCcGwh0quwGNppzts/Gh
	 0sggRL971Mg2WRTa5Avr160uQjs58pW9EKAKZfbkS92cgwkxz8iizDbugYauWrKrxa
	 T6bY9XxzGgQIQ==
Message-ID: <sashiko-outbox-190400@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 net-next 6/9] octeontx2: cn20k: Coordinate default
 rules with NIX LF lifecycle
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ratheesh Kannoth" <rkannoth@marvell.com>, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org
In-Reply-To: <20260508034912.4082520-7-rkannoth@marvell.com>
References: <20260508034912.4082520-7-rkannoth@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:54:04 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Undocumented logic change in `rvu_npc_install_allmulti_entry`.
--

commit 905a3173f74be8db2d23362cf0c4656c9ea8d645
Author: Ratheesh Kannoth <rkannoth@marvell.com>

octeontx2: cn20k: Coordinate default rules with NIX LF lifecycle

This commit adds a new flag NIX_LF_DONT_FREE_DFT_IDXS to prevent the AF
from freeing CN20K default NPC rule indexes during PF hw reinit or teardown.
It also updates rvu_mbox_handler_nix_lf_alloc to improve error handling.

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/driver=
s/net/ethernet/marvell/octeontx2/af/rvu_npc.c
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
> @@ -990,7 +990,7 @@ void rvu_npc_install_allmulti_entry(struct rvu *rvu, =
u16 pcifunc, int nixlf,
>  	u16 vf_func;
> =20
>  	/* Only CGX PF/VF can add allmulticast entry */
> -	if (is_lbk_vf(rvu, pcifunc) && is_sdp_vf(rvu, pcifunc))
> +	if (is_lbk_vf(rvu, pcifunc) || is_sdp_vf(rvu, pcifunc))

Is this logic change intended to be part of this commit?

The commit message focuses on coordinating default rules with the NIX LF
lifecycle, but this silently changes the condition from a logical AND to a
logical OR. While this appears to correctly fix a bug where the condition
could never be true (since a device cannot simultaneously be both an LBK VF
and an SDP VF), including an undocumented bug fix in a patch about a
different topic obscures the commit's intent.

Should this be split into a separate patch, or explicitly mentioned in the
commit message?

>  		return;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260508034912.4082=
520-1-rkannoth@marvell.com?part=3D6
