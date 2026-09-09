Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E205C3A873C
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 06:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788936939; cv=none; b=Hxg/9542ZTD70a/l45eFpgPEouZcF3ymsBuwpdqjhpO/yaHXXjvcrPCq7HN+vOASypnUzsxZ37m8IGv03hVRLk81bjaMZO7cLPfx60qjorFRnHP3bjSTpDJXRMX1MzywXfodnndWfLcwR8/PXN4DdZ4boubd3bIB6vk5OLPB9w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788936939; c=relaxed/simple;
	bh=oBb/27DAY9sSUqD+lAKLo/ukJ0+Vbmrj6gwPZvHxiR8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MjJNyBx1kMJebwB60Ff4g1JnUTvY3n7pjWRups7iDEG0lJfAxfEhaJ8NVV0B7YtJuXwa3dJBCmGRiciC6MCTAbSSSpBjJBDw95CZlxqmv/4rf+Xe5Syjr6rqSJ6FJ+SRePmcbJ7gmNaTUT0kh9fPd7mIOw6yUn9Gul/oEwKsDW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RldNgmS9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RldNgmS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0DF1F00A3A;
	Wed,  9 Sep 2026 06:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788936937;
	bh=oBb/27DAY9sSUqD+lAKLo/ukJ0+Vbmrj6gwPZvHxiR8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RldNgmS9EZrRnfwQdm6EmQNGCjkSjOfx+VoYrSjVEM/rhHehaOdZesyvhd45SpCXF
	 vMNhwjpRmzYOno3BLhmI9Dp5jVZRK55wLjMuajs2g5+cYlGvv14ap+42Nn5DqwEacK
	 IMtxM4J88+haM/7QlR9Nuq+pijIOlsTuDCGuHZR6xUxpq2hnbJzVBByXtrpt0Kh3R+
	 laT+7SEWzqiR5PRdTttOS6TYzvxmOYoHJHsR8L7axvU/fM9Gkck+0hcPI7NPl/HXzq
	 fYtxXNPICSgatCwyGtsySIfdt6AlydcbC1OjkgLxhJey5geFdl9oYwzmd60FE2IMoy
	 pMXNfwj/Bxx9Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V4 02/14] net/mlx5e: ipsec: Block TC offload
 when IPsec is enabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260908065244.3799142-3-tariqt@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
 <20260908065244.3799142-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 06:55:37 +0000
Message-Id: <20260909065537.7C0DF1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> Currently the mutual exclusion mechanism is only used in packet offload
> mode. But with the upcoming changes to flow_tag, all RX IPsec flows need
> to block TC offload, so do that with the help of a small helper.
>=20
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908065244.3799=
142-1-tariqt@nvidia.com?part=3D2

