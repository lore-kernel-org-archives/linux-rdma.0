Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794291620;
	b=gAjc9+RD0sATPLrxf4XkIt9BhVbQ5n/8iwDDpQ3fQnNj4EGC95cnAUW4T8vpPZ6DTBu2
	 vvETP4NOkmKAgzVkPDWFNrYnPcliwZTxDcoHgvzhCdqlPRrtihV3iO+GfbMvDKb4g9lbq
	 bYYDo6K2HKlHcmi3lnArXT8uHLID5a/S9jJAxo7iC2C1rxiaIeNdPr+27gIjC9mkfjDnG
	 XrkmmRgko368oHzu5ucV4/Gb9Vel4LnB9X81dgVsB9KCfVPluIgW8RKYMdkw+5nrPxEBB
	 3gwqMcighGLg1+UqYusbP7m+xZ2NE/qaXqrqaLWl/iaq/bPlGXTIFdQkjRvBkFB4rbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794291620;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1jHeUvmhQkwpsrPq3YNhVfrg5B1iUrRRQamjQsgih3I=;
	b=dHVmkGQKbN2uzjf3VU/3ewP72EAvtViwyFDxNAdsUYozrzy4H7wXJqqQZyXF0ITxYfpO
	 AAQE/NuURhUpAMIlxtlAUf/xOI5Y0W/3Y4POPPD+677fpUTWGajzBt9juX4DRa6/sFIAI
	 mrNaljJXZeb3IzhtkgNGlQFjujQN1J6OLPK3koalzX1Ejh0j0oSiIYdmFt2lOxSWfRckc
	 UipLcvGz3KbeMxomz90ypCh4KBFKGFGz2w8fbSk6dIX+3ZaJWr2ouMtXc1xziMhf+kTq1
	 FVn7wmS/osMjk5VKX8VukrRzqlUyHmBr4nyIG9yDUbyx6VKC3TI0weD/+mOSo9ZXnpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H1g1Bs7n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C4C606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 06:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H1g1Bs7n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E0E1F0089F;
	Tue, 10 Nov 2026 06:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794291619;
	bh=1jHeUvmhQkwpsrPq3YNhVfrg5B1iUrRRQamjQsgih3I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H1g1Bs7nswo0FEeFetkOcjswR+u0i5KzCGf0o/+EB3U0NKjGTt3oYxymxownZORMx
	 +mQC4rogY3Isbc33t3mR4RSjJtjyclDd3xB3AdB6jZFy2ICSnr4OcofJ1Z+6dVbCZw
	 zpwYclPr/UEJh3PBoHrwbU6TP4Q+i3Rd86uTqPFj1hEqMsgEnef+Mx+N44VxoT8XmU
	 CSc/iuf66kt5QzH3N6oEamiJN+RhmCyMTZ/lqr4X4uzGAzd0OUpWegyT4UtM0Wh1Oo
	 zPDtt2YkpZcDMmJtqKYWTkMHkr+o1fHSU3bzEOJom9rD6+hJEIeKDqV6yN9/3gGqtC
	 4kkaJEiutUyNw==
Message-ID: <sashiko-outbox-206403@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 13/13] RDMA/core: attach a memory region to
 a queue pair
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109-uet-ib-core-v3-13-3e7e7ffed2e9@broadcom.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261109-uet-ib-core-v3-13-3e7e7ffed2e9@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 06:20:18 +0000
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
- [Medium] RDMA/core: mr->usecnt release ordering race in QP_DETACH_MR
  and destroy_qp
--

commit beeb942760f9f2e71c333c8b383858123a5c467f
Author: Eric Davis <eric.davis@broadcom.com>

RDMA/core: attach a memory region to a queue pair

This commit adds uverbs methods and driver callbacks to attach a user
memory region to a single RU queue pair and detach it again.

> diff --git a/drivers/infiniband/core/uverbs_std_types_qp.c b/drivers/infi=
niband/core/uverbs_std_types_qp.c
> index a1112083fb73f..88a6050d1d046 100644
> --- a/drivers/infiniband/core/uverbs_std_types_qp.c
> +++ b/drivers/infiniband/core/uverbs_std_types_qp.c
> @@ -683,12 +683,126 @@ DECLARE_UVERBS_NAMED_METHOD(
>  			     enum ib_uverbs_qp_attach_comp_cntr_op,
>  			     UA_MANDATORY));
> =20
> +/* bind a region to the QP that will use it */
> +static int UVERBS_HANDLER(UVERBS_METHOD_QP_ATTACH_MR)(
> +	struct uverbs_attr_bundle *attrs)
> +{
[ ... ]
> +	/* the QP holds the region until detach or its own destroy */
> +	mr->attach_id =3D id;
> +	atomic_inc(&mr->usecnt);
> +	/* the MR's read lock drops with a relaxed atomic, order the hold
> +	 * before it so a dereg that gets in next sees the region in use
> +	 */
> +	smp_mb__after_atomic();
> +
> +	return 0;
> +
> +err_xa:
> +	xa_erase(&qp->attached_mrs, id);
> +err_claim:
> +	WRITE_ONCE(mr->attached_qp, NULL);
> +	return ret;
> +}
> +
> +static int UVERBS_HANDLER(UVERBS_METHOD_QP_DETACH_MR)(
> +	struct uverbs_attr_bundle *attrs)
> +{
> +	struct ib_qp *qp =3D
> +		uverbs_attr_get_obj(attrs, UVERBS_ATTR_QP_DETACH_MR_QP_HANDLE);
> +	struct ib_mr *mr =3D
> +		uverbs_attr_get_obj(attrs, UVERBS_ATTR_QP_DETACH_MR_MR_HANDLE);
> +	int ret;
> +
> +	if (!qp->device->ops.qp_detach_mr)
> +		return -EOPNOTSUPP;
> +
> +	if (qp->real_qp !=3D qp)
> +		return -EINVAL;
> +
> +	if (READ_ONCE(mr->attached_qp) !=3D qp)
> +		return -EINVAL;
> +
> +	ret =3D qp->device->ops.qp_detach_mr(qp, mr);
> +	if (ret)
> +		return ret;
> +
> +	xa_erase(&qp->attached_mrs, mr->attach_id);
> +	WRITE_ONCE(mr->attached_qp, NULL);
> +	/* once usecnt reads zero the MR can be freed under us */
> +	smp_mb__before_atomic();
> +	atomic_dec(&mr->usecnt);
> +
> +	return 0;
> +}

[Severity: Medium]
Can uverbs_free_mr() observe a stale non-zero mr->usecnt after
UVERBS_METHOD_QP_DETACH_MR or ib_destroy_qp_user() detaches the region and
spuriously fail with -EBUSY?

When UVERBS_METHOD_QP_DETACH_MR finishes, rdma_lookup_put_uobject() drops
UVERBS_LOOKUP_READ on the MR with a relaxed atomic_dec(&uobj->usecnt).
Because UVERBS_METHOD_QP_DETACH_MR places smp_mb__before_atomic() before
atomic_dec(&mr->usecnt) instead of smp_mb__after_atomic() after it, the
two relaxed atomic_dec() calls can be reordered on weakly-ordered
architectures:

CPU0                                  CPU1
UVERBS_METHOD_QP_DETACH_MR
  WRITE_ONCE(mr->attached_qp, NULL)
  smp_mb__before_atomic()
  [atomic_dec(&mr->usecnt) delayed]
  rdma_lookup_put_uobject(mr_uobj)
    atomic_dec(&uobj->usecnt)
                                      uverbs_free_mr()
                                        rdma_lookup_get_uobject()
                                          atomic_cmpxchg(&uobj->usecnt, 0, =
-1)
                                        atomic_read(&mr->usecnt) -> 1
                                        return -EBUSY;  <-- spurious -EBUSY
  atomic_dec(&mr->usecnt)

In addition, both UVERBS_METHOD_QP_DETACH_MR and ib_destroy_qp_user()
clear mr->attached_qp before decrementing mr->usecnt.  Once
mr->attached_qp is NULL, another thread can attach the MR to a second QP
(which only takes UVERBS_ACCESS_READ on the MR), detach it, and call
uverbs_free_mr() before the first thread runs atomic_dec(&mr->usecnt),
again seeing mr->usecnt =3D=3D 1 and failing with -EBUSY.

Decrementing mr->usecnt with atomic_dec_return_release() before
smp_store_release(&mr->attached_qp, NULL) in both detach paths, paired
with smp_mb__after_atomic() in UVERBS_METHOD_QP_DETACH_MR, would close
both windows.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-uet-ib-cor=
e-v3-0-3e7e7ffed2e9@broadcom.com?part=3D13
