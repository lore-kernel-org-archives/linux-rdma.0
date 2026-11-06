Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793947430;
	b=G3iCede9Y1b52iQs1F3vTVDA8Nta96dnUxuOiuqd5UDR43Rh35FInQUMz2/wEpK90geK
	 zyxqDpF60rVT6nBtCia1bKtNljb6G9WoIi82qVYeFatEmVOKkwxnEpAPRVi7xi0I4QiFW
	 r7E2DirBR8pQRMOh7dTGkaeLId+dECKmlUg3B8BooIp9FJx/rbOj/gJspvn91QO3qEgzA
	 rhWbl5GfIdJtCVzWXWiod67DM3UVELGVnZKZf61VRjbDSJnu4wdApXjmqrEWylt2gU1H2
	 Q7Bpz/PCOoxFb7E3KoYOt57ofkW8/GE8OstQBwMxG8FIDJOw6IwRKaEDl8L+D91LM7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793947430;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1yNfnyw91DLMFdrC32IRytKrdDwbpIqLaWcNcKGsngc=;
	b=iKs+5Awxdnw+uPA6zQly2f9jLZx3z6C3tyeVlRFYPJsRQF3rWbPfwWrcIGXZpNiLQYxv
	 RpiFXSzTJy3Nlc+BqtkeM3/KioayDNl/J2Qt3U0ADOTPibH8M9jP77b3u7gdyEl5nHAXL
	 cl2ijo3mARHKUQCME7c9UrJEA2jddgHqj19hcRt0J4QuVVOvKrCdlxCDKg7RcDLTEWqhD
	 dGy6ZVsBFJQ9Cu/IF6GFXWrfuhXmrp/TU1JD0p8c+yru9WWf8rv5YAzNqS0S3D4sm7/im
	 98FNTKOEowLnP31FWBkc7Xfo2ulrTAgctD907i6I0weQ4hXm2N7Ou7XNL45IKwxO5FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TI0Lzi5F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4C0606A339
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 06:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TI0Lzi5F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1BA1F008A1;
	Fri,  6 Nov 2026 06:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793947430;
	bh=1yNfnyw91DLMFdrC32IRytKrdDwbpIqLaWcNcKGsngc=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=TI0Lzi5FJiMchmRfGpbZGiocrJBSZ1jN5/Z4E1592hryb9j34g8LCnV2tcu/PHtCl
	 G2QUGgqnyKqnyEiqeTylFScAb+v5bXH/Y9XYiWoOqNyrxnkrVAQDNkydhEbBe4XNk6
	 hvbMQ54rSVLF1r2HiqutOeL4DxzOSiRKcWAyVNwMh6Q55GxctDYWM5+pV899BvaQsU
	 b3jcgYh9JigriiRP6cJ2TkPZt9qfyzD+8COkBEkXTHuO0I9qB+wq2UwIyWlaH0EwGD
	 o/A+VNIS5g61IKeE9EzF6cGwRVsbZWrNSJun3NBAZhhlp7pV6bnzjYgxYYdHrjjJr3
	 QGzXEe8J2VHgg==
Message-ID: <sashiko-outbox-200921@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 05/23] dma-buf: Route SGT related actions through the
 attachment's mapping type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-dma_mapping_type_v4-v2-5-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-5-78b8dc9ae80a@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 06:43:49 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Jason Gunthorpe <jgg@nvidia.com>
>=20
> Now that dma_buf_dynamic_attach() ensures a mapping type exists, even for
> exporters and importers that don't provide it, route operations through
> dma_buf_attach_map_type().
>=20
> For map/unmap this will go through dma_buf_sgt_compat_map_dma_buf() which
> calls the same attach->dmabuf->ops->map_dma_buf().
>=20
> Move the debugfs processing unique to SGT into a callback too.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-dma_mappin=
g_type_v4-v2-0-78b8dc9ae80a@nvidia.com?part=3D5

