Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794911810;
	b=uXg33OGa5x32KIXKntSgpmwc8w/46iqmHcqlPPy+9IenLL4mDm0906fsYIU6AetI2sip
	 Gu1THS78oinInIVHI3VgalXPNIbJAZI3wTbfCBPzKyatg/3gLjgReUTU44SL1sePT8P8Y
	 vUwHC1ad/TQQWviC+K+sfNBBMxOwAiqc0axlxRuMdPMDta5TO6/I+/P6MvhXJ1ezg2+X3
	 bGmZV4dYloNVcMUcu2wz+EodULVdosTQjlwfuiDCHR041c0JfeU42/zXhw44G0u2qOZud
	 a2WnZfLWyhdDvbN0Em1WTYKkYWIbHpo+RRMcIMKpZCbhyNAL/C1LrtPnD7jleaaW46g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794911810;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BBg2sbiU24qVPYRye6dSkqZ1KoxtZ/uqwvqBMCvfnKY=;
	b=0fyqbo43ASK1jMgU3IhSDOvjrLXqJk3pkAaYzFs+GwPza6NnAyX3zBT54oEfXHp+gkgN
	 h1qKCWx/+3jkLzCturZTJkNkpxGCMkN4qkltH+3iIqeGg6GhDB2xS+1a90eg+20kys+mh
	 YlBZXxOb5BzQ++GNdZUewu/DLvpdhwCZoDrGrBuajbcwuWdK5ul+D0bcG0XNYXMN7X0y6
	 S+wTb9RGt1EUpG0b4vI8ddfdFHOCQSpSh8r0O0q55+gZVugi64yeoyagNbHlYBT8B/ptv
	 FzSTHTTBw+8FqyXVwWXJWRfvj1WJJz81y40SHWt7ttHXeiklrZG8QkDOeG0cajFfHlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OGwbpp5W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D9C60A2601
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 10:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OGwbpp5W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CD51F000C6;
	Tue, 17 Nov 2026 10:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794911809;
	bh=BBg2sbiU24qVPYRye6dSkqZ1KoxtZ/uqwvqBMCvfnKY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OGwbpp5WBRa+i8y3T1wAKCFhqMoZUc+7MogrUw11NimREjn6cTYi1kwhQt5KQe32k
	 XHoX+kbfqiFbMW3EKS2DFEclRJLO/xq5xUGyZ+/YNb7DVU0bucw8TGpV5+N05Q0xIL
	 ZqnGWbuLsZoB71hXKhQuw3O8disFcMay3mv7hK/Yw4CmmINiKaP3EX6gp9szTu3QvC
	 8sJA4mm0EKf/jhZn3x9RnMi7MGYpNQ18lGVRcd+/D55ZQ4QVJ086J7MG8qeJg9DMNm
	 kPhWwD56W2zTETUUg3poVEJwb7tPI1+7eorXL8sqitTzavv0aXqF4nTH4qLxhjQJi9
	 DBGjotGnFtciw==
Message-ID: <sashiko-outbox-218637@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 09/10] net/mlx5: LAG, drop MLX5_MAX_PORTS
 scratch array from device rescan
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261116103010.1129666-10-tariqt@nvidia.com>
References: <20261116103010.1129666-1-tariqt@nvidia.com>
 <20261116103010.1129666-10-tariqt@nvidia.com>
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
> mlx5_lag_rescan_devices_locked_filter() collected the participating LAG
> members into a fixed-size devs[MLX5_MAX_PORTS] array only to iterate
> over it a second time for the rescan calls. Drop the scratch array and
> re-walk the members directly with mlx5_lag_for_each().
>=20
> This removes another dependency on the compile-time MLX5_MAX_PORTS bound
> with no functional change.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116103010.1129=
666-1-tariqt@nvidia.com?part=3D9

