Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673384C9E08
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 11:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790769366; cv=none; b=L6fWbNQsWWRdyTQ2tOmoZPmbxXp0/3/nWI0scdnyR5piUR5tWg4RROfCgqYN3gFBbmkQBGvXjwTprFokB983+hyhUfd+fZOYuHiewmCufs8c3W8qBTduthrFSPxXF4oJBaQw8qBtcdCn9Z3CSnKDRLSKUuRQOsvadYRXUmIRCCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790769366; c=relaxed/simple;
	bh=hPiV46Wwr3QLpYKG4/zvtaE9ziTfuSWhG3Ef8dvXHwk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HySv0mVGt66z/1h/xa0Ka0G6KRe6iZmf+YqpJyG9REqSx553Tn1tZet/63NWLcTaubLEUje1EeHJ+z7wuWN87RPtgYWUH1FwVu/2yIxNzwYj9eM3X+bLuaA/OkI4xYhaEu463gReUf7tcqjn4GXINQuu7O6aHR+F8shFJT8XaZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mqi9Ph54; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mqi9Ph54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFD21F000FF;
	Wed, 30 Sep 2026 11:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790769365;
	bh=hPiV46Wwr3QLpYKG4/zvtaE9ziTfuSWhG3Ef8dvXHwk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mqi9Ph54vegEQguh+GEQO4+P3NwbpCp3wgoqNY1fZ4AMSNumGcTJNIY8kOSCUqJlb
	 EVjPsiQbOgWNEbSYtlvaBfRalBZcvqHp58PxnIX6JGaJ0alxWW8j/Ax5J/ImLgBTRq
	 gs9zV1bs7YGNRWp55gK4r2P9RhYzdOhS9Om9dTWK0LrAGBuC4MRK0F+MEHB5vse/8f
	 re0jtaDNG4ZTRHgtQg3H04UBwDeqKT3ZZMzJTOH8YPCnpck4kWkp8wNvF/lhWZs8OS
	 WtcxCKW78iAC55Oty5frBHOAKOMp8d+Shkmq5Uws1Gw9mKdsvX/p9MabmzCxFN+6xp
	 roZk7UKi/uQwA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next V2 10/10] mlx5: Move data direct
 implementation to mlx5_core
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930114227.139274-11-tariqt@nvidia.com>
References: <20260930114227.139274-1-tariqt@nvidia.com>
 <20260930114227.139274-11-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 11:56:04 +0000
Message-Id: <20260930115605.2FFD21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> As data direct will also be used by netdev devices, move the data direct
> code to mlx5_core. Now mlx5_core is responsible for data direct
> initialization and resource creation.
>=20
> Now data_direct is initialized in mlx5_load() before attaching consumers
> and clean it up in mlx5_unload() after detaching them. The data direct
> PCI driver is moved and registered in mlx5_core.
>=20
> IB specific work stays in mlx5_ib: notifier registration, mutex
> initialization and MR list initialization.
>=20
> Failure to query the VUID is now fatal because this is done only on
> devices that support data direct. Other than this, this patch has no
> additional functional changes.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930114227.1392=
74-1-tariqt@nvidia.com?part=3D10

