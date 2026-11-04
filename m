Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812425;
	b=zpf4MnOKAyLvaQXr3zItN+nKjz4vG/Itc9GcAs0E12WZ2FJOkmnNExiWsI2SqoybQIGI
	 NcSgEXJsZbUYyC/yhP5BzcxUGin1ek2reapskbL6w13zDmzSxZfWEPq6NMBKFMncG5JQN
	 jhVFlxx329jXf/ynBjP3KERqb7JxUMJOLvDjx/LzqJkNP5RrKE+oRVrMWMbnkJZWXCE1k
	 k0r2bYKKZXi+JnXoo8sqyddB26/P6xbGed61PPanTCIFDyUsNows7pV6zlsYn0N/FagM1
	 euVt31VEF4KOheeqB5mbGMHm84h96PZijiVedyiiORPs6XT5jlOK+yKqTTsij2Deb5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812425;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zrKzJHPl7+i+j4sxCaqLspAAktZewBCB/HIeojsxVoU=;
	b=BQKSE23t8kTODKRAboSAaMdemm3ow/qktRiSURuGNl25QChhawy8vG3wdrm0PWZq5NUq
	 tZ7fn6rPDvbRwkaWNGhDC/Bba4x4Xjmtq1k4b3QNma9CaBEU6GXuM+YKKkWYKgv7NgM4Z
	 AyhTReMg+6jvaKBucgK1WVS26bPJZzO9qh4tMMMkc24DJRoDiYEzOZEU/EeI4yzhAxIOJ
	 e5JFDbiBFGsK9ogU4jPM5odfU+jzsY2whxHoZbIZiuALuzc0Jd7XuU3VgwNloYCYGaGSx
	 auEGDX0wunjj3mIfvZ1juvfPfQxvF8XujfpXB//wjDNYeETa6qxzF+Qfq0z9Tbn3t0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q4LPOrny;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637E3606A333
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 17:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q4LPOrny
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231FC1F0093A;
	Wed,  4 Nov 2026 17:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793812425;
	bh=zrKzJHPl7+i+j4sxCaqLspAAktZewBCB/HIeojsxVoU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q4LPOrny9VK61wnNsBfcCXPJBNtNcLM6fFDrCWb2SNR0AbaqbDGvBm/dc42Bw/dGX
	 F640MYqAbR7TNCGHbP/9EnFF7H2kmtoBhvcqrBqjEr8L1Y8TXfjGiPTVrqmnWhimdZ
	 vX2iBLjyluzrDT/AFQ3r3L1b5686chTNdpw4oHJbMfBo7tjGeH+GT+jEOk8LjVSX3r
	 YnRC01MMi6jNKp/j6RkQoZ8OEenPjxsNmh9l+EBqkMzOaBgi1YAfcJXNf+oRGHXzJu
	 6BP8ICAIui6cGXMl5Wf9MdemfT39bUqWlkQuU1JJ3n5SD17AwJoI7tIACsJ9EtQjmr
	 TteEfL4HPiLZg==
Message-ID: <sashiko-outbox-197730@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 03/15] net/mlx5: LAG, skip phys LAG
 prerequisites for a virt LAG
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103171009.563034-4-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
 <20261103171009.563034-4-tariqt@nvidia.com>
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
> mlx5_lag_enable_mpesw() gates on port_select_flow_table and
> create_lag_when_not_master_up, and on mlx5_lag_check_prereq(). Those
> describe the phys LAG: the port-selection flow table and the
> physical-LAG prerequisites (e.g. member count equal to the physical port
> count).
>=20
> A LAG of VFs/SFs is a software-only shared-FDB MPESW LAG, so these
> checks do not apply and would reject it outright. Require them only when
> it is a phys LAG; a LAG of VFs/SFs instead requires port_select_eswitch.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103171009.5630=
34-1-tariqt@nvidia.com?part=3D3

