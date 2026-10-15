Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763D449A3C2
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 08:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792053852; cv=none; b=OfLkKqXkRlQH9VAVYit+uoFOdhkCFCP37+fSyk32rDvP853pGIbfENZiH7Ka7LqTQ82+DeZDczSSNC5CCpQEfJEBmuPdiw+XdUCnH+VTlsJrjNFtGFJWhc6aUGzokJXlYpXuIsCcVo1zaPP2xACjp23u9tcNZKE+Pe9fxhACA1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792053852; c=relaxed/simple;
	bh=KgF1DdJRWSENjKnO9if/+zTzcq5W1yB+R5mx2OQVUTg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=EbrLOU/xGsW7zpp4mzldbM41Qd0H/mQAcLQDZ6f61gNVbvZ541icg6Hif/pECHEwbWXk/rShCwXOcZQ1qP8uMhLHSIwggbe3qlE2Oyw8oVeLrXBlqbzP6PipnGRV0WDac8PsurrpvhZfld/4nl/aqgLxww2Mv9H7tmUA2vpc7jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FgSUDFqG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FgSUDFqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09ED1F000C4;
	Thu, 15 Oct 2026 08:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792053849;
	bh=7RfH5W6Yp27HV4moV3xREauVjFm+7E7I5p8t+zFFR+Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FgSUDFqGGfNrdi9OG/aDlAgOdyWzSnk/yIbNC+Ils6qf8kO9WGQOge7tOF1tue2uU
	 QbDzwcH98LTOe6p2D7tcQykAIam/ywCmUabSpQJSHdnnxVe4ZfVjPpb6JMGLpSl7sm
	 +czsRkbTGmSxgapPWRIQtzgzjo/8EIGwOZCsU1l9hnL8Hn9qfR0P8YHZn2oYxHtjrM
	 XnLHCalZl0nwQN0QUHncRJBV+2T+T9jAfv+cplkaWPNKMrIAkwKO3/wJ1V+8DfMWNx
	 GgOwR4HFDsLuctZMw6K2w8i47nSbKFiZk8fhQsxGajYmJk+XKaAALWPV6D6h0WATk1
	 d7i9P/x2LBn9w==
Message-ID: <sashiko-outbox-172512@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-rc 2/2] RDMA/uverbs: Fix DMABUF use-after-free
 during ufile cleanup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Deep Shah" <deepshah146@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261015083637.200958-3-deepshah146@gmail.com>
References: <20261015083637.200958-1-deepshah146@gmail.com>
 <20261015083637.200958-3-deepshah146@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 08:44:09 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The DMABUF release can race with ufile cleanup. When the cleanup holds
> hw_destroy_rwsem for write, uverbs_uobject_release() fails its trylock
> and leaves the uobject on the ufile list, but the dma_buf is freed as
> soon as the release returns. The cleanup then destroys the uobject and
> uses the freed dma_buf:
>=20
>   BUG: KASAN: slab-use-after-free in uverbs_dmabuf_fd_destroy_uobj+0x46/0=
x200
>   Read of size 8 at addr ff11000109cf14b0 by task repro/435
>   Call Trace:
>    uverbs_dmabuf_fd_destroy_uobj+0x46/0x200
>    destroy_hw_fd_uobject+0x3f/0x50
>    uverbs_destroy_uobject+0xc5/0x380
>    __uverbs_cleanup_ufile+0x1a8/0x260
>    uverbs_destroy_ufile_hw+0x54/0x160
>    ib_uverbs_close+0x34/0x110
> [ ... ]
>=20
> Fixes: 0ac6f4056c4a ("RDMA/uverbs: Add DMABUF object type and operations")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Deep Shah <deepshah146@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015083637.2009=
58-1-deepshah146@gmail.com?part=3D2

