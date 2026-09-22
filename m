Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1144DA548;
	Tue, 22 Sep 2026 22:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790116708; cv=none; b=YMszqht2cAOafAcXnHgHZ1qJtTSMksLULJ/uCCNoV2rCSoFYk+3UNx7fM+c3UWBzdz9VMZ2zhmwqpVKD8qU86btaPIideXD+/Trd2I+960FJAvSpjiGWMctyuhLEG0YFnJvfcwW1q1UHy/9srKLoCOj8zeZR4QltBcFLQdOPCAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790116708; c=relaxed/simple;
	bh=PNUmfXo4J0SHVv/YatpV90GEMqCEfbkZL6wCJK6i17s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jUGvGtCjAB7fCrW8HGNh7sNsSoaJmysJJDp/qKPi1s22y9amyOnrwlCdYVZ9YAA8bfFta/arXeRfv+xTLXfGLngNsJZF5BmDT/vMAsLbLKDFW0NXCOiGQ4QIXVm0MW0Df1pCGW1m1WBRkKpwJ5zgTk84ZuXMtZFE4YpDwsO6JiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m4vsfPyu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m4vsfPyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FF41F008A1;
	Tue, 22 Sep 2026 22:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790116691;
	bh=PNUmfXo4J0SHVv/YatpV90GEMqCEfbkZL6wCJK6i17s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m4vsfPyuSLtyNsZvaSFOjxn/m3ju0lyc9rQN8kBGnfmw5NIhmP/lyZANhLZQLxW85
	 QNGKS9cvtfjjc1JYX5PhvGeOAi+69BbPypmWdms7ic5cAhCxODy5LykagV9IrPCJdU
	 ZTQBBr96iwMneXrAh7avRwajVkY3h9eGzRAzKApKQH4xpqfbtP32ecuAICmAI9AMwH
	 Kf+0/MOk0GPdwSx1mSVDpBLnzat2R8rLbatTJlAkvRrfwfTTn1V/ZwnGhVG44kU1Z7
	 aectmrGrrfvOTFHHsVrkbB0Zj4hzwu6xNbWgWd8a+wNY21q7d14nco3Bgn6dA8aZcH
	 k0kATuYH+qmvQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 10/10] vfio: selftests: mlx5 driver - add send_msi
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: "Marc Zyngier" <maz@kernel.org>, linux-rdma@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <10-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
References: <10-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 22:38:11 +0000
Message-Id: <20260922223811.62FF41F008A1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Wire an MSI-X vector to a dedicated EQ so the mlx5 driver supports
> send_msi().
>=20
> Each EQ can be linked to an MSI-X vector, and the CQ can be set up
> to deliver an event to the EQ. Thus, when everything is armed, an
> RDMA WRITE posted to the QP generates a CQE, which generates an
> EQE, which generates an MSI-X.
>=20
> To keep things simple this just re-uses all the existing QPs and
> CQs, so they generate single MSIs during memcpy.
>=20
> send_msi() drains any accumulated MSI EQ events from prior memcpy
> completions, posts a small signaled RDMA Write, then polls the CQ to
> consume the resulting CQE (avoiding stale completions on subsequent
> test cycles).
>=20
> Assisted-by: Claude:claude-opus-4.6
> Acked-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v7-c6d30e8ce1e4+3=
dfa6-mlx5st_jgg@nvidia.com?part=3D10

