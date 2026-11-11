Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794422432;
	b=0+5PGDsd/biPedIHP5/+x5Pq31pLwBRNICX5qBeNiWvHYfNd0k9pejfFmZUJ9TsXTO0q
	 EODmYDhQ39VU1mUeqR2tcDKpGtA0c9m7u1iO6iQcjA4PxuRpIR6/XylC37X5ELtRCVvci
	 cSVu2rz1RdwGei9h+9J+uLJdfdySszMku7gBKB1y+GRbCQUAGRBbZP+hpLUwm4u23JQpe
	 5khR4uelHK4UCzawdn3roTgnvkgjqZZHScvtHR3TLOdj5Sr/YmF1NMTIOKtTggPBSU9pX
	 89WIZxXyx8k460y9nFFv7Z35IkQq2se6F/hk2rA9dpEhjAKPr9YSfeSdK6xmz3A+lNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794422432;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=PIZBV+6r05VUdVoS2eE+qrO9S4vROyArBoX7g1p7JB0=;
	b=HqcOtaSeHpFG9KCZN/SwkrRvK31QzmtQSFcwhpmAUloB6Au+C2wR4cncu9dVhwkDBmYW
	 JciLdK0D5+scogduBakqAEWkaOj8kxlUsGcfjrqQ/S7h4TgSYPNGduYByzgsCd03znq9n
	 AUF5VMFN1aRllrJLzptMQsxPC+v+nwpgW33KWrK+zOE+gSMAjVpIxRiCu+RipLj2XLDmU
	 tfR72NAnuWEItG6hPBrkh6iS+y6TcQFo/gr5UHERrkxpZgbYfH1YronCv5h024g4TBvlf
	 J/WAxHzmUhjLlpg4qCTqJzTeJCg4nJjZsC9wt8lVgw8gCYp96/zmRjD9nvx6r6lUtmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KPZw9aYW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9766606A335
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 18:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KPZw9aYW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4751F00A06;
	Wed, 11 Nov 2026 18:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794422432;
	bh=PIZBV+6r05VUdVoS2eE+qrO9S4vROyArBoX7g1p7JB0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KPZw9aYWYrAwZ/0go/c37sieuBAz7SdyuwEcBE7HQAudKa6/rfHGJHHUQsybDCaOV
	 GZMS1Sxok0CKEioRurlAKLIvMQhVpALgLtUCqYbbrl1tYYUyyFXpY4B12/La8rESaN
	 CYfLvjAk0VRdFVCLYjqvCjNMTw24OhXhRMruTiOb0H5Z/K8/kzeGd2NJnOIgBsbfzg
	 hV2IMJsUYweWVnTDY3N21j20DKqwuBK//UiLmQ1L5+WPxtTpcAKWFUwKkyGYcB1o0V
	 mdHdXLet0OYWOEFBCtiaUkJ+uJYa68etfkRBMEv+mkLoLizZ5cm1wdul7e8h+6r93C
	 BStPR+He2t59w==
Message-ID: <sashiko-outbox-209472@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 04/13] net/mlx5e: Pre-calculate UMR padding
 and entry size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110183826.2927274-5-tariqt@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
 <20261110183826.2927274-5-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 18:40:32 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> A future patch will add KSM UMRs alongside MTT UMRs for data direct. To
> avoid additional ifs in the datapath, pre-calculate the UMR padding and
> entry size based on the UMR mode of the RQ.
>=20
> An additional side benefit is that the padding check from
> mlx5e_alloc_rx_mpwqe() is no longer needed.
>=20
> This patch doesn't introduce any functional changes. The mlx5e_rq struct
> doesn't grow because the new members were added in a hole.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110183826.2927=
274-1-tariqt@nvidia.com?part=3D4

