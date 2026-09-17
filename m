Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646193BD225
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 09:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789636422; cv=none; b=rTR5svZxq85QFEl+WvBgwvHBA9lkDQOK3hS6UcB6aFEjv+nVcHl8XmRA54Eul2Rki8lFG7gkzeohjSC0eHzt8XTvbyH7pE0sbP5Q9hpbwjVK1RJEEajgYCNQ8WKjZoEEvjT+WYGUhhv1OzahtWNN92/sknYZzq659ekOoUtH5Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789636422; c=relaxed/simple;
	bh=CsxGNK5T81PpTdsPKWxPyfmU3Azw5q04WT+aJ3VXNU0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=f2xGdgmznsj+TCYIAu6YU4U8zND6GVlS+2JbJLvEeXSvoN4KjKFcwmGmXA0jKVx9HbeZWNv2UsBQZYohwxE2CMfm7H5mTl3ESxog/cpmbS+7dEacU6HuSdCA5p0F5aIurBDQNN5qpB8fuqYRe1c2RjRyb0EKA3PM3LOAYwymblE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ED2rKUiI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ED2rKUiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3A01F000FF;
	Thu, 17 Sep 2026 09:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789636420;
	bh=CsxGNK5T81PpTdsPKWxPyfmU3Azw5q04WT+aJ3VXNU0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ED2rKUiIj2zLQBMd98YioD938t9EIe22Yi1Ot+eGqM7MZclJx9G3bdlpTsXVULC3i
	 R6XWZYIMGaLKrZGtmjS8zus/eWC3Vdr5MnSiAIddhai/jUpYJw72Ab6VNAGVCulu7s
	 Ecg5WHtE2edaZwQyUmVf8RKst85e2W6mfD/p09EsTZW3H/mJu0UA2uuiGQ4fezUGrd
	 /SmVb4erfD+A6oyDuEUwe1vruGSevmm5X/C1Ul3fKiAihoTMps3y486VW1ou8yBiVK
	 9G8/FkhwOc7zEvWpubuxRAbUprAZmhwmqFaFBSnVUhmrdZ3nY/5plUbiVaK2E275B0
	 ypBLB7UvSB/Hw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Guard steering anchor resource destruction
 on create error
Reply-To: sashiko-reviews@lists.linux.dev
To: lirongqing <lirongqing@baidu.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917085419.1792-1-lirongqing@baidu.com>
References: <20260917085419.1792-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 09:13:40 +0000
Message-Id: <20260917091340.AD3A01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Li RongQing <lirongqing@baidu.com>
>=20
> The steering anchor resources are shared between anchors with the same
> priority and are protected by rule_goto_table_ref.
>=20
> When steering anchor creation succeeds but uverbs_copy_to() fails, the
> error path drops the reference acquired for the new anchor. However, it
> unconditionally calls mlx5_steering_anchor_destroy_res(), even when
> other anchors are still using the shared resources.
>=20
> This can destroy the shared flow table, flow groups, and rules while
> existing anchors still hold references to them, resulting in a
> use-after-free when those anchors are subsequently cleaned up.
>=20
> Only destroy the shared resources when dropping the reference makes
> rule_goto_table_ref zero, consistent with the existing cleanup path.
>=20
> Fixes: e1f4a52ac171 ("RDMA/mlx5: Create an indirect flow table for steeri=
ng anchor")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917085419.1792=
-1-lirongqing@baidu.com?part=3D1

