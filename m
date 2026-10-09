Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5FD3A9629
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 05:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791524080; cv=none; b=fjjd2/hknOn2n566o+8x+S3SYe4OMLR5WnB2HXgIQIk4smK/Hz3ZMjojDALj6qz8OZbEK1UrfAMrsiSAnUqBQ9p5wyPenRyCgWoN2xnk6eMumNEyRSJdPvMkXY2nfCzHGW8DaiTIyXKFhJ5BpjqBxqOXyzyC6jMEfo+GnXlVB+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791524080; c=relaxed/simple;
	bh=rTUPjGPJvLd2/hYnhYRmcHasTEr5nIavjczgYDboKkw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=rp09plUTgilAKtZf4QGnKN3NkwMLC7tJgOI+1jugYa1WM6/iObOXpFyHecXb9dovB9YIv1jVz91yc5QQf7dCs64qRULmk4L0o9+OL+YDRjNaUIoJ1lUyow/1I32Y8XMaqf5cKhVty+1jWD7vkd09SI+MfND9i5c2OxSxLVCTV6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=frZH/N+b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="frZH/N+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4626D1F000FF;
	Fri,  9 Oct 2026 05:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791524079;
	bh=rTUPjGPJvLd2/hYnhYRmcHasTEr5nIavjczgYDboKkw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=frZH/N+bMIthDHNp7M9jk/+C99fY7k8iUIHl7hZ3MJgWqqkSgzmSYlwvJsyBB5+4R
	 X0g83yhN02x9hq+LMFswkeIVAKRCTYduYJ3zbKB4y9C3nuZ5kqDtjC+nzNjrEANYIj
	 30eNs3X63WJJZV3zaGLS8Whkg6RkmBoAzelRznJ/7OvdFoI2097/uFiKzzJXh/nTqW
	 mIXCZKxk3WB2hjcnpIG2/V5ErA1dFxcvb0Z+4Wmqa9O7pflNbKQyaoMrMOm/fVoVwH
	 YyT98e3kcZS63BBTNuThOLKmB7r37bYnyd8BHbPZL4v30zieR0BklGH1/KdTpllZzV
	 jcRCXI70/Nt9A==
Message-ID: <sashiko-outbox-164901@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 2/2] net/mlx5: HWS, shrink FTE action array to
 fit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261009052103.3621855-3-acassen@corp.free.fr>
References: <20261009052103.3621855-1-acassen@corp.free.fr>
 <20261009052103.3621855-3-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 05:34:38 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> An FTE keeps the actions it must release in the array used to build
> them. This is a 1 KB allocation sized for MLX5_FLOW_CONTEXT_ACTION_MAX
> entries while a rule rarely needs more than three. Keep a copy sized to
> the actions in use.
>=20
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009052103.3621=
855-1-acassen@corp.free.fr?part=3D2

