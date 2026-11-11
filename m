Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794422431;
	b=SigPUXjt9RCs7oxJ4d+esfnPPjLFJwAnTXRDqF30ps9xDHsgf1/KrXQ/LJk0X9sPy3mZ
	 5qKgKgCn3QM+2imIgfAi2beVifZGiIRb0C7GdhfI/ejm8he8QQlCirp4id55DjWGAlgwp
	 BJKv3VJr6wdCteo6INDTWkrjMJNoAtyloZGHl+3+4nG2C/agtWNbnb12DAgZ4j0Pq12DB
	 +ovYGo60D6A2hZqWzkcn6UJc8ITHtwJLNKuEdoH9ignJai0KFAVU15yHlI1ImqAPY7Iup
	 oy0czI0SNo/cF9dqcGq8/ebtTNt7zn/m7mDns0U2qwwL6OysXLKG3vidRs7zgO15bfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794422431;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GYKa579jaqMipbOroXz3Y51F15m4MKNBMRHrCriUW0g=;
	b=gvR/ZVG1FuYUeXA/RoU/E6TelHEUczSBRbBGg1TfzcmllQFOs0f0Xc43BI35rW39e89L
	 tf1iswVyI+xK39rZM7zmrF3hmTO8MiJttBwI/eck+If2TW4+CkWO0JJa05lSyIIvuDIP7
	 dUIopVDYH0mdkztN9Jb7suPkArECur/3vWVGDnyJ9qXwuL73PPY+PIG8uww8/edNx4VaI
	 2ibD1tGRvEtJuOU94kcn83SgQbkrtZ8oZGLU+JD6S05DruMhyt0eOqI6KUZG1m4I4BQfF
	 gLnfZYo4vS5SWujfvBsqYcDLwIp2ERl4l5uasUG81n3oCq7x09RzxvAxK99m0MWSwFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VDCqYnJB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293B1606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 18:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VDCqYnJB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839F51F00A05;
	Wed, 11 Nov 2026 18:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794422430;
	bh=GYKa579jaqMipbOroXz3Y51F15m4MKNBMRHrCriUW0g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VDCqYnJBbCflmRRe+89nsKEc+QalpjVb1C9LflCPD+hdma7A81QeY+9WJA8iIOOEA
	 38jrbdcvtliQmtp3VLaqhDAmaYvGIaFNk/8rLn4INZ24+Z5PIINgbXVX05tWapg5MW
	 TZ9IByft1PV/hEaC9xj0Q5MW2AOf+tXWhq+mjiIVu3dphwbB3hXN3pQNj4dy17cAB7
	 7kIaPmrqzxTVypIvR+Yw+2dJtnf2CBN3Q2bGK0SXLEfTRCZaTmPpKIuOJSxKc0gSXJ
	 c8cy+MOZcKOYkeNnfKKz0YZ/ZZDSAQngE+B1obVINhQJ5qIaCbJspsbVdEh3GM4Gbs
	 oPcuHuWyFBszw==
Message-ID: <sashiko-outbox-209469@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 01/13] net/mlx5: Log the data direct to PF
 device mapping
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110183826.2927274-2-tariqt@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
 <20261110183826.2927274-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 18:40:30 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> Emit an informational message when a data direct device is bound to a
> PF, showing the data direct BDF alongside the PF BDF (the mlx5_core log
> prefix), to make the mapping observable from dmesg.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110183826.2927=
274-1-tariqt@nvidia.com?part=3D1

