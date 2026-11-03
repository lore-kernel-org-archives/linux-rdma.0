Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793693768;
	b=rNzKKCV42HXtbAymGxmarSnx/eNVvbfawhVTX3b4mI2LP2yESA1yiIGbHlxU8DpFsBUr
	 8A9+eh2lyNpWWm/sjFFQlYs1dMjJ9Min0+k011EnLzF9GwXcMJeetIVWm4x0zMD7FAe+U
	 WNNBBZEh27lmDwfoXkurZIJttl4B3BMxkr0zZRnknrupEtDA8ggqpzIYvqynK9vkQ7m6F
	 VXa3XGpcciTT1rrvLByuqoNec2IwS68+qdpUQlwtIAcOjOkvgdmMg9gNvLXTWUXxIyYue
	 ls594WA7UPaWlONoAHlXiPZfn2mFcJF/4Sd7ITYGH+vkn1vUfKJZg8Fk1QtntC5Pc6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793693768;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pg6GfllxlosRtPU3ejxVFoPWmAAx+cVU+CJJdF20+EY=;
	b=Uchbmg7T+p9iQXQsgBGcmZ0bdqYZ72hBBdtYT/tEQh3GzL5HEs6+2bFShiFGsxte9dRI
	 rzSZRt8D4CGqMDPGbBfYe6NlYHp8xhE0+MJILe9GTWdyHRLXbX9S03NEPduT7OzndLwtY
	 ytTm/tEoDImQkQAHKi/UscHrCUFTjCgdhu80SLYdY2rKBkThyxz0U1FL7KCAhULatJXxs
	 ppLo6DQ/QNvBvytdouWfTpYEqUzGclPyEztJpZjQVHz9V2z37UsaYLqmwi0/Z8odRnwta
	 yAlz5yoiRW3jhYBYgBGsxbmWsXklwurXNJdWjn5Ct3FBDPKdP2e1SZG5fQZkBSrx+Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EZQap68A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ED5606A32C
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 08:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EZQap68A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3161F000C1;
	Tue,  3 Nov 2026 08:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793693767;
	bh=pg6GfllxlosRtPU3ejxVFoPWmAAx+cVU+CJJdF20+EY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EZQap68AEXqj+B0La1GhLsK2SL7/o/5Qw+nWiJmIcU/EXXf7Ehm1NVWvYbpQRV+rJ
	 dKk130VcO9qqy28txOjU9AvR0OOlg7a2zDilhlBJ7qzdOELf3CKfYMseGj4J8KGcf6
	 5D0M+7HdlQigdV89G0vXQh32LyHewdF/H6Y8hLxhqEDK9gRyDgdNZBDWKTbNmSfSRP
	 buklwadK+b6qB3GbNP+ae3McKksr6OKa37GDE1laXDU2pvjUDwlyLRQrQ/8B3sDEXs
	 CyrG2KmOvQzO8PZY13RAI3KWbCdH9gdrBIcREzxL5TBb0YvuPiA6A/YPy5w15LeXZ+
	 X8E3tUEuJWGFQ==
Message-ID: <sashiko-outbox-194813@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/cm: Release the GID attribute even if its port has
 no CM support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103081103.1134475-1-vulab@iscas.ac.cn>
References: <20261103081103.1134475-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 08:16:06 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> When no source GID attribute is supplied, get_cm_port_from_path() looks
> one up with rdma_find_gid(). A successful lookup takes a reference even
> if the matching port has no CM port object. cm_add_one() skips ports
> without IB CM support, so cm_dev->port[] can contain NULL entries.
>=20
> The current cleanup tests port instead of the lookup result, leaking the
> GID attribute reference when a matching non-CM port is found. Test whether
> the attribute is valid before releasing it. Keep the put outside the
> CM device lock and skip it for a failed lookup or an empty device list.
>=20
> Fixes: 398391071f25 ("IB/cm: Replace members of sa_path_rec with 'struct =
sgid_attr *'")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103081103.1134=
475-1-vulab@iscas.ac.cn?part=3D1

