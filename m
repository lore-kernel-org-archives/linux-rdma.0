Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793612864;
	b=AS/5Fn+IOBlivik/PciKdAmHKZC8M0+SrRYolAtPArsH0q6VRv8IdHTpjjH2R4mn6iw/
	 yYCv2vVhpZ+W0bgJzVNHOCSO8quK65ynimJvH+24CzXdmFSxHHBGSgyA3OjcasOYrrCTS
	 Mpe2mmurr+x28xVTipXK6973z/F2QeFXb6euiEpMNgknXvgyFWZ9UW86jZbeyf1WuJawt
	 3P3vqNFSPey16zMY/Rh/bjmKSgXoW8wngPEuTN0Z/50iAvn4uwgbHCHynmr3jsvm4O9j+
	 EdXoT1ntze6cyyWbO4CoPQDaIgeFTiOse6IOhSQg6mXgE0ef0v24AhpH2YGQEmiMbRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793612864;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4sOlI3Y3GiGnp4mrMu9VcEXgklsU8LZWy3NI59MfFYc=;
	b=VjMt8rTvSpTh74P41L9DbVtqcmOIU8pXfXwe4886kSW6NZevFtjOsoTwOKwk95FIlp/k
	 tdCc+lEULMJ9j32Y5Nsz87EXZn5fPfi0uSM3YC/lefLsKhuQvO/x26ruKXfKslAqT6LAd
	 Folrj9S99Ni1OVYXOV3fKRDTq8XtJ4x0f1NxnFIRKYjw5RNSpJsw1JgMtjlZ8HxY004Ff
	 4m9vd3Us0ZAECeBlwT/e/uE7eo9vqUtCbURUY0++GUuEHaW7wDtcBnlS4BD1HoeZFJH1S
	 8Wv+r+A+QioKLKdNtDwBra22UM1YH1yYuaUGcmMe4FxXYq3jWPGZtnvrohwIK8o4ceA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZHVpgWCZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7FB606A337
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 09:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZHVpgWCZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D202D1F00A1A;
	Mon,  2 Nov 2026 09:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793612864;
	bh=4sOlI3Y3GiGnp4mrMu9VcEXgklsU8LZWy3NI59MfFYc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZHVpgWCZTRt6NtSuvwWX4tg91+rnp5fw8FW2dn/clOSwPPlZ2qWORKIycG+eK+tq+
	 nNkLoo8nkwaaHreySNgZ+wfTSa0ZQRbLdMYHlJECN2yd9vsggBsHY2OVTXHF7I4BE3
	 WgDc+RUG9mYONpO9N3vgoOuOtPxNzVSJ8HzVo2gCdy/nbuP7An3SAAd3wTa7NwdT8E
	 l2jiqkBTqq6NbDo2dwI4eTZOi1i7shjk+IzfcNkFPSr+/PJXzgWmbc+timK90TY/nz
	 n92ir5egOFaUIqMUtRNpTiTgDe04LZMwpnT039TsK0hEMbBfbA50vmxz0vUZpDrOA9
	 XEBTGSvXgNJ/g==
Message-ID: <sashiko-outbox-193206@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma v8 7/7] RDMA/zrdma: Implement context, PD, and mmap
 operations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102082026.2645777-8-zhang.yanze@zte.com.cn>
References: <20261102082026.2645777-1-zhang.yanze@zte.com.cn>
 <20261102082026.2645777-8-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 09:47:43 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] RDMA/zrdma: missing udata validation and response zeroing in uco=
ntext and PD ops
- [Low] RDMA/zrdma: unratelimited pr_err() on user-triggerable paths in zxd=
h_alloc_ucontext() and zxdh_mmap()
--

commit 34250bc80391a0c4ba1beb61faa1ec946d1b1b77
Author: Yanze Zhang <zhang.yanze@zte.com.cn>

RDMA/zrdma: Implement context, PD, and mmap operations

This commit implements protection domain allocation and deallocation, user
context management, and doorbell memory mapping operations for the zrdma
driver.

> diff --git a/drivers/infiniband/hw/zrdma/zrdma_verbs.c b/drivers/infiniba=
nd/hw/zrdma/zrdma_verbs.c
> index 821ccbc2054ea..239d607f7d182 100644
> --- a/drivers/infiniband/hw/zrdma/zrdma_verbs.c
> +++ b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
[ ... ]
> @@ -392,15 +393,343 @@ int zxdh_ib_register_device(struct zxdh_device *zd=
ev)
>  	return ret;
>  }
> =20
> +static void zxdh_sc_pd_init(struct zxdh_sc_dev *dev, struct zxdh_sc_pd *=
pd,
> +			    u32 pd_id, int abi_ver)
> +{
> +	pd->pd_id =3D pd_id;
> +	pd->abi_ver =3D abi_ver;
> +	pd->dev =3D dev;
> +}
> +
> +static int zxdh_alloc_pd(struct ib_pd *pd, struct ib_udata *udata)
> +{
> +	struct zxdh_device *zdev =3D to_zdev(pd->device);
> +	struct zxdh_sc_dev *dev =3D &zdev->rf->sc_dev;
> +	struct zxdh_alloc_pd_resp uresp =3D {};
> +	struct zxdh_pd *zpd =3D to_zpd(pd);
> +	struct zxdh_pci_f *rf =3D zdev->rf;
> +	struct zxdh_sc_pd *sc_pd;
> +	u32 pd_id;
> +	int err;
> +
> +	/* The user has to provide a buffer for the whole response. A short
> +	 * buffer is reported instead of being silently truncated, and no
> +	 * resource is taken for it.
> +	 */
> +	if (udata && udata->outlen < sizeof(uresp))
> +		return -ENOSPC;
> +
> +	err =3D zxdh_alloc_rsrc(rf, rf->allocated_pds, rf->max_pd, &pd_id,
> +			      &rf->next_pd, "PD");
> +	if (err) {
> +		pr_warn_ratelimited("zrdma: PD allocation failed err=3D%d\n",
> +				    err);
> +		return err;
> +	}
> +
> +	sc_pd =3D &zpd->sc_pd;
> +	if (udata) {
> +		struct zxdh_ucontext *ucontext;
> +
> +		ucontext =3D rdma_udata_to_drv_context(udata,
> +						     struct zxdh_ucontext,
> +						     ibucontext);
> +
> +		zxdh_sc_pd_init(dev, sc_pd, pd_id, ucontext->abi_ver);
> +		uresp.pd_id =3D pd_id;
> +		if (ib_copy_to_udata(udata, &uresp, sizeof(uresp))) {
> +			err =3D -EFAULT;
> +			goto error;
> +		}
[ ... ]
> +static int zxdh_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata=
 *udata)
> +{
> +	struct zxdh_ucontext *ucontext =3D to_ucontext(uctx);
> +	struct zxdh_alloc_ucontext_resp uresp =3D {};
> +	struct ib_device *ibdev =3D uctx->device;
> +	struct zxdh_device *zdev =3D to_zdev(ibdev);
> +	struct zxdh_alloc_ucontext_req req =3D {};
> +	u64 srq_db_mmap_size;
> +
> +	if (ib_copy_from_udata(&req, udata, min(sizeof(req), udata->inlen)))
> +		return -EINVAL;
> +
> +	if (req.userspace_ver !=3D ZXDH_CONTEXT_VER_V1 &&
> +	    req.userspace_ver !=3D ZXDH_CONTEXT_VER_V2 &&
> +	    req.userspace_ver !=3D ZXDH_CONTEXT_VER_V3) {
> +		pr_err("zrdma: Invalid userspace_ver%d\n", req.userspace_ver);
> +		return -EINVAL;
> +	}
> +
> +	/* The response carries the keys of the doorbell mappings, so the
> +	 * user has to provide a buffer for the whole of it. A short buffer
> +	 * is reported instead of being silently truncated.
> +	 */
> +	if (udata->outlen < sizeof(uresp))
> +		return -ENOSPC;
[ ... ]
> +	if (ib_copy_to_udata(udata, &uresp, sizeof(uresp))) {
> +		rdma_user_mmap_entry_remove(ucontext->sq_db_mmap_entry);
> +		ucontext->sq_db_mmap_entry =3D NULL;
> +		rdma_user_mmap_entry_remove(ucontext->cq_db_mmap_entry);
> +		ucontext->cq_db_mmap_entry =3D NULL;
> +		rdma_user_mmap_entry_remove(ucontext->srq_db_mmap_entry);
> +		ucontext->srq_db_mmap_entry =3D NULL;
> +		return -EFAULT;
> +	}
[ ... ]
> +static int zxdh_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
> +{
> +	struct zxdh_pd *zpd =3D to_zpd(ibpd);
> +	struct zxdh_device *zdev =3D to_zdev(ibpd->device);
> +
> +	zxdh_free_rsrc(zdev->rf, zdev->rf->allocated_pds, zpd->sc_pd.pd_id);
> +	return 0;
> +}

[Severity: Medium]
Should the ucontext and PD operations in drivers/infiniband/hw/zrdma/zrdma_=
verbs.c
validate udata input and zero-fill trailing response bytes to preserve UAPI
forward compatibility?

In zxdh_alloc_ucontext(), copying req via ib_copy_from_udata() with
min(sizeof(req), udata->inlen) and returning -EINVAL masks -EFAULT on bad u=
ser
pointers, accepts truncated input buffers smaller than sizeof(req), and
silently ignores non-zero trailing bytes when udata->inlen > sizeof(req).

Additionally, struct zxdh_alloc_ucontext_req in include/uapi/rdma/zrdma_abi=
.h
defines reserved fields:

struct zxdh_alloc_ucontext_req {
	__u32 rsvd32;
	/* Version of the user space, one of the ZXDH_CONTEXT_VER_*. */
	__u8 userspace_ver;
	__u8 rsvd8[3];
};

However, zxdh_alloc_ucontext() does not check that req.rsvd32 and req.rsvd8
are zeroed. Using ib_copy_validate_udata_in(udata, req, rsvd8) and checking
req.rsvd32 and req.rsvd8 for zero would ensure these fields remain usable f=
or
future extensions.

Similarly, zxdh_alloc_pd() does not check ib_is_udata_in_empty(udata) when
udata is present, zxdh_dealloc_pd() does not check ib_no_udata_io(udata)
before freeing the PD, and both zxdh_alloc_pd() and zxdh_alloc_ucontext() u=
se
ib_copy_to_udata(udata, &uresp, sizeof(uresp)) instead of
ib_respond_udata(udata, uresp), leaving trailing bytes in udata->outbuf
unzeroed when udata->outlen > sizeof(uresp).

[ ... ]
> +static int zxdh_mmap(struct ib_ucontext *context, struct vm_area_struct =
*vma)
> +{
> +	struct rdma_user_mmap_entry *rdma_entry;
> +	struct zxdh_user_mmap_entry *entry;
> +	struct zxdh_ucontext *ucontext;
> +	u64 pfn;
> +	int ret;
> +
> +	ucontext =3D to_ucontext(context);
> +
> +	rdma_entry =3D rdma_user_mmap_entry_get(&ucontext->ibucontext, vma);
> +	if (!rdma_entry) {
> +		pr_err("zrdma: pgoff[0x%lx] does not have valid entry\n",
> +		       vma->vm_pgoff);
> +		return -EINVAL;
> +	}

[Severity: Low]
Can unprivileged users flood the kernel log via these unratelimited pr_err()
calls in drivers/infiniband/hw/zrdma/zrdma_verbs.c?

In zxdh_alloc_ucontext(), passing an unsupported req.userspace_ver value
triggers an unratelimited pr_err(). In zxdh_mmap(), calling mmap() on the
uverbs file descriptor with an invalid page offset, a mismatched VMA length,
or without VM_SHARED causes rdma_user_mmap_entry_get() to return NULL and a=
lso
triggers an unratelimited pr_err().

Would ibdev_dbg() or ratelimited logging be more appropriate for these
user-triggerable error paths?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102082026.2645=
777-1-zhang.yanze@zte.com.cn?part=3D7
