Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794290487;
	b=FzTakbmJ2TGE1pgLz1AbcMxRTXYsFxmLy6jAeCBbSLCevoO/tuqtXMD/C9yOdnOK6KT2
	 UBMfa8+auAjjWqPuG+HiyUzeFFNt8VFDLZ6jQltafD406Lq4ScCzkvDyHIiMGorwUcW2B
	 VEerZHieAR0gLOV8Cfg5DOP4WpJLZjU5aAGwE+zJhR2aJeYajsCgN+BdRO9uxmCPuChXa
	 /E4DL/MwFACgJWkM5Bo+fjqls2n/hpeq3g4OSp6lUAA8N/yEgtll/Oo2+6B+rGdGOWv16
	 OY5NPzvnrftOkZ658zc0hgOBRLd2qXdc0gw1DjbakP7LE2/UDs1/h865x4HqkN/ZXEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794290487;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Z5KjUWT2IaDFzPhy6MWnYmn0Q7dwpB4eYWLJ2Wjo10o=;
	b=C8V5CmMFoNtrZJ0ggKcBpg4fxg+W1nxiKPnFjpR54zOeBo3GFLt0KhP5qTITjgJ19YlA
	 b9X41esNaVdYyc0VdMmoY7bdCX3BXSa/OROu9ds8on12HlRNzAx4f46XfJNRUwMXh8p8Q
	 DwVtEtlmDiwUPbPCHwnBsk4h2inIW9JgczFEwGbeZDVknWZ/Qfq92JceXaLfQYuAb2BPN
	 DYFPw875qUEPwrvdIoBLH5u1nSddsxVmwkejf0a1NfoFtqR9Vtj4xHHOk/8e6Fs9/sNch
	 SvLWFgngCzndwuktoAEj1u3lXbrK+mX/+gi8/cJ2JmDJ8aZGXAcpONkYwKORRmCHQ1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WLW5nXxW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E921606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 06:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WLW5nXxW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3F21F0089F;
	Tue, 10 Nov 2026 06:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794290487;
	bh=Z5KjUWT2IaDFzPhy6MWnYmn0Q7dwpB4eYWLJ2Wjo10o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WLW5nXxWk24E+Iyd+gPZRWNRmxtBYLewwAKPfUiirSTfDjx1ftH3jgWfDjunCnwh/
	 KjbChjfNi7aLPw3C6+rQ7Ixk9ZXayIckpw8tNJpadcA2Cl3m7TiFsZWOj85zPQODDC
	 zni05+7N8ZNNARqDygCUslzdnqNHbrzDlb44WfrI0u0GAbrfkmMak73RCwIuupZvGa
	 yhZ0jP361Zr+OftSCPchhW4Y6qRD/KD5Qp+1orkJcdKdsT6AtKo/uUalrXSgxLlYrx
	 R96D3iCEdVbcOtAhczx9qIOKvqi+ei9AdKcVJCbY31YO5xMoUirAhAN9UKxMdGc0Pw
	 MU3UsNE71Zogw==
Message-ID: <sashiko-outbox-206385@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 12/13] RDMA/core: 64-bit memory keys
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109-uet-ib-core-v3-12-3e7e7ffed2e9@broadcom.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261109-uet-ib-core-v3-12-3e7e7ffed2e9@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 06:01:26 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> A device whose keys are wider than 32 bits has no way to name a region
> through lkey and rkey. Carry the wide pair on the region and return it
> from registration when userspace asks for it.
>=20
> The attributes are optional in both directions, so a kernel that does not
> know them ignores the request, and a region without a wide key answers
> zero.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-uet-ib-cor=
e-v3-0-3e7e7ffed2e9@broadcom.com?part=3D12

