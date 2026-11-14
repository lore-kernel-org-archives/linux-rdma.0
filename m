Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794672563;
	b=aS8XBfLN6S5CbfGv/s1ham/0EFJePMTc2WGDXLoJbqxDjMoYkenkoxNuJ8Y7byA7YUjQ
	 NI1fY1xQXJ+2vQFigc41P5aM6syRMcxV85Hunc/KiWvwNN3ofXvPNZ5ECZWpF6m9fCncg
	 /nI2OQnYjP66Iut5bvfIuCkzCQeprcc0ucv9m8SyoDv1Cj7uGzfGv79BEDZdB+oTwOHZ6
	 1oQgYd7DW6a8yzvfnlcJ73ZNE99kLBN1UFV2X1QNe1tpgBpcbjx4/E2R4VDIMij9WET49
	 Pf+eEu4MbUxPE/O+EGzKi2F2Y7mTeqRlCRq//aCv2pO66t8IOuBnvd4gW6gFXCPZuSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794672563;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DzZgymGJ8VNOcv0BEoheD/CGeTcywXHG0FCsMnlddfI=;
	b=wQq26Iz9Pt7L+sRXj21uo+W1/5ZuQiwnzg1tSlprl6RHViIVwDXHY2tC5i0UBZd3GRIh
	 0V/1alTf4COIAdrW8NgrccnEE1T2j2PDuQ/1ViIWZLXIeHOxSwLGS7kKGmN6Wc1ASA7po
	 qd+S/d1HrUvmJWQOUyZFP22YpkyjF4uMMpEMB5Scw9fR84JVlIWuDmiIKHWO2+Q3y2Zqr
	 EpoyzYv+8QXKzJEvfMTEyL+FFdHO62tvZlBxUuh2kQ0rP/YrFrx522yTnlh97lIyPbN1+
	 qcxNBk4ue4K6tBVCZZBg+bimtZ2diPRi48Pcg/yq9btztEucxUMIrbhO61o2Do+dh9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gef4O14e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC851606A33B
	for <linux-rdma@vger.kernel.org>; Sat, 14 Nov 2026 16:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gef4O14e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D001F000C5;
	Sat, 14 Nov 2026 16:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794672563;
	bh=DzZgymGJ8VNOcv0BEoheD/CGeTcywXHG0FCsMnlddfI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gef4O14ep8No/Tn2arGJMp/kuebvhy73OAGCC9yDRDQrhlCDgsKeTjF6UrGWZWbR5
	 B9RlheRb+Mv8urD2oXmXXgP1YXoatq4/W38M4JJZn9aSMVLPh+e83XN6GBP7CyhHFy
	 6IlNv+ka6nTUxmu23ynJeRheyzNbsOcw4/ya69l+Qy4Z7dE/0j2Kl20RvKRXCZa/v1
	 nsikE8pU24TZaG4JYQVGlyUjmUMfemHauRyPlgWHMBh0/XAbUyznbPY0UiTWoFR1tu
	 qDCbEaXF8BlBVj5mz8wKhoJQ+tzcYHVLbTHcsxl5KwDpklBIkq2/o9xEFTc/6QQbrF
	 N8laoW8y0oJNQ==
Message-ID: <sashiko-outbox-214738@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] treewide: Use struct_offset()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bence Csokas" <bence.csokas@arm.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261113-offsetof-v3-2-714df7053893@arm.com>
References: <20261113-offsetof-v3-0-714df7053893@arm.com>
 <20261113-offsetof-v3-2-714df7053893@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 16:09:23 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Generated with a simple Coccinelle patch found in
> scripts/coccinelle/api/struct_offsetof.cocci
>=20
> Signed-off-by: Bence Csokas <bence.csokas@arm.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-offsetof-v=
3-0-714df7053893@arm.com?part=3D2

