Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793006913;
	b=VbfQ34zzfg9jmEgHlvVdi4/qgg1ZLfIE/mCkyo0sJY61Twrr+cxEzhPmbHg41CyLcgPn
	 d0CJKlWt/uRmVNxpQqFswDyj8ur64w54g6iOvMqS70WSF0VHIlCB35Yy9pu0KFx7brRhk
	 6D/x0guwkboujcvp0vjhwfS2XG0OqMyR3qJ5SFsAzs5qhqKHl2md+ksXULTMVBX8CTcyb
	 K9r/w59p8xhbiDIjwEZ7qlKgRYLwPn1ncVIDCoIgDD7YwB0p9Y7pEDt2B757u7N35q3qH
	 +1VQhgNAVkF+OAcvnzbUq7WbgmlaC/WV4cbhGYfsGSUDCvkB7/xN8KWLj3Rfnufq5EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793006913;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wwCR1wXxdMK0T/DuwI7do9B/wfhFjfgBNXLtrcsqJWE=;
	b=kycqSkmlSYcJmhDVtbCyFyqqApgOSgPcNba6w81aTyveCCv7/w4wgfye/DFOgQbHgX/4
	 ApcR1poZrhq01wEoixCLlP0nXeIm2DLU/AVgrpOWBPAfs+VfFQ0b5F9G3ZuxV9J8iE5dv
	 TJkRpkCW+5vIRD/WacRrzVN6AL2KJ9s87ApRfcRzK3scEP6YFqnGZnUNDAwUGjC5lVUO3
	 E9LzUvaLalXetblYugQuT7jOfsXlcy3Wsak0PXmwGcHFmXilbeAyMhmbjCDtjeX/+YQt/
	 wYohi+heoG+tSZSa2HEHw3BH25tJQaMDJPmfIyNgJXe+z55Zi5ipVSs+zXgjxagE8fA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k1mGGPsM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D092E606A31B
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 09:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k1mGGPsM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F34F1F01825;
	Mon, 26 Oct 2026 09:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793006912;
	bh=wwCR1wXxdMK0T/DuwI7do9B/wfhFjfgBNXLtrcsqJWE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k1mGGPsMDbvMDPB4l4uEQLWWlXSS2PfqPzm989Mc3YIKkG/lcwf7NdORSwhSZEjpF
	 ewWO5PEUHnueTpOkY7BOhwDKArYic5f9huHl8GkpzHsdcxUrt4SAOcJtFMNS+j9jtt
	 jLdusiSbjRt0wVTZpxE0kHOZiJ46lU+m80hioSbYrIQfYlL/ZoBb4qgu20cMI1lMNW
	 O7aCg/KRknHN3Hm0KqPzx1Rzfi5F+VeLEhghe0dGanBzu5tot4cIM5N5egsAwYGlWK
	 IkJ2rh4KOgmSjRJLB92GNap0cx5aWGnssCGWhkOUFuQwYf6fLW3Em899KtAumaCv2P
	 ZL1GgCDEqgKmw==
Message-ID: <sashiko-outbox-184792@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 18/26] iio: buffer: convert to use the SGT mapping type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026053623.202642-19-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-19-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 09:28:31 +0000
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
> These importer helper functions should call dma_buf_sgt_dma_device() as
> they are always working with SGTs.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D18

