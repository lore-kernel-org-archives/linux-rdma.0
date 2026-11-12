Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794473950;
	b=xewghS6ZqmhXEFB6Y85vTS5HgwcakBWrktwq6UeEoK/NLbsTvaGs0A3dfA/UY7KmjzSE
	 5KXMrpG4l12TjHHIwRk+oT/MbKgVD3Xx5uCeiuE4CKy7FTU/H9lEbv3B1Bhk4a3u1Ya7M
	 lTjr59IdlYbn/DxMsCEc1KN1KxWmHkhG4GYZZH/maDfIRQMFv2PH0od79SYYJbgOU5Goh
	 bGYnSqu4rQ/Tkh9o1yOu+c+M1ed1ZOCXYfKPdoAFdfku1GcDtsZc9JtY5CDCPedozjwFF
	 qZu1oi2x2T9nUcyJXvUGk9X2dwyDZXRf4sPUH8QnKwRgqgGm6pWYOsZJQoScdh37DBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794473950;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tkjkDfCiM6JxGaYUV+umV2zvzSFoglip7T8M6qrecAI=;
	b=zu36vHnreUg30jV1Yg2K5FDISdB/hyH9HXAWf9LAdGRQg6LLWcCXrh9okzC0WvdlU4wi
	 3F1yQrEtqDbbZXV8ke9MBoce+wR3vjrIXOnoOHW+uXhtecuLliuT9vUwoLRUtBiIbNmuD
	 LatNOTQNbzQkv35sKW/9Ur88j/wnRfJm/dejCkRBzAUzEMbdlmElW0eRqALeYEyVdVVbh
	 xI4IQ4BgXT3P/OqFu+k/zpGrB32MfDy8eyLlBtx2NUfMKj3T4vQoCnB++4k7SJWsz+De+
	 4HDXVZpRy6/IMgdTZpgb5hc7y3S+uCRCNpzr6Vg5kVjH2G7MdknopZfMF4ccdWsdDbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QoqsoYq4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4F3606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 08:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QoqsoYq4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E17F1F00A05;
	Thu, 12 Nov 2026 08:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794473950;
	bh=tkjkDfCiM6JxGaYUV+umV2zvzSFoglip7T8M6qrecAI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QoqsoYq4fQrSqm/Y1YqkH6dxUpNmzIKS29MW4YdqjL7zmsomRXsd/kW2HeG5OMbVO
	 U6Nv3hZ5zaabaEgFfLPmLuw9SRibY1iRCypelDlO2+wVkfixSQktR6XbToGv/OckU4
	 Uwi8NxSH071ZewCB8Htsb0E42pFVjH50+Yw8G4ffmqeRERsl51jD8swB9C+ysT3TMG
	 Ootnc3ys0we2KfOryI97uNQB4sSOYR4hn5dkyTZBGBBdbef8Nqx+l+R+JBIC0d8sAF
	 BIcqKyKu2UQrjm/VgY3aTPQ/V2L92YcdhKEu71wPYVdvgGnzD8Gfv9sEkNGv+bPcbQ
	 9YKsp3WhWwhkw==
Message-ID: <sashiko-outbox-210810@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v11 1/9] RDMA/mana_ib: Allocate and map
 fast-registration MRs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261112084716.1483342-2-kotaranov@linux.microsoft.com>
References: <20261112084716.1483342-1-kotaranov@linux.microsoft.com>
 <20261112084716.1483342-2-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 08:59:09 +0000
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
> Implement alloc_mr and map_mr_sg for memory-registration MRs.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112084716.1483=
342-1-kotaranov@linux.microsoft.com?part=3D1

