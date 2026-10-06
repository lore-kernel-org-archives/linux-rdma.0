Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FCF45D90A;
	Tue,  6 Oct 2026 23:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330699; cv=none; b=WyM9v+akN4jnOvOKmUCBn1GFjE/X0WZ4IgWjkF20CmNSCanD7f6F5qINlH0+MAokG208FbTCMpggVyKvvvFwo2fc8uNZRXii2ekO75f/dIvH1Un0q0Xt9gOJdVTm3uzo/UBpuiNKwwxSoXXP3/IgOom/keDs0qjPf0dW+c4S19w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330699; c=relaxed/simple;
	bh=3hUbVCztv1hYEM6wjkEyDGTyPpgI0uE9D9WXleIrXXI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=grVLCnLLfp0blexJx+Zp8WVCKofKZ/e7VfOeGtlye7D1nvvfKCEXeZmNtuL64mb5d693mjLCxAF9/fJmGCcR1LMoL3mXWHkjyxO6ryJcpPSQb8rzaTUi0PF6xn4vP5jxmZAd6wylYdyMhVzplsJVpVq0DW0nuKEjNzsW/MG6TRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f182rh10; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f182rh10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C87C1F0089B;
	Tue,  6 Oct 2026 23:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791330697;
	bh=T5fEJovPsoCfP5P+FXv4U7qjHPT68sKbk0R51K6ii7M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f182rh103XM6R0hz4Tps9Q6Csl2cT7UIdegA7GvOeNN7R9YaFA2IEQt/nmOOk7MHH
	 BNS9BM8zIilThfi4NrccOwFzYeEEI453zGIlYWsmT9QKomKDx1w3zbZp2i3HjcCEbd
	 7CUlscOkOClPQD/howpAlCJ8az7wiTcrZAlz55pUT/DATXM0mBaezQscpqGEcugrpo
	 Hab7sMjwXzJtAkKmywrBajq3wugy7kq6G3hUzZg8Ylc4S/K+N/qhX0ZL5kF9CIacQC
	 78gyCjRYiyj1rgpqgyRXnOVrlP9vI8xw0RuOLX06ucqjIdXXkhXr40yY6X4R/m/bcV
	 HQAulhOQrQIpg==
Message-ID: <sashiko-outbox-162530@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v1 7/8] nfs: allow LOCALIO for P2PDMA pages only as
 aligned direct I/O
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pranjal Shrivastava" <praan@google.com>
Cc: linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, "Anna Schumaker" <anna@kernel.org>
In-Reply-To: <20261006233248.705086-8-praan@google.com>
References: <20261006233248.705086-1-praan@google.com>
 <20261006233248.705086-8-praan@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 23:51:36 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm: memory and refcount leak in nfs_local_doio() on initialization=
 failure
--

commit 9173ddb2cde9be449dc0867c1db4182cfbf16690
Author: Pranjal Shrivastava <praan@google.com>

nfs: allow LOCALIO for P2PDMA pages only as aligned direct I/O
   =20
LOCALIO hands READs and WRITEs to the local filesystem, which can take
P2PDMA pages only if its disk can DMA to them. Use LOCALIO for such I/O
only if the filesystem's block device supports P2PDMA. Otherwise send a
regular READ or WRITE RPC, as if LOCALIO were off.

[ ... ]

> diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
> index ec535ed3051d4..2d1d07c460fd4 100644
> --- a/fs/nfs/pagelist.c
> +++ b/fs/nfs/pagelist.c
> @@ -1023,6 +1023,9 @@ static int nfs_generic_pg_pgios(struct nfs_pageio_d=
escriptor *desc)
>  					  &hdr->args.context->nfl,
>  					  hdr->args.context->mode);
> =20
> +		if (localio && hdr->args.p2pdma)
> +			localio =3D nfs_local_p2pdma_check(localio);
> +
>  		if (NFS_SERVER(hdr->inode)->nfs_client->cl_minorversion)
>  			task_flags =3D RPC_TASK_MOVEABLE;
>  		ret =3D nfs_initiate_pgio(NFS_CLIENT(hdr->inode),
>  					hdr,
>  					hdr->cred,
>  					NFS_PROTO(hdr->inode),
>  					desc->pg_rpc_callops,
>  					desc->pg_ioflags,
>  					RPC_TASK_CRED_NOREF | task_flags,
>  					localio);

[Severity: High]
Does this code leak the localio reference and the nfs_pgio_header on
initialization failure?

The localio reference is created here and passed down. On error return from
nfs_initiate_pgio() -> nfs_local_doio(), this caller does not drop the
reference, nor does it have access to the requests bound to the leaked hdr.

If nfs_local_iocb_init() fails (e.g. -ENOMEM) or !hdr->args.count evaluates
to true, nfs_local_doio() returns early:

fs/nfs/localio.c:nfs_local_doio() {
    ...
	if (!hdr->args.count)
		return 0;

	iocb =3D nfs_local_iocb_init(hdr, localio);
	if (IS_ERR(iocb))
		return PTR_ERR(iocb);
    ...
}

In these early return paths, it looks like the nfsd_file reference (localio)
is leaked because nfs_local_file_put(localio) is not called.

Furthermore, call_ops->rpc_release(hdr) is never invoked. Because the
requests (nfs_page structs) were already moved to hdr->pages in the caller
(nfs_generic_pgio), the nfs_pgio_header and all attached pages seem to be
permanently leaked, potentially resulting in hung processes waiting on page
writeback/read and memory depletion.

By comparison, nfs_local_commit() correctly invokes
nfs_local_release_commit_data() to clean up on its allocation failure.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006233248.7050=
86-1-praan@google.com?part=3D7
