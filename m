Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794911810;
	b=O2VUs8SXbp/SyUqFJ4aLZLWPjLKMIXMHCsL4AkzxsByl4fuXMNxHiF9xl3X2zTkGlCis
	 P6p0ZVxs2xAI+kX7XOK9TWvQWUEbby2HoL3Vqz/J2mDfPxId/V7BPyl+MMy79TdaPjulS
	 8iP3z6XJKv5krvG3Xl+Yk/NJhGEI3bkPiu5F4s867OlWdwXQ34SXJ44dMDLYfq3r6bGsd
	 CfnW50CBgSFoY/VWElB3C4SpweOcbRaLGYZLX7TVt78xbKNXjfcPnKCLxLKBnH1vF5WqV
	 JGCoG6LjCTlxNyPC/KxvIIvi81XH57JjOwAoqdQCNnE5i/Pw1/4cL/XElX/HZdv1u/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794911810;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=E4Tm21a+iGTOKS7qmWj9DtPit7iUKA8ZqwcqyN6LmW8=;
	b=HJ20hnYs6gzUhcfe+j1CzEYy/j/axiSCsVFdNzPehgmyxt6sDeAzYiziAcBlUZWEhRrb
	 HWkOW0xm1rYM/bvyfV9DoHB520AXcqCxzyXTZ1xjP22j+oYP29rZ/pbpdnId9KBdkNQrq
	 E8hJe21BkCAkg+crMhLUV9XBMq1B/6STlaQx7BtpZRUfazVZr5ER34U/Z9SAlQ+5wdpiE
	 A/cQVHzp5W7TrpkaL+HaFkN1JS2O9vzlyxzKJXVYKXc9D3w5+0aBx7x514WzgEl42cO6r
	 LWZ5AxhgcvFSjeYxgpQ3m05HBEQs/UovKGxM2SpVTU+4soY4ud3PvCM8dPvfLu1WjIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZ9nUsDR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAAB60A260B
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 10:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZ9nUsDR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B97A1F000C6;
	Tue, 17 Nov 2026 10:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794911810;
	bh=E4Tm21a+iGTOKS7qmWj9DtPit7iUKA8ZqwcqyN6LmW8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BZ9nUsDR1x7GUFLK3CBXDEWjWt0o7jDIJ1wviqs4pTOIQooig7S3UFDodkN90M0AW
	 2ejexHBrhIDS53NzeecMS+fO7RrVRXcMhbzd92MgEPtQKLNuMRqoE+7X5/V3x/6GP2
	 7nSnwm1N6tOR+JxjgOYqSEfPNbTpqLVpdbKuqSTDEA/qAZ9M883aNNmiWOAb90jMka
	 7mZVqZGYHWASlBqg9YXYiYGO/YwnvXsp/j+DJFswsfJXY7OfdxxWcfEvviU6N5daLd
	 3B50C5AjgnTNYHoqrstFShoHKJYbu3UDxkY7wSCrsVlin0qkyZYIerxkhMXHeCRTRr
	 5NBjcSz6nt4gg==
Message-ID: <sashiko-outbox-218638@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 10/10] net/mlx5: LAG, do not add a device to
 an already-active virt LAG
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261116103010.1129666-11-tariqt@nvidia.com>
References: <20261116103010.1129666-1-tariqt@nvidia.com>
 <20261116103010.1129666-11-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 10:36:49 +0000
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
> mlx5_ldev_add_mdev() would add a newly probed device to the LAG even
> when the LAG is already active, mutating membership while getters may be
> iterating it and while the active mapping assumes a fixed member set.
>=20
> A LAG of VFs/SFs is the only one whose members come independently of
> its activation. Reject the join of a virt LAG capable function when the
> group's virt LAG is active. The device stays out of the LAG until it
> is reprobed and the LAG is disabled.
>=20
> The other join paths cannot reach an active LAG. A LAG of PFs is
> activated only once all the PFs of the card are members, so there is no
> further PF that could join it, and SD secondaries join at load, before
> MPESW can be enabled. Hence the check is limited to virt LAG capable
> functions, and it is a no-op for existing configurations.
>=20
> In addition, do not register the eswitch devcom component of such a
> device, so it does not pair with the eswitches of the LAG members.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116103010.1129=
666-1-tariqt@nvidia.com?part=3D10

