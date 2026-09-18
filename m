Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6047A4E7804
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 11:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730193; cv=none; b=knfLwF4kzmO7ILhqUlACS5QgA2pGSaqcWz9l4xj3GrFHdCZLv9NQvNZACLfaR7d8kgSvA01SxrxlKxHIt3PNMsXsch8xXHk1DPWv579VLAV1NrNlYdKN+uPTYKopO2a9Pg2GCUbE2SYax9Fi94YPRfLcapVJ2fdEYQQTD6GNgIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730193; c=relaxed/simple;
	bh=FyIubXrgIjweXbPpOY99R+9AK7uo1B8AgLAwB/l/78I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SjP0iLe0AteM6q2BAQiG7xdOmXHZCZnraal9xWzp8TUUjknLmmGV3draGpgmqKT8tBQlfJOKLcgpe26rRY5KNfGGRhxBZfOYSRQ+TR9l1XMyAuMkovv+/zJqyNLT/0waPBlolV1y0CJQN3khdYn841JEcEpC9jTofOXGHXeZVFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=POVZS2+w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="POVZS2+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08B31F0089B;
	Fri, 18 Sep 2026 11:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730191;
	bh=FyIubXrgIjweXbPpOY99R+9AK7uo1B8AgLAwB/l/78I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=POVZS2+wtmNFgiFbkipH8Yge4jLyXYiF8OEZOxmpFPt4svxKatJXaK0AhauvJSxSR
	 brD/xfIDKqTZe449zqbDvHXZCY6sZxKGdjpTZ1lKVHKZAGubhTzaLJLxDcZj1f+6OV
	 Iy1nfmm5T7VzZX4ahgl9lCyCEYKMT5xQOMBF2Wgt5jh0A8llQIYHorjRpBRaIAD2Iy
	 6WdjtEa7J6+WvcYCbsKpMinCjIR3FDq3aY2TibKwCZvKhWCcyR6OGRzqqb60Q6qO50
	 suFnrFuzYoi4KFOTS35UbL6J/Mzj2wLY46uHSCU+ZQFk3R5qznYonMPXpKAY5vytx8
	 DgTPSG92Q4PKg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next 05/10] RDMA/mlx5: Move and rename data direct
 resource functions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917111422.4054862-6-tariqt@nvidia.com>
References: <20260917111422.4054862-1-tariqt@nvidia.com>
 <20260917111422.4054862-6-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:16:30 +0000
Message-Id: <20260918111630.F08B31F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> Move the data direct resource creation/deletion and resource
> struct to be self contained in the data direct file. Rename
> the functions to be consistent with the rest.
>=20
> While at it clear the fields on resource deletion.
>=20
> This is preparation for moving the data direct code to the
> mlx5_core driver. The code has no functional changes.
> Keep the resource struct and function declarations in the IB-local
> data_direct.h header.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917111422.4054=
862-1-tariqt@nvidia.com?part=3D5

