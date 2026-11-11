Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794408536;
	b=vocOV8wFL6CB+BiIMrX9v/UHRKPHn3qbcsKThH0fxsv9YgVkoOuk0DTfE+ZyIb1rQOrg
	 AXpwbWqa3zNigSwqpn0ryvuVFU3hWUpCYbRxr+PR8r1xy8tmLtwWs6vq5qlpMneU8nhni
	 Y4/ARm++l5EoWGk4NuRimJUysV/Unjsbc6X7j1LPr8r2QzsYdiE1xb1JJjGbx3CHVgtO4
	 vkoMcliYfrc42YqX6Kft7dFrKfnY/yM7N8qEfaGahBPsNahkN9uYXh5jmKNUVAfqoKm8g
	 7MP5jixsF86O6KB8WRx3j8RtWRmWEwe7Mmu4j0tlXrwW/MB+zyIkIQ68hoL/Cz6ISvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794408536;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gFTBcYWeLeBPEONSeocFblGDpZdJstpCic/d0dN8QVY=;
	b=LapMUW+CDg4VFS1N7dV6AotaLaeTxbVYjgwYZDsXQ0RCxhDpxhvbcjh7mnXvKbJphenI
	 cjm+UxcvY28RzmzNcUippooQswTGGuYMIscxVafaZ/x5IG1xd0psIQy3hoFwrwh5pB+UA
	 83oFza5cPTfNLnEZgVoz+Wy7eT815RGOvZmws7RplIcRBy0ruhalixh9sB401Yh7Iwoa2
	 R2HyRrmP6epGSUpwOWQ+dPCQbTPYIY1Zu7/I4iBk2yUV4tGYmlrXZr4s0dQ5YbKNPXUuh
	 YtiIMkqo+0IMEQSK+g+8eGvo8FnXeW/fZrDmQxvEOsXJK3v2AvI1CwzdWqOKQDFGlmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mltoy4jq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C603606A324
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 14:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mltoy4jq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1E71F00A06;
	Wed, 11 Nov 2026 14:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794408535;
	bh=gFTBcYWeLeBPEONSeocFblGDpZdJstpCic/d0dN8QVY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Mltoy4jqSdLPSJQ+lxvcttkuOHncdTySVObFymcrLNTF71aqdkg42tLOhy7dB9857
	 LUfBX3Xi6rLxh6/rtkuhbT807vmVymo6USE6cxyR0UmROVMGySynMoOR+sjRY6IuEP
	 1OtTrXbpvDXAneQEtex7KnkMgDs/WDvoAUkfpb+xBFfNNGxJn835XeaGritNv6dgQW
	 MNLAwxiaazV5a23wrBcGz3/MAgjgrgSyq2sNJRGX/vi65FkPBT4hauRwU+fT8Bzztw
	 oP93OYDJAMKLZLJCBy14bXWwQiqGNnbQ0QW4v8E0h8V2PYdIxZb9pTfN/u81lNB2LS
	 WSYL0jR/4Fk/w==
Message-ID: <sashiko-outbox-209193@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 1/3] RDMA/mlx5: Respect pgsz_bitmap when
 reducing the DEVX UMEM page size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111-devx-umem-mailbox-overflow-v2-1-1e7ca8237b58@nvidia.com>
References: <20261111-devx-umem-mailbox-overflow-v2-0-1e7ca8237b58@nvidia.com>
 <20261111-devx-umem-mailbox-overflow-v2-1-1e7ca8237b58@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 14:48:55 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> devx_umem_find_best_pgsize() starts from the largest usable page size
> allowed by the user's pgsz_bitmap and halves it until the umem starts
> on a page boundary and its length is a multiple of the page size. The
> halving ignores pgsz_bitmap, so the umem can be created with a page
> size userspace did not allow, although the bitmap is meant to reflect
> the HW limits of the intended use of the umem.
>=20
> Step down to the next smaller size in pgsz_bitmap instead, and fail
> the registration if none is left. The default bitmap includes every
> power-of-two page size from 4K up, so the result is unchanged when
> userspace does not pass one.
>=20
> The Sashiko AI reviewer found this while reviewing another DEVX UMEM
> patch.
>=20
> Fixes: 7610ab57de56 ("RDMA/mlx5: Allow larger pages in DevX umem")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/linux-rdma/sashiko-outbox-205134@kernel.o=
rg/
> Signed-off-by: Edward Srouji <edwards@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-devx-umem-=
mailbox-overflow-v2-0-1e7ca8237b58@nvidia.com?part=3D1

