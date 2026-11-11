Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794427713;
	b=sYHa9H/K9B407p8wD4toTnPI6ksjK53qv453VMoDcL2v7P2oaa/QJjyVUWwR324Fa8ER
	 aKg2PPv1scexFDUYRqh48Vh4wnp3qm9hAqeq5+qDg04O9pbjZvU5w3mRGgfGq3H8OR2cp
	 uyvj9NMPF/h+CKwTs+QomV+6zno4Le4p5ENK7sH40dIyeAWWlctp2fSN1+BdR/Yx7nMOG
	 u2BkfXnyv0V84OPkQjQvt6flQdACr3Yk5nxEO0PGsY7dDJ8SLqcKLceEq5OAliPXj51W3
	 PRIsPzpMd9OdFtU/XXUpkYSjM6NVrN5GCfZKZbjni4n6Ce1UHeqcIbMzhk2xN8QRXLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794427713;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=E3Hs/JzY0ofyndvk3uNemsyTh7rcvkQ5De6sdfrrqJw=;
	b=DFgDJSv7yWTHDc2rLFowsvSke1s1mFAXQhCeTaTLMa2+BfAgHRoyvg288o5wKTNVzgN1
	 nIIsIx7r4ce2aWZhUbcMVEbl5lQWRsa0bhxu5MMBQk9arN0+TG6tIzsDCY2MghifSBYmr
	 Aa4qktLJdA2Am/rrkN2dBrGni2i+gbTgXYMCfO5aG93a3unzmRxb+aNk9pzH94RD+do2L
	 z+SfWyl9qIwtyl3TLL1XlZRSIJrq5M96YFu1JIS99EiQaMycqWEkK+jdPMv/2T7aWRU45
	 V9T0fkIp1WfC743mzPLKNP3f6jk0Hbar4Z6vvTuU75RdHmlN8y4slPOIT3FEfS0P2Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kiO8plzQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E68606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 20:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kiO8plzQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133A51F00A05;
	Wed, 11 Nov 2026 20:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794427713;
	bh=E3Hs/JzY0ofyndvk3uNemsyTh7rcvkQ5De6sdfrrqJw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kiO8plzQYd6c4ep4j1wdbZwaDGbk+G4UhwlQf/TXHS9Uq9Zvq1q0xOsATbsY5i/YS
	 yJdknYZIp2zNRrRZEbQlgmbV1Q8m1vDHjhAenhmMnp2xEAeOXgQ3N5QmWRh1at38pV
	 uWTh8xhZJUG1VXa/lXtp8L4+Bpy2ZgsCSi4whOcJhJ3xkB/iCfwA9PYCUYrBUnybWg
	 w97saJaIm31EYzJfbWrmUy4p3i0bJINcOzIQm9XlzJzqLIV32gKcbPuYD7BXlKXHEr
	 NmKFJ9dgNBMA/BNvBkHxeQfgGxdT2iEMITViUhwrGc1zZxdQ1Rx0hB8ZNNhSqzxemC
	 4pRnOAf2h3IKw==
Message-ID: <sashiko-outbox-209609@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/cm: Read the remote_id_table root under cm.lock
Reply-To: sashiko-reviews@lists.linux.dev
To: "Changyul Lee" <lcy8047@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111191913.98044-1-lcy8047@gmail.com>
References: <20261111191913.98044-1-lcy8047@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 20:08:32 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> cm_find_remote_id() reads the root of cm.remote_id_table before it
> takes cm.lock. While it waits for the lock, cm_destroy_id() or
> cm_reset_to_idle() on another CPU can remove that cm_timewait_info from
> the tree and free it, and the lookup then starts from freed memory.
> This lookup is done for a REJ with reason IB_CM_REJ_TIMEOUT.
>=20
> Read the root after taking cm.lock.
>=20
> Fixes: cfa68b0d0440 ("RDMA/cm: Make find_remote_id() return a cm_id_priva=
te")
> Signed-off-by: Changyul Lee <lcy8047@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111191913.9804=
4-1-lcy8047@gmail.com?part=3D1

