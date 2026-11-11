Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794400691;
	b=Gq38T3TVHdeyE+1Xi0dcI/Rizr96GL6O4LGmFZM4xpD0yk/7zYibi5PdagGjJBjaKjDC
	 KKnAU6n0MSAOrKuOmfzq+PIQPOGgQsoUtJifFyz0uI9y4bh7WkDIoUualjVbrtGlmIxjn
	 7SFlfKV1gsSEmNPgPVwJ/Q373poO3MebhgtKyNpLtDU46OSyBTVSXew4+vxLLazQbjwVQ
	 LQRQuivylWlGltEs9a+h1sGWysFU8Tr12HVr4tOCtFXF24d/cvPsN0Ddt2vwFyfRXHWKe
	 xbpgjsvQATiEWZ92B7q4g+6EA/pkt4oGer5cNpyF8TeBFpcmNGjZ5ilEBqyUP91U1wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794400691;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=g2UkT8bTNeAus7YOpTd2FU94UX84ezHKvtTPA6XlLbo=;
	b=HvtIlifC+6Fer7xMC64ojWWnCtYUyp7e7x2Cx3/vK0NsqEL1XHE0nx4whNKnSR+CPTNI
	 CbaTxP/evDBtW6cM7vQGJcdtcurdfj6tGCESlcB+k23wTV6O4sCuF6C0sKrK9/Tz9UGhU
	 tsfLxXk1m7IurlWy6EPFCjZZ84zNRzb/3GUEQ42MCjCLtRoM6gdIT5e2CEfBryVmnU862
	 bFtuRxte/ss5EPurGWiQ8g99I9t3S9UUU/6fKStndYKTm0aKfE1FOXYJ7vOFU30Q/Q6ql
	 E8RXH4w+O/NTzomLGDjFRL6o9Ur+tUAZD0Td1aZnUQ783uzENMDuJLnvf3O+nugYpuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cCd5H8MD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE553606A8AB
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 12:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cCd5H8MD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED6B1F00A07;
	Wed, 11 Nov 2026 12:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794400691;
	bh=g2UkT8bTNeAus7YOpTd2FU94UX84ezHKvtTPA6XlLbo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cCd5H8MDTS24dojQAfMFHJVW/Azgs+eyzRJo3mGDGagdFe1eUohea/8pZec0iAOQ+
	 VCn8uINSJq3tBq6vqZaTOG1cfYBVp9ehe2T/06Poh6tPldPf0BeEZM4dVyotKk0DHt
	 LQBb6ikChlROWug91CH8M0XR5Ro0JUO2Qn1mZBlDF/Vy/wd25yf7RjIXxdVZsbKZVV
	 3vhBijXbFHaFxZSvxrvt7/cH4T2xne/YJ+V1L5etUue2J4zAUijZDEjhwxXVb7f+p4
	 yGEeoCywfS6+lPO1leXBl2M7UGef1tmxZVO48Tmz0znZ+Yq6F5uZueKgaDEmMpbmGc
	 gc5yQxqY/GiCg==
Message-ID: <sashiko-outbox-208989@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v10 1/9] RDMA/mana_ib: Allocate and map
 fast-registration MRs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111121417.1265896-2-kotaranov@linux.microsoft.com>
References: <20261111121417.1265896-1-kotaranov@linux.microsoft.com>
 <20261111121417.1265896-2-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 12:38:10 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement alloc_mr and map_mr_sg for memory-registration MRs.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111121417.1265=
896-1-kotaranov@linux.microsoft.com?part=3D1

