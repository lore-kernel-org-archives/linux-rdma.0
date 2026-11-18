Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795007659;
	b=mEk9ZVge2/8qr/pTlxaQ1Lth44GWVItUUwlz6lQ7BVw7q6JOE7GTuEr1nqHL2VPjvf5K
	 8sIAGVmI5+5o3eMzCjfJGTcneTh576TPO3RwMvQffkwFMZgDW1h8wb8DpWgj8JqnBs/Qo
	 2FtBjSUiORuKJ7hQeG0qt1ilZ0tphR0QwBQU2city6berR4f+JMnv8OphFdSVZ5l8hkMi
	 mprt1HClIWo/llydOd8AEnrgDcx4pkf74sVB5HxW/G4R/lCKL8q04QVfQ1TMsLzqO7Tun
	 ePMaZ+vfMXYUYtoyO7kVvTOOpO+il9jKKpGvViN4te0yfu3NhmxAME4NN/6kordOC6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795007659;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xHUEqWZloSUNy+abKmteM/t4wNupuA98wk8RZEo96Gk=;
	b=J3681P6x2+YUzglTr0fLqg2mDSyhGNcmTymjmmEHUMMnGjm+Mk5kOly51Qj3ZBaa1ihf
	 makdv+zqyki2+LpxBTDOz/3eqfZer/5sz2qxokweMJ/hjec6yCTIOeSdD10IMrOG+BaLX
	 6f2QxofwPPLx/TIhtwri8dvVuP6pLt0fMPxFoBHuG8V8YKbazozvWew+IPUwpxVZ71+KE
	 9XZMr65hB64tRgJ2RMamjemGzV9lc1keH1cLVJx34dmGN4IQKwgoIbbGF/NBvAP4Nkxu3
	 t5Zhgmu0sZPc5pXj7k9n0HmF2dNrMc+HqG/SxtUSnFFyGT2cGSFYRitRxYlEAUNPihQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=awFjY5vh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A4F606A32C
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 13:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=awFjY5vh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08B71F000C4;
	Wed, 18 Nov 2026 13:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795007658;
	bh=xHUEqWZloSUNy+abKmteM/t4wNupuA98wk8RZEo96Gk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=awFjY5vhJLZZAqBadBxjYelJ13dCZRVAveZ9ReshQd1BC6jp+75MwJk/Whs0Fvzgq
	 W4xSJKZtgBias6yJfXAV+biOnr9jmAgHL8arxNoX1JfHUDDjFdJdBPbHECBu7a0WYA
	 27DCS6nOoalUasJ5TtByDaeJx+ZDN70RvNUpFtSMUkmK8QKwWq15/nnDZBsDlG63tY
	 lOtKT85PcN+QGYbMh8iw2voEW5NEpCCTk+0kbdIFYENp3CH28AmSsfcoTUdbOTFEpd
	 sbw6O10O6H75Kn+F1Juy2b3LoAv9ALrj2wIsRfdEQwOlDHvoRm4maufOEpnzvyzvph
	 UcLs7KjYe3Wfg==
Message-ID: <sashiko-outbox-220989@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] IB/hfi1: clear VM_MAYWRITE on read-only STATUS mmap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abdifatah Suruur" <suruurism@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118125848.26160-1-suruurism@gmail.com>
References: <20261118125848.26160-1-suruurism@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 13:14:18 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] IB/hfi1: missing Fixes trailer for STATUS mmap VM_MAYWRITE fix
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Critical] IB/hfi1: missing VM_WRITE check in hfi1_file_mmap() [1]
--

commit acb6e09931f843c6bef13cb9b188808881bec93a
Author: Abdifatah Suruur <suruurism@gmail.com>

> IB/hfi1: clear VM_MAYWRITE on read-only STATUS mmap
>
> hfi1_file_mmap() rejects a writable mapping of the device status page,
> but leaves VM_MAYWRITE set in the VMA flags. Userspace can map the page
> read-only and then upgrade it to writable with mprotect(), bypassing
> the check and writing to a device-owned status page.
>
> Clear VM_MAYWRITE on this path, as the RTAIL and SUBCTXT_EGRBUF cases in
> the same function already do.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>

[Severity: Low]
Since this fixes the read-only STATUS mmap check added in commit
12220267645c ("IB/hfi: Protect against writable mmap"), consider adding:

  Fixes: 12220267645c ("IB/hfi: Protect against writable mmap")

> diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/h=
w/hfi1/file_ops.c
> index 680364fda856f..779dbe32c69da 100644
> --- a/drivers/infiniband/hw/hfi1/file_ops.c
> +++ b/drivers/infiniband/hw/hfi1/file_ops.c
> @@ -492,6 +492,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_=
area_struct *vma)
>  			ret =3D -EPERM;
>  			goto done;
>  		}
> +		flags &=3D ~VM_MAYWRITE;
>  		memaddr =3D kvirt_to_phys((void *)dd->status);
>  		memlen =3D PAGE_SIZE;
>  		break;

[Severity: Critical]
This problem wasn't introduced by this patch, but can userspace map the
SUBCTXT_EGRBUF region as writable [1] by passing PROT_WRITE to
mmap()?

drivers/infiniband/hw/hfi1/file_ops.c:hfi1_file_mmap() {
	...
	case SUBCTXT_EGRBUF:
		memvirt =3D uctxt->subctxt_rcvegrbuf;
		memlen =3D uctxt->egrbufs.size * uctxt->subctxt_cnt;
		flags &=3D ~VM_MAYWRITE;
		is_vmalloc =3D 1;
		break;
	...
}

The SUBCTXT_EGRBUF case clears VM_MAYWRITE from flags, but unlike
RCV_EGRBUF, STATUS, and RTAIL, it never checks if VM_WRITE is set in
flags and does not reject the mapping with -EPERM.  When userspace maps
SUBCTXT_EGRBUF with PROT_WRITE, vm_flags_reset() leaves VM_WRITE set on
the VMA and remap_vmalloc_range() maps uctxt->subctxt_rcvegrbuf with
write permissions, allowing userspace to modify the read-only eager
receive buffers.

[1] https://sashiko.dev/#/bug/linux-011f18cc-47f7-48a3-9cad-8eb2f835cdbe

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118125848.2616=
0-1-suruurism@gmail.com?part=3D1
