From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc] IB/uverbs: Fix NULL pointer dereference during
 device removal
Date: Wed, 16 Aug 2017 20:46:19 +0300
Message-ID: <20170816174619.GW24282@mtr-leonro.local>
References: <20170816155704.23997-1-leon@kernel.org>
 <1502902487.33760.18.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qvqe4mReYAfpWQmG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502902487.33760.18.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--qvqe4mReYAfpWQmG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 16, 2017 at 12:54:47PM -0400, Doug Ledford wrote:
> On Wed, 2017-08-16 at 18:57 +0300, Leon Romanovsky wrote:
> > From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > As part of ib_uverbs_remove_one which might be triggered upon
> > reset flow, we trigger IB_EVENT_DEVICE_FATAL event to userspace
> > application.
> > If device was removed after uverbs fd was opened but before
> > ib_uverbs_get_context was called, the event file will be accessed
> > before it was allocated, result in NULL pointer dereference:
>
> Thanks, applied to -rc.
>
> Are there any more -rc patches waiting in the works over there?  As per
> my other email, I'm trying to process the -rc today...

I don't have anything in my -rc queue (ready or waiting for my internal review).

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

--qvqe4mReYAfpWQmG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmUhOsACgkQ5GN7iDZy
WKcYpg/7BntUmiziOlD9f1P+fHCmvqInv7hsreGOGtLvVb3m14UtClvx6/IV7gwT
2CEc7lagtNgws3DAYQrpnpV8hfVMNmLT40lpvdd2PozD6lDLDLzPM2t8nxIueCk4
7LTA62dnXcHdHCPHwSknrwA2kbzEeN1LVkwrS8/8Rk59cgiNPkFyKVIfc10qX2JR
7seoIa5vV9JMbYYoB02EpAH66x58Tnua3ASnErszPBe9TRHMQuddqc1tp7pxB/gf
8WTMQ6WPN9NSQj6mOjj1ZYeRnrw3LIdfNk2qCguP65Yy7UxuNEUi+WYXhr8166P0
zPqATuMeWOivJLeq7llEVQchNExAEe/xKjRse4/q+30DZjyGxzqocaFnnvNtC8tE
IapYN8jxOh7PlI3d01cWdZ8shgSY5pmpkKWYvbM6gHggEgfWts0ZkLh5OjT95ppf
l2M5ipyuCtkRPfYpQcn2vQGeTGDrRno+kv/Z/qtMG5OJxb7ATKNOwM+T593j8gd2
vI+/2dukBIVQLNvINfmze7uIuFOqw3YKzro81YIoHviao4GzZnwUdjolSnK1UuDH
AVwRInYf5IYGqLnUS+u+2TIHMY9M4qPt9wojVqrubg6A7GLVcQER4iJ4FjjCcm2q
We/R2i+Eob92X4YLzI19Mg842eHQbnmH2iHqj5+gbQUuF9O9lrg=
=wTet
-----END PGP SIGNATURE-----

--qvqe4mReYAfpWQmG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
