Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE9645C713
	for <linux-rdma@vger.kernel.org>; Sat, 19 Sep 2026 10:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789812886; cv=none; b=X53WceThjKI2dp8tBEw9hvuIzIBiMfREM7CIVZT2hHc7dNe6suToPl8toRn4IqicBXPZw47390sx3fP/mPK266ycEoErxXcNEOH6GiiTCwpci6eOlZmbHvtQby2nafzlo8ffcNIuT5qHpkEiEppODY+KHGfJMGIieFLu+hdK+i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789812886; c=relaxed/simple;
	bh=2fSUY8eSm3lsIgGuNlW9iPWJAFxGDBTnBGHeSa1er4A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LTUWsXa9B1H2gDYVxqSL5MnQtdE9+Qj8w6L4F4xpacbR1bIU+ly04SG1ABTozcQIR2RJApvvqM0TtZndV7cUkfKZY45AoaIXpu++k0ZMCOtv8E6CJrJiv2bkNgvdKqHXfdlUFPVwdD0ioimAtgt4b6A7+a8Ku9l1KqOfUBKFaqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S+fiNGxp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S+fiNGxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A607C1F000FF;
	Sat, 19 Sep 2026 10:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789812884;
	bh=2fSUY8eSm3lsIgGuNlW9iPWJAFxGDBTnBGHeSa1er4A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S+fiNGxphQh8HLaEvh2tGtCdHQyPBY0et5oT5umTcSmf3V/2q7tXWRy/8gs5IPaai
	 GgroeJEnIk/TNUUF+JIENVHFiZkK26sXwOuJxaCI9H98MsZ7x9mJSGsA1xK4j8NeYI
	 Lj8PePzgLbpAdQg6Grku5KSPKqJuuG0F03ScxjNy10dK6d+/MYshrUx2ZvjheWTgiO
	 xZCP5POJrLG5wU2adblNHjb4nXdEAVHocRqBJbgwCurg825d8pt9Dr/AyaYNl2BtGr
	 Mom6K+p/GKh4X/8RFlSDuuWjv+ok3L9V07Gw74G+5p6ZjuWo5SswkRorn/Pjv8+9JH
	 Vxmy+alUbPw8Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Fix CQ resize destination index mask
Reply-To: sashiko-reviews@lists.linux.dev
To: lirongqing <lirongqing@baidu.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260919100716.2221-1-lirongqing@baidu.com>
References: <20260919100716.2221-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 19 Sep 2026 10:14:44 +0000
Message-Id: <20260919101444.A607C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Li RongQing <lirongqing@baidu.com>
>=20
> In copy_resize_cqes, the destination CQE index is computed as
> (i + 1) & cq->resize_buf->nent, but resize_buf->nent is the power-of-two
> entry count, so the mask only yields 0 or nent -- and nent is one past the
> last valid slot. The following memcpy then writes out of bounds.
>=20
> Use (nent - 1) as the wrap mask, consistent with get_sw_cqe which masks
> against cq->ibcq.cqe (the nent - 1 value).
>=20
> Fixes: bde51583f49b ("IB/mlx5: Add support for resize CQ")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919100716.2221=
-1-lirongqing@baidu.com?part=3D1

