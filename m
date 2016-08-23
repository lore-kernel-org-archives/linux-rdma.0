From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2] i40iw: Do not set self-referencing pointer to NULL
 after kfree
Date: Wed, 24 Aug 2016 00:03:47 +0300
Message-ID: <20160823210347.GP15065@leon.nu>
References: <1471910507-83104-1-git-send-email-shiraz.saleem@intel.com>
 <20160823014135.GF15065@leon.nu>
 <20160823160030.GA37288@ssaleem-MOBL4.amr.corp.intel.com>
 <a65ff978-0790-24aa-d0c9-0e5aaaf7b301@redhat.com>
 <20160823184623.GN15065@leon.nu>
 <20160823190022.GA76544@ssaleem-MOBL4.amr.corp.intel.com>
 <66032524-b459-6429-93f9-101da7809f7e@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="eAnxKwVhzStH6fSc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <66032524-b459-6429-93f9-101da7809f7e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--eAnxKwVhzStH6fSc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 23, 2016 at 03:05:42PM -0400, Doug Ledford wrote:
> On 8/23/2016 3:00 PM, Shiraz Saleem wrote:
> > On Tue, Aug 23, 2016 at 09:46:23PM +0300, Leon Romanovsky wrote:
> >> On Tue, Aug 23, 2016 at 12:51:10PM -0400, Doug Ledford wrote:
> >>> On 8/23/2016 12:00 PM, Shiraz Saleem wrote:
> >>>> On Tue, Aug 23, 2016 at 04:41:35AM +0300, Leon Romanovsky wrote:
> >>>>> On Mon, Aug 22, 2016 at 07:01:47PM -0500, Shiraz Saleem wrote:
> >>>>>> From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>>>>>
> >>>>>> In i40iw_free_virt_mem(), do not set mem->va to NULL
> >>>>>> after freeing it as mem->va is a self-referencing pointer
> >>>>>> to mem.
> >>>>>
> >>>>> Sorry, I failed to understand your commit message and your change.
> >>>>> What did you mean? How do you suppose to use mem->va pointer
> >>>>> after kfree() call on that pointer? Won't you have use-after-free b=
ug in
> >>>>> such case?
> >>>>
> >>>> The pointer mem->va cannot be used after kfree. But setting it to=20
> >>>> NULL would be writing to freed memory. In i40iw_puda_alloc_buf(),=20
> >>>> when a buffer is allocated of type struct i40iw_puda_buf, the addres=
s=20
> >>>> of the buffer itself is stored within the structure (in member buf_m=
em).=20
> >>>> When this pointer is freed, the structure containing the pointer is =
freed,
> >>>> so writing to the structure would be writing to freed memory, which =
is=20
> >>>> what this fix is for.
> >>>> =20
> >>>>>>
> >>>>>> Fixes: 4e9042e647ff ("i40iw: add hw and utils files")
> >>>>>>
> >>>>>> Reported-by: Stefan Assmann <sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>>>>> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>>>>> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>>>>> ---
> >>>>>>
> >>>>>> V2: Fix typo in subject line.
> >>>>>>
> >>>>>>  drivers/infiniband/hw/i40iw/i40iw_utils.c | 1 -
> >>>>>>  1 file changed, 1 deletion(-)
> >>>>>>
> >>>>>> diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/i=
nfiniband/hw/i40iw/i40iw_utils.c
> >>>>>> index 0e8db0a..d5f5de2 100644
> >>>>>> --- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
> >>>>>> +++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
> >>>>>> @@ -674,7 +674,6 @@ enum i40iw_status_code i40iw_free_virt_mem(str=
uct i40iw_hw *hw,
> >>>>>>  	if (!mem)
> >>>>>>  		return I40IW_ERR_PARAM;
> >>>>>>  	kfree(mem->va);
> >>>>>> -	mem->va =3D NULL;
> >>>>>>  	return 0;
> >>>
> >>> Your commit message is a bit hard to follow, but if I follow the
> >>> conversation, kfree(mem->va) is the same as kfree(mem), is it not?  If
> >>> it is, couldn't you just kfree(mem)?  That would avoid the confusion
> >>> here.  Also, if it matters, you can use a temporary pointer, aka:
> >>>
> >>> p =3D mem->va;
> >>> mem->va =3D NULL;
> >>> kfree(p);
> >>>
> >>> but, again, if mem->va is just a self-referencing pointer back to mem,
> >>> then why not just kfree(mem)?  I'm concerned that this convoluted way=
 of
> >>> doing things will come back to haunt us later when people think they =
are
> >>> submitting a fix and simply reintroduce the same bug again.
> >>
> >> Yeah, I totally agree with you.
> >>
> >=20
> > OK, I see the the possible confusion of the commit message.=20
> >=20
> > Maybe the following is clearer:
> > "In i40iw_free_virt_mem(), do not set mem->va to NULL after freeing it,=
 as mem->va is a pointer=20
> > to the structure containing mem"
> >=20
> > So kfree(mem->va) is not the same as kfree(mem).=20
>=20
> That makes more sense.  I still think things are a bit convoluted here,
> and maybe even a code comment is in order.  I'll probably change it up a
> little bit as I pull it in.

I would like to see code snippet of such struct and/or code which is
depend on it.

Thanks

>=20
>=20
> --=20
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: 0E572FDD
>=20




--eAnxKwVhzStH6fSc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXvLozAAoJEORje4g2clinNU0P/2tIfKybk/o/zRFY8OCvViMb
OxtAmMKLFbQe/bcS3fJULerYRdMLpOQoR39Fizps2jZiM1twcvwfMW2sQOQY7s3i
uWcoqYXMwDo5FRCimmkv7sP64nV3sToA+xU36i7++DHsvtBhSUqTsnOSHrvDz1Sn
96SGLhkQs8cIB6m1unWJ2qgtVTE8r3xZTtC0P3pjLnxijzLYr6UVDWcp1hstp8jg
xsS9FVwyqWt48rCiH4dFBfl2KkjaL+GcUP/iWQQyO0Vs0xIWVPchLPkoA1y/hGLk
IN5lorsBbCfMM9YIrjw14Q9gL8t6DlZLFG8Q0SCAfSS46Bt7z18cRXIXE3bfd9za
wOX1yQIufmI0W0lN9i7gMis6XDRzTAHUrfwT4e0jD03+vSE4kMFc3gLPXDH33VSD
mOwUuUipjHTxkVR9FoZMBG09yAmVRZmoBmfN4DDPRTqMxDvBx5ceL0WpjWvWeN7k
1W4q1yPTm4A3ieSD7qNeWU3cfPQSpnIUEaHyQFVygOFD/wujDc3UeHMAvChnLpIb
4jgIHiMTHuladxKd/xOPFWkEz5tTU1Kn5r6amdm1+TZ9WirFHzDJUkmpI7qIAx8d
0eBYJtg3Za3wTcNAYHYT+5rAy1KwHjL8OpconK1p9KbvxiLIV6ZzbXWeyo+3Btxz
k6lZvpN/K9iKd8fzdKB8
=V4w/
-----END PGP SIGNATURE-----

--eAnxKwVhzStH6fSc--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
