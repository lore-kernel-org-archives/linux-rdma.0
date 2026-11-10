Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794286167;
	b=WbWVKxZZhRFbR7b6epeWsIpPPmaPTbsC9Gsl5RfqVSyq/fgsOEOEcqDcm6w14z8md9ir
	 GagsEUX1VXVTn8vz7TaPSQOZNyQWuMumPez7q6muw0et+PO2cRr7Lz+LCObFtXK3HVMB6
	 LQ4gqQUO68TsFSh9OMf7fz3GJ7066bmdeWpamQcA/JHOmpuSQDilbtxIAlaNHKto51WF3
	 8YaTswU3R2IqEXSdwnJHWNhQP7N9ubxMruutM2GO9L/H+HzRLBlryPzLtgzOaBzOnLDIV
	 Grkgpss7JWolgXqnR0E9zbyMHd7ZnfTwvqzzI4SB1dIlzqf5fUdfXkIwhty5Pva6swg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794286167;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=dFbkOJa0W3vfkreUlLXG84bpyCfs9Ae9uyQ/gpG/Fi0=;
	b=PxBx3Fustz+aydS0GtUCLEHXTj8ei0Me6qvEmHrxhcnn6mTLByrpUYjb+kUrmUpn0jrz
	 nNOwdNJegPYOvtkbk7oZaUeNTlVEtNJoH2+mAZFztSLF3tSR6rwSAAlPsk9voArW6kgPF
	 h654RPWH7RkS1Jv6741Ozx4ndMAscTzo9zEggFtq/DUUTlpzEAE5+sV5/OBpiuFOqRT3r
	 Hw7ea9bO7oWBId8Tm0d0NXlr4NRSuW/nHACXyj/ScDghyUl+JCzTRydSr+fGUU10qyOWx
	 temFwGPtC9BOWrKuBkuvxUhuyAHMP7NG0+xaZDA0rnxQ5nt+Yta7QOKOpGAGBZFtsLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gs93E3JU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23089606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 04:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gs93E3JU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB5E1F0089F;
	Tue, 10 Nov 2026 04:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794286166;
	bh=dFbkOJa0W3vfkreUlLXG84bpyCfs9Ae9uyQ/gpG/Fi0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Gs93E3JUOZH4iY5a4y8H5O8LxleOdOn5ENaXvyDLqQ+2EJVTYJWIq0mfaUs5Kuj0I
	 e3JypQWRBrSeGcj6R+ahC/P9cd5tuwYkFVqMo3P/uDzUB91DzkUkN1RWzmUMOMu1ay
	 JCpClGTE22MtWa9wjTGB4nBuZI1w7gK7bEE8h+aAbKZ3vYi2xqIgSiwq8lWYDuY2FW
	 uAFi9CSAFU4FmdpM2eNKmX50V+bQ9i572jo/2VD1eLDt8u0TIgD/f005dxFzPpaVLD
	 xXxsnASMQeennQ48yXN/8ZBVUl1KZ0zgxIlvXJP/xrMg2ZhHOxQs9pnf3HFKzh9SqG
	 IKvz7g/wPHCsQ==
Message-ID: <sashiko-outbox-206242@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 06/13] RDMA/core: query the semantics a
 queue pair type guarantees
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109-uet-ib-core-v3-6-3e7e7ffed2e9@broadcom.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261109-uet-ib-core-v3-6-3e7e7ffed2e9@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 04:49:26 +0000
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
> An unconnected transport orders far less than a connected one, and how
> much varies by device. Add a device method that reports, for a queue pair
> type, which operations it orders against which and up to what size the
> data stays in that order, the largest packet it puts on the wire, how
> wide an immediate it carries, and whether that immediate consumes a
> posted receive.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-uet-ib-cor=
e-v3-0-3e7e7ffed2e9@broadcom.com?part=3D6

