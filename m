Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812425;
	b=24RnW1qUM+Gc7Z19n6Y6Z3MJYA693RTAUqmQcFBEVaAq1KzVOOj1M7WVVdcrmuwnTI5Q
	 9eckP5B/I+UGpbuMPQj1E+hjP/v+USFn7zR1TA+QF0oRZD44NH4ZQfc2uvCrQSWUJXC3H
	 n9NDAbhbaShUptV3PmBMTp44fNQY8MctuDe+d7J9L62H/S7U8HbwxhQK5cwtbzElT0M/s
	 pDbKDNGWuVcj2lcqCnmYmfYYu1HdHXKCiHGBnpmBnOjrXFyX/GkrE7h+aW7wQvWgFw7u3
	 rRTO0i6FCiRmj5R5I9aK7kTYG4Uw+UCjAu8gbbufrkaDJnbP9XyUPyz9/bLMY5rgazA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812425;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=AO0z64+SvykOFNxtRfNrxRuwsDkD+tsX12lvaeZY6Zc=;
	b=A+ELAdBqFzPJp/cVrlxzmVjdaQ7i7fs3JvGEKfclW+EvsX1EytWffyhmDGmFfzNZFLUv
	 rAMfZvuSGH+H0coAKzbWYoV/RUxoWvAsRpeIVdHYmNVJiCaGfcNus6eyRCFvl9c4oOUKD
	 s2uNyC11JxlGZOFEF5hHXdpxFEaM5iYiNzHKKYB4e7eIggwlOG2zaRmWLE+1h02KIM45P
	 huGux+nUpQqfn1Gv+Xyn/Nq3fHlI5OcqT9DGU0oQO0/0uXIs/UWpKd6+EZdfpVeVTqDmA
	 Zstj4vSIvC0kqiz083yrcOJ7Xyls5UWMwy0AWqm/9zw6ksV038EtKNLnaNkaGUDtpGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y0X3ZxyB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B048E606A32F
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 17:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y0X3ZxyB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8B21F0093A;
	Wed,  4 Nov 2026 17:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793812424;
	bh=AO0z64+SvykOFNxtRfNrxRuwsDkD+tsX12lvaeZY6Zc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y0X3ZxyBsjH8CeEi1Ie3s5NwRXSjUpKQ7SGMVYgBobOd9B8B/qLBEnu3TdNa1qSSZ
	 1P2wqASfw4U0F7109ifmaeszaIC8K9ZtOOOJ7jH3JbS8xxiWyBACsVbtBA0xhyJbvx
	 2ua3EUTjgKNme5viiK1JLcBuUYJafh2tnQkbni5ErVe7k4v4j/TTA50sbWpHkIoSMK
	 OOMpvojKZxONI4ALrPPxGDkRRkjjZV/5lgO3xG61iQAdZJciiDUUlZYlHT6yelUb3q
	 GtLEdF9C4wFwvbVM1fuOnKXWDdKBUaP2DudnT5FQ7TzTVCbDpwNJHBHeiFoqO9gngq
	 853nzkI/e00qQ==
Message-ID: <sashiko-outbox-197729@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 02/15] net/mlx5: LAG, select the MPESW master
 from the live member snapshot
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103171009.563034-3-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
 <20261103171009.563034-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 17:13:44 +0000
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
> The LAG master is marked by the devcom PAIR event when all physical
> ports have registered (mlx5_lag_num_devs() =3D=3D ldev->ports). That does
> not work for a virtual LAG of VFs/SFs: those functions are unrelated to
> the physical port count.
>=20
> Select the master from the current membership snapshot in
> mlx5_lag_enable_mpesw() via mlx5_virt_lag_mark_master(), and clear it in
> mlx5_lag_disable_mpesw(). Unlike the regular path, it walks all LAG
> members.
> mlx5_get_dev_index() is identical for a PF and all its VFs/SFs, so
> tie-break by a stable per-member key is used - PCI BDF for VFs, sfnum
> for SFs.
>=20
> This is gated by a new ldev->virt_lag bit identifying this type of LAG.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103171009.5630=
34-1-tariqt@nvidia.com?part=3D2

