Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810624;
	b=Ym//TvRBpBHhP5idhXQ+iB0iJV/VQe0hePPUosPJQ4hSjwCvdhJY0e70nzszVCqig0UU
	 U/I8Fy0GgC/m/LkaTICwi59SDCEv8Jbe8FSE1FfV9qxAZOaymJOrPk/eYCbFsGbUEMf7t
	 EYUuL5rImDMOeB3JYCyAHOaeTs+wVTRf5f6BbZvObuCLkXId4anDq2steblPiej3Es1a4
	 e5MAvbO2LRkmgcFgbodkcTOcnTRfqafDXlrVS1Aw0YGv1N+3m84AGIyuYmIC6CLDqU2nx
	 dceetL6p7/1TFFlmU55lGtj5Tw9gQaHzMfyfthqs6T2IwiU29WjF3xuQBxL3vT5CsKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810624;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=AYMLoYBUxrNS9z92Ifslt1lmXy6GeutY/EG2eaOvJV4=;
	b=avmFBCd9L9oa2vki4XW9/qnobtivRUzEHuJm6Y7VyUp02LOXzJTHtNK1xU6mFXEPG5Wu
	 2dgDBXdZYqJMi4rPwihkxlNnYc74r0aDE+ERLr+b4R/bRKcr9o3sJhkNjMoTyaU65vGf4
	 Emj8YYS+JN4Wh0a33oE60tLEbecGn4dU6TULgOHsXN+xCNwIQUD+hgb/b6ORo08zBZ0R+
	 DLJSRiddJ/EPqQBar/FeMSHiortpHqRsAB2+/E4AMMm8nqsZ6CLbCL6etAT0eE1zXjpcW
	 QLQD+82+KfbuvPmjFklnxiJA89+nGfFSB8U/B9bHk/HfUoO+kZuz7spmLyFdzDGD2sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J6WBuYP0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A91606A328
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J6WBuYP0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539241F00919;
	Wed,  4 Nov 2026 16:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810624;
	bh=AYMLoYBUxrNS9z92Ifslt1lmXy6GeutY/EG2eaOvJV4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J6WBuYP0ysxlP6WtFUbe7s0J5+prnhHmeUrdEIlzyYyCwYOUyKEWpUdG4GdTeyJM9
	 BGGE7ilPic/WbhS2XVbXOmwkQIA4xbqJtdZwuiMKSLGbGXvbL8HqX6itglf2I91ZZ0
	 WnoDK5bRpcWnk9fgSp2EPgO4qANPgPcHlz5PR2wNY/S1+kr+PL3gT4QnqhG9i0MTkV
	 wJ4R3w/h2l7Fv13aZsvIH7SxNBbOdyDHVr6wmQtOHEK6KTKmxZvgQHfQcaKRCSKBlg
	 OOVxB8/y1ZTUzRFREOWxvhvMgKevZcECOzmbFlFVF+TPIw3TGmfmq3tNgxLCP2iJNI
	 TxgUcXFHHEDDw==
Message-ID: <sashiko-outbox-197659@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 06/23] RDMA/mlx5: Require IB_QPT_DRIVER for
 the DC vendor QP types
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-7-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-7-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:44 +0000
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
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D6

