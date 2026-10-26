Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793010823;
	b=YVkF8TAVYvJfFvIoYwst7Otqdrx44nUDRb2wF1eG+v3kKWIRBraVOmNRTsHDTm/b8Z1l
	 7KQSLydiESbG3XB7T2wyZoY0RdJ/m58/khz1grB5ByZ1FUsG7xkWmtrh02ychKs3YCbl5
	 RT8by+23/eIlwGNm2lijXARZVf2FGKZIde1BdJt89/5B7rtJiS5uGgt7gj67fpRK+aysl
	 U89w5t8YF8huOu8sohKkpwGRdIqaatz7Q+mS7WJ6Uh5rkZFL9ThcVogkcQhLAfWN4UfeK
	 33VdPiAk9gmMeecEGzqAaGb6PRmbLNydbbRzfpJcMqXtJaVl207OoRgHC65qaUmMZcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793010823;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+nrvxDZRCS/v1B+q/hh3jsEQlQhpdAZ4XM5GsaSBRiw=;
	b=GTYqfL4dtPAK9IqMKlm8ZKM6+Ja+rOMXb0RBar6pt9RDkR90CTYc4d2UfVVhwvhjYlr/
	 H5IASsI0P+/8HO3+/pACMum7RJEnZcwjcycjMHeilltpCTVT7sTUUzrUfGoIQgBKgsz+v
	 4srRpot6d05JT3IUpOEkoAU+cQEpyv4CBjQVDoiMMMhR0ARxE2eEwZBmfMMYzgA7siBSk
	 uE4HZ0D6WjiYUhYtrpHAdjEcLtz6R4HGUrdzCRCc93sbvs9lb6g+6/Wj8uhMisBYORsV/
	 K0E711wJn1NVRBLtVVPIGFYjAl+qQkEyMBZRibgbGT35LtZFwsHbTwpLYnk4HeIQHGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="D16JQwQ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E9E606A31B
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 10:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D16JQwQ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821F71F01825;
	Mon, 26 Oct 2026 10:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793010822;
	bh=+nrvxDZRCS/v1B+q/hh3jsEQlQhpdAZ4XM5GsaSBRiw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D16JQwQ/MTvtKMMce7e5ty7zVPQmRjteP3qkGSKBBMBgVq70imJZ8snX5Pv8SqUPS
	 JVW/n/3JP3TE0obwNAZ83Gtz8PuuQ7L0aTjGc3EmPoitKePI5OIKDIKTEb3Rot3eER
	 TjnKPZJ1DjCYzEGVa0OeAw6NdPzfi8DECe9urOWAI+868HmK4WOejEhqnOueJHotWm
	 P+wAMv9bK0Ad+IKnG/wbVAAM1uCtltu0uxyFun7/bypdRnmUXKeu6obuSNk+YuRjtg
	 vrbSyPz0SR5E/aq5XXMvaE+HMsvpkw71xOJ6iQssI4Gg8TCVWD/XRbABVZXbKIc0O2
	 Feg7+rSDXySFA==
Message-ID: <sashiko-outbox-184961@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v1] net/mlx5e: kTLS, Fix missing error unwind when
 enabling RX offload
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xuanqiang Luo" <xuanqiang.luo@linux.dev>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026095346.1212609-1-xuanqiang.luo@linux.dev>
References: <20261026095346.1212609-1-xuanqiang.luo@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 10:33:41 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
>=20
> Since commit abed42f9cd80 ("net/mlx5e: Conditionally create async
> ICOSQ"), the async ICOSQ is only created when an XDP program is attached
> or priv->ktls_rx_was_enabled is set. When TLS RX offload is enabled for
> the first time, mlx5e_ktls_set_feature_rx() sets the flag and reopens
> the channels so that they get the queue, but it ignores the return value
> of mlx5e_safe_reopen_channels().
>=20
> If the reopen fails, mlx5e_safe_switch_params() keeps the old channels,
> which have no async ICOSQ, while NETIF_F_HW_TLS_RX is still reported as
> enabled. The next offloaded RX connection then dereferences the NULL
> c->async_icosq in post_rx_param_wqes(). Enabling the feature again does
> not help, as the flag is already set and the reopen is skipped.
>=20
> Propagate the error, clear the flag and destroy the accel TCP flow
> tables again, so that the feature stays disabled and the next attempt
> retries the reopen.
>=20
> Fixes: abed42f9cd80 ("net/mlx5e: Conditionally create async ICOSQ")
> Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026095346.1212=
609-1-xuanqiang.luo@linux.dev?part=3D1

