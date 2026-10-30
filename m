Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793385259;
	b=SSUiC6GjfSOSKVx0qNYeLO6Q1efZOSNh7ydMnnrDCYdGhaE7hYVHqhKVKnKeRZ3WY4R1
	 F5C4exGO6EYTP48Tz6ym2/3qYz4V3ZqkhE2ftMyPxlpvKy2cJjvb/J3U7l6vzHX5qI4pl
	 G5NDuILdBDSqYz0nBfOAaqG0/Z2paAQywFQvInOVbquCJQRF/Pk9UCur+Z6OQUM+cIf2p
	 ekaU/WSuPDKJU7nQK4UsNnN3e9K4xT8imr2l0aquNPbhG4Gdz7vBeNHUPxmkxPOveyNfy
	 Rc5V0LjJV9Le+hytngstf0Ztcr4uIWRosb8A2OchYWeWSmJa8dK+XIkOIQLkGtm/vMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793385259;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mZPmwsYSB1ZVPFcI57o02zSqU46o1+QOy/iizr/+8hM=;
	b=kSubRApYC0+psvEUwGH+1TGg/oaC294Jr2EvUrnJ0S58hfwr7iMSinSiGZMH6wQoQg9C
	 ZkeES7dsTY4hQTTNQSKJMf+6k+qQWSYZ10pIwfIj3wczq/8uLXIoIhKjH38Ww4quR5vWL
	 H+sL2+WxJo+zRY/hNzNxWI/RK87okFdLyzLal9LDEiv7vadXXAaszk8snaj4o3WpML1IB
	 9C1tCkwNRrt3buIz/zQR1jvbYEmKaSMNtmtICxjuqAJVwAT/rYzc8dZ8TvaNN+epPiggW
	 YFOlov5+8gKowSs8Im/KCE33I/Xdi/sNg1qXeqBcT4JfasvMUyLPKV04+vffIDPxJdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nkeXwMCh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53432606A31C
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 18:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nkeXwMCh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2E51F0093A;
	Fri, 30 Oct 2026 18:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793385258;
	bh=mZPmwsYSB1ZVPFcI57o02zSqU46o1+QOy/iizr/+8hM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nkeXwMCh94FdgAUPq2mdW6EDCqYZ0TVlpxjDQdhOZnEKI3MVA0BdR2S6cPjMehg3q
	 oBoEySYPEg8cVWo5yMdNvwBzA/hEP93/4iy3bL+bX+nS/kjckzhVDwwgg4Oc8qfvmy
	 UJzxDhm13GSLST38CswKKLOnrOQGWYygtjHJce8fopIKOFwWpXmsZcpIXuiPU4lQhg
	 T6hczihisFCplYsKiupwh9BtzmtkJRr/dhWswIMEryXoqOBYVsLtlXWREsW/NBS6ZS
	 TeOHfXj4fdN1/VOCJgQ6QrEIEoLevdB5nt+/raKR+nOq4locS7HrslTsrNa89hzmW9
	 7ERT4PwJBDABw==
Message-ID: <sashiko-outbox-191413@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v4 6/6] RDMA/irdma: Support UMEM attribute for
 SRQ creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030181512.2056056-7-dhu@x6u.co>
References: <20261030181512.2056056-1-dhu@x6u.co>
 <20261030181512.2056056-7-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 18:34:18 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: David Hu <xuehaohu@google.com>
>=20
> Support the standard 1-step queue buffer creation for SRQ by
> `UVERBS_ATTR_CREATE_SRQ_BUF_UMEM` via `ib_umem_get_attr()`.
>=20
> Set up hardware pble directly from the pinned SRQ umem via
> `irdma_setup_q_pbl_from_umem()`.
>=20
> Proper umem and pble cleanup, and error unwind are added into existing
> `irdma_srq_free_rsrc()` upon SRQ destruction.
>=20
> We maintain backward compatibility for the legacy 2-step registration if
> the UMEM attribute is not provided.
>=20
> Signed-off-by: David Hu <xuehaohu@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030181512.2056=
056-1-dhu@x6u.co?part=3D6

