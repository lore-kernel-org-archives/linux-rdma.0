Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793947432;
	b=zWl7Emt9+cnLfDCbjNprR5PM2knSihZpXjfG8oXSEXvAuRkeUlwbR8+MXs/7L/SalV16
	 pLH3q2dsK1EPjkkNLAaRpzMqkSipSh9bmcLmHjmKwFLLQJOuyC9+iJe+a2aj2TTgRFNJq
	 a6/zXcRuKU2b/SXbTG2vUEEJHgoQieQHKkMWUKkCrhkk7eGHFV+NAB5bULgPj2xkVnNh7
	 At2PYmR7bc1YoVVn1Zg+avnRzV4Vl8LiWQUWHUOu0ZM2mZgSK3gLENn6OI8Y4gDlmOqbQ
	 82rzJLb9vdJBH8T5hiEZ2i0IL54ECDDaRYIZ+E0a9Qsjb5Vl5V/e/Tw8smYUKrhAoVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793947432;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ORF4nO3i0uhEbL0R2zv1UUToGtqYIRTBu1yU1p8nwDc=;
	b=Gpg+BjB9y1U3wraPT64yGKfMvzNYOZx8kJJvYUwI4Cv5cy7w7evU53KI+cxJLnPaNHhm
	 QZfRzIwOoH6YbERcE7ekNgJPHtxlW7jaKfZxAxgwg/gvfdtPo8R+dAzbMDCurNRoHK0ki
	 LH4FHrTSGB7uuUEim5r4x/qqZfAqp6qPEUaEezWrdJFI6LFd3QzOZrEmqPcCXXZzi6rvs
	 fckfobMouInUUxgkbRJbVowf/iiK2p5L+wRqYOzbJsSDbN4BU6w4UCEt26EF4sAWRwOy5
	 lbH6YIgykUIIVGKUrVaOLAXgbvY+yFaRKmWzgQIlE7dEeNauz3WM0CV9tRfzAAyulnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="J/czpj+/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DAD606A330
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 06:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J/czpj+/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585D61F008A2;
	Fri,  6 Nov 2026 06:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793947431;
	bh=ORF4nO3i0uhEbL0R2zv1UUToGtqYIRTBu1yU1p8nwDc=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=J/czpj+/XPmSlci4Cr0FmxEhairEgRGr65ItM2bLWNMVocvN2rVcT849Ii81+HmS3
	 wz0kNnrpJ/MslH9l7wPWsuxRgZXC2GINxFI/VmQlQ3y3bof/nLmWHrxWXq+wJ53cN8
	 7U33oxH8gtz+1dL5q/Ti+Ms8oGB7Hf0j7JbrrxTu9OG7bbATUYr3m18TCloGOFK6L4
	 npLAyccoJrEUpxnpMnQwtHiFF8vhf8a8704YqHpKfCaQEiP/KE0G9PcCCZb2tfjk3O
	 Jz6ypr0yZGyG5LETzlBd7iXqyp/YhP8Mpk3KhAIf0ZKdmOMgLLMk6E8TBRvk8+ZJc7
	 TlHuhW/jjlh2A==
Message-ID: <sashiko-outbox-200923@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 07/23] dma-buf: Add match set queries for exporter
 placement decisions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-dma_mapping_type_v4-v2-7-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-7-78b8dc9ae80a@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 06:43:51 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Exporters deciding placement in their pin path walk every attachment
> to determine whether it can take P2P. With selection deferred to pin or
> map an unmapped attachment only holds the exporter's default. Therefore
> determining what is possible requires walking attachments.
>=20
> Add dma_buf_attach_accepts() and dma_buf_attach_accepts_sgt_p2p() to
> walk the match set and determine if an attachment is possible with P2P.
> A future series will convert P2P into a distinct match type.
>=20
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-dma_mappin=
g_type_v4-v2-0-78b8dc9ae80a@nvidia.com?part=3D7

