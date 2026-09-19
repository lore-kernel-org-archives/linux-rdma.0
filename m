Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236D93F4138
	for <linux-rdma@vger.kernel.org>; Sat, 19 Sep 2026 10:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789813452; cv=none; b=b3YODcZwfFdq4qvzpXzowf31ELiqo6RiliPqEe5dmftP07h4xLnILitDRM+w7NUKu+xKZ1fSnXNdvb0GmYGVkqTbvVdMlWRMtpJauDD9Xvi3hqfSdr8lJCW/FZE83hmASGQzz86/qVmIPIR4s4Xvs4cwXdg4yuC7ztXzcJsjDis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789813452; c=relaxed/simple;
	bh=9+v6uugAhSvlJybQTu8n3i54NzFwoppMILOftWgNKTs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sbgc1sXdqSs/ms5K8e45t/QfvBRkso8CZSf4XIvCLHl9MaA6tuPCAysZPN6taI6e0KcnkT9FJH5gFiVLTJwnvTzb+07oAdfnhayMGBMq4dc65VqNmvUWA28mghFUlom/1zzE/zAXC1/521GpxFtiVgt96pOGqOhvnmKgivQSpuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lSbuXJef; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lSbuXJef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8507F1F000FF;
	Sat, 19 Sep 2026 10:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789813450;
	bh=9+v6uugAhSvlJybQTu8n3i54NzFwoppMILOftWgNKTs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lSbuXJefkJ8j+v2y6IZTwi1goVVHgabUcJ5snFTsF/tvCbiBVDiI9aJHrtZsi7b55
	 fIw2Aj5uFTq2A3+WrOaFT7hwQJ3TimoA8Q0dLtcdRvEOCUUJFItzaHhiIe0P1PTTtp
	 KGRd+bGR7Tp/FL8VygDZ5NJSeh/3NnG+eTFEvQkV0MDUcXiVFawVmx9YGeJIcMjn1Z
	 9QYlxp8YABrkiF75ys6qqdVYX+S5PEuNdaDpEhfPbSVavwix03BVd1ObbSUeE0aTgD
	 9/Y4R18lLWOHhGHl0D8HPN2hDtgNMlETfVByjgse3TkF/1gmECIzeODjuAxRelHba2
	 5MkVmi2dnLvWg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Restore mr->pi_mr after temporary
 stack-local assignment
Reply-To: sashiko-reviews@lists.linux.dev
To: lirongqing <lirongqing@baidu.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260919100848.2442-1-lirongqing@baidu.com>
References: <20260919100848.2442-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 19 Sep 2026 10:24:10 +0000
Message-Id: <20260919102410.8507F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Li RongQing <lirongqing@baidu.com>
>=20
> In handle_reg_mr_integrity, when mr->pi_mr is NULL (physical-address
> optimization path), the code points mr->pi_mr at a stack-local pa_pi_mr
> so set_pi_umr_wr can read it during this call. The pointer is never
> restored, so after the function returns mr->pi_mr dangles at a freed stack
> frame. A second IB_WR_REG_MR_INTEGRITY posted on the same MR without
> remapping reads the stale pointer and dereferences it.
>=20
> Save the original pi_mr (captured at function entry) and restore it on
> the out path.
>=20
> Fixes: 2563e2f30acb ("RDMA/mlx5: Use PA mapping for PI handover")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919100848.2442=
-1-lirongqing@baidu.com?part=3D1

