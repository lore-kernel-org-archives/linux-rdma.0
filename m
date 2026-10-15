Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CD044065D
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 12:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792066185; cv=none; b=Cvpx0Zt4LcA876tHqoZgnYVc6jLPhfcRaEvFmf2tuGqX1Eo0twDe+yALf5vEE00nVt0+pBY9AiU7tngBexaSdTeQBZi/nX9NKgSi0MaWwu6YsmHY/bIvXnoaUjz6mVsnyssr2pHpFEXC4Z9RjktdamsS6zseAGo041aD416b+zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792066185; c=relaxed/simple;
	bh=dgd5huWAcC/fa6q65WlXhsQ2nQDlm5BCx0KtVpuVl8M=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=pdyDGIBvbCgJLA26jVL9uSJuBfxy3CVdAio5iYuxOlsZTxZNNPv+NZncxhriC0MztHHGtXNfUnRhamWsfIAe8X5ZAjh0GBaxx1In9VVf/fErXAP8EKqr+oy1Z7myd0AI5xddEgYon+sUHD0l4BACRzAmFtgQ/YZiTmjboXTaZSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EjVgeBX3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EjVgeBX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FAA1F000C4;
	Thu, 15 Oct 2026 12:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792066183;
	bh=dgd5huWAcC/fa6q65WlXhsQ2nQDlm5BCx0KtVpuVl8M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EjVgeBX3Cw5j+W8nqJhOnGcVk86zoSkrAuy2ewRJW9FqyYT6NXe80PvBD9emX4RiY
	 bgro7ik0b+/EUU0MS7X6gJy/0gstzerTZfIP2tZiODpjdPbq97SDkjVTQf9a7zyG0F
	 wrIbQKjAudpO6pqXa9mkh4NvkQpbYJvoxR4umkLg6DOVzug+JYSazwNTa9qQFX8sFP
	 AzxWDnAr4gG+BmVq5gwiz3+U1HEqsxkhZVvrIONXbQ4+a6WP3uDhKVz+ajPEDsXasE
	 byltxjLS9pMwZTDElGprkRZC8Z35ok9S/o1B8BMjDyfKfqcZXdlP6nOpZzxiqTCeGz
	 yBah2kxjQsfnw==
Message-ID: <sashiko-outbox-172783@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 2/3] RDMA/core: Free unpublished port
 statistics after initial-read failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261015-ib-core-fixes-v1-2-60f6da3ddec3@nvidia.com>
References: <20261015-ib-core-fixes-v1-0-60f6da3ddec3@nvidia.com>
 <20261015-ib-core-fixes-v1-2-60f6da3ddec3@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 12:09:43 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> An initial port counter read can fail after allocating its statistics
> buffer and wrapper. Free these both allocations.
>=20
> Fixes: 467f432a521a ("RDMA/core: Split port and device counter sysfs attr=
ibutes")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015-ib-core-fi=
xes-v1-0-60f6da3ddec3@nvidia.com?part=3D2

