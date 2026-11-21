Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795255562;
	b=JWrNNw92MVekXD4TJuTa6wu23VqDqEKBDJBHYku8cQX9s+0+tirHCnW7gwU4G9A1b3G9
	 hIuxMqnQV92pQ68R2Mc6qQyRpaW9mcLOtQGS7PxBVaOdF9tUyKriSkKhvDSR4JTsSHJRe
	 9UurawYgAh0ciCkcduOlzKRtJVomhhcKBR7BBT8FpEYZZ0xZYXE/NZohs7lvtl7mmZUGw
	 63cWm1UqzieUJnhmeLT08ntu1s7bQY6JNk1V7uRkffl2sxPuZMXyjN5gY6OTInhMw8ZCq
	 kZ5dhfE93fM3bKbmRZAxOIwpcbJc8JzLTM8jMTzkPzATTU3+1Znf9iLWjtMdpoOgKKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795255562;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=x8PzcOFbHluV2eHkrVwu9MndJjf6KifwtI4pX//QIO0=;
	b=qsCFQLN+3kNbMLxXkBbiaGCPcnihHasRmJq5USYeOqgkloirKaN9RlucKsZyGQMc1bM6
	 3UjPlppimT2pQ/vafx25bbWlPc8TMkChfQECn/iOe+FejGgzxdwZzRx98i4cK7bcEU2sN
	 j+iYGBtpf/8AxDs/08/2n0fkmcfwyPbG/R5KsRldRtg5MCqBhqr2nE//wA/Hi001Nd+tf
	 PnwJsH4Pvkv0Eafdg+gYiD1yo+ezoyxqei19Hh3cFj93JGAkJ8mQ39LQqlzP6gjzuNnw6
	 LFQ+UNh/RD3/6PpNmn9SxLlDmdPIP32gskXx5w4fnW7jusC8A0F+iY3S8kqKqkMflJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BjckQP7N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1965606A339
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 10:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BjckQP7N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C971F000C4;
	Sat, 21 Nov 2026 10:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795255562;
	bh=x8PzcOFbHluV2eHkrVwu9MndJjf6KifwtI4pX//QIO0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BjckQP7NQvvfK8E7JfF+bO8RZBSugBI6wq3YXTDbBrOAoSa+STdydKWJ2Q8RVqlM0
	 spG73MQOYJonCdLq03CKhAptbhy1KsudtTE+/1Tw6dL3Ri6vo8PllGq9CuJSH1325b
	 G5/970kDon9iXQ0BeubFSiglTQzoJOl2kg7mMwcxbBR4kdhyaNKZMq23MC0bIgDZxu
	 93B+54pl4rv51nlisEGpz13vQIHZaW4j9wgugt899lDaQiLRDCCEgRhbbuQO0vo6rN
	 /HhWj1NNRyAvxDVa2IpzI7PBOdJOusBk0DvxGSj7fTbTUqye0ylj/46DVf8Ur5iBl8
	 gTXCEMAfoweww==
Message-ID: <sashiko-outbox-226908@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] IB/mlx5: Fix a potential memory leak in setup_qp()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wanhui Fu" <fuwh1120@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261121095902.442960-1-fuwh1120@163.com>
References: <20261121095902.442960-1-fuwh1120@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 10:06:01 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> create_gsi_ud_qp() creates a QP but the QP is not
> released if modify_to_rts() fails. Free the QP by
> calling ib_destroy_qp().
>=20
> Fixes: ebab41cff4db ("IB/mlx5: Create multiple transmission GSI QPs")
> Signed-off-by: Wanhui Fu <fuwh1120@163.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261121095902.4429=
60-1-fuwh1120@163.com?part=3D1
