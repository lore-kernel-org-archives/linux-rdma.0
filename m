Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794932179;
	b=3RMfywrWMhF+cZ4nuincUjJZjoByBb4K8qd0Kzkeu4uXrtAXRW8f4nELwi19GIgyjYVV
	 nZeg5PxvQkZNy6osJAo2riXP8OPY6pVUHFpquCR/kp6JCCFcbkfGmOfda5RSaIr3Ve+Fl
	 wVTm6e58EAP/vOG75ujFLzTPbkknWHCBJrPYLSD4leF8NB/o9fSao8rkAsCf3mwMzRgQQ
	 U51sE/tJPRUBdWSDaczQMKj96XbsuuuiGSW6H8m0wiSG1MRmGsfL2du1Xaj3Bx264rgov
	 YfTk9mejxxbeqOQprY2jEAusGLEp42+zaioCbRfw2ofvFit5YfB/wDuSQ9BLuVDFMJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794932179;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wrAINhqY27MsXWDikCsCpm9YycL8gCmtdeanxMq33Dc=;
	b=3hr2LtNQ5hz0zKzvRul9YGV8SP1b81UjAYUsbh+3EQe8+aT56EOd5ns8nYP+tm51rfdW
	 EGqSS8FACptxxj1Ll5BP/5S713DPFaRlG552RU3dznjaozdKRhsgN/U3HsOCiN+/st5C8
	 bXx7sQBDAOcdDniheGWR0yCZIHkvBrmoKgV9HtSREGxmo/o6uL4sNlBqL9to1j3yX2f+K
	 +42rakatkRBv2KouzV9V0C93X2AKhySvn6AfPaAEf0lHfe55Qe4Odo9VOeW8B2NP/HeoN
	 VfvIP1/XFC6tQYe7TThlpcdudvNbiGFYaJqjHuSMBYgJ/TnAos4yI4Ewhgeo9WCPmiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZjTKe+5U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4DC606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 16:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZjTKe+5U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1955F1F000CA;
	Tue, 17 Nov 2026 16:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794932179;
	bh=wrAINhqY27MsXWDikCsCpm9YycL8gCmtdeanxMq33Dc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZjTKe+5UjtwRZK0T+fo9pdlePaZdkBIlsZwcTcfNczv5GDYzwjoOy1B/KgYUHnqsd
	 K5ZvBVIUi3LJiCnljF3rqYZats40V2hNV2RhUYzeWhLzezzuNBRRRxkNTop6n7cxsI
	 5eZ8NZ0/qMFFelr0kqFXFoqJJjgYlBf3FfnLPMQWqj2Wqg5UtkXoNDbAszwGxdWdVZ
	 T/CqAAt6zNT2jCuzuuhKSPFEGBf1fFpMJw40TjNIaSJbhpXrsp4k7EWgemtGKXooID
	 GJ4Cgz5IMRZFHrgFJA/U2W3v+yPFQkMRO2GBx0S/ETyt8rtpv90NhSDmjpYhInYokr
	 1blHtStOeT4Rg==
Message-ID: <sashiko-outbox-219152@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 5/5] net/mlx4: flush pending doorbell when
 dropping a TX skb
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joe Damato" <joe@dama.to>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117155353.2250540-6-joe@dama.to>
References: <20261117155353.2250540-1-joe@dama.to>
 <20261117155353.2250540-6-joe@dama.to>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 16:16:18 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> If mlx4_en_xmit drops an skb (for example because DMA mapping fails) and
> that skb happens to be the last one in the batch, the doorbell for the
> WQEs posted earlier in the batch isn't written.
>=20
> The queue stays awake, though, so those WQEs are eventually announced to
> the HW after the next TX, but that depends on traffic and could induce
> latency.
>=20
> Avoid all of that by writing the pending doorbell in the drop path.
>=20
> Signed-off-by: Joe Damato <joe@dama.to>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117155353.2250=
540-1-joe@dama.to?part=3D5

