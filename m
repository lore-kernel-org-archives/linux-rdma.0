Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316260;
	b=0AEjxxPQ9s820Z3Ndfe9HOQXN7UJgv2OqF1LXZUV+n9b89Yzk+H6znAZAZiyC7JZoBhd
	 Ry9U12z+aCUp3kI5CqQ1RdttduE+K1+EXKZ1k0vPWVyWoJ6418M7V1/wQlMtvyMRWwuex
	 aVU8/Hp38Q9sv+nnnsKtA2uW4pz0C1Irkp0MCK+nE9/OyXxTQQimwfJX19FWKSJf8OZ+O
	 UokVJbOTQsHAn05d5eM83CL41H748XuPSPcKQJQIV6RMW7UX6wQxK2G9giY6BsZ9zri4E
	 NA06c7LMzkQ1lIjfz2bBb18JB9ZGxllEGP+LXYg3IgTibML6lPtN0hkBoVrKTa4I4Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316260;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HfHOZTbOLfSwFLXtVQHOYKqrv9V4M0Ek+fi2yv2YtzE=;
	b=uh7tbSfkdO1DF9So9JMIgC6cJt0D1jgUdwcRpZ8rSv51Q2sQp8KDrXBYoL2I6fwlo14M
	 Jt73EofE9AK68BGY0k3FTY77lpL4AawRRqj84LAK2T4ljBLrvmZQAtuM26HDj24dvInHW
	 jwxegkwmogFhVzewliJ3WqZrAz3c6eaMVfz+ZpdrmY/Oi1FnuVwN52fzhc27VhhDav+/q
	 VBH8TIVpZ5JNTcyncWDw8NUO9pbXrSE3LIGwyu+JkImMa3Jz72Wyh7jmpf02r2S2rdOoB
	 FTRK5JqXAKrQ+N1+JrKyCg3x1acUcq73AmiXV5kZAC7lFOKu1gt5FYKdmUOCzVY1P3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QxuaCmNf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9822C606A338
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 13:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QxuaCmNf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA5C1F008A1;
	Tue, 10 Nov 2026 13:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794316260;
	bh=HfHOZTbOLfSwFLXtVQHOYKqrv9V4M0Ek+fi2yv2YtzE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QxuaCmNfN8moGWJsAdUN6znEviYPHvKgJqPQB1C2Y34OrRQuIA+7qu0jfPrDCrURx
	 y9OTTxkXJCOsiWqiWdlmY6vGjl5lcMw9ie8yNl2c1TFdW0UQDm+MJOJA7KkT2y93T/
	 XnwR/B7hFUkoumHFKggrTsr2uLzqmiZ2+dOlchU8q8GlG6kPuX97N/hrGBCZpyZHOp
	 1FxgJYLRQA1dKbRrARGWiFYFW8Zn1NGkhKFXjLtDhjAdgOlMnzKpx41diWOUO/Tmyd
	 1xP52nRZ+LCLdqgjASy5L1cM4EVJ74Ko5m579YdBA100Q48RzR55kcaPbssrQ9nqxV
	 arCPu22Q9eINg==
Message-ID: <sashiko-outbox-207091@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 02/10] cxgb4: flower: refuse a tunnel key wider
 than the VNI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109131039.959438-3-acassen@corp.free.fr>
References: <20261109131039.959438-1-acassen@corp.free.fr>
 <20261109131039.959438-3-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 13:10:59 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] cxgb4: unvalidated tunnel key mask in
  cxgb4_validate_flow_match()
- [Low] cxgb4: missing Fixes trailer for tunnel VNI truncation fix
--

commit ffa1601309a5cbc17d72770bb794d0648b47f21f
Author: Alexandre Cassen <acassen@corp.free.fr>

> cxgb4: flower: refuse a tunnel key wider than the VNI
>
> cxgb4 holds a 24 bit VNI and truncates the key and the mask of enc_key_id.
> An exact key above bit 23 already selects the wrong VNI. Flower is about
> to accept partial masks. A mask that only covers bits above 23 would then
> clear the VNI mask and encap_vld. The rule would match any traffic its
> other keys allow. Refuse a key that no VNI can match.
>
> Found by an AI code review agent while auditing the users of enc_key_id.
> Build tested only.
>
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

[Severity: Low]
Since this also fixes the truncation of exact tunnel keys above bit 23,
should it include:

  Fixes: 98f3697f8d41 ("cxgb4: add tc flower match support for tunnel VNI")

> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drive=
rs/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
> index 3307e50426819..d9a509be5c517 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
> @@ -316,6 +316,17 @@ static int cxgb4_validate_flow_match(struct netlink_=
ext_ack *extack,
>  		return -EOPNOTSUPP;
>  	}
> =20
> +	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
> +		struct flow_match_enc_keyid match;
> +
> +		flow_rule_match_enc_keyid(rule, &match);
> +		if (be32_to_cpu(match.key->keyid) >> ENCAP_VNI_BITWIDTH) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Tunnel key does not fit the 24 bit VNI");
> +			return -EOPNOTSUPP;
> +		}
> +	}

[Severity: Medium]
Should this check match.mask->keyid instead of (or in addition to)
match.key->keyid?

When a rule matches on bits above bit 23 being zero (for example,
keyid =3D 0 and mask =3D 0xff000000), match.key->keyid is 0 and passes this
check.  cxgb4_process_flow_match() then truncates the 32-bit mask into
the 24-bit fs->mask.vni bitfield:

drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c:cxgb4_process_flow_mat=
ch() {
    ...
		fs->val.vni =3D be32_to_cpu(match.key->keyid);
		fs->mask.vni =3D be32_to_cpu(match.mask->keyid);
		if (fs->mask.vni) {
			fs->val.encap_vld =3D 1;
			fs->mask.encap_vld =3D 1;
		}
    ...
}

Because fs->mask.vni becomes 0, encap_vld is left unset and the offloaded
filter matches any traffic allowed by the remaining keys.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109131039.9594=
38-1-acassen@corp.free.fr?part=3D2
