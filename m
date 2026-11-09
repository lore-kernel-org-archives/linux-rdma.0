Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794234432;
	b=yEaoYfmi/aTUC0CMpJm718GdPeCnEYLSsOJadEQEVGXAv771o8SS0fSo6GVWQshnO/Zm
	 AiJDVn3+zFRKzthiSowQKTOAec4WfsJ4kwMRd+Ou++XWkuk3kMsglKSFEzwdz8UO6xaQF
	 t9UY/xG3IlUQyF45gn5IMIHPy+TZuxE37/Ph8pR18cSaYZbPU0Vp3rB1kTDDeR2Zq9jzm
	 WTDJrU++bhlDZ0wX3BJrDRn37Igq4M7dNYXJ0jyVWOOt00tHsTkau/u3Rlljf9oNGU1+1
	 DyEGN47/Wg3N3RiTrWasLmD4xVaychlydvG0hA+vwUigVtVoUpoiir2OejREB2CK8zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794234432;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9P6LPlIyeSlbOABbVEor2Q+FFbF2lhjgw82jctC7RAQ=;
	b=V8qRyrBcZYbz/EeQnCixqKNn5FInLUwwOZcd3vb8eLWIzt6J/7yYpa1ExIADXjFW4x6R
	 a3adfmmd4R1+mGaUt9QYSrmk3KuPksaAUd5+95YunGxp5HFDVG8bzBaqxYYmUIxLFbeGy
	 ndAuTylblGZyEy9luxdL45ClJV69opu2r4ArIk0LENFgZ3C2eWQFeIpEEp85bVdPS0E0A
	 OHYs1NvZLM/KfMY43s3yAlgpLZRHiAGEmM9apWUaWP83+3mCHQu62T62w/NRiPJPi0JP+
	 GfOjnRsKajTEJ6s4djOP1YAk4joyW5N1Tt5Fy88fp88uJCKKjj41Nh6y61LS6V7XpTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Ep3jpS/n";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D10606A331
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 14:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ep3jpS/n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975DC1F008A3;
	Mon,  9 Nov 2026 14:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794234431;
	bh=9P6LPlIyeSlbOABbVEor2Q+FFbF2lhjgw82jctC7RAQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ep3jpS/nk18srktSzdeI97hVy/rdnb///itnA8vDWn4zkavc4LV/0+uINDY77OL2a
	 vBhNw9DlXmiAKZgLr2tItAAwBEm50lduU0/+KZdPUOKjaHeLedR0wVkEFDuxVzV15b
	 4I+nUCXFVupEk/IVE9Gc7xDZ4FNvAHCH65kSwgYNH45dMTcn4eWHoirgh3P+7odmk1
	 tZzF+BhGTQfyVfeiODhvgnteIsq5R2z+NhLydt238GIbB6EMWAW612CpChg6IBSlqU
	 WGM5WYUSDB+LmZyQxjDry50UDZ0015yEP+LN2cuK86DaXoBB1qVplePP89e+R4ONWc
	 qAMPNf91az3bA==
Message-ID: <sashiko-outbox-205096@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH ipsec v2 3/7] xfrm: esp: use the current sequence number
 for AAD and offload
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261108142652.1330952-4-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20261108142652.1330952-1-Jeremy.Jean@oss.cyber.gouv.fr>
 <20261108142652.1330952-4-Jeremy.Jean@oss.cyber.gouv.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 14:27:11 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> When a GSO packet is split in software, esp_xmit() and esp6_xmit()
> advance xo->seq before software encryption or the handoff to the NIC.
> If the 64-bit sequence number of the segment is (H, 0xffffffff), the
> counter becomes (H+1, 0). Both the software ESN helpers and drivers
> such as Chelsio then use H+1 instead of H as part of the associated
> data that is authenticated.
>=20
> However, the ESN 32 high bits are not present in the ESP header: the
> receiver reconstructs the 64-bit value from the received 32 low bits
> and its own replay state, and uses it to check cryptographic
> integrity. It uses H for this packet at the boundary, so the GCM tag
> computed by the sender with H+1 fails verification, as it is different
> from the one obtained by the receiver using H.
>=20
> Use the high bits saved in esp->seqno for the software AAD. For
> hardware encryption, restore the current sequence after skb_ext_add()
> makes the secpath private, leaving the shared counter advanced for
> the remaining segments. Restore both halves because drivers can also
> use xo->seq to generate the IV.
>=20
> Fixes: 3dca3f38cfb8 ("xfrm: Separate ESP handling from segmentation for G=
RO packets.")
> Fixes: 4b549ccce941 ("xfrm: replay: Fix ESN wrap around for GSO")
> Cc: stable@vger.kernel.org
> Signed-off-by: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108142652.1330=
952-1-Jeremy.Jean@oss.cyber.gouv.fr?part=3D3

