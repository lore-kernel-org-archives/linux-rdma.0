Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794994190;
	b=RiW2S+KDJN2C0QS3Asil4Xe42A1g1SjR3qMtSsF4tPZ3nPfc2xkq2J/kurVbn7DpLYYK
	 6jonOqn0zwxmVuHOWfpD0fQP4Ud559Jf6GxlsEjD6o744IUebJxJEZbGiZYcWpnZGRLjd
	 Gm5JtGHn0Lat6aUbDf2tY1208I2A8I0mYI8knF5XsNYUyQWbhHpbmZTt6kN61XRgBfmsn
	 uY0CCvT9hy2ymU4kokGMaUQLhGYNzDls2hhijxeQOK5ThQMgFBF6gLAmijB4J6SRf1ifG
	 4cbO5/aPt3MpsMp3koNuvLeDsYp10nQkgp7SRl83cWHkqACwWbXV4X0CvK+9Hweuo3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794994190;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GSYrRzh7iy44MiKyAHckLLJCRxFFYB6ulwBssTO+Ltc=;
	b=kFUqZeT8wq+oyy2MooejroUP/lbhYSvAQvJTOXVfQJ/YABiPB7+PuoxGvlVwfeLKamUE
	 YAP77LRy0L2eX0xT0trB4paTa9TE/JpXR5aLSCwSy+LVJKX5xlGJKaqQddO+GropjjcgG
	 ihBHFJICF/ccJfeZqdjDwqUuR1FRxtfmYlQ0QV7DQL3Bb1r0O5tbx6e90L0GD8IrfUYBX
	 pnDQ3Ctnhhy7nEwuWjuLadb2wB/o05dPCoPzASnS8pymVVqWdP/JJSKXjQKzsFkIlJcR6
	 yWigttSuPYQI4DX+ylmPpmo8XKaUorh5/OpiNdZQwmRST5gdz5bdfErzJwCRg1+y2Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QwDG+kql;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7C8606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 09:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QwDG+kql
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25B61F000C8;
	Wed, 18 Nov 2026 09:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794994190;
	bh=GSYrRzh7iy44MiKyAHckLLJCRxFFYB6ulwBssTO+Ltc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QwDG+kql7KkPUiIrrJ4JmUBj6MCq2iGd8P9LTfV1nGL8smi7lIZErluc50QEgxmwg
	 WgEtz2QF95VLcD9mpnv67BO67AMRZ623Sih4/z88YyZNmvr8O5RXJ17W3K0ttWFhjr
	 xOn9dKmSlwj//2icPnqkBNPLzle9UQFT61c14rGYwQGrU2vwNjFauQ0zUH3qfEIMyF
	 zXbXc0GQgB1o9hZa3x84EOGG5W8goZ2tVDCROUC0OOqvrsmQiWWbt/D+NXcxPL96Fe
	 xsTqMmPebywhJm+ibR4heC8F1pp3TpNvOxSqk/tqQRFpoN8AVszLtjD8osuOiKNSzp
	 XsdArtMtfIW2w==
Message-ID: <sashiko-outbox-220562@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 01/10] bnxt_en: require an exact tunnel id
 in TC flows
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117092915.255194-2-acassen@corp.free.fr>
References: <20261117092915.255194-1-acassen@corp.free.fr>
 <20261117092915.255194-2-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 09:29:49 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> bnxt programs the value of enc_key_id and never reads its mask. Flower is
> about to accept partial masks. bnxt would offload them as an exact match
> on the masked key. Reject them like the other exact fields.
>=20
> Found by an AI code review agent while auditing the users of enc_key_id.
> Build tested only.
>=20
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117092915.2551=
94-1-acassen@corp.free.fr?part=3D1

