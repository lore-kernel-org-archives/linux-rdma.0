Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55874F053F
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 11:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891976; cv=none; b=NB2fTRkvrSSydgYJED8ZIUZieCSzA1qZqRqFShng84S16IRLV/ZrAf6pyOo8ewaiXZgx2lVXxnUySuFEOwRWK3R9zJkmf25ExXu4ce6gxrnKCJDSgowlh9iVtqDqCu8rj2s5S/FNEr4QFuPAVIHsqAgHQNfdb+fWzA74QXDMcXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891976; c=relaxed/simple;
	bh=UkYfVhWeBINFBDsIQAX9EmPDaOky+PaVPamZbBa4+zI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=mBQDe+a19lpBZb85DcBvIT76hF1TDZYQ5T4wB3NddgOyRsgzCWPI36pTesKs3McS56Cmb2CUJcBpde3JH9xUK/3zJiSgEP1D6HKN2xi+G3zS/JUChTAN00Hj4u1ojxGHtVNdmY/xbUb5EdBJLZ2olwMn5uVsc0vMOZmTwY/Bq5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ImQ0CXmG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ImQ0CXmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED081F00898;
	Tue, 13 Oct 2026 11:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791891975;
	bh=jOBDtKGdL555aALxiXMIeCIopxknSkul29WEy4ro6YA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ImQ0CXmG5z7L525m1hT07F2Xt5x2ZJGH+bqmGU/ydLmvKuhX1eWmrgZDWLeuE+EDr
	 /xx/DVYTMPoJ96as8seoMLIWkZ7l2llhDxfpT/OwsA3jbcdqqWdVHYOjbI/DEv3eeS
	 2bbvLK9zLZh1MlfYnCiUasQixQBRpTRkstXpoGZjEaq6kPBJS3ZP89Vf7WDUZgd44S
	 23aUlO+VBioZgWssFFwQlk/W7ur42E+y68I7nz/vCkOI5RU0cIUU/UBc6XUt6k01Ef
	 hul5XshZJKHpG2iq5gUiSaWLO+UXk1qv3PwtRj0k1uheH7KC0DW68Ddk3fACgYdt7C
	 X4DIN9sq0dOiA==
Message-ID: <sashiko-outbox-169652@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 14/15] yunsilicon: add RDMA counters and sysfs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261012114425.2471317-15-tianx@yunsilicon.com>
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
 <20261012114425.2471317-15-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 11:46:15 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] sysfs: kobject UAF via missing .release and synchronous kfree
- [High] sysfs: global singleton g_global_cnt_interface corrupts multi-devi=
ce state
- [Medium] sysfs: counters_value_read breaks partial reads and ignores offs=
et
- [Medium] infiniband: sysfs attribute creation races with udev KOBJ_ADD
--

commit e407716ecbb78f776fbe73fcb02888c7ab5c00c8
Author: Xin Tian <tianx@yunsilicon.com>

yunsilicon: add RDMA counters and sysfs

This commit adds hardware counter reporting through the RDMA counter
interface, global counter sysfs attributes, and hca_type/hw_rev sysfs
attributes.

> diff --git a/drivers/infiniband/hw/xsc/counters.c b/drivers/infiniband/hw=
/xsc/counters.c
> new file mode 100644
> index 0000000000000..135df95954a75
> --- /dev/null
> +++ b/drivers/infiniband/hw/xsc/counters.c
[ ... ]
> +static ssize_t counters_value_read(struct file *file, struct kobject *ko=
b,
> +				   const struct bin_attribute *bin_attr,
> +				   char *buf, loff_t loff, size_t size)
> +{
[ ... ]
> +	if (bin_attr->size > size || bin_attr->size =3D=3D 0)
> +		return 0;

[Severity: Medium]
Does this check incorrectly reject partial or offset-bounded reads?=20

Since the sysfs core bounds the requested size to max_size - loff, a read
with a non-zero offset or a user buffer smaller than bin_attr->size might
immediately fail with an early EOF here.

[ ... ]
> +	mask =3D xsc_get_rdma_stat_mask(xdev, be16_to_cpu(stats_rdma.ver));
> +	j =3D 0;
> +	for (i =3D 0; i < desc_size; i++) {
> +		if (!((1ULL << i) & mask))
> +			continue;
> +		tmp_value[j] =3D be64_to_cpu(*(u64 *)(stats + desc[i].offset));
> +		j++;
> +	}
> +
> +	memcpy(buf, tmp_value, bin_attr->size);
> +
> +	kfree(tmp_value);
> +	return bin_attr->size;
> +}

[Severity: Medium]
Could this ignore the requested offset during a read?

The loff parameter is not used in the memcpy() call, so if a read succeeded
at a non-zero offset, it would incorrectly copy from the beginning of
tmp_value instead of applying the requested offset.

[ ... ]
> +static const struct kobj_type global_cnt_ktype =3D {
> +	.sysfs_ops     =3D &global_cnt_sysfs_ops,
> +	.default_groups =3D global_cnt_groups,
> +};

[Severity: High]
Is this kobj_type missing the mandatory .release callback required for
kobjects?=20

Without it, the kobject container memory cannot be safely managed when the
reference count reaches zero.

> +
> +static struct xsc_global_cnt_interface *g_global_cnt_interface;
> +
> +static int global_cnt_sysfs_init(struct ib_device *ib_dev, struct xsc_co=
re_device *xdev)
> +{
[ ... ]
> +	err =3D kobject_init_and_add(&tmp->kobj, &global_cnt_ktype,
> +				   &ib_dev->dev.kobj, GLOBAL_COUNTERS_GROUP_NAME);
> +	if (err)
> +		goto error_return;
> +
> +	g_global_cnt_interface =3D tmp;
> +	tmp->xdev =3D xdev;
> +	return 0;

[Severity: High]
Does this blindly overwrite the global pointer g_global_cnt_interface for
every initialized physical function?

If the system contains multiple Yunsilicon network adapters, initializing t=
he
second one would overwrite the pointer. This would lose the previous device=
's
state and permanently leak its memory and kobject. Furthermore, removing the
first device would cause global_cnt_sysfs_fini() to mistakenly operate on t=
he
second device's state.

[ ... ]
> +static void global_cnt_sysfs_fini(struct xsc_core_device *xdev)
> +{
> +	if (!g_global_cnt_interface || !xdev || !xsc_core_is_pf(xdev) || xdev->=
pf_id !=3D 0)
> +		return;
> +
> +	kobject_put(&g_global_cnt_interface->kobj);
> +	kfree(g_global_cnt_interface);
> +	g_global_cnt_interface =3D NULL;
> +}

[Severity: High]
Is it safe to synchronously free the kobject container memory here?

Since kobject_put() merely decrements the reference count, the kobject and
its sysfs representation could remain active if userspace still holds an
open file descriptor. Calling kfree() immediately afterwards destroys the
underlying memory prematurely, which might lead to a use-after-free crash
when userspace subsequently accesses the sysfs files.

> diff --git a/drivers/infiniband/hw/xsc/main.c b/drivers/infiniband/hw/xsc=
/main.c
> index 30927006bae2d..38c8b4f0690c2 100644
> --- a/drivers/infiniband/hw/xsc/main.c
> +++ b/drivers/infiniband/hw/xsc/main.c
[ ... ]
> @@ -745,7 +745,9 @@ static int init_one(struct xsc_core_device *xdev,
> =20
>  	xsc_register_netdev_notifier(dev);
> =20
> +	xsc_counters_init(&dev->ib_dev, xdev);
> =20
> +	xsc_ib_sysfs_init(&dev->ib_dev, xdev);
> =20
>  	return 0;

[Severity: Medium]
Does creating the sysfs attribute files here cause a race condition with
udev?

The driver registers the device earlier in init_one() by calling
ib_register_device(), which triggers a KOBJ_ADD uevent. Adding the sysfs
files after this registration means udev rules might execute before the
attributes actually exist. Should the sysfs groups be assigned to the
device's attribute groups (e.g., ib_dev->groups) prior to registration
instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012114352.2471=
317-1-tianx@yunsilicon.com?part=3D14
