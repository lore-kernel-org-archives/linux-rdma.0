Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792486800;
	b=sno9mmIxLrKdczqMiTEy5CQqBPr+dHGnLiY7W98gSBb5WKC0NlNEoWi2l8Q5ajl7vlf/
	 3DLkUMwFn3sIsIIcgLsEEQrOUnPt2cBDBRKzWbL7uGsX3HRSVHYkp8Trsjr0eG9QphHCf
	 pn2DOYgs1AmdfzGh7iCJFnuH2zn4GHpXaD11Bm4fcNRwqF67ALt/SgUPsllf7OGuwe50a
	 c1NDkURpPuLK9waTfweq5aA0Rt8/fy4yFjiZOEqEDpXqNZ+YVFeswYAniBV6OV17mcHXs
	 v5/l0N7ym0mTBxJuAaJ68VH1DOaYCQE57dlLHTVaxxcgdeWAdZJieldmAVf6nYydOPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792486800;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=RdX2TPB9njZFG29KKMgC6emNkD0HlXhlSNL8SsR9NEA=;
	b=2r7VsOFDW7BxZ7xn70DoUFViDvBSA0Xe99GPEywtwbiXExPWiaDDivedBCMC629MieRw
	 EFpirxHQppaF8JLxI6t82bltjELgxgjDAU7HEYQDbWadN0rnLiadrCi0vzXo+FGOkb8f1
	 Bg9uy+ADe4yWfimCOC6rHTYNHYP2M5Ac+FY3bu4E4bpd8FBFiNq0+1946UrIZeMk/0haR
	 dsQhXDP5OTaVt639xHUM2wUw0H3WHajPR7zmRaSlx6qzuyuJ0LGOllRsw782qd4kbnxt7
	 cN5i5eVej1j3ZamPhW2WfNLo6VnPq06hovJ71iaOt/Mvyd0mU+QRUBmM1aiDJH1DRPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B3L4ZWrS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65A5606A31A
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 08:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B3L4ZWrS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6397E1F000C5;
	Tue, 20 Oct 2026 08:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792486799;
	bh=RdX2TPB9njZFG29KKMgC6emNkD0HlXhlSNL8SsR9NEA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B3L4ZWrSp5o9eHncbrERIdTx4WZ260DMDkl4/pwjQIhnbcW2zSYaJ/p7K0pA56hIh
	 4ew5I/kbgGB9GdaC7pOF61x6Wvc8+BpgJJliyCC5DCzM6uezToOb9Jp3L3sP20CQaP
	 fnPXHYkjKkr7w9fht7/XW3NlEvcMfwLefsknsmiBPkwf151bYeLm8wB9YaCndplZ45
	 Tsf7jw9ZoRZajswsX+oPnSJh+CWGwfQvC+lw4gcXCRXh+Qou3/Cngx4YFCnPYibB6n
	 ifU3CyWJg+O//wGhIoQlFhdP9W0qo2Iu4I+5To0Lc7Qh8iJWWhHve5alee1wL/SxQt
	 0gxeS/0pAZoQA==
Message-ID: <sashiko-outbox-178673@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 07/13] RDMA/core: job and job key objects
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019-uet-ib-core-v2-7-8bd654f25370@broadcom.com>
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
 <20261019-uet-ib-core-v2-7-8bd654f25370@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 08:59:58 +0000
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
- [High] RDMA/uverbs: missing uverbs_finalize_uobj_create() in job alloc an=
d import
--

commit 5f0d9f9de261cb667b880d34e0c2d952d5a61944
Author: Eric Davis <eric.davis@broadcom.com>

RDMA/core: job and job key objects

This commit introduces job and job key objects to RDMA core to support
unconnected transports that demultiplex incoming traffic on a JobID. It
also allows jobs to be exported to a file descriptor and imported into
another context.

> diff --git a/drivers/infiniband/core/uverbs_std_types_job.c b/drivers/inf=
iniband/core/uverbs_std_types_job.c
> new file mode 100644
> index 0000000000000..20acb2aa9871f
> --- /dev/null
> +++ b/drivers/infiniband/core/uverbs_std_types_job.c

[ ... ]

> +static int UVERBS_HANDLER(UVERBS_METHOD_JOB_IMPORT)(
> +	struct uverbs_attr_bundle *attrs)
> +{
> +	struct ib_uobject *uobj =3D
> +		uverbs_attr_get_uobject(attrs, UVERBS_ATTR_IMPORT_JOB_HANDLE);
> +	struct ib_device *ib_dev =3D attrs->context->device;
> +	struct ib_job *job;
> +	int fd, ret;
> +
> +	ret =3D uverbs_get_raw_fd(&fd, attrs, UVERBS_ATTR_IMPORT_JOB_FD);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D ib_job_get_from_fd(fd, ib_dev, &job);
> +	if (ret)
> +		return ret;
> +
> +	uobj->object =3D job;
> +
> +	return 0;
> +}
> +
> +static int uverbs_free_job(struct ib_uobject *uobject,
> +			   enum rdma_remove_reason why,
> +			   struct uverbs_attr_bundle *attrs)
> +{
> +	struct ib_ujob_object *ujob =3D
> +		container_of(uobject, struct ib_ujob_object, uobject);
> +	struct ib_job *job =3D uobject->object;
> +
> +	/* don't free if there are still references to this job */
> +	if (atomic_read(&ujob->refcnt))
> +		return -EBUSY;
> +
> +	kref_put(&job->ref, ib_job_release);
> +
> +	return 0;
> +}
> +
> +static int UVERBS_HANDLER(UVERBS_METHOD_JOB_ALLOC)(
> +	struct uverbs_attr_bundle *attrs)
> +{
> +	struct ib_uobject *uobj =3D
> +		uverbs_attr_get_uobject(attrs, UVERBS_ATTR_ALLOC_JOB_HANDLE);
> +	struct ib_device *ib_dev =3D attrs->context->device;
> +	struct ib_job_attr attr =3D {};
> +	struct ib_job *job;
> +	int ret;

[ ... ]

> +	job =3D rdma_zalloc_drv_obj(ib_dev, ib_job);
> +	if (!job)
> +		return -ENOMEM;
> +
> +	job->device =3D ib_dev;
> +	job->job_id =3D attr.job_id;
> +	job->max_addr_entries =3D attr.max_addr_entries;
> +	kref_init(&job->ref);
> +	uobj->object =3D job;
> +
> +	rdma_restrack_new(&job->res, RDMA_RESTRACK_JOB);
> +	rdma_restrack_set_name(&job->res, NULL);
> +
> +	ret =3D ib_dev->ops.alloc_job(job, &attr, attrs);
> +	if (ret)
> +		goto err_free;
> +
> +	rdma_restrack_add(&job->res);
> +
> +	return 0;

[Severity: High]
Should UVERBS_HANDLER(UVERBS_METHOD_JOB_ALLOC) and
UVERBS_HANDLER(UVERBS_METHOD_JOB_IMPORT) call uverbs_finalize_uobj_create()
before returning 0?

UVERBS_METHOD_JOB_ALLOC declares UVERBS_ATTR_UHW(), which sets
bundle->method_elm->has_udata =3D true. After the handler returns 0,
ib_uverbs_run_method() updates UVERBS_ATTR_UHW_OUT when present:

drivers/infiniband/core/uverbs_ioctl.c:ib_uverbs_run_method() {
	...
	ret =3D handler(&pbundle->bundle);
	if (!ret && bundle->method_elm->has_udata) {
		const struct uverbs_attr *attr =3D
			uverbs_attr_get(bundle, UVERBS_ATTR_UHW_OUT);

		if (!IS_ERR(attr))
			ret =3D uverbs_set_output(bundle, attr);
	}
	...
}

If uverbs_set_output() fails with -EFAULT when writing to user_attrs,
ib_uverbs_cmd_verbs() calls bundle_destroy(pbundle, false). Because
uverbs_finalize_uobj_create() was not called to mark uobj_hw_obj_valid,
uverbs_finalize_object() passes hw_obj_valid =3D false to
rdma_alloc_abort_uobject():

drivers/infiniband/core/rdma_core.c:rdma_alloc_abort_uobject() {
	...
	if (hw_obj_valid) {
		uverbs_get_cleared_udata(attrs);
		ret =3D uobj->uapi_object->type_class->destroy_hw(
			uobj, RDMA_REMOVE_ABORT, attrs);
	...
}

Without hw_obj_valid set, destroy_hw (uverbs_free_job()) is skipped on the
abort path. Does this leak the struct ib_job allocation, the driver job
resource from alloc_job(), and leave job->res in the RDMA_RESTRACK_JOB
table?

[ ... ]

> +DECLARE_UVERBS_NAMED_METHOD(
> +	UVERBS_METHOD_JOB_ALLOC,
> +	UVERBS_ATTR_IDR(UVERBS_ATTR_ALLOC_JOB_HANDLE,
> +			UVERBS_OBJECT_JOB,
> +			UVERBS_ACCESS_NEW,
> +			UA_MANDATORY),
> +	UVERBS_ATTR_PTR_IN(UVERBS_ATTR_ALLOC_JOB_ID,
> +			   UVERBS_ATTR_TYPE(u32),
> +			   UA_MANDATORY),
> +	UVERBS_ATTR_PTR_IN(UVERBS_ATTR_ALLOC_JOB_MAX_ADDR_ENTRIES,
> +			   UVERBS_ATTR_TYPE(u32),
> +			   UA_MANDATORY),
> +	UVERBS_ATTR_PTR_IN(UVERBS_ATTR_ALLOC_JOB_PORT_NUM,
> +			   UVERBS_ATTR_TYPE(u32),
> +			   UA_OPTIONAL),
> +	UVERBS_ATTR_PTR_IN(UVERBS_ATTR_ALLOC_JOB_SGID_INDEX,
> +			   UVERBS_ATTR_TYPE(u8),
> +			   UA_OPTIONAL),
> +	UVERBS_ATTR_UHW());

[ ... ]

=E5=AE=8C=E7=BE=8E=E7=BB=93=E6=9D=9F=EF=BC=8C=E7=A1=AE=E4=BF=9D=E6=9C=80=E5=
=90=8E=E6=9C=89=E4=B8=80=E4=B8=AA=E7=A9=BA=E8=A1=8C=E3=80=82

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019-uet-ib-cor=
e-v2-0-8bd654f25370@broadcom.com?part=3D7
