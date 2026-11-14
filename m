Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794666309;
	b=eUPR/fQT5pmJkPJek6+bkUDSyjpRWOnVBS1hGg/QooBRGJGMUNz0rksIoONNW47EIX7g
	 jTeFYrfcQy9+A9z2TPFoS6EbbgGPgAZNfo1esVwz1u8Nn2acmGB3HVW4Z/lmxFXat53fe
	 lWaPcrYUFxPm+Fq9A6HXtL5elXWIrJD1KdXeQ6n4lkuQD3TdHu5JQSFiB1UQi6ffgtcKM
	 Krahzgb1h9tufE86braI8jU4mgstFfxWkFG8PbiuTKntUzAC6faZuLYMut27sDj+Rjl24
	 cZxjppfyy585HwHG28xEwXoaaOy0d8cfn3oTEbqWOzmZV3sUvUnO9GckheeI+yjyzrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794666309;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WM6xLZAjT3uCv9VK9LzJjuZLzWFjsC6Y6cnqp+nT8K8=;
	b=la8gGVsNGRice2KgBeEZnoVvL2dBfiCydom/ONRE2hqdGq+ynGCvRdJKAgukaA6eXiM6
	 sJz5NCf9G5UyTYv4IOTvRlE5jDluc/v6M/ob1lceqnth2x76qODSLT7Bgb1JC5fdmnVOm
	 L5hR2cYdsp7ZsANIW6CzlgLKIoQSdt52sFzYawtioB4VL17KvIWp9cNIIoYLTUgOqMCbL
	 flnIdqfBfpDRIs+60UpgASjw898azbDUItY1LWs5s+RSFj96uGy0FZrCPN3D7j5jBGqQg
	 nBDUKb39YVPquuW/fL9tL4krCtbuuUhtk0zgQCKq+y2ZEVS/1loeeW4pUmZWnbgGquQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CbrQTx5j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77790606A327;
	Sat, 14 Nov 2026 14:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CbrQTx5j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DA91F000C4;
	Sat, 14 Nov 2026 14:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794666309;
	bh=WM6xLZAjT3uCv9VK9LzJjuZLzWFjsC6Y6cnqp+nT8K8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CbrQTx5jZQBSiOA5iwYmI30FRA7qXK5WKUwporvcQPZoV2FqtY3uUZjQZfSnbXjYm
	 CqlfRwCLyWnmGYVKhMERLFvgi79/JHNYGP+1aWd34uxXTRkBiFDtBtloFXd654jfDs
	 RdVYzZeSODtfrr60SIF4wPUtGA4+jsSywV2EdRkBxrtKDXewbEe2cDzuXGU4kZNohh
	 e2R6pEgxjmuqdK/jHP2D2joFbNR15H9D1a6I0Z00wy4fGWaE5k7Admz1Zvz/m25BfW
	 E5kJOmSGQ63DkU31pblDQxrbAqTOrVzdJ8eNR4QX3HaAunqPXZFPlz17s66vyBma+i
	 SPkCBjVWHkP8A==
Message-ID: <sashiko-outbox-214630@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/smc: set the lkey of every SGE in
 smcr_tx_rdma_writes()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261114-b4-disp-dd99cd41-v1-1-009e1c022346@proton.me>
References: <20261114-b4-disp-dd99cd41-v1-1-009e1c022346@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 14:25:08 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Bryam Vargas <hexlabsecurity@proton.me>
>=20
> smcr_tx_rdma_writes() sets the lkey of an SGE only for a virtually
> contiguous send buffer; for a physically contiguous one it leaves the
> lkey the work request slot already holds. With net.smc.smcr_buf_type=3D2
> a send buffer falls back to vzalloc() when alloc_pages() fails, so one
> link carries both kinds, and a slot last used by a virtually contiguous
> buffer posts the DMA address of a physically contiguous one under the
> earlier buffer's MR lkey. That write fails, the link goes down and,
> with no link to switch to, the link group is terminated with all of
> its connections.
>=20
> Set the lkey on both branches: the MR's for a virtually contiguous
> buffer, local_dma_lkey otherwise.
>=20
> Fixes: b8d199451c99 ("net/smc: Allow virtually contiguous sndbufs or RMBs=
 for SMC-R")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114-b4-disp-dd=
99cd41-v1-1-009e1c022346@proton.me?part=3D1

