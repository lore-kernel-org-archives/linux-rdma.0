Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792485906;
	b=CyEoy6SYgWjzVgaEn0YzunwBXGP/NY26jvVjXgoiLgk9Du2Yzlch2VzeG0c26QosBAle
	 p5D6FvPnTE2VCJEGqFDdIj8Ty3HD2qhurwBwwAWcNjQO9oeF/Ey1rTNDSLquqdneiw5Jr
	 oR6xOIhl8fFNia1j+CESbkSp9e5rRlbuxLZs+/32MleYT5Ak52nonVofwfJpm8Z+sYmBX
	 4j6Egx4+szB7LUG5JEOLjBSbYerNC3y1XuVfqjVg8VeRKbd6qLahiDwgSsj5YGYx5Mrdq
	 dAOUJycqyHaxdepKy+ogTgBDgS/RXvLthLC5yKt0eFHBaaPb4VbVRrMQsRByvoxXprg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792485906;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ylM7lspDJ9sdotrDjVsIdQlitvHEsImCTtGDeRU4tok=;
	b=civIs7zheX+tGSuV7rt4ANSYIKmBlugt4ff/DryUmbLbpPejLGVWFZ4/xSXK/IBg84mR
	 EUgX5wDO5rgafTNhETj01OiuUeGrP+dy2nijuADDP/FzN+zwXEq29VkcZ+f4/lN3hl5lA
	 ztsbrmkts8mt+EOMNk2veSSeJGzgG7dRPpTPlAEgLfs3x0mJ5Ld2nhS5Q4cIMs/PJcTZ1
	 ym4RkklVsZvK9Jq/P8bPvmC1QIlhOzeGVrUYWgjnwVeA1FEljkacEOvgaMPriZex5ibft
	 L0Vn6o2WSztMgKNq7vlQc1pr0fNDuqNU9ufExyLI8L+1Eq24G2u7qkJq0Ur9ycWD4hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fr4oH+34;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7893606A33B
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 08:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fr4oH+34
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F96A1F000C6;
	Tue, 20 Oct 2026 08:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792485905;
	bh=ylM7lspDJ9sdotrDjVsIdQlitvHEsImCTtGDeRU4tok=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fr4oH+34+xISgjeotChuoUmJce9l5YwMw8nmyrCHOhYFWxa7ZGl7bfkqccCRlEjGc
	 VG7kop5982GqZqY/WVIkwzYel8Gl/pcg3sqNJD4vgNoccjdXk00tfv2Nthwtx0dmBZ
	 DkILLFNudKrkX/wYZXvYnXTJS2LkKvsQezQbTdHMKepQHw2pVMIN+AqO3pAPuIOxuS
	 /QV8VWaJwKGB1/fP4HK/+ciLNreIvBRl5Xq9RiwFml2uZ9wzILKeoQLx2WFNVVNtmr
	 7tTDdCN2CbsvHpWs4v751m3GfXHMmb0OVjHCapkesIYfA6k66ZBJwWOdATOHIRKMA3
	 CY96iHvipbNGQ==
Message-ID: <sashiko-outbox-178611@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 06/13] RDMA/core: query the semantics a
 queue pair type guarantees
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019-uet-ib-core-v2-6-8bd654f25370@broadcom.com>
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
 <20261019-uet-ib-core-v2-6-8bd654f25370@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 08:45:04 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> An unconnected transport orders far less than a connected one, and how
> much varies by device. Add a device method that reports, for a queue pair
> type, which operations it orders against which, the largest packet it
> puts on the wire, and how wide an immediate it carries.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019-uet-ib-cor=
e-v2-0-8bd654f25370@broadcom.com?part=3D6

