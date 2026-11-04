Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810631;
	b=WpyNNNIoeTSQnWTSkPMIsaiKmyTM0RulMxrt7sAu9f4OFRHNzJFcf9IGmN1UisCYh5ji
	 92L6ynA25ztOI+vqqByJNID4aMPQMh0E8jXegdwA/1lpxH7ltEOJFUbdvCf6p5HPuECjo
	 aLz/EXWLT7RaEZLLNkgk9qPlcrwA5P3xVrFZcXHF9qu7IaNxpPH50k5tCHvGjt+wnnn/4
	 AeQj9MsogudHJdCtVjYqabptzdh3CbUURCW9GAnDmxblQp7n0uq/LOG2KsBvtHS2/0QjC
	 sNNR3GNIE0aqsT+ct54SaLt2YDW6odTax4qdcyocdo/7aBYPQtsmkce6g02QXLC0dgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810631;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=RKDxi46IMSWxwMfcXrrQLiUgjadEkuJzBMmblBpjVaU=;
	b=3usbDTLWx9IOCI5sUKZesH5rK2D0WgAisnN+TDxeASiDIuZkrOPMijsjMFPM+Ibaj+ss
	 sM3vTEzEAXHDnOkeU7Uw/OnTIOHUOn/e8gTKNEcxZwdTmcmrGR0dAhZgF7nD7Vrxf20m+
	 UsVgZdx+9Wg/UuHAQ2zV9NTGqv+RY/Arxq+B8Fep7dZcszI25dfAht/5w0PMgFN2s2KAB
	 SoF0EsMC6HUUt+UVVgTmUBy1Sc9FES/ARFiU4aj583ry5VxLq/9491aESq3YJm51vAKEZ
	 uFIHuHczPeD2VN58C7BUJYa4q0HelPqj6ltwLtgequZHsKxl7IUNg9DnyJpwJpTV9/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T3977MuI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D8E606D809
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T3977MuI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A8C1F00919;
	Wed,  4 Nov 2026 16:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810631;
	bh=RKDxi46IMSWxwMfcXrrQLiUgjadEkuJzBMmblBpjVaU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T3977MuIivKOA7n7Xw29paqKwfN3nGxXhZsJmUGcPBGxG7F5lRgU5JgT7Tj+H79/f
	 dB0tAjQK5TJzQGQlQXXVwmYGQnd8GnKZlnPdHNbHN11yIgC5IZ7BDdY1vRcP60W9fr
	 am1QbPktw3i7Mf655yxWT/r1/TUsvDflY/lL/c5SWYhPvOTc1w3cUYywJj7vKoVvi9
	 nnsI4YkEY9a1AWGLf/+6n0rD4sKrnL1h3SH5/4lv4boR8KIcltoT8+tH7gqMxDMDUm
	 opP+LoacJkTm+P0dm3GYq9LBOJnlAHaBnigi0RWhmPLJhgxt3sY7iPiIqa2Ion6U/p
	 zIiLxdencCcsA==
Message-ID: <sashiko-outbox-197670@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 17/23] RDMA/mlx5: Validate EQE port and GSI
 port before indexing devr.ports[]
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-18-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-18-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:50 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> devr.ports[] has 2 entries, but it is indexed by port numbers taken
> from the NIC, which adversarial mode does not trust.
>=20
> handle_port_change() uses the EQE port before any validation, so port 0
> wraps the index to UINT_MAX and a port above 2 overflows the array.
> mlx5_ib_create_gsi() gets a port already checked against phys_port_cnt,
> but that comes from the num_ports and num_vhca_ports FW caps, which may
> report more than 2 ports.
>=20
> Validate the port and bound it by ARRAY_SIZE() in both paths.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D17

