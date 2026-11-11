Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404818;
	b=L/0kTi73rNcb8JJDUKKrbAsytkzUjysXyNVJSU6eB74ARyKurMOQgIvsTB3XCL+7nJsP
	 mHcU/eGG6YobIqIUCPzGJjxfr3GLwzor4jTmdDkqpFE86e8evHh79t56EKP5uu+4q7NfG
	 LpK20hBawvfksautJVxEJA4/VDbqXt7MnzE//1zm0L4k+qKmofoNtQRN6k3ebHF6hi8J7
	 bdQBuT/OnZd4qZgdJzq64mE+O1ntRvjBu/N7TxqxeCEmljI6+hsr9yOpe4K86EpvL3HBV
	 AOns+PMQGjS2rHwM9+AWsEadfIYpLESLp67O1oq4s9sgx5wGErxzGMcu5hiiXc75M8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404818;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=yr07n9uMEKEZUtk8kE9GSJs+C2eSRtS/zlAChWdK0jg=;
	b=E8Zx3stz1TXa5s9ZDf4ok7GqXlxk3l5GgNER571vOzxQsUnwbr4/wTKQIPZUXGcFxhEF
	 K4B2WfBs78lA4DMHUF2CEidNQ0KTdhRAqs0U5SROKXy4/eqoGpGKiwLkQroFszfnuEffM
	 r7nQbPtVrdJ4jO5fIxt5vhF+2lKIZwMhFsURiaQsTKioLikXn96u/pYbi7SsrGTT0VN1i
	 eBeGoGZgECN4CwxIpGENXoJS/OD+SG3852LbHFP76Lq9aiqwnRGPSYhBdhfMQSKdAV2U7
	 r6L8I6sQlTHptEumxDwQEO4jB7s8MTnB8lYEk2rqE4mQ5BYRhE4k4IcKqkvbjZh1YiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NBnIwVuS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08840606A894
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NBnIwVuS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15001F00A06;
	Wed, 11 Nov 2026 13:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404817;
	bh=yr07n9uMEKEZUtk8kE9GSJs+C2eSRtS/zlAChWdK0jg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NBnIwVuS4UucHiszKaj2m7FK2lfj7iQvPIYUADRmodHk4v7x8Gm6w1/+GZy67z30u
	 jk8ZvtIMtKvAO+Ju8HX8H67dvH4yFD5vL1BMPjBhT6FbLDwReAZSFsYd9zhj3EPh1p
	 EvShpo28Mlvhhv81+zCEJT+8RC9VTOQWcrGGf0It58aNln7fey7G1Khgs23uVLqdOF
	 CONl7mMAJBE41PiQUXzbPW4SSxRb3Frtg8EZTayvqFZ99Fj8X8gDT6pkaLf71ZaGMH
	 bAcv+HEB4WzXBN8c2ypY9jTGmx0DuOvSYDlOx9q1vTp6m4hd0VYbN2Hx1maFMnT8h7
	 N8lgj81IHcSzw==
Message-ID: <sashiko-outbox-209106@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 21/24] RDMA/mlx5: Clamp log_max_* shifts in
 QP and WQ limit checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-22-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-22-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:57 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Several QP and WQ size checks in qp.c compute their limit as
> 1 << cap, where cap is a log_max_* FW capability. An untrusted NIC can
> report 31 or more, which makes the shift undefined.
>=20
> Use MLX5_CAP_GEN_LOGSZ_U32() for these limits, as done for
> log_max_cq_sz.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D21

