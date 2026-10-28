Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168364;
	b=rMVW/uBeYByXE7Vqu0FXue+nQThMEDDqPwzlrUBKJ7oXnJopajZ4Xvde3ZQDwVnxsyc8
	 7CRnJ6CzmczecH5tCozUlZMt557OIVyaNt5beeRRkGZISIdJp2GObfRHe5jlzWzpCykeg
	 DsMx2C7pNByal7DX/TcSltRnh1is5SvyrLBJNTdopBwBLIVbcF14Wpe42nS6AzVztNo/G
	 tYIoFmV/jAJ57YJlFpnr6JF7MfRpL+CCpKtX+Nps/SowyYSLo5gYJAskhYk/zip23kAbK
	 7MX4ymjhbBJ66xw/n/4UsGqeqdcLSsxnClTwXxdssRriQNtNiREK/nDN6h7sRgwBB5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168364;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kbI1CR8MSznilCujyjjRwrqXZh6m41tIFsa6zsQ3HRI=;
	b=qqzDLuDNwz4yt74VJLgHgnXqAE1CEcLZpjIOnLHEaTnzICEBseHk5ubeYYLKCgEKdkci
	 7d0ZlmzSBntQoG6Fz7+ukqX9LgH+mWjLctvKwnSfB1j9QS0snXBHVGRiQP+gr5jTfFSfQ
	 5yj/G9YXPbM4aT2nzjdR056H+ZDCOl7k+PebRKNSVKQG31/v3jGQsETmMtHwD8zE5cKs3
	 39XGi54IeVSrpiBmoIAeu0YOk5Oz+dEPHiG+RAbekAQ+jcbl6GosYV/DVfHv1lAxeyfmq
	 zIUgK9zW2TBURRihDwGSiykIvRWnf51yWgHJzDkcYtgUlMJWNnywwww4oYPhFBaaYmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=li4QnJQI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BF1606A31A
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 06:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=li4QnJQI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479BB1F01825;
	Wed, 28 Oct 2026 06:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793168363;
	bh=kbI1CR8MSznilCujyjjRwrqXZh6m41tIFsa6zsQ3HRI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=li4QnJQIP66S46us6aHwvvWvzQOK1mbv0W8As35l3gGIA/+wwio1Yq1xLZ3aTpm6G
	 nlXXD6btUk50ubfZIuEQvp0cKUx+c7hHrX92cB0s7vNB+YUR0Ewx4iH8srO2kQz8zv
	 GaNUoQC2CT40DxWghf+GXBdqozknJxmXS30OSKKx8nuE3k6yThaQt+YRiFWpVyoiBn
	 CIcD1gwdnhVKbxl8uQtHKApjZnUzUaPXgsRYGDA6KkL51fd4DTNUBfP6LFriWyn1ju
	 Ka0VtM4bQkIG+SajS7KGzWX1INvvDKjjcntgdGMKZMyzeXxgbRWlGb0ldDnWe1KUxz
	 f3c25Whc3y3NA==
Message-ID: <sashiko-outbox-187555@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc 3/7] RDMA/bnxt_re: Do not treat CQ error
 notification as a command completion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261028113404.33289-4-selvin.xavier@broadcom.com>
References: <20261028113404.33289-1-selvin.xavier@broadcom.com>
 <20261028113404.33289-4-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 06:19:22 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> creq_cq_error_notification has the same type as creq_qp_event, and its
> cq_err_reason (1-6) sits where creq_qp_event carries the cookie. With
> no case for the event in bnxt_qplib_process_qp_event(), it is handled
> as a completion for cookie 1-6 and can corrupt an outstanding command.
>=20
> Handle the event explicitly and do not touch crsqe_tbl. The event is
> intentionally not reported to the stack for now; that will be handled
> in a later series.
>=20
> Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028113404.3328=
9-1-selvin.xavier@broadcom.com?part=3D3

