Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794840922;
	b=wmtY/U51RQZaQ6XKfh0Z4c3SYqTYHMMHnd+33kcafPQ6Jba7rrXvatBZU0kFSHT++JEh
	 /+nX7/n8YeyhVaShb7lXxLR68HqaG8zK4oRsomCq4XC9PslLXlLsRfjY3/bie46j5KH/E
	 j14NKS/jeU6s1TnRpHbH7WzQrBoMFAOyj0B1lxS8eSd9PUcz1mWa/VqcxkahuXh9MoT33
	 79WN+2mNm/5s+qTzm8yswkUFxaSlPyPS91Fx2yCkNf7dVOCOrT/J/PzLTpkSWgMl9d4CK
	 rPbrh4JuH9pYdTxoXEd/uF6XqblLWWV1V526oA2R9UWCCg57VN2ywJMGkADCjItkfIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794840922;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Wc3jIUA28778oPZmWmicqOm+GamekFjlkU1L0DV1OLI=;
	b=LzPd6keNW8ftTooQ1EAhc6OPaHZCEnyrfHAiCaGCx7kxGy/Yn5t75BSKwt+r2/O9yeCr
	 W0EMCAZZ9vW7n1za0ChRKnDB6On1UCMg8AGloCVuZ0yYMEhWZIP15ENKz69C1L9k9MyOk
	 z+DIA1tpizR4OO71vzmNod0H9ExU6jx8Gs/a+d7JpFOpYUHWWsywMTuoB4nqzqS3HVUb3
	 nCQ1CrzwVebaq0GD5ha+WyEiahFIb6yzLo1Pi6L/fn7fHubwkIVQzTDmtIx/s9cllY/O7
	 JGERVrgUgHODwhuMic/5gyaTbjH4sqVcAGBF/jUpuL4Wy8PzOqzg7NyFvWVLwpWiC6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JR1yTyoA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7E5606A33A
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 14:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JR1yTyoA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605351F000CA;
	Mon, 16 Nov 2026 14:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794840922;
	bh=Wc3jIUA28778oPZmWmicqOm+GamekFjlkU1L0DV1OLI=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=JR1yTyoAjBotP6ivw/Gew5XVb/cFi9z68/02nk3DPChTpE9dvLPKEA+5DazANM1H2
	 0+hVL2EYnvOG4l74/k1/E7tN6rV+QUyv/nwt0o9jFz+GAsBcHgtPA/iYLlhMJvqH9N
	 j1EEStgRB7GnJeUzRWtfOrhJsodT2hARPy/MwrAX3PD4Xlqro7BDKx20juS2QgCcNr
	 aOGH9ofAxtgDW7yQgpY7m8ELJZepHur7U59eG7VnBLarMyfF/J43db/RW1vRQuoS3C
	 5Mm1HW4M89i6h42FHPNBMKCMw/20E4239QFmPRSE1C3ahzbO4lFPSUYHQMhnco+MJp
	 odJg4He4PYNiw==
Message-ID: <sashiko-outbox-217204@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next 3/3] net/mlx5: Add MLX5_PCI_PF_TYPE_QUERY_PF
 to mlx5_ifc
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261116144554.1194389-4-tariqt@nvidia.com>
References: <20261116144554.1194389-1-tariqt@nvidia.com>
 <20261116144554.1194389-4-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 14:55:22 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Chris Mi <cmi@nvidia.com>
>=20
> FW exposes a new PCI PF type value (0x2) in QUERY_ESW_FUNCTIONS to
> identify the querying PF itself, allowing the driver to read its own
> host_number from the firmware response.
>=20
> Signed-off-by: Chris Mi <cmi@nvidia.com>
> Reviewed-by: Shay Drori <shayd@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116144554.1194=
389-1-tariqt@nvidia.com?part=3D3

