Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16AB4E3EF3
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 11:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730191; cv=none; b=t64g9/uD9sVKo4ZvQzVnVUe7BdN+o3T2jzB5AsjNMCzjK82GP/D/fd6DQvZdX6uum1vFOkaYJLxeU8kKGRc3jns+5pbKkypsTIyzz8INddz9GGhqRQ+ZTgRKUVYhAt+ZFPzm+hM572tyaOMj9jHIdYOZyPcNP/t5U4W7xkNvj/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730191; c=relaxed/simple;
	bh=IRV0DfhBlHN7K20K83VeGaQfkn/x8GOLUf61PkUD/Pk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Cd2M1OiJCnrKnfrGiKtTdzcf0RwI2n8G5VWIFvU9zGLj18QMBh7OkKpuWmNsLFng8gXvt5HZo5SxNqGdortP6tUxRRMj4+ZizxuDoq2B2/f5FKYZaY6NVVjFp6hcu85cA7IfsQYmtmL4QXylgU/ggyhlLLE3OPeYwDKZ+zwQ/6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gU6atsY/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gU6atsY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE641F00899;
	Fri, 18 Sep 2026 11:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730189;
	bh=IRV0DfhBlHN7K20K83VeGaQfkn/x8GOLUf61PkUD/Pk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gU6atsY/Lz7yhMxK+zA2FIyvs1EfaFFGxebL59QlTCbM6sVszKBkndsippNw90vjS
	 zEVttum1WzcZs5CwygMr2wPqKtIKc+6m2FejT6jQcEnciT4h1E6J4EeS9dlu+ur5lc
	 uJ6bmG8Eyk9DnqxbwvqMzFID31+oA9hLtwJd4BBXNVrRZ1+XAxk1//26u/6SrBi+Mt
	 Kh1YTKnXFDRHMFgD9ii++w4x4E5n0deZMIuckhGQFR1Hzp6nfCIyQmKYIHQsGk/X8x
	 eXvup6F+Kd83/SkvaTpdKWSQrVV+6YIaPbzIYRx4UjYDed+3DelQo1c3sG4z6rqzQx
	 zC6DjR8JNBCKQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next 03/10] RDMA/mlx5: Make the data direct VUID
 query self-contained
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917111422.4054862-4-tariqt@nvidia.com>
References: <20260917111422.4054862-1-tariqt@nvidia.com>
 <20260917111422.4054862-4-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:16:29 +0000
Message-Id: <20260918111629.9FE641F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> mlx5_cmd_query_vuid() in cmd.c is generic over the data_direct flag but
> its only caller is the data direct init path, which always passes
> data_direct=3Dtrue.
>=20
> Move it into data_direct.c as mlx5_data_direct_query_vuid(), dropping
> the always-true parameter and hardcoding data_direct=3D1. This groups the
> query with the rest of the data direct code so that it travels together
> when the data direct matching code is relocated to mlx5_core, and lets
> it become static there once the query is folded into the core bind path.
>=20
> This function will become private in a subsequent patch.
>=20
> No functional change.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917111422.4054=
862-1-tariqt@nvidia.com?part=3D3

