Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812431;
	b=mbmxzMvTgfEjIWcL5U+vmQWn5da4WAZPCit2vqcVm2pxdZK4ArlvtzKbPIkcRhvKXl8f
	 60HTtygXL3mdvpZXCU+gZhtYu+KXN0l9v8Va9WyI/+Yy8a2WU13sMyrDBIYyRrXIOjOcz
	 WuDlHs9IN476/A36sslUvCYc54eX5jwGEbaIIm4u8WrdNjKeVrXLV10G5XX3OYvB12LWn
	 kq0HUQuSu+JgrSJOpJD2XMoSXOfc9UMg/rg/t9nXr30PQseDF/z5/XWCAb3C51Sw6uUCV
	 G5AgP+YzpxszMH8Tgi7cmiaUbGOBXX1HsVp5Wa3HMoTE3h0WPspbHTlfqTrP37tI9Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812431;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2lHGe5ueLK0tLMxj3EcQxKfBoSDrMqdz2L57qVhdaG4=;
	b=geCr4vuaX22eKswkDEh4QbjhLUgWcg1QU4gPGs4RLJwDNVlDdmzKu4RxVyYNhCP9oKNV
	 e9yRcIXkUCbEj5myE8/UQBFsxZ2lptAHCQrvSjRNMPFGStQB3L2D5tSkjnJpoYI6u0Xrt
	 WGZ8IqJb7g3g4bJVnXCmq9DWdDCGswGJRTygVTGzclrz57CrkRc5R7tMqVQ5+6kU/Ugwd
	 7erjBDQP74MSXxdrxJUUMX9EhLkXgRlrBKFCq2mP8h7XOaUDiB7v/o0riinZOZK1rHLec
	 gzqaB9zOGHQVbib9uQTHUOo1wVMQlz5UHp59K2WMiJizbDc7LXN0MxPjkK9XTGE2ruQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ovjGAFTD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EDA606A33E
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 17:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ovjGAFTD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4D01F000C1;
	Wed,  4 Nov 2026 17:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793812431;
	bh=2lHGe5ueLK0tLMxj3EcQxKfBoSDrMqdz2L57qVhdaG4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ovjGAFTDTa0EYJ5+mmByPM/S/P5C6Hl/I9fexAgKf2o3Bmgce5UVSQHGPcbry8Hhr
	 dw9c+pmiLbGZxuazNfkzvQRv18mNu+Q2urHocC7qGjGPYw6VoHb1iX9PVacMUdpBnL
	 gwELSf+TMmqr+QdXh2vHcSHMNFYIvR/Y7fTHTazaGOhmjHnESSwUFmdJsNeB2xW3Pr
	 5Alje/TBjTQVNGoGAipW1Ns2ht9tSWbB+LR22oaM//RY5M02yWeD16g7wkCcMj51TO
	 h2fdUlmqUuSQLlgSfCjzDUNDlq2kgYvPeqn1fh009xoy1DRzep9RUuxb5Ao2//0LgJ
	 sSMvpAMK9pNDg==
Message-ID: <sashiko-outbox-197739@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 12/15] net/mlx5: E-switch, match master egress
 rule by vport metadata
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103171009.563034-13-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
 <20261103171009.563034-13-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 17:13:50 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Shay Drory <shayd@nvidia.com>
>=20
> The master egress-ACL bounce group and rule matched the slave uplink by
> source_port + source_eswitch_owner_vhca_id. Virt LAG master cannot match
> that way; it must match by vport metadata (reg_c_0).
>=20
> Virt LAG only supports MPESW, where every uplink has a unique metadata.
> Hence, use metadata matching when LAG is virt LAG, and keep the
> source_port + source_eswitch_owner_vhca_id match otherwise.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103171009.5630=
34-1-tariqt@nvidia.com?part=3D12

