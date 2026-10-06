Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA8C3E7621
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 11:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791284984; cv=none; b=M9+CDTHU7cNGKzGB4wzffRNTpXuuZTrFbx1ygnSooyADdHcKdWoOzHrCjqehGDg+WZsjXkNPIBcb2Q9ZdeN1QLfvqe5t0dDsBitzHFiXC1HNlCh93eWWB4jQKSD4gM2LRx8QIk7mqZWYHQGnRznSegb81dpVeaNgERdjn0Bd35Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791284984; c=relaxed/simple;
	bh=eGhysv8iIbTO5/Os4Nv0eGWt5wqbznUbMiv8ERsemBg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=B+RCWGq+yPbPQZuaH3o1L+FqmUvZZdyQSiExUURNrx7dVg9mQVFbf4GSaIUzCT2uRGzFsXKxkWPE8SyOQAr1TnzDSIxaNwDDDxcnrHcxV3fmnsluCP8Z0Tk/b9K5yZ4zLeeH79FGcYrFqCOfrwmz6PXn2iaATkUzgwmvSWXWDFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aO37ANx4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aO37ANx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C7E1F000FF;
	Tue,  6 Oct 2026 11:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791284982;
	bh=eGhysv8iIbTO5/Os4Nv0eGWt5wqbznUbMiv8ERsemBg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aO37ANx4ukO0+zwJBEHiiQD0R5we3O+SS6dLqIgglw4VbkP0SOjuhlQx9i2QXESJd
	 GgNVrhQ4U9V94FIrkFEKJrztISZDaFsGpOALpoQjKA0gGKr17bZ/RKxq1Qs5ts3rCa
	 sSbGreTG8w0t1qMuxjGn32CmsJ1YyYoDzPlNbzvL2dOs6QbM/ihQIs5qyyx2H/uacN
	 GhSgRIoTY2V/giBvm8r4DPG5RivI6ApfcznfEjgw+/LsPrdQ7oYeJyZY8uM1fW/6P8
	 NAzL+zaNxQBzykjcqSY3rPb5upUgaKYnyuDg/L2FsbfZczlFLcO1jYZzcA7eH3aRAu
	 oaDaCbC0V4oZA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net V2] net/mlx5e: Order ICOSQ cc update after CQ
 doorbell
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261006105820.257208-1-tariqt@nvidia.com>
References: <20261006105820.257208-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 11:09:41 +0000
Message-Id: <20261006110941.D2C7E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Li RongQing <lirongqing@baidu.com>
>=20
> mlx5e_poll_ico_cq() requires sq->cc to be updated only after
> mlx5_cqwq_update_db_record(), otherwise a CQ overrun may occur.
>=20
> The current implementation updates sq->cc before the CQ doorbell
> record, violating this ordering requirement.
>=20
> Update the CQ doorbell record first and use dma_wmb() before updating
> sq->cc. This ensures that the CQ space is released to the device
> before the corresponding ICOSQ consumer index is updated by software.
>=20
> Fixes: fd9b4be8002c ("net/mlx5e: RX, Support multiple outstanding UMR pos=
ts")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006105820.2572=
08-1-tariqt@nvidia.com?part=3D1

