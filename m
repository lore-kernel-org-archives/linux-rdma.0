Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792491716;
	b=aCuVfWZKvYvn0YDlyWnxG3MWwIWSju+aYCAqunUKRu4Hvz2WEk+ByEasGihFmCeZAl+4
	 RkRRt8/kArEyN8yYhKIwq13wwxtRHiS2Sy0cMMX7/ByE3kAcdoHf895uTqOfK9fH4o5Gz
	 9+lSLSpnKdqPtIGoPS84c1tf10/Vvq4mkw2tZSq4LiCvfz/nwEkDkEMpgg4EaKNwvlZUC
	 WBcVmhV+pvSzLh9RyAPKhKIbdOywIOIgwPKoF967xYnl7bVufovsUo43qgXGAZODe9zHv
	 aTW/bVD2RqFEZ1wXxKkmXmwU+zDRZr9Jr6qKgE5jhAuA/reJT8n/yx8Vj82foWS13xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792491716;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YIFvi7xKow5q2d1XbNm0iKOxka/fS+9KgNireQjtd2s=;
	b=OfJECHyLxCZcEnuNFZETo2SwKqIidJtSfJNc1rV3z9ga/+5Z0nAN6dMP7+4bQ+xmQNJ1
	 jwM0x4aSlItyFvgW5GagcS6OjGUrzkWY3RHtggU9X7lDAe8yoW9Yg9DIu29Jmv4P4SOG7
	 A23TaIwdL8gwqzHcypL+l7yqavBxqjnmI/PR/q90Kz49PQ+/Qc/AVHOrxA6X0wWaeGg+i
	 Q9+yLF/SJATxSdCksTA7cl4vI9j1ahN87z6vihASa/4elwg1K4U0n+gTK6O5nQ2rs3Yv+
	 vWXMewZGf1yrP15Vhpaccca6ANwVpkG0fs/GBSRVVjJSHw9rLK73oVSZiUulS9bK4lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YGHCXdVG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF3C606A32A
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 10:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YGHCXdVG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7831F000CA;
	Tue, 20 Oct 2026 10:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792491715;
	bh=YIFvi7xKow5q2d1XbNm0iKOxka/fS+9KgNireQjtd2s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YGHCXdVGJQBuI6jOseuTlo5aNM+b3g0ev75BqhhGMnmjW4VeU0AbbFFXagauVbKXJ
	 ZruLw4tDWL1P/53+wJmRlBPY6wzYbcbqSvOuoA5/eD2t2nDFnoz2AV6kGSj8p3wflD
	 1aJl6cJMoyUJMKldM1ZaUGB80Y23cOeUpAGxn9WQ/jjccSSE0xlY4n5VwlNX5CPQ6k
	 XI8cla9MCL28Sg6vL0jr6RRV/5tpUA6VdhAiQgDql9IS2oC0RWaIbPkmA73XNYAZen
	 1eLFzg1WnQbHeZV8Wa9wYOQerf4AhKBz+zra1fl4eKd8zLKmj6FUX2vdT9kUhCNpXk
	 em8W7almhIFgw==
Message-ID: <sashiko-outbox-178828@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 13/13] RDMA/core: attach a memory region to
 a queue pair
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019-uet-ib-core-v2-13-8bd654f25370@broadcom.com>
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
 <20261019-uet-ib-core-v2-13-8bd654f25370@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 10:21:54 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] RDMA/core: UAF and race releasing mr->attached_qp in ib_destro=
y_qp_user()
--

commit 42577e79697ce5d46b89cf9d6635da521b34d381
Author: Eric Davis <eric.davis@broadcom.com>

RDMA/core: attach a memory region to a queue pair

This commit adds uverbs methods and driver callbacks to attach and detach a
user memory region to a single queue pair, restricting access to that
region to the bound queue pair.

> diff --git a/drivers/infiniband/core/uverbs_std_types_mr.c b/drivers/infi=
niband/core/uverbs_std_types_mr.c
> index 1ff45556e0b21..cb33d4e665072 100644
> --- a/drivers/infiniband/core/uverbs_std_types_mr.c
> +++ b/drivers/infiniband/core/uverbs_std_types_mr.c
> @@ -42,7 +42,7 @@ static int uverbs_free_mr(struct ib_uobject *uobject,
>  {
>  	struct ib_mr *mr =3D uobject->object;
> =20
> -	/* regions derived from this one still use it */
> +	/* regions derived from this one, or the QP it is attached to, use it */
>  	if (atomic_read(&mr->usecnt))
>  		return -EBUSY;
> =20
> diff --git a/drivers/infiniband/core/uverbs_std_types_qp.c b/drivers/infi=
niband/core/uverbs_std_types_qp.c
> index 47ca994f9ac96..4593965069f19 100644
> --- a/drivers/infiniband/core/uverbs_std_types_qp.c
> +++ b/drivers/infiniband/core/uverbs_std_types_qp.c
> @@ -666,12 +666,120 @@ DECLARE_UVERBS_NAMED_METHOD(
>  			     enum ib_uverbs_qp_attach_comp_cntr_op,
>  			     UA_MANDATORY));
> =20
> +/* bind a region to the QP that will use it */
> +static int UVERBS_HANDLER(UVERBS_METHOD_QP_ATTACH_MR)(
> +	struct uverbs_attr_bundle *attrs)
> +{
> +	struct ib_qp *qp =3D
> +		uverbs_attr_get_obj(attrs, UVERBS_ATTR_QP_ATTACH_MR_QP_HANDLE);
> +	struct ib_mr *mr =3D
> +		uverbs_attr_get_obj(attrs, UVERBS_ATTR_QP_ATTACH_MR_MR_HANDLE);
> +	u64 caps =3D qp->device->attrs.device_cap_flags;
> +	u32 id;
> +	int ret;
> +
> +	if (!qp->device->ops.qp_attach_mr)
> +		return -EOPNOTSUPP;
> +
> +	if (qp->real_qp !=3D qp || qp->qp_type !=3D IB_QPT_RU)
> +		return -EINVAL;
> +
> +	if (mr->pd !=3D qp->pd || mr->type !=3D IB_MR_TYPE_USER)
> +		return -EINVAL;
> +
> +	/* the device has to implement the access class the region asks for */
> +	if (!(caps & (mr->jkey ? IB_DEVICE_MR_QP_JOB_RESTRICTED :
> +				 IB_DEVICE_MR_QP_RESTRICTED)))
> +		return -EOPNOTSUPP;
> +
> +	/* a region restricted to a job serves a QP in that job */
> +	if (mr->jkey && (!qp->jkey || qp->jkey->job !=3D mr->jkey->job))
> +		return -EINVAL;
> +
> +	/* one QP at a time */
> +	if (cmpxchg(&mr->attached_qp, NULL, qp))
> +		return -EBUSY;
> +
> +	ret =3D xa_alloc(&qp->attached_mrs, &id, mr, xa_limit_32b, GFP_KERNEL);
> +	if (ret)
> +		goto err_claim;
> +
> +	ret =3D qp->device->ops.qp_attach_mr(qp, mr);
> +	if (ret)
> +		goto err_xa;
> +
> +	/* the QP holds the region until detach or its own destroy */
> +	mr->attach_id =3D id;
> +	atomic_inc(&mr->usecnt);
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
> +	atomic_dec(&mr->usecnt);
> +
> +	return 0;
> +}

[ ... ]

> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/ve=
rbs.c
> index ca5eac4a96b3c..adcda33b04f2b 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c

[ ... ]

> @@ -2249,6 +2252,13 @@ int ib_destroy_qp_user(struct ib_qp *qp, struct ib=
_udata *udata)
>  		atomic_dec(&cc->usecnt);
>  	xa_destroy(&qp->comp_cntrs);
> =20
> +	/* the driver ended the bindings with the QP, release the regions */
> +	xa_for_each(&qp->attached_mrs, index, mr) {
> +		WRITE_ONCE(mr->attached_qp, NULL);
> +		atomic_dec(&mr->usecnt);
> +	}
> +	xa_destroy(&qp->attached_mrs);

[Severity: Critical]
Can this sequence in ib_destroy_qp_user() cause a use-after-free write to
mr->attached_qp or a race on mr->usecnt?

In ib_destroy_qp_user(), only the QP's ib_uobject is locked, and no lock is
held on the attached MRs. If one thread destroys the QP while another thread
concurrently destroys the MR via uverbs_free_mr():

CPU0                                 CPU1
ib_destroy_qp_user()                 uverbs_free_mr()
  WRITE_ONCE(mr->attached_qp, NULL);
  atomic_dec(&mr->usecnt);
                                       if (atomic_read(&mr->usecnt))
                                           return -EBUSY;
                                       ib_dereg_mr_user(mr, ...)
                                         -> dereg_mr(mr, ...)
                                         -> kfree(mr)

Because non-value-returning atomic_dec() and atomic_read() are relaxed
operations without release or acquire ordering, on weakly-ordered
architectures atomic_dec(&mr->usecnt) can be reordered before
WRITE_ONCE(mr->attached_qp, NULL) becomes visible. CPU1 can observe
atomic_read(&mr->usecnt) =3D=3D 0 and free mr before CPU0's store to
mr->attached_qp completes.

Additionally, both ib_destroy_qp_user() and
UVERBS_HANDLER(UVERBS_METHOD_QP_DETACH_MR) clear mr->attached_qp before
calling atomic_dec(&mr->usecnt), while UVERBS_METHOD_QP_ATTACH_MR and
UVERBS_METHOD_QP_DETACH_MR only hold a shared UVERBS_ACCESS_READ lock on the
MR's uobject. Once mr->attached_qp is cleared to NULL, another thread can
attach and detach the MR on a second QP via cmpxchg(&mr->attached_qp, NULL,
qp2) and then call uverbs_free_mr() or ib_uverbs_rereg_mr() before the first
thread runs atomic_dec(&mr->usecnt), causing a spurious -EBUSY or -EINVAL
failure while mr->usecnt is still elevated.

Should mr->usecnt be decremented before clearing mr->attached_qp (or with
proper ordering / exclusive uobject locking on the MR) so that mr cannot be
freed or re-attached while the prior detach or QP teardown is still touching
it?

> +
>  	ib_qp_usecnt_dec(qp);
>  	if (sec)
>  		ib_destroy_qp_security_end(sec);

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019-uet-ib-cor=
e-v2-0-8bd654f25370@broadcom.com?part=3D13
