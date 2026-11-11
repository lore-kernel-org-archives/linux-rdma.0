Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404817;
	b=Y/R6QoG+zuoezRGGtc7AjdXseOmSVa1sLDD7VF/EINVK4fgl8i+RRLnM7EXyvfC+H6Lo
	 eyMsVOcRebMzwBEc0ZAQunF2++ROlXhZtmFrtdENpWZYvp6P55sRF6T3aut6N+Bto4USc
	 k5bKCqpOII9oumWBirEt220j4xRujOX1354riSbEEozWg2ZtBW5yrA8fcdDJAlrk9rmfw
	 Zrs+m3JWTi/8+F49/ivA40TrNojNQC4nmEFQU07erMoFUxw71pC/oNcuXfkB9du+sTbo6
	 06rCMvpAm0ZVpJSHq0IRvOH1aBBL7iluULz9xbII3I0W0ERIVB0KED2h5MMa2jGWJSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404817;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=u8KEfVuL4wvU1sndRvVu4LTJxFR0jkHcM5U0Za9/Xe8=;
	b=GhTkK9XGiaKifZ8yjrnuBx2jRq6cQeLsXnnVXz9+S4VrFo7mBVRw6x/5SfUMSDPrnWxh
	 z7kYPqkU6dHky7Ex0m/SK71J2gCk+Zmcf64WTRzZHSEybWubI6ES7pN98OWFbi99QRmE+
	 PzxCGREUJsVcIqpmPvPgRFVkfB44dqVpLkPF6O2loJklK0um82wuJ1CST3sJB8S3APwz5
	 QigNy3TB5wQWShdRz7ULGfAR2awRXbWm9sfsS73RO0JGrTM01MKriFykqTlHc28Z4udNB
	 Ca2ZFoFzxda3+1ZrOamu6dGyFWFC9uBgC470L3LpSWGITegT1aCm1G4iDsD2bGNO79Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X+FNH42w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDD0606A88E
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X+FNH42w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABD61F00A06;
	Wed, 11 Nov 2026 13:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404817;
	bh=u8KEfVuL4wvU1sndRvVu4LTJxFR0jkHcM5U0Za9/Xe8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X+FNH42wEUr6GnkEAMmlIPuMfgiTTGKrYndOToOXKrc/OwYA7k7yTfc9/wwWlT/j0
	 iVZ01vRP4P4i6uRgcZayqJJfRisbjcF2g/eo9ORLyP5MheJKVbvC01CQwTE70yhfeH
	 EVLx3xSElCvIxBtCkl6vUaOnj+h5GCDH+TEDZPHlnEyefcPhSmFUyJtIGT6jMZhP/b
	 fXjukY/vB6XrBPsSR0nBT9Xirj0TejAgXOQ9HCa+1/9c7pHBekT029h3GvsOBpoovy
	 RcGHcOBBUfd1JW466Qh0ZNcJOqzd2NiXbAoU0r3WmmKmg5HReEzSoyyf9yBtnhEZj1
	 3xtVwIyjyWOIg==
Message-ID: <sashiko-outbox-209105@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 20/24] RDMA/mlx5: Clamp log_max_cq_sz shift
 in CQ size checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-21-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-21-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:56 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The CQ create and resize paths check the requested size against
> 1 << log_max_cq_sz. The cap is 8 bits wide, so an untrusted NIC can
> report 31 or more, which makes the shift undefined. A large limit also
> lets the rounded up CQ size exceed INT_MAX, and it is then truncated
> when passed on as an int.
>=20
> Such a size also overflows the CQ buffer size, entries * cqe_size,
> which create_cq_user() and alloc_cq_frag_buf() compute as an int. A
> user CQ buffer smaller than the CQ the NIC is given then passes the
> umem size check, and a kernel CQ gets a zero-sized buffer that
> init_cq_frag_buf() writes to.
>=20
> Take the limit from MLX5_CAP_GEN_LOGSZ_U64(), round up in 64 bits, and
> reject sizes above INT_MAX. Compute the buffer size with
> check_mul_overflow(), as resize_user() already does.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D20

