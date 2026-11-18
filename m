Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795010062;
	b=mugXvhOOpKcvfLi4ZMQLo/3SXmHJyYtSEXcLRy1Twbt8x0IbRmms0K0v9r1epU28RVAH
	 UTD68yzPYCPcLbILuS/bcU/rQ3nFWiQOY1Bvj+GAMJJQYDH3hjdNw+PGSSequFW/Uf9IQ
	 fcnrnUUiqnZ2ARI8q94dPCSHhrx4SkH3CumWHQL5QT68HGAuawjlZNu+423XXpNtgfUFt
	 XITDRPn51dW8eWTP4NoxlaygGMJORNjH2CYyFm6JAe6u33DxTr2B89hqsUNCbjLaMDN4X
	 BHE1e9Ijz6P+Bu3T9kKn1/65/mXV/mUvEPIOqO2yeMlJQqNDhh1JR9lYdHY0h/Mpmew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010062;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JWJKQsjrfbmV+RZlXe589AFFksBP1JQm1xDO1XikynA=;
	b=ULqdFBqgUMla/QVrTsIWDbcWFIjqwh6nB+JyNKFnc5ibmb35lHCDzRddS7sH8sHDEpey
	 +nDsfzSvRX709zmylrIUegZx1U0Ixm4JUAuJw9LvUzmh4pP9Y5sJ5s6RTI/iBQF3VBHAx
	 V7PRKIF55+mtcma8GXn2FLPwhfsgTe2/LAjNwCxm/APmgjKEbNtOaYfr1RVooKJSWSDWh
	 T6Gyrn4l/eCkSsxltukPdj3KfcYT4Bx55OHLqsEKt7AZWzN1WxRTWx39zw+gJjX4hEQ4X
	 pgelbatiDlxsJ4dSRs8cnf+DfpQ57+e/cWxin0xaxS3EkfFNbkzCpmNLzlKq5b/XS7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ie0WWPeF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1934C606A332
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 13:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ie0WWPeF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8BF1F000C9;
	Wed, 18 Nov 2026 13:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795010062;
	bh=JWJKQsjrfbmV+RZlXe589AFFksBP1JQm1xDO1XikynA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ie0WWPeF+feHsyqh0ixnWIRDY0imqOTR582lEQc/8HgY4VsX5RYTX3fjjIvmwpssI
	 aMN1cJ09M8YGJnElBNyFtVs6uyk69VqCD09HnhzKdPyupuLlcUNRVREIzCHGdfWTUu
	 KSHGnbn0aYnaphG0yfdT+o2oURVIcpp/TYqH9DGLxxe8V1qAalWsJlH1adFHnWzJyn
	 EBhedJ49rlmRqWk6pmiI2SL2uubAHtV7q8/lV4+ac5xQOK/o7gcn1ZJ0V/1xReEzOe
	 Hh+3qwganm0OKkiN3N+/wNBNNIL7ztol8Qkw4OSQvrb9/Vl2HhOHZCm7d7NWbRN65F
	 j9tTu0Wdzk+Gw==
Message-ID: <sashiko-outbox-221095@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v3 1/1] net/mlx5e: fix NULL pointer dereference in
 arfs_create_groups()
Reply-To: sashiko-reviews@lists.linux.dev
To: Jinvas <jinvas@126.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118134514.1765-2-jinvas@126.com>
References: <20261118134514.1765-1-jinvas@126.com>
 <20261118134514.1765-2-jinvas@126.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 13:54:21 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> arfs_create_groups() creates up to two flow groups in ft->g[], and
> increments ft->num_groups for each group that was created successfully.
> If creating the second group fails, the error path frees ft->g and sets
> it to NULL, but leaves ft->num_groups at 1.
>=20
> The only caller, arfs_create_table(), calls mlx5e_destroy_flow_table() on
> the error path, which calls mlx5e_destroy_groups(). The latter walks
> ft->g[] from ft->num_groups - 1 down to 0 and dereferences ft->g[0].
> Since ft->g was freed and set to NULL, this is a NULL pointer
> dereference, and the kernel oopses.
>=20
> The same error path also leaks the flow group that was created
> successfully before the failure, since ft->g is freed without the group
> being destroyed.
>=20
> [ ... ]
> The fix has not been tested: the patched kernel was not booted, only the
> original crash was reproduced.
>=20
> Fixes: 3c6d5189246f ("net/mlx5e: fix a double-free in arfs_create_groups")
> Signed-off-by: Jinvas <jinvas@126.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118134514.1765=
-1-jinvas@126.com?part=3D1

