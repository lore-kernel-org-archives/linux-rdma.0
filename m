Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793705159;
	b=v1onTk88Fy+v23MoJLmQIYfz0lihqK+PlEgZKtLC8Qhx/CjTW/9Oz5DzOZI5llc9xTrW
	 MAnF/qjPBe9oUg5prRWGg5A3sxj+jBKbiGCWAZyHsrj+l+39ogLTCs6TvcFkKu8DbEIhe
	 21anB5os6FlbG7QLAkBqOb642jIFJ+UDUlLRdMksOHH3SWlcgxmfFPYuK4+6rmbUaFk5g
	 Y4FWiLcl3wdls5F5rUaP8OIQpV7khzPy5oy5gaLliSbLxjOmGYwu2GlcUyYW6qn4G/6OC
	 0g8QgbleeC2cO9IbSIog3E5c0EygIhZ+sneDtxWtNN+n3PK7phEQMd+F/KaxeZsZ7Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793705159;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qYs4OzczOI3h4LWdpJTy7tchOcbBqbeAtSmHDc3q0w4=;
	b=LmfQguZTRdenkgNMUuhc4SbJ0a3C7XlPmKTekHVGvnnr9UOUImrHkeuyIfuFCpj8ClXr
	 yS/lenOIF2ZfzMCExh2YNecIsVAOHkEPwXjSLsyzDpo25lvMHLJD9ahCM0Cm3Ck+z2Cq+
	 fdfsIXbMs29r/VM9ttmudFpkakKRWYfPUP0KrK105l9BusHoMjNJu0YvVjOJRAz68uUUn
	 A1v4YG34BO8tUq7dam8viSjCLGgzvnlkizazl58fU0EL0Yq+wQAb/Gicbj6hy7cbgjDiW
	 iFUmLi/SZdAXhSH8a5aXRcVWviqMmX1gyuJlDaySHaoceVHOiABlKc1HVzyY6PsoXNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cu24a4cm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED073606B10A
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 11:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cu24a4cm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC191F00919;
	Tue,  3 Nov 2026 11:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793705158;
	bh=qYs4OzczOI3h4LWdpJTy7tchOcbBqbeAtSmHDc3q0w4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cu24a4cmErcL/vf1GGIkiJRZnEJrGgORLIYjIvDEHfoBosyzXIQf+bCNl3B3TozS4
	 9KphaBpL7duuuSrJZvmEIAlnN5pzpZ3TgLhMrqdPJVq8dbLph5V1XwYMnlZ/1L8yXz
	 TukgmZoVMv3YjK1n6/ra8L2N7YXG+AJ138Ze95GqEkTFNMoQIus+VPMHuqsqPQRig7
	 RWUo2cObbQ2p34MFbF9I5/7Ves/2y/KDtcfIADA/9GA18AidBfPk+ZfC4yG1LtOaHE
	 jbmWXTYm2kbSKowT7lRKvztKRugthBTTG5QxFRsqvmT59r66zGv6c50eudNiJMsl1m
	 OV+HRc50lT+ZQ==
Message-ID: <sashiko-outbox-195144@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v8 5/9] RDMA/mana_ib: Post receive WRs on
 kernel RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103111729.729886-6-kotaranov@linux.microsoft.com>
References: <20261103111729.729886-1-kotaranov@linux.microsoft.com>
 <20261103111729.729886-6-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 11:25:57 +0000
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
> Implement receive request posting for RC QPs. When posting a batch of
> WRs, ring the doorbell periodically to prevent the u8 counter from
> overflowing.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103111729.7298=
86-1-kotaranov@linux.microsoft.com?part=3D5

