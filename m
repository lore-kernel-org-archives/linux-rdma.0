Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770D94BD7B7;
	Thu, 17 Sep 2026 23:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789689170; cv=none; b=mgwtsr81u2txXcQbq8yulw8wZDDmt6vHbURazm4/MVBBmoC7NGSwWIDo6ySm/n+ZNXjTO+UEHkfde2UF7m6qAZwGCsaup2BOi0RNm5FErI0b3XYly4BEC1Wts6VSlFdvbbWyEcF/atoti16SFh5lJ2empH6D5bODgdgP/EBJdgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789689170; c=relaxed/simple;
	bh=M/19vYhMIWr+TJRVw75jkeubKln1BLJoGSPDTdM/8tU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SwrU0fBBeCmjSoayT0JXmjT98ACfCZQbG2aepTBd+mvYZzIcVmH2q4s+g/6o4QY2/jZm7o9pcvPPFbmZ21b3J2qMtb1Z2cJzfR+JulRYdbTBJBg4l+gDt4cAXlHCiwMfyI5wX+RN2pO0PJSfxtQ0V4+HDKyOyia82p3AiLFWZDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EIfVNNzN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EIfVNNzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3BC1F00893;
	Thu, 17 Sep 2026 23:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789689168;
	bh=M/19vYhMIWr+TJRVw75jkeubKln1BLJoGSPDTdM/8tU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EIfVNNzN1VAygZ2f9EAnql/QxzD6RuUqreH+SfJeAeeqxK13FxWBqXVI62RuZ4p2K
	 1L1nb82s5V5n5pH/GJF/GtXYasD3vjGwCT4kT+77NmavbOUK95NL8s9Sbg48ZJbP/B
	 3fYDKgQS4RfeLL/Eec/+vL5+B6dKeWp2R4mpMde3YlBourE3uug1FD9WIdcjRxwnMz
	 VbYZTfvWIu/xWdQ5yVMhHQ0lP4lnxQs/WQipgvNGpCxaM7fyOYcaQHC/ZmWzvolE3N
	 nZubd5881NlwEYg8KNlQaRUsllDoOzosBFIg40rRRG7NohqLu9vSlgCTKaVKGqOCul
	 ChOHpmnWB7Bfg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 10/10] vfio: selftests: mlx5 driver - add send_msi
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: linux-rdma@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <10-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
References: <10-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 23:52:47 +0000
Message-Id: <20260917235248.0D3BC1F00893@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v6-8af36cf7b73f+e=
2-mlx5st_jgg@nvidia.com?part=3D10

