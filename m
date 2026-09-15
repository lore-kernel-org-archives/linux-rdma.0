Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AEC3B4EB7
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482109; cv=none; b=pRWGCUrfTmHsKyxknwWVJ6wN4jLRMkG/LY2/Hf+ILQJBsYYdulRZ+vH2lsMQB5XW3u4On8v8749KBLkSo1Pvxb3OPN+EO//eFb2ZCXxCFR8yppdcizjZD5Trid9Ttc6ZZb2qf1dBnFamxTuXBwsvhAlOyavbLzfBL6dZgxCvxM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482109; c=relaxed/simple;
	bh=ZECKgZ6dGMcO/LQGeWkrSrPD2pM5VjCs21rxUEj1uhU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=o3P7r91wuqY4spT2IlrwTj5RTSVAcZrOSiRqgqb43/3ZaYuyEQhOiVnbfWMvDIgE+0tihcet/NGgvcYi+MDcwa6oSpDLGwZLk0l7H+sglnNhGYL1Tc+3BlULBTKyQZrjTd3EtU5qNkAaS7lZgTO9p1B19uahPxxwRb+dyMxaVa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oom0k48H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oom0k48H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4C81F000FF;
	Tue, 15 Sep 2026 14:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482106;
	bh=ZECKgZ6dGMcO/LQGeWkrSrPD2pM5VjCs21rxUEj1uhU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Oom0k48Hlxu9DZqmevbDYQifUb1+IfV37lzq4q2fDz4dG+5lvd9s4M5m6/YxDboTX
	 Qy/9aCI9LMMdELm7Oso3tPY1gfCths2b3cRbMFmuBh62bOY1Y0oHz0Xo58a5sPCRQT
	 sAj3cisFhbNL4qY3Z++8J10T1K1T5eU18S7k9HQLSpv5DpIFjhZiZlw57iRDkYZstB
	 BHn9Q6tRVHmxrcWPHCuDtHABFNDsC/Snpo2dxJ6jNwvljsmoTg9xbV740ZaLnR6F82
	 V4ql2mPrItt0Tc6OHeam94AqUaF3B3Y9hP6CZvkxTMR7glbVOsS8iZ7lBP3Xk7UuhS
	 HlFK++r7nfPoQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 03/15] RDMA/vmw_pvrdma: Pin QP and SRQ
 rings writable to match device DMA write access
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915140933.40580-4-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
 <20260915140933.40580-4-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 14:21:45 +0000
Message-Id: <20260915142146.3C4C81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> pvrdma embeds a pvrdma_ring_state header directly inside the QP and SRQ
> ring buffers, and the hypervisor writes cons_head into that header.
> Pinning with access=3D0 does not force a private page copy (no
> FOLL_WRITE), so the hypervisor may write into a shared page.
>=20
> Pass IB_ACCESS_LOCAL_WRITE for all three rings. The SRQ ring_state is
> not currently used by the driver but is pinned writable for consistency.
>=20
> Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915140933.4058=
0-1-yishaih@nvidia.com?part=3D3

