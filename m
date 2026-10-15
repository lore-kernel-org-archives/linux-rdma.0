Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD7D3E2ADA
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 08:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792052325; cv=none; b=uNaiB8l1vl47vKnvg+Jp78cZtKHcpn3+uzRPtBb/tVsP/cauOpP6bQkD8Csggz97DGOlmWVxeZMoAMVufzHt+ND3j9Xg7FNX/Fx2hdWh0HmA3cH1RAdx9PWPN/+pnw743JgxizHQLQta0lU3RadGdXPmzR0EJ1SYmqzYyPTk6OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792052325; c=relaxed/simple;
	bh=Il811EfvIThKieWULgfBXnUAHu+6Dmp46ATjJdZNsZQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=SLzJXr6tVnWZP+HzLgPX3JzD40290/urqEw+ZbiN8zfdt0Xrq0BAY+AmuZh3MzL1+jxY3sQPteAFZsdt/DqYki4bKBxTbLFKfjfgIkr3Trte0l2xJLRwLmji/C3d1ZkninXuqvCYX/YOfg7VzMpjCHtNE4zm0GHDOUOLoTnOnS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YBL1yejn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YBL1yejn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C5A1F000C4;
	Thu, 15 Oct 2026 08:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792052324;
	bh=Il811EfvIThKieWULgfBXnUAHu+6Dmp46ATjJdZNsZQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YBL1yejnwHRTQUoKgho9kX/pKECM0g3Ke0qyj8XUqupM9HJdVPQTq+wp7fCXV3nVQ
	 r00zCcEstig3uhA0AcZIEEUdSszX31gtkCJD7g3RSGntJscMApZrVJbCISBcDYIol2
	 KgzLhPEclVQxF0kZ555VV16WfTCRJbngru7fjz9/s61xH3TojYaUF3PFroiYxaD/UI
	 CxOVTCI1wvJlZoNO6035SnvPYyyUn9QPpSjkBX/eAusAD9cfS3KAV0lePJWOWsbO5m
	 Dea0NvGw8wi1LqKUmAetfkF6Y+mqaD6VgK7QtBmKcBiflHyFl/tJTkhoHWVPNPeJmM
	 SKOdDLiEEuJRA==
Message-ID: <sashiko-outbox-172459@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5e: Fix NULL deref in PTP TX timestamp
 recovery warn
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261015080218.1102172-1-tariqt@nvidia.com>
References: <20261015080218.1102172-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 08:18:43 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Carolina Jubran <cjubran@nvidia.com>
>=20
> PTP SQs are allocated via mlx5e_ptp_alloc_txqsq(), which never sets
> sq->channel. The excessive port timestamp delta recovery path
> incorrectly used sq->channel->netdev for netdev_warn(), causing a NULL
> pointer dereference. Use sq->netdev instead.
>=20
> Fixes: 391dad2e686f ("net/mlx5e: Recover SQ on excessive PTP TX timestamp=
 delta")
> Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
> Reviewed-by: Alex Lazar <alazar@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015080218.1102=
172-1-tariqt@nvidia.com?part=3D1

