Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794911803;
	b=ejS1uczCRrrgzflDi3nFgCAdqCcMZVa3Imrvj2kwAcBWpwfHAmn0yfzDQTO9RxRuXsn5
	 QI9vcWykjugWCHiB8c48omTxqLmVMwmNuHTX5aE7KYDUQPxV25HR9qIBSCUxrYK6TYC/Y
	 jd8RezQ9sMBhiDkPKp5SDcJ1DRzh5qmr7z2qDyey3xV6w+bQ/pU7uXl/FrpcQdI5Kj333
	 FP9ElEoKrS4YMvRkQattCwRBjurkDtIj9CplDfq6t9L6XZ1NnyO1ukToDo35b1KYRXjh7
	 j9708/CjN5hVZrexpO1gBy9SPWf+lT7PM0MBoaeL+J5aRczAc0qYFhO2H0deFx2e14g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794911803;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UEQomq6ABsY/1HrYtp073SyIxw7604IgLapGzWuGkt4=;
	b=RyGegE0a6fclFTspsgfP/Uxse7OkeKDXFKJbx3oUIXBM2qKKUWTcLVv9lZ9B1jIC94tl
	 ruKV4kfKpXVGl2bQdfQHMr1ofeGBjxD5BxWh9PHQxZXtcKE7c9dzR6Y5P9wmx0YDp+vdz
	 mfCToXf/tJUwJ/78TMVgBiNV9EDVeX5O0xOsmlY+J0DW6nzOmiSSu7BBtLNaHtFhuCR4w
	 TanvD6nNF+oTUg5VyQF3UsZNxUl5/KGnkpQff1QIVEVThX5POkNQ76JnEjm72hrDO4woI
	 HBcucbmuwNo6ja11p4UlPFtu/K4uqMQBRS8fKpU3OdhdkwbmchyhaqKI0XYVso884wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jS3OzzRw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E183606A88E
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 10:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jS3OzzRw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670001F000D2;
	Tue, 17 Nov 2026 10:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794911803;
	bh=UEQomq6ABsY/1HrYtp073SyIxw7604IgLapGzWuGkt4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jS3OzzRwetFJxaappnYOfD2u+9TzK9RagihrqBl+/svBLKDTBLnM+ze9yHfBc/6uh
	 1k2nWESQW17DP5QCVl4/6+dSC+zTW0HdyibBEI4W8UMuq7qAdXc0PWq07hKDUm+5HY
	 iLXbqqqtw/74WTO+bLhNPEppN/kfLl8DA9/D+9LNo+DordaNsCIBwqjIfuTl70nNWV
	 Zlhf+QdOmUjFbusFCpShNI0zCYM0RlSzhH9kmLXLsuzhxFtqMzxjOUoGv3B3qT9IOd
	 EM9hLWnUB7aG7Z0rO9F1+PbE7XEzEBcmV85KJ8loeU9ePFNzxByDEwnei2JDuAxAh6
	 eRwCSklXXb9ww==
Message-ID: <sashiko-outbox-218632@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 04/10] net/mlx5: LAG, treat virt LAG as a
 software managed LAG
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261116103010.1129666-5-tariqt@nvidia.com>
References: <20261116103010.1129666-1-tariqt@nvidia.com>
 <20261116103010.1129666-5-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 10:36:41 +0000
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
> mlx5_lag_is_sw_managed() (renamed from mlx5_lag_is_sw_lag()) marks the
> LAG paths the driver builds in software - the LAG demux and vport-LAG -
> which must skip the FW vport-LAG commands. A virt LAG is
> software-managed like an SD LAG.
>=20
> In the same manner, block multipath LAG over virt LAG as well.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116103010.1129=
666-1-tariqt@nvidia.com?part=3D4

