From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] IB/uverbs: ex_query_device: fail if output buffer
 size does not match
Date: Mon, 26 Jan 2015 11:05:31 +0100
Message-ID: <1422266731.3133.14.camel@opteya.com>
References: <cover.1421931555.git.ydroneaud@opteya.com>
	 <d60715123c640bc7b720ad11a9faa3af78950aa6.1421931555.git.ydroneaud@opteya.com>
	 <54C50BBD.5000009@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54C50BBD.5000009-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le dimanche 25 janvier 2015 =C3=A0 17:29 +0200, Haggai Eran a =C3=A9cri=
t :
> On 22/01/2015 15:28, Yann Droneaud wrote:
> > Instead of silently truncating extended QUERY_DEVICE uverb's
> > response, see commit 5a77abf9a97a ("IB/core: Add support for
> > extended query device caps")), this patch makes function
> > ib_uverbs_ex_query_device() check the available space in the
> > response buffer against the requested features set in comp_mask
> > (currently only IB_USER_VERBS_EX_QUERY_DEVICE_ODP per commit
> > 860f10a799c8 ("IB/core: Add flags for on demand paging support").
>=20
> Currently you only need to check two possible sizes. With each
> additional field you will need to check another size.

Yes, that's mandatory for any interface with a dynamic, ever growing,
data structure.

> Sooner or later someone will forget to add a check and will create a =
non-backward
> compatible kernel.
>=20

That's why we have to review userspace interface patch with lot of care=
=2E

Anyway, such a change should be fixed easily as it's would be
definitively a bug.

If the behavior I'm proposing is in place, userspace won't be allowed
to supply unsupported bits in a request, so older userspace requests on
newer kernels won't trigger unsupported new behavior. This ensure we ca=
n
extend the interfance with no risk of breaking existing program.

> > If the response buffer is not large enough to store the expected
> > response, -ENOSPC is returned to userspace so that it can adjust
> > the size of its buffer.
> >=20
> > Note: as offsetof() is used to retrieve the size of the lower chunk
> > of the response, beware that it only works if the upper chunk
> > is right after, without any implicit padding. And, as the size of
> > the latter chunk is added to the base size, implicit padding at the
> > end of the structure is not taken in account. Both point must be
> > taken in account when extending the uverbs functionalities.
>=20
> Another point future contributors will easily miss.
>=20

One should use "pahole" tool when modifying data structure part of the
ABI to ensure the data structure are correctly aligned on various
architectures.

> > Link: http://mid.gmane.org/cover.1421931555.git.ydroneaud-RlY5vtjFyJ1hl2p70BpVqQ@public.gmane.org=
m
> > Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/core/uverbs_cmd.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infinib=
and/core/uverbs_cmd.c
> > index 532d8eba8b02..8668b328b7e6 100644
> > --- a/drivers/infiniband/core/uverbs_cmd.c
> > +++ b/drivers/infiniband/core/uverbs_cmd.c
> > @@ -3302,6 +3302,7 @@ int ib_uverbs_ex_query_device(struct ib_uverb=
s_file *file,
> >  	struct ib_uverbs_ex_query_device  cmd;
> >  	struct ib_device_attr attr;
> >  	struct ib_device *device;
> > +	size_t resp_len;
> >  	int err;
> > =20
> >  	device =3D file->device->ib_dev;
> > @@ -3315,6 +3316,11 @@ int ib_uverbs_ex_query_device(struct ib_uver=
bs_file *file,
> >  	if (cmd.reserved)
> >  		return -EINVAL;
> > =20
> > +	resp_len =3D offsetof(typeof(resp), odp_caps);
> > +
> > +	if (ucore->outlen < resp_len)
> > +		return -ENOSPC;
> > +
> >  	err =3D device->query_device(device, &attr);
> >  	if (err)
> >  		return err;
> > @@ -3325,6 +3331,11 @@ int ib_uverbs_ex_query_device(struct ib_uver=
bs_file *file,
> > =20
> >  #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> >  	if (cmd.comp_mask & IB_USER_VERBS_EX_QUERY_DEVICE_ODP) {
> > +		resp_len +=3D sizeof(resp.odp_caps);
> > +
> > +		if (ucore->outlen < resp_len)
> > +			return -ENOSPC;
> > +
> >  		resp.odp_caps.general_caps =3D attr.odp_caps.general_caps;
> >  		resp.odp_caps.per_transport_caps.rc_odp_caps =3D
> >  			attr.odp_caps.per_transport_caps.rc_odp_caps;
> > @@ -3336,7 +3347,7 @@ int ib_uverbs_ex_query_device(struct ib_uverb=
s_file *file,
> >  	}
> >  #endif
> > =20
> > -	err =3D ib_copy_to_udata(ucore, &resp, sizeof(resp));
> > +	err =3D ib_copy_to_udata(ucore, &resp, resp_len);
> >  	if (err)
> >  		return err;
> > =20
> >=20
>=20

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
