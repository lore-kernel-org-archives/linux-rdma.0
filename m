Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794733258;
	b=n1hOqKpBJKZxJzDZaWBuL4wCMbWFfhKSLuANiIlXBXawRAF2czoSXq/R4BLuYDgQc6Qh
	 wYJrDKDCOwEpE642in0scww9Qyzs5NK+j5TnbQ/v++qejKcRjt3NCALO1z2C9VkvvZ662
	 vntxESm1OvbR89yN8Trc8bnBwaEiqKVihM4tPb44k5md/ehmbjYMfRKMtpk5lPlmM3utI
	 XZBfbAS1hrH+ARbBWEkGKUlux7pBOUISUnftoB1+JSojo8oPOuF/jEHWNpbarpSjelSbE
	 Ty0RSIPhkzzCBdW3HJALfaJvbho8j/QBt2GtiQfT5XCWzMoq4zhMhUKqZg4xds/no5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794733258;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DWdXRczY5n5P9tx8ZtsdFUz5kI61xpSN1EtyJ2GcVAc=;
	b=fjACHcdsmq9G68MjnpZnfKcg8+r3QZyoDdin8Op6JTU5IVKFPMSbUg7UAsxwWS+Ntos+
	 8aWSRmhNBYxR/69EGbBIJHTIkOg88Iba+12ZFyg4+1TZUdEJkGe5sViPGV1xhsRsWjcRn
	 MwTkqk+y5EXQydsxh9p2VPEXKbPirxyeJuv2EBbAsmXfROxWpaMOKV8Glphwuq5LEiR6p
	 zgmjoURIowDuOrT5yqtmEiBfE33MMZYg2auviD7p1WInIGvqjvolPV9uaLhgoGKp+U0mG
	 rysW8lJdzvF2Bq3/i5jBP6zpewcg+f5uRGzRjfc282ypznT1SjDX0dRDwWZrqyRxORw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GCA2GAMy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4620606A31A
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 09:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GCA2GAMy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFA71F000C4;
	Sun, 15 Nov 2026 09:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794733258;
	bh=DWdXRczY5n5P9tx8ZtsdFUz5kI61xpSN1EtyJ2GcVAc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GCA2GAMykTUIXCv4Mef8mL9rHZQgeZOv7zFjygjZsFglPNpBG5AED4Mvfrbvx2nYs
	 fIJdEC50xqkwvXayogjWht/PWQE5XbzBM0qmEckqA73YXgwdolYqftMraXFewyET4z
	 dcpwVCNemRdlY7UcWG6PElg3q9EfnAbzH7abEthsfjroobEbUeUPJl+v9zrst7gCgh
	 yoyJV+U5Sz5P0YcN2zljT2AU1KwbXSW8+ww3wE7+gteYFbhBWUYjhFStiJH4Ge8cBU
	 Be/eUxxVYrLRPX0lRtiJE3yh61cLWmJdoVtNdya5M6euUiNHZyITXBm5lDsy6aKBDl
	 81MZ5mA44O7qA==
Message-ID: <sashiko-outbox-215319@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Fix cntrs_max_index overflow when binding
 flow counters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hungyu Lin" <dennylin0707@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261115085025.53203-1-dennylin0707@gmail.com>
References: <20261115085025.53203-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 09:00:57 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> counters_set_description() stores the highest counter index supplied by
> the user plus one in cntrs_max_index. Both are u32, so an index of
> U32_MAX wraps cntrs_max_index to zero, and the entries after it can only
> raise it to their own index plus one.
>=20
> mlx5_ib_read_counters() uses cntrs_max_index to check that every bound
> index fits in the output buffer before it runs
>=20
> 	read_attr->counters_buff[desc[i].index] +=3D ...
>=20
> With the wrapped value the check passes whatever the buffer size is, and
> the entry with index U32_MAX is added to memory almost 32 GiB past the
> start of the buffer.
>=20
> Reject an index of U32_MAX in counters_set_description(), so that
> cntrs_max_index is larger than every bound index.
>=20
> Fixes: 3b3233fbf02e ("IB/mlx5: Add flow counters binding support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115085025.5320=
3-1-dennylin0707@gmail.com?part=3D1

