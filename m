Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794401320;
	b=WjXv7Vg1DBpGN0yVEkpFRFtEgW8y/6ZgB1UBmw7RgBO3ZFjGSs/aBXBCVMi4q0eCX7eI
	 7kadGiH0jKtTKXuAFdHbOcqnDULniSRFPU2r1o/v9rN++GJgE9DxhZ+nEL9wed85NgQm0
	 xRJmdh/ekYn3fLpZb/R5MIIRAt7GXMRaMPvNl+kj7oTeZvzO9ECq2O3I1FpPxsPZvjSg0
	 zLT78w5nzrtJYBt6gBGOwkUyP/1aIeoJ0Xz7U7UC77xAh3DjPoF5jc5CLmfz7I/F+oKFa
	 /mFufRevqB7x0cEsFoQvvRYh9UrLagu8FoPzYVGpSe2/rOPDpdbzz6xel9axcUo+pgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794401320;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JKGeFaQQMXC93vnJve4QjnWfntLa2HzFS+1wijSXNB0=;
	b=L0+ChtIzl9J2UpWDBs3x+4fGwEC7XoUyqxuPl+qwV7sKM7kq/pJMyBx3dYmlVBb1RrP2
	 fghw0IlK64WF7Y0j29VJfUauu5tf3ly8tNp+9hVElTW1a/sn1qpYawls79Fcq6fucaFLi
	 yZLL01TgvMounZcrrjMuUK2LkiHCi3NzgpVarnnKkbsILmAlRhnM9g5eI4Xa2Z14SILOI
	 KOTZrjyYWjTdcskw9XC6M9L1UBZUbQhgWNMWOsYBxJM7xgvkYZLvrqSGJzYsZQMXa/M+N
	 VCwMN5EQ3b+QNGRaS21uLHsFWSxXSjNy62c4RC80QRIR6LMT9rbztXuCR/y+KyZnSDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MvD3+umq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93FD606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 12:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MvD3+umq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6141F00A05;
	Wed, 11 Nov 2026 12:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794401320;
	bh=JKGeFaQQMXC93vnJve4QjnWfntLa2HzFS+1wijSXNB0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MvD3+umqjeUa45ngl9ibjtB3Lx6HAVU5hTBaf2pNMr6ZncfsGa+F+aeF/keCfNGlO
	 4FSycFhppOm4yLB3L+Kx+GG31AjqB7b28e1YMi+72pzkUSaFLESrYhPvtrJwYp916Q
	 fuLwWSIfPjqt2aj+OoyV2ZuGmLTZiImX8ufpLh8iPLKrpvwMhEpjY/ooEEGd/XC5rd
	 dkrgOMUvUVXukQw7UySbs4p7ZrorhjzQKSQPweR4GOK0izv7sqImHRnVQFfg0BkdH9
	 9gqqd/quxhpKxEUBQ4rKPcvex2Pjr3mBsovzEdnw7TM84wb4TuQ4MnAOj/y8SMP6QZ
	 bqSLDTCz1Gnkw==
Message-ID: <sashiko-outbox-209014@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v10 2/9] RDMA/mana: Create and destroy kernel
 RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111121417.1265896-3-kotaranov@linux.microsoft.com>
References: <20261111121417.1265896-1-kotaranov@linux.microsoft.com>
 <20261111121417.1265896-3-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 12:48:39 +0000
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
> Implement kernel RC QP creation and destruction. This feature requires
> extended-WQE and power-of-two-SQ support from the HW.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111121417.1265=
896-1-kotaranov@linux.microsoft.com?part=3D2

