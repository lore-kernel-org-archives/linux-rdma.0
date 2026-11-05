Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793901983;
	b=MGSnUHz+o8PFRqfr6SxYGoyhrJZL2Kyi4NRhNQ5d/MpnMgDjKX6/V5p9IJohueriGDe4
	 9YVkdXe6VzrTAwniRHlv/ehNUmvxobEti8pOKXNxCoV9vp4+aZbOR/q2WPtJ5GlvCKkc+
	 oT29+X3H2s/mZaqfxRVky+/dCD0JBDfUWXeJ9Jp+4+TcMxtfpCPQUA2NXtufGneFV6oRO
	 a6HNJkghZpsOAqrrRu4CE0H+/yQAWYOopG+6plxXrrrWmiVgyE+J18Dnn87kVX6F7RRZD
	 mWbBhFvBzFbgoRe1PGnpyUYK0Uog/XNkJKc/Yoe10xRmWvcBI5lwR94c/dcHhnztUCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793901983;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vvJZoe0dn1Nq/mz9oe7r6xmEqgPSjcOKeISIjivX1YY=;
	b=xwlL+86n9XiWJiwPUDi2t0RnTPb9mZSiaGYOL0JISmymQZCtaQZIcH46POfjMXoAERdA
	 NkFxaKSoIq3Q9xBjoDmeaS6Y4jxbZFIqM5So417c9kYJC2H15QIhx6E1hEBZ1RtU6aO7I
	 S8sRi4bamb6cgIeygaS4jzbczsIxQx52engjE31SfyLIqg6wEP87hGJSImdtf+Vv0bdrB
	 HZveJbPqAT5/+A6iv1wYZ0+AadqwEtZ3lxNYbwk9a9OnZjSwDU9CdB+xNQBh5vgSJNV/3
	 jY5ISmiFGS2i41CMFCtpMv2LaBlG1wqs2dqps7Yp+FdQ/GtWZXRQT6uACEiSXZHA69w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LJmguZX5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E42606A326
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 18:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LJmguZX5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687B81F0093A;
	Thu,  5 Nov 2026 18:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793901982;
	bh=vvJZoe0dn1Nq/mz9oe7r6xmEqgPSjcOKeISIjivX1YY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LJmguZX5TVYL/LAkoCVeq6JcDpaXYnuDbN9cxvG886QTA568DvloxTMCCaSufeO5y
	 ezyO2WD5ra5I5zxHKMM24bnjW+Hk8SA3p5jR9jsTV/8A/Y+I3h0nwZb/QMBmLB2Xrl
	 PNdgiur8UEIZjfhtutZfuD/pMj5Z82u7I4UAkk+O+qaUaWd5vC5uaAEr0VrGR3r4CM
	 W6o2A91LmIQWhKQwk8GuGf5rHk8ha8oe4esyTipH8Jx/hE2Bik8rRYc2de4QJQQBYr
	 K/87oiZHvnW8VvE+gLGJ3YxBqxBnoHnzGrXizJ/rnk8J/Bj6F0pksX7glHmTmy1EPx
	 KkZDlrqDZy9IA==
Message-ID: <sashiko-outbox-199687@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v9 1/9] RDMA/mana_ib: Allocate and map
 fast-registration MRs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261105175928.1326682-2-kotaranov@linux.microsoft.com>
References: <20261105175928.1326682-1-kotaranov@linux.microsoft.com>
 <20261105175928.1326682-2-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 18:06:22 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement alloc_mr and map_mr_sg for memory-registration MRs.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105175928.1326=
682-1-kotaranov@linux.microsoft.com?part=3D1

