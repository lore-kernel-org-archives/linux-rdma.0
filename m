Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794490509;
	b=qX859xLpUOWTwKiD19sMq7KS7kQgsOZahLfsM/MWjrbWxGvSMpPKjnHRlIChk8a7XSAD
	 J5ZckBMactoWVxRFYYbY1TwrYtoVBw2tLdUqSYMNhgtLWutgkeL1bHivnvb+OEus+X+yE
	 P/PhOcroJVFlijwDspXUwRc7TVhMngRFUfltKDmfc8RRgUG9kJ/KxL248HRN7OCLh77Yx
	 SbxkvqGP+o4/KwYt+Okrg0QRfOKGdHimRMNV8Xm3IHW7DpNnPhE1VNuO+Gd6ksJSPZlVG
	 YZ4ktz8fLm9AI1oxJbToBm/lnnLjv/w+UQxNqTZFkOI1Pqs/XioN8jOtinzkWM90UpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794490509;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bBUR70Tu7fIfM3kTnM8gYilyl6eTMSn1RVZ6TreSGVM=;
	b=t87EFF4A9vUQ5aUnYTQ5r1ugYucyUZfjOk8L6MkkpE0bOGlILaxDvwHtR6RQSjG1OWb7
	 T8AkKgxWMPCYBP5pPm/3XwqDkZgf1/WK8pY6ljVLeI+GQZeeFIzD2F8rJrCFGTTtQXbAP
	 3dmrW7atb2A2sHoMLRfbVLFTCPJzeOD97XuawoxWI1y5o37s5LxYWyosxrYRC+X1aT0Lb
	 TG+lqS/V1I5EyDjxZToLhHjndCcFEmpo6CgzZSFI0A4vtwMhLg1xJr8PIcdh+kk8OuuFs
	 chqH5ZCw1/UCuqh0rszmjMNI9C48A4/0EitCNv0bsqhmRiqDxqMXTpbSuuUI2esB+nA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CO1zM2nQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F57606A321
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 13:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CO1zM2nQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62AF1F00A0D;
	Thu, 12 Nov 2026 13:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794490508;
	bh=bBUR70Tu7fIfM3kTnM8gYilyl6eTMSn1RVZ6TreSGVM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CO1zM2nQBD7gxOyZ00JSfxJBLq0qdv9uE+RaSh5S8wuYCF2pGLy8YtUGKAg2PFWRy
	 hKtJDwjGkPG9yXxM+V2hQ1XvpkbRfGx6V+uy10Ht3jTleH45m0vchC94RE1jANWtxq
	 5a0MxHKwFRcxNqyaBbJ7B2rdy63JolvkWkcNoIin0e8EskMpAIHgU3SER49viQEJha
	 OGdP5z7ATabJULi0ThtiDNk4Rcp+Cc2dUoOFUOdaFXLx1J0LsergBY5cr26JOQLtK7
	 4JdNcdKec9KAiUjnAJBYF99o0kmXrn4cMxeylqX7vTvKjVYlN+QzzTKYI/xAynG1eq
	 byVIUa+4NTwbQ==
Message-ID: <sashiko-outbox-211197@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/mlx5: Skip vport context query on FW
 without ib_virt support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261112-moshe-ib-virt-guard-v1-1-6d2caf8bdb1b@nvidia.com>
References: <20261112-moshe-ib-virt-guard-v1-1-6d2caf8bdb1b@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 13:35:08 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Moshe Shemesh <moshe@nvidia.com>
>=20
> Since commit b02289b3d60f ("RDMA: Validate grh_required when handling
> AVs"), mlx5_port_immutable() unconditionally issues
> QUERY_HCA_VPORT_CONTEXT on InfiniBand ports to read grh_required.
> Devices that do not support the InfiniBand virtualization interface
> (ib_virt cleared) are not guaranteed to implement this command. For
> example, Connect-IB with FW 10.10.5020 rejects it and mlx5_ib fails to
> probe:
>=20
>   mlx5_core 0000:01:00.0: mlx5_cmd_out_err:810:(pid 731): QUERY_HCA_VPORT=
_CONTEXT(0x762) op_mod(0x0) failed, status bad operation(0x2), syndrome (0x=
3590f5), err(-22)
>   infiniband mlx5_0: Couldn't create per-port data
>   mlx5_ib.rdma: probe of mlx5_core.rdma.0 failed with error -12
>=20
> All other HCA vport context users in mlx5_ib are already gated on
> [ ... ]
> Reported-by: Tony Battersby <tonyb@cybernetics.com>
> Closes: https://lore.kernel.org/all/064dfa67-8fd4-40f0-b925-6d1e0cd42e6a@=
cybernetics.com/
> Tested-by: Tony Battersby <tonyb@cybernetics.com>
> Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Edward Srouji <edwards@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112-moshe-ib-v=
irt-guard-v1-1-6d2caf8bdb1b@nvidia.com?part=3D1

