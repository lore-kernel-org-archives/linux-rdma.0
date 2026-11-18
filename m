Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795008960;
	b=Q+M8WUnTm8bJ6xV06NZuguYe3oU/iiBXz+sVBE45s9CnhaWogtPUv15OHnq9ZDu6iWXk
	 siLLCGVLVERyUVwPXhTSD10Y/gLkJkHl4lehoZmeodzNk2Eq2cohpE1lOOnIPeLAXG89t
	 6sQymQKE/Glme7dxKgMn9SUYiyM9IiwMPp7Q75T+zPhNW2C25DGbZIWx0tVuGn/2EpqWQ
	 lpMzaDuJ+CLEqZ45odlZnmTdCGQ61mCTSSGl9aH3DS2nJLzuhxaTf7U6sheMreqjIYUCR
	 9WJrEnwBGX/hrqiQbTAojWAU/og2hVVFOTWPBgqC0OxUlUyXDkC4vmQq3elBKtB1OzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795008960;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+41PqZSHv8MMTPcB5xlIB7ntimdZR4paAOnw4mxkHns=;
	b=kfhs14LfmD6ugJMFhbJzorIGGdgYft1BKolv9lJh9nUPCBejKp+w5Jbz7s2bttYRWd6c
	 uhqMuMxHE/qMm7FQRj8u39WgVBAH4mHsqHrDw1w7GN1sxqIS+wNDCZJLH67Xkf+xDKe4+
	 HSJhTOMQUHCZM5M3U96XoRn5s7WaaupjUMG0gHmyA8fzR96i/xYr1d3GFf7KEGZVlFKGW
	 s8+o5b5EWOIUDeVbDQA2RXjV3wvczv2e46hdhWeHKnmPXNzLtL7TDixWGiePsrTuEyJ7g
	 O3OEIRV9o+yHJPcHNjW876mcGHLQJDhu12dkqNbQX1uGUOUEF9zY8xj8WqPgv1m9JmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k1eJjvIQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859EA606A325
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 13:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k1eJjvIQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B141F000C4;
	Wed, 18 Nov 2026 13:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795008960;
	bh=+41PqZSHv8MMTPcB5xlIB7ntimdZR4paAOnw4mxkHns=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k1eJjvIQDl3O4NmyJ00AKz+DOAD6PeiNLK/SIA3PjyL7+LQ6sNEoNfyI50F2O0eun
	 mxMKUok5394UNkhfc4W6+pC6IKAgnR6sA/33ScQpkI5s/iLRiR6UiIFswENujzvzqr
	 Hf+vXpZWRRU8GToy6XmZkHAxjfUibcwIAfsYcyiBMq2j04Gex696fk/lr8uzMIog6D
	 Y4Ttguh8aXjemst7Iryn/2ryojKZhn9+/VtC4iUn+owEW/Km842AHaM1aEV0e5UfvT
	 4HB7MvEJB6o/LecHFCi/Xco1p1JwsH4PcoTTKdb39TvnHFAJN89mwXp5h+FoodzEgL
	 VulzFG7PBnncA==
Message-ID: <sashiko-outbox-221032@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] IB/hfi1: reject writable SUBCTXT_EGRBUF mmap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abdifatah Suruur" <suruurism@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118131948.28748-2-suruurism@gmail.com>
References: <20261118131948.28748-1-suruurism@gmail.com>
 <20261118131948.28748-2-suruurism@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 13:35:59 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] IB/hfi1: rejecting VM_WRITE on SUBCTXT_EGRBUF in
  hfi1_file_mmap() breaks subcontexts
- [Low] IB/hfi1: inaccurate Fixes trailer citing 12220267645c for
  hfi1_file_mmap()
--

commit 0342c207f57f73ef2cbfe9cff3f4ce685d284272
Author: Abdifatah Suruur <suruurism@gmail.com>

> IB/hfi1: reject writable SUBCTXT_EGRBUF mmap
>
> hfi1_file_mmap() clears VM_MAYWRITE for the SUBCTXT_EGRBUF mapping, but
> never checks whether the caller requested VM_WRITE in the first place.
> A caller can pass PROT_WRITE to mmap() and get a writable mapping of
> the read-only shared eager receive buffers, unlike RCV_EGRBUF which
> rejects the request with -EPERM.
>
> Add the missing VM_WRITE check, matching the other read-only mmap cases
> in this function.
>
> Fixes: 12220267645c ("IB/hfi: Protect against writable mmap")
> Cc: stable@vger.kernel.org
> Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>

[Severity: Low]
12220267645c ("IB/hfi: Protect against writable mmap") only added a
VM_WRITE | VM_EXEC check to the STATUS case in hfi1_file_mmap().  The
SUBCTXT_EGRBUF handling dates back to 7724105686e7 ("IB/hfi1: add driver
files").

> diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/h=
w/hfi1/file_ops.c
> index 779dbe32c69da..412c134e5fb2a 100644
> --- a/drivers/infiniband/hw/hfi1/file_ops.c
> +++ b/drivers/infiniband/hw/hfi1/file_ops.c
> @@ -526,6 +526,10 @@ static int hfi1_file_mmap(struct file *fp, struct vm=
_area_struct *vma)
>  		is_vmalloc =3D 1;
>  		break;
>  	case SUBCTXT_EGRBUF:
> +		if (flags & VM_WRITE) {
> +			ret =3D -EPERM;
> +			goto done;
> +		}
>  		memvirt =3D uctxt->subctxt_rcvegrbuf;
>  		memlen =3D uctxt->egrbufs.size * uctxt->subctxt_cnt;
>  		flags &=3D ~VM_MAYWRITE;

[Severity: High]
Does rejecting VM_WRITE on SUBCTXT_EGRBUF break userspace context sharing?

Unlike RCV_EGRBUF, which maps DMA buffers written by the HFI1 chip,
uctxt->subctxt_rcvegrbuf is a vmalloc_user() buffer allocated in
setup_subctxt() for userspace subcontexts sharing a hardware context, and
neither hardware nor the kernel ever writes to it.  The process polling
the hardware receive queue forwards eager packets to sibling subcontexts
by writing them into this shared mapping (alongside SUBCTXT_RCV_HDRQ and
SUBCTXT_UREGS), so userspace maps SUBCTXT_EGRBUF with PROT_READ |
PROT_WRITE.  Rejecting VM_WRITE causes subcontext initialization to fail
with -EPERM and leaves nothing able to populate uctxt->subctxt_rcvegrbuf.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118131948.2874=
8-1-suruurism@gmail.com?part=3D2
