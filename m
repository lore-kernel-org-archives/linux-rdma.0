Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6960C221DAE
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 04:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792213173; cv=none; b=pc0xZJsHx/eMedLrKetMdKLP1Po0MpvavjUCBfGM6cXBqBSSLSg6ZBBt4GacVfw0gBBCB/GolV+EvB3IaM7xgSTrbSSmzca9hzkH8oldtUYDF7ATggX/Z5L3aIXGzQP4ixo6Mpro6ka8VqqWc3NbMnhpGWMerAzEZvlSEZmUGKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792213173; c=relaxed/simple;
	bh=YOVe8fP5Xue5KKUcZwCx1Ag+b3By+De5pDcE3floz3A=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=hGgkaeI8VVwnG4H1+RBwDeVll3pshsm/vlHyQqq3GMKVBnugNu2J6I0MiWM9V1uitEKUcn2h5kKEgqo/gwsbCfZ4wx/rYJEGRLZ/Z+kvCQ8pQD0MNOclVp02btNRL/NR3PpbHZ+0PAlhqiz5pQUOACP3vIKXcI/o9a6RWqrEpAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BD8Ty3fV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BD8Ty3fV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56B11F000C4;
	Sat, 17 Oct 2026 04:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792213172;
	bh=YOVe8fP5Xue5KKUcZwCx1Ag+b3By+De5pDcE3floz3A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BD8Ty3fV5IPPyOyMcdxmrtRZqloeVwRE1z21J1rjG/f8DN29OP+6wHqUJUIGPTrH/
	 acjc8hEHk3+eWB81c5UlCWcA/1ZKeBLJ8aGxZtes1cfcnZf6OhAsTaWT38KY9Qi85p
	 qRZ3A4YJrytFeWymHaVIZiDOUl1tyU9Kj3Vgy+9e7WuEknxIyaeGikKHAohv1E568P
	 5QOdI0NwLlSOnRvvdTKF54PQpsRcKMMCte/8Ky7pIUwpl29N+EGAOJJwNkjqt6jVov
	 T5E3TywAFaWul6j+HAWLpIr8Qz70uo7M1+T5Knl1NkDroXUaXkBZyK7xKvrW7Jb8Mg
	 fL4dLBZYrjOmA==
Message-ID: <sashiko-outbox-175294@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 1/4] net/mlx5: Don't free the ASO CQ if
 destroying it fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yuho Choi" <oss.patchbox@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261016045849.813696-7-oss.patchbox@gmail.com>
References: <20261016045849.813696-6-oss.patchbox@gmail.com>
 <20261016045849.813696-7-oss.patchbox@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 04:59:31 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> mlx5_aso_destroy_cq() ignores the result of mlx5_core_destroy_cq() and
> frees the CQ buffer and doorbell record anyway, and its callers then
> free the struct mlx5_aso that embeds the CQ. If DESTROY_CQ fails, the
> CQ may still exist in firmware and retain access to its buffer and
> doorbell record. mlx5_core_destroy_cq() also returns early in that case,
> without waiting for EQ handlers that may already hold a reference to
> the CQ.
>=20
> Return the error from mlx5_aso_destroy_cq() and keep both the buffer
> and the struct mlx5_aso when it fails, as the regular mlx5_ib CQ destroy
> path does. A device in internal error is not affected, since the mlx5
> core reports success for DESTROY_CQ in that state.
>=20
> Fixes: cdd04f4d4d71 ("net/mlx5: Add support to create SQ and CQ for ASO")
> Assisted-by: LLM
> Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016045849.8136=
96-6-oss.patchbox@gmail.com?part=3D1

