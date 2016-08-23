From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2] i40iw: Do not set self-referencing pointer to NULL
 after kfree
Date: Tue, 23 Aug 2016 21:46:23 +0300
Message-ID: <20160823184623.GN15065@leon.nu>
References: <1471910507-83104-1-git-send-email-shiraz.saleem@intel.com>
 <20160823014135.GF15065@leon.nu>
 <20160823160030.GA37288@ssaleem-MOBL4.amr.corp.intel.com>
 <a65ff978-0790-24aa-d0c9-0e5aaaf7b301@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XBg9NAhDNArbJUtw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a65ff978-0790-24aa-d0c9-0e5aaaf7b301-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--XBg9NAhDNArbJUtw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 23, 2016 at 12:51:10PM -0400, Doug Ledford wrote:
> On 8/23/2016 12:00 PM, Shiraz Saleem wrote:
> > On Tue, Aug 23, 2016 at 04:41:35AM +0300, Leon Romanovsky wrote:
> >> On Mon, Aug 22, 2016 at 07:01:47PM -0500, Shiraz Saleem wrote:
> >>> From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>>
> >>> In i40iw_free_virt_mem(), do not set mem->va to NULL
> >>> after freeing it as mem->va is a self-referencing pointer
> >>> to mem.
> >>
> >> Sorry, I failed to understand your commit message and your change.
> >> What did you mean? How do you suppose to use mem->va pointer
> >> after kfree() call on that pointer? Won't you have use-after-free bug =
in
> >> such case?
> >=20
> > The pointer mem->va cannot be used after kfree. But setting it to=20
> > NULL would be writing to freed memory. In i40iw_puda_alloc_buf(),=20
> > when a buffer is allocated of type struct i40iw_puda_buf, the address=
=20
> > of the buffer itself is stored within the structure (in member buf_mem)=
=2E=20
> > When this pointer is freed, the structure containing the pointer is fre=
ed,
> > so writing to the structure would be writing to freed memory, which is=
=20
> > what this fix is for.
> > =20
> >>>
> >>> Fixes: 4e9042e647ff ("i40iw: add hw and utils files")
> >>>
> >>> Reported-by: Stefan Assmann <sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>> ---
> >>>
> >>> V2: Fix typo in subject line.
> >>>
> >>>  drivers/infiniband/hw/i40iw/i40iw_utils.c | 1 -
> >>>  1 file changed, 1 deletion(-)
> >>>
> >>> diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infi=
niband/hw/i40iw/i40iw_utils.c
> >>> index 0e8db0a..d5f5de2 100644
> >>> --- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
> >>> +++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
> >>> @@ -674,7 +674,6 @@ enum i40iw_status_code i40iw_free_virt_mem(struct=
 i40iw_hw *hw,
> >>>  	if (!mem)
> >>>  		return I40IW_ERR_PARAM;
> >>>  	kfree(mem->va);
> >>> -	mem->va =3D NULL;
> >>>  	return 0;
>=20
> Your commit message is a bit hard to follow, but if I follow the
> conversation, kfree(mem->va) is the same as kfree(mem), is it not?  If
> it is, couldn't you just kfree(mem)?  That would avoid the confusion
> here.  Also, if it matters, you can use a temporary pointer, aka:
>=20
> p =3D mem->va;
> mem->va =3D NULL;
> kfree(p);
>=20
> but, again, if mem->va is just a self-referencing pointer back to mem,
> then why not just kfree(mem)?  I'm concerned that this convoluted way of
> doing things will come back to haunt us later when people think they are
> submitting a fix and simply reintroduce the same bug again.

Yeah, I totally agree with you.

>=20
>=20
> --=20
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: 0E572FDD
>=20




--XBg9NAhDNArbJUtw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXvJn/AAoJEORje4g2clinccEP/R8lTDX5zG13U/pbe6GmdzKz
Ffa400v3ZTQwhGTVJ20pRdJwNtQ4RCSbnj9RhSdPCHBL2VhKGPTDZfZNMXPLpE59
8YbZv5ElNY35jiF67OTj1+krfPOLPGztIpkoaVgeWrMdz1CXWipYq/poKHvN+FGq
Xpu8xfybaYqQo5UTWN/8e5yZbpbAXTX5VJ1fEsiwWQ2+HJvMkUqms+S6AFQ++t/E
Gsv1Hs+qo+BrbQUOH8mhRIpTmT4Cqn+pd+8a5JecLIguA3qUwop6kFx6p1qvR4CZ
TXZMZdcjov0LgflVuUwGdMlgKr5QhEw+z7dxvCfkc+tM6m9aDk2+3TWI+nGJmcvi
l25o5Eor7ecE1zzWdKvGwHsAbINhsUp+r7k9iWQ6LfI61gRApgAH0HIIPM1ujsum
BSQoNEEuhkg1HjyUuHBnCB8Sdk37OLIqVroIy2FzeHv3l6/9wsmS4RIBZ2lNOXWx
9HmIltAecUYXD9LfxcFLFkvqdy4wfbx2jlRu98zuEUal8nMGPgc2GumoQeOzONIv
3LPQ/vYISozjMwCiv3JinwAWc3UpkASdV0r8vG0SjR9PfvNI5mGAv8l6o0ZRMk7O
y2/SJxP4/mwdcZaAekXmvSZy5fSV5B2V6Gc8A1km7x4rW3CAK//9srqbMY0gE40T
EHXIrCBbD0rvePMKJ33J
=Okx3
-----END PGP SIGNATURE-----

--XBg9NAhDNArbJUtw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
