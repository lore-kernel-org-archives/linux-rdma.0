Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404809;
	b=lBwaZL1V7tawAYEurXRAnxwmnSEQDjo5xu6xeyUqHD6b43BH1E1ewLHa+dhFh0MAeDEq
	 iYtyg38Xxw3XQxvNFAqx9/V1eo6CAHtAWQJdgyhtZ6g0NOJwtREnuss468I0KIzWuHRXj
	 /GByDVQa2NHkVAWwG4OxWAS7M0yEgcrOdEJKh8r2sMej71+MCR4eF7bmiuwXPitJSsvIZ
	 CqvL/5X+c0z+QAXM/GOuPDa49Ot8I2TFlyHDHKLSKVpm0DaCDnUWpyTNG7WXeqV1jA+FB
	 UhEt5LupNlGWw8tPE3EW3oGobugqbXkF0MHHIRVhqw4LaXwekyIiJMPu34Ulo/tvqgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404809;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=PRiVmHZo0P1XJRCamyYd4LEyikkxQWmgusm2LN4+v54=;
	b=KCq1OIz0KY5/4XqaTc+Xp6qdqE8WQQrjOSzANhSqcbl5CW6ILfzCyhscwqJEfDZ0/Arp
	 wRPAooN6qwGiODSioe9egaFxV225gXn8jZGUBFFnVWS8i9hg10OqwugPLCicNDImQLfhs
	 2ZYvPCHjgQk0/zcgtIupXGbjSsydgPBmAO1/e3JtmytZUV4guYvNQvWyYQmxaPxX85I4j
	 sVoAmZb/2UrMZ8Ucwjdoc6YH6LAoGBx69rUpA89X1OWWPqugeYMDppJnAiFGaIIm8DzKi
	 9Dj8L29psWUL45vimvTJJoxPjirN1Nop19R61eq6l0blfHNSWdmJE3hdbswaINT6xww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J8bQxih6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB06606A338
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J8bQxih6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21331F00A06;
	Wed, 11 Nov 2026 13:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404808;
	bh=PRiVmHZo0P1XJRCamyYd4LEyikkxQWmgusm2LN4+v54=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J8bQxih6QUh/H/v4+k00jdD6UIemJY4T7m1WG7XXhvfC6InY3FyRotjz9yN5YiQXe
	 Ab+hJPcKYgHuhkezniQLhksXf8pnHGCyYmHNWvnzefEtMmKQ/uo+QFutY4tI1Tc3eU
	 vtbXt6+0dF0KsgoKVdv8hr1AeEzs6xchLemJa6PZpe7J1CuKn0DIInojREy1B3w9C0
	 VwJYUuV85mGVblEUxIgmI1+6equwlYsjMLI0vzKKxUaILWqOZlzxlSm5gsA9HE09hB
	 ARVcMNni5WjKzVEKVal4ZNb4SWbPNhiTLs80oY8vMXw9pDUeDb4heJLppa0Y40f2al
	 CE+2PgQwpFJ7A==
Message-ID: <sashiko-outbox-209092@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 07/24] RDMA/mlx5: Require IB_QPT_DRIVER for
 the DC vendor QP types
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-8-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-8-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:48 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> check_qp_type() checks the dct capability only for IB_QPT_DRIVER, but
> process_vendor_flags() turns any QP that carries a DC type flag into a
> DCI or DCT QP. A QP created as, for example, IB_QPT_RC with a DC flag
> thus becomes a DC QP without the capability check.
>=20
> Accept the DC type flags only on IB_QPT_DRIVER, the type userspace
> uses to create DC QPs.
>=20
> Fixes: 37518fa49f76 ("RDMA/mlx5: Process all vendor flags in one place")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D7

