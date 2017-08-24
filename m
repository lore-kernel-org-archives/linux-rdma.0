From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next 8/8] RDMA: Use defines instead of hard coded value
 for phys_state
Date: Thu, 24 Aug 2017 16:24:53 +0300
Message-ID: <20170824132453.GK1724@mtr-leonro.local>
References: <20170815091431.12822-1-leon@kernel.org>
 <20170815091431.12822-9-leon@kernel.org>
 <D5C31047.1DB0A%Andrew.Boyer@emc.com>
 <20170823152915.GQ1724@mtr-leonro.local>
 <D5C444A5.1DC28%Andrew.Boyer@emc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NffpD3bBbNaSNdk0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <D5C444A5.1DC28%Andrew.Boyer-mb1K0bWo544@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--NffpD3bBbNaSNdk0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 24, 2017 at 12:56:29PM +0000, Boyer, Andrew wrote:
> On 8/23/17, 11:29 AM, "Leon Romanovsky" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> >On Wed, Aug 23, 2017 at 02:59:52PM +0000, Boyer, Andrew wrote:
> >>
> >>
> >> On 8/15/17, 5:14 AM, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of Le=
on
> >> Romanovsky" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of
> >> leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >>
> >> >From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> >
> >> >There are new defines to express the physical state of the link, so
> >> >let's reuse them instead hard-coded values.
> >> >
> >> >Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> >---
> >> >diff --git a/drivers/infiniband/sw/rxe/rxe_param.h
> >> >b/drivers/infiniband/sw/rxe/rxe_param.h
> >> >index 1b596fbbe251..475767262102 100644
> >> >--- a/drivers/infiniband/sw/rxe/rxe_param.h
> >> >+++ b/drivers/infiniband/sw/rxe/rxe_param.h
> >> >@@ -157,7 +157,7 @@ enum rxe_port_param {
> >> > 	RXE_PORT_ACTIVE_WIDTH		=3D IB_WIDTH_1X,
> >> > 	RXE_PORT_ACTIVE_SPEED		=3D 1,
> >> > 	RXE_PORT_PKEY_TBL_LEN		=3D 64,
> >> >-	RXE_PORT_PHYS_STATE		=3D 2,
> >> >+	RXE_PORT_PHYS_STATE		=3D RDMA_LINK_PHYS_STATE_POLLING,
> >> > 	RXE_PORT_SUBNET_PREFIX		=3D 0xfe80000000000000ULL,
> >> > };
> >>
> >> You can also remove IB_PHYS_STATE_* from rxe.h and the places where
> >> they=C2=B9re used.
> >
> >At the end, I found the way to avoid the whole this series.
> >This series is dropped.
> >
> >Thanks
>
> Would you object if I added similar / matching defines in ib_verbs.h?

Of course not, it will be good to see most of the cleanups from this
pull request, so feel free to resend/base your work on it.

>
> The phys_state field allows userspace to distinguish between a link that=
=E2=80=99s
> down and a link that=E2=80=99s turned off, but only a few drivers seem to=
 support
> it.
>
> -Andrew
>
>

--NffpD3bBbNaSNdk0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlme06UACgkQ5GN7iDZy
WKc4CA//VMXwoQfX4LP126v8VKR4u8lyI/usj/MzXE+jFWR+5/P065XAjanXABoa
9I7iY5kYkgnyvVxWjB/w8cJHAf+fvRftmJTnVt6bcHpVhbNxR2x5jO8JXFvQBm8Q
j9zYgCVPYloJAYuNnjOGD2mPSK6khdTpfkJ3t6cgWKcuJ6KXnjQB1IRpegJvPuC3
h0yak4HFAZC1IZFTXY/hoynRHRel7yJq8GbWkKJfZ8jdtiBUfthdgfJ4VicEBUfP
84m066O8eWbyjMSx0MteIFhbqSqBptqpQT8HLi/WXvCyqVamHpIh95WyHDYveXlh
cF9Q4+IfZsXSqCWgwZSLlOY8BnIjWpc0LKfs0vjQIrpKOU5NEGYyKt5uWwIKPPKE
OvGxR7fqgpsw+pAlGJ4445lZN+/gXAZtk13toCZVORQJ1G8s8kfV5MGg+tF0h9eR
/t5MTzeZKTmqRDDq0FHpu8Ig7T9dtrThScQena44Lm+QqkuXNODzYLNbMInECFik
ozSjNnOqexDgkoNGYhrqsuBT3pBWWEr2xnVydPgDiKFQ/ERc4erjyBwn1823dIIp
x60rgvkXJ7v9zwU60hstq/FvKLuVQ6giHeU20fZbZzN2/azZdozgQfQCD/tLZGkq
17cnVAeNA9btfFOxbQhyijQiWymrdW/nUs96CovuRqCY5THO20Q=
=9bGz
-----END PGP SIGNATURE-----

--NffpD3bBbNaSNdk0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
