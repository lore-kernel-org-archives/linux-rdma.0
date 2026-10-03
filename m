Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1160378D70
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 06:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791010518; cv=none; b=iCw1qFLshCZavkGTRzEkeV7+nphlEGylfaSHkMhmMVsr5Rd+6BbB/Ij4CKSSlRw+A4LebXr/Y+Gju+ctDZKuPPZNFw5CWxwTHegQMstObYEwvPh+Njz6SE1fLucazd/Qd95nZQ6S809ZT4gHystnhWYuWa4N1VvYac/xYeJehpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791010518; c=relaxed/simple;
	bh=1yYGoCxzwv7NviAbHbGErkhalQ1Sx3zx3OaWKkhzifk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TXuQBzy1wsGc91mt9fM0nYpUU8QAIW/bQ0XGoqpjqb3CSr8jp3XYgVK27S8rIyIW/Yij68jAHXqKrUOTmKD0FVsJthJDl4VVWudw/cUb1ON1QRrr8eVCdF/oeXZNgm+v1tw4ozzfpmvK5XbTm1y9jyae/pYfRpgWpKAjGF5Hzn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hhN98LTI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hhN98LTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22ED51F0089B;
	Sat,  3 Oct 2026 06:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791010517;
	bh=1yYGoCxzwv7NviAbHbGErkhalQ1Sx3zx3OaWKkhzifk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hhN98LTIk2A4joxFiGWjvQ/SS1AZZzTZPyhb7vNbXtRuh91G3HyNb4QZri/tJAsMS
	 owVMaDpmq0DDeL8h0dIQBbmGQPd2mqwaf8QjVmD68qHiLxdRntxnN1a091hOYs9dPb
	 //wxhHn67Np003WAFM+9+mA8KK9p/50gRYEF1VusNxjA5kMyD52NV+8eIy7/FqZhGs
	 j0ZYSpml6goZjpJZINcrQO1rCyoZMf7mMyUzGi4BsueWJDFWUjryL+L9tYevFf6LAD
	 JYmQzsDY6U/pzqjKR/L1DA6otrFnnm30Ubyidi/aRXE/RsM9Ahyh6JKFlsjCSPWUIc
	 NmekGybMRWx2A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 03/10] net/mana: Extend GDMA encoding for
 new RDMA WQEs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003064037.2092669-4-kotaranov@linux.microsoft.com>
References: <20261003064037.2092669-1-kotaranov@linux.microsoft.com>
 <20261003064037.2092669-4-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 06:55:16 +0000
Message-Id: <20261003065517.22ED51F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Extend mana_gd_post_work_request() to support extra-large OOB data and
> fixed-size WQEs. These formats are supported only for power-of-two WQE
> sizes.
>=20
> For fixed-size WQEs, use num_pad_sge to specify the padding size. Encode
> the WQE header fields required by RC QPs based on the WR flags.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003064037.2092=
669-1-kotaranov@linux.microsoft.com?part=3D3

