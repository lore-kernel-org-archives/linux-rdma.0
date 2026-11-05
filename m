Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793902344;
	b=PWa7WLdmgUgBQdm1Mr08eXTco570MLKJcmao9xSFPJL5g2Gi9FUq0RUDSITRc59fLv2D
	 97WBUKxFuP38MacIzurt9U75LGVG9a8h7xCHpnBwK1K/Rk2w2aLNcnn1vQjihw3zgYqbU
	 oItjrEmsxc/g3Zw2OOz0O9n+swq9RifS9bSVfGFD21mTq92ECtV65vOrY4tXQa3qt5Xac
	 OvDRznPHYqjqu00xoHvebVM9kaeeQRkCuPfLZv5+xJlzdclGQFVO9dFps2wxMta4L+303
	 Ss8oCU7zi4lt1ttlWy51MqQdtkXtpZ0/9ALOi2n3pUu74/bMMTSkyDUSHZGCmA58xeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793902344;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pk2hzdOTt3gZGP0SLZgVCgj4QDdtrCNuoYQplQK3d6c=;
	b=pIst2eZOrfJa/HnZT1u0XXd9E/2m9u+3ij2AK962H3En1wAFImNJqgTUOYaU0CEGY7U/
	 kq6xts+RJ5WCwr7hOKuFKz866o3YXCrNtL2W8fx5VYWQModP09lRsvvq+GswM36WgMiFI
	 KH9Uzm6YpJ52u2r680s5I0xY1DmqhkWR+4707yzDJOV5cHMSPAOj+NF3BQbHf/KaqXw8x
	 3dXZmgl4B2ZHsMA4iphENmYBc4Y+GE5jOKb96VPi2BzrfRwNGzqoADNpnmdEjWqGiBwO3
	 U8oYrYchDIS5NkWUcMN+pTxmGn31qQJLpuOlFFqXNDha4QnVxh7e+BicuDp1jyyD8Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ooypNmYF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC57606A329
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 18:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ooypNmYF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0E41F000C1;
	Thu,  5 Nov 2026 18:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793902343;
	bh=pk2hzdOTt3gZGP0SLZgVCgj4QDdtrCNuoYQplQK3d6c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ooypNmYFgZZRnuKMCccPJ9/RYm19xLLfiHxcdlessoRFuniDov0HQxfG2PzflsdvU
	 DifRqL+ZDjRDwQ4FlzKCs8AusJ2vVd8dVQb88jzgXvwhvocLB46zGWXXj6qvDY2bOc
	 pIXvU27h5LwpkjRcK1XlQM++a7gQQqIF5YP+WCoMlrGSKMJg+JB9ziXE+VMwLrs3t8
	 5z4CsIpRF1ylSJO4qIidtmmx9+PnmcFPNVvD/k/Lid1LVwZZj/6t6bVFSY+6jnPiS9
	 UbDd0t8NGajoz9KOztZcBNAFVLs5IIVIkuZDw6CZlhqm6mNHOuD7zeANLfAZPnax21
	 8ztXI4Qj4Iz2w==
Message-ID: <sashiko-outbox-199702@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v9 6/9] RDMA/mana_ib: Post send and
 memory-management WRs on RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261105175928.1326682-7-kotaranov@linux.microsoft.com>
References: <20261105175928.1326682-1-kotaranov@linux.microsoft.com>
 <20261105175928.1326682-7-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 18:12:23 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement send work request posting for RC QPs. Post communication WRs
> to the send queue and memory WRs to the memory management queue.
>=20
> Advertise the memory management extensions on adapters that support
> extended WQEs.
>=20
> Annotate the immediate-data OOB fields as little-endian to match
> the encoded values and avoid Sparse endianness warnings.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105175928.1326=
682-1-kotaranov@linux.microsoft.com?part=3D6

