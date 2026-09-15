Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1FF3C5DC3
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482925; cv=none; b=Fa4+/YjQrwKYIUXpkm/hKPoef9I2Bra7mbajEJcLw29GAahiPNMgYcUZd9KasqoUDEzavhodxj396JuHbp1HZU8Dwc6orqLeuWKxACN2fnpVyprWLE9K76pMb7DpjYBR3a/PprzWfsYwcVHWmp+bAmVXXHU+lZ8nlcxRpLBHf94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482925; c=relaxed/simple;
	bh=eNrWQCwwQYZhVahZleew82I/8PCHzOYDEFuYfTxzrQg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ACUqcd2QPymtLAxCxZ44ekPAnivEmJZMGKSTVIMNkXKDuVLdsLWvif4AhxiT86g8MaigDjGazEUQjKuVIWdu0uCX+LZ9mmRd/KImAJRE+lWbjH26gJbPA6GjSC9V1VsrDQRJgobrwB90dav0NZvlwrBtBr0AUv4ShtMVpMQDEyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CC/TDjIy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CC/TDjIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A661F000FF;
	Tue, 15 Sep 2026 14:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482923;
	bh=eNrWQCwwQYZhVahZleew82I/8PCHzOYDEFuYfTxzrQg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CC/TDjIyzYIlicaHPdM7SCmE2A7aj+vB1Ky+/j7cdw1rQ3fvVwxwD182O3X1mrdc1
	 O5UrEPj7yaOU+Am1JqSFdD24nteRr8V7yGnbGNL7lGi4mafIovz2kAOVhq/BJANHAF
	 fnfBB2UjiXjt9mViuVeZUs9CIUxot9r+XgA9hMy89nOUJU57WiyI9esjWg71ZTSawR
	 C2ndzLIFH6lNfJ6JRpw58bqUlDvfKiqXRl0vCW9pWZ5rQekbnhYZv/2nW1YDw906U1
	 gXZE0rJQbBQj9VluaMMbbyFTzwaqw13lgDL7V3bS7/8jG8COF1gyHp3CjcmsuoFnbG
	 921MoEgi/bRzA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 13/15] RDMA/mlx5: Set QP event handler
 before firmware QPC insertion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915140933.40580-14-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
 <20260915140933.40580-14-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 14:35:23 +0000
Message-Id: <20260915143523.88A661F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Four QP creation paths assigned base->container_mibqp and
> base->mqp.event after the firmware create call that inserts the QP into
> dev->qp_table.tree. A firmware error EQE in that window reaches
> qp->event() with a NULL pointer.
>=20
> Move both assignments before the firmware call.
>=20
> Also set ibqp.qp_num inside mlx5_qpc_create_qp() before
> create_resource_common() so an EQE arriving early does not observe
> qp_num=3D=3D0.
>=20
> In addition, add a WARN_ON_ONCE(!qp->event) guard in
> rsc_event_notifier() as a safeguard for future regressions.
>=20
> Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915140933.4058=
0-1-yishaih@nvidia.com?part=3D13

