Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B679C3D6CC6
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 04:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792213174; cv=none; b=qmG73KNB3TqXAuAOazWH7TAKz/tDeX8D4lO0rjGgUQw9+MaCEUii/vctw0f5TW8/fCW3SahEJ6o611FrMFDH2kk2Yhmk5cAy6dcxRTQxtqmc0rWSiNhE2Rm5bJtIJA9b+VZWW+r6ONgCLxVrhTEn5DgrsNCtZ0Q3Vd2Ry+4QBr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792213174; c=relaxed/simple;
	bh=sPTIbwpuP4I/UqS3W+gXGWcjAt47yAKwqUTBWtlSkCM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=S7UoWcx/R5GeN++f/sbJP3AQ0DinU9hrumf5wIVERZyL8QApZ0qHrpTE8XMLMvzbyuo/sgEV1taRRDFNpZEmuiWBIotrkAFfhejwtKTzqepXNZTHxlxTjRr6FsBiv8sbczk9c6ThQN+BtcPa0a62WmXeZyI5Luu9TAvo09jZe6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ne3NMYuL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ne3NMYuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFE11F000C6;
	Sat, 17 Oct 2026 04:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792213173;
	bh=sPTIbwpuP4I/UqS3W+gXGWcjAt47yAKwqUTBWtlSkCM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ne3NMYuLe+3S5eryJ/49zAXjC3uH4BIUn6GsdZXKrcp+3bIiorLdbMKTijwl1pwS2
	 40XbWBRCqQnKh953vO2zoEldXqU90mMthOLmxXw0CNZE0vnXfactvJ8EkICZFy4hn2
	 mMKvHEoqWb6BZa+JjhQ1PtJvroH0FwC8ZwW4aDlXntbcfEfkDGOAQXvC1/ejirZsJu
	 HnHkPsAkKAvR7tWhC3yOXq0fYgwhpuo9aax3GXbRo1+T3gFmmiTPVlAALbqsS8aaOg
	 3rPQJjaHRBaxSWHL26rX78u0ul7aC+tsTzMYMcMKdAm3UM5fZ9CGNlNXsU0RfsQ6Xp
	 DwkcP1WX5x2ZQ==
Message-ID: <sashiko-outbox-175296@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 3/4] net/mlx5: DR, Don't free the send ring
 CQ if destroying it fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yuho Choi" <oss.patchbox@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261016045849.813696-9-oss.patchbox@gmail.com>
References: <20261016045849.813696-6-oss.patchbox@gmail.com>
 <20261016045849.813696-9-oss.patchbox@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 04:59:32 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> dr_destroy_cq() ignores the result of mlx5_core_destroy_cq() and frees
> the CQ buffer, doorbell record and struct mlx5dr_cq anyway. If
> DESTROY_CQ fails, the CQ may still exist in firmware and retain access
> to its buffer and doorbell record. mlx5_core_destroy_cq() also returns
> early in that case, without waiting for EQ handlers that may already
> hold a reference to the CQ.
>=20
> Keep the CQ and its buffer when DESTROY_CQ fails, as the regular mlx5_ib
> CQ destroy path does. A device in internal error is not affected, since
> the mlx5 core reports success for DESTROY_CQ in that state.
>=20
> Fixes: 297cccebdc5a ("net/mlx5: DR, Expose an internal API to issue RDMA =
operations")
> Assisted-by: LLM
> Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016045849.8136=
96-6-oss.patchbox@gmail.com?part=3D3

