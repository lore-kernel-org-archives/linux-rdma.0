Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795722138;
	b=DlK0k2YjQFIE7QaaRjf58k9LLD7nns+BCFw8DZspTd/N4OS/nH/0/yIe9tdv3jq00JYf
	 jqYcmhl2wJ1p0ET1PLg/aRwKyyjSGfw5n1/bvoTQ7un6STgibQs1BUxW8YOhwMnqZj+FN
	 8wFRPWvj6pmoBLcSy3wzni9ycxISlnud1Jo5RXg9tmRvbxltE1OLgoPud3yu1tPDvIvE1
	 g5zAx8h6U686wKrD3BwEA7NBWNI51MP/OKN5hGB1r6o9FWqSlXe7c/6YkLgDj+CU7IUqH
	 wb5fi9KRT2gPMaLATVGJXKIHIv6hTLHtN0PAotPjFG5VMLQClz+SQR8jtWHHTP/PVgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795722138;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+RLXyT0vUY25NLUtR2Imv6I1Y0vADmxXpu0lOhVTRGU=;
	b=hQ6083fFExJD8CE2HoJCP2VFSzTZYK14aULC8d/swdsCdEk1K8rHuAL4CJuC4wKiPvTj
	 U15Yqx5Y0xZLv7D52AW7D4dfs5a/HT3SaUwrN2+omHzrLVw013RZM1vDOfzmmBJWDNxRq
	 iaR8u22DITH16tTNhD1MTEN8OCjGya8FcKsMksk86AYwSNcwsF0UQhyI0UOc+zbiZfjHP
	 xwOEvCHzetShXkiT1KTXPyD5UqVeLSl3sHEnYtfe+GbsQYuXIlmCXMTaH5SaOzb33EP3N
	 5ko8BOjm/c4tcvdBOl76ZKkW8gRDZMK96a0DfNpESt6aySal9XvpeavgYShEsU7ofiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L3syFSEE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2448606A31E
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 19:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L3syFSEE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0AE1F000D0;
	Thu, 26 Nov 2026 19:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795722138;
	bh=+RLXyT0vUY25NLUtR2Imv6I1Y0vADmxXpu0lOhVTRGU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L3syFSEE1KoysfkWidrdyZhZfe4dasC3mkuPYXwO/0UlJLq8QOiQGekWCkQgfZfPu
	 /SuErx3PJeMGteIyUdDSgu8qtWIXfLJ4Z1RGxUDqUYFmS+IEJ+0WHq3TX7K1JJs8ym
	 CKbVfy2O7O/loUB0qAc/eJaR3AkNyccNDhbUcAWabam12s/0z3e4ed0jxcxC1JN4Ip
	 OS1RM25UtJG8xiRx7BlkQSk4ZeMJAwsBq+9NYoxrdn4aRQgaVDjoTRI8lhJKnn7ojZ
	 mOar5/Py9kRkk4sjBtIZxKUKLDstV7siSDxb915cXVFaGkiM0Uk23nz9o74Rfewr5i
	 c6TSJFJXU1+ew==
Message-ID: <sashiko-outbox-236108@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 1/1] net/mlx5: Add PSP header extension length
 match field
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126193618.725006-2-tariqt@nvidia.com>
References: <20261126193618.725006-1-tariqt@nvidia.com>
 <20261126193618.725006-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 19:42:17 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> Expose the PSP header extension length (hdr_ext_len), so steering rules
> can match PSP packets with extension headers (such as the virt cookie).
>=20
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> Link: https://patch.msgid.link/20261126061904.387686-1-tariqt@nvidia.com
> Signed-off-by: Leon Romanovsky <leon@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126193618.7250=
06-1-tariqt@nvidia.com?part=3D1
