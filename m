Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F2339B943;
	Tue,  6 Oct 2026 23:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330125; cv=none; b=OwfsULm0i0dNndUvXouHpjmUS5bc+/l15srIsPvDRXomDsb8zF6R1dR2XSuC4+QsgxdNHSmOz40IM/GKpMcw5nQ9LKb+Z/vbr5DFs6O4fgI966H6Q1yrjm814OOVKDLaNqPQoJKrorc2/cgqltOPihiktiVdyUaR3ypYY4DTxPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330125; c=relaxed/simple;
	bh=Nap5fZ4JORLq1tq8tO/SiD4IMV1fWsDChD3q6NRHKPY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=pAgZ03Sn2mHJru5qYrzgAoueYg0eTRtM3KV47nOhvXssoYbPEVWs0e5yJt5HcccpoI8tYcfOZlT5Pt+mQ//rZ4tyxvUUNiYr7Pc+B5zP6vCXAsNdn53ma8uWkgP6aKw8FOgC0mcGJM8BPlllfAVvqGuFH7dIUui6zWHbhLCssZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B+Ud1LMC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B+Ud1LMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF3C1F0089B;
	Tue,  6 Oct 2026 23:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791330124;
	bh=KWxuXnmCCetnz95Ez66rckTIF3cYN/uEIk/KHCOryUk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B+Ud1LMCfvCtHjscpUooLAv1AW1CZLCDJ0cZXaMdhxFE05LYDufaOT4rC/iGFKkkv
	 iIs8KjtV0QxyCRXLvsFXT5o2bqV1kBqY9mdIOtH5/U4987z9g7jGYCbRxNHBUF1a4v
	 nIAOvKsjPdfee4khq2HW4SPUyWNvzPURxdrl+VS7aOv4j34TtckDtRim+0YOUsvIez
	 6omA/dnGEhTLRdviFliv9iY9XAWlhGOHyJGrvyig9pVRHw3Qz1yfJK5eeIgblPIvYp
	 62PrWYLWPgeKzboeDbiD5qXVcMDW/iUEVqiShHlEYsERxhQdeskuNygKPmdPbZoQVJ
	 fjh9yvqulMujg==
Message-ID: <sashiko-outbox-162518@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v1 8/8] nfs: allow P2PDMA pages for O_DIRECT on RDMA
 mounts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pranjal Shrivastava" <praan@google.com>
Cc: linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>, "Chuck Lever" <cel@kernel.org>
In-Reply-To: <20261006233248.705086-9-praan@google.com>
References: <20261006233248.705086-1-praan@google.com>
 <20261006233248.705086-9-praan@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 23:42:03 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] nfs: build failure when CONFIG_NFS_V4 is disabled due to missing pn=
fs_enabled_sb() stub
--

commit e7be3531eda417e46246d357bf5c813741ed9450
Author: Pranjal Shrivastava <praan@google.com>

nfs: allow P2PDMA pages for O_DIRECT on RDMA mounts

This commit passes ITER_ALLOW_P2PDMA when extracting O_DIRECT pages on moun=
ts
that use the RDMA transport and not pNFS. The RDMA transport moves such pag=
es
only by DMA, and fails the RPC with -EREMOTEIO if the device cannot reach t=
hem.

> diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
> index a3c6e8f4ea06a..dbeb4f8274e3a 100644
> --- a/fs/nfs/direct.c
> +++ b/fs/nfs/direct.c
> @@ -157,14 +157,22 @@ static ssize_t nfs_direct_extract_pages(struct nfs_=
direct_req *dreq,
[ ... ]
>  	unsigned int npages, i;
>  	size_t pgbase;
> =20
> -	result =3D iov_iter_extract_pages(iter, &pagevec, size, ~0U, 0, &pgbase=
);
> +	/* Allow P2PDMA pages only on RDMA mounts that do not use pNFS */
> +	if (server->nfs_client->cl_proto =3D=3D XPRT_TRANSPORT_RDMA &&
> +	    !pnfs_enabled_sb(server))
> +		flags =3D ITER_ALLOW_P2PDMA;

[Severity: Low]
Will this cause a build failure when CONFIG_NFS_V4 is disabled?

The file fs/nfs/direct.c is compiled unconditionally for all NFS versions v=
ia
CONFIG_NFS_FS. However, pnfs_enabled_sb() is defined in fs/nfs/pnfs.h
exclusively inside an #if IS_ENABLED(CONFIG_NFS_V4) block:

fs/nfs/pnfs.h:pnfs_enabled_sb() {
	return nfss->pnfs_curr_ld !=3D NULL;
}

Since there is no fallback provided in the #else block for configurations
without NFSv4, it seems any kernel configuration with CONFIG_NFS_FS=3Dy
and CONFIG_NFS_V4=3Dn might fail to build with an implicit function declara=
tion.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006233248.7050=
86-1-praan@google.com?part=3D8
