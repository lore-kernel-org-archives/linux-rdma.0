Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794932177;
	b=ESkeXy4/I8nfbMJ5VnL/dptICSbvTE8wtpogrQcsKTyQ4UvJ8HX+4tJEWSHhe6Y/X9dQ
	 AWCKkkQxTtFwIx3xuGlYYKMPGG1ZAHfTFKTjidBJKQNPb3Pqp8rV8DpOabBrq/PXHxHB9
	 2nxdFXGLtF7BY7XaI9oMz/r7/F2WP9byr1Y8EpIBxuyt8Ohh3jbfdbCJLAG8AayxxVq/f
	 Nc/DF5R8XbbenjHEbSXAHBmSUs/8iEz6wwuUcGU903X+yF9fYS9anRo4HTtmpys8eC7dk
	 KbnJbKu72Q9P6biouNMnlh5/GTaTnwI5Rzcehii5o9ir7ztzTPVquKS6Rnyl/tvBnIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794932177;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=yVizmmJPXDWQmvC39hVtId9oKupqzWqiVIwoQxeDSn0=;
	b=zl7IRH0mwS8y+4nGW3U/IKhQg/dOv3DgSME9XVdRpkkAr7X+6X/T3E2GqoyfH9Cy5GKN
	 c55GeikcN+/Y02vmXqRHi7Yfr0lcYdk29SUgZFymm+hy3UF6am7CUtKU5C9c5UkSDm/gb
	 vdKwwHHW/busOoSuoF9nQkMa2GMN9QhO/kxQRbLA2kdNTZmPJfjM8alnerupHCKzzAGDy
	 L75vwNhNtakhFOCcYWLzJCq1LaTKuUsXun/ex3aTgcSDzM6H8ZbMINLzW3xBBdPTJSc3+
	 B4QI83SYe2c2ubiqNNN6GdDecd095md/8mGmAFdhqh/XOowZwxVIjAoTCq+HYQFdnMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XdV8VsxC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B993606A332
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 16:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XdV8VsxC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30EE61F000C4;
	Tue, 17 Nov 2026 16:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794932177;
	bh=yVizmmJPXDWQmvC39hVtId9oKupqzWqiVIwoQxeDSn0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XdV8VsxCFPLIH1/A6pT+muxZKDqLSZe4ILR+B6+GcU7dBRKo+pk7Sf4WQXA1GVtvJ
	 6lI94/YuovgvJwXuyqARqEDJ61lbNFcbpfiR0HpWAPmxwzckLZAhzIIoyhNRKjTxX1
	 kd0+5mDwX2qeYwVKRwa5YP2YfN7daC8UoCvGajO3aI5CfJu0KYUclSvuxO29IhL45o
	 p2jLOZVspjllFgyFCOOc7I+ESxwf0Cd/K4mp3NAqTqqyO3q33sUHbrZ7pLWjHCOjfk
	 sAldvUFZFtesP2Qmi+wP6p2hKE6wCV/lAWAKJ0mplwyZqtXgHTigfL8zQni80uFnae
	 QO31fPOCuB+Nw==
Message-ID: <sashiko-outbox-219149@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 2/5] net/mlx4: factor csum flags into
 mlx4_en_csum_flags()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joe Damato" <joe@dama.to>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117155353.2250540-3-joe@dama.to>
References: <20261117155353.2250540-1-joe@dama.to>
 <20261117155353.2250540-3-joe@dama.to>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 16:16:16 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Extract the code which converts skb csum fields to WQE fields into a
> helper. This helper will be used by a follow-up series implementing
> software USO, to reduce code duplication.
>=20
> Signed-off-by: Joe Damato <joe@dama.to>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117155353.2250=
540-1-joe@dama.to?part=3D2

