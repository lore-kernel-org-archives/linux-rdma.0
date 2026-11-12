Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445024;
	b=zMx5QiCUCwKDh54h8NKakvqGeo6pr77Zg03bALetpwnKPeAyvK9tnkD4nJZ+D1ZgBCC1
	 y31l+a48iofIJ1KijZh6KU5Qho5Rru5VlTe1ZcLZuNI6Qqxr2PvsFGEmZRo3rgDCRaqJr
	 soXdMixguNdB8YjB2auCkeX3knoBrpS3vUtmbjBB0jPyGKro+2LQWWU3bQakSGZxZD/Lj
	 mAqQDj3v23Nog0Qivp3Zb7yqtbF6qnWLTFhLHESWqsi29PnoIGNhTeIGfHbLWlDqktevo
	 ghiY7txScldOyzmjYAR4tEAgjTKYAB5NWIF6Gk7vyLSQhIutJtIUxQTY1yUsjMYI20Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445024;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cJB43Vn4gLVZzFCMguckd5uAqjpq2HJ85xvvZGR4Hmo=;
	b=JBlmDxmQSbiwbUFyL7ugzmFd3C1XGSKdCVYtzqcC9Yy8G2Ht7JqrWoWblzZU/r4QWNhY
	 B2Ce7niLavFjM/fYQo8d/CNA1N0aDhhzTY7yrMuDeJcgHdt0VLJCR4AqO7cwvTrIhviFw
	 lQfgv1fN5Z2Z/xS+f6zpaD4GZjg435ZGtOOPCGy/pObbqMaJLuRLLJ9xPtK2zcf3LsBWf
	 Cn139+oziBc6sMlXOs/kY+AvY8HaJQ1TtrfxaSiTES57lHIFeTGdaUIbunbyal4te9Kmy
	 wlZ+iWg0Yuw32ptyQXWCjifgVkLoCyS4rb+jgu5eHeyakaMEuGulquAqFapckZbyWuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J67LJvoW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627F8606A33D;
	Thu, 12 Nov 2026 00:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J67LJvoW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCBA1F00A08;
	Thu, 12 Nov 2026 00:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445024;
	bh=cJB43Vn4gLVZzFCMguckd5uAqjpq2HJ85xvvZGR4Hmo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J67LJvoWGCbfVZsNqdAP2Aj+J7rkFjKcYKXWmW0zRzkOhEEGW5EZB+V10QNj+7cFz
	 0b09DZgGFzzLzWvVqcC0H0NttxsdtDbd2g9ZrzXe1ZaGnwx/SEPghO+Uz+nrGO7DTi
	 0HNADKKJN2eLZkSMQxSvTtkkDmja1L1VI0pC+FIQW+U/B8ufb1zKPERcYMV7opkdbW
	 eAhOAlWc9FbzJ663zda7B3aY0Pv2TMxs/Ydr9AEkNJGKH3qfCcimf30Q3oGJ+u29GW
	 qIrw2i/S0rIV4gpegEcYa+rXr9BYbmg9nxTpBXQ88T1kKOtHwhgg45OX3IvhWXmTby
	 mnKsAnkVld9SQ==
Message-ID: <sashiko-outbox-210010@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 07/15] bpf: don't redirect decrypted skbs
 from egress to ingress
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: bpf@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261111005533.6436-8-toddfreed@meta.com>
References: <20261111005533.6436-1-toddfreed@meta.com>
 <20261111005533.6436-8-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:57:03 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] bpf: non-standard multi-line comment style in __bpf_redirect()
--

commit a5cc3bc1e6d8f72d0aefee8fc281286777a450a4
Author: Todd Freed <toddfreed@meta.com>

bpf: don't redirect decrypted skbs from egress to ingress

This commit drops packets with skb->decrypted set when BPF redirects them
from egress to ingress in __bpf_redirect().

> diff --git a/net/core/filter.c b/net/core/filter.c
> index aca8160b26a1a..a178a9dd30070 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -2226,6 +2226,15 @@ static int __bpf_redirect_common(struct sk_buff *s=
kb, struct net_device *dev,
>  static int __bpf_redirect(struct sk_buff *skb, struct net_device *dev,
>  			  u32 flags)
>  {
> +	/* On transmit, decrypted asks the device to encrypt the packet. Sent
> +	 * to ingress, the packet would read as decrypted by the device.
> +	 */

[Severity: Low]
This isn't a bug, but BPF code uses the multi-line comment style with the
opening /* on its own line.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111005533.6436=
-1-toddfreed@meta.com?part=3D7
