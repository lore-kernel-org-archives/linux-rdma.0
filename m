Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793611885;
	b=xF7A6/8p76PxbNErlfG7G+6RTov21Kx1jI7rNHC4bbPcwxarH/mgsexYBozKASiypJsu
	 a1WKqSqszzA+nFr0v0XX88KOOxo5CAgraxGgFwF2cTs23kgpXfhTbeeZqr9f3kaYZNfk+
	 MH2zBcie2x56NyfK4Z75vCtsuzM9+JO4jq+a12f7p+lZOprsqANfcCU0S65SSplZU0cGA
	 cRYUqPOe4kyTlDk942CPMxLZrqA7sFflZq+5xmATHivP4dIQ8Rq9fB8EEwn3P+PmD8C4b
	 ylplBJJjdxe8tVAuhepu5/zmGX5V4ZsmIzOTmgsg1gZkTvfm8z7hm7sRqjkTZC2qOFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793611885;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=C8YjMKXv/jcNP7cvxA972+Zr7uuiVXk1L9RvIefQ+4w=;
	b=S5zuOOktUB9+J2MpgTYsAIZohECBeL4IaHZHFY4Log8vJ136/8xO1f9G0eBYhrg+l4Vb
	 f6PmfrAGkUm4C2pyL7mLeMYMQoV8Rda4bdY8g8EUGBOMLGi6nV4cXaMx6AUtbCesIlavl
	 iFc2lNA6kYGcd54EH4Q2ynG4w8pIDSEypxwWEaMvMiJuj4xQgk1j6dQnw7oiI3AhzQv2j
	 7EFSRGNKGfeMorQ7mDTXoH59XzK95CKJfAyU9uaolcUwTpx6WCu991RADH3qCy7cjAq6l
	 qMNdx5AYqdyrilxDh11atRWmFCR7rGl7NDZnS+LU/jnEydR5CjaCURatNJbnPIVPyPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ePcd0BLl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA10606A327
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 09:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ePcd0BLl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F1F1F000C1;
	Mon,  2 Nov 2026 09:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793611885;
	bh=C8YjMKXv/jcNP7cvxA972+Zr7uuiVXk1L9RvIefQ+4w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ePcd0BLlohyggoO+fTszluG18WPBNkdV5pvl4wu0QVZKaYoIBTTNtEMaeMOtWYTYW
	 Dd3O2roTz76epVF8augNn3/Dk8Q8BBCAHw88uW4hKrYiD0BFcMCQeHX+ZaC2I0akQ4
	 NjEILJsi4WAYzbhPAzPUX/ngxLgvDpqlhauum6urmPe9XsCINAcRgnWA4sh2+3gb0p
	 yCaoS9goLqbh+y6jwNgUontu8byR/Ga+kyHOXB1ZgivMBzwT6rAeGbAWQnyKnZMued
	 dHoTgtv7PUVP5lvyb8cMhZ+VdmHw8Xpc3OA9Y2i3RtITAzpjxy5Xwv+iBmTZrkbjni
	 WtP/qQGQ1L45w==
Message-ID: <sashiko-outbox-193180@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma v8 5/7] RDMA/zrdma: Implement device and port query
 operations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102082026.2645777-6-zhang.yanze@zte.com.cn>
References: <20261102082026.2645777-1-zhang.yanze@zte.com.cn>
 <20261102082026.2645777-6-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 09:31:24 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add implementation for querying device attributes, port attributes,
> PKey, and link layer information. Also include firmware version string
> retrieval.
>=20
> The device attributes report the limits of the hardware, the vendor id
> and the firmware version, which is taken from the driver info of the
> network device. The port attributes report the state and the speed of
> the port, which is taken from the network device on every query. The
> immutable port information describes the RoCE encapsulation of the
> port.
>=20
> Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102082026.2645=
777-1-zhang.yanze@zte.com.cn?part=3D5

