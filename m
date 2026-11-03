Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793705862;
	b=BCO9XXfKbmS4drRzsCUsf/BWdhoeXbesvrQY7HvKELDkVK1tyTZ0GzDnnIktWDItozls
	 xqdb8qCUMYi15dau5y1tRUxWzgAe9Cg9UvS+m/i1nUOoDfnPmfSPcNt+VfXt4N/LTUBDb
	 CBo9tHKtsHNfzhZKAm/3whJGo2ld2dJeE2s0cfYuSTkIAwma/E9xUrAC9fYv/V5QL61Kr
	 4SrncrYX8whVHZ1WhdVBbsD4gK1F0ISYffK+HAPxSt7R1mWFHlz7fLqr07+Rg7rL8S94J
	 J4rWEk6amTamkioVbbXDiyJVpXbIbiSwhfDN0rQ+cyK6EWDYV0Frgi8BuF9K6UUrong==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793705862;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+EAHYzrAn2SOhztFeY5yo+UlyJUVgn/PtideOkNUq7w=;
	b=gi+fP7wM+/+Ff0or3GEuE8LiaFkX716Krr6CoBrdJS/UICveXDmUnLupXYay+8ff52pe
	 1o37e+PoRJXBro8mIV39HP1m9xXGdq60JmG8VeRqY+iHvFuhdpay5sM69Kz2U+aEwZSDV
	 V65Vu6lwMBzPUUeCZfOIe+3CW8WjCSbYD6lxtONOwjZkzEA0s9XplelyfFbhteVLbylfR
	 6hoUcSahxM/kssk5JX/rol3NC2Jph/HYj2YrP88S5DrkWXtLsyItIcwOmBihGrDhpgTmi
	 4yBs66vv3FlNfpOboIYYI02K+j09B4TX4OeWHwChKZxtPllgfb/QYcpIWbYYfz/ya7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gau7NlXl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB527606D808
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 11:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gau7NlXl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209341F000C1;
	Tue,  3 Nov 2026 11:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793705861;
	bh=+EAHYzrAn2SOhztFeY5yo+UlyJUVgn/PtideOkNUq7w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Gau7NlXlM2rdOQ4sWvVodDnFsYawdZ8lxyH4UVV0bPgXaD0S89stkfzmkrHIvZiJH
	 Vo0RNGUpBxPPQseT5baoufohihp/B1qV6vEaRaUcbW654ixVmzb7OKfOa72VnbAQke
	 Ia8Te+JTUKqZTiRnolp9aQA0zM/ah7hlB1E2VBBxIj+/6c+mp4T9zK+zus+Qb0RYCl
	 0enKnaJZxihPsSUq6UbuzSGL7ugMWlh+IhN3GkyFHtMRvE5JgGK9lyd6XlQOkO2hCJ
	 OAeOaJKkGiyQyFvNWcins+RzEYdsMV8qu52yqa1TLMSxwHyPl+i4mcDUgXDerORxol
	 Uc+8vikeCm9QA==
Message-ID: <sashiko-outbox-195160@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v8 6/9] RDMA/mana_ib: Post send and
 memory-management WRs on RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103111729.729886-7-kotaranov@linux.microsoft.com>
References: <20261103111729.729886-1-kotaranov@linux.microsoft.com>
 <20261103111729.729886-7-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 11:37:40 +0000
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
> Implement send work request posting for RC QPs. Post communication WRs
> to the send queue and memory WRs to the memory management queue.
>=20
> Advertise the memory management extensions on adapters that support
> extended WQEs.
>=20
> Annotate the immediate-data OOB fields as little-endian to match
> the encoded values and avoid Sparse endianness warnings.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103111729.7298=
86-1-kotaranov@linux.microsoft.com?part=3D6

