Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812430;
	b=mnO7t+MVHAPQLmfZ5XbmvcOAGyKMe4wCh1Z5YaZ5r+wM0NgGIlmLqoLFPfWjPTPUknM3
	 2z4Pn/w32ivAH8+eUUIkUal1QX7QGGcO4nqAD0loY1Jfryht9wH6joRk8AfgaRW8deYb/
	 WJImd5QbDMpEuW7YfYUUQASgNXw3FryTARf7dgEQrzFyKqqsGO5avyNOYth7Qlj0nZwzL
	 GURrTWnZKoB+1W/GRj0OPAi7YWQVHOfDR84Y7se8hsD7w1ua7QfLpnpRU5uehdtNFYDPM
	 8/7RM1kT3eX0V9Jjro+ybJTCb96eBuFBt7gdMFMr6y7CrB+5sThEXYO/X0XeX1VPyXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812430;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4jrz0K101TrKc+vbBrkHIWsSvPoNX1YwhXUoLDeFZSA=;
	b=TrwckBpD/K26WwSDAHnIVpCvp3Z/a1N66J5qT+0JrDOTP7J89FDNTekbPVjySthb655e
	 KRnrovxlPnt5Vugd3IhI13WQvmPjYkslEbQbwy4fe2HyhO/QVLmvle1Uw3pK10QEIxQOP
	 Uah7sVmfs6hLvMlsiYCZ9Sg4FUYmIGzO8830zP3pImOr1zcQWN7l+RFRF+Mk8kdtWmy1L
	 wVMLtPvI524gea0EPfQLosBbXR/EXHjb8ZCkw2kzCsPCLuR4wPcHdRuejsaqqI2aTeu0E
	 /zqYiY5Fy7cKsDh4YZloxeWRjIxjg9c3IKzp564MMH/YhlK0VVAqWb6KK4A6g97T2Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lJtVmVWF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC20606A32D
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 17:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lJtVmVWF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C2B1F000C1;
	Wed,  4 Nov 2026 17:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793812429;
	bh=4jrz0K101TrKc+vbBrkHIWsSvPoNX1YwhXUoLDeFZSA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lJtVmVWFeoSQFNHF7DNQxpmkWRdMVCK3oRh3eQ2BamTt44HoaxXcCKYzPnqwZd19n
	 H7M4xIuRFfpE3gwabATheZw7UQjP7eehFu11Hc2nKMWNwT99NJsKffpIiRp9qTBWSt
	 8JXLYSth4AsFmu1cwEV0LNzzDSfkjOHauAAVfKz+uVc5Xg5cpged1OKQa2VkvRisMj
	 ahgOE9f/tUpzTck8sRi8pj9Y4iSK+nmqKsHyc9rsgntCcHSmaune1hE1HnEPb+s0tT
	 DJ8GIEDsbv33miZDaXk1rBJ/MmOV/xXBhGF8Lb+QYUJ4xloDvIkGSYOlYkxX35QKgp
	 AYdnHvlj7RnFQ==
Message-ID: <sashiko-outbox-197737@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 10/15] net/mlx5: LAG, do not add a device to an
 already-active LAG
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103171009.563034-11-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
 <20261103171009.563034-11-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 17:13:49 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Shay Drory <shayd@nvidia.com>
>=20
> mlx5_ldev_add_mdev() would add a newly probed device to the LAG even
> when the LAG is already active, mutating membership while getters may be
> iterating it and while the active mapping assumes a fixed member set.
>=20
> Reject the join when the group's LAG is active:
> __mlx5_lag_dev_add_mdev() returns -EOPNOTSUPP, and mlx5_lag_add_mdev()
> treats that as terminal - unregister the HCA devcom component and leave
> the device standalone, rather than the -EAGAIN retry used for the
> bounded mode-change window.
> The device stays out of the LAG until it is reprobed.
>=20
> This keeps LAG membership stable while active. It is a no-op for
> existing configurations, where no device is added to a LAG once it is
> active.
>=20
> In addition, do not register the eswitch devcom component of such a
> device, so it does not pair with the eswitches of the LAG members.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103171009.5630=
34-1-tariqt@nvidia.com?part=3D10

