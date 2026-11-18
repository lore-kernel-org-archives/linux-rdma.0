Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022026;
	b=mcB1kW3TYSpG1USshVelnS2I09sI9AEtDgGjpIUaxg2h7ei/OT7Exk89vewCkbIESUNx
	 QAcLaiT+vuJkStj9/6lT8FTTC+HgWbdO2GWRvNovdApmmCjbaPyy2dFRuVG2VBrDm9gGV
	 AnIHCe6LP1YOqKOosjZAGXvAry7SES8vJBD2Y3tvzIc3FcdgYWyGS/3SoZ5upsKRRrLQA
	 63j3/Eh5xG+YGwAgPpcfDJLsaNf2E5i60a7UIgUeeclmwgUgcaq/ASsjZ75DHrLcaIS6u
	 oCvIwq2vTi1zeKKPPEYkqITyLCe3ZOvDI/9v7PdTq5sQu4FPSwtoUHsxwRduuB2U6XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022026;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TMcyG7eTiEvMB+GJabgKlfduvn3xCTCGhnQ8bdPhcTM=;
	b=EorxEOx5HAY8OxhBIGCk0rPJ8LiUZpJ1jAiCbbLy/Qvnvpv2E86+Knt9pwfMkrWRDduR
	 2vZbp/TOtnSfce9PuxAy7/vz63iGeyGT1bBSTWPubmG9Oj2xMJ73owBmF7S7d4Zb5EU+a
	 kHDIVqBpEdHMnBkElmrA4NJYbhoP02qnsh5ejbOkkN4qFxFzmP9gpJg8rpaYItlW7mRDd
	 G4brHH/mvqDCBf+ps/E4iUIrrNvV0HmrXPteiqPTlbTFwVuTF89VpwFCLz67OmjfeK2IJ
	 CPJjBofZ5YRa119+q9u/K0IU6MAgeo34F/jDIlaDfHeJFv1+8KznQmvdyjEXsvQhOKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iOKrRjAv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CD3606A339
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iOKrRjAv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069CA1F000C5;
	Wed, 18 Nov 2026 17:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022026;
	bh=TMcyG7eTiEvMB+GJabgKlfduvn3xCTCGhnQ8bdPhcTM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iOKrRjAvKU/6b4mn/vXK39nxstztRfa36F1vh3PDozvzmWnAoOsbeVPHmUxhrWhhw
	 j45aK/mWcEc20DuFEaTaVTCGE1q79OTJcPA7TWZBbxsNTh10qK7e8P941aT6u8QEMo
	 AyKNDy/xNgd8pFB2NXWKBx1tIlEIHU6O8zaPF+4Br6/ly7B9SyjRygijccGKoxl9Xw
	 WpvtVdgpwpPXmDI3t7E71rkyXXgbOMhOrmxDPJqvKqAvNRnTx0sCWq8cE6VZTd/6ev
	 H9W5mTALMMyRNP/29UwwfFpiOqAiC4wPHPGpm4aM1nVumbkjtq6wSD148E7UkRoUJc
	 KECJKP+i16NBA==
Message-ID: <sashiko-outbox-221610@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2 rdma-next 09/21] RDMA/mlx5: Set
 ib_device::adversarial_mode from mlx5_core
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117170914.27410-10-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-10-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:13:45 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Set ib_device::adversarial_mode during capability init from
> mlx5_is_adversarial(), so that every mlx5 device in a CC guest runs in
> adversarial mode. The core then keeps the kernel ULPs off the device.
>=20
> The mlx5_ib checks for adversarial mode, added by the next patches, read
> this per-device field.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117170914.2741=
0-1-yishaih@nvidia.com?part=3D9

