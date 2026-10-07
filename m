Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A890B4BF931
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 15:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791388019; cv=none; b=C2g5+MQ7axIG5PwWsF+zt6jxxoB6DF2l1AU179Z7hHOcWxJKAyoRBlamFetf/pjhm/eWGX6m7I/U8hibi2yWx4b9SSm9akJ1hq/7dYhywYcWVa2toYp+0L4NHr5zaTDjXkgIv50GHB4hefPe3By64UBw+gjMGdI0k07D3x2y0Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791388019; c=relaxed/simple;
	bh=c6W9pLP/3PvhktaKD38nIZdqkyZBHSEoeS0qqkEPaRw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=FIhf+oy0lSTBYBNVgLQXc9BGr/ySDkM62/Fjp63wCPi+zM1JTzV8hX4i4BNOnC+WyMzhymTJgbgXkEPEurOTuxlIHnzjP/MtET5cVFDc8AAXYmEgIE3pfPLqZxdI1GZwP8g9QNYVMlUFs+aILxe7CTCp6TqlhTz1l3+bA8pKu2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GfJn0Xvw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GfJn0Xvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165CD1F00893;
	Wed,  7 Oct 2026 15:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791388017;
	bh=c6W9pLP/3PvhktaKD38nIZdqkyZBHSEoeS0qqkEPaRw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GfJn0Xvw5NICGYsD1EiSvbhTxOS5/xvp6BXSvdqGl5qorJGHtgkant0XJa3mNB+F8
	 SOMvQ1e5T/nerFchC7DpMdWVXM+tp0JXyv20sUm52SBgPGrlP3gjWjO6nDKCOQcO9V
	 PuREtjG6AOpSVWK1sET5cn52ckAoen6Ovti/wxH6p+wkKbmYE96pYRUhXh8psABQyz
	 f9jlgCd7Msjfhe2nSBykxqfNYOuUvWCsw+Rm4lbRLVnPugMxbQEPSpBDobH8+n1ncq
	 TXxBN0iDzldvqsPLjt/QaT7N5E4srujCb7n8AoTkHp+Olz504TIOaIMsNXNYn+9TSC
	 jNem8nQjTTqMg==
Message-ID: <sashiko-outbox-163160@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 08/10] RDMA/mana_ib: Flush and notify CQs
 when kernel QPs enter ERR
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007153330.2979799-9-kotaranov@linux.microsoft.com>
References: <20261007153330.2979799-1-kotaranov@linux.microsoft.com>
 <20261007153330.2979799-9-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 15:46:56 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Complete the RC software flush path by adding a kernel QP to the CQ
> error lists when it transitions to the ERR state.
>=20
> Invoke the CQ handlers after the transition to flush pending work
> requests.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007153330.2979=
799-1-kotaranov@linux.microsoft.com?part=3D8

