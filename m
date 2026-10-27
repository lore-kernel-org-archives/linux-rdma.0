Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793141780;
	b=a2BCBuCmIlPVo0VVaqfka0fShjjL1yMpf04M54mG8MI/ts1XCHwSDTjbhqCN+jSqZfbD
	 +DoN3Xrcdn1HltRoArX6kzH598FTmTeSm9FS9I7d9FwqIMlBIPFtitPPYpsHOAeNCz+ye
	 A0xJ8aGMEzA5MRXZ+U0y+QTkCcGkWHXHN/zpulSDQGmkleMa/LLIl84Ifu7H9CNfm1Ko3
	 Ds0FxEUqv5ryD7zsxnDoWT2+bU7ox8JA2TSiweK6gSuLePzrczDfnglVE/6A5FqzoiOsc
	 Vv2k+HWCtOk90coGMw6N0ciK6izjfBvPhtqAR9XM1v/OXsvWjuhZuNz7ACA7UF6/lzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793141780;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=PGIVzh2vRG3PPdwb4MSHQ9cli0w5dxMbX/Iatj0t//Q=;
	b=R+dB8y6tbOlQ5hrIvW6UXGJTG2htH/zVk1i8X3jORtgsg7y0gZyRMkl2xt9MjyL6W3uU
	 /oayu61Rx7MXC7Vw2N8umA4V/jOfStGWO9rMSL6W1JLrCSm9XLLFBrPDMJtqEhBqVgZV+
	 xU4BeypppPIjJOim4VW8GBohVpVb1v+Lw/euFYXzdN6Qbo5dgrdCeRgMNUZ5XksW0m/pV
	 ZGdJtLAFYC5w2/YcypLB5Lis7MPQ3fw/G2WfoGHSMVXE5C7n1RD64xAWqIhtxXql7xM3q
	 jrZFP5xePKrPV5B3G1huI6gv0edQbYTb5p0QVxbA1e3lyv2rIqQ39iMY6kbG4x5rovw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n0o9bM6M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B495606A31A;
	Tue, 27 Oct 2026 22:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n0o9bM6M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A4D1F01825;
	Tue, 27 Oct 2026 22:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793141779;
	bh=PGIVzh2vRG3PPdwb4MSHQ9cli0w5dxMbX/Iatj0t//Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n0o9bM6MejvHAu2M8cKnApFDeCr2pztgVJxcJ/U/dYUzh92/xwspw74DYEdN6lYep
	 +qdRFfx5AU7lmjuWZ129Fvk2AY0ZXG8WiqNXsGrHHgrwmueDNBifSXHdFzyF74bb8+
	 qgtQtXflCYHfZePgXewrsALMQeWz+mIHd3tufJqtp0SR+uqiaW8X70UadF6vsouu1g
	 C0g9p35bk5DF3wbGpLPy2ZzcgD319ZnaYjFA2H/KzAd8wn6cignLz0T0oMsbxfUQa+
	 KD3DlYfzkrRHjGgUA+c2jE7IbK9I+1kaW/P0okr7V2WH5q2tR81v2keIq4H2UDJeGQ
	 UZAoUOmFMMq7g==
Message-ID: <sashiko-outbox-187180@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 9/9] kobject: Require explicit initialization of
 struct kobj_type::release
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ian Rogers" <irogers@google.com>, "Kees Cook" <kees@kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Miguel Ojeda" <ojeda@kernel.org>, "Rafael
 J . Wysocki" <rafael@kernel.org>, "Danilo Krummrich" <dakr@kernel.org>
Cc: "Nathan Chancellor" <nathan@kernel.org>, "Nick Desaulniers" <ndesaulniers@google.com>, "Miguel
 Ojeda" <miguel.ojeda.sandonis@gmail.com>, =?utf-8?b?Q2hyaXN0aWFuIEvDtm5p?=
 =?utf-8?b?Zw==?= <christian.koenig@amd.com>, "Zhihao Cheng" <chengzhihao1@huawei.com>, "Zhongqiu
 Han" <zhongqiu.han@oss.qualcomm.com>, "Sumanth Korikkar" <sumanthk@linux.ibm.com>, "Bill
 Wendling" <morbo@google.com>, "Justin Stitt" <justinstitt@google.com>, linux-s390@vger.kernel.org, linux-mtd@lists.infradead.org, dri-devel@lists.freedesktop.org, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>, "Mark
 Rutland" <mark.rutland@arm.com>, "Len Brown" <lenb@kernel.org>, "Vinod Koul" <vkoul@kernel.org>, "Frank
 Li" <Frank.Li@kernel.org>, "Alex Deucher" <alexander.deucher@amd.com>, "David
 Airlie" <airlied@gmail.com>, "Simona Vetter" <simona@ffwll.ch>, "Dennis
 Dalessandro" <dennis.dalessandro@cornelisnetworks.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Leon
 Romanovsky" <leon@kernel.org>, "Nelson Escobar" <neescoba@cisco.com>, "Satish
 Kharat" <satishkh@cisco.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Helge
 Deller" <deller@gmx.de>, "Linus Walleij" <linusw@kernel.org>, "Sebastian
 Reichel" <sre@kernel.org>, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Sven Schnelle" <svens@linux.ibm.com>, "Huisong
 Li" <lihuisong@huawei.com>, "Gao Xiang" <xiang@kernel.org>, "Chao Yu" <chao@kernel.org>, "Yue
 Hu" <zbestahu@gmail.com>, "Jingbo Xu" <jefflexu@163.com>, "Sandeep Dhavale" <dhavale@google.com>, "Hongbo
 Li" <hongbohbli@tencent.com>, "Chunhai Guo" <guochunhai@vivo.com>, "Jaegeuk
 Kim" <jaegeuk@kernel.org>, "Mark Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph
 Qi" <joseph.qi@linux.alibaba.com>, "Heming Zhao" <heming.zhao@suse.com>, "Johan
 Hovold" <johan@kernel.org>, dmaengine@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261027223847.652884-10-irogers@google.com>
References: <20261027223847.652884-1-irogers@google.com>
 <20261027223847.652884-10-irogers@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 22:56:16 +0000
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
- [Low] fbdev: omapdss: inaccurate kobj_type comments for managers and over=
lays
- [Low] kobject: inaccurate kobj_type comments on static lifetime and delay=
ed release
--

commit 2811dd0d4494f584b7b3fad73d8e6b9f2f067c96
Author: Ian Rogers <irogers@google.com>

kobject: Require explicit initialization of struct kobj_type::release

This commit annotates struct kobj_type::release with __must_init so the
compiler diagnoses any struct kobj_type initializer that omits .release. For
remaining legacy struct kobj_type definitions that do not free their kobject
via kobject_put(), it explicitly initializes .release =3D NULL with comments
documenting the kobject lifetime and CONFIG_DEBUG_KOBJECT_RELEASE behavior.

Link: https://lpc.events/event/20/contributions/2392/

>     kobject: Require explicit initialization of struct kobj_type::release
>    =20
>     Documentation/core-api/kobject.rst states:
>    =20
>       "One important point cannot be overstated: every kobject must have a
>       release() method, and the kobject must persist (in a consistent sta=
te)
>       until that method is called. If these constraints are not met, the =
code
>       is flawed. Note that the kernel will warn you if you forget to prov=
ide
>       a release() method. Do not try to get rid of this warning by provid=
ing
>       an \"empty\" release function."
>    =20
>     Annotate struct kobj_type::release with __must_init
>     so the compiler diagnoses any struct kobj_type initializer that omits
>     .release.
>    =20
>     For the remaining legacy struct kobj_type definitions where the kobje=
ct
>     is static, per-CPU, permanent firmware structures, or embedded inside=
 a
>     devm- or parent-managed structure rather than freed by kobject_put(),
>     explicitly initialize .release =3D NULL with a comment documenting wh=
y no
>     release callback is provided.
>    =20
>     Where the existing teardown is not safe with CONFIG_DEBUG_KOBJECT_REL=
EASE,
>     because the kobject's memory can be freed or cleared while the delayed
>     kobject cleanup is still pending (ioat, kunpeng_hccs and omapfb displ=
ay),
>     the comment says so. Fixing those is left to follow-up patches; this
>     change does not alter their behavior.
>    =20
>     Link: https://lpc.events/event/20/contributions/2392/
>     Signed-off-by: Ian Rogers <irogers@google.com>

[Severity: Low]
The commit message notes that where existing teardown is not safe with
CONFIG_DEBUG_KOBJECT_RELEASE (listing ioat, kunpeng_hccs, and omapfb
display), the comment says so.

Are there additional kobj_type definitions touched in this patch where the
backing memory is freed, zeroed, or unmapped while delayed kobject cleanup =
is
still pending under CONFIG_DEBUG_KOBJECT_RELEASE, such as omapfb manager_kt=
ype
and overlay_ktype, amdgpu ualink_xcp_info_ktype and xcp_sysfs_ktype, hfi1
sde_ktype, usnic usnic_ib_qpn_type, ab8500_fg_ktype (on the
kobject_init_and_add() error path in ab8500_fg_sysfs_init() before devm fre=
es
di), and the static kobjects/ksets in loadable modules (erofs, f2fs, ocfs2,
and pdc_stable on module unload)?

> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ualink.c b/drivers/gpu/drm=
/amd/amdgpu/amdgpu_ualink.c
> index 17888cf544472..c2cccd924b03c 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ualink.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ualink.c
> @@ -885,6 +885,11 @@ static const struct attribute_group ualink_xcp_info_=
group =3D {
>  };
> =20
>  static const struct kobj_type ualink_xcp_info_ktype =3D {
> +	/*
> +	 * Pre-existing: xcp->ualink.kobj is embedded in struct amdgpu_xcp_mgr
> +	 * rather than freed individually by kobject_put().
> +	 */
> +	.release =3D NULL,
>  	.sysfs_ops =3D &kobj_sysfs_ops
>  };
> =20
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c b/drivers/gpu/drm/am=
d/amdgpu/amdgpu_xcp.c
> index ab14079d1c422..0847134a13917 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c

[ ... ]

> @@ -1061,6 +1066,11 @@ static const struct attribute_group amdgpu_xcp_att=
rs_group =3D {
>  };
> =20
>  static const struct kobj_type xcp_sysfs_ktype =3D {
> +	/*
> +	 * Pre-existing: xcp is embedded in struct amdgpu_xcp_mgr
> +	 * rather than freed individually by kobject_put().
> +	 */
> +	.release =3D NULL,
>  	.sysfs_ops =3D &kobj_sysfs_ops,
>  };

[Severity: Low]
Should the comments on ualink_xcp_info_ktype and xcp_sysfs_ktype also note =
the
CONFIG_DEBUG_KOBJECT_RELEASE use-after-free hazard?

During teardown, amdgpu_device_fini_hw() calls amdgpu_ualink_sysfs_fini() a=
nd
amdgpu_xcp_sysfs_fini(), which call kobject_put(&xcp->ualink.kobj) and
kobject_put(&xcp->kobj), and then amdgpu_device_fini_sw() frees adev->xcp_m=
gr
while delayed kobject cleanup may still be pending.

> diff --git a/drivers/infiniband/hw/hfi1/sysfs.c b/drivers/infiniband/hw/h=
fi1/sysfs.c
> index 372cfd13dc616..5a1aca06b542b 100644
> --- a/drivers/infiniband/hw/hfi1/sysfs.c
> +++ b/drivers/infiniband/hw/hfi1/sysfs.c
> @@ -608,6 +608,11 @@ static const struct sysfs_ops sde_sysfs_ops =3D {
>  };
> =20
>  static struct kobj_type sde_ktype =3D {
> +	/*
> +	 * Pre-existing: sdma_engine is embedded in dd->per_sdma array
> +	 * rather than freed by kobject_put().
> +	 */
> +	.release =3D NULL,
>  	.sysfs_ops =3D &sde_sysfs_ops,
>  };

[Severity: Low]
Does sde_ktype also have the same CONFIG_DEBUG_KOBJECT_RELEASE use-after-fr=
ee
issue worth noting in this comment?

In the device removal path, hfi1_verbs_unregister_sysfs() calls
kobject_put(&dd->per_sdma[i].kobj) right before remove_one() ->
hfi1_free_devdata() -> sdma_clean() calls kfree(dd->per_sdma).

> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c b/drivers/infin=
iband/hw/usnic/usnic_ib_sysfs.c
> index fdb63a8fb9974..df0e48070c2ee 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
> @@ -245,6 +245,8 @@ static struct attribute *usnic_ib_qpn_default_attrs[]=
 =3D {
>  ATTRIBUTE_GROUPS(usnic_ib_qpn_default);
> =20
>  static struct kobj_type usnic_ib_qpn_type =3D {
> +	/* Pre-existing: usnic_ib_qp_grp is embedded in RDMA core-managed struc=
t usnic_ib_qp_grp. */
> +	.release =3D NULL,
>  	.sysfs_ops =3D &usnic_ib_qpn_sysfs_ops,
>  	.default_groups =3D usnic_ib_qpn_default_groups,
>  };

[Severity: Low]
Should this comment on usnic_ib_qpn_type also mention
CONFIG_DEBUG_KOBJECT_RELEASE?

When destroying a QP, ib_destroy_qp_user() calls usnic_ib_destroy_qp() ->
usnic_ib_sysfs_qpn_remove(), which calls kobject_put(&qp_grp->kobj)
immediately before the RDMA core frees the struct usnic_ib_qp_grp allocatio=
n.

> diff --git a/drivers/video/fbdev/omap2/omapfb/dss/manager-sysfs.c b/drive=
rs/video/fbdev/omap2/omapfb/dss/manager-sysfs.c
> index 1b644be5fe2ed..40ec750f43155 100644
> --- a/drivers/video/fbdev/omap2/omapfb/dss/manager-sysfs.c
> +++ b/drivers/video/fbdev/omap2/omapfb/dss/manager-sysfs.c
> @@ -496,6 +496,11 @@ static const struct sysfs_ops manager_sysfs_ops =3D {
>  };
> =20
>  static struct kobj_type manager_ktype =3D {
> +	/*
> +	 * Pre-existing: mgr->kobj is embedded in static managers[] and
> +	 * zeroed in dss_manager_kobj_uninit().
> +	 */
> +	.release =3D NULL,
>  	.sysfs_ops =3D &manager_sysfs_ops,
>  	.default_groups =3D manager_sysfs_groups,
>  };

[Severity: Low]
Is managers[] actually a static array here, and does this teardown also
corrupt pending delayed cleanup under CONFIG_DEBUG_KOBJECT_RELEASE?

In drivers/video/fbdev/omap2/omapfb/dss/manager.c, managers is dynamically
allocated on the heap in dss_init_overlay_managers() and freed in
dss_uninit_overlay_managers():

static struct omap_overlay_manager *managers;

int dss_init_overlay_managers(void)
{
	int i;

	num_managers =3D dss_feat_get_num_mgrs();

	managers =3D kzalloc_objs(struct omap_overlay_manager, num_managers);
	...
}

In addition, dss_manager_kobj_uninit() calls
memset(&mgr->kobj, 0, sizeof(mgr->kobj)) right after kobject_put(&mgr->kobj)
(and dss_uninit_overlay_managers() then calls kfree(managers)), which clobb=
ers
and frees the pending delayed kobject cleanup under
CONFIG_DEBUG_KOBJECT_RELEASE just like display_uninit_sysfs() in
display-sysfs.c.

> diff --git a/drivers/video/fbdev/omap2/omapfb/dss/overlay-sysfs.c b/drive=
rs/video/fbdev/omap2/omapfb/dss/overlay-sysfs.c
> index 1da4fb1c77b4a..4d333031b18d6 100644
> --- a/drivers/video/fbdev/omap2/omapfb/dss/overlay-sysfs.c
> +++ b/drivers/video/fbdev/omap2/omapfb/dss/overlay-sysfs.c
> @@ -429,6 +429,11 @@ static const struct sysfs_ops overlay_sysfs_ops =3D {
>  };
> =20
>  static struct kobj_type overlay_ktype =3D {
> +	/*
> +	 * Pre-existing: ovl->kobj is embedded in static overlays[];
> +	 * dss_overlay_kobj_uninit() drops the kobject ref.
> +	 */
> +	.release =3D NULL,
>  	.sysfs_ops =3D &overlay_sysfs_ops,
>  	.default_groups =3D overlay_sysfs_groups,
>  };

[Severity: Low]
Similarly, is overlays[] heap-allocated rather than static, with a
use-after-free under CONFIG_DEBUG_KOBJECT_RELEASE?

In drivers/video/fbdev/omap2/omapfb/dss/overlay.c, overlays is allocated via
kzalloc_objs(struct omap_overlay, num_overlays) in dss_init_overlays(), and
dss_uninit_overlays() frees it immediately after dss_overlay_kobj_uninit()
calls kobject_put(&ovl->kobj):

void dss_uninit_overlays(struct platform_device *pdev)
{
	int i;

	for (i =3D 0; i < num_overlays; ++i) {
		struct omap_overlay *ovl =3D &overlays[i];
		dss_overlay_kobj_uninit(ovl);
	}

	kfree(overlays);
	overlays =3D NULL;
	num_overlays =3D 0;
}

Should the comments on manager_ktype and overlay_ktype describe managers and
overlays as dynamically allocated arrays and note the
CONFIG_DEBUG_KOBJECT_RELEASE hazard as well?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027223847.6528=
84-1-irogers@google.com?part=3D9
